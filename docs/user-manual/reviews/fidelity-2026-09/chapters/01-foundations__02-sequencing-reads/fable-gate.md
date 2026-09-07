# Fable gate: 01-foundations/02-sequencing-reads

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. Concept chapter. What it is, Why you would do this, Before you start, then concept sections, How LGE shows a read set, What good looks like, Next. No Procedure or Settings, and `parameters_refs` is empty. |
| Every registry setting present | Not applicable, no operation documented. |
| Every number traceable | Pass. Record headers, lengths, quality characters, 45,574 pairs, 182,296 lines, 22,662,846 bases, N50s, Q averages, and 44.7x / 99.77% all verified by the fidelity review against the committed files. Quality decodes (D to Q35, ( to Q7, ~ to Q93) rechecked by hand. |
| Menu paths and surfaces | Pass. Nine cards, three sparklines, Operations and Reads tabs, 1,000-record preview, Refresh QC Summary under QC & Reporting. |
| Fidelity false claims corrected | Pass. Rows 37 and 42 applied verbatim. Row 43 ruled true and now names `lungfish-cli fastq qc-summary`. |
| Removed content noted | Pass. The invented SRR record, the interleaved-storage claim, fastp --merge, FastQC and BWA, and the SARS-CoV-2 coverage targets were removed under the drift decisions and listed in the author report. |
| Glossary alphabetised | Pass. Four entries (CCS, Insert size, Interleaved FASTQ, Read) each under the right letter. |
| Nav and help-ids | Pass. Title unchanged, no help-id entry for this chapter. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The editor's expansion "fastp for trimming and quality reporting" was wrong. The viewport's summary statistics come from `seqkit` (FASTQDatasetViewController.swift, seqkit stats). Sentence now names fastp for trimming and seqkit for the statistics.
2. The fixture read files are renamed from `.R1`/`.R2` to `_R1`/`_R2` because the Import Center pairs only underscore suffixes (FASTQImportConfiguration.swift:181-185). Every file name in the chapter updated, and one sentence added saying a dot-delimited name imports as two single-end bundles.
3. The read-count rule contradicted its own example (a 30 kb genome at 30 to 50x needs thousands of pairs, not hundreds of thousands). Rewritten so the arithmetic and the amplicon practice are both stated.
4. The `{{ fixtures_refs[] | cite }}` line had already been removed by the editor.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
