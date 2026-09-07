# Fable gate: 06-classification/07-running-freyja

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`parameters.yaml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Seven cli_only flags, seven paragraphs, in registry order. The registry's --dry-run and --extra-args effect lines are corrected at the gate to match the chapter. |
| Every number traceable | Pass. 16,779 variant rows, 29,903 depth rows, 16.7 seconds, twelve lineages with BQ.1 at 0.62326010 and BE.1.1.1 at 0.34613150, resid 12.29, coverage 99.51, the 0.9885 sum, the 22 March 2026 barcode date, --eps 0.001 and --covcut 10 from the tool's help, 21.7 MB and 1.5 GB, all from the author's six runs and the fidelity review. |
| Menu paths and surfaces | Pass. The Settings > Advanced toggle and its label confirmed in source by the editor, the Packs tab card and Install All, the conda install form, the output file names, the sidecar fields. |
| Fidelity false claims corrected | Pass. Both rows fixed with the fixed experimental-features sentence. Three unverifiable rows hedged or left to the gate. |
| Defects disclosed | Pass. The hidden pack, the demix result record without checksum or size, stderr absent on both paths, --sample never passed, the silent empty variants table from a bare freyja. |
| Reader consensus | Pass. Eighteen of eighteen applied. The terminal-only warning now opens What it is and Before you start. Step 1 is performable by full path. |
| Thresholds | Pass. No residual or abundance-total threshold quoted, since the tool's own help and metadata give none. |
| Glossary alphabetised | Pass. Five new entries in place. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. Two unmeasured download-time inferences removed, leaving the sourced sizes.
2. The 40 percent coverage figure in What good looks like is now an illustration rather than a cutoff.
3. Reading time raised to 28 minutes.
4. Registry effect lines for --dry-run and --extra-args brought into line with the chapter.

## Rulings

The Pango naming-cadence guidance stays as guidance. The unmanaged `freyja variants` step stays, with its silent-failure warning, since LGE does not wrap it. The screenshot recipe must turn on Show Experimental Features before capturing the pack card, recorded for Phase 5.

## Findings for RESULTS.md

The Wastewater Surveillance pack is hidden from the Packs tab in Preview builds unless experimental features are on, while the CLI installs it regardless. FreyjaDemixPlan records the output file before the run and never refreshes it, so the result carries no checksum or size. The sidecar omits stderr on success and failure. `freyja variants` with a bare program name not on PATH writes an empty table and exits 0.

## Phase 5 notes

Turn on Show Experimental Features before capturing plugin-manager-wastewater-pack.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
