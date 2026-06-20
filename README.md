# homelab-schemas

[![CI](https://github.com/dryvist/homelab-schemas/actions/workflows/ci.yml/badge.svg)](https://github.com/dryvist/homelab-schemas/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Single source of truth for the **dryvist homelab inventory contract**:

- JSON Schema for `ansible_inventory.json` (the inventory artifact produced by IaC and consumed downstream)
- YAML constants for service / syslog / NetFlow / notification / vector-DB ports
- Versioned history under `versions/<vX.Y.Z>/` so breaking changes are structurally enforceable

This repo carries no runtime code — it only ships the contract and validates it in CI.
The contract defines the exact shape any consumer must match; describing that shape
here is the whole point of the repo.

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

A consumer pins this repo by tag or full SHA and reads the schema and port
constants from the pinned checkout — for example, a JSON Schema validation step
against `schemas/ansible-inventory-v1.json`, or `yamldecode` of
`schemas/service-ports.yaml` for port values. Pinning by tag or SHA keeps the
resolution deterministic.

## Why

Before this repo existed, the inventory shape was duplicated across multiple
places and drift between copies was caught only at runtime, usually mid-deploy.

Centralising the schema gives us:

| Benefit | Mechanism |
| --- | --- |
| Compile-time parity | One published schema, pinned by tag or SHA, validated wherever the inventory is read |
| Single constants surface | Port values live in `schemas/service-ports.yaml`, never duplicated downstream |
| Breaking-change gate | CI compares `schemas/` against latest `versions/<vX.Y.Z>/` and requires a `versions/<vX.Y.Z>/` snapshot on shape change (per ADR 0003); major-bump enforcement is human-reviewed via release-please manifest edits |
| One human-edit surface | The schema and port constants are edited here once, then republished |

## Repository layout

```text
schemas/
  ansible-inventory-v1.json    # JSON Schema (draft 2020-12) for the inventory artifact
  service-ports.yaml           # Single source of truth for service / syslog / NetFlow / notification / vector-DB ports
examples/
  ansible_inventory.json       # Reference example matching the v1 schema (used as CI fixture)
versions/
  v1.0.0/
    ansible-inventory.json     # Frozen v1.0.0 schema (compared against schemas/ on every PR)
tests/
  validate.sh                  # One-line check-jsonschema invocation
docs/
  adr/                         # Architectural decision records
  assets/                      # Mermaid `.mmd` sources + rendered `.svg`
.github/workflows/
  ci.yml                       # Runs tests/validate.sh + semver-bump validation
  release-please.yml           # release-please managed CHANGELOG + tags
  mermaid-render-check.yml     # Re-renders .mmd; fails PR on diff
```

## How to bump the schema

1. **Patch / additive change** (new optional field, new constant): bump `1.0.x` → `1.0.x+1`.
   - Edit `schemas/ansible-inventory-v1.json` (or `service-ports.yaml`)
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

> Part of the [dryvist homelab](https://docs.dryvist.com) — how the private repos and infrastructure connect (gated).
