---
type: Model Dossier
title: "Qwen/Qwen3-Reranker-4B"
description: "Dated retrieval evidence and trial completion fields."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

[Shared provenance](_shared/candidate-provenance.md)

## 1. Upstream evidence

- Observed: 2026-11-06. [Official card](https://huggingface.co/Qwen/Qwen3-Reranker-4B).
- Release: [2025-06-05](https://qwenlm.github.io/blog/qwen3-embedding/).
  This exceeds 12 months as of the observation date.
- Immutable upstream revision:
  [22e683669bc0f0bd69640a1354a6d0aebcfeede5](https://huggingface.co/Qwen/Qwen3-Reranker-4B/commit/22e683669bc0f0bd69640a1354a6d0aebcfeede5).
- Architecture: Qwen3 text reranker, 4B parameters; 32K context.
  License: Apache-2.0.
- Intended comparison: text reranking.

## 2. Artifact evidence

- Original BF16 checkpoint at the upstream revision above.
- [Files](https://huggingface.co/Qwen/Qwen3-Reranker-4B/tree/main):
  `model-00001-of-00002.safetensors` and
  `model-00002-of-00002.safetensors`, rounded to 4.06 and 3.98 GB.
  Exact byte counts: UNVERIFIED.
- Conversion date/recipe/calibration: not applicable to original BF16.
  Fine-tuning source revision and transformation audit: UNVERIFIED.

## 3. Runtime and memory

- Official card documents Transformers >=4.51.0 and Sentence Transformers.
  Exact qualified runtime/container revision: UNVERIFIED.
- Checkpoint-specific query/document template and yes/no logit scoring
  need parity checks. Target hardware/kernel support, tokenizer,
  truncation, endpoint, and unsupported features: UNVERIFIED.
  Generative tool/reasoning parsers are not part of relevance scoring.
- Analytical weight floor: rounded 8.04 billion bytes / 2^30 =
  approximately 7.49 GiB. Full budget adds sequence activations,
  any runtime cache, graph/compiler workspace, and co-resident models.
  Vision workspace and drafter are not assumed for this text-only task.
  Exact allocations and comparable measured peak: UNVERIFIED.
- Intended input length, candidate depth, output, and concurrency:
  UNVERIFIED; output is a relevance score rather than generated prose.

## 4. Evaluation and comparison

- Official card observed 2026-11-06: MTEB-R 69.76,
  CMTEB-R 75.94, MMTEB-R 72.74, MLDR 69.97, MTEB-Code 81.20.
  Exact evaluation/publication day: UNVERIFIED.
- Publisher protocol: retrieval subsets of MTEB English v2, Chinese v1,
  MMTEB, and MTEB Code; top 100 candidates from Qwen3-Embedding-0.6B.
- Matched incumbent BEIR/MIRACL results, candidate-pool parity,
  pairwise/listwise parity, and local latency: UNVERIFIED.
- Expected local ranking gain: UNVERIFIED. A historical comparison would
  use identical candidates, dimensions, truncation, and scorer; dataset,
  baseline revision, numeric acceptance thresholds, and uncertainty
  remain UNVERIFIED. Age eligibility must be resolved before any trial.

## 5. Trial status

- Excluded from new policy `models[]` entries: upstream exceeds 12 months.
- Additional completion gaps: exact artifact bytes, runtime qualification,
  full memory budget, dated matched evaluation, and acceptance thresholds.
- Artifact conversion or metadata updates do not reset upstream age.
