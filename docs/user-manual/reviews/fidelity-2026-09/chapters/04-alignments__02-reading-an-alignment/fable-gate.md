# Fable gate: 04-alignments/02-reading-an-alignment

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`,
`parameters.yaml`, and `CONSISTENCY.md`. The first editor was killed by a
usage limit before it wrote anything and a second editor ran the pass.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Sixteen bam.read-display settings and both bam.extract-reads-in-region settings in the three-sentence shape with the registry labels verbatim, in registry order. |
| Every number traceable | Pass. Mean depth, maximum column, breadth, sub-10x and zero positions, the position 2,078 column and its strand split, the MAPQ distribution, the supplementary count, the soft-clip rate, the three read-count totals, and the 91,148 extraction, all measured by the author with samtools and reproduced by the fidelity review. The editor caught three of its own drafted figures against source (the compressed-axis labels and the 0.6 and 0.25 bases-per-pixel tier boundaries). |
| Menu paths and surfaces | Pass. The three viewport bands and tiers, the status bar, the Depth key and the max and mean label, every View Settings control on the Alignment and Reads tabs, Go to Location and Go to Gene, the zoom commands, the context-menu items including Extract Reads in Selected Region..., Copy as FASTA, Extract Reads..., and Show BAM in Finder, the sample banner and Load all, the Selected Read panel, the Inspector summary and its Analysis tabs, and every CLI flag. |
| Fidelity false claims corrected | Pass. One coverage band, the joint max and mean label, Est. Coverage 27.3x as a 150-base estimate, the extraction destination and the absence of a save panel. The registry entry and its notes corrected to match, and CONSISTENCY.md records the exception. |
| Defects disclosed | Pass. The `--region` coordinate limitation and the Est. Coverage assumption. |
| Glossary alphabetised | Pass. Alignment track appears once. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. Flag Stats became Flag Statistics, matching the Inspector and chapter 22.
2. A forward reference to a note at the end of Alignment Quality that does not yet exist was removed.

## Rulings

A group of viewer display settings with no command-line equivalent may state that fact once in the group's lead paragraph instead of once per setting, and CONSISTENCY.md now says so. The screenshot placement and the arrow-key table are Phase 5 items.

## Findings for RESULTS.md

`extract reads --by-region` rejects any `--region` carrying coordinates (BAMRegionMatcher compares the whole string against bare SN names, the error blames the reference name, and the fourth strategy falls back to every reference). The Inspector's Est. Coverage assumes 150-base reads. Extract Reads in Selected Region writes to `alignment-read-extractions/` rather than `Extractions/`, against the 2026-08-22 decision. The live coverage renderer draws one band, and the strand-split `drawCoverage` overload is dead code that misled the reality map.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
