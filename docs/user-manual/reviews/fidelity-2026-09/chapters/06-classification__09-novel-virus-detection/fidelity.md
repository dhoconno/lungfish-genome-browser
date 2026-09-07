# Fidelity review, 06-classification/09-novel-virus-detection

Chapter: `docs/user-manual/chapters/06-classification/09-novel-virus-detection.md`
Roster row 40. Registry id `import.nvd`. Fixture `nvd-demo`.
Reviewed 2026-09-07 against Preview 2026.9.13 sources, the CLI help tree, and
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.
No GUI session was run, so every window claim is checked against Swift source
rather than against pixels. Read-only CLI commands were rerun.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "NVD is an external pipeline written in Snakemake" | true | `cli-help/nvd.txt`, `==== nvd ====`: "Novel Virus Diagnostics (NVD) Snakemake pipeline". Glossary `GLOSSARY.md:355` agrees. `features.yaml:743` says Nextflow but the CLI wins on the campaign's precedence order. | |
| 2 | "LGE does not run the NVD pipeline" | true | Only `import` and `summary` subcommands exist (`cli-help/nvd.txt`). No run path in `Sources/`. | |
| 3 | "The pipeline's output file is named `*_blast_concatenated.csv`, optionally gzip-compressed ... in a folder named `05_labkey_bundling/`" | true | `cli-help/import.txt:449-451`, "Path to NVD results directory (containing 05_labkey_bundling/)". `NvdImportSheet.swift:202`. | |
| 4 | "10 BLAST hit rows across 3 samples and 4 contigs" | true | `nvd summary` rerun 2026-09-07 prints "Total BLAST hits: 10 / Samples: 3 / Unique contigs: 4". CSV has 10 data rows. | |
| 5 | Before you start opens with the two fixed sentences | true | `CONSISTENCY.md:138-148`. Chapter lines 58-64 match, adjusted for the fixture. | |
| 6 | Import Center card "NVD Results", description, file hint "NVD run folder containing *_blast_concatenated.csv(.gz)" | true | `ImportCenterViewModel.swift:488-496`, verbatim. | |
| 7 | The card opens a wizard sheet titled NVD Import rather than a plain file panel | true | `ImportCardInfo(importKind: .wizardSheet(action: .nvd))` at `ImportCenterViewModel.swift:495`; `NvdImportSheet.swift:140` `title: "NVD Import"`. | |
| 8 | "Click **Browse...**" | true | `NvdImportSheet.swift:195` `Button("Browse\u{2026}")`. Corrects the old **Choose** (DRIFT row 4). | |
| 9 | Hint "Select the top-level NVD run directory (containing 05_labkey_bundling/)" | true | `NvdImportSheet.swift:202`, verbatim. | |
| 10 | "The path readout to the left of the button is a display of the chosen path and is not editable" | true | `NvdImportSheet.swift:181-193` is a `Text`, not a `TextField`. | |
| 11 | Preview panel lists **Experiment**, **Samples**, **Contigs**, **BLAST hits**, plus a conditional **Total BAM size** row | true | `NvdImportSheet.swift:244-258`. The BAM row is gated on `bamSize > 0`. | |
| 12 | "While the scan runs the panel counts rows as it reads them" | true | `NvdImportSheet.swift:219-224`, "Scanning… \(n) rows". | |
| 13 | "If the scan cannot find or parse the table, the panel shows a warning instead of the counts" | true | `NvdImportSheet.swift:231-245`, the `scanError` branch with `exclamationmark.triangle.fill`. | |
| 14 | Preview reads experiment `100`, 3 samples, 4 contigs, 10 BLAST hits | true | Same parser as `nvd summary`, whose rerun prints exactly those four figures. | |
| 15 | "Click **Run**" and the button is gated on a finished successful scan | true | `NvdImportSheet.swift:131-134` `canRun = selectedPath != nil && !isScanning && hitCount != nil`; `:88` "Run button (never 'Import', 'Go', etc.)". | |
| 16 | "A row titled NVD Import appears in the Operations panel" | true | `AppDelegate+ToolsMenu.swift:646` `OperationCenter.shared.start(title: "NVD Import", ...)`. | |
| 17 | "The result folder is named after the run's experiment identifier, so the demo results import as `nvd-100`" | true | `MetagenomicsImportService.swift:650` `"nvd-\(parseResult.experiment ...)"`. CLI run produced `nvd-100`. | |
| 18 | "Importing from the Import Center writes the folder into the project's `Imports/` folder" | true | `AppDelegate+ToolsMenu.swift:636` `projectURL.appendingPathComponent("Imports")`, passed as `outputDirectory` at `:659` and echoed in the `cliCommand` at `:647-650`. See App defects. | |
| 19 | "those go under `Analyses/`" for classification runs started inside LGE | true | `AnalysesFolder.knownTools` (`AnalysesFolder.swift:24-28`) includes kraken2, esviritu, taxtriage, naomgs, nvd, cz-id. `CONSISTENCY.md:54-61`. | |
| 20 | "The command line writes wherever `--output-dir` points" | true | `cli-help/import.txt:454-456`, default "current directory". Confirmed by the demo project's own bundle under `Analyses/nvd-demo`. | |
| 21 | Four summary cards **Experiment**, **Samples**, **Contigs**, **Hits** reading `100`, `3 samples`, `4 contigs`, `10 hits` | true | `NvdResultViewController.swift:2951-2976`. Pluralisation and the "N contigs"/"N hits" shapes match. | |
| 22 | "A detail pane occupies the left side and an outline list of contigs the right" | true by default only | `NvdResultViewController.swift:1164-1170` branches on `MetagenomicsPanelLayout.current()`, whose default is `.detailLeading` (`MetagenomicsLayoutPreference.swift:36-43`). A reader who has switched the Inspector's layout preference to List leading or Stacked sees the opposite. | Optionally add "by default" and note the Inspector preference. |
| 23 | "A filter bar sits above the outline holding three controls, which are the grouping control, the sample filter, and the search field" | **false** (order) | `NvdResultViewController.swift:1469`, `:1479`, `:1491` add them in the order sample filter, grouping segment, search field. Three controls is right, the naming order is not. | "...holding three controls, which are the sample filter, the grouping control, and the search field". |
| 24 | Disclosure triangle opens the same contig's lower-ranked results | true | `NvdResultViewController.swift:1214-1218` sets `outlineTableColumn = contigCol`; child hits keyed by `hitRank`. | |
| 25 | "in the order the pipeline ranked them" | true in effect, imprecise | `NvdResultParser.swift:234-236`, `hitRank` is derived by LGE as evalue ascending with bitscore descending as tiebreak, not read from the CSV. On this fixture the two orders coincide. | "in rank order, best e-value first". |
| 26 | `NODE_2_length_300_cov_5.0` opens to four further HIV-1 matches; `NODE_1_length_500_cov_10.0` to two further SARS-CoV-2 matches | true | CSV: NODE_2/SampleA has 5 rows, NODE_1/SampleA has 3. | |
| 27 | Detail subtitle `Sample: SampleA` then `SARS-CoV-2 (species)` | true | `NvdResultViewController.swift:751-756`, `"Sample: \(hit.sampleId)  •  \(classificationText)"` with `"\(name) (\(rank))"`. | |
| 28 | Six metric pills Identity, E-value, Bit Score, Mapped Reads, RPB, Length | true | `NvdResultViewController.swift:806-813`, exactly those six labels in that order. | |
| 29 | **Contig Alignment** section naming the best hit's accession and title | true | `NvdResultViewController.swift:889-899`, header "Contig Alignment" and "Best hit: \(sseqid) — \(stitle)". | |
| 30 | "that whole area reads 'No BAM data available.'" when no alignment shipped | true | `NvdResultViewController.swift:872-887`, the `guard let database, let bundleURL else` branch. Demo bundle's `bam/` is empty. | |
| 31 | BLAST Verify sits in the action bar at the bottom | true | `ClassifierActionBar.swift:22-26`, `btn.title = "BLAST Verify"`. | |
| 32 | Disabled until exactly one identity-backed row is selected; tooltips "Select a row to use BLAST Verify" and "Select a single row to use BLAST Verify" | true | `NvdResultViewController.swift:2128` and `:2107`, both strings verbatim. Gate `singleIdentityBackedSelectedHit()` at `:2561-2573`. | |
| 33 | "A taxon group heading in the By Taxon grouping is not itself a hit" | true | `NvdResultViewController.swift:2570-2571`, `case .taxonGroup: return nil`. | |
| 34 | Drawer "slides open across the bottom of the window between the outline and the action bar, 220 points tall" | true | `NvdResultViewController.swift:1901` `constant = 220`; `:1862` pins `container.bottomAnchor` to `actionBar.topAnchor` and `:1865-1867` re-pins the split view's bottom to the container's top. | |
| 35 | "you can drag its top edge to resize it down to 160 points" | true | `NvdResultViewController.swift:1878` `minimumDrawerExtent: 160`, via `container.onDrag`. | |
| 36 | "The drawer offers a rerun control" | true | `NvdResultViewController.swift:1885-1887`, `blastResultsTab.onRerunBlast`. | |
| 37 | "Verification pulls the contig's own sequence out of the sample's contig-sequence file" | true | `NvdResultViewController.swift:1807-1826` reads the per-sample FASTA before submitting. Fixture's `fasta/` is empty, so the action is inert there. | |
| 38 | Fourteen columns "Sample, Contig, Length, Classification, Rank, Accession, Subject, Identity %, E-value, Bit Score, Mapped Reads, Unique Reads, RPB, Aln Length" | true | `NvdResultViewController.swift:1206-1290`, fourteen `addTableColumn` calls with exactly those titles in exactly that order. DRIFT's "thirteen" is wrong. | |
| 39 | "Contigs are listed longest first by default, and there is no sort control, so the ordering is fixed" | true | `NvdDatabase.swift:565-577` and `:696`, `ORDER BY qlen DESC`. No `sortDescriptor`, no `sortDescriptorsDidChange`, no header-click action anywhere in `NvdResultViewController.swift`. | |
| 40 | "reordered by dragging their headers and resized by dragging the dividers" | true | `NSOutlineView` defaults; `allowsColumnReordering`/`allowsColumnResizing` are not disabled, and `MetadataColumnController` offers Reset Column Widths, which only makes sense if resizing works. | |
| 41 | Right-click header menu with **Standard Columns**, **Reset Column Widths**, and a **Sample Metadata** section | true | `MetadataColumnController.swift:358-400`, all three section titles verbatim; installed at `NvdResultViewController.swift:1307-1313`. | |
| 42 | "A sample with no value for a column shows an em dash in grey" | true | `MetadataColumnController.swift:503` returns `"\u{2014}"`; `:535` sets `.tertiaryLabelColor` for that value. | |
| 43 | "contig `NODE_1_length_500_cov_10.0` is 500 bases long and aligns over 498" | true | CSV row 1, `qlen`=500, `length`=498. | |
| 44 | "the four best matches run 99.5%, 96.0%, 99.0%, and 97.5%" | true | `nvd summary` rerun output, %ID column. | |
| 45 | "the demo results run from `0.0` ... down to `1e-90`" | true | CSV evalue column, min `0.0`, max `1e-90` (SampleC). | |
| 46 | "**Unique Reads** ... when the pipeline did not report a separate figure the column repeats the mapped-read count" | true | `NvdResultViewController.swift:2487-2492` `ClassifierUniqueReads.normalizedOrFloor(stored:readCount:)`; `uniqueReads` is optional at `NvdResultParser.swift:105`, and the CSV has no such column. | |
| 47 | "SampleA's SARS-CoV-2 contig carries 50 mapped reads out of 1,000,000 total, giving an RPB of 50,000" | true | CSV `mapped_reads`=50, `total_reads`=1000000. Formula at `NvdResultParser.swift:237`, `mappedReads / totalReads * 1e9`. Manifest `readsPerBillion` = 50000. | |
| 48 | "SampleB's herpesvirus contig carries 100 out of 2,000,000, and its RPB is also 50,000" | true | CSV row 9. 100/2000000 × 1e9 = 50000. | |
| 49 | "one reads `clade`, the Norovirus GII row" | true | CSV row 10, `adjusted_taxid_rank`=clade. | |
| 50 | Right-click items **View Accession on NCBI** and **Search PubMed** | true | `NvdResultViewController.swift:1975`, `:1982`, verbatim. | |
| 51 | **Extract Reads…**, **Copy Contig Name**, **Copy Accession** | true | `NvdResultViewController.swift:1918`, `:1959`, `:1966`, verbatim. | |
| 52 | "**Extract Sequence…**, **Verify with BLAST…**, **Copy FASTA**, **Export FASTA…**, **Create Bundle…**, and **Run Operation…**" | **false** (one item) | `FASTASequenceActionMenuBuilder.swift:78`, `:23`, `:93`, `:31`, `:14`, `:120`. Five of the six titles are right. The create-bundle item's title is `createBundleMenuTitle`, whose default is **Extract to New Bundle…** (`:14`), and NVD passes no override (`NvdResultViewController.swift:1943`). "Create Bundle…" appears nowhere. | "**Extract Sequence…**, **Verify with BLAST…**, **Copy FASTA**, **Export FASTA…**, **Extract to New Bundle…**, and **Run Operation…**". |
| 53 | "The six shared sequence actions" is the complete shared set for NVD | true | The builder can emit a seventh, **Align with MAFFT…** (`:113-118`), but only when `onAlignWithMAFFT` is non-nil, and NVD never sets it (`NvdResultViewController.swift:1930-1950`). Six is right for this viewport. | |
| 54 | "**Export** writes the displayed rows out as a tab-separated file through a save panel, including whatever metadata columns are showing" | true, incomplete | `NvdResultViewController.swift:2161-2172` (save panel, `experiment_nvd_contigs.tsv`), `:2223-2229` appends `metadataColumnController.exportHeaders`. But the export's twelve columns (`:2223`) drop **Unique Reads** and **Aln Length**, two columns the outline shows. A reader told "the displayed rows" will expect all fourteen. | Add "The exported table carries twelve of the fourteen columns, leaving out Unique Reads and Aln Length." |
| 55 | "**Extract FASTQ** reaches the same extraction dialog as the right-click item" | true | `ClassifierActionBar.swift:48-60` and the shared `onExtract` route into the same `contextExtractReadsUnified` path. | |
| 56 | "The information button at the right end opens the provenance popover" | true | `ClassifierActionBar.swift:76-82` (`info.circle`); `NvdResultViewController.swift:2135-2143` shows `NvdProvenanceView`. | |
| 57 | "Use **Import Metadata…** in the Inspector" | true | `InspectorView.swift:1155-1158`, `Button("Import Metadata\u{2026}")`. | |
| 58 | "the columns survive closing and reopening the result" | unverifiable | `MetadataColumnController` persists column state, but no run was made against an NVD result. A GUI session that imports metadata, closes the result, and reopens it would settle it. | |
| 59 | "hits at least equal to contigs since every contig has at least one match" | true | Structural: every contig row in the CSV is a hit row. 4 contigs, 10 hits. | |
| 60 | "five matches whose bit scores step down gently from 750 to 660 and whose identities run from 96.0% down to 92.0%" | true | CSV rows 4-8, bitscore 750/720/700/680/660, pident 96.0/95.0/94.0/93.0/92.0. | |
| 61 | The `nvd summary` text block, quoted verbatim | true | Rerun 2026-09-07 reproduces it line for line, including the box-drawing rule and the four rows. Only difference is trailing spaces in the Reads column, which markdown drops. | |
| 62 | "`--top` sets how many contigs the table lists and defaults to 20" | true | `cli-help/nvd.txt`, `==== nvd summary ====`, "--top <top> Number of top contigs to display (default: 20)". | |
| 63 | TSV columns `sample_id qseqid qlen adjusted_taxid_name sseqid pident evalue bitscore mapped_reads rpb` | true | Rerun of `nvd summary ... --top 2 --format tsv` prints exactly that header. | |
| 64 | "`--format json` emits ... as JSON" | true | `cli-help/nvd.txt`, "--format <format> Output format: text, json, tsv". Not exercised, and the chapter quotes no shape, so nothing is at risk. | |
| 65 | `import nvd` "finishes by reporting the same three counts ... ending with `✓ NVD import complete: nvd-100`" | true | Author's run 3 and the fixture README's own transcript both show `Total hits: 10 / Samples: 3 / Contigs: 4` then `✓ NVD import complete: <name>`. | |
| 66 | "`lungfish-cli nvd import` is a second spelling of the same operation and takes the same argument, the same `--name`, and the same `--output-dir`" | true | `cli-help/nvd.txt`, `==== nvd import ====` vs `cli-help/import.txt`, `==== import nvd ====`. Same `<input-path>`, same `-o/--output-dir`, same `--name` with the same default. | |
| 67 | `extract reads --by-classifier --tool nvd` flags `--sample`, `--accession`, `--read-format fasta`, `--bundle` | true | `cli-help/extract.txt:131-147` and `:151`. `--accession` is documented as "Reference accession / contig name". | |
| 68 | "the two produce byte-identical output for the same selection" | true | `cli-help/extract.txt:93-97`, "the CLI and GUI produce byte-identical output for the same selection". | |
| 69 | The failure string `No BAM file found for sample 'SampleA'. ...` | true | `ClassifierReadResolver.swift:1236`, verbatim. | |
| 70 | "Run against the demo results it exits with status 1" | true | Author's run 4 recorded exit 1. The bundle's `bam/` is empty, so the resolver has nothing to find. | |

