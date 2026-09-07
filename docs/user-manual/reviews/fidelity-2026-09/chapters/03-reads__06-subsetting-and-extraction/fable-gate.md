# Fable gate: 03-reads/06-subsetting-and-extraction

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`,
`parameters.yaml`, and the reality map.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Fourteen paragraphs cover the seventeen registry settings, Output Strategy once for all five operations and Use Regular Expression once per operation that has it. |
| Every number traceable | Pass. Every count recomputed by the fidelity review, including 4,473, 10,000, 10,622, 521 as 260 plus 261, 565, 218 plus 45,356, and the 12,058 and 40,507 overlap sweep. The project manager settled the over-count case by running `fastq subsample --count 100000`, which returned all 45,574 reads. |
| Menu paths and surfaces | Pass. Tools > Search & Subsetting > each of the five items, the FASTQ/FASTA Operations window, every readiness message, File > Export > FASTQ... and the sidebar's Export as FASTQ..., Show in Finder, the Operations Panel, and every CLI option. |
| Fidelity false claims corrected | Pass. Direct `Analyses/` output named `<input stem>-<operation>` with a counter on collision. The editor also corrected the command-line-only export claim against source. |
| Registry and reality map | Pass. The fastq.extract-reads-by-motif note now says both strands are searched, and reality-map rows 10 and 24 are annotated. |
| Glossary alphabetised | Pass. Seven new entries in place. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The reads are not all 250 bases (71.1 percent are, per the chapter 21 review). The sentence now says up to 250 with most at the full length.
2. The editor's 9.5 to 10.5 percent tolerance was a synthesis from one run, and the command line is deterministic, so no second run could test it. Replaced with the measured 9.81 percent and a several-points warning.
3. Reading time raised to 25 minutes.

## Rulings

The interleaved layout block stays schematic, since the fixture's headers carry no mate suffix to show. The `--search-end both` note stays in the command-line section.

## Findings for RESULTS.md

`fastq sequence-filter` crashes with a raw Java assertion when round(error rate times minimum overlap) exceeds bbduk's cap of 2, at the dialog's own default error rate. The window runs cutadapt for the same operation. `extract reads --output` always writes gzip. The window and the command line disagree on defaults for Min Overlap (16 against 8), Error Rate (0.15 against 0.1), Keep Matched Reads (on against off), and Search End (5' against both).

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
