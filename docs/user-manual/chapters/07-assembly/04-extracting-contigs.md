---
title: Extracting Contigs
chapter_id: 07-assembly/04-extracting-contigs
audience: bench-scientist
prereqs: [07-assembly/01-when-to-assemble, 07-assembly/02-running-spades]
estimated_reading_min: 22
task: Pick contigs from an assembly and derive a new reference bundle from them.
tags: [assembly, extract, contigs, reference]
tools: []
parameters_refs: [assemble.extract-contigs]
entry_points:
  - "Assembly viewport action bar: Create Bundle"
  - "Assembly viewport contig table context menu: Extract to New Bundle..."
  - "CLI: lungfish-cli extract contigs --assembly <run folder> --contig <name> --bundle"
shots:
  - id: create-bundle-action-bar
    caption: "The assembly result viewport for the HG002 mitochondrial MEGAHIT run, with the longest contig selected in the table and the action bar below reading one contig selected, so BLAST Contig, Copy FASTA, Export FASTA, and Create Bundle are all enabled."
  - id: contig-context-menu
    caption: "The contig table's right-click menu on a selected row, showing Extract Sequence..., BLAST Contig..., Copy FASTA, and Export FASTA... above Extract to New Bundle..., with a separator and Run Operation... below."
  - id: derived-bundle-in-sidebar
    caption: "The derived reference bundle in the project sidebar under Reference Sequences, carrying the selected contig's own name because a single contig was selected."
illustrations: []
glossary_refs: [blast, contig, coverage, de-novo-assembly, depth, fai, fasta, mapping, mitochondrial-genome, msa, operations-panel, provenance, read, reference-bundle, variant-caller]
features_refs: []
fixtures_refs: [human-mito]
brand_reviewed: true
lead_approved: true
---

## What it is

