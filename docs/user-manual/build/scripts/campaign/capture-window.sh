#!/usr/bin/env bash
# Capture one macOS window by CGWindowID at the display's native (Retina)
# scale, without its shadow, and store it as a manual screenshot.
#
#   capture-window.sh <window-id> <part-dir> <shot-id> [max-width]
#
# Writes docs/user-manual/assets/screenshots/<part-dir>/<shot-id>.png,
# downscaled to max-width pixels (default 1600) when wider, per the shot
# size ruling in reviews/fidelity-2026-09/SHOTS.md. Prints the final
# pixel size. Optional region crop: set CROP="x y w h" in window points
# (top-left origin, as System Events reports) to keep only that region.
set -euo pipefail
WID="${1:?window id}"; PART="${2:?part dir}"; ID="${3:?shot id}"; MAXW="${4:-1600}"
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../.." && pwd)"
OUT_DIR="$ROOT/assets/screenshots/$PART"
mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/$ID.png"
TMP="$(mktemp -t lge-shot.XXXXXX).png"
screencapture -l "$WID" -o -x "$TMP"
SCALE=2
if [[ -n "${CROP:-}" ]]; then
  read -r CX CY CW CH <<<"$CROP"
  sips --cropOffset $((CY*SCALE)) $((CX*SCALE)) --cropToHeightWidth $((CH*SCALE)) $((CW*SCALE)) "$TMP" >/dev/null
fi
W=$(sips -g pixelWidth "$TMP" | awk '/pixelWidth/{print $2}')
if [[ "$W" -gt "$MAXW" ]]; then
  sips --resampleWidth "$MAXW" "$TMP" >/dev/null
fi
mv "$TMP" "$OUT"
sips -g pixelWidth -g pixelHeight "$OUT" | awk '/pixel/{printf "%s %s ", $1, $2} END{print ""}'
echo "$OUT"
