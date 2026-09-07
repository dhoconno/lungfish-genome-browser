# Fable gate: appendices/troubleshooting

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Shape | Pass for a symptom-organised appendix. What it is, Before you type anything, Start here at the failed row, then six symptom sections each opening with its window-or-Terminal sentence, Reporting, Next. |
| Every message traceable | Pass. Every quoted string cites a source line or a campaign run record, the four diagnostics reran with matching output, and 21 of the 28 symptom entries trace to a gate file. |
| Fidelity false claims corrected | Pass. Three of three, with the Medaka and Clair3 symptom added and the two unverifiable claims hedged. |
| Rulings | Pass. All nine, with the failed-row instruction first, the exit-status table before first use and matching the CONSISTENCY ruling, the machine figures labelled, lock clearing pointed at Shared Projects, and every glossary ref linked. |
| Reader consensus | Pass. Forty-eight of forty-eight applied, 44 of 50 others. |
| No invented thresholds | Pass after the gate edit. A 30-read starting point for Min Reads removed. |
| Cross-chapter agreement | Pass after the gate edits. Genotype only means no haplotype analysis, per the genotyping chapters, and five link texts match their targets' titles. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The Min Reads row defines Genotype only correctly and drops the invented 30-read starting point.
2. The Medaka and Clair3 row no longer says neither caller completes a run, since Clair3 fails only on a path with a space.
3. A hedge phrase replaced with the campaign's actual evidence, and five link texts aligned with their titles.
4. Reading time raised to 30 minutes.

## Rulings

Exit 64 is a workflow error and 2 is a usage error, per the CONSISTENCY ruling, and chapters 57 and 58 are swept to match. The Deacon indexes install with Required Setup, and chapter 50 is swept to match. The failure-store retention of fifty is sourced in chapter 63.

## Findings for RESULTS.md

No new app defects. The Workflow Library card shows Install Dependencies in place of the Enabled switch and that button enables the workflow itself.

## Phase 5 notes

One shot, a failed Operations panel row expanded with the context menu open on Copy Failure Report, which needs a deliberately failing run on the demo project (a Kraken 2 run against a database that matches nothing is the cheapest).

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
