---
title: Extracting and Comparing Sequences
chapter_id: 02-sequences/03-extracting-and-comparing
audience: bench-scientist
prereqs: [02-sequences/01-importing-and-viewing]
estimated_reading_min: 13
task: Cut one region out of a reference bundle as a new bundle or as clipboard FASTA, pull every feature of one type out at once, and mark candidate coding stretches with an ORF track.
tags: [sequences, extract, region, copy, fasta, orf, hbb]
tools: []
parameters_refs: [sequence.find-orfs, sequence.extract-region]
entry_points:
  - Sequence > Extract Visible Region... (Cmd-Shift-E)
  - Sequence > Copy Visible Region as FASTA (Cmd-Shift-C)
  - Sequence > Find ORFs...
  - Right-click a feature > Extract Sequence...
  - "CLI: lungfish-cli extract sequence, lungfish-cli bundle extract-annotations"
shots:
  - id: hbb-record-in-sequence-viewport
    caption: "The imported HBB gene record open in the sequence viewport, with its annotation features drawn above the bases."
  - id: go-to-location-hbb-codon
    caption: "The Go to Location dialog holding the coordinate that frames the sickle cell codon in the HBB gene record."
  - id: extract-region-dialog
    caption: "The Extract Sequence sheet opened by Extract Visible Region, with its Action picker, its Source summary, the 5' Flank and 3' Flank fields with their preset buttons, the Options toggles, and the Extract button."
  - id: hbb-annotation-context-menu
    caption: "The right-click menu on the HBB gene feature in the annotation lane, with the Copy submenu open."
  - id: find-orfs-dialog
    caption: "The Find ORFs dialog with its Reading Frames, Translation, Output, and Options groups above the Run button."
illustrations:
  - id: extraction-header-anatomy
    brief: "An annotated breakdown of the FASTA header line '>NG_000007:70544-72152 [NG_000007:70544-72152] [1608 bp]'. Three labelled parts, the leading region name, the bracketed coordinate token, and the bracketed length token, each with a lead line to a short explanation. Below it a second variant of the same header carrying an extra '[reverse complement]' token, labelled as the token that appears only when the extraction was flipped. Use IBM Plex Mono for the header text, Lungfish Creamsicle for the lead lines and labels, Deep Ink for the explanatory text."
glossary_refs: [annotation-track, cds, checksum, codon, contig-reference, exon, extraction, fasta, genetic-code, open-reading-frame, provenance-sidecar, reading-frame, reference-bundle, sequence-viewport, sidebar, strand]
features_refs: []
fixtures_refs: [hbb-gene]
brand_reviewed: true
lead_approved: true
---

## What it is

