# Fable gate: 06-human-germline-variants/01-haplotype-caller

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`,
`parameters.yaml`, and `mkdocs.yml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (with three subsections), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Five shared dialog controls, nine HaplotypeCaller cli_only flags, six phased cli_only flags. The registry's two threshold effect lines are corrected at the gate. |
| Every number traceable | Pass. 1,026 rows, 844 SNVs and 182 indels by the first-ALT convention recounted by the project manager, 589 het, 418 hom, 19 with two non-reference alleles, mean QUAL 903, first-row QUAL 2175.06, FORMAT DP mean 38 against window depth 44.7, 48,057 GVCF rows with 46,858 reference blocks and 1,199 alternate rows, 373 phased in 125 phase sets with 188 and 185, 961 benchmark records, 23 and 26 seconds, all from the author's runs and the fidelity review. |
| Menu paths and surfaces | Pass. Tools > Call Variants..., the Inspector's Variant Calling tab, the two alerts, the tool sidebar subtitles and both badges, the four sections and their controls, the readiness line, the Operations panel row, the Variants tab and Presets button, the Variant Calling Not Ready alert on the phased entry. |
| Fidelity false claims corrected | Pass. Thresholds discarded not recorded in three places, the phased subsection's six flags, and the two smaller items. |
| Defects disclosed | Pass. The phased dialog entry that cannot run, the two ignored threshold fields, the missing sequence dictionary as a required step, --threads shadowed by the global option, the experimental pack refused by conda install --pack. |
| Reader consensus | Pass. Forty-one of forty-one applied. The experimental sentence sits in Before you start, the terminal-only blocks are marked skippable, every flagged term is glossed. |
| Human example | Pass. HG002 chromosome 20. |
| Glossary alphabetised | Pass. Six new entries. |
| Nav | Pass after the gate edit. The nav label read HaplotypeCaller Dry Runs. The Reference Files for GATK label is fixed in the same edit. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. Two unmeasured durations (mapping, dictionary) removed.
2. Reading time raised to 30 minutes.
3. Registry threshold effects now say discarded rather than recorded.
4. Nav labels for chapters 42 and 45 corrected.
5. CONSISTENCY.md records the gatk variant path exception and the manual-wide count convention.

## Rulings

The 844 and 182 counts stand across chapters 42, 43, and 44. The per-megabase rate stays as an order of magnitude. bcftools and tabix are named as separate managed environments.

## Findings for RESULTS.md

The GATK + WhatsHap Phased dialog entry builds a plan nothing consumes and raises Variant Calling Not Ready. The Call Variants dialog's Minimum Allele Frequency and Minimum Depth are discarded on both GATK entries. LGE never creates the .dict sequence dictionary, so a first GATK run fails until the reader makes it. `variants phase --threads` is shadowed by the root command's global --threads. `conda install --pack gatk-core` reports an unknown pack. `--emit-ref-confidence` falls back to GVCF on an unrecognised value.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
