# 0001 — Shared schema repo rationale

- Status: accepted
- Date: 2026-05-10

## Context

The dryvist homelab spans three repos that all touch the same data shape:

- `dryvist/tofu-proxmox-cluster` writes `ansible_inventory.json`
- `dryvist/ansible-proxmox-cluster` reads it (host-level config)
- `dryvist/ansible-server-apps` reads it (app-level config)

Until now, the contract lived implicitly in:

- `JacobPEvans/terraform-proxmox/outputs.tf:ansible_inventory`
- `JacobPEvans/ansible-proxmox/playbooks/load_terraform.yml:40-66`
- `JacobPEvans/ansible-proxmox-apps/inventory/load_terraform.yml`

Every change required coordinated edits across three repos with no compile-time check.
Drift was caught only at runtime, mid-deploy, by a confused playbook.

## Decision

Carve the contract out into `dryvist/homelab-schemas` as the single source of truth:

- JSON Schema (draft 2020-12) for the inventory shape — `schemas/ansible-inventory-v1.json`
- YAML for port constants — `schemas/service-ports.yaml`
- Reference example fixture — `examples/ansible_inventory.json`
- Frozen historical snapshots — `versions/<vX.Y.Z>/`

Both Ansible repos pin this repo via `requirements.yml` git source. The OpenTofu
repo includes the YAML constants via Terragrunt include (cached locally from a
tagged release).

## Consequences

- Positive: structural parity across consumers; no manual diff anywhere.
- Positive: breaking changes are now CI-detectable (see ADR 0003).
- Negative: one extra repo to maintain. The cost is small — the repo carries no runtime code.
- Negative: consumers must re-pin on each release. Offset by Renovate auto-PRs.
