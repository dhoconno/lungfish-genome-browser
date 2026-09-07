---
title: When to Assemble
chapter_id: 07-assembly/01-when-to-assemble
audience: bench-scientist
prereqs: [01-foundations/02-sequencing-reads, 03-reads/01-importing-fastq]
estimated_reading_min: 28
task: Decide whether a sample needs de novo assembly or reference mapping, and pick which of the five assemblers LGE ships fits your reads.
tags: [assembly, spades, megahit, skesa, flye, hifiasm, de-novo]
tools: []
parameters_refs: []
entry_points:
  - "Tools > Assembly > SPAdes..."
  - "Tools > Assembly > MEGAHIT..."
  - "Tools > Assembly > SKESA..."
  - "Tools > Assembly > Flye..."
  - "Tools > Assembly > Hifiasm..."
shots:
  - id: assembly-submenu
    caption: "The Tools menu open on its Assembly submenu, showing the five assemblers as separate items, SPAdes..., MEGAHIT..., SKESA..., Flye..., and Hifiasm..."
  - id: assembly-sheet-assembler-picker
    caption: "The assembly sheet's Primary Settings, with the segmented Assembler picker above the Read Type row, which reads Illumina short reads with the note Locked from FASTQ header detection beneath it."
  - id: assembly-bundle-in-analyses
    caption: "An assembly run folder under the project's Analyses folder in the sidebar, with the .lungfishref bundle inside it selected and the assembly viewport open behind."
illustrations:
  - id: assembly-vs-mapping
    brief: "Side-by-side schematic. Left: reads being mapped to a known reference (read-to-genome arrows). Right: reads being assembled into contigs without a reference (overlap-then-extend cartoon producing a few long contigs). Use Lungfish Creamsicle for reads, Deep Ink for the reference and contigs."
glossary_refs: [accession, assembly-bundle, assembly-graph, blast, contig, coverage, de-novo-assembly, fastq, gc-content, l50, mapper, mitochondrial-genome, n50, operations-panel, paired-end, percent-identity, plugin-pack, read, read-length, reference-bundle, scaffold, shotgun, structural-variation]
features_refs: []
fixtures_refs: [human-mito]
brand_reviewed: true
lead_approved: true
---

## What it is

This chapter is the deciding chapter. It works out whether a sample needs assembling and which of the five assemblers fits your reads. The chapters after it run one end to end.

