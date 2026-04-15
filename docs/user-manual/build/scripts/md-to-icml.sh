#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BUILD_DIR="$(cd -- "$SCRIPT_DIR/.." &>/dev/null && pwd)"
OUT_DIR="$BUILD_DIR/indesign/stories"

if [[ $# -lt 1 ]]; then
  echo "usage: md-to-icml.sh <chapter.md> [<chapter.md>...]"
  exit 2
fi

command -v pandoc >/dev/null || { echo "pandoc required (brew install pandoc)" >&2; exit 1; }

mkdir -p "$OUT_DIR"

for md in "$@"; do
  rel="$(basename "$md" .md)"
  out="$OUT_DIR/$rel.icml"
  pandoc \
    --from markdown+yaml_metadata_block \
    --to icml \
    --lua-filter="$SCRIPT_DIR/icml-filter.lua" \
    -o "$out" \
    "$md"
  echo "wrote $out"
done
