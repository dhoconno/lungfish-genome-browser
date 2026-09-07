# Fable gate: 03-reads/03-quality-control

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. The one fastq.refresh-qc-summary setting, Output Strategy, in the three-sentence shape with both values. The registry entry was never changed, and the fidelity review confirmed the picker offers both Per Input and Grouped Result. |
| Every number traceable | Pass. The nine card values as the cards render them (249 not 248.6), the three histograms, the four per-position figures, the paired command-line figures, the min and max read lengths, and the N50 and Phred worked examples, all recomputed. |
| Menu paths and surfaces | Pass. Tools > QC & Reporting > Refresh QC Summary..., the FASTQ/FASTA Operations window and its Primary Settings text, the Operations Panel, the Click to Compute sparklines and their Quality Report row, the Reads tab, the import sheet's Quality Binning control and its None (preserve original) value, and every CLI option. |
| Fidelity false claims corrected | Pass. Mean Length card, the mean-versus-median lesson, statistics of the same shape, the full refusal message, the two domain thresholds reconciled to one attributed rule of thumb and a whole-genome GC figure. |
| Removed content noted | Pass. Unsourced duration removed by the editor. |
| Glossary alphabetised | Pass. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after the gate edit. |

## Gate edits

1. The second full "Lungfish Genome Explorer" in What it is became LGE, per the naming rule the editor asked for a ruling on.

## Rulings

The Operations Panel stays folded into step 5 rather than becoming a sixth step, since the bullet cap is a hard rule and the run does not depend on the panel. The reading-time estimate of 18 minutes stands.

## Findings for RESULTS.md

The Mean Q card is seqkit's error-probability average while `fastq qc-summary` reports the arithmetic mean, and Q20 and Q30 also differ slightly between the two because seqkit rounds to whole percents. The Mean Length card rounds to a whole base.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
