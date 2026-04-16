#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
MANUAL_DIR="$(cd -- "$SCRIPT_DIR/../.." &>/dev/null && pwd)"
BUILD_DIR="$SCRIPT_DIR/.."

python3 -m pip install --quiet 'mkdocs==1.6.1' 'mkdocs-material==9.5.40'

cd "$BUILD_DIR"
exec mkdocs build --strict --clean
