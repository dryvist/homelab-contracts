---
type: Model Dossier
title: "Qwen/Qwen3.8-27B"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Upstream repository and immutable revision: `Qwen/Qwen3.8-27B`,
  `8c0b3d30f3ae96f5c7f774de704bf0ada83e422a`.
  [Pinned upstream card](https://huggingface.co/Qwen/Qwen3.8-27B/blob/8c0b3d30f3ae96f5c7f774de704bf0ada83e422a/README.md).
- Upstream repository created: 2026-08-05T08:22:59.000Z (`createdAt`),
  [Hub metadata](https://huggingface.co/api/models/Qwen/Qwen3.8-27B),
  observed 2026-11-06. Conversion dates do not renew upstream age.
- Upstream creation or release date: 2026-08-05T08:22:59.000Z (`createdAt`),
  [Hub API](https://huggingface.co/api/models/Qwen/Qwen3.8-27B), observed 2026-11-06.
- Release date: 2026-08-14, [official release news](https://github.com/QwenLM/Qwen3.8#news),
  observed 2026-11-06. Repository creation precedes public release.
- License and restrictions: Apache-2.0; redistribution requires retaining the
  license and applicable notices, and identifying modified files. Trademark
  rights are excluded. [Upstream license](https://huggingface.co/Qwen/Qwen3.8-27B/resolve/main/LICENSE),
  observed 2026-11-06.
- Architecture: `Qwen3_5ForConditionalGeneration`, dense 27B vision-language
  model with hybrid gated-delta and attention layers.
  [Official model card](https://huggingface.co/Qwen/Qwen3.8-27B), observed 2026-11-06.
- Intended task: General chat, coding, long context, and tool calling.
- Role-assigned artifacts: `mlx-community/Qwen3.8-27B-4bit`.
- Official versus third-party evidence: upstream metadata, license, and card
  are publisher evidence. MLX conversion evidence is from the third-party
  artifact publisher; Arena and Artificial Analysis evaluate the upstream model.
- Lane rationale: Document the selected MLX artifact for chat, coding, and
  long-context roles, keeping upstream evaluations separate from quant results.

## 2. Artifact evidence

[Shared evidence](_shared/runtime-and-evaluation.md)

### unsloth/Qwen3.8-27B-GGUF

- [Artifact metadata](https://huggingface.co/api/models/unsloth/Qwen3.8-27B-GGUF?blobs=true),
  observed 2026-11-06; artifact repository created 2026-08-13.
- Artifact revision: `4ca720788d1e01f1bff70c033e0d0028fd02e502`.
  [Pinned files](https://huggingface.co/unsloth/Qwen3.8-27B-GGUF/tree/4ca720788d1e01f1bff70c033e0d0028fd02e502).
- Listed files match the observed artifact revision.
- Weight files:
  - `Qwen3.8-27B-UD-IQ3_XXS.gguf`: 10934860704 bytes.
- Listed weight total: 10934860704 bytes
  (10.18 GiB).

### mlx-community/Qwen3.8-27B-4bit

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/Qwen3.8-27B-4bit?blobs=true),
  observed 2026-11-06; artifact repository created
  2026-08-14T15:29:59.000Z (`createdAt`).
- Artifact repository and immutable revision: `mlx-community/Qwen3.8-27B-4bit`,
  `10c35caafbb80f7dc6a7a432cdd11af10a6d4818`.
  [Pinned files](https://huggingface.co/mlx-community/Qwen3.8-27B-4bit/tree/10c35caafbb80f7dc6a7a432cdd11af10a6d4818).
- Artifact repository: `mlx-community/Qwen3.8-27B-4bit`.
- Artifact publisher: `mlx-community` (`author`).
- Immutable artifact revision: `10c35caafbb80f7dc6a7a432cdd11af10a6d4818` (`sha`).
- Artifact created date: 2026-08-14T15:29:59.000Z (`createdAt`).
- Evidence observed date: 2026-11-06,
  [Hub API](https://huggingface.co/api/models/mlx-community/Qwen3.8-27B-4bit?blobs=true).
- Listed files match the observed artifact revision.
- Filename/shards and bytes:
  - `model-00001-of-00003.safetensors`: 5343268662 bytes.
  - `model-00002-of-00003.safetensors`: 5354185130 bytes.
  - `model-00003-of-00003.safetensors`: 5357087557 bytes.
- Listed weight total: 16054541349 bytes
  (14.95 GiB).
- Upstream source revision: not published by converter; `base_model` is
  `Qwen/Qwen3.8-27B`. The [pinned publisher card](https://huggingface.co/mlx-community/Qwen3.8-27B-4bit/blob/10c35caafbb80f7dc6a7a432cdd11af10a6d4818/README.md)
  reports conversion with `mlx-vlm` 0.6.8, observed 2026-11-06.
- Quantization recipe: 4-bit affine, group size 64,
  [pinned artifact configuration](https://huggingface.co/mlx-community/Qwen3.8-27B-4bit/blob/10c35caafbb80f7dc6a7a432cdd11af10a6d4818/config.json),
  observed 2026-11-06.
- Calibration provenance: not applicable; plain MLX affine 4-bit,
  group size 64 in the pinned configuration above, observed 2026-11-06.
- Transformation: publisher reports conversion to MLX; pruning, merging,
  distillation, or safety modification evidence: UNVERIFIED.

## 4. Evaluation and comparison

- Dated upstream evaluations, observed 2026-11-06:
  - [Text Arena overall](https://arena.ai/leaderboard/chat/text), board dated
    2026-11-06: `Qwen3.8-27B`, rank 108, score 1435 ± 5, 32,347 votes.
  - [Artificial Analysis](https://artificialanalysis.ai/models/qwen3-8-27b):
    `Qwen3.8 27B (xhigh)`, Intelligence Index v5.0.1 score 20.
    Observation date records retrieval, not an evaluation publication date.
  - [Official model card](https://huggingface.co/Qwen/Qwen3.8-27B): IFBench
    79.5, Terminal-Bench 2.1 with Terminus 73.0, LiveCodeBench v6 90.3,
    SWE-bench Pro 61.7 with Claude Code, temperature 1.0, top-p 0.95, and
    256K context. These are publisher results for the upstream weights.
- These upstream rows do not measure the selected MLX quant's fidelity or
  establish task-matched runtime, memory, or promotion evidence.

[Shared evidence](_shared/runtime-and-evaluation.md)

- General chat: upstream preference, index, and instruction-following results
  above; selected-quant agent-task evidence remains UNVERIFIED.
- Coding: SWE-bench split/scaffold, Terminal-Bench version/scaffold,
  LiveCodeBench, and Aider results: UNVERIFIED.
- Long context: RULER and long-document results by operating length,
  reasoning/output allowance, and prefill cost: UNVERIFIED.
- Tool calling: BFCL and tau-bench, malformed/parallel/irrelevant calls,
  multi-turn reliability, and serving parser results: UNVERIFIED.
