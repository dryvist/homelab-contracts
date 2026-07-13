# homelab-contracts

[![CI](https://github.com/dryvist/homelab-contracts/actions/workflows/ci.yml/badge.svg)](https://github.com/dryvist/homelab-contracts/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Single source of truth for the **dryvist homelab cross-repo contracts** —
both the data shapes and the small shared tools that enforce them:

- JSON Schema for `ansible_inventory.json` (the inventory artifact produced by IaC and
  consumed downstream) — including the `constants` block that carries the service /
  syslog / NetFlow / notification / vector-DB port values
- Versioned history under `versions/<vX.Y.Z>/` so breaking changes are structurally enforceable
- `bin/flow-lock` — the OpenBao-backed lease for coordinated non-IaC mutation
  tools such as `deployment.json` edits
- `bin/deployment-json` — locked, schema-gated access to the canonical
  `deployment.json` object
- `ansible/roles/inventory_resolve` — the shared inventory-resolution role
  consumed by the ansible repos (replaces per-repo copy-paste)

Formerly `homelab-schemas`; renamed when the shared flow tooling moved in
(the contract repo now ships the enforcement, not just the shape).

## Locking boundaries

Terrakube serializes OpenTofu runs with its native per-workspace lock. Do not
wrap a Terrakube or local OpenTofu run in the global `flow-lock` lease.

For the remaining non-IaC multi-step mutation tools, one OpenBao KV v2 lease
(`secret/data/locks/global`, create-if-absent via
`cas=0`, TTL + background renewal, CAS takeover of expired leases) is the only
path to runtime credentials. `flow-lock status` shows the holder;
`flow-lock break --reason ...` force-breaks with an audit entry. Consumers pin
this repo by release tag (Nix flake input) and get `flow-lock` in their dev
shell.

## Installation

This repo is consumed, not installed. There is nothing to install locally except validation tooling:

```sh
# One-time: install check-jsonschema (via Nix, no global install needed)
nix run nixpkgs#check-jsonschema -- --version

# Mermaid CLI (used by docs/assets/ rendering)
nix run nixpkgs#mermaid-cli -- --version
```

## Usage

```sh
# Validate the example fixture against the schema
bash tests/validate.sh

# Re-render mermaid diagrams (the CI gate enforces this)
nix run nixpkgs#mermaid-cli -- -i docs/assets/ecosystem-context.mmd -o docs/assets/ecosystem-context.svg --quiet
```

A consumer pins this repo by tag or full SHA and reads the schema from the
pinned checkout — for example, a JSON Schema validation step against
`schemas/ansible-inventory-v1.json`. Port values are not a separate file; they
ride in the inventory artifact's `constants` block, validated by that schema.
Pinning by tag or SHA keeps the resolution deterministic.

## Why

Before this repo existed, the inventory shape was duplicated across multiple
places and drift between copies was caught only at runtime, usually mid-deploy.

Centralising the schema gives us:

| Benefit | Mechanism |
| --- | --- |
| Compile-time parity | One published schema, pinned by tag or SHA, validated wherever the inventory is read |
| Single constants surface | Port values ride in the inventory's `constants` block (schema-validated), defined once upstream and never duplicated here |
| Breaking-change gate | CI diffs `schemas/` vs `versions/<vX.Y.Z>/`; shape changes need a snapshot (ADR 0003), major bumps human-reviewed via release-please |
| One human-edit surface | The schema and port constants are edited here once, then republished |

## Repository layout

```text
schemas/
  ansible-inventory-v1.json    # JSON Schema (draft 2020-12) for the inventory artifact, incl. the `constants` port block
bin/
  flow-lock                    # Non-IaC mutation lease + gated credential injection
  deployment-json              # Locked, schema-gated deployment.json fetch/edit/put
ansible/
  roles/inventory_resolve/     # Shared inventory-resolution role (pin via requirements.yml)
examples/
  ansible_inventory.json       # Reference example matching the v1 schema (used as CI fixture)
versions/
  v1.0.0/
    ansible-inventory.json     # Frozen v1.0.0 schema (compared against schemas/ on every PR)
tests/
  validate.sh                  # One-line check-jsonschema invocation
  flow-lock.bats               # CLI-contract tests for bin/
docs/
  adr/                         # Architectural decision records
  assets/                      # Mermaid `.mmd` sources + rendered `.svg`
flake.nix                      # packages.flow-lock + dev shell (consumers pin by tag)
.github/workflows/
  ci.yml                       # validate.sh + semver gate + shellcheck + bats + ansible-lint
  release-please.yml           # release-please managed CHANGELOG + tags
  mermaid-render-check.yml     # Re-renders .mmd; fails PR on diff
```

## How to bump the schema

1. **Patch / additive change** (new optional field, new constant): bump `1.0.x` → `1.0.x+1`.
   - Edit `schemas/ansible-inventory-v1.json`
   - Copy current `schemas/` contents to `versions/v1.0.x+1/`
   - release-please picks up the `fix:` commit and tags
2. **Minor / additive in a backward-compatible way** (new required field with a default in consumers,
   new optional cluster block): bump `1.x.y` → `1.x+1.0`.
   - Same workflow, but commit prefix is `feat:`
3. **Major / breaking change** (rename, removal, type change): bump `x.y.z` → `x+1.0.0`.
   - Major bumps are **human-only**: edit `.release-please-manifest.json` manually
   - Add a `versions/v2.0.0/` directory with the new shape
   - Add a `docs/adr/<NNNN>-v2-migration.md` explaining the break + migration path
   - Open a tracking issue in every consumer before merging

CI gate:

```sh
diff -u versions/v1.0.0/ansible-inventory.json schemas/ansible-inventory-v1.json
# Any diff requires a corresponding versions/<bump>/ directory or CI fails
```

## Local development

```sh
# Validate example fixture against the schema
bash tests/validate.sh

# Re-render mermaid diagrams (CI gate enforces this)
nix run nixpkgs#mermaid-cli -- -i docs/assets/ecosystem-context.mmd -o docs/assets/ecosystem-context.svg --quiet
```

## License

MIT — see [LICENSE](LICENSE).

---

> Part of a [larger ecosystem of ~40 repos](https://docs.jacobpevans.com) — see how it all fits together.
