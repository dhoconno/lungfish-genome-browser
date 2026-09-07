# Fable gate: 03-reads/08-read-processing

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`mkdocs.yml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Twelve settings across the six operations in the three-sentence shape with the registry labels verbatim, Output Strategy on all six. |
| Every number traceable | Pass. Merge, repair, error-correction, orientation, reverse-complement, and translation figures all recomputed by the fidelity review, and the sibling bundle names checked against operationKindString at the gate. |
| Menu paths and surfaces | Pass. Tools > Read Processing > each of the six items, the FASTQ/FASTA Operations dialog and its pane labels and readiness messages, the FASTQ viewport's Operations tab checkbox, the Operations panel, the Plugin Manager, and every CLI option. |
| Fidelity false claims corrected | Pass. Read lengths up to 250, the pairedEndMerge bundle name, glossary_refs and fixtures_refs. The wrong DRIFT row on Output Strategy is struck. |
| Defects disclosed | Pass after gate edits. |
| Glossary alphabetised | Pass. |
| Nav and help-ids | Pass. Nav entry added under Reads (FASTQ) after ONT Runs. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The Orient Reads procedure and its command-line example ran the chromosome 20 reads against the chromosome 20 reference, the exact case the author found orients nothing and writes an empty bundle with no warning. Both now use the mitochondrial reads and reference the author actually ran (927 of 950), Before you start names the two extra files, and the defect is stated in the procedure and the command-line section.
2. The `fastq interleave` quality defect (Phred 2 rewritten as Phred 0) is disclosed beside the interleave paragraph, since the chapter's command-line example starts with that command.
3. The editor's synthesised 20-reads-per-position threshold for error correction replaced by a hedge.
4. Reading time raised to 30 minutes.

## Rulings

The fixed Before-you-start sentences and the GitHub download wording stay as CONSISTENCY.md sets them.

## Findings for RESULTS.md

`fastq interleave` re-encodes Phred 2 as Phred 0 (reformat.sh without qin=33 qout=33, FastqCommand.swift near 2395). `fastq orient` and the Orient Reads dialog against a single long reference record orient nothing and write an empty output with exit 0 and no message. The Output Strategy picker is on all six read-processing operations.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
