# Fable gate: 09-genotyping/04-haplotype-definitions-and-export

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`parameters.yaml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure (three window-only steps), Settings with the command-line-only options, Reading the results, What good looks like, the one-sentence haplotype placeholder, On the command line, Next. |
| Every registry setting present | Pass. Eleven window settings and eight cli_only flags, with the two haplotyped-only controls placed and the write-back control singled out. |
| Every number traceable | Pass. 682,927 reads over 30 samples at 22,764 each, 2 to 58,370, 7 Low Support, 14 blank rows over seven loci, 970 and 305 and 13, 1,478 blanked and 192 removed leaving 113, 929 over 5 to 927 over 3, 2,109 long rows, sampleCount 30 and locusCount 13, 27 columns, five LabKey files, all from the author's exports and the fidelity review's reruns. |
| Fidelity false claims corrected | Pass. Both. |
| Rulings | Pass. All thirteen, with the Procedure window-only, the three text exports moved to the command-line section, the opener clause naming them, the four counts reconciled once, the M tokens explained, the location instruction dropped for want of a recorded reason, and the write-back exception stated. |
| Sample-status ruling | Pass. The 1,000-read Low Support line is the only threshold named, and the worked filter is called one example. |
| Reader consensus | Pass. Twenty-one of twenty-one applied, 63 others, 15 skipped with reasons. |
| Registry | Pass after the gate edit. The wrong-cased source path corrected. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The command-line flag labels wrapped in code spans and the four command blocks tagged as shell, matching the sibling chapters.
2. The sibling link uses chapter 54's title.
3. Reading time raised to 26 minutes.
4. `parameters.yaml`: the genotype.export source list names `GenotypeExportXlsxSubcommand.swift` with its real casing.

## Rulings

The file name `04-haplotype-definitions-and-export.md` stays, since renaming it would break links, and the title Exporting Genotypes carries the meaning. DRIFT row 4.45 closes as not byte-reproducible by embedded timestamp. The Filtered Pivot... gating sentence keeps the registry's wording. The two DRIFT rows citing the wrong-cased file are left as a record.

## Findings for RESULTS.md

On a genotype-only result the Actions menu is hidden and the Audit lens is unreachable, so Filtered Pivot... is the only in-app export. `genotype export` fails under a /private/tmp path because two spellings of one path are compared, writing nothing and leaving a zero-byte lock. The pivot workbook writes 14 blank haplotype rows over a fixed list of seven loci while the data covers 13. Two exports of the same subcommand differ in the workbook's embedded timestamp.

## Phase 5 notes

Three shots on the Williams result, all on the Inspector's View tab with the Genotype Display section scrolled to its Export block, then the save panel, then the pivot sheet in a spreadsheet application.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
