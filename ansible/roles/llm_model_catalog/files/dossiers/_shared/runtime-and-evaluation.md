---
type: Model Dossier Defaults
title: "Shared runtime and evaluation evidence"
description: "Common evidence fields referenced by individual model dossiers."
timestamp: "2026-11-06T00:00:00Z"
status: started
---

Individual dossiers reference these sections and state only their differences.
A local field replaces the corresponding shared field. Referenced required
fields remain subject to the same completeness checks as local evidence.

## 3. Runtime and memory

- Runtime: MLX or llama.cpp according to the selected artifact.
- Tagged runtime/container revision: UNVERIFIED.
- Supported architecture and hardware path: local accelerator; exact runtime
  qualification UNVERIFIED.
- Precision kernels: UNVERIFIED.
- Tokenizer/chat template: UNVERIFIED.
- Reasoning and tool parsers: UNVERIFIED.
- Endpoint behavior and unsupported features: UNVERIFIED.
- Weights, cache/state, vision, graph/compiler, drafter, and co-resident bytes:
  UNVERIFIED beyond the artifact weight totals in each dossier.
- Input/output length and concurrency: UNVERIFIED for a matched trial; catalog
  serving limits are configuration values, not measured capacity.
- Analytical estimate and assumptions: the weight-only lower bound in GiB is
  selected artifact bytes divided by 1,073,741,824. It excludes key/value cache,
  recurrent state, vision workspace, graph/compiler workspace, drafter, and
  co-resident models. Full runtime estimate: UNVERIFIED.
- Comparable published peak: UNVERIFIED.

## 4. Evaluation and comparison

- Applicable use cases: the intended tasks stated in each dossier.
- Dated task-matched benchmarks and versions: UNVERIFIED.
- Settings, scaffold, and reasoning budget: UNVERIFIED.
- Quant fidelity: UNVERIFIED.
- Candidate/incumbent comparison: UNVERIFIED under matched settings.
- Expected results: quality, latency, and throughput UNVERIFIED.

## Classification and extraction

- Task-matched accuracy, schema validity, class balance, languages, calibration,
  abstention, false positives/negatives, and latency: UNVERIFIED.

## 5. Trial status

- Dated promotion decision: UNVERIFIED; dossier started and trial authorization
  pending completed evidence.
- Predeclared acceptance criteria: UNVERIFIED; set acceptance thresholds,
  matched incumbent baseline, and expected results before a trial or replacement.
- Unresolved fields: UNVERIFIED entries remain visible in the shared and local
  evidence. The policy checks identity, age, and dossier completeness; it does
  not certify runtime support, memory fit, quality, or replacement readiness.