## Front matter

`title`, `chapter_id`, `audience`, `prereqs`, `task`, `tags`, `tools`,
`estimated_reading_min` all well formed. `parameters_refs: [import.nvd]`
matches the roster and the registry key at `parameters.yaml:1856`.
`entry_points` reproduce the registry's two and add `nvd summary`, which is
real (`cli-help/nvd.txt`) and useful. `fixtures_refs: [nvd-demo]` matches.
`features_refs: []` is defensible, since the only NVD entry in
`features.yaml` is wrong on two counts (App defect 5).
`brand_reviewed: false` and `lead_approved: false` are correct for this stage.

`glossary_refs` lists fourteen ids. Each resolves in `GLOSSARY.md`, including
the newly added `reads-per-billion` (`GLOSSARY.md:445`), which sits in correct
alphabetical position between "Reading frame" and "Regular expression" and
carries the same formula the parser uses. The chapter links every one of them
in the body.

Five `shots`, all with `<!-- SHOT: ... -->` markers in the body, each beside
the step it illustrates. Every named surface is real.

- `nvd-import-card`: the card and its exact file hint exist
  (`ImportCenterViewModel.swift:488-496`). Caption accurate.
- `nvd-import-preview`: Browse..., the path readout, and all four preview row
  labels exist (`NvdImportSheet.swift:181-258`). Caption accurate.
