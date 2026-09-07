---
title: Importing CZ ID Results
chapter_id: 06-classification/08-importing-cz-id-results
audience: bench-scientist
prereqs: [01-foundations/06-the-lungfish-project, 06-classification/01-what-is-classification]
estimated_reading_min: 28
task: Import a CZ ID taxon report export into a project as a taxonomy result bundle and read it in the taxonomy viewport.
tags: [classification, cz-id, import, taxonomy, metagenomics]
tools: [cz-id]
parameters_refs: [import.cz-id]
entry_points:
  - "File > Import Center... > Classification Results > CZ-ID Results"
  - "CLI: lungfish-cli import cz-id"
  - "CLI: lungfish-cli cz-id summary"
shots:
  - id: czid-import-card
    caption: "The Import Center on its Classification Results tab with the CZ-ID Results card, whose file hint reads taxon report TSV, .zip, or extracted folder."
  - id: czid-import-sheet
    caption: "The CZ-ID Import sheet after a successful scan, showing the CZ-ID Export section with its Browse... button, the Preview panel listing Sample, Project, Rows, Source, Report, Pipeline, NT DB, NR DB, and Top taxa, and the Project Destination readout, which must stay visible because it is the defective control this chapter documents."
  - id: czid-result-viewport
    caption: "An imported CZ ID result open in the taxonomy viewport, with the sunburst on the left, the per-taxon table on the right, and the action bar reading Imported CZ-ID result followed by the sample name and taxon count."
  - id: czid-provenance-popover
    caption: "The CZ-ID Pipeline Info popover opened from the action bar's Provenance button, listing Sample, Project, Format Version, Rows, Pipeline, NT Database, NR Database, Bundle, and Source Files."
illustrations: []
glossary_refs: [bundle, checksum, clade, cz-id, e-value, fastq, import-center, kreport, metagenomics, operations-panel, percent-identity, plugin-pack, provenance, provenance-sidecar, read, read-classification, reads-per-million, taxon, taxonomic-rank, taxon-report]
features_refs: []
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

## What it is

