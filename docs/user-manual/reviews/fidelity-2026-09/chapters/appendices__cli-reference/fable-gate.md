# Fable gate: appendices/cli-reference

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Shape | Pass for a reference appendix. What it is, Before you type anything, the notation key, Finding the program, the 44-command index, global flags, fourteen domain sections each opening with its window route, What the command line cannot do, Known defects, Next. |
| Index | Pass. Forty-four commands, set-diffed both ways against the root help by the reviewer. |
| Every flag traceable | Pass. Every syntax line from a help dump or a live help run, fifteen examples rerun with their outputs and the four deliberate nonzero statuses. |
| Fidelity false claim corrected | Pass. The deprecation target at both sites, plus the strict default and the palindrome note. |
| Rulings | Pass. All nine, with the Terminal opener, the six-row notation key, seventeen window-route openers, placeholders or fixtures for every example, five tables, coordinates stated once and echoed, the binary path word for word. |
| Reader consensus | Pass. Seventy-nine of seventy-nine applied, 108 of 113 others. |
| Cross-chapter agreement | Pass after the gate edit. The bundle export command is documented as unrunnable in this release, matching chapter 61's finding. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The glossary refs use slugs, matching the anchors the body links to.
2. `bundle export` is marked unrunnable in this release with a pointer to File Formats, and added to Known defects, which now counts seven.
3. The ops pointer goes to Running in CI, the ONT genotyping opener names the two genotyping chapters by their titles, and the Next paragraph sends provenance layout to the Foundations chapter.
4. Reading time raised to 45 minutes.

## Rulings

The reference appendix keeps its own shape and does not take the operation template. The `export PATH` line is the appendix's own convenience, and the CONSISTENCY binary-path sentence stands beside it. DRIFT rows 47, 90, and 128 are wrong and the chapter is right.

## Findings for RESULTS.md

Any command run with a working directory under /private/tmp fails with a provenance publication artifact error and writes nothing, because a resolved path is compared with an unresolved one across the /tmp symlink. `bundle export` cannot be run because its `--format` collides with the global one.

## Phase 5 notes

No shots.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
