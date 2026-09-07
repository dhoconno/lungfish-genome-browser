# Fable gate: 04-alignments/01-mapping-reads-to-a-reference

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Fourteen settings across the four mapping wizards in the three-sentence shape with the registry labels verbatim, colon-terminated labels included, and import.bam's absence of settings stated. |
| Every number traceable | Pass. All four mappers' flagstat figures, the supplementary counts, mean depth, median MAPQ, coverage breadth, and the tool versions, reproduced by the fidelity review from its own flagstat runs. |
| Menu paths and surfaces | Pass. Tools > Mapping and its four items, every wizard section and control label, the Input Compatibility block verbatim, the Operations panel row and its five pipeline steps, the Inspector's five rows and Flag Statistics list, the Import Center's BAM/CRAM Alignments card, and every CLI option. |
| Fidelity false claims corrected | Pass. Flag Statistics, the timestamp shape, CRAM staying CRAM. The identical-methods provenance claim dropped. |
| Removed content noted | Pass. The unreachable FASTQ/FASTA Operations mapping path and its planned shot are gone. |
| Glossary alphabetised | Pass. Six new entries in place. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The reference-import link pointed at a file that does not exist. It now points at Importing and Viewing a Sequence.
2. The UUID explanation of the track identifier was the claim the reality map lists as unverifiable, so it is gone. A sentence records that adoption moves the BAM into the bundle, which Task 3.9 established.
3. Reading time raised to 25 minutes.

## Rulings

The colon-terminated registry labels stay verbatim. The behaviour of a space typed into the ID field stays undocumented. The measured 4.8 second runtime stays, attributed to the run and the machine.

## Findings for RESULTS.md

`lungfish-cli map` prints the flagstat record count under the label Total reads. `showFASTQMappingOperations` and `showWorkflowOperations` in MainMenu.swift have no bound menu item. A CRAM import stays CRAM.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
