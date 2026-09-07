---
title: Amplicons and Shotgun Sequencing
chapter_id: 01-foundations/03-amplicon-vs-shotgun
audience: bench-scientist
prereqs: [01-foundations/01-what-is-a-genome, 01-foundations/02-sequencing-reads]
estimated_reading_min: 9
task: Understand the difference between amplicon and shotgun sequencing and why amplicon data needs primer trimming.
tags: [foundations, amplicon, shotgun, primers, primer-scheme, artic, qiaseq]
tools: []
parameters_refs: []
entry_points: []
shots:
  - id: primer-scheme-picker-built-in
    caption: "The Primer Scheme menu in the primer-trim dialog, open on its Built-in section listing the eight schemes LGE ships."
illustrations:
  - id: amplicon-vs-shotgun
    brief: "Top row: shotgun sequencing schematic showing a genome with reads scattered randomly across it, each read starting and ending at arbitrary positions. Bottom row: amplicon sequencing showing the same genome with reads starting and ending at fixed primer positions, with about 8-10 overlapping amplicons covering the genome. Use Lungfish Creamsicle for read positions, Peach for primer positions."
  - id: primer-scheme-diagram
    brief: "A 2000-base region of a genome backbone in Deep Ink, with three primer pairs marked above the backbone (forward primers as right-pointing Creamsicle arrows, reverse primers as left-pointing arrows), creating three overlapping amplicons. Below the backbone, a small table showing the BED-style start/end coordinates of each primer."
  - id: primer-trim-soft-clip
    brief: "A single read shown twice. Top: untrimmed read, with the leftmost ~20 bases highlighted in Peach (primer-derived) and the body of the read in Lungfish Creamsicle (sample-derived). Bottom: same read after primer trim, with primer-derived bases shown lightened/struck-through to indicate soft-clipping, body unchanged. Annotate 'Primer bases ignored by the variant caller'."
glossary_refs: [amplicon, shotgun, primer, primer-scheme, primer-trim, soft-clip, target-enrichment, tiling, library-prep, mhc, coverage, depth]
features_refs: []
fixtures_refs: [hg002-chr20, demo-assets]
brand_reviewed: true
lead_approved: true
---

## What it is

