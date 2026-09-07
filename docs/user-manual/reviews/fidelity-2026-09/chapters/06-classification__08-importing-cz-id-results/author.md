# Author record, 06-classification/08-importing-cz-id-results

Chapter: `docs/user-manual/chapters/06-classification/08-importing-cz-id-results.md`
Roster row 39, registry id `import.cz-id`, title "Importing CZ ID Results".
Author pass run 2026-09-07 against the 2026.9.13 Preview source tree in the
worktree `.claude/worktrees/user-manual-fidelity-campaign`.

## Fixture

The roster marks the fixture as an open item. `Tests/Fixtures/czid/` exists and
holds exactly one file, `minimal_taxon_report.tsv`, a 553-byte synthetic CZ ID
taxon report with a header row and three data rows. It is a SARS-CoV-2
respiratory-sample report, sample `Sample-CZ-001`, project `Project-42`,
pipeline version 8.4, NT database `nt_2025_12_01`, NR database
`nr_2025_12_01`. The three rows are root (taxid 1, 1200 NT reads), Viruses
(taxid 10239, superkingdom, 88 NT reads), and Severe acute respiratory
syndrome coronavirus 2 (taxid 2697049, species, 42 NT reads).

It is viral, and the chapter says in Why you would do this that it is one of
the manual's viral examples because CZ ID is a pathogen-detection service.

The fixture was copied to the scratchpad at
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/cz-id/`
and every command below was run there. Nothing was written into the repository
tree and nothing was read from or written to `~/Desktop/lge-docs/`.

There is no `docs/user-manual/fixtures/czid/` folder, so `fixtures_refs` is
left empty and Before you start tells the reader to export their own report
from CZ ID, naming the repository test report as the source of the chapter's
figures. See the Phase 5 notes at the end.

## Commands run

Binary: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
(176 MB, built 2026-09-06 16:48).

| # | Command | Exit | Figures taken |
|---|---|---|---|
| 1 | `lungfish-cli import cz-id --help` | 0 | Confirmed `--project` and `--sample-name` required, `--metadata` and `--non-host-fastq` optional. Matches `cli-help/import.txt` verbatim. |
| 2 | `lungfish-cli cz-id summary minimal_taxon_report.tsv --top 20` | 0 | The full text block quoted in On the command line. Sample, Rows 3, Pipeline 8.4, both DB versions, and the two-row table with NT Reads 88 / 42 and NT RPM 73333.0 / 35000.0. Confirms root is dropped and rows are ranked by NT read count. |
| 3 | `lungfish-cli cz-id summary minimal_taxon_report.tsv --top 5 --format tsv` | 0 | Column names `tax_id`, `name`, `rank`, `nt_reads`, `nt_rpm`, `nr_reads`. Settles ground-truth claim 16, previously unverifiable. |
| 4 | `lungfish-cli cz-id summary minimal_taxon_report.tsv --top 3 --format json` | 0 | Field names `name`, `nrReadCount`, `nrRpm`, `ntAlignmentLength`, `ntEValue`, `ntPercentIdentity`, `ntReadCount`, `rank`, `taxId`. Root dropped here too. |
| 5 | `lungfish-cli import cz-id minimal_taxon_report.tsv --project demo.lungfish --sample-name Sample-CZ-001` | 0 | The CZ-ID Import output block quoted in Reading the results, and the destination path `demo.lungfish/Classifications/Sample-CZ-001.lungfishtax`. |
| 6 | `find demo.lungfish -print` | 0 | The five bundle files plus the `provenance/` folder listed in What lands in the bundle. |
| 7 | `cat .../classification.kreport` | 0 | The three-line kreport quoted verbatim in Reading the results, including the 100.00 / 7.33 / 3.50 percentages and the R / D / S rank codes. |
| 8 | `head -c 1500 .../classification-result.json` | 0 | `databaseName` = `CZ-ID`, `databaseVersion` = `nt=nt_2025_12_01; nr=nr_2025_12_01`, `reportPath` = `classification.kreport`, `outputPath` = `classification.czid.tsv`, `toolVersion` = `8.4`. |
| 9 | Python read of `.lungfish-provenance.json` | 0 | argv, `exitStatus` 0, `wallTimeSeconds`, `workflowName` = "CZ-ID Import", `toolName` = "lungfish import cz-id", and the input SHA-256 `3852c1bd...` matching the copied `classification.czid.tsv` byte for byte. |
| 10 | `lungfish-cli import cz-id czid-export.zip --project demo.lungfish --sample-name Sample-CZ-ZIP` | 0 | ZIP archive path works and produces an identical bundle. |
| 11 | `lungfish-cli import cz-id exportfolder --project demo.lungfish --sample-name Sample-CZ-FOLDER` | 0 | Extracted-folder path works and produces an identical bundle. |
| 12 | `lungfish-cli cz-id import minimal_taxon_report.tsv --output-dir ./standalone` | 0 | Standalone form writes the same five files to the named folder, takes no `--project` and no `--sample-name`, and derives the sample from the export. Settles the Missing row about `cz-id import`. |
| 13 | `lungfish-cli import cz-id ... --metadata metadata.json --non-host-fastq non-host.fastq.gz` | 0 | Both paths are recorded in provenance with role `input`, size, and checksum. Neither file is copied into the bundle. This is the evidence behind the two Settings paragraphs. |
| 14 | `lungfish-cli import cz-id bad.tsv --project demo.lungfish --sample-name Bad` | 1 | Error text quoted in Before you start, "CZ-ID taxon report must include tax_id, taxon_name, and rank columns". |
| 15 | `lungfish-cli import cz-id ... --project /nonexistent.lungfish` | non-zero | "Project directory not found" message. Not quoted in the chapter but confirms the project must exist first. |
| 16 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh <chapter>` | 0 | Final run prints "no issues found". |

