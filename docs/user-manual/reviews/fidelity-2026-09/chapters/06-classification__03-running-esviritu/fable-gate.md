# Fable gate: 06-classification/03-running-esviritu

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. classify.esviritu's six controls (Sample, Run Mode, Enable quality filtering (fastp), Min read length:, Threads:, Extra arguments:) each have a paragraph with the on-screen label, default, allowed values, and flag. |
| Every number traceable | Pass. 85,199 pairs, 345.2 seconds on fourteen cores, 127 seconds for the first mapping pass, 162,441 mapped of 170,180 filtered, RPKMF 32,022.4, 1259.4x, 99.7% from the detail pane, OP400692.1 at 29,808 bases, 29,777 covered for 99.90%, thinnest window 319.4, 19,925 assemblies, 895.6 MB, all recounted by the fidelity review from the author's run. |
| Menu paths and surfaces | Pass. Tools > Classification > EsViritu..., the FASTQ/FASTA Operations title, the Sample and Database sections and their states, the Databases tab heading EsViritu Databases, the Operations panel phase strings as unordered matches, the viewport columns, the detail pane pills, the context menu and action bar items, the Export menu's four items, Import Metadata..., the Inspector's three validation states. |
| Fidelity false claims corrected | Pass. Six rows fixed. The unverifiable metadata-persistence claim cut. |
| Defects disclosed | Pass. Identity column printing the raw fraction, the Coverage filter matching breadth, the toolVersion path fragment, each in one sentence where the reader meets it. |
| Reader consensus | Pass. Seventeen of seventeen applied, no invented counts. Unique Reads for the reference run stays unquoted since no run file records it. |
| Glossary alphabetised | Pass. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. A comma splice in the Identity guidance became two sentences, with 95% framed as a rule of thumb.
2. The reference-run table's Segment cell now says the column shows a dash, matching the detail-pane paragraph.
3. Reading time raised to 28 minutes.
4. Hotfix to chapter 33. Its example result folder name used the shape `kraken2-20260907-142310`, which the app never writes. It now reads `kraken2-2026-09-07T14-23-10`, the `AnalysesFolder` shape chapter 32 already documents.

## Rulings

The 345.2 second duration stays, attributed to the reference run and its core count. SRA download size and time stay out until Phase 5 measures them. The two-sparkline illustration request goes to the Phase 5 illustration list. The read-length lookup location and the fraction of known viruses covered stay out for want of a source.

## Findings for RESULTS.md

Identity column renders the stored fraction with a percent sign (1.0% for a 99.7% detection). Coverage column filter compares breadth while the column displays depth. detectToolVersion records a Python path fragment as the EsViritu version. Three disagreeing database sizes across the lock file, the CLI banner, and db-status. install-managed --list omits the EsViritu database. The run log is deleted on success.

## Phase 5 notes

Illustration candidate: two example sparklines, an evenly tiled genome against a spiky pile. Measure the SRR36291587 download size and time.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
