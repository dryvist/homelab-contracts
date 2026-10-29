#!/usr/bin/env python3
"""Local stand-in for the Langfuse web endpoints that tasks/provision.yml calls.

Test-only. It implements the subset the role depends on, with the shapes Langfuse 4.27.0 and 4.71.0 return:
the NextAuth csrf and credentials callback (form body, json=true), the session read, and the tRPC procedures
projects.create and projectApiKeys.create (superjson envelope, non-batch). Calls without a session cookie get the
UNAUTHORIZED envelope. Key values are fixed by a counter, so the playbook can predict them.

The /_test/ endpoints are for the playbook only: reset the organization and projects, read the request log, shut down.
"""

import argparse
import json
import threading
import urllib.parse
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any

CSRF_TOKEN = "csrf-test-token"
ADMIN_EMAIL = "admin@example.test"
ADMIN_PASSWORD = "admin-test-password"
CSRF_COOKIE = f"next-auth.csrf-token={CSRF_TOKEN}|0123abcd"

STATE: dict[str, Any] = {}
LOG: list[dict[str, Any]] = []


def reset(org_name: str, projects: list[str]) -> None:
    STATE.clear()
    STATE.update(
        {
            "org": {"id": "org-1", "name": org_name},
            "projects": [{"id": f"proj-{i + 1}", "name": name} for i, name in enumerate(projects)],
            "sessions": [],
            "keys": [],
            "counter": len(projects),
        }
    )
    LOG.clear()


reset("homelab", [])


def parse_cookies(header: str) -> dict[str, str]:
    jar = {}
    for part in header.split(";"):
        name, sep, value = part.strip().partition("=")
        if sep:
            jar[name] = value
    return jar


