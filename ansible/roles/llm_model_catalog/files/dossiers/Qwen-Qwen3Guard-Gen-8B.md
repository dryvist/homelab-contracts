---
type: Model Dossier
title: "Qwen/Qwen3Guard-Gen-8B"
description: "Dated candidate evidence and explicit trial completion fields."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

[Shared provenance](_shared/candidate-provenance.md)

## 1. Upstream evidence

- Observed: 2026-11-06. [Official card](https://huggingface.co/Qwen/Qwen3Guard-Gen-8B).
- Release: [2025-09-23](https://qwenlm.github.io/blog/qwen3guard/).
  This exceeds 12 months as of the observation date.
- Immutable upstream revision:
  [4505cb1a6f1864f21f8b27f7daf1b9a1aab6edbb](https://huggingface.co/Qwen/Qwen3Guard-Gen-8B/commit/4505cb1a6f1864f21f8b27f7daf1b9a1aab6edbb).
- Architecture: Qwen3-based generative guard, 8B class.
  License: Apache-2.0.
- Intended comparison: prompt/response moderation. The Gen checkpoint is
  distinct from the streaming guard family.

## 2. Artifact evidence

- Original BF16 checkpoint at the upstream revision above.
- [Files](https://huggingface.co/Qwen/Qwen3Guard-Gen-8B/tree/main):
  `model-00001-of-00005.safetensors` through
  `model-00005-of-00005.safetensors`, rounded to
  4.00 / 3.99 / 3.96 / 3.19 / 1.24 GB. Exact bytes: UNVERIFIED.
- Quantization conversion date/recipe/calibration: not applicable to this
  BF16 selection. Exact fine-tuning source revision and complete
  transformation audit: UNVERIFIED.

## 3. Runtime and memory

- Official card documents Transformers generation. Tagged runtime/container
  revision, target kernels, tokenizer/template parity, endpoint,
  structured-verdict parser, and unsupported features: UNVERIFIED.
- Generative guard output requires verdict/category validation; tool-call
  parsing is not the moderation contract. Parser failures must be counted.
- Analytical weight floor: rounded 16.38 billion bytes / 2^30 =
  approximately 15.26 GiB. Full budget adds key/value cache, any recurrent
  state, graph/compiler workspace, any drafter, and co-resident models.
  Vision workspace is not assumed for text moderation. Exact allocations,
  intended input/output length, concurrency, and comparable peak: UNVERIFIED.

## 4. Evaluation and comparison

- Dated release evidence above establishes age, not a new numerical guard
  evaluation. Exact guard-classification benchmark/version/scores and
  evaluation dates extracted for this checkpoint: UNVERIFIED.
- Intended-policy unsafe-content recall, benign-request false positives,
  adversarial robustness, multilingual/trajectory coverage, calibration,
  and moderation latency: UNVERIFIED.
- Generator refusal benchmarks are not substituted for guard accuracy.
- Expected local recall/false-positive rate: UNVERIFIED. A historical
  comparison would use identical policy labels, schema-validity scoring,
  data, and runtime settings. Baseline revision, numeric acceptance
  thresholds, and uncertainty: UNVERIFIED.
  Age eligibility must be resolved before any trial.

## 5. Trial status

- Excluded from new policy `models[]` entries: upstream exceeds 12 months.
- Additional completion gaps: exact bytes/lineage, runtime qualification,
  full memory budget, dated matched guard evaluation, baseline,
  and numeric acceptance thresholds.
