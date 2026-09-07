# Fable gate: 05-variants/05-consensus-and-lineage (Extracting a Consensus Sequence)

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`mkdocs.yml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Ten bam.extract-consensus settings in the three-sentence shape with the registry labels verbatim, and the flagless statement made once in the Settings lead under the chapter 23 ruling. |
| Every number traceable | Pass after the editor's rebuild. Every figure now comes from the fidelity review's rerun of the app's full four-stage chain (view with -F 3332, samtools consensus, the normaliser, the depth mask): 500,001 letters, 1,027 N and 498,974 called bases, 337 letter differences, position 2,078 at 51 usable bases and depth 63, the five-row settings table, and the 182, 191, and 176 ambiguity letters. |
| Menu paths and surfaces | Pass. The Inspector's Analysis tab and Consensus tab with its note, every control, the Extract Consensus... button and its disabled line, the Generate Alignment Consensus row, the Extract Sequence dialog's four radio choices and renaming button, the Consensus Contains Only N alert, and the View Settings read-inclusion filters. |
| Fidelity false claims corrected | Pass. All nineteen, including the asterisk teaching claim, the destination control, the clipboard-only summary block, and the header form. |
| Defects disclosed | Pass. No command-line equivalent, and the unrunnable Lungfish.app command string in the operation history. |
| Glossary alphabetised | Pass. IUPAC ambiguity code and samtools in place. |
| Nav | Pass. Retitled Extracting a Consensus Sequence. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The front-matter entry point restored to the path form the registry uses, under the ruling that the prose rule applies to body text only.
2. The alignment track name aligned with chapter 22's default, "minimap2 Mapping", instead of the fixture BAM's file stem.
3. Reading time raised to 28 minutes.

## Rulings

The 337 against 961 explanation stays as the provable statement about what a consensus can show. Structural reader requests go to Phase 5.

## Findings for RESULTS.md

The operation history records alignment consensus as `Lungfish.app alignment consensus ...`, a command-shaped string that no `lungfish-cli` subcommand can run. The consensus chain masks by depth twice, once in samtools consensus and once from a separate samtools depth pass, and rewrites every `*` as `N`, so raw samtools output does not match the app's.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
