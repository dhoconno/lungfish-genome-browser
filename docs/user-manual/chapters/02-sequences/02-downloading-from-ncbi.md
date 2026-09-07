---
title: Downloading from NCBI
chapter_id: 02-sequences/02-downloading-from-ncbi
audience: bench-scientist
prereqs: [01-foundations/06-the-lungfish-project, 02-sequences/01-importing-and-viewing]
estimated_reading_min: 14
task: Search a public sequence database by accession and download the record into the project as a reference bundle.
tags: [sequences, ncbi, download, fasta, gff3, genbank, accession, pathoplexus, sra]
tools: []
parameters_refs: [fetch.ncbi, fetch.pathoplexus]
entry_points:
  - Tools > Search Online Databases > Search NCBI...
  - Tools > Search Online Databases > Search SRA...
  - Tools > Search Online Databases > Search Pathoplexus...
  - "CLI: lungfish-cli fetch ncbi <accession>"
  - "CLI: lungfish-cli fetch search <query>"
  - "CLI: lungfish-cli fetch genome <accession>"
shots:
  - id: ncbi-search-dialog
    caption: "The database search dialog on its GenBank & Genomes pane, with the Mode picker on Nucleotide, the RefSeq Only and Include GFF3 Annotations checkboxes below it, and the accession typed into the query field."
  - id: ncbi-advanced-filters
    caption: "The Advanced Search Filters panel expanded under the query field, showing the Organism, Location, Gene, Author, and Journal fields alongside the Molecule Type, Sequence Length, Publication Date, and Sequence Properties controls."
  - id: ncbi-results-download-selected
    caption: "The results list with the NC_012920.1 record ticked and the primary button reading Download Selected instead of Search."
  - id: ncbi-bundle-in-sidebar
    caption: "The downloaded NC_012920.1 reference bundle under the project's Downloads folder in the sidebar, open in the sequence viewport with its NCBI GFF3 Annotations track drawn above the bases."
  - id: pathoplexus-pane
    caption: "The Pathoplexus pane after the access and benefit sharing notice is accepted, showing the organism chips above the shared query field."
illustrations:
  - id: ncbi-accession-anatomy
    caption: "How an NCBI accession decomposes into prefix, number, and version, and which download path handles each kind."
glossary_refs: [accession, reference-bundle, reference-genome, gff, provenance, provenance-sidecar, checksum, insdc, pathoplexus, sra, ena, mitochondrial-genome, refseq]
features_refs: [fetch.ncbi, database.pathoplexus]
fixtures_refs: [human-mito]
brand_reviewed: true
lead_approved: true
---

## What it is

