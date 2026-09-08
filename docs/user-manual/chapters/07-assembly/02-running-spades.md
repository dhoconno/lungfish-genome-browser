---
title: Running SPAdes
chapter_id: 07-assembly/02-running-spades
audience: bench-scientist
prereqs: [01-foundations/07-plugin-packs, 03-reads/01-importing-fastq, 07-assembly/01-when-to-assemble]
estimated_reading_min: 30
task: Assemble Illumina paired-end reads with SPAdes, MEGAHIT, or SKESA and read the contigs the run produces.
tags: [assembly, spades, megahit, skesa, illumina, de-novo, contigs, n50]
tools: [spades, megahit, skesa]
parameters_refs: [assemble.spades, assemble.megahit, assemble.skesa]
entry_points:
  - "Tools > Assembly > SPAdes..."
  - "Tools > Assembly > MEGAHIT..."
  - "Tools > Assembly > SKESA..."
  - "CLI: lungfish-cli assemble"
shots:
  - id: assembly-wizard-spades
    caption: "The assembly sheet opened from Tools > Assembly > SPAdes..., showing the read-only Inputs rows, the Assembler and Read Type controls at the top of Primary Settings, the Isolate profile, and the Readiness panel at the bottom."
  - id: assembly-advanced-settings
    caption: "The sheet's Advanced Settings section with the Curated extra arguments disclosure expanded, showing the Careful mode and Skip error correction toggles above the Extra arguments field."
  - id: assembly-viewport
    caption: "The assembly result viewport after the HG002 mitochondrial run, with the contig table open and the Inspector's Assembly Context block reporting one contig, 16697 total bp, and an N50 of 16697 bp."
  - id: contig-detail-pane
    caption: "The detail pane for the longest contig, showing its header, length, GC percent, rank, share of the assembly, and sequence."
illustrations: []
glossary_refs: [amplicon, assembly-bundle, assembly-graph, bundle, conda, contig, coverage, de-bruijn-graph, de-novo-assembly, error-correction, fastq, gc-content, k-mer, l50, mitochondrial-genome, n50, operations-panel, paired-end, plugin-pack, read, reference-bundle, scaffold]
features_refs: []
fixtures_refs: [human-mito]
brand_reviewed: true
lead_approved: true
---

## What it is

