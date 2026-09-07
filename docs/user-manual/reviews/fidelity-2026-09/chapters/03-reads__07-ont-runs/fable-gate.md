# Fable gate: 03-reads/07-ont-runs

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`CONSISTENCY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass after a gate edit. The trailing "What this chapter does not cover" section was folded into What it is as a subsection. |
| Every registry setting present | Pass. Four import.ont-run settings and nine fastq.demultiplex-barcodes settings in the three-sentence shape with the registry labels verbatim, colon-terminated labels included, and the Fluidigm split's absence of settings stated. |
| Every number traceable | Pass. 950 reads, 263 to 39,647 bases, mean Q 7.9, 262-fold mitochondrial coverage, the import and demultiplex and scout summaries, the 927-read loss, the 7,495,398 against 4,348,051 base counts, all reproduced by the fidelity review. |
| Menu paths and surfaces | Pass. File > Import Center... and the ONT Run Folder card, the Import FASTQ configuration sheet, Tools > Demultiplexing > both items, the FASTQ/FASTA Operations pane labels, the Operations Panel, and every CLI option. |
| Fidelity false claims corrected | Pass. The imported bundle lands at the project root, with the run-named sibling folder on conflict, and CONSISTENCY.md records the shape. |
| Defects disclosed | Pass. The estimated base count, the 23 silently dropped reads, and the Fluidigm split's post-completion provenance error with its failure exit status. |
| Glossary alphabetised | Pass. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The out-of-template closing section became a subsection of What it is.
2. The command-line paragraph claimed a bundle path and a file path behave the same, which no run showed. It now says the runs used the fixture file copied into `Imports/` and points at the FASTQ inside the bundle for the other case.
3. Reading time raised to 20 minutes.

## Rulings

Settings stay under one heading with the boundary named in prose. No healthy demultiplex summary is invented. The nested-barcode diagram is an illustration candidate for Phase 5, not a prose fix. The CLI input paths stay as run.

## Findings for RESULTS.md

`ONTDirectoryImporter` estimates the manifest base count as compressed bytes times 1.5. Demultiplexing reports the post-loss input count and drops 23 of 950 reads silently. `fastq ont-fluidigm-samples` prints a provenance error after completion and exits 1. An imported ONT run lands at the project root.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
