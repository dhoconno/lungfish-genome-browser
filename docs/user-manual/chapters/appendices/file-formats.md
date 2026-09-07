---
title: File Formats
chapter_id: appendices/file-formats
audience: analyst
prereqs: []
estimated_reading_min: 40
task: Look up the structure and conventions of any file format Lungfish Genome Explorer reads or writes.
tags: [reference, file-formats, fasta, fastq, bam, vcf, gff3, lungfishref, bundles]
tools: [samtools, bcftools]
entry_points: []
shots: []
illustrations: []
glossary_refs: [bam, bcf, bed, bgzip, bundle, checksum, csi, csv, fai, fasta, fastq, gff, msa, newick, primer-scheme, provenance-sidecar, reference-bundle, run-bundle, tabix, tsv, vcf, virtual-bundle, workflow-bundle, bedgraph, bigbed, bigwig, cram, embl, format-registry, genbank, gtf, oci-layout, sam, two-bit, assembler, byte-offset, camel-case, classifier, contig, cz-id, ena, fixture, gc-content, half-open, haplotype, json, materialization, metabarcoding, n50, nextflow, ont, paired-end, pha4ge, phase, phred-score, primer-pool, repeat-masking, rooting, samtools, snake-case, spliced-feature, sra, stderr, table-drawer, tarball, twelve-s, variable-site, xlsx, zero-based]
features_refs: []
fixtures_refs: [hbb-gene, hg002-chr20, primate-mito, demo-project]
brand_reviewed: true
lead_approved: true
---

## What it is

Lungfish Genome Explorer (LGE) works with two kinds of file. The first kind is the standard bioinformatics formats that every genomics tool understands, such as FASTA for sequences and BAM for alignments, each defined in its own section below. The second kind is LGE's own bundle formats, which are ordinary folders that macOS shows as a single icon. Double-clicking one opens it in LGE rather than opening a folder window, and yet the files are plain files on your disk that any program can read, which is the main way LGE differs from a tool that keeps results locked inside its own library.

This appendix is for looking up one section at a time rather than reading start to finish. Each section says what one format holds, what LGE does with it, and how to look inside it. Every term is explained where it first appears.

Two ideas recur throughout. An index is a small companion file that lets a program jump straight to one position in a large file instead of reading the whole thing from the start, and LGE writes one beside almost every data file it produces. A manifest is a small text file inside a bundle that describes what the bundle holds, and reading it is how you learn what a bundle actually contains rather than guessing from the folder name.

The examples below come from two sources. One is the manual's fixtures, meaning the example files that ship with this manual for you to download, which live under `docs/user-manual/fixtures/` in the manual's repository. The other is the demo project at `~/Desktop/lge-docs/LGE Manual Demo.lungfish`, where the leading tilde stands for your own home folder, the one carrying your Desktop and Documents. Every line quoted here was read off disk rather than invented.

## Before you type anything

Most of this appendix inspects files with commands you type into Terminal, an application macOS ships with. [CLI Reference](cli-reference.md) opens with a section called "Before you type anything" that says where to find Terminal, how to move a Terminal window into the folder holding your files, and how to make the bare name `lungfish-cli` work. Read that section once and the commands below will run.

Two of the programs used here are not `lungfish-cli`. Samtools reads alignment files and bcftools reads variant files. LGE installs both for its own internal use rather than for yours, so typing either at a fresh prompt may find nothing until you install a copy of your own. [Power User Notes](power-user-notes.md) covers the copies LGE manages.

Every command block below is preceded by a sentence saying which folder to run it from. Where the LGE window shows the same information, the section says so and names the chapter that covers it. A reader who works entirely in the window can skip every code block in this appendix without losing anything.

## The format registry

LGE keeps an internal catalog of the formats it recognizes, called the format registry. Each entry names the format and lists the filename extensions that identify it. Each entry also says whether LGE can read the format and whether LGE can write it, and assigns a category. The category decides where the format appears in a file picker, which is the Open dialog that appears when you ask LGE for a file, so a format's category is what makes it offered or filtered out when you go looking for one. The categories are sequence, annotation, variant, alignment, coverage, and index, plus two more for the documents and images that ride along as attachments.

The read and write columns are easy to misread, so read this paragraph before the table. A format LGE can read is one it can open and display. A format LGE can write is one that a part of LGE itself produces directly. Many results you see in the window are written by an outside tool such as samtools, the standard program for reading and writing alignment files, rather than by LGE itself. That is why a format can be central to your work and still show No in the write column. BAM is the clearest case. Its row says No because no part of LGE writes a BAM by itself, and yet every alignment that reaches a viewport is a sorted BAM produced by the mapping pipeline, because the pipeline hands the writing to samtools. Read the write column as a statement about which program holds the pen rather than about what you end up with.

Two entries in the registry are detection only. LGE recognizes a BigWig or a BigBed file by its extension and labels it correctly in the interface, but it has no reader for either, so it cannot draw their contents. Seeing a BigWig track means converting it to bedGraph first, with a program such as the UCSC `bigWigToBedGraph` utility, which this manual does not cover.

The table below is the registry as of Preview 2026.9.13. Detection only in the read column means LGE names the file type correctly and does nothing else with it.

| Format | Extensions | Category | LGE reads | LGE writes |
|---|---|---|---|---|
| FASTA | `.fa`, `.fasta`, `.fna`, `.faa`, `.ffn`, `.frn`, `.fas` | Sequence | Yes | Yes |
| FASTQ | `.fq`, `.fastq` | Sequence | Yes | Yes |
| GenBank | `.gb`, `.gbk`, `.genbank`, `.gbff` | Sequence | Yes | Yes |
| GFF3 | `.gff`, `.gff3` | Annotation | Yes | Yes |
| GTF | `.gtf` | Annotation | Yes | No |
| BED | `.bed` | Annotation | Yes | Yes |
| VCF | `.vcf` | Variant | Yes | Yes |
| BCF | `.bcf` | Variant | Yes | No |
| SAM | `.sam` | Alignment | Yes | Yes |
| BAM | `.bam` | Alignment | Yes | No |
| CRAM | `.cram` | Alignment | Yes | No |
| BigWig | `.bw`, `.bigwig` | Coverage | Detection only | No |
| BigBed | `.bb`, `.bigbed` | Coverage | Detection only | No |
| bedGraph | `.bedgraph`, `.bg` | Coverage | Yes | Yes |
| FASTA index | `.fai` | Index | Yes | No |
| BAM index | `.bai` | Index | Yes | No |
| PDF | `.pdf` | Document | No | No |
| Plain text | `.txt`, `.text` | Document | No | No |
| Markdown | `.md`, `.markdown` | Document | No | No |
| CSV | `.csv` | Document | No | No |
| TSV | `.tsv` | Document | No | No |
| PNG | `.png` | Image | No | No |
| JPEG | `.jpg`, `.jpeg` | Image | No | No |
| TIFF | `.tiff`, `.tif` | Image | No | No |
| SVG | `.svg` | Image | No | No |

