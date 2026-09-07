#!/usr/bin/env bash
# Dump the lungfish-cli help tree (root, every command, one level of
# subcommands) into docs/user-manual/reviews/fidelity-2026-09/cli-help/.
#
# Wrapped in `timeout 30` because a command that tries to contact the
# network (e.g. `fetch`) would otherwise hang the dump indefinitely.
set -euo pipefail
CLI="${LUNGFISH_CLI:-.build/debug/lungfish-cli}"
[ -x "$CLI" ] || CLI="/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli"
OUT="docs/user-manual/reviews/fidelity-2026-09/cli-help"
mkdir -p "$OUT"
timeout 30 "$CLI" --version > "$OUT/_version.txt"
timeout 30 "$CLI" --help > "$OUT/_root.txt" 2>&1
cmds=$(sed -n '/^SUBCOMMANDS:/,/^$/p' "$OUT/_root.txt" | grep -E '^  [a-z]' | awk '{print $1}')
for c in $cmds; do
  f="$OUT/$c.txt"
  { echo "==== $c ===="; timeout 30 "$CLI" help "$c" 2>&1; } > "$f"
  # `|| true`: a command with no subcommands (e.g. `version`) makes grep
  # find nothing, which would otherwise trip `set -e`/pipefail here.
  subs=$(sed -n '/^SUBCOMMANDS:/,/^$/p' "$f" | grep -E '^  [a-z]' | awk '{print $1}' | sed 's/^(default)$//' || true)
  for s in $subs; do
    { echo; echo "==== $c $s ===="; timeout 30 "$CLI" help "$c" "$s" 2>&1; } >> "$f"
    # one more level for the groups that nest (fastq, tree infer, genotype)
    subsubs=$(sed -n "/==== $c $s ====/,\$p" "$f" | sed -n '/^SUBCOMMANDS:/,/^$/p' | grep -E '^  [a-z]' | awk '{print $1}' || true)
    for t in $subsubs; do { echo; echo "==== $c $s $t ===="; timeout 30 "$CLI" help "$c" "$s" "$t" 2>&1; } >> "$f"; done
  done
done
echo "wrote $(ls "$OUT" | wc -l | tr -d ' ') files; version $(cat "$OUT/_version.txt")"