A public sequence database holds finished sequences that somebody else has already read, checked, and deposited. Each deposited sequence gets an [accession](../../GLOSSARY.md#accession), a permanent identifier that never points at anything else. The National Center for Biotechnology Information, usually written NCBI, runs the largest of these collections. Lungfish Genome Explorer (LGE) searches it from inside the app, so a sequence you need can go from a name in a paper to a working file in your project without a browser.

The record you are after is often a [reference genome](../../GLOSSARY.md#reference-genome), the fixed sequence every sample in a field is compared against. LGE reaches NCBI through **Tools > Search Online Databases > Search NCBI...**, which opens a database search dialog on its GenBank & Genomes pane. Type a query, run the search, tick a result, and download it. What lands is a [reference bundle](../../GLOSSARY.md#reference-bundle), a folder carrying the `.lungfishref` extension that holds the sequence, its indexes, and any annotations together. An index is a small lookup file that lets the app jump straight to a position in a sequence without reading everything before it. macOS shows the whole bundle as a single item, so you open it by double-clicking it the way you would open a file.

An annotation is a labelled feature drawn on a sequence, such as a gene or a protein-coding stretch. Many records carry a whole table of them. Leave the Include GFF3 Annotations checkbox on and LGE downloads that table too, converting it into a track attached to the bundle. [GFF](../../GLOSSARY.md#gff) is the plain-text format NCBI serves those features in, and GFF3 is version 3 of that format. Annotations matter downstream because a variant caller, the program that reports where your sample differs from the reference, can only say which protein a change falls in when it knows where the proteins are.

The same dialog reaches two other collections from its sidebar. SRA holds raw sequencing reads rather than finished sequences, where a read is one stretch of sequence produced by the sequencing machine, and [Pathoplexus](../../GLOSSARY.md#pathoplexus) holds pathogen submissions that may never have reached NCBI. Download an annotated record once, and every later chapter in this manual can point at the bundle you made here.

## Why you would do this

This chapter downloads the human mitochondrial genome, `NC_012920.1`. A [mitochondrial genome](../../GLOSSARY.md#mitochondrial-genome) is the small separate circle of DNA carried inside the mitochondrion, the compartment that makes a cell's chemical energy. The human one is 16,569 bases long against roughly 3.1 billion bases in the nuclear genome, which makes it about two hundred thousand times smaller and small enough that a download finishes before you have finished reading the results list.

That record is the revised Cambridge Reference Sequence, which is simply the standard name for this record, abbreviated rCRS. Every human mitochondrial study numbers its positions against it. The record is also densely annotated for its size. GenBank is one of the formats the same record comes in, and the GenBank version carries 77 features in total. Among them are 13 protein-coding sequences, 22 transfer RNA genes, and 2 ribosomal RNA genes, and the remaining features are of other types such as genes and the control region. A coding sequence is the translated stretch inside a gene, which is why a gene and a coding sequence can be counted separately at the same place. Almost every base of the molecule sits inside something labelled, so it shows what an annotation track is for more clearly than a longer, emptier record would.

The record's accession begins with `NC_`, which marks it as [RefSeq](../../GLOSSARY.md#refseq). NCBI staff choose RefSeq records and keep one reviewed record per sequence, unlike the ordinary submissions anyone may deposit. A record chosen that way does not change under you between the day the manual was written and the day you follow it, which is why this chapter can promise you exact numbers.

Download it once and it is yours to reuse. Later chapters map reads against it, extract regions from it, and call variants on it.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. This chapter uses the human mitochondrial genome fixture, but there is nothing to download first, because the chapter fetches the record live from NCBI. A fixture is the manual's own frozen copy of a dataset, kept so the numbers printed here can be checked. You can read this one's notes in the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/human-mito.

You also need a working internet connection, since every step here talks to a public server. Nothing here needs a plugin pack or Docker Desktop, which are optional installs covered in a later chapter. The download runs in the app, and the bundle build uses the samtools tooling LGE ships with, so there is nothing for you to install.

One habit is worth forming before you start. Type the version suffix, the `.1` in `NC_012920.1`, every time. Curators revise deposited sequences and the version number ticks up when they do, so a bare accession can quietly give you a different sequence than a colleague got last year.

## Procedure

1. Choose **Tools > Search Online Databases > Search NCBI...**. The database search dialog opens on its GenBank & Genomes pane. Leave **Mode** on Nucleotide, which is the collection of single records and holds this one, and leave **Include GFF3 Annotations** checked. Both are the defaults.

    <!-- SHOT: ncbi-search-dialog -->

2. Type `NC_012920.1` into the query field and click Search. A search on a full accession returns one result, or a small handful when related records share the identifier. The Advanced Search Filters panel below the field stays collapsed until you click Show, and you do not need it when you already hold the accession. The screenshot below shows that panel opened, for reference only.

    <!-- SHOT: ncbi-advanced-filters -->

3. Tick the matching record in the results list. The primary button changes from Search to Download Selected.

    <!-- SHOT: ncbi-results-download-selected -->

4. Click Download Selected. LGE fetches the record, fetches its annotations, and assembles the `.lungfishref` bundle in one action, reporting each stage in the Download Center rather than in the Operations Panel.

5. Find the finished bundle in the sidebar under `Downloads/`, which is a folder inside your project and not the system Downloads folder, and open it. The sequence fills the viewport and the annotation features draw above the bases.

    <!-- SHOT: ncbi-bundle-in-sidebar -->

There is no separate import step. The download builds the bundle, so no loose `.gb` file waits for you to do anything with it afterwards. Two behaviours are worth knowing before you download in bulk. Ticking more than fifty records raises a confirmation with Download All and Cancel, so nothing large starts by accident, and a single record never raises it. Turning **Include GFF3 Annotations** off skips the GFF3 fetch but never skips the bundle itself, and when the record carries a FEATURES table, as this one does, LGE still builds a track from that table instead.

## Settings

The controls below belong to two panes of the same dialog, and four labels appear twice because the Pathoplexus pane repeats them on filters of its own. The first group is the GenBank & Genomes pane, reached by **Tools > Search Online Databases > Search NCBI...**, and it runs from **Mode** through **Annotated Only**. Five of those, from **Host** through **Annotated Only**, appear only when **Mode** is set to Virus. The second group starts at the **Organism** paragraph that describes the chip row, and everything from there on belongs to the Pathoplexus pane, which the section on Pathoplexus later in this chapter says when to open. Each paragraph names which pane its control sits on wherever the label is one of the repeated four. The query field and its scope popup are shared between the panes, which is why the scope setting is documented once.

Every entry ends by saying whether the setting reaches the command line. If you work only in the dialog, those last sentences are safe to skip.

**Mode.** Chooses which NCBI collection is searched, since Nucleotide returns individual GenBank records, Genome returns whole assemblies, and Virus reaches NCBI's separate virus collection with filters of its own. An assembly is all of an organism's chromosomes put together, as against the single molecule a Nucleotide record holds. The default is Nucleotide, which is the collection that holds single-molecule records like the mitochondrial genome this chapter downloads. Switch to Genome for a whole assembly such as a human or macaque reference, and to Virus for a curated viral record set. On the command line this is `--db`.

**RefSeq Only.** Filters a search down to RefSeq records, the reviewed subset NCBI staff maintain, instead of every submitted GenBank entry. The default is off, so a search returns everything deposited. Most of the time you want it on, since it gives you one canonical sequence per organism rather than every deposited variation of it. Leave it off when you are looking for one particular submitter's sequence, which will not be in RefSeq. This setting has no command-line flag.

**Include GFF3 Annotations.** Downloads the record's gene and feature annotations alongside its sequence and attaches them to the bundle as a track. The default is on, because a bundle with annotations works everywhere a bundle without them works, and without them nothing downstream can tell you which protein change a mutation causes. Turn it off when you only need the raw sequence, which makes the download smaller and faster while still producing a bundle. On the command line the nearest equivalent is `--fasta-only` on `fetch genome`, which skips both the annotations and the bundle.

**(search scope).** Restricts the query text to one indexed field rather than matching anywhere in the record, through the unlabelled popup at the right-hand end of the query field. The default is All Fields, which is the right setting when you do not yet know which part of a record your search word sits in. Narrow it to Accession when you already hold the identifier, so a common word in some other record's title cannot swamp the results. This setting has no command-line flag.

**Organism.** On the GenBank & Genomes pane this text field adds an organism term to the query, so only records from that species or group come back. The default is empty, since most searches start from an accession or a title rather than from a species. Fill it when a query word such as a gene name occurs across many species. On the command line this is `--organism` on `fetch search`.

**Location.** Adds a geographic term to the query, matching where the sample was collected. The default is empty, because most records are not sought by collection site. Fill it when you are assembling a regional sequence set. This setting has no command-line flag.

**Gene.** Adds a gene term to the query, so only records annotated with that gene come back. The default is empty, which lets a search return whole genomes and single loci together. Fill it when you want one locus rather than whole genomes. This setting has no command-line flag.

**Author.** Adds an author term to the query, matching the people credited on the submission. The default is empty, since a record's authors are rarely how you find it. Fill it when you are chasing the sequences behind a particular paper. This setting has no command-line flag.

**Journal.** Adds a journal term to the query, matching where the record was published. The default is empty, for the same reason the author field is. Fill it alongside **Author** to pin down one publication. This setting has no command-line flag.

**Molecule Type.** Restricts results to records of one molecule type, which separates a genomic sequence from a transcript of the same gene. A transcript is the RNA copy a cell makes from a gene, with the non-coding pieces spliced out. The default is Any, so nothing is excluded before you have looked at what came back. Set it to mRNA when you want the spliced transcript, or to Genomic DNA when you want the locus itself with its introns intact. This setting has no command-line flag.

**Sequence Length.** On the GenBank & Genomes pane this pair of fields keeps only records whose sequence falls between the two lengths you enter, measured in bases. Both sides start empty, so no length filter applies until you type one. Set a minimum to drop short partial fragments from a query that returns thousands of them, for example a minimum of 16000 to keep only complete human mitochondrial genomes and drop the partial ones. This setting has no command-line flag.

**Publication Date.** Keeps only records published inside the range you enter. Both sides start empty, so the whole history of the database is in scope. Set a start date to exclude older records that have been superseded. This setting has no command-line flag.

**Sequence Properties.** Keeps only records that carry the annotation features you check, among Has CDS, Has Gene, Has Source, Has tRNA, and Has rRNA, where CDS is a coding sequence and Source is the record's own description of the sample it came from, and the checks combine with AND so a record must carry every property you tick. Nothing is checked by default, which keeps unannotated records in the results. Check Has CDS when you need coding regions and a bare sequence is no use to you. This setting has no command-line flag.

**Host.** In Virus mode on the GenBank & Genomes pane, keeps only records whose sample came from that host organism. The default is empty, so isolates from every host come back together. Fill it to separate human isolates from animal ones in a query about a virus that crosses between species. This setting has no command-line flag.

**Geographic Location.** In Virus mode, keeps only records collected in that place. The default is empty, for the same reason the nucleotide Location field is. Fill it when you are building a regional viral sequence set. This setting has no command-line flag.

**Completeness.** In Virus mode, keeps only whole genomes or only partial ones. The default is Any, which returns both kinds mixed together. Set it to Complete when you are building an alignment and partial sequences would leave large gaps in it. This setting has no command-line flag.

**Released Since.** In Virus mode, keeps only records released on or after the date you type, written as year, month, and day. The default is empty, so the whole collection is in scope. Fill it when you are topping up a set you downloaded earlier. This setting has no command-line flag.

**Annotated Only.** In Virus mode, keeps only records that carry gene annotations. The default is off, so unannotated submissions still appear. Turn it on when the work downstream needs gene coordinates rather than sequence alone. This setting has no command-line flag.

The remaining settings are the Pathoplexus pane's, beginning with its own **Organism** control. Four of the labels repeat NCBI labels documented above, and on this pane they filter the Pathoplexus collection instead.

**Organism.** On the Pathoplexus pane this is the chip row above the query field, and it chooses which pathogen's records are searched. The default is Mpox virus, and Pathoplexus keeps one collection per organism, so changing the chip clears the results you were looking at. Change it whenever you move to a different pathogen, since there is no way to search across all of them at once. This setting has no command-line flag.

**Country.** Keeps only records whose sample was collected in that country. The default is empty, so every country's submissions come back together. Fill it when you are assembling a national or regional set. This setting has no command-line flag.

**Host.** On the Pathoplexus pane this text field keeps only records whose sample came from that host species. The default is empty, so samples from every host come back together. Fill it to separate human cases from animal reservoir samples, which is the usual reason a Pathoplexus set needs splitting. This setting has no command-line flag.

**Clade.** Keeps only records assigned to that clade, which is a named branch of the pathogen's family tree. The default is empty, so every branch is in scope. Fill it when one clade is the subject and the rest are background. This setting has no command-line flag.

**Lineage.** Keeps only records assigned to that lineage, which is a finer division than a clade. The default is empty, for the same reason **Clade** is. Fill it when you are following a specific descendant group inside a clade. This setting has no command-line flag.

**Nucleotide Mutations.** Keeps only records carrying every mutation you list, matched against the genome sequence and written as reference base, position, and new base, so a single entry looks like `C180T` and two entries look like `C180T, A200G`. The default is empty, so no mutation filter applies. Fill it when you are following one defining change through a population. This setting has no command-line flag.

**Amino Acid Mutations.** Keeps only records carrying every protein-level change you list, written as a gene name and a change joined by a colon, so a single entry looks like `GP:440G` and further entries are separated by commas. The default is empty, for the same reason the nucleotide field is. Fill it when the change of interest is in the protein rather than the nucleotide sequence, for example a known antibody-escape site. This setting has no command-line flag.

**Collection Date.** Keeps only records whose sample was collected inside the range you enter, which is the sampling date and not the date the record was published. Both sides start empty, so every collection date is in scope. Set it when you are reconstructing one season or one outbreak window. This setting has no command-line flag.

**Sequence Length.** On the Pathoplexus pane this pair of fields keeps only records whose sequence falls between the two lengths you enter, in base pairs. Both sides start empty, so no length filter applies until you type one. Set a minimum to drop fragments too short to be worth aligning, which on a viral genome usually means anything under about half the expected length. This setting has no command-line flag.

**INSDC Source.** Splits records by whether they also appear in the international sequence databases GenBank, ENA, and DDBJ, which together make up [INSDC](../../GLOSSARY.md#insdc). The default is Any, which mixes both kinds in the results. Set it to Non-INSDC Only when you want the records deposited to Pathoplexus alone, which are the ones no NCBI search could have found. This setting has no command-line flag.

## Reading the results

The bundle in the sidebar carries the accession as its name, so it appears as `NC_012920.1`. To look inside it, right-click the bundle in the sidebar and choose Show in Finder, then right-click it again in the Finder window that opens and choose Show Package Contents. A `manifest.json` sits at the root, a `genome/` folder holds the sequence as a compressed FASTA with its indexes, and an `annotations/` folder holds the feature track.

That track is a file named `ncbi_gff3_annotations.db`, and the app displays it as NCBI GFF3 Annotations. It is a SQLite database, a single file that stores a table, and it is internal to the bundle rather than something you are meant to open. LGE keeps every feature row the GFF3 gives it, applying no filter by feature type, so the whole of the annotation table the server sent survives the conversion. Nothing is dropped for being a transfer RNA rather than a coding sequence.

The name of the track is worth reading before you trust it, because it tells you which of two paths the download took. When the GFF3 fetch fails, LGE falls back to the feature table carried inside the GenBank record itself and writes `ncbi_genbank_annotations.db`, displayed as NCBI GenBank Annotations. Nothing warns you when that happens. A track under the second name still works everywhere the first one does, so nothing downstream breaks, but the two paths can label a feature differently. If you see the second name and you want the GFF3 track, delete the bundle and download the record again, since the fallback usually means the server was briefly unavailable.

The bundle records where it came from in its manifest. The `source` block names the database as NCBI, carries the accession, holds a source URL under `https://www.ncbi.nlm.nih.gov/nuccore/`, stamps the download date, and copies the record's own definition line. Select the bundle in the sidebar and the Inspector shows those fields.

The command-line fetch keeps a fuller record than the download does, in a [provenance sidecar](../../GLOSSARY.md#provenance-sidecar) written beside the file it saved. The rest of this section is reference material about what that file holds, and nothing in it is a step you need to take. Running the fetch shown at the end of this chapter produced `NC_012920.1.gb` at 64,640 bytes and `NC_012920.1.gb.lungfish-provenance.json` beside it. Inside that file the endpoint reads `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi`, the database reads `nucleotide`, `apiKeyProvided` reads false, `retryCount` reads 0 with an empty list of retry events, `exitStatus` reads 0, and `wallTimeSeconds` reads 0.61. The tool is named as `ncbi-efetch`.

Two fields there earn their keep. The [checksum](../../GLOSSARY.md#checksum) is a short fingerprint of the file's exact bytes, and for that run it reads `7530d659e7174272372814edfecb2ece1f87a444395a861fcdf1b977c4aa5c1f`. Nothing needs typing to see it, since the sidecar carries it already, and a different checksum on a later fetch of the same accession means the deposited record changed under you. The `reproducibleCommand` field holds the full command line, so the run can be repeated exactly without anyone remembering what was typed. The sidecar records only whether an API key was supplied, never the key itself.

## What good looks like

Four checks are worth running before you build anything on a downloaded reference.

Confirm the length. The viewport reports the sequence length, and for this record it is 16,569 bases exactly. Anything under 16,000 means a partial record was selected rather than the complete genome, and a number within a few dozen bases of 16,569 is a different mitochondrial record rather than a broken one.

Confirm the accession, including the version. The bundle name and the manifest's `source` block should both read `NC_012920.1`. If either reads something else, read the next section before going further.

Confirm the annotations are there and came from where you think. Features should draw above the bases, and the track should be named NCBI GFF3 Annotations. A track named NCBI GenBank Annotations means the fallback described above ran.

Confirm the folder. A downloaded bundle lands under the project's `Downloads/` folder, which is how a project distinguishes what came off the internet from what came off your own disk under `Imports/`. If a reference you expected to find there is missing, check the Download Center row for the download rather than searching the disk.

## When a download returns a different accession

The dialog you have just used is not affected by what follows, so if you work only in the dialog you can read the last paragraph and skip the rest. The command line has a trap in it that is worth knowing about, because the reference it produces looks entirely healthy.

`lungfish-cli fetch genome` handles two kinds of accession. An assembly accession, which begins `GCF_` or `GCA_`, names a whole assembled genome rather than one molecule, and `fetch genome` resolves it through NCBI's assembly database. Any other accession is fetched from the nucleotide database instead, which returns the exact record you asked for.

The trap is what happens when the two are crossed. Asking the assembly database for a nucleotide accession returns the linked assembly rather than the record you named, under a different sequence name, and nothing announces the substitution. A substituted reference gives every downstream coordinate a different meaning.

Check the accession on the bundle against the one you asked for, every time. That check is why the confirmation step sits in the list above.

![How an NCBI accession decomposes into prefix, number, and version](../../assets/illustrations-imagegen/02-sequences/02-downloading-from-ncbi/ncbi-accession-anatomy.png)

## Searching Pathoplexus

Pathoplexus is an open database for pathogen genome submissions, and LGE reaches it through **Tools > Search Online Databases > Search Pathoplexus...**, which opens the same dialog on its Pathoplexus pane. It is a viral collection by design, holding ten outbreak-relevant pathogens and nothing else. The chips read Mpox virus, Marburg virus, Measles virus, Sudan ebolavirus, Zaire ebolavirus, RSV-A, RSV-B, Human metapneumovirus, West Nile virus, and Crimean-Congo hemorrhagic fever, which is spelled the American way on screen. Some of them are segmented, meaning the genome is split across several separate molecules, and Crimean-Congo hemorrhagic fever splits into segments named `S`, `M`, and `L`, which LGE fetches one segment at a time.

Reach for it when a record has not reached NCBI, or when you want the metadata Pathoplexus carries that INSDC does not. On first use the pane shows an access and benefit sharing notice titled Pathoplexus Access and Benefit Sharing, and nothing else on the pane works until you click I Understand and Agree.

<!-- SHOT: pathoplexus-pane -->

Pick an organism chip before you do anything else. A download attempted with no organism selected stops with the message "Select a Pathoplexus organism". Ten filters narrow a Pathoplexus search, and the Settings section describes all of them. Nine sit in the shared Advanced Search Filters panel below the query field, collapsed until you click Show, and the tenth is the scope popup on the query field itself. A record must match every filter you fill in, so each one you add narrows the results rather than widening them. LGE retrieves only records marked OPEN, a status the submitter sets when depositing, so sequences the submitter restricted never appear in the results.

What arrives is a `.lungfishref` bundle like any other. When a record carries an INSDC accession, LGE tries the GenBank path first and appends the Pathoplexus metadata to it. When that retrieval fails, or when the record has no INSDC accession at all, LGE builds the bundle from the Pathoplexus sequence directly. Either way, the bundle behaves exactly like the one this chapter's procedure produced. There is no command-line equivalent for Pathoplexus.

## Searching SRA

The second item in the same submenu is **Tools > Search Online Databases > Search SRA...**, and it opens the same dialog on its SRA Runs pane. [SRA](../../GLOSSARY.md#sra) is the Sequence Read Archive, and it holds raw sequencing reads rather than finished sequences. An SRA run accession looks like `SRR11140748`.

Reads are a different kind of object from the reference this chapter downloaded, so downloading them is covered in the reads chapter rather than here. Nothing extra needs installing to fetch them.

## On the command line

This section is optional. If you work entirely in the dialog you have just used, you can skip it.

The command below is the one this chapter's numbers came from. It fetches the same record in GenBank format and writes it, with its provenance sidecar, into the project's `Downloads/` folder.

```bash
lungfish-cli fetch ncbi NC_012920.1 \
  --fetch-format genbank \
  --save-to ./Downloads/NC_012920.1.gb
```

The backslash at the end of each line continues the command onto the next one, and you type it exactly as shown. `--fetch-format` picks what the server returns, among `genbank`, `fasta`, `gff3`, and `xml`, and it defaults to `genbank`. `--save-to` names the output file, and without it the record prints to the terminal. `--db` picks `nucleotide` or `protein`, defaulting to `nucleotide`. Several accessions can follow the subcommand in one call, and they all land in the one output file.

Two more flags matter for anything larger than a single record. An API key is a free identifier you can request from NCBI, and nothing in this chapter needs one. `--api-key` sends yours so the service allows a higher request rate, and `NCBI_API_KEY` in the environment does the same thing without putting the key in your shell history. `--no-retry` stops the command retrying after NCBI answers with a rate-limit response, which is what a script wants when it would rather fail immediately than wait.

To build a bundle rather than save a file, use `fetch genome`, which downloads the FASTA and the GFF3 and assembles the indexed `.lungfishref` for you.

```bash
lungfish-cli fetch genome NC_012920.1 --output-dir ./Downloads
```

`--output-dir` sets the destination and defaults to the current directory. `--name` sets the bundle name, which is otherwise derived from the assembly. `--fasta-only` saves just the decompressed FASTA, skipping the annotations and the bundle both, while `--no-bundle` keeps the annotations and stops short of assembling them. `--api-key` works here too. Read the section above on accession substitution before pointing this command at anything other than the accession you want back.

When you do not yet hold an accession, `fetch search` runs a query and lists what matches.

```bash
lungfish-cli fetch search "mitochondrion complete genome" --organism human --limit 5
```

`--limit` caps the number of results and defaults to 20. `--organism` filters by species. `--db` accepts `nucleotide`, `genome`, and `protein` here. That last one is a collection the dialog's Mode picker does not offer, so a protein search is only reachable from the command line. The European Nucleotide Archive is reachable directly too, through `fetch ena search`, `fetch ena fasta`, and `fetch ena reads`, which helps when ENA holds something NCBI has not mirrored.

## Next

Continue to [Extracting and Comparing Sequences](03-extracting-and-comparing.md) to cut a region out of the reference you just downloaded.
