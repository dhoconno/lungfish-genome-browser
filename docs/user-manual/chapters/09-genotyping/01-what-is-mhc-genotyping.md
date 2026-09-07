---
title: What Is MHC Genotyping
chapter_id: 09-genotyping/01-what-is-mhc-genotyping
audience: bench-scientist
prereqs: [01-foundations/02-sequencing-reads, 01-foundations/03-amplicon-vs-shotgun, 01-foundations/06-the-lungfish-project]
estimated_reading_min: 30
task: Understand the question an MHC genotyping run answers, tell an allele apart from a haplotype, and pick between the two genotyping workflows LGE offers.
tags: [genotyping, mhc, immunogenetics, amplicon, macaque, rhesus]
tools: []
parameters_refs: []
entry_points:
  - "Tools > Genotyping > miSeq amplicon MHC genotyping..."
  - "Tools > Genotyping > Full-length ONT MHC genotyping..."
shots:
  - id: genotyping-submenu
    caption: "The Tools menu open on its Genotyping submenu, showing the three specialized workflows it holds, miSeq amplicon MHC genotyping..., Full-length ONT MHC genotyping..., and 12S Amplicon Matching..., with any workflow that is not yet enabled shown in grey followed by (not enabled)."
  - id: genotype-matrix-overview
    caption: "The Genotype Matrix view of the Williams MiSeq genotyping result, with allele-target rows down the left named by their reference record and one column per sample across the top."
illustrations: []
glossary_refs: [alignment, allele, allele-target, amplicon, bbmerge, class-i-mhc, class-ii-mhc, clustering, fasta, fastq, genotype-matrix, haplotype, immunogenetics, ipd-mhc, locus, mcm, mhc, minimap2, operations-panel, paired-end, pcr, plugin-pack, primer, provenance, read, reference-bundle, retained-read, variant-caller]
features_refs: []
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

## What it is

