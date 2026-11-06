---
type: Model Dossier
title: "Qwen/Qwen3.6-35B-A3B"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/Qwen/Qwen3.6-35B-A3B).
- Upstream repository created: 2026-04-15 (Hub `createdAt`).
  Release date: UNVERIFIED. Conversion dates do not renew upstream age.
- Observed immutable upstream revision: `995ad96eacd98c81ed38be0c5b274b04031597b0`.
  [Pinned upstream card](https://huggingface.co/Qwen/Qwen3.6-35B-A3B/blob/995ad96eacd98c81ed38be0c5b274b04031597b0/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/Qwen/Qwen3.6-35B-A3B/tree/995ad96eacd98c81ed38be0c5b274b04031597b0).
  Additional restrictions: UNVERIFIED.
- Architecture: Qwen3_5MoeForConditionalGeneration.
- Intended task: Catalogued self-hosted inference; role assignment absent.
- Role-assigned artifacts: none.
- Official evidence: upstream Hub metadata and card. Conversion evidence is
  third-party unless the artifact and upstream publishers match.

## 2. Artifact evidence

### bartowski/Qwen_Qwen3.6-35B-A3B-GGUF

- [Artifact metadata](https://huggingface.co/api/models/bartowski/Qwen_Qwen3.6-35B-A3B-GGUF?blobs=true),
  observed 2026-11-06; artifact repository created 2026-04-16.
- Artifact revision: `5c2410d71524f4f72b023ce8daf7a80528226d5f`.
  [Pinned files](https://huggingface.co/bartowski/Qwen_Qwen3.6-35B-A3B-GGUF/tree/5c2410d71524f4f72b023ce8daf7a80528226d5f).
- Listed files match the observed artifact revision.
- Weight files:
  - `Qwen_Qwen3.6-35B-A3B-Q4_K_M.gguf`: 22285080192 bytes.
- Listed weight total: 22285080192 bytes
  (20.75 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: artifact declares this upstream as its base;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

### mlx-community/Qwen3.6-35B-A3B-4bit

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/Qwen3.6-35B-A3B-4bit?blobs=true),
  observed 2026-11-06; artifact repository created 2026-04-16.
- Artifact revision: `38740b847e4cb78f352aba30aa41c76e08e6eb46`.
  [Pinned files](https://huggingface.co/mlx-community/Qwen3.6-35B-A3B-4bit/tree/38740b847e4cb78f352aba30aa41c76e08e6eb46).
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00004.safetensors`: 5288196018 bytes.
  - `model-00002-of-00004.safetensors`: 5368472749 bytes.
  - `model-00003-of-00004.safetensors`: 5368324139 bytes.
  - `model-00004-of-00004.safetensors`: 4377211365 bytes.
- Listed weight total: 20402204271 bytes
  (19.00 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: artifact declares this upstream as its base;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

### mlx-community/Qwen3.6-35B-A3B-OptiQ-4bit

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/Qwen3.6-35B-A3B-OptiQ-4bit?blobs=true),
  observed 2026-11-06; artifact repository created 2026-04-26.
- Artifact revision: `08567bc6e2bcb36630b3efb9aca40611c9832795`.
  [Pinned files](https://huggingface.co/mlx-community/Qwen3.6-35B-A3B-OptiQ-4bit/tree/08567bc6e2bcb36630b3efb9aca40611c9832795).
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00005.safetensors`: 5354469690 bytes.
  - `model-00002-of-00005.safetensors`: 5367895914 bytes.
  - `model-00003-of-00005.safetensors`: 5247553415 bytes.
  - `model-00004-of-00005.safetensors`: 5185753324 bytes.
  - `model-00005-of-00005.safetensors`: 979903453 bytes.
  - `optiq/mtp.safetensors`: 487458979 bytes.
  - `optiq/optiq_vision.safetensors`: 893179469 bytes.
- Listed weight total: 23516214244 bytes
  (21.90 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: artifact declares this upstream as its base;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

## 3. Runtime and memory

[Shared evidence](_shared/runtime-and-evaluation.md)

## 4. Evaluation and comparison

[Shared evidence](_shared/runtime-and-evaluation.md)

```text
- Benchmark: MMLU-Pro upstream; score: 85.2; date: 2026-04-24;
  source: https://huggingface.co/Qwen/Qwen3.6-35B-A3B/blob/995ad96eacd98c81ed38be0c5b274b04031597b0/README.md
```

- [Card publication history](https://huggingface.co/Qwen/Qwen3.6-35B-A3B/commits/main/README.md).

- Classification/extraction: see the [shared task evidence](_shared/runtime-and-evaluation.md#classification-and-extraction).

## 5. Trial status

[Shared evidence](_shared/runtime-and-evaluation.md)
