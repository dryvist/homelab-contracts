---
type: Model Dossier
title: "ggml-org/GLM-OCR-GGUF"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-13T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Evidence observed date: 2026-11-13 for the sources below.
- Upstream repository and immutable revision: `zai-org/GLM-OCR`,
  `2e85a62840ccac27daa451df36c736c4636b8628` (`sha`),
  [Hub metadata](https://huggingface.co/api/models/zai-org/GLM-OCR), observed 2026-11-13.
- Upstream creation or release date: 2026-01-30T04:24:21.000Z (`createdAt`),
  [Hub metadata](https://huggingface.co/api/models/zai-org/GLM-OCR), observed 2026-11-13.
  Conversion dates do not renew upstream age.
- Release date: UNVERIFIED independently of repository creation; the Hub
  metadata exposes `createdAt` and `lastModified`.
  [Hub metadata](https://huggingface.co/api/models/zai-org/GLM-OCR),
  observed 2026-11-13.
- License and restrictions: upstream metadata and card declare MIT. The GGUF
  repository metadata has no license field; artifact-specific terms and
  additional restrictions are UNVERIFIED.
  [Upstream model card](https://huggingface.co/zai-org/GLM-OCR/blob/2e85a62840ccac27daa451df36c736c4636b8628/README.md);
  [GGUF metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true),
  observed 2026-11-13.
- Architecture: the GGUF page labels the architecture `glm4`; upstream metadata
  reports `GlmOcrForConditionalGeneration` and `model_type: glm_ocr`.
  [GGUF model page](https://huggingface.co/ggml-org/GLM-OCR-GGUF);
  [upstream metadata](https://huggingface.co/api/models/zai-org/GLM-OCR),
  observed 2026-11-13.
- Parameter count: the GGUF page and upstream card state 0.9B parameters. The
  upstream metadata API reports 1,325,258,240 parameters for its safetensors
  weights; the upstream card describes a GLM-0.5B language decoder.
  [GGUF model page](https://huggingface.co/ggml-org/GLM-OCR-GGUF);
  [upstream model card](https://huggingface.co/zai-org/GLM-OCR/blob/2e85a62840ccac27daa451df36c736c4636b8628/README.md);
  [upstream metadata](https://huggingface.co/api/models/zai-org/GLM-OCR),
  observed 2026-11-13.
- Intended task: image-text model for dense-layout image text.
  [Upstream model card](https://huggingface.co/zai-org/GLM-OCR/blob/2e85a62840ccac27daa451df36c736c4636b8628/README.md).
- Official versus third-party evidence: `zai-org/GLM-OCR` is the upstream
  repository; the GGUF page says `ggml-org` converted it to GGUF using
  `convert_hf_to_gguf.py`.
  [Upstream model page](https://huggingface.co/zai-org/GLM-OCR);
  [GGUF model page](https://huggingface.co/ggml-org/GLM-OCR-GGUF), observed 2026-11-13.
- Lane rationale: UNVERIFIED.

## 2. Artifact evidence

### ggml-org/GLM-OCR-GGUF

- Artifact repository: `ggml-org/GLM-OCR-GGUF`.
  [Hub metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true).
- Artifact publisher: `ggml-org` (`author` in Hub metadata).
  [Hub metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true).
- Immutable artifact revision: `65a42de1148dbed2297e922b5dbc7d9b70c36578` (`sha`).
  [Pinned files](https://huggingface.co/ggml-org/GLM-OCR-GGUF/tree/65a42de1148dbed2297e922b5dbc7d9b70c36578).
- Artifact created date: 2026-02-17T00:04:10.000Z (`createdAt`),
  [Hub metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true),
  observed 2026-11-13.
- Evidence observed date: 2026-11-13,
  [Hub metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true).
- Filename/shards and bytes, from the observed artifact revision:
  - `GLM-OCR-Q8_0.gguf`: 950433408 bytes.
  - `mmproj-GLM-OCR-Q8_0.gguf`: 484403648 bytes.
  [Hub metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true).
- Upstream source revision: not published by the converter; Hub `base_model`
  names `zai-org/GLM-OCR`.
  [GGUF metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true),
  observed 2026-11-13.
- Quantization recipe: Q8_0, as named by the listed artifact files and the
  GGUF page's Q8_0 entry. Exact quantization command and arguments are not
  reported.
  [GGUF model page](https://huggingface.co/ggml-org/GLM-OCR-GGUF);
  [Hub metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true),
  observed 2026-11-13.
- Calibration provenance: not reported in the GGUF model page or its listed
  metadata files, observed 2026-11-13.
  [GGUF model page](https://huggingface.co/ggml-org/GLM-OCR-GGUF);
  [Hub metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true).
- Transformation: the GGUF page reports conversion from `zai-org/GLM-OCR`
  with `convert_hf_to_gguf.py`; other transformations are UNVERIFIED.
  [GGUF model page](https://huggingface.co/ggml-org/GLM-OCR-GGUF),
  observed 2026-11-13.

## 3. Runtime and memory

- Tagged runtime/container revision: GLM-OCR support was merged into
  llama.cpp on 2026-02-18; a tagged runtime/container revision is UNVERIFIED.
  [Upstream support PR #19677](https://github.com/ggml-org/llama.cpp/pull/19677).
- Supported architecture and hardware path: llama.cpp merged GLM-OCR engine
  support; the support change describes a GLM4-family text model with one MTP
  layer and Q/K normalization in the image path. Hardware-specific validation
  is UNVERIFIED.
  [Upstream support PR #19677](https://github.com/ggml-org/llama.cpp/pull/19677);
  [llama.cpp GLM conversion source](https://github.com/ggml-org/llama.cpp/blob/master/conversion/glm.py).
- Precision kernels: UNVERIFIED.
- Tokenizer/chat template: the upstream metadata includes a chat template and
  the model card uses `AutoTokenizer.apply_chat_template`; llama.cpp template
  validation for this artifact is UNVERIFIED.
  [Upstream metadata](https://huggingface.co/api/models/zai-org/GLM-OCR);
  [upstream model card](https://huggingface.co/zai-org/GLM-OCR/blob/2e85a62840ccac27daa451df36c736c4636b8628/README.md).
- Reasoning and tool parsers: UNVERIFIED.
- Endpoint behavior and unsupported features: the GGUF page documents
  `llama serve -hf ggml-org/GLM-OCR-GGUF` and
  `llama cli -hf ggml-org/GLM-OCR-GGUF`; llama.cpp multimodal documentation identifies
  `llama-cli` and `llama-server` input support. Artifact-specific endpoint
  validation and unsupported features are UNVERIFIED.
  [GGUF model page](https://huggingface.co/ggml-org/GLM-OCR-GGUF);
  [llama.cpp multimodal documentation](https://github.com/ggml-org/llama.cpp/blob/master/docs/multimodal.md).
- Weights, cache/state, vision, graph/compiler, drafter, and co-resident bytes:
  the two listed GGUF files total 1434837056 bytes; all runtime allocations
  beyond those files are UNVERIFIED.
  [Hub metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true).
- Input/output length and concurrency: UNVERIFIED.
- Analytical estimate and assumptions: 1434837056 listed bytes provide a
  storage baseline only; total runtime memory and assumptions are UNVERIFIED.
  [Hub metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true).
- Comparable published peak: UNVERIFIED.

## 4. Evaluation and comparison

- Benchmark: OmniDocBench V1.5, upstream; score: 94.62; date: 2026-11-13;
  source: <https://huggingface.co/zai-org/GLM-OCR/blob/2e85a62840ccac27daa451df36c736c4636b8628/README.md>
- Benchmark date basis: source observation on 2026-11-13; the upstream card
  does not state an evaluation date. This is the upstream result, not a measured
  result for the selected GGUF artifact.
- Applicable use cases: image-text model for dense-layout image text, as
  described by the upstream card.
  [Upstream model card](https://huggingface.co/zai-org/GLM-OCR/blob/2e85a62840ccac27daa451df36c736c4636b8628/README.md).
- Dated task-matched benchmarks and versions: the upstream card reports
  OmniDocBench V1.5 above; artifact-specific results are UNVERIFIED.
- Settings, scaffold, and reasoning budget: UNVERIFIED.
- Quant fidelity: UNVERIFIED.
- Candidate/incumbent comparison: UNVERIFIED.
- Expected results: UNVERIFIED.

## 5. Trial status

- Dated promotion decision: 2026-11-13. The policy record uses the upstream
  base repository's 2026-01-30 `createdAt` (287 days old on this date), within
  `max_age_days: 365`. The GGUF artifact repository was created 2026-02-17
  (269 days old); the three-month preference is not met, while both dates
  remain within the policy's 365-day maximum.
  [Policy](https://github.com/jpe-ansible/homelab-contracts/blob/main/ansible/roles/llm_model_catalog/files/model-policy.json);
  [upstream metadata](https://huggingface.co/api/models/zai-org/GLM-OCR);
  [artifact metadata](https://huggingface.co/api/models/ggml-org/GLM-OCR-GGUF?blobs=true).
- Predeclared acceptance criteria: UNVERIFIED.
- Unresolved fields: independent release date; artifact-specific license terms;
  calibration provenance; converter source revision; tagged runtime and hardware
  validation; runtime allocations; artifact-specific evaluation, quantization
  fidelity, and matched comparison remain UNVERIFIED.
