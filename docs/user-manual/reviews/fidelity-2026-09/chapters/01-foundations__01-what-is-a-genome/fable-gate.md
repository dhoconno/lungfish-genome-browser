# Fable gate: 01-foundations/01-what-is-a-genome

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order (What it is, Why, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line) | Pass. Three concept sections sit between Reading the results and What good looks like, and one between What good looks like and the command line, which the template allows for a foundations chapter. |
| Every registry setting present | Pass. `import.reference` has `settings: []`. The Settings section says so and documents the two CLI flags. |
| Every number traceable | Pass. 81,706 bp, gene 70545..72152, CDS join, codon 70613..70615 GAG, 8/5/5/13 features and 102 imported all match `fixtures/hbb-gene/README.md` and the fidelity review's live `bundle info` run. |
| Menu paths match the reality map | Pass. File > Import Center... (Cmd-Shift-I), Sequence > Go to Location... (Cmd-L), File > New Project (Cmd-N) verified in `MainMenu.swift` by the fidelity reviewer. |
| Fidelity false claims corrected | Pass. Rows 24 (no accession in Provenance), 28 (unmatched contig navigates rather than refuses), 34 (Chrom is the third column) all read correctly in the final text. |
| Removed content noted | Pass. The SARS-CoV-2 worked example, "What you will learn", and "A preview of what comes next" were replaced under DRIFT Part A decisions for this chapter. |
| Glossary alphabetised | Fixed at the gate. The Exon entry had been inserted under the F heading. Moved to E after ENA. |
| Nav and help-ids | Pass. Nav title unchanged. `help-ids.yaml` has no entry for this chapter. |
| Strict lint | Pass, "no issues found" after gate edits. |

## Gate edits

Four small edits made directly rather than through a fix round.

1. `NG_000007.3` is a RefSeq record, not a GenBank record. The database sentence now names RefSeq.
2. "does encode" tightened to "encodes".
3. Step 1 lost a redundant clause about the shortcut.
4. The Settings paragraph now spells `--output-dir` to match the command block, instead of the `-o` short form.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
