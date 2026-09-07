# Fable gate: 08-workflows/01-the-workflow-builder

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure (six steps), Settings with a command-line subsection, Reading the results with three subsections, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Nine node settings, three window controls, five cli_only flags, each with its owner named and the Configure... route stated once in the lead-in. |
| Every number traceable | Pass. 19,916 reads and 9,958 pairs at 248.4 bases, the four-row count table in reads (19,916 to 19,752 to 318 to 225 to 106), 19,434 removed as 98.4 percent, 30,498 bases and 287.7 mean, the two refusal strings, the three completion lines, the diff output, all from the author's runs and the fidelity review's reruns. |
| Menu paths and surfaces | Pass. Settings > Advanced toggle and its two notes, Tools > Workflow Builder (Experimental)..., the New Workflow prompt text, the three sidebar buttons, the four palette headers and six node types, the toolbar controls, the Workflow Not Ready, No Active Project, and Input Bundle Not Ready alerts, the Save/Don't Save/Cancel prompt confirmed from source by the editor. |
| Fidelity false claims corrected | Pass. Seven of seven, with the count table in reads throughout and the Deacon depletion stated once. |
| Defects disclosed | Pass. Six, including the inspector defect that hides eight node settings behind Configure..., the missing run.json on command-line runs, the diff format flag, validate refusing builder graphs, and list omitting chains. |
| Reader consensus | Pass. Thirty-seven of thirty-seven applied, 62 of 84 other rows. |
| Human example | Pass. HG002 mitochondrial reads, with the near-total depletion explained as the expected outcome. |
| Shot convention | Pass after the gate edit. A stray empty planned_shots key removed. |
| Command-line opener | Pass after the gate edit. The "nothing here unlocks" clause replaced, since workflow diff exists only on the command line. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The empty `planned_shots` key removed from the front matter.
2. The fixed opener's "nothing here unlocks" clause replaced with the one command-line-only capability, matching the chapter 51 ruling.

## Rulings

The editor's two source findings stand: closing the window prompts to save rather than discarding silently, and per-node status appears only in run.json. Deacon's index installs only from the command line because the Databases tab excludes it, which the editor confirmed in source. The Required Setup pack membership of fastp, Deacon, and seqkit is inherited from the author and is a Phase 6 check against the tool lock.

## Findings for RESULTS.md

The five operation nodes' parameters are unreachable from the inspector, which shows only Label, tool, Configure..., ports, and validation, so eight of twelve settings live behind the shared operations dialog. `workflow diff --format json` and `--format tsv` print the text form. A command-line `builder-run` writes no run.json and no provenance.json. `workflow validate` refuses a builder graph with exit 5. `workflow list` omits saved chains. The graph JSON encoding is undocumented.

## Phase 5 notes

Five shots, none captured. The experimental toggle shot needs Settings > Advanced with the toggle on. The inspector shot must show the Configure... button, not parameter fields.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
