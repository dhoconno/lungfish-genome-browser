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
`Imports/`, downloaded data under `Downloads/`, reference bundles under
`Reference Sequences/`, extractions under `Extractions/`, and every
analysis result under `Analyses/<tool>-<timestamp>/`. There is no
`Assemblies/` folder. Bundle extensions are written in code font:
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
