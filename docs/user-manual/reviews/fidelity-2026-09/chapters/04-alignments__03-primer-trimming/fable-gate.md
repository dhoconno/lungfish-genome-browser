# Fable gate: 04-alignments/03-primer-trimming

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`. The
editor pass was interrupted by a usage limit and completed by a second
editor that re-verified the whole chapter.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Seven bam.primer-trim settings in the three-sentence shape with the registry labels verbatim. |
| Every number traceable | Pass. Soft-clipped and matched base counts before and after, the record counts, all four iVar summary lines and the fifth, both wrong-scheme lines, the mapping rate, and the iVar version, reproduced by the fidelity review from the scratch BAMs and provenance sidecars. |
| Menu paths and surfaces | Pass. The Inspector's Analysis section and its six tabs, Primer-trim BAM..., the four dialog sections and every control and readiness message, the Operations Panel row, both alert titles, the Provenance and Primer-trim Derivation surfaces, the Import Center's Reference Sequences tab and Primer Scheme card, and every CLI option. |
| Fidelity false claims corrected | Pass. Reference Sequences tab. The unverifiable JSON stream shape reworded. Three DRIFT rows overturned on evidence. |
| Defects disclosed | Pass. A wrong scheme trims silently and the trim rate is the only check. |
| Glossary alphabetised | Pass. BED and iVar in place, the primer-scheme entry corrected by the author. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after the gate edit. |

## Gate edits

1. One unsourced generalisation about typical clinical amplicon run sizes dropped.

## Rulings

The Import Center steps stay in the command-line section with the editor's signpost. The trim-rate threshold stays as a reading rule framed against the two measured runs. The glossary primer-scheme wording is adequate, since the entry no longer claims a FASTA is carried.

## Findings for RESULTS.md

A wrong primer scheme trims with exit 0 and no warning while iVar's summary is captured into provenance and never surfaced. PrimerSchemePickerView shows only the display name although it holds the accession and amplicon count, and the Viral Recon wizard's picker does render a detail line. DRIFT row 17's literal grep missed text interpolated from pack.name.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
