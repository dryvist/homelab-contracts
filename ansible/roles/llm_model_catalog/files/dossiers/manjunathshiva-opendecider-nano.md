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

[Shared evidence](_shared/runtime-and-evaluation.md)

- Runtime: opendecider[serve].
- Hardware path: CPU reference server.
- Endpoint contract: /v1/systemone.

## 4. Evaluation and comparison

[Shared evidence](_shared/runtime-and-evaluation.md)

```text
- Benchmark: typed-decisions accuracy; score: 0.796; date: 2026-10-10; source: https://huggingface.co/manjunathshiva/opendecider-nano/blob/9a8174b70ed8b088ccaacea13c01e32ae4d631b1/README.md
```

- [Card publication history](https://huggingface.co/manjunathshiva/opendecider-nano/commits/main/README.md).

- Classification/extraction: see the [shared task evidence](_shared/runtime-and-evaluation.md#classification-and-extraction).

## 5. Trial status

[Shared evidence](_shared/runtime-and-evaluation.md)
