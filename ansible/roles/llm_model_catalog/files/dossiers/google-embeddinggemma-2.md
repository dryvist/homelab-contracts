---
type: Model Dossier
title: "google/embeddinggemma-2"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/google/embeddinggemma-2).
- Upstream repository created: 2026-09-14 (Hub `createdAt`).
  Release date: UNVERIFIED. Conversion dates do not renew upstream age.
- Observed immutable upstream revision: `f9972ac22e696a105c482202646979e33e4b5a1e`.
  [Pinned upstream card](https://huggingface.co/google/embeddinggemma-2/blob/f9972ac22e696a105c482202646979e33e4b5a1e/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/google/embeddinggemma-2/tree/f9972ac22e696a105c482202646979e33e4b5a1e).
  Additional restrictions: UNVERIFIED.
- Architecture: EmbeddingGemma2Model.
- Intended task: Embedding extraction.
- Role-assigned artifacts: `nativ-community/embeddinggemma-2-mxfp8`.
- Official evidence: upstream Hub metadata and card. Conversion evidence is
  third-party unless the artifact and upstream publishers match.

## 2. Artifact evidence

[Shared evidence](_shared/runtime-and-evaluation.md)

### nativ-community/embeddinggemma-2-mxfp8

- [Artifact metadata](https://huggingface.co/api/models/nativ-community/embeddinggemma-2-mxfp8?blobs=true),
  observed 2026-11-06; artifact repository created 2026-10-06.
- Artifact revision: `a35a0bd2132265bc29a9130a1b2bcd545ad4b765`.
  [Pinned files](https://huggingface.co/nativ-community/embeddinggemma-2-mxfp8/tree/a35a0bd2132265bc29a9130a1b2bcd545ad4b765).
- Listed files match the observed artifact revision.
- Weight files:
  - `model.safetensors`: 1225720015 bytes.
- Listed weight total: 1225720015 bytes
  (1.14 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  source `google/embeddinggemma-2@914f7f89142e33e77833254d9c9b90c3cef7303b`
  is declared in the catalog; remaining conversion fields: UNVERIFIED.

## 3. Runtime and memory

[Shared evidence](_shared/runtime-and-evaluation.md)

- Runtime: mlx-vlm.
- Tagged runtime/container revision: `3d87e88402f307efbf68e568971aa887ee7d9ed0`.
- Endpoint behavior and unsupported features: /v1/embeddings; unsupported features
  UNVERIFIED.

## 4. Evaluation and comparison

[Shared evidence](_shared/runtime-and-evaluation.md)

- Retrieval: task-matched MTEB/code retrieval, ViDoRe, dimensions,
  truncation, index compatibility, and re-embedding plan: UNVERIFIED.

## 5. Trial status

[Shared evidence](_shared/runtime-and-evaluation.md)
