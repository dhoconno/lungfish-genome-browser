# Fidelity review, 06-classification/08-importing-cz-id-results

Chapter: `docs/user-manual/chapters/06-classification/08-importing-cz-id-results.md`
Roster row 39, registry id `import.cz-id`, title "Importing CZ ID Results".
Reviewed 2026-09-07 against the 2026.9.13 Preview source tree in the worktree
`.claude/worktrees/user-manual-fidelity-campaign`.

Evidence used. Swift source under `Sources/`, the CLI help dumps under
`reviews/fidelity-2026-09/cli-help/`, `docs/user-manual/parameters.yaml`,
`docs/user-manual/GLOSSARY.md`, and eleven read-only reruns of the author's
commands against the author's scratch outputs at
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/cz-id/`.
No GUI run. Every window claim below is verified from source, not from screen.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "The command-line help states the boundary in one line, saying that the command imports existing CZ ID outputs and does not run or submit data to CZ ID." | true | `cli-help/cz-id.txt`, `==== cz-id ====`, "This command imports existing CZ-ID outputs; it does not run or submit data to CZ-ID." | |
| "The import is not available under **Tools > Classification**, and it does not turn CZ ID into a runnable option there." | true | `FASTQOperationDialogState.swift:2070` omits CZ-ID from the classification tool list. `MainMenu.swift:786-819` builds the menu as **Tools > Classification**. Applies DRIFT row 1's correction, dropping the old `FASTQ/FASTA Operations` path. | |
| "The conversion writes a kreport, the tab-separated summary format Kraken 2 uses" | true | Rerun of the reference import wrote `classification.kreport`, three tab-separated lines, `cat -A` confirms `^I` separators | |
| "it also keeps the original report verbatim beside the converted copy" | true | `shasum -a 256` on source and `classification.czid.tsv` both give `3852c1bdcf6bfdc9575b20cdab99c142799c3cc6b35b28302d08ef10758f3f20` | |
| "You need a project open ... choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder." | true | `MainMenu.swift:169-173`, title "New Project", `keyEquivalent: "n"`. Matches the fixed sentence in CONSISTENCY.md line 143 verbatim | |
| "the import stops with the message 'CZ-ID taxon report must include tax_id, taxon_name, and rank columns' and writes nothing" | true | `CzIdDataConverter.swift:521` holds the string. Rerun against `bad.tsv` printed it, exited 1, and wrote nothing under `Classifications/` | |
| "CZ ID hands its reports out in three shapes, and LGE accepts all three" (TSV, ZIP, extracted folder) | true | `CzIdImportPreview.swift:8-20`, `SourceKind` cases `taxonReportFile`, `zipArchive`, `extractedFolder`, display names "Taxon report file", "ZIP archive", "Extracted folder". `cli-help/import.txt` argument text names all three | |
| "The reference run confirmed all three paths against the same three-row report, and each produced an identical bundle." | true | Reran `shasum` on all three bundles' kreports. `Sample-CZ-001`, `Sample-CZ-ZIP`, and `Sample-CZ-FOLDER` all give `04eb7fa89080875688ad...` | Caveat for the editor. The ZIP was built locally with `zip`, not downloaded from CZ ID. The author flags this and the chapter does not overclaim. |
| "Choose **File > Import Center...** and click the **Classification Results** tab." | true | `MainMenu.swift:208` titles the item `Import Center…`. `ImportCenterViewModel.swift:499-507` sets `tab: .classificationResults` on the CZ-ID card. Matches CONSISTENCY.md line 27 | |
| "It carries a small `CZ` badge for an icon, and its file hint reads 'taxon report TSV, .zip, or extracted folder'." | true | `ImportCenterViewModel.swift:503-504`, `TextBadgeIcon.image(text: "CZ", size: NSSize(width: 28, height: 28))` and `fileHint: "taxon report TSV, .zip, or extracted folder"` | |
| "The card's own description states the boundary again, that CZ ID is imported and not run locally." | true | `ImportCenterViewModel.swift:501`, "CZ-ID is imported, not run locally" | |
| "A sheet titled **CZ-ID Import** opens, subtitled 'Hosted metagenomics taxon report'." | true | `CzIdImportSheet.swift:117-118` | |
| "The readout beside the button reads 'No file or folder selected' until you do, and the status line at the foot of the sheet reads 'Select a CZ-ID export.'" | true | `CzIdImportSheet.swift:27` and `:42` | |
| "The status line reads 'Scanning CZ-ID export...' while it works" | true | `CzIdImportSheet.swift:33`. The literal is `Scanning CZ-ID export\u{2026}`, an ellipsis character, which the chapter renders as three dots as the manual does elsewhere | |
| Preview panel rows "Sample, Project, Rows, Source, Report, Pipeline, NT DB, NR DB, and Top taxa" | true | `CzIdImportSheet.swift:218-243` renders exactly these nine labels in this order. Settles DRIFT row 11's open question, the Report and Top taxa rows do exist | |
| "The Project row appears only when the export carries a project identifier, and the Pipeline, NT DB, and NR DB rows only when the report carries those columns." | true | `CzIdImportSheet.swift:220-235`, each of the four is wrapped in an `if let` plus a non-empty test | |
| "Top taxa lists at most five names." | true | `CzIdImportPreview.swift:111`, `.prefix(5)`, applied after root is filtered out and rows are sorted by NT read count descending | |
| Preview named sample `Sample-CZ-001`, project `Project-42`, 3 rows, source "Taxon report file", pipeline `8.4`, NT `nt_2025_12_01`, NR `nr_2025_12_01` | true | Rerun of `cz-id summary` prints the same five values. `cz-id-manifest.json` from the rerun import carries `projectId` `Project-42` and `rowCount` 3 | |
| "The button is labelled Run rather than Import" | true | `CzIdImportSheet.swift:124`, `primaryTitle: "Run"`. Corrects DRIFT row 12, which called it the Import button | |
| "it stays disabled until a path is selected and the scan has finished and succeeded" | true | `CzIdImportSheet.swift:30`, `isPrimaryEnabled = selectedPath != nil && preview != nil && !isScanning`. A failed scan leaves `preview` nil | |
| "If the scan failed, an amber triangle and the reason appear in the Preview panel instead of the rows" | true | `CzIdImportSheet.swift:206-217`, `exclamationmark.triangle.fill` with `.foregroundStyle(.yellow)` on a yellow-tinted rounded rectangle | The symbol is filled and tinted `.yellow` in source. "Amber" is a fair reading of the rendered SF Symbol, but the shot will settle it. Low importance. |
| **Defect claim 1.** "The **Project Destination** readout ... shows a path under the project's `Analyses` folder ending in `cz-id-` and a timestamp, but the importer writes the bundle to the project's `Classifications` folder instead, on both the app path and the command-line path." | true | Confirmed. `CzIdImportSheet.swift:47-59`, `destinationText` composes `projectURL/Analyses/cz-id-<timestampHint>` with `timestampHint` formatted `yyyy-MM-dd'T'HH-mm-ss`, and falls back to the string "Current project / Analyses" when no project is open. Against that, `AppDelegate+ToolsMenu.swift:860-867` builds `projectURL/Classifications/<bundleFileName>.lungfishtax`, and the CLI rerun wrote `demo.lungfish/Classifications/Sample-CZ-001.lungfishtax`. No `createAnalysisDirectory` call exists anywhere under `Sources/LungfishWorkflow/Metagenomics/CzId/` or in the CZ ID app path, so nothing ever creates the `Analyses/` folder the readout names | |
| "The row is titled 'CZ-ID Import' and its detail reads 'Converting' followed by the report's file name, then finishes with 'Imported' and the sample name." | true | `AppDelegate+ToolsMenu.swift:883-885` starts with `title: "CZ-ID Import"` and `detail: "Converting \(preview.reportFileName)..."`. `:912` completes with `detail: "Imported \(imported.sampleName)"` | |
| "The row carries the equivalent command line" | true | `AppDelegate+ToolsMenu.swift:870-880` builds `cliCmd` via `OperationCenter.buildCLICommand` and passes it as `cliCommand:` | |
| "The bundle lands at `Classifications/<sample>.lungfishtax` inside the project, named from the sample name with any character that is not a letter, a digit, a dot, a hyphen, or an underscore replaced by a hyphen." | true | `CzIdProjectImportWorkflow.swift:88-97`, `CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "._-"))`, everything else becomes `-` | The source does two further things the chapter omits, collapsing runs of hyphens and trimming leading or trailing dots and hyphens, falling back to `cz-id-sample` when nothing survives. Optional to add. |
| The CLI block `lungfish-cli import cz-id <path> --project <p> --sample-name <n>` | true | `cli-help/import.txt`, `==== import cz-id ====`, usage line requires exactly these. Rerun exited 0 | |
| "The CZ ID import has no settings." | true | `parameters.yaml` `import.cz-id` has `settings: []`. `CzIdImportSheet.swift:145-153` shows the three sections carry a Browse button, a read-only path, the preview, and a read-only destination | |
| "**--sample-name.** ... It has no default and the flag is required" | true | `cli-help/import.txt` usage line places `--sample-name <sample-name>` outside brackets. `parameters.yaml` records "none, and the flag is required" | |
| "the app path takes this name from the report's own sample column instead of asking you" | true | `AppDelegate+ToolsMenu.swift:857`, `let sampleName = preview.sampleName`, and there is no name field in the sheet | |
| "**--metadata.** ... the file is recorded as an input in provenance with its size and checksum rather than copied into the bundle." | true | Reread the author's `Sample-CZ-Prov` bundle provenance. `metadata.json` appears with `role` `input`, `sizeBytes` 55, and a sha256, and the bundle directory holds only the five standard files plus `provenance/` | |
| "**--non-host-fastq.** ... the path, size, and checksum are recorded rather than the reads copied." | true | Same provenance file, `non-host.fastq.gz`, `role` `input`, `sizeBytes` 34, sha256 present, not copied in | |
| The terminal output block under Reading the results | true | Rerun of the import prints the block character for character, Sample `Sample-CZ-001`, Rows 3, Pipeline 8.4, and both database versions | |
| "Rows counts every taxon row in the report, including the `root` row" | true | `cz-id-manifest.json` `rowCount` is 3 for a report whose data rows are root, Viruses, and SARS-CoV-2 | |
| "The reference run's bundle held five files beside a `provenance` folder." | true | `find` rerun lists `classification.czid.tsv`, `classification.kreport`, `classification-result.json`, `cz-id-manifest.json`, and `.lungfish-provenance.json`, plus `provenance/` holding five per-file sidecars | |
| "`classification-result.json` records the run as LGE models it, naming the database `CZ-ID` and the database version `nt=nt_2025_12_01; nr=nr_2025_12_01`." | true | Both values are present, nested under the `config` object rather than at top level, alongside `toolVersion` `8.4`, `reportPath` `classification.kreport`, and `outputPath` `classification.czid.tsv`. The chapter claims the file records them and does not claim where, so it stands | |
| "`cz-id-manifest.json` holds the sample name, the project identifier, the row count, the three versions, and a schema version reading `cz-id-taxon-report-v1`." | true | Reread the manifest. All six fields present, `schemaVersion` is `cz-id-taxon-report-v1`. It also carries `sourceFiles`, which the chapter does not list here but does describe in the popover subsection | |
| "`.lungfish-provenance.json` is the sidecar for the whole import, recording the argv, the exit status, the wall time, and every input and output file with its size and SHA-256 checksum." | true | Reread. `argv`, `exitStatus` 0, `wallTimeSeconds`, and a `files` array carrying `role`, `sizeBytes`, and `sha256` per entry. `workflowName` is "CZ-ID Import" | |
| The three-line kreport block | true | `cat` of the rerun's `classification.kreport` matches byte for byte, including `100.00`, `7.33`, `3.50`, the `R`/`D`/`S` codes, and the two-space indents before Viruses and the species name | |
| "Viruses drew 88 of the sample's 1,200 reads, which is 7.33 percent, and SARS-CoV-2 drew 42 of them, which is 3.50 percent." | true | 88/1200 = 7.333, 42/1200 = 3.50. `CzIdDataConverter.swift:166-185` divides each row's NT read count by the root row's | |
| "Only the NT read counts reach the kreport. NR counts, percent identity, alignment length, and e-value stay in the preserved original report" | true | The kreport's columns 2 and 3 carry 1200/88/42, the NT counts. The `--format json` rerun shows `nrReadCount`, `ntPercentIdentity`, `ntAlignmentLength`, and `ntEValue` are parsed and available, yet none appears in the kreport | |
| "Selecting the bundle opens the taxonomy viewport, the same one a Kraken 2 run opens." | true | `CzIdResultViewController.swift:11` holds a `TaxonomyViewController` and `:52-65` embeds it edge to edge. `MainSplitViewController+ClassifierDisplay.swift:1053-1098` routes a selected `.lungfishtax` there | |
| "A sunburst chart sits on the left ... and the per-taxon table sits on the right with a breadcrumb bar" | true | Inherited whole from `TaxonomyViewController`. Consistent with chapter 02 line 46, which describes the same three parts | |
| "The action bar ... reads 'Imported CZ-ID result' followed by the sample name and the taxon count" | true | `CzIdResultViewController.swift:41-43`, `"Imported CZ-ID result · \(manifest.sampleName) · \(manifest.rowCount) taxa"` | The separator is a middle dot. The chapter's "followed by" is accurate without quoting the glyph. |
| **Defect claim 2.** "The count shown is the manifest's row count, which includes the root row, so the reference bundle reports 3 taxa for a report holding two real ones." | true | Confirmed. `CzIdResultViewController.swift:43` interpolates `manifest.rowCount`, which the rerun manifest gives as 3. Against that, `CzIdImportPreview.swift:104-111` filters `taxId != 1` and rank `root` out of Top taxa, and the `cz-id summary` rerun lists two rows. The same bundle reports 3 in the action bar and 2 in the summary | |
| Table columns "Sample, Taxon Name, Rank, Reads, Direct, and a percent column headed simply **%**" | true | `TaxonomyTableView.swift:18-28` documents Sample, Taxon Name, Rank, Reads, Direct, Bracken, %. Matches chapter 02 line 190 | |
| "There is no Bracken column, because that column appears only when Bracken ran" | true | `TaxonomyTableView.swift:24`, "hidden unless Bracken ran". No CZ ID path runs Bracken, and the rerun's `classification-result.json` has `profileOutcome.state` `notRequested` | |
| "In a CZ ID import the two are equal for every row, because the report gives one count per taxon" | true | The kreport's columns 2 and 3 are identical on all three rows, 1200/1200, 88/88, 42/42 | |
| "The action bar's **Extract FASTQ** button is deliberately disabled on a CZ ID result, and hovering it explains why, reading 'CZ-ID imports do not include per-read source IDs for FASTQ extraction.'" | true | `CzIdResultViewController.swift:46-48`, `setExtractEnabled(false)` then the tooltip string verbatim | |
| "**BLAST Verify** and **Export** stay available." | true | `ClassifierActionBar.swift:24` and `:38` create both, and nothing in `CzIdResultViewController.configure` disables either. Only Extract is disabled | |
| "The action bar's rightmost button opens a popover headed **CZ-ID Pipeline Info**" | true | `ClassifierActionBar.swift:210` pins `provenanceButton` to the trailing edge, making it rightmost. `CzIdResultViewController.swift:44-45` wires `onProvenance`. `CzIdProvenanceView.swift:14` sets the heading | |
| Popover lists "Sample, Project when the export carried one, Format Version, Rows, Pipeline, NT Database, NR Database, the bundle's path on disk, and every source file" | true | `CzIdProvenanceView.swift:17-36`, in that order. Project is conditional on a non-empty `projectId`, Bundle is conditional on a non-nil `bundleURL`, and Source Files is a labelled group of `File` rows | |
| "Each row is selectable text" | true | `CzIdProvenanceView.swift:54`, `.textSelection(.enabled)` | Strictly the modifier is on the value text, not the label. The reader copies values, so the claim holds in practice. |
| "`cz-id summary` prints a text table by default" and the quoted summary block | true | Rerun with `--top 20` reproduced the block exactly, including the box-drawing rule and the column spacing | |
| "The table drops the root row and ranks what is left by NT read count, so a three-row report shows two taxa." | true | Rerun lists Viruses (88) then SARS-CoV-2 (42), no root | |
| "NT RPM is reads per million" and the values 73333.0 and 35000.0 | true | Rerun prints both. 88/1200 x 1e6 = 73,333 and 42/1200 x 1e6 = 35,000 | |
| "`--top` caps how many taxa are listed and defaults to 20." | true | `cli-help/cz-id.txt`, `==== cz-id summary ====`, "--top <top> Number of top taxa to display (default: 20)" | |
| "The `--format tsv` form writes a header row and the columns `tax_id`, `name`, `rank`, `nt_reads`, `nt_rpm`, and `nr_reads`." | true | Rerun printed exactly that header. Settles DRIFT row 16, previously unverifiable | |
| "The `--format json` form emits an array of records carrying those fields plus `ntPercentIdentity`, `ntAlignmentLength`, `ntEValue`, and `nrRpm`." | false | The four extra field names are right, but "those fields" points back at the TSV column names, and the JSON uses different keys. The rerun emits `taxId`, `name`, `rank`, `ntReadCount`, `ntRpm`, and `nrReadCount`, not `tax_id`, `nt_reads`, or `nr_reads`. A reader writing a parser against this sentence will look for the wrong keys | "The `--format json` form emits an array of records. It carries the same six values under camel-case names, `taxId`, `name`, `rank`, `ntReadCount`, `ntRpm`, and `nrReadCount`, plus four the TSV omits, `ntPercentIdentity`, `ntAlignmentLength`, `ntEValue`, and `nrRpm`." |
| "Both drop the root row and both respect `--top`." | true | Both reruns list two rows and no root. `--top 3` and `--top 5` reruns in the author's record show the cap applied | |
| "`lungfish-cli import cz-id` puts the result inside a project and requires `--project` and `--sample-name`." | true | `cli-help/import.txt` usage line places both outside brackets | |
| "`lungfish-cli cz-id import` takes neither, derives the sample name from the export itself, and writes a self-contained result folder wherever `--output-dir` points, defaulting to `./cz-id-{sample}`." | true | `cli-help/cz-id.txt`, `==== cz-id import ====`, usage carries no `--project` and no `--sample-name`, and `-o, --output-dir` documents "(default: ./cz-id-{sample})". The author's `standalone/` folder holds the same five files | |
| "The reference import of the three-row report finished in well under a second" | true | The rerun's `.lungfish-provenance.json` gives `wallTimeSeconds` 0.0054 | |
| "No plugin pack is needed." | true | `parameters.yaml` `import.cz-id` has `gating: []`, and nothing in the CZ ID path touches the conda or plugin machinery | |
| Cross-reference "**Operations > Show Operations Panel** (Cmd-Shift-P)" | true | `MainMenu.swift:866-873`, `keyEquivalent: "p"` with `[.command, .shift]`. Matches CONSISTENCY.md line 33 | |
| "a report of a few thousand rows will still finish while you are reading the sheet" | unverifiable | Extrapolated from a three-row import. Nothing was run at that scale. The claim is a reassurance rather than a number, and the 0.0054s measurement makes it plausible. A single import of a few-thousand-row report would settle it | |
| "A count far smaller than expected usually means you pointed the importer at one sample's report inside a multi-sample export" | unverifiable | The author flags this as inferred from the importer taking one sample name and one report, and says it was not reproduced. No multi-sample CZ ID export was available. A real multi-sample export would settle it | |
| "A disagreement means the report's root row and its taxon rows came from different runs, which happens when an export is assembled by hand from two downloads." | unverifiable | The arithmetic behind it is sound, since every percentage is computed against the root row, so a foreign root row would skew all of them. The stated cause, hand-assembly from two downloads, is a plausible story rather than an observed one. Nothing in the source or the CLI can confirm how often it happens | |

## Front matter

Checked against the schema at `STYLE.md:153-175` and the sibling chapter
`03-running-esviritu.md`. Every required key is present and correctly typed.

`chapter_id` matches the file location. `parameters_refs: [import.cz-id]`
matches the roster row and resolves in `parameters.yaml`. `tools: [cz-id]`
matches the CLI command group. The three `entry_points` all resolve, the
Import Center path against `MainMenu.swift:208` and
`ImportCenterViewModel.swift:499-507`, and the two CLI entries against the
help dumps. `prereqs` names two chapters that exist. `audience:
bench-scientist` is right for a chapter that glosses read, taxon, and
metagenomics from scratch. `brand_reviewed: false` and `lead_approved: false`
are correct for a chapter that has not been through those gates.

`fixtures_refs: []` is correct and deliberate. There is no
`docs/user-manual/fixtures/czid/` folder, so there is nothing to name, and
the author's reasoning in Phase 5 note 1 is sound. `features_refs: []` is
consistent with the campaign's other classification chapters.

Four shot captions, all accurate against source.

- `czid-import-card`. The file hint quoted matches
  `ImportCenterViewModel.swift:504` verbatim.
- `czid-import-sheet`. The nine preview labels and their order match
  `CzIdImportSheet.swift:218-243`. The three named sections match `:145-153`.
- `czid-result-viewport`. The action bar text matches
  `CzIdResultViewController.swift:41-43`, and the left-right layout matches
  the embedded `TaxonomyViewController`.
- `czid-provenance-popover`. The nine popover rows and their order match
  `CzIdProvenanceView.swift:17-36`.

One caution for the capture pass. `czid-import-sheet` asks the shot to show
the Project Destination readout, which is the defective control. That is the
right call, since the chapter documents the defect and the shot is the
evidence, but whoever captures it should not silently crop the readout out.
If the sheet is fixed before capture, the caption and two passages of prose
change together.

## Settings coverage against parameters.yaml

`parameters.yaml` gives `import.cz-id` an empty `settings` list and three
`cli_only` flags. The chapter covers all three and invents none.

| Registry entry | Covered | Shape |
|---|---|---|
| `settings: []` | yes | The Settings section opens by saying the import has no settings and names each of the five controls that are not settings. Accurate against `CzIdImportSheet.swift:145-153` |
| `--sample-name` | yes | Three-sentence shape held. Default stated as "no default and the flag is required", matching the registry's "none, and the flag is required" |
| `--metadata` | yes | Three-sentence shape held. Default "none" stated as "There is no default" |
| `--non-host-fastq` | yes | Three-sentence shape held. Default "none" stated the same way |

Each of the three paragraphs opens with the flag in bold with the period
inside the bold, and closes with the fixed "On the command line this is
`--flag`" sentence the campaign uses for cli_only entries. Coverage is
complete.

## Consistency

Checked against `CONSISTENCY.md` and the committed chapters
`02-running-kraken2.md` and `03-running-esviritu.md`.

Agreements. The Import Center is written as **File > Import Center...**, the
form CONSISTENCY.md line 27 fixes. The Operations panel sentence and its
Cmd-Shift-P shortcut match line 33. The Before you start opening matches the
fixed two-sentence shape at line 143, adapted for a chapter with no fixture,
which is the right adaptation since there is no GitHub link to give. The
viewport prose agrees with chapter 02 on the sunburst, the breadcrumb bar,
the column list, and the Reads versus Direct distinction, and it defers to
chapter 02 rather than restating the sunburst controls. "Lungfish Genome
Explorer (LGE)" appears at first mention and "LGE" after. The Run button
naming matches the dialog convention.

The Download ZIP sentence is correctly absent, since there is no fixture
folder to download. It becomes required if Phase 5 ships one.

One live conflict, for the sheet rather than the chapter. CONSISTENCY.md
lines 58 to 61 list `cz-id` among the tools that get an
`Analyses/<tool>-<timestamp>/` folder, drawn from
`AnalysesFolder.knownTools`. That entry is dead for this import. I confirmed
`AnalysesFolder.swift:24-28` does list `cz-id`, and also that
`AnalysesFolder.swift:32` puts `cz-id` in `importedResultTools`, a set that
governs how an existing directory is named and parsed rather than whether
one is created. No CZ ID code path calls `createAnalysisDirectory` at all.
The chapter is right and the consistency sheet's folder section is
misleading on this one tool. It needs a line saying the CZ ID import writes
to `Classifications/` despite the `knownTools` membership, so the next
author does not trip on it. The author raised this in Phase 5 note 4 and I
am seconding it.

## App defects

Both of the author's claims are confirmed. Neither is a documentation error.

**1. The CZ-ID Import sheet's Project Destination readout names a folder no
import writes to.** Confirmed, severity low, confusion certain.
`CzIdImportSheet.swift:47-59` composes the readout as
`<project>/Analyses/cz-id-<timestamp>`, and its no-project fallback string
is "Current project / Analyses". Both the app handler
(`AppDelegate+ToolsMenu.swift:860-867`) and the CLI write
`<project>/Classifications/<sample>.lungfishtax`, which my rerun confirmed
on disk. Nothing under `Sources/LungfishWorkflow/Metagenomics/CzId/` or the
CZ ID app path calls `createAnalysisDirectory`, so the `Analyses/` folder
the readout names is never created by this import. The readout is
display-only and the import is correct. The fix is a one-line change to
`destinationText` to compose the `Classifications/` path from the scanned
preview's sample name.

**2. The action bar's taxon count includes the root row.** Confirmed,
severity low. `CzIdResultViewController.swift:43` labels
`manifest.rowCount` as "taxa", and that count includes root, so the
reference bundle reads "3 taxa" for two real taxa. The same bundle's
`cz-id summary` shows two rows, because `CzIdImportPreview.swift:104-111`
filters root out. The mismatch is in the word "taxa" rather than in the
number, since Rows is documented as a row count everywhere else. Either
subtract the root row from the count or relabel it "rows".

**3. New, not in the author's report. The Project Destination readout
recomputes its timestamp on every view update.** `timestampHint` is a
computed static property that calls `DateFormatter().string(from: Date())`
each time it is read (`CzIdImportSheet.swift:55-59`), and it is read from
`destinationText` inside `CzIdImportDialogPresentation.init`, which the
sheet rebuilds on every state change through the computed `presentation`
property (`:104-113`). So the path shown in the sheet changes as the user
interacts with it, and `CzIdImportDialogPresentation`'s `==` compares
`destinationText`, meaning two presentations built a second apart never
compare equal. Severity is very low while defect 1 stands, because the whole
readout is wrong anyway, but it matters for the fix. Whoever repairs defect
1 should not carry the timestamp across, since the correct path has no
timestamp in it. Worth noting because a naive fix that keeps
`timestampHint` would leave the equality behaviour broken.

## Notes for the editor

**The one false claim is small and self-contained.** The JSON field-name
sentence in On the command line is the only correction needed. The
replacement wording is in the claim table. Nothing else in the chapter needs
a change for accuracy.

**Two optional additions, both discretionary.** The bundle-name
sanitisation sentence omits two behaviours the source has, collapsing runs
of hyphens and trimming leading and trailing dots and hyphens. The chapter's
version is correct as far as it goes and the omission only bites a reader
who names a sample something exotic. Add it only if the sentence can absorb
it without growing.

**The defect passages are load-bearing and correctly placed.** The chapter
warns about defect 1 twice, in Procedure step 5 and again under its own
heading in What good looks like. That is the right treatment for a defect
that would otherwise send a reader to an empty folder. Both passages come
out together if the sheet is fixed, as the author says in Phase 5 note 3.
The chapter should not go to the brand pass until that is settled.

**The three unverifiable claims are all in What good looks like** and all
three are advice rather than assertions about what the app does. None of
them misleads a reader who follows them, and the failure modes they describe
are reasonable inferences from how the importer works. I would leave all
three. If the editor wants them tightened, the multi-sample sentence is the
one worth softening, since it names a specific cause for a symptom that has
several.

**No GUI run stands behind any window claim.** Every sheet, viewport, and
popover claim in this chapter is verified from Swift source and is correct
as source. The four shots will confirm them at capture time. Defect 1 in
particular should be seen on screen before it is filed as a bug rather than
carried as a documentation note, which is what the author recommends and
what I would do.

**The chapter's viral framing is justified and stated.** The campaign
prefers human or macaque examples, and this chapter opens Why you would do
this by saying it is one of the manual's viral examples because CZ ID is a
pathogen-detection service. That is the documented exception and it is
invoked correctly.

**Lint is green.** `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` prints "no
issues found", exit 0, on the chapter as committed.

## Counts

True 56. False 1. Unverifiable 3.

Defects confirmed 2, both from the author's report. Defects newly found 1,
the recomputed timestamp in the same readout as defect 1. Consistency-sheet
corrections needed 1, the dead `cz-id` entry in the `Analyses/` folder
section. Settings coverage complete, three of three cli_only flags and the
empty settings list. Glossary refs 15 of 15 resolve in `GLOSSARY.md`,
including the two the author added, `reads-per-million` at line 453 and
`taxon-report` at line 565.
