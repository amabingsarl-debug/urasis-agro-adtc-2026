#!/usr/bin/env bash
set -euo pipefail

MODEL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/model"
MODEL_PATH="$MODEL_DIR/urasis-agro-qwen2.5-3b-q4_k_m.gguf"
MODEL_URL="https://huggingface.co/Qwen/Qwen2.5-3B-Instruct-GGUF/resolve/main/qwen2.5-3b-instruct-q4_k_m.gguf?download=true"
MODEL_SHA256="626b4a6678b86442240e33df819e00132d3ba7dddfe1cdc4fbb18e0a9615c62d"

mkdir -p "$MODEL_DIR"

if [[ -f "$MODEL_PATH" ]] && echo "$MODEL_SHA256  $MODEL_PATH" | sha256sum --check --status; then
  echo "Model already present and verified: $MODEL_PATH"
  exit 0
fi

echo "Downloading Urasis Agro base model (approximately 2.1 GB)..."
curl --fail --location --retry 5 --retry-delay 3 --continue-at - \
  --output "$MODEL_PATH.part" "$MODEL_URL"

echo "$MODEL_SHA256  $MODEL_PATH.part" | sha256sum --check
mv "$MODEL_PATH.part" "$MODEL_PATH"
echo "Model downloaded and verified: $MODEL_PATH"
