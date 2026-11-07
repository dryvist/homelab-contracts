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
- Upstream creation or release date: 2026-09-21T18:18:40.000Z (`createdAt`),
  [Hub API](https://huggingface.co/api/models/XiaomiMiMo/MiMo-V2.6-Distill-Qwen-9B),
  observed 2026-11-06.
- Observed immutable upstream revision: `1f09ddcc1a0ea45751ae0dfe2af20d533168c46f`.
  [Pinned upstream card](https://huggingface.co/XiaomiMiMo/MiMo-V2.6-Distill-Qwen-9B/blob/1f09ddcc1a0ea45751ae0dfe2af20d533168c46f/README.md).
- License: mit. [License evidence](https://huggingface.co/XiaomiMiMo/MiMo-V2.6-Distill-Qwen-9B/tree/1f09ddcc1a0ea45751ae0dfe2af20d533168c46f).
  Additional restrictions: UNVERIFIED.
- Architecture: Qwen3_5ForConditionalGeneration.
- Intended task: Classification, evaluation, and summarization.
- Role-assigned artifacts: `mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit`.

## 2. Artifact evidence

[Shared evidence](_shared/runtime-and-evaluation.md)

### mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit?blobs=true),
  observed 2026-11-06; artifact repository created 2026-09-21.
- Artifact revision: `60061fc7499d25ce238e0687154557e504ea690a`.
  [Pinned files](https://huggingface.co/mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit/tree/60061fc7499d25ce238e0687154557e504ea690a).
- Artifact repository: `mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit`.
- Artifact publisher: `mlx-community` (`author`).
- Immutable artifact revision: `60061fc7499d25ce238e0687154557e504ea690a` (`sha`).
- Artifact created date: 2026-09-21T23:21:27.000Z (`createdAt`).
- Evidence observed date: 2026-11-06,
  [Hub API](https://huggingface.co/api/models/mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit?blobs=true).
- Quantization recipe: OptiQ mixed 4/8-bit affine, group size 64,
  [pinned config](https://huggingface.co/mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit/blob/60061fc7499d25ce238e0687154557e504ea690a/config.json),
  observed 2026-11-06.
- Calibration provenance: publisher transferred the Qwen3.5-9B allocation,
  derived from KL sensitivity over prose, reasoning, code, agent, tool-call,
  and instruction domains; no sensitivity measurement on this checkpoint.
  [Pinned publisher card](https://huggingface.co/mlx-community/MiMo-V2.6-Distill-Qwen-9B-OptiQ-4bit/blob/60061fc7499d25ce238e0687154557e504ea690a/README.md),
  observed 2026-11-06.
- Upstream source revision: not published by converter; `base_model` is
  `XiaomiMiMo/MiMo-V2.6-Distill-Qwen-9B` in the artifact API metadata.
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00002.safetensors`: 5349381654 bytes.
  - `model-00002-of-00002.safetensors`: 1751328472 bytes.
- Listed weight total: 7100710126 bytes
  (6.61 GiB).
