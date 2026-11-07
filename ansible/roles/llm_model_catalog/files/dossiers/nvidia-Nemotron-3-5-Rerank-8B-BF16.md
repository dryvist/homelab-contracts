---
type: Model Dossier
title: "Nemotron 3.5 Rerank 8B BF16"
description: "Dated retrieval evidence and trial completion fields."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

[Shared provenance](_shared/candidate-provenance.md)

## 1. Upstream evidence

- Observed: 2026-11-06. [Official card](https://huggingface.co/nvidia/Nemotron-3.5-Rerank-8B-BF16).
- Release: 2026-10-20, stated by the card. Repository creation: UNVERIFIED.
- Exact checkpoint: `nvidia/Nemotron-3.5-Rerank-8B-BF16`, revision
  [f88f8d9104726747791283ab156d2fcdb29e90a7](https://huggingface.co/nvidia/Nemotron-3.5-Rerank-8B-BF16/commit/f88f8d9104726747791283ab156d2fcdb29e90a7).
- Architecture: Pixtral vision encoder and bidirectional Ministral3 tower.
  Intended comparison: multilingual text/image query-document relevance.
- License: OpenMDW-1.1; base-model Apache-2.0 terms and component notices
  also apply.

## 2. Artifact evidence

- Original BF16 checkpoint at the revision above, not a selected conversion.
- [Files](https://huggingface.co/nvidia/Nemotron-3.5-Rerank-8B-BF16/tree/main):
  `model-00001-of-00004.safetensors` through
  `model-00004-of-00004.safetensors`, rounded respectively to
  4.88, 4.93, 4.93, and 2.01 GB. Exact bytes: UNVERIFIED.
- Quantization conversion date/recipe/calibration: not applicable to this
  BF16 selection. Training lineage is described in the card; exact source
  checkpoint revision and additional transformation audit: UNVERIFIED.

## 3. Runtime and memory

- Card documents vLLM 0.32.0 with Transformers 5.19.0 and pooling output
  through `/classify`. Chat template uses query/document roles;
  one image per pair, longest edge 1,120 pixels, 32,768 total tokens.
- Exact target kernel/template/tokenizer qualification, container digest,
  unsupported features, and scoring parity: UNVERIFIED. Generative
  reasoning/tool parsers are not applicable to relevance-logit output.
- Analytical weight floor: rounded shard sum 16.75 billion bytes / 2^30 =
  approximately 15.60 GiB. Full budget adds activations, image workspace,
  graph/compiler workspace, and co-resident models. Decoder key/value
  cache, recurrent state, and drafter are not assumed for pooling.
  Exact allocations and comparable measured peak: UNVERIFIED.
- Intended pair length/resolution, candidate depth, batch/concurrency,
  and local request latency: UNVERIFIED.

## 4. Evaluation and comparison

- [Publisher announcement, 2026-10-21](https://huggingface.co/blog/nvidia/nemotron-retriever-world-class-agentic-retrieval):
  ViDoRe v3.1 combined-input nDCG@10 60.49, with a 2026-10-20
  leaderboard snapshot; top 50 candidates from Nemotron 3.5 Embed 1B.
- Current card separately reports ViDoRe V3 combined 67.56 and
  MIRACL-VISION image 78.69, with top 50 BF16 embedder candidates.
  Publication/evaluation day for those card results: UNVERIFIED.
  Keep V3 and v3.1 protocols separate.
- Matched text-domain BEIR/MIRACL subsets, incumbent candidate pool,
  pairwise/listwise protocol parity, and local latency: UNVERIFIED.
- Expected local ranking improvement: UNVERIFIED. Proposed criterion:
  improve held-out nDCG@10 over the same first-stage candidates without
  exceeding the declared latency/memory budget. Numeric thresholds,
  baseline revision, dataset version, and uncertainty: UNVERIFIED.

## 5. Trial status

- Evidence recorded; no new policy `models[]` entry and no trial authorized.
- Completion gaps: exact bytes/source lineage, license review, target
  runtime, full memory budget, dated matched retrieval evaluation,
  candidate-pool baseline, and numeric acceptance thresholds.
