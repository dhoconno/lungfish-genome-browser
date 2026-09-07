# Fable gate: 06-classification/04-running-taxtriage

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. All eleven classify.taxtriage controls have a paragraph with the on-screen label, default, allowed values, and flag. Skip Krona visualization is written without a colon, as the app draws it. |
| Every number traceable | Pass, on the raw-read rerun. 85,199 pairs, 73.4 seconds, 106 files, TASS 99, 96.9542%, breadth 100.0, depth 1258.7, 165,208 aligned from the report against 168,265 from the database with each source named once, 82,983 assigned and 770 unclassified pairs, 6,865 unique reads, fifteen rows, the two-sample 86.2 seconds, 30 rows, and subsample figures, all recorded in author.md's rerun section. Covered Bases not quoted. |
| Menu paths and surfaces | Pass. Tools > Classification > TaxTriage..., the Prerequisites row and its messages, the Samples rows and role picker, Add Sample and Remove, the Kraken2 Database picker and its empty state, Sequencing Platform, Skip assembly (faster) and its caption, the taxtriage-batch folder name, the six-column table, the four cards, the action bar with Extract FASTQ and the hidden Related button, the context menu, the batch overview as one table, the two contamination-flag surfaces, the Export menu's five items. |
| Fidelity false claims corrected | Pass. Nine rows fixed with the reviewer's wording, three unverifiable rows resolved. |
| Defects disclosed | Pass. The TASS column, Confidence column, and High Confidence card all reading zero on this pinned revision, stated once ahead of the tables, with the report file named and the route to it through the Finder. Open Report's file choice disclosed. |
| Reader consensus | Pass. Twenty-four of twenty-four applied. |
| Worked example on the raw bundle | Pass. Every figure from the extraction-based runs is gone. |
| Glossary alphabetised | Pass. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The editor's unmeasured "tens of minutes" first-run estimate became a statement that the first run lasts as long as the image download.
2. Reading time raised to 30 minutes.

## Rulings

The author's runs on the Kraken 2 extraction were replaced by a rerun on the raw demo copy before editing, recorded in the ledger. Open Report stays described as opening one of the report files, since the source picks the first PDF or else the first report file. The deposited 86,281-pair count is dropped from this chapter.

## Findings for RESULTS.md

TASS scores all 0.000 because the pinned v3.3.8 never writes multiqc_confidences.txt, the top-report fallback carries no score, and the parser's 0 to 1 scale disagrees with the report's 0 to 100. The single-sample entry point always names the folder taxtriage-batch. `extract reads --tool taxtriage` requires --accession and rejects --taxon. Open Report picks the first PDF or the first report file rather than the organism detection report.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
