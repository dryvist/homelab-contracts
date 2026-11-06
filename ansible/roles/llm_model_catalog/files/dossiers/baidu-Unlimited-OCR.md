---
type: Model Dossier
title: "baidu/Unlimited-OCR"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/baidu/Unlimited-OCR).
- Upstream repository created: 2026-06-19 (Hub `createdAt`).
  Release date: UNVERIFIED. Conversion dates do not renew upstream age.
- Observed immutable upstream revision: `8249d20b2822a7d8a4c22c8d8c9069b5ac36bda3`.
  [Pinned upstream card](https://huggingface.co/baidu/Unlimited-OCR/blob/8249d20b2822a7d8a4c22c8d8c9069b5ac36bda3/README.md).
- License: mit. [License evidence](https://huggingface.co/baidu/Unlimited-OCR/tree/8249d20b2822a7d8a4c22c8d8c9069b5ac36bda3).
  Additional restrictions: UNVERIFIED.
- Architecture: UnlimitedOCRForCausalLM.
- Intended task: Optical character recognition and document parsing.
- Role-assigned artifacts: `mlx-community/Unlimited-OCR-bf16`.
- Official evidence: upstream Hub metadata and card. Conversion evidence is
  third-party unless the artifact and upstream publishers match.

## 2. Artifact evidence

### mlx-community/Unlimited-OCR-bf16

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/Unlimited-OCR-bf16?blobs=true),
  observed 2026-11-06; artifact repository created 2026-07-31.
- Artifact revision: `6d9f675e3fa73dd49cd03f630868b1941c72803f`.
  [Pinned files](https://huggingface.co/mlx-community/Unlimited-OCR-bf16/tree/6d9f675e3fa73dd49cd03f630868b1941c72803f).
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00002.safetensors`: 5240462002 bytes.
  - `model-00002-of-00002.safetensors`: 1431828399 bytes.
- Listed weight total: 6672290401 bytes
  (6.21 GiB); tokenizer, configuration,
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

```text
- Benchmark: OmniDocBench v1.5; score: 93.23; date: 2026-06-22; source: https://arxiv.org/html/2606.23050v1
```

- Publication date: report v1 header; Table 1 reports the upstream model.
  Observed 2026-11-06; conversion fidelity and local results remain UNVERIFIED.

- Candidate/incumbent comparison under matched settings: UNVERIFIED.
- Expected quality, quantization fidelity, latency, and throughput: UNVERIFIED.
- Documents: OCRBench and OmniDocBench/olmOCR, text error, tables,
  formulas, reading order, layout, languages, and long-document results:
  UNVERIFIED.

## 5. Trial status

- Dossier started; trial authorization pending completed evidence.
- Acceptance thresholds, matched incumbent baseline, and expected-result
  statement: UNVERIFIED; set them before a trial or replacement.
- The policy records dated identity and age eligibility. It does not certify
  runtime support, memory fit, quality, or replacement readiness.
