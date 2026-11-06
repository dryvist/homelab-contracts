---
type: Model Dossier
title: "Qwen/Qwen3.8-27B"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/Qwen/Qwen3.8-27B).
- Upstream repository created: 2026-08-05 (Hub `createdAt`).
  Release date: UNVERIFIED. Conversion dates do not renew upstream age.
- Observed immutable upstream revision: `8c0b3d30f3ae96f5c7f774de704bf0ada83e422a`.
  [Pinned upstream card](https://huggingface.co/Qwen/Qwen3.8-27B/blob/8c0b3d30f3ae96f5c7f774de704bf0ada83e422a/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/Qwen/Qwen3.8-27B/tree/8c0b3d30f3ae96f5c7f774de704bf0ada83e422a).
  Additional restrictions: UNVERIFIED.
- Architecture: Qwen3_5ForConditionalGeneration.
- Intended task: General chat, coding, long context, and tool calling.
- Role-assigned artifacts: `mlx-community/Qwen3.8-27B-4bit`.
- Official evidence: upstream Hub metadata and card. Conversion evidence is
  third-party unless the artifact and upstream publishers match.

## 2. Artifact evidence

### unsloth/Qwen3.8-27B-GGUF

- [Artifact metadata](https://huggingface.co/api/models/unsloth/Qwen3.8-27B-GGUF?blobs=true),
  observed 2026-11-06; artifact repository created 2026-08-13.
- Artifact revision: `4ca720788d1e01f1bff70c033e0d0028fd02e502`.
  [Pinned files](https://huggingface.co/unsloth/Qwen3.8-27B-GGUF/tree/4ca720788d1e01f1bff70c033e0d0028fd02e502).
- Listed files match the observed artifact revision.
- Weight files:
  - `Qwen3.8-27B-UD-IQ3_XXS.gguf`: 10934860704 bytes.
- Listed weight total: 10934860704 bytes
  (10.18 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: artifact declares this upstream as its base;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

### mlx-community/Qwen3.8-27B-4bit

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/Qwen3.8-27B-4bit?blobs=true),
  observed 2026-11-06; artifact repository created 2026-08-14.
- Artifact revision: `10c35caafbb80f7dc6a7a432cdd11af10a6d4818`.
  [Pinned files](https://huggingface.co/mlx-community/Qwen3.8-27B-4bit/tree/10c35caafbb80f7dc6a7a432cdd11af10a6d4818).
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00003.safetensors`: 5343268662 bytes.
  - `model-00002-of-00003.safetensors`: 5354185130 bytes.
  - `model-00003-of-00003.safetensors`: 5357087557 bytes.
- Listed weight total: 16054541349 bytes
  (14.95 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: artifact declares this upstream as its base;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

## 3. Runtime and memory

- Runtime: MLX or llama.cpp according to the selected artifact.
- Tagged runtime/container revision: UNVERIFIED.
- Hardware path: local accelerator; exact runtime qualification UNVERIFIED.
- Endpoint contract: UNVERIFIED.
- Precision kernels, tokenizer/chat template compatibility, reasoning parser,
  tool parser, and unsupported features: UNVERIFIED.
- Analytical memory lower bound: selected weight bytes above divided by
  1,073,741,824. This assumes weights alone and excludes key/value cache,
  recurrent state, vision workspace, graph/compiler workspace, drafter, and
  co-resident models. Full estimate and comparable measured peak: UNVERIFIED.
- Intended input/output length and concurrency: UNVERIFIED for a matched trial;
  catalog serving limits are configuration values, not measured capacity.

## 4. Evaluation and comparison

- Candidate/incumbent comparison under matched settings: UNVERIFIED.
- Expected quality, quantization fidelity, latency, and throughput: UNVERIFIED.
- General chat: dated Arena category, LiveBench/Artificial Analysis version,
  instruction following, and agent-task evidence: UNVERIFIED.
- Coding: SWE-bench split/scaffold, Terminal-Bench version/scaffold,
  LiveCodeBench, and Aider results: UNVERIFIED.
- Long context: RULER and long-document results by operating length,
  reasoning/output allowance, and prefill cost: UNVERIFIED.
- Tool calling: BFCL and tau-bench, malformed/parallel/irrelevant calls,
  multi-turn reliability, and serving parser results: UNVERIFIED.

## 5. Trial status

- Dossier started; trial authorization pending completed evidence.
- Acceptance thresholds, matched incumbent baseline, and expected-result
  statement: UNVERIFIED; set them before a trial or replacement.
- The policy records dated identity and age eligibility. It does not certify
  runtime support, memory fit, quality, or replacement readiness.
