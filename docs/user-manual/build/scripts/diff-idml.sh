#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: diff-idml.sh <old.idml> <new.idml>"
  exit 2
fi

OLD="$1"
NEW="$2"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/old" "$TMP/new"
( cd "$TMP/old" && unzip -q "$OLD" )
( cd "$TMP/new" && unzip -q "$NEW" )

# Pretty-print each XML file for readable diffs.
command -v xmllint >/dev/null || { echo "xmllint required (install via 'brew install libxml2')" >&2; exit 1; }
for f in $(cd "$TMP/old" && find . -name '*.xml'); do
  xmllint --format "$TMP/old/$f" > "$TMP/old/$f.pretty" 2>/dev/null || true
done
for f in $(cd "$TMP/new" && find . -name '*.xml'); do
  xmllint --format "$TMP/new/$f" > "$TMP/new/$f.pretty" 2>/dev/null || true
done

diff -ruN "$TMP/old" "$TMP/new" --exclude='*.xml'  # metadata files
find "$TMP/old" -name '*.pretty' | while read f; do
  rel="${f#$TMP/old/}"
  diff -u "$f" "$TMP/new/$rel" || true
done
