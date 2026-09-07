---
title: Downloading Reads from the SRA
chapter_id: 03-reads/02-downloading-from-sra
audience: bench-scientist
prereqs: [01-foundations/02-sequencing-reads, 01-foundations/06-the-lungfish-project, 03-reads/01-importing-fastq]
estimated_reading_min: 15
task: Search the Sequence Read Archive for a sequencing run and download it into the project as a read bundle.
tags: [reads, sra, ena, download, fastq, accession, amplicon]
tools: []
parameters_refs: [fetch.sra]
entry_points:
  - Tools > Search Online Databases > Search SRA...
  - "CLI: lungfish-cli fetch sra search <query>"
  - "CLI: lungfish-cli fetch sra download <accession>"
  - "CLI: lungfish-cli fetch sra info <accession>"
shots:
  - id: sra-runs-pane
    caption: "The Database Browser on its SRA Runs pane, with the Import Accessions button above the query field and the Advanced Search Filters panel expanded to show Platform, Strategy, Layout, Min Size (Mbases), Publication Date, and Max Results."
  - id: sra-results-download-selected
    caption: "The results list with the SRR32909537 run ticked and the dialog's primary button at the bottom of the window reading Download Selected instead of Search."
  - id: sra-import-configuration-sheet
    caption: "The Import FASTQ configuration sheet as it opens for an SRA download, with Platform on Illumina and Pairing on Paired-end, both read from the run's archive metadata."
  - id: sra-bundle-in-sidebar
    caption: "The downloaded SRR32909537 read bundle under the project's Imports folder in the sidebar, open in the FASTQ viewport."
illustrations: []
glossary_refs: [SRA, ENA, FASTQ, accession, run-accession, library-strategy, library-layout, operations-panel, project, bundle, provenance, provenance-sidecar, paired-end, interleaved-fastq, amplicon, insdc, phred-score, sparkline, mitochondrial-genome]
features_refs: [fetch.sra, fetch.ena]
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

## What it is

