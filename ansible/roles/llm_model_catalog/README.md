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

An MLX entry defines `profiles.mlx.context_window`, `max_output_tokens`,
`max_parallel_requests`, `queue_size`, `prefill_tokens_per_second`, and
`decode_tokens_per_second` for resident serving. It can also define
`profiles.mlx.swap` for on-demand serving limits; static resident and swap
profiles are projected separately.

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

## Model policy

`files/model-policy.json` records upstream creation dates, denied model IDs,
and hosted-provider exemptions. CI measures upstream age against the current
UTC date and requires `as_of` to be within the preceding 30 days.

Global roles, host role overrides, and host resident and swap selections use
the same eligibility checks. The single
[dossier field contract](../../../../tests/llm_model_catalog/dossier-fields.json)
marks each field as `admission`, `complete`, or `optional`.

Admission requires an upstream creation or release date, artifact repository,
publisher, immutable Hub `sha`, artifact `createdAt`, observation date, and a
quantization method from the artifact's own configuration or metadata. The
artifact identity, publisher, revision, and creation date cite the Hub API.
Every admitted policy model also records at least 1 model-specific benchmark
with a numeric score, a valid nonfuture date, and an HTTP(S) source URL.
The same benchmark rule applies to complete dossiers and every selection.
Calibration provenance is required for calibrated methods; calibration-free
methods record "not applicable" with their method and source. Every required
field rejects missing or `UNVERIFIED` evidence, including continuation lines.
Each selected artifact supplies its own facts within its dossier subsection.
When the catalog pins `hf_revision`, a converted artifact revision, or a source
checkpoint revision, that selection requires the same immutable artifact
revision in its dossier. Aliases and catalog references retain the selected pin.

The converter's upstream revision is optional. When it is not published, the
dossier records `base_model` and "not published by converter". Weight-download
dates belong to deployment records. Repository creation dates do not claim a
conversion timestamp.

Dossier front matter accepts `status: started` or `status: complete`. Every
complete model dossier passes the full evidence gate, including models without
role assignments and every artifact in the dossier. Started dossiers can pass
admission while runtime, further evaluation, and trial evidence remains unfinished.
Shared evidence supplies sections and field defaults through one
`[Shared evidence](_shared/runtime-and-evaluation.md)` reference; local fields
override only their matching defaults.

The evidence fields cover upstream identity, artifacts, runtime support,
memory budgets, task-matched evaluations, and promotion criteria. Benchmark
evidence records applicable use cases, dated results and versions, matched
settings, quantization fidelity, and expected results.

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