- `nvd-result-viewport`: four cards, the By Sample/By Taxon segment
  (`:313`), the Search contigs… field (`:1482`), an expandable row, and the
  detail pane all exist. The caption says "the detail pane on the left",
  which is the default layout but a user preference (claim 22). Consider
  "the detail pane alongside".
- `nvd-column-menu`: all three menu sections exist
  (`MetadataColumnController.swift:358-400`). Caption accurate, though the
  Sample Metadata section only appears once metadata has been imported, so
  the shot recipe must import metadata first.
- `nvd-blast-drawer`: the drawer does sit below the outline and above the
  action bar (`NvdResultViewController.swift:1862-1867`), and BLAST Verify is
  the leftmost action-bar button (`ClassifierActionBar.swift:22`). Caption
  accurate. This shot needs a full NVD run, since the fixture ships no
  per-sample FASTA and BLAST Verify cannot fire on it.

## Settings coverage against parameters.yaml

`parameters.yaml:1856-1881` gives `import.nvd` an empty `settings: []`, a
`gating: []`, and two `cli_only` flags. The chapter covers both.

| Registry entry | Covered | Verdict |
|---|---|---|
| `settings: []` | Chapter opens Settings with "The NVD import has no settings." | Correct. The sheet holds only Browse..., a readout, the Preview panel, Cancel, and Run (`NvdImportSheet.swift:174-266`), none of which alters the import. |
| `cli_only --name`, default `nvd-{experiment}` | Yes | Default and effect match `cli-help/import.txt:457` and `MetagenomicsImportService.swift:650`. Three-sentence shape honoured. |
| `cli_only --output-dir`, default "the current directory" | Yes | Matches `cli-help/import.txt:454-456`. The chapter adds the `-o` abbreviation, which the help confirms. Three-sentence shape honoured. |
| `gating: []` | Yes | "No plugin pack is needed" in Before you start. |