A [taxon](../../GLOSSARY.md#taxon) is any named group on the tree of life, so *Homo sapiens*, *Streptococcus*, and the virus family *Coronaviridae* are each one taxon. [CZ ID](../../GLOSSARY.md#cz-id) is a [metagenomics](../../GLOSSARY.md#metagenomics) service that runs in a web browser rather than on your own machine, and it reports what it found one taxon at a time. Metagenomics means studying all the genetic material in a mixed sample at once rather than one cultured organism at a time. You upload sequencing [reads](../../GLOSSARY.md#read) to CZ ID, a read being one stretch of sequence a sequencing instrument produced, and the service compares them against its reference databases and hands back a table naming the organisms it found. A reference database is a stored collection of known sequences that the reads are compared against, so it is a library of many organisms rather than the single genome a reference sequence holds. The table CZ ID returns is a [taxon report](../../GLOSSARY.md#taxon-report), with one row per taxon and the evidence CZ ID gathered for it.

One row in that table is not an organism at all. CZ ID writes a `root` row carrying the sample's total read count, so that every other row's share can be measured against it. The root row turns up again in the converted file, in the taxon count the window shows, and at the centre of the chart, and this chapter calls it the root row everywhere.

Lungfish Genome Explorer (LGE) reads that report. It does not run CZ ID, does not upload your reads anywhere, and does not sign in to a CZ ID account or sync with one. That is all LGE does with CZ ID. CZ ID stays a service you use in a browser, and LGE stores and displays the answer it gave you.

Importing does more than copy a file into a folder. LGE converts the CZ ID report into its own [read classification](../../GLOSSARY.md#read-classification) format, which is the same format every classifier in LGE writes. A classifier is a program that names the organism each read most likely came from, and read classification is what such a program produces. The format is written to disk as a [kreport](../../GLOSSARY.md#kreport) file, so the two names refer to one thing. A kreport is a table with a tab character between the columns, the summary format [Kraken 2](02-running-kraken2.md) writes, Kraken 2 being the classifier LGE installs and runs on your own machine rather than a service you send data to. Because the format is shared, an imported CZ ID result opens in the same viewport as a Kraken 2 run and can be sorted, searched, and exported the same way, a viewport being the panel LGE opens over one result to display it. The import also keeps the original report verbatim beside the converted copy and records the CZ ID pipeline version and both database versions in [provenance](../../GLOSSARY.md#provenance), the record LGE keeps of where every file came from. A pipeline is a chain of programs run one after another, and a pipeline version names which chain of code produced your numbers.

You reach the import through **File > Import Center...**, and the Procedure below walks that route. It is not under **Tools > Classification**, and importing does not turn CZ ID into a runnable option there, because that menu holds tools LGE can run itself on a [FASTQ](../../GLOSSARY.md#fastq) file, FASTQ being the plain-text format that holds raw sequencing reads. Export the report from CZ ID first, then bring it in through the Import Center or the command line, so the pipeline and database versions travel into the project with the numbers.

## Why you would do this

Most labs that use CZ ID do so because it removes the burden of running a large metagenomic pipeline on their own hardware. That is a reasonable choice, and it leaves you with one problem. The answer lives in a browser tab, in an account, behind a login, and only while that service keeps it. Six months later the question a journal reviewer or an auditor asks is not "what did CZ ID say" but "which database version said it, and can you show me the file".

Importing the report answers that question by moving the evidence into a project you control. A [bundle](../../GLOSSARY.md#bundle) is a folder LGE treats as one object in the sidebar, and the bundle the import creates carries the original report unchanged, the converted copy, and a [provenance sidecar](../../GLOSSARY.md#provenance-sidecar) recording the source file's [checksum](../../GLOSSARY.md#checksum). A checksum is a short fingerprint computed from the file's exact bytes, so two people can confirm they hold the identical file. LGE computes and stores checksums for you and compares them when it needs to, so you never type one or check one by hand. The record survives whatever happens to the account.

The second reason is that a CZ ID report on its own is a long table, and a table of a thousand rows makes it hard to see which taxa dominate. Once the report is in a project it opens in the taxonomy viewport, which draws the same rows as a chart sized by read count, so the two or three taxa that actually matter separate visually from the many taxa carrying only one or two reads, which are usually background rather than real findings.

The worked example is a three-row taxon report from a SARS-CoV-2 respiratory sample, small enough that you can check every number in it by hand. This chapter uses a viral example because CZ ID is a pathogen-detection service.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. A name written as Cmd-N is a keyboard shortcut, meaning hold the Command key and press N. Make a new empty folder for the project rather than picking one that already holds your data, since LGE fills the folder with its own structure.

This chapter uses the file `minimal_taxon_report.tsv`, a small synthetic three-row taxon report kept in the repository for testing. GitHub offers no download for a single folder, so open the repository's front page at https://github.com/dhoconno/lungfish-genome-explorer, click the green **Code** button, choose **Download ZIP**, double-click the downloaded file to unpack it, and find the file inside it under `Tests/Fixtures/czid/`. Every number quoted in this chapter comes from importing that file on 2026-09-07, and this chapter calls that the reference run. A report from a real CZ ID run will be far longer while behaving in every way the same.

Getting the export out of CZ ID is the one step this chapter cannot walk you through. The buttons and pages inside the CZ ID website belong to the service and are not covered here, so follow CZ ID's own instructions for downloading a sample's report. What matters on this side is the file you end up with. LGE needs a taxon report carrying the three columns `tax_id`, `taxon_name`, and `rank`, and a standard CZ ID taxon report has all three. Either a download of a single sample's report or the whole export archive works, and the Procedure below says how to point the importer at each. To check the columns yourself, open the file in a spreadsheet program such as Numbers or Excel and read the header row across the top. If the three columns are missing, the import stops with the message "CZ-ID taxon report must include tax_id, taxon_name, and rank columns" and writes nothing.

No [plugin pack](../../GLOSSARY.md#plugin-pack) is needed. A plugin pack is a themed group of external tools LGE installs on demand, and importing a CZ ID report reads and rewrites a text file, so it uses nothing beyond LGE itself. The reference import of the three-row report finished in well under a second, and the work is parsing text rather than analysing sequence, so it stays quick on a longer report.

## Procedure

The worked example imports one taxon report into a project and then reads the result in the taxonomy viewport. In the commands and paths below, anything written as `/path/to/something` is a placeholder standing in for wherever the file sits on your own machine, and you type your own path in its place.

### 1. Choose the export CZ ID gave you

CZ ID hands its reports out in three forms, and LGE accepts all three.

- A single taxon report file ending in `.tsv`. TSV stands for tab-separated values, a plain-text table with one row per line and a tab character between the columns.
- A ZIP archive, which is one compressed file holding a whole export.
- A folder you have already unpacked from such an archive.

Point the importer at whichever you have. Given an archive or a folder, LGE finds the taxon report inside for you, and any unpacking it does happens in a temporary place and leaves nothing new beside your own file. The reference run confirmed all three ways against the same three-row report, and each produced an identical bundle.

### 2. Open the Import Center card

Choose **File > Import Center...** and click the **Classification Results** tab. The Import Center is a tabbed grid of cards, one card per kind of import. Find the **CZ-ID Results** card, which carries a small `CZ` badge for an icon and whose file hint reads "taxon report TSV, .zip, or extracted folder". The card's own description states the boundary again, that CZ ID is imported and not run locally.

<!-- SHOT: czid-import-card -->

Click the card. A sheet titled **CZ-ID Import** opens, subtitled "Hosted metagenomics taxon report". Dragging your export file onto the card opens the same sheet with the path already filled in, so drag and drop saves the Browse step rather than completing the import on its own.

### 3. Point the sheet at the export and read the preview

1. Click **Browse...** in the **CZ-ID Export** section and select your report file, ZIP archive, or extracted folder. The readout beside the button reads "No file or folder selected" until you do, and the status line at the foot of the sheet reads "Select a CZ-ID export."

2. Wait for the scan. The status line reads "Scanning CZ-ID export..." while it works, which on a report this size is momentary.

3. Read the **Preview** panel. It reports what LGE found without importing anything, so a wrong file is caught here rather than in the project. On the reference run the panel read as follows.

    | Preview row | Value on the reference run |
    |---|---|
    | Sample | `Sample-CZ-001` |
    | Project | `Project-42` |
    | Rows | 3 |
    | Source | Taxon report file |
    | Report | the report's file name |
    | Pipeline | `8.4` |
    | NT DB | `nt_2025_12_01` |
    | NR DB | `nr_2025_12_01` |
    | Top taxa | the taxon names, at most five of them |

    Compare the Rows figure against the row count CZ ID showed you in the browser while the panel is still on screen, because this is the last moment the two are easy to hold side by side. The Project row appears only when the export carries a project identifier, which names the CZ ID project the sample was uploaded into, so a missing Project row is normal rather than a fault. The Pipeline, NT DB, and NR DB rows appear only when the report carries those columns.

    <!-- SHOT: czid-import-sheet -->

4. Read the **Project Destination** section, and treat the path it shows as wrong. The 2026.9.13 build names a folder there that no import writes to, and the note below step 5 says where the result actually lands.

5. Click **Run**. The button is labelled Run rather than Import, the same word every LGE dialog uses to start the work, and it stays disabled until you have selected a path. It then stays disabled until the scan has finished and succeeded. If the scan failed, the Preview panel shows a warning triangle with the reason written out as text beside it, and Run stays disabled.

The **Project Destination** readout in this sheet is wrong in the 2026.9.13 build. It shows a path under the project's `Analyses` folder ending in `cz-id-` and a timestamp, but the importer writes the bundle to the project's `Classifications` folder instead, on both the app route and the command-line route. The timestamp in that readout also changes as you work in the sheet, which is part of the same defect. Look for the result under `Classifications`, not under `Analyses`. The defect is recorded again at the end of this chapter.

### 4. Watch the import and find the result

The sheet closes and a row appears in the [Operations Panel](../../GLOSSARY.md#operations-panel), which does not open on its own, so open it yourself with **Operations > Show Operations Panel** (Cmd-Shift-P) if you want to watch. The row is titled "CZ-ID Import" and its detail reads "Converting" followed by the report's file name, then finishes with "Imported" and the sample name.

The row also carries the equivalent command line, which is optional and only useful if you later want to script the import or repeat it on a server. It is the same command the optional section at the end of this chapter explains.

LGE names the bundle for you, taking the sample name and replacing any character that is not a letter, a digit, a dot, a hyphen, or an underscore with a hyphen. The result lands at `Classifications/<sample>.lungfishtax` inside the project. Click that row in the project sidebar to open it.

### 5. Do the same on the command line (optional)

This step is optional. Everything above happens in the window, and a reader who never opens a terminal can go straight to Reading the results and lose nothing. The command below does the whole of step 2 through step 4 in one line. It is the same command the Operations Panel row carries, and running it against the reference report printed exactly the block shown under Reading the results.

```bash
lungfish-cli import cz-id /path/to/cz-id-taxon-report.tsv \
  --project /path/to/project.lungfish \
  --sample-name Sample-CZ-001
```

## Settings

The CZ ID import has no settings in the window. The sheet holds a **Browse...** button, a read-only path readout, the Preview panel, the Project Destination readout, and the **Cancel** and **Run** buttons, and none of those changes how the import behaves. Three options exist on the command line only, with no equivalent anywhere in the window, and all three are described below. A reader working only in the window needs none of them and can skip to Reading the results.

**--sample-name.** Names the `.lungfishtax` bundle the import creates, and therefore the row that appears in the sidebar under `Classifications`. It has no default and the flag is required, so `lungfish-cli import cz-id` refuses to run without it. Set it to whatever you want the result called in the project, remembering that in the app no name field appears, because the app takes the name from the report's own sample column. On the command line this is `--sample-name`.

**--metadata.** Records where a CZ ID metadata sidecar sits, a sidecar being a separate file that describes the sample rather than the taxa found in it, which CZ ID offers as its own download alongside the report. There is no default, so without the flag no metadata path is recorded. Pass it whenever you exported sample metadata alongside the report and want the audit trail to name it, and note that the reference run confirmed the file is recorded in provenance with its path, size, and checksum rather than copied into the bundle, so moving or deleting your copy later leaves the bundle intact and only leaves the recorded path pointing at a file that has moved. On the command line this is `--metadata`.

**--non-host-fastq.** Records where the run's non-host FASTQ sits, the non-host FASTQ being the reads CZ ID kept after discarding everything matching the host organism, the host being the person or animal the sample came from. There is no default, so without the flag no such path is recorded. Pass it when you downloaded those reads and want the bundle to point at them, and expect the same treatment as the metadata flag, meaning the path, size, and checksum are recorded rather than the reads copied. On the command line this is `--non-host-fastq`.

## Reading the results

Whichever route you took, the same five values describe the import. In the window they sit in the provenance popover described below. On the command line the reference import printed them like this.

```text
CZ-ID Import

Sample     : Sample-CZ-001
Rows       : 3
Pipeline   : 8.4
NT database: nt_2025_12_01
NR database: nr_2025_12_01
```

Rows counts every taxon row in the report, including the root row CZ ID writes to carry the sample's total read count. The reference report has three rows, so two of them are real taxa and the third is the root row. Pipeline is CZ ID's own pipeline version, naming which version of its analysis code produced the numbers. The two database versions name which snapshots of CZ ID's reference collections were searched. NT is NCBI's collection of nucleotide sequences, meaning DNA and RNA, and NR is NCBI's collection of protein sequences. All three values are read out of the report rather than invented, and they are the numbers a journal reviewer or an auditor will ask for.

### What lands in the bundle

The reference run's bundle held five files beside a `provenance` folder. These files are internal to the bundle and you never need to open one by hand, so read this subsection to know what is being kept for you rather than as a set of files to go and find.

`classification.czid.tsv` is the original report copied in byte for byte, which the run confirmed by comparing checksums, both source and copy reading `3852c1bd...`. That value is shortened here for display, and what matters is only that the two are identical, which LGE checks for you. `classification.kreport` is the converted copy in Kraken 2's summary format, which is what the viewport reads. `classification-result.json` records the run as LGE models it, naming the database `CZ-ID` and the database version `nt=nt_2025_12_01; nr=nr_2025_12_01`. `cz-id-manifest.json` holds the sample name, the project identifier, the row count, the three versions, and a schema version reading `cz-id-taxon-report-v1`. `.lungfish-provenance.json` is the sidecar for the whole import, recording the command that ran, whether it succeeded, how long it took, and every input and output file with its size and checksum.

The converted kreport for the reference report reads as follows, and it is worth reading closely because it shows exactly what the conversion does.

```text
100.00	1200	1200	R	1	root
7.33	88	88	D	10239	  Viruses
3.50	42	42	S	2697049	  Severe acute respiratory syndrome coronavirus 2
```

The six columns, left to right, are the percentage of reads under this taxon, the clade read count, the direct read count, a one-letter rank code, the NCBI taxonomy identifier, and the taxon name indented by its depth in the hierarchy.

The percentage in the first column is that taxon's NT read count as a share of the root row's NT read count, and the root row's 1,200 is where every percentage in the file comes from. Viruses drew 88 of those 1,200 reads, and 88 divided by 1,200 is 0.0733, which is the 7.33 percent shown. SARS-CoV-2 drew 42 of them, and 42 divided by 1,200 is 0.035, which is the 3.50 percent shown. The reads not accounted for by any row are the ones CZ ID could not assign and the ones it matched to the host, and neither group appears in the report as a row of its own. The fourth column is a one-letter [rank](../../GLOSSARY.md#taxonomic-rank) code, R for root, D for domain, S for species, a rank being the level of the naming hierarchy a taxon sits at. The fifth is the NCBI taxonomy identifier, the stable number NCBI assigns each named group, so 2697049 is SARS-CoV-2 wherever you meet it.

Only the NT read counts reach the kreport. The NR counts stay behind in the preserved original report, and so do three measures of how good each match was. [Percent identity](../../GLOSSARY.md#percent-identity) is the share of aligned positions where the read and the database sequence agree. Alignment length is how many positions were lined up to reach that figure, so a high identity over a short alignment is weaker evidence than the same identity over a long one. The [e-value](../../GLOSSARY.md#e-value) is how many matches this good you would expect to see by chance alone, so smaller is better. E-values are written on a logarithmic scale, meaning each step down is a factor of ten, so `1e-30` is ten to the power of minus thirty and is far stronger evidence than `1e-3`. None of the three travels into the shared format, and all three stay readable in the preserved original.

### The viewport

Selecting the bundle opens the taxonomy viewport, the same one a Kraken 2 run opens. On the left is a sunburst chart, which draws the root row at the centre and one ring per rank outward, with each wedge sized by read count, so the wedges nearest the centre are the broadest groups and each ring outward is more specific. On the right is the per-taxon table, with a breadcrumb bar naming wherever in the tree you have moved. Clicking a wedge selects that taxon and syncs the table to it. [Running Kraken 2](02-running-kraken2.md) describes how to move around the chart in full, and every part of it works the same way here.

Two things about the viewport are specific to an imported CZ ID result. The action bar, the strip of buttons along the top, reads "Imported CZ-ID result" followed by the sample name and the taxon count, so you can tell an import from a local run at a glance. The count shown is the manifest's row count, which counts the root row along with the real taxa, so the reference bundle reads 3 taxa for a report holding two real ones. That is expected behaviour rather than a mistake in your file, though counting the root row as a taxon is a defect in the label and is recorded at the end of this chapter.

The table's columns are Sample, Taxon Name, Rank, Reads, Direct, and a percent column headed simply **%**. Reads is the [clade](../../GLOSSARY.md#clade) count, a clade being one taxon together with everything beneath it in the classification, so Reads counts the reads assigned to that taxon or to anything under it. Direct is reads assigned to that taxon exactly. The two columns are shared with the classifiers LGE runs itself, where they usually differ. In a CZ ID import they are equal on every row, because the report gives one count per taxon and the conversion has no per-read assignments to add together.

<!-- SHOT: czid-result-viewport -->

The action bar's **Extract FASTQ** button is deliberately disabled on a CZ ID result, and hovering it explains why, reading "CZ-ID imports do not include per-read source IDs for FASTQ extraction." Pulling one taxon's reads out into a new bundle needs to know which reads those were, and a taxon report is a summary that does not say. To get those reads, go back to CZ ID and download them there. **BLAST Verify**, which sends a sequence to NCBI to see what else it matches and is covered in [BLAST Verification](06-blast-verification.md), stays available, and so does **Export**, which writes the whole table out as a CSV or TSV file.

### The provenance popover

The action bar's rightmost button opens a popover headed **CZ-ID Pipeline Info**, which is where the imported versions are meant to be read. It lists Sample, Project when the export carried one, Format Version, Rows, Pipeline, NT Database, NR Database, the bundle's path on disk, and every source file the import recorded. Each value is selectable text, so you can copy a database version straight into a methods section.

<!-- SHOT: czid-provenance-popover -->

## What good looks like

Check four things before you trust an imported result. The first three are checks on the Preview panel, so make them while the sheet is still open, as step 3 says.

First, check that the row count in the Preview panel matches the count CZ ID showed you in the browser for that sample. A real CZ ID report runs to many more rows than this fixture's three, so a preview reading far fewer rows than CZ ID showed you means you are looking at a different file from the one you meant, and the fix is to download the sample's report again from CZ ID.

Second, check that Pipeline, NT DB, and NR DB all carry values rather than being absent from the preview. A report exported without those columns imports fine and leaves you with numbers you cannot attribute to a database version later. Importing exists to prevent exactly that.

Third, check that the top taxa named in the preview are ones the sample could plausibly contain. For a SARS-CoV-2 respiratory sample, the virus and its family *Coronaviridae* near the top are what you expect, and a soil bacterium or a plant virus in first place says the file came from a different sample. The preview lists the names precisely so a mismatched file is caught before it lands.

Fourth, once the bundle is open, check that the sunburst's largest wedges are the organisms you expected, and compare the percent column for the top two or three of them against what CZ ID reported. Checking the whole table row by row against a browser tab is not practical on a report of any real size, and the largest wedges are where a problem shows. If the percentages disagree, re-export the sample from CZ ID as a single download rather than assembling files from several downloads by hand, since every percentage is computed against the root row and a root row from a different run skews all of them at once.

### Known defect in this build

The CZ ID Import sheet's **Project Destination** readout names a path under `Analyses` that no import ever writes to, and the timestamp it shows changes as you work in the sheet. Both the app and the command line write the bundle to `Classifications/<sample>.lungfishtax`. The readout is display only and the import itself is correct, so ignore the destination the sheet shows and look under `Classifications` for the result.

The action bar's taxon count is the second known defect. It counts the root row along with the real taxa, so a report holding two real taxa reads 3 taxa. The number is right for rows and wrong for taxa, and the summary command described below shows two rows for the same bundle.

## Troubleshooting

Three failure states show up in this chapter, and each has one cause worth checking first.

- The import stops with a message about `tax_id`, `taxon_name`, and `rank`. The file you pointed at is not a taxon report, or it was exported without those columns, so open it in a spreadsheet and read the header row.
- The Run button stays greyed out. Either no path is selected or the scan has not finished and succeeded, so wait for the Preview panel to fill and read the warning text if one appeared.
- The result is not under `Analyses` where the sheet said it would be. That is the known defect above, so look under the project's `Classifications` folder instead.

## On the command line

This section is optional. Everything above happens in the window, and nothing here unlocks a result the dialog cannot produce. It is here for readers who want to script an import or repeat one on a server. The whole procedure runs headless, meaning with no app window at all, by typing commands into the Terminal application. [The CLI Reference](../appendices/cli-reference.md) covers installing `lungfish-cli` and opening a terminal. As above, `/path/to/...` stands for wherever your own files sit.

The block below reproduces the whole chapter. The first command previews the report without importing anything, the second imports it into a project, and the third writes a converted result to a folder of your choosing instead of into a project.

```bash
# Preview the report before importing, ranked by NT read count.
lungfish-cli cz-id summary /path/to/cz-id-taxon-report.tsv --top 20

# Machine-readable forms of the same preview.
lungfish-cli cz-id summary /path/to/cz-id-taxon-report.tsv --top 20 --format tsv
lungfish-cli cz-id summary /path/to/cz-id-taxon-report.tsv --top 20 --format json

# Import into a project. Writes Classifications/<sample>.lungfishtax.
lungfish-cli import cz-id /path/to/cz-id-taxon-report.tsv \
  --project /path/to/project.lungfish \
  --sample-name Sample-CZ-001

# Record a metadata sidecar and the non-host reads in provenance.
lungfish-cli import cz-id /path/to/cz-id-export.zip \
  --project /path/to/project.lungfish \
  --sample-name Sample-CZ-001 \
  --metadata /path/to/metadata.json \
  --non-host-fastq /path/to/non-host.fastq.gz

# Standalone conversion outside any project.
lungfish-cli cz-id import /path/to/cz-id-taxon-report.tsv --output-dir ./cz-id-Sample-CZ-001
```

`cz-id summary` prints a text table by default. The reference report produced this.

```text
CZ-ID Results Summary

Sample     : Sample-CZ-001
Rows       : 3
Pipeline   : 8.4
NT database: nt_2025_12_01
NR database: nr_2025_12_01

TaxID    Organism                                         Rank          NT Reads  NT RPM 
─────────────────────────────────────────────────────────────────────────────────────────
10239    Viruses                                          superkingdom  88        73333.0
2697049  Severe acute respiratory syndrome coronavirus 2  species       42        35000.0
```

The table drops the root row and ranks what is left by NT read count, so a three-row report shows two taxa. CZ ID writes the rank of Viruses as `superkingdom`, which is the same rank the kreport's one-letter code writes as D for domain, so the two names refer to one level of the hierarchy.

NT RPM is [reads per million](../../GLOSSARY.md#reads-per-million), the taxon's read count scaled as though the sample held exactly a million reads. The Viruses row reads 73333.0 because 88 of 1,200 reads works out to 73,333 in every million. A single RPM figure is not high or low on its own, and the reason to compute one is to compare the same taxon across samples sequenced to different depths, where the raw read counts cannot be compared directly.

`--top` caps how many taxa are listed and defaults to 20, so the reference report's two taxa are well inside the cap. On a real report the cap hides everything past the twentieth taxon by NT read count, and you would raise it when you are looking for something you expect to be rare rather than reading the dominant organisms.

The `--format tsv` form writes a header row and the columns `tax_id`, `name`, `rank`, `nt_reads`, `nt_rpm`, and `nr_reads`. The `--format json` form carries the same six values under camel-case names, `taxId`, `name`, `rank`, `ntReadCount`, `ntRpm`, and `nrReadCount`, plus four the TSV omits, `ntPercentIdentity`, `ntAlignmentLength`, `ntEValue`, and `nrRpm`. The two forms hold the same measurements written in two naming styles for programs to read, so pick whichever your own script finds easier. Both drop the root row and both respect `--top`.

The import comes in two spellings, `lungfish-cli import cz-id` and `lungfish-cli cz-id import`, which differ only in word order and are easy to type in place of one another. They do the same conversion and differ in what they need from you and where they put the result.

| Command | What it needs | Where the result lands |
|---|---|---|
| `lungfish-cli import cz-id` | `--project` and `--sample-name`, both required | Inside the project, at `Classifications/<sample>.lungfishtax` |
| `lungfish-cli cz-id import` | Neither, since it takes the sample name from the export | A self-contained folder wherever `--output-dir` points, defaulting to `./cz-id-{sample}` |

Use the first when you want the result in a project and the second when you want a converted result on disk.

## Next

Read [BLAST Verification](06-blast-verification.md) to confirm one of the taxa the imported report names against NCBI, which sends a sequence to NCBI's search service and returns what else in the database it matches. [Running Kraken 2](02-running-kraken2.md) covers the taxonomy viewport in full, including the sunburst controls an imported CZ ID result shares with it. To classify reads inside LGE rather than importing an answer from elsewhere, start at [What Is Read Classification](01-what-is-classification.md).
