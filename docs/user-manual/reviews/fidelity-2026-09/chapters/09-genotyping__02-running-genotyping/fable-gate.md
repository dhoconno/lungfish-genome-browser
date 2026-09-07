# Fable gate: 09-genotyping/02-running-genotyping

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`mkdocs.yml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure (seven steps), Settings with a command-line subsection, Reading the results, What good looks like, the one-sentence haplotype section, On the command line, Next. |
| Every registry setting present | Pass. Sixteen window settings and seventeen cli_only flags, each with effect, default, when to change, and flag, and the Min Reads defect stated inside its own entry. |
| Every number traceable | Pass. 30 bundles at 180 MB, 970 targets with 198 at 244 bases, 156 and 244 and 198, 329 and 55 seconds, 2,854,092 and 682,927 at 23.9 percent, 505,528 and 119,146 at 23.6 percent, the four drop counts, 682,928 alignments, 23 and 7, 2 to 58,370, 1,976 to 58,370 and 2 to 713, 2 to 117 rows with a median of 80, 2,109, 104 for WD1, 3,598 DRB reads, 293 rows under Min Reads 50, 67 tool invocations, all from the author's runs and the fidelity review's reruns. |
| Menu paths and surfaces | Pass. Tools > Genotyping items, the Reference group and Project Reference menu shared by both routes, the batch caption, the mode caption, the Haplotyping group and its three segments, Advanced Options on both routes, the two results folders, the Workflow Library route for the full-length item. |
| Fidelity false claims corrected | Pass. Seven of seven, including the /private/tmp cause and the two-bundle minimum. |
| Sample-status ruling | Pass after the gate edit. One sentence still drew a 100-read line, replaced with the whole-plate row range. |
| Reader consensus | Pass. Twenty-seven of twenty-seven applied, 74 of 79 others. |
| Macaque example | Pass. The Williams plate throughout, with the no-substitute caveat stated once. |
| Nav | Pass after the gate edit. The label follows the chapter title. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The allele-row sentence no longer draws a 100-read line, per the CONSISTENCY sample-status ruling.
2. The command-line-only flag labels wrapped in code spans, matching chapter 50.
3. The appendix link text and the About menu path aligned with the manual's names.
4. Reading time raised to 34 minutes.
5. `mkdocs.yml`: the nav label is Running Amplicon MHC Genotyping.

## Rulings

The two retained figures stay labelled as two runs at every mention. The /private/tmp failure is described by its spelling cause with the working advice, and the same defect is recorded for chapters 56 and 57. The world-writable explanation is withdrawn.

## Findings for RESULTS.md

Min Reads and `--min-support` are recorded but never filter a genotype-only run. An output directory under /private/tmp fails at 84 percent after all the work with a misleading outside-the-bundle message, because two path spellings are compared. `genotype-cohort` enforces an undocumented two-bundle minimum. The reality map misfiles Savont Clustering under Tools > Genotyping.

## Phase 5 notes

Five shots. The run dialog and analysis-mode shots come from the miSeq dialog with the demo or Williams bundles selected. The full-length dialog shot needs that workflow enabled first and should keep Keep Intermediates in frame.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
