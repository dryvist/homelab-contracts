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

[Shared evidence](_shared/runtime-and-evaluation.md)

## 4. Evaluation and comparison

[Shared evidence](_shared/runtime-and-evaluation.md)

- Classification/extraction: see the [shared task evidence](_shared/runtime-and-evaluation.md#classification-and-extraction).

## 5. Trial status

[Shared evidence](_shared/runtime-and-evaluation.md)
