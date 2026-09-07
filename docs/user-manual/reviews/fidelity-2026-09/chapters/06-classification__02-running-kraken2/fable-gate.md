# Fable gate: 06-classification/02-running-kraken2

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`,
`parameters.yaml`, and the Plugin Packs chapter.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. classify.kraken2 (eight controls), classify.install-database (five Databases tab controls), classify.taxonomy-browser (five viewport controls), classify.extract-reads-by-taxon (four, one hidden for Kraken 2). Labels with on-screen colons match the registry. |
| Every number traceable | Pass. 85,199 pairs, the Viral and Standard-16 tables, the three-preset table, 83,591 extracted pairs and 167,182 records, the 1,471 unclassified, the 718 above-species reads, 2.6 and 11.3 seconds, all from the author's 2026-09-07 runs and recounted by the fidelity review. |
| Menu paths and surfaces | Pass. Tools > Classification > Kraken2..., the FASTQ/FASTA Operations title, the Databases tab and its banner text, the Operations panel row titles, the Analyses folder naming, the Extract Reads... item and Create Bundle button, the Look Up on NCBI submenu, Export and Copy Summary, exit 64 and the Empty Kraken2 report text. |
| Fidelity false claims corrected | Pass. Nine rows fixed. Plugin pack card wording, Create Bundle, the % column header, header-click column filter, Standard at 67 GB. |
| Editor items ruled | Durations stay out. Registry conda extract already reconciled before the gate. Two captions fixed at the gate. Unclassified row stays out of the table since the kreport places it outside the tree. |
| Defects disclosed | Pass. Empty Kraken2 report on an all-unclassified run, Copy Taxonomy Path copying names rather than the taxid, no route to register a custom database. |
| Glossary alphabetised | Pass. Kreport entry corrected to eight columns with the taxid in column 7. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. Databases tab caption now says eleven Kraken 2 rows.
2. Taxonomy viewport caption now places the breadcrumb bar across both panes.
3. Reading time raised to 30 minutes.

## Rulings

The three measured durations stay out of the fixed prose and appear once, attributed to the reference run. The Plugin Packs chapter's Kraken 2 database count is corrected in the same commit (eleven rows, nine downloadable plus SILVA and Greengenes). The esviritu Run Mode registry correction rides along.

## Findings for RESULTS.md

An all-unclassified Kraken 2 run exits 64 with Empty Kraken2 report before Bracken runs. Copy Taxonomy Path copies names, so the taxid for extract reads must come from the kreport or NCBI. Kreports LGE writes always carry eight columns. The Databases tab lists eleven Kraken 2 rows against the thirteen the reality map assumed.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