FASTA's seven extensions differ only in what the file holds. `.faa` holds protein sequence and the other six hold nucleotide sequence, and LGE treats all seven the same way.

The document and image rows read No in both columns because LGE identifies those files so it can label an attachment or an export, not so it can open them. A PDF you attach to a sample stays a PDF that Preview opens.

Four more formats have a registry identifier without a full entry. The practical effect is that LGE can name the file type when it sees one but cannot open it as a track. They are EMBL (`.embl`), the European counterpart to GenBank, 2bit (`.2bit`), a packed binary sequence format from the UCSC genome browser, and the two index formats CSI (`.csi`) and tabix (`.tbi`), both described under the variant section below. EMBL is the one of the four you can actually get into the app, because `lungfish-cli import fasta` accepts an EMBL file.

## Standard sequence formats

Every code block in this section shows a line as it sits in the file, shortened at the right edge where the real line runs wider than the page. A block that has been shortened says so once in the sentence introducing it.

FASTA is the plainest sequence format there is. A record starts with a line beginning `>`, which holds a name and an optional description, and the sequence follows on the lines after it. Here are the first three lines of the human chromosome 20 slice from the `hg002-chr20` fixture. HG002 is a widely used reference human sample whose genome has been sequenced many times over, and the name `chr20_10.0-10.5Mb` was chosen by whoever cut the slice to record that it covers positions 10.0 to 10.5 megabases of chromosome 20.

```fasta
>chr20_10.0-10.5Mb
GAACAAGTTCCAGAAGATAGCTAGAGGATGGGAGCACATGAAGAGCAGAT
CACAACCATCCCTGGGgagcccagcctggaccagctacagccacccgtct
```

Lowercase bases are normal and need no action from you. They mark repeat-masked regions, meaning stretches a repeat-finding program flagged as repetitive, and they carry the same meaning as their uppercase equivalents when a tool reads the sequence. LGE's sequence viewport draws them like any other base rather than marking them out.

A FASTA index, extension `.fai`, is a plain-text table that lets a program fetch one region without reading the file from the start. The whole index for that half-megabase slice is a single line.

```text
chr20_10.0-10.5Mb	500001	19	50	51
```

The line is the sequence name followed by four numbers. They are its length in bases, the byte offset at which its sequence starts, the number of bases per line, and the number of bytes per line including the line ending. A byte offset is a count of characters from the very start of the file, so 19 here means the sequence begins at the twentieth character, just past the name line.

LGE writes a `.fai` for you whenever it imports a FASTA, so importing a reference never leaves you needing to make one. To make one by hand, run `samtools faidx` from the folder holding the FASTA.

```bash
samtools faidx GRCh38.chr20.10.0-10.5Mb.fasta
```

FASTQ stores sequencing reads with a quality score for every base. Each read is four lines. The first begins with `@` and names the read, the second is the sequence, the third begins with `+`, and the fourth encodes one Phred quality score per base as a single character. A Phred score is a measure of how confident the instrument was in a base call, where 30 means roughly a one in a thousand chance of being wrong. Here is the first read of `HG002.chr20.10.0-10.5Mb_R1.fastq.gz`, shortened at the right edge. The read name is generated by the sequencing instrument, and its colon-separated fields record the machine, the run, and the position on the flow cell.

```fastq
@D00360:94:H2YT5BCXX:1:1101:1503:41403
GCTGGGATTACAGGCATGAGCCACCGCCCAGCCATTTCTGTTTTTTTAGATGTAGTCCTGCTTTATTGCCCA
+
0<0DD=1<DGHHE@?FFC?@CGCDGDHE<E1DG11<1<<1<11D1<E1CEC@D11D1<D@1@1D1<1<<11<
```

The characters on that fourth line are the scores, one character per base, and reading them by eye is not expected of anyone. LGE plots them for you in the FASTQ viewport, and [Quality Control](../03-reads/03-quality-control.md) reads that plot and gives the thresholds a run is judged against.

GenBank is a richer sequence format that carries annotations and curator notes alongside the bases. LGE reads GenBank on import and converts each record into a FASTA plus a GFF3 annotation track, keeping the original record in a small database inside the bundle so nothing is lost.

The `import fasta` command accepts a compressed input directly and recognizes five compression suffixes, which are `.gz`, `.bgz`, `.bz2`, `.xz`, and `.zst`. All five are ordinary compression formats and LGE handles them the same way, with `.gz` the one you will meet almost every time. You do not have to decompress a reference before importing it.

## Standard annotation formats

An annotation is a labelled region of a genome, such as a gene or an exon. GFF3 is the annotation format LGE prefers. Every feature line carries nine tab-separated columns. The first five are the sequence name, the source that produced the feature, the feature type, the start coordinate, and the end coordinate. The last four are a score, the strand, a reading-frame phase, and a semicolon-separated list of attributes. Phase says which base of a codon the feature begins on, written as 0, 1, or 2, and a dot everywhere the question does not apply, which is most rows and is safe to ignore.

Here are the first three lines of the annotation track LGE wrote when it imported the HBB gene record, read from `HBB.lungfishref/annotations/imported_annotations.gff3` in the demo project. The attribute column of both feature lines is cut in the middle, marked by an ellipsis, because it runs several times the width of this page. Semicolons separate one attribute from the next, so each `name=value` pair between two semicolons is one attribute.

```text
##gff-version 3
NG_000007	.	gene	52070	53062	.	+	.	_lf_raw_genbank_location=52070..53062;db_xref=GeneID:103344929,...;gene=BGLT3;gene_synonym=BGL3%3B%20LINC01083%3B%20lncRNA-BGL3;note=beta%20globin%20locus%20transcript%203
NG_000007	.	ncRNA	52070	53062	.	+	.	_lf_raw_genbank_location=52070..53062;...;gene=BGLT3;gene_synonym=BGL3%3B%20LINC01083%3B%20lncRNA-BGL3;...;product=beta%20globin%20locus%20transcript%203;transcript_id=NR_121648.1
```

