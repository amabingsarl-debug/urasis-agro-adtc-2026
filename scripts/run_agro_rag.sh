#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export LLAMA_CLI="${LLAMA_CLI:-$ROOT_DIR/.tools/llama.cpp/build/bin/llama-cli}"
exec python3 "$ROOT_DIR/src/agro_cli.py" "$@"