SPAdes, short for St. Petersburg genome assembler and said as "spades", is a program that takes sequencing [reads](../../GLOSSARY.md#read) and reconstructs the longer stretches of DNA they came from, using only the reads. A read is one short piece of sequence the instrument produced, typically a couple of hundred bases long. Short reads of this kind come from one family of instruments, and the long reads named later in this chapter come from a different family that reads thousands of bases at a time. The pieces SPAdes builds are [contigs](../../GLOSSARY.md#contig), which are continuous stretches of assembled sequence with no gaps inside them. A contig is longer than any single read and usually far shorter than a whole chromosome. Doing this without a reference genome to line the reads up against is called [de novo assembly](../../GLOSSARY.md#de-novo-assembly), and the previous chapter covers when that is the right thing to want.

How SPAdes does this is worth understanding, because it explains most of what can go wrong. A [k-mer](../../GLOSSARY.md#k-mer) is a substring of exactly k bases cut out of a longer sequence, so the read `ACGTA` yields the 3-mers `ACG`, `CGT`, and `GTA`. Two 3-mers join when the last two bases of one are the first two bases of the next, so `ACG` joins `CGT` because both contain `CG`, and `CGT` joins `GTA` because both contain `GT`. In general two k-mers join when they share k minus 1 bases in that way. SPAdes cuts every read into k-mers and builds a [de Bruijn graph](../../GLOSSARY.md#de-bruijn-graph), which is a network in which each k-mer is a point and joined k-mers are connected. Where the reads agree, the graph is a single unbranching path. Where they disagree, because of a sequencing error or a repeated region of the genome, the path branches. SPAdes removes the branches that look like errors, which are the ones supported by very few reads, and then follows each remaining path that has only one route through it. Each path it completes becomes one contig. The real program runs this whole procedure at several k values and merges the answers, and you never choose k yourself. On the fixture reads SPAdes chose six values, 21, 33, 55, 77, 99, and 127, so the shortest pieces it compared were 21 bases long and the longest 127.

Lungfish Genome Explorer (LGE) runs SPAdes through an assembly sheet reached from **Tools > Assembly > SPAdes...**. The same sheet runs MEGAHIT and SKESA, the other two assemblers LGE includes for short reads, so this chapter covers all three. They differ in their presets, meaning their named bundles of settings, and in a few starting values rather than in how you drive them. When a run finishes, LGE writes an assembly result into a per-run folder under the project's `Analyses` folder. The result appears as one sidebar row. Selected contigs can later become a `.lungfishref` [reference bundle](../../GLOSSARY.md#reference-bundle) through **Create Bundle**. Opening the result shows the assembly viewport, which ranks the contig list by length and shows each contig's length, [GC content](../../GLOSSARY.md#gc-content), and share of the assembly, with a sequence preview. GC content is the fraction of bases in a sequence that are G or C rather than A or T.

Here is what to do with this. Run SPAdes on a small single-organism library and do not change any setting the first time, then read the contig count and the longest contig against what you expected the genome to be. Those two numbers tell you almost everything about whether the assembly worked.

## Why you would do this

You assemble when you want the sequence itself rather than a list of differences from something already known. Mapping reads to a reference tells you where your sample departs from that reference, which is fast and precise, and it cannot detect anything the reference does not contain. An assembly does not have this limitation, because it is built only from your own reads.

The clearest case is a genome you have no good reference for. A new isolate, an organism nobody has deposited, or a plasmid you engineered yourself. A plasmid is a small circular piece of DNA that lives inside a bacterial cell alongside its main chromosome. A second case is a genome you do have a reference for but suspect has been rearranged, because a large insertion or a structural change shows up plainly as an unexpected contig and only obliquely as a [coverage](../../GLOSSARY.md#coverage) anomaly on a mapped alignment. Coverage is the number of reads stacked over a given position in the genome, and some tools call the same quantity depth. A third case is simple confirmation. You believe your sample contains one organism, you assemble, and if one contig comes back at the length you expected then you have independent evidence rather than an assumption.

This chapter assembles the HG002 mitochondrial reads, a paired-end Illumina library covering the human [mitochondrial genome](../../GLOSSARY.md#mitochondrial-genome). HG002 is a widely used reference human sample whose sequence many laboratories have measured. Mitochondria are the compartments inside a cell that make most of its usable energy, and they carry a small circular chromosome of their own, separate from the chromosomes in the nucleus. In humans that chromosome is 16,569 bases long, which is small enough that a whole assembly finishes in seconds on a laptop and large enough to be a real genome rather than an artificial example. [Paired-end](../../GLOSSARY.md#paired-end) means the instrument read each DNA fragment from both ends, so one fragment produces two reads that travel together as mate files. The fixture holds 9,958 such pairs. A fixture here is the practice dataset supplied with this manual. Those 9,958 pairs assemble cleanly because the target genome is only 16.6 kb, which gives about 122-fold coverage as the finished contig's own name reports. What matters is the coverage rather than the raw read count, and the same number of pairs spread over a larger genome would not be enough. The right answer is known in advance, so you can see plainly what each assembler gets right and where they disagree with each other.

## Before you start

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. Pick a new empty folder, such as one called `assembly-practice` on your Desktop, so the project has the place to itself.

This chapter uses the HG002 mitochondrial reads. Download the fixture folder from the manual's fixtures on GitHub at

https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/human-mito

GitHub offers no download for a single folder, so open the repository's front page at https://github.com/dhoconno/lungfish-genome-explorer, click the green **Code** button, choose **Download ZIP**, double-click the downloaded file to unpack it, and find the folder inside it under `docs/user-manual/fixtures/`. The folder you want is named `human-mito`. The two files you need from it are `HG002.chrM_R1.fastq.gz` and `HG002.chrM_R2.fastq.gz`. These are the two mate files of one paired-end run. Import them as they are, since LGE reads gzipped FASTQ directly and nothing needs unzipping first. Follow [Importing FASTQ](../03-reads/01-importing-fastq.md), which groups the two mate files into one bundle, meaning one row in the sidebar holding both. That row is named `HG002.chrM`, the part of the file names the two share.

All three assemblers arrive in the `assembly` [plugin pack](../../GLOSSARY.md#plugin-pack), which the Plugin Manager lists as **Genome Assembly**. A plugin pack is a themed group of tools LGE installs when you first ask for a tool, into private [conda](../../GLOSSARY.md#conda) environments, meaning each tool gets its own isolated copy of the software it needs so one tool cannot interfere with another tool's software. Open **Tools > Plugin Manager...** (Cmd-Shift-B), look at the **Packs** tab, and click **Install All** on the Genome Assembly card if it is not already installed. Install All downloads the tools, so the Mac needs a network connection, and the pack occupies about 950 MB once installed. The pack fixes the versions at SPAdes 4.3.0, MEGAHIT 1.2.9, SKESA 2.5.1, Flye 2.9.6, and hifiasm 0.25.0, so everyone running this chapter runs the same versions. [Plugin Packs and Databases](../01-foundations/07-plugin-packs.md) describes packs in full.

The SPAdes run committed with this fixture took 13.7 seconds, and MEGAHIT and SKESA on the same reads took under three seconds each. Treat those as a rough guide rather than a target. The same SPAdes command took 110.7 seconds in the author's own run on a machine that was busy with other work at the time, with byte-identical results, so wall time is not a check on whether a result is right and cannot be scaled from a core count. Two numbers on your own Mac do set the Threads and Memory Limit defaults described below. Open the **Apple menu**, choose **About This Mac**, and read the **Chip** line for the core count and the **Memory** line for the installed memory.

## Procedure

Every number quoted below came from real runs made on 2026-09-07 against the fixture reads. Your figures should match these to within a few bases rather than exactly, because a different machine, a different thread count, or a later tool version can shift a contig boundary slightly. A difference of tens of bases in a contig length is ordinary. A different contig count is not, and the What good looks like section says what to make of one.

### 1. Open the sheet

1. Click the bundle holding the HG002 mitochondrial reads in the project sidebar to select it, the row named `HG002.chrM`. A paired bundle appears as one row rather than two, because LGE groups the two mate files into a single bundle when it imports them.

2. Choose **Tools > Assembly > SPAdes...**. The assembly sheet opens with SPAdes already chosen in the Assembler picker at the top of Primary Settings. Assembly is a submenu with one item per assembler, so SPAdes, MEGAHIT, SKESA, Flye, and Hifiasm are five separate menu items into the same sheet rather than one shared entry point.

3. Read the **Inputs** section at the top. It shows the dataset you selected, its read layout, and the detected read class in three rows. These are read-only. To assemble a different bundle, close the sheet, select that bundle in the sidebar, and open the menu item again.

    <!-- SHOT: assembly-wizard-spades -->

4. Check the **Read Type** row in Primary Settings. LGE reads the first FASTQ header, the identifier line that sits above each read's sequence, to work out which sequencing chemistry produced the reads. When the answer is clear the row is a locked label, meaning text you cannot change, with the caption "Locked from FASTQ header detection." beneath it. For the fixture it reads Illumina short reads. When the headers give no clear answer the row becomes a picker you must set before Run turns on. In that case take the chemistry from whoever ran the instrument, or from the sequencing facility's report that came with the files, since the reads themselves no longer say.

5. Leave the **Profile** popup on **Isolate**, which is the preset for a sample believed to hold one organism, and do not change any other control for a first run. The Settings section below is reference material to return to later rather than something to read first.

Look at the **Readiness** panel at the bottom of the sheet before you click anything. It reports the managed tool status for the assembler you picked, saying that it is checking the Genome Assembly pack while it looks and naming the state once it knows. Run stays disabled until the pack is installed and its smoke test, a quick check that the tool actually launches, has passed. The check takes a few seconds on an installed pack. If it never passes, reinstall the pack from the Plugin Manager, which [Plugin Packs and Databases](../01-foundations/07-plugin-packs.md) covers. When Run is disabled for some other reason, a short line under the panel says exactly which one, such as "Select at least one FASTQ input." or "Project name is required."

### 2. Run it

Click **Run**. The sheet closes and a row appears in the [Operations Panel](../../GLOSSARY.md#operations-panel), which you open with **Operations > Show Operations Panel** (Cmd-Shift-P). LGE first checks whether it needs to materialise the FASTQ files, meaning write the full read set back out to disk. Some bundles are derived, meaning LGE built them from other reads by an earlier step such as trimming, and a derived bundle stores only a short preview of its reads rather than all of them. The bundle you just imported is not derived, so this step finishes at once for the fixture. LGE then launches SPAdes inside its own conda environment and streams the tool's own output into the panel as it works. The complete text is also saved as `assembly.log` in the run folder, so you can read the whole log later.

The reference run reported this on completion. Every term in it is explained under Reading the results below.

```text
Assembly Results

Contigs       : 1
Total length  : 16697 bp
N50           : 16697 bp
Largest contig: 16697 bp
GC content    : 44.4%
```

The published length of the human mitochondrial genome is 16,569 bases, so a total length of 16,697 is the right order of answer at this point.

When the row finishes, find the result in the sidebar. It is a folder inside the project's `Analyses` folder, named with the tool and the date and time in the shape `<tool>-2026-09-07T14-23-10`, where the letter `T` separates the date from the time. Every run gets its own timestamped folder, so a SPAdes result and a MEGAHIT result on the same reads sit side by side without either overwriting the other. The sidebar presents the result as one row rather than a folder with a nested bundle. Double-click that row to open the assembly result viewport.

<!-- SHOT: assembly-viewport -->

## Settings

This section is reference material. Read it when a control puzzles you rather than before your first run.

The sheet carries eleven controls with SPAdes selected, arranged in four sections. Thirteen entries follow, because Profile is documented twice, once for SPAdes and once for MEGAHIT, and because Output Folder is a read-only row rather than a control you can set. Some controls appear only for certain assemblers, and each entry says which. The **Assembler**, **Read Type**, **Threads**, **Min Contig**, **Extra arguments**, **Project Name**, and **Run Mode** controls are shared, appearing for SPAdes, MEGAHIT, and SKESA alike, so they are documented once. **Memory Limit** appears for all three of these assemblers but not for the two long-read tools. Each entry ends with a short sentence naming the command-line flag that does the same job. Those closing sentences belong to the optional command-line section at the end of this chapter, so skip them if you are staying in the window.

Both sliders in this section show their own resolved number beside them, so you never need to look a figure up before you move one.

One caution before you change the Assembler. MEGAHIT 1.2.9 is unreliable on Apple Silicon. LGE already applies the two published workarounds, capping it to two threads and turning off its hardware acceleration, and runs still stop partway more often than not, at a different stage each time. The failure appears in the Operations Panel as a nonzero exit code with no contigs written. The MEGAHIT figures in this chapter come from a run that completed, and a run that does complete is correct. If yours stops, that is the known fault rather than anything you did, and rerunning is the only workaround. Use SPAdes or SKESA for a single-organism sample until it is fixed.

**Assembler.** Picks which assembler runs the job, as a row of connected buttons at the top of Primary Settings where only one can be selected at a time. It arrives set to whichever tool you chose from the menu, and the row lists only the assemblers that accept the read class LGE detected, so an Illumina bundle offers SPAdes, MEGAHIT, and SKESA while a Nanopore bundle offers Flye and Hifiasm. Switch it when you want to compare two assemblers on the same reads without closing the sheet. Read the caution above before you switch it to MEGAHIT. On the command line this is `--assembler`.

**Read Type.** States which sequencing chemistry produced the reads, which is what decides the assembler list above it. It arrives as a locked label carrying the class LGE read off the FASTQ headers, one of Illumina short reads, ONT reads, or PacBio HiFi/CCS. ONT is Oxford Nanopore Technologies and PacBio is Pacific Biosciences, the two long-read instrument makers, and HiFi and CCS are two names for PacBio's most accurate read type. The row only becomes a picker when the headers give no clear answer, and you must set it by hand in that case, since Run stays off until you do. On the command line this is `--read-type`.

**Profile.** Chooses the SPAdes run mode, and appears for SPAdes and MEGAHIT but not for SKESA, which has no presets. For SPAdes it offers Isolate, Meta, and Plasmid, defaulting to Isolate, which assumes one organism sequenced at reasonably even coverage. Pick Meta for a metagenome, meaning a mixture of organisms sequenced together, or for any enrichment carrying more than one organism. Pick Plasmid when the plasmids in a bacterial preparation rather than the main chromosome are what you want. On the command line this is `--profile`.

**Profile (MEGAHIT).** Chooses a MEGAHIT preset, offering Default, Meta Sensitive, and Meta Large and defaulting to Default, the balanced setting. Meta Sensitive spends more time recovering the rarer organisms in a mixed community, and Meta Large is tuned for a large complex one such as soil or gut. Change this setting when you want to find rare organisms in a mixture. On the command line this is `--profile`.

**Threads.** Sets how many CPU threads the assembler may use at once, as a slider running from 1 to the number of cores your Mac reports, with the chosen number shown beside it. It defaults to the smaller of that core count and 8, which finishes quickly while leaving some of the machine responsive. Lower it when you want cores free for other work during a long run. On Apple Silicon, which is every Mac whose About This Mac window names an M-series chip, LGE lowers whatever you pick to 2 for MEGAHIT and turns off that tool's hardware acceleration, so the slider has little effect for MEGAHIT there. This reduces MEGAHIT's crash rate on Apple Silicon and does not remove it, and a MEGAHIT run may still stop partway with a nonzero exit code at two threads. The reference MEGAHIT run reported `Threads : 2` even though the machine has fourteen cores. On the command line this is `--threads`.

**Memory Limit.** Caps how much RAM the assembler may claim, as a slider reading whole gigabytes from 1 up to the memory your Mac reports, with the chosen number shown beside it. It defaults to three quarters of installed memory capped at 32 GB, which leaves room for the rest of the system. Raise it for a large or high-coverage library that fails partway through, and lower it when you need memory for other applications. This is the maximum allowed, and the memory is not set aside in advance. When SPAdes reaches the cap it stops with an error rather than spilling its working data onto the disk, which is the safe behaviour, since a clear failure is easier to act on than a run that grinds on for hours. The slider appears for SPAdes, MEGAHIT, and SKESA and is hidden for Flye and hifiasm, which take no memory budget. On the command line this is `--memory-gb`.

**Min Contig.** Drops contigs shorter than this length from the result, as a stepper in Primary Settings below the Threads and Memory Limit sliders, accepting 0 to 1,000,000 bases in steps of 100 and defaulting to 0. It reaches MEGAHIT and SKESA, which receive it as `--min-contig-len` and `--min_contig` respectively, so raising it on a metagenome keeps thousands of unidentifiable fragments out of the contig table. Leave it at 0 for a first run, and raise it on a metagenome once you have seen how many short fragments the table holds. With SPAdes selected the value is shown and editable but never reaches the SPAdes command, so it changes nothing for SPAdes. That is an app defect. Leave it at 0 for SPAdes and screen short contigs afterwards by sorting the viewport's Length (bp) column. On the command line this is `--min-contig-length`.

**Careful mode.** Turns on SPAdes' own `--careful` flag, which adds a pass after the assembly proper that corrects single-base mismatches and short indels, meaning small insertions or deletions of a few bases. It appears for SPAdes alone inside the **Curated extra arguments** group under Advanced Settings, which you open by clicking the triangle beside its name. It is off by default, because the pass costs noticeably more wall time, meaning the real elapsed time you wait, and most runs do not need it. The reference run left it off, and off is the right choice for a first pass on any sample, which is why the Procedure tells you to change nothing. Turn it on for a later run on a small genome where per-base accuracy matters more than speed, which a mitochondrial or plasmid assembly usually is. This setting has no command-line flag, so on the command line you pass it through `--extra-args "--careful"`.

**Skip error correction.** Passes SPAdes' `--only-assembler` flag, which skips the read [error-correction](../../GLOSSARY.md#error-correction) stage and goes straight to building the graph. It appears for SPAdes alone inside the same Curated extra arguments group. It is off by default, and off means the correction stage runs, which is what you want for a routine run. Correcting sequencing errors before graph building is most of what keeps false branches out of the graph. Turn it on when the reads were already corrected by an earlier step, or when the correction stage is the part that keeps running out of memory. This setting has no command-line flag, so on the command line you pass it through `--extra-args "--only-assembler"`.

<!-- SHOT: assembly-advanced-settings -->

**Extra arguments.** Appends whatever you type to the assembler's command exactly as written, as a free-text field at the bottom of Advanced Settings, which makes it the only route to an option the sheet does not offer. It is empty by default and should stay empty for almost every run. Use it only after reading the assembler's own documentation for the option you want. LGE reads what you type the way a shell would, so quotation marks must come in pairs. `--cov-cutoff auto` is read without trouble, while `--cov-cutoff "auto` leaves a quotation mark unclosed, which blocks Run and prints the reason in the footer, the strip along the bottom of the sheet. On the command line this is `--extra-args`.

One value is filled in for you on every SKESA run. LGE adds `--min_count 2`, which tells SKESA to keep a k-mer only when it saw that k-mer at least twice, so a k-mer seen once is treated as a sequencing error. SKESA raises this threshold on its own when coverage is high, and on a small or subsetted library that adjustment can push it past every real k-mer and return an empty assembly, so LGE holds it at 2. Typing your own `--min_count` in this field replaces the pinned value.

**Project Name.** Names the assembly bundle the run produces, as a text field in the Output section. It arrives filled in from the first input file's name with the mate suffixes `_R1`, `_R2`, `_1`, `_2`, and the `.lungfishfastq` extension removed and `_assembly` added, falling back to the literal `assembly` when no input name can be read. For this chapter's `HG002.chrM` bundle that gives `HG002.chrM_assembly`. Rename it when you are assembling the same reads more than once and want to tell the results apart, and note that an empty name blocks Run. On the command line this is `--project-name`, which also answers to `--name`.

**Output Folder.** Shows where the run will land, as a read-only row under the Project Name field in the Output section. It resolves to the project's `Analyses` folder, and the row exists so you can confirm the path before committing rather than change it. There is nothing to change here in the window. This setting has no command-line flag as such, though `--output` on the command line writes the run somewhere else.

**Run Mode.** Says how a selection of more than one bundle is handled, and appears only when you selected several. Two options are shown and only **Run separately per bundle** can be selected. **Combine all inputs, run once** is locked, with a caption saying that combining several bundles into one assembly run is not yet supported and that each bundle assembles separately. There is nothing to change here in this version. This setting has no command-line flag, and on the command line you get the same result by invoking `assemble` once per sample.

## Reading the results

The assembly viewport contains a contig table and a detail pane, with the whole-assembly metrics available in the Inspector. With no contig selected, the table uses the available viewport width. Selecting a contig opens its detail pane. The default arrangement puts that pane on the left and the table on the right. The current Preview does not expose a layout picker in the Inspector. Open the Inspector with **View > Show Inspector** (Cmd-Opt-I) if it is not showing.

Open the Inspector's **Bundle** tab and read **Assembly Context** for the headline metrics. It reports the assembler, read type, contig count, total bases assembled, N50, L50, longest contig, whole-assembly GC percent, tool version, and recorded wall time. The strip above the table may show only wall time in the current Preview. The earlier CLI reference run recorded the following figures. The screenshot shows a separate run with the same assembly statistics and a wall time of 25.6 seconds.

```text
SPAdes | Illumina short reads | 1 contig | 16697 total bp
N50 16697 bp | L50 1 | longest 16697 bp | global GC 44.4%
version 4.3.0 | wall time 13.7s
```

That GC figure is the same number the code block above calls GC content and the comparison table below calls Global GC.

[N50](../../GLOSSARY.md#n50) is a length. Sort the contigs longest first and add up their lengths going down the list. N50 is the length of the contig at which that running total first reaches half the assembly's total bases, so half the assembly sits in contigs at least that long. On the fixture's single-contig SPAdes result the N50 equals the contig length, 16,697 bases. That is what a one-contig assembly always gives, so here it tells you nothing new. N50 is useful on a fragmented assembly. A 5 Mb bacterial isolate coming back as 50 contigs with an N50 of 200 kb is tidy. The same 5 Mb arriving as 5,000 contigs with an N50 of 1 kb is a stressed assembly worth re-running with more reads. [L50](../../GLOSSARY.md#l50) measures the same halfway mark but counts contigs instead of bases, giving the number of contigs it took to get there, so an L50 of 1 means one contig holds half the assembly and a large L50 describes a fragmented one.

The contig table has six columns, `#`, `Contig`, `Length (bp)`, `GC %`, `Share of Assembly (%)`, and `Sequence Preview`, and a filter field above them narrows the rows by name or by header, where header means the contig's full FASTA name line. The `#` column is the contig's rank by length, so row 1 is always the longest regardless of what order the assembler wrote its FASTA in. The table carries no coverage column, and LGE does not compute coverage for assembled contigs, though the assemblers themselves record their own estimate in each contig's name.

Click a row. Clicking selects the row both for the detail pane and for the action buttons below the table. The detail pane beside the table shows the contig header, its length, its GC percent, its rank in the assembly, its share of the total assembly length, and a scrollable view of its sequence. The fixture's single contig is named `NODE_1_length_16697_cov_121.957333`, where the `cov_121.957333` field says SPAdes saw roughly 122-fold coverage across it. Compare that figure only against others from the same tool, since each assembler counts coverage its own way.

<!-- SHOT: contig-detail-pane -->

The action bar along the bottom offers **BLAST Contigs**, **Copy FASTA**, **Export FASTA**, and **Create Bundle**, all disabled until you select at least one contig, with a label beside them reading how many are selected. BLAST compares a sequence against a public database of known sequences to see what it resembles, and this button sends the selected contigs to the NCBI BLAST service over the internet. The first button reads **BLAST Contig** in the singular when exactly one is selected. Right-clicking a row adds **Extract Sequence...** and **Run Operation...** to the same set. **Align with MAFFT...** does not appear in the assembly contig menu in this release, which is an app defect. To open a contig in a sequence viewport, select it and use **Create Bundle** to derive a [reference bundle](../../GLOSSARY.md#reference-bundle) from it, which [Extracting Contigs](04-extracting-contigs.md) covers in full, since double-clicking a row does not do it.

### What the three assemblers gave on the same reads

Running all three on the fixture is the quickest way to see that assemblers differ in the exact ends they report and agree on the sequence content. The MEGAHIT row comes from a run that completed, and the caution in the Settings section explains why that is worth saying.

| Assembler | Version | Wall time | Contigs | Total bp | Longest | N50 | Global GC |
|---|---|---|---|---|---|---|---|
| SPAdes | 4.3.0 | 13.7s | 1 | 16697 | 16697 | 16697 | 44.4% |
| MEGAHIT | 1.2.9 | 2.7s | 3 | 17405 | 16711 | 16711 | 44.6% |
| SKESA | 2.5.1 | 1.6s | 1 | 16570 | 16570 | 16570 | 44.4% |

SPAdes took the longest here because it runs the whole graph procedure six times over, once at each k value, and merges the answers, where SKESA does far less work for a comparable result on a genome this simple. That extra work is what makes SPAdes the safer choice on a harder sample.

All three recovered the mitochondrial genome, whose published length is 16,569 bases. SKESA landed on 16,570 and labelled its contig `Contig_1_257.173_Circ [topology=circular]`, where `257.173` is SKESA's own coverage estimate for that contig, the same kind of figure SPAdes writes as `cov_121.957333`. The two differ because each tool counts coverage its own way, so compare a figure only against others from the same tool. The `Circ` and the `[topology=circular]` note say SKESA recognised that the molecule closes on itself. SPAdes and MEGAHIT both overshot by a little over a hundred bases. That is expected on a circular genome assembled by a program that writes linear contigs, because the assembler cannot join the two ends, so the stretch of sequence where the circle closes is written out twice, once at each end of the contig. MEGAHIT additionally emitted two short contigs of 332 and 362 bases, which is why its total is higher and its contig count is 3. Short extras like these are usually fragments the assembler could not place, from a low-coverage patch or a repeated region. The three assemblers disagreed about the genome's exact ends and agreed about its content, which is expected and is the reason the contig count matters more than the last hundred bases of length.

## What good looks like

Check three things before you trust an assembly, in this order.

Start with the contig count and the longest contig together, because they answer the question that matters first, which is whether the thing you meant to assemble came out in one piece. For a small single-molecule target like the mitochondrial genome, one contig at roughly the expected length is the right answer. On a circular genome the overshoot is the length of the closing overlap, which is why the fixture's 16,697 bases against a published 16,569 is acceptable and MEGAHIT's three contigs on the same reads still count as a good result, since one of them holds the whole genome. What is not acceptable is many short contigs with none of them close to the expected length, which is the fingerprint of thin or uneven coverage.

Then read the GC percent, which is the whole-assembly GC content. It is close to constant within a genome and different between genomes, which makes it a cheap identity check. The human mitochondrial genome sits near 44 percent, and all three runs reported 44.4 to 44.6 percent, so the contig is the molecule it should be. Treat a difference of a few tenths of a percent as nothing and a difference of several percentage points as worth explaining, because a contig whose GC percent sits that far from what you expected is usually a contaminant or a host fragment rather than your target.

Finally read the total assembled length against the genome size you expected. A total far above it means the assembler wrote duplicate or spurious pieces, often from contamination. A total far below it means part of the genome had no reads over it at all, so nothing could be built there. On the fixture the totals ran from 16,570 to 17,405 bases against a 16,569-base genome, and the excess is accounted for by the circular overlap and, for MEGAHIT, two short extras.

Two failure modes account for almost every problem run. The first is many small contigs with none at the expected length, which as above means the data are too thin. Coverage rather than the read count is what decides this, so work out roughly what coverage you have before blaming the assembler. Multiply your read count by the read length and divide by the genome size you expect. On the fixture's 16.6 kb genome that arithmetic gives a few hundred fold, and SPAdes reported 122-fold in the contig name. The two differ because each assembler counts coverage its own way, which is why a figure is worth comparing only against others from the same tool. Either number is ample here. The same 9,958 pairs spread over a 5 Mb bacterial chromosome would give about one-fold, which is hopeless. When coverage is too low, more reads is the fix, and that means sequencing the sample again rather than reprocessing what you have. Pooling separate runs of the same library helps only if those runs exist already. The second failure mode is a run that produces no assembly at all. Read the Operations Panel log first, since the usual cause is a truncated FASTQ, an interrupted download, or a pair of mate files with different read counts. LGE reports a run that exited cleanly but wrote nothing as a distinct outcome rather than as a success with an empty table, so an empty result is never silent.

## On the command line

This section is optional. If you do your work in the LGE window, everything above is complete without it, and nothing here unlocks a result the sheet cannot produce. It is here for readers who want to script a run or repeat one on a server. The whole procedure runs headless, meaning with no window at all, by typing commands into the Terminal application. It assumes `lungfish-cli` is already installed, which the [command-line reference](../appendices/cli-reference.md) covers.

The command is `lungfish-cli assemble`. It takes the input files as arguments, with `--paired` binding exactly two of them as the two mate files of one library, and it uses the same tool and read-class compatibility model the sheet does. This is the exact command that produced every SPAdes figure in this chapter. It names the two files without any folder in front of them, so run it from the folder that holds them. The backslash at the end of a line joins that line to the next, so the five lines below are one command, and you type the backslashes as shown.

```bash
lungfish-cli assemble HG002.chrM_R1.fastq.gz HG002.chrM_R2.fastq.gz \
  --paired \
  --assembler spades \
  --profile isolate \
  --project-name HG002.chrM_assembly \
  --output ./out-spades
```

Swap `--assembler megahit` or `--assembler skesa` for the other two runs in the comparison table. Four flags have no equivalent control in the sheet.

| Flag | What it does |
|---|---|
| `--paired` | Treats the two input files as the two mate files of one library. The sheet works this out from the file names instead. Off by default. |
| `--output` | Writes the run somewhere other than the project's `Analyses` folder. It also answers to `-o` and `--output-dir`, and these three spellings are interchangeable, so type whichever one you like. |
| `--extra-arg` | Adds one extra assembler argument and may be repeated. Note the singular name, which differs from the plural `--extra-args` above by one letter. That one takes the whole argument string at once. |
| `--format` | Prints the run summary as `text`, `json`, or `tsv`. Defaults to `text`. |

Three notes on flags that behave differently from how they read. `--min-contig-length` is passed to MEGAHIT and SKESA and ignored by SPAdes, Flye, and hifiasm, matching the sheet's behaviour and its defect. `--profile` is accepted for SKESA and ignored, since SKESA has no profiles, and the run still succeeds when you pass it. For MEGAHIT, `--profile default` passes nothing to MEGAHIT at all, because LGE stores that choice as an empty value and omits the flag when the value is empty, so only `meta-sensitive` and `meta-large` ever reach the tool.

Every run also writes `assembly-result.json` beside the contigs, which carries the resolved tool version, the exact command line, the wall time, and the full statistics block, so a scripted run records its own provenance without any extra step.

## Next

Continue to [Running Flye or hifiasm](03-running-flye-or-hifiasm.md), which covers long-read assembly only. If your reads are Illumina, skip to [Extracting Contigs](04-extracting-contigs.md), which turns a contig into a reference bundle for downstream mapping and variant calling.
