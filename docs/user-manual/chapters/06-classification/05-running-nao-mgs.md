---
title: Importing NAO-MGS Results
chapter_id: 06-classification/05-running-nao-mgs
audience: analyst
prereqs: [06-classification/01-what-is-classification]
estimated_reading_min: 26
task: Import externally produced NAO-MGS wastewater-surveillance results and read the taxon viewport.
tags: [classification, nao-mgs, wastewater, surveillance, import]
tools: [nao-mgs]
parameters_refs: [import.nao-mgs]
entry_points:
  - "File > Import Center... > Classification Results > NAO-MGS Results"
  - "CLI: lungfish-cli import nao-mgs <input-path>"
  - "CLI: lungfish-cli nao-mgs summary <input-path>"
shots:
  - id: nao-mgs-import-card
    caption: "The Import Center's Classification Results tab, showing the NAO-MGS Results card with the file hint reading virus_hits_final.tsv.gz or _virus_hits.tsv.gz."
  - id: nao-mgs-import-sheet
    caption: "The NAO-MGS Import sheet after a file is chosen, showing the read-only path readout beside the Browse... button and the Validation section reporting Valid NAO-MGS results with the source file name."
  - id: nao-mgs-result-viewport
    caption: "The NAO-MGS viewport on the imported wastewater fixture, showing the Samples and Taxa summary cards along the top, the sample-filter button reading All Samples above the taxon table, the table's Sample, Taxon, Hits, Unique Reads, and Refs columns, and the overview bar chart filling the detail pane."
  - id: nao-mgs-taxon-detail
    caption: "The detail pane after a taxon row is selected, showing the taxon name header, the Taxid line with its unique-of-total read counts and accession count, and the miniBAM Panels section with one read-pileup panel per top accession."
illustrations: []
glossary_refs: [accession, bam, bit-score, blast, fastq, metagenomics, minibam, nao-mgs, operations-panel, paired-end, pcr-duplicate, percent-identity, provenance, read, taxon, taxonomy-id]
features_refs: []
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

## What it is

This chapter is about reading a file somebody else made. You do not run anything to produce it, and Lungfish Genome Explorer (LGE) cannot produce it either.

