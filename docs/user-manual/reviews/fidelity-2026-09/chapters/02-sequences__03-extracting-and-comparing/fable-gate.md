# Fable gate: 02-sequences/03-extracting-and-comparing

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `parameters.yaml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener once), two Procedure sections, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. All seven sequence.extract-region settings and all seven sequence.find-orfs settings in the three-sentence shape with the registry labels, grouped by sheet. |
| Every number traceable | Pass. Both FASTA headers with their 0-based starts, the 203 bp flank header, the eight gene records, five CDS records, the 1,424-base CDS span, the 444 / 148 / 147 arithmetic, the ORF at 70658-71060 with 402 nt and its peptide, and `--name-prefix HBB` returning 2, all rerun by the fidelity review. |
| Menu paths and surfaces | Pass. Extract Visible Region... (Cmd-Shift-E, verified in MainMenu.swift), the two Extract Sequence sheets each described with its own controls and destination folder, Copy Visible Region as FASTA (Cmd-Shift-C), Find ORFs..., Delete Track... in the annotation drawer, Extract Reads in Selected Region... on an alignment selection. |
| Fidelity false claims corrected | Pass. The visible-region sheet is now ExtractionConfigurationView with its Action picker, flanks, and Extract button landing in Extractions/, and the annotation sheet lands its bundle in Reference Sequences/. The window deletes tracks. The codon arithmetic is right. |
| Removed content noted | Pass. The SARS-CoV-2 examples, the operations table with its ellipsis and Cmd-Shift-C claims, the Extract button, the Reference Sequences destination for the region route, the wrong mapping menu, and the drag-selects claims were removed under the drift decisions and listed in the author report. |
| Glossary alphabetised | Pass. No new entries. |
| Nav and help-ids | Pass. Title unchanged. Next link now points at 04-aligning-sequences.md (repointed by the Building Trees author). |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The fixed Before-you-start sentences were repeated at the head of both Procedure sections. Kept once, in Before you start.
2. "Budget about twenty-five minutes" had no source. Dropped.
3. "134 triplets counting the terminal stop" contradicted the verified 134 amino acids. Now "134 codons".
4. The visible-region command always passes a plain region (`extractSelectionSequence` builds `.region`, and `presentExtractionSheet` sets `isDiscontiguous` false for a region), so the Concatenate Exons toggle can never appear from the menus and the `[exons concatenated]` token is unreachable. The Settings paragraph, the header-token sentence, and the spliced-product advice now say so.

## Findings for RESULTS.md

`ExtractionConfigurationView` carries a Concatenate Exons control and `presentExtractionSheet(for:)` has an `.annotation` case, but no caller passes an annotation source, so the control is dead in this release. `extract sequence` prints a 0-based start in its header tokens while its length token is the inclusive span.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
