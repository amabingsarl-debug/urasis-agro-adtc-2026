# Urasis Agro — ADTC 2026

Urasis Agro is a Swahili-first, offline agricultural assistant for African smallholder farmers and extension workers. This competition edition uses a 3B-parameter Qwen model in GGUF Q4_K_M format and runs only through `llama.cpp`.

The reproducible build pins `llama.cpp` release `b10218` and compiles it with network-backed model loading disabled (`LLAMA_CURL=OFF`).

## Why it exists

Cloud assistants require connectivity, recurring API fees and data transfer. Urasis Agro keeps the core interaction on an ordinary 8 GB laptop and can answer in Kiswahili even when the network is unavailable. Its local agricultural notes encourage field observation, low-cost action, integrated pest management and escalation to a local extension officer when uncertainty is high.

## Quick start on Ubuntu 22.04

```bash
cd adtc-2026
bash scripts/setup_ubuntu.sh
bash download_model.sh
bash scripts/run_cli.sh
```

Run the optional local agricultural retrieval demonstrator:

```bash
bash scripts/run_agro_rag.sh --show-sources \
  "Majani ya mahindi yangu yana mashimo na kinyesi ndani ya moyo. Nifanye nini?"
```

Run the official profiler:

```bash
bash scripts/profile.sh --skip-accuracy   # smoke test
bash scripts/profile.sh                   # final participant report
```

Validate the repository structure before profiling:

```bash
node scripts/validate_submission.mjs
python3 -m unittest discover -s tests -v
node scripts/validate_submission.mjs --final  # fails while personal metadata is pending
```

## Offline boundary

`download_model.sh` and the one-time setup require Internet access. After the GGUF file and tools are installed, `run_cli.sh` and `run_agro_rag.sh` make no network requests. Gemini, Firebase and WebLLM are not part of this submission runtime.

For a strict offline check, disconnect the machine after setup, then run both declared prompts through `scripts/run_cli.sh` or `scripts/run_agro_rag.sh` and the official profiler. The model URL, expected size and SHA-256 are documented in `download_model.sh`.

## Repository status

The submission metadata contains the Devpost project ID, the submitter's legal name and the verified GitHub handle. Official profiler results are reported only after an Ubuntu 22.04 benchmark run.

The main Urasis PWA remains a separate product demonstrator with avatars, speech, image input and online/local modes. It is not required by the ADTC profiler and is not used to claim model benchmark results.
