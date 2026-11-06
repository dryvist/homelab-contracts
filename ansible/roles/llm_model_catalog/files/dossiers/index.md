# Model dossiers

## Priority candidates

* [LFM3-1.7B](LiquidAI-LFM3-1-7B.md)
  Small classification, extraction, and tool-use evidence.
* [Nemotron 3.5 Super-VL NVFP4](nvidia-NVIDIA-Nemotron-3-5-Super-VL-120B-A12B-NVFP4.md)
  Agent and document evidence.
* [Nemotron 3.5 Lightning NVFP4](nvidia-NVIDIA-Nemotron-3-5-Lightning-30B-A3B-NVFP4.md)
  Agent efficiency evidence.
* [EmbeddingGemma 2](google-embeddinggemma-2.md)
  Multimodal embedding evidence and conversion snapshot.
* [Nemotron 3.5 Embed 1B NVFP4](nvidia-Nemotron-3-5-Embed-1B-NVFP4.md)
  Precision-specific retrieval evidence.
* [Qwen3-Reranker-4B](Qwen-Qwen3-Reranker-4B.md) - Historical text-reranking evidence.
* [Nemotron 3.5 Rerank 8B BF16](nvidia-Nemotron-3-5-Rerank-8B-BF16.md)
  Multimodal reranking evidence.
* [Xiaomi-OCR-0](xiaomi-research-Xiaomi-OCR-0.md) - Compact document-parsing evidence.
* [LightOnOCR-3-4B](lightonai-LightOnOCR-3-4B.md) - Transcription and layout evidence.
* [Nemotron 3.5 Parse](nvidia-Nemotron-3-5-Parse.md)
  Document parsing and pass-specific results.
* [AdaGuard-4B](AdaGuard-4B.md) - Policy-conditioned guard evidence.
* [Qwen3Guard-Gen-8B](Qwen-Qwen3Guard-Gen-8B.md) - Historical generative-guard evidence.

## Admission status

Observed 2026-11-06. No priority candidate has a completed trial dossier.
No new entry is added to [policy models](../model-policy.json).
The existing EmbeddingGemma MXFP8 entry remains inherited policy data;
it does not certify conversion fidelity or trial readiness.

Every priority dossier lists its own completion gaps. Shared UNVERIFIED
fields include exact artifact/source provenance, restrictions review,
target runtime qualification, full memory budget, dated task-matched
comparison, incumbent revision, and numeric acceptance thresholds.
Rounded storage estimates are not runtime capacity measurements.

Policy admission requires at least 1 dated benchmark entry with a numeric
score and source URL, with an optional indented source continuation:

```text
- Benchmark: NAME VERSION; score: NUMBER; date: YYYY-MM-DD;
  source: https://SOURCE
```

The date records evaluation or publication, and cannot be in the future.
`UNVERIFIED` entries do not count. Other incomplete fields remain visible
alongside verified benchmark entries.

For pinned publisher cards, the date is the cited card revision's publication
day in the linked history. It does not establish the evaluation run date.
Upstream scores describe the original checkpoint; converted-artifact fidelity,
local capacity, and trial authorization require their own evidence.

* LFM3: conversion pins/bytes, classification and schema-validity results.
* Super-VL: BF16 source pin, complete shard bytes, RULER and parser support.
* Lightning: BF16 source pin, conversion provenance, long-context comparison.
* EmbeddingGemma 2: conversion refresh, quantized retrieval, re-embedding plan.
* Nemotron Embed: source pin, quantization provenance, matched retrieval/index plan.
* Qwen3-Reranker-4B: release 2025-06-05 exceeds 12 months; no admission.
* Nemotron Rerank: exact bytes, matched candidate pool and retrieval protocol.
* Xiaomi-OCR-0: selected manifest, runtime namespace equivalence, OCRBench.
* LightOnOCR-3: tagged runtime, benchmark revisions, OCRBench.
* Nemotron Parse: target/drafter bytes, tagged runtime, matched OCR protocol.
* AdaGuard: weight-release date and immutable checkpoint revision UNVERIFIED.
* Qwen3Guard: release 2025-09-23 exceeds 12 months; no admission.

## Other catalog dossiers

* [K2 Horizon 7B](IFM-K2-Horizon-7B.md) - Catalog artifact evidence.
* [Qwen3.5-9B](Qwen-Qwen3-5-9B.md) - Catalog artifact evidence.
* [Qwen3.6-27B](Qwen-Qwen3-6-27B.md) - Catalog artifact evidence.
* [Qwen3.6-35B-A3B](Qwen-Qwen3-6-35B-A3B.md) - Catalog artifact evidence.
* [Qwen3.8-27B](Qwen-Qwen3-8-27B.md) - Catalog artifact evidence.
* [MiMo V2.6 Distill Qwen 9B](XiaomiMiMo-MiMo-V2-6-Distill-Qwen-9B.md)
  Catalog artifact evidence.
* [Unlimited OCR](baidu-Unlimited-OCR.md) - Catalog artifact evidence.
* [Laya typed decisions](convaiinnovations-laya-typed-decisions.md)
  Catalog artifact evidence.
* [OpenDecider Nano](manjunathshiva-opendecider-nano.md) - Catalog artifact evidence.
* [Nemotron 3.5 Bolt BF16](nvidia-NVIDIA-Nemotron-3-5-Bolt-74B-A9B-BF16.md)
  Catalog artifact evidence.

## Shared evidence

* [Shared runtime and evaluation evidence](_shared/runtime-and-evaluation.md)
  Common fields with per-dossier overrides.

## Change history

* [Dossier log](log.md) - Dated changes to the evidence bundle.
