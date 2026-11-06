---
type: Model Dossier
title: "manjunathshiva/opendecider-nano"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Hub metadata](https://huggingface.co/api/models/manjunathshiva/opendecider-nano).
- Upstream repository created: 2026-09-27 (Hub `createdAt`).
  Release date: UNVERIFIED. Conversion dates do not renew upstream age.
- Observed immutable upstream revision: `1e1f0a7322e446c5ae9bbe840df11680f18a752a`.
  [Pinned upstream card](https://huggingface.co/manjunathshiva/opendecider-nano/blob/1e1f0a7322e446c5ae9bbe840df11680f18a752a/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/manjunathshiva/opendecider-nano/tree/1e1f0a7322e446c5ae9bbe840df11680f18a752a).
  Additional restrictions: UNVERIFIED.
- Architecture: ModernBertModel.
- Intended task: System One classification and typed decisions.
- Role-assigned artifacts: `manjunathshiva/opendecider-nano`.
- Official evidence: upstream Hub metadata and card. Conversion evidence is
  third-party unless the artifact and upstream publishers match.

## 2. Artifact evidence

### manjunathshiva/opendecider-nano

- [Artifact metadata](https://huggingface.co/api/models/manjunathshiva/opendecider-nano?blobs=true),
  observed 2026-11-06; artifact repository created 2026-09-27.
- Artifact revision: `10c4b349f63d28186a46eacb6478cfce29c488e8`.
  [Pinned files](https://huggingface.co/manjunathshiva/opendecider-nano/tree/10c4b349f63d28186a46eacb6478cfce29c488e8).
- Listed file sizes describe the current Hub revision; pinned sizes: UNVERIFIED.
- Weight files:
  - `head.safetensors`: 2105802 bytes.
  - `model.safetensors`: 789580328 bytes.
- Listed weight total: 791686130 bytes
  (0.74 GiB); tokenizer, configuration,
  cache, and runtime allocations are additional.
- Conversion date, source revision, recipe, and calibration provenance:
  UNVERIFIED.
- Weight download date: UNVERIFIED (metadata only; no weights downloaded).
- Transformation: source checkpoint;
  unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED.

## 3. Runtime and memory

- Runtime: opendecider[serve].
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

```text
- Benchmark: typed-decisions accuracy; score: 0.796; date: 2026-10-10; source: https://huggingface.co/manjunathshiva/opendecider-nano/blob/9a8174b70ed8b088ccaacea13c01e32ae4d631b1/README.md
```

- Publication date: the cited card revision in [publisher history](https://huggingface.co/manjunathshiva/opendecider-nano/commits/main/README.md).
  Observed 2026-11-06; evaluation run date remains UNVERIFIED.

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
