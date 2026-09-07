---
title: Novel Virus Diagnostics
chapter_id: 06-classification/09-novel-virus-detection
audience: analyst
prereqs: [06-classification/01-what-is-classification]
estimated_reading_min: 26
task: Import Novel Virus Diagnostics (NVD) pipeline results and read the contig-keyed BLAST viewport.
tags: [classification, nvd, novel-virus, blast, import, wastewater]
tools: [nvd]
parameters_refs: [import.nvd]
entry_points:
  - "File > Import Center... > Classification Results > NVD Results"
  - "CLI: lungfish-cli import nvd <input-path>"
  - "CLI: lungfish-cli nvd summary <input-path>"
shots:
  - id: nvd-import-card
    caption: "The Import Center on its Classification Results tab with the NVD Results card, whose file hint reads NVD run folder containing *_blast_concatenated.csv(.gz)."
  - id: nvd-import-preview
    caption: "The NVD Import sheet after a successful scan of the NVD demo results, showing the Browse... button, the path readout, and the Preview panel's Experiment, Samples, Contigs, and BLAST hits rows."
  - id: nvd-result-viewport
    caption: "The NVD viewport on the demo results, showing the four summary cards, the By Sample and By Taxon grouping control, the Search contigs... field, a contig row expanded to its secondary hits, and the detail pane alongside."
  - id: nvd-column-menu
    caption: "The right-click menu on the contig outline's column header, showing the Standard Columns checklist, Reset Column Widths, and the Sample Metadata section."
  - id: nvd-blast-drawer
    caption: "The BLAST results drawer open across the bottom of the NVD viewport below the outline and above the action bar, with the BLAST Verify button in the action bar at lower left."
illustrations: []
glossary_refs: [nvd, contig, blast, e-value, percent-identity, bit-score, accession, taxon, read, fastq, bam, bundle, provenance, reads-per-billion, inspector, operations-panel]
features_refs: []
fixtures_refs: [nvd-demo]
brand_reviewed: true
lead_approved: true
---

## What it is