Those attribute values are percent-encoded, meaning `%20` stands for a space and `%3B` for a semicolon, because the format reserves those characters as separators. Both codes appear in the `gene_synonym` value above. The `_lf_raw_genbank_location` attribute is LGE's own addition, preserving the original GenBank location string. That matters for a spliced feature, meaning one built from several separate pieces of sequence with the intervening stretches left out, which a single start and a single end cannot record. This particular feature is one unbroken stretch, so its location string is the plain `52070..53062`, and a spliced one would read as a list of ranges instead.

GTF is an older relative of GFF3 that uses the same nine columns with a different attribute syntax. LGE reads GTF and converts it, and the registry marks GTF as read only because LGE never writes one back out.

BED is a plain table of genomic intervals, at minimum three columns giving a sequence name, a start, and an end. Its most important job inside LGE is holding primer coordinates in a primer scheme bundle, where the fourth column names the primer, the fifth gives its pool, meaning which of the reaction's primer mixes the primer belongs to, and the sixth gives its strand. Here are the first two rows of `primers.bed` from the QIAseq scheme included with LGE. `MN908947.3` is the SARS-CoV-2 reference genome, which is what a primer scheme for that virus is written against.

```text
MN908947.3	27	51	QIAseq_221_LEFT	1	+
MN908947.3	31	56	QIAseq_221-2_LEFT	1	+
```

bedGraph is a four-column relative of BED whose fourth column is a numeric value per interval, used for coverage and signal tracks. LGE both reads and writes it.

Those two numbers are where the two coordinate conventions in genomics part company, and this is the single most useful paragraph in the section. BED and bedGraph are zero-based and half-open. Zero-based means the first base of a sequence is numbered 0. Half-open means the end number is the first base left out rather than the last base included. GFF3, GTF, and VCF are one-based and inclusive, meaning the first base is numbered 1 and the end number is the last base included.

Work the first BED row above through the conversion. It reads 27 and 51. To get the one-based inclusive start, add 1 to the BED start, so 27 becomes 28. The one-based inclusive end is the BED end unchanged, so 51 stays 51. That primer therefore covers bases 28 through 51, and its length is 51 minus 27, which is 24 bases. Notice that subtracting the two BED numbers gives the length directly, which is the practical reason the format is written that way.

LGE keeps each file in its own convention on disk and shows you one-based inclusive coordinates everywhere in the window. So a coordinate you read on screen can be typed straight into a region box or a VCF query, and a coordinate copied out of a BED file needs 1 added to its start first. [CLI Reference](cli-reference.md) says which convention each command takes under "How the syntax lines are written".

## Standard alignment formats

An alignment file records where each sequencing read landed on a reference. SAM is the human-readable text form, BAM is the same information packed into a compressed binary form, and CRAM is a further-compressed form that stores only the differences from the reference. A CRAM therefore cannot be read at all without the exact reference it was written against, down to the version, so keep that FASTA beside it. LGE refuses to open a CRAM whose reference it cannot find rather than opening it with the sequence missing.

LGE reads all three, and the `import bam` command accepts a BAM or a CRAM. What you always end up with, whichever tool did the mapping, is a sorted, indexed BAM. Sorted means the records are ordered by position along the reference, which is what makes an index possible at all, since an index is a shortcut into an ordered file. LGE's mapping pipeline runs any tool that emits SAM through `samtools sort` and `samtools index` and then deletes the intermediate text file, so no SAM survives as a result. That is a pipeline convention rather than a limit on format support.

A `.bai` index lets a viewer jump to a region without scanning the file. CSI is the alternative index for a reference sequence longer than the roughly 512-megabase limit a `.bai` can point into. That limit is a property of the index format rather than something to judge your data by, and it matters only for a single chromosome longer than about half a gigabase, which no human chromosome is. LGE writes `.bai` for the BAMs it produces and reads a `.csi` that arrives beside an imported BAM.

The LGE window shows the same figures the two commands below print. The Inspector's alignment summary reports Total Mapped, Total Unmapped, and Mapped %, with the raw flagstat categories under it, and [Mapping Reads to a Reference](../04-alignments/01-mapping-reads-to-a-reference.md) reads all of them in full. To get them at a prompt instead, run these two from the folder holding the project, using the alignment track in the demo project.

```bash
samtools idxstats "LGE Manual Demo.lungfish/Reference Sequences/chr20_10.0-10.5Mb.lungfishref/alignments/mapped/hg002-minimap2.bam"
samtools flagstat "LGE Manual Demo.lungfish/Reference Sequences/chr20_10.0-10.5Mb.lungfishref/alignments/mapped/hg002-minimap2.bam"
```

The first prints one line per reference sequence giving the name, its length, the number of mapped reads, and the number of unmapped reads. The final row, whose name is `*`, counts reads that matched nothing on any reference sequence.

```text
chr20_10.0-10.5Mb	500001	90990	213
*	0	0	0
```

The second summarizes the whole file. Its first lines on that same BAM read as follows.

```text
91203 + 0 in total (QC-passed reads + QC-failed reads)
91148 + 0 primary
0 + 0 secondary
55 + 0 supplementary
0 + 0 duplicates
```

Each line is written as two numbers joined by a plus sign. The first counts records that passed the instrument's own quality check and the second counts records that failed it, so a trailing `+ 0` means nothing failed, which is the usual case. A beginner can read the first line and skip the rest. Primary counts one record per read, supplementary counts extra records for reads split across two places, and secondary counts alternative placements, all read in full by [Mapping Reads to a Reference](../04-alignments/01-mapping-reads-to-a-reference.md).

Reading the two outputs together tells you that 90,990 of 91,203 records mapped to the slice, which is 99.8%. That chapter gives the anchor to judge such a figure against. Human reads against the matching human reference should sit above 99%, and a rate under 50% almost always means the reads were mapped against the wrong reference, so confirm the bundle really is the genome you sequenced before you go further.

## Standard variant formats

A variant is a position where a sample differs from the reference, and VCF is the format that records one. The header lines begin with `##` and declare the file version, the reference contigs, and the meaning of every field used below. A contig is one continuous stretch of reference sequence, which for a whole human genome means one chromosome and for this fixture means the single slice. The body has one variant per line. Here is the column header and the first rows of the HG002 benchmark VCF from the `hg002-chr20` fixture. Each data row is cut at the right edge for space, which is why the FORMAT and sample columns the header names do not appear.

