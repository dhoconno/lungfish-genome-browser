# Fable gate: 09-genotyping/03-reading-the-genotype-comparison

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure (five steps), Settings, Reading the results, What good looks like, the haplotype placeholder, On the command line, Next. |
| Every control present | Pass. The four pinned columns and their header menu, the search field with its two query forms, the six quick buttons with four named as haplotype-only, every Genotype Display control including Rows... and Columns..., Reset Visibility, Cell Color, Content Text Size, Filtered Pivot..., and the Matrix Annotations controls, each placed in its Inspector tab. |
| Every number traceable | Pass. 970 by 30 and 2,109 filled at about 7 percent, 305 rows with a call, 342 MHC-B and 222 MHC-DRB and 5 each for MHC-F and MHC-J, the 1,000-read and 20-alignment Call-support check, 23 and 7, 1,976 to 58,370 and 2 to 713, 11 to 13 of 13 loci, the two command outputs, all from the author's runs and the fidelity review's reruns. |
| Fidelity false claims corrected | Pass. Seven of seven. Step 2 no longer documents the hidden cohort summary and the Smart Cohorts paragraph is gone. |
| Rulings | Pass. All twelve, with the shot renamed to genotype-matrix-reading, the three depth numbers told apart once, the locus count routed to top_calls_by_locus, and the orders-of-magnitude claim cut after the editor checked the bundle. |
| Reader consensus | Pass. Thirty-one of thirty-one applied, 48 others, 8 skipped for the cut panel and the fixed placeholder. |
| Sample-status ruling | Pass. The chapter matches the CONSISTENCY ruling and chapter 53. |
| Command-line opener | Pass after the gate edit. The clause now names the cohort depth check as the one thing the command line alone offers, and the duplicate paragraph is removed. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The fixed opener's clause replaced and the redundant exception paragraph removed.
2. The Next link uses chapter 56's current title, Exporting Genotypes.
3. Reading time raised to 30 minutes.

## Rulings

The shot id genotype-call-evidence stays, with the caption describing the sample workbench that a genotype-only result actually shows. The genotyping reality map's rows 3.13, 3.18, 3.23, 3.24, and 3.25 and its call-evidence shot row are wrong, and the chapter rather than the map is corrected.

## Findings for RESULTS.md

The cohort summary panel is hidden on a genotype-only result by design, with two tests asserting it, so the cohort-level counts it builds are never shown. The matrix's own filter field and locus popup are built and hidden. Smart Cohorts is not rendered on a genotype-only result and its guard is doubled. The summary section title renders its threshold as Below 5.0K reads.

## Phase 5 notes

Three shots on the Williams result. The evidence shot needs one sample column selected. The Inspector shot needs the View tab's Genotype Display section in frame. Confirm from the window that the detail pane opens blank and that no filter row sits on the matrix itself.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
