# Fable gate: 05-variants/04-nanopore-variant-calling

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Seven settings across variants.call-medaka and variants.call-clair3 in the three-sentence shape with the registry labels verbatim, and the shared stored setting behind the two model fields stated. |
| Every number traceable | Pass. 950 reads, 1,210 records and 260 supplementary, 4,348,051 bases and 262-fold coverage, mean depth 236, and every Clair3 count (44, 27, 17, 18, 26, 14, 23, 4), the fourteen substitution positions, position 9028's row, the QUAL range and the PASS boundary, all recomputed by the fidelity review from the author's run artifacts. |
| Menu paths and surfaces | Pass. The Import Center cards, Tools > Mapping > minimap2... and the wizard's sections, Tools > Call Variants... and the Inspector's Variant Calling tab, the dialog's sections and both model fields with their placeholder and readiness messages, and every CLI option. |
| Fidelity false claims corrected | Pass. No track preselection, and the PASS quality band replaced by the measured range with position 14229 named. |
| Defects disclosed | Pass. Neither caller completes through LGE, stated at the top, in Before you start, in What good looks like, and in the command-line section, with both causes and the direct Clair3 route given. |
| Glossary alphabetised | Pass. Haplogroup, homopolymer, and medaka in place. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after the gate edit. |

## Gate edits

1. Reading time raised to 30 minutes.

## Rulings

No haplogroup is named, per the fidelity review. The variant track filename is read off the folder rather than guessed.

## Findings for RESULTS.md

Every Medaka run fails in Preview 2026.9.13 because the pipeline calls the `variant` subcommand that Medaka 2.2.2 removed, and its preflight demands a basecaller model in the BAM header that no LGE mapping writes. Clair3 launches without its managed environment on PATH and aborts on the ambient Python, and its CheckEnvs.py cannot read a BAM path containing a space, which every bundle path under Reference Sequences/ does. The two model fields share one stored setting and one flag named for Medaka. `lungfish-cli map` refuses a loose FASTQ with no override flag.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