Lint history. The first run gave 5 warnings. Two were SHOT markers indented four
spaces outside a list, which markdown parsed as a code block, fixed by
unindenting lines 162 and 170. One was a semicolon inside a quoted line of CLI
help, fixed by paraphrasing the quote. Two were the banned word "navigation"
(list entry "navigate"), fixed by rewriting both sentences. Final run is clean.

## Source files consulted for a window claim

| File | What it settled |
|---|---|
| `Sources/LungfishApp/Views/Metagenomics/CzIdImportSheet.swift` | Sheet title "CZ-ID Import" and subtitle "Hosted metagenomics taxon report" (`:114-115`). Three sections in order, CZ-ID Export, Preview, Project Destination (`:145-153`). The **Browse…** button (`:176`) and the hint line "Select a CZ-ID taxon report TSV, a ZIP export, or an extracted export folder." (`:182`). Preview rows Sample, Project, Rows, Source, Report, Pipeline, NT DB, NR DB, Top taxa (`:218-243`). Status strings "Scanning CZ-ID export...", "Ready to import CZ-ID report.", "Select a CZ-ID export." (`:33-44`). The primary button is titled **Run**, not Import (`:120`). It is enabled only when a path is selected, a preview exists, and the scan has stopped (`:30`). Sheet size 520x460. |
| `Sources/LungfishApp/App/AppDelegate+ToolsMenu.swift:829-950` | The GUI import writes to `projectURL/Classifications/<bundleFileName>.lungfishtax` (`:860-867`). Operation title "CZ-ID Import", detail "Converting <report file name>...", completion detail "Imported <sample>". The equivalent CLI command is attached to the Operations row (`:870-880`). Alerts "No Project Open" and "CZ-ID Import Failed". |
| `Sources/LungfishWorkflow/Metagenomics/CzId/CzIdImportPreview.swift` | `SourceKind` display names "Taxon report file", "Extracted folder", "ZIP archive" (`:13-19`). Top taxa capped at 5 (`:111`). |
| `Sources/LungfishWorkflow/Metagenomics/CzId/CzIdDataConverter.swift` | Required columns and the error text (`:521`). The kreport percentage is NT reads over the root row's NT reads (`:166-185`). Column aliases accepted for `tax_id` and NT read count. |
| `Sources/LungfishWorkflow/Metagenomics/CzId/CzIdProjectImportWorkflow.swift:88-97` | Bundle file name sanitisation, replacing anything outside letters, digits, dot, hyphen, underscore with a hyphen. |
| `Sources/LungfishApp/Views/ImportCenter/ImportCenterViewModel.swift:498-508` | The CZ-ID Results card, its `CZ` badge icon, its file hint "taxon report TSV, .zip, or extracted folder", its description naming CZ ID as imported not run, and its placement on the Classification Results tab. |
| `Sources/LungfishApp/Views/Metagenomics/CzIdResultViewController.swift` | The result viewport embeds `TaxonomyViewController` whole. Action bar info text "Imported CZ-ID result · <sample> · <rowCount> taxa" (`:41-43`). Extract is disabled with the tooltip "CZ-ID imports do not include per-read source IDs for FASTQ extraction." (`:46-48`). The Provenance button opens the popover. |
| `Sources/LungfishApp/Views/Metagenomics/CzIdProvenanceView.swift` | Popover heading "CZ-ID Pipeline Info" and its rows Sample, Project, Format Version, Rows, Pipeline, NT Database, NR Database, Bundle, Source Files. Rows are selectable text. Width 360. |
| `Sources/LungfishKit/ClassifierActionBar.swift` | Action bar button titles BLAST Verify, Export, Extract FASTQ, plus the Provenance button. |
| `Sources/LungfishApp/Views/Metagenomics/TaxonomyTableView.swift:18-28` | Table columns Sample, Taxon Name, Rank, Reads, Direct, Bracken, %. Bracken is hidden unless Bracken ran, which is why an imported CZ ID result has no Bracken column. |
| `Sources/LungfishApp/Views/MainWindow/MainSplitViewController+ClassifierDisplay.swift:1053-1098` | Selecting the bundle in the sidebar reads `cz-id-manifest.json`, loads the `ClassificationResult`, and configures `CzIdResultViewController`. Failure alert "Failed to Load CZ-ID Result". |
| `Sources/LungfishApp/Views/Sidebar/SidebarProjectScanner.swift:324-329` | A `.lungfishtax` folder is shown as a CZ ID result only when it holds `cz-id-manifest.json`, otherwise as a plain document. |

