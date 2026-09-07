# Fable gate: 07-assembly/02-running-spades

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results with the three-assembler comparison, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Thirteen entries covering the three registry entries' settings, with the shared controls documented once and the assembler each appears for named. |
| Every number traceable | Pass. 9,958 pairs, 16,569 bases, the six k values from spades.log, SPAdes 16,697 at 13.7 seconds from the fixture's committed run with 110.7 named once, MEGAHIT 3 contigs of 17,405 with 16,711 longest at 2.7 seconds, SKESA 16,570 at 1.6 seconds, 122-fold from the contig name, GC 44.4 to 44.6, all confirmed by the fidelity review and reproduced on the run that completed. |
| Menu paths and surfaces | Pass. Tools > Assembly > SPAdes..., the Inputs rows, the Read Type row and its locked caption, the Profile popup, the Readiness panel and its messages, the Operations panel, the run folder shape, the summary strip, the six columns and filter, the detail pane, the action bar, the context menu, the layout preference. |
| MEGAHIT caution | Pass. The shared wording sits in the Settings lead and the Threads entry, with no claim that two threads makes it safe, and the MEGAHIT figures are attributed to the run that completed. |
| Fidelity | Pass. Zero false claims, both inconsistencies resolved, all four Notes items applied. |
| Defects disclosed | Pass. Min Contig ignored by SPAdes at its entry and in the command-line notes, MEGAHIT's thread override, Align with MAFFT absent, the MEGAHIT profile default sending nothing. |
| Reader consensus | Pass. Thirty-seven of thirty-seven applied. The control count matches, Careful mode is reconciled with the first-run instruction, the k-mer overlap is shown. |
| Human example | Pass. HG002 mitochondrial reads. |
| Glossary alphabetised | Pass. Two new entries. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The invented Min Contig floor (twice the read length, about 500 bases) removed.
2. The invented coverage bands (tens thin, a hundred comfortable) removed.
3. The Next paragraph's link text now matches the sibling's title and drops the chapter numbers.
4. Reading time raised to 30 minutes.

## Rulings

SKESA's `257.173` stays named as its coverage estimate by analogy with SPAdes' field, stated as a comparison across tools that should not be made. The Min Contig defect's second statement stays in the command-line notes, since the Procedure never names the control. The k values come from the fixture's own log.

## Findings for RESULTS.md

The assembly sheet's Min Contig control is shown and editable for SPAdes but never reaches the command. MEGAHIT's Threads are overridden to 2 on Apple Silicon with no indication in the sheet. `--profile default` for MEGAHIT passes nothing. Align with MAFFT is missing from the assembly contig menu. The Run Mode caption contains a semicolon.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
