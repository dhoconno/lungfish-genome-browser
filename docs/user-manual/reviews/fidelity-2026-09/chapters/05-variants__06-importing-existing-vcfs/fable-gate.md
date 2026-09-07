# Fable gate: 05-variants/06-importing-existing-vcfs

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`parameters.yaml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. The import.vcf entry now carries the Import profile setting with its on-screen colon, matched verbatim by the chapter, and the two command-line-only flags. |
| Every number traceable | Pass. 961 records, 961 PASS, quality 50 throughout, 809, 77, and 75 by the bundle's classifier against 809, 74, 64, and 14 from the command line, 571, 374, and 16 genotypes, position 250,527, one difference per 520 bases, and the quoted Summary block, all recounted by the fidelity review. |
| Menu paths and surfaces | Pass. The Import Center's Variants tab and VCF Variants card, the Operations panel row and its profile name, the Operation in Progress alert, the Name Imported Variant Bundle alert, the No Active Project alert, the Settings picker, and every CLI option. |
| Fidelity false claims corrected | Pass. The permission check's scope, the `--format` option, and the 5,000-row cap belonging to `variants query` alone. The manifest-count and Source-column claims qualified. |
| Defects disclosed | Pass. The wrong manifest count on a never-opened bundle, the ignored `--format`, the BCF plus CSI storage on the command-line path. |
| Glossary alphabetised | Pass. Variant-only bundle in place. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The Next paragraph linked two directories. It now links the first Classification chapter.
2. Reading time raised to 25 minutes.

## Rulings

The reference download size stays unquoted until Phase 5 measures it. The fixed Before-you-start sentences stay. The drop-onto-viewport import and the profile on the standalone path are Phase 5 checks.

## Findings for RESULTS.md

`bundle create --variant` writes variant_count 0 to the manifest until the window opens the bundle. `importVCFToBundle` has no menu item, so features.yaml's File > Open VCF entry is unreachable. The Settings picker tags Low Memory as lowMemory against the enum's low-memory and omits ultraLowMemory. `import vcf --format` is accepted and ignored. The CLI and the bundle database classify variant types differently, and a CLI-built database has no source_file column.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