The Sequence Read Archive, written [SRA](../../GLOSSARY.md#sra), is the public warehouse for raw sequencing reads. When a paper reports new sequencing data, the reads are almost always deposited there. Lungfish Genome Explorer (LGE) searches that archive from inside the app and pulls a chosen run straight into your [project](../../GLOSSARY.md#project), so reads named in a paper become working data without a browser download and without a manual import afterwards.

The archive nests four kinds of [accession](../../GLOSSARY.md#accession), one inside the next, and only the innermost is what you download. A project holds samples, each sample holds experiments, and each experiment holds runs. A project accession begins `SRP`, or `PRJNA` in NCBI's own BioProject numbering, and gathers every experiment in one study. A sample accession begins `SRS` and names the biological material. An experiment accession begins `SRX` and gathers runs that share a library and a platform. A library here is one prepared pool of DNA fragments ready for the instrument, not a cloned collection. A [run accession](../../GLOSSARY.md#run-accession) begins `SRR`, `ERR`, or `DRR` and names one pass of one library through one instrument. Those three run prefixes and the two project prefixes record only which of the partner archives took the deposit, not any difference in the data. LGE downloads at the run level, because a run is what produces [FASTQ](../../GLOSSARY.md#fastq) files.

LGE reaches the archive through **Tools > Search Online Databases > Search SRA...**, which opens the Database Browser on its SRA Runs pane. That window is the same one [Downloading from NCBI](../02-sequences/02-downloading-from-ncbi.md) uses for finished sequences. Three tabs across the top of it switch between GenBank & Genomes, SRA Runs, and Pathoplexus, and the pane below the tabs is whichever one you have chosen. Search from the query field, tick a run, and download it.

What arrives is a finished bundle rather than loose files. LGE fetches the FASTQs from [ENA](../../GLOSSARY.md#ena), the European mirror of the same archive, then runs the same import the Import Center runs. You never open the Import Center yourself in this procedure. Each run lands as a `.lungfishfastq` [bundle](../../GLOSSARY.md#bundle) under the project's `Imports/` folder with its archive [provenance](../../GLOSSARY.md#provenance) written into the bundle's metadata sidecar. Provenance is the record of where a file came from and what was done to it. The practical consequence is that a downloaded run and an imported run are the same kind of object from the moment either one lands, so every later chapter treats them identically.

## Why you would do this

Two situations send you to the archive. You want to reproduce a published analysis, and the reads behind it carry a run accession printed in the paper. Or you want a known dataset to test a workflow against before you spend your own samples on it.

This chapter downloads `SRR32909537`, a human amplicon run that targets the [mitochondrial genome](../../GLOSSARY.md#mitochondrial-genome), the small circular genome carried inside mitochondria rather than in the nucleus. An [amplicon](../../GLOSSARY.md#amplicon) is a stretch of a genome copied many times by PCR before sequencing, so an amplicon run reads one target region deeply rather than the whole genome thinly. This run is 115,776 read pairs of 151-base Illumina reads, which is an ordinary depth for a single amplicon target and neither unusually shallow nor unusually deep. Those pairs hold 34,964,352 bases in total, a figure that already counts both mates of every pair. The two compressed files come to about 28 MB together, small enough to finish in under a minute on an ordinary connection and large enough to behave like a real dataset in every later chapter.

The run belongs to BioProject `PRJNA1243402`, one of 238 human amplicon runs deposited in the same study, which makes it a fair example of what a search returns in practice. You will rarely find one run sitting alone.

Download it once and the bundle is yours to reuse. Quality control, trimming, and mapping all take it as input.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. The active project decides where the reads land, so open the right one before you search.

This chapter uses a live SRA search rather than a downloaded fixture. A fixture is the manual's own frozen copy of a dataset, kept so the numbers printed here can be checked, and there is none here because the archive itself is the source. Every number in this chapter came from a real search and a real download run on 2026-09-06, and the run accession is fixed, so a repeat of these steps returns the same figures.

You need a working internet connection. No extra software has to be installed for this chapter. The download itself takes about 20 seconds for this run, and the import that follows takes a few seconds more.

## Procedure

1. Choose **Tools > Search Online Databases > Search SRA...**. The Database Browser opens on its SRA Runs pane, headed SRA Runs with the line "Search sequencing runs and import accession lists." beneath it. An Import Accessions button sits near the top of the pane in its own card, and the query field sits below that card with an unlabelled scope popup at its left end. That popup reads All Fields until you change it.

2. Click the Show button on the Advanced Search Filters panel below the query field. Six controls appear, Platform, Strategy, Layout, Min Size (Mbases), Publication Date, and Max Results. These narrow the search itself rather than the list you already have, so set them before you search rather than after. Set **Platform** to ILLUMINA, **Strategy** to AMPLICON, and **Layout** to PAIRED. The Settings section describes each control in full.

    <!-- SHOT: sra-runs-pane -->

3. Type `Homo sapiens mitochondrion` into the query field and click Search. That text matches the mitochondrial target this run was built to sequence. The results list fills with runs that match every filter you set.

4. Tick `SRR32909537` in the results list. Each row carries the run accession in the left, its length in bases at the right, and the run title and organism beneath. When the list is long and the rows look alike, set the scope popup to Accession, type the accession itself, and search again, which returns that one run on its own. Two buttons in this window read Search, so watch the right one. The Search button beside the query field never changes its title. The dialog's primary button at the bottom of the window is the one that changes from Search to Download Selected as soon as a row is ticked, and it goes back to Search when nothing is ticked.

    <!-- SHOT: sra-results-download-selected -->

5. Click Download Selected. LGE reads the run's archive metadata, then shows the Import FASTQ configuration sheet with the platform and the pairing it read from that metadata. For this run Platform reads Illumina and Pairing reads Paired-end. Read those two values, check that they match what you expect, and click Import.

    <!-- SHOT: sra-import-configuration-sheet -->

Override the Pairing popup before you import when you know the archive metadata is wrong, which the troubleshooting section below explains. Every other control on that sheet works exactly as [Importing Sequencing Reads](01-importing-fastq.md) describes, because it is the same sheet.

Watch the progress in the [Operations Panel](../../GLOSSARY.md#operations-panel), which you open with **Operations > Show Operations Panel** (Cmd-Shift-P) and which reports every download alongside every other running job. When it finishes, a bundle named `SRR32909537` appears under `Imports/` in the sidebar. Click it once to open it in the FASTQ viewport.

<!-- SHOT: sra-bundle-in-sidebar -->

### Downloading a list of accessions

When you already hold run identifiers, skip the free-text search. Click Import Accessions on the SRA Runs pane and pick a CSV or plain-text file listing them. One accession per line is enough, with no header row, so a file whose first line reads `SRR32909537` and whose second reads `SRR32909543` works. LGE parses the file, sets the scope popup to Accession, and runs one search for the whole list, so the results fill with those runs and you tick and download them as a batch. A file with no recognisable accession in it raises an alert reading "No Valid Accessions" rather than searching for nothing.

## Settings

These are the controls on the SRA Runs pane. Six of them sit in the Advanced Search Filters panel, which stays collapsed until you click Show, and the seventh is the scope popup on the query field itself. All seven shape the search, and none of them touches the download. The settings that shape the download are on the Import FASTQ configuration sheet, which [Importing Sequencing Reads](01-importing-fastq.md) documents in full.

Every entry ends by saying whether the setting reaches the command line. The command line is optional throughout this chapter, so if you work only in the dialog, those last sentences are safe to skip.

**Platform.** Keeps only runs produced on that sequencing instrument family, among Any, ILLUMINA, OXFORD_NANOPORE, PACBIO_SMRT, ION_TORRENT, ULTIMA, ELEMENT, and BGISEQ, of which OXFORD_NANOPORE and PACBIO_SMRT are the long-read families and the rest are short-read. The default is Any, which mixes short-read and long-read runs in one list. Set it when your analysis assumes one read type, since short and long reads need different tools all the way downstream. This setting has no command-line flag.

**Strategy.** Keeps only runs whose library was built for one purpose, among Any, WGS, AMPLICON, RNA-Seq, WXS, Targeted-Capture, and OTHER, where WGS is whole-genome shotgun, WXS is whole-exome shotgun, and AMPLICON is targeted PCR product. The default is Any, so every [library strategy](../../GLOSSARY.md#library-strategy) comes back together. Set it to AMPLICON when you want tiled primer-scheme data and whole-genome runs would be off target. This setting has no command-line flag.

**Layout.** Keeps only runs whose reads come in mate pairs, or only runs whose reads are single, among Any, PAIRED, and SINGLE. The default is Any, which returns both [library layout](../../GLOSSARY.md#library-layout) kinds mixed together. Set it to PAIRED when the workflow you plan to run needs both mates. This setting has no command-line flag.

**Min Size (Mbases).** Drops runs that produced less sequence than the amount you enter, measured in millions of bases. It starts empty, so no size floor applies and the shallowest deposits in the study still appear. Set it to exclude runs too thin to give the depth your analysis needs, and read the floor against this chapter's own run, which produced about 35 million bases, so a floor of 10 keeps it while a floor of 50 would drop it. This setting has no command-line flag.

**Publication Date.** Keeps only runs released inside the range you enter, through two fields labelled From and To. Both sides start empty, so the whole history of the archive is in scope. Set a start date when you are following an outbreak and older deposits are irrelevant. This setting has no command-line flag.

**Max Results.** Caps how many runs the search returns, offering 50, 100, 200, 500, and 1000. The default is 50, which is enough to look at without waiting. Raise it when a broad query is clearly truncating results you need. On the command line this is `--limit`, which defaults to 20 rather than 50. The two defaults differ deliberately, because a dialog shows a longer list without cost while a command-line default stays deliberately small.

**(search scope).** Restricts the query text to one indexed field rather than matching anywhere in the run record, through the unlabelled popup at the left-hand end of the query field, offering All Fields, Accession, Organism, Title, BioProject, and Author. The default is All Fields, which is right when you do not yet know which part of a record your search word sits in. Narrow it to BioProject when you want every run from one study, or to Accession when you already hold the identifier. This setting has no command-line flag.

## Reading the results

Two surfaces carry numbers worth reading, the search results list and the bundle that lands.

Each row in the results list shows the run accession in monospaced type, the sequence length in bases at the right of the same line, then the run title and the organism beneath it. The list is not a sortable table and it carries no column headers, so the filters above it are how you narrow a large result set. Ticking a row is what arms the download.

The command line prints the same runs as a real table, which is easier to scan when you are choosing among many. Here is the search this chapter used, run on 2026-09-06.

```text
Accession    Organism      Platform  Strategy  Layout  Reads         Size
──────────────────────────────────────────────────────────────────────────
SRR32909537  Homo sapiens  ILLUMINA  AMPLICON  PAIRED  115.8K reads  23 MB
SRR32909543  Homo sapiens  ILLUMINA  AMPLICON  PAIRED  73.7K reads   14 MB
SRR32909542  Homo sapiens  ILLUMINA  AMPLICON  PAIRED  56.5K reads   10 MB
```

Read that Reads column carefully, because it counts spots rather than individual reads. A spot is the archive's word for one fragment the instrument read from end to end, so a paired run reports one spot for every pair of mates. The 115.8K figure for `SRR32909537` is 115,776 spots, which is 115,776 pairs, which is 231,552 reads once the two mates are counted separately. The Size column is the archive's own compressed figure and it undercounts what actually arrives, since the two downloaded files came to 12,840,092 bytes (12.8 MB) and 15,276,682 bytes (15.3 MB) against the 23 MB the table promised. The delivered total of about 28 MB is the figure to trust.

Confirm a run before downloading it with `fetch sra info`, which reads the archive record without pulling a byte. It prints the same labelled fields for every run, filled in from that run's own record.

```text
Accession : SRR32909537
Experiment: SRX28184639
Study     : SRP573913
BioProject: PRJNA1243402
BioSample : SAMN47626540
Organism  : Homo sapiens
Platform  : ILLUMINA
Strategy  : AMPLICON
Source    : GENOMIC
Layout    : PAIRED
Reads     : 115.8K reads
Bases     : 34964352
Size      : 23 MB
```

The bundle that lands under `Imports/` behaves exactly like an imported one. Its FASTQ viewport shows the nine summary cards and the three [sparkline](../../GLOSSARY.md#sparkline) charts that [Importing Sequencing Reads](01-importing-fastq.md) walks through. A sparkline is a small chart drawn inline beside the cards, with no axes or labels of its own. For this run every read is exactly 151 bases, so the Length Dist. sparkline is a single spike rather than a spread. That single spike is expected here and is not a warning sign, because an untrimmed Illumina run carries one fixed read length until trimming shortens some reads.

The bundle also carries where it came from, in two separate files. The metadata sidecar describes the reads themselves and records the ENA read record, the download date, the download source, and the sequencing platform that was confirmed on the import sheet. The [provenance sidecar](../../GLOSSARY.md#provenance-sidecar) instead records the steps that produced the bundle, from the archive fetch through the import. Select the bundle in the sidebar and open the Inspector's Provenance section to read that history without leaving the app.

## What good looks like

Four checks are worth running before you build anything on downloaded reads.

Confirm the accession. The bundle name should read the run accession you asked for, here `SRR32909537`. A different name means a different run was ticked, which is easy to do in a list of 238 near-identical rows.

Confirm the read count against the archive. `fetch sra info` reported 115.8K and 34,964,352 bases, and that first figure counts spots, so it means 115,776 pairs. The bundle's Reads card counts individual reads instead, so it should read 231,552 for this run, twice the archive figure. A count well under 231,552 means the download stopped short.

Confirm the pairing. This run is PAIRED in the archive and the bundle should hold both mates. A Reads card showing 115,776 rather than 231,552 means only one mate arrived and the import ran as single-end, which the troubleshooting section below covers.

Confirm the folder. A downloaded run lands under `Imports/`, alongside anything you imported from disk, and not under `Downloads/`, which holds reference bundles fetched from NCBI. A read bundle anywhere else came from a different path than the one you thought you took.

## Which path served your download

LGE prefers ENA and falls back to NCBI's SRA Toolkit when ENA is out of reach. The two paths produce equivalent FASTQs and differ in speed and in the machinery underneath.

| Aspect | ENA (preferred) | NCBI SRA Toolkit (fallback) |
|---|---|---|
| What you get | Pre-converted FASTQ over HTTPS | `.sra` archive, then converted locally |
| Tools involved | Direct HTTPS fetch | `prefetch` then `fasterq-dump` |
| Typical speed | Fast, often network-limited | Slower, conversion-limited |
| When it fires | First attempt for every accession | ENA refuses or times out, or `--use-toolkit` is set |
| How to force it | Default | `lungfish-cli fetch sra download --use-toolkit` |

ENA hosts FASTQs directly because the European archives chose to keep the converted form beside the deposit. NCBI holds the same data as `.sra` archives and asks for a conversion step on download. LGE installs `prefetch` and `fasterq-dump` for you as part of its managed SRA Toolkit environment, so the fallback path needs nothing from you beyond a working connection. A newly released run is sometimes on NCBI alone for its first few hours, and a very old run is sometimes on ENA alone. The fallback exists so either case still ends in a file. Both archives are [INSDC](../../GLOSSARY.md#insdc) partners, so the data underneath is the same deposit either way.

The provenance sidecar names which path ran, and the Inspector's Provenance section is where you read it. For the download this chapter made, `selectedStrategy` read `ena-direct` and each download step recorded a `curl` command, the standard file-transfer program, against a `ftp.sra.ebi.ac.uk` address. A toolkit download instead records the `prefetch` and `fasterq-dump` commands it ran, with their full argument lists.

## Troubleshooting

Three failures account for most bad downloads.

**Rate limits.** ENA and NCBI both throttle anonymous requests when too many arrive from one network. The symptom is a download that starts, crawls, and ends in a partial file or an HTTP 429 in the log, where 429 is the web server's code for too many requests. Click View Log on the download's row in the Operations Panel to read it. A failed row carries no retry control of its own, so wait a few minutes, then start the download again from the SRA Runs pane exactly as you did the first time. An NCBI API key lifts the ceiling on searches and is free, optional, and worth requesting only if you search heavily. You pass it with `lungfish-cli fetch sra search --api-key <key>` after requesting the key from your NCBI account settings.

**Network failures mid-download.** A flaky connection leaves a partial file and the download reports as failed. Start it again from the same pane. When the failure survives several attempts, the toolkit fallback often succeeds where a direct ENA fetch does not, because it moves the bytes over a different transport, and `--use-toolkit` on the command line forces it.

**Archive metadata that disagrees with the data.** A small share of older deposits are tagged SINGLE in their metadata even though the data underneath is paired. LGE reads that metadata to fill the import sheet, so the sheet will offer Single-end and the reads will import as one file. The fix is to set the sheet's Pairing popup to Paired-end before you import, or to Interleaved when a single file holds both mates as consecutive records, which you recognise because the two mates of each pair alternate down the file rather than sitting in two separate files. Searching the run accession on the NCBI website reaches the run page, which shows the real layout and settles which is right.

## On the command line

This section is optional. If you work entirely in the dialog you have just used, you can skip it.

The commands below are the ones this chapter's numbers came from. The first searches, the second reads one record, and the third downloads.

```bash
# Search, and cap the list at 15 rows.
lungfish-cli fetch sra search "Homo sapiens mitochondrion AMPLICON Illumina" --limit 15

# Read one run's archive record without downloading anything.
lungfish-cli fetch sra info SRR32909537

# Download the run's FASTQ files into a folder.
lungfish-cli fetch sra download SRR32909537 --output-dir ./fastq
```

`--limit` caps the number of results and defaults to 20, which is lower than the dialog's default of 50. `--output-dir` names the destination and defaults to the current directory. `--use-toolkit` forces the SRA Toolkit path, which needs `prefetch` and `fasterq-dump` installed. `--api-key` sends your NCBI key so the service allows a higher request rate. Every `fetch` subcommand also takes `--format` with `text`, `json`, or `tsv`, alongside the usual `--verbose`, `--quiet`, `--debug`, and `--log-file` options.

The command line differs from the app in what it leaves behind. It writes loose files rather than a bundle, so a paired run lands as `SRR32909537_1.fastq.gz` and `SRR32909537_2.fastq.gz`, and a single-end run lands as `SRR32909537.fastq.gz`. Beside them it writes one provenance sidecar for the whole download, named `.lungfish-provenance.json` and placed in the output directory rather than named after any one file. To get a bundle from those files, import them with `lungfish-cli import fastq`, which is the step the app performs for you.

The `fetch` command reaches three other places besides the archive. `fetch ncbi` pulls a sequence record by accession, `fetch search` queries NCBI's sequence databases, and `fetch genome` builds an indexed reference bundle, all of which [Downloading from NCBI](../02-sequences/02-downloading-from-ncbi.md) covers.

### Reaching ENA directly

The download path above resolves through ENA on its own, so most people never call the mirror by name. When you want to see the exact URLs behind a run, `fetch ena reads` prints them.

```bash
lungfish-cli fetch ena reads SRR32909537
```

For this run it printed the Run, Study, Platform, Strategy, Layout, Reads, and File Size fields, followed by the two FASTQ URLs under `ftp.sra.ebi.ac.uk`. Note that its File Size of 28.1 MB is the delivered size, the same figure the two downloaded files add up to, and it is the one to trust against the 23 MB the SRA search reported. This resolves the URLs and does not pull the bytes, so treat it as a lookup rather than a recorded download step.

Two sibling subcommands round out the set. `fetch ena search <query>` searches ENA for sequences rather than runs, with `--organism` to filter by species and `--limit` to bound the list. `fetch ena fasta <accession> --save-to <path>` fetches a sequence in FASTA form, which helps on the odd occasion when ENA holds a record NCBI has not mirrored. For a reference that needs annotations, prefer the NCBI path instead, since the ENA FASTA carries bases only.

## Next

Continue to [Quality Control](03-quality-control.md) to run the first full quality pass on the reads you just pulled down.
