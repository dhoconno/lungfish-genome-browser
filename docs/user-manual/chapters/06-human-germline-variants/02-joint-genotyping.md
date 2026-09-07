---
title: Joint Genotyping
chapter_id: 06-human-germline-variants/02-joint-genotyping
audience: power-user
prereqs: [06-human-germline-variants/01-haplotype-caller, 01-foundations/07-plugin-packs]
estimated_reading_min: 30
task: Combine per-sample GVCFs into one cohort VCF with GATK joint genotyping from the command line.
tags: [gatk, genotypegvcfs, combinegvcfs, genomicsdb, joint-genotyping, cli]
tools: [gatk]
parameters_refs: [variants.gatk-plans]
entry_points:
  - "CLI: lungfish-cli gatk joint-genotype --reference <fasta> --gvcf <gvcf> --intermediate <path> --output <vcf>"
shots: []
illustrations: []
glossary_refs: [allele-specific-annotation, checksum, cohort, combinegvcfs, genomicsdb, genotype, genotypegvcfs, gvcf, indel, interval-list, joint-genotyping, phred-score, plugin-pack, provenance-sidecar, reference-genome, tabix, vcf]
features_refs: [variants.gatk-germline]
fixtures_refs: [hg002-chr20]
brand_reviewed: true
lead_approved: true
---

## What it is

Joint genotyping has no dialog and no menu item in Lungfish Genome Explorer (LGE), so everything in this chapter runs from the command line in a terminal. A terminal is a window in which you type commands one line at a time instead of clicking, and on a Mac it is the Terminal application in your Applications folder under Utilities. If you have never opened one, read [CLI Reference](../appendices/cli-reference.md) first, which covers where LGE's command line tool lives and how to run it. The previous chapter, [HaplotypeCaller](01-haplotype-caller.md), ends with one file per sample. This chapter turns several of those files into one table that covers every sample at once.

