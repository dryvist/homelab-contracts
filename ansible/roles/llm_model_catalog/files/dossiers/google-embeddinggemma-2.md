---
type: Model Dossier
title: "google/embeddinggemma-2"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/google/embeddinggemma-2).
- Release: [2026-10-06](https://blog.google/innovation-and-ai/technology/developers-tools/embeddinggemma-2/).
  Repository creation date: UNVERIFIED in this live refresh.
  Conversion dates do not renew upstream age.
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

### nativ-community/embeddinggemma-2-mxfp8

- [Artifact metadata](https://huggingface.co/api/models/nativ-community/embeddinggemma-2-mxfp8?blobs=true),
  metadata access unavailable in this refresh; repository creation date:
  UNVERIFIED.
- Catalog artifact revision: `a35a0bd2132265bc29a9130a1b2bcd545ad4b765`.
  [Pinned files](https://huggingface.co/nativ-community/embeddinggemma-2-mxfp8/tree/a35a0bd2132265bc29a9130a1b2bcd545ad4b765).
- Catalog snapshot weight files; current revision/bytes re-verification:
  UNVERIFIED.
  - `model.safetensors`: 1225720015 bytes.
- Listed weight total: 1225720015 bytes
  (1.14 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  source `google/embeddinggemma-2@914f7f89142e33e77833254d9c9b90c3cef7303b`
  is declared in the catalog; remaining conversion fields: UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: artifact declares this upstream as its base;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

## 3. Runtime and memory

[Shared evidence](_shared/runtime-and-evaluation.md)

- Runtime: mlx-vlm.
- Catalog runtime revision: `3d87e88402f307efbf68e568971aa887ee7d9ed0`;
  live qualification: UNVERIFIED.
- Endpoint contract: /v1/embeddings.

## 4. Evaluation and comparison

[Shared evidence](_shared/runtime-and-evaluation.md)

```text
- Benchmark: MTEB multilingual v2; score: 61.36; date: 2026-10-28; source: https://huggingface.co/google/embeddinggemma-2/blob/f9972ac22e696a105c482202646979e33e4b5a1e/README.md
```

- [Card publication history](https://huggingface.co/google/embeddinggemma-2/commits/main/README.md).

- [Official card](https://huggingface.co/google/embeddinggemma-2), observed
  2026-11-06: MTEB multilingual v2 61.36; MTEB Code v1 78.68.
  Individual evaluation day and MXFP8 conversion fidelity: UNVERIFIED.
- Card architecture: 740M total parameters and multimodal encoders.
  It documents an 8,192-token operating window and 768-dimensional output,
  with 512/256/128-dimensional truncation followed by re-normalization.
  The example text/code results use the full 768 dimensions.
- Selected dimension, truncation, language/domain-matched retrieval
  subsets, ViDoRe result, candidate/incumbent comparison, indexing/query
  throughput, latency, and quantization tolerance: UNVERIFIED.
- Expected local result: UNVERIFIED. Proposed comparison criterion:
  preserve incumbent retrieval quality at a declared dimension within
  predeclared latency and memory bounds. Numeric thresholds, dataset
  version, baseline revision, and uncertainty estimate: UNVERIFIED.
- Index compatibility and re-embedding plan: UNVERIFIED. Define a complete
  collection rebuild, held-out retrieval comparison, and rollback before
  replacement. No collection is modified by this evidence update.

## 5. Trial status

[Shared evidence](_shared/runtime-and-evaluation.md)

- No new policy entry is added. The inherited MXFP8 entry is unchanged;
  upstream BF16 admission remains pending completed evidence.
- Completion gaps: live artifact provenance/bytes, restrictions review,
  target runtime, full memory budget, dated matched retrieval evaluation,
  re-embedding plan, and numeric acceptance thresholds.
