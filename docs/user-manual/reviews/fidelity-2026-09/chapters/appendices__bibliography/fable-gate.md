# Fable gate: appendices/bibliography

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Shape | Pass for a reference appendix. What it is, What the command prints with the mishandled-tools subsection, the four tables with their reference blocks and a worked example, Which tools you need to cite, Citing LGE, Using this with a methods section, Next, with the appendix anchor kept. |
| Every table row traceable | Pass. Fifty-one rows against the tool lock, checked row by row by the reviewer, thirty-five DOIs none invented, the three command outputs and the exit statuses from reruns. |
| Fidelity false claims corrected | Pass. Three of three, with the shared-word matching tier explained and the wrong-citation cause added. |
| Rulings | Pass. All eight, with the Terminal steps, the worked reference, the count matched to the rows, the lock named as the version source, and two terminal-free routes to the tool list. |
| Reader consensus | Pass. Thirty of thirty applied, 52 of 57 others. |
| Binary path | Pass after the gate edit. The chapter said the bare name works from any folder, which the CONSISTENCY ruling contradicts. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The bare-name sentence replaced with the CONSISTENCY binary path and the export line the CLI Reference gives.
2. A meta remark about the front-matter audience label and an instruction to file issues removed, since the manual records defects in this release rather than asking readers to report them.
3. Reading time raised to 26 minutes.

## Rulings

Versions follow the tool lock, so Bracken reads 1.0.0 here and chapter 66 regenerates Tool Versions from the same lock. The six DOIs the alias table does not carry (SPAdes, MEGAHIT, SKESA, Flye, hifiasm, RiboDetector) and the IQ-TREE 3 question are a Phase 6 DOI-resolution pass. The fixture is the demo project's mapping run, which the chapter names as HG002.

## Findings for RESULTS.md

The bibliography's shared-word matching tier prints a confident wrong citation for Trim Galore, gatk-variant-filtration, and gatk-variants-to-table. Sixteen managed tools have no alias entry, including every assembler, GATK, Clair3, WhatsHap, Freyja, BLAST, Bracken, EsViritu, RiboDetector, Savont, TaxTriage, pysam, and openpyxl. GATK and Freyja record wrapper step names. A matched-nothing run exits 0. Three packs are Plugin Manager only. Four alias entries name tools in no lock array. tool-versions.md is stale against the lock on nine versions and omits Trim Galore.

## Phase 5 notes

No shots.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