```text
##fileformat=VCFv4.2
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	HG002
chr20_10.0-10.5Mb	2078	.	G	A	50	PASS	platforms=5;platformnames=Illumina,PacBio,10X,CG,Solid
chr20_10.0-10.5Mb	2162	.	A	T	50	PASS	platforms=5;platformnames=Illumina,PacBio,10X,CG,Solid
```

LGE rejects a file written in VCF version 3, which has to be converted with an outside tool such as `bcftools convert` before import. Any 4.x version is accepted. The `##fileformat` line at the top of the file, shown above, is where you read your own file's version.

A large VCF is normally stored bgzip-compressed as `.vcf.gz` with a tabix index as `.vcf.gz.tbi`. Bgzip is a form of gzip that compresses the file in separate blocks rather than as one continuous stream. That means a program can start reading in the middle of the file instead of decompressing everything before it, and tabix is the index that says which block holds which position. BCF is the binary form of VCF, which LGE reads with a `.csi` index beside it.

The Variants tab of the table drawer, a panel that slides up from the bottom of a reference bundle viewport, shows these rows in the window, and [Reading the Variant Browser](../05-variants/02-reading-the-variant-browser.md) reads every column of it. To get the rows at a prompt instead, run bcftools from the folder holding the project. The `-H` flag prints the data rows and suppresses the header.

```bash
bcftools view -H "LGE Manual Demo.lungfish/Reference Sequences/chr20_10.0-10.5Mb.lungfishref/variants/vc-6edd1356-e900-470c-95a3-eb1e4b5ffcfd.vcf.gz"
```

Bcftools prints a warning line about the fixture's `MQ` field being declared under the wrong type before the rows appear. That is a wrinkle in the file's own header and not a sign anything failed. The first rows of the bcftools track in the demo project print as follows, cut at the right edge.

```text
chr20_10.0-10.5Mb	2078	.	G	A	225.417	.	DP=62;VDB=0.240996;SGB=-0.693147;MQSBZ=0
chr20_10.0-10.5Mb	2162	.	A	T	222.406	.	DP=56;VDB=0.985023;SGB=-0.693021
```

`DP` is the read depth, meaning how many reads covered that position, and the other codes on the line are the caller's own internal statistics that you can skip. The sixth column is QUAL, the caller's confidence on the Phred scale. The two blocks above show the same position twice with two different QUAL values, 50 in the benchmark file and 225.417 here, because two different programs wrote them. There is no pass mark on that column, so judge a QUAL against the other calls in the same file rather than against a fixed number, which is what [Reading the Variant Browser](../05-variants/02-reading-the-variant-browser.md) does at length.

The long name `vc-6edd1356-e900-470c-95a3-eb1e4b5ffcfd` in that command is an identifier LGE generated when it made the track. Your own tracks will carry different ones, and the way to get such a name into a command is to copy it out of the Finder rather than to type it.

Variants produced inside LGE do not get a bundle of their own. A variant track lives inside the reference bundle it was called against, under that bundle's `variants/` folder, as a `.vcf.gz` with a `.vcf.gz.tbi` index and a `.db` SQLite sidecar that the Variants tab uses for fast filtering. Two routes are exceptions to that shape. The GATK entries of the Call Variants dialog write to `variants/gatk/<track-id>.vcf.gz` with a SQLite sidecar, and `lungfish-cli bundle create --variant` writes a `.bcf` with a `.csi` index instead. Nothing in the window marks the difference, since a track opens the same way whichever route made it, so the distinction matters only when you go looking at the files yourself.

## Standard tree format

A phylogenetic tree is a diagram of how a set of sequences are related by descent, and Newick is the compact text notation for one. Nested parentheses group the sequences that share a common ancestor, a number after a colon gives a branch length, and a semicolon ends the tree. Here is the whole tree LGE inferred from the five primate mitochondrial genomes, read from `Primate mitochondria.lungfishtree/tree/primary.nwk` in the demo project. The file holds it as one unbroken line, and it is broken across lines here so you can see the nesting.

```text
(Human_NC_012920.1:0.0601416264,
 Chimp_NC_001643.1:0.0589380812,
 (Gorilla_NC_011120.1:0.0740414756,
  (RhesusMacaque_NC_005943.1:0.0650250928,
   CynomolgusMacaque_NC_012670.1:0.0299081384):0.8982224217):0.0295665031);
```

This tree is unrooted, meaning it records which sequences group together but not which lineage came first. Its own manifest records `isRooted` as false. So the order the names appear in, on the page or in the description below, asserts nothing about ancestry, and neither does sitting outside a bracket.

Read the innermost parentheses first. The two macaques pair with each other, that pair joins the gorilla, and the human and chimpanzee sit outside that group. The branch lengths are substitutions per site, so the 0.0299 on the cynomolgus macaque branch means about 3 changes per hundred aligned positions since it split from the rhesus macaque. The 0.898 on the branch joining the macaque pair to the gorilla is far longer than any other, which is what you expect when a branch spans the deep split between the great apes and the Old World monkeys rather than a recent one.

LGE reads Newick produced by IQ-TREE, the tree program included with LGE, and stores it inside a `.lungfishtree` bundle described below.

## What an LGE bundle is

A bundle is a folder with a fixed extension that macOS Finder draws as a single icon. LGE treats it as one object in the sidebar, and yet at a Terminal prompt it is an ordinary folder whose files you can open with any tool. To browse one in the Finder, right-click it and choose **Show Package Contents**. That step is for the Finder only, and every command in this appendix reaches inside a bundle without it.

Every bundle carries a manifest at its root, and a manifest is a JSON file, meaning a plain-text format that stores data as named values. Each name is called a key. The manifest's shape is not shared across bundle kinds, so the practical rule is simple. Open the manifest and read it, rather than expecting a key you found in one bundle to appear in another.

The differences are mostly in how the key names are spelled. The reference bundle's manifest is `manifest.json` with snake_case keys such as `format_version`, meaning words joined by underscores. The alignment and tree bundles use `manifest.json` with camelCase keys such as `schemaVersion` and `bundleKind`, meaning words run together with each new word capitalized. The primer scheme's manifest uses `schema_version` and has no file map at all. The MHC amplicon reference does not use the name `manifest.json`, calling its manifest `mhc-reference.json` instead.

Most bundles also carry provenance, which is a record of the command that produced a file, described in its own section below.

Only three bundle extensions have identifiers in the format registry, which are `.lungfishref`, `.lungfish12sref`, and `.lungfishmhcref`. Nothing about that is visible while you work, since the other bundle kinds are recognized by their own commands and viewports instead, so a missing registry row never means a bundle is unsupported.

