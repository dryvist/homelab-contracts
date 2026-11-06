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
- Upstream creation or release date: 2026-09-18T17:45:14.000Z (`createdAt`),
  [Hub API](https://huggingface.co/api/models/convaiinnovations/laya-typed-decisions),
  observed 2026-11-06.
- Observed immutable upstream revision: `e929ae5cf69bc34259cd2f95c9e91145b818b1f0`.
  [Pinned upstream card](https://huggingface.co/convaiinnovations/laya-typed-decisions/blob/e929ae5cf69bc34259cd2f95c9e91145b818b1f0/README.md).
- License: apache-2.0. [License evidence](https://huggingface.co/convaiinnovations/laya-typed-decisions/tree/e929ae5cf69bc34259cd2f95c9e91145b818b1f0).
  Additional restrictions: UNVERIFIED.
- Architecture: LayaTypedDecisions.
- Intended task: System One classification and typed decisions.
- Role-assigned artifacts: `convaiinnovations/laya-typed-decisions`.

## 2. Artifact evidence

[Shared evidence](_shared/runtime-and-evaluation.md)

### convaiinnovations/laya-typed-decisions

- [Artifact metadata](https://huggingface.co/api/models/convaiinnovations/laya-typed-decisions?blobs=true),
  observed 2026-11-06; artifact repository created 2026-09-18.
- Artifact revision: `e929ae5cf69bc34259cd2f95c9e91145b818b1f0`.
  [Pinned files](https://huggingface.co/convaiinnovations/laya-typed-decisions/tree/e929ae5cf69bc34259cd2f95c9e91145b818b1f0).
- Artifact repository: `convaiinnovations/laya-typed-decisions`.
- Artifact publisher: `convaiinnovations` (`author`).
- Immutable artifact revision: `e929ae5cf69bc34259cd2f95c9e91145b818b1f0` (`sha`).
- Artifact created date: 2026-09-18T17:45:14.000Z (`createdAt`).
- Evidence observed date: 2026-11-06,
  [Hub API](https://huggingface.co/api/models/convaiinnovations/laya-typed-decisions?blobs=true).
- Quantization recipe: none; original trained decision checkpoint with no
  quantization metadata in its
  [pinned configuration](https://huggingface.co/convaiinnovations/laya-typed-decisions/blob/e929ae5cf69bc34259cd2f95c9e91145b818b1f0/config.json),
  observed 2026-11-06.
- Calibration provenance: not applicable to weight quantization; this native
  checkpoint uses RLCD fine-tuning. Its probability-temperature calibration is
  separate training evidence in the
  [publisher model card](https://huggingface.co/convaiinnovations/laya-typed-decisions/blob/e929ae5cf69bc34259cd2f95c9e91145b818b1f0/README.md),
  observed 2026-11-06.
- Upstream source revision: no conversion; artifact metadata has no
  `base_model`, and the publisher card names `convaiinnovations/laya` as the
  fine-tuning parent without an immutable parent revision.
- Listed files match the observed artifact revision.
- Weight files:
  - `model.safetensors`: 842609220 bytes.
- Listed weight total: 842609220 bytes
  (0.78 GiB).
- Artifact type: source checkpoint.

## 3. Runtime and memory

[Shared evidence](_shared/runtime-and-evaluation.md)

- Runtime: laya-serve.
- CPU serving: [shared qualification evidence](_shared/runtime-and-evaluation.md#cpu-decision-models).
