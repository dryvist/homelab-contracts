---
type: Model Dossier
title: "LightOnOCR-3-4B"
description: "Dated candidate evidence and explicit trial completion fields."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

[Shared provenance](_shared/candidate-provenance.md)

## 1. Upstream evidence

- Observed: 2026-11-06. [Official card](https://huggingface.co/lightonai/LightOnOCR-3-4B).
- Release: [2026-10-08](https://huggingface.co/blog/lightonai/lightonocr-3).
  Repository creation date: UNVERIFIED.
- Exact upstream: `lightonai/LightOnOCR-3-4B`; immutable revision:
  [b71010f095dc3735de7ee6b9969bff8f8f50b39a](https://huggingface.co/lightonai/LightOnOCR-3-4B/commit/b71010f095dc3735de7ee6b9969bff8f8f50b39a).
- Architecture: Qwen3.5 vision-language architecture.
  License: Apache-2.0.
- Intended comparison: OCR, document transcription, and layout extraction.

## 2. Artifact evidence

- Original checkpoint at the upstream revision above.
- [File listing](https://huggingface.co/lightonai/LightOnOCR-3-4B/tree/main):
  `model.safetensors`, rounded to 9.08 GB. Exact bytes: UNVERIFIED.
- Quantization conversion date/recipe/calibration: not applicable to the
  original selection. Fine-tuning source revision and transformation audit:
  UNVERIFIED. No community conversion receives these upstream scores.

## 3. Runtime and memory

- Official card documents vLLM with remote model code and thinking disabled.
  Exact tagged runtime/container revision, precision kernels, tokenizer,
  template, endpoint/postprocessor compatibility, unsupported features,
  and target hardware qualification: UNVERIFIED.
- Reasoning/tool parsers are not required by the proposed OCR interface;
  any thinking output must be excluded from document text.
- Analytical weight floor: rounded 9.08 billion bytes / 2^30 =
  approximately 8.46 GiB. Full budget adds cache/state, vision/crop
  workspace, graph/compiler workspace, any drafter, and co-resident models.
  Exact allocations and comparable measured peak: UNVERIFIED.
- Intended resolution, crops, passes, page count, input/output length,
  and concurrency: UNVERIFIED.

## 4. Evaluation and comparison

- [Publisher release, 2026-10-08](https://huggingface.co/blog/lightonai/lightonocr-3):
  olmOCR benchmark overall 86.3. Current card also reports
  ParseBench mean 75.1; individual evaluation/publication day: UNVERIFIED.
- Benchmark dataset revisions, OCRBench result, text error, tables,
  formulas, reading order, layout, target languages, long-document
  behavior, and matched local page/document throughput: UNVERIFIED.
- Expected local accuracy/throughput: UNVERIFIED. Proposed criterion:
  preserve incumbent transcription and layout accuracy while improving
  throughput at identical resolution/crops/passes/page count.
  Baseline revision, dataset, numeric thresholds, and uncertainty:
  UNVERIFIED; establish before a trial.

## 5. Trial status

- Evidence recorded; no new policy `models[]` entry and no trial authorized.
- Completion gaps: exact bytes/source lineage, license review, tagged
  runtime and output qualification, full memory budget, dated matched OCR
  evaluations, incumbent baseline, and numeric acceptance thresholds.
