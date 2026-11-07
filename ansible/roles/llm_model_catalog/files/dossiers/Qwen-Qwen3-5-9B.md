---
type: Model Dossier
title: "Qwen/Qwen3.5-9B"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/Qwen/Qwen3.5-9B).
- Upstream repository created: 2026-02-27 (Hub `createdAt`).
  Release date: UNVERIFIED. Conversion dates do not renew upstream age.
- Upstream creation or release date: 2026-02-27T12:58:26.000Z (`createdAt`),
  [Hub API](https://huggingface.co/api/models/Qwen/Qwen3.5-9B), observed 2026-11-06.
- Observed immutable upstream revision: `c202236235762e1c871ad0ccb60c8ee5ba337b9a`.
  [Pinned upstream card](https://huggingface.co/Qwen/Qwen3.5-9B/blob/c202236235762e1c871ad0ccb60c8ee5ba337b9a/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/Qwen/Qwen3.5-9B/tree/c202236235762e1c871ad0ccb60c8ee5ba337b9a).
  Additional restrictions: UNVERIFIED.
- Architecture: Qwen3_5ForConditionalGeneration.
- Intended task: Classification, evaluation, and summarization.
- Role-assigned artifacts: `mlx-community/Qwen3.5-9B-OptiQ-4bit`.

## 2. Artifact evidence

[Shared evidence](_shared/runtime-and-evaluation.md)

### unsloth/Qwen3.5-9B-GGUF

- [Artifact metadata](https://huggingface.co/api/models/unsloth/Qwen3.5-9B-GGUF?blobs=true),
  observed 2026-11-06; artifact repository created 2026-02-28.
- Artifact revision: `3885219b6810b007914f3a7950a8d1b469d598a5`.
  [Pinned files](https://huggingface.co/unsloth/Qwen3.5-9B-GGUF/tree/3885219b6810b007914f3a7950a8d1b469d598a5).
- Listed files match the observed artifact revision.
- Weight files:
  - `Qwen3.5-9B-Q4_K_M.gguf`: 5680522464 bytes.
- Listed weight total: 5680522464 bytes
  (5.29 GiB).

### mlx-community/Qwen3.5-9B-MLX-4bit

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/Qwen3.5-9B-MLX-4bit?blobs=true),
  observed 2026-11-06; artifact repository created 2026-03-02.
- Artifact revision: `938d8919941c6e7efd3c7150eff7fe9d12afa631`.
  [Pinned files](https://huggingface.co/mlx-community/Qwen3.5-9B-MLX-4bit/tree/938d8919941c6e7efd3c7150eff7fe9d12afa631).
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00002.safetensors`: 5349771222 bytes.
  - `model-00002-of-00002.safetensors`: 600449850 bytes.
- Listed weight total: 5950221072 bytes
  (5.54 GiB).

### mlx-community/Qwen3.5-9B-OptiQ-4bit

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/Qwen3.5-9B-OptiQ-4bit?blobs=true),
  observed 2026-11-06; artifact repository created 2026-03-05.
- Artifact revision: `10a7fc93870c02a14b6bd5ddef4a7f6ada5f111f`.
  [Pinned files](https://huggingface.co/mlx-community/Qwen3.5-9B-OptiQ-4bit/tree/10a7fc93870c02a14b6bd5ddef4a7f6ada5f111f).
- Artifact repository: `mlx-community/Qwen3.5-9B-OptiQ-4bit`.
- Artifact publisher: `mlx-community` (`author`).
- Immutable artifact revision: `10a7fc93870c02a14b6bd5ddef4a7f6ada5f111f` (`sha`).
- Artifact created date: 2026-03-05T12:04:40.000Z (`createdAt`).
- Evidence observed date: 2026-11-06,
  [Hub API](https://huggingface.co/api/models/mlx-community/Qwen3.5-9B-OptiQ-4bit?blobs=true).
- Quantization recipe: affine OptiQ allocation with a 4-bit default and 8-bit
  sensitive layers, group size 64 in the
  [pinned artifact config](https://huggingface.co/mlx-community/Qwen3.5-9B-OptiQ-4bit/blob/10a7fc93870c02a14b6bd5ddef4a7f6ada5f111f/config.json),
  observed 2026-11-06.
- Calibration provenance: KL-divergence sensitivity against a bf16 reference,
  40 samples in each of 6 domains (prose, reasoning, code, agent, tool-call,
  and constraint-bearing instructions), reported by the
  [pinned publisher card](https://huggingface.co/mlx-community/Qwen3.5-9B-OptiQ-4bit/blob/10a7fc93870c02a14b6bd5ddef4a7f6ada5f111f/README.md),
  observed 2026-11-06.
- Upstream source revision: not published by converter; the API `base_model`
  is `Qwen/Qwen3.5-9B`.
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00002.safetensors`: 5349382977 bytes.
  - `model-00002-of-00002.safetensors`: 1751328661 bytes.
  - `optiq/mtp.safetensors`: 185118739 bytes.
  - `optiq_vision.safetensors`: 912057935 bytes.
- Listed weight total: 8197888312 bytes
  (7.63 GiB).
