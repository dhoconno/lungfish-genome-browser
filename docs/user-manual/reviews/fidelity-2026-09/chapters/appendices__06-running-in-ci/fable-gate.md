# Fable gate: appendices/06-running-in-ci

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Shape | Pass for a power-user appendix. Before you read this, What it is, Finding the program, What a job needs installed, Running the workflow, Offline packs, the two templates, Keeping the provenance, What fails and why with the rough edges under a subheading. |
| Every command traceable | Pass. Fourteen commands with their exit statuses, the quoted plan, refusal, dry-run, unknown-pack, ops stats, and verify outputs, all from the author's runs and the fidelity review's reruns, with the two missing lines restored. |
| Fidelity false claims corrected | Pass. Eight of eight. |
| Rulings | Pass. Both templates set the quoted bundle path into one variable, the GitHub cache step is gone in favour of install-and-cache, the opening section and the exit-status table are in, fourteen terms glossed, no thresholds invented. |
| Binary path | Pass. Matches the CONSISTENCY ruling word for word. |
| Reader consensus | Pass. Forty-two of forty-two applied, 52 of 58 others. |
| Templates | Pass with the caveat stated in the text that neither was executed by a CI service. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. Three cross-reference link texts use the target chapters' titles.
2. The sidecar-field authority points at the Foundations provenance chapter rather than at the power-user appendix, which is being rewritten and does not carry that list.
3. Reading time raised to 30 minutes.

## Rulings

The Before you read this section stays ahead of What it is, since this appendix is typed rather than clicked and the readers needed that said before any command. The CircleCI template's committed offline pack stands as the chapter explains it. Chapter 52's "beside the output" sentence is a Phase 6 sweep item, already logged.

## Findings for RESULTS.md

`--format json` is accepted and ignored by conda packs, ops stats, workflow list, conda offline-export, and version. The unknown-pack error lists eight ids while offline-export accepts eighteen, three of them real packs the CLI cannot install. The sidecar's wallTimeSeconds held a small negative number. `debug env --check-tools` probes Nextflow with a flag it rejects. The offline-export provenance record has an empty file list and no reproducible command. A bundle output's sidecar lands inside the bundle. `provenance verify` handles only signed sidecars and signing is off by default.

## Phase 5 notes

No shots.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
