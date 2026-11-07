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
- Upstream creation or release date: 2026-06-19T09:40:33.000Z (`createdAt`),
  [Hub API](https://huggingface.co/api/models/baidu/Unlimited-OCR), observed 2026-11-06.
- Observed immutable upstream revision: `8249d20b2822a7d8a4c22c8d8c9069b5ac36bda3`.
  [Pinned upstream card](https://huggingface.co/baidu/Unlimited-OCR/blob/8249d20b2822a7d8a4c22c8d8c9069b5ac36bda3/README.md).
- License: mit. [License evidence](https://huggingface.co/baidu/Unlimited-OCR/tree/8249d20b2822a7d8a4c22c8d8c9069b5ac36bda3).
  Additional restrictions: UNVERIFIED.
- Architecture: UnlimitedOCRForCausalLM.
- Intended task: Optical character recognition and document parsing.
- Role-assigned artifacts: `mlx-community/Unlimited-OCR-bf16`.

## 2. Artifact evidence

[Shared evidence](_shared/runtime-and-evaluation.md)

### mlx-community/Unlimited-OCR-bf16

- [Artifact metadata](https://huggingface.co/api/models/mlx-community/Unlimited-OCR-bf16?blobs=true),
  observed 2026-11-06; artifact repository created 2026-07-31.
- Artifact revision: `6d9f675e3fa73dd49cd03f630868b1941c72803f`.
  [Pinned files](https://huggingface.co/mlx-community/Unlimited-OCR-bf16/tree/6d9f675e3fa73dd49cd03f630868b1941c72803f).
- Artifact repository: `mlx-community/Unlimited-OCR-bf16`.
- Artifact publisher: `mlx-community` (`author`).
- Immutable artifact revision: `6d9f675e3fa73dd49cd03f630868b1941c72803f` (`sha`).
- Artifact created date: 2026-07-31T18:02:20.000Z (`createdAt`).
- Evidence observed date: 2026-11-06,
  [Hub API](https://huggingface.co/api/models/mlx-community/Unlimited-OCR-bf16?blobs=true).
- Quantization recipe: none; unquantized bfloat16 conversion with `mlx-vlm`
  0.6.8 and MLX 0.32.0, reported in the
  [pinned conversion card](https://huggingface.co/mlx-community/Unlimited-OCR-bf16/blob/6d9f675e3fa73dd49cd03f630868b1941c72803f/README.md),
  observed 2026-11-06.
- Calibration provenance: not applicable to the unquantized bf16 conversion
  documented in the conversion card above (observed 2026-11-06).
- Upstream source revision: not published by converter; Hub `base_model`
  names `baidu/Unlimited-OCR`.
- Listed files match the observed artifact revision.
- Weight files:
  - `model-00001-of-00002.safetensors`: 5240462002 bytes.
  - `model-00002-of-00002.safetensors`: 1431828399 bytes.
- Listed weight total: 6672290401 bytes
  (6.21 GiB).

## 4. Evaluation and comparison

- Benchmark: OmniDocBench v1.6 overall, upstream; score: 93.92; date: 2026-06-22;
  source: <https://arxiv.org/html/2606.23050v1#S5.SS2>
- OCR result basis: section 5.2 of the publisher report, v1 dated 2026-06-22,
  observed 2026-11-07; this does not measure the MLX bf16 conversion.

[Shared evidence](_shared/runtime-and-evaluation.md)

- Documents: OCRBench and OmniDocBench/olmOCR, text error, tables,
  formulas, reading order, layout, languages, and long-document results:
  UNVERIFIED.
