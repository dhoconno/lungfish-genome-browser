# Fable gate: 06-classification/06-blast-verification

Gate run by the project manager (Fable) on 2026-09-07 against the full
text after the editor pass and the scoped follow-up pass, and the diff of
the chapter, `GLOSSARY.md`, and `parameters.yaml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line, a closing section on the other viewports, Next. |
| Every registry setting present | Pass. Reads to submit: with its on-screen colon, the fixed blastn, nt, and five-hit values, and the three cli_only flags. The registry's hidden-column list, slider range, one-read threshold, and drawer counts were corrected by the follow-up pass. |
| Every number traceable | Pass. The 80 and 40 percent bands, the 90 percent identity, 80 percent coverage, and 1e-10 Verified rule, the 10, 15, and 30 second polls and ten-minute ceiling, the ten-second pacing and fifty-per-hour ceiling, the longest-five-or-a-quarter sampling, the two live runs with their request IDs, and 21.7 MB, all cited to source or to the author's runs by the fidelity review. |
| Menu paths and surfaces | Pass. BLAST Verify in the action bar, BLAST Matching Reads..., the popover title, the drawer's two tabs, six default and five hidden columns, the context menu, the two drawer buttons, Export, and the per-viewport right-click wording. |
| Fidelity false claims corrected | Pass. Seventh column, no Copy Taxon ID, the NVD drawer's confidence word. |
| Defects disclosed | Pass. The gzipped --source failure with its misleading message, the NVD confidence word on a single contig. |
| Reader consensus | Pass. All 44 rows of the final merge addressed, verified by the follow-up pass. |
| Worked example honesty | Pass. Two reads, the timed-out five-read attempt, and the default of 20 all stated, with the small-sample warning pointed at the example itself. |
| Glossary alphabetised | Pass. Three new entries, representative-read corrected. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The 1e-5 working cutoff, which had no source, now points at the Verified rule's 1e-10.
2. The What good looks like thresholds (95, 90, 1e-20) now defer to the sourced Verified rule instead of a second unsourced set.
3. The conflicting-organisms count is framed as a rule of thumb.
4. Reading time raised to 24 minutes.

## Rulings

Dot colours and the read-length floor stay out. The "day or so" NCBI retention stays as general guidance. DRIFT row 13 of the Part A record keeps its original wording as a historical record, with this gate noting that the drawer hides five columns, and the EsViritu ground-truth row 29 is settled true by the author's source check.

## Findings for RESULTS.md

`blast verify --source` cannot read a gzipped FASTQ and reports no matching reads. The taxonomy viewport offers no Copy Taxon ID item, so the taxid comes from the table's Tax ID column or the kreport's seventh column. The NVD viewport never sets a presentation style, so a single-contig BLAST shows a Supported or Unsupported word that has no supporting share behind it.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
