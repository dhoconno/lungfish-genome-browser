# Fable gate: 02-sequences/05-building-trees

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`,
`mkdocs.yml`, `help-ids.yaml`, `illustrations.yaml`, the imagegen
`manifest.json`, and `ARCHITECTURE.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Thirteen tree.iqtree settings, two tree.reroot, three tree.extract-subtree, and import.tree's absence of settings, each in the three-sentence shape with the registry label verbatim. Both Replicates paragraphs say the field reads plain Replicates on screen. |
| Every number traceable | Pass. 5 tips, 3 internal nodes, the five branch lengths, the 0.8982 stem at 12 times the gorilla branch, cumulative divergence 0.958 and 0.060, 13 tips after re-rooting, IQ-TREE 3.1.3, all recomputed by the fidelity review from the scratch bundle. |
| Menu paths and surfaces | Pass. Right-click Build Tree with IQ-TREE..., the Phylogenetic Tree Operations dialog and its Scope line, Plugin Manager, the Operations panel, `Phylogenetic Trees/` as the destination, the Import Center's Alignments tab and Phylogenetic Trees card, the summary line, toolbar controls, Nodes drawer, Inspector rows, all ten context-menu items, and every CLI option. |
| Fidelity false claims corrected | Pass. Nodes drawer position, both Replicates labels, the shortest-branch sentence, and the re-root defect on both surfaces. |
| Re-root defect disclosed | Pass. Stated in Procedure as a demonstration of the tip-count check, in Settings, in the context-menu paragraph, in What good looks like, and as a comment in the CLI block. No re-rooted output is shown as a result. |
| Glossary alphabetised | Pass. |
| Nav and help-ids | Pass after gate edits. Nav carries Aligning Sequences and Building Trees. Five help-ids entries retargeted, the illustration registry key split, the imagegen manifest repathed, and the ARCHITECTURE roster updated. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The reading of the unrooted topology was wrong. The chapter said the gorilla joins the macaques and that the tree could not address the expected ape relationships without a root. On an unrooted tree the Newick nesting is arbitrary, and the two splits in this tree (macaques against apes, and human plus chimpanzee against the rest) confirm every relationship the Why section asked the reader to check. The three paragraphs under The numbers on this tree and the topology check under What good looks like were rewritten to read the tree as splits.
2. Two unsourced durations dropped (a minute or two, a couple of minutes), and the unsourced ten-to-twenty-times rule of thumb for stem branches removed.
3. The Next paragraph linked to a directory twice. It now links to Importing FASTQ.
4. `help-ids.yaml` entries dialog.IQTreeInferenceDialog and viewport.TreeViewer now point at 05-building-trees, and dialog.MSAOperations, viewport.MSAViewer, and menu.Tools.FASTQOperations.MSA at 04-aligning-sequences, with anchors matching the live headings and the menu description corrected to Tools > Multiple Sequence Alignment > MAFFT...
5. `illustrations.yaml` key 02-sequences/04-msa-and-trees split into 04-aligning-sequences and 05-building-trees. The imagegen `manifest.json` chapter and asset paths and the `ARCHITECTURE.md` roster entry updated to match.

## Findings for RESULTS.md

`tree reroot` and Re-root Here duplicate every tip except the new root (5 tips become 13). `tree infer iqtree` fails when the MSA bundle lacks a root `.lungfish-provenance.json`. The IQ-TREE dialog labels both replicate fields plain Replicates.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
