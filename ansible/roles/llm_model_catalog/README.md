# llm_model_catalog

Single-source catalog of homelab models and their per-model serving limits.
GGUF-backed entries also carry the HuggingFace repo, filename, and a
Renovate-tracked commit revision.

## What it does

Nothing at run time — this role has no tasks. Including it in a play loads
`llm_model_catalog_models` (its only variable) as role defaults, which then
stay in scope for every later role in the same play. Consumers use the model
entry for context, output, concurrency, timeout, retry, and provider-limit
values instead of keeping per-model copies:

- `ansible-proxmox`'s `llm_model_store_seed` role downloads each entry with
  the complete `hf_repo`, `gguf`, and `hf_revision` group onto the PVE host
  that owns the shared model-store mount.
- `ansible-proxmox-ai`'s serving roles use the same GGUF metadata and apply
  the catalog's serving limits.
- The router and Hermes presets project the same model fields to their output
  formats; repo CI verifies that projections agree with the catalog.

Checksums are never stored here: the sha256 for a download is read from
HuggingFace's own LFS blob metadata at run time, pinned against the exact
`hf_revision` each entry declares — never a hand-copied literal that could
drift from what HuggingFace actually publishes.

## Installation

Ships in this collection — see the [collection README](../../README.md) for
the `requirements.yml` entry. No separate install step.

## Usage

Include before any role that reads `llm_model_catalog_models`, in the same
play:

```yaml
roles:
  - role: dryvist.homelab.llm_model_catalog
  - role: llm_model_store_seed
```

## Variables

See `defaults/main.yml` for the full list and each field's meaning. Entries
without all three HuggingFace fields are provider-hosted or otherwise supplied
by an existing model server and are not downloaded by `llm_model_store_seed`.

## License

MIT — see [`LICENSE`](../../../LICENSE) at the repository root.
