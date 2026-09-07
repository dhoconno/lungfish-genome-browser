# Fable gate: 01-foundations/06-the-lungfish-project

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`help-ids.yaml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener present), Procedure, concept sections, What good looks like, On the command line, Next. `parameters_refs` is empty by ruling, so no Settings section. |
| Every number traceable | Pass. The ten-entry recent list, the seven folders, the timestamp shape, and the lock record fields all verified by the fidelity review against source. |
| Menu paths and surfaces | Pass. Every menu path, shortcut, Welcome card, Inspector row, and Operations row item verified (94 true rows). |
| Fidelity false claims corrected | Pass. Claims 9, 38, 48, 68, 69 applied. Claim 100 ruled true from the live CLI observation. |
| Removed content noted | Pass. The SARS-CoV-2 walkthrough, the Assemblies folder passage, the wrong CLI name and shortcuts, and the Cmd-Period sentence were removed under the drift decisions and listed in the author report. Workflow Library deferred to the workflows part by ruling. |
| Glossary alphabetised | Pass. Extraction under E, Project lock under P, four corrected entries in place. |
| Nav and help-ids | Pass. Title unchanged. Two help-ids descriptions corrected, all seven entries resolve. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. Before you start said the fixture page's command creates the project. Since the demo-project fix earlier today, the reader creates the project in the app first and the script fills it. Sentence corrected.
2. The command block quoted `~` inside double quotes, which no shell expands. Paths now use `$HOME` and one sentence explains why.

## Notes for Phase 5

The demo project's `Analyses/` folders carry script-chosen names (`mapping-HG002`, `HG002-chrM`, `kraken2-SRR36291587`, `nvd-demo`) rather than the `<tool>-<timestamp>` shape the app writes. The sidebar recognises them through their sidecars. Rename them to the app's shape before the sidebar shot, or accept the difference and say so in SHOTS.md.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
