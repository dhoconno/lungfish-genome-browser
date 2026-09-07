# Author record, 06-classification/09-novel-virus-detection

Chapter: `docs/user-manual/chapters/06-classification/09-novel-virus-detection.md`
Roster row 40. Registry id `import.nvd`. Fixture `nvd-demo`.
Written 2026-09-07 against Preview 2026.9.13 sources and
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.

## Fixture provenance

The demo project's bundle at
`~/Desktop/lge-docs/LGE Manual Demo.lungfish/Analyses/nvd-demo/` names its
source in two places that agree. `manifest.json` carries
`sourceDirectoryPath` =
`docs/user-manual/fixtures/nvd-demo/results` in this worktree, and
`.lungfish-provenance.json` records the `argv`
`lungfish-cli import nvd <that path> --output-dir "<demo project>/Analyses" --name nvd-demo`.
The source fixture is therefore in-repo and was copied to the scratchpad at
`<scratchpad>/nvd/results` for the runs below.

## Commands run

All run from the scratchpad copy, not from the repo fixture.

| # | Command | Exit | Figures taken |
|---|---|---|---|
| 1 | `lungfish-cli nvd summary <scratch>/nvd/results --top 20` | 0 | The full text block quoted in "On the command line". Experiment `100`, 10 hits, 3 samples, 4 contigs. The four best-hit rows with lengths 500/300/400/200, organisms SARS-CoV-2 / HIV-1 / Human gammaherpesvirus 4 / Norovirus GII, identities 99.5 / 96.0 / 99.0 / 97.5, bit scores 920 / 750 / 750 / 380, mapped reads 50 / 20 / 100 / 10. |
| 2 | `lungfish-cli nvd summary <scratch>/nvd/results --top 2 --format tsv` | 0 | The TSV column list quoted in the chapter: `sample_id qseqid qlen adjusted_taxid_name sseqid pident evalue bitscore mapped_reads rpb`. Confirms `--top` limits the machine-readable form too. |
| 3 | `lungfish-cli import nvd <scratch>/nvd/results --output-dir <scratch>/nvd/proj/Analyses` | 0 | Confirmed the `nvd-{experiment}` default names the folder `nvd-100`. Final line `✓ NVD import complete: nvd-100`. Reported `Total hits: 10`, `Samples: 3`, `Contigs: 4`. Bundle contents: `analysis-metadata.json`, `bam/` (empty), `fasta/` (empty), `hits.sqlite`, `manifest.json`. |
| 4 | `lungfish-cli extract reads --by-classifier --tool nvd --result <scratch>/nvd/proj/Analyses/nvd-100 --sample SampleA --accession NODE_1_length_500_cov_10.0 --output <scratch>/nvd/nodeA.fastq` | 1 | The error string quoted verbatim in the chapter: `No BAM file found for sample 'SampleA'. The classifier result may be corrupted or imported without the underlying alignment data.` |

Command 4 failed by design rather than by fault. The fixture ships the BLAST
table only, and the importer therefore created empty `bam/` and `fasta/`
directories. The chapter documents the command and states plainly that it
cannot be run against this fixture.

## Figures computed from files read, not from a run

`docs/user-manual/fixtures/nvd-demo/results/05_labkey_bundling/demo_blast_concatenated.csv`
was read in full. Hits per contig, counted from it:
SampleA/NODE_1 = 3 rows (best + 2 secondary), SampleA/NODE_2 = 5 rows
(best + 4 secondary), SampleB/NODE_1 = 1, SampleC/NODE_5 = 1. The chapter's
"two further SARS-CoV-2 matches" and "four further HIV-1 matches" come from
these counts. The HIV-1 secondary bit-score run 750 down to 660 and identity
run 96.0 down to 92.0 are read off the same five rows. The aligned length 498
against contig length 500 is columns `length` and `qlen` of the first row.

RPB was verified arithmetically against
`NvdResultParser.swift:237` (`mappedReads / totalReads * 1e9`).
SampleA 50/1,000,000 = 50,000 and SampleB 100/2,000,000 = 50,000, matching
the manifest's `readsPerBillion` values.

## Source files consulted for window claims