## Imports/ versus Analyses/ versus Classifications/

The answer is `Classifications/` on both paths, and neither `Imports/` nor
`Analyses/` is ever written to by this import.

On the CLI, command 5 above printed the output path
`demo.lungfish/Classifications/Sample-CZ-001.lungfishtax` and `find` confirmed
the bundle is the only thing in the project. On the GUI,
`AppDelegate+ToolsMenu.swift:860-867` builds the destination as
`projectURL.appendingPathComponent("Classifications").appendingPathComponent("<name>.lungfishtax")`,
with no `AnalysesFolder.createAnalysisDirectory` call anywhere in the CZ ID
path, unlike the Kraken 2 and EsViritu paths.

This is worth flagging against the consistency sheet, which lists `cz-id` in
`AnalysesFolder.knownTools`. That list entry is dead for this import. It would
matter only if some other CZ ID code path called
`createAnalysisDirectory(tool: "cz-id", ...)`, and none does in this build.

## Defects found

1. **The CZ-ID Import sheet's Project Destination readout names a folder no
   import writes to.** `CzIdImportDialogPresentation.destinationText`
   (`CzIdImportSheet.swift:47-59`) composes
   `<project>/Analyses/cz-id-<timestamp>`, while both the app handler
   (`AppDelegate+ToolsMenu.swift:860-867`) and the CLI write
   `<project>/Classifications/<sample>.lungfishtax`. A reader who trusts the
   sheet will look in the wrong folder. The readout is cosmetic and the import
   itself is correct. The chapter documents this in step 5 of the Procedure and
   again under "Known defect in this build" so the reader is not misled.
   Severity is low but the confusion is certain, since the sheet is the only
   place the app states a destination.

2. **The action bar's taxon count includes the root row.** The manifest's
   `rowCount` counts every row in the report, so the reference bundle's action
   bar reads "3 taxa" for a report holding two real taxa plus root. The
   `cz-id summary` table and the sunburst both drop root, so the same bundle
   reports 3 in one place and 2 in another. The chapter states this plainly in
   Reading the results rather than papering over it. Arguably intended, since
   Rows is documented as a row count throughout the sheet and the CLI, but the
   action bar labels it "taxa" rather than "rows", which is where the mismatch
   comes from.

## Ground-truth rows settled or corrected by this pass

- Claim 5, previously **unverifiable**. Now verified. The bundle holds
  `classification-result.json`, `classification.kreport`,
  `classification.czid.tsv`, `cz-id-manifest.json`, and
  `.lungfish-provenance.json`, plus a `provenance/` folder with one sidecar per
  output file. NT and NR metrics are kept in the preserved original report, but
  only NT counts reach the kreport, which the old chapter did not say.
- Claim 11's open question. The **Report** row and the **Top taxa** row both
  exist, at `CzIdImportSheet.swift:227` and `:236-241`. The ground truth said
  they could not be located in `:192-243` and suggested dropping them. They
  stay, and Top taxa is capped at five names.
- Claim 12's wording. The button is titled **Run**, not **Import**. The gate
  described is correct.
- Claim 16, previously **unverifiable**. Now verified by commands 3 and 4. The
  TSV columns and the root-dropping rule are exactly as the old chapter said.
  The JSON form carries four more fields than the old chapter listed.
