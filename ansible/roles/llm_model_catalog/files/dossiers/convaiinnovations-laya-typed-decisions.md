---
type: Model Dossier
title: "convaiinnovations/laya-typed-decisions"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/convaiinnovations/laya-typed-decisions).
- Upstream repository created: 2026-09-18 (Hub `createdAt`).
  Release date: UNVERIFIED. Conversion dates do not renew upstream age.
- Observed immutable upstream revision: `e929ae5cf69bc34259cd2f95c9e91145b818b1f0`.
  [Pinned upstream card](https://huggingface.co/convaiinnovations/laya-typed-decisions/blob/e929ae5cf69bc34259cd2f95c9e91145b818b1f0/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/convaiinnovations/laya-typed-decisions/tree/e929ae5cf69bc34259cd2f95c9e91145b818b1f0).
  Additional restrictions: UNVERIFIED.
- Architecture: LayaTypedDecisions.
- Intended task: System One classification and typed decisions.
- Role-assigned artifacts: `convaiinnovations/laya-typed-decisions`.
- Official evidence: upstream Hub metadata and card. Conversion evidence is
  third-party unless the artifact and upstream publishers match.

## 2. Artifact evidence

### convaiinnovations/laya-typed-decisions

- [Artifact metadata](https://huggingface.co/api/models/convaiinnovations/laya-typed-decisions?blobs=true),
  observed 2026-11-06; artifact repository created 2026-09-18.
- Artifact revision: `e929ae5cf69bc34259cd2f95c9e91145b818b1f0`.
  [Pinned files](https://huggingface.co/convaiinnovations/laya-typed-decisions/tree/e929ae5cf69bc34259cd2f95c9e91145b818b1f0).
- Listed files match the observed artifact revision.
- Weight files:
  - `model.safetensors`: 842609220 bytes.
- Listed weight total: 842609220 bytes
  (0.78 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: source checkpoint;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

## 3. Runtime and memory

- Runtime: laya-serve.
- Tagged runtime/container revision: UNVERIFIED.
- Hardware path: CPU reference server.
- Endpoint contract: /v1/systemone.
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
