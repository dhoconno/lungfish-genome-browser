# Fidelity review, 06-classification/05-running-nao-mgs.md

Chapter: Importing NAO-MGS Results. Roster row 36, registry id `import.nao-mgs`.
Reviewed against Preview 2026.9.13 sources, the CLI help tree, the author's
scratch bundle, and reruns of the author's read-only commands.

Binary used: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.
Bundle inspected:
`<scratchpad>/nao-mgs/scratch.lungfish/naomgs-virus_hits_final/`.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "NAO-MGS is a metagenomic surveillance pipeline built by SecureBio for wastewater pathogen monitoring." | true | `NaoMgsResultParser.swift:319` names `https://github.com/securebio/nao-mgs-workflow`; `cli-help/nao-mgs.txt` banner "Import results from the SecureBio NAO-MGS metagenomic surveillance pipeline" | |
| 2 | "LGE does not run that pipeline, and there is no way to start one from inside the window." | true | `FASTQOperationDialogState.swift:2070` omits naomgs from the run wizard; `ImportCenterViewModel.swift:414-422` routes it to a wizard sheet only | |
| 3 | "The file LGE reads is `virus_hits_final.tsv.gz` ... the importer accepts [`_virus_hits.tsv.gz`] too." | true | `ImportCenterViewModel.swift:419` fileHint "virus_hits_final.tsv.gz or _virus_hits.tsv.gz" | |
| 4 | "Point the importer at the results directory and it finds the table for you, or point it at the table itself." | true | `NaoMgsImportSheet.swift:161` "Select a directory containing virus_hits_final.tsv.gz, or the file directly."; `cli-help/import.txt` argument "Path to NAO-MGS results directory or virus_hits_final.tsv(.gz)" | |
| 5 | "there is no `samples/` folder, `metadata.tsv`, or `manifest.json` structure to assemble first." | true | `NaoMgsImportSheet.swift:168-220` renders exactly one Validation section keyed on the header | |
| 6 | "The pipeline reports viral taxa and nothing else, so a wastewater sample's bacteria never appear." | true | Fixture's four taxa are all viral (28875, 10941, 2748378, 1187973); parser is a virus-hits parser | |
| 7 | "Each row holds one read's alignment ... Thirty columns wide, one row per matching read." | true | `gzcat virus_hits_final.tsv.gz \| head -1` gives 30 columns including `query_seq`, `query_qual`; 35 data rows | |
| 8 | "Choose **File > Import Center...**, then click the **Classification Results** tab." | true | `MainMenu.swift:208` adds "Import Center…"; `ImportCenterViewModel.swift:178` names the tab | |
| 9 | "The **NAO-MGS Results** card carries an NM badge and the file hint `virus_hits_final.tsv.gz or _virus_hits.tsv.gz`." | true | `ImportCenterViewModel.swift:415-420` (title, `TextBadgeIcon.image(text: "NM")`, fileHint) | |
| 10 | "The card opens a sheet titled **NAO-MGS Import**." | true | `NaoMgsImportSheet.swift:97` `title: "NAO-MGS Import"` | |
| 11 | "It holds no settings at all, only a source picker and a validation readout." | true | `NaoMgsImportSheet.swift:112-122` composes only `locationSection` and `previewSection`. Note the file's own layout doc comment at `:33-35` still draws a stale "Options / Min % identity" block that the body never renders, so trust the body. | |
| 12 | "Click **Browse...**" | true | `NaoMgsImportSheet.swift:154` `Button("Browse\u{2026}")`. DRIFT row 7 (the old "Choose") is fixed. | |
| 13 | "The chosen path appears in the read-only readout beside the button, truncated in the middle when it is long." | true | `NaoMgsImportSheet.swift:140-147`, `.truncationMode(.middle)` | |
| 14 | "the section shows a green tick beside **Valid NAO-MGS results** and names the source file underneath." | true | `NaoMgsImportSheet.swift:198-210`, `checkmark.circle.fill` in green, then `previewRow(label: "Source file", ...)` | |
| 15 | "it also reports how many files it found, on a row labelled **Files found** whose value counts the per-lane files." | true | `NaoMgsImportSheet.swift:211-216`, shown only when `fileCount > 1`, value "\(fileCount) per-lane files" | |
| 16 | "When the header is not recognisable, the section shows a warning triangle and the reason instead." | true | `NaoMgsImportSheet.swift:185-196`, `exclamationmark.triangle.fill` plus the error string | |
| 17 | "LGE partitions the table by sample, imports each sample in turn, merges the per-sample databases, and resolves the numeric taxonomy identifiers ... at NCBI." | true | `MetagenomicsImportService.swift:868-877` (partition), `:888-908` (per sample), `:915` (merge), plus the taxon-name resolution phase | |
| 18 | "`28875` is the identifier for Rotavirus A" | true | Manifest `cachedTaxonRows` maps taxId 28875 to name "Rotavirus A" | |
| 19 | "**Operations > Show Operations Panel** (Cmd-Shift-P)" | true | `MainMenu.swift:866-872`, keyEquivalent "p" with `[.command, .shift]` | |
| 20 | "The finished result lands in the sidebar under the project's `Analyses` folder, named `naomgs-<sample>`." | true, GUI path only | `AppDelegate+ImportCenter.swift:695-700` uses `AnalysesFolder.url(for: projectURL)` for `.naomgs`. See the Imports/Analyses note below. | Add "when you import through the Import Center". The CLI does not do this. |
| 21 | "named `naomgs-<sample>` after the first sample the table names" | false | The bundle is named from the input file stem, not the sample. The run produced `naomgs-virus_hits_final` while `manifest.sampleName` is `MU-CASPER-...-CA_LosAngeles_County_20260304`. `MetagenomicsImportService.swift:847-859` derives `baseName` from `preferredName ?? preliminarySampleName`, whose fallback is `inputURL.deletingPathExtension().deletingPathExtension().lastPathComponent`. | "named `naomgs-` followed by the sample name when one is given, and by the input file's name otherwise, as in `naomgs-virus_hits_final`." |
| 22 | "On the five-sample surveillance run the import reported 35 hits across 4 distinct taxa." | true | Rerun of `import nao-mgs`: `Total hits : 35`, `Distinct taxa : 4`; manifest `hitCount` 35, `taxonCount` 4 | |
| 23 | "a folder holding a SQLite database of every hit, a `manifest.json` summary, an alignment file per sample under `bams/`, and a provenance record." | false (in part) | The layout is right, but the database is not "of every hit". `virus_hits` holds **0 rows** in the merged bundle (`sqlite3 hits.sqlite`), by design at `NaoMgsDatabase+Merge.swift:15`. It carries summaries and read names only. This claim also contradicts the chapter's own defect note at line 206. | "a folder holding a SQLite database of the per-taxon and per-accession summaries, a `manifest.json` summary, an alignment file per sample under `bams/`, and a provenance record." |
| 24 | "storing the hits that way is what lets the viewport sort a large run and jump to one taxon's reads without re-reading the whole table." | true | `NaoMgsDatabase+Queries.swift:92-110`, `:229-236` are indexed per-sample/per-taxon queries | |
| 25 | "The alignment files are BAMs ... reconstructed from the sequences the pipeline's table carried." | true | `NaoMgsBamMaterializer.materializeAllWithProvenance` at `MetagenomicsImportService.swift:1170`; bundle holds one `.bam` + `.bai` per sample | |
| 26 | Settings, "**Sample name.** ... On the command line this is `--sample-name`." | true | `cli-help/import.txt`, `--sample-name <sample-name>` "Override sample name"; matches `parameters.yaml:1839-1841` | |
| 27 | "It defaults to a name derived from the results themselves, taken from the first sample the virus-hits table names" | false | Same evidence as row 21. The default name comes from the input path stem. The *sample label* recorded in the manifest is the first sample alphabetically (`sortedSamples` at `:885`, first is the CA site), not the first the table names (the file's first data row is the CA site by luck, but the ordering is a sort). | "It defaults to a name derived from the input file, and the sample label recorded on the bundle is the first sample in alphabetical order." |
| 28 | "**Fetch references.** Downloads a reference FASTA from NCBI for each accession the results name and stores it in the result's `references/` folder" | true | `cli-help/import.txt` "Fetch NCBI reference FASTA files into references/ (default: enabled)"; `MetagenomicsImportService.swift:1019-1026` drives it from `allMiniBAMAccessions()` | |
| 29 | "The registry records reference fetching as on by default" | true | `parameters.yaml:1842-1844` "default: reference fetching is on"; CLI help "(default: --fetch-references)" | |
| 30 | "On the command line this is `--no-fetch-references`, which turns the fetching off rather than on." | true | `cli-help/import.txt`, `--fetch-references/--no-fetch-references` | |
| 31 | "**Output directory.** ... It defaults to the current directory" | true | `cli-help/import.txt` "(default: current directory)"; `ImportCommand.swift:1761-1766` falls back to `currentDirectoryPath` | |
| 32 | "Point it at the `.lungfish` project folder and let the importer place the bundle under `Analyses` itself." | false | The service creates the result directory **directly inside** `outputDirectory` with no `Analyses` component (`MetagenomicsImportService.swift:855-860`). The author's own run confirms it: the bundle sits at `scratch.lungfish/naomgs-virus_hits_final`, a sibling of nothing, at the project root. | "Point it at the project's `Analyses` folder, because the importer writes the bundle directly into whatever directory you name and does not add `Analyses` for you." |
| 33 | "The viewport is a split view. A summary bar runs along the top, the detail pane fills the left side, the taxon table fills the right, and an action bar runs along the bottom." | true | `NaoMgsResultViewController.swift:27-41` layout diagram | |
| 34 | "The summary bar holds two cards. **Samples** ... **Taxa** ..." | true | `NaoMgsResultViewController.swift:3295-3300` `cards` returns exactly `Samples` and `Taxa` | |
| 35 | "**Samples** reports how many samples the result covers, or reads 'N of M samples' when you have filtered to a subset." | true | `:3250-3258` | |
| 36 | "**Taxa** reports how many distinct taxa the current sample selection contains." | false | The card counts **table rows**, not distinct taxa. `:3260-3261` sets `taxaLabel` from `rows.count` of `fetchTaxonSummaryRows`, and that table holds one row per sample-taxon pair. On the fixture: 7 rows, 4 distinct tax_ids (`select count(*), count(distinct tax_id) from taxon_summaries` gives `7\|4`). | "**Taxa** reports how many rows the taxon table currently holds, which is one per sample-taxon pair rather than one per organism." |
| 37 | "On the surveillance run the bar read 5 samples and 4 taxa." | false | Samples is right (5). Taxa would read **7 taxa**, because the bar counts the 7 `taxon_summaries` rows. The number 4 is the *overview pane's* Unique Taxa card, which does deduplicate by taxId (`:884-899` aggregates into `taxonAgg` keyed on `row.taxId`). | "On the surveillance run the bar read 5 samples and 7 taxa, those 7 rows covering 4 distinct organisms." |
| 38 | "It reads **All Samples** when every sample is included and **N of M Samples** when it is not." | true | `NaoMgsResultViewController.swift:665-673` | |
| 39 | "it is the only control on that row." | true | `:1692-1709` adds only `sampleFilterButton` to `taxonomyFilterBar` | |
| 40 | "Click it to open the sample picker" | true | `:708-726` presents `ClassifierSamplePickerView` in an `NSPopover` | |
| 41 | "The table has five columns. **Sample** ... **Taxon** ... **Hits** ... **Unique Reads** ... **Refs**." | true | `:1618`, `:1629`, `:1637`, `:1645`, `:1653` set exactly those titles | |
| 42 | "so one taxon found in three sites occupies three rows rather than one." | true | Fixture: Cressdnaviricota sp. (2748378) occupies 3 rows across Water, MA_Boston, IL_CHI | |
| 43 | "**Taxon** is the organism name resolved from the taxonomy identifier, falling back to `Taxid N` when the lookup found no name." | true | `:2922` `summaryRow.name.isEmpty ? "Taxid \(summaryRow.taxId)" : summaryRow.name` | |
| 44 | "Click a column header to sort by it, and right-click a header to filter on that column's values." | true | Every column has a `sortDescriptorPrototype`; `:1725-1729` sets `columnTypes` for the filter menus | |
| 45 | "**Import Metadata...**, which takes a `.tsv`, `.csv`, or `.txt` file" | true | `InspectorView.swift:1158` button title; `FeatureFilePanelFactory.swift:16` `allowedContentTypes = [.commaSeparatedText, .tabSeparatedText, .plainText]` | |
| 46 | "those fields arrive as extra columns and can be sorted and filtered like any other." | true | `NaoMgsResultViewController.swift:234-241` refreshes metadata columns from the store | |
| 47 | "one site's Rotavirus A row showed 12 hits from 8 unique reads" | true | Manifest row IL_CHI_StickneyWS, taxid 28875, hitCount 12, uniqueReadCount 8 | |
| 48 | "Another site's row for the same organism showed 28 hits from 26 unique reads" | true | Manifest row CA_LosAngeles_County, taxid 28875, hitCount 28, uniqueReadCount 26 | |
| 49 | "It opens with a **Total Hits** card, a **Unique Taxa** card, and a card naming the sample or counting the samples in view" | true | `NaoMgsChartViews.swift:207-228`, with the `Sample` card when one sample and `Samples` when more | |
| 50 | "then draws a **Top Taxa by Read Count** bar chart of the top fifteen taxa." | true | `NaoMgsChartViews.swift:234` heading; `:177` `Array(taxonSummaries.prefix(15))` | |
| 51 | "Each bar is clickable and selects that taxon in the table" | true | `NaoMgsChartViews.swift:238-241` Button calling `onTaxonSelected`; wired at `NaoMgsResultViewController.swift:925` to `selectTaxonById` | |
| 52 | "The chart is a snapshot of one import. It does not plot a time series." | true | The chart plots taxa against hit count with no date axis. DRIFT row 16's over-broad negative is now correctly narrowed. | |
| 53 | "a line under it reads `Taxid N`, then the unique-of-total read counts, then the accession count, as in `Taxid 28875  •  26 unique / 28 total reads  •  7 accessions`." | false | The format string carries a colon. `:965` renders `"Taxid: \(row.taxId)  •  ..."`, so the real line is `Taxid: 28875  •  26 unique / 28 total reads  •  7 accessions`. The three fields and the fixture's values are otherwise exact. | Change both `Taxid N` and the example to `Taxid: N` and `Taxid: 28875  •  26 unique / 28 total reads  •  7 accessions`. |
| 54 | "a **miniBAM Panels** section, whose heading names how many accessions are shown out of how many exist, reading `All: 3 of 3 accessions` ... and `Top 5: 5 of 12 accessions`" | true | `:1035-1037` renders `"miniBAM Panels (\(scopeLabel): \(shownCount) of \(totalCount) accessions)"` with scopeLabel "All" or "Top 5". The quoted fragments are the inner part of that string, which is what the chapter says. | Optionally quote the whole heading, `miniBAM Panels (All: 3 of 3 accessions)`, so a reader matching text on screen finds it. |
| 55 | "the panels are ordered by unique read count so the best-supported reference comes first." | false | The panels are ordered by **total** read count. `NaoMgsDatabase+Queries.swift:235` is `ORDER BY read_count DESC`, and the detail pane consumes that order at `NaoMgsResultViewController.swift:950`. The UI's own note label at `:1045` says "Top references by unique read count", so the app's caption is wrong too, and the chapter repeats it. | "the panels are ordered by total hit count, so the reference with the most reads comes first. The note above them says unique read count, which is a mislabel." |
| 56 | "Drag a panel's handle downward to make it taller when the reads are crowded." | true | `:1045` note "Drag a panel handle downward to make it taller."; `miniBAMMinHeight` 140 / `miniBAMMaxHeight` 900 at `:173-175` | |
| 57 | "Each accession above its panel is a clickable link to that record at GenBank, and right-clicking it offers to open the record or copy the accession." | true | `:1112-1141` builds the link button and a menu with "View <acc> on NCBI GenBank" and "Copy Accession" | |
| 58 | "Three buttons and an information button run along the bottom." | true | `ClassifierActionBar.swift:22-83` defines blastButton, exportButton, extractButton, provenanceButton | |
| 59 | "**BLAST Verify** submits a sample of the selected taxon's reads to NCBI BLAST" | true | `ClassifierActionBar.swift:23`; `NaoMgsResultViewController.swift:307` `onBlastVerification` | |
| 60 | "**Export** writes the taxon table as it currently stands to a `.tsv` file, suggested as `<sample>_naomgs_summary.tsv`." | true | `:2659-2661` `suggestedName: "\(sampleName)_naomgs_summary.tsv"` | |
| 61 | "It exports the displayed rows, so your sample filter, column filters, sort order, and any metadata columns all carry through, and the export records those choices in its own provenance sidecar." | true | `:2676-2708` writes from `displayedRows` and records `columnFilters`, `sortDescriptors`, `selectedSamples`, `metadataColumns` through `ScientificFileExportProvenance` | |
| 62 | "**Extract FASTQ** pulls the reads behind your selection out as a FASTQ file" | true | `ClassifierActionBar.swift:49-51`; `:1884` presents the unified extraction dialog | |
| 63 | "The information button at the right end opens the provenance record, which names the source file path, the import command, and the input checksums." | true | `ClassifierActionBar.swift:75-82` provenanceButton; `NaoMgsResultViewController.swift:473` records `sourceFilePath` | |
| 64 | "Right-clicking a taxon row offers the same actions plus **Copy Taxon ID**, **Copy Top Accessions**, **View on NCBI**, **View Taxonomy on NCBI**, and **Search PubMed**." | false (in part) | The five named items are exact (`:2098-2127`). But "the same actions" overstates it. The menu carries BLAST entries and **Extract Reads…** and has **no Export item** (`:2063-2134`). | "Right-clicking a taxon row offers BLAST verification and **Extract Reads...**, plus **Copy Taxon ID**, **Copy Top Accessions**, **View on NCBI**, **View Taxonomy on NCBI**, and **Search PubMed**." |
| 65 | "There is no threshold the app enforces" | true | No unique-read gate appears in the viewport or the importer | |
| 66 | "Sort by Taxon rather than Hits to see this, since the table keeps one row per sample and the rows for one organism then sit together." | true | `nameColumn` sorts on `name` with a localized comparator (`:1633`) | |
| 67 | "A row naming a broad group such as `Cressdnaviricota sp.` ..." | true | That name is in the fixture's manifest for taxid 2748378. The gloss "an unclassified member of a large viral phylum" is general taxonomy, not an app claim. | |
| 68 | "Pair the result with a broad survey such as [Running Kraken2](02-running-kraken2.md)" | true | Target file exists | |
| 69 | "`lungfish-cli import nao-mgs /path/to/virus_hits_final.tsv.gz --output-dir ...`" | true | `cli-help/import.txt`, positional `<input-path>`, `-o, --output-dir` | |
| 70 | "The input is a positional argument rather than a flag" | true | `ImportCommand.swift:1730-1731` `@Argument` | |
| 71 | "`--sample-name` overrides the derived sample name, and `--no-fetch-references` skips the NCBI reference downloads" | true | `ImportCommand.swift:1733-1747` | |
| 72 | The printed summary block `Total hits : 35 / Distinct taxa : 4 / References fetched: 0 / Output : naomgs-virus_hits_final` | true | Reproduced by the author's run 5; the key labels match `ImportCommand.swift:1799-1805` | |
| 73 | "`--top` sets how many taxa the table prints and defaults to 20." | true | `cli-help/nao-mgs.txt`, `--top` "(default: 20)" | |
| 74 | "The output names the sample, the total virus hits, the distinct taxa, and the source file, then prints a table of TaxID, Organism, Hits, Avg %ID, Avg Score, and Refs." | true | Rerun: header lines `Sample`, `Total virus hits`, `Distinct taxa`, `Source`, then those six column headings | |
| 75 | "on the five-sample surveillance run it printed one sample name, 34 hits, and blank Organism cells, while the project importer ... found five samples, 35 hits, and resolved every organism name." | true | Rerun reproduces exactly: `Sample : MU-CASPER-...-IL_CHI_StickneyWS_20260308_S19_L002`, `Total virus hits: 34`, `Distinct taxa : 4`, empty Organism column. Import gives 35 hits and named taxa. Defect 1 and 3 confirmed. | |
| 76 | "`lungfish-cli nao-mgs import ... --output-dir ./summaries` ... takes `--sample-name`, `--output-dir` (`-o`), and `--min-bitscore`, which drops hits below a bit-score floor and defaults to 0" | true | `cli-help/nao-mgs.txt`, `==== nao-mgs import ====`, all three options, `--min-bitscore` "(default: 0.0)" | |
| 77 | "With `--tool naomgs` the selection is made by accession rather than by taxonomy identifier, and at least one `--accession` is required." | true | `ExtractReadsCommand.swift:306-309` | |
| 78 | "Passing `--taxon` instead fails with `--tool naomgs requires at least one --accession`" | true | `ExtractReadsCommand.swift:308` produces that exact string | |
| 79 | "because `--taxon` is accepted only for Kraken 2." | true | `cli-help/extract.txt` documents `--taxon` as "for --by-classifier --tool kraken2". Worth noting the same accession requirement binds esviritu, taxtriage, and nvd (`ExtractReadsCommand.swift:306`), so this is not special to naomgs. | |
| 80 | "`--sample` scopes the accessions that follow it" | true | `cli-help/extract.txt` "repeatable; scopes subsequent --accession/--taxon flags" | |
| 81 | "The command above extracted 4 reads." | true | `grep -c "^@" extract1.fastq` gives 4 | |
| 82 | "`--read-format fasta` drops the quality scores, `--include-unmapped-mates` ... and `--bundle` wraps the output as a `.lungfishfastq` bundle" | true | `cli-help/extract.txt` lines for all three | |
| 83 | "The same resolver backs the viewport's Extract FASTQ button and this command, so both produce identical output for the same selection." | false | Not established, and the code says otherwise. The viewport builds a `readNameAllowlist` from the taxon's read names (`NaoMgsResultViewController.swift:1836-1857`); the CLI has no such flag and no such filter (`grep readNameAllowlist Sources/LungfishCLI/Commands/ExtractReadsCommand.swift` returns nothing). Both go through the classifier resolver, but the GUI narrows the selection further. | "The viewport's Extract FASTQ button uses the same classifier resolver, and additionally narrows the reads to the taxon's own read names, so a command-line extraction of one accession can return more reads than the button does." |
| 84 | "`extract reads --by-db` queries an NAO-MGS SQLite database directly ... filtered with `--db-sample`, `--db-taxid`, and `--db-accession` and capped with `--max-reads`." | true | `cli-help/extract.txt` documents all four | |
| 85 | "The merge step ... deliberately leaves the per-read rows behind, so the bundle's `hits.sqlite` carries the summaries and the read names but not the read sequences, and the command exits with `The extraction produced zero reads`." | true | `NaoMgsDatabase+Merge.swift:14-15` "`virus_hits` rows are intentionally not copied"; `select count(*) from virus_hits` gives 0 while `taxon_read_names` holds 34; rerun exits 1 with that exact message. Defect 2 confirmed. | |
| 86 | "Use `--by-classifier` instead, which reads the alignment files the import wrote and works." | true | The `--by-classifier` run produced 4 reads from the same bundle | |
| 87 | "Continue to [BLAST Verification](06-blast-verification.md) or to [Novel Virus Diagnostics](09-novel-virus-detection.md)" | true | Both files exist | |
| 88 | Shot caption `nao-mgs-import-card` | true | Card title, NM badge, and file hint all verified at `ImportCenterViewModel.swift:415-420`; tab at `:178` | |
| 89 | Shot caption `nao-mgs-import-sheet` | true | Path readout, Browse... button, "Valid NAO-MGS results", source file name all verified at `NaoMgsImportSheet.swift:140-210` | |
| 90 | Shot caption `nao-mgs-result-viewport`, "showing the Samples and Taxa summary cards ... the sample-filter button reading All Samples ... the table's Sample, Taxon, Hits, Unique Reads, and Refs columns, and the overview bar chart" | true | Every named element verified above. DRIFT's requested sample-filter framing is applied. | |
| 91 | Shot caption `nao-mgs-taxon-detail`, "the Taxid line with its unique-of-total read counts and accession count, and the miniBAM Panels section with one read-pileup panel per top accession" | true | `:957-965`, `:1030-1046`. The caption avoids quoting `Taxid` verbatim, so the colon error in row 53 does not reach it. | |

Counts: 78 true, 10 false, 0 unverifiable, plus 3 rows carrying a partial
qualification (20, 54, 79) that are true as written.

## Front matter

Schema-conformant against `STYLE.md:153-168`. `title` matches the mkdocs nav
label and the roster. `chapter_id` matches the file location. `audience:
analyst` is one of the three permitted values and suits an import-and-read
chapter. `parameters_refs: [import.nao-mgs]` is the correct registry id.
`entry_points` has three, and all three resolve (the menu path at
`MainMenu.swift:208`, and both CLI forms in the help tree).

Four `shots` with captions, all four verified above. `illustrations`,
`features_refs`, and `fixtures_refs` are empty. The empty `fixtures_refs` is
honest, because the chapter runs on a test fixture rather than a published
manual fixture, but it is the reason the Before you start section cannot give
a download link. See Notes for the editor.

`brand_reviewed: false` and `lead_approved: false` are correct for this stage.

Two problems.

`glossary_refs` lists 20 terms but the body links only 16. Unused: `coverage`,
`depth`, `mapping`, `read-classification`, `reference-genome`. Either link them
at first use or drop them from the list. Every listed anchor does exist in
`GLOSSARY.md`, so nothing is broken, only unused.

`estimated_reading_min: 6` is too low for 3,861 words, which is nearer 18
minutes. Committed chapter 02 carries the same 6 against 8,768 words, so the
field is unreliable across the classification set and this is not a regression
introduced here. Worth a sweep rather than a chapter fix.

## Settings coverage against parameters.yaml

`parameters.yaml:1826-1854` gives `import.nao-mgs` an empty `settings: []` and
three `cli_only` flags. The chapter documents all three and no others, so
coverage is complete.

| Registry entry | Documented | Shape |
|---|---|---|
| `settings: []` | Yes, stated | "The NAO-MGS Import sheet holds no settings." Verified against `NaoMgsImportSheet.swift:112-122`. |
| `--sample-name` | Yes | Three-sentence shape, flag in a final sentence. Correct. |
| `--no-fetch-references` | Yes | Correct, and it correctly warns the flag turns fetching off rather than on. |
| `--output-dir` | Yes | Shape correct, but the third sentence is factually wrong. See claim 32. |

The registry itself needs one correction. Its `notes` field ends "The imported
result lands under the project's Analyses folder as naomgs-<sample>." That is
true of the Import Center path only, and the `<sample>` half is wrong on both
paths when no `--sample-name` is given. The registry is not mine to edit, so it
is flagged here for whoever owns it.

Settings-entry shape matches the CONSISTENCY sheet: label in bold with the
period inside, then what it does, the default and why, when to change it, then
the flag sentence.

## Consistency

Section order matches the template and matches committed chapters 02 and 03
exactly: What it is, Why you would do this, Before you start, Procedure,
Settings, Reading the results, What good looks like, On the command line, Next.

Naming is correct. "Lungfish Genome Explorer (LGE)" at first mention in the
body (line 36), "LGE" after, `lungfish-cli` in code font.

Menu paths use the bold greater-than form with the ellipsis, matching the
sheet. **File > Import Center...**, **File > New Project**, **Operations >
Show Operations Panel**. The Inspector reference is written as "the Inspector's
**Import Metadata...**", which follows the sheet's rule to use the possessive
form in prose rather than the `Inspector > Analysis > ...` path.

The Before you start opening sentence is the fixed one, word for word.

Lint is green under `LUNGFISH_MANUAL_STRICT=1`, so the prose rules (no em
dashes, no semicolons, no in-sentence colons, bullet caps, banned words) all
pass.

Three divergences.

First, the On the command line lead. Chapters 02 and 03 both open that section
with a fixed three-sentence run: "This section is optional. If you do your work
in the LGE window, everything above is complete without it, and nothing here
unlocks a result the dialog cannot produce. It is here for readers who want to
script a run or repeat one on a server. The whole procedure runs headless,
meaning with no window at all, by typing commands into the Terminal
application." This chapter writes its own variant and drops the "headless"
gloss entirely. The variant reads well and its second clause is adapted
sensibly for an import-only tool ("nothing here produces a result the Import
Center cannot"), but if that opening is meant to be fixed the way the Before
you start opening is, this chapter is off-pattern. The CONSISTENCY sheet does
not currently list it as fixed, so this is a question for the project manager
rather than a defect. Whichever way it is settled should be written into the
sheet, because three chapters now share the pattern by convention only.

Second, the storage location. The CONSISTENCY sheet's Folders and files
section already carries a near-identical precedent, settled 2026-09-07 at the
chapter 20 review: an imported ONT run folder "lands at the project root, not
under `Imports/`". The NAO-MGS CLI import behaves the same way, and the sheet
should gain a line saying so once the wording in claim 32 is fixed. The sheet's
sentence that `naomgs` is among the `knownTools` that get
`Analyses/<tool>-<timestamp>/` is also slightly misleading for the three
imported-result tools, which use `<tool>-<name>` and not a timestamp
(`AnalysesFolder.swift:30-32`).

Third, a stale cross-reference outside this chapter. `help-ids.yaml:367-368`
points `viewport.CzIdResultViewer` at `06-classification/07-importing-cz-id-results`,
but the CZ ID chapter is `08-importing-cz-id-results.md` and `07` is Freyja.
This predates the author's edits and is not theirs to fix, but it sits four
lines below the entry they did edit and should be swept.

The two files the author edited outside the chapter are both correct.
`mkdocs.yml:110` reads "Importing NAO-MGS Results" and matches the front-matter
title. `help-ids.yaml:361-365` repoints the anchor to `reading-the-results`,
which is a real heading in the rewritten chapter (`## Reading the results`),
and the rewritten description drops the "longitudinal abundance charts" claim
that no surface produces.

## App defects

The author's three claims are confirmed, and I found two more.

1. **`nao-mgs summary` reports only the first sample of a multi-sample table.**
   Confirmed by rerun. On the five-site fixture it prints
   `Sample : MU-CASPER-2026-03-31-a-IL_CHI_StickneyWS_20260308_S19_L002` and
   `Total virus hits: 34`, while `import nao-mgs` on the same file finds five
   samples and 35 hits. The one-row gap is a second symptom of the same
   single-sample path. Correctly documented in the chapter.

2. **`extract reads --by-db` cannot work against any imported NAO-MGS bundle.**
   Confirmed. `NaoMgsDatabase+Merge.swift:14-15` states `virus_hits` rows are
   intentionally not copied, `select count(*) from virus_hits` returns 0, and
   the command exits 1 with `Error: The extraction produced zero reads`. The
   CLI help advertises the mode with no caveat. Correctly documented.

3. **`nao-mgs summary` prints an empty Organism column.** Confirmed. Name
   resolution runs during the project import, not in the standalone summary.
   Cosmetic, and the chapter's quoted column list makes it visible.

4. **New. The miniBAM note label contradicts the ordering.** The note at
   `NaoMgsResultViewController.swift:1045` reads "Top references by unique read
   count", but the panels come from `fetchAccessionSummaries`, whose SQL is
   `ORDER BY read_count DESC` (`NaoMgsDatabase+Queries.swift:235`). The panels
   are ordered by total hits. Either the label or the ordering is wrong. The
   chapter currently repeats the label, so the chapter fix and the app fix are
   separate.

5. **New. The summary bar's Taxa card counts rows, not taxa.** The card is
   labelled "Taxa" and its value comes from `rows.count` of
   `fetchTaxonSummaryRows` (`:3260-3261`), which is one row per sample-taxon
   pair. On the fixture it reads 7 while the result holds 4 organisms. The
   overview pane's "Unique Taxa" card on the same screen deduplicates by taxId
   (`:884-899`) and reads 4, so the viewport shows two different taxon counts
   at once with no hint that they measure different things. This is the likely
   source of the chapter's error in claims 36 and 37.

## Notes for the editor

Ten false claims to fix, in rough order of how much they would mislead a
reader.

Claim 32 matters most, because it is an instruction. A reader who follows
"point `--output-dir` at the `.lungfish` project folder and let the importer
place the bundle under `Analyses`" gets the bundle at the project root instead,
where the sidebar's Analyses folder will not show it. Tell them to name the
`Analyses` folder itself.

Claims 36 and 37 are the viewport's two taxon counts. The fix has to name both
numbers, because a reader looking at the fixture sees 7 in the summary bar and
4 in the overview and needs to know why.

Claim 23 contradicts the chapter's own defect note 50 lines later. Saying the
database holds "every hit" and then explaining that the merge drops the per-read
rows cannot both stand. Fix the earlier sentence.

Claims 21 and 27 are the bundle-naming pair. The bundle is named after the
input file, not the sample, which is exactly why the worked example reads
`naomgs-virus_hits_final` and not `naomgs-MU-CASPER-...`. A reader comparing the
prose to the code block will notice.

Claim 55 repeats an app mislabel. The honest fix names the real ordering and
says the app's own note disagrees, which also warns the reader off trusting the
label.

Claim 53 is a one-character fix, `Taxid:` not `Taxid`, in two places.

Claim 83 overpromises parity between the button and the command. The GUI filters
by read name and the CLI cannot, so the counts can differ.

Claim 64's "the same actions" should name what the menu actually carries, since
Export is not on it.

Claim 20 needs four words to scope it to the Import Center path.

Two things that are right and should not be touched. The DRIFT items are all
applied correctly, including the hard one, row 16, where the chapter now makes
the narrow provable statement about the chart rather than the old blanket
negative. And the defect disclosures in the On the command line section are the
right call, because both defects would otherwise cost a reader real time.

One thing the screenshot pass must confirm, carried forward from the author's
own Not verified list and now sharper. The summary bar's Taxa value is the
single most likely caption error in this chapter, so the
`nao-mgs-result-viewport` shot should be read carefully when it is captured. If
it shows 7, claims 36 and 37 are settled as written above. The miniBAM heading
and the `Taxid:` line should be checked in the same pass.

Finally, the Phase 5 fixture question stands. The chapter runs on
`Tests/Fixtures/naomgs/virus_hits_final.tsv.gz`, a test fixture with no
published download, so Before you start tells the reader to produce their own
output. Every other chapter in this part links a fixture. Either promote this
file with provenance and licence notes or obtain a publishable sample. If a
cleaner sample set arrives, the worked figures (35 hits, 4 taxa, the 12/8 and
28/26 pairs, 4 extracted reads, and whatever the Taxa card reads) all need
re-running.

## Counts

78 true, 10 false, 0 unverifiable, across 91 checked claims.

False: 21, 23, 27, 32, 36, 37, 53, 55, 64, 83.

App defects confirmed: 3 of the author's 3. New defects found: 2.
