---
type: Model Dossier
title: "Nemotron 3.5 Parse"
description: "Dated candidate evidence and explicit trial completion fields."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-06. [Official card](https://huggingface.co/nvidia/Nemotron-3.5-Parse).
- Release: 2026-10-17, stated by the card. Repository creation: UNVERIFIED.
- Exact upstream: `nvidia/Nemotron-3.5-Parse`; immutable revision:
  [73acd6632fc1dde8d68ccbd3c1d8d630e46d00db](https://huggingface.co/nvidia/Nemotron-3.5-Parse/commit/73acd6632fc1dde8d68ccbd3c1d8d630e46d00db).
- Architecture: C-RADIOv4 vision encoder plus 10-layer mBART decoder,
  approximately 0.631B parameters with an included MTP head.
- License: OpenMDW-1.1; tokenizer has separate MIT attribution.
  Full restrictions/component-notice review: UNVERIFIED.
- Intended comparison: document text, tables, formulas, layout, reading order.
  Evidence is publisher-reported; no independent evaluation or local run.

## 2. Artifact evidence

- Original checkpoint at the upstream revision above.
- [Repository files](https://huggingface.co/nvidia/Nemotron-3.5-Parse/tree/main):
  selected weight manifest and exact bytes: UNVERIFIED.
- Conversion date/recipe/calibration: not applicable to original weights.
  Source checkpoint revisions and complete transformation audit:
  UNVERIFIED. A separate optional DFlash2 drafter needs its own byte budget.
- Weight download date: UNVERIFIED; no weights downloaded.

## 3. Runtime and memory

- Card documents Transformers and vLLM, including optional DFlash2;
  reference hardware includes H100/H200 with BF16.
- Exact tagged runtime/container revision, target precision kernels,
  tokenizer/template, endpoint/postprocessor, unsupported features,
  and target hardware qualification: UNVERIFIED.
  Generative tool/reasoning parsers are not a document-output interface.
- Illustrative BF16 floor: 0.631 billion parameters * 2 bytes / 2^30 =
  approximately 1.18 GiB. Actual artifact bytes remain UNVERIFIED.
- Full budget adds cache/state, image/crop workspace, graph/compiler
  workspace, optional drafter, and co-resident models. Resolution,
  input/output length, passes/crops/page count, concurrency, exact
  allocations, and comparable measured peak: UNVERIFIED.

## 4. Evaluation and comparison

- Official card observed 2026-11-06: ParseBench single/double/triple-pass
  overall 72.74 / 74.92 / 75.20. DFlash2 throughput respectively
  18.01 / 14.26 / 12.99 pages/s. These are publisher configurations,
  not target-device measurements; exact evaluation date: UNVERIFIED.
- The [2026-10-21 announcement](https://huggingface.co/blog/nvidia/nemotron-retriever-world-class-agentic-retrieval)
  is separate dated release evidence; its older throughput recipe must
  not be combined with the current card's DFlash2 measurements.
- OCRBench and matched parsing-dataset revisions, text error, formulas,
  tables, reading order, layout, target languages, long-document behavior,
  and matched incumbent throughput: UNVERIFIED.
- Expected local result: UNVERIFIED. Proposed criterion: retain incumbent
  document accuracy at a fixed pass/crop/resolution budget while improving
  throughput. Dataset, baseline revision, numeric thresholds, and
  uncertainty: UNVERIFIED; establish before a trial.

## 5. Trial status

- Evidence recorded; no new policy `models[]` entry and no trial authorized.
- Completion gaps: weight/drafter bytes and lineage, license review,
  tagged runtime, full memory budget, dated matched OCR evaluation,
  incumbent baseline, and numeric acceptance thresholds.
