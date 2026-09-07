# Consistency sheet for the 2026-09 rewrite

Every chapter author, editor, and reviewer reads this before touching a
chapter. It holds the phrasings that must be identical across the manual so
that chapters written days apart read as one book. The project manager
(Fable) maintains it and adds a line whenever a chapter settles a phrasing
that later chapters will reuse.

## Naming

The app is "Lungfish Genome Explorer" at first mention in each chapter body
and "LGE" after that. "Lungfish" alone is the research collaborative. The
command line tool is `lungfish-cli`. The installed preview build is
"Lungfish Preview.app" only inside quotes or code.

## Menu paths and surfaces

Menu paths are written with a greater-than sign and spaces, in bold, ending
with an ellipsis when the item opens a dialog, for example
**Tools > Mapping > minimap2...**. The Tools menu holds one submenu per
category (QC & Reporting, Demultiplexing, Trimming & Filtering,
Decontamination, Read Processing, Search & Subsetting, Clustering, Mapping,
Classification, Assembly, Multiple Sequence Alignment, Genotyping, Variant
Calling) and one item per tool inside it. "FASTQ/FASTA Operations" is the
title of the dialog window, never a menu.

The Import Center is **File > Import Center...**, a tabbed grid of cards,
each card a drop target. The Inspector's Analysis section is a grid of six
tabs (Filtering, Annotations, Consensus, Primer Trim, Variant Calling,
Export). Write "the Inspector's Consensus tab", not "Inspector > Analysis >
Consensus". The Operations panel opens with **Operations > Show Operations
Panel** (Cmd-Shift-P). The Plugin Manager opens with **Tools > Plugin
Manager...** (Cmd-Shift-B).

Variants live in the table drawer at the bottom of a reference bundle
viewport, on its Variants tab. Call it "the Variants tab of the table
drawer" on first mention and "the Variants tab" after. There is no variant
browser window.

## Folders and files

A project is a `.lungfish` folder. Inside it, imported reads sit under
`Imports/`, downloaded reference records under `Downloads/` (reads fetched
from SRA or ENA are fetched from the Database Browser, **Tools > Search Online Databases > Search SRA...**, and land under `Imports/` as
`.lungfishfastq` bundles, settled by a live download on 2026-09-06), reference bundles under
`Reference Sequences/`, extractions under `Extractions/`, and analysis
results under `Analyses/`. Two shapes live there. A run by a named tool
(a classifier, a mapper, an assembler, ONT genotyping, Viral Recon) gets
its own subfolder `Analyses/<tool>-<timestamp>/`
(`AnalysesFolder.createAnalysisDirectory`, whose `knownTools` list names
esviritu, kraken2, taxtriage, minimap2, bwa-mem2, bowtie2, bbmap, spades,
megahit, skesa, flye, hifiasm, naomgs, nvd, cz-id, mafft, ont-genotyping,
viralrecon). A FASTQ/FASTA operation from the operations window (trimming,
filtering, decontamination, subsetting, read processing) writes its result
bundle directly under `Analyses/`, named `<input stem>-<operation>`, for example
`HG002.chr20.10.0-10.5Mb-fastpTrim` (`FASTQOperationOutputImporter.bundleNameStem`,
`FASTQOperationDialogState.defaultOutputDirectory`,
`MainSplitViewController+GenomicsDisplay.swift:993-994` and `:1231`, settled
2026-09-07). A Grouped Result run names its folder from the operation
title, not a timestamp. One further exception.
Multiple sequence alignments land under `Analyses/Multiple Sequence
Alignments/` as `.lungfishmsa` bundles (verified by a CLI run on
2026-09-06). Tree bundles are different. The app writes a `.lungfishtree`
built in the window, and an imported tree, to a top-level `Phylogenetic
Trees/` folder (`ViewerViewController.swift:2156`, `ImportMSATreeSubcommands.swift:147`),
while the CLI's `tree infer --output` writes wherever you point it. There
is no `Assemblies/` folder. Bundle extensions are written in code font:
`.lungfishref`, `.lungfishfastq`, `.lungfishmsa`, `.lungfishtree`,
`.lungfishgenotype`, `.lungfishprimers`.

