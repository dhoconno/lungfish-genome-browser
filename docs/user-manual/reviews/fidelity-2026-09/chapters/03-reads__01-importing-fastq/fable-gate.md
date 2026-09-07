# Fable gate: 03-reads/01-importing-fastq

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), a pairing primer, Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Eight import.fastq settings in the three-sentence shape with the registry labels, and the sample-sheet card's absence of settings stated. |
| Every number traceable | Pass. Every figure from the scratch import and the naming probe reverified by the fidelity review, including the byte counts and the card renderings (249 bp, 24.9). |
| Menu paths and surfaces | Pass. Import Center's Sequencing Reads tab and Sequencing Read Files card, the configuration sheet and its summary lines, the duplicate dialog's Replace / Keep Both / Skip, the Operations Panel, the Inspector's Sample Metadata table, and every CLI option. |
| Fidelity false claims corrected | Pass. Charts fill at import, the reimport dialog, the unpaired summary shape, the card text, the glossary_refs anchors. |
| Removed content noted | Pass. The Paired badge, the sample-name field, the case-insensitive pairing claim, the missing-mate warning, the BAM platform claim, the Assemblies folder, and the SARS-CoV-2 example were removed under the drift decisions and listed in the author report. |
| Glossary alphabetised | Pass. Quality binning, Read clumping, Sample sheet in place. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after the gate edit. |

## Gate edits

1. The Mean Q sentence was broken mid-sentence and gave the wrong reason for the low value. It now explains that the card holds seqkit's error-probability average, which a minority of poor bases pulls down, and points at the Quality Control chapter for the second average the command line reports.

## Findings for RESULTS.md

A paired import is stored inside its bundle as one interleaved file. The Mean Q card and `fastq qc-summary` compute different averages of the same reads.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