The table below lists every bundle kind Preview 2026.9.13 writes. ONT stands for Oxford Nanopore Technologies, the maker of the long-read sequencers LGE's genotyping runs use. CZ ID is an outside classification service that reports which organisms a sample holds, and 12S is a short stretch of a mitochondrial gene widely used to tell species apart.

| Bundle kind | Extension | Holds |
|---|---|---|
| Reference or assembly | `.lungfishref` | A genome sequence, its indexes, annotations, alignment tracks, and variant tracks |
| Read dataset | `.lungfishfastq` | One sample's reads, its statistics sidecar, and its metadata |
| Multiple sequence alignment | `.lungfishmsa` | An aligned FASTA, per-row metadata, and a lookup index |
| Phylogenetic tree | `.lungfishtree` | A Newick tree, its normalized form, and the inference tool's own artifacts |
| Primer scheme | `.lungfishprimers` | A primer BED, an optional primer FASTA, and a manifest |
| Genotype result | `.lungfishgenotype` | MHC genotype calls, an annotation sidecar, and an XLSX workbook |
| 12S amplicon result | `.lungfish12s` | A 12S metabarcoding run's species table and its supporting files |
| 12S reference | `.lungfish12sref` | 12S amplicon reference sequences with their taxonomy metadata |
| MHC reference | `.lungfishmhcref` | MHC amplicon reference sequences with allele and haplotype metadata |
| CZ ID taxonomy | `.lungfishtax` | A CZ ID species list, rewritten into the shape LGE's own taxonomy viewport reads |
| Workflow definition | `.lungfishflow` | A saved workflow graph as JSON |
| Workflow package | `.lungfishflowpkg` | An external pipeline file with a manifest describing it |
| Workflow run | `.lungfishrun` | A recorded pipeline execution with its configuration and provenance |

Where each of these lands inside a project is a separate question from what it holds, and the sections below name the folder for each. Note that results from the classifiers, meaning the programs that read a set of reads and report which organisms they came from, are not bundles. Kraken2, EsViritu, TaxTriage, NAO-MGS, and NVD each write a plain result folder holding a result JSON and the tool's own output files, which usually sits under `Analyses/` and lands under `Imports/` when NVD results arrive through the Import Center. Only the CZ ID import produces a `.lungfishtax` bundle.

## The reference bundle

An assembly and an imported reference are the same format kept in two different places, which is why an assembly appears in every reference picker with no conversion step in between. A `.lungfishref` bundle holds a genome sequence together with everything built against it. It is created when you import a reference from a file, fetch one from NCBI, the US National Center for Biotechnology Information, or run an assembler, meaning a program that reconstructs a genome from overlapping reads without a reference to guide it. An imported or fetched reference lands in the project's `Reference Sequences/` folder, and an assembly lands in the assembler's own run folder under `Analyses/`.

Here is the layout of `chr20_10.0-10.5Mb.lungfishref` from the demo project, which has been mapped against and had variants called on it twice. The provenance sidecars are left out for room, and the whole `provenance/` subtree with them, since they have a section of their own below. Every file whose name begins with a dot is hidden in the Finder by default.

```text
chr20_10.0-10.5Mb.lungfishref/
  manifest.json
  .lungfish-provenance.json
  genome/
    sequence.fa.gz
    sequence.fa.gz.fai
    sequence.fa.gz.gzi
  annotations/
  alignments/
    mapped/
      hg002-minimap2.bam
      hg002-minimap2.bam.bai
      hg002-minimap2.stats.db
      mapping-provenance.json
  variants/
    vc-6edd1356-e900-470c-95a3-eb1e4b5ffcfd.vcf.gz
    vc-6edd1356-e900-470c-95a3-eb1e4b5ffcfd.vcf.gz.tbi
    vc-6edd1356-e900-470c-95a3-eb1e4b5ffcfd.db
    vc-7ed9726c-de61-4735-80cf-0735eee621ec.vcf.gz
    vc-7ed9726c-de61-4735-80cf-0735eee621ec.vcf.gz.tbi
    vc-7ed9726c-de61-4735-80cf-0735eee621ec.db
  tracks/
  metadata/
  provenance/
```

Several details there are worth naming. The sequence is stored bgzip-compressed rather than as a plain FASTA, so it carries two indexes rather than one. The `.fai` points to sequence positions, exactly as the FASTA index section above describes, and the `.gzi` is an extra index the compression itself needs, pointing to the compressed blocks. Alignment tracks sit under `alignments/mapped/` rather than at the bundle root.

The two variant tracks make the naming point. Both are named by a generated track identifier rather than by the caller that produced them, so this listing cannot tell you which of the two came from bcftools. The window can. Open the bundle, look at the Variants tab of the table drawer, and each track carries its display name, with the recorded command in the Inspector's Provenance block beneath it.

The `annotations/` and `tracks/` folders exist even when empty, which is expected and not a sign anything went wrong. The HBB bundle in the same project fills `annotations/` with a GFF3 and its SQLite index and fills `metadata/` with a `genbank_records.sqlite` holding the original record.

The manifest carries fourteen keys, and `genome` is the one worth reading, since it is where the actual sequence files are named. The other thirteen are `format_version`, `name`, `identifier`, `created_date`, `modified_date`, `annotations`, `alignments`, `tracks`, `variants`, `record_store`, `browser_summary`, `source`, and `warnings`. The `genome` block names the sequence file, both index files, the total length, and one entry per chromosome. Here is that block from `HBB.lungfishref/manifest.json`.

```json
"genome": {
  "gzip_index_path": "genome/sequence.fa.gz.gzi",
  "index_path": "genome/sequence.fa.gz.fai",
  "path": "genome/sequence.fa.gz",
  "total_length": 81706
}
```

The friendlier way to read all of that is `lungfish-cli`, the command-line program that ships inside LGE and does most of what the window does. The window shows the same facts in the Inspector when the bundle is open. Run this from the folder holding the project.

```bash
lungfish-cli bundle info "LGE Manual Demo.lungfish/Reference Sequences/HBB.lungfishref"
```

That prints the name, the identifier, the source record it was imported from, the genome block, a chromosome table, and a table of annotation tracks. On the HBB bundle its chromosome and annotation tables read as follows. Primary marks the sequences LGE treats as the reference proper, as against alternative or patch sequences a large assembly can carry alongside them, and Mitochondrial marks the mitochondrial genome where one is present.

