# Fable gate: 01-foundations/03-amplicon-vs-shotgun

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. Concept chapter with no Procedure or Settings. What it is, Why you would do this, concept sections, What good looks like, Next. `parameters_refs` is empty. |
| Every registry setting present | Not applicable. The 0.05 pre-fill is described, and its documentation is pointed at the variant calling chapters. |
| Every number traceable | Pass. 45,574 pairs, 91,148 reads, 500,001 bases, 44.7x and 99.99% from the chr20 fixture; WD28 32,740 reads at 251 bases and the 970 / 577 / 198 allele counts from the Williams project; every scheme's amplicon and primer counts from the bundled manifests, all verified by the fidelity review. |
| Menu paths and surfaces | Pass. Primer Trim tab of the Inspector, the Primer Scheme menu's Built-in and In This Project sections and its Choose Scheme button, Adapter Removal and Primer Trimming as operation names. |
| Fidelity false claims corrected | Pass. Primer Trimming is the operation name, and the bbduk / cutadapt-linked engine choice is described as a command-line flag with the app choosing by primer source. |
| Unverifiable rows | Ruled. Three domain facts stay. Two coverage-shape sentences are now general statements about library types. |
| Removed content noted | Pass. The fastp and samtools ampliconclip claims, the ARTIC release dates, the QIAseq 250 bp figure, the SARS-CoV-2 Ct and viral-fraction passages, the external protocol link list, and the SARS-CoV-2 walkthrough were removed under the drift decisions and listed in the author report. |
| Glossary alphabetised | Pass. Library prep under L, Target enrichment and Tiling under T. |
| Nav and help-ids | Pass. Title unchanged, no help-id entry. Cross-links to the trimming and primer-trimming chapters resolve. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The 0.05 setting was pointed at the Variants and VCF Files chapter, which is a concept chapter with no Settings section. It now points at the variant calling chapters.
2. "The Williams samples are every read exactly 251 bases" generalised from the one sample the author measured. Now names WD28.
3. The `{{ fixtures_refs[] | cite }}` line was removed before review under the STYLE.md ruling.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
