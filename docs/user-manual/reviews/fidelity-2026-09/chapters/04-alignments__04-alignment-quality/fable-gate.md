# Fable gate: 04-alignments/04-alignment-quality

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`parameters.yaml`. The first fidelity reviewer and all four readers were
killed by a usage limit before writing and were rerun.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Eight bam.filter settings in the three-sentence shape with the registry labels verbatim, and bam.mark-duplicates' absence of settings stated. The Name for New Alignment default corrected in the registry to match. |
| Every number traceable | Pass. The five Inspector figures, the flagstat rows, 1,684 duplicates, the 89,107 filtered records with their four-way breakdown, the three mean depths, the MAPQ counts, the deduplicated 89,519, and both CLI transcripts, all reproduced by the fidelity review two independent ways. |
| Menu paths and surfaces | Pass. The Inspector's Bundle and Analysis tabs, Flag Statistics and Per-Chromosome, the Filtering, Export, and Annotations tabs and every control on them, the confirmation sheets' wording, the Operation in Progress alert, the View Settings toggle the marking run flips, and every CLI option. |
| Fidelity false claims corrected | Pass. Est. Coverage 27.3x at four sites, no operation lock and no Operations panel row for either duplicate workflow, the auto-filled name, and the author's orphaned-file claim withdrawn. |
| Defects disclosed | Pass. The 150-base estimate, the missing lock, the missing panel row, and the in-place command-line marking. |
| Glossary alphabetised | Pass. Duplicate rate and Edit distance in place, and the flagstat entry now says Flag Statistics. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. Two unsourced generalisations dropped or softened (200x meaning over-amplification, and a fixed 80 percent amplicon duplicate rate).
2. Reading time raised to 30 minutes.

## Rulings

The filtered-alignment procedure stays as prose under the two-list cap. The Flag Stats naming in the glossary was fixed by the controller.

## Findings for RESULTS.md

`runMarkDuplicatesWorkflow` and `runCreateDeduplicatedBundleWorkflow` have no canStartOperation guard and never register with OperationCenter, so a marking run can start on a bundle another operation is mutating and posts no row. `lungfish-cli markdup` marks in place while the Inspector button writes new tracks and deletes the old ones. The Inspector's Est. Coverage assumes 150-base reads.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
