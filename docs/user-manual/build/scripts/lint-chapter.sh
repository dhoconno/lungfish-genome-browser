#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LINT_DIR="$SCRIPT_DIR/lint"

if [[ ! -d "$LINT_DIR/node_modules" ]]; then
  echo "installing lint dependencies…" >&2
  (cd "$LINT_DIR" && npm install --silent)
fi

exec node "$LINT_DIR/bin/lint-chapter.mjs" "$@"
