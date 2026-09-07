---
title: What Is a Genome
chapter_id: 01-foundations/01-what-is-a-genome
audience: bench-scientist
prereqs: []
estimated_reading_min: 9
task: Understand what a reference genome is, how a position on one is named, and how to open a real gene record in Lungfish Genome Explorer.
tags: [foundations, genome, reference, coordinates, annotation, hbb]
tools: []
parameters_refs: [import.reference]
entry_points:
  - File > Import Center... (Cmd-Shift-I)
  - Sequence > Go to Location... (Cmd-L)
shots:
  - id: import-center-reference-card
    caption: "The Import Center with the Reference Sequences tab open and the Reference Sequences card ready to accept a dropped file."
  - id: hbb-record-in-sequence-viewport
    caption: "The imported HBB gene record open in the sequence viewport, with its annotation features drawn above the bases."
  - id: go-to-location-hbb-codon
    caption: "The Go to Location dialog holding the coordinate that frames the sickle cell codon in the HBB gene record."
illustrations:
  - id: linear-vs-circular-genomes
    brief: "Side-by-side schematic showing a linear chromosome (with two ends labelled 5' and 3') above a circular genome (closed loop, position 1 marked at the top). Use Lungfish Creamsicle for the genome backbone, Deep Ink labels."
  - id: position-coordinates
    brief: "A horizontal backbone for the record NG_000007.3 with position ticks at 1, 20000, 40000, 60000, 70613, 81706. Above the backbone, a callout showing total length 81,706 bases, and a second callout marking the HBB gene span 70545 to 72152. Use IBM Plex Mono for the numbers and Lungfish Creamsicle for the backbone."
  - id: variant-notation
    brief: "An annotated breakdown of the variant string 'NG_000007.3:70614 A>T'. Each component is labelled: record name, colon separator, 1-based position, reference base, '>' separator, alternate base. Use IBM Plex Mono for the variant string, Lungfish Creamsicle for the labels and lead lines, Deep Ink for the explanatory text."
glossary_refs: [reference-genome, coordinate, contig-reference, reference-bundle, provenance, fastq, bam, vcf, ref-alt, codon, cds, fasta, inspector]
features_refs: []
fixtures_refs: [hbb-gene]
brand_reviewed: true
lead_approved: true
---

## What it is

Every organism carries an instruction set written in a four-letter alphabet. That set is its genome, the complete genetic sequence of a cell, a virus, or any other biological entity, spelled in A, C, G, and T for DNA. RNA uses U where DNA uses T. Nearly every cell in an organism carries the same copy of that instruction set.

Sequencing does not give you the genome whole. A sample is the physical material you put into the instrument, such as a tube of DNA extracted from blood, saliva, or a bacterial culture. Running that sample returns millions of short reads, which are fragments of the sequence broken from random positions along it, with errors scattered through them. A short read is often 150 bases long, and one run commonly returns tens of millions of them. The work of a genomics tool is to put those fragments back into a coherent picture, and to say how the picture differs from a version already known.

