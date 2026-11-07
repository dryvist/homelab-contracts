---
type: Model Dossier
title: "zai-org/GLM-4.7"
description: "Upstream and MXFP4 artifact evidence for the shared model policy."
timestamp: "2026-11-07T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Evidence observed date: 2026-11-07 for every source below.
- Upstream repository and immutable revision: `zai-org/GLM-4.7`,
  `602d01efcdd332c5238ca4bcede555defbe83eb7`;
  [Hub metadata](https://huggingface.co/api/models/zai-org/GLM-4.7).
- Upstream creation or release date: 2025-12-22T07:45:52.000Z (`createdAt`),
  from that metadata. Release date: UNVERIFIED independently of repository creation.
- License and restrictions: upstream metadata declares MIT; the
  [artifact card](https://huggingface.co/mlx-community/GLM-4.7-REAP-50-mxfp4/blob/9ad1984a355f7593fcc2db1c08576f68ec8c2f12/README.md)
  declares Apache-2.0. Additional restrictions and license compatibility: UNVERIFIED.
- Architecture: `Glm4MoeForCausalLM`, `glm4_moe`, from upstream metadata.
- Intended task: text generation; the upstream card reports coding and tool-use results.
- Official versus third-party evidence: `zai-org` publishes upstream evidence;
  `0xSero` publishes pruning evidence; `mlx-community` publishes the MLX conversion.
- Lineage: the artifact card names `0xSero/GLM-4.7-REAP-50`; its
  [parent metadata](https://huggingface.co/api/models/0xSero/GLM-4.7-REAP-50)
  now resolves to `0xSero/GLM-4.7-185B`, revision
  `948d7ed5cdd7d5ac0003482798640675500f50aa`.
  The [parent card](https://huggingface.co/0xSero/GLM-4.7-185B/blob/948d7ed5cdd7d5ac0003482798640675500f50aa/README.md)
  identifies GLM-4.7 as its base.
- Age: pruning and quantization inherit `zai-org/GLM-4.7` creation on
  2025-12-22. With `max_age_days: 365`, the inclusive validator accepts through
  2026-12-22 (365 days) and rejects from 2026-12-23 (366 days).
- Lane rationale: record the MLX MXFP4 artifact and its inherited age.

## 2. Artifact evidence

### mlx-community/GLM-4.7-REAP-50-mxfp4

- Artifact repository: `mlx-community/GLM-4.7-REAP-50-mxfp4`.
- Artifact publisher: `mlx-community`.
- Immutable artifact revision: `9ad1984a355f7593fcc2db1c08576f68ec8c2f12`.
- Artifact created date: 2026-01-03T05:46:40.000Z (`createdAt`).
- Evidence observed date: 2026-11-07,
  [artifact metadata](https://huggingface.co/api/models/mlx-community/GLM-4.7-REAP-50-mxfp4?blobs=true).
- Filename/shards and bytes: `model-00001-of-00019.safetensors` through
  `model-00019-of-00019.safetensors`, 19 shards totaling 98221349756 bytes,
  summed from metadata `siblings[].size`. Weights were not downloaded;
  download date: not applicable.
- Quantization recipe: MXFP4, 4 bits, group size 32, from the
  [pinned config](https://huggingface.co/mlx-community/GLM-4.7-REAP-50-mxfp4/blob/9ad1984a355f7593fcc2db1c08576f68ec8c2f12/config.json),
  observed 2026-11-07. The artifact card records mlx-lm 0.30.0.
  Exact conversion command and conversion date: UNVERIFIED.
- Upstream source revision: UNVERIFIED; the converter names its parent repository
  but does not pin the converted source checkpoint.
- Calibration provenance: the parent card lists a 1360-sample REAP mixture
  from evol-codealpaca-v1, xlam-function-calling-60k, and SWE-smith-trajectories.
  MXFP4 conversion calibration: UNVERIFIED.
- Transformation: expert pruning followed by MLX MXFP4 conversion, as described
  in the parent and artifact cards; this changes the upstream weights.

## 3. Runtime and memory

- Tagged runtime/container revision: mlx-lm 0.30.0 is the converter-reported
  version in the artifact card, observed 2026-11-07; serving revision: UNVERIFIED.
- Supported architecture and hardware path: MLX is named by the artifact card;
  validated hardware and distributed serving behavior: UNVERIFIED.
- Precision kernels: config declares MXFP4; executed kernels: UNVERIFIED.
- Tokenizer/chat template: artifact card uses `tokenizer.apply_chat_template`;
  serving template validation: UNVERIFIED.
- Reasoning and tool parsers: UNVERIFIED for this artifact/runtime combination.
- Endpoint behavior and unsupported features: UNVERIFIED.
- Weights, cache/state, vision, graph/compiler, drafter, and co-resident bytes:
  weight files total 98221349756 bytes; all additional allocations: UNVERIFIED.
- Input/output length and concurrency: UNVERIFIED.
- Analytical estimate and assumptions: weight-file bytes provide a storage
  baseline only; total serving memory and runtime assumptions: UNVERIFIED.
- Comparable published peak: UNVERIFIED.

## 4. Evaluation and comparison

- Benchmark: SWE-bench Verified, upstream GLM-4.7; score: 73.8; date: 2025-12-22;
  source: https://huggingface.co/zai-org/GLM-4.7/blob/294238269c0a7040598a453fd0e39c07876572a4/README.md
- Benchmark date basis: the linked card revision is dated 2025-12-22T16:22:08Z
  in [upstream history](https://huggingface.co/api/models/zai-org/GLM-4.7/commits/main),
  observed 2026-11-07. This dates publication, not benchmark execution.
- Applicable use cases: upstream coding and tool use; artifact-specific
  classification, extraction, long-context, and safety results: UNVERIFIED.
- Dated task-matched benchmarks and versions: upstream SWE-bench Verified
  above; matched pruned MXFP4 results, Arena, LiveBench, BFCL, and long-context
  results: UNVERIFIED.
- Settings, scaffold, and reasoning budget: the pinned upstream card specifies
  temperature 0.7, top-p 1.0, and 16384 maximum new tokens for SWE-bench Verified.
  Exact scaffold and artifact settings: UNVERIFIED.
- Quant fidelity: UNVERIFIED. The upstream result does not measure pruning
  or MXFP4 conversion fidelity and is not an artifact score.
- Candidate/incumbent comparison: UNVERIFIED under matched settings.
- Expected results: UNVERIFIED for the pruned MXFP4 artifact.

## 5. Trial status

- Dated promotion decision: UNVERIFIED; this dossier records policy age evidence.
- Predeclared acceptance criteria: UNVERIFIED for runtime or quality promotion.
- Unresolved fields: source revision, conversion provenance, runtime support,
  memory fit, artifact evaluation, and matched comparison remain UNVERIFIED.
