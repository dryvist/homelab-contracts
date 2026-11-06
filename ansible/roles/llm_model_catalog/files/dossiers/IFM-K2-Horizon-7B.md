---
type: Model Dossier
title: "IFM/K2-Horizon-7B"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/IFM/K2-Horizon-7B).
- Upstream repository created: 2026-09-01 (Hub `createdAt`).
  Release date: UNVERIFIED. Conversion dates do not renew upstream age.
- Observed immutable upstream revision: `1ad5223c80f635ede5fb926f6304dc7228246a4b`.
  [Pinned upstream card](https://huggingface.co/IFM/K2-Horizon-7B/blob/1ad5223c80f635ede5fb926f6304dc7228246a4b/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/IFM/K2-Horizon-7B/tree/1ad5223c80f635ede5fb926f6304dc7228246a4b).
  Additional restrictions: UNVERIFIED.
- Architecture: K2HorizonForCausalLM.
- Intended task: Catalogued self-hosted inference; role assignment absent.
- Role-assigned artifacts: none.
- Official evidence: upstream Hub metadata and card. Conversion evidence is
  third-party unless the artifact and upstream publishers match.

## 2. Artifact evidence

### IFM/K2-Horizon-7B-GGUF

- [Artifact metadata](https://huggingface.co/api/models/IFM/K2-Horizon-7B-GGUF?blobs=true),
  observed 2026-11-06; artifact repository created 2026-09-03.
- Artifact revision: `7a75dbda05e3d440351543131ff3f7fa5687e879`.
  [Pinned files](https://huggingface.co/IFM/K2-Horizon-7B-GGUF/tree/7a75dbda05e3d440351543131ff3f7fa5687e879).
- Listed files match the observed artifact revision.
- Weight files:
  - `K2-Horizon-7B-BF16.gguf`: 18010413440 bytes.
  - `K2-Horizon-7B-Q4_K_M.gguf`: 5592217984 bytes.
  - `K2-Horizon-7B-Q5_0.gguf`: 6335723904 bytes.
  - `K2-Horizon-7B-Q5_K_M.gguf`: 6466075008 bytes.
  - `K2-Horizon-7B-Q6_K.gguf`: 7394548096 bytes.
  - `K2-Horizon-7B-Q8_0.gguf`: 9573964160 bytes.
- Listed weight total: 53372942592 bytes
  (49.71 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: artifact declares this upstream as its base;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

### mlx-community/K2-Horizon-7B-4bit

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/K2-Horizon-7B-4bit?blobs=true),
  observed 2026-11-06; artifact repository created 2026-09-29.
- Artifact revision: `c8698376a102bc5e7ad49089b21b62c096a2506c`.
  [Pinned files](https://huggingface.co/mlx-community/K2-Horizon-7B-4bit/tree/c8698376a102bc5e7ad49089b21b62c096a2506c).
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00002.safetensors`: 5366857275 bytes.
  - `model-00002-of-00002.safetensors`: 1816975229 bytes.
- Listed weight total: 7183832504 bytes
  (6.69 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: artifact declares this upstream as its base;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

### mlx-community/K2-Horizon-7B-oQ6e

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/K2-Horizon-7B-oQ6e?blobs=true),
  observed 2026-11-06; artifact repository created 2026-09-04.
- Artifact revision: `2cca82ec88e24bd5fc264e4bcd29922182c8f62f`.
  [Pinned files](https://huggingface.co/mlx-community/K2-Horizon-7B-oQ6e/tree/2cca82ec88e24bd5fc264e4bcd29922182c8f62f).
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00002.safetensors`: 5029044275 bytes.
  - `model-00002-of-00002.safetensors`: 2507633767 bytes.
- Listed weight total: 7536678042 bytes
  (7.02 GiB); tokenizer, configuration,
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
