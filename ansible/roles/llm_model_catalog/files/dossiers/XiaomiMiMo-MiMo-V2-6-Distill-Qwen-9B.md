---
type: Model Dossier
title: "XiaomiMiMo/MiMo-V2.6-Distill-Qwen-9B"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/XiaomiMiMo/MiMo-V2.6-Distill-Qwen-9B).
- Upstream repository created: 2026-09-21 (Hub `createdAt`).
  Release date: UNVERIFIED. Conversion dates do not renew upstream age.
- Observed immutable upstream revision: `1f09ddcc1a0ea45751ae0dfe2af20d533168c46f`.
  [Pinned upstream card](https://huggingface.co/XiaomiMiMo/MiMo-V2.6-Distill-Qwen-9B/blob/1f09ddcc1a0ea45751ae0dfe2af20d533168c46f/README.md).
- License: mit. [License evidence](https://huggingface.co/XiaomiMiMo/MiMo-V2.6-Distill-Qwen-9B/tree/1f09ddcc1a0ea45751ae0dfe2af20d533168c46f).
  Additional restrictions: UNVERIFIED.
- Architecture: Qwen3_5ForConditionalGeneration.
- Intended task: Short-request inference and output evaluation.
- Role-assigned artifacts: `mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit`.
- Official evidence: upstream Hub metadata and card. Conversion evidence is
  third-party unless the artifact and upstream publishers match.

## 2. Artifact evidence

### mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit?blobs=true),
  observed 2026-11-06; artifact repository created 2026-09-21.
- Artifact revision: `60061fc7499d25ce238e0687154557e504ea690a`.
  [Pinned files](https://huggingface.co/mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit/tree/60061fc7499d25ce238e0687154557e504ea690a).
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00002.safetensors`: 5349381654 bytes.
  - `model-00002-of-00002.safetensors`: 1751328472 bytes.
- Listed weight total: 7100710126 bytes
  (6.61 GiB); tokenizer, configuration,
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
- Benchmark: Terminal-Bench 2.1 avg@1; score: 37.1; date: 2026-10-28; source: https://huggingface.co/XiaomiMiMo/MiMo-V2.6-Distill-Qwen-9B/blob/1f09ddcc1a0ea45751ae0dfe2af20d533168c46f/README.md
```

- [Card publication history](https://huggingface.co/XiaomiMiMo/MiMo-V2.6-Distill-Qwen-9B/commits/main/README.md).

- Classification/extraction: see the [shared task evidence](_shared/runtime-and-evaluation.md#classification-and-extraction).

## 5. Trial status

[Shared evidence](_shared/runtime-and-evaluation.md)