```text
Chromosomes
Name       Length (bp)  Primary  Mitochondrial
──────────────────────────────────────────────
NG_000007  81706        Yes      No

Annotation Tracks
ID                    Name                  Type  Features  Path
──────────────────────────────────────────────────────────────────────────
imported_annotations  Imported Annotations  gene  102       annotations/imported_annotations.gff3
```

## The read dataset bundle

A `.lungfishfastq` bundle holds one sample's sequencing reads. It lands in the project's `Imports/` folder when you import files or fetch reads from the SRA, the Sequence Read Archive at NCBI, or the ENA, the European Nucleotide Archive that mirrors it. It lands under `Analyses/` when a read operation such as trimming, meaning cutting low-quality bases and leftover adapter sequence off the ends of reads, produces a new dataset. Here is the whole of `HG002-chrM.lungfishfastq` from the demo project.

```text
HG002-chrM.lungfishfastq/
  HG002-chrM.fastq.gz
  HG002-chrM.fastq.gz.lungfish-meta.json
  .lungfish-provenance.json
  provenance/
    bundle.lungfish-provenance.json
    HG002-chrM.fastq.gz.lungfish-provenance.json
    HG002-chrM.fastq.gz.lungfish-meta.json.lungfish-provenance.json
```

Those three filenames under `provenance/` each end in two suffixes because LGE builds a provenance filename by appending `.lungfish-provenance.json` to the name of the file it describes. A doubled ending is the pattern working as intended rather than a typo.

A paired-end import produces one interleaved file rather than two. Paired-end means the instrument read each DNA fragment from both ends, giving two reads per fragment. Interleaved means those two reads sit as consecutive records in a single file, and the sidecar's `ingestion` block records `pairingMode: interleaved` so LGE knows to read them back that way. The Pairing setting in the import dialog controls how LGE reads your files in, not whether the bundle can hand the two ends back, which it always can.

The `.lungfish-meta.json` sidecar is where the read statistics live. Its keys include `assemblyReadType`, naming the instrument class, and a `computedStatistics` block. That block holds `baseCount`, `gcContent`, `meanQuality`, `meanReadLength`, `medianReadLength`, `minReadLength`, `maxReadLength`, `n50ReadLength`, and a `perPositionQuality` array with one entry per read position. N50 is a length statistic. Sort the reads longest first, add their lengths up until you pass half the total, and N50 is the length of the read you were on when you crossed. On the HG002 mitochondrial reads that block opens as follows.

```json
"computedStatistics": {
  "baseCount": 2473714,
  "gcContent": 0.444,
  "maxReadLength": 250,
  "meanQuality": 26.52,
  "meanReadLength": 248.4
}
```

Two of those numbers deserve a word of scale. `gcContent` of 0.444 means 44.4% of the bases are G or C rather than A or T, which is the fingerprint the human mitochondrial genome gives and matches what the assembly chapters report for the same molecule. `meanQuality` of 26.52 sits below the Phred 30 anchor that the quality chapter uses as a mark of a healthy Illumina run, and [Quality Control](../03-reads/03-quality-control.md) explains how each of LGE's quality averages is computed and why two of them can differ on the same reads. Read 26.52 as this fixture's own property rather than as a threshold anything else should be judged against.

Some read bundles are virtual. Your reads are safe and reachable, and the bundle simply stores the recipe rather than a second copy of the data. A subset, a trim, or a demultiplex writes a bundle recording its parent and the operation to rerun on demand, along with a `preview.fastq` of about a thousand reads so the viewport has something to show. Finding a `preview.fastq` where you expected a full file is correct rather than a truncated result.

Nothing in the window asks you to do anything about this. Any operation that needs the real reads materializes them itself, meaning it reruns the stored operation, writes the full file, and clears it away afterwards, which [Subsetting and Extraction](../03-reads/06-subsetting-and-extraction.md) covers. There is no menu item for it. Doing it deliberately, to get a plain FASTQ for a program outside LGE, is a command-line step. Run it from the folder holding the bundle.

```bash
lungfish-cli fastq materialize HG002-chrM.lungfishfastq --output HG002-chrM.fastq
```

Per-bundle sample metadata is stored as `metadata.csv` inside the bundle, and folder-level metadata as `samples.csv` at the folder root. Both follow the PHA4GE specification, a community standard from the Public Health Alliance for Genomic Epidemiology that fixes the field names for describing a pathogen sample. It settles what the columns are called and does not restrict what you type into them. The `lungfish-cli metadata` command reads and writes both files, and `lungfish-cli metadata export-biosample` turns a folder of them into a TSV file you can submit to NCBI's BioSample portal. The window has no equivalent for that export, so it is a command-line step.

## The alignment and tree bundles

A `.lungfishmsa` bundle holds a multiple sequence alignment. An alignment is a set of sequences padded with gap characters, written as dashes, so that positions descended from the same ancestral base line up in the same column. These bundles land under `Analyses/Multiple Sequence Alignments/`. Here is the layout of `Primate-mitochondria.lungfishmsa` from the demo project, with the bundle's own provenance sidecar and its view-state file left out for room.

```text
Primate-mitochondria.lungfishmsa/
  manifest.json
  analysis-metadata.json
  alignment/
    primary.aligned.fasta
    input.unaligned.fasta
    source.original
  metadata/
    rows.json
    annotations.json
    annotations.sqlite
    coordinate-maps.json
    source-row-map.json
  cache/
    alignment-index.sqlite
```

The aligned FASTA is `alignment/primary.aligned.fasta`, and the bundle keeps the unaligned input beside it so you can rerun the alignment with different settings. The file named `source.original` in this bundle and in the tree bundle below is the file exactly as it arrived, kept unchanged so nothing about the import is lost, and it carries no extension because its original format varies.

The manifest uses camelCase keys and records `bundleKind` as `multiple-sequence-alignment`, plus `alignedLength`, `rowCount`, `variableSiteCount`, `parsimonyInformativeSiteCount`, the computed `consensus` string, a `checksums` map, and a `fileSizes` map. On the primate alignment those counts are an aligned length of 17,247, five rows, 5,053 variable sites, and 2,709 parsimony-informative sites. A variable site is a column where the rows do not all agree. Those two counts are properties of this particular set of five primate genomes and carry no threshold, since how many sites vary depends entirely on how distant the sequences you aligned are.

A `.lungfishtree` bundle holds a phylogenetic tree and lands in a top-level `Phylogenetic Trees/` folder, whether the tree was built in the window or imported. Its layout is parallel to the alignment bundle, and the same two root files are left out again.

