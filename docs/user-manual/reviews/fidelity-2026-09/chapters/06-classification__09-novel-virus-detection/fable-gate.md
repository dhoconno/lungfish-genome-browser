# Fable gate: 06-classification/09-novel-virus-detection

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line, Troubleshooting, Next. |
| Every registry setting present | Pass. import.nvd's two cli_only flags, with the three result-window controls labelled as controls rather than settings. |
| Every number traceable | Pass. 10 hits, 3 samples, 4 contigs, experiment 100, the four best-hit rows with their identities, scores, and read counts, the five-hit HIV-1 contig stepping from 750 to 660, the RPB worked pair, the twelve-column export, all from the author's import and summary runs and the fidelity review. |
| Menu paths and surfaces | Pass. File > Import Center... > Classification Results > NVD Results, the sheet's Browse..., path readout, Preview rows, Run, the four cards, the filter bar in source order, the fourteen columns, the header menu, the context menu with Extract to New Bundle…, the action bar, BLAST Verify's enablement rule and tooltips, the drawer, Import Metadata... in the Inspector. |
| Fidelity false claims corrected | Pass. Two rows fixed, one incomplete row completed, one unverifiable row cut. |
| Defects disclosed | Pass. No sort control, the twelve-column export, extract reads failing on a BAM-less result, each in one sentence. |
| Reader consensus | Pass. Forty-three of forty-three applied, including the Download ZIP sentence and the plain import-destination statement. |
| Import destination | Pass, with a gate edit. The Settings paragraph no longer says the reader always passes Analyses. CONSISTENCY.md gains the ruling that the three import routes land in three different places. |
| Glossary alphabetised | Pass. Reads per billion in place. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The unmeasured "few seconds" for a large run replaced by a qualitative statement.
2. The --output-dir paragraph names both project folders rather than mandating Analyses.
3. The 1e-30 guidance framed as a rule of thumb.
4. Next links renamed to the retitled NAO-MGS and CZ ID chapters.
5. Reading time raised to 26 minutes.

## Rulings

The identity bands stay as a rule of thumb since the viewport draws no banding. The BLAST database stays unnamed since the CSV records only its version. Metadata persistence across reopen is a Phase 5 check. The fixture README's expansion of NVD and its hits claim, and features.yaml's Discovery and Nextflow wording, are Phase 6 items.

## Findings for RESULTS.md

The NVD outline has no sort control. The TSV export drops Unique Reads and Aln Length. The Import Center writes NVD into Imports while NAO-MGS goes to Analyses and CZ ID to Classifications. features.yaml misnames NVD and its engine. The fixture README misnames NVD and misdescribes the hits.

## Phase 5 notes

Confirm metadata columns survive closing and reopening an NVD result.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
