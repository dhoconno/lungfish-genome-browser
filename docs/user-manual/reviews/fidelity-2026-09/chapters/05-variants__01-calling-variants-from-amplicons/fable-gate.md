# Fable gate: 05-variants/01-calling-variants-from-amplicons (Calling Variants)

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`mkdocs.yml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Ten settings across variants.call-lofreq, variants.call-ivar, and variants.call-bcftools in the three-sentence shape with the registry labels verbatim, including the label that ends in a period. |
| Every number traceable | Pass. 1,056 and 862 rows, the 873 and 183 split, the 623, 415, and 18 genotypes, the position 2078 block, the 954 and 808 benchmark matches, the three file sizes, and bcftools 1.24, all recounted by the fidelity review from the author's run artifacts and the committed expected VCFs. |
| Menu paths and surfaces | Pass. Tools > Call Variants..., the Inspector's Variant Calling tab, the dialog's two columns and four sections, the iVar Options section, the readiness messages, the disabled badges as the app draws them, the Operations panel steps, the table drawer's Variants tab and Source column, and every CLI option. |
| Fidelity false claims corrected | Pass. No track preselection, three codon-merge rules with the fixed 0.40 to 0.60 band named, and LoFreq's missing version record. Row for row rather than byte for byte, and the 18 multiallelic rows accounted for. |
| Defects disclosed | Pass. Thresholds reach only iVar, the PASS chip empties a bcftools table, the LoFreq version field holds an error string. |
| Glossary alphabetised | Pass. Seven new entries in place. |
| Nav and help-ids | Pass. Nav title changed to Calling Variants, committed with this chapter together with the retired Cross-Caller Comparison entry's removal. |
| Strict lint | Pass after the gate edit. |

## Gate edits

1. An unsourced clause calling the slice gene-rich was dropped.

## Rulings

Menu items keep three ASCII periods manual-wide. The two requested durations stay out. The three unlinked glossary_refs stay.

## Findings for RESULTS.md

Minimum Allele Frequency and Minimum Depth reach only iVar and are recorded as caller-default for every other caller with no warning. The PASS chip hides every default bcftools row with no empty-state explanation. `IVarCodonMerger` applies a fixed 0.40 to 0.60 merge band that no setting controls. LoFreq rejects `--version`, so its provenance version field holds an error message. The top-level Call Variants item uses a real ellipsis where its neighbours use three periods.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
