# Fable gate: 08-workflows/02-exporting-as-nextflow-or-snakemake

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results with one subsection per target, What good looks like with the defects under a findable heading, On the command line, Next. |
| Every registry setting present | Pass. Provenance, Save As, Where, and the two cli_only verify flags. |
| Every number traceable | Pass. Six targets and their files, the eight-line params block quoted in full from the emitted main.nf, five processes, the minimap2 2.31 comment, the empty containers manifest, one error and eleven warnings from nextflow lint, the CyclicGraphException rule, two bibliography entries, the pinned 26.04.6 and 9.25.2 against the 8.26.0 the dry run used, all from the author's exports and the fidelity review's reruns. |
| Menu paths and surfaces | Pass. File > Export > Provenance and its six items with the divider, the Export Provenance panel's message and prefilled name, the No Provenance Available alert, the Provenance Export Complete alert's two buttons. |
| Fidelity false claims corrected | Pass. The full params block, the Snakemake engine version, the command-line opener. |
| Defects disclosed | Pass. Five under Known defects in this release, each in reader-facing words, with the verify exit status disclosed again where the command appears. |
| Honesty | Pass. The chapter says in What it is and again in Why you would do this that neither emitted workflow validates and that the runnable targets are transcriptions to edit. |
| Reader consensus | Pass. Forty-one of forty-one applied. |
| Shot convention | Pass after the gate edit. The author used planned markers and a planned_shots key, which the template does not define. Converted to SHOT markers and the shots key. |
| Glossary | Pass after the gate edit. The stale methods-export entry now describes the document the export writes. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. Four planned markers converted to SHOT markers and the planned_shots key renamed to shots.
2. fixtures_refs names the demo-project fixture the chapter builds on.
3. The methods-export glossary entry rewritten to match the emitted file.
4. Reading time raised to 30 minutes.

## Rulings

The command-line section keeps the fixed opener minus its "nothing here unlocks" clause, since scripting, bibliography, and verify exist only there. The Foundations provenance chapter's promise of a re-runnable export is a Phase 6 sweep item. The Workflow Builder's separate exporter stays described as untested.

## Findings for RESULTS.md

The Nextflow emitter calls a three-input process with one channel. The Snakemake emitter lists the flagstat BAM as both input and output, producing a cycle. A parameter is emitted twice at four sites. Every emitted command carries absolute host paths. `provenance verify` exits 64 with an error line on an ordinary unsigned record.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
