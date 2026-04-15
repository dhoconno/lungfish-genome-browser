#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SHOT_DIR="$SCRIPT_DIR/shot"

if [[ ! -d "$SHOT_DIR/node_modules" ]]; then
  echo "installing shot dependencies..." >&2
  (cd "$SHOT_DIR" && npm install --silent)
fi

CMD="${1:-}"
shift || true

case "$CMD" in
  plan|execute)
    exec node "$SHOT_DIR/runner.mjs" "$CMD" "$@"
    ;;
  *)
    echo "usage: run-shot.sh <plan|execute> <recipe.yaml>" >&2
    exit 2
    ;;
esac
