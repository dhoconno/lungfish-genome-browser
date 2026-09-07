# Fable gate: 03-reads/04-trimming-and-filtering

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. All 26 settings across the six operations in the three-sentence shape with the registry labels verbatim. |
| Every number traceable | Pass. Every before-and-after count reproduced by the fidelity review from its own reruns. The primer-removal figures that did not reproduce are absent. |
| Menu paths and surfaces | Pass. Tools > Trimming & Filtering > each of the six items, the FASTQ/FASTA Operations window and its left-hand list, the readiness-line messages, the Plugin Manager's Required Setup heading, the Operations Panel and Copy CLI Command, and every CLI flag. |
| Fidelity false claims corrected | Pass. FASTA input on four of six operations. Fixed-base trimming's fastp attribution confirmed by the controller from FastqCommand.swift. |
| Removed content noted | Pass. |
| Glossary alphabetised | Pass. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The output location followed the retired `Analyses/<tool>-<timestamp>/` rule in three places. A FASTQ operation writes its bundle directly under `Analyses/`, named `<input stem>-<operation>` (`FASTQOperationOutputImporter.bundleNameStem`), so the run writes `HG002.chr20.10.0-10.5Mb-fastpTrim`. The illustrative dated folder name was removed with it, and the sidebar name the editor had derived as `fastpTrim` corrected to the full form. Chapter 6 and CONSISTENCY.md corrected in the same commit.
2. One unsourced duration dropped from Before you start.
3. The claim that a bundle with orphaned mates still maps was unverified against LGE's mapping path. Replaced with tool-dependent advice to keep the minimum low.

## Rulings

The readiness-line paragraph stays as prose above the list under the bullet cap. The command-line sentences stay inside the Settings entries per CONSISTENCY.md.

## Findings for RESULTS.md

`fastq primer-remove` defaults `--kmer` to 23 where the dialog defaults k to 15. `fastq trim` and `quality-trim` take `--extra-args` while only the Quality Trim pane offers the field. The adapter fastp auto-detects is not reported anywhere in the app.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
