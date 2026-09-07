#!/usr/bin/env bash
# Capture a rectangle of the display, for subjects that are not a window:
# open menus and submenus, pop-up pickers, context menus, and popovers.
#
#   capture-region.sh <part-dir> <shot-id> <x> <y> <w> <h> [max-width]
#
# x y w h are display points (top-left origin of the main display, the
# frame the `screenshot` tool reports once you convert it to points).
# Writes docs/user-manual/assets/screenshots/<part-dir>/<shot-id>.png at
# the display's native scale, downscaled to max-width (default 1600) when
# wider. The app must be frontmost with the menu already open; run this
# from a shell while the menu is held open by a click, since keyboard focus
# never leaves the menu.
set -euo pipefail
PART="${1:?part dir}"; ID="${2:?shot id}"
X="${3:?x}"; Y="${4:?y}"; W="${5:?w}"; H="${6:?h}"; MAXW="${7:-1600}"
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../.." && pwd)"
OUT_DIR="$ROOT/assets/screenshots/$PART"
mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/$ID.png"
TMP="$(mktemp -t lge-region.XXXXXX).png"
screencapture -x -R "$X,$Y,$W,$H" "$TMP"
PW=$(sips -g pixelWidth "$TMP" | awk '/pixelWidth/{print $2}')
if [[ "$PW" -gt "$MAXW" ]]; then
  sips --resampleWidth "$MAXW" "$TMP" >/dev/null
fi
mv "$TMP" "$OUT"
sips -g pixelWidth -g pixelHeight "$OUT" | awk '/pixel/{printf "%s %s ", $1, $2} END{print ""}'
echo "$OUT"
