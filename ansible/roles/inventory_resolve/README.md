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
