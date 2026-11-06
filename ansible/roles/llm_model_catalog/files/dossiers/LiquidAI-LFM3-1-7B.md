---
type: Model Dossier
title: "LiquidAI/LFM3-1.7B"
description: "Dated evidence for small classification, extraction, and tool-use comparisons."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Official card](https://huggingface.co/LiquidAI/LFM3-1.7B).
- Release: [2026-10-27](https://www.liquid.ai/blog/lfm3).
  Repository creation date: UNVERIFIED; conversion dates do not renew age.
- Immutable upstream revision:
  [0dc4268b561499c648c7ba7c9466bf3d8d01517a](https://huggingface.co/LiquidAI/LFM3-1.7B/commit/0dc4268b561499c648c7ba7c9466bf3d8d01517a).
- Architecture: tri-hybrid, 1.73B parameters; convolution, sliding-window
  attention, and global attention. Advertised context: 262,144 total tokens.
- License: LFM Open License v1.0, according to the official card.
  Full restriction review: UNVERIFIED; Apache-2.0 eligibility is not asserted.
- Intended comparison: small classification and structured extraction;
  tool-use results are supporting evidence, not classification accuracy.
- Evidence is publisher-reported. No independent evaluation or local run.

## 2. Artifact evidence

- BF16 checkpoint: upstream repository and revision above;
  [file listing](https://huggingface.co/LiquidAI/LFM3-1.7B/tree/main)
  lists `model.safetensors`, rounded to 3.46 GB. Exact bytes: UNVERIFIED.
- Official conversion candidates:
  [GGUF](https://huggingface.co/LiquidAI/LFM3-1.7B-GGUF) and
  [MLX 4-bit](https://huggingface.co/LiquidAI/LFM3-1.7B-MLX-4bit).
- Selected GGUF filename, conversion revisions/dates, source revisions,
  quantization recipe, calibration provenance, and exact bytes: UNVERIFIED.
- Unchanged conversion versus pruning, merging, distillation, or safety
  modification: UNVERIFIED for each conversion. BF16 scores are not
  transferred to converted weights.
- Weight download date: UNVERIFIED; no weights downloaded.

## 3. Runtime and memory

- Candidate paths: llama.cpp for GGUF, MLX for the MLX conversion,
  and vLLM for BF16. Tagged llama.cpp and vLLM revisions: UNVERIFIED.
- The MLX artifact card requires MLX-VLM 0.7.11 or later.
  An exact qualified runtime revision remains UNVERIFIED.
- Hardware/kernel qualification for the chosen artifact, tokenizer/chat
  template compatibility, reasoning parser, tool parser, endpoint behavior,
  and unsupported-feature inventory: UNVERIFIED.
- Analytical BF16 weight floor: approximately 3.46 billion bytes / 2^30,
  or 3.22 GiB, using the rounded file listing. This is not a runtime peak.
- Full budget: weights, cache/recurrent state, graph/compiler workspace,
  drafter, and co-resident models. Text-only input adds no vision workspace.
  Exact allocations and a comparable measured peak: UNVERIFIED.
- Intended input/output lengths and concurrency: UNVERIFIED; choose these
  before calculating capacity or authorizing a trial.

## 4. Evaluation and comparison

- Official card observed 2026-11-06: BF16 BFCL v4 71.39,
  ToolSandbox 80.36, RULER at 128K 65.56, and AA-LCR 52.83.
  Individual result publication/evaluation dates: UNVERIFIED.
- BFCL uses greedy decoding and up to 32,768 output tokens;
  ToolSandbox uses greedy decoding and up to 1,024 tokens per turn.
- Task-matched classification accuracy, class balance, languages,
  calibration, abstention, false positives/negatives, structured-output
  validity, and latency: UNVERIFIED.
- Dated Arena category, LiveBench or versioned Artificial Analysis result,
  instruction-following result, and matched incumbent comparison: UNVERIFIED.
- Expected result: UNVERIFIED for the proposed classification/extraction
  workload. Published tool-use scores do not predict its accuracy.
- Proposed comparison criterion: retain incumbent task accuracy and valid
  output rate while reducing latency under identical inputs and concurrency.
  Numeric thresholds, incumbent revision, dataset, and quant-fidelity bounds:
  UNVERIFIED; declare them before a trial.

## 5. Trial status

- Evidence recorded; no new policy `models[]` entry and no trial authorized.
- Completion gaps: license restrictions, conversion provenance/bytes,
  tagged runtime/parser support, full memory budget, dated task-matched
  evaluations, incumbent baseline, and numeric acceptance thresholds.
- A dated release alone does not establish expected local trial results.
