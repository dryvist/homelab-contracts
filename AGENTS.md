# AI Agents Configuration — dryvist/homelab-schemas

This repo is the **single source of truth** for the dryvist homelab inventory contract.
It carries no runtime code; only the schema, port constants, examples, and CI gates.

## Scope

This repo owns:

- `schemas/ansible-inventory-v1.json` — JSON Schema (draft 2020-12) for the inventory artifact
- `schemas/service-ports.yaml` — service / syslog / NetFlow / notification / vector-DB port constants
- `examples/ansible_inventory.json` — reference fixture used by CI
- `versions/<vX.Y.Z>/` — frozen historical schemas for breaking-change detection
- `tests/validate.sh` — one-line `check-jsonschema` invocation

This repo does **not** own:

- Ansible playbooks, roles, or inventories (live in `dryvist/ansible-proxmox-cluster` and `dryvist/ansible-server-apps`)
- OpenTofu modules (live in `dryvist/tofu-proxmox-cluster`)
- Runtime code of any kind

## Hard rules

1. **No `infisical` references anywhere.** The runtime secret store is OpenBao
   (Vault API). Use `openbao` as the field name.
2. **`tests/validate.sh` is a single-line CLI pass-through.** No control flow, no
   logic. If you need orchestration, add a marketplace action to
   `.github/workflows/ci.yml` instead.
3. **Breaking changes require a major version bump and a `versions/<vX.Y.Z>/`
   directory.** CI enforces this by diffing `schemas/` against the latest
   `versions/`.
4. **Port constants only live in `schemas/service-ports.yaml`.** No duplication
   in HCL, Ansible vars, or examples. Examples reference the canonical names by
   lookup pattern only.
5. **Mermaid round-trip CI gate**: every `.mmd` change must include a
   re-rendered `.svg`. The `mermaid-render-check.yml` workflow fails the PR if
   `.svg` doesn't match.

## Conventional commits

Use these prefixes:

| Prefix | When |
| --- | --- |
| `feat:` | New schema field, new port constant, new ADR |
| `fix:` | Documentation tweak, dependency update, CI fix |
| `chore:` | Repo maintenance (Renovate, release-please) |
| `docs:` | README or ADR-only changes |

release-please drives version bumps from these prefixes. Major bumps are human-initiated only
(edit `.release-please-manifest.json`).

## File operations

- Read files with the Read tool (NEVER cat, head, tail, less, bat)
- Edit existing files with the Edit tool (NEVER sed, awk, perl -i, python -c)
- Create new files with the Write tool (NEVER cat >, echo >, tee, heredocs)
- Search file contents with the Grep tool (NEVER grep, rg, ag via Bash)
- Find files with the Glob tool (NEVER find, ls, fd via Bash)
- Bash is ONLY for running system commands (git, gh, nix, mermaid-cli, check-jsonschema, etc.)

## Cross-repo context

| Repo | Relationship |
| --- | --- |
| `dryvist/ansible-proxmox-cluster` | Consumes via `requirements.yml` git source; validates inventory in CI |
| `dryvist/ansible-server-apps` | Consumes via `requirements.yml` git source; validates inventory in CI |
| `dryvist/tofu-proxmox-cluster` | Consumes `service-ports.yaml` via Terragrunt include (cached locally); writes `ansible_inventory.json` matching the schema |

## ADRs

Locked decisions live in `docs/adr/`:

- `0001-shared-schema-repo-rationale.md` — why a separate repo at all
- `0002-jsonschema-not-protobuf.md` — why JSON Schema over alternatives
- `0003-versioning-policy.md` — semver discipline + breaking-change gate
