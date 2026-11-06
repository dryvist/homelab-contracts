---
type: Model Dossier
title: "Qwen/Qwen3.6-27B"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/Qwen/Qwen3.6-27B).
- Upstream repository created: 2026-04-21 (Hub `createdAt`).
  Release date: UNVERIFIED. Conversion dates do not renew upstream age.
- Observed immutable upstream revision: `6a9e13bd6fc8f0983b9b99948120bc37f49c13e9`.
  [Pinned upstream card](https://huggingface.co/Qwen/Qwen3.6-27B/blob/6a9e13bd6fc8f0983b9b99948120bc37f49c13e9/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/Qwen/Qwen3.6-27B/tree/6a9e13bd6fc8f0983b9b99948120bc37f49c13e9).
  Additional restrictions: UNVERIFIED.
- Architecture: Qwen3_5ForConditionalGeneration.
- Intended task: Catalogued self-hosted inference; role assignment absent.
- Role-assigned artifacts: none.
- Official evidence: upstream Hub metadata and card. Conversion evidence is
  third-party unless the artifact and upstream publishers match.

## 2. Artifact evidence

### mlx-community/Qwen3.6-27B-mxfp4

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/Qwen3.6-27B-mxfp4?blobs=true),
  observed 2026-11-06; artifact repository created 2026-04-22.
- Artifact revision: `b4ac73652af626fd653d0e4fe48a4e9c468a82f6`.
  [Pinned files](https://huggingface.co/mlx-community/Qwen3.6-27B-mxfp4/tree/b4ac73652af626fd653d0e4fe48a4e9c468a82f6).
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00003.safetensors`: 5348727346 bytes.
  - `model-00002-of-00003.safetensors`: 5349386469 bytes.
  - `model-00003-of-00003.safetensors`: 4515944397 bytes.
- Listed weight total: 15214058212 bytes
  (14.17 GiB); tokenizer, configuration,
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
