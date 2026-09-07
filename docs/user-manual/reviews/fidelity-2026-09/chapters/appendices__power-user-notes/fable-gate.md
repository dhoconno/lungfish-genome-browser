# Fable gate: appendices/power-user-notes

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Shape | Pass for a power-user appendix. What it is with the terminal signpost, the consolidated caveat list second, then one section per wrapped tool, the sidecar envelope and steps, ops stats, reproducibility, pinning, the conda lock, asserting an installation, the Operations panel, reaching an unwrapped flag, querying variants, Next. |
| Every flag traceable | Pass. Every argument list cites a source line in the author's record, and the reviewer confirmed each. |
| Fidelity false claims corrected | Pass. Four of four, with the two missing gate caveats added. |
| Rulings | Pass. All nine, with the caveat list carrying a consequence per entry, terminal-only capabilities named, the FORMAT DP trap listed, determinism claims held to the recorded evidence, eight glossary terms. |
| Reader consensus | Pass. Fifty-three of fifty-three applied, 71 others, 12 skipped. |
| Cross-chapter agreement | Pass after the gate edits. Every link text now matches the target chapter's title. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. Thirteen link texts aligned with the target chapters' titles.
2. The "twelve tools" count replaced, since the lock pins forty-one tools across the always-installed set and the packs.
3. Reading time raised to 45 minutes.

## Rulings

The determinism table dropped by the author stays dropped. The failure-report retention of fifty is sourced here at OperationFailureReportStore.swift, so chapter 67's author was right to drop it only for want of a citation of their own.

## Findings for RESULTS.md

`ops stats` counts only files named exactly `.lungfish-provenance.json`, so per-output sidecars are never counted. `ops stats --format json` and `tsv` are advertised and unimplemented. The four `--ivar-*` flags configure LGE's own converter and never reach iVar. Every `files[]` entry writes checksum and size under two key spellings. `--format` is a root-level option every subcommand advertises regardless of implementation, which is also the mechanism behind the `bundle export` collision.

## Phase 5 notes

No shots.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
