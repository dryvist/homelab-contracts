---
type: Model Dossier
title: "Nemotron 3.5 Super-VL 120B-A12B NVFP4"
description: "Dated artifact and evaluation evidence for agent and document comparisons."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Official NVFP4 card](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Super-VL-120B-A12B-NVFP4).
- Release: 2026-10-15, stated by the card. Repository creation: UNVERIFIED.
- Upstream: `nvidia/NVIDIA-Nemotron-3.5-Super-VL-120B-A12B-BF16`.
  Immutable BF16 revision: UNVERIFIED; artifact revision is recorded below.
- Architecture: Nemotron-H hybrid vision-language mixture of experts.
  Exact architecture/configuration qualification: UNVERIFIED.
- License: OpenMDW-1.1. Full restriction and component-notice review:
  UNVERIFIED.
- Intended comparison: agent tasks, document understanding, and long context.
  Evidence is publisher-reported, not a local qualification.

## 2. Artifact evidence

- Repository: `nvidia/NVIDIA-Nemotron-3.5-Super-VL-120B-A12B-NVFP4`.
- Immutable artifact revision:
  [da5b2650a835292c678994a1fa3fb653250fb508](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Super-VL-120B-A12B-NVFP4/commit/da5b2650a835292c678994a1fa3fb653250fb508).
- [File listing](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Super-VL-120B-A12B-NVFP4/tree/main)
  reports 75.1 GB for the repository and shard names such as
  `model-00001-of-00088.safetensors`. Complete shard manifest and exact
  weight-only bytes: UNVERIFIED; the repository total includes other files.
- Official NVFP4 artifact. Conversion date, source revision, recipe,
  calibration provenance, and unchanged conversion versus distillation or
  other weight modification: UNVERIFIED. Precision is not assumed uniform.
- Weight download date: UNVERIFIED; no weights downloaded.

## 3. Runtime and memory

- The official card documents `vllm/vllm-openai:v0.32.0` and an NVIDIA
  RTX PRO 6000 recipe. Exact tested hardware/kernel combination: UNVERIFIED.
- Tokenizer/chat template, reasoning parser, tool parser, endpoint behavior,
  unsupported features, and locally qualified runtime digest: UNVERIFIED.
- Analytical storage proxy: 75.1 billion bytes / 2^30 = approximately
  69.94 GiB. It is a rounded repository total, not a weight-only runtime floor.
- Full budget includes selected weights, key/value cache, recurrent state,
  vision workspace, graph/compiler workspace, drafter, and co-resident models.
  Those allocations and comparable measured peak: UNVERIFIED.
- Intended input/output lengths and concurrency: UNVERIFIED.
  An advertised context maximum does not establish capacity.

## 4. Evaluation and comparison

- Official card, observed 2026-11-06: NVFP4 GPQA Diamond 89.90,
  SWE-bench Verified 71.07, Terminal-Bench 2.1 62.78, AA-LCR v1.1 67.69,
  IFBench 71.50, and tau2-bench retail 69.30.
- Paired BF16 values include AA-LCR v1.1 68.62 and IFBench 70.86.
  The publisher states that non-model evaluation settings are held fixed.
  Individual evaluation/publication dates and pinned harness recipes:
  UNVERIFIED; these are release-associated card results.
- Dated Arena category, LiveBench or versioned Artificial Analysis result,
  RULER by operating length, and BFCL coverage: UNVERIFIED.
- Matched incumbent, reasoning/output budgets, local latency/throughput,
  and task-specific quantization tolerance: UNVERIFIED.
- Expected local result: UNVERIFIED. Proposed comparison criterion: preserve
  incumbent task completion and document accuracy at the declared length,
  within predeclared latency and memory limits. Numeric thresholds and
  baseline dataset/revision: UNVERIFIED; establish before a trial.

## 5. Trial status

- Evidence recorded; no new policy `models[]` entry and no trial authorized.
- Completion gaps: BF16 revision, conversion provenance, exact artifact
  bytes, license review, runtime/parser qualification, memory budget,
  dated independent/task-matched scores, and numeric acceptance thresholds.