An assembler is the program that joins overlapping sequencing [reads](../../GLOSSARY.md#read) into longer stretches of sequence, and a read is one fragment of DNA reported by the sequencing instrument. MEGAHIT and SPAdes are the two assemblers the previous chapters run. An assembler produces every [contig](../../GLOSSARY.md#contig) it could build. A contig is one continuous stretch of sequence reconstructed from the overlaps between reads, and [de novo assembly](../../GLOSSARY.md#de-novo-assembly) means building those stretches from the reads alone with no reference genome consulted at any point.

On a clean sample one contig is the one you want and the rest are short fragments the assembler could not extend, because it found no further overlapping reads to add. On the HG002 mitochondrial reads used throughout this part, MEGAHIT produced three contigs. One is 16,711 bases and holds the [mitochondrial genome](../../GLOSSARY.md#mitochondrial-genome) end to end. The other two are 362 and 332 bases, together under 4% of the assembly.

Extraction is the operation that picks contigs from an assembly and creates a new [reference bundle](../../GLOSSARY.md#reference-bundle) holding copies of just those contigs. A bundle is the folder Lungfish Genome Explorer (LGE) uses to keep a sequence together with the files built alongside it, and it carries the extension `.lungfishref`. It is a folder that macOS shows in the Finder as a single item, the way an application is a folder shown as one icon. Alongside the sequence, the bundle keeps a record of where that sequence came from.

Extraction writes four things.

1. A new [FASTA](../../GLOSSARY.md#fasta) file holding the selected contigs, FASTA being the plain-text format that stores sequences as a `>` header line followed by bases.
2. A [FASTA index](../../GLOSSARY.md#fai) beside it, a small companion file built automatically that lists where each sequence starts, so tools can jump to any position without reading the whole file.
3. A `.lungfishref` bundle around the pair.
4. A [provenance](../../GLOSSARY.md#provenance) record naming where the sequence came from.

Extraction has one main use, and it is narrower than it first appears. An assembly bundle is already a `.lungfishref`, so the menus where you choose a reference will list the whole assembly, and you can map reads against an assembly without extracting anything. Extracting is how you narrow the target to the contigs you actually want, so that a [mapping](../../GLOSSARY.md#mapping) run or a [variant-caller](../../GLOSSARY.md#variant-caller), the program that compares aligned reads to a reference and writes down where the sample differs from it, aims at one sequence rather than at every fragment the assembler emitted. After an assembly, look at the contig table and extract when you want that clean single-sequence target.

## Why you would do this

The clearest case is calling variants against your own assembly. A variant call is a recorded position where your reads disagree with the reference sequence they were mapped to. You assembled a genome because no reference existed, or because the available reference is too distant to map against comfortably, and now you want to know where your reads disagree with the sequence you built.

Mapping against the whole assembly would let some reads align to the short fragments instead of to the real genome. That thins out the [depth](../../GLOSSARY.md#depth) at the positions you care about, depth being how many reads cover a given position, and depth is the number you use to decide whether a variant call is trustworthy. Extracting the one long contig first means each read has only one matching sequence to align to.

The second case is wanting to look at a contig as a sequence rather than as a table row. The assembly viewport lists contigs and shows a preview of each one. It will not open a contig in the sequence viewport, where you can move along it by coordinate, read off its protein translation, or search it, and double-clicking a contig row does not open it either, unlike the sequence viewers you may have used elsewhere. Extracting a reference bundle from that contig is how you open it in the sequence viewport, and the bundle you get behaves like any other reference from then on.

The third case is keeping the project readable. A bundle made from the command line with `--assembly` carries a small metadata block naming the assembler, the source assembly, and the contigs you picked, so months later you can still read where the bundle came from. The full assembly can stay in the project and can be extracted from again as often as you like, and nothing about extracting consumes or alters the original.

## Before you start

Open Lungfish Genome Explorer first. You need a project open. A project is the `.lungfish` folder LGE keeps everything for one analysis in. If you do not have one, choose **File > New Project** (Cmd-N), where Cmd is the command key on a Mac keyboard, or click Create Project on the Welcome window, and pick a folder.

This chapter uses the HG002 mitochondrial reads. HG002 is a widely used human reference sample. These are example files provided for practice rather than anything the app requires. Download the folder `human-mito` from the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/human-mito and remember where you saved it. GitHub offers no download for a single folder, so open the repository's front page at https://github.com/dhoconno/lungfish-genome-explorer, click the green **Code** button, choose **Download ZIP**, double-click the downloaded file to unpack it, and find the folder inside it under `docs/user-manual/fixtures/`.

You also need an assembly to extract from, because extraction has no input of its own. Run the MEGAHIT assembly described in [Running SPAdes](02-running-spades.md), which is the chapter that covers both assemblers, against those reads first. This chapter uses the MEGAHIT run rather than the SPAdes one because MEGAHIT gives three contigs, which makes the selection step real, while SPAdes on the same reads gives one contig, so there is nothing to select. MEGAHIT 1.2.9 fails partway through on most runs on Apple Silicon in this release, so you may need to run it more than once. A run that completes is a correct result and can be used here. If you would rather not rerun it, follow this chapter with the single SPAdes contig instead. Every step works the same way, with one row to select rather than three.

The assembly lands in a timestamped folder under `Analyses/` in your project, named for the tool and the time it started, for example `megahit-2026-09-07T05-05-00`, with the assembly bundle inside it. The command-line examples at the end of this chapter use a run folder the author named by hand, so its name has a different shape.

## Procedure

The steps below are the same whether you extract one contig or several.

1. Open the assembly bundle from `Analyses/` in the sidebar, the list of the project's contents down the left side of the window, so its result viewport appears. The contig table lists every contig in six columns. `#` is the rank, which is the row's position in the table under the current sort. `Contig` is the name the assembler gave it. `Length (bp)` is its length in bases. `GC %` is the share of its bases that are G or C, which for human mitochondrial DNA sits near 44%. `Share of Assembly (%)` is its length as a percentage of all assembled bases. `Sequence Preview` shows the first few bases.
2. Click the rows you want. The action bar along the bottom shows how many rows are selected, reading "1 contig selected" or "3 contigs selected", and shows "Select contigs to materialize" while nothing is chosen, materialize being the app's word for writing the selection out as real files. On the MEGAHIT run, select the top row by length, the 16,711-base contig named `k141_1`, and leave the two short fragments alone.
3. Click **Create Bundle** in that action bar. All four of its buttons stay disabled until at least one row is selected. The other three are **BLAST Contigs**, **Copy FASTA**, and **Export FASTA**, and with exactly one contig selected the **BLAST Contigs** button retitles itself **BLAST Contig**. [BLAST](../../GLOSSARY.md#blast) is NCBI's sequence search service, which sends your sequence over the internet and returns the database entries that resemble it, and [BLAST Verification](../06-classification/06-blast-verification.md) covers it in full.
4. Watch the run in the [Operations Panel](../../GLOSSARY.md#operations-panel) if you want to. The panel is a list of everything LGE is running or has run this session, opening it is optional, and you open it with **Operations > Show Operations Panel** (Cmd-Shift-P). The row is titled `Create Reference Bundle`, its detail names how many sequences you selected, and it can be cancelled. Extraction takes a couple of seconds on this fixture, because the only work is subsetting and indexing.
5. Find the new bundle under `Reference Sequences/` in the sidebar. It is a reference bundle like any other from this point on, so you can open it, map against it, or call variants on it.

One thing to know before you build anything on top of the result. A bundle made with the **Create Bundle** button records its assembler as `Unknown`, because of a defect described in the Settings section below. The same selection made from the command line with `--assembly` records `MEGAHIT 1.2.9` instead. Nothing else about the two bundles differs.

<!-- SHOT: create-bundle-action-bar -->

Right-clicking a selected row, or Control-clicking it on a trackpad, opens the same actions under slightly different names. The items are **Extract Sequence...**, **BLAST Contig...**, **Copy FASTA**, and **Export FASTA...**, then **Extract to New Bundle...**, which is the context menu's name for Create Bundle. A separator sits below those, with **Run Operation...** alone underneath it.

**Extract Sequence...** opens a small dialog covering the same selection, carrying two controls. The Destination control offers Save as Bundle, Save to File..., Copy to Clipboard, and Share..., and the Name field arrives pre-filled from the selection. Pick a destination, edit the name if you want to, and click the button at the bottom right, which reads **Create Bundle**, **Save**, **Copy**, or **Share** depending on the destination you chose. The dialog offers no start and end positions, so it takes whole contigs rather than a sub-range of one.

**Run Operation...** hands the selection to the FASTQ/FASTA Operations dialog, the window that runs trimming, filtering, and subsetting tools on sequence files. The BLAST item is the only one with a selection limit. BLAST itself is capped at 50 selected sequences, and the item explains that limit in a tooltip when you exceed it. The bundle and export items in the same menu carry no such cap.

**Align with MAFFT...** is absent from this menu. MAFFT is the program LGE uses to build a [multiple sequence alignment](../../GLOSSARY.md#msa), which lines several sequences up column by column so that matching positions sit above each other, and the item appears in the FASTA collection viewport rather than here. This is a gap in the assembly viewport's wiring rather than a setting you can turn on.

<!-- SHOT: contig-context-menu -->

## Settings

Extraction has no dialog. What it does is decided by which rows are selected and by what you call the bundle, so the window offers two settings.

**Contig selection.** Chooses which contigs go into the new bundle, and it is the only input the operation takes. Nothing is selected when the viewport opens, the action bar reads "Select contigs to materialize", and every button in it is disabled until you pick at least one row. Select the contigs you actually want as a mapping or variant-calling target rather than every fragment the assembler emitted. On the command line this is `--contig`, which may be repeated.

**Bundle name.** Names the reference bundle the extraction writes. A single selected contig suggests that contig's own name, so on this chapter's MEGAHIT run the suggestion is `k141_1`, and a selection of several suggests `<run folder name>-selected-contigs`. Rename it when the suggestion is a long assembler-generated identifier you would rather not read in the sidebar, which is common with SPAdes, whose contig names carry their length and coverage. On the command line this is `--bundle-name`.

A bundle built with the **Create Bundle** button records its `Assembler` as `Unknown`. The button reaches the command below through `--contigs`, which reads the sequences from a file and so cannot see which assembler produced them. Building the same selection from the command line with `--assembly` records `MEGAHIT 1.2.9` instead. The sequences, the index, and the bundle itself are identical either way, so this matters only if you rely on that metadata later.

### Command-line-only flags

The eight flags below have no counterpart in the window. If you do your work in the LGE window you can stop reading here and go on to Reading the results, since nothing in this subsection changes what the buttons above do.

**`--assembly`.** Points the command at the assembly run folder under `Analyses/` that holds `assembly-result.json`, rather than at the `.lungfishref` bundle sitting inside it. Both are visible in the Finder rather than in LGE's sidebar, which shows names rather than files. There is no default, and it is one of the two ways to name a source. Use it whenever you are extracting from an assembly LGE ran, because this is the form that lets the derived bundle record which assembler built the sequence.

**`--contigs`.** Reads the source contigs from a plain FASTA instead of from an assembly run folder. There is no default, and exactly one of `--contigs` and `--assembly` must be given. Use it for contigs that never came from a managed run, accepting that the derived bundle will record its assembler as `Unknown`.

**`--contig-file`.** Reads contig names from a text file, one name per line, and may be repeated to read several files. There is no default, and it can be combined with `--contig`. Use it when the list is long enough to be worth keeping in a file, or when a script generates the list.

**`--output`.** Writes the selected contigs to a plain FASTA at this path instead of building a bundle. The default is standard output, which is the stream a command prints its ordinary results to and which appears in the Terminal window, so the FASTA prints to the terminal when the flag is omitted. Use it when you want a bare FASTA for another tool rather than something the sidebar will show.

**`--bundle`.** Builds a `.lungfishref` bundle in the project instead of writing a plain FASTA, which is what the **Create Bundle** button does. It is off by default, so a command without this flag prints FASTA rather than creating anything. Pass it, together with `--project-root`, whenever you want the result to appear in the sidebar.

**`--project-root`.** Names the project the new bundle belongs to. There is no default and the command refuses to run without it in `--bundle` mode. Point it at the `.lungfish` folder holding the assembly, so the derived bundle lands beside its source.

**`--line-width`.** Sets how many bases go on each line of the FASTA the command writes. The default is 60, which is the width most tools and most people reading the file expect, and most readers should leave it alone. Change it only when a later step in your own work demands a particular width, and note that 0 is accepted.

**`--format`.** Prints the command's result summary as text, json, or tsv. The default is text. Switch to json or tsv when a script is reading the summary rather than a person.

## Reading the results

A successful extraction is quiet. The `Create Reference Bundle` row in the Operations Panel finishes and reports the name of the bundle it made, the bundle appears under `Reference Sequences/`, and you can open it straight away. Nothing about the source assembly changes.

The bundle lands in the project's `Reference Sequences/` folder. When you build it from the command line without naming it, it is called `<assembly>-subset`. If that name is already taken, LGE adds a counter to the new bundle rather than overwriting the old one, and the sidebar and the Finder show that counter differently. The sidebar reads `-subset 2` while the folder on disk reads `_2`. This destination differs from read extractions, which land under the project's `Extractions/` folder, because what this operation produces is a reference to map against rather than a set of reads.

<!-- SHOT: derived-bundle-in-sidebar -->

Open the new bundle and check that it holds the sequences you meant to pick, at the lengths you saw in the contig table. Extracting the long MEGAHIT contig from the HG002 mitochondrial assembly gives a bundle with one sequence of 16,711 bases at 44.3% GC, which is the contig alone rather than the 44.6% [Running SPAdes](02-running-spades.md) reports for all three contigs together. Extracting that contig together with the 362-base fragment gives two sequences totalling 17,073 bases. Extraction copies sequence rather than editing it, so the lengths carry across unchanged. A length that does not match means you selected a different row than you thought.

A bundle built from the command line with `--assembly` also carries a Derived Subset block of metadata, which you read in the Inspector along the right side of the window when the bundle is open. It names the assembler and version, the source assembly, the contigs you selected, the contig count, the total length, and the GC content, so the block records where the sequence came from. Alongside it the bundle's source information records the source assembly's path and the note "Derived from `<source name>`".

Renaming the derived bundle in the sidebar is safe. Moving or renaming the source assembly is not. The bundle's source record stores the assembly's path, so once the assembly moves that path points at nothing and the record no longer leads anywhere. The sequence in the bundle is unaffected and stays usable. To repair the record, extract again from the assembly in its new location.

A **Create Bundle** run on an assembly that sits outside a project stops before it starts, because there is no `Reference Sequences/` folder to write into. This is rare, since an assembly you ran from the window is inside a project by definition. Move the assembly into a project and try again. Any other failure raises an alert headed "Reference Bundle Creation Failed" carrying the underlying message.

## What good looks like

Check the extracted contig against the length you expected before you build anything on top of it. The human mitochondrial genome is 16,569 bases in the reference record `NC_012920.1`, which is the accession number NCBI gives the standard human mitochondrial sequence. The MEGAHIT contig is 16,711, which is 142 bases longer.

Those extra bases have an ordinary explanation. The mitochondrial genome is a circle, and an assembler writing a circle down as a straight line has to cut it open somewhere. It typically carries a short stretch of sequence past the cut so that the two ends overlap, and that repeated stretch is what the extra length is. A contig landing near the length you expected is the quickest check available that the assembly worked.

Check the GC percent the same way, against the value known for the organism. The `NC_012920.1` reference in the fixture is 44.4% GC, and the extracted contig is 44.3%, which is the agreement you want. A figure far from the reference usually means the contig is not what you think it is.

Check the share of the assembly the contig represents. That column is the contig's length as a percentage of the total assembled bases, so it tells you whether one sequence dominates. The long HG002 mitochondrial contig is 96.01% of its assembly, with the two fragments at 2.08% and 1.91%. One contig holding almost all of the assembled bases means a clean assembly of a single molecule. Several contigs of comparable share means either that the assembly broke the genome into pieces, or that the sample genuinely held several sequences. To tell those apart, add up the contig lengths and compare the total against the genome length you expected. A total near the expected length with several contigs points to a broken assembly, and a total well above it points to more than one organism.

Judge the extraction by what happens downstream rather than by the operation itself, because the operation almost never fails in an interesting way. [Coverage](../../GLOSSARY.md#coverage) is how many reads sit over each position of the sequence you mapped to. If coverage against the extracted contig comes back uneven, with stretches under about 10 reads deep while the rest of the contig sits far higher, or well below what the same reads gave against an external reference, the assembly probably lost or broke up part of the genome and the assembly step is what to revisit. If annotation later shows the contig came from the host organism, or from a cloning vector such as a plasmid carried through the library preparation, delete the derived bundle and extract a different contig. Extraction is cheap to redo.

## On the command line

This section is optional. If you do your work in the LGE window, everything above is complete without it, and nothing here unlocks a result the action bar cannot produce. It is here for readers who want to script a run or repeat one on a server. The whole procedure runs headless, meaning with no window at all, by typing commands into the Terminal application, which you will find in the Applications folder under Utilities. The section assumes you have used a terminal before.

The command needs an assembly to read from, and the assembly it understands is a run folder rather than a bundle. A run started from the window leaves a run folder under `Analyses/`. A run started with `lungfish-cli assemble --output <dir>` leaves a run folder wherever you pointed it, holding `contigs.fasta` or `final.contigs.fa` alongside `assembly-result.json`, and that folder is what `--assembly` wants. The command-line assembler does not build the `.lungfishref` bundle that the window puts inside the run folder, so a headless reader works from the run folder throughout and gets a bundle for the first time from this command.

In the commands below, angle brackets mark a value you replace with your own, and a backslash at the end of a line continues one command onto the next line.

```bash
lungfish-cli extract contigs \
  --assembly ./HG002-mito.lungfish/Analyses/megahit-20260907-050500 \
  --contig k141_1 \
  --bundle \
  --project-root ./HG002-mito.lungfish
```

That run printed the path of the bundle it created, followed by the line `✓ Created bundle megahit-20260907-050500-subset.lungfishref`. Both appear in the Terminal window. The path goes to standard output, the stream a command prints its results to, and the message goes to standard error, the stream it prints its progress and warnings to, which matters only when you send the results to a file and want the messages to stay on screen. Without `--bundle-name` the name defaults to `<source>-subset`, taking the source from the run folder's own name.

Leave out `--bundle` and the command writes FASTA instead of building anything, which is what makes it usable from a script, meaning a file of commands you run without typing them again.

```bash
lungfish-cli extract contigs \
  --assembly ./HG002-mito.lungfish/Analyses/megahit-20260907-050500 \
  --contig k141_1 --contig k141_2 \
  --output two-contigs.fa --line-width 80
```

Omitting `--output` prints the FASTA to standard output, so the selection can be sent straight into another tool. `--contig-file names.txt` reads the names from a file, one per line, which suits a list long enough to be worth storing, and the flag may be repeated for several files. `--contigs <fasta>` replaces `--assembly` when the source is a bare FASTA rather than a managed run, and exactly one of the two must be given.

Inside a bundle the command builds, `genome/sequence.fa` holds the selected contigs with their original headers intact and `genome/sequence.fa.fai` is the index built beside it. The FASTA is plain text rather than compressed. The `manifest.json` records the bundle's genome files and carries the Derived Subset metadata described above.

The two sources differ in one way, and the difference shows up in the bundle rather than in the run. Sourcing with `--assembly` lets the command read `assembly-result.json` and record `Assembler` as `MEGAHIT 1.2.9`. Sourcing the same contigs with `--contigs` gives a bundle whose `Assembler` reads `Unknown` and whose `Source Assembly` is the FASTA's filename. The **Create Bundle** button takes the `--contigs` route internally, so a bundle made in the window records `Unknown` where a bundle made with `--assembly` records the real assembler. If that provenance matters to you, extract from the command line with `--assembly`.

## Next

This is the last chapter in Assembly. If you are reading this part in order, go to [Mapping Reads to a Reference](../04-alignments/01-mapping-reads-to-a-reference.md) next, which maps reads against the contig you just extracted and produces the alignment the following chapter needs. Then read [Calling Variants from Amplicons](../05-variants/01-calling-variants-from-amplicons.md) to call variants against your own assembly. [The Workflow Builder](../08-workflows/01-the-workflow-builder.md) covers composing these steps into a pipeline you can rerun.
