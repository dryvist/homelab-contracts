---
type: Model Dossier
title: "Xiaomi-OCR-0"
description: "Dated candidate evidence and explicit trial completion fields."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Official card](https://huggingface.co/xiaomi-research/Xiaomi-OCR-0).
- Release: 2026-09-30, stated in the card's news section.
  Repository creation date: UNVERIFIED.
- Exact upstream: `xiaomi-research/Xiaomi-OCR-0`; immutable release revision:
  [e4d1c4a6804bd9ef342b93d705a73af003e2ef4e](https://huggingface.co/xiaomi-research/Xiaomi-OCR-0/commit/e4d1c4a6804bd9ef342b93d705a73af003e2ef4e).
  Current-card results may postdate that weight-upload revision.
- Architecture: Qwen3.5-0.8B-based vision-language model.
  License: Apache-2.0; full restrictions/component-notice review: UNVERIFIED.
- Intended comparison: compact document parsing, tables, and formulas.
  Evidence is publisher-reported; no independent evaluation or local run.

## 2. Artifact evidence

- Original checkpoint at the release revision above; selected weight
  filenames/shards, exact bytes, and storage precision: UNVERIFIED.
- Conversion date/recipe/calibration: not applicable until a conversion
  is selected. Fine-tuning source revision and complete transformation
  audit: UNVERIFIED. Community conversions do not inherit upstream scores.
- Weight download date: UNVERIFIED; no weights downloaded.

## 3. Runtime and memory

- Current official card documents Transformers 5.17.0, PyTorch 2.14.0,
  and torchvision 0.29.0; its detailed example points to another publisher
  namespace. Byte/revision equivalence with the selected release:
  UNVERIFIED. Generated Hub launch snippets do not qualify the checkpoint.
- Exact serving runtime/container revision, precision kernels,
  tokenizer/template compatibility, endpoint, document postprocessor,
  unsupported features, and target hardware qualification: UNVERIFIED.
  Generative reasoning/tool parsing is not a required OCR output interface.
- Analytical illustrative BF16 floor: assuming exactly 0.8 billion
  parameters at 2 bytes each, 1.6 billion / 2^30 = 1.49 GiB.
  Actual selected-artifact bytes and precision remain UNVERIFIED.
- Full budget adds key/value or recurrent state, vision/crop workspace,
  graph/compiler workspace, any drafter, and co-resident models.
  Input resolution, crops/passes/page count, output budget, concurrency,
  exact allocations, and comparable measured peak: UNVERIFIED.

## 4. Evaluation and comparison

- Official card observed 2026-11-06: OmniDocBench v1.6 overall 96.83,
  Real5 overall 95.24, Wild-OmniDocBench overall 87.94,
  UniMER-Test 97.84, and PubTabNet 92.27.
  Individual evaluation/publication dates: UNVERIFIED.
- OCRBench version/results, text error, reading order, layout,
  target-language coverage, long-document behavior, and local
  page/document throughput under matched settings: UNVERIFIED.
- Expected local accuracy: UNVERIFIED. Proposed comparison criterion:
  preserve incumbent text/table/formula/reading-order accuracy while
  improving page throughput at identical resolution, crops, passes, and
  page count. Dataset versions, baseline revision, numeric thresholds,
  and uncertainty: UNVERIFIED; establish before a trial.

## 5. Trial status

- Evidence recorded; no new policy `models[]` entry and no trial authorized.
- Completion gaps: exact artifact manifest/bytes, runtime namespace parity,
  license review, template/kernel support, full memory budget, dated
  matched OCR evaluation, incumbent baseline, and acceptance thresholds.