That already-known version is the [reference genome](../../GLOSSARY.md#reference-genome). It is one specific sequence, read from a well-characterised sample. Well-characterised means the sample was sequenced deeply enough, and checked by enough independent groups, that its sequence is no longer in doubt. That sequence is then filed in a public database under a stable accession, in this case RefSeq, the curated collection kept by the National Center for Biotechnology Information. An accession is the permanent identifier a database assigns to one record, such as `NG_000007.3`. Its two-letter prefix encodes a record type, and `NG_` marks a curated genomic region rather than a whole chromosome. A field adopts one such record as the fixed point that every other sequence is measured against.

When a paper reports a mutation at some numbered position, that number means nothing on its own. It is a [coordinate](../../GLOSSARY.md#coordinate) on a shared map. Remove the map and two labs sequencing the same patient sample would name the same change with different numbers.

Three ideas carry through every chapter that follows. The first is what a reference holds, and how that differs from the sequence of any one sample. The second is how Lungfish Genome Explorer (LGE) points at a position. LGE counts positions 1-based and inclusive, so the first base of a sequence is position 1 and not 0, and both the start base and the end base of a range are counted inside it. A position is always paired with the name of the sequence it sits on. The third idea is that the choice of reference decides what the position numbers mean. Read this chapter once, unhurried, and treat the worked coordinate in the What good looks like section as your checkpoint.

## Why you would do this

This chapter works through a human gene with a famous single-base change in it. A curated slice of a chromosome centred on one gene or gene cluster, sized for people who study that gene rather than the whole chromosome, is called a RefSeqGene record. The HBB gene record is `NG_000007.3`, the RefSeqGene record for the beta-globin region of human chromosome 11. This one is 81,706 bases long, which is roughly a thousandth of chromosome 11. It covers the whole beta-globin cluster, so it carries eight genes and not only HBB. The beta-globin genes sit next to each other on the chromosome and are switched on in turn across development. A curator files that whole neighbourhood in one record because the genes are studied together.

HBB itself encodes the beta chain of haemoglobin, the protein that carries oxygen in red blood cells. In the record, the HBB gene spans positions 70545 to 72152. Its protein-coding stretch, the [CDS](../../GLOSSARY.md#cds), is split into three pieces by intervening non-coding stretches called introns, so it is written as `join(70595..70686,70817..71039,71890..72018)`. In that notation `join` lists the pieces that are stitched together, and the two dots inside each piece mark a range from a start position to an end position.

Sickle cell disease comes from a single-base change inside that CDS. A [codon](../../GLOSSARY.md#codon) is a run of three consecutive bases that together specify one amino acid. The sixth amino acid of the mature beta-globin protein is glutamate, spelled by the codon `GAG`. Mature here means the protein after the cell removes the initiator methionine that every coding sequence starts with, so the sixth amino acid of the mature chain is the seventh codon of the CDS.

That codon sits at positions 70613 to 70615 of the record, one position per base.

```text
position  70613 70614 70615
base          G     A     G
```

Change the middle base, the `A` at 70614, to `T` and the codon becomes `GTG`, which specifies valine instead. The protein that results is haemoglobin S. A person who inherits the change on both copies of chromosome 11 has sickle cell disease, and a person who inherits it on one copy carries the sickle cell trait and is usually healthy. That single base is the reason you would open this record and go looking for a coordinate.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. This chapter uses the HBB gene record. Download the file `NG_000007.3.gb` from the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/hbb-gene and remember where you saved it.

A fixture is one of the small, fixed example datasets this manual is written against, so that every reader sees the same numbers on screen. This one ships the record as `NG_000007.3.gb`, a GenBank flatfile. GenBank flatfile is a plain-text format that carries a sequence together with a table of the features annotated on it, which is why this fixture is a `.gb` file and not a bare [FASTA](../../GLOSSARY.md#fasta). Importing it takes well under a minute and needs no external tools, because reading sequence files is built into the app. The source and citation for the record sit in the `README.md` beside the file on GitHub.

## Procedure

1. Choose **File > Import Center...** (Cmd-Shift-I). The tabs run across the top of the window. Click Reference Sequences unless the window already opens on it.

    <!-- SHOT: import-center-reference-card -->

2. Drag `NG_000007.3.gb` from the folder you saved it in and drop it onto the Reference Sequences card. LGE compresses and indexes the sequence and builds the bundle without asking you to confirm anything. The import finishes in about a second, and you know it is done when the new reference appears in the sidebar.

3. Find the new bundle under `Reference Sequences/` in the sidebar and open it. It carries the name of the file you dropped, so it appears as `NG_000007.3`. Because a GenBank record carries a feature table, the bundle arrives with an annotation track already attached, and the features draw above the bases in the sequence viewport.

    <!-- SHOT: hbb-record-in-sequence-viewport -->

4. Choose **Sequence > Go to Location...** (Cmd-L) and type `NG_000007:70613-70615`. Type it without the trailing `.3`, which is not a typo. The import names the sequence from the record's LOCUS line, and that line carries no version. The viewport frames the three bases of the sickle cell codon, which read `GAG`.

    <!-- SHOT: go-to-location-hbb-codon -->

5. Type the same coordinate into the position field on the ruler instead if you prefer. The ruler is the numbered strip running across the top of the sequence viewport, and the position field sits at its left end. It accepts the same input and shows the placeholder `chr:start-end`.

## Settings

The Reference Sequences card has no settings. It opens a file panel, and it imports the file you choose, compressing and indexing the sequence and building the bundle without asking you to confirm anything. On the command line the equivalent is `lungfish-cli import fasta <file> --name <name> --output-dir <project>`, where `--name` sets the display name of the reference and `--output-dir` names the project directory the bundle is written into.

## Reading the results

The bundle in the sidebar is a [reference bundle](../../GLOSSARY.md#reference-bundle), a folder that macOS shows as one item and that carries the extension `.lungfishref`. It behaves like a single file until you ask otherwise, and you can look inside by right-clicking it in the Finder and choosing Show Package Contents. Inside it, a `manifest.json` sits at the root, a `genome/` folder holds the sequence as a compressed FASTA with its two indexes beside it, and `annotations/`, `variants/`, and `tracks/` folders hold anything attached to the sequence later. An index is a small companion file that lets a tool jump straight to a position instead of reading from the start. A compressed FASTA needs two of them. The `.fai` maps each sequence name to its offset, and the `.gzi` maps that offset into the compressed file.

The bundle also carries [provenance](../../GLOSSARY.md#provenance), which is the record of where the sequence came from. Select the reference in the sidebar and the [Inspector](../../GLOSSARY.md#inspector) shows a Provenance section holding the file it was built from, the date of the run, and a SHA-256 checksum for every file the import read and wrote. A checksum is a short fingerprint of a file's exact bytes, so two people can confirm they hold the same file. If your checksum differs from someone else's for a file of the same name, the two files are not the same bytes, and one of you has a different or a damaged copy.

The coordinate you typed has two halves. `NG_000007` is the name of the sequence, which the assembly literature calls the [contig](../../GLOSSARY.md#contig-reference) name. It comes from the record's own identifier, which is why the import drops the trailing version and the coordinate does too. Every downstream file has to agree on that name. `70613-70615` is the range, counted 1-based and inclusive, so it holds three bases and not two.

Hand LGE a coordinate whose position falls outside the loaded sequence and it refuses, with the message "Position is outside the sequence bounds". A contig name it cannot match is treated more gently. LGE first puts the name through its chromosome-name mapping, which is the table that lets equivalent spellings of the same sequence match each other, such as `chr11` and `11`. If that fails too, the app moves to the position on the sequence already open rather than warning you. Checking that the name in the ruler is the one you meant is the first sign that you have loaded the wrong reference for your data.

The annotation features drawn above the bases come straight from the GenBank feature table. The record carries 8 genes, 5 mRNAs, 5 CDS features, and 13 exons, and 102 annotation features in total once the other GenBank feature types are counted. An exon is one of the pieces a coding sequence is split into. There are more genes than mRNAs because three of the eight are pseudogenes, which are gene-shaped sequences that no longer produce a protein and so carry no mRNA or CDS. For a curated record of this size, a hundred or so features is what you should expect. A count in the single digits means the feature table did not come through, and the likeliest cause is that a bare FASTA was imported by mistake.

## Reading a variant

The sickle cell change written in full is `NG_000007.3:70614 A>T`. It breaks into four parts. `NG_000007.3` names the record. `70614` is the 1-based position, the middle base of the `GAG` codon at 70613 to 70615. `A` is the reference base, the base the reference genome holds at that position. That base is called [REF](../../GLOSSARY.md#ref-alt). `T` is the observed base, the base the sample's reads showed instead, and it is called ALT. Both names come from [VCF](../../GLOSSARY.md#vcf), which is the standard file format for variant calls and which uses REF and ALT as its column headings. Read the `>` aloud as "to" and the whole string says that where the reference reads A, this sample reads T.

REF always comes from the reference and never from a sample. ALT is what the reads in the sample actually showed. When REF and ALT are each one base long, the change is a single-nucleotide variant. An insertion makes REF one base and ALT several, so `A>ACGT` adds three bases after the A. A deletion does the reverse, so `ACGT>A` removes the same three bases. The base they share is the one before the change, which VCF keeps in both columns as an anchor.

The number is anchored to `NG_000007.3` and to nothing else. The same biological change has a different number on the human chromosome 11 sequence, and a different number again inside the HBB coding sequence on its own. The change is the same, the coordinate is not. That is why every variant in an LGE project is stored next to the accession of the reference it was called against. It is also why the variants table always carries the contig in its Chrom column, the third column of the table. The variants table is the Variants tab of the table drawer at the bottom of a reference bundle viewport, and the variant calling chapters cover it in full.

## Sample data and reference data

A sample's sequence is what you collected. A reference is the fixed sequence you compare it against. They come from opposite places, and LGE keeps them visibly apart.

Your sample sequence is empirical. It came off an instrument with per-base quality scores, a share of sequencing errors, and stretches where almost no reads landed. A quality score is the instrument's own estimate of how likely it is to have called that base wrong. The scale runs so that 20 means a 1 in 100 chance of error, 30 means 1 in 1,000, and 40 means 1 in 10,000. Some stretches of low coverage are expected in any run, because reads do not land evenly, and only a stretch that matters to your question is worth chasing. In LGE you meet the sample first as a [FASTQ](../../GLOSSARY.md#fastq) file, which is a text file of sequencing reads and their quality strings. You meet it later as a [BAM](../../GLOSSARY.md#bam) file, which is the compact indexed form those reads take once aligned to a reference. Each format has its own chapter.

A reference sequence is curated rather than collected. Some group settled it from representative samples, stamped it with a stable accession, and deposited it in a public database. It does not change while you analyse sample after sample against it, and that fixedness is the point. The trailing `.3` in `NG_000007.3` is a version number. When a curator revises the deposited sequence the version ticks up and the earlier one stays available. So when you publish a position, pin the version, which means writing the accession with its version in the methods section as `NG_000007.3` rather than as `NG_000007`.

In a project, references sit under `Reference Sequences/`, files you brought from your own disk sit under `Imports/`, and files LGE fetched from a public archive sit under `Downloads/`. Read extractions, which pull a chosen set of reads out into a new file, and region extractions, which pull a chosen stretch of a reference out into a new file, both land under `Extractions/`. Later chapters cover both. The folder names show which kind of data each item is, so opening a project makes the line between sample data and reference data visible at once.

## Linear, circular, and segmented genomes

Genomes come in different physical shapes. Eukaryotic chromosomes are linear, with two real ends, and the HBB record is a slice of one of them. Bacterial chromosomes and many viral genomes are circular, a closed loop where base 1 is wherever the curator chose to start counting. Some virus families split their genome across several separate molecules called segments, each filed under its own accession.

![Side-by-side schematic contrasting a linear chromosome and a circular genome](../../assets/illustrations-imagegen/01-foundations/01-what-is-a-genome/linear-vs-circular-genomes.png)

For the tools in this manual, the shape barely matters. LGE, like every aligner and variant caller it wraps, treats every reference as linear. A circular genome is simply unrolled at the curator's chosen origin. A read that physically crossed that origin shows up in the file as two pieces, one near the end and one near position 1. That split-read problem belongs to plasmids and bacterial genomes. A plasmid is a small circular DNA molecule that sits in a bacterial cell apart from its chromosome. LGE can assemble and classify bacterial data, but it still unrolls every reference at the curator's chosen origin. None of this changes a step in this chapter, because the HBB record is a slice of a linear chromosome.

The reason a DNA genome and an RNA genome look alike on disk is mechanical. Sequencing instruments read DNA, so an RNA sample is first copied into DNA in the lab, and the files that follow are written in DNA letters even though the original molecule was RNA. Reference databases and analysis tools then store everything in the DNA alphabet, which means an RNA reference is spelled with T in place of U and is indistinguishable from a DNA one.

## What good looks like

Four checks are worth running before you trust a coordinate. Confirm that the sequence viewport shows the length you expected, which is 81,706 bases for this record, and which appears in the Inspector beside the reference's name. Confirm that annotation features appear above the bases, since a bundle built from a bare FASTA would show none. A bare FASTA holds only header lines starting with `>` and the bases beneath them. A GenBank flatfile opens with a `LOCUS` line and carries a FEATURES table. Opening the file in any text editor tells the two apart. Confirm that the bases at 70613 to 70615 read `GAG`, which is the codon this chapter is about. This check fails when the wrong record or the wrong version was imported, because the same coordinate then lands on different bases. And confirm that the Inspector's Provenance section names the file you imported.

If any of those disagree, suspect the input rather than the app. The commonest cause is a file that looks right by name but holds a different record or a different version of it.

## Why reference choice matters

A reference exists to give a field one shared coordinate system. Pick a different reference and you have picked a different coordinate system. Most of the time the switch is invisible, because everyone in a subfield uses the same customary choice. An assembly is one complete reconstruction of an organism's genome, released as a numbered version by the group that built it. Human germline work uses the assembly called GRCh38, or its earlier release GRCh37. A large amount of clinical infrastructure exists for the sole purpose of translating between those two coordinate systems. LGE does not do that translation. It reports positions on whichever reference you imported, so converting between assemblies is a separate job done with dedicated tools.

A mismatch usually announces itself the same way. Your own output and a public database, or a colleague's spreadsheet, disagree about a number. Align against a reference that differs by even a one-base insertion near the start and every position after it slides by one. Same change, different coordinate.

LGE guards against this on two fronts. Every reference imported into a project carries the provenance described above. And every variant call keeps the reference accession in its file header, so a VCF you hand to a collaborator describes itself. One habit prevents most of this trouble. When someone gives you a list of variant positions, ask which reference they were called against before you do anything else with the numbers.

## On the command line

This section is optional. If you work entirely in the window you have just used, you can skip it. The same import also runs from `lungfish-cli`, which is the command-line tool that ships with LGE. Despite the subcommand name, the importer accepts GenBank as well as FASTA, which is why a `.gb` file is passed to `import fasta` below. The path shown is the one you downloaded the fixture to, written here as if it sits in your Downloads folder.

```bash
lungfish-cli import fasta ~/Downloads/NG_000007.3.gb \
  --name HBB \
  --output-dir ~/Documents/hbb-example.lungfish
```

`--name` sets the display name of the reference the import creates, defaulting to the input filename. `--output-dir` names the project directory the `.lungfishref` bundle is written into, defaulting to the current directory. The command creates that project directory if it does not already exist. The two extensions are easy to confuse. A project folder ends in `.lungfish` and a reference bundle inside it ends in `.lungfishref`.

## Next

Continue to [Sequencing Reads](02-sequencing-reads.md) to learn what FASTQ files are and how raw sequencing output relates to the reference you just met.
