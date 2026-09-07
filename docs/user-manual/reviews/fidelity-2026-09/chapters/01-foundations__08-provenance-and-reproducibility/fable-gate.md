# Fable gate: 01-foundations/08-provenance-and-reproducibility

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Provenance, Save As, Where in the three-sentence shape with the registry labels. |
| Every number traceable | Pass. Both checksums, the reproducibleCommand, the bcftools version string, the eleven steps, steps 4 and 5, `-t 14`, and the runtime fields verified byte for byte by the fidelity review against the demo project's sidecars. Exported file names confirmed by six real exports. |
| Menu paths and surfaces | Pass. File > Export > Provenance submenu and its six items, the seven Provenance blocks with ampersands, Filter provenance, Copy, Run Summary rows, the export save panel text, the Provenance Export Complete alert and Show in Finder, the signing controls, the Missing provenance and No provenance required states. |
| Fidelity false claims corrected | Pass. Step numbering, bibliography needs a bundle, the Inspector empty-state text, the fixtures page's create-in-app order, ampersands, the Nextflow containers folder. |
| Removed content noted | Pass. The Provenance tab, the Inputs and Outputs sections, the wrong CLI name, the Full Provenance title, the quoted verify and bibliography strings, and the SARS-CoV-2 paths were removed under the drift decisions and listed in the author report. |
| Glossary alphabetised | Pass. Run record under R, Workflow lineage under a new W section. The run-record entry's block names now carry ampersands. |
| Nav and help-ids | Pass. Title unchanged, no help-id entry. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The quoted reproducibleCommand carried the user's home path. Shortened to the `...` form the prose already explains.
2. "The demo project's build script installs what those earlier runs needed" was untrue, the script installs nothing. Reworded.
3. The command block quoted `~` inside double quotes, which no shell expands. Paths use `$HOME` and the introducing sentence explains why.
4. The `provenance verify` example pointed at the project folder, which holds no sidecar. It now points at the chr20 bundle like the other three commands.
5. The Next section linked part directories that have no index page. Each link now points at the part's first chapter.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