| Claim in the chapter | File and lines |
|---|---|
| Import Center card title, description, and file hint | `Sources/LungfishApp/Views/ImportCenter/ImportCenterViewModel.swift:488-496` |
| Sheet is a wizard titled NVD Import with a **Browse…** button, a read-only path readout, and the hint "Select the top-level NVD run directory (containing 05_labkey_bundling/)" | `Sources/LungfishApp/Views/Metagenomics/NvdImportSheet.swift:180-206` |
| Preview panel rows Experiment / Samples / Contigs / BLAST hits, the conditional Total BAM size row, the live row counter, and the warning state | `NvdImportSheet.swift:209-266` |
| Confirm button is **Run**, not "Import", and is gated on `selectedPath != nil && !isScanning && hitCount != nil` | `NvdImportSheet.swift:80-90`, `:131-134` |
| GUI import writes into the project's `Imports/` folder | `Sources/LungfishApp/App/AppDelegate+ToolsMenu.swift:636`, and the `cliCommand` it builds at `:647-650` |
| Bundle name default `nvd-<experiment>`, shared by GUI and CLI | `Sources/LungfishWorkflow/Metagenomics/MetagenomicsImportService.swift:650` |
| Four summary cards labelled Experiment, Samples, Contigs, Hits, and their value formatting | `Sources/LungfishNvdUI/NvdResultViewController.swift:2944-2976`, fed at `:520-525` |
| Detail pane on the left, outline on the right | `NvdResultViewController.swift:90-104` |
| The fourteen outline columns, in order | `NvdResultViewController.swift:1206-1290` |
| Grouping segmented control labelled "By Sample" / "By Taxon" | `NvdResultViewController.swift:313` |
| Sample filter button relabelling between "All Samples" and "N of M Samples" | `NvdResultViewController.swift:1703-1712` |
| Search field placeholder "Search contigs…" | `NvdResultViewController.swift:1482` |
| Search matches organism name, subject title, subject accession, and contig name, on best hits only | `Sources/LungfishIO/Formats/Nvd/NvdDatabase.swift:680-697` |
| Default row order is longest contig first | `NvdDatabase.swift:565-577` (`ORDER BY qlen DESC`) |
| Six detail metric pills labelled Identity, E-value, Bit Score, Mapped Reads, RPB, Length | `NvdResultViewController.swift:797-821` |
| Detail subtitle shape `Sample: <id>  •  <organism> (<rank>)` | `NvdResultViewController.swift:749-757` |
| "Contig Alignment" section header and the "Best hit: <accession> — <title>" line | `NvdResultViewController.swift:889-906` |
| "No BAM data available." fallback | `NvdResultViewController.swift:872-887` |
| Action bar buttons **BLAST Verify**, **Export**, **Extract FASTQ**, and the provenance info button | `Sources/LungfishKit/ClassifierActionBar.swift:22-82` |
| BLAST Verify enabled only for exactly one identity-backed row, and the two tooltip strings "Select a row to use BLAST Verify" and "Select a single row to use BLAST Verify" | `NvdResultViewController.swift:2107`, `:2128`, gate at `:2561-2573` |
| A taxon group row is not identity-backed | `NvdResultViewController.swift:2570-2571` |
| BLAST Verify pulls the contig sequence from the sample's FASTA before submitting | `NvdResultViewController.swift:1807-1826` |
| BLAST drawer opens at 220 points, is drag-resizable with a 160-point floor, and offers a rerun | `NvdResultViewController.swift:1852-1893`, `:1899-1910` |
| Column visibility is a right-click header menu with Standard Columns, Reset Column Widths, and Sample Metadata sections | `Sources/LungfishKit/MetadataColumnController.swift:355-400`, installed at `NvdResultViewController.swift:1307-1313` |
| Missing metadata values render as an em dash in a tertiary colour | `MetadataColumnController.swift:503`, `:535-536` |
| Context menu titles Extract Reads…, Copy Contig Name, Copy Accession, View Accession on NCBI, Search PubMed | `NvdResultViewController.swift:1915-1985` |
| The six shared sequence actions in that menu | `Sources/LungfishKit/FASTASequenceActionMenuBuilder.swift` via `NvdResultViewController.swift:1930-1950` |
| Unique Reads falls back to the mapped-read count when the pipeline supplied none | `NvdResultViewController.swift:2487-2492`, optional field at `NvdResultParser.swift:105` |
| Export writes a TSV through a save panel | `NvdResultViewController.swift:2224-2240` |
| Import Metadata… lives in the Inspector | `Sources/LungfishApp/Views/Inspector/InspectorView.swift:1155-1160` |
| Provenance popover reachable from the action bar | `NvdResultViewController.swift:2135-2143`, `Sources/LungfishNvdUI/NvdProvenanceView.swift` |

