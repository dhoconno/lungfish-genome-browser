# Fable gate: 05-variants/02-reading-the-variant-browser (Reading the Variants Table)

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`,
`parameters.yaml`, `help-ids.yaml`, `mkdocs.yml`, `ARCHITECTURE.md`, and
`CONSISTENCY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Six variants.filter-table settings in the three-sentence shape with the registry labels verbatim, and variants.query's flags in the command-line section. |
| Every number traceable | Pass. 1,918 rows, 874 and 182 by the Type column's first-alternate rule, the 623, 415, and 18 genotypes, the 852, 201, and 9 shared and exclusive positions, the quality ranges, the 1,049 at DP 10 or more, the 339, 517, and 6 allele-fraction groups, coordinate 250527's two rows, and the four query counts, all recounted by the fidelity review. |
| Menu paths and surfaces | Pass. The table drawer and its three tabs, the six toolbar controls, the twelve columns and the promoted INFO columns, the fourteen chips and their four sections, the Profiles pull-down, the Search Builder's categories and operators, the Inspector's rows, and every CLI option. |
| Fidelity false claims corrected | Pass. Region form with the reference name, the Inspector's actual rows, the Search Builder grammar against `--filter`, the 18 multiallelic rows, the Type convention stated. |
| Defects disclosed | Pass. Het Only never offered, the Region silent no-op, the per-sample DP mismatch, and the two grammars. |
| Registry, help-ids, and sheets | Pass. The variants.query and Presets notes corrected, inspector.VariantSection retargeted and redescribed, three help-id anchors match live headings, the retired chapter struck from ARCHITECTURE.md, and CONSISTENCY.md records the bundle create exception and the entry-point ruling. |
| Glossary alphabetised | Pass. Four new entries in place. |
| Nav | Pass. Retitled, with the retired entry removed in the chapter 27 commit. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. An unsourced gene-rich clause dropped, as in chapter 27.
2. The Next paragraph's note about file numbering removed, and the consensus chapter linked by its new title.
3. The help-ids description for the Inspector's Variant section corrected.
4. Reading time raised to 30 minutes.

## Rulings

The Auto ploidy guess (haploid under 10 megabases) is described from source and the reader is told to set Diploid. Phase 5 confirms the chip strip on Auto. The drag-to-reorder and right-click-to-hide affordances stay asserted for Phase 5 to confirm.

## Findings for RESULTS.md

The Het Only chip is defined but never offered. A Search Builder Region value without the reference name is silently ignored. `variants query --filter` accepts per-sample clauses only and `Sample[x].DP` reads a FORMAT DP that bcftools does not write. `bundle create --variant` writes BCF plus CSI. QueryLogic.matchAny is rewritten to matchAll on preset load. The Auto ploidy guess treats any reference under 10 megabases as haploid.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
