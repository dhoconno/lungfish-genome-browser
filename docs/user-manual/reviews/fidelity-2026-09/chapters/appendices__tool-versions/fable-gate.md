# Fable gate: appendices/tool-versions

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Shape | Pass for a generated reference. What it is, Reading the tables, the four lock-derived tables, Two checks before you cite a number, On the command line, Which one governs, Next, with the anchor kept. |
| Every cell traceable | Pass. Fifty-nine rows regenerated from the lock by the reviewer's own script, `version --tools` rerun live and agreeing on all eighteen rows, the bibliography agreeing row for row. |
| Fidelity false claims corrected | Pass. Three of three, with the license cell regenerated through the script rather than typed. |
| Rulings | Pass, with one correct deviation. The editor found that the About window does list tool versions per installed pack and the Plugin Manager's Installed tab lists packages, so the chapter gives three routes rather than saying no window shows versions. The ruling is withdrawn and the chapter is right. |
| Reader consensus | Pass. Twenty-seven of twenty-seven applied, 46 of 52 others. |
| Cross-chapter agreement | Pass. Versions match the bibliography, the Deacon rows read bundledPayload as the CONSISTENCY ruling records, and the three Plugin-Manager-only packs match chapters 57 and 60. |
| Strict lint | Pass after the gate edit. |

## Gate edits

1. Reading time raised to 24 minutes.

## Rulings

Ruling (b) of the editor brief is withdrawn. The About window prints a version for every tool in an installed pack, so the manual's routes to a version are the About window, the Plugin Manager's Installed tab, and the provenance sidecar. No generator exists for this page, and the author's script in the author record is the regeneration route until one is added, a Phase 6 tooling note.

## Findings for RESULTS.md

None new. The old page presented a derived Source column as lock data and invented a micromamba license.

## Phase 5 notes

No shots.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
