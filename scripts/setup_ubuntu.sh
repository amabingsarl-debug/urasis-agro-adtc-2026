#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$ROOT_DIR/.tools"
LLAMA_DIR="$TOOLS_DIR/llama.cpp"
LLAMA_CPP_TAG="${LLAMA_CPP_TAG:-b10218}"
LLAMA_BUILD_JOBS="${LLAMA_BUILD_JOBS:-2}"

sudo apt-get update
sudo apt-get install -y build-essential cmake curl git

mkdir -p "$TOOLS_DIR"
if [[ ! -d "$LLAMA_DIR/.git" ]]; then
  git clone --depth 1 --branch "$LLAMA_CPP_TAG" \
    https://github.com/ggml-org/llama.cpp.git "$LLAMA_DIR"
else
  git -C "$LLAMA_DIR" fetch --depth 1 origin "refs/tags/$LLAMA_CPP_TAG"
  git -C "$LLAMA_DIR" checkout --detach FETCH_HEAD
fi

cmake -S "$LLAMA_DIR" -B "$LLAMA_DIR/build" \
  -DGGML_NATIVE=ON \
  -DGGML_OPENMP=ON \
  -DLLAMA_CURL=OFF \
  -DCMAKE_BUILD_TYPE=Release
cmake --build "$LLAMA_DIR/build" --target llama-bench --config Release --parallel "$LLAMA_BUILD_JOBS"

git -C "$LLAMA_DIR" rev-parse HEAD > "$TOOLS_DIR/llama.cpp.commit"

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export CMAKE_BUILD_PARALLEL_LEVEL="${CMAKE_BUILD_PARALLEL_LEVEL:-1}"
uv python install 3.11
uv tool install --force --python 3.11 \
  "git+https://github.com/Africa-Deep-Tech-Foundation/adtc-profiler.git"

echo "llama.cpp installed in $LLAMA_DIR/build/bin"
echo "ADTC profiler installed with an isolated Python 3.11 runtime"
echo "Next: bash $ROOT_DIR/download_model.sh"