The three viewport controls (By Sample / By Taxon, All Samples, Search
contigs…) are **not** registry settings and do not belong to `import.nvd`.
Putting them under this chapter's Settings heading is a judgement call rather
than an error. In their favour: the chapter announces the move explicitly at
line 118 and again at line 124, they are the viewport's only stateful
controls, they get no other home, and each is written in the fixed
three-sentence shape with a real default. Against: a reader who has learned
that Settings maps to the registry now finds three entries with no registry
row and no CLI flag, and every claim in them was verified true
(`NvdResultViewController.swift:313`, `:1703-1712`, `:1482`,
`NvdDatabase.swift:680-697`). Recommendation: keep them, since the alternative
is losing them, but flag to the documentation lead whether a viewport-controls
subsection under Reading the results is the better home across the campaign.
This is a template question, not a fidelity failure.

## Consistency

Checked against `CONSISTENCY.md` and the committed classification chapters.

- App naming. "Lungfish Genome Explorer (LGE)" at line 40, "LGE" thereafter,
  never bare "Lungfish" for the app. Matches `CONSISTENCY.md:11-12`.
- Import Center path "**File > Import Center...**" matches
  `CONSISTENCY.md:27`.
- Fixture name "the NVD demo results" is the exact approved string
  (`CONSISTENCY.md:127`).