MHC genotyping asks which versions of a set of immune-system genes an individual animal carries. The [MHC](../../GLOSSARY.md#mhc), short for major histocompatibility complex, is a dense cluster of genes. Their proteins sit on the outside surface of a cell and display fragments of what is being made inside it, so that the immune system can inspect them. It is the most variable region of a vertebrate genome. Treating it like an ordinary gene fails. Reads from one animal's alleles often will not align cleanly to another animal's sequence, so the region gets its own assay, meaning its own laboratory panel plus its own analysis. A [locus](../../GLOSSARY.md#locus) is the place on a chromosome where one particular gene sits, and an [allele](../../GLOSSARY.md#allele) is one of the alternative sequences a locus can carry. At most MHC loci the number of known alleles runs into the hundreds, and two animals of the same species routinely carry entirely different ones.

The assay works by [amplicon](../../GLOSSARY.md#amplicon) sequencing. An amplicon is a short stretch of DNA copied many times from one defined region by [PCR](../../GLOSSARY.md#pcr), the reaction that makes millions of copies of a chosen piece of DNA. An amplicon run therefore reads one chosen piece of the genome deeply, meaning many reads cover the same place, rather than reading the whole genome evenly. A genotyping panel uses a pair of [primers](../../GLOSSARY.md#primer), short synthetic DNA pieces that mark where copying starts and stops. The pair sits in sequence shared by every allele at a locus and flanks the variable stretch between them, so whatever alleles the animal carries come back as amplicons. The [reads](../../GLOSSARY.md#read), each one stretch of sequence from one DNA fragment, arrive as a [FASTQ](../../GLOSSARY.md#fastq) file, the standard text format holding sequencing reads with their quality scores. A quality score is a per-base confidence number, and genotyping does not use it.

What happens next is what makes genotyping different from the other read workflows in this manual. Lungfish Genome Explorer (LGE) compares each read against a library of known allele sequences held as a [FASTA](../../GLOSSARY.md#fasta) file, which is a plain-text file listing each sequence under a name. The library is curated by the [immunogenetics](../../GLOSSARY.md#immunogenetics) community rather than by LGE, meaning the researchers who study immune-system genes. It is published by a database such as IPD-MHC, and you supply it yourself as a [reference bundle](../../GLOSSARY.md#reference-bundle) when you set up the run. LGE does not fetch one for you. Every sequence in it is an [allele target](../../GLOSSARY.md#allele-target), meaning one reference sequence a read either matches or does not. For each allele target the run asks one plain question, which is whether any reads in this sample match it exactly and how many. The answer for a whole run is a table with allele targets as rows and samples as columns. A filled cell holds a read count, and an empty cell means no read in that sample matched that allele target.

That is a different question from variant calling. A [variant caller](../../GLOSSARY.md#variant-caller) lines reads up against one reference genome and lists every position where the sample differs from it. Genotyping never reports a position. It reports identities, naming which catalogued sequences are present, and a read that differs from every allele target by even one base is simply not counted rather than being reported as a difference. The reason for this is biological. A named allele is the unit immunologists work with, because it is the unit that is inherited, published, and matched between animals, and a partial match does not identify an allele.

What this asks of you before you run anything is one decision. Work out whether your reads are short amplicons or full-length sequences. Your read length is the observable test, and it is printed on the run sheet and visible in LGE after you import the reads. Reads of a few hundred bases or less are short amplicons. Reads long enough to cover a whole allele, typically well over a thousand bases and produced on an Oxford Nanopore instrument, are full length. LGE offers two genotyping workflows and that is the question separating them.

## Why you would do this

You genotype the MHC when the alleles an animal carries change how you interpret everything else you measure about it. Three situations account for most of the work.

The first is study design in nonhuman primate research. Macaques are the standard model for vaccine and infectious-disease studies, and MHC genotype strongly shapes how an individual animal's immune system responds. Assigning animals to groups without knowing their genotypes risks filling one arm of a study, meaning one treatment group, with animals that happen to keep virus levels low on their own. The study then measures the genetics of those animals rather than the effect of the treatment. Genotyping before assignment is what prevents that. The same reasoning and the same workflow apply to human HLA work, which is the human name for the MHC, provided you supply a human allele library.

The second is interpreting an immune response after the fact. A T cell is an immune cell that inspects the fragments an MHC protein displays, in the way described above. When you find that a T cell recognizes some fragment of a pathogen, one particular MHC protein displayed that fragment. You cannot say which animals could make that response without knowing which alleles they carry.

The third is colony management. A breeding colony tracks genotypes across generations. Pedigree work, meaning confirming which animals are the parents of which, needs the same assay run consistently on every animal.

The worked example throughout this part of the manual is the Williams MiSeq genotyping project. It is a rhesus macaque study of 30 animals sequenced on an Illumina MiSeq, a benchtop sequencing instrument made by Illumina. It does not ship with LGE, so the figures below are for orientation rather than something you can reproduce on your own machine. Rhesus macaque MHC genes carry the prefix `Mamu`, from the species name *Macaca mulatta*, and the run matched its reads against the IPD-MHC Mamu allele library dated 2021-07-09, which holds 970 allele targets. That 970 is what this particular library release holds, and 362 of those records are groups rather than single alleles, so the count of distinct published alleles behind it is higher. Whether a given release is the complete catalogue for a species is a question for the database that published it rather than something LGE reports. A 2021 library is still usable in 2026, provided every run in a study uses the same one, because calls made against different releases are not comparable. A finished result names alleles the way the library does, so a call reads as `01_Mamu-A1_001_05_01_01`. A variant caller would instead report a coordinate, meaning a chromosome, a position number, and the base change found there, naming where a difference sits rather than which allele is present. That naming is explained in its own section below.

## Alleles, loci, and haplotypes

Three words get used interchangeably in conversation and mean quite different things in a result, so it is worth separating them before you open one.

An allele is a single sequence at a single locus. It is the unit the assay actually measures, because a read either matches one of the library's allele targets exactly or it does not. Because an animal has two copies of each chromosome, it carries at most two alleles at any one locus, and often two identical ones.

A locus is the gene, and the MHC holds many of them. They fall into two groups. [Class I](../../GLOSSARY.md#class-i-mhc) genes are carried on nearly every cell in the body and show fragments of whatever that cell is making internally, which is how an infected cell is recognized. [Class II](../../GLOSSARY.md#class-ii-mhc) genes sit on a smaller set of immune cells and show fragments the cell has taken in from outside. The Williams result reports 13 loci in all. Its class I loci are MHC-A, MHC-AG, MHC-B, MHC-E, MHC-F, MHC-G, MHC-I, and MHC-J, and its class II loci are MHC-DPA1, MHC-DPB1, MHC-DQA1, MHC-DQB1, and MHC-DRB. That list is for reference rather than something to memorize, since MHC-A, MHC-B, and MHC-DRB carry most of the alleles immunologists work with day to day. These names drop the species prefix that the allele names themselves carry, so the locus written `MHC-A` here is the same locus written `Mamu-A1` inside an allele name. Which loci appear in your own result depends entirely on the allele library the run used rather than on any setting in LGE, and the run's [provenance](../../GLOSSARY.md#provenance) record names the library it read.

A [haplotype](../../GLOSSARY.md#haplotype) is the level above both, meaning a set of alleles across several linked loci that are inherited together as one block. They travel together because recombination, the shuffling of chromosome copies that happens when eggs and sperm are made, rarely cuts between loci that sit this close together. Haplotypes are what let immunologists name a whole MHC region with one label instead of listing a dozen alleles. A genotyping run does not observe a haplotype directly. It observes alleles, and a haplotype is an interpretation built on top of them, which is why the two must not be confused when reading a result.

## Haplotype analysis (placeholder)

LGE can also assign MHC haplotypes from called alleles. A worked example with an MCM dataset will be added in a later release of this manual.

[MCM](../../GLOSSARY.md#mcm) is short for Mauritian cynomolgus macaque, a population whose limited founding stock left it carrying only a handful of MHC haplotypes, which is what makes it the standard teaching set for haplotype work. Haplotype assignment is not a separate menu item, and this manual does not yet document the choice inside the run dialog that turns it on.

## How allele names are built

An allele name in a genotyping result is not something LGE composes. It is the record name from the FASTA library the run matched against, copied through unchanged, so learning to read one is learning to read that library's convention.

The [IPD-MHC](../../GLOSSARY.md#ipd-mhc) library the Williams project used builds each name in three parts. Take `01_Mamu-A1_001_05_01_01` and read it left to right. The leading `01` groups records by locus, so every record beginning `01_` belongs to the same locus family. Next comes the species and locus prefix, `Mamu-A1` here, or `Mamu-DQB1` at another locus. Last comes the allele designation itself, `001_05_01_01`, a series of numbers separated by underscores that runs from broad to specific.

Each added number narrows the call. Two alleles agreeing on the first number are close relatives, and each further number they share makes them closer still. So `001_05_01_01` sits inside the same family as `001_05` rather than being a different allele from it. In the naming systems this convention follows, the earlier numbers track differences that change the protein and the later ones track differences that do not. A difference in an early number therefore matters more biologically than one in a late number. The library itself records no meaning for each position, so treat the ladder as a measure of relatedness rather than as a promise about protein sequence.

Many records carry a `g` and a list after a vertical bar, as in `01_Mamu-A1_001g1|A1_001_01_01_01,A1_001_01_01_02,A1_001_02`. That marks a group. The `g` says the record stands for a group of alleles rather than one. The digit after it numbers the groups within that allele family, so `001g1` is the first such group among the `001` alleles. The amplicon this panel sequences is only about 156 bases long, which covers one variable exon rather than the whole gene. An MHC gene runs to several thousand bases across all its parts. Several published alleles are therefore identical to one another across that short stretch while differing elsewhere in the gene. Because the reads cannot separate them, the library folds them into one record and lists every member after the bar. Here that is three alleles under one name.

A call on a group record is an honest statement that the animal carries one of the listed alleles and that this assay cannot say which. The wrong reading is to treat a group record as several separate calls, or to read the length of the name as the length of the sequence. Both are common. The number of members listed after the bar says nothing about how long the sequence is. It is one call whose resolution, meaning how finely the assay can tell alleles apart, the amplicon length limits.

The other consequence of that design is worth stating plainly. Grouping catches alleles the library curators already knew were identical over the standard stretch, but a given panel's amplicon does not always match that stretch exactly. So two allele targets in the library can still be identical over the sequenced region even after grouping. A read matching one then matches both, and both appear in the result. Extra rows of this kind are the assay working correctly rather than a contamination signal.

## What LGE offers, and where it lives

Every genotyping workflow opens from the **Tools** menu. Open **Tools > Genotyping** and you get a submenu holding two MHC workflows, **miSeq amplicon MHC genotyping...** and **Full-length ONT MHC genotyping...**. A third item sits beside them, **12S Amplicon Matching...**, which does no MHC work at all. It identifies vertebrate species from a short mitochondrial marker and is covered by [12S Amplicon Metabarcoding](../06-classification/10-twelve-s-metabarcoding.md), filed in this submenu because it uses the same exact-matching method rather than because it genotypes anything.

<!-- SHOT: genotyping-submenu -->

The table below names the two MHC workflows and the question each answers. Oxford Nanopore, abbreviated ONT, is the maker of the long-read instruments the second one expects.

| Workflow | Reads it expects | The question it answers best |
|---|---|---|
| miSeq amplicon MHC genotyping | Illumina paired reads, meaning two sequences read from opposite ends of one fragment, or Oxford Nanopore reads, from a short-amplicon panel | Which catalogued alleles does each animal carry, as finely as a short amplicon can tell them apart? |
| Full-length ONT MHC genotyping | Oxford Nanopore reads long enough to span a whole allele | What is the full-length sequence of each allele, including ones no library names yet? |

The names mislead slightly, so here is the correction. **miSeq amplicon MHC genotyping** is one workflow that handles both Illumina paired reads and Oxford Nanopore reads from a short-amplicon panel, despite naming only one instrument. There is no separate short-read ONT genotyping item to look for. The workflow has two modes, meaning two input shapes it knows how to handle, one for Illumina and one for Oxford Nanopore. It works out which one your reads are and reports that as a caption in its dialog rather than asking you to pick. If the caption names the platform you did not use, close the dialog and check that you selected the right read bundles, since the reads are what it decided from.

Running either workflow on reads it was not meant for does not raise an error. It produces a poor result instead. Full-length reads pushed through the short-amplicon workflow rarely span an allele target from end to end and so mostly go uncounted, and short reads pushed through the full-length workflow cluster into nothing usable. The read-length check above is what keeps you out of both.

Both workflows need [plugin packs](../../GLOSSARY.md#plugin-pack) installed first, meaning the bundled sets of third-party programs that LGE downloads on demand into its own private storage. You install nothing yourself and nothing is added to the rest of your Mac. The MiSeq workflow needs the Third-Party Tools and Read Mapping packs, the second of which supplies [minimap2](../../GLOSSARY.md#minimap2) 2.31, the program that aligns reads to the allele library. The full-length workflow needs those two plus Full-length MHC Genotyping, which supplies Savont 0.6.3 for [clustering](../../GLOSSARY.md#clustering) and BLAST 2.16.0. Clustering means grouping near-identical reads into one representative sequence before matching. The version numbers are here so you can cite them in a methods section, not because you have to match them by hand, since LGE pins each one. [Plugin Packs](../01-foundations/07-plugin-packs.md) covers installing them.

### Enabling a genotyping workflow

All three items are specialized workflows, which means they do not appear ready to run until you enable them. Unlike the Classification or Assembly submenus, this one holds nothing that is available from the start, so a reader opening it for the first time sees three grey rows. An item you have not enabled shows in grey with `(not enabled)` after its name, and choosing it raises a message window offering to enable it rather than opening a run dialog. This is the most common point of confusion in this part of the manual. The Workflow Library turns a workflow on. The Tools menu runs it.

To turn one on, open **Tools > Workflow Library...**, find the workflow's card under the **Specialized Workflows** heading in the **Genotyping** group, and turn its **Enabled** switch on. The card carries a dependency row underneath reading either Ready or Needs install for the plugin packs the workflow needs. If it says Needs install, an **Install Dependencies** button replaces the switch, and it fetches the packs and enables the workflow when it finishes. That download needs a network connection and is the slow part, since the packs hold whole programs. Enabling a workflow whose packs are already installed is immediate. Once the switch is on, the workflow appears in **Tools > Genotyping** in black rather than grey and opens a dialog when you choose it.

## What counts as a supporting read

A genotyping run is strict about what it will count, and understanding the rule explains most of the numbers in a finished result.

The unit being judged is the [alignment](../../GLOSSARY.md#alignment), meaning one record of where a single read was placed against one allele target. An alignment is retained only when it covers the allele target from the first base of the reference record to the last. The read must also agree with the reference at every one of those bases. One substituted base disqualifies it.

The indel case is worth stating carefully, because it is easy to read the rule as more forgiving than it is. What LGE counts is substitutions, meaning positions where the read carries a different base from the reference. It counts those from the alignment's own record of matches and mismatches, and that record does not expose insertions and deletions to the count at all. So an insertion or a deletion inside the span does not by itself disqualify a read, while a single substitution does. In practice this rarely widens what passes, because a read must still cover every reference base and agree at every one it covers. Treat the rule as exact matching over the full length, with the narrow exception that a gap does not get counted as a mismatch.

Reads that fail any of those tests are discarded rather than counted weakly. The reason for the strictness is that the whole assay depends on exact matching. Take a read matching an allele target over 90 percent of its length with two differences. It is evidence for some allele, but not for that one. Counting it would create a call, meaning a statement that the animal carries that allele, which the data does not support.

The [retained read](../../GLOSSARY.md#retained-read) count that appears in a result cell is the number of reads that passed all of those tests for that allele target in that sample. Because the requirement is strict, the fraction retained out of everything sequenced is much smaller than a mapping workflow would report, and a low fraction is not by itself a problem. In the Williams run, 2,854,092 reads went in and 682,927 were retained, which is 23.9 percent. LGE defines no threshold for that percentage, so there is no number below which it warns you, and this manual has only the one worked run to go on. Take the Williams run's 23.9 percent as a single point of orientation rather than as a target, and compare your own runs against each other.

The run's own tally counts alignments rather than input reads, which is why its numbers do not subtract from the 2,854,092. The run produced 1,515,819 alignment records in total. Of those, 682,928 passed, 224,134 were unmapped, 311,914 failed to span the reference end to end, and 296,843 carried too many mismatches. Those four categories are exhaustive and sum to 1,515,819 exactly. The three rejection categories account for 832,891 discarded alignments between them. Those are the shapes to expect. A run where nearly everything passes is worth a second look. The usual explanation is that the allele library was built from these very reads. The reads are then being matched against themselves rather than against an independent catalogue, which guarantees a good-looking result and proves nothing.

One consequence of the full-span rule affects Illumina users specifically, and LGE handles it for you. Illumina reads arrive as [pairs](../../GLOSSARY.md#paired-end), two reads from opposite ends of the same fragment, and each half of a pair is called a mate. A single MiSeq mate is often shorter than the longest amplicons in a panel, so it cannot span them end to end no matter how good the sequencing was. In the IPD-MHC Mamu reference the class I amplicons are about 156 bases and the longest DRB amplicons are 244. A MiSeq reads up to about 250 bases per mate, and once the primer and adapter sequence at the ends are removed a single mate typically covers only about 198 bases of the amplicon, so neither mate alone covers a 244-base reference from its first base to its last. Left alone, every DRB allele would receive zero reads with no warning, while every shorter locus genotyped normally.

The workflow therefore runs [bbmerge](../../GLOSSARY.md#bbmerge) first, joining each overlapping pair into one longer fragment before mapping. Mates that fail to merge are still carried through as singles, and those singles are matched by the same rule as everything else. A single can therefore support a call at a locus short enough for one mate to span, which covers the class I loci. It can never support a DRB call, and that is exactly the gap merging exists to close. LGE reports no count of how many pairs merged. This step happens without a setting, and it is the reason a DRB call appears at all.

## What a finished run looks like

Both workflows write a `.lungfishgenotype` bundle, which is a folder LGE treats as one item so you click it once in the sidebar rather than opening the files inside it. Bundle is LGE's word for a folder the app presents as a single thing. It is an ordinary folder on disk, so you reach it either by clicking it in the LGE sidebar or by opening it in the Finder and looking at the files inside. The bundle lands under the project's `Analyses/` folder, and the MiSeq workflow gathers its runs into an `Amplicon genotyping results` subfolder inside it.

Clicking that bundle opens the [genotype matrix](../../GLOSSARY.md#genotype-matrix), the main view for a genotyping result. Its central grid holds one row per allele target and one column per sample, so a filled cell says that sample carried that allele and holds the retained read count behind it.

<!-- SHOT: genotype-matrix-overview -->

What the viewport offers at the top depends on what the run produced. A run that produced allele calls and nothing else, which is what the Williams project holds, offers a single **Genotype Matrix** view. A run that also carried out haplotype analysis offers a segmented toggle, a two-part control you click to switch between views, with **Haplotype Calls** beside **Genotype Matrix**. If you are looking for a Haplotype Calls segment and cannot find one, the run did not haplotype rather than the view being hidden.

Beside the bundle the run writes files you can read without LGE, chiefly a per-sample summary and a long-form table. Each row of the long table is one called allele in one sample. A sample therefore contributes as many rows as it has calls, and the total is the sum across samples rather than a fixed multiple of them. The Williams result's long table holds 2,109 such rows across its 30 samples, with individual samples contributing between 2 and 117 rows each. An Excel workbook is written alongside them, and [Exporting Genotypes](04-haplotype-definitions-and-export.md) covers taking a result elsewhere. Both workflows report progress into the [Operations panel](../../GLOSSARY.md#operations-panel) while they run, and the main window stays usable throughout.

## What good looks like

Four checks tell you a genotyping result is worth interpreting, and all four are visible without leaving the app.

LGE labels every sample with a status it works out from that sample's read counts, shown as OK, Low Support, or Review, and written into the result files as `ok`, `lowSupport`, and `review`. The Inspector counts how many samples fall into each. A sample is marked Low Support when it retained fewer than 1,000 reads or fewer than 20 alignments, and Review when it retained none at all. The Williams run produced only OK and Low Support samples, and the two checks below use those labels.

1. Every sample you submitted appears. A sample that produced no usable reads still gets a row in the genotype matrix, which lists every sample, so a missing sample means an input problem rather than a biological one.
2. The read counts per sample are in the same range as each other. In the Williams run the 23 samples marked OK carried between 1,976 and 58,370 retained reads, and the 7 marked Low Support carried between 2 and 713. What you are looking for is a clear separation rather than a smooth slide. A run whose weakest samples sit just under its strongest ones gives you no way to tell a failed sample from a lightly sequenced one.
3. Every locus you expect is represented. This is the check that catches the DRB failure described above and its equivalents in other panels. The 13 loci the Williams library reports are the ceiling for that panel, and its well-sequenced samples reach 11 to 13 of them. A count a little short of the ceiling is normal, because an animal need not carry a catalogued allele at every locus. Its Low Support samples carry as few as 2, which is the sign of a sample that failed rather than of an unusual genotype. A well-sequenced sample missing a whole locus is worth investigating.
4. The allele library was the one you meant to use. A run against the wrong species or the wrong library version produces a full result that is entirely wrong, and nothing about the numbers reveals it. The bundle's provenance record names the reference file the run read. You reach it in the Inspector, the panel down the right-hand side of the window, which **View > Show Inspector** opens if it is hidden.

The judgement a genotyping result asks of you is different from the one a variant call asks. A variant caller puts a confidence number on every call, telling you how sure it is. A genotyping run gives you no such number, because a call is an exact match or nothing. What you are judging instead is whether the sample had enough reads for an empty cell to mean the allele is truly not there, rather than that the sample failed.

LGE defines no read count at which an empty cell becomes trustworthy. Its 1,000-read Low Support line flags a weak sample. It is not a promise that a sample above it was sequenced deeply enough for every absence to be real, and this manual will not invent a second number. What the Williams run offers is orientation. Its samples span 2 to 58,370 retained reads, its Low Support samples top out at 713, and its OK samples start at 1,976. A sample with 2 retained reads has told you nothing. Reading its empty cells as a homozygous animal, meaning one carrying the same allele on both chromosome copies, is the most consequential mistake available in this workflow. Judge each sample against the rest of your own run as well as against that line.

## Next

Continue to [Running Amplicon MHC Genotyping](02-running-genotyping.md), which walks a run from selecting reads to a finished bundle. [Reading the Genotype Comparison](03-reading-the-genotype-comparison.md) covers the matrix, its filters, and the per-sample workbench once you have a result open. [Exporting Genotypes](04-haplotype-definitions-and-export.md) covers getting a result out of LGE as a workbook or a set of CSV files.

The genotype viewport also carries a manual haplotyping mode for assigning haplotypes by hand, which is not documented in this release and which you do not need for any task in this part.
