#!/usr/bin/env python3
"""Local stand-in for the OpenBao calls made by tasks/seed_generated.yml.

Test-only. It implements the subset the role depends on: X-Vault-Token checks,
KV v2 reads (200, or 404 for absent and soft-deleted secrets, with metadata for the
latter), check-and-set writes (cas must equal the current version; 0 means absent),
token lookup-self, sys/capabilities-self and token revoke-self. It records every
request so the playbook can assert what was sent.

The /_test/ endpoints are for the playbook only: seed a secret, read state and the
request log, arm one write failure, shut down. Revocation is recorded, not enforced.
"""

import argparse
import json
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any

STATE = {}  # data path -> {"version": int, "data": dict or None}
LOG = []  # one entry per request, oldest first
ARMED = {"fail_next_write": False}

TOKENS = {
    "writer-ok": {
        "policies": ["default", "test-write"],
        "identity_policies": [],
        "renewable": False,
        "orphan": True,
        "ttl": 300,
    },
    "writer-extra-policy": {
        "policies": ["default", "test-write", "other"],
        "identity_policies": [],
        "renewable": False,
        "orphan": True,
        "ttl": 300,
    },
    "writer-renewable": {
        "policies": ["default", "test-write"],
        "identity_policies": [],
        "renewable": True,
        "orphan": True,
        "ttl": 300,
    },
    "writer-caps-bad": {
        "policies": ["default", "test-write"],
        "identity_policies": [],
        "renewable": False,
        "orphan": True,
        "ttl": 300,
    },
}


def capabilities_for(token, path):
    if token == "writer-caps-bad":
        return ["read"]
    if "/metadata/" in path:
        return ["read"]
    return ["create", "read", "update"]


class Handler(BaseHTTPRequestHandler):
    server_version = "fake-kv2"

    def log_message(self, format: str, *args: Any) -> None:
        # The base class writes one stderr line per request. The playbook asserts on
        # /_test/state instead, so the line is dropped.
        del format, args

    def _send(self, status, body=None):
        raw = b"" if body is None else json.dumps(body).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(raw)))
        self.end_headers()
        self.wfile.write(raw)

    def _body(self):
        length = int(self.headers.get("Content-Length") or 0)
        if not length:
            return {}
        return json.loads(self.rfile.read(length) or b"{}")

    def _token(self):
        return self.headers.get("X-Vault-Token", "")

    def _record(self, method, path, **extra):
        entry = {"method": method, "path": path, "token": self._token()}
        entry.update(extra)
        LOG.append(entry)

    def do_GET(self):
        if self.path.startswith("/_test/"):
            return self._test_get()
        path = self.path.split("?")[0]
        token = self._token()
        if token not in TOKENS:
            self._record("GET", path)
            return self._send(403, {"errors": ["permission denied"]})
        if path == "/v1/auth/token/lookup-self":
            self._record("GET", path)
            return self._send(200, {"data": TOKENS[token]})
        if path.startswith("/v1/secret/data/"):
            data_path = path[len("/v1/"):]
            self._record("GET", data_path)
            entry = STATE.get(data_path)
            if entry is None:
                return self._send(404, {"errors": []})
            if entry["data"] is None:
                return self._send(404, {"data": {"data": None, "metadata": {"version": entry["version"]}}})
            return self._send(200, {"data": {"data": entry["data"], "metadata": {"version": entry["version"]}}})
        self._record("GET", path)
        return self._send(404, {"errors": ["unsupported by fake"]})

    def do_POST(self):
        if self.path.startswith("/_test/"):
            return self._test_post()
        path = self.path.split("?")[0]
        token = self._token()
        body = self._body()
        if token not in TOKENS:
            self._record("POST", path)
            return self._send(403, {"errors": ["permission denied"]})
        if path == "/v1/auth/token/revoke-self":
            self._record("POST", path)
            return self._send(204)
        if path == "/v1/sys/capabilities-self":
            self._record("POST", path)
            caps = {p: capabilities_for(token, p) for p in body.get("paths", [])}
            return self._send(200, {"data": caps})
        if path.startswith("/v1/secret/data/"):
            data_path = path[len("/v1/"):]
            cas = (body.get("options") or {}).get("cas")
            self._record("POST", data_path, cas=cas, keys=sorted((body.get("data") or {}).keys()))
            if ARMED["fail_next_write"]:
                ARMED["fail_next_write"] = False
                return self._send(400, {"errors": ["check-and-set parameter did not match the current version"]})
            entry = STATE.get(data_path)
            current = entry["version"] if entry else 0
            if cas is not None and int(cas) != current:
                return self._send(400, {"errors": ["check-and-set parameter did not match the current version"]})
            version = current + 1
            STATE[data_path] = {"version": version, "data": dict(body.get("data") or {})}
            return self._send(200, {"data": {"version": version}})
        self._record("POST", path)
        return self._send(404, {"errors": ["unsupported by fake"]})

    def _test_get(self):
        if self.path == "/_test/state":
            return self._send(200, {"state": STATE, "log": LOG})
        return self._send(404, {"errors": ["no such test endpoint"]})

    def _test_post(self):
        body = self._body()
        if self.path == "/_test/seed":
            STATE[body["path"]] = {"version": int(body.get("version", 1)), "data": body.get("data")}
            return self._send(200, {})
        if self.path == "/_test/log-reset":
            LOG.clear()
            return self._send(200, {})
        if self.path == "/_test/arm-write-failure":
            ARMED["fail_next_write"] = True
            return self._send(200, {})
        if self.path == "/_test/shutdown":
            self._send(200, {})
            threading.Thread(target=self.server.shutdown, daemon=True).start()
            return None
        return self._send(404, {"errors": ["no such test endpoint"]})


def main():
    parser = argparse.ArgumentParser(description="Local stand-in for the OpenBao calls made by seed_generated.")
    parser.add_argument("--port", type=int, required=True)
    args = parser.parse_args()
    server = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    server.serve_forever()


if __name__ == "__main__":
    main()
