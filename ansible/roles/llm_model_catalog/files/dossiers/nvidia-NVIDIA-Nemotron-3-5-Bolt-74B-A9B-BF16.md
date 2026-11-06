---
type: Model Dossier
title: "nvidia/NVIDIA-Nemotron-3.5-Bolt-74B-A9B-BF16"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/nvidia/NVIDIA-Nemotron-3.5-Bolt-74B-A9B-BF16).
- Upstream repository created: 2026-10-09 (Hub `createdAt`).
  Release date: UNVERIFIED. Conversion dates do not renew upstream age.
- Observed immutable upstream revision: `e09a4cedb1787db1760375ee5539f222cae0c672`.
  [Pinned upstream card](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Bolt-74B-A9B-BF16/blob/e09a4cedb1787db1760375ee5539f222cae0c672/README.md).
- License: openmdw-1.1. [License evidence](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Bolt-74B-A9B-BF16/tree/e09a4cedb1787db1760375ee5539f222cae0c672).
  Additional restrictions: UNVERIFIED.
- Architecture: NemotronH_Omni_Reasoning_V3.
- Intended task: Catalogued self-hosted inference; role assignment absent.
- Role-assigned artifacts: none.
- Official evidence: upstream Hub metadata and card. Conversion evidence is
  third-party unless the artifact and upstream publishers match.

## 2. Artifact evidence

### nvidia/NVIDIA-Nemotron-3.5-Bolt-74B-A9B-24GB-GGUF

- [Artifact metadata](https://huggingface.co/api/models/nvidia/NVIDIA-Nemotron-3.5-Bolt-74B-A9B-24GB-GGUF?blobs=true),
  observed 2026-11-06; artifact repository created 2026-10-07.
- Artifact revision: `e0fecb69cb3e5e4c5e8a056fa2aec98c78e91246`.
  [Pinned files](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Bolt-74B-A9B-24GB-GGUF/tree/e0fecb69cb3e5e4c5e8a056fa2aec98c78e91246).
- Listed files match the observed artifact revision.
- Weight files:
  - `NVIDIA-Nemotron-3.5-Bolt-74B-A9B-24GB.gguf`: 22018326528 bytes.
- Listed weight total: 22018326528 bytes
  (20.51 GiB); tokenizer, configuration,
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