class Handler(BaseHTTPRequestHandler):
    server_version = "fake-langfuse"

    def log_message(self, format: str, *args: Any) -> None:
        # The playbook asserts on /_test/state instead, so the per-request stderr line is dropped.
        del format, args

    def _send(self, status, body=None, set_cookie=None):
        raw = b"" if body is None else json.dumps(body).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(raw)))
        if set_cookie:
            self.send_header("Set-Cookie", set_cookie)
        self.end_headers()
        self.wfile.write(raw)

    def _body(self) -> bytes:
        length = int(self.headers.get("Content-Length") or 0)
        return self.rfile.read(length) if length else b""

    def _session_ok(self) -> bool:
        jar = parse_cookies(self.headers.get("Cookie", ""))
        return any(jar.get("next-auth.session-token") == s for s in STATE["sessions"])

    def _record(self, method: str, path: str, **extra: Any) -> None:
        LOG.append({"method": method, "path": path, **extra})

    def do_GET(self):
        if self.path.startswith("/_test/"):
            return self._test_get()
        path = self.path.split("?")[0]
        if path == "/api/auth/csrf":
            self._record("GET", path)
            return self._send(200, {"csrfToken": CSRF_TOKEN}, set_cookie=f"{CSRF_COOKIE}; Path=/; HttpOnly")
        if path == "/api/auth/session":
            self._record("GET", path)
            if not self._session_ok():
                return self._send(200, {})
            projects = [{"id": p["id"], "name": p["name"], "role": "OWNER"} for p in STATE["projects"]]
            org = {**STATE["org"], "role": "OWNER", "projects": projects}
            return self._send(200, {"user": {"email": ADMIN_EMAIL, "organizations": [org]}, "expires": "2099-01-01T00:00:00.000Z"})
        self._record("GET", path)
        return self._send(404, {"error": "unsupported by fake"})

    def do_POST(self):
        if self.path.startswith("/_test/"):
            return self._test_post()
        path = self.path.split("?")[0]
        raw = self._body()
        if path == "/api/auth/callback/credentials":
            form = urllib.parse.parse_qs(raw.decode())
            csrf_ok = parse_cookies(self.headers.get("Cookie", "")).get("next-auth.csrf-token", "").startswith(CSRF_TOKEN)
            creds_ok = (
                form.get("email", [""])[0] == ADMIN_EMAIL
                and form.get("password", [""])[0] == ADMIN_PASSWORD
                and form.get("csrfToken", [""])[0] == CSRF_TOKEN
            )
            self._record("POST", path, json_flag=form.get("json", [""])[0], csrf_ok=csrf_ok, creds_ok=creds_ok)
            base = f"http://{self.headers.get('Host', '127.0.0.1')}"
            if not (csrf_ok and creds_ok and form.get("json", [""])[0] == "true"):
                return self._send(401, {"url": f"{base}/api/auth/error?error=CredentialsSignin&provider=credentials"})
            session = f"sess-{len(STATE['sessions']) + 1}"
            STATE["sessions"].append(session)
            cookie = f"next-auth.session-token={session}; Path=/; HttpOnly"
            return self._send(200, {"url": f"{base}/"}, set_cookie=cookie)
        if path in ("/api/trpc/projects.create", "/api/trpc/projectApiKeys.create"):
            return self._trpc(path, raw)
        self._record("POST", path)
        return self._send(404, {"error": "unsupported by fake"})

    def _trpc(self, path, raw):
        procedure = path.rsplit("/", 1)[1]
        payload = json.loads(raw or b"{}").get("json", {})
        if not self._session_ok():
            self._record("POST", path, procedure=procedure, authorized=False)
            return self._send(401, {"error": {"json": {"message": "UNAUTHORIZED", "code": -32001, "data": {"code": "UNAUTHORIZED", "httpStatus": 401}}}})
        self._record("POST", path, procedure=procedure, authorized=True, input=payload)
        if procedure == "projects.create":
            if payload.get("orgId") != STATE["org"]["id"]:
                return self._send(403, {"error": {"json": {"message": "FORBIDDEN", "code": -32003, "data": {"code": "FORBIDDEN", "httpStatus": 403}}}})
            if any(p["name"] == payload.get("name") for p in STATE["projects"]):
                return self._send(409, {"error": {"json": {"message": "CONFLICT", "code": -32009, "data": {"code": "CONFLICT", "httpStatus": 409}}}})
            STATE["counter"] += 1
            project = {"id": f"proj-{STATE['counter']}", "name": payload["name"]}
            STATE["projects"].append(project)
            return self._send(200, {"result": {"data": {"json": {"id": project["id"], "name": project["name"], "role": "OWNER"}}}})
        if not any(p["id"] == payload.get("projectId") for p in STATE["projects"]):
            return self._send(404, {"error": {"json": {"message": "NOT_FOUND", "code": -32004, "data": {"code": "NOT_FOUND", "httpStatus": 404}}}})
        STATE["counter"] += 1
        n = STATE["counter"]
        key = {
            "id": f"key-{n}",
            "publicKey": f"pk-lf-fake-{n}",
            "secretKey": f"sk-lf-fake-{n}",
            "displaySecretKey": f"sk-lf-...{n:04d}",
            "projectId": payload["projectId"],
        }
        STATE["keys"].append(key)
        return self._send(200, {"result": {"data": {"json": key}}})

    def _test_get(self):
        if self.path == "/_test/state":
            return self._send(200, {"state": STATE, "log": LOG})
        return self._send(404, {"errors": ["no such test endpoint"]})

    def _test_post(self):
        body = json.loads(self._body() or b"{}")
        if self.path == "/_test/reset":
            reset(body.get("org_name", "homelab"), body.get("projects", []))
            return self._send(200, {})
        if self.path == "/_test/shutdown":
            self._send(200, {})
            threading.Thread(target=self.server.shutdown, daemon=True).start()
            return None
        return self._send(404, {"errors": ["no such test endpoint"]})


def main():
    parser = argparse.ArgumentParser(description="Local stand-in for the Langfuse endpoints used by provision.yml.")
    parser.add_argument("--port", type=int, required=True)
    args = parser.parse_args()
    server = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    server.serve_forever()


if __name__ == "__main__":
    main()
