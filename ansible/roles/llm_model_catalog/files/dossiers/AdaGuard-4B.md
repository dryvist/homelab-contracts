---
type: Model Dossier
title: "AdaGuard-4B"
description: "Dated candidate evidence and explicit trial completion fields."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Publisher checkpoint card](https://huggingface.co/Yunhao-Feng/AdaGuard-4B).
- [Paper](https://arxiv.org/abs/2609.34241): submitted 2026-09-28,
  revised 2026-10-21. Weight-release and repository-creation dates:
  UNVERIFIED; a paper revision does not date a checkpoint release.
- Exact checkpoint repository is linked above; immutable revision:
  UNVERIFIED. Base: Qwen3Guard-Gen-4B; architecture: Qwen3ForCausalLM.
- License: Apache-2.0 with upstream attribution retained.
  Full restrictions/component-notice review: UNVERIFIED.
- Intended comparison: policy-conditioned moderation of requests and agent
  trajectories. Evidence is publisher-reported; no independent/local run.

## 2. Artifact evidence

- Publisher checkpoint card reports FP32 storage and approximately
  17.65 GB of weights; exact manifest, filenames/shards, revision, and bytes:
  UNVERIFIED.
- Card reports retained original weight values and chat template.
  Independently verified lineage/source revision and transformation audit:
  UNVERIFIED. BF16 is a load-time precision, not the stored file format.
- Selected quantization, conversion date/recipe/calibration: none selected;
  any converted artifact requires its own evidence.
- Weight download date: UNVERIFIED; no weights downloaded.

## 3. Runtime and memory

- Card example: Transformers 5.2.0 with CUDA/BF16 and SDPA.
  Exact target serving/container revision, kernels, endpoint,
  tokenizer/template parity, and unsupported-feature inventory: UNVERIFIED.
- Output analysis and rule labels require schema/label validation.
  Invalid output must count as failure, not a safe verdict.
  Tool-call/reasoning-parser compatibility with a selected server:
  UNVERIFIED.
- Analytical BF16 floor: 4,411,424,256 stored parameters * 2 bytes / 2^30 =
  approximately 8.22 GiB, assuming all are loaded at BF16.
  FP32 storage does not prove BF16 peak memory.
- Full budget adds cache/state, graph/compiler workspace, any drafter,
  and co-resident models. Vision workspace is not assumed for this text
  classifier. Intended input/output length, concurrency, exact allocations,
  and comparable measured peak: UNVERIFIED.

## 4. Evaluation and comparison

- Card observed 2026-11-06: AdaptiveSafety accuracy 89.30,
  violation recall 82.60, precision 95.38; DynaBench accuracy 71.82.
  Individual evaluation/publication day: UNVERIFIED.
- Publisher describes BF16 greedy decoding with 16,000 prompt tokens
  and 512 new tokens; these are single-run results, not calibrated risks.
- Adversarial robustness, benign-request false positives under the intended
  policy, multilingual coverage, matched agent-trajectory benchmark,
  moderation latency, and incumbent baseline: UNVERIFIED.
- Expected local recall/false-positive rate: UNVERIFIED. Proposed criterion:
  retain incumbent unsafe-content recall without increasing benign-request
  rejection, while validating rule labels and moderation latency.
  Dataset/policy version, baseline revision, numeric thresholds,
  uncertainty, and calibration: UNVERIFIED; establish before a trial.

## 5. Trial status

- Excluded from new policy `models[]` entries: checkpoint date UNVERIFIED.
- Additional completion gaps: immutable revision, exact bytes/lineage,
  restrictions review, runtime/parser qualification, full memory budget,
  dated matched guard evaluation, and numeric acceptance thresholds.
