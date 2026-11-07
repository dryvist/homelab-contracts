---
type: Model Dossier
title: "Nemotron 3.5 Lightning 30B-A3B NVFP4"
description: "Dated artifact and evaluation evidence for efficient agent comparisons."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

[Shared provenance](_shared/candidate-provenance.md)

## 1. Upstream evidence

- Observed: 2026-11-06. [Official NVFP4 card](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-NVFP4).
- Release: 2026-08-11, stated by the card. Repository creation: UNVERIFIED.
- Upstream: `nvidia/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-BF16`.
  Immutable BF16 revision: UNVERIFIED.
- Architecture: Nemotron-H hybrid mixture of experts; text generation.
  License: OpenMDW-1.1.
- Intended comparison: agent efficiency and long-context tasks.

## 2. Artifact evidence

- Repository: `nvidia/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-NVFP4`.
- Immutable artifact revision: `bee7596271d1495f6992ae224aefde4410e816b8`.
  [Revision evidence](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-NVFP4/commit/bee7596271d1495f6992ae224aefde4410e816b8).
- [File listing](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-NVFP4/tree/main)
  reports 21.6 GB for the repository and shard names such as
  `model-00001-of-00052.safetensors`. Complete manifest and exact
  weight-only bytes: UNVERIFIED.
- Official NVFP4 artifact. Conversion date, source revision, quantization
  recipe, calibration provenance, and unchanged conversion versus pruning,
  merging, distillation, or safety modification: UNVERIFIED.

## 3. Runtime and memory

- Official card documents `vllm/vllm-openai:v0.27.1`, Marlin,
  FP8 key/value cache, FlashInfer Mamba backend, and `nemotron_v3`
  reasoning parsing. The cited quick start uses a separate speculative model.
- Exact target hardware/kernel qualification, template/tool parsing,
  endpoint behavior, unsupported features, and runtime digest: UNVERIFIED.
- Analytical storage proxy: 21.6 billion bytes / 2^30 = approximately
  20.12 GiB; rounded repository bytes are not measured inference memory.
- Full budget includes selected weights, key/value cache, recurrent state,
  graph/compiler workspace, drafter, and co-resident models. Text-only
  serving adds no vision workspace. Allocations and comparable peak:
  UNVERIFIED.
- Intended input/output lengths and concurrency: UNVERIFIED.

## 4. Evaluation and comparison

- Official card, observed 2026-11-06: NVFP4 GPQA Diamond 75.57,
  SWE-bench Verified 52.80, Terminal-Bench 2.1 23.46,
  IFBench loose 72.88, and AA-LCR 49.19.
- Paired BF16 AA-LCR: 52.00; Terminal-Bench 2.1: 24.58.
  Publisher identifies NeMo Gym/NeMo Evaluator harnesses.
  Individual evaluation dates, pinned recipes, and reasoning budgets:
  UNVERIFIED; release-associated results do not date every benchmark run.
- Dated Arena category, LiveBench or versioned Artificial Analysis result,
  RULER by operating length, BFCL, and tau-bench coverage: UNVERIFIED.
- Expected local result, matched incumbent task completion, quantization
  tolerance, latency, and throughput: UNVERIFIED.
- Proposed comparison criterion: preserve incumbent task completion at
  lower latency or memory under matched inputs, reasoning budget, and
  concurrency. Numeric thresholds and baseline revision/dataset:
  UNVERIFIED; establish before a trial.

## 5. Trial status

- Evidence recorded; no new policy `models[]` entry and no trial authorized.
- Completion gaps: upstream revision, conversion provenance, exact bytes,
  license review, target runtime/parser support, full memory budget,
  dated task-matched evaluations, baseline, and acceptance thresholds.