- Before you start reproduces both fixed sentences verbatim
  (`CONSISTENCY.md:140-147`).
- Folder convention. The chapter's statement that classifier runs go under
  `Analyses/` matches `CONSISTENCY.md:54-61` and `AnalysesFolder.swift:24-28`.
  Its statement that the Import Center writes to `Imports/` is true of the
  code but is a divergence the consistency doc does not yet record. See App
  defect 1.
- Cross-references. `06-blast-verification.md`,
  `08-importing-cz-id-results.md`, `05-running-nao-mgs.md`, and
  `01-what-is-classification.md` all exist in the same directory.
- The DRIFT note for chapter 06/02 (`DRIFT.md:1965`) settles that the NVD
  contig viewport's menu item reads **Verify with BLAST…**, and this chapter
  uses that string. Consistent.
- Glossary discipline. Every term glossed inline at first use in this
  chapter, per `CONSISTENCY.md:132-136`.
- Prose rules. Lint is green under `LUNGFISH_MANUAL_STRICT=1`. No em dashes
  in prose, no semicolons, no in-sentence colons, bullet caps respected (the
  chapter uses no bullet lists at all).

## App defects

1. **Import destination contradicts the folder convention.** Confirmed and
   ruled on. The GUI Import Center route builds
   `projectURL/Imports` and passes it as the output directory
   (`AppDelegate+ToolsMenu.swift:636`, used at `:659`, and echoed into the
   replayable `cliCommand` at `:647-650`). Both CLI spellings default to the
   current working directory and honour `--output-dir`
   (`cli-help/import.txt:454-456`, `cli-help/nvd.txt` `==== nvd import ====`),
   so neither has an opinion about `Imports/` versus `Analyses/`. The demo
   project's bundle sits at `Analyses/nvd-demo` purely because the fixture
   build passed `--output-dir ".../Analyses" --name nvd-demo` explicitly, which
   its `.lungfish-provenance.json` `argv` records. So the three routes are
   GUI to `Imports/` always, `lungfish-cli import nvd` and `lungfish-cli nvd
   import` to wherever you point them. Meanwhile `nvd` is a member of
   `AnalysesFolder.knownTools` (`AnalysesFolder.swift:26`) and is listed in
   `importedResultTools` (`:32`), which exists precisely to give imported NVD
   results `{tool}-{name}` naming under `Analyses/`. The app therefore carries
   machinery for `Analyses/nvd-*` that the GUI import path never reaches. The
   chapter's handling is correct and honest. This is a product decision.
