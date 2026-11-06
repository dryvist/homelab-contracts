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
- Observed immutable upstream revision: `c202236235762e1c871ad0ccb60c8ee5ba337b9a`.
  [Pinned upstream card](https://huggingface.co/Qwen/Qwen3.5-9B/blob/c202236235762e1c871ad0ccb60c8ee5ba337b9a/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/Qwen/Qwen3.5-9B/tree/c202236235762e1c871ad0ccb60c8ee5ba337b9a).
  Additional restrictions: UNVERIFIED.
- Architecture: Qwen3_5ForConditionalGeneration.
- Intended task: Small requests, judging, and recording.
- Role-assigned artifacts: `mlx-community/Qwen3.5-9B-OptiQ-4bit`.
- Official evidence: upstream Hub metadata and card. Conversion evidence is
  third-party unless the artifact and upstream publishers match.

## 2. Artifact evidence

### unsloth/Qwen3.5-9B-GGUF

- [Artifact metadata](https://huggingface.co/api/models/unsloth/Qwen3.5-9B-GGUF?blobs=true),
  observed 2026-11-06; artifact repository created 2026-02-28.
- Artifact revision: `3885219b6810b007914f3a7950a8d1b469d598a5`.
  [Pinned files](https://huggingface.co/unsloth/Qwen3.5-9B-GGUF/tree/3885219b6810b007914f3a7950a8d1b469d598a5).
- Listed files match the observed artifact revision.
- Weight files:
  - `Qwen3.5-9B-Q4_K_M.gguf`: 5680522464 bytes.
- Listed weight total: 5680522464 bytes
  (5.29 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: artifact declares this upstream as its base;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

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
  (5.54 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: artifact declares this upstream as its base;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

### mlx-community/Qwen3.5-9B-OptiQ-4bit

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/Qwen3.5-9B-OptiQ-4bit?blobs=true),
  observed 2026-11-06; artifact repository created 2026-03-05.
- Artifact revision: `10a7fc93870c02a14b6bd5ddef4a7f6ada5f111f`.
  [Pinned files](https://huggingface.co/mlx-community/Qwen3.5-9B-OptiQ-4bit/tree/10a7fc93870c02a14b6bd5ddef4a7f6ada5f111f).
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00002.safetensors`: 5349382977 bytes.
  - `model-00002-of-00002.safetensors`: 1751328661 bytes.
  - `optiq/mtp.safetensors`: 185118739 bytes.
  - `optiq_vision.safetensors`: 912057935 bytes.
- Listed weight total: 8197888312 bytes
  (7.63 GiB); tokenizer, configuration,
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
- Classification/extraction: task-matched accuracy, schema validity, class
  balance, languages, calibration, abstention, false positives/negatives,
  and latency: UNVERIFIED.

## 5. Trial status

- Dossier started; trial authorization pending completed evidence.
- Acceptance thresholds, matched incumbent baseline, and expected-result
  statement: UNVERIFIED; set them before a trial or replacement.
- The policy records dated identity and age eligibility. It does not certify
  runtime support, memory fit, quality, or replacement readiness.
