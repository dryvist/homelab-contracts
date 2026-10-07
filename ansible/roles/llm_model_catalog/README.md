# llm_model_catalog

Single-source catalog of homelab models and their per-model serving limits.
GGUF-backed entries also carry the HuggingFace repo, filename, and a
Renovate-tracked commit revision.

## What it does

Including it in a play loads `llm_model_catalog_models` from the role's JSON
data file into the play. The same JSON is readable by Ansible and Nix, so the
MLX profiles and router, serving, guard, and Hermes values share one source.
Consumers use the model entry for context, output, concurrency, timeout,
retry, and provider-limit values instead of keeping per-model copies:

- `ansible-proxmox`'s `llm_model_store_seed` role downloads each entry with
  the complete `hf_repo`, `gguf`, and `hf_revision` group onto the PVE host
  that owns the shared model-store mount.
- `ansible-proxmox-ai`'s serving roles use the same GGUF metadata and apply
  the catalog's serving limits.
- The router and Hermes presets project the same model fields to their output
  formats; repo CI verifies that projections agree with the catalog.

An MLX entry can also define `profiles.mlx.swap` for its on-demand serving
limits; static resident and swap profiles are projected separately.

Stage 0 evaluation checkpoints use a separate `stage0` object. It records the
source Hugging Face repository, immutable revision, pipeline tag, and license.
An available Metal artifact records its own repository and revision, the source
checkpoint it was converted from, its format, runtime revision, and endpoint.
The decision checkpoints record their CPU reference server and System One API;
they do not claim a converted Metal artifact.

Each Stage 0 model declares `max_parallel_requests: 4` as its consumer-side
in-flight admission cap. This is a routing default accepted by the current
consumer limit, not measured service capacity or throughput. Load clients may
run the requested closed-loop concurrency ladder above this cap; record queued
requests and the cap with each result.

The model map's `stage0_embedding`, `stage0_systemone_opendecider`, and
`stage0_systemone_laya` IDs resolve to the three catalog entries. Consumers can
use these stable IDs without copying physical model IDs into host/provider
configuration. Their `egress` values are declared classifications; this
catalog does not enforce endpoint fallback policy. Consumers must verify their
local routes in their own rendered-configuration tests. The generic `embed`
role remains unbound until its consumer sends embedding tasks to the embedding
endpoint rather than chat completions.

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

See `files/model-catalog.json` for the full list and each field's meaning. Entries
without all three HuggingFace fields are provider-hosted or otherwise supplied
by an existing model server and are not downloaded by `llm_model_store_seed`.

## License

MIT — see [`LICENSE`](../../../LICENSE) at the repository root.
