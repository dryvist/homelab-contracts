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
- Upstream creation or release date: 2026-09-27T07:36:16.000Z (`createdAt`),
  [Hub API](https://huggingface.co/api/models/manjunathshiva/opendecider-nano),
  observed 2026-11-06.
- Observed immutable upstream revision: `1e1f0a7322e446c5ae9bbe840df11680f18a752a`.
  [Pinned upstream card](https://huggingface.co/manjunathshiva/opendecider-nano/blob/1e1f0a7322e446c5ae9bbe840df11680f18a752a/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/manjunathshiva/opendecider-nano/tree/1e1f0a7322e446c5ae9bbe840df11680f18a752a).
  Additional restrictions: UNVERIFIED.
- Architecture: ModernBertModel.
- Intended task: System One classification and typed decisions.
- Role-assigned artifacts: `manjunathshiva/opendecider-nano`.

## 4. Evaluation and comparison

- Benchmark: typed-decisions official test split accuracy, OpenDecider-nano;
  score: 0.796; date: 2026-09-27;
  source: <https://huggingface.co/blog/manjunathshiva/opendecider-beats-laya-and-jev>
- Decision result basis: publisher article dated 2026-09-27, observed
  2026-11-07; 2,000 decisions, trained only on the training split.

## 2. Artifact evidence

[Shared evidence](_shared/runtime-and-evaluation.md)

### manjunathshiva/opendecider-nano

- [Pinned artifact API](https://huggingface.co/api/models/manjunathshiva/opendecider-nano/revision/10c4b349f63d28186a46eacb6478cfce29c488e8?blobs=true),
  observed 2026-11-06; artifact repository created 2026-09-27.
- Artifact repository: `manjunathshiva/opendecider-nano`.
- Artifact publisher: `manjunathshiva` (`author`).
- Immutable artifact revision: `10c4b349f63d28186a46eacb6478cfce29c488e8` (`sha`).
  [Pinned files](https://huggingface.co/manjunathshiva/opendecider-nano/tree/10c4b349f63d28186a46eacb6478cfce29c488e8).
- Artifact created date: 2026-09-27T07:36:16.000Z (`createdAt`).
- Evidence observed date: 2026-11-06,
  [Hub API at the catalog pin](https://huggingface.co/api/models/manjunathshiva/opendecider-nano/revision/10c4b349f63d28186a46eacb6478cfce29c488e8?blobs=true).
- Quantization recipe: none; native bf16 encoder and decision head,
  [pinned config](https://huggingface.co/manjunathshiva/opendecider-nano/blob/10c4b349f63d28186a46eacb6478cfce29c488e8/config.json),
  observed 2026-11-06.
- Calibration provenance: not applicable to weight quantization; this is the
  original bf16 checkpoint. Teacher probability calibration is a training
  detail, described in the
  [publisher card](https://huggingface.co/manjunathshiva/opendecider-nano/blob/10c4b349f63d28186a46eacb6478cfce29c488e8/README.md),
  observed 2026-11-06.
- Upstream source revision: native checkpoint, no converter; artifact API
  `base_model` identifies `jhu-clsp/ettin-encoder-400m` as the training backbone.
- Weight files:
  - `head.safetensors`: 2105802 bytes.
  - `model.safetensors`: 789580328 bytes.
- Listed weight total: 791686130 bytes
  (0.74 GiB).
- Artifact type: source checkpoint.

## 3. Runtime and memory

[Shared evidence](_shared/runtime-and-evaluation.md)

- Runtime: opendecider[serve].
- CPU serving: [shared qualification evidence](_shared/runtime-and-evaluation.md#cpu-decision-models).
