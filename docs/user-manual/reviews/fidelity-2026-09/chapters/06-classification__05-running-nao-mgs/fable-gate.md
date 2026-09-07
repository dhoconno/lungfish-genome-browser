# Fable gate: 06-classification/05-running-nao-mgs

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`,
`parameters.yaml`, `mkdocs.yml`, and `help-ids.yaml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line, Troubleshooting, Next. |
| Every registry setting present | Pass. import.nao-mgs's three cli_only flags, with the sheet stated to hold no settings. The registry notes are corrected at the gate. |
| Every number traceable | Pass. 35 hits, 4 distinct taxa, 5 samples, 7 table rows, the two Rotavirus A rows (12 of 8 and 28 of 26) with their sites, 7 accessions against the cap of 5, 4 reads extracted, the 34 confined to the summary command, all from the author's runs and the fidelity review. |
| Menu paths and surfaces | Pass. File > Import Center... > Classification Results > NAO-MGS Results with its NM badge and file hint, the sheet's Browse..., readout, Validation section, Files found row, and Run button, the Operations panel, the two summary cards, the sample button, the five columns, the header sort and filter menu, the Inspector's Import Metadata..., the detail pane's Taxid: line and miniBAM heading strings, the action bar and context menu. |
| Fidelity false claims corrected | Pass. Ten rows fixed with the reviewer's wording. |
| Defects disclosed | Pass. The summary command's first-sample-only report, the empty hits table behind --by-db, the summary's blank Organism column, the miniBAM note mislabel, the two taxon counts on one screen. |
| Reader consensus | Pass. Thirty-eight of thirty-eight applied. The fixture is reachable through the repository ZIP. |
| Retitle | Pass. Title, nav label, and help-ids entry read Importing NAO-MGS Results. |
| Glossary alphabetised | Pass. miniBAM and Taxonomy identifier in place. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The "reaches the thousands" figure for a full run, which had no source, is gone.
2. The bit-score range and the BLAST wait are framed as guidance, the latter matching chapter 37's rule that no duration is quoted.
3. Two link texts read Running Kraken 2.
4. Reading time raised to 26 minutes.
5. The import.nao-mgs registry notes now describe both destinations and the input-stem naming.
6. CONSISTENCY.md gains the imported-result naming rule and the fixed command-line opener.

## Rulings

The fixture stays a repository test fixture reached through the ZIP, with `fixtures_refs` empty. Phase 5 needs a NAO-MGS sample output with provenance and licence notes if the manual is to ship one. The stale CZ ID cross-reference in help-ids.yaml is fixed at the chapter 39 gate. Whether taxonomy lookup needs a network connection stays out.

## Findings for RESULTS.md

`nao-mgs summary` reads only the first sample of a multi-sample table and prints no organism names. `extract reads --by-db` can never return reads from an imported NAO-MGS bundle because the merge drops the virus_hits rows. The miniBAM note says unique read count while the panels are ordered by total. The Taxa card counts sample-taxon rows while the Unique Taxa card counts distinct taxa.

## Phase 5 notes

Capture nao-mgs-result-viewport with the Taxa card reading 7, and check the miniBAM heading and Taxid: line strings in the same pass. A publishable NAO-MGS sample output is still an open item.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
