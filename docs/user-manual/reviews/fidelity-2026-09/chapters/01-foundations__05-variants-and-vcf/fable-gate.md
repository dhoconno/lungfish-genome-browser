# Fable gate: 01-foundations/05-variants-and-vcf

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. Concept chapter. What it is, Why you would do this, Before you start, concept sections, Reading a variant track in LGE, What good looks like, On the command line, Next. `parameters_refs` is empty by ruling and every caller setting is pointed at the variant calling chapters. |
| Every number traceable | Pass. Both caller rows at 250,527, the indel at 5,839, the benchmark GT and DP, header counts 30 / 19 / 235, record counts 1,056 / 862 / 961, FILTER tallies, and benchmark matches 954 / 1,053 and 808 / 861 all verified byte for byte by the fidelity review against the committed fixture files. |
| Menu paths and surfaces | Pass. Variants tab of the table drawer, Presets button and its chips, the four built-in profiles, the fourteen smart tokens, the Query Builder's seven categories and Match All, the Inspector fields, and the four `variants` subcommands verified after the editor's corrections. `--caller` values match `cli-help/variants.txt`. |
| Fidelity false claims corrected | Pass. The storage claim now reads `.vcf.gz` plus `.tbi` plus `.db`, the gitignore sentence is gone, header counts are right, the Presets disclosure and the fixed column set are described, the token and subcommand lists are complete, and the LoFreq version sentence says where the number came from. The drift report's own BCF correction was wrong and is recorded in CONSISTENCY.md. |
| Removed content noted | Pass. The invented SARS-CoV-2 VCF excerpts, the SQLite storage claim, the invented FILTER flags, `Presets > PASS`, the colour claim, and the viral haploid and wastewater passages were removed under the drift decisions and listed in the author report. |
| Glossary alphabetised | Pass. Six new entries under B, F, H, S; FILTER, FORMAT, Genotype, BCF, and Smart-filter token corrected in place. `strand-bias` anchor resolves. |
| Nav and help-ids | Pass. Title unchanged, no help-id entry. |
| Strict lint | Pass with no gate edits. |

## Notes for Phase 5

The `vcf-row-anatomy` and `filter-flag-cartoon` illustration briefs were rewritten, so their existing PNGs are stale and need regenerating before the build.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
