# Fable gate: 01-foundations/04-alignment-files

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. Concept chapter. What it is, Why you would do this, Before you start, concept sections, What good looks like, On the command line, Next. `parameters_refs` is empty and the mapping dialog's settings are pointed at the mapping chapter. |
| Every number traceable | Pass. Both BAM records, the 91,203 / 91,148 / 55 counts, 44.7 mean depth, 79 maximum, 31 zero-coverage and 505 under-10 positions, 99.77% mapped, 99.99% breadth, the 53 / 20 / 33 pileup with its 16 / 17 strand split, minimap2 2.31 and 4.7 s, all verified by the fidelity review against the fixture BAM, the mapping summary, and the provenance sidecar. |
| Menu paths and surfaces | Pass. Plugin Manager path, coverage track behaviour, mapping results table, Inspector mapping rows. |
| Fidelity false claims corrected | Pass. LGE writes BAI only and reads CSI from imported BAMs (chapter and the glossary CSI entry). Mean depth and breadth live in the mapping results table and the coverage track label, not the Inspector. |
| Removed content noted | Pass. The invented SARS-CoV-2 record and pileup, the HTSlib wording, and the SAM aside were removed under the drift decisions and listed in the author report. The long-read pack is not offered because PluginPack.swift:823-831 lacks isActive. |
| Glossary alphabetised | Pass. CSI under C, Mapping preset and Mark duplicates under M. |
| Nav and help-ids | Pass. Title unchanged, no help-id entry. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The editor's sentence that per-strand counts are "in the Inspector" was unverified. VariantSection.swift lists a variant's INFO fields, so the counts reach the reader as bcftools' `DP4` value. Sentence now says so.
2. `--preset` has no default in `cli-help/map.txt`, so the sentence no longer claims one.
3. `lungfish-cli bam` has seven subcommands, and the chapter listed four as if they were all of them. The three annotate subcommands are now named and deferred.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
