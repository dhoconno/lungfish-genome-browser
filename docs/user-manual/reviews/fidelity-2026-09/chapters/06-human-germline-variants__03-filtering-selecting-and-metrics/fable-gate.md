# Fable gate: 06-human-germline-variants/03-filtering-selecting-and-metrics

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure (seven steps covering all five operations), Settings, Reading the results with three subsections, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Twenty-one flag paragraphs including the added --reference, plus the three shared flags. The gatk-plans registry entry indexes subcommands rather than per-plan flags and omits --preset custom and the two lenient parses, recorded as a Phase 6 registry item. |
| Every number traceable | Pass. 1,026 in and out of the filter, 1,013 PASS with 12 SOR3 and 2 QD2 over 13 rows and the overlap shown, the two QD2 rows' QUAL values, 842 and 182 and 2 by GATK's typing reconciled against the manual's 844 and 182, 836 and 175 PASS with the two MIXED rows explaining 1,011 against 1,013, 19 split rows giving 1,045, 1,013 table rows, the ten metrics figures, 258 rows ending at 99,174, all re-measured exactly by the fidelity review. |
| Prerequisites performable | Pass. The .dict and the reheadered known-sites commands sit in Before you start with the Reference Files for GATK chapter linked, the FASTA is used in Step 4, the terminal is located, and every command block runs from the stated folder. |
| Fidelity false claims corrected | Pass. Nine test header lines plus LowQual. Two unverifiable claims marked inherited. |
| Defects disclosed | Pass. The provenance sidecar overwritten per run, the two silent parses, --preset custom, collect-metrics hiding Picard's error behind exit 3, conda install --pack, each where the reader meets it. |
| Reader consensus | Pass. Forty-three of forty-three applied, including the filter-test table, the labelled VCF row, and the three SNP counts reconciled. |
| Human example | Pass. HG002 chromosome 20. |
| Glossary alphabetised | Pass. Eight new entries. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. An unmeasured reading time for the CLI Reference removed.
2. Three link texts corrected to the retitled sibling chapters.
3. The HET_HOMVAR_RATIO range framed as general guidance.
4. Reading time raised to 35 minutes.

## Rulings

GATK's own SelectVariants typing stays alongside the manual's first-ALT convention with the reconciling paragraph. The open project is described as serving only the pack install, which the editor traced to the absence of any project option on the command. The Ti/Tv expectation of 2 to 3 stands as established genomics guidance.

## Findings for RESULTS.md

The GATK provenance sidecar has a fixed name per output folder, so each --execute overwrites the previous run's record. An unrecognised --preset falls back to best-practices-both and an unrecognised --type is dropped, both silently. --preset custom applies no expressions and has no companion flag. collect-metrics reports exit 3 and hides Picard's dictionary error in the sidecar.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
