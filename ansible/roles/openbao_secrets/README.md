# openbao_secrets

A controller-side **pre-play** that logs in to OpenBao **once per
resource-domain identity** (each with its own least-privilege AppRole) and
reads that domain's KV subtree into a per-domain fact,
`bao_<domain>_secrets` (hyphens become underscores, e.g. `local-cloud` ->
`bao_local_cloud_secrets`). Consumer roles then resolve their secrets
**bao-first with an env fallback**:

```yaml
some_secret: "{{ bao_observability_secrets.SOME_SECRET | default(lookup('env', 'SOME_SECRET'), true) }}"
```

It runs **once** on the controller (`delegate_to: localhost`, `run_once`),
looping `openbao_secrets_domains` and leaving each domain's merged result in
`openbao_secrets_by_domain[<domain>]` on the controller; the calling playbook
then copies each domain's dict into its own shared, un-prefixed
`bao_<domain>_secrets` fact per host (the publish lives at the playbook
layer — like `tofu_data` in `load_tofu.yml` — so the role's own facts stay
role-prefixed). Each domain **skips cleanly** when its own role_id/secret_id
envs are unset, so an operator can migrate one domain at a time onto OpenBao
while the rest keep resolving from env/SOPS (the `group_vars/all.yml` `{}`
defaults guarantee the fallback resolves for every domain).

## Alignment with `roles/openbao` (RBAC)

The layout is aligned to what `roles/openbao` bootstraps — do not invent paths
a policy can't read:

- **KV mount**: `secret` (KV v2).
- **One AppRole per domain**, not one shared identity — a domain's
  credentials only ever unlock that domain's own KV subtree. See
  `tofu-proxmox` `docs/SECRETS_HIERARCHY.md` for the full RBAC table.
- **Seeding**: `roles/openbao` seeds **no** values; it creates only the mount,
  policies, and AppRoles. So a domain's paths yield keys only once a writer
  populates them; until then every read is empty and the env fallback wins.

## Installation

Reference the role from a pre-fetch play in your own playbook — this is a
**bespoke calling contract**, not something the role does for you. The role
only fills `openbao_secrets_by_domain` on the controller
(`hostvars['localhost'].openbao_secrets_by_domain`); your playbook must copy
each domain's dict into its own `bao_<domain>_secrets` fact so consumer
roles can read it:

```yaml
- hosts: <union of every domain's consumer groups>
  gather_facts: false
  # `always`: every consumer role resolves its secrets bao-first, so a
  # tagged converge (--tags <role>) must still run this play, or that
  # role's secrets template empty. The role still skips cleanly when
  # BAO_ADDR / a domain's AppRole envs are unset, so `always` costs
  # nothing in env-less runs.
  tags: [always]
  tasks:
    - name: Fetch each resource-domain's KV subtree via its own AppRole
      ansible.builtin.include_role:
        name: dryvist.homelab.openbao_secrets

    # Publish each domain's shared, un-prefixed fact at the playbook layer.
    # openbao_secrets_by_domain was computed once on the delegated
    # controller; a domain that was skipped (BAO_ADDR or that domain's
    # creds unset) is simply absent, so `default({})` covers it.
    - name: Publish each domain's merged secrets to every host in this play
      ansible.builtin.set_fact:
        bao_<domain>_secrets: "{{ openbao_secrets_by_domain['<domain>'] | default({}) }}"
        # ...repeat one line per domain your playbook consumes
      vars:
        openbao_secrets_by_domain: "{{ hostvars['localhost'].openbao_secrets_by_domain | default({}) }}"
      no_log: true
```

