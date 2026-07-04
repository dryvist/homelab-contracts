# inventory_resolve

Shared resolution of the published OpenTofu inventory. Replaces the
copy-pasted resolution block that previously lived in each ansible repo's
`load_tofu.yml`.

Source priority (first match wins):

1. `TOFU_INVENTORY_PATH` — explicit local path (tests, pins)
2. Published S3 artifact — the on-prem store when `S3_ENDPOINT` is present
   (injected by `flow-lock run --creds rustfs`), else the legacy AWS state
   bucket via the ambient credential chain
3. Local gitignored cache — **only** with `TOFU_INVENTORY_ALLOW_STALE=1`
   (a stale inventory deploys wrong VMIDs/IPs; the opt-in is deliberate)

On success the role leaves two facts for the consumer:

- `tofu_inventory_resolved` — the path that won
- `tofu_data` — the parsed inventory (via `include_vars`)

Repo-specific validation and `add_host` group mapping stay in the consumer —
pass `inventory_resolve_required_keys` for top-level key checks.

```yaml
# consumer playbook (localhost play)
- name: Resolve the published inventory
  ansible.builtin.include_role:
    name: inventory_resolve
  vars:
    inventory_resolve_required_keys: [containers, nodes, domain]
```

Pin via `requirements.yml`:

```yaml
roles:
  - name: inventory_resolve
    src: https://github.com/dryvist/homelab-contracts.git
    scm: git
    version: v1.9.0   # release tag
```
