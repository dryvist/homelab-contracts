# AI Agents Configuration — dryvist/homelab-contracts

This repo is the **single source of truth** for the dryvist homelab cross-repo
contracts: the inventory shape, the port constants, and the small shared tools
that enforce the contracts at runtime (flow lease, deployment.json access,
inventory resolution). Formerly `homelab-schemas`.

## Scope

This repo owns:

- `schemas/ansible-inventory-v1.json` — JSON Schema (draft 2020-12) for the inventory
  artifact, including the `constants` block that carries the service / syslog / NetFlow /
  notification / vector-DB port values
- `bin/flow-lock` — the non-IaC mutation lease + gated credential injection (OpenBao KV v2 CAS)
- `bin/deployment-json` — locked, schema-gated deployment.json fetch/edit/put
- `ansible/roles/inventory_resolve` — shared inventory-resolution role for the ansible repos
- `examples/ansible_inventory.json` — reference fixture used by CI
- `versions/<vX.Y.Z>/` — frozen historical schemas for breaking-change detection
- `tests/validate.sh` — one-line `check-jsonschema` invocation
- `tests/flow-lock.bats` — CLI-contract tests for `bin/`
- `flake.nix` — `packages.flow-lock` + dev shell; consumers pin by release tag

This repo does **not** own:

- Ansible playbooks, repo-specific roles, or inventories (live in
  `dryvist/ansible-proxmox` and `dryvist/ansible-proxmox-apps`)
- OpenTofu modules (live in `dryvist/terraform-proxmox`)
- The OpenBao deployment itself (role lives in `dryvist/ansible-proxmox-apps`)
- Business logic of any kind — `bin/` tools are pure contract enforcement
  (lease, creds injection, validation); anything flow-specific stays downstream

## Hard rules

1. **No `infisical` references anywhere.** The runtime secret store is OpenBao
   (Vault API). Use `openbao` as the field name.
2. **`tests/validate.sh` is a single-line CLI pass-through.** No control flow, no
   logic. If you need orchestration, add a marketplace action to
   `.github/workflows/ci.yml` instead.
3. **Breaking changes require a major version bump and a `versions/<vX.Y.Z>/`
   directory.** CI enforces this by diffing `schemas/` against the latest
   `versions/`.
4. **Port values are defined once, upstream.** They originate in
   `dryvist/terraform-proxmox` `pipeline_constants` and reach consumers through
   the inventory artifact's `constants` block — whose shape (`portMap`) this
   schema enforces. Do not re-declare port values here, or duplicate them in
   HCL, Ansible vars, or examples; examples reference the canonical names by
   lookup pattern only.
5. **Mermaid round-trip CI gate**: every `.mmd` change must include a
   re-rendered `.svg`. The `mermaid-render-check.yml` workflow fails the PR if
   `.svg` doesn't match.
6. **`bin/` tools stay dependency-light and shellcheck-clean.** bash + curl +
   jq (+ aws CLI / check-jsonschema for `deployment-json`) only — no Python,
   no per-flow logic. Every behavior change needs a matching
   `tests/flow-lock.bats` case.

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
| `dryvist/ansible-proxmox` | Consumes `inventory_resolve` via `requirements.yml` git source; validates inventory in CI |
| `dryvist/ansible-proxmox-apps` | Same as above; also owns the OpenBao deployment role the lease lives on |
| `dryvist/tofu-proxmox` | Defines `pipeline_constants` (ports) and writes them into `ansible_inventory.json` per the schema; Terrakube serializes runs per workspace |

## ADRs

Locked decisions live in `docs/adr/`:

- `0001-shared-schema-repo-rationale.md` — why a separate repo at all
- `0002-jsonschema-not-protobuf.md` — why JSON Schema over alternatives
- `0003-versioning-policy.md` — semver discipline + breaking-change gate