2. **No sort control in the contig outline.** Confirmed. No sort descriptor
   is assigned to any of the fourteen columns, `sortDescriptorsDidChange` is
   not implemented, and no header-click action is wired
   (`NvdResultViewController.swift:1206-1290`). Rows arrive `ORDER BY qlen
   DESC` (`NvdDatabase.swift:576`, `:696`) and stay that way. DRIFT's Missing
   row calling this "Column visibility and sorting ... driven by the shared
   column-filter machinery" is wrong about sorting. Every sibling
   classification viewport offers sorting, so this reads as an omission rather
   than a design choice.
3. **Column count.** Confirmed. Fourteen, not DRIFT's thirteen. Aln Length
   (`NvdResultViewController.swift:1284-1288`, identifier `coverage`) is a
   distinct column from the three read-count columns.
4. **Fixture README wrong on two counts.** Confirmed, both.
   `docs/user-manual/fixtures/nvd-demo/README.md:3` calls NVD "Nucleotide
   Viral Diversity"; the CLI help, the glossary, and the Import Center card
   all say Novel Virus Diagnostics. Line 27 says the rows are "all SARS-CoV-2
   hits"; the CSV holds SARS-CoV-2 (3 rows), HIV-1 (5), Human gammaherpesvirus
   4 (1), and Norovirus GII (1). Another role owns that file.
