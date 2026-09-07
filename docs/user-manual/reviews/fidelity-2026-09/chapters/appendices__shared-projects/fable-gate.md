# Fable gate: appendices/shared-projects

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Shape | Pass for a power-user appendix. What it is, If a project just opened read-only, Why you would do this, Before you start, Reading the window's read-only state, Before you type anything, locking, unlocking, migrating, provenance expectations, What good looks like, Next. |
| Every command traceable | Pass. Twenty-four runs on a scratch copy, every quoted line and exit status reproduced by the reviewer, the lock record's twelve fields, the four migration report lines, the two backup files. |
| Fidelity false claims corrected | Pass. Three of three. |
| Rulings | Pass. All ten, with the copied-while-open case stated as ordinary, the read-only reader's fix first, the Terminal pointer, the stale-lock contradiction removed, `--force` warned before it is offered, Activity Monitor as the check, hidden paths explained, six glossary terms. |
| Reader consensus | Pass. Thirty-two of thirty-two applied, 43 of 48 others. |
| Honesty | Pass after the gate edit. A paragraph describing a planned rule rather than the shipping app is removed. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The paragraph describing a planned migration rule removed, since the manual documents the shipping app.
2. The closing heading is Next, matching every other chapter, and the four command fences carry the shell tag.
3. Reading time raised to 30 minutes.

## Rulings

The lock inside the demo project on the machine that wrote this manual belongs to the running Lungfish Preview with the project open, and the chapter describes that as the ordinary copied-while-open case. Chapter 06 of Foundations wrongly says the window has no lock-recovery button, a Phase 6 sweep item. The `--format tsv` defect and the migration count quirk stand as documented.

## Findings for RESULTS.md

Two consecutive CLI locks both succeed because a CLI lock is stale the instant the command exits. The host field can change between two lock records minutes apart on one Mac. `project` subcommands accept `--format tsv` and print the text report. The migration summary counts do not reconcile. `lock --force` deletes the displaced record with no archive. Stale-lock recovery in the window is unreachable dead code.

## Phase 5 notes

One shot, the read-only banner, which needs a second session holding the demo project open, or a copy of the project made while the app has it open.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
