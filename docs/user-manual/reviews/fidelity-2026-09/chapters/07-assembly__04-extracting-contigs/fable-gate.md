# Fable gate: 07-assembly/04-extracting-contigs

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`parameters.yaml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings (two window settings and a command-line-only subsection), Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Contig selection, Bundle name, and the eight cli_only flags. The registry's context-menu entry point is corrected at the gate. |
| Every number traceable | Pass. 16,711, 362, and 332 bases at 96.01, 2.08, and 1.91 percent, 44.3 against 44.4 percent GC, 17,073 bases for two contigs, 16,569 for NC_012920.1, the 142 base overshoot, 2.70 seconds, all recomputed by the fidelity review from the author's runs. |
| Menu paths and surfaces | Pass. The six contig columns, the action bar's four buttons and their retitling, the Operations panel row title, the Reference Sequences destination, the context menu's five items and separator with Extract to New Bundle..., the Extract Sequence dialog's two controls, the Derived Subset block, the failure alert. |
| Fidelity false claims corrected | Pass. Four rows fixed, plus a fifth the editor found by reading the Extract Sequence dialog's source (it takes whole contigs, not a sub-range). Three unverifiable rows hedged. |
| Defects disclosed | Pass. Create Bundle recording Assembler Unknown, Align with MAFFT absent from the menu, the sidebar and disk collision suffixes differing. |
| Reader consensus | Pass. Thirty-six of thirty-six applied. The MEGAHIT caution and the single-contig SPAdes alternative sit in Before you start. |
| Human example | Pass. HG002 mitochondrial reads. |
| Glossary alphabetised | Pass. Derived bundle in place, the dead variant anchor replaced. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The example run-folder name now has the app's timestamp shape, with one sentence explaining why the command-line examples use a hand-named folder.
2. Two directory links in Next replaced by plain text and a first-chapter link.
3. Reading time raised to 22 minutes.
4. The registry's context-menu entry point renamed to Extract to New Bundle....

## Rulings

The Reference Sequences destination stands as a recorded exception to the Extractions rule (already in CONSISTENCY.md). The ZIP download size, the json and tsv summary shapes, and the Export FASTA panel's pre-filled name stay out for want of a source. DRIFT claim 14's second half is wrong and is left as a historical record.

## Findings for RESULTS.md

The assembly viewport's Create Bundle button passes --contigs rather than --assembly, so window-made bundles record Assembler Unknown. Align with MAFFT never appears in the assembly contig menu because the handler is not passed. The derived bundle's collision suffix reads -subset 2 in the sidebar and _2 on disk.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
