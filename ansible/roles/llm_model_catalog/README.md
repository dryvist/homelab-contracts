# llm_model_catalog

Single-source catalog of GGUF models served on the llm fabric: model id,
HuggingFace repo, filename, and a Renovate-tracked commit revision.

## What it does

Nothing at run time — this role has no tasks. Including it in a play loads
`llm_model_catalog_models` (its only variable) as role defaults, which then
stay in scope for every later role in the same play. Two consumers read it
instead of each keeping their own copy:

- `ansible-proxmox`'s `llm_model_store_seed` role downloads each catalog
  entry's GGUF onto the PVE host that owns the shared model-store mount.
- `ansible-proxmox-ai`'s `llama_cpp` role serves the same GGUFs from that
  mount.

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

See `defaults/main.yml` for the full list and each field's meaning.

## License

MIT — see [`LICENSE`](../../../LICENSE) at the repository root.
