# inventory_resolve

Shared resolution of the published OpenTofu inventory. Replaces the
copy-pasted resolution block that previously lived in each ansible repo's
`load_tofu.yml`.

Source priority (first match wins):

1. `TOFU_INVENTORY_PATH` — explicit local path (tests, pins)
2. Published S3 artifact — the homelab RustFS object, using credentials read
   natively from OpenBao `secret/platform/object-storage`

Those two are the whole list. The published object is the only source of live
infrastructure data: a local on-disk copy cannot know whether it is current,
and one that has fallen behind deploys wrong VMIDs and IPs while every task
reports success. An inventory that does not resolve is a hard failure.

This list is the canonical statement of the resolution order. Consumer repos
link here rather than restating it.

On success the role leaves two facts for the consumer:

- `tofu_inventory_resolved` — the path that won
- `tofu_data` — the parsed inventory (via `include_vars`)

Repo-specific validation and `add_host` group mapping stay in the consumer —
pass `inventory_resolve_required_keys` for top-level key checks.
Set `inventory_resolve_fail_when_unresolved: false` only when the consumer has
its own explicit static or DNS fallback.

The controller supplies only `BAO_ADDR` and `BAO_TOKEN`. The OpenBao path must
contain `S3_ENDPOINT`, `S3_ACCESS_KEY_ID`, `S3_SECRET_ACCESS_KEY`, and optionally
`S3_REGION`. Object-store credentials remain in Ansible memory and are never
exported into the shell.

## Installation

Pin via `requirements.yml`:

```yaml
roles:
  - name: inventory_resolve
    src: https://github.com/dryvist/homelab-contracts.git
    scm: git
    version: v1.10.0   # release tag
```

## Usage

```yaml
# consumer playbook (localhost play)
- name: Resolve the published inventory
  ansible.builtin.include_role:
    name: inventory_resolve
  vars:
    inventory_resolve_required_keys: [containers, nodes, domain]
```

## Is an apply owed?

After loading the artifact, the role answers one more question: was this
artifact built from the desired state that exists *right now*?

That link has no other signal. An apply only re-renders the artifact, and a
converge only consumes whatever the artifact currently says, so a desired-state
edit that was never applied leaves every converge acting on an artifact that
contradicts it — producing a confidently wrong result rather than an error. The
ordering that avoids it is **apply, then converge**; doing them the other way
round is silently wrong.

The producer stamps the desired-state object's ETag into the artifact
(`desired_state.etag`, schema 2.1.0+). The role re-reads the live object with
the credentials it already holds and compares. Exports:

| Fact | Meaning |
| --- | --- |
| `tofu_desired_state_published` | fingerprint the artifact was rendered from |
| `tofu_desired_state_live` | fingerprint of desired state right now |
| `tofu_desired_state_current` | `false` when an apply is owed |

It **warns, never fails** — a detector that can block every converge is a worse
outage than the drift it watches for — and it **fails open** at every step (no
credentials, no fingerprint in the artifact, an unreadable object): the facts
are left unset rather than reporting "current", because a check that could not
run must never be reported as a check that passed.
`tests/inventory_resolve/apply_owed_fail_open.yml` pins that.

An ETag rather than a timestamp, deliberately: the publish rewrites the artifact
only when its content changes, so a desired-state edit that altered nothing else
would never move a timestamp and the artifact would read as permanently stale.
The fingerprint is part of the published content, so every desired-state change
changes it.
