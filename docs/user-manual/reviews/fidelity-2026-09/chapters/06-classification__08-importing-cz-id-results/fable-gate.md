# Fable gate: 06-classification/08-importing-cz-id-results

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`help-ids.yaml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, Troubleshooting, On the command line, Next. |
| Every registry setting present | Pass. import.cz-id's three cli_only flags, with the sheet stated to hold no settings. |
| Every number traceable | Pass. Three rows, 1,200 root reads, 88 and 42 with their 7.33 and 3.50 percent, 73333.0 and 35000.0 RPM, pipeline 8.4 and the two database versions, the checksum prefix, the 3 taxa label, all from the author's sixteen commands and the fidelity review. |
| Menu paths and surfaces | Pass. File > Import Center... > Classification Results > CZ-ID Results with its CZ badge and file hint, the sheet's title and subtitle, its CZ-ID Export section, Preview rows, Project Destination readout, Run button and its enablement, the Operations panel row titles, the Classifications folder, the viewport's action bar label, the disabled Extract FASTQ tooltip, the CZ-ID Pipeline Info popover. |
| Fidelity false claims corrected | Pass. The JSON key names. Three unverifiable rows cut or hedged. |
| Defects disclosed | Pass. The Project Destination readout and its drifting timestamp, the root row in the taxon count, each where the reader meets it and once more under a heading. |
| Reader consensus | Pass. Thirty-five of thirty-five applied. The fixture is reachable through the repository ZIP. |
| Help ids | Pass after the gate edit. The CZ ID viewport entry pointed at chapter 07, which is Freyja. |
| Glossary alphabetised | Pass. Reads per million and Taxon report in place. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The unsourced "hundreds or thousands of rows" claim became a comparison against the fixture.
2. The expected top taxa no longer name human sequence, which CZ ID removes as host.
3. Reading time raised to 28 minutes.
4. help-ids.yaml's CzIdResultViewer entry now points at chapter 08.
5. CONSISTENCY.md records that the cz-id knownTools entry is dead for the import.

## Rulings

The fixture stays a repository test fixture reached through the ZIP, with `fixtures_refs` empty. A publishable CZ ID export with provenance notes is a Phase 5 item, as are the four shots.

## Findings for RESULTS.md

The CZ ID import sheet's Project Destination readout composes `Analyses/cz-id-<timestamp>`, which no import writes to, and recomputes the timestamp on every read. The action bar's taxon count includes the root row. Neither GUI nor CLI CZ ID import creates an Analyses folder, so the cz-id knownTools entry is unreachable.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