[De novo assembly](../../GLOSSARY.md#de-novo-assembly) rebuilds a sample's sequence out of its own [reads](../../GLOSSARY.md#read), with no reference genome anywhere in the calculation. A read is one short stretch of sequence the instrument produced, stored as one record in a [FASTQ](../../GLOSSARY.md#fastq) file. On their own the reads are a heap of fragments in no particular order.

An assembler works in three moves. It looks for places where the end of one read matches the start of another. It records every such overlap in an [assembly graph](../../GLOSSARY.md#assembly-graph), which here means a network of pieces joined by their overlaps rather than a plot or a chart. Then it traces paths through that network, joining reads end to end along each path, and writes out the long stretches those paths spell as [contigs](../../GLOSSARY.md#contig). "De novo" is Latin for "from new", and that is what makes the method different. The assembler is told nothing about what the sample should look like.

That is a different question from the one mapping asks. Mapping starts from a genome you have already named and asks where on it each read belongs. Assembly starts from nothing and asks what sequence the sample must carry for these reads to make sense at all. The two are complementary rather than competing, and the commonest working pattern in this manual runs them in that order, assembling to find out what a sample holds and then mapping against whatever the assembly turned up.

![Mapping with a reference contrasted against de novo assembly from read overlaps into contigs](../../assets/illustrations-imagegen/07-assembly/01-when-to-assemble/assembly-vs-mapping.png)

An assembly almost never comes back as one sequence per chromosome. A good assembly still usually holds many contigs, and expecting one per chromosome only leads to reading a good result as a bad one. The reason is a repeat, meaning a stretch of sequence that occurs more than once in the genome. When the assembler reaches the end of a repeat it finds two different reads matching that same end equally well, one from each copy, so the network offers two ways forward and the assembler stops rather than guessing which is right. A read long enough to span the whole repeat and carry unique sequence out the far side settles the question and bridges the gap. A read shorter than the repeat cannot, so the contig breaks in two there.

What you get is a set of contigs, sometimes a handful and sometimes many thousands, and judging an assembly is largely a matter of judging how badly it fragmented. The "What good looks like" section at the end of this chapter gives the counts to expect. A [mitochondrial genome](../../GLOSSARY.md#mitochondrial-genome) of a few tens of thousands of bases, sequenced at high [coverage](../../GLOSSARY.md#coverage), meaning many reads sit over each base, can come back whole, and this chapter shows one that does. That is the easy end of the range rather than the normal case.

Lungfish Genome Explorer (LGE) ships five assemblers behind one shared configuration sheet. You reach the sheet by picking a tool under **Tools > Assembly**, and it opens with that tool already chosen in its Assembler picker. Whichever one runs, the result is packaged the same way, as a `.lungfishref` [assembly bundle](../../GLOSSARY.md#assembly-bundle) inside a per-run folder under the project's `Analyses/` folder. A bundle is a folder of files that LGE shows and treats as one item, so you click it once in the sidebar rather than opening the files inside it. `Analyses/` is likewise a folder, visible in the LGE sidebar rather than something you type.

That bundle's internal structure is identical to a [reference bundle](../../GLOSSARY.md#reference-bundle), which is the folder LGE uses to hold any genome you work against. The two share the `.lungfishref` extension deliberately, because the formats are the same, and that is what makes a finished assembly usable as the input to later steps rather than a dead end. Those later steps are the ones the rest of this manual covers, chiefly viewing a contig as a sequence, mapping fresh reads back onto it, and calling variants against it.

What this asks of you is one decision before you open anything. Work out whether your sample actually needs assembling, because a great many do not, and then match the assembler to the kind of reads you have.

## Why you would do this

Three situations call for assembly, and it is worth being able to name which one you are in.

The first is a sample with no reference that fits. A novel virus is the clearest case, since nothing in the databases is the right genome. So is an organism whose closest relative in a public database is too distant, far enough that mapping leaves more than half your reads unaligned. And so is a contaminant you want to identify by assembling it first and then searching the contigs against a public database, which is what the **BLAST Contigs** button described later in this chapter does. In all three the mapping question cannot even be asked, because there is nothing sensible to map against.

The second is a sample where mapping would hide what you care about. Mapping forces every read into the reference's coordinate system, meaning the numbered positions running along the reference from one end to the other. That is exactly what makes mapping fast, and exactly what makes it lossy, meaning some of what your reads carry is thrown away in the process. Suppose your sample carries an insertion, a stretch of extra sequence that the reference does not have at all. Those numbered positions have no slot for it, so mapping cannot place it. Assembly has no coordinate system to force anything into, so the insertion simply appears in the contig at its real length.

The third is [structural variation](../../GLOSSARY.md#structural-variation), meaning a rearrangement large enough to move, duplicate, invert, or delete a whole block of sequence rather than change single bases. Against a reference these show up indirectly, as reads whose ends fail to align or as [paired-end](../../GLOSSARY.md#paired-end) reads landing implausibly far apart. Paired-end means each DNA fragment was read from both ends, so the two reads of a pair should land a known distance apart, and a pair that does not is evidence something moved. Reading that evidence takes practice. In an assembly the rearranged sequence is just there, written out, because the assembler had no reference telling it what order the blocks were supposed to come in.

Set against those, the case for not assembling is strong and often the right answer. When a good reference exists, mapping is faster, needs far less memory, gives you coverage at every position, and feeds variant calling directly. Variant calling means finding the positions where your sample differs from the reference, which is a question assembly does not answer on its own. Assembly answers a harder question and pays for it in compute, in memory, and in the work of interpreting a fragmented result. Use assembly only when mapping cannot answer your question, not by default.

## What LGE ships, and what it does not

Five assemblers arrive in one [plugin pack](../../GLOSSARY.md#plugin-pack), shown in the Plugin Manager as Genome Assembly, at roughly 950 MB installed. A plugin pack is a themed group of tools LGE installs on demand rather than bundling into the application. None of the five is present until that pack is installed, so if this is your first assembly, install it first. Open **Tools > Plugin Manager...** (Cmd-Shift-B), look at the **Packs** tab, and click **Install All** on the Genome Assembly card if it is not already installed. Leave the window open until the card finishes. [Plugin Packs and Databases](../01-foundations/07-plugin-packs.md) describes packs in full, including what to do when an install stops partway.

If you forget, the assembly sheet catches it for you. The sheet carries a Readiness panel at the bottom that reports whether the pack and the selected tool are present, and it names what is missing when they are not.

The versions are pinned, meaning fixed to one version rather than tracking whatever is newest, so an assembly you run today and one you run next year use the same code. This release ships SPAdes 4.3.0, MEGAHIT 1.2.9, SKESA 2.5.1, Flye 2.9.6, and hifiasm 0.25.0. The last of those is written in lower case by its own authors and this manual follows them, so where a menu item or a picker reads Hifiasm with a capital letter, it is the same single tool.

Once the pack is installed, each of the five appears as its own item in the **Tools > Assembly** submenu. There is no single Assembly command that then asks which tool you want, and picking an item is how you choose.

Select the reads you want to assemble in the project sidebar before you open a menu item, because the sheet takes whatever is selected when it opens and offers no file picker of its own. What you are looking for is a FASTQ bundle, which appears in the sidebar as one row bearing the sample's name, usually under the project's `Imports` folder. A paired-end sample is one row and not two, because LGE folds the two mate files into a single bundle when it imports them. Click that row once so it highlights, then open the menu item.

<!-- SHOT: assembly-submenu -->

Two assemblers are missing that people often expect. Canu is not here, having been largely overtaken by Flye for the long, error-prone reads an Oxford Nanopore instrument produces. Trinity is not here either, because it assembles transcriptomes, meaning the RNA a cell is actively expressing rather than its genome, and LGE exposes no transcriptome workflow for it to belong to.

The table below is the whole catalogue. Two of its columns need a word first.

The genome-size column is guidance from published practice rather than a limit the application enforces. Nothing in LGE checks your genome size or refuses a run because of it, and you will get no warning if you push a tool past where it works well. Its figures are in megabases, written Mb, where one megabase is a million bases. Kilobases, written kb, are a thousand bases each. Neither is a measure of file size, so Mb here has nothing to do with the 950 MB of megabytes above. For scale, the human mitochondrial genome used later in this chapter is 16,569 bases, or about 17 kb, a typical bacterial chromosome is around 5 Mb, and the human nuclear genome is about 3,100 Mb. To find the expected size for your own organism, look up its assembly record on NCBI, which states the total length of the deposited genome. If you already hold a reference bundle for that organism in LGE, select it and read **Total Length** in the Inspector.

The "Best for" column uses two words as opposites. A contiguous assembly is one with fewer, longer contigs, which is what you usually want. A conservative assembly is one that stops a contig whenever the evidence for joining is less than certain, giving more contigs, each of which you can trust further.

| Assembler | Read type it accepts | Best for | Practical size ceiling, not enforced by the app |
|---|---|---|---|
| SPAdes | Illumina short reads | Viral and bacterial isolates, meaning a sample grown from a single organism, and the usual first reach for short reads | around 10 Mb |
| MEGAHIT | Illumina short reads | [Shotgun](../../GLOSSARY.md#shotgun) metagenomes, meaning a sample whose whole DNA content is sequenced at random and which holds many organisms at once. See the reliability caution below before you pick it | no practical ceiling |
| SKESA | Illumina short reads | Bacterial isolates where a conservative assembly matters more than a contiguous one | around 10 Mb |
| Flye | Oxford Nanopore reads | Long-read assembly of anything from a virus to a bacterial chromosome | around 100 Mb |
| hifiasm | Oxford Nanopore or PacBio HiFi reads | High-accuracy long-read assembly | no practical ceiling |

MEGAHIT 1.2.9 fails most runs on Apple Silicon in this release. LGE already applies the two published workarounds, capping the tool to two threads, meaning two parallel streams of work, and disabling its hardware acceleration, and runs still stop partway more often than not, at a different stage each time. The failure appears as a nonzero exit code in the [Operations panel](../../GLOSSARY.md#operations-panel), the window that lists every run LGE has started, which you open with **Operations > Show Operations Panel** (Cmd-Shift-P). The run's row there is marked as failed and its log ends with an exit code, meaning a number the tool hands back when it stops, where zero means success and anything else means failure. No contigs are written. A run that does complete is correct, and its figures can be trusted. Rerunning is the only workaround, and the reruns made for this manual completed about one time in five. Use SPAdes or SKESA for a single-organism sample until it is fixed.

## How the sheet decides what you may run

The sheet does not offer you all five and let you pick wrongly. Every read in a FASTQ file begins with a header line, and sequencing instruments stamp their own identifying marks into it, so the first line of the file is usually enough to say what machine wrote it. The sheet reads that line, works out which class of instrument produced the reads, and narrows the Assembler picker to the tools that accept that class. A picker here is a row of buttons of which exactly one is selected at a time.

Select Illumina reads and the picker offers SPAdes, MEGAHIT, and SKESA. Select Oxford Nanopore reads and it offers Flye and hifiasm. Select PacBio HiFi reads and it offers hifiasm alone. The tools that do not fit are not greyed out, they do not appear at all. So a tool you expected to see may be absent simply because it does not take your kind of reads, which is a narrower and more recoverable problem than the tool having gone missing.

Beneath the Assembler picker sits a Read Type row, and what it shows tells you how the detection went. When the header identified the reads, the row is a plain label reading the detected class with the note "Locked from FASTQ header detection." underneath, and you cannot change it. Detection can also come back inconclusive, which happens when the header was rewritten before LGE saw it, most often by a trimming or filtering step, or by a colleague renaming reads before sending you the file. The row then becomes an editable picker offering all three classes and you tell it what you have. If you are unsure, the sequencing core's run report names the instrument, and so does the file name in many labs.

<!-- SHOT: assembly-sheet-assembler-picker -->

Two selections the sheet refuses outright are worth knowing before you make one. From here on, a FASTQ bundle means one of the read bundles you feed in, to keep it apart from the assembly bundle that comes out. Selecting FASTQ bundles from more than one kind of instrument at once blocks the run with the message "Hybrid assembly is not supported in v1. Select one read class per run." Hybrid assembly, meaning combining short and long reads into a single assembly to get the accuracy of one and the contiguity of the other, is a real technique that this version does not do. Mixing FASTQ bundles the sheet could classify with bundles it could not gives a second, similar block, "Selected FASTQ inputs mix detected and unclassified read classes. Select one read class per run." The "v1" in both of those is the app's own wording for this version of the feature, quoted here exactly as it appears on screen.

Selecting several FASTQ bundles at once behaves differently for the two groups. For SPAdes, MEGAHIT, and SKESA a Run Mode picker appears, and it is disabled rather than broken. It shows one option, which runs each bundle as its own separate assembly, and it will not let you choose anything else. Pooling several bundles into one assembly is not supported yet, and the sheet shows the locked control and says why rather than quietly deciding for you. Flye and hifiasm reject a multi-file selection before you get that far, with a message that long-read assembly expects a single FASTQ input in this version.

## Working out which assembler you want

Three questions, in this order, settle it nearly every time.

**Does a reference fit my sample?** A reference fits when your sample is close enough to it that most reads align. Published practice puts that somewhere above roughly 95% [identity](../../GLOSSARY.md#percent-identity) across most of the reference's length, which is a working rule of thumb rather than a threshold LGE checks or enforces. Percent identity is the share of positions that match between two sequences, and you do not have to estimate it by eye. A mapping run reports it in the summary that [Mapping Reads to a Reference](../04-alignments/01-mapping-reads-to-a-reference.md) walks through, alongside the share of reads that aligned at all. A [BLAST](../../GLOSSARY.md#blast) search reports it too, on each hit, where a hit is simply the best match a search returned. If the nearest hit is a different genus, or if a trial mapping leaves more than half your reads unaligned, no reference fits and assembly is the tool. If a reference does fit, map instead. Assemble anyway only when you suspect structural variation the mapping is concealing.

**Are my reads short or long?** This question overrides the next one, because it is a hard constraint rather than advice. Illumina reads are short, with a [read length](../../GLOSSARY.md#read-length) of tens to a few hundred bases, and they go to SPAdes, MEGAHIT, or SKESA. Oxford Nanopore reads are long, thousands to tens of thousands of bases, and they go to Flye or hifiasm. PacBio HiFi reads are long and unusually accurate, and they go to hifiasm. Long reads change what assembly can do, because a read that spans a repeat resolves it outright rather than breaking the contig there.

Accuracy differs between the three in a way worth naming. Illumina and PacBio HiFi both make well under one error per hundred bases. Oxford Nanopore makes a few per hundred. Where that matters is in reading a finished contig base by base, since a nanopore assembly's individual positions are less trustworthy than its overall shape, and it matters least where long reads earn their keep, which is deciding what order the blocks of a genome come in.

**Is my sample one organism or many?** Among the short-read three, SPAdes is the default and assumes a single dominant organism, which is right for an isolate and for a virus. MEGAHIT assumes the opposite, that the sample is a mixture at wildly different abundances, as a stool or swab sample is, where a few species are common and hundreds are rare. Published guidance is that MEGAHIT uses less memory than SPAdes on samples of that kind, which is the usual reason people reach for it, though no measurement in this manual tests that. SKESA is NCBI's isolate assembler and is deliberately cautious, preferring to stop a contig rather than risk joining two stretches that only look joinable, which yields more contigs and fewer wrong ones.

A worked example. Suppose you have a clinical bacterial isolate sequenced on a Nanopore instrument, with no Illumina reads to fall back on. The first question sends you to assembly, since you want the chromosome as it actually is, rearrangements included. The second question says your reads are long, which rules out all three short-read tools and leaves Flye and hifiasm. The third question reads as isolate territory, which on short reads would have pointed at SKESA, but SKESA cannot take Nanopore reads at all, so it never enters. The answer is Flye. Read length is the constraint you check first for exactly this reason.

## Two assemblers on the same human reads

The comparison below uses the HG002 mitochondrial reads, a fixture this manual ships. A fixture is a small sample dataset committed alongside the manual so anyone can repeat what a chapter shows, and this one lives in the manual's `fixtures/human-mito` folder in the project's public repository.

They are Illumina reads from HG002, the reference individual of the Genome in a Bottle consortium, whose DNA is characterised in more detail than almost any other sample and so is used as a benchmark everywhere. The reads come from the mitochondrial chromosome and were thinned to about 300-fold coverage, meaning reads were discarded at random until roughly 300 remained over each base. What was left is 9,958 read pairs, which is 19,916 individual reads, since each pair is two paired-end reads of one fragment. Three hundred-fold is far more coverage than assembly needs, which is part of why this fixture assembles cleanly.

The human mitochondrial genome is 16,569 bases and circular, and it is published under the NCBI [accession](../../GLOSSARY.md#accession) `NC_012920.1`, a permanent identifier for one deposited sequence. So there is a known right answer to check any assembly against. That combination, a small genome sequenced deeply with a reference to compare against, is why this fixture opens the assembly part.

Both runs below were made for this chapter on 2026-09-06 and 2026-09-07 against those reads.

SPAdes returned **one contig of 16,697 bases**, with an [N50](../../GLOSSARY.md#n50) of 16,697, an [L50](../../GLOSSARY.md#l50) of 1, and 44.4% [GC content](../../GLOSSARY.md#gc-content), in 13.7 seconds. GC content is the share of bases that are G or C rather than A or T, and its one everyday use here is as a fingerprint. A contig whose GC differs sharply from the rest often came from a different organism. SKESA returned **one contig of 16,570 bases**, the same N50 and L50, the same 44.4% GC, in 1.6 seconds. Both reconstructed the genome end to end.

Ignore the gap in run times. It is real at this scale but it says nothing about which answer is better, and a run time is not a check on a result. The same SPAdes command took 110.7 seconds in another author's run on a busy machine, against the fixture's committed 13.7 seconds, on identical reads producing identical contigs. What run time does track is the size of the job, so a larger genome takes correspondingly longer on any of these tools.

Two figures come out of the comparison, and they measure different things. The gap between the two assemblies is 127 bases, which is SPAdes' 16,697 minus SKESA's 16,570. Measured instead against the 16,569-base published reference, SKESA is one base over and SPAdes is 128 bases over, which on a 16,569-base genome is about 0.8%. So 127 compares the two assemblies to each other, and 128 compares SPAdes to the reference. Neither result is wrong, and neither is a defect in the fixture.

A circular genome has no beginning, so an assembler tracing a circular path has to cut it somewhere to write out a linear contig, and the sequence either side of that cut is easy to write out twice. SKESA labels its contig `[topology=circular]` in the FASTA header, meaning it recognised the circle and trimmed the overlap almost exactly. That header is the contig's own name line inside the file, and in LGE you read it in the assembly viewport, in the detail pane that opens beside the contig table when you select a row. SPAdes writes the overlap out instead. This is the single most common reason an assembled organelle or plasmid comes back slightly longer than its published length. Do not read a 0.8% overshoot as a real insertion.

The lesson generalises past this fixture. Two assemblers given identical reads produce different answers because they carry different assumptions, and the difference is informative rather than a sign that one of them failed. Match the assumption to your sample.

MEGAHIT is absent from this comparison for the reason given in the catalogue above. MEGAHIT 1.2.9 fails most runs on Apple Silicon in this release, the failure appears as a nonzero exit code in the Operations panel with no contigs written, a run that does complete is correct, and rerunning is the only workaround.

## What the numbers mean

Two statistics dominate every assembly report, and both are easy to misread.

**N50** is a length. Stated plainly, it is the contig length at which contigs of that length or longer account for half of all the bases you assembled. The procedure that gets you there is to sort your contigs longest to shortest, add up their lengths from the top of the list downwards, and stop at the first contig where the running total reaches half the assembly's total length. That contig's length is the N50. That is exactly how LGE computes it.

Here is the arithmetic on a real, small example. One MEGAHIT run of the same HG002 mitochondrial reads, the run that produced the figures quoted in [Running SPAdes](02-running-spades.md), returned three contigs of 16,711, 362, and 332 bases, which total 17,405 bases. Half of 17,405 is 8,702.5. Sorted longest first, the running total after the first contig alone is 16,711, which has already passed 8,702.5. So the walk stops on the first contig, and the N50 is 16,711 bases.

What makes N50 more useful than an average contig length is that it is weighted by length. Every assembly picks up a scatter of short, low-value contigs, which is ordinary and not a sign of trouble, and those barely move the N50 while dragging an average down. A genuinely fragmented assembly drags the N50 down hard. Higher is better, and how much better depends entirely on the genome. On the SPAdes result above, the N50 is the full 16,697 bases because the single contig is the whole assembly.

**L50** is a count, and its similar name causes more confusion than any other pair of terms here. It is the number of contigs you had to walk through to reach that same halfway point. In the three-contig example above the walk stopped on the first contig, so the L50 is 1. An L50 of 1 means one contig holds half the assembly, which is as good as it gets. An L50 of 400 means it took 400 contigs to account for half the bases, which describes a badly fragmented result. N50 going up and L50 going down are the same piece of good news said two ways.

There is no threshold that separates a good N50 from a bad one across all genomes, and any number offered as one is wrong. What you compare against is the genome you were trying to assemble. An N50 near the full genome length on a small circular genome, as above, means it came back whole. An N50 of 50 kb on a bacterial chromosome of 5 Mb is a perfectly ordinary short-read result. The same 50 kb on a viral genome of 30 kb would be impossible, since a contig is built out of the genome it came from and so cannot be longer than that genome, and a figure like that means the assembly is not of what you thought it was.

## Where the result lands

Every assembler writes a `.lungfishref` assembly bundle into a per-run folder under the project's `Analyses/` folder. The folder is named for the tool and the moment the run started, and LGE writes that name for you. It reads as the year, then the month, then the day, then a `T`, then the hour, minute, and second, so a run started at ten past two in the afternoon on 7 September 2026 gives `spades-2026-09-07T14-23-10`. Nothing there is typed by you. A run across several bundles at once uses `spades-batch-` followed by the same timestamp, with the individual assemblies inside it.

Assemblies live alongside classifications, mappings, and every other analysis result under `Analyses/`, which is what lets several assemblies of the same reads sit side by side without any of them overwriting another.

<!-- SHOT: assembly-bundle-in-analyses -->

The bundle appears in the sidebar as one item rather than as a list of contigs. Opening it opens the assembly viewport, which has three parts. A summary strip along the top carries the whole-assembly figures, which are the assembler, the read type, the contig count, total bp, N50, L50, the longest contig, and the global GC percent. Here bp is short for base pairs and means the same as bases everywhere else in this chapter. Two further fields sit at the end, the tool version and the wall time, which is the elapsed real time the run took from start to finish. All five assemblers record both, so both appear on any assembly LGE made. They are absent only on an older bundle made before LGE recorded them.

A table below the strip lists the contigs one per row, ranked longest first, with columns for rank, contig name, length in bases, GC percent, share of the assembly as a percentage, and a preview of the sequence. The share is of the total assembled bases rather than of the contig count, so on a single-contig assembly it reads 100%. The preview shows the contig's first 80 bases, which is enough to recognise a sequence and not enough to read one, so anything more comes from the detail pane. Selecting a row fills that detail pane beside the table with the contig's header, its length, its GC, its rank, its share, and its full sequence.

Note that the ranking is the table's doing, not the file's. The bundle's FASTA holds the contigs in whatever order the assembler wrote them, and while SPAdes and MEGAHIT happen to write theirs longest first, Flye and hifiasm make no such promise. The table sorts by length regardless, so row 1 is the longest contig whichever tool produced it.

A [scaffold](../../GLOSSARY.md#scaffold) file also lands in the run folder for the assemblers that produce one. Scaffolds are contigs that the assembler has ordered and oriented relative to one another using paired-end information, with runs of `N` characters standing in for the gaps between them, where `N` means a base whose identity is unknown. LGE builds the bundle from the contigs rather than the scaffolds, so what you browse in the viewport is the unscaffolded set. The scaffold file needs no action from you, and you can ignore it unless a later analysis outside LGE asks for it specifically.

From the viewport an assembly feeds the rest of your work. Selecting contigs and using **Create Bundle** in the action bar beneath the table derives a reference bundle from them, which is how a contig reaches a sequence viewport. The action bar is the only route to that, so double-clicking or dragging a contig row does nothing, and the [Extracting Contigs](04-extracting-contigs.md) chapter covers the path in full. The same action bar carries **BLAST Contigs** for identifying what assembled, along with **Copy FASTA** and **Export FASTA**.

A bundle derived this way then serves as a mapping target for a fresh run under **Tools > Mapping**, which is how you get back to per-position coverage and variant calling on a genome that had no reference to begin with. Four [mappers](../../GLOSSARY.md#mapper) sit in that submenu. minimap2 handles long reads and is the usual choice for Nanopore or PacBio data. BWA-MEM2 and Bowtie2 are both long-established short-read mappers. BBMap is a short-read mapper that tolerates a more divergent reference than the other two. [Mapping Reads to a Reference](../04-alignments/01-mapping-reads-to-a-reference.md) makes the choice properly.

Two more behaviours are worth knowing. Right-clicking an assembly bundle in the sidebar offers **Reassemble...**, which reopens the sheet against the same reads so you can change a setting and run again. It appears only on bundles LGE assembled itself, because only those carry the record of which reads and settings produced them. A reference bundle you imported or downloaded has no such record and shows no Reassemble item.

And an assembler can finish cleanly while producing nothing at all, which LGE records as a distinct outcome rather than as either success or failure. The viewport says so in place of the contig table, reading "Assembly completed, but no contigs were generated." That is the expected result from too few reads or coverage too thin to find any overlaps, and the fix is more sequencing rather than a different setting.

## What good looks like

Four checks tell you an assembly is worth building on.

1. The run finished and produced contigs. A run that finished with none shows "Assembly completed, but no contigs were generated." in the viewport, which means the reads carried too little overlapping sequence to assemble.
2. The total assembled length is close to the published length of the genome you expected, as the fixture's 0.8% overshoot is. Look that length up on the organism's NCBI assembly record, or read **Total Length** in the Inspector if you already hold a reference bundle for it. Far short means the reads did not cover the genome. Far over, on a small circular genome, is usually the overlap artefact described above rather than extra sequence.
3. The contig count and N50 are consistent with the read type and the genome. A small circular genome sequenced deeply, like the mitochondrial fixture above, should come back as one contig or a very few. A short-read bacterial assembly landing in the tens to low hundreds of contigs is ordinary. A short-read assembly of a large eukaryotic genome runs to thousands and is still normal. Tens of thousands of contigs on a sample you believed was one organism says it was not, or that coverage was too thin.
4. The tool that ran is the tool you meant. The summary strip names the assembler and its version, which matters most after a run where the picker narrowed its choices because the detected read class ruled some tools out.

When an assembly disappoints, suspect coverage before the assembler. Too few reads is the commonest cause of a fragmented result, and no amount of changing tools compensates for sequence that was never there. To see how much you have, select the FASTQ bundle and read **Read Count** in the Inspector, then judge it against the genome you expected, since coverage is roughly the total bases in your reads divided by the genome's length. The fixture above sits at 300-fold, which is generous. As published practice rather than a figure this manual measured, a short-read assembly is usually workable from about 30-fold and struggles below 10.

## Next

Continue to [Running SPAdes](02-running-spades.md), which walks a short-read assembly end to end and covers MEGAHIT and SKESA in the same sheet. [Running Flye or hifiasm](03-running-flye-or-hifiasm.md) does the same for long reads and shows when each of the two is right. [Extracting Contigs](04-extracting-contigs.md) then covers picking contigs out of a finished assembly and deriving a bundle you can use as a reference downstream.
