# Fable gate: 09-genotyping/01-what-is-mhc-genotyping

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass for a concept chapter. What it is, Why you would do this, Alleles loci and haplotypes, the haplotype placeholder, How allele names are built, What LGE offers and where it lives with the enabling route, What counts as a supporting read, What a finished run looks like, What good looks like, Next. |
| Every number traceable | Pass. 970 targets and 362 group records, 13 loci by name, 156 and 244 bases as modes, 198 bases per mate, 2,854,092 in and 682,927 retained at 23.9 percent, the four alignment tallies summing to 1,515,819, 2,109 rows over 30 samples with 2 to 117 each, 23 OK from 1,976 to 58,370 and 7 Low Support from 2 to 713, 11 to 13 loci, minimap2 2.31, Savont 0.6.3, BLAST 2.16.0, all from the author's runs and the fidelity review. |
| Menu paths and surfaces | Pass. Tools > Genotyping with three items each carrying the ellipsis, the (not enabled) suffix, Tools > Workflow Library... with the Specialized Workflows heading, Genotyping group, Enabled switch, Install Dependencies button, the Genotype Matrix view and the Haplotype Calls segment on a haplotyped result. |
| Fidelity false claims corrected | Pass. The group record is the library's verbatim three-member form. Claim 30 hedged. |
| Rulings | Pass. All ten, with the discard tally resolved as alignment records and the indel rule stated from the MD-tag counter. The editor's correction to ruling (f) stands, since the app does define the 1,000-read and 20-alignment Low Support line, and the chapter now matches the CONSISTENCY sample-status ruling. |
| Reader consensus | Pass. Twenty-nine of twenty-nine applied, 61 of 64 others. |
| Macaque example | Pass. The Williams project throughout, with the caveat that it does not ship. |
| Haplotyping placeholder | Pass after the gate edit. Trimmed to the placeholder sentence, the MCM gloss, and one sentence saying the route is undocumented. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The haplotype placeholder section shortened to its placeholder sentence, the MCM gloss, and one sentence.
2. The 198-base sentence rewritten so the number is the covered amplicon length after primer and adapter removal rather than a fragment size.
3. The Next paragraph uses the sibling chapters' current titles and drops the evidence panel, which a genotype-only result never shows.
4. Reading time raised to 30 minutes.

## Rulings

The shot id `genotype-matrix-overview` belongs to this chapter. Chapter 54's nav label follows its title, Running Amplicon MHC Genotyping, to be fixed at that gate. The Inspector tab that holds the provenance record is not named here because no reviewer confirmed it, and Phase 5 confirms it from the window. DRIFT rows 3.13, 3.18, 3.23, 3.24, and 3.25 of the genotyping map are wrong as the chapter 55 review found, and the chapters, not the map, are corrected.

## Findings for RESULTS.md

Every Genotyping submenu item starts greyed until enabled in the Workflow Library, and nothing on screen says so beyond the suffix. The run reports no count of merged pairs. The status `review` exists in the result files but is undocumented.

## Phase 5 notes

Two shots. The submenu shot should show all three items enabled, or one greyed to illustrate the suffix. The matrix shot is the Williams result at `Amplicon genotyping results/`.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
