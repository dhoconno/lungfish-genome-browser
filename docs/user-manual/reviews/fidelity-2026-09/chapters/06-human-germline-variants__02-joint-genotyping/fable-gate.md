# Fable gate: 06-human-germline-variants/02-joint-genotyping

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line, Next, in the command-line-only pattern chapter 38 set. |
| Every registry setting present | Pass. Nine flags with the three fixed GATK options and the silent strategy fallback. The registry's gatk-plans entry indexes subcommands rather than per-plan flags, recorded as a Phase 6 registry item rather than restructured here. |
| Every number traceable | Pass. 48,057 GVCF rows to 1,026 cohort rows, 844 SNVs and 182 indels by the first-ALT convention with the position 29224 explanation, the first row's fields, lowest QUAL 31.6, INFO DP mean 39.4 named against the sibling's FORMAT DP 38, 3.30 seconds, the GenomicsDB run's 258 rows ending at 99,174, eight AS_ keys, GATK 4.6.2.0, all from the author's runs and the fidelity review, with the unrecorded step split dropped. |
| Fidelity false claims corrected | Pass. Two dialog entries, three required flags, six of nine siblings covered, the counts. |
| Defects disclosed | Pass. conda install --pack refusing the pack, the silent strategy fallback, the missing --gvcf accepted, the 24-hour limit, each where the reader meets it. |
| Reader consensus | Pass. Twenty-nine of twenty-nine applied. The GVCF is obtainable, the compressed VCF is readable, the terminal is located, every flagged term is glossed. |
| Human example | Pass. HG002 chromosome 20, with the single-sample limitation stated. |
| Glossary alphabetised | Pass. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The pack download estimate became the two sourced sizes with no time.
2. The dictionary's "twenty seconds" and the whole-genome "hours" claims removed as unmeasured.
3. The Reference Files for GATK link text corrected.
4. Reading time raised to 30 minutes.

## Rulings

The 844 and 182 counts and the INFO against FORMAT depth naming stand across chapters 42 and 43. The gatk-plans registry entry stays an index of subcommands for Phase 6 to reconsider.

## Findings for RESULTS.md

`gatk joint-genotype` accepts no --gvcf and composes a CombineGVCFs command with no input at exit 0. An unrecognised --combine-strategy silently falls back to auto. `conda install --pack gatk-core` reports an unknown pack. The tool lock's pinned build no longer resolves.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