## Settings entries

Each setting is one paragraph beginning with the control's label in bold
with the period inside the bold, then three sentences in this order: what it
does, what the default is and why, when to change it. Labels are copied from
`parameters.yaml`. Example:

    **Minimum read length.** Discards reads shorter than this after
    trimming. The default is 50 bases, long enough to map uniquely on most
    genomes. Lower it for very short amplicons, raise it when adapters
    leave many short fragments.

When a setting reaches the command line, the flag goes in a final short
sentence, "On the command line this is `--min-length`." When a setting has
no flag, say "This setting has no command-line flag."

## Recurring sentences

Introduce a number by what it measures, then a typical value on the
fixture, then what a bad value looks like. "Depth is the number of reads
covering a position. On the HG002 slice the mean depth is 45. A region
under 10 is too thin to call a variant with confidence."

Experimental features are introduced with one fixed sentence: "This feature
is experimental. Turn on **Show Experimental Features** in
**Settings > Advanced** before you look for it."

Docker is introduced with one fixed sentence: "This pipeline runs inside
Docker containers, so Docker Desktop must be installed and running."

The haplotyping placeholder in the genotyping chapters is one section headed
`## Haplotype analysis (placeholder)` with exactly two sentences: "LGE can
also assign MHC haplotypes from called alleles. A worked example with an MCM
dataset will be added in a later release of this manual."

## Fixtures by name

Refer to fixtures by these names: "the HG002 chromosome 20 slice", "the
HG002 mitochondrial reads", "the HG002 long reads", "the primate
mitochondrial genomes", "the HBB gene record", "the SRR36291587 SARS-CoV-2
reads", "the NVD demo results", "the Williams MiSeq genotyping project", and
"the demo project" (the project the build script produces under
`~/Desktop/lge-docs/`).

## Glossary discipline

Gloss a term the first time it appears in a chapter, even if an earlier
chapter glossed it. The gloss is one short sentence in plain words, and the
full definition lives in the Glossary. Add new terms to `GLOSSARY.md` in
alphabetical order using the existing entry shape.

## Before you start, fixed sentences (added after the chapter 1 reader team)

Every procedure chapter's Before you start section opens with these two
sentences, adjusted only for the fixture name and file. "You need a
project open. If you do not have one, choose **File > New Project**
(Cmd-N), or click Create Project on the Welcome window, and pick a folder."
Then: "This chapter uses the HBB gene record. Download the file
`NG_000007.3.gb` from the manual's fixtures on GitHub at
https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/hbb-gene
and remember where you saved it." All four readers of chapter 1 stopped at
step 1 because neither fact was stated. Never assume a project or a file.

## Variant track storage (settled by the chapter 5 fidelity review)

A variant track lives under the reference bundle's `variants/` folder as
`<name>.vcf.gz` with a `.vcf.gz.tbi` index and a `.db` SQLite sidecar that
the Variants tab uses for fast filtering
(`BundleVariantTrackAttachmentService.swift:71-74`). There is no BCF and no
CSI index, whatever the drift report's row 3 for chapter 5 said. The filter
chips sit behind a **Presets** disclosure button above the Variants table.

## Paired-end storage (settled by a live import on 2026-09-06)

A paired-end import is stored inside its `.lungfishfastq` bundle as one
interleaved `<sample>.fastq.gz` whose meta file records
`pairingMode: interleaved` (`FASTQBatchImporter.swift:1032`). Chapters say a
bundle holds the sample's reads, never "the R1 and R2 files", and describe
Interleave and Deinterleave as operations on files outside a bundle.

## Mean quality has two definitions (settled by chapter 16's runs)

The FASTQ viewport's Mean Q card holds seqkit's probability-averaged Phred
score (24.87 on the HG002 chromosome 20 pair). `lungfish-cli fastq
qc-summary` reports the arithmetic mean of the scores (34.93 on the same
reads). Both are right. Chapters quote the card value when they describe
the window, name which average a number is whenever the command line is
involved, and never compare a card to a CLI report.