CLI help captures consulted:
`reviews/fidelity-2026-09/cli-help/nvd.txt`,
`cli-help/import.txt` (`==== import nvd ====`, lines 445-472),
`cli-help/extract.txt` (`==== extract reads ====`, the
"By Classifier Selection (--by-classifier)" block at lines 93-97 and the flag
list at lines 105-147).

## DRIFT items addressed

The one false claim (row 4, "Click **Choose**") is corrected to **Browse…**,
and further corrected past the drift report, since the sheet's confirm button
is **Run** rather than an "Import" button.

All five Missing rows are covered. The import sheet's Preview panel gets its
own procedure step with the four row labels and the conditional BAM-size row.
The BLAST results drawer is described with its 220-point opening height and
its drag behaviour. BLAST Verify's single-row rule is stated with both
tooltip strings. Column visibility is described as the header context menu it
actually is. `extract reads --by-classifier --tool nvd` gets a worked command
block in "On the command line", including the byte-identical-to-the-GUI
guarantee the help text states.

Both previously unverifiable claims were settled. The em dash for missing
metadata values is real (`MetadataColumnController.swift:503`). The
"reference-free" Inspector wording was not found anywhere in `Sources/`, so
the chapter no longer makes that claim at all and describes the actual
fallback string "No BAM data available." instead.

## Defects and inconsistencies found

1. **Import destination disagrees with the folder convention.** The Import
   Center path writes the NVD bundle into the project's `Imports/` folder
   (`AppDelegate+ToolsMenu.swift:636`), while `CONSISTENCY.md` and
   `AnalysesFolder.knownTools` both say a run by a named tool, nvd included,
   belongs under `Analyses/<tool>-<timestamp>/`. The demo project's own
   bundle sits under `Analyses/` because it was created by a CLI call with an
   explicit `--output-dir`, not by the app. The chapter states the app's
   actual behaviour and notes the difference rather than hiding it. Worth a
   product decision.

2. **The chapter previously instructed a sort that does not exist.** The old
   text told the reader to "Sort by Identity % ascending". The NVD outline
   installs no sort descriptors and no header sort action, and rows come back
   in a fixed `ORDER BY qlen DESC`. The rewrite says the ordering is fixed at
   longest-contig-first and restructures the "What good looks like" advice
   around that. The drift report did not catch this.

3. **Column count.** The drift report's row 11 says thirteen column titles.
   There are fourteen (`NvdResultViewController.swift:1206-1290`), because
   Aln Length is a separate column from the three read-count columns.

4. **The fixture README misnames the tool and misdescribes the data.**
   `docs/user-manual/fixtures/nvd-demo/README.md` calls NVD "Nucleotide Viral
   Diversity", whereas the CLI help and the glossary both say "Novel Virus
   Diagnostics". The same README says the hits are "all SARS-CoV-2 hits",
   but the CSV holds SARS-CoV-2, HIV-1, Human gammaherpesvirus 4, and
   Norovirus GII across four contigs. The README is another role's file and
   was not edited. Both errors should be fixed there.

5. **`features.yaml:748` calls NVD a Nextflow pipeline.** The CLI help says
   Snakemake, and per the campaign's precedence order the CLI wins. The
   chapter says Snakemake. Noted here because the features entry is still
   wrong.

## What could not be verified

- No GUI session was run. Every window claim in this chapter comes from the
  Swift sources listed above rather than from the running app.
- The BLAST Verify round trip was not exercised. It needs a per-sample contig
  FASTA, which this fixture does not ship, and it also needs a live NCBI
  call. The drawer's 220-point height and 160-point floor are read from the
  layout code, not measured on screen.
- The embedded alignment viewer inside the Contig Alignment section was not
  seen with data in it, for the same missing-BAM reason. The chapter
  describes it as the full alignment viewer and does not enumerate its
  controls.
- The Import Metadata flow was not run against an NVD result, so the claim
  that metadata columns survive reopening rests on
  `MetadataColumnController` plus the existing drift verdict rather than on a
  fresh observation.
- `--format json` for `nvd summary` was not run. Only `text` and `tsv` were
  exercised, and the chapter describes the JSON form only as "as JSON",
  without quoting a shape.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/06-classification/09-novel-virus-detection.md
```

Result: `docs/user-manual/chapters/06-classification/09-novel-virus-detection.md: no issues found`

## Glossary

One term added to `docs/user-manual/GLOSSARY.md`, in alphabetical position
between "Reading frame" and "Regular expression":
**Reads per billion**{#reads-per-billion}. It is listed in the chapter's
`glossary_refs`. No existing entry was edited.