```text
Primate mitochondria.lungfishtree/
  manifest.json
  tree/
    primary.nwk
    primary.normalized.json
    source.original
  artifacts/
    iqtree/
      input.aligned.fasta
      run.treefile
      run.iqtree
      run.log
  cache/
    tree-index.sqlite
```

The canonical tree is `tree/primary.nwk`. The `artifacts/iqtree/` folder keeps the inference tool's own output untouched, including its log and its full report, so you can read exactly what IQ-TREE decided rather than only LGE's summary of it. The tree manifest records `bundleKind` as `phylogenetic-tree`, plus `tipCount`, `internalNodeCount`, `treeCount`, `isRooted`, `sourceFormat`, and the same `checksums` and `fileSizes` maps the alignment manifest carries.

The primate tree reports five tips, three internal nodes, one tree, and `isRooted` false. A rooted tree names one point as the common ancestor of everything else, so it reads as a history running in one direction. An unrooted tree records only which sequences group together, which is what this one does. That is also why the internal node count is three rather than four. An unrooted tree of five tips has no separate node at the top, since the outermost bracket in the Newick line is the whole tree rather than an ancestor of part of it.

## The primer scheme bundle

A `.lungfishprimers` bundle pairs primer coordinates with a description of the scheme, and project-local schemes live in the project's `Primer Schemes/` folder. The schemes included with LGE carry only three files.

```text
QIASeqDIRECT-SARS2.lungfishprimers/
  manifest.json
  primers.bed
  PROVENANCE.md
```

`PROVENANCE.md` is a plain Markdown note rather than the JSON sidecar every other bundle here carries, because the schemes included with LGE record where they came from as a citation for a person to read rather than as a machine record of a run.

A project-local bundle adds an optional `primers.fasta` holding the primer sequences, an optional `attachments/` folder for vendor PDFs or lab notes, and a `provenance/` folder holding one machine-readable sidecar per file plus a `bundle.lungfish-provenance.json` for the import as a whole. The manifest names its version key `schema_version`, and it carries no file map, meaning it does not list the bundle's filenames anywhere. Those names are therefore fixed by convention, so renaming `primers.bed` breaks the bundle and nothing in the manifest would need editing to match. The manifest's other keys include `name`, `display_name`, `description`, `organism`, `reference_accessions`, `primer_count`, `amplicon_count`, `source`, `source_url`, `version`, `created`, and `imported`.

Preview 2026.9.13 includes eight built-in schemes, all of them for SARS-CoV-2.

- `ARTIC-nCoV-2019-V3` and `ARTIC-SARS-CoV-2-V4`
- `ARTIC-SARS-CoV-2-V4.1` and `ARTIC-SARS-CoV-2-V5.3.2`
- `QIASeqDIRECT-SARS2`
- `Midnight-1200-V1`
- `NEB-VarSkip-vss1` and `NEB-VarSkip-Long-vsl1`

Import a vendor or lab scheme of your own through **File > Import Center...**, which needs a project window open and frontmost, and the resulting bundle lands in `Primer Schemes/`. It is then offered by the Primer Trim dialog, which opens from the Inspector's Primer Trim tab with an alignment selected, as [Primer Trimming an Alignment](../04-alignments/03-primer-trimming.md) shows. See [Primer Scheme Bundles](primer-schemes.md) for the manifest field by field.

## The result bundles

A `.lungfishgenotype` bundle holds one MHC genotyping run, from either the MiSeq amplicon route or the full-length Oxford Nanopore route. A MiSeq run lands under `Analyses/Amplicon genotyping results/` and a full-length run under `Analyses/Full-length ONT MHC genotyping results/`. The example read here comes from the Williams MiSeq genotyping project, a separate project used by the genotyping chapters and not included with this manual, so no fixture exists for it.

That bundle holds `genotype-result.json` as the machine-readable calls, an XLSX workbook named for the run as the shareable report, XLSX being the Excel spreadsheet format. Beside them sit a demultiplexed BAM with its `.bai` index, per-sample and per-genotype CSV tables, the error logs each tool the run invoked wrote as it went, an `artifacts/` folder holding workbooks and projections, meaning saved views of the result cut down to one question, and a `provenance/` folder with one sidecar per output file. The annotation layer, which is where manual review decisions are kept separately from the calls themselves, is written as `annotations.json` and appears only once someone has annotated the result.

A `.lungfish12s` bundle holds a 12S metabarcoding run, meaning a run that identifies every species present in a mixed sample from one short marker sequence. It lands at `Analyses/12S amplicon results/<Result Name>.lungfish12s`, in a folder named for the category rather than for the time of the run.

A `.lungfishtax` bundle holds a CZ ID species list rewritten into the shape LGE's own taxonomy viewport reads. It is the one classifier result that is a bundle, and both the app route and the command-line route write it to `Classifications/<sample>.lungfishtax`.

One known defect goes with that. In Preview 2026.9.13 the CZ ID import sheet's Project Destination readout displays a path under `Analyses` that nothing ever writes to. The import itself succeeds and the result is real. Only the readout is wrong, so look under `Classifications` for the bundle.

The 12S and MHC amplicon reference bundles are inputs rather than results. A `.lungfish12sref` holds 12S reference sequences with their species labels, with identical duplicates removed. A `.lungfishmhcref` holds MHC amplicon reference sequences with allele metadata, and its manifest is named `mhc-reference.json` rather than `manifest.json`. Reading the `MCM-MHC-miSeq-20260617.lungfishmhcref` included with LGE shows it also carries a `haplotypes/` folder and a `sources/` folder holding the spreadsheets and FASTAs it was built from. A haplotype is a set of alleles at linked positions that get inherited together as one block. Haplotype definitions are plain files inside that folder with the suffix `.lungfishhaplotypedef.json` rather than bundles of their own, so you move one by copying a file rather than by importing a bundle.

## The workflow bundles

Three formats cover workflows and they do different jobs.

A `.lungfishflow` bundle is a workflow definition, meaning the connected sequence of steps you assembled in the Workflow Builder. It lives in the project's `Workflows/` folder and holds `graph.json`, `workflow.json`, and `provenance.json`. Running a saved bundle writes each execution into a `runs/<run-id>/` folder inside that same bundle.

A `.lungfishflowpkg` package holds an external pipeline file, such as a Nextflow script. Nextflow is an outside system for describing a multi-step analysis, and an engine is the program that runs such a description. The package pairs that file with a `manifest.json` declaring its name, version, engine, inputs, and outputs. LGE builds the run form from those declarations, so a package that declares a reference and a reads input gets a reference picker and a reads picker.