The file each sample arrives in is a [GVCF](../../GLOSSARY.md#gvcf), a variant file that records the sample's state at every position of the [reference genome](../../GLOSSARY.md#reference-genome) rather than only where it differs. A reference genome is the agreed sequence that everything else is described against. An ordinary [VCF](../../GLOSSARY.md#vcf), which is a plain text table whose columns are separated by tab characters and which lists the positions where a sample differs from that reference, says nothing at all about the positions it leaves out, so a missing row in a VCF is ambiguous. It could mean the sample matched the reference, or it could mean nobody looked. A GVCF removes that ambiguity by carrying a confidence figure at every position, and that figure is the caller's confidence in the sample's state there, the same quantity the finished cohort VCF later reports per sample as `GQ`. That is exactly what a later step needs in order to compare samples fairly.

[Joint genotyping](../../GLOSSARY.md#joint-genotyping) is the step that reads those per-sample GVCFs together and decides the [genotype](../../GLOSSARY.md#genotype) of every sample at every variant position in one pass. A genotype is the notation saying which copies of a position a sample carries. In it `0` stands for the reference base and `1` for the alternate base, so a diploid sample reads `0/1` when one of its two copies differs from the reference and `1/1` when both do. Calling each sample alone gives you a set of tables you then have to compare position by position yourself, and a position missing from one table tells you nothing about why. Calling them together gives you one table with one column per sample and an explicit call in every cell.

LGE builds this as two GATK commands rather than one. The first gathers the GVCFs into a single combined store, which is either one file or one folder depending on which combining tool runs, and the second reads that store and writes the finished [cohort](../../GLOSSARY.md#cohort) VCF, a cohort being the set of samples you are genotyping and comparing together. Use this chapter once you have a GVCF per sample and you want them genotyped against each other rather than one at a time.

## Why you would do this

The reason joint genotyping matters in human germline work is that most of the questions people ask of a set of samples are comparisons. Which family members carry the variant the patient carries, which controls do not, which position differs between a tumour and its matched normal sample, meaning healthy tissue taken from the same patient as the tumour so that the two can be compared directly. Every one of those questions needs the same position evaluated in every sample, including the samples where nothing was found.

Per-sample calling cannot answer them cleanly. If a variant appears in sample A's VCF and is absent from sample B's, you cannot tell from those two files whether sample B genuinely matches the reference there or whether no reads covered the position in sample B at all. Joint genotyping answers it, because the GVCFs carry sample B's confidence at that position whether or not sample B had a variant, and the cohort VCF puts sample B's call in a cell next to sample A's.

The worked example below uses the HG002 chromosome 20 slice, which is the small practice dataset this manual ships for human germline work. HG002 is a consenting research participant whose DNA is distributed as a cell line, so laboratories everywhere sequence the same genome, and the slice is a chosen 500 kilobase stretch of chromosome 20 rather than the whole thing, which keeps every run in this chapter down to seconds. It holds one sample rather than several. That is a genuine limitation of the practice data and it is worth stating plainly, because a one-sample cohort cannot demonstrate the comparison the step exists for. What it can demonstrate is every mechanical part of the run, which is what this chapter records, and the command you type is identical for two samples or two hundred. Repeat the `--gvcf` option once per sample and nothing else in the command changes, though LGE does switch combining tools on your behalf above 50 samples, which the Settings section explains.

## Before you start

Everything in this chapter runs from the command line in a terminal. Joint genotyping has no dialog and no menu item in LGE, so there is no window to open for it, and no step below happens inside the app. Open the Terminal application, which sits in the Utilities folder inside your Applications folder, and keep it open for the whole chapter. Every command below uses bare filenames with no folder in front of them, so put all of the files named in this section in one folder and run every command from that folder. Type `cd `, then drag the folder from a Finder window onto the terminal window, then press Return, and the terminal is looking at that folder.

You need a project open. If you do not have one, choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window, and pick a folder. The project is where LGE keeps the reads and results you work with in the app, and this chapter needs it only because the app expects one to exist. The files used below do not need to sit inside the project folder, because the command line tool writes wherever you point it.

This chapter uses the HG002 chromosome 20 slice. You need three files from it, the reference `GRCh38.chr20.10.0-10.5Mb.fasta`, its `.fai` index `GRCh38.chr20.10.0-10.5Mb.fasta.fai`, and the paired read files `HG002.chr20.10.0-10.5Mb_R1.fastq.gz` and `HG002.chr20.10.0-10.5Mb_R2.fastq.gz` that the GVCF is made from. The `.fai` index is a small companion file listing where each sequence starts inside the FASTA, so a tool can jump to a position without reading the whole file, and it ships in the fixture folder beside the FASTA rather than being something you make. GitHub offers no download for a single folder, so open the repository's front page at https://github.com/dhoconno/lungfish-genome-explorer, click the green **Code** button, choose **Download ZIP**, double-click the downloaded file to unpack it, and find the folder inside it under `docs/user-manual/fixtures/`. The folder you want is `hg002-chr20`.

You also need at least one GVCF, and there is no fixture copy of one, so make it by running HaplotypeCaller in GVCF mode as [HaplotypeCaller](01-haplotype-caller.md) describes. That chapter offers a dialog route and a command line route, and either produces the same file. The one command that produces it is below, and the flag that matters is `--emit-ref-confidence GVCF`, which asks the caller for reference confidence so it writes a GVCF rather than an ordinary VCF. A plain VCF cannot be joint-genotyped and the run will fail on it. The command needs an alignment of the reads to the reference, which [Mapping Reads to a Reference](../04-alignments/01-mapping-reads-to-a-reference.md) produces as `HG002.sorted.bam`.

```bash
lungfish-cli gatk haplotype-caller \
    --reference GRCh38.chr20.10.0-10.5Mb.fasta \
    --bam HG002.sorted.bam \
    --output HG002.g.vcf.gz \
    --emit-ref-confidence GVCF \
    --execute
```

GATK comes from the GATK Core [plugin pack](../../GLOSSARY.md#plugin-pack), a themed group of tools LGE installs on demand, and it is not installed by default. This feature is experimental. Turn on **Show Experimental Features** in **Settings > Advanced** before you look for it. Experimental here describes the LGE wrapper around the tool rather than the calls themselves, since the calls come from GATK unchanged, so what it warns you about is that flags and defaults on this subcommand may move between releases rather than that the numbers are unsound. With that toggle on, open **Tools > Plugin Manager...** (Cmd-Shift-B), go to the Packs tab, and install the GATK Core card. The pack installs exactly version 4.6.2.0 of GATK and no other. Its card reports about 600 MB, and the installed environment measures closer to 890 MB on disk, so allow time for the download.

Install the pack through the Plugin Manager rather than the command line, because the command line route that other chapters use does not work for this pack. Running `lungfish-cli conda install --pack gatk-core` answers `Unknown tool pack: gatk-core` and lists eight packs that do not include it, because the installer only offers the packs it considers non-experimental. That is a defect in LGE rather than a design choice, and until it is fixed the Plugin Manager is the only route.

GATK also needs one more small companion file beside your reference FASTA, and LGE never produces it. That file is a sequence dictionary named `GRCh38.chr20.10.0-10.5Mb.dict`, a short list of every sequence in the FASTA and its length, and you make it once with GATK's own tool. The pack installs GATK at `~/.lungfish/conda/envs/gatk-core/bin/gatk`, so call it by that full path. The leading tilde is the terminal's shorthand for your home folder, the one holding Documents and Downloads, and you type it as the character above the backtick at the top left of the keyboard rather than spelling out your user name.

```bash
~/.lungfish/conda/envs/gatk-core/bin/gatk CreateSequenceDictionary \
    -R GRCh38.chr20.10.0-10.5Mb.fasta
```

That writes `GRCh38.chr20.10.0-10.5Mb.dict` beside the FASTA, prints a few lines of GATK's own startup logging and nothing you need to act on, and you never touch the file again.

One more program is used in this chapter, and you already have it. Reading a compressed VCF needs bcftools, which LGE installs with its Required Setup pack the first time you run the app, so there is nothing to fetch by hand.

Both runs recorded in this chapter finished in under five seconds on the 500 kilobase slice. A whole human genome across a real cohort takes far longer, and no figure is quoted here because none was measured. LGE allows a single GATK step 24 hours before it gives up on it, and no flag on this subcommand changes that limit.

## Procedure

Joint genotyping runs from the command line only. It has no dialog in LGE, no menu item, and no entry in the Call Variants dialog's tool list, which is worth stating plainly rather than letting you hunt for a window that does not exist. The Call Variants dialog reaches two GATK tools, GATK HaplotypeCaller and GATK + WhatsHap Phased, and joint genotyping is not among the tools it offers.

The command line tool is `lungfish-cli`, typed as a bare word because installing LGE puts it where the terminal already looks for programs, unlike GATK, which the plugin pack installs off to one side and which therefore needs its full path. Check that the terminal can find it by typing `lungfish-cli --version` and pressing Return before you go on. If the terminal answers that the command was not found, [CLI Reference](../appendices/cli-reference.md) covers what to do.

In the commands below, a backslash at the end of a line continues one command onto the next line, so you can paste a whole block as a single command. The backslash leans the other way from the forward slashes inside the file paths, `\` rather than `/`, and on a Mac keyboard it sits above the Return key.

Each setting you add is a flag, meaning a word beginning with two dashes, sometimes followed by a value. The Settings section describes every flag this subcommand takes.

**Step 1.** Preview the commands without running anything. The flag that actually runs a job is `--execute`, and leaving it off is the default, so a command without it prints the plan and stops.

```bash
lungfish-cli gatk joint-genotype \
    --reference GRCh38.chr20.10.0-10.5Mb.fasta \
    --gvcf HG002.g.vcf.gz \
    --intermediate cohort.combined.g.vcf.gz \
    --output cohort.vcf.gz
```

The file named by `--intermediate` does not have to exist beforehand. The run creates it, and the run creates the output VCF too.

The command prints the two GATK command lines it composed and stops. Here is what the recorded run printed. The directory part of each path is shortened to three dots, and the path to GATK itself is shortened the same way, both purely so the lines fit this page. Your own terminal prints the full paths, so the block below is a record to read rather than something to paste and run.

```
gatk CombineGVCFs -R .../GRCh38.chr20.10.0-10.5Mb.fasta -O .../cohort.combined.g.vcf.gz --variant .../HG002.g.vcf.gz
gatk GenotypeGVCFs -R .../GRCh38.chr20.10.0-10.5Mb.fasta -V .../cohort.combined.g.vcf.gz -O .../cohort.vcf.gz --standard-min-confidence-threshold-for-calling 30.0 -G AS_StandardAnnotation
```

Two of those options were never typed. `--standard-min-confidence-threshold-for-calling 30.0` and `-G AS_StandardAnnotation` are added by LGE on every run, so seeing them in the preview means the command was built correctly rather than that something went wrong. The Settings section says what each one does.

Read the first word after `gatk` on the first line, because that is where you learn which of the two combining tools LGE picked for your cohort size. It reads either `CombineGVCFs`, which merges the GVCFs into one file, or [`GenomicsDBImport`](../../GLOSSARY.md#genomicsdb), which imports them into an on-disk store built for many samples. The Settings section explains the choice.

**Step 2.** Run it for real by adding `--execute`.

```bash
lungfish-cli gatk joint-genotype \
    --reference GRCh38.chr20.10.0-10.5Mb.fasta \
    --gvcf HG002.g.vcf.gz \
    --intermediate cohort.combined.g.vcf.gz \
    --output cohort.vcf.gz \
    --execute
```

Add one `--gvcf` for each further sample. The command prints two lines when it finishes.

```
GATK execution completed with exit code 0.
Provenance: .../.lungfish-provenance.json
```

An exit code is the number a command hands back to the terminal when it stops, and `0` always means success while any other number means failure. The word after `Provenance:` is the path of the [provenance sidecar](../../GLOSSARY.md#provenance-sidecar), a small file LGE writes beside your results recording exactly what it ran, described at the end of the next section.

The exit code on that first line is the exit code of the last GATK step rather than a figure for the run as a whole, so on a successful two-step run it is the code from [GenotypeGVCFs](../../GLOSSARY.md#genotypegvcfs), the second of the two GATK tools. The two could differ if, say, the combine step failed and no genotyping step ever ran, in which case the line reports what the genotyping step would have returned rather than the combine step's failure. When a run fails, read the sidecar rather than that line, and the failure paragraph in the next section says what the sidecar holds.

The recorded run took 3.30 seconds of wall time, meaning elapsed clock time from start to finish. No duration is quoted for your own machine, because the time depends on how many samples you pass and how much of the genome they cover.

**Step 3.** Read the cohort VCF. It is compressed, so it is not a file to double-click, and one command prints its first lines.

```bash
bcftools view cohort.vcf.gz | head -40
```

That shows the header followed by the first few variant rows. The next section explains what is in them.

## Settings

Joint genotyping has no dialog, so it has no dialog settings. Every setting is a command-line flag, so each entry below ends by naming the flag rather than pointing at a control. Three of them are required and the run refuses to start without them, **Reference**, **Output**, and **Intermediate**. A fourth, **GVCF**, ought to be required and is not, which the entry below explains. Three further flags, `--execute`, `--dry-run`, and `--extra-args`, are shared by all ten subcommands of `lungfish-cli gatk`. Six of the other nine subcommands are covered in [Filtering, Selecting, and Metrics](03-filtering-selecting-and-metrics.md) and [Reference Files for GATK](04-reference-packs.md), one is the `haplotype-caller` of the previous chapter, and the remaining two, `markdup` and `validate-sam`, are not covered anywhere in this manual.

**Reference.** Names the reference FASTA that both GATK steps are run against, which must be the same reference the GVCFs were called against. There is no default and the flag is required, because GATK cannot interpret a GVCF's coordinates without the sequence they refer to. Change it for each reference you work with, and make sure its `.fai` index and `.dict` dictionary sit beside it. On the command line this is `--reference`.

**GVCF.** Names one input GVCF, and you repeat the whole flag once for each sample rather than giving it a list of files. There is no default, and although the GVCFs are the whole of the evidence the step works from, LGE does not enforce that you pass any. Give one for every sample in the cohort, and pass GVCFs rather than ordinary VCFs, since a file without reference confidence carries nothing for the step to compare. On the command line this is `--gvcf`.

Passing no `--gvcf` at all is accepted when it should be refused, which is a defect in LGE rather than something you can configure. A command with a reference, an intermediate, and an output but no `--gvcf` exits `0` and prints a `CombineGVCFs` line carrying no input file, and adding `--execute` would hand GATK that empty command. Count your `--gvcf` flags against your samples before you run, because nothing else will.

**Output.** Names the cohort VCF the run writes, which is the finished answer with one column per sample. There is no default and the flag is required. Give each cohort its own output path, and expect a [tabix](../../GLOSSARY.md#tabix) index to appear beside it, tabix being the standard companion file that lets a program jump straight to a position in a compressed VCF instead of reading from the top, named after the VCF with `.tbi` appended. On the command line this is `--output`.

**Intermediate.** Names the combined store the first GATK step writes and the second step reads. There is no default and the flag is required either way, which is easy to miss because it has no equivalent in single-sample calling. Give it a path ending `.g.vcf.gz` when CombineGVCFs runs and a plain folder name when GenomicsDBImport runs, which under the default `auto` means a path ending `.g.vcf.gz` for any cohort of 50 samples or fewer. On the command line this is `--intermediate`.

**Combine strategy.** Chooses which GATK tool gathers the GVCFs before genotyping, either [CombineGVCFs](../../GLOSSARY.md#combinegvcfs), which merges them into one file and grows slow and large once the sample count climbs, or [GenomicsDB](../../GLOSSARY.md#genomicsdb), which imports them into an on-disk store built for many samples and carries setup cost that is wasted on a handful. The default is `auto`, which picks CombineGVCFs for cohorts of 50 samples or fewer and GenomicsDB above that. A cohort of exactly 50 uses CombineGVCFs. Set it to `combine-gvcfs` or `genomicsdb` when you want the same tool used every time regardless of how many samples you happen to pass, which matters in an automated series of steps that must not change behaviour as a cohort grows past 50. On the command line this is `--combine-strategy`.

**Intervals.** Restricts both GATK steps to the stretches of the reference named in an [interval list](../../GLOSSARY.md#interval-list), which can be a BED file, a Picard-style interval list, or a bare contig name such as `chr20`. Picard is another widely used genomics toolkit, and its interval list is a plain text file, as a BED file is. The default is empty, so the whole reference is genotyped. Set it when you only care about a defined region, such as a gene panel, because restricting both steps rather than filtering afterwards saves the time the combine step would have spent on the rest of the genome. On the command line this is `--intervals`.

**Extra args.** Appends further arguments to the final `GenotypeGVCFs` command, after the ones LGE composed. The default is empty, and the arguments land only on the genotyping step, never on the combine or import step. Use it for GATK options LGE does not expose as flags of its own, and put the whole set inside one pair of straight double quotes, the plain `"` a terminal expects rather than the curly quotes a word processor makes, for example `--extra-args "--max-alternate-alleles 3"`. On the command line this is `--extra-args`.

**Execute.** Runs both GATK steps through the GATK Core pack instead of only printing them. The default is false, so a command with neither this flag nor `--dry-run` prints the two command lines and stops without running anything or writing any file. Add it once you have read the preview and want the cohort VCF. On the command line this is `--execute`.

**Dry run.** Forces a run to stop at the preview even when `--execute` is present, since it overrides `--execute` whenever both are given. The default is false, and given on its own it changes nothing, because not executing is already what happens without `--execute`. Reach for it only in a script where `--execute` is fixed in the command and you want one run to stop short, and a recorded run confirmed the override by printing the two commands and writing no files. On the command line this is `--dry-run`.

Three GATK options are set for you and cannot be changed from this subcommand, which is worth knowing because they shape every number in the result.

The genotyping step always receives `--standard-min-confidence-threshold-for-calling 30.0`. That 30 is a [Phred score](../../GLOSSARY.md#phred-score), a confidence measured on a logarithmic scale where 10 means the caller expects to be wrong about one time in ten, 20 one time in a hundred, and 30 one time in a thousand, so every ten points divides the expected error rate by ten again. A candidate scoring below 30 is not written out at all, which makes the threshold a fairly strict one.

The genotyping step also always receives `-G AS_StandardAnnotation`, which asks GATK for [allele-specific annotations](../../GLOSSARY.md#allele-specific-annotation). An annotation is an extra measurement the caller records alongside a call, and an allele-specific one is recorded separately for each alternate allele on a row rather than once for the whole row. Their keys all carry an `AS_` prefix.

And each step runs with its working directory set to the folder holding that step's own output, the working directory being the folder a program treats as its own while it runs. That one needs nothing from you.

There is no flag for any of the three, so the only way to change the confidence threshold is to pass a second copy of it through `--extra-args`, for example `--extra-args "--standard-min-confidence-threshold-for-calling 20.0"`. Passing a flag twice looks like a mistake and is not one here, because LGE's copy lands first on the `GenotypeGVCFs` line and yours lands after it, and GATK takes the last value it is given.

One behaviour of the strategy flag deserves care. An unrecognised value is not rejected. LGE falls back to `auto` and says nothing, so a typo such as `--combine-strategy genomics-db` with a hyphen in the middle quietly runs the automatic choice instead of the GenomicsDB one you asked for. A recorded run with that exact typo printed `CombineGVCFs` with no warning. Nothing later in the run warns you either, and the finished cohort VCF looks the same whichever tool made it, so the preview in step 1 is the only way to catch it. The first word after `gatk` tells you what you actually got.

## Reading the results

A finished run leaves five files beside the paths you named.

| File | What it holds |
|---|---|
| `cohort.vcf.gz` | The cohort VCF, one row per variant position and one column per sample |
| `cohort.vcf.gz.tbi` | The tabix index that lets a viewer jump to a position in it |
| `cohort.combined.g.vcf.gz` | The combined GVCF the first step wrote |
| `cohort.combined.g.vcf.gz.tbi` | The tabix index for that combined GVCF |
| `.lungfish-provenance.json` | The LGE provenance sidecar for the whole run |

The provenance file's name begins with a dot, which macOS treats as hidden, so it will not appear in a Finder window until you press Cmd-Shift-Period to show hidden files. It holds text in JSON format, so any text editor opens it, TextEdit included.

The size difference between the inputs and the answer is the clearest picture of what the step did. The recorded run's input GVCF held 48,057 rows across the 500 kilobase slice, because a GVCF carries a row for every position or block of positions whether or not anything varies there. The cohort VCF that came out held 1,026 rows, one for each position where something actually differed. That is a reduction of roughly forty-seven fold, and on your own germline data expect the same order, tens of rows in to one row out, rather than a precise ratio.

Of those 1,026 rows, 844 are substitutions of one base for another and 182 are [indels](../../GLOSSARY.md#indel), meaning insertions or deletions where the reference and the sample differ in length. Those two figures follow this manual's counting rule, which reads only the first alternate allele on a row and gives the whole row that one type. A count made with bcftools' own type headings comes out as 843 and 184 instead, because bcftools counts a row once per alternate allele. One row in this file, at position 29224, offers both a substitution and an insertion, so bcftools counts it twice and the manual counts it once. That is why 843 plus 184 exceeds the 1,026 rows the file holds while 844 plus 182 lands on it exactly.

So the genotyping step is where reference confidence stops being carried and only the variant positions survive.

Here is the first row of the recorded cohort VCF. Its columns, in order, are CHROM, POS, ID, REF, ALT, QUAL, FILTER, INFO, FORMAT, and then one column per sample. The row is one long line in the file, wrapped across two lines here to fit the page, and the three dots inside the INFO column stand for the INFO keys this chapter does not discuss.

```
chr20_10.0-10.5Mb	2078	.	G	A	2175.06	.
AC=2;AF=1;AN=2;AS_QD=25.36;DP=62;...;QD=28.73;SOR=0.76	GT:AD:DP:GQ:PL	1/1:0,60:60:99:2189,180,0
```

The last column is the part joint genotyping produced. Its keys are declared by the `GT:AD:DP:GQ:PL` column before it, so read the two in parallel. `GT` is the genotype, here `1/1`, meaning both copies of this position carry the alternate base. `AD` is the pair of read counts supporting the reference base and the alternate, here `0,60`, so no read carried the reference. A `1/1` call with zero reference reads is the expected pattern rather than a surprise, since a sample carrying the alternate on both copies has nothing left to produce a reference read. `DP` is the depth, meaning the number of reads covering the position, here 60. `GQ` is the confidence in the genotype call, and `PL` holds the same information as a set of scores for every possible genotype, which nothing in this chapter needs.

Two numbers on that row are confidences on the same Phred scale, and they measure different things. `QUAL`, the sixth column, is `2175.06` here and says how confident GATK is that this position carries a variant at all. `GQ`, inside the sample column, is `99` here and says how confident GATK is in the particular genotype it assigned that sample. On a Phred scale 20 means an expected error rate of one in a hundred and 30 means one in a thousand, so the 30 threshold the genotyping step always applies to `QUAL` is a fairly strict one, and a `GQ` under 20 is weak while 99 is the ceiling GATK writes. In a real cohort there is one sample column per sample, which is the whole point of the step.

The two depth figures on the row also differ by definition rather than by error. `DP=62` in the INFO column sums the depth across every sample at this position, and `DP` inside the sample column is 60 because that is what this one sample contributed. On a one-sample cohort the two are close, and on a real cohort the INFO figure is the larger by far.

The `AS_QD` key in the INFO column is one of the allele-specific annotations the run always asks for. The recorded cohort VCF declared eight `AS_` keys in its header, and none of the eight is needed to read a result. Plain `QD` is quality divided by depth, one figure for the whole row, and `AS_QD` gives one such figure per alternate allele, which is what lets you judge a position carrying two different alternate alleles without the weaker one being hidden inside a single averaged figure.

Two figures tell you the run behaved as expected. The lowest `QUAL` in the recorded cohort VCF was 31.6, just above the 30.0 threshold the genotyping step always applies, which is what you should expect since anything lower was discarded before it was written. Mean depth across the 1,026 rows was 39.4 reads, which is the mean of the INFO `DP` field and so sums across samples at each position. The previous chapter reports 38 for the same positions, which is the mean of the per-sample FORMAT `DP` field, so the two differ by definition rather than because one of them is wrong. Neither number has a target to hit. Judge depth against the alignment's own depth over the same region, which [HaplotypeCaller](01-haplotype-caller.md) reports as 44.7 reads for this slice, and expect the called positions to sit a little below it.

The FILTER column is worth a specific warning. Every row in the recorded cohort VCF carried a bare `.` in that column. A `.` there means no filter was applied to the row. It does not mean the row was tested and passed. Joint genotyping applies no quality filters at all, so a bare `.` is easy to misread as approval. Filtering is a separate step, covered in [Filtering, Selecting, and Metrics](03-filtering-selecting-and-metrics.md), and until you run it the cohort VCF is unfiltered.

The provenance sidecar is the reproducibility record. It holds one entry per GATK step, so a two-step run records both, each with its full command, the exit code, the wall time, and the exact tool version `4.6.2.0`. It also records the path of the conda environment GATK ran from, every resolved option including the three you cannot change, and a SHA-256 [checksum](../../GLOSSARY.md#checksum) and byte size for each file. A checksum is a short string computed from a file's contents, so it acts as a fingerprint, and SHA-256 is simply the recipe used to compute it, which you need know nothing more about. Change one byte and the checksum changes, which is how it proves later that the file you hold is the file the run used. Cite the sidecar when you write up a method rather than retyping the command from memory, so a methods section reads along the lines of "Joint genotyping used GATK 4.6.2.0 through Lungfish Genome Explorer, with the full command and file checksums recorded in the accompanying provenance sidecar."

A failed run is handled carefully and leaves a usable record. A recorded run pointed at a GVCF that did not exist printed `Error: GATK command failed with exit code 2.` followed by the path of the provenance file. Any exit code other than `0` means failure, and the 2 here is GATK's own. LGE removes the result files it had created before it gives up, so no partial cohort VCF is left behind, and the one file it does leave is the provenance sidecar. That record carries the status `failed` and the failing step's exit code, so the sidecar is where you look to find out which of the two steps went wrong.

The GenomicsDB path produces the same cohort VCF but a differently shaped intermediate. A recorded run forcing `--combine-strategy genomicsdb` with `--intervals` restricted to the first 100 kilobases of the slice wrote a `gdb-workspace` directory holding a `callset.json`, a `vidmap.json`, a `vcfheader.vcf`, and one subdirectory per interval. Those are GATK's own internal bookkeeping, you never open any of them by hand, and once the cohort VCF exists the whole workspace directory can be deleted unless you plan to add more samples to the same store later.

The cohort VCF that came out of that run held 258 rows and its last row sat at position 99,174, just inside the 100 kilobase boundary. The unrestricted run over the whole 500 kilobase slice held 1,026 rows reaching to the end of it, so both figures moved. That is what tells you `--intervals` restricted both steps rather than only the second one. Had the restriction applied only at genotyping, the import step would still have read the whole slice.

## What good looks like

Check these before you trust a cohort VCF. Each check is one command, run from the folder holding the files.

Every sample you passed should appear as a column in the output. The file is compressed, so `bcftools query -l cohort.vcf.gz` is what lists the sample names, one per line. The recorded single-sample run listed exactly one, `HG002`. A sample missing from that list was not genotyped, whatever the exit code said, and the usual cause is a `--gvcf` flag left out of the command, so count your flags against your samples and run it again.

The row count should collapse sharply from the input. Count with `bcftools view -H cohort.vcf.gz | wc -l`. The recorded run went from 48,057 GVCF rows to 1,026 cohort rows, a reduction of roughly forty-seven fold, and anything of that order is healthy. A cohort VCF within a few fold of its input GVCF suggests reference confidence was carried through rather than resolved, which usually means an ordinary VCF was passed where a GVCF was expected.

The strategy in the preview should be the one you meant. Run step 1 first and read the first word after `gatk` on the first line, because a mistyped `--combine-strategy` value falls back to the automatic choice without complaining.

The lowest `QUAL` should sit at or above 30. Find it with `bcftools query -f '%QUAL\n' cohort.vcf.gz | sort -g | head -1`, which prints every row's quality, sorts them low to high, and shows the first. On the recorded run it was 31.6. A row below 30 in a cohort VCF from this command would mean the threshold was overridden through `--extra-args`, so check what you passed.

Do not read a bare `.` in the FILTER column as a pass. Joint genotyping applies no filters, so every row carries `.` until you run the filtering step in the next chapter.

## On the command line

The whole procedure, from a per-sample GVCF to a cohort VCF. This section repeats the steps above in one block rather than adding anything to them, so nothing here is a route the earlier sections leave out. Run every line from the folder holding your files, which the first line of the block does for you.

```bash
# Move the terminal to the folder holding the FASTA, the GVCF, and the rest.
cd ~/Downloads/hg002-chr20

# Once per reference, build the sequence dictionary GATK needs beside the FASTA.
~/.lungfish/conda/envs/gatk-core/bin/gatk CreateSequenceDictionary \
    -R GRCh38.chr20.10.0-10.5Mb.fasta

# Step 1, read the two commands before running anything.
lungfish-cli gatk joint-genotype \
    --reference GRCh38.chr20.10.0-10.5Mb.fasta \
    --gvcf HG002.g.vcf.gz \
    --intermediate cohort.combined.g.vcf.gz \
    --output cohort.vcf.gz

# Step 2, run both steps and write the cohort VCF and the provenance sidecar.
lungfish-cli gatk joint-genotype \
    --reference GRCh38.chr20.10.0-10.5Mb.fasta \
    --gvcf HG002.g.vcf.gz \
    --intermediate cohort.combined.g.vcf.gz \
    --output cohort.vcf.gz \
    --execute
```

For a real cohort, repeat `--gvcf` once per sample and nothing else changes.

```bash
lungfish-cli gatk joint-genotype \
    --reference GRCh38.chr20.10.0-10.5Mb.fasta \
    --gvcf sample1.g.vcf.gz \
    --gvcf sample2.g.vcf.gz \
    --gvcf sample3.g.vcf.gz \
    --intermediate cohort.combined.g.vcf.gz \
    --output cohort.vcf.gz \
    --execute
```

To force the GenomicsDB store and restrict both steps to a region, point `--intermediate` at a directory rather than a file. The `first100kb.bed` in the last block is a BED file you write yourself in any text editor, one region per line, holding a single tab-separated line naming the sequence, the start, and the end.

```
chr20_10.0-10.5Mb	0	100000
```

```bash
lungfish-cli gatk joint-genotype \
    --reference GRCh38.chr20.10.0-10.5Mb.fasta \
    --gvcf HG002.g.vcf.gz \
    --intermediate gdb-workspace \
    --output cohort.gdb.vcf.gz \
    --combine-strategy genomicsdb \
    --intervals first100kb.bed \
    --execute
```

## Next

The cohort VCF this chapter produces is unfiltered, so every row carries a bare `.` in its FILTER column whatever its quality. [Filtering, Selecting, and Metrics](03-filtering-selecting-and-metrics.md) covers the GATK steps that mark the calls not worth trusting, pull one sample or one variant type out of a cohort, and summarise a finished call set.
