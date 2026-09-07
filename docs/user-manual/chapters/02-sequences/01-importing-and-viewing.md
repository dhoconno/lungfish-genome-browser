---
title: Importing and Viewing a Sequence
chapter_id: 02-sequences/01-importing-and-viewing
audience: bench-scientist
prereqs: [01-foundations/01-what-is-a-genome, 01-foundations/06-the-lungfish-project]
estimated_reading_min: 14
task: Import a sequence file into a project, attach a standalone annotation file to the bundle it makes, and read and move around the record in the sequence viewport.
tags: [sequences, import, fasta, genbank, viewport, annotations, hbb]
tools: []
parameters_refs: [import.reference, import.annotation-track]
entry_points:
  - File > Import Center... (Cmd-Shift-I)
  - Sequence > Go to Location... (Cmd-L)
  - Sequence > Go to Gene... (Cmd-Opt-G)
  - Sequence > Find ORFs...
  - CLI: lungfish-cli import fasta
shots:
  - id: import-center-reference-card
    caption: "The Import Center with the Reference Sequences tab open and the Reference Sequences card ready to accept a dropped file."
  - id: import-center-annotation-track-alert
    caption: "The Import Annotation Track alert, showing the Reference popup above the Track Name and Track ID fields."
  - id: hbb-record-in-sequence-viewport
    caption: "The imported HBB gene record open in the sequence viewport, with its annotation features drawn above the bases."
  - id: go-to-location-hbb-codon
    caption: "The Go to Location dialog holding the coordinate that frames the sickle cell codon in the HBB gene record."
  - id: hbb-annotation-context-menu
    caption: "The right-click menu on the HBB gene feature in the annotation lane, with the Copy submenu open."
  - id: translation-tool-hbb-cds
    caption: "The translation tool opened from the window toolbar, with its Mode, Genetic Code, and Color Scheme controls above the Apply button."
illustrations:
  - id: reference-bundle-anatomy
    caption: "Anatomy of a reference bundle on disk."
  - id: viewport-lanes
    brief: "A single sequence viewport drawn as three stacked drawing lanes rather than three separate panes. Top lane is the numbered position ruler with ticks at 70600, 70613, 70620. Middle lane is a run of DNA letters reading GAG at the marked position. Bottom lane is a row of coloured feature blocks of differing colours, labelled one colour per feature type. Use Lungfish Creamsicle for the ruler and the lead lines, Deep Ink for the letters and labels, IBM Plex Mono for the numbers and bases."
glossary_refs: [reference-bundle, bundle, contig-reference, annotation-track, import-center, sequence-viewport, sidebar, inspector, fasta, gff, cds, exon, codon, reading-frame, reverse-complement, genetic-code, open-reading-frame, refseqgene, provenance]
features_refs: []
fixtures_refs: [hbb-gene]
brand_reviewed: true
lead_approved: true
---

## What it is

