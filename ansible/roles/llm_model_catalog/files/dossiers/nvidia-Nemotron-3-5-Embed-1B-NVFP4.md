---
type: Model Dossier
title: "Nemotron 3.5 Embed 1B NVFP4"
description: "Dated retrieval evidence and trial completion fields."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Official card](https://huggingface.co/nvidia/Nemotron-3.5-Embed-1B-NVFP4).
- Release: 2026-10-20, stated by the card. Repository creation: UNVERIFIED.
- Upstream: `nvidia/Nemotron-3.5-Embed-1B-BF16`;
  immutable upstream revision: UNVERIFIED.
- Architecture: distilled multimodal Transformer, 1.55B parameters.
  License: OpenMDW-1.1; full restrictions/component-notice review: UNVERIFIED.
- Intended comparison: compact text/image retrieval embeddings.
  Evidence is publisher-reported; no independent evaluation or local run.

## 2. Artifact evidence

- Official artifact: `nvidia/Nemotron-3.5-Embed-1B-NVFP4`.
- Immutable artifact revision:
  [74be9a95780080480b909a4ee4a1d3a70a63d09f](https://huggingface.co/nvidia/Nemotron-3.5-Embed-1B-NVFP4/commit/74be9a95780080480b909a4ee4a1d3a70a63d09f).
- [Files](https://huggingface.co/nvidia/Nemotron-3.5-Embed-1B-NVFP4/tree/main):
  `model.safetensors`, rounded to 1.27 GB; exact bytes: UNVERIFIED.
- NVFP4 quantization of the BF16 model. Conversion date, source revision,
  quantization recipe, calibration provenance, and additional pruning,
  merging, distillation, or safety modifications: UNVERIFIED.
- Weight download date: UNVERIFIED; no weights downloaded.

## 3. Runtime and memory

- Publisher-tested: vLLM 0.32.0 with Transformers 5.19.0;
  `vllm/vllm-openai:v0.32.0`. NVFP4 requires compatible hardware,
  such as NVIDIA Blackwell. BF16 library support does not qualify NVFP4.
- Mean pooling, L2 normalization, 2,048 dimensions; truncated vectors
  require re-normalization. Exact chosen dimension/truncation: UNVERIFIED.
- Target precision kernels, template/tokenizer compatibility, endpoint
  contract, unsupported-feature inventory, and runtime digest: UNVERIFIED.
  Reasoning/tool parsers are not applicable to embedding-vector output.
- Analytical weight floor: approximately 1.27 billion bytes / 2^30 =
  1.18 GiB, using rounded file size. Full budget adds sequence activations,
  vision workspace, graph/compiler workspace, and co-resident models.
  Decoder cache/recurrent state and drafter are not assumed for this
  pooling workload. Exact allocations and comparable peak: UNVERIFIED.
- Intended text length, image resolution, batch/concurrency, indexing/query
  throughput, and full peak memory: UNVERIFIED.

## 4. Evaluation and comparison

- Official card observed 2026-11-06: ViDoRe V3 nDCG@10,
  NVFP4 image/text/combined: 57.82 / 57.53 / 58.71;
  BF16: 58.02 / 57.80 / 58.82. Image longest edge: 1,120 pixels.
  Evaluation/publication day: UNVERIFIED.
- These are card-specific V3 results, not the V3.1 BF16 result in the
  [2026-10-21 family announcement](https://huggingface.co/blog/nvidia/nemotron-retriever-world-class-agentic-retrieval).
- Task-matched MTEB language/domain/code retrieval, matched incumbent,
  quantization tolerance, and measured indexing/query latency: UNVERIFIED.
- Expected local retrieval quality: UNVERIFIED. Proposed comparison:
  preserve incumbent nDCG@10 at the selected dimension and truncation,
  within predeclared latency/memory bounds. Dataset, baseline revision,
  numeric thresholds, and uncertainty calculation: UNVERIFIED.
- Index compatibility and re-embedding plan: UNVERIFIED. Define collection
  rebuild, held-out retrieval comparison, and rollback before replacement.

## 5. Trial status

- Evidence recorded; no new policy `models[]` entry and no trial authorized.
- Completion gaps: upstream/source revision, conversion provenance/bytes,
  license review, target runtime, full memory budget, dated matched retrieval
  evaluations, re-embedding plan, and numeric acceptance thresholds.