[NAO-MGS](../../GLOSSARY.md#nao-mgs) is the name of a [metagenomic](../../GLOSSARY.md#metagenomics) surveillance pipeline built by SecureBio, a nonprofit research organisation working on biosecurity. A pipeline is a fixed chain of programs run one after another on the same data. LGE uses the pipeline's own name and does not expand the letters, so treat NAO-MGS as a proper name for a metagenomic sequencing pipeline whose output LGE imports. Metagenomics means sequencing all the nucleic acid in a mixed sample at once rather than culturing one organism first, and surveillance here means running that sequencing repeatedly on samples from a population so that a new pathogen shows up as a signal before anyone reports a case.

The pipeline runs on a computing cluster, meaning a shared bank of many computers, or in the cloud, and it is run by whoever operates it rather than by you. It compares every [read](../../GLOSSARY.md#read) against a reference collection, which is the fixed set of viral genomes the pipeline searches against. A read is one fragment of sequence the instrument reported, a few hundred bases long. Comparing means aligning each read against those genomes and scoring how well it fits. The pipeline's main output is a table with one row per matching read, not one row per virus.

What LGE does is import that finished output and give it a viewport. A viewport is the panel inside the app that displays one result. The import folds the pipeline's per-read table into a per-taxon table you can sort, attaches the read evidence behind each taxon, and stores the whole thing so you can come back to it. A [taxon](../../GLOSSARY.md#taxon) is any named group on the tree of life, so a species, a genus, or a family each count as one.

The file LGE reads is `virus_hits_final.tsv.gz`, the pipeline's combined virus-hit table. The `.tsv` part means a plain text table with tab characters between the columns, and the `.gz` part means that text file has been compressed with gzip to make it smaller. The pipeline also writes one file per sample, named `_virus_hits.tsv.gz`, and the importer accepts those too. Point the importer at the results folder and it finds the table for you, or point it at the table itself and it reads that. Nothing else from the pipeline output has to be prepared first.

Because NAO-MGS screens for viruses, this chapter's example is a viral one, unlike most of the manual's examples. The pipeline reports viral taxa and nothing else, so a wastewater sample's bacteria never appear in the table whatever their abundance.

When a colleague or a scheduled cluster job produces NAO-MGS output, import the virus-hits table into your project and read it in the viewport rather than opening the raw table in a spreadsheet.

## Why you would do this

The raw `virus_hits_final.tsv.gz` is organised per read rather than per organism, and that is the wrong arrangement for the question you actually have. The table runs thirty columns wide with one row per matching read, split across every sample the run covered. Each row holds one read's alignment against one viral reference, along with the full read sequence and quality string.

Three of those columns describe the quality of the match. The [bit score](../../GLOSSARY.md#bit-score) is a length-aware measure of alignment strength, where a higher number means a better match and the scale stays comparable between different searches. The edit distance is the count of single-base changes needed to turn the read into the stretch of reference it matched, so a lower number means a closer match. The reference position is where along that reference genome the read landed, counted in bases from one end.

Reading the table directly means totalling it up by taxon and by sample yourself before you can say anything at all. The question you have is which viruses drew reads, in which samples, and whether the reads behind any one of them look convincing. The import answers the first two by totalling for you, and it answers the third by keeping the reads.

A surveillance signal is only worth acting on if the reads under it are real, and a per-taxon count on its own cannot tell you that. Sample preparation copies fragments many times over in a step called [PCR](../../GLOSSARY.md#pcr-duplicate), and those copies are called PCR duplicates. Ten reads that are ten copies of one such fragment and ten reads from ten independent fragments produce the same count and mean entirely different things. The viewport therefore reports unique reads beside total hits, and it lets you open the read pileups underneath a taxon and look.

The second reason is that the import puts the surveillance result in the same project as everything else. The same [BLAST](../../GLOSSARY.md#blast) verification and the same read extraction you use for the classifiers LGE runs itself, such as Kraken 2 in [Running Kraken 2](02-running-kraken2.md), work on an imported NAO-MGS result. A candidate signal can then be investigated without leaving the window or writing your own analysis code.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. A name written as Cmd-N is a keyboard shortcut, meaning hold the Command key and press N.

This chapter uses the file `Tests/Fixtures/naomgs/virus_hits_final.tsv.gz`, a small five-site wastewater run kept in the repository for testing. It is one combined table covering all five sites rather than five separate files. GitHub offers no download for a single folder, so open the repository's front page at https://github.com/dhoconno/lungfish-genome-explorer, click the green **Code** button, choose **Download ZIP**, double-click the downloaded file to unpack it, and find the file inside it under `Tests/Fixtures/naomgs/`. Remember where you saved it.

In normal work this file arrives from a collaborator or a computing core rather than from a download, because the pipeline that writes it runs outside LGE.

Nothing needs installing for this import.

## Procedure

### 1. Open the NAO-MGS Results card

Choose **File > Import Center...**, then click the **Classification Results** tab. LGE routes every import through this one window rather than through a plain file-open dialog, so there is no **File > Import** item to look for. The Import Center is a tabbed grid of cards, one card per kind of thing LGE can bring into a project, and a file can also be dragged straight onto a card.

The **NAO-MGS Results** card carries a small two-letter tag reading NM, which stands for the pipeline's name and marks the card in the grid. Its file hint reads `virus_hits_final.tsv.gz or _virus_hits.tsv.gz`. Click it.

<!-- SHOT: nao-mgs-import-card -->

### 2. Choose the results and check the validation

The card opens a sheet titled **NAO-MGS Import**. It holds no settings at all, only a source picker and a validation readout, so there is nothing to configure before you commit. The three settings named in the Settings section below exist on the command line only.

Click **Browse...** and select either the pipeline output folder or the table itself, which is `virus_hits_final.tsv` or the compressed `virus_hits_final.tsv.gz`. Prefer the folder, since the importer then finds the right file for you. The caption under the button says the same thing. The chosen path appears in the read-only readout beside the button, shortened with dots in the middle when it is long.

The **Validation** section then checks the file's header, meaning its first line of column names. When that header matches the shape of an NAO-MGS virus-hits table, the section shows a green tick beside **Valid NAO-MGS results** and names the source file underneath. When the run wrote one file per sequencing lane rather than one combined table, it also reports how many files it found, on a row labelled **Files found**. A lane is one physical channel on the sequencer, and a run often uses several. Any count above zero there is normal, the number is informational only, and the importer handles the multi-file case with nothing extra from you. When the header does not match, the section shows a warning triangle and the reason instead, and the fix is to point it at the right file.

<!-- SHOT: nao-mgs-import-sheet -->

### 3. Import and open the result

Click **Run**. LGE partitions the table by sample, imports each sample in turn, merges the per-sample databases, and then resolves the numeric taxonomy identifiers into organism names by looking them up at NCBI, the US National Center for Biotechnology Information, which runs GenBank and the taxonomy database this step queries.

A [taxonomy identifier](../../GLOSSARY.md#taxonomy-id) is the number NCBI assigns to one taxon, so `28875` is the identifier for Rotavirus A. Progress runs in the [Operations Panel](../../GLOSSARY.md#operations-panel), which you can open with **Operations > Show Operations Panel** (Cmd-Shift-P) to watch the phases go by.

The Import Center writes the finished bundle under the project's `Analyses` folder, where the sidebar shows it. The bundle is named `naomgs-` followed by the sample name when one is given, and by the input file's name otherwise, so on this fixture it comes out as `naomgs-virus_hits_final`. On the fixture the import reported 35 hits across 4 distinct taxa. A count in the tens is what a small run like this one produces, and a larger run over more sites produces more, so read the number against the size of the run rather than against a fixed scale. Double-click the result to open the NAO-MGS viewport.

The result is not a copy of the table. It is a folder holding a database of the per-taxon and per-accession summaries, a `manifest.json` summary, an alignment file per sample under `bams/`, and a [provenance](../../GLOSSARY.md#provenance) record. That database is in SQLite format, a small self-contained database format, and storing the summaries that way is what lets the viewport sort a large run and jump to one taxon's reads without re-reading the whole table. The alignment files are [BAMs](../../GLOSSARY.md#bam), the indexed binary format for read placements, rebuilt from the sequences the pipeline's table carried.

## Settings

The NAO-MGS Import sheet has no settings. Its **Browse...** button, path readout, Validation section, and the **Cancel** and **Run** buttons are the whole surface, and none of them changes what the import produces. The three settings below exist on the command line only, with no equivalent anywhere in the window. A reader working only in the window can skip them.

**Sample name.** Overrides the sample label recorded on the imported bundle, which is the label the viewport's summary is built from. It defaults to the first sample in alphabetical order, taken from the table itself, which on this fixture is one site's long instrument-style identifier. Set it when the pipeline's own sample identifier is not the label you want to read six months from now. On the command line this is `--sample-name`.

**Fetch references.** Downloads a reference FASTA from NCBI for each accession the results name and stores it in the result's `references/` folder, so the reference sequence each read matched sits beside the reads themselves. FASTA is the plain-text format that stores sequence with no quality scores, unlike FASTQ, which stores both. Reference fetching is on by default, because having the references locally is what lets later steps compare a read against what it matched without going back to the network. Turn it off when you are working offline, when the run names many hundreds of accessions and you do not want the download, or when you only need the taxon counts. On the command line this is `--no-fetch-references`, which turns the fetching off rather than on.

**Output directory.** Names the folder the imported bundle is written into. It defaults to the current directory, meaning the folder the terminal is pointed at when you press Return, which is almost never what you want, so pass it on every real run. Point it at the project's own `Analyses` folder, because the command line writes the bundle directly into whatever folder you name and does not add an `Analyses` step for you. Your project folder is the one ending in `.lungfish` that New Project created. On the command line this is `--output-dir`, or `-o`.

## Reading the results

The viewport is a split view. A summary bar runs along the top, the taxon table fills the right side, the detail pane fills the left side, and an action bar runs along the bottom.

<!-- SHOT: nao-mgs-result-viewport -->

### The summary bar and the sample filter

The summary bar holds two cards. **Samples** reports how many samples the result covers, or reads a count such as `2 of 5 samples` when you have filtered to a subset. **Taxa** counts the rows in the taxon table, which is one row per sample-and-taxon pair rather than one per organism. On the fixture the bar reads 5 samples and 7 taxa, those 7 rows covering 4 distinct organisms. The overview pane's **Unique Taxa** card counts the distinct organisms instead and reads 4, so the two cards on the same screen measure different things and the app gives no hint of that.

The sample selection sits in a single button above the taxon table. It reads **All Samples** when every sample is included and a count such as **2 of 5 Samples** when it is not. Click it to open the sample picker and choose which sites you want in view. Everything below reacts to that choice, including both summary cards, so narrowing to one site turns the whole viewport into that site's result.

### The taxon table

The table has five columns. **Sample** names the sample the row belongs to, so one taxon found in three sites occupies three rows rather than one. **Taxon** is the organism name resolved from the taxonomy identifier, falling back to `Taxid N` when the lookup found no name, which means NCBI returned no name for that number and not that anything is broken. The row is still usable. **Hits** is the number of read-to-reference alignments assigned to that taxon in that sample, so one read matching two references counts twice. **Unique Reads** is how many distinct reads lie behind those hits. **Refs** is how many reference accessions the taxon's hits spread across, an [accession](../../GLOSSARY.md#accession) being the permanent identifier of one database record such as `KU048583.1`. A high Refs value means the reads matched many different records, which is normal for a virus with many deposited genomes, and a low one means they concentrated on a few.

Click a column header to sort by it, and right-click a header to open a menu listing that column's values with a tick beside each. Untick a value to hide its rows, and tick it again to bring them back. Hits is the usual first sort, because it brings the strongest signals to the top. If you have loaded per-sample metadata through the Inspector, which is the panel down the right-hand side of the window and opens with **View > Show Inspector** (Cmd-Opt-I), its **Import Metadata...** button takes a `.tsv`, `.csv`, or `.txt` file of rows keyed by sample, and those fields arrive as extra columns that sort and filter like any other.

The pairing worth reading carefully is Hits against Unique Reads. On the fixture, the IL_CHI_StickneyWS site's Rotavirus A row shows 12 hits from 8 unique reads, which the bundle's `manifest.json` records, so 4 of the 12 hits are duplicate copies rather than independent observations. The CA_LosAngeles_County site's row for the same organism shows 28 hits from 26 unique reads, which is 93 percent independent against the other site's 67 percent. Compare those proportions rather than the raw counts. When Unique Reads falls well below Hits, the taxon is leaning on a small number of fragments that PCR copied, and the honest count is the unique one.

### The detail pane

With no taxon selected, the detail pane shows an overview of the whole result. It opens with a **Total Hits** card, a **Unique Taxa** card, and a third card that names the sample when one sample is in view and counts them otherwise, then draws a **Top Taxa by Read Count** bar chart of the top fifteen taxa. When the result holds fewer than fifteen, as this fixture's 4 organisms do, the chart shows all of them. Each bar is clickable and selects that taxon in the table, so the chart works as a shortcut into the strongest rows. Surveillance trends need several imports compared side by side, because one import is one run and this chart plots that one run only.

Select a taxon and the pane switches to that taxon's evidence. A header gives the organism name, and a line under it reads `Taxid: N`, then the unique-of-total read counts, then the accession count. For the CA_LosAngeles_County Rotavirus A row discussed above, that line reads `Taxid: 28875  •  26 unique / 28 total reads  •  7 accessions`, the same 26 and 28 the table showed for that row.

Below that sits a **miniBAM Panels** section, whose heading names how many accessions are shown out of how many exist. That Rotavirus A row has 7 accessions and the cap is 5, so its heading reads `miniBAM Panels (Top 5: 5 of 7 accessions)`. A taxon with 3 accessions reads `miniBAM Panels (All: 3 of 3 accessions)` instead. The cap is fixed at 5 and there is no setting for it.

A [miniBAM](../../GLOSSARY.md#minibam) panel is a compact read-pileup view. It draws the reference along the top with a depth curve above it, then stacks the individual reads underneath at the positions where they matched, colouring the bases that disagree with the reference. The panels are ordered by total hit count, so the reference with the most reads comes first. The note above them says unique read count, which is a mislabel in the app. Each panel has a resize handle along its bottom edge, and dragging that edge downward makes the panel taller when the reads are crowded.

<!-- SHOT: nao-mgs-taxon-detail -->

Each accession above its panel is a clickable link to that record at GenBank, NCBI's sequence database, and right-clicking it offers to open the record or copy the accession.

### The action bar

Three buttons and an information button run along the bottom.

**BLAST Verify** submits a subset of the selected taxon's reads to NCBI BLAST, 20 reads by default, and reports back whether NCBI agrees with the name on the row. It behaves exactly as it does for the classifiers LGE runs itself. [BLAST Verification](06-blast-verification.md) covers how to read the verdict.

**Export** writes the taxon table as it currently stands to a `.tsv` file, suggested as `<sample>_naomgs_summary.tsv`. It exports the displayed rows, so your sample filter, column filters, sort order, and any metadata columns all carry through, and the export records those choices in its own provenance sidecar, a small companion file written beside the export.

**Extract FASTQ** pulls out the reads behind the taxon rows you have selected in the table, as a [FASTQ](../../GLOSSARY.md#fastq) file, the plain-text format that stores each read beside its quality scores. Select a row first, since with nothing selected there is no taxon to pull reads for. That is the route to taking a candidate signal to an assembler, to another classifier, or to a manual BLAST.

The information button at the right end opens the provenance record, which names the source file path, the import command, and the input checksums. That record is what a methods section cites, so the review you do in this viewport stays auditable back to the external run that produced the data.

Right-clicking a taxon row offers BLAST verification and **Extract Reads...**, plus **Copy Taxon ID**, **Copy Top Accessions**, **View on NCBI**, **View Taxonomy on NCBI**, and **Search PubMed**, which opens a literature search for the organism name. Export is not on that menu, so use the action bar button for it.

## What good looks like

Read Unique Reads before you read Hits. A taxon whose two columns are close is supported by that many independent fragments, and a taxon whose unique count is a fraction of its hit count is supported by far less than the hit count suggests. As a rule of thumb, a row whose unique count is under half its hit count deserves the read pileups opened before you quote the number. The app enforces nothing here, so the judgement is yours, and the fixture's two Rotavirus A rows both sit above that line at 67 and 93 percent unique.

Then check whether the taxon appears in more than one sample. A surveillance run's real value is comparison across sites. One organism found in several independent samples is a stronger observation than the same number of reads found in a single sample. Sort by Taxon rather than Hits to see this, since the table keeps one row per sample and the rows for one organism then sit together. A row whose name failed to resolve sorts under its `Taxid N` text instead, so those rows group among themselves rather than with the named ones.

Then open the miniBAM panels and look at where the reads sat. Reads spread along the reference are what a genuine presence looks like, and a rough guide is that reads should touch several separated parts of the genome rather than one. Reads stacked on one short stretch are what a conserved region looks like, a conserved region being a piece of sequence that changes little between related species and so is shared with the organism's relatives. That same stacking is also what a PCR amplification artifact looks like, and either way the name on the row is a weaker claim than the count suggests.

Then be careful about what the name proves and does not prove. NAO-MGS reports the nearest match in its reference collection, so a row reading Rotavirus A says the reads matched a Rotavirus A genome better than anything else the collection held. A row naming a broad group, such as an unclassified enterovirus or the fixture's `Cressdnaviricota sp.`, which is an unclassified member of a large viral phylum, is telling you the reads matched something in that group and that the pipeline could not narrow it further.

Then verify anything you intend to act on. A few reads suggest something to check, not a confirmed result. BLAST Verify settles most questions, though the wait depends on NCBI's queue, and extracting the reads lets you take the question elsewhere.

Finally, remember the boundary. An NAO-MGS result is a statement about viruses that the pipeline's reference collection contains. A virus absent from that collection cannot appear, and a bacterium cannot appear at all. Pair the result with a broad survey such as [Running Kraken 2](02-running-kraken2.md) when you need to know what else the sample held.

## On the command line

This section is optional. If you do your work in the LGE window, everything above is complete without it, and nothing here unlocks a result the Import Center cannot produce. It is here for readers who want to script an import, or to run one from a scheduled job that drops new pipeline output into a project. The whole procedure runs headless, meaning with no window at all, by typing commands into the Terminal application. [The CLI Reference](../appendices/cli-reference.md) covers installing `lungfish-cli` and opening a terminal.

The project import is the command that produces the bundle the app opens.

```bash
lungfish-cli import nao-mgs /path/to/virus_hits_final.tsv.gz \
  --output-dir "/path/to/My Project.lungfish/Analyses"
```

The input comes first with no flag in front of it, and it takes either the results folder or the table file. Name the project's `Analyses` folder in `--output-dir`, because the importer writes the bundle straight into the folder you give it and adds no `Analyses` step of its own. `--sample-name` overrides the derived sample label, and `--no-fetch-references` skips the NCBI reference downloads, which is the flag to reach for when you are offline or in a hurry.

The command prints its phases as it works, then a summary. On the fixture, imported with `--no-fetch-references`, it printed the sample label, then:

```text
Total hits        : 35
Distinct taxa     : 4
References fetched: 0
Output            : naomgs-virus_hits_final
```

A second command reads a virus-hits table without importing anything, which is the quick look to take before you commit a large run to a project.

```bash
lungfish-cli nao-mgs summary /path/to/virus_hits_final.tsv.gz --top 20
```

`--top` sets how many taxa the table prints and defaults to 20. The output names the sample, the total virus hits, the distinct taxa, and the source file, then prints a table of TaxID, Organism, Hits, Avg %ID, Avg Score, and Refs. Avg %ID is the mean [percent identity](../../GLOSSARY.md#percent-identity) of the taxon's alignments, meaning the fraction of aligned positions where read and reference agreed, and Avg Score is the mean bit score.

One defect is worth knowing before you rely on that summary. On a table covering several samples it reports only the first sample it meets, so on this fixture it printed one sample label, a total of 34 hits, and blank Organism cells. That 34 is confined to this command. It counts one sample's rows, while the project importer reading the same file found all five samples, all 35 hits, and every organism name, and the viewport's numbers come from the importer. Use `nao-mgs summary` for a shape check on a single-sample table, and use the project import for any count you intend to quote.

A third command writes a standalone JSON summary outside any project, which is the form to parse in a script.

```bash
lungfish-cli nao-mgs import /path/to/virus_hits_final.tsv.gz --output-dir ./summaries
```

It takes `--sample-name`, `--output-dir` (`-o`), and `--min-bitscore`, which drops hits below a bit-score floor. As a rough guide, bit scores on a read of a few hundred bases run from the low tens for a weak match into the hundreds for a strong one, and the floor defaults to 0, meaning no filtering.

Extracting one taxon's reads is its own command, and it takes the imported result folder rather than the original table.

```bash
lungfish-cli extract reads --by-classifier --tool naomgs \
  --result "/path/to/My Project.lungfish/Analyses/naomgs-virus_hits_final" \
  --sample MU-CASPER-2026-03-31-a-IL_CHI_StickneyWS_20260308 \
  --accession KU048583.1 \
  --output virus-reads.fastq
```

The `--sample` value is the pipeline's own sample identifier, copied from the Sample column of the viewport's taxon table, and you replace it with whichever identifier your own run uses. With `--tool naomgs` the selection is made by accession rather than by taxonomy identifier, and at least one `--accession` is required. Passing `--taxon` instead fails with `--tool naomgs requires at least one --accession`, because `--taxon` is accepted only for Kraken 2. `--sample` scopes the accessions that follow it, so a run covering many sites can be picked apart site by site. The command above extracted 4 reads. `--read-format fasta` drops the quality scores, `--include-unmapped-mates` also pulls the partner of any [pair](../../GLOSSARY.md#paired-end) where only one mate matched, and `--bundle` wraps the output as a `.lungfishfastq` bundle rather than a loose file.

The viewport's Extract FASTQ button uses this same classifier resolver and additionally narrows the reads to the taxon's own read names, so a command-line extraction of one accession can return more reads than the button does for the same taxon.

A fourth route, `extract reads --by-db`, always returns zero reads on an imported bundle, because the merge step drops the per-read rows and the command exits with `The extraction produced zero reads` whatever you ask it for. Use `--by-classifier`, which reads the alignment files the import wrote and works.

## Troubleshooting

Three failure states show up in this chapter, and each has one cause worth checking first.

- The Validation section shows a warning triangle instead of a green tick. The file's header does not match a virus-hits table, so point **Browse...** at the results folder or at the table itself.
- The Run button stays greyed out. Validation has not succeeded yet, so wait for it to finish and read the warning if one appeared.
- A taxon's name reads `Taxid N` rather than an organism. The NCBI lookup returned no name for that number, and the row's counts and reads are unaffected.

## Next

Continue to [BLAST Verification](06-blast-verification.md) to confirm a specific taxon against NCBI, or to [Novel Virus Diagnostics](09-novel-virus-detection.md) for the other surveillance import path.