A `.lungfishrun` bundle records one external pipeline execution. It holds `manifest.json` alongside `logs/`, `reports/`, and `outputs/` folders. A workflow can also be saved as a plain JSON file rather than as a bundle, and a run started from one of those has no bundle to write into, so its results land under a `Workflow Runs/<run-id>/` folder in the project instead.

## Provenance sidecars

A provenance sidecar is a JSON file written next to a result recording exactly how that result was produced. LGE names each one by taking the file it describes and appending `.lungfish-provenance.json`, so the sidecar for `hg002-minimap2.bam` is `hg002-minimap2.bam.lungfish-provenance.json`. It gathers a bundle's sidecars under a `provenance/` folder, and writes a `.lungfish-provenance.json` at the bundle root for the bundle as a whole.

Here is the shape LGE writes, read from the bcftools variant track in the demo project. The top-level keys are `id`, `name`, `appVersion`, `hostOS`, `startTime`, `endTime`, `status`, `runtime`, `parameters`, and `steps`. The block below is shortened to seven of those ten. The remaining three, `runtime`, `parameters`, and `steps`, hold too much to print and are described in the paragraphs after it. In `hostOS`, `arm64` names the processor family Apple Silicon Macs use.

```json
{
  "appVersion": "lungfish-cli 2026.9.13",
  "endTime": "2026-09-07T03:19:48Z",
  "hostOS": "macOS 26.6.2 (arm64)",
  "id": "12B3DCA5-5EF7-4781-A314-A4F32AD25582",
  "name": "lungfish variants call",
  "startTime": "2026-09-07T03:19:46Z",
  "status": "completed"
}
```

The `parameters` block records every setting the operation ran with, including the ones left at their defaults, each as an object with a `type` and a `value`. On that variant call it recorded `caller` as `bcftools`, `variantCallerVersion` as `1.24`, `threads` as `14`, and `minimumDepth` as `caller-default`. That last value is how LGE writes down a setting you did not override. It does not record the number bcftools then used, so recovering that means reading the `command` array in the `steps` block below, which gives the exact argument list, and consulting the tool's own documentation for whatever it does when the flag is absent.

The `steps` array holds one entry per process the operation ran. Each entry carries an `id`, a `command` array giving the exact argument list, a `dependsOn` list, `startTime` and `endTime`, an `exitCode`, `toolName`, `toolVersion`, `wallTime`, and `inputs` and `outputs` arrays.

Those arrays are how a sidecar records what went in and what came out. Every entry naming a file on disk carries a `path`, a `role`, a `format`, a `sha256` checksum, and a `sizeBytes` count. A checksum is a short fingerprint computed from a file's exact bytes, which lets two people confirm later that they hold the identical file. There is one exception. A step that pipes its output straight into the next one, without writing anything to disk, records that stream as an entry with a `path` such as `pipe:stdout:bcftools-mpileup` and no checksum or byte size, because no file was ever written.

A sidecar carries no `schema_version` key. Tools reading these files should identify the shape from the keys named above rather than looking for a version number, and read the file directly when they need a key this section does not name.

## Sharing and inspecting bundles

Because a bundle is a folder, a compressed archive is all it takes to send one to a colleague. The Finder does this without any command. Right-click the bundle, choose **Compress**, and macOS writes a `.zip` beside it. macOS also treats the bundle as one document, so dragging it into Mail attaches the whole thing.

The command-line equivalent, run from the folder holding the bundle, is one line. The `-r` flag tells zip to walk into the folder and include everything inside it rather than only the folder itself.

```bash
zip -r HBB.lungfishref.zip HBB.lungfishref
```

The recipient unzips it and drags the resulting folder into the LGE project window's sidebar, or copies it into the project folder in the Finder. Either route works.

The next paragraph is for readers moving bundles through container infrastructure. Anyone else can skip to the inspection commands below, and should, because the command it describes does not currently work.

In Preview 2026.9.13, `lungfish-cli bundle export` cannot be run at all. Its `--format` option collides with the global `--format` option that every LGE command carries, so `--format container` is rejected with the message that the value is invalid and only `text`, `json`, or `tsv` are accepted, while omitting the flag fails with a missing-argument error. There is no spelling that works. Share a reference bundle as a zip archive instead, exactly as above.

What that command is meant to write is a deterministic OCI layout tarball. A tarball is a single file holding a whole folder tree, and OCI layout is the standard folder shape that container systems store images in. Deterministic means the same bundle exported twice produces byte-identical output. The tarball holds an `oci-layout` file declaring the layout version, an `index.json` pointing at the image manifest, a config file, a manifest file, and one layer file holding the bundle's own contents, each of those named by its own SHA-256 checksum, plus a provenance record for the export itself.

Ordinary command-line tools work on a bundle's contents without unpacking anything, since the files inside are ordinary files. Run these from the folder holding the bundles. `python3` ships with macOS, so the last line needs nothing installed.

```bash
ls HBB.lungfishref/
samtools faidx HBB.lungfishref/genome/sequence.fa.gz NG_000007:70545-70600
bcftools view -H chr20_10.0-10.5Mb.lungfishref/variants/vc-6edd1356-e900-470c-95a3-eb1e4b5ffcfd.vcf.gz
python3 -m json.tool HBB.lungfishref/manifest.json
```

The region in the second line, `NG_000007:70545-70600`, is one-based and inclusive, the convention the coordinate example under the annotation formats section works through.

## Finding a format by its extension

This list maps an extension you found on disk to the section that covers it.

| Extension | Section |
|---|---|
| `.fa`, `.fasta`, `.fq`, `.fastq`, `.gb`, `.fai` | Standard sequence formats |
| `.gff3`, `.gtf`, `.bed`, `.bedgraph` | Standard annotation formats |
| `.sam`, `.bam`, `.cram`, `.bai`, `.csi` | Standard alignment formats |
| `.vcf`, `.vcf.gz`, `.tbi`, `.bcf` | Standard variant formats |
| `.nwk` | Standard tree format |
| `.gz`, `.gzi` | The reference bundle, under the `genome/` folder |
| Any `.lungfish` ending | What an LGE bundle is, then that bundle's own section |

## Next

See [CLI Reference](cli-reference.md) for the commands that read and write each of these formats. See [Power User Notes](power-user-notes.md) for the exact options LGE passes to the tools it wraps. See [Primer Scheme Bundles](primer-schemes.md) for the primer manifest in full.
