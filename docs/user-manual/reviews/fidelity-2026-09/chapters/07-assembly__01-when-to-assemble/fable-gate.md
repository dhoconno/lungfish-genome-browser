# Fable gate: 07-assembly/01-when-to-assemble

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass for a concept chapter. What it is, Why you would do this, What LGE ships, How the sheet decides, Working out which assembler, Two assemblers on the same human reads, What the numbers mean, Where the result lands, What good looks like, Next. The dropped procedure sections are explained in the author's report. |
| Every number traceable | Pass. The five pinned versions, 950 MB, 9,958 pairs at 300-fold, 16,569 bases and NC_012920.1, SPAdes 16,697 at 13.7 seconds from the fixture's committed run, SKESA 16,570 at 1.6 seconds, the 127 and 128 base figures each with what it compares, the three MEGAHIT contigs for the N50 walk attributed to chapter 47's run, the summary strip's fields, the 80-base preview, all from the fidelity review and the sibling reviews. |
| Menu paths and surfaces | Pass. Tools > Assembly with five items, the sheet's Assembler picker and Read Type row and its locked note, the two refusal messages quoted, the disabled Run Mode picker, the Readiness panel, the viewport's strip, table, and detail pane, the action bar's four buttons, Reassemble..., the no-contigs message. |
| Fidelity | Pass. Zero false claims, two unverifiable claims hedged, the front-matter mismatch fixed. |
| MEGAHIT caution | Pass. The shared wording appears at the catalogue row and the comparison, with no claim that the thread cap fixes it. |
| Reader consensus | Pass. Thirty-eight of thirty-eight applied, and every remaining row. |
| Human example | Pass. HG002 mitochondrial reads. |
| Glossary alphabetised | Pass. Five new entries, twenty-three anchors linked. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The Assemblies folder denial cut, since the reader was never told of one.
2. The unmeasured bacterial and eukaryotic run times became a proportional statement.
3. The rerun success rate now states the reviewer's one in five.
4. The invented 10 percent length tolerance became a comparison to the fixture's measured overshoot.
5. The 30-fold and 10-fold coverage guidance framed as published practice.
6. Reading time raised to 28 minutes.
7. CONSISTENCY.md gains the assembly rulings shared by chapters 46 to 49.

## Rulings

The 3,100 Mb human genome figure stays as established scale. The dead `analysisDirectoryPrefix` is an engineering item for RESULTS.md. The three shots wait for Phase 5, with the picker capture taken from a detected Illumina bundle.

## Findings for RESULTS.md

MEGAHIT 1.2.9 fails about four runs in five on Apple Silicon with both shipped workarounds active. `AssemblyTool.analysisDirectoryPrefix` is dead code whose comment names a folder shape the app never writes.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
