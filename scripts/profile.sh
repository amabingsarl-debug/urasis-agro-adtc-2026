#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export PATH="$ROOT_DIR/.tools/llama.cpp/build/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if ! command -v llama-bench >/dev/null 2>&1; then
  echo "llama-bench was not found. Run: bash scripts/setup_ubuntu.sh" >&2
  exit 1
fi
if ! command -v adtc-profiler >/dev/null 2>&1; then
  echo "adtc-profiler was not found. Run: bash scripts/setup_ubuntu.sh" >&2
  exit 1
fi

adtc-profiler run \
  --submission "$ROOT_DIR" \
  --mode participant \
  --output "$ROOT_DIR/submission.json" \
  "$@"

echo "Profiler report: $ROOT_DIR/submission.json"