5. **`features.yaml` wrong on two counts, not one.** `features.yaml:743-746`
   reads "Novel Virus Discovery Nextflow output". It is wrong about the
   workflow engine (Snakemake per `cli-help/nvd.txt`) **and** about the
   expansion (Diagnostics, not Discovery). The author reported only the
   Nextflow half.
6. **New: the Export TSV silently drops two visible columns.** Not previously
   reported. `contigsTSVContent()` writes twelve columns
   (`NvdResultViewController.swift:2223`) while the outline shows fourteen
   (`:1206-1290`). `uniqueReads` and `coverage` (Aln Length) have no export
   counterpart, so a user who reads the chapter's advice to compare Length
   against Aln Length cannot carry that comparison into the exported table.
   The export's own provenance record names the metadata columns but not this
   omission.
7. **Minor: the filter bar's built order differs from every description of
   it.** The controls are added sample filter, grouping, search
   (`NvdResultViewController.swift:1469`, `:1479`, `:1491`), while the class's
   own layout comment (`:96-101`) and the chapter both present grouping first.
   Cosmetic, but it makes the chapter's sentence wrong (claim 23) and will
   make the planned screenshot caption misleading if it enumerates them.

## Notes for the editor

- Two false claims to fix, both one-word or one-clause repairs. Claim 23 is
  the filter bar's control order. Claim 52 is the menu item title
  **Extract to New Bundle…**, not "Create Bundle…".
- Claim 54 is true but under-informs. A sentence naming the two columns the
  export leaves out would prevent a real surprise, and the chapter is the only
  place a reader would learn it.
- Claim 22's "detail pane on the left" is right by default and wrong for a
  reader who has changed the Inspector's panel-layout preference. The same
  wording appears in the `nvd-result-viewport` caption. Softening both to
  "alongside" or adding "by default" costs nothing.
- Claim 25's "in the order the pipeline ranked them" credits the pipeline with
  an ordering LGE actually derives. On this fixture the two agree, so nothing
  visible changes, but "best e-value first" is both shorter and true.
- The chapter's RPB worked examples both check out. SampleA's SARS-CoV-2
  contig and SampleB's herpesvirus contig are both 50,000, which is exactly
  the point the passage makes. Note for anyone re-deriving figures that
  SampleA's HIV-1 contig is 20,000 and SampleC's total read count is 500,000,
  neither of which the chapter uses.
- Everything the author flagged as unverifiable remains unverifiable and is
  correctly hedged or omitted in the chapter. The one claim I would still call
  open is metadata columns surviving a close and reopen (claim 58).
- DRIFT's own row for this chapter needs two corrections recorded: thirteen
  columns should read fourteen, and the Missing row asserting sorting should
  be struck.

## Counts

70 claims checked. 66 true, 2 false, 1 unverifiable, 1 true but incomplete.
Two of the true verdicts carry a precision note (claims 22 and 25).
Seven app defects, of which two are new to this review (the Export TSV's
missing columns, and the filter bar's built order), and one is an enlargement
of a defect the author reported (`features.yaml` is wrong about the expansion
as well as the workflow engine).