Extraction cuts a stretch out of a sequence you already have and writes that stretch somewhere new. A stretch here means a region of bases named by a start number and an end number, not a mouse selection and not a whole gene unless you framed one. Lungfish Genome Explorer (LGE) calls the result an [extraction](../../GLOSSARY.md#extraction). Nothing is removed from the source. The original [reference bundle](../../GLOSSARY.md#reference-bundle) is untouched, and the extraction is a copy of part of it.

Three routes exist, and the difference between them is what decides the boundaries of the cut. The first route takes whatever the [sequence viewport](../../GLOSSARY.md#sequence-viewport) is currently showing, so you frame the region on screen and then extract it. The second route takes one annotated feature, so a right-click on a gene block cuts exactly that gene. The third route runs on the command line and takes every feature of a chosen type at once, so one command gives you all eight genes on a record as eight [FASTA](../../GLOSSARY.md#fasta) records.

The window covers the first two routes without a terminal, and the command line is optional for everything except pulling a whole feature set out at once. Read the last section only when you want that, or when you want the exact base count the window's framing cannot promise.

The two window routes put the result in different places, because they are two different sheets. The visible-region route offers a three-way Action picker, so the result becomes clipboard FASTA, clipboard protein, or a new bundle in the project. The annotation route offers four destinations instead, adding a file on disk and the macOS share sheet, which is the standard macOS panel that hands the file to another app such as Mail or Messages. A bundle is the choice when the region will be an input to another LGE operation, and the clipboard is the choice when the region is going into a web form or an email.

This chapter also covers one thing that is not extraction but sits next to it. Find ORFs scans a sequence for candidate protein-coding stretches and records them as a new [annotation track](../../GLOSSARY.md#annotation-track) on the bundle. It writes into the bundle rather than out of it, and its output gives you feature blocks that the other two extraction routes can then cut out.

None of this compares two sequences to each other. Cutting the same gene out of two records gives you two bundles, and the comparison itself is an alignment, which is the next chapter. Treat this chapter as the step that produces the pieces an alignment consumes.

## Why you would do this

The HBB gene record is one downloaded stretch of human chromosome 11 rather than one gene, and the stretch happens to hold a cluster of related beta-globin genes. It carries eight genes across 81,706 bases, and almost no question you would put to it concerns all 81,706. The cluster is worth having in one record because the genes are studied together, but a day's work usually concerns one of them.

Say you want the HBB gene on its own. It spans positions 70545 to 72152 of the record, which is 1,608 bases, about two percent of the file. You might want it as a bundle so you can map reads against just that gene rather than the whole cluster. You might want it as clipboard text because you are checking a primer against it in an external design tool. You might want its coding stretch specifically, because the sickle cell change sits in that stretch and the introns around it are not what you are checking. That change swaps one base in the sixth codon, `GAG` to `GTG`, so the glutamic acid at position 6 becomes a valine and the protein sticks to itself when oxygen runs low.

Or you might want all eight genes at once. Pulling `HBE1`, `HBG2`, `HBG1`, `BGLT3`, `HBBP1`, `HBD`, `HBB`, and the pseudogene `OR51AB1P`, a gene copy that carries changes stopping it from making a working protein, out as eight separate records is one command, and the result is a ready input for an alignment across the cluster. Doing the same by hand would be eight rounds of framing and extracting.

The practical takeaway is to cut the piece you actually need, once, and let the extraction carry its own coordinates so you can always trace it back.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. This chapter uses the HBB gene record. Download the file `NG_000007.3.gb` from the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/hbb-gene and remember where you saved it.

The `.3` on that filename is the record's version number, which later mentions drop, so `NG_000007` and `NG_000007.3` name the same record. Import that file first, which the [Importing and Viewing a Sequence](01-importing-and-viewing.md) chapter covers step by step. The short version is **File > Import Center...** (Cmd-Shift-I), then drop the file on the Reference Sequences card. Open the resulting bundle so the record is on screen before you start here.

Nothing in this chapter needs a plugin pack, an internet connection, or Docker. Cutting sequence and scanning for reading frames are built into the app, though writing a new bundle also runs the managed `bgzip` and `samtools` binaries the app installs for itself, which needs no setup from you. Every extraction here is fast enough to feel immediate.

<!-- SHOT: hbb-record-in-sequence-viewport -->

## Procedure, cutting a region out

### Extract the region the viewport is showing

1. Find the ruler, the thin numbered strip running across the top of the viewport just above the bases. Its left end holds a small text field showing grey placeholder text reading `chr:start-end`, which is a hint about the format rather than something you type. Type `70545-72152` there and press Return to put the HBB gene span on screen. On a single-[contig](../../GLOSSARY.md#contig-reference) bundle such as this one you can leave the sequence name off, because there is only one sequence to mean. **Sequence > Go to Location...** (Cmd-L) accepts the same text.

    <!-- SHOT: go-to-location-hbb-codon -->

2. Read the numbers the ruler settled on before you go further. This route extracts whatever the viewport is showing, and the viewport rounds your range outward to a whole number of drawn bases, so the framed span is usually within a few dozen bases of what you typed and can be wider by a few hundred at a zoomed-out view. Nothing you highlight with the mouse narrows it. When the count has to be exact to the base, use the command line, which cuts the range you name.

3. Choose **Sequence > Extract Visible Region...** (Cmd-Shift-E). A sheet titled Extract Sequence opens, headed by a scissors icon, with a Source group naming the region, its type, and its [strand](../../GLOSSARY.md#strand).

    <!-- SHOT: extract-region-dialog -->

4. Pick one of the choices in the Action picker at the top of the sheet. Copy as FASTA puts the FASTA text on the clipboard. Copy Protein appears only when the source is a [CDS](../../GLOSSARY.md#cds) and gives the translated protein instead. New Bundle writes a new `.lungfishref` bundle into the project. Set the flanking and option controls below it as the Settings section describes.

5. Pick New Bundle, type `HBB-gene` into the Bundle Name field that appears once you do, and click **Extract** at the bottom right. That button reads Extract whichever Action you picked.

The new bundle appears under `Extractions/` in the [sidebar](../../GLOSSARY.md#sidebar). When LGE cannot work out which project the source belongs to, it falls back to an `Extractions` folder sitting next to the project folder, and failing that to `Lungfish Extractions` in your Documents folder.

### Extract one annotated feature

This route skips the framing entirely, which makes it the better choice whenever the thing you want already has a feature block drawn for it. It also opens a different sheet, and the difference matters, because this one writes its bundle somewhere else.

1. Right-click the feature block in the annotation lane, the horizontal band of feature blocks drawn above the bases. On the HBB record, right-click the `HBB` gene block. On a trackpad with no second button, hold Control and click instead.

    <!-- SHOT: hbb-annotation-context-menu -->

2. Choose **Extract Sequence...**. A second sheet also titled Extract Sequence opens, and it is not the sheet the visible-region route opens. Its header carries a count reading "1 selected", which counts the FASTA records the extraction will write rather than bases. One feature gives one record, so it reads 1 here. A FASTA file can hold many records one after another, so a higher number means more than one feature was prepared.

3. Pick one of the four choices in the Destination group. Save as Bundle writes a new `.lungfishref` bundle into the project. Save to File... writes a FASTA to a location you choose. Copy to Clipboard puts the FASTA text on the clipboard. Share... hands the FASTA to the macOS share sheet.

4. Type a name into the Name field, which arrives already holding the feature's own name. The field appears for the first two destinations and hides for the other two, because a clipboard entry and a shared item have no filename to set.

5. Click the button at the bottom right. Its label follows the destination you picked, so it reads Create Bundle for a bundle, Save for a file, Copy for the clipboard, and Share for the share sheet. The bases you get are the feature's own, taken from its recorded start and end rather than from the screen.

Save as Bundle on this route writes into `Reference Sequences/` rather than `Extractions/`, because it goes through the same import path an imported FASTA takes and arrives as a derived reference bundle. The visible-region route is the one that fills `Extractions/`. Neither route ever writes into `Imports/`.

The same right-click menu holds a Copy submenu that skips the sheet. **Copy Sequence** puts the bases on the clipboard as plain text, **Copy as FASTA** adds a header line, **Copy Reverse Complement** gives you the other strand, and **Copy Translation as FASTA** gives the protein. That last item appears only on a CDS feature, because only a CDS records which base its reading frame starts on, so it is the only feature the app can translate without guessing. Use these when you want one quick paste and no new file.

A fourth route exists but belongs to a different viewport. **Extract Reads in Selected Region...** appears on the right-click menu only when an alignment selection is present, and it pulls reads rather than reference sequence. The alignments chapters cover it.

## Procedure, copying and scanning

### Copy the visible region without a sheet

1. Frame the region as before.

2. Choose **Sequence > Copy Visible Region as FASTA** (Cmd-Shift-C). This item runs immediately and opens no dialog. It is the only item on the **Sequence** menu written without three trailing dots, and on macOS those three dots are the standard signal that an item will ask you something first.

3. Paste. The clipboard holds the visible bases with a FASTA header above them.

The shortcut is worth knowing but not worth relying on for an exact span, because the copy takes the visible region and the visible region is whatever the viewport settled on. When the base count has to be exact, use the command line.

### Mark candidate coding stretches with Find ORFs

An [open reading frame](../../GLOSSARY.md#open-reading-frame), or ORF, is a stretch running from a start [codon](../../GLOSSARY.md#codon) to a stop codon with no stop in between, which makes it a candidate protein-coding region. A codon is a run of three bases specifying one amino acid, and a [reading frame](../../GLOSSARY.md#reading-frame) is the offset those triplets are counted from. Six frames exist, three on each strand.

1. Open the bundle you want annotated and frame the HBB gene span as in the first procedure, because the scan covers the range the viewport is showing.

2. Choose **Sequence > Find ORFs...**. A panel titled Find ORFs opens.

    <!-- SHOT: find-orfs-dialog -->

3. Set the controls, which are grouped under Reading Frames, Translation, Output, and Options. Raise Minimum ORF length from its default of 100 to 300 for this record, because a human gene span this size returns a long list of short chance ORFs at the default. The Settings section below covers every control.

4. Click Run. LGE writes a new annotation track holding one feature per surviving ORF, each carrying its own translated protein alongside its coordinates. Select an ORF to read that protein in the Inspector.

The track behaves like the imported track beside it. Click an ORF to jump to it, and right-click it to copy or extract it through the routes above. To remove a whole track, open the annotation table drawer at the bottom of the viewport, choose **Delete Track...** from its track menu, and confirm the alert. The command line can do the same, which the last section covers.

## Settings

Four controls sit on the Extract Sequence sheet the visible-region route opens, and the flank fields carry preset buttons reading 100, 500, 1000, and 5000 that fill the field for you.

**5' Flank.** Adds this many extra bases upstream of the region, on the 5' side, so the extraction carries context the framing did not include. The default is 0, because the usual request is the region itself and nothing more. Raise it when the piece needs its surroundings, for example the primer-binding sequence just outside an amplicon. On the command line this is `--flank-5`.

**3' Flank.** Adds this many extra bases downstream of the region, on the 3' side. The default is 0, for the same reason. Raise it alongside 5' Flank when you want equal padding on both ends, which is what the `--flank` shorthand does on the command line. On the command line this is `--flank-3`.

**Reverse Complement.** Writes the extraction as its reverse complement, the same sequence read from the other [strand](../../GLOSSARY.md#strand). It starts off, because the region you framed is read from the plus strand and most reference work stays there. Turn it on when the gene you cut sits on the minus strand and you want its coding orientation. On the command line this is `--reverse-complement`.

**Concatenate Exons (remove introns).** Joins a multi-exon feature's pieces into one continuous sequence with the introns dropped, and appears only when the sheet's source is a spliced feature rather than a framed region. It starts on, because a spliced feature's useful product is the spliced sequence. In this release the menu routes always hand the sheet a framed region, so the control stays hidden and you will not meet it. This setting has no command-line flag.

Three more controls sit on the Extract Sequence sheet the annotation right-click opens, and the third of them is the button that runs the extraction.

**Destination.** Chooses where the extracted sequence goes, as four radio buttons. Save as Bundle is preselected, because a bundle is the form another LGE operation can consume. Pick Save to File... or Share... when the sequence is headed outside the app, and Copy to Clipboard for a quick paste into another program. This setting has no command-line flag.

**Name.** Names the new bundle or file the extraction creates. It arrives holding a name derived from the source region or the feature you right-clicked, which is descriptive enough to find again in most cases. Change it when the derived name will not tell this extraction apart from the next one. This setting has no command-line flag.

**Create Bundle / Save / Copy / Share.** Runs the extraction, under whichever of those four labels matches the destination you picked. It has no default because it is not a value, and its label changes as you move between destinations. Click it once the destination and the name read the way you want. This setting has no command-line flag.

Seven controls sit on the Find ORFs panel, grouped under its four headings.

**+1, +2, +3, -1, -2, -3.** Chooses which reading frames the scan covers, as one checkbox per frame under the Reading Frames heading. All six start checked, since a stretch you have not annotated could be coding on either strand at any of the three offsets. Uncheck the frames you already know are empty, for example when the sequence is a CDS you extracted yourself, which begins at its own first base and so can only be coding on `+1`. On the command line this is `--frames`, which takes a comma-separated list such as `+1,+2,+3`.

**Codon table.** Chooses the [genetic code](../../GLOSSARY.md#genetic-code) that decides which codons start an ORF and how each triplet translates. The default is `1 - Standard`, the code that covers nuclear genes including everything on the HBB record. Switch it for organelle or bacterial sequence, where table 2 covers vertebrate mitochondria and table 11 covers bacteria. On the command line this is `--table`.

**Minimum ORF length.** Discards any ORF shorter than this, counted in nucleotides rather than in amino acids. The default is 100 nucleotides, about 33 codons, which suits a short sequence such as a single small gene. Raise it on a long span like this record's gene cluster, where 300 keeps the list readable, and lower it when you are hunting a known short peptide. On the command line this is `--min-length`.

**Track name.** Sets the label the new track shows in the viewport and the annotation table, and this is the name you read. It arrives prefilled with the sequence name followed by ` ORFs`, so on this record it reads `NG_000007 ORFs`, which keeps the track traceable to what was scanned. Change it when one bundle will carry several ORF tracks and the names have to tell them apart. On the command line this is `--track-name`.

**Track ID.** Sets the internal identifier the bundle stores for the track, which is the name commands use rather than the name you read. It arrives prefilled with a generated id built from the same sequence name, in the form `orfs-<sequence>`, so on this record it reads `orfs-NG_000007`. Leave it alone unless you plan to name the track in a command later. On the command line this is `--track-id`.

**Include partial ORFs.** Keeps ORFs that run off either end of the scanned range instead of dropping them. It starts off, because an ORF with no visible stop cannot be scored the way a complete one can. Turn it on when you are scanning a fragment and a real gene is likely to be cut by the edge of it, which is the usual case on assembly contigs. On the command line this is `--include-partial`.

**Allow alternative starts.** Also treats the codon table's alternative start codons as starts, not only `ATG`. It starts off, which keeps the scan to the common case and the output short. Turn it on for bacterial sequence, where the standard `ATG` is joined by `GTG` and `TTG` as ordinary starts. On the command line this is `--allow-alternative-starts`.

## Reading the results

### The FASTA header

Every extraction carries its coordinates in its own header line, which is what lets you trace a loose file back to the record it came from. Extracting the HBB gene span gives this header.

```text
>NG_000007:70544-72152 [NG_000007:70544-72152] [1608 bp]
```

![An annotated breakdown of an extraction FASTA header showing its region name, coordinate token, and length token](../../assets/illustrations-imagegen/02-sequences/03-extracting-and-comparing/extraction-header-anatomy.png)

Three parts sit on that line. The leading token names the region. The bracketed coordinate token repeats it in `chrom:start-end` form. The bracketed length token reports how many bases came out, here 1608, which matches 72152 minus 70545 plus 1.

Both coordinate tokens print 70544 where you asked for 70545, because both print the start LGE counts internally from zero while you typed a start counted from one. The bases themselves are the ones you asked for, and only the printed start differs. The rule is to read the length token as the authority on how much sequence you got, and to add one to a printed start before comparing it against a coordinate you typed.

Three coordinate conventions appear across this chapter, and this table says which applies where.

| Where | Convention | The HBB gene span reads |
|---|---|---|
| Prose, the ruler field, `extract sequence` regions | 1-based, both ends included | 70545 to 72152 |
| FASTA header tokens | 0-based start, inclusive end | 70544 to 72152 |
| `annotate-orfs` `--start` and `--end` | 0-based start, end excluded | 70544 to 72152 |

Two more tokens appear when they apply. A flipped extraction adds `[reverse complement]`, and a feature stitched from several [exons](../../GLOSSARY.md#exon) would add `[exons concatenated]`, though no menu route in this release produces that stitching. A feature also contributes its feature type and then `[strand: +]` or `[strand: -]`, in that order.

Padding changes only the second token. Asking for the three bases of the sickle cell codon with 100 bases of context on each side gives this.

```text
>NG_000007:70612-70615 [NG_000007:70512-70715] [203 bp]
```

That leading token is the same three-base span the command block below asks for as `NG_000007:70613-70615`, printed with the 0-based start the table above describes. The bracketed token reports the padded span that was actually cut, and the length is 3 plus 100 plus 100.

### The new bundle

A bundle extraction is a complete reference bundle rather than a loose FASTA. It carries its own `manifest.json`, its own compressed FASTA with index files under `genome/`, and its own [provenance sidecar](../../GLOSSARY.md#provenance-sidecar). An index is a small companion file that lets the app jump straight to a position without reading the whole sequence first, and LGE writes one whenever it writes a bundle, so there is nothing for you to do with it. That sidecar records the exact command that produced it, the timestamp, the exit status, and one entry per input and output file carrying a SHA-256 [checksum](../../GLOSSARY.md#checksum) and a byte size. A checksum is a short string computed from a file's contents, recorded automatically so that anyone can prove the file has not changed since, and you never compute one yourself. A collaborator who opens the bundle a year later can read where it came from without asking you.

Because it is a full bundle, it behaves like one. Map reads against it with **Tools > Mapping > minimap2...**, attach annotations to it, or cut a smaller region out of it later.

### The ORF track

Running Find ORFs over the HBB gene span with the minimum length at 300 nucleotides gives one surviving ORF, on frame `+1`, from 70658 to 71060. That is 402 nucleotides, or 134 codons, and its translation starts `MKLVVRPWAGWYQGYKTGL`. Those are the exact numbers and the exact letters this record produces at those settings, so a run that differs was scanning a different range.

Compare that against the record's own curated CDS, which the flatfile writes as `join(70595..70686,70817..71039,71890..72018)`. That is the GenBank way of writing a spliced feature, one range per exon inside a `join`, with two dots between the ends of each range, and you never type it anywhere. Its three pieces add to 444 bases, which is 148 triplets, giving 147 amino acids plus a stop codon that is not itself an amino acid. The ORF scan found neither the right start nor the right end, and this is the expected result rather than a fault. An ORF scan reads the DNA straight through and knows nothing about introns, so on a spliced eukaryotic gene it reports the longest uninterrupted stretch it can see, which here happens to be an intron-spanning frame that reads open by chance.

That is the lesson the HBB record teaches better than any bacterial example would. An ORF track is a set of candidates, not a set of genes. Read it beside a curated track, never instead of one, and reach for a dedicated gene caller when you need real gene models. Prodigal and Prokka are two such programs, both separate command-line tools installed and run outside LGE.

### Extracting every feature of one type

The command-line route in the last section pulls whole feature sets at once. Running it over the record's imported track for the `gene` type gives eight records, each headed with its own source coordinates.

```text
>OR51AB1P source=NG_000007:5265-6149 strand=+
>HBE1 source=NG_000007:27671-29271 strand=+
>HBG2 source=NG_000007:42835-44428 strand=+
>HBG1 source=NG_000007:47759-49344 strand=+
>BGLT3 source=NG_000007:52070-53062 strand=+
>HBBP1 source=NG_000007:54024-55662 strand=+
>HBD source=NG_000007:63133-64778 strand=+
>HBB source=NG_000007:70545-72152 strand=+
```

Those headers use a different shape from the viewport extraction, with a `source=` token in 1-based coordinates and a `strand=` token. The HBB line reads `70545-72152`, matching the record's own gene span exactly.

Asking for the `CDS` type instead gives five records, because `BGLT3` is a long non-coding RNA and `HBBP1` is a pseudogene, so neither has one. The HBB CDS record comes out at 1,424 bases spanning 70595 to 72018. That is the outer span of the coding feature rather than the 444 spliced bases, because this command cuts a single interval from the first coordinate to the last. The CDS extraction uses the CDS feature's own first and last coordinates rather than the gene's, which is why 70595 to 72018 differs from the gene's 70545 to 72152. No window route in this release writes the spliced nucleotide sequence on its own, since the annotation right-click route never concatenates and the visible-region route only offers Concatenate Exons for a source the menus do not produce. Join the exons outside LGE when you need the spliced bases themselves.

## What good looks like

Four checks are worth running on any extraction before you hand it to something else.

Read the length token in the header and confirm it is what you meant to cut. On the HBB gene span that is 1608. A few dozen bases either way is the viewport's ordinary rounding, and anything more than a couple of hundred off means the viewport framed a wider view than the range you typed, so reframe and extract again.

Confirm the new bundle landed where its route puts it, under `Extractions/` for the visible-region route and under `Reference Sequences/` for the annotation route. Anything that turned up under `Imports/` came from a different operation than the one you thought you ran.

Confirm the first bases are the ones you expect. The HBB gene span opens `ACATTTGCTTCTGACACAACT`. The coding stretch opens `ATG GTG CAT CTG ACT CCT GAG GAG` when you split it into triplets, which reads start, valine, histidine, leucine, threonine, proline, glutamic acid, glutamic acid. The seventh triplet is the `GAG` at codon 6 that the sickle cell change turns into `GTG`, swapping that glutamic acid for a valine.

Confirm the provenance sidecar names the source you meant. An extraction whose sidecar points at a different bundle is an extraction from the wrong record, and the coordinates in its header will be meaningless against the reference you assumed.

When an ORF track is what you produced, apply one more check. Count the features. A scan of a small span that returns dozens of ORFs almost always has its minimum length set too low, and one that returns none on a span you know is coding usually has the wrong genetic code or the wrong frames selected.

## On the command line

This section is optional. The window covers everything above except pulling a whole feature set out in one go, which only the command line does. The command line is also the better route when the exact base count matters, because it cuts the range you name rather than the range the viewport settled on.

```bash
# Cut the HBB gene span out of an imported bundle's FASTA.
lungfish-cli extract sequence \
  ~/Documents/hbb-example.lungfish/"Reference Sequences"/HBB.lungfishref/genome/sequence.fa.gz \
  NG_000007:70545-72152 --line-width 70 -o hbb-gene.fasta

# Cut the sickle cell codon with 100 bases of context on each side.
lungfish-cli extract sequence \
  ~/Documents/hbb-example.lungfish/"Reference Sequences"/HBB.lungfishref/genome/sequence.fa.gz \
  NG_000007:70613-70615 --flank 100 -o codon6-context.fasta

# Pull every gene feature out of the imported track as its own record.
lungfish-cli bundle extract-annotations \
  --bundle ~/Documents/hbb-example.lungfish/"Reference Sequences"/HBB.lungfishref \
  --track imported_annotations --feature-type gene \
  --output-bundle ~/Documents/hbb-genes.lungfishref

# Scan the HBB gene span for ORFs and store them as a named track.
lungfish-cli sequence annotate-orfs \
  ~/Documents/hbb-example.lungfish/"Reference Sequences"/HBB.lungfishref \
  --sequence NG_000007 --start 70544 --end 72152 \
  --table 1 --min-length 300 --track-name "HBB ORFs" --track-id hbb_orfs

# Remove that track, which the annotation drawer can also do.
lungfish-cli sequence delete-annotation-track \
  ~/Documents/hbb-example.lungfish/"Reference Sequences"/HBB.lungfishref \
  --track-id hbb_orfs
```

The double quotes around `Reference Sequences` in those paths are shell syntax rather than a typo. They hold the folder name together despite the space in it.

`extract sequence` needs FASTA input and rejects a GenBank flatfile, so point it at the `genome/sequence.fa.gz` inside a bundle you already imported rather than at the `.gb` file. Its region argument is `name:start-end`, counted 1-based and inclusive. On a file holding one sequence you may leave the name off. `--line-width` sets the FASTA wrapping and defaults to 70. `--flank` pads both sides by the same amount, while `--flank-5` and `--flank-3` pad the upstream and downstream sides separately. `--reverse-complement` flips the result and adds `[reverse complement]` to the header. Output goes to standard output unless `-o` names a file.

Its two siblings cover the other extraction shapes. `extract contigs` pulls named contigs out of an assembly, taking `--assembly` or `--contigs` for the source, `--contig` repeated once per name or `--contig-file` for a list in a file, and `--bundle` to write a `.lungfishref` into the project instead of a loose FASTA. Its `--line-width` defaults to 60 rather than the 70 quoted above. `extract reads` pulls reads rather than sequence, which the reads chapters cover.

`bundle extract-annotations` needs `--bundle`, `--track`, and `--output-bundle`. `--track` accepts either the track ID or the display name, so `imported_annotations` and `"Imported Annotations"` both work. `--feature-type` picks which features to cut and defaults to `gene`, so pass `CDS` when you want the coding features instead. `--name-prefix` keeps only features whose name or gene name starts with a string, which is a prefix match and not an exact one, so `--name-prefix HBB` on this record returns two records rather than one, `HBB` and `HBBP1`. `--replace` overwrites an existing output bundle instead of stopping. Minus-strand features come out reverse-complemented so every record reads in its coding orientation.

`sequence annotate-orfs` scopes its scan with `--sequence`, which defaults to the first sequence in the bundle, plus `--start` and `--end`, which default to the whole sequence. Those two are 0-based with the start inclusive and the end exclusive, which is why the block above passes 70544 for a gene starting at 70545. The window's controls map to `--frames`, `--table`, `--min-length`, `--include-partial`, `--allow-alternative-starts`, `--track-name`, and `--track-id`, all covered in the Settings section.

`sequence delete-annotation-track` removes a whole track by `--track-id`, and `sequence delete-annotations` removes individual rows from one, taking `--track-id` plus one or more `--row-id` values.

## Next

Continue to [Aligning Sequences](04-aligning-sequences.md), which takes the extractions this chapter produced and lines them up column by column so the differences between them become visible.
