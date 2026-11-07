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

## 2. Artifact evidence

- Artifact repository: UNVERIFIED unless the individual artifact records its
  Hub API identity.
- Artifact publisher: UNVERIFIED unless recorded from the Hub API `author`.
- Immutable artifact revision: UNVERIFIED unless recorded from the Hub API `sha`.
- Artifact created date: UNVERIFIED unless recorded from the Hub API `createdAt`.
- Evidence observed date: UNVERIFIED unless recorded with the API observation.
- Upstream source revision: recorded when published; otherwise retain the
  artifact's `base_model` and state "not published by converter". Optional.
- Quantization recipe: UNVERIFIED unless the artifact records its recipe.
- Calibration provenance: UNVERIFIED unless the publisher identifies it for
  a calibrated method. Calibration-free methods record "not applicable",
  the method, and a source for that method.
- Transformation: pruning, merging, distillation, or safety modification
  evidence is UNVERIFIED unless recorded for the individual artifact.

Artifact records cite the Hub API and pinned publisher card/configuration,
with an observation date. Repository creation and upload dates are distinct
from conversion timestamps. Download dates belong to deployment records.
Listed bytes cover weights only; tokenizer, configuration, cache, and runtime
allocations are additional. A total in GiB divides bytes by 1,073,741,824.
The pinned files link identifies the revision of each listed weight file.

## Upstream interpretation

Conversion dates do not renew upstream age. Official upstream metadata and
cards are publisher evidence; conversion claims are third-party evidence
unless the artifact and upstream publishers match.
Unless a dossier names a role assignment, it records a catalog candidate for
self-hosted inference only.

## CPU decision models

The CPU reference servers' architecture qualification and unsupported features
remain UNVERIFIED. Their endpoint contract is `/v1/systemone`.

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

Each policy model records its own `Benchmark` entries with score, date, and
source URL. For publisher-card rows dated 2026-11-07, the date records live
source observation in UTC, not an unpublished evaluation-run date. Upstream
scores describe original weights; conversion fidelity and trial readiness
remain separate evidence. Published report/card dates are identified locally.

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
