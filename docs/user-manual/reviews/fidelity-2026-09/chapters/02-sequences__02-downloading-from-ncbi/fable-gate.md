# Fable gate: 02-sequences/02-downloading-from-ncbi

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, concept sections, On the command line, Next. |
| Every registry setting present | Pass. All eighteen fetch.ncbi settings and all eleven fetch.pathoplexus settings in the three-sentence shape with the registry labels, the shared scope popup documented once by design, and the repeated labels disambiguated in their first sentence. |
| Every number traceable | Pass. 16,569 bp, 77 features with 13 CDS, 22 tRNA, and 2 rRNA, 64,640 bytes, the checksum, the endpoint, and every sidecar field recomputed by the fidelity review from the fetched record. |
| Menu paths and surfaces | Pass. Tools > Search Online Databases > Search NCBI... and its SRA and Pathoplexus siblings, the GenBank & Genomes pane and its Mode, the Advanced Search Filters panel, Download Selected, the fifty-record confirmation, the Download Center, the Pathoplexus chips and consent notice, the OPEN-only filter, the track names and the GenBank fallback. |
| Fidelity false claims corrected | Pass. The three missing Pathoplexus settings added, ten filters, Download Center rather than Operations Panel, GFF3 rows distinct from GenBank FEATURES rows, `--db protein` as the collection the picker lacks. |
| Removed content noted | Pass. The SARS-CoV-2 example, the imported_annotations.gff3 claim, the feature filter, the Reference Sequences destination, the GUI sidecar claim, the mirror clause, and the timing claims were removed under the drift decisions and listed in the author report. |
| Glossary alphabetised | Pass. Mitochondrial genome under M, RefSeq under R. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The fixed Before-you-start sentence had gained "where Cmd is the Command key". Restored to the sheet's wording.
2. "The whole procedure takes under a minute" had no source, the same class of claim removed from chapters 7 and 9. Dropped.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