A read classifier and [Novel Virus Diagnostics](../../GLOSSARY.md#nvd), abbreviated NVD, are both trying to answer the same question, which is what organisms a sample contains. They go about it differently. A [read](../../GLOSSARY.md#read) is one stretch of sequence the instrument produced, typically about 150 bases on an Illumina machine. A read classifier takes each read on its own and asks which organism it came from. NVD instead stitches the reads into [contigs](../../GLOSSARY.md#contig) first, a contig being a long continuous stretch of sequence assembled out of many overlapping reads, and then searches each contig against a database of known nucleotide sequences using [BLAST](../../GLOSSARY.md#blast), NCBI's sequence search program.

That extra length is what makes the evidence stronger. A chance resemblance between two sequences gets rapidly less likely as the matching stretch grows, so a match running across thousands of bases of contig is far harder to explain away than a match on a single 150-base read.

The pipeline chooses which database to search and records its version rather than its name in the output, so what you are reading afterwards are the results of a search against the pipeline's own BLAST database. It is not a database you pick or install.

That difference in evidence is what makes NVD a discovery tool rather than a tool for counting what is already known. When a read classifier meets sequence from a virus nobody has deposited in a database yet, it either names the nearest relative with more confidence than the evidence supports, or it reports nothing at all. A contig behaves differently. A long contig that matches a known virus across only part of its length, or matches it at low [percent identity](../../GLOSSARY.md#percent-identity), meaning the share of bases that agree, is a visible and interpretable signal, and that signal is exactly what a search for new viruses is looking for.

Lungfish Genome Explorer (LGE) does not run the NVD pipeline. NVD is an external pipeline written in Snakemake, a system for describing and running multi-step analyses. You never install or run Snakemake yourself. Somebody else runs the pipeline, usually on a computing cluster, and the finished results reach you as a folder of files. NVD was built for wastewater viral surveillance, the practice of sequencing sewage to watch which viruses are circulating in a community, and that is why this chapter's examples are viral throughout. What LGE offers is the import path and the reading surface. It parses the pipeline's finished output, stores it in the project, and opens it as a browsable window where each contig is a row and its ranked BLAST matches sit underneath.

An NVD run writes a series of numbered stage folders, and only the last one matters here. The pipeline's output file is named `*_blast_concatenated.csv`, where the asterisk stands for whatever prefix that particular run used, and it may be gzip-compressed as `*_blast_concatenated.csv.gz`, gzip being a compression format like zip that holds one file inside one archive. The file lives in a folder named `05_labkey_bundling/`, which is the pipeline's own internal label for its final stage and asks nothing of you. That one file is the only thing the importer reads, so the earlier stage folders do not need to be present and nothing is lost by their absence.

Read the window contigs first and organisms second. Each row states that this assembled sequence best matches that virus, alongside the numbers saying how good the match is, which is the right framing when the interesting cases are the imperfect matches.

## Why you would do this

You would import an NVD run whenever somebody else has run the pipeline and you now need to look at the answers. A finished NVD run is a large CSV file, short for comma-separated values, meaning a plain text table with one row per line and commas between the fields. Several rows describe the same contig. Each of those rows is one ranked match for that contig, and only the first of them is the pipeline's best guess, which is why the table is hard to reason about in a spreadsheet.

Importing solves that. LGE groups the rows back into contigs, keeps the ranked alternatives underneath each one, records where the file came from, and gives you a window where the runner-up matches are one click away, behind a small triangle called a disclosure triangle that opens a row to show what is nested inside it. Judging whether a match is trustworthy usually means comparing the best match against the second-best one, and a table with no grouping hides that comparison.

The second reason is bookkeeping. An imported result carries a [provenance](../../GLOSSARY.md#provenance) record naming the source directory, the command that imported it, and a checksum of the input file. A checksum is a short fingerprint computed from a file's contents, and it changes if so much as one character of the file changes, so it proves later that the file you imported is the file you still have. A figure or a methods paragraph can then point at the external run and the LGE import as two separate, auditable steps.

This chapter works through the NVD demo results, a small synthetic run holding 10 BLAST hit rows across 3 samples and 4 contigs. Ten hits for four contigs means most contigs carry several ranked matches, which is the normal shape of an NVD table. The fixture is deliberately tiny so that every number in this chapter can be checked by hand against the source file.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. A name written as Cmd-N is a keyboard shortcut, meaning hold the Command key and press N.

This chapter uses the NVD demo results. Download the folder `nvd-demo` from the manual's fixtures on GitHub at

https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/nvd-demo

GitHub offers no download for a single folder, so open the repository's front page at https://github.com/dhoconno/lungfish-genome-explorer, click the green **Code** button, choose **Download ZIP**, double-click the downloaded file to unpack it, and find the folder inside it under `docs/user-manual/fixtures/`.

The folder nests like this, and the folder you point the importer at is `nvd-demo/results`.

```text
nvd-demo/
  README.md
  results/
    05_labkey_bundling/
      demo_blast_concatenated.csv
```

Two steps in this chapter cannot be performed on the demo results, and it is worth knowing which before you start following them. Step 5, verifying a contig with BLAST, needs the contig's own sequence, which a full NVD run supplies as a FASTA file per sample. The final command-line example, extracting the reads behind a contig, needs the [BAM](../../GLOSSARY.md#bam) alignment files a full run produces, a BAM being the compressed record of where every read landed. In NVD the reads are aligned back to the contigs the pipeline assembled rather than to an outside reference genome, so a BAM here records which reads built which contig. The demo results ship neither file, so both of those steps are described rather than performed, and each says so again where you reach it.

No plugin pack is needed. A [plugin pack](../../GLOSSARY.md#plugin-pack) is a themed group of external tools LGE installs on demand, and importing an NVD run reads and reorganises a text file, so it uses nothing beyond LGE itself. The demo results finish in well under a second. A real surveillance run holding tens of thousands of hit rows takes longer, but the work is parsing text rather than analysing sequence, so it stays quick.

## Procedure

### 1. Open the importer

Choose **File > Import Center...**, click the **Classification Results** tab, and find the **NVD Results** card. Three dots at the end of a menu item mean the item opens a window rather than acting straight away. The card describes itself as importing Novel Virus Diagnostics classification results, and its file hint reads "NVD run folder containing *_blast_concatenated.csv(.gz)".

<!-- SHOT: nvd-import-card -->

Click the card. It opens a wizard sheet titled NVD Import, a sheet being a panel that drops down attached to the top of the window and holds it until you finish or cancel. The sheet scans the run and reports what it found before anything is written.

### 2. Point it at the run and read the preview

Click **Browse...** and select the run directory, which for the fixture is `nvd-demo/results`. The sheet's hint under the path readout says "Select the top-level NVD run directory (containing 05_labkey_bundling/)", so pick the folder above `05_labkey_bundling/` rather than the folder itself or the CSV file inside it. The path readout to the left of the button shows the chosen path for confirmation only, and the way to change it is to click **Browse...** again.

The sheet then scans the file and fills its **Preview** panel. While the scan runs the panel counts rows as it reads them, which you will see on a real run and not on the demo, since a file this small scans faster than the eye catches. When the scan finishes, the panel lists **Experiment**, **Samples**, **Contigs**, and **BLAST hits**, and it adds a **Total BAM size** row when the run also ships alignment files.

On the demo results the preview reads experiment `100`, 3 samples, 4 contigs, and 10 BLAST hits. The experiment identifier is a label the pipeline operator gave the run, carried in the CSV's first column, and it is not a count of anything, so `100` here names the run rather than measuring it. If the scan cannot find or parse the table, the panel shows a warning instead of the counts, which is the moment to check that you picked the run directory rather than one of its subfolders.

<!-- SHOT: nvd-import-preview -->

### 3. Import and open the result

Click **Run**. The button stays disabled until the scan has finished and found hits, so a sheet whose Run button is greyed out is telling you the preview has not succeeded yet. LGE parses the BLAST rows, groups them into per-contig rankings, writes them into a small database file inside the new result folder, copies any alignment and contig-sequence files the run provided, and writes the provenance record. That database file is internal to the result folder and you never open it by hand, so nothing extra needs installing. A row titled NVD Import appears in the [Operations panel](../../GLOSSARY.md#operations-panel), which you open with **Operations > Show Operations Panel** (Cmd-Shift-P).

The result folder is named after the run's experiment identifier, so the demo results import as `nvd-100`. The Import Center always writes the bundle into the project's `Imports` folder. Classification runs you start inside LGE go under `Analyses` instead, so an imported NVD result and a Kraken 2 run you launched yourself sit in different places. The demo project ships its own copy of an NVD result under `Analyses` only because that copy was imported from the command line with `Analyses` given as the destination.

Double-click that folder in the sidebar to open the NVD viewport, a viewport being the window LGE opens over one result to display it.

<!-- SHOT: nvd-result-viewport -->

### 4. Walk the viewport

Four summary cards run across the top of the window, labelled **Experiment**, **Samples**, **Contigs**, and **Hits**. On the demo results they read `100`, `3 samples`, `4 contigs`, and `10 hits`, which are the same four numbers the import preview showed. The command-line summary prints them too, which is an optional cross-check for readers who use the terminal.

Below the cards the window splits in two. A detail pane sits on one side and an outline of contigs on the other, the outline being an expandable table whose rows open to show further rows nested underneath. The detail pane is on the left by default, and the Inspector's panel-layout preference can put it elsewhere.

A filter bar sits above the outline holding three controls, which are the sample filter, the grouping control, and the search field. The grouping control offers **By Sample**, which lists every contig flat, and **By Taxon**, which gathers contigs under the organism their best match names. The Settings section below describes all three controls in full.

Each top-level row in the outline is one contig showing its best BLAST match. Click the disclosure triangle on a row to open its secondary matches, which are the same contig's lower-ranked results in rank order, best e-value first. On the demo results, contig `NODE_2_length_300_cov_5.0` in SampleA holds five matches in all, so opening it reveals four more HIV-1 matches under its best one. Contig `NODE_1_length_500_cov_10.0` in SampleA holds three, so opening it reveals two more SARS-CoV-2 matches. A contig name carries the assembler's own labels, where `NODE_2` numbers the contig, `length_300` gives its length in bases, and `cov_5.0` gives the average read depth the assembler saw across it. None of the three needs decoding to read the table.

Click a contig row to fill the detail pane. The pane heads with the contig name, then a line naming the sample and the organism with its rank, such as `Sample: SampleA` followed by `SARS-CoV-2 (species)`. Six metric pills sit under that. A metric pill is a small rounded badge carrying one label and one number. The six are labelled Identity, E-value, Bit Score, Mapped Reads, RPB (reads per billion), and Length, and the Reading the results section defines each number.

Below the pills sits a **Contig Alignment** section, which names the best hit's accession and title and then embeds LGE's alignment viewer over the reads that built the contig. That viewer draws the contig along the top and stacks the individual reads underneath at the positions where they matched it, so you can see how deeply and how evenly the reads cover the contig. When the run shipped no alignment file, that whole area reads "No BAM data available." instead, which is what the demo results show, since the fixture carries the BLAST table alone.

### 5. Verify a contig with BLAST

This step cannot be performed on the demo results, because verification needs the sample's contig-sequence FASTA and the fixture ships only the BLAST table. Read it now and run it against a full NVD run later.

Select exactly one contig row, or one secondary-hit row underneath a contig, and click **BLAST Verify** in the action bar at the bottom of the window. The button requires exactly one selected row that stands for a real BLAST hit, and it stays disabled otherwise. Hovering a disabled control in LGE shows a tooltip explaining the reason, which here reads "Select a row to use BLAST Verify" when nothing is selected and "Select a single row to use BLAST Verify" when several rows are. A taxon group heading in the By Taxon grouping is not itself a hit, so selecting one leaves the button disabled too. The context menu names the same action **Verify with BLAST…**, and the two labels do the same thing.

Verification pulls the contig's own sequence out of the sample's contig-sequence file and submits it to NCBI. Results arrive in a drawer that slides open across the bottom of the window between the outline and the action bar, taking up roughly the lower quarter of the window to begin with, and you can drag its top edge to make it smaller or to let it fill most of the window. The drawer offers a rerun control that repeats the search for whichever row is selected. [BLAST Verification](06-blast-verification.md) covers reading the returned matches.

<!-- SHOT: nvd-blast-drawer -->

## Settings

The NVD import has no settings in the window. The wizard sheet holds a **Browse...** button, a read-only path readout, the Preview panel, and the **Cancel** and **Run** buttons, and none of those change how the import behaves. Two options exist on the command line only, with no equivalent anywhere in the window, and both are described below. A reader working only in the window can skip them.

**--name.** Overrides the name of the folder the imported bundle is written into. The default is `nvd-{experiment}`, which takes the experiment identifier out of the CSV's first column, so the demo results import as `nvd-100` unless you say otherwise. Set it when you are importing two runs that share an experiment identifier, or when you want a name that reads better in the sidebar than a bare number. On the command line this is `--name`.

**--output-dir.** Names the directory the imported bundle is written into. The default is the current working directory, meaning the folder the terminal is sitting in when you press Return, which is almost never the folder you want, so in practice you pass a folder inside the project you mean to import into, either its `Imports` folder, where the window writes, or its `Analyses` folder, where the demo project keeps its copy, and the sidebar shows the result in either place. Change it whenever you are importing into a project rather than into a scratch folder. On the command line this is `--output-dir`, abbreviated `-o`.

The result window offers three controls of its own. They change what the window shows rather than what the import produces, so none of them is an import setting and none has a command-line flag.

**By Sample / By Taxon.** Switches the outline between two arrangements of the same contigs, where By Sample lists every contig flat and By Taxon gathers contigs under the organism their best match names. The default is By Sample, which is the arrangement for walking one run's contigs in order. Switch to By Taxon when you want every contig that matched a given virus collected in one place, which on the demo results groups SampleA's two contigs apart under SARS-CoV-2 and HIV-1.

**All Samples.** Opens a popover, a small panel that appears beside the button, for narrowing the outline to a chosen subset of the run's samples. The default is every sample selected, and the button relabels itself to report the state, reading "All Samples" while everything is selected and "2 of 3 Samples" once you deselect one. Narrow it when a run holds many samples and you want to read one of them without the others in the way.

**Search contigs….** Filters the outline to contigs whose organism name, subject title, subject accession, or contig name contains what you type. The default is empty, meaning every contig in the selected samples is listed. Type in it when you are looking for a named virus or a known accession rather than scanning the list. It searches best matches only, so a term appearing solely in a secondary hit will not bring its contig into view.

## Reading the results

The outline carries fourteen columns, left to right, and reading them well is most of what this window is for. Six of them also appear as the metric pills in the detail pane, marked below.

| Column | What it holds |
|---|---|
| Sample | The library the contig was assembled from |
| Contig | The assembler's name for the contig |
| Length | The contig's own length in bases (pill) |
| Classification | The organism the pipeline settled on |
| Rank | The taxonomic level of that name |
| Accession | The database record the contig matched |
| Subject | The full title of that database record |
| Identity % | Share of aligned bases that agree (pill) |
| E-value | How likely a match this good is by chance (pill) |
| Bit Score | Raw strength of the alignment (pill) |
| Mapped Reads | Reads that mapped back to this contig (pill) |
| Unique Reads | Of those, the reads that mapped nowhere else |
| RPB | Reads per billion, an abundance figure (pill) |
| Aln Length | Length of the region BLAST actually aligned |

Contigs are listed longest first and there is no sort control, so the order is fixed by design. Clicking a column header does nothing here, unlike the spreadsheets and genome browsers where a header click sorts. The columns can be reordered by dragging their headers and resized by dragging the dividers between them.

Right-click any column header to open a menu controlling which columns are shown. The menu opens with a **Standard Columns** checklist holding every column named above, so unticking one hides it, followed by **Reset Column Widths**, which restores the original widths after you have dragged them about. When sample metadata has been attached to the result, a **Sample Metadata** section appears below those, listing each metadata column so you can show it beside the BLAST numbers.

<!-- SHOT: nvd-column-menu -->

**Length** is how much sequence the assembler managed to build, and **Aln Length** is the length of the region BLAST actually aligned. Read the two together, because the gap between them is the part of your contig that matched nothing. On the demo results contig `NODE_1_length_500_cov_10.0` is 500 bases long and aligns over 498 of them, a match covering essentially the whole contig. A contig of 5,000 bases aligning over 400 is a very different claim, and the number that would tell you so is this pair rather than the identity figure. As a rough working line, a match covering less than half a long contig's length is worth chasing, since the unmatched majority is sequence no database explains.

**Identity %** is [percent identity](../../GLOSSARY.md#percent-identity), the share of aligned positions where the contig and the database sequence carry the same base, counted only across the aligned region. One rule of thumb covers the whole range. A contig whose best hit sits near 100 percent is a known virus. A contig in the high eighties to mid nineties is a divergent relative of a known virus, meaning something related to a database entry without being it, and that is the most common shape for a genuinely new sequence. A contig whose best hit falls below about 90 percent identity is the interesting case and the one the pipeline exists to find. On the demo results the four best matches run 99.5%, 96.0%, 99.0%, and 97.5%, all of them in known-virus territory.

**E-value** is the [e-value](../../GLOSSARY.md#e-value), the number of matches this good you would expect to find by chance alone in a database this size. Smaller is better, and the scale is logarithmic, so each step from `1e-30` to `1e-60` to `1e-90` is a thousandfold drop in the chance of a coincidence. On the demo results the strongest e-value is `1e-90` and the weakest is `0.0`, which does not mean zero chance but a number too small for the precision NCBI reports. As a rule of thumb, anything at or under `1e-30` is effectively certain not to be chance for sequence of this length. A value such as `0.004` would fail that test and would tell you the match could easily be an accident. E-values therefore matter mainly on short contigs, where a modest score can still be a coincidence, and they rarely change a decision on a long one.

**Bit Score** is the [bit score](../../GLOSSARY.md#bit-score), the raw strength of the alignment on a scale that does not shift with database size. A larger database gives chance matches more opportunities to turn up, which is why an e-value moves with database size and a bit score does not. The score rises with both the length and the quality of the match, so it is comparable among one contig's own hits rather than between contigs or between runs. That comparison is its real use in this window. Set the top hit's bit score against the second hit's. A drop of the same order as the top score itself means the call is clean, and two scores within a few percent of each other mean it is ambiguous.

**Mapped Reads** is the number of reads that mapped back to this contig, which is how much sequencing evidence stands behind it. **Unique Reads** is the subset of those that mapped to this contig and nowhere else. When the pipeline reported no separate figure, this column repeats the mapped-read count, which is what the demo results do, so seeing the two columns carry identical numbers on the fixture is expected rather than a fault.

**RPB** is [reads per billion](../../GLOSSARY.md#reads-per-billion), the mapped-read count divided by the sample's total read count and multiplied by a billion, which puts contigs from libraries of different sizes on one scale. The total read count comes from the pipeline's own table and is stored in the result rather than shown anywhere in the window, so RPB is the figure to compare rather than the raw counts. SampleA's SARS-CoV-2 contig carries 50 mapped reads out of 1,000,000 total, giving an RPB of 50,000. SampleB's herpesvirus contig carries 100 out of 2,000,000, and its RPB is also 50,000, so those two contigs are equally abundant in their own samples although one has twice as many reads. That is the whole point of the column. The figure has no fixed good or bad value, because what counts as abundant depends on the sample type, so read RPB by comparing contigs within one run rather than against a remembered number.

**Classification** and **Rank** are the organism the pipeline settled on and the [taxonomic](../../GLOSSARY.md#taxon) level of that name. Most rows on the demo results read `species`, and one reads `clade`, the Norovirus GII row. A clade is any group of organisms descended from one common ancestor, so it is a branch of the tree rather than a rung on the kingdom-to-species ladder, and NCBI uses it where a named group does not fit that ladder. Norovirus GII sits between genus and species in exactly that way. A broad rank is not a defect. It means the pipeline was unwilling to be more specific than the evidence allowed, and the right response is to report the identification as that group rather than as a species.

**Accession** and **Subject** identify the database record the contig matched, by [accession](../../GLOSSARY.md#accession) and by its full title. Right-click a row and choose **View Accession on NCBI** to open that record in a browser, or **Search PubMed** to search the literature for the organism name.

Right-clicking a contig row also reaches everything else you can do with one. **Extract Reads…** opens the shared extraction dialog for pulling the reads that built the contig into a new [FASTQ](../../GLOSSARY.md#fastq) [bundle](../../GLOSSARY.md#bundle). **Extract Sequence…** pulls the contig's own sequence into the project, **Verify with BLAST…** runs the verification described in step 5, **Copy FASTA** puts the sequence on the clipboard, **Export FASTA…** writes it to a file through a save panel, and **Extract to New Bundle…** wraps it as a new bundle in the project. **Run Operation…** hands the contig's sequence to the FASTQ/FASTA Operations dialog, so any operation that takes a sequence can be started from the row you are reading. **Copy Contig Name** and **Copy Accession** put those identifiers on the clipboard.

The action bar along the bottom holds three more actions beside BLAST Verify. **Export** writes the displayed rows out as a tab-separated file through a save panel, including whatever metadata columns are showing. The exported table carries twelve of the fourteen columns, leaving out Unique Reads and Aln Length, so a comparison of Length against Aln Length has to be made in the window rather than in the exported file. **Extract FASTQ** reaches the same extraction dialog as the right-click item. The information button at the right end, drawn as a lowercase letter i inside a circle, opens the provenance popover, which names the source directory, the importing command, and the input checksum.

Use **Import Metadata…** in the [Inspector](../../GLOSSARY.md#inspector), which you open with **View > Show Inspector** (Cmd-Opt-I), to attach a CSV or TSV sheet of sample metadata to the result. Each column in the sheet becomes a column you can show in the outline through the header menu. A sample with no value for a column shows a grey dash rather than dropping the column.

## What good looks like

Before you trust an NVD result, check the summary cards against what you expected the run to hold. The Samples card should report the number of libraries that went into the run, a library being one prepared sample loaded onto the sequencer. The hits count can never be lower than the contigs count, since every contig carries at least one match. The demo results show 4 contigs and 10 hits, meaning most contigs carry several ranked matches.

Then read the contigs the way the tool was built to be read, which is longest first, since that is the fixed ordering. For each of the long ones, compare Length against Aln Length and look at Identity %. A long contig matching near 100 percent identity across nearly its whole length is the routine case, and it says your sample contains a virus already in the database. A long contig whose match covers only part of its length, or whose identity falls below about 90 percent, is the candidate the pipeline exists to find, and it is the row to expand next.

Expanding is the check that matters most. A trustworthy call shows one match whose bit score is far above everything under it, dropping by something like the whole size of the top score. An ambiguous call shows several near-equal scores, often pointing at different organisms, and it should not be reported as a single identification.

SampleA's HIV-1 contig on the demo results shows the ambiguous shape in miniature. Its five matches step down gently from bit score 750 to 660, with identities running from 96.0% down to 92.0%. That shape would normally be a warning. Here it is not, because every one of the five matches names HIV-1, so the call is safe even though the scores sit close together. The shape to worry about is that same gentle step down across matches naming different organisms.

Finally, look at Mapped Reads before you believe a contig at all. A contig assembled from too few reads may be an assembly artifact rather than real sequence, and no BLAST number can tell you that. The check is to open the alignment in the detail pane's Contig Alignment section and look at the [pileup](../../GLOSSARY.md#pileup), meaning the stack of reads sitting over each position of the contig. A pileup covering only a short stretch of the contig, leaving most of its length bare, is the sign of an artifact. A pileup running the full length of the contig at a steady depth supports it.

## On the command line

This section is optional. The window steps above already did this work, and nothing here unlocks a result the dialog cannot produce. It is here for readers who want to script a run or repeat one on a server. The whole procedure runs headless, meaning with no app window at all, by typing commands into the Terminal application. [The CLI Reference](../appendices/cli-reference.md) covers installing `lungfish-cli` and opening a terminal. In the examples below, `/path/to/nvd-demo` stands for wherever you saved the fixture folder, and you type your own path in its place.

Both of these commands were run against the demo results on 2026-09-07 with `lungfish-cli` from the 2026.9.13 build, and the output quoted below is what they printed.

Inspect a run before importing anything with `nvd summary`, which takes either the run directory or a single `*_blast_concatenated.csv(.gz)` file:

```bash
lungfish-cli nvd summary /path/to/nvd-demo/results --top 20
```

```text
NVD Results Summary

Experiment      : 100
Source          : demo_blast_concatenated.csv
Total BLAST hits: 10
Samples         : 3
Unique contigs  : 4

Top Contigs (Best BLAST Hits)

Sample   Contig                      Len  Organism                  %ID    Score  Reads
───────────────────────────────────────────────────────────────────────────────────────
SampleA  NODE_1_length_500_cov_10.0  500  SARS-CoV-2                99.5%  920.0  50
SampleA  NODE_2_length_300_cov_5.0   300  HIV-1                     96.0%  750.0  20
SampleB  NODE_1_length_400_cov_8.0   400  Human gammaherpesvirus 4  99.0%  750.0  100
SampleC  NODE_5_length_200_cov_2.0   200  Norovirus GII             97.5%  380.0  10
```

`--top` sets how many contigs the table lists and defaults to 20, which is why the example above prints every one of the fixture's four contigs. Passing `--top 2` would cut the table to the two longest. Adding `--format tsv` or `--format json` emits the same summary as a machine-readable file instead of the block above, TSV being a plain text table with tab characters between the fields and JSON being a structured text format that programs read easily.

The TSV form's columns carry the pipeline's own raw names rather than the window's display names.

| TSV column | Column in the window |
|---|---|
| `sample_id` | Sample |
| `qseqid` | Contig |
| `qlen` | Length |
| `adjusted_taxid_name` | Classification |
| `sseqid` | Accession |
| `pident` | Identity % |
| `evalue` | E-value |
| `bitscore` | Bit Score |
| `mapped_reads` | Mapped Reads |
| `rpb` | RPB |

Import the run with `import nvd`, pointing `--output-dir` at the project's `Analyses` folder so the bundle lands where the app looks for it:

```bash
lungfish-cli import nvd /path/to/nvd-demo/results \
  --output-dir "/path/to/My Project.lungfish/Analyses"
```

The command prints its progress a step at a time and finishes by reporting the same three counts the preview showed, ending with `✓ NVD import complete: nvd-100`. The command `lungfish-cli nvd import` is a second spelling of the same operation and takes the same argument, the same `--name`, and the same `--output-dir`.

Extracting the reads behind a contig is its own command, and it takes the imported result folder rather than the original run:

```bash
lungfish-cli extract reads --by-classifier --tool nvd \
  --result "/path/to/My Project.lungfish/Analyses/nvd-100" \
  --sample SampleA --accession NODE_1_length_500_cov_10.0 \
  --output sampleA-contig1.fastq
```

`--sample` names the sample and `--accession` names the contig, and both repeat if you want several. `--read-format fasta` writes FASTA instead of FASTQ, and `--bundle` wraps the output as a `.lungfishfastq` bundle, meaning the reads are kept together with a record of where they came from rather than left as a loose file. This route sends the request through the same resolver the viewport's Extract FASTQ button uses, so the button and the command produce the same file for the same selection.

Extraction reads the alignment file the NVD run produced, so it fails on a result imported without one. Run against the demo results the command stops with an error rather than writing a file, reporting `No BAM file found for sample 'SampleA'. The classifier result may be corrupted or imported without the underlying alignment data.` and finishing with an exit status of 1, which is the terminal's way of saying the command reported a failure. That is the expected behaviour for a BLAST-table-only fixture rather than a fault.

## Troubleshooting

Three failure states show up in this chapter, and each has one cause worth checking first.

- The import preview shows a warning instead of counts. You picked a subfolder rather than the run directory, so point Browse... at the folder holding `05_labkey_bundling/`.
- The Run button stays greyed out. The scan has not finished or found no hits, so wait for the preview to fill and read the warning if one appeared.
- The detail pane reads "No BAM data available." and read extraction fails. The run shipped no alignment files, so read-level steps are unavailable for that result.

## Next

Continue to [BLAST Verification](06-blast-verification.md) for reading the matches a verification returns. For the other import-only classification paths, see [Importing CZ ID Results](08-importing-cz-id-results.md) and [Importing NAO-MGS Results](05-running-nao-mgs.md), or return to [What Is Read Classification](01-what-is-classification.md) to compare NVD against the classifiers LGE runs itself.
