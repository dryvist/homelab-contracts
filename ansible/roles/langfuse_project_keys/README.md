# langfuse_project_keys

Provisions one Langfuse project API key pair into an OpenBao KV v2 secret, once. Langfuse OSS has no admin API
without an enterprise licence, so the role signs in as an existing organization owner through the same session
routes the web UI uses, then calls two tRPC procedures:

| Step | Call |
| --- | --- |
| Sign in | `GET /api/auth/csrf`, then `POST /api/auth/callback/credentials` (form body, `json=true`) |
| Read the organizations and projects | `GET /api/auth/session` |
| Create the project if absent | `POST /api/trpc/projects.create` with `{"json": {"name", "orgId"}}` |
| Create the key pair | `POST /api/trpc/projectApiKeys.create` with `{"json": {"projectId", "name"}}` |
| Store the pair | `openbao_secrets` `tasks_from: seed_generated`, with the two fields given as values |

## Installation

- Put `ansible/roles` on the role path. The role includes `openbao_secrets` (`tasks_from: seed_generated`), so that
  role must be present too.
- Install `community.general` in the controller environment, as `seed_generated` requires. The OpenBao reads and the
  write use `ansible.builtin.uri`, so no `hvac` library is needed.
- The key pair is returned once, in the response body of `projectApiKeys.create`. A failed write after the key is
  created leaves that key unused in Langfuse.

## Usage

```yaml
- ansible.builtin.include_role:
    name: langfuse_project_keys
  vars:
    langfuse_project_keys_base_url: https://langfuse.example.test
    langfuse_project_keys_admin_email: "{{ langfuse_admin_email }}"
    langfuse_project_keys_admin_password: "{{ langfuse_admin_password }}"
    langfuse_project_keys_org_name: homelab
    langfuse_project_keys_project_name: hermes
    langfuse_project_keys_openbao_addr: "{{ openbao_addr }}"
    langfuse_project_keys_openbao_token: "{{ writer_token }}"
    langfuse_project_keys_openbao_path: ai/hermes
```

The caller supplies the admin password and the writer token from its own secret store. The role reads neither. The
inputs are in `meta/argument_specs.yml`; the field names default to `LANGFUSE_PUBLIC_KEY` and `LANGFUSE_SECRET_KEY`.

## Order and idempotency

1. Plan: `seed_generated` runs in check mode. It reads the secret and sends no write.
2. OpenBao not reachable or not healthy: stop before any Langfuse call. `seed_generated` would otherwise return values
   without writing, and a key created then would never be stored.
3. Both key fields absent: sign in, find the project, create what is missing, create one key pair, write both fields
   with one check-and-set write.
4. Both present: stop. No Langfuse call is made and no key is created.
5. Exactly one present: stop before any Langfuse call. A new key beside a stored one would not form a pair.

Under `--check` the role plans and reports, and makes no Langfuse call and no write.

Every task that handles the password, a cookie, the CSRF token or a key is `no_log`.

## Versions

Checked against the Langfuse v4.71.0 and v4.27.0 source:

- Sign-in, session and `projects.create` are the same at both tags. NextAuth is 4.24.15 at both.
- `projectApiKeys.create` takes `name` at 4.71.0. At 4.27.0 it takes `note` and drops `name`, so the key has no label
  there. Both return `publicKey` and `secretKey`.
- At 4.71.0 `role` is optional and the role is left unset, so the procedure assigns the legacy role. Role selection
  is gated by environment flags and is not used.
- Neither procedure checks an entitlement at either tag. The public admin API is not used because it is gated by the
  `admin-api` entitlement.
