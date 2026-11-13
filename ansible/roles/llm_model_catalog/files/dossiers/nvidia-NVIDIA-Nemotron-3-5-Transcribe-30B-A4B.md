---
type: Model Dossier
title: "nvidia/NVIDIA-Nemotron-3.5-Transcribe-30B-A4B"
description: "Upstream and artifact evidence for the shared model policy."
timestamp: "2026-11-13T00:00:00Z"
status: started
---

## 1. Upstream evidence

- Observed: 2026-11-13. [Hub metadata](https://huggingface.co/api/models/nvidia/NVIDIA-Nemotron-3.5-Transcribe-30B-A4B).
- Upstream repository: `nvidia/NVIDIA-Nemotron-3.5-Transcribe-30B-A4B`.
- Observed immutable upstream revision: `c17667641642c4265ff2b7037dd101b7d4567634` (`sha`).
  [Pinned upstream card](https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Transcribe-30B-A4B/blob/c17667641642c4265ff2b7037dd101b7d4567634/README.md).
- Upstream creation or release date: 2026-10-07T22:50:21.000Z (Hub `createdAt`
  of the repository, used for `upstream_created`), observed 2026-11-13. The pinned
  card's Release Date section lists 10/28/2026 for Hugging Face, GitHub, NGC, and
  build.nvidia.com.
- Release date: 2026-10-28,
  [pinned card, Release Date section][upstream-card].
- License and restrictions: OpenMDW-1.1 (`license_name: openmdw-1.1` in card metadata;
  [license link](https://openmdw.ai/license/1-1/)). Third-party notices shipped with the
  upstream repository: UNVERIFIED.
- Architecture: speech-augmented language model. Audio perception uses a transformer ASR
  encoder, a speaker encoder, and a CTC timestamp alignment head, feeding a Nemotron-3.5
  Lightning 30B-A3B language backbone (base model `nvidia/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-BF16`).
  Card states 34B total parameters, 4.3B active, including the audio encoder.
- Intended task: offline speech transcription, speech translation, speaker-attributed
  transcription, rich transcription, and audio question answering, for 40 languages and
  recordings up to one hour, per the pinned card.
- Official versus third-party evidence: `nvidia` publishes the upstream checkpoint. The
  4-bit MLX artifact is a third-party conversion by `nativ-community`.
- Lane rationale: UNVERIFIED.

## 2. Artifact evidence

### nativ-community/Nemotron-3.5-Transcribe-30B-A4B-EA-4bit

- [Artifact metadata](https://huggingface.co/api/models/nativ-community/Nemotron-3.5-Transcribe-30B-A4B-EA-4bit?blobs=true),
  observed 2026-11-13.
- Artifact repository: `nativ-community/Nemotron-3.5-Transcribe-30B-A4B-EA-4bit`.
- Artifact publisher: `nativ-community` (`author`).
- Immutable artifact revision: `c47153ca2ce4024d43e216b81e6db4f67b886545` (`sha`).
  [Pinned files](https://huggingface.co/nativ-community/Nemotron-3.5-Transcribe-30B-A4B-EA-4bit/tree/c47153ca2ce4024d43e216b81e6db4f67b886545).
- Artifact created date: 2026-10-28T15:04:50.000Z (`createdAt`).
- Evidence observed date: 2026-11-13,
  [Hub API](https://huggingface.co/api/models/nativ-community/Nemotron-3.5-Transcribe-30B-A4B-EA-4bit?blobs=true).
- Quantization recipe: affine 4-bit, group size 64, on language-model weights (164 quantized
  modules). Speech and speaker encoders are unquantized.
  [Pinned conversion record][nativ-conversion],
  observed 2026-11-13.
- Calibration provenance: not applicable; affine MLX quantization is calibration-free.
  Method and source: `conversion.json` in the pinned revision, observed 2026-11-13.
- Upstream source revision: not published by converter. `conversion.json` names the source as
  `Nemotron-3.5-Transcribe-30B-A4B-EA` with source weights SHA-256
  `3c8fea7c469945ade54def8340e2f3c9571f6383b9bf379edcc476419c35caaf`. Mapping that
  source to the `nvidia` repository revision above: UNVERIFIED.
- Transformation: MLX conversion of the upstream checkpoint, mlx 0.32.4, quantization as above;
  optional MTP heads omitted (`conversion.json`).
- Weight files: four safetensors shards, 19,258,638,574 bytes in total (about 19.3 GB), per the
  pinned file listing.

## 3. Runtime and memory

- Runtime: mlx-audio, pinned to implementation commit
  `92decb7577878ef8e9274c1a7e33084760be03aa` (install line on the pinned artifact card).
  Released mlx-audio version: UNVERIFIED.
- Tagged runtime/container revision: `92decb7577878ef8e9274c1a7e33084760be03aa`.
- Supported architecture and hardware path: Apple silicon with MLX 0.32.4. The publisher's
  validation ran on Apple M3 Ultra with strict reload (`validation.json`).
- Precision kernels: MLX affine 4-bit quantized modules; other kernel details UNVERIFIED.
- Tokenizer/chat template: `tokenizer.json` present in the artifact. Chat template: UNVERIFIED.
- Reasoning and tool parsers: UNVERIFIED.
- Endpoint behavior and unsupported features: the pinned card documents the Python API
  (`load`, then `generate` with task options). OpenAI-compatible serving: UNVERIFIED. Card
  limitations: no timestamps for speaker tags, streaming is not incremental microphone
  recognition, output is text only.
- Weights, cache/state, vision, graph/compiler, drafter, and co-resident bytes: weight shards
  19,258,638,574 bytes. Cache, graph, and co-resident bytes: UNVERIFIED.
- Input/output length and concurrency: upstream card states recordings up to one hour and a
  65,536-token context. Converted-artifact limits: UNVERIFIED.
- Analytical estimate and assumptions: UNVERIFIED.
- Comparable published peak: one publisher smoke run recorded peak memory 19,723,936,056 bytes
  (`validation.json`). Not a capacity measurement.

## 4. Evaluation and comparison

- Benchmark: Open ASR Leaderboard English mean WER, 9 public datasets, upstream BF16 checkpoint (not the 4-bit artifact); score: 4.71; date: 2026-10-12;
  source: <https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Transcribe-30B-A4B/blob/c17667641642c4265ff2b7037dd101b7d4567634/README.md>
- Benchmark date basis: upstream `.eval_results/open_asr_leaderboard.yaml` at the pinned revision,
  dated 2026-10-12. Card states results captured October 12, 2026.
- Applicable use cases: transcription, speech translation, speaker-attributed transcription, and
  audio question answering, per the pinned card. Artifact smoke checks cover six task cases on
  synthesized inputs; these are not an accuracy benchmark.
- Dated task-matched benchmarks and versions for the converted artifact: UNVERIFIED.
- Settings, scaffold, and reasoning budget: UNVERIFIED.
- Quant fidelity: UNVERIFIED. The 4-bit artifact has no measured comparison to the BF16 checkpoint.
- Candidate/incumbent comparison: UNVERIFIED.
- Expected results: UNVERIFIED.

## 5. Trial status

- Dated promotion decision: UNVERIFIED.
- Predeclared acceptance criteria: UNVERIFIED.
- Unresolved fields: quantized-artifact benchmark, source-to-upstream revision mapping, third-party
  notices review, runtime and endpoint details, memory budget beyond weight bytes, comparison and
  acceptance criteria.

[upstream-card]: https://huggingface.co/nvidia/NVIDIA-Nemotron-3.5-Transcribe-30B-A4B/blob/c17667641642c4265ff2b7037dd101b7d4567634/README.md
[nativ-conversion]: https://huggingface.co/nativ-community/Nemotron-3.5-Transcribe-30B-A4B-EA-4bit/blob/c47153ca2ce4024d43e216b81e6db4f67b886545/conversion.json
