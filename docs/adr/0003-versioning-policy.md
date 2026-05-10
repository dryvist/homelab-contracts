# 0003 — Versioning policy + breaking-change gate

- Status: accepted
- Date: 2026-05-10

## Context

Multi-consumer schemas need a versioning discipline that prevents accidental
breaks. The two failure modes we want to make impossible:

1. Someone tweaks `schemas/ansible-inventory-v1.json` and forgets to bump.
   Consumers pinned to `v1.0.0` keep working — until they re-pull and explode.
2. Someone removes a required field but only bumps patch.

## Decision

Three rules:

1. **Semver** with release-please-managed tags. `feat:` → minor, `fix:` → patch,
   major bumps are human-initiated only (edit `.release-please-manifest.json`).
2. **Frozen snapshots in `versions/`.** Every release tag has a corresponding
   `versions/v<X.Y.Z>/ansible-inventory.json` that is byte-identical to the
   schema at that tag.
3. **CI gate**: a PR is rejected unless `diff -u versions/<latest>/ schemas/`
   either reports no diff OR the PR adds a new `versions/<bump>/` directory
   matching the new shape.

For the first release (this PR), `versions/v1.0.0/ansible-inventory.json` is
created alongside `schemas/ansible-inventory-v1.json` and they are byte-identical.

## Major-bump workflow

Major bumps mean a new file: `schemas/ansible-inventory-v2.json` lives
alongside v1 for a deprecation window. Consumers migrate when ready, and
`v1` is removed only after every consumer is on `v2`.

## Consequences

- Positive: drift is impossible — any shape change either bumps and snapshots
  or fails CI.
- Positive: consumers can pin to a SHA for exact reproducibility.
- Negative: every shape edit means TWO file touches (schema + new snapshot).
  Acceptable cost for the gate.
