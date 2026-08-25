#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODEL="$ROOT_DIR/model/urasis-agro-qwen2.5-3b-q4_k_m.gguf"
LLAMA_CLI="${LLAMA_CLI:-$ROOT_DIR/.tools/llama.cpp/build/bin/llama-cli}"

if [[ ! -x "$LLAMA_CLI" ]]; then
  echo "llama-cli was not found. Run: bash scripts/setup_ubuntu.sh" >&2
  exit 1
fi
if [[ ! -f "$MODEL" ]]; then
  echo "Model was not found. Run: bash download_model.sh" >&2
  exit 1
fi

exec "$LLAMA_CLI" \
  --model "$MODEL" \
  --system-prompt-file "$ROOT_DIR/system_prompt.txt" \
  --conversation \
  --ctx-size 4096 \
  --threads "${URASIS_THREADS:-4}" \
  --n-predict 420 \
  --temp 0.2 \
  --top-p 0.9 \
  --flash-attn auto \
  --color on
