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
consumer roles — see [Installation](#installation) for how the pre-fetch play
publishes each domain's fact.

## Client failover

Before fetching, the controller probes an ordered list of endpoints and pins the
first that answers a health check unsealed (standbyok, since a standby forwards
to the active peer so any node can serve the read). It tries `BAO_ADDR` (the
Traefik ingress VIP name, made HA by the `keepalived` role) first, then each
`openbao`-tagged container's own per-node endpoint derived from the tofu
inventory (no literal address), so failover holds even if both ingress instances
are unreachable. If none answers, the role skips to the env/SOPS fallback for
this run rather than hard-failing every converge. This is client failover only;
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

## Read-path switches

Each input defaults to the behaviour the role already had. `meta/argument_specs.yml` documents them.

| Input | Default | Effect when set |
| --- | --- | --- |
| `openbao_secrets_domain_groups`, `openbao_secrets_active_groups` | `{}`, `[]` | A grouped domain is fetched only when one of its groups is active. |
| `openbao_secrets_fail_on_missing_credentials` | `false` | A domain with no login fails the play unless listed in `openbao_secrets_optional_domains`. |
| `openbao_secrets_fail_when_unavailable` | `false` | No reachable endpoint fails the play instead of skipping the read path. |
| `openbao_secrets_skip_cidr_refusals` | `false` | A source-address refusal skips its domain, which publishes no key. |
| `openbao_secrets_isolate_optional_login_failures` | `false` | A failed login in an all-optional domain publishes an empty result. |
| `openbao_secrets_strict_reads` | `false` | An unreadable required path, a 403 or a transport error fails its domain. |
| `openbao_secrets_isolate_optional_read_failures` | `false` | With strict reads, an all-optional domain publishes an empty result on an unreadable path. |
| `openbao_secrets_alert_ntfy_url` | `""` | An isolated domain sends a best-effort ntfy page naming the domain and failure class. |

A path is a string or a mapping with `path`, `mount`, `optional` and `enabled`. `enabled: false` skips it before any read.
`tasks_from: assert_nonempty.yml` fails when a variable named in `openbao_secrets_required_vars` resolves empty.

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
- Set a field's `generate: false` to require a nonempty caller `value` when the field is missing or needs
  replacement. Valid stored values are kept; the same guard applies in check mode.
- One check-and-set write: `cas=0` creates the secret, and `cas=<observed version>` merges into an existing one.
  A concurrent writer makes the run fail; nothing is overwritten.
- `openbao_secrets_seed_rotate_fields` regenerates the named fields. A field's `valid_pattern` regenerates a stored
  value that does not match it.
- The no-log fact named by `openbao_secrets_seed_register` receives a dictionary of declared field names to their
  final values (stored, caller-supplied, or generated). Its default name is `openbao_secrets_seed_result`.
- Generated fields accept `charset: lower_alpha` for lowercase letters only, `charset: upper_numeric` for uppercase
  letters and digits only, in addition to `alnum`, `lower`, and `hex`.
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
- `community.hashi_vault` (added to `requirements.yml`) and its Python `hvac`
  dependency in the controller environment (provided by the Nix dev shell —
  `nix-devenv#ansible-apps`).
- `community.general` for the `random_string` lookup used by `seed_generated`.

## Not yet live-validated

Verify at the first bao-backed converge: each domain's AppRole login against
the Traefik ingress, and that `vault_kv2_get` returns the expected field names
once that domain's `secret/<path>` is seeded.