- Changed claim 1. The chapter now says the import is not available under
  **Tools > Classification**, with the `FASTQ/FASTA Operations` path removed.

## Missing rows covered

All five Missing rows are now in the chapter. The **Browse...** button and the
Project Destination section are in Procedure step 3. The card's file hint is
quoted in step 2. The dedicated result viewport is the subject of the Reading
the results subsection headed "The viewport", including the action bar's info
text and the disabled Extract FASTQ button with its tooltip. The provenance
view has its own subsection. The `cz-id import` versus `import cz-id`
distinction closes On the command line.

## Screenshots

The old chapter had no shots and an empty `planned_shots`, which the ground
truth called not adequate. Four shots are declared, two more than the ground
truth asked for, because the result viewport and the provenance popover are
both surfaces the chapter now describes in detail.

- `czid-import-card`, the Import Center card with its file hint.
- `czid-import-sheet`, the sheet with a successful preview.
- `czid-result-viewport`, the imported result in the taxonomy viewport.
- `czid-provenance-popover`, the CZ-ID Pipeline Info popover.

## Glossary

Two terms added to `GLOSSARY.md` in alphabetical order and listed in
`glossary_refs`.

- **Reads per million** `{#reads-per-million}`, inserted after "Reads per
  billion" and before "Regular expression". Shaped on the existing "Reads per
  billion" entry.
- **Taxon report** `{#taxon-report}`, inserted after "Taxon" and before
  "Taxonomic rank".

`CZ-ID` `{#cz-id}` already existed and already named the `Classifications/`
folder correctly, so it needed no change.

## What could not be verified

- **No GUI run.** Every window claim in this chapter comes from source
  reading, not from driving the app. The Preview panel's exact rendering, the
  Operations Panel row's live detail text, the sunburst drawn from a three-row
  report, and the provenance popover were all read out of Swift rather than
  seen. The four shots will settle them at capture time, and the Project
  Destination defect in particular should be confirmed on screen before it is
  reported as a bug rather than a documentation note.
- **A real CZ ID export.** The repository fixture is synthetic and minimal. A
  genuine export from the CZ ID web interface may carry columns, a folder
  layout, or a ZIP structure the fixture does not exercise. In particular the
  ZIP path was tested against an archive built here with `zip`, not against a
  CZ ID download, and `findTaxonReport` picks the report out of an unpacked
  folder by rules that were not tested against a real multi-file export.
- **Multi-sample exports.** The chapter's What good looks like tells the reader
  to check whether they pointed the importer at one sample's report inside a
  multi-sample export. That failure mode is inferred from the importer taking
  one sample name and one report, and was not reproduced.
- **The Operations Panel row text.** Taken from the `OperationCenter.start` and
  `complete` calls in the source. The panel was not opened.

## Phase 5 notes

1. **The fixture is still an open item and the chapter is written around that.**
   `Tests/Fixtures/czid/minimal_taxon_report.tsv` is a test fixture, not a
   manual fixture. It has no `README.md`, no source, no licence, and no
   citation block, so it does not meet the bar in
   `docs/user-manual/fixtures/README.md` and the author persona forbids using a
   fixture without complete metadata. `fixtures_refs` is therefore empty and
   Before you start asks the reader to export their own report, naming the test
   file only as the provenance of the chapter's figures. If Phase 5 publishes a
   `docs/user-manual/fixtures/czid/` folder, three things change. Before you
   start gains the fixture name, the GitHub link, and, if the fixture is a
   folder rather than one file, the fixed Download ZIP sentence from the
   consistency sheet. `fixtures_refs` gains the folder name. The sentence
   naming `Tests/Fixtures/czid/` comes out.
2. **The Download ZIP sentence is not in this chapter**, because there is no
   fixture folder to download. It becomes required the moment a folder fixture
   ships.
3. **The Project Destination defect wants a decision.** The chapter currently
   documents it in place, in the Procedure and again under its own heading. If
   the sheet is fixed before the manual ships, both passages come out and step 5
   loses its warning. If it is not fixed, the passages stay. Either way the
   chapter should not go to the brand pass until that is settled, because the
   fix removes about a paragraph of prose.
4. **The `AnalysesFolder.knownTools` entry for `cz-id` is dead** on this path.
   Worth a consistency-sheet line if another chapter's author trips on it,
   since the sheet currently lists `cz-id` among the tools that get an
   `Analyses/<tool>-<timestamp>/` folder and this import does not.
