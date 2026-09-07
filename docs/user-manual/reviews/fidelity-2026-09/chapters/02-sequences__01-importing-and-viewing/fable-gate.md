# Fable gate: 02-sequences/01-importing-and-viewing

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener present), Procedure, Settings, Reading the results, concept sections, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. import.reference has none and the chapter says so. import.annotation-track's Reference, Track Name, and Track ID each in the three-sentence shape with the registry labels. |
| Every number traceable | Pass. 81,706 bases, 102 features, 8 / 5 / 5 / 13, the sickle codon, the ORF defaults, `--min-query-cover` 0.5, `--line-width` 70, all verified by the fidelity review; the two corrected command blocks were run by the editor against the fixture bundle. |
| Menu paths and surfaces | Pass. Six Import Center tabs, the Annotation Track alert and its Import button, Go to Location (Cmd-L), Go to Gene (Cmd-Option-G, verified in MainMenu.swift), Reverse Complement (Cmd-Shift-R), the toolbar Translate button versus the menu item, the three lanes, the Copy submenu titles, the sidebar menu items, the Export items. |
| Fidelity false claims corrected | Pass. FASTA-only inputs for translate and extract sequence, Total Length at 81.7 Kb, the alert's multi-file behaviour, the free-text Go to Gene alert, click selects and Zoom to Annotation centres, the fuller sidebar menu. |
| Removed content noted | Pass. The SARS-CoV-2 walkthrough, the format table, the invented drop zone and preview, Zoom to Visible Region, the pane and orange-block claims, and the invented error sheet were removed under the drift decisions and listed in the author report. |
| Glossary alphabetised | Pass. Annotation track, Reverse complement, Sequence viewport in place. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after the gate edit. |

## Gate edits

1. "the whole chapter takes about twenty minutes" had no source, the same class of claim removed from chapter 7. Dropped.

## Notes for Phase 5

`viewport-lanes.png` does not exist yet and the body links it. Generate it from the brief before the build.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
