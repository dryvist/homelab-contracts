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
- Upstream creation or release date: 2026-09-14T14:53:42.000Z (`createdAt`),
  [Hub API](https://huggingface.co/api/models/google/embeddinggemma-2),
  observed 2026-11-06.
- Observed immutable upstream revision: `f9972ac22e696a105c482202646979e33e4b5a1e`.
  [Pinned upstream card](https://huggingface.co/google/embeddinggemma-2/blob/f9972ac22e696a105c482202646979e33e4b5a1e/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/google/embeddinggemma-2/tree/f9972ac22e696a105c482202646979e33e4b5a1e).
  Additional restrictions: UNVERIFIED.
- Architecture: EmbeddingGemma2Model.
- Intended task: Embedding extraction.
- Role-assigned artifacts: `nativ-community/embeddinggemma-2-mxfp8`.

## 2. Artifact evidence

[Shared evidence](_shared/runtime-and-evaluation.md)

### nativ-community/embeddinggemma-2-mxfp8

- [Artifact metadata](https://huggingface.co/api/models/nativ-community/embeddinggemma-2-mxfp8?blobs=true),
  observed 2026-11-06; artifact repository created 2026-10-06.
- Artifact revision: `a35a0bd2132265bc29a9130a1b2bcd545ad4b765`.
  [Pinned files](https://huggingface.co/nativ-community/embeddinggemma-2-mxfp8/tree/a35a0bd2132265bc29a9130a1b2bcd545ad4b765).
- Artifact repository: `nativ-community/embeddinggemma-2-mxfp8`.
- Artifact publisher: `nativ-community` (`author`).
- Immutable artifact revision: `a35a0bd2132265bc29a9130a1b2bcd545ad4b765` (`sha`).
- Artifact created date: 2026-10-06T15:53:49.000Z (`createdAt`).
- Evidence observed date: 2026-11-06,
  [Hub API](https://huggingface.co/api/models/nativ-community/embeddinggemma-2-mxfp8?blobs=true).
- Quantization recipe: MXFP8, 8 bits, group size 32; text encoder and audio
  projection quantized, other modality towers and vision projection stay BF16.
  [Pinned config](https://huggingface.co/nativ-community/embeddinggemma-2-mxfp8/blob/a35a0bd2132265bc29a9130a1b2bcd545ad4b765/config.json),
  observed 2026-11-06.
- Calibration provenance: not applicable; direct MLX-VLM MXFP8 conversion,
  with the no-calibration command published in the
  [pinned conversion recipe](https://huggingface.co/nativ-community/embeddinggemma-2-mxfp8/blob/a35a0bd2132265bc29a9130a1b2bcd545ad4b765/README.md),
  observed 2026-11-06.
- Upstream source revision: `914f7f89142e33e77833254d9c9b90c3cef7303b`,
  published in that recipe with MLX-VLM `3d87e88402f307efbf68e568971aa887ee7d9ed0`
  and MLX 0.32.3; Hub `base_model` is `google/embeddinggemma-2`.
- Listed files match the observed artifact revision.
- Weight files:
  - `model.safetensors`: 1225720015 bytes.
- Listed weight total: 1225720015 bytes
  (1.14 GiB).

## 3. Runtime and memory

[Shared evidence](_shared/runtime-and-evaluation.md)

- Runtime: mlx-vlm.
- Tagged runtime/container revision: `3d87e88402f307efbf68e568971aa887ee7d9ed0`.
- Endpoint behavior and unsupported features: /v1/embeddings; unsupported features
  UNVERIFIED.

## 4. Evaluation and comparison

- Benchmark: MTEB multilingual v2 Mean(Task), upstream 768d;
  score: 61.36; date: 2026-10-06;
  source: <https://huggingface.co/google/embeddinggemma-2/blob/914f7f89142e33e77833254d9c9b90c3cef7303b/README.md>
- Benchmark: MTEB code v1 NDCG@10, upstream 768d;
  score: 78.68; date: 2026-10-06;
  source: <https://huggingface.co/google/embeddinggemma-2/blob/914f7f89142e33e77833254d9c9b90c3cef7303b/README.md>
- Benchmark date basis: publisher card revision dated 2026-10-06 in the
  [card history](https://huggingface.co/google/embeddinggemma-2/commits/main/README.md),
  observed 2026-11-07. This is the converter's published source checkpoint.
- MXFP8 evidence: the [pinned conversion card](https://huggingface.co/nativ-community/embeddinggemma-2-mxfp8/blob/a35a0bd2132265bc29a9130a1b2bcd545ad4b765/README.md)
  reports text minimum cosine 0.998305 against PyTorch FP32; its conversion
  checks explicitly exclude MTEB and retrieval-quality evaluation. Observed
  2026-11-07. The MTEB scores above measure upstream full precision.

[Shared evidence](_shared/runtime-and-evaluation.md)

- Retrieval: task-matched MTEB/code retrieval, ViDoRe, dimensions,
  truncation, index compatibility, and re-embedding plan: UNVERIFIED.
