# Fable gate: 07-assembly/03-running-flye-or-hifiasm

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure (three steps), Settings with a command-line subsection, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Eight entries covering the fourteen registry settings (seven per tool, six shared) and the five cli_only flags, with the two ignored flags disclosed. |
| Every number traceable | Pass. 950 and 363 reads with their base totals and the 262-fold and 301-fold arithmetic, Flye 16,359 bp at 43.9 percent GC in 35.2 seconds with the 210 bp and 1.3 percent shortfall, hifiasm 33,140 bp at 44.4 percent in 5.9 seconds and its 2.0002 ratio, the 32,652 bp doubled branch at multiplicity 4, 16,569 bp for NC_012920.1, all from the author's runs and the fidelity review's reruns. |
| Menu paths and surfaces | Pass. Tools > Assembly > Flye... and Hifiasm..., the Inputs rows and Detected row, the Assembler picker's narrowing, the locked Read Type note, both Profile sets, the Curated extra arguments disclosure and its four read-only descriptions, Reassemble... and Show in Finder on the sidebar menu, the summary strip and six columns, the no-contigs message, the three refusal strings. |
| Fidelity false claims corrected | Pass. The haplotype graph names carry the project prefix. The unverifiable mechanism claim hedged. |
| Defects disclosed | Pass. The two ignored command-line flags, the exit-0 refusal, the viewport hiding circularity and multiplicity, the doubled circle on both tools. |
| Flye reruns | Pass. Three of four runs plus the committed fixture at 16,359 bp, one doubled, framed as a rare branch with a check and a remedy. |
| Reader consensus | Pass. Forty-three of forty-three applied, with the run folder reachable through Show in Finder and every flagged term glossed. |
| Human example | Pass. HG002 mitochondrial long reads. |
| Glossary alphabetised | Pass. Three new entries. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. An unsourced claim about Apple's chip lineup removed.
2. The unmeasured "hours" for real genomes became a proportional statement.
3. The rerun success wording softened to match three of four.
4. Reading time raised to 28 minutes.

## Rulings

The semicolon ban does not reach GLOSSARY.md entries that quote on-screen text, but glossary prose follows the same rules. The Plugin Manager install button label stays as chapter 33 wrote it. The fixture's Flye length assertion is a Phase 6 item, since the doubled branch will make a regenerate assertion flake.

## Findings for RESULTS.md

`assemble` accepts `--memory-gb` and `--min-contig-length` for Flye and hifiasm and ignores both silently. The multi-input refusal on the command line exits 0. The assembly viewport shows no circularity or multiplicity column, so a doubled circular contig looks healthy. Flye 2.9.6 rarely doubles a small circular genome on identical input, and hifiasm always does on the mitochondrial fixture alone.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