A second consumer must reproduce this publish step itself — copy the pattern
above, substituting its own domain names. See
[Domains fetched](#domains-fetched-openbao_secrets_domains) for the domain
list this instance of the role is configured with; a new repo defines its own
subset in its own `openbao_secrets_domains` var.

## Usage

Set `BAO_ADDR` plus each domain's `<DOMAIN>_VAULT_ROLE_ID` / `_SECRET_ID`
(see [Inputs (env)](#inputs-env)), then run through the normal wrapper:

```sh
doppler run -- ansible-playbook playbooks/site.yml --tags openbao_secrets
```

Any domain whose credentials aren't set simply falls back to env/SOPS for its
consumer roles — see [Wiring](#wiring) for how the pre-fetch play publishes
each domain's fact.

## Client failover

Before fetching, the controller probes an ordered list of endpoints and pins the
first that answers a health check unsealed (standbyok, since a standby forwards
to the active peer so any node can serve the read). It tries `BAO_ADDR` (the
Traefik ingress VIP name, made HA by the `keepalived` role) first, then each
`openbao`-tagged container's own per-node endpoint derived from the tofu
inventory (no literal address), so failover holds even if both ingress instances
are unreachable. If none answers, the role skips the read path for this run. Set
`openbao_secrets_fail_when_unavailable` to `true` to fail the play instead. This is client failover only;
server-side quorum HA needs a fourth node and is out of scope.

## Domains fetched (`openbao_secrets_domains`)

| Domain | AppRole env vars | KV paths | Consumers |
| --- | --- | --- | --- |
| `observability` | `OBSERVABILITY_VAULT_ROLE_ID` / `_SECRET_ID` | `platform/splunk`, `platform/cribl` | splunk_docker, cribl_* roles |
| `local-cloud` | `LOCAL_CLOUD_VAULT_ROLE_ID` / `_SECRET_ID` | `platform/object-storage`, `platform/compute` | object_storage role |
| `monitoring` | `MONITORING_VAULT_ROLE_ID` / `_SECRET_ID` | `apps/monitoring` | netmon, unifi_metrics, prometheus_stack |
| `media` | `MEDIA_VAULT_ROLE_ID` / `_SECRET_ID` | `apps/media` | *arr/qBittorrent/Plex roles |
| `local-llm` | `LOCAL_LLM_VAULT_ROLE_ID` / `_SECRET_ID` | `ai/*` (router/llm-large/qdrant/open-webui/hermes) | LLM serving roles |

`local-llm` replaces the old `ai-readonly`-backed `bao_ai_secrets` for the LLM
**serving stack** — `ai-readonly`/`ai-elevated` are reserved for AI AGENT
identities (Claude/codex-style agents), not the serving stack itself; keeping
them separate means an agent's credentials can never be used to read the
serving stack's own secrets, and vice versa.

All readable path keys for a domain are merged flat into that domain's
`bao_<domain>_secrets`, keyed by the field name, so a consumer default reads
`bao_<domain>_secrets.<FIELD_NAME>`.

## Inputs (env)

| Env var | Purpose |
| --- | --- |
| `SECRET_STORE_ADDR` (fallback `BAO_ADDR`) | Store URL. Unset ⇒ skip everything. |
| `SECRET_STORE_<DOMAIN>_ROLE_ID` / `_SECRET_ID` (then `OPENBAO_APPROLE_<DOMAIN>_*`, `<DOMAIN>_VAULT_*`) | That domain's own credentials. Unset ⇒ skip it. |
| `SECRET_STORE_PUBLISH_ROLE_ID` / `_SECRET_ID` (fallback `OPENBAO_APPROLE_ANSIBLE_*`) | Identity for the one publish path. |
| `SECRET_STORE_KV_MOUNT` | KV mount name; the role default applies when unset. |

On macOS these are sourced from the operator's dedicated `openbao.keychain-db`
keychain (72h auto-lock — the keychain's lock state is the access boundary,
not the AppRole's own TTL) via a resolver script; on Linux guests, from a
root-only systemd credential / `0600` EnvironmentFile. See
`tofu-proxmox` `docs/SECRETS_HIERARCHY.md`.

## Read-path switches

Each switch below is an input of the default entry point, which the role runs when `tasks_from` is not set. Every
default keeps the behaviour described above. A caller that needs the stricter behaviour sets the switch in its play
vars. `meta/argument_specs.yml` documents each input.

- `openbao_secrets_domain_groups` (domain name to consumer groups) with `openbao_secrets_active_groups`. Default `{}`
  and `[]`, so every domain is fetched. When set, a domain with groups is fetched only when one of them is active. A
  domain with no entry is always fetched.
- `openbao_secrets_fail_on_missing_credentials`. Default `false`: a domain with no login is skipped. When `true`, the
  play fails, unless the domain is listed in `openbao_secrets_optional_domains`. A domain with `required: true` always
  fails.
- `openbao_secrets_fail_when_unavailable`. Default `false`: when no endpoint is reachable, the read path is skipped.
  When `true`, the play fails.
- `openbao_secrets_skip_cidr_refusals`. Default `false`: a source-address refusal fails the play. When `true`, that
  domain is skipped for the run and publishes no key.
- `openbao_secrets_isolate_optional_login_failures`. Default `false`: a failed login fails the play. When `true`, a
  domain whose every path is optional records the failure, publishes an empty result, and the run continues.
- `openbao_secrets_strict_reads`. Default `false`: unreadable paths are ignored. When `true`, a 404 on a required
  path, any 403, and any transport error fail the domain. A 404 on an `optional` path is still skipped with a warning.
- `openbao_secrets_isolate_optional_read_failures`. Default `false`, used with `strict_reads`. When `true`, a domain
  whose every path is optional records the unreadable path, publishes an empty result, and the run continues.

Path and domain fields:

- A path is a string (required) or a mapping with `path` (required), `mount` (default `openbao_secrets_kv_mount`),
  `optional` (default `false`), and `enabled` (default `true`; `false` skips the path before any read).
- `workstation_issuer_role` logs the domain in with a per-call token from `flow-lock approle-token <role>` when
  `OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID` and `OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID` are both set and `flow-lock`
  is on the controller's `PATH`. The token is revoked after the domain's reads. If exactly one of the two issuer
  variables is set, the play fails.
- `credential_domain` names another domain whose AppRole pair the domain uses.
- Source-address refusals are detected from the login's message. A refusal is never retried with another credential.

The required-value guard is a separate entry point. `tasks_from: assert_nonempty.yml` fails when any variable named
in `openbao_secrets_required_vars` resolves to an empty value. It prints the names only.

```yaml
- ansible.builtin.include_role:
    name: openbao_secrets
    tasks_from: assert_nonempty.yml
  vars:
    openbao_secrets_required_vars:
      - myapp_db_password
```

`tests/openbao_secrets/read_path.yml` runs each switch and path field against `tests/openbao_secrets/fake_kv2.py`,
which also serves an AppRole login and a `flow-lock` stand-in in `tests/openbao_secrets/stub-bin/`. The playbook's
header lists the environment it needs.

## Wiring

Runs as a pre-fetch play in `playbooks/site.yml`, against the union of every
domain's consumer groups, before any of those roles evaluate their secret
defaults. One execution fetches ALL configured domains (regardless of which
specific groups are in the play's host list) — cheap and avoids redundant
logins from being split across multiple domain-scoped plays.

## Generate-if-absent seeding (`tasks_from: seed_generated`)

Adds missing fields to one KV v2 secret. The interface is in `meta/argument_specs.yml` (entry point
`seed_generated`); the defaults are in `defaults/main.yml`.

```yaml
- ansible.builtin.include_role:
    name: openbao_secrets
    tasks_from: seed_generated
  vars:
    openbao_secrets_seed_addr: "{{ openbao_secrets_bao_addr }}"
    openbao_secrets_seed_token: "{{ writer_token }}"
    openbao_secrets_seed_path: apps/example
    openbao_secrets_seed_fields:
      - name: password
        length: 32
      - name: api_key
        length: 32
        charset: hex
        prefix: "sk-"
```

- A stored field keeps its value. A missing field gets a generated value, or the field's `value` when given.
- One check-and-set write: `cas=0` creates the secret, and `cas=<observed version>` merges into an existing one.
  A concurrent writer makes the run fail; nothing is overwritten.
- `openbao_secrets_seed_rotate_fields` regenerates the named fields. A field's `valid_pattern` regenerates a stored
  value that does not match it.
- The no-log fact named by `openbao_secrets_seed_register` receives a dictionary of declared field names to their
  final values (stored, caller-supplied, or generated). Its default name is `openbao_secrets_seed_result`.
- Generated fields accept `charset: lower_alpha` for lowercase letters only, in addition to `alnum`, `lower`, and
  `hex`.
- In check mode, the task reads existing values, returns `(placeholder in check mode)` for fields that would be
  generated, and sends no KV write. Caller-supplied values and existing stored values remain available to templates.
- When the seed endpoint is unset or its
  `/v1/sys/health?standbyok=true&perfstandbyok=true` response is not `200`, nonempty string values in
  `openbao_secrets_seed_local_values` are returned for their declared fields without a KV read or write. An empty
  mapping preserves the OpenBao-required behavior. A KV authorization denial after a healthy response fails the
  task and does not select local values.
- Opt-ins: `openbao_secrets_seed_expected_writer_policy` (asserts the writer token's exact identity through
  `auth/token/lookup-self`), `openbao_secrets_seed_check_capabilities` (asserts the exact capabilities through
  `sys/capabilities-self`), and `openbao_secrets_seed_revoke_token` (self-revokes the writer token on exit).
- The role does not delegate. A caller that must run the writes from another host wraps the include in a `block`
  with `delegate_to`.

`tests/openbao_secrets/seed_generated.yml` runs these paths against `tests/openbao_secrets/fake_kv2.py`, a local
stand-in for the KV v2 and token endpoints. It is not an OpenBao implementation.

## Dependencies

- `seed_generated` uses `ansible.builtin.uri` for OpenBao HTTP requests, so it does not need Python `hvac` on the
  delegated host.
- The read path's login and KV read tasks use `community.hashi_vault` (added to `requirements.yml`), which needs
  Python `hvac` on the controller.
- `community.general` for the `random_string` lookup used by `seed_generated`.

## Not yet live-validated

Verify at the first bao-backed converge: each domain's AppRole login against
the Traefik ingress, and that `vault_kv2_get` returns the expected field names
once that domain's `secret/<path>` is seeded.
