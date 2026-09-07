# Fable gate: 06-classification/10-twelve-s-metabarcoding

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`,
`parameters.yaml`, and the new `fixtures/primate-12s/` folder.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Fourteen settings and seven cli_only flags, labels verbatim, with the six Inspector controls split four and two. The registry's chimera states are corrected at the gate. |
| Every number traceable | Pass. 173 reads, 110 exact, 63 unresolved, 63.6 and 36.4 percent, the five primates with Homo sapiens at 110 and the rest at zero, 56 clusters with 51 singletons, four pairs, and one of four reads, the 75 of 110 lost without orientation, all from the author's run, reproduced byte for byte by the fixture publisher. |
| Fixture | Pass. The constructed primate 12S fixture is published under `docs/user-manual/fixtures/primate-12s/` with a README and a regenerate script that rebuilds it from the primate-mito and human-mito fixtures, and Before you start cites it with the fixed sentences. `fixtures_refs` names it. |
| Human example | Pass. Human reads against a five-primate reference, as the manual prefers. |
| Menu paths and surfaces | Pass. Tools > Workflow Library..., Specialized Workflows, the Genotyping group, the card's Specialized badge, Third-Party Tools dependency row, Enabled switch and Install Dependencies button, the "(not enabled)" Tools item and its prompt, the Workflow Operations dialog's controls, the Targets and Unresolved views and their columns, the summary line, the context menu's Learn More About and View Photo of, the action bar, the Export menu, the Inspector's 12S Results section. |
| Fidelity false claims corrected | Pass. Third-Party Tools, and four plus two Inspector controls. |
| Defects disclosed | Pass. No reverse-complement attempt, the help text omitting two columns, the parenthesis-free header producing empty metadata at exit 0, `fastq orient --compress` writing plain text. |
| Reader consensus | Pass. Thirty-five of thirty-five applied. Orientation and merging moved into Before you start with chapter links. |
| Glossary alphabetised | Pass. Four new entries plus the soft-clip entry extended. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. Two unmeasured durations removed (pack install, BLAST wait), matching chapter 37's rule.
2. Two invented example values removed from Min Soft Clip and Minimum Exact Reads.
3. Reading time raised to 30 minutes.
4. The registry's chimera review effect now lists all four states and says which two the review writes.
5. CONSISTENCY.md records the `Analyses/12S amplicon results/` folder shape.
6. DRIFT roster row 41 now names the primate-12s fixture.

## Rulings

The Inspector tab is described as the Inspector only, since its tab is labelled Summary. The chimera review's confirmed state is described as one the review never writes. Whether the window's Orient Reads shares the --compress defect stays out for want of a source.

## Findings for RESULTS.md

The 12S matcher never tries the reverse complement, silently losing every read on the other strand. `12s-reference-metadata` and `12s-reference-bundle` help text names five of seven required columns. A reference header without parentheses yields empty species metadata at exit 0. `fastq orient --compress` writes plain text under a .gz name.

## Phase 5 notes

Seven shots to capture from a GUI run on the primate-12s fixture, with the 12S workflow enabled through the Workflow Library first.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
