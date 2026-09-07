# Fable gate: 02-sequences/04-aligning-sequences

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`,
`mkdocs.yml`, and `illustrations.yaml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Eleven msa.mafft, nine msa.view, and five msa.export settings in the three-sentence shape with the registry labels, and import.msa's absence of settings stated. |
| Every number traceable | Pass. 5 rows, 17,247 columns, the five input lengths, 672 and 835 gaps, 5,053 variable columns, the consensus length and 479 N, the identity matrix, MAFFT 7.526 and FFT-NS-2, all recomputed by the fidelity review from the scratch bundle. |
| Menu paths and surfaces | Pass. Tools > Multiple Sequence Alignment > MAFFT..., the operations dialog and its FASTQ/FASTA Operations title, the scope picker and its summary line, Strategy reads Automatic, the Advanced Options group, the Import Center's Alignments tab and its card, every viewport control and context-menu item, the export sheet and its 5 MB cap, Analyses/Multiple Sequence Alignments/ as the destination. |
| Fidelity false claims corrected | Pass. The scope picker's visibility and stored default, the Batch Output row's visibility and label, the Format row hiding, and the `.lungfishref` output of Extract Selection to New Bundle. The consensus-threshold disclosure stays. |
| Removed content noted | Pass. The tree half of the old chapter went to Building Trees, and the MUSCLE and Clustal Omega table was dropped as documenting tools LGE does not run. |
| Glossary alphabetised | Pass. Alignment column, Consensus sequence, Conservation, Gap, Homologous in place. |
| Nav and help-ids | Pass. Nav entry swapped to the new file. help-ids entries naming the retired chapter id are retargeted at the Building Trees gate. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The Next paragraph named Building Trees without a link. Linked to 05-building-trees.md.
2. The msa-column-homology illustration lived under the retired chapter's asset folder. Folder moved to 04-aligning-sequences with `git mv`, and the chapter and `illustrations.yaml` updated. The tree-anatomy path in `illustrations.yaml` was updated to 05-building-trees at the same time.

## Findings for RESULTS.md

The consensus Low support slider defaults to 50 percent while `msa consensus --threshold` defaults to 0.6. The chapter discloses both.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