Sequencing reads do not simply appear. Somebody first turned a tube of extracted nucleic acid into a form the instrument can read, and that preparation is called the [library prep](../../GLOSSARY.md#library-prep). The library prep decides where on the genome your reads will land, and that single fact changes how the rest of the analysis has to work.

Two preparations cover most of what you will meet. In [shotgun](../../GLOSSARY.md#shotgun) sequencing the sample is chopped into short pieces at essentially random places, and every read starts wherever a break happened to fall. In [amplicon](../../GLOSSARY.md#amplicon) sequencing a chosen stretch of the genome is copied many times by PCR before sequencing, using short synthetic pieces of DNA called [primers](../../GLOSSARY.md#primer) that stick to two known positions and mark out what gets copied. Every read from an amplicon library starts and ends at those same designed positions.

Both preparations produce FASTQ files that look identical on disk. A FASTQ file stores one read in four lines, a header naming the read, the bases themselves, a separator line, and a quality string with one character per base. Both preparations write those same four lines, and a paired-end run splits them across two files, read 1 in one and read 2 in the other. Nothing inside the file announces which preparation made it. You have to know, or find out, because one of the two needs a cleanup step that the other does not.

That step is primer trimming, and this chapter explains why it exists. The short version is that the first and last stretch of every amplicon read is primer, not sample, and a variant caller that is not told so will report the primer as a mutation. A variant caller is the program that compares your reads to a reference and decides where the sample genuinely differs from it. Lungfish Genome Explorer (LGE) can do the trim in either of two places in a workflow, and this chapter says which to prefer. What this asks of you is one habit. Find out which library prep made your sample before you call a single variant, and if the answer is amplicon, find the matching primer scheme too.

## Why you would do this

Two real datasets in this manual sit on opposite sides of this line, and comparing them makes the difference concrete.

The HG002 chromosome 20 slice is shotgun. HG002 is a reference human sample sequenced many times over by many groups, which is why it is used to benchmark methods. The slice holds 45,574 Illumina read pairs, covering a 500,001 base stretch of chromosome 20. A read pair is the two reads that came from opposite ends of one fragment, so 45,574 pairs means 91,148 reads split across the two files.

Mapped back to its own reference those reads reach a mean [depth](../../GLOSSARY.md#depth) of 44.7 reads per position and cover 99.99% of the slice. Depth is the number of reads stacked at one position. Around 30 or more is comfortable for calling variants on a human sample, 10 to 20 is thin, and under 10 is too thin to trust, so 44.7 is a healthy working depth. Coverage breadth is the share of positions that got any reads at all. Above 99% is routine for a shotgun run on an easy region, and a figure in the 80s or 90s would point at reads lost to repeats or to a mismatched reference. Shotgun coverage in general is smooth, because no one chose where the fragments would break, and it climbs and falls gently with the local base composition rather than jumping at fixed points.

The Williams MiSeq genotyping project is amplicon. It is a laboratory dataset named for the group that produced it, and it holds 30 macaque samples prepared by PCR against the [MHC](../../GLOSSARY.md#mhc), the immune-system gene region, and sequenced on an Illumina MiSeq. One of its samples, WD28, holds 32,740 reads, every one of them exactly 251 bases long. That uniformity is the giveaway. Amplicon coverage in general does not spread across a chromosome at all. It piles onto the set of targets the primers were designed to reach.

The reference this project is genotyped against is worth a moment, because it is not a chromosome. It is a database of 970 short allele sequences, a catalogue of the MHC variants already known in this species, and reads are matched against that catalogue rather than against a position on a genome. Some references are lists of known alleles in this way. The 970 records come in several lengths, because the panel amplifies several different loci and each one has its own target length. The two commonest lengths are 156 bases with 577 records and 244 bases with 198 records. The remaining 195 records sit at other lengths.

The two datasets ask different questions, and each preparation answers its own question well. The sections that follow set out what each one is good for, so you can place your own sample against them.

## Shotgun sequencing

In a shotgun prep the nucleic acid in the tube is broken into short pieces, by an enzyme or by physical shearing, and sequencing adapters are attached to both ends of every piece. Adapters are short synthetic sequences the instrument needs in order to read a fragment at all. Where any given read lands is a matter of where the break happened, and for every purpose in this manual that placement is random.

![Shotgun reads scattered randomly compared with tiled overlapping amplicons at fixed positions](../../assets/illustrations-imagegen/01-foundations/03-amplicon-vs-shotgun/amplicon-vs-shotgun.png)

The gain is that shotgun sees whatever was in the tube. It carries no assumption about what sequence you expect to find, so an unexpected organism, a rearranged genome, or a stretch that has drifted far from anything in a database all still produce reads. The cost is that shotgun spends reads in proportion to what is present. If your target is one part in ten thousand of the material, then roughly one read in ten thousand is on target, and you have to sequence very deeply to collect enough of them.

Shotgun data needs no primer trimming, because no primers were used. Adapters do get removed, but adapter trimming is a different step with a different tool, and the sequencing instrument's own software often does it before you ever see the file. LGE never removes adapters on its own. Adapter Removal is a separate operation you run deliberately, so if you did not run it, it did not happen.

## Amplicon sequencing

An amplicon prep uses PCR instead of shearing. Two primers, each usually 18 to 30 bases long, bind at two known positions on the target, and a polymerase copies everything between them. The copied piece is the amplicon. Its two ends are the two primer sites, exactly, in every copy.

One primer pair covers one stretch. To cover something larger, a protocol uses many pairs at once so that their amplicons overlap end to end, which is called [tiling](../../GLOSSARY.md#tiling). The SARS-CoV-2 schemes LGE ships are tiling schemes of this kind. The Williams project works differently, because the MHC targets it amplifies are separate genes rather than one continuous region, so its amplicons sit on chosen loci rather than tiling a chromosome. A locus is one specific place on the genome, and loci is its plural.

The gain is sensitivity. PCR multiplies the target by orders of magnitude before sequencing, so a sample with very little starting material can still yield a usable result, and the reads that come back are nearly all on target. Coverage becomes predictable as well. Every amplicon is supposed to produce reads at its own coordinates, so a missing amplicon is a specific and diagnosable event rather than bad luck.

The cost is that you only see what the primers were designed to reach. A target that has mutated under a primer site amplifies poorly or not at all, and anything the panel does not target is invisible. PCR also introduces artifacts of its own. The polymerase makes occasional errors that are then copied forward, and it can sometimes join two different templates into one chimeric product. A template is a molecule being copied, and a chimeric product is an artificial hybrid stitched together from two of them, a sequence that never existed in the sample. Most of these show up as low-frequency variants rather than fixed ones, and the minimum allele-frequency setting in the variant-calling dialog, which is pre-filled at 0.05, usually filters them out. That 0.05 is a fraction rather than a percentage, so it means the difference has to appear in at least 5 percent of the reads stacked at that position before the caller will report it. The variant calling chapters document that setting.

## What an amplicon looks like, end to end

Take one amplicon in the abstract, with round numbers chosen for clarity rather than copied from a real scheme. Every position range in this manual counts both of its ends, so positions 1000 to 1021 is 22 bases and not 21. A 22-base forward primer binds at reference positions 1000 to 1021. A 22-base reverse primer binds at positions 1378 to 1399. The amplicon is everything between and including them, 400 bases running from position 1000 to position 1399.

Sequence that amplicon on a 150-base paired-end run and you get two reads per molecule. The two reads of a pair start at opposite ends of the molecule and are read inward toward each other, so read 1 begins at the amplicon's left edge and read 2 begins at its right edge. Read 1 covers positions 1000 to 1149. Read 2 covers positions 1250 to 1399, from the other strand. The 100 bases in the middle get no coverage from this amplicon. That gap is expected rather than a fault, because in a tiling scheme the neighbouring amplicons overlap this one and cover it.

Here is the part that decides everything downstream. The first 22 bases of read 1 are not your sample. They are the primer, which became the physical end of the amplicon during PCR and was then copied into every descendant molecule. Whatever your sample truly reads at positions 1000 to 1021, the read shows the primer sequence there instead. The last 22 bases of read 2 do the same at the other end.

Now suppose your sample carries a real difference from the reference at position 1015, inside the forward primer site. The primer overwrote it. Every read says primer. Worse, suppose the primer was designed against a slightly different version of the target than the one you have. Then every read reports the primer's base as a variant, at close to 100% frequency, with hundreds of reads behind it. A variant caller has no way to tell that apart from a real fixed mutation, so it reports one. What it found was the primer.

![Before and after primer trimming, showing soft-clipped primer bases](../../assets/illustrations-imagegen/01-foundations/03-amplicon-vs-shotgun/primer-trim-soft-clip.png)

## Primer trimming

[Primer trimming](../../GLOSSARY.md#primer-trim) is the fix. It marks the primer-derived bases so that nothing downstream counts them as evidence. LGE offers two ways to do it, and they differ in where in the workflow the trim happens.

The first works on the reads, before alignment. LGE's Primer Trimming operation takes the primer sequences, matches them against each FASTQ read, strips those bases, and writes a trimmed FASTQ. On the command line this is `lungfish-cli fastq primer-remove`, and its engine there is `bbduk` by default, with `cutadapt-linked` as the alternative. In the app the engine follows the primer source, `bbduk` for a typed-in primer sequence and linked `cutadapt` for a primer FASTA. You do not pick between them in the app, and the choice it makes suits an ordinary run. Because it matches sequence rather than position, it needs no reference, but it is thrown off when your sample differs from the canonical primer under the primer site. In that case the read end no longer matches and the bases slip through untrimmed.

The second works on the alignment, after mapping. `ivar trim` takes the primer coordinates from a BED file, walks each aligned read in the BAM, finds where the read's mapped position overlaps a primer footprint, and marks those bases as [soft-clipped](../../GLOSSARY.md#soft-clip). A BAM is the file that holds your reads after they have been mapped, each read recorded with the reference position it landed on. Soft-clipping means the bases stay in the record but are excluded from coverage, pileup, and variant calling. The pileup is the stack of reads sitting over one reference position, which is the evidence a variant caller weighs there. Because this method works from coordinates rather than sequence, a mutation under the primer site does not confuse it, and the original bases remain in the file for inspection later.

In LGE the alignment-based trim runs after alignment and before variant calling, from the Primer Trim tab of the Inspector. The Inspector is the panel down the right-hand side of the project window, showing details and actions for whatever you have selected. Its provenance sidecar records the exact options used so the run can be repeated. A provenance sidecar is a small file LGE saves beside every result, holding the tool version, the full command, and the checksums of what went in and came out.

Prefer the alignment-based trim whenever you have a primer scheme and a mapped BAM, because coordinates survive a mutated primer site and sequence matching does not. Reach for the read-based trim only when you have no reference to map against, or when you want trimmed FASTQ files to hand on to something outside LGE.

Most reads pass through the trim with their ends soft-clipped and their count unchanged. Some `ivar trim` options can drop a read whose remaining aligned stretch is too short to be useful. Losing a few reads this way is normal rather than a fault, and `ivar trim` writes its own tally of what it kept and dropped into the run's log, which the Operations panel row for the trim links to. This chapter does not cover the settings of either operation. [Trimming and Filtering](../03-reads/04-trimming-and-filtering.md) documents the read-based settings and [Primer Trimming](../04-alignments/03-primer-trimming.md) documents the alignment-based ones.

## What a primer scheme is, as a file

A [primer scheme](../../GLOSSARY.md#primer-scheme) is a coordinate table. For each primer it records which sequence the primer sits on, where it starts, where it ends, what it is called, a score, and which strand it binds. The usual on-disk format is BED, a tab-separated text file whose six standard columns are chrom, start, end, name, score, strand. The score column carries no meaning for primer schemes. It is present because BED requires it, it is filled with a placeholder, and nothing in LGE reads it.

Here is one row in the shape BED uses, with the invented coordinates from the worked example above and a deliberately generic primer name.

```
MN908947.3	999	1021	scheme_1_LEFT	1	+
```

BED counts differently from the rest of this manual, in two separate ways. First, it numbers the very first base of a sequence 0 rather than 1, so every start position is one lower than the number you would say out loud. Second, it treats the end position as the first base past the primer rather than the last base of it, so the end position is not shifted down.

Put those two together and the primer this manual calls positions 1000 to 1021 is written `999` and `1021` in a BED file. The convention has a name, zero-based half-open, and you only meet it if you open the BED yourself. LGE converts for you everywhere else.

![ARTIC-style primer scheme showing forward primers, reverse primers, and overlapping amplicon bands](../../assets/illustrations-imagegen/01-foundations/03-amplicon-vs-shotgun/primer-scheme-diagram.png)

LGE packages a scheme as a `.lungfishprimers` bundle, a folder that macOS shows as one item. Inside sit the BED file, the primer sequences as a companion FASTA where the scheme supplies them, a manifest, and a provenance note naming the source and the reference accession the coordinates belong to. To look inside safely, right-click the bundle in the Finder and choose Show Package Contents, which opens it as the folder it is. Bundles you add yourself live in the project's `Primer Schemes/` folder.

## The schemes LGE ships

Primer schemes in LGE are viral by design, and the eight it bundles are all SARS-CoV-2 schemes. They appear in the Primer Scheme menu under the heading "Built-in", and any scheme you added to your own project is listed separately under "In This Project". A "Choose Scheme…" button beside the menu opens a file chooser for a bundle stored somewhere else on disk.

<!-- SHOT: primer-scheme-picker-built-in -->

Four are from the ARTIC network. **ARTIC SARS-CoV-2 V3** is the original 400-base scheme, 98 amplicons across 218 primer rows, more rows than twice the amplicon count because the scheme includes alternate primers for some positions. **ARTIC SARS-CoV-2 V4** and **ARTIC SARS-CoV-2 V4.1** each hold 99 amplicons, across 198 and 209 primers, and V4.1 adds spike-in primers that restore coverage lost to Omicron mutations. A spike-in primer is an extra primer added to an existing design to bring back an amplicon that stopped working, and the term has nothing to do with the coronavirus spike gene. **ARTIC SARS-CoV-2 V5.3.2** is a redesign rebalanced for coverage uniformity, 96 amplicons across 192 primers.

The other four come from elsewhere. **QIAseq Direct SARS-CoV-2 with Booster A** is a commercial kit built for fragmented RNA, 223 amplicons across 563 primers. **Midnight 1200 bp V1** uses far longer amplicons, 29 of them across 58 primers, suited to Oxford Nanopore reads. **NEB VarSkip Short v1** holds 74 amplicons across 148 primers, and **NEB VarSkip Long v1** holds 29 across 50.

The ARTIC project keeps releasing new versions. Any scheme LGE does not bundle has to come from outside. Without leaving the app, click "Choose Scheme…" beside the Primer Scheme menu and point the file chooser at a `.lungfishprimers` bundle anywhere on disk. To turn a plain BED file into such a bundle, or to file one permanently into the project's `Primer Schemes/` folder, the command line has `lungfish-cli primers import`. Every bundled scheme declares both `MN908947.3` and `NC_045512.2` as accessions for the same SARS-CoV-2 sequence, so a BAM aligned to either name resolves against the scheme without further work.

Picking the wrong scheme is a common source of phantom variants. Trim a V4.1 sample against the V3 coordinates and the trimmer clips the wrong places, so the real primer bases stream into the pileup and the result is a tidy-looking variant list at the V4.1 primer sites. Those calls match no lineage, appear in no database, and track exactly with the protocol rather than with the biology.

## How to tell which prep your sample had

Three places usually hold the answer, in order of reliability. The person who prepared the library is the authoritative record, so ask first. The sequencing submission record names the kit, for a public dataset in the SRA or ENA fields describing library strategy and construction protocol. The SRA is NCBI's Sequence Read Archive and the ENA is the European Nucleotide Archive, the two public archives where raw sequencing reads are deposited, and each run in them carries a metadata page with those fields on it. And the protocol or publication the sample came from names the scheme and version.

Failing all three, the data itself gives a hint. Amplicon coverage steps up and down at fixed coordinates and repeats that shape across every sample prepared the same way. Shotgun coverage is smoother and does not repeat its bumps from sample to sample. Read lengths help too. The Williams sample WD28 has every read at exactly 251 bases, which is what happens when a short amplicon is read to the full length of the run.

A hint is not proof. Guessing at a scheme is worse than not trimming at all, because trimming against the wrong coordinates soft-clips real sample bases along with nothing useful.

## Target enrichment, the third route

A third preparation sits between the two. This manual calls it [target enrichment](../../GLOSSARY.md#target-enrichment) throughout, though you will meet it elsewhere under the names capture and hybridisation capture. Hybridisation is the pairing of two complementary strands of nucleic acid, which is the step the method depends on.

Target enrichment uses probes, which are pieces of DNA or RNA complementary to the regions you want, fixed to something you can physically pull out of the tube. The targeted material comes with them and the rest is washed away. Twist and IDT sell panels of this kind, named here only as examples of commercial vendors rather than as products you need.

Target enrichment borrows from both sides. Like amplicon, it needs the targets chosen in advance and it concentrates the reads onto them. Like shotgun, the fragments are randomly sheared, so reads do not start at fixed coordinates and no primer sequence ends up inside them. It also tolerates a target that has drifted further from the design than PCR does, because a probe can still grab a target that differs from it in places where a primer would fail to bind.

For every workflow in this manual, treat target-enrichment data as shotgun data. Do not trim primers, since there are none. When you inspect coverage, expect the dips to sit at probe boundaries and in regions that drifted away from the probe sequence, rather than at amplicon junctions.

## Side by side

| Property | Shotgun | Amplicon |
|---|---|---|
| Where reads start | Wherever the fragment broke | At the primer coordinates, every time |
| Starting material needed | More | Less |
| Reads that land on target | In proportion to what is present | Nearly all of them |
| Primer trimming | Not applicable | Required before variant calling |
| Sees the unexpected | Yes | Only what the primers reach |

Reach for shotgun when you do not yet know what is in the sample, when the target is abundant, or when you need an unbiased view. Reach for amplicon when the target is known, the material is scarce, and you want the same regions covered the same way across many samples so their results can be compared.

## What good looks like

Four checks are worth running before you trust an amplicon result. Confirm you know the scheme name and version from a record rather than from memory. Confirm the scheme's reference accession matches the reference the reads were mapped to, since the coordinates mean nothing otherwise. Confirm the primer trim actually ran, which the Inspector shows on the trimmed alignment track. And look at the variant list for a cluster of high-frequency calls sitting at primer positions, which is what an untrimmed or mistrimmed run produces.

For a shotgun result the checks are shorter. Confirm that no primer trim was applied, since there is nothing to trim, and read the coverage profile expecting a smooth curve rather than steps.

## Next

Continue to [Alignment Files](04-alignment-files.md) to see what happens once reads are mapped to a reference, and how soft-clipping is recorded in a BAM.
