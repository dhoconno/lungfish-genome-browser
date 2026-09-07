# Fable gate: 03-reads/02-downloading-from-sra

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Seven fetch.sra settings in the three-sentence shape with the registry labels Platform, Strategy, Layout, Min Size (Mbases), Publication Date, Max Results, and the search scope. |
| Every number traceable | Pass. The live SRA search and download figures were reverified by the fidelity review against the CLI, and the one duration kept is a measured timing of the documented run. |
| Menu paths and surfaces | Pass. The Database Browser's SRA collection, its two Search buttons, the Operations Panel as the progress surface, the `Imports/` destination for the read bundle, and every CLI option. |
| Fidelity false claims corrected | Pass. The Download Center name and the `Downloads/` destination for reads were replaced by the Operations Panel and `Imports/` per CONSISTENCY.md. |
| Removed content noted | Pass. Unsourced durations and the viral example were dropped under the drift decisions and listed in the author report. |
| Glossary alphabetised | Pass. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass. |

## Gate edits

None. The editor pass left no sentence the gate had to change.

## Findings for RESULTS.md

SRA read downloads land under `Imports/` as bundles while only NCBI reference records go to `Downloads/`. The Database Browser exposes two Search buttons.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