Lungfish Genome Explorer (LGE) keeps every genome you work with inside a [reference bundle](../../GLOSSARY.md#reference-bundle), a folder carrying the `.lungfishref` extension that the Finder shows as one icon. Importing turns a loose sequence file on your disk into a bundle in the project's `Reference Sequences/` folder. Your original file stays where it was and is never altered, because the import copies rather than moves. The bundle holds a copy of the sequence, the indexes that let LGE jump to a position inside it, and, where the source format supports it, the features the file carried. An index is a small lookup table stored beside the sequence that records where each stretch of it begins, so the app can jump straight to base 70613 rather than reading the whole record from the start to get there.

A feature is a labelled stretch of the sequence with a start, an end, a strand, and a type such as `gene` or `CDS`. Strand means which of the two complementary DNA strands the feature is read from. Features arrive in the bundle as an [annotation track](../../GLOSSARY.md#annotation-track), which is one named set of features stored together and drawn as one layer. A bundle can hold several tracks at once, and each one keeps its own name.

The format of the file you import decides what you get. A [FASTA](../../GLOSSARY.md#fasta) file holds sequence and nothing else, so the bundle it makes has no features in it. A GenBank flatfile holds the sequence together with a table of features, so the bundle it makes arrives with a track already attached. A [GFF3](../../GLOSSARY.md#gff), GTF, or BED file is the opposite case. All three are plain-text formats that list features and carry no sequence at all, differing only in how many columns they spend on each feature, so none of them can make a bundle on its own. You attach one of those to a bundle that already exists, and LGE reads all three the same way.

Once a bundle exists, opening it loads the record into the [sequence viewport](../../GLOSSARY.md#sequence-viewport), the centre pane that draws a sequence along one horizontal axis. Every later operation in LGE, from mapping reads to calling variants, points at a bundle rather than at the loose file you started from. Import each genome once and then point everything downstream at the bundle.

## Why you would do this

Chapter 1 imported the HBB gene record and jumped to one codon in it. This chapter stays with that same record and works out the rest of the window around it, because a record you can only read at one coordinate is not much use. You do not have to have worked through chapter 1 first. Every step here starts from the downloaded file, so a reader arriving cold can follow the whole chapter from the Before you start section.

The HBB gene record is `NG_000007.3`, a [RefSeqGene](../../GLOSSARY.md#refseqgene) record covering the human beta-globin cluster on chromosome 11. A cluster is a run of related genes sitting next to each other on the chromosome, so this record holds the whole beta-globin family rather than the single HBB gene its name suggests. That is why it is 81,706 bases long and carries 102 annotation features rather than the handful one small gene would need. Eight of those features are genes, five are mRNAs, five are coding sequences, and thirteen are exons. An [exon](../../GLOSSARY.md#exon) is one of the pieces a coding sequence is split into. The remaining seventy-one are other GenBank feature types that this chapter does not break out one by one, mostly `misc_feature`, a catch-all for a labelled stretch with no more specific type, and `regulatory`, a stretch that controls when a nearby gene is switched on.

That mixture is the reason this record is worth opening rather than a bare FASTA. Every question you might put to a genome browser has an answer somewhere in those 102 features. Which gene sits at this position. Where does its coding stretch start. What protein do those bases spell. Which stretch of this record has never been annotated at all. This chapter covers the four surfaces that answer those questions, which are the import route, the viewport, the commands that move the view, and the tools on the **Sequence** menu.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. This chapter uses the HBB gene record. Download the file `NG_000007.3.gb` from the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/hbb-gene and remember where you saved it.

That link opens a folder listing rather than the file itself, so two clicks stand between you and the file. Click `NG_000007.3.gb` in the listing to open the file's own page, then use the download control in the toolbar above the file contents. Your browser saves the file to its usual download folder, which is where the command-line examples at the end of this chapter assume it sits.

Nothing else has to be installed and nothing here needs an internet connection after that download. Reading sequence files and drawing them is built into the app. The import finishes in about a second.

The GenBank flatfile is a plain-text format that carries a sequence and a table of the features annotated on it. That is why this fixture is a `.gb` file and not a FASTA, and it is why the bundle you build from it arrives with features in it.

## Procedure

### Import the record

1. Choose **File > Import Center...** (Cmd-Shift-I). The [Import Center](../../GLOSSARY.md#import-center) opens as a window with a row of tabs across the top and a grid of cards below them, one card per kind of file. The six tabs are Sequencing Reads, Alignments, Variants, Classification Results, Reference Sequences, and Application Exports. Only Reference Sequences matters here, and the other five belong to later chapters that import the kinds of data they name. Click Reference Sequences unless the window already opens on it.

    <!-- SHOT: import-center-reference-card -->

2. Drag `NG_000007.3.gb` from the folder you saved it in and drop it onto the Reference Sequences card. Every card is its own drop target, so the card you drop on decides what kind of import runs. There is no format picker and no preview step. The drop starts the import at once, and LGE compresses and indexes the sequence and builds the bundle without asking you to confirm anything.

3. Click that card's **Import...** button instead if you would rather pick the file from a panel. The panel and the drop do the same work, and the panel accepts more than one file at a time.

4. Find the new bundle under `Reference Sequences/` in the sidebar and open it. It carries the name of the file you dropped, so it appears as `NG_000007.3`. Because the record carried a feature table, the bundle arrives with an annotation track named Imported Annotations, and its features draw above the bases.

    <!-- SHOT: hbb-record-in-sequence-viewport -->

Dragging the file onto the project sidebar does the same import without opening the Import Center. The whole sidebar accepts a dropped file, not only the `Reference Sequences/` row.

### Attach a standalone annotation file

Do this only when you have a GFF3, GTF, or BED file that describes a genome already in the project. The HBB record needs none, because its features came in with it. The steps are here so you recognise the route when a collaborator sends you a bare feature file.

1. Choose **File > Import Center...** (Cmd-Shift-I) and stay on the Reference Sequences tab.

2. Drop the `.gff3`, `.gtf`, or `.bed` file on the Annotation Track card, or click that card's **Import...** button and pick it.

3. Fill in the Import Annotation Track alert that appears. Its three controls are covered in the Settings section below.

    <!-- SHOT: import-center-annotation-track-alert -->

4. Click **Import**. The new track joins the tracks the bundle already holds, and its features draw in the annotation lane alongside them.

Selecting more than one file at step 2 still shows the alert, but only the Reference choice is used. LGE then imports every file into the chosen bundle under names derived from the filenames. The alert does not appear at all when the project holds no reference bundle, so import a sequence first.

## Settings

The Reference Sequences card has no settings. It opens a file panel, and it imports what you give it, compressing and indexing the sequence and building the bundle without asking you to confirm anything. Two options exist on the command line only, and the On the command line section below covers both.

The Annotation Track card has three, and they appear in the Import Annotation Track alert after you choose a file.

**Reference.** Chooses which reference sequence the annotations are attached to, because the coordinates in the file are read against that reference. The default is the reference bundle currently open in the viewport, and otherwise the first bundle the project holds, which is right whenever you open a record and then attach features to it. Change it when the annotations describe a different genome than the one you happen to have open. This setting has no command-line flag.

**Track Name.** Sets the label the track shows in the viewport and in the annotation table. The default is derived from the annotation filename, which keeps the track traceable to the file it came from without you typing anything. Change it when the filename is opaque, so the track reads as something like RefSeq genes rather than as a bare accession. This setting has no command-line flag.

**Track ID.** Sets the stable identifier the bundle stores for this track, which is what other files inside the bundle refer to, so it has to be unique within the bundle. The default is derived from the annotation filename for the same reason the name is. Change it only when the derived identifier collides with a track the bundle already has. This setting has no command-line flag.

There is no command-line equivalent for attaching an annotation track. The window is the only route.

## Reading the results

### The bundle on disk

![Reference bundle folder connected to FASTA, FAI, manifest, and provenance files](../../assets/illustrations-imagegen/02-sequences/01-importing-and-viewing/reference-bundle-anatomy.png)

The bundle is a folder that behaves like a single file. Right-click it in the Finder and choose Show Package Contents to look inside. A `manifest.json` sits at the root, a `genome/` folder holds the sequence as a compressed FASTA with its indexes, and `annotations/`, `variants/`, and `tracks/` folders hold whatever is attached to the sequence. Compressed means the same bases stored in a smaller form with nothing thrown away, and the app reads them without unpacking anything first. The bundle also carries [provenance](../../GLOSSARY.md#provenance), the record of where the sequence came from, which the [Inspector](../../GLOSSARY.md#inspector) shows in its own section when the reference is selected in the sidebar.

The Inspector is a summary rather than a fixed list, because the rows it shows depend on what you have selected. Selecting the reference gives you a Total Length row reading 81.7 Kb, and selecting a single feature gives you that feature's own details. Drag out a selection instead and the Inspector switches to a Selected Region state, where a Length row gives the size of what you dragged and a separate Sequence Length row gives the size of the whole sequence it came from. The rows change with the selection, so read what is there rather than looking for a row this manual promised.

The [sidebar](../../GLOSSARY.md#sidebar) on the left shows the bundle inside the `Reference Sequences/` folder. Right-click it for **Rename...**, **Show in Finder**, and **Move to Trash**, among other items such as **Copy Path**, **Show in Inspector**, **Duplicate**, and a **Move to** submenu.

### The viewport

The viewport draws the record on one horizontal axis. Three lanes stack vertically inside that one view. They are drawing layers rather than separate labelled panes, so there is no divider to drag between them.

<!-- ILLUSTRATION: viewport-lanes -->

The top lane is the position ruler, the numbered strip that reports coordinates. The middle lane is the bases, which show as letters when you are zoomed in far enough to fit them and as a density rendering when you are not. Zoomed out, each pixel column covers more bases than a letter could be drawn for, so the lane becomes a run of coloured blocks, each block tinted for the base that dominates the stretch beneath it. Zoom out further still and even the blocks give way to a plain line marking where the sequence runs. Zooming back in reverses both steps and the letters return. The bottom lane is the annotations, present only when the bundle carries features, drawn as coloured blocks. The colour comes from a per-type table, so a `misc_feature` and a `mat_peptide` are different colours. One colour means one feature type, never one gene.

On the HBB record that lane fills with blocks as soon as the bundle opens. The useful number is not the total but the total divided by the length. The 102 features across 81,706 bases work out at rather more than one feature per kilobase, and comparing that ratio is how you judge a record of a different size. What matters is the order of magnitude rather than the exact figure, since a curated record annotated down to the exon runs far denser than a draft one annotated only at the gene. A count in the single digits on a record of tens of kilobases means the feature table did not come through, and the usual cause is that a bare FASTA was imported by mistake. Zero features on a file you believed was GenBank is the same problem in its clearest form.

### Moving around the record

Two commands cover most movement, and both live on the **Sequence** menu.

**Sequence > Go to Location...** (Cmd-L) takes a coordinate. Write the sequence name without the trailing `.3` before you type anything, because the import names the sequence from the record's own LOCUS line, and that line carries no version, so the [contig](../../GLOSSARY.md#contig-reference) name inside the bundle is `NG_000007` rather than `NG_000007.3`. Type `NG_000007:70613-70615` and the viewport frames three bases reading `GAG`. Those three are the normal codon at the sickle cell position, the healthy sequence rather than the sickle variant. A single number jumps to that base and a range zooms to fit it. On a single-contig bundle such as this one, the bare range `70613-70615` resolves to the only sequence there is.

<!-- SHOT: go-to-location-hbb-codon -->

The editable position field at the left end of the ruler accepts the same input and shows the placeholder `chr:start-end`.

**Sequence > Go to Gene...** (Cmd-Opt-G) opens a dialog where you type a gene name, which is the faster route when you know the gene and not the coordinate. The field is free text with the placeholder `e.g., BRCA1 or TP53`, so nothing is listed for you to pick from and you have to know the name the annotation carries. Clicking a feature block in the annotation lane selects it and highlights its row in the table drawer rather than moving the view. Use **Zoom to Annotation** in its right-click menu to fit the view to the feature, and double-click the block to read its details in a popover.

### Right-click actions

Right-click inside the viewport and the menu matches whatever sits under the pointer.

Right-click a feature block and you get that feature's own menu. A **Copy** submenu holds **Copy Name**, **Copy Coordinates**, **Copy Sequence**, **Copy Complement**, **Copy Reverse Complement**, and **Copy as FASTA**, plus **Copy Translation as FASTA** on a CDS feature. The two that sound alike differ in one step. The complement swaps each base for its pair, A for T and C for G, and keeps the order it found them in. The [reverse complement](../../GLOSSARY.md#reverse-complement) does the same swap and then reads the result backwards, which is what the other strand actually spells, so it is the one you want far more often. Below the submenu sit **Extract Sequence...**, which writes the feature's bases to a fresh bundle, a file, or the clipboard, and **Run FASTQ/FASTA Operation...**, which sends the feature's sequence into the FASTQ/FASTA Operations dialog. That dialog is where LGE runs the tools that transform sequence and read files, and the chapters on reads work through it in detail, so treat the item as a shortcut into work this chapter does not cover. **Zoom to Annotation** fits the view to the feature and **Show Annotation in Inspector** opens its details on the right. **Edit Annotation...** and **Delete Annotation** revise or remove it.

<!-- SHOT: hbb-annotation-context-menu -->

Right-click the bases instead and the menu acts on the visible region. **Copy Visible Region** puts the bases now on screen onto the clipboard, **Center View Here** recentres on the point you clicked, and **Zoom to Fit** returns the whole sequence to view. Those items keep acting on the visible region even when you have dragged out a selection, so a drag narrows what you are looking at rather than what the menu copies. Two more items, **Show All Translations** and **Hide All Translations**, appear only when the viewport is stacking several sequences. Stacking starts as soon as more than one sequence is loaded into the view, which is what a bundle of several contigs does, so a single-contig record such as this one never shows those two items.

## Translating a sequence to protein

Translation reads a nucleotide sequence three bases at a time and swaps each triplet for the amino acid it encodes. A triplet read this way is a [codon](../../GLOSSARY.md#codon). Which amino acid a codon maps to depends on the [genetic code](../../GLOSSARY.md#genetic-code) in use. The standard code, table 1, covers most nuclear genes, and alternatives cover vertebrate mitochondria (table 2), yeast mitochondria (table 3), and bacteria (table 11). Human nuclear genes such as HBB use table 1. What picks the table is where the sequence came from, so ask which organism and which compartment inside its cells before you choose. A gene from the nucleus of any animal, plant, or fungus takes table 1, the same organism's mitochondrial DNA takes table 2 or 3, and a bacterial gene takes table 11. Table 1 is the right first guess when the source is genuinely unknown.

A [reading frame](../../GLOSSARY.md#reading-frame) is the offset the triplets are counted from. There are six. Three run along the forward strand as `+1`, `+2`, and `+3`, and three run along the reverse complement, the other strand introduced above, as `-1`, `-2`, and `-3`. Translate in the frame and code that match your sequence when you know them, and scan all six when you do not.

### In the app

Two controls in the window are both named Translate, and this section means the toolbar button rather than the menu item. Click **Translate** in the window toolbar. That button is the only route to the overlay translation tool, which draws the protein over the bases you are looking at. **Sequence > Translate...** (Cmd-Shift-T) is the other one, and it runs the translate operation on the active sequence to produce a result rather than opening the overlay. Reach for the toolbar button when you want to read the protein against the DNA, and the menu item when you want the translation as an output. Its sibling **Sequence > Reverse Complement...** (Cmd-Shift-R) runs the reverse-complement operation the same way.

The tool opens with a Mode control offering `Single Frame`, `3 Forward`, `3 Reverse`, and `All 6 Frames`. Picking `Single Frame` reveals a picker for one specific frame. Choose the code under `Genetic Code`. The `Color Scheme` picker sets how the overlaid residues are tinted, offering `Zappo`, which is the default, then `ClustalX`, `Taylor`, and `Hydrophobicity`. Each one groups the amino acids by a different chemical property and gives each group a colour. The choice changes nothing but the colours, so leave it on `Zappo` unless a colleague has asked you to match a particular scheme. Leave `Show Stop Codons` on if you want stop positions marked, then click `Apply`. The translation appears as an overlay aligned to the bases, and `Hide Translation` clears it. The tool overlays the protein for reading and writes no file, so use the command line below when you need a protein FASTA on disk.

<!-- SHOT: translation-tool-hbb-cds -->

## Annotating features on a sequence

A GenBank import brings features in for you. You can also add one by hand and let LGE propose candidates.

### Adding one annotation by hand

Drag across the bases to select a region, then choose **Sequence > Add Annotation...**. A dialog asks for a name, a type, and a strand. The type menu offers `gene`, `CDS`, `exon`, `mRNA`, `region`, `misc_feature`, `promoter`, `primer`, and `restriction_site`, and the strand menu offers `+`, `-`, or `none`. Pick `+` unless you know the feature is read from the other strand, because the bases you dragged across are the forward strand ones the viewport is drawing. Pick `none` for a feature that has no direction, such as a region you are marking for your own reference. Click **Add**. LGE writes the annotation into the bundle, so it travels with the reference. Selecting nothing first stops the command with the message "Please select a region of the sequence first."

### Auto-detecting open reading frames

An [open reading frame](../../GLOSSARY.md#open-reading-frame), or ORF, is a stretch that runs from a start codon to a stop codon without an interruption, which makes it a candidate coding region. Choose **Sequence > Find ORFs...** on an open bundle. The dialog groups its controls under four headings.

- Reading Frames holds a checkbox per frame, all six on by default.
- Translation holds `Codon table` and `Minimum ORF length`, the shortest ORF to keep in nucleotides, default 100. A real human coding sequence usually runs from a few hundred to a few thousand bases, and the HBB coding sequence is 444, so a threshold of 100 is deliberately generous and returns plenty of chance matches alongside the real ones. Raising it to 300 or more, as the command-line example below does, trims most of that noise.
- Output holds `Track name`, prefilled with the sequence name followed by ` ORFs`, so on this record it reads `NG_000007 ORFs`, and `Track ID`.
- Options holds `Include partial ORFs`, which keeps ORFs running off the end of the range, and `Allow alternative starts`, which also treats the selected genetic code's alternative start codons as starts. `ATG` is the usual start codon, but several genetic codes let a handful of other codons open a gene, mostly in bacteria and in mitochondria. Leave the box off for a human nuclear record such as this one and turn it on when you are scanning a bacterial or mitochondrial sequence.

Click **Run**. LGE writes a new annotation track holding one feature per ORF, each carrying its translated protein as an attribute. An ORF track is a set of candidates and not a set of genes, because ORF length is only a weak proxy for a real gene. Read it beside the curated track rather than instead of it.

### Removing a track

To delete a whole annotation track in the window, open the annotation table drawer at the bottom of the viewport, pick the track, and choose **Delete Track...** from its track menu, which asks you to confirm before anything is removed. The command line offers the same removal, plus deletion of single rows from a track, and the On the command line section below shows both subcommands.

### Transferring best-match CDS annotations

This section looks ahead and needs nothing from you now. It describes a route that only opens once you have worked through [Mapping Reads to a Reference](../04-alignments/01-mapping-reads-to-a-reference.md), which is where mapping is covered properly.

Mapping is lining reads or sequences up against a reference to find where each one belongs, and an assembly is a genome rebuilt from sequencing reads rather than downloaded from a database. Once you have mapped one reference's coding sequences against a new assembly, LGE can carry the best-matching CDS models, meaning the coding regions with the closest alignments, across onto a fresh bundle. That path reads a mapping result, so it sits with the alignment commands rather than on the **Sequence** menu, and it runs from the command line.

## Getting data back out

Three items under **File > Export** take a bundle apart again. **Sequences (FASTA/GenBank)...** writes the sequence out, **Annotations (GFF3)...** writes the features out as a GFF3, and the **Provenance** submenu writes the bundle's run record. Exporting the features and re-attaching them to another bundle through the Annotation Track card is the round trip that moves one record's annotations onto another.

## What good looks like

Four checks are worth running before you trust an imported bundle. Confirm the Total Length in the Inspector reads 81.7 Kb for this record, which is how the Inspector rounds its 81,706 bases, since a truncated download shows up here first. Confirm that features appear in the annotation lane at all, because a bundle built from a bare FASTA shows none. Confirm that the bases at 70613 to 70615 read `GAG`, which fails when the wrong record or the wrong version came in, since the same coordinate then lands on different bases. And confirm that the Inspector's Provenance section names the file you actually imported.

When one of those disagrees, suspect the file rather than the app. Two malformed inputs account for most first-time failures. A FASTA whose first line does not begin with `>` gives LGE nowhere to start the record, and the fix is to open the file in a text editor and add a header line. A file saved out of a word processor carries invisible formatting characters among the bases, and the fix is to re-export it as plain text. A GenBank flatfile opens with a `LOCUS` line and carries a FEATURES table, so opening a file in any text editor tells the two formats apart in a second.

## On the command line

This section is optional. The window does everything above, and the terminal adds row-level deletion inside a track. The path shown is the one you downloaded the fixture to, written here as if it sits in your Downloads folder.

Two counting conventions meet here, and mixing them shifts a coordinate by one. The window counts 1-based and inclusive, so the first base of a sequence is base 1 and the range 70545 to 72152 takes both endpoints. Most of the command line counts the same way, and `extract sequence` says so in its own help. The exception is `sequence annotate-orfs`, whose `--start` and `--end` are 0-based with the start included and the end excluded, so the first base is 0. The HBB gene starting at window position 70545 is therefore passed to that one command as `--start 70544`, which is the subtraction the block below performs.

```bash
# Import the record. Despite the subcommand name, this accepts GenBank too.
lungfish-cli import fasta ~/Downloads/NG_000007.3.gb \
  --name HBB \
  --output-dir ~/Documents/hbb-example.lungfish

# Write a protein FASTA for one frame under the standard code.
# translate reads FASTA only, so point it at the bundle's own sequence.
lungfish-cli translate \
  ~/Documents/hbb-example.lungfish/"Reference Sequences"/HBB.lungfishref/genome/sequence.fa.gz \
  --frame 1 --table 1 -o hbb-frame1.faa

# Cut a region out as FASTA, wrapped at 70 characters per line.
# extract sequence reads FASTA only, so it takes the same file.
lungfish-cli extract sequence \
  ~/Documents/hbb-example.lungfish/"Reference Sequences"/HBB.lungfishref/genome/sequence.fa.gz \
  NG_000007:70545-72152 --line-width 70 -o hbb-gene.fasta

# Find ORFs in the HBB gene span only and store them as a named track.
lungfish-cli sequence annotate-orfs ~/Documents/hbb-example.lungfish/"Reference Sequences"/HBB.lungfishref \
  --sequence NG_000007 --start 70544 --end 72152 \
  --frames +1,+2,+3 --table 1 --min-length 300 --track-name "HBB ORFs"

# Remove a whole track again, the same job as Delete Track... in the drawer.
lungfish-cli sequence delete-annotation-track ~/Documents/hbb-example.lungfish/"Reference Sequences"/HBB.lungfishref \
  --track-id imported_annotations
```

`import fasta` takes `--name`, which sets the display name of the reference and defaults to the input filename, and `--output-dir`, which names the project directory the bundle is written into and defaults to the current directory.

`translate` and `extract sequence` both read FASTA only. Handing either one the `.gb` file you downloaded stops it with the message `Unsupported format: gb`, which is why the block runs both against `genome/sequence.fa.gz` inside the bundle the first command built. Exporting a FASTA through **File > Export > Sequences (FASTA/GenBank)...** gives you the same input under a name you choose.

`translate` takes `--frame`, where 1 to 3 are the forward strand and 4 to 6 are the reverse complement, and translates all six when you omit it. `--table` picks the genetic code and defaults to 1. Three flags shape the output. `--trim-to-stop` cuts each translation at its first stop codon, `--no-stop-asterisk` drops the `*` characters marking stops, and `--longest-orf` keeps only the longest open reading frame per sequence per frame. The global `--format` flag takes `text`, `json`, or `tsv` and defaults to `text`, so `--format json` gives a script something machine-readable to read back.

`extract sequence` takes its region as `name:start-end`, counted 1-based and inclusive like the window. `--line-width` sets the FASTA wrapping and defaults to 70.

`sequence annotate-orfs` scopes the search with three options. `--sequence` picks the contig and defaults to the first in the bundle. `--start` and `--end` bound the search and default to the whole sequence, and unlike the window they are 0-based with the start inclusive and the end exclusive, which is why the block above passes 70544 for a gene that starts at 70545. `--track-name` has no default at all, so pass it when you want a named track. `--track-id` falls back to a workflow-provided identifier.

`sequence delete-annotation-track` removes a whole track by `--track-id`. Its sibling `sequence delete-annotations` removes individual rows from a track, taking `--track-id` plus one or more `--row-id` values.

`bam annotate-cds-best` is the CDS-transfer command named above. Its four required options are `--bundle` for the source, `--mapping-result` for the mapping output to read, and `--output-bundle` and `--output-track-name` for what it writes. It builds a new bundle and leaves the source untouched. `--min-query-cover` sets how much of a CDS query the alignment has to cover before the model transfers, defaulting to 0.5, which means half. `--output-track-id` names the new track and otherwise falls back to a generated identifier. `--replace` overwrites an output bundle or track of the same name rather than stopping. `--include-secondary` treats secondary alignments as candidate duplicated loci and `--include-supplementary` treats supplementary alignments as candidate CDS models, so both widen the search beyond the primary alignment of each read.

## Next

Continue to [Downloading from NCBI](02-downloading-from-ncbi.md) to learn how to fetch an accession from NCBI straight into the project, with its provenance recorded as it arrives.
