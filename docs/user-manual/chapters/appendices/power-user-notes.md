---
title: Power User Notes
chapter_id: appendices/power-user-notes
audience: power-user
prereqs: []
estimated_reading_min: 45
task: Look up the exact arguments Lungfish Genome Explorer passes to each wrapped tool, the shape of a provenance record, and the reproducibility caveats the workflow chapters leave out.
tags: [reference, power-user, mpileup, ivar, lofreq, minimap2, kraken2, assembly, gatk, provenance, determinism, reproducibility]
tools: [samtools, bcftools, ivar, lofreq, minimap2, bwa-mem2, bowtie2, kraken2, spades, megahit, skesa, flye, hifiasm, gatk]
entry_points: []
shots: []
illustrations: []
glossary_refs: [absolute-path, advisory-lock, allele-frequency, alternate-read, amplicon, argument, assembly-graph, baq, bed, bracken, bundle, camel-case, checksum, codon, command-line-flag, conda, continuous-integration, contig, dependency-set, determinism, dialog, exit-status, gvcf, haplotype, hg002, indel, ivar, json, kraken2, linkage, lofreq, mapping-quality, oci-layout, phase, phred-score, pileup, pivot-workbook, plugin-pack, primer-trim, process-id, provenance-sidecar, read-group, ref-alt, reference-bundle, secondary-alignment, sliding-window-trimming, smart-filter-token, stderr, strand-bias, symlink, thread, vcf, wall-time, wrapper]
features_refs: []
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

## What it is

This appendix is for readers who want the exact argument list underneath a setting, rather than a description of what the setting does. Most of it needs a terminal, meaning the Terminal application where you type a command and press Return. The [CLI Reference](cli-reference.md) opens with two sections, "Before you type anything" and "Finding the program", that say how to open Terminal and how to make the name `lungfish-cli` work at a prompt. Read those first if you have not used a terminal before.

A reader who only uses the Lungfish Genome Explorer (LGE) window can still act on two sections of this page. [The consolidated caveat list](#the-consolidated-caveat-list) names every reproducibility defect the 2026-09 campaign found and what to do about each one, and [Debugging from the Operations panel](#debugging-from-the-operations-panel) is entirely a window procedure. The rest of the page describes command lines you would have to type, so skip it without loss.

The workflow chapters of this manual leave things out on purpose. To keep them readable for someone at a bench, they describe what a setting does and skip the argument list underneath it. This appendix is where the argument lists live. It also holds the shape of the record LGE keeps of each run, and the honest limits on repeating a run and getting the same answer.

Every command here was read out of the LGE source code, meaning the app's own program text, that builds it. The same text appears in the [provenance sidecar](../../GLOSSARY.md#provenance-sidecar), the small JSON file LGE writes beside a result recording exactly how that result was made. Reading the flags here is faster than opening a sidecar and working backwards, and it lets you check LGE's choices before you start a run.

Three conventions hold throughout. Argument lists are shown in `bash` blocks, meaning grey blocks of terminal text, with the file paths replaced by short names, because the real ones are [absolute paths](../../GLOSSARY.md#absolute-path) into a temporary scratch folder LGE creates and cleans up for you. Nothing on this page has to be typed to read it, and none of these blocks is a step in a procedure. Flag values are the release defaults from [dependency set](../../GLOSSARY.md#dependency-set) `2026.2`, the named list of tool versions Preview 2026.9.13 was built against, and a sidecar's `runtimeIdentity.dependencySet` field records which set your own installation used. And when this page and a specific run's sidecar disagree, the sidecar wins, because it records what actually happened rather than what the source says usually happens.

Two words recur on every page below. A [flag](../../GLOSSARY.md#command-line-flag) is a hyphen-prefixed word such as `-q` or `--threads` that switches a tool behaviour on or sets a value. An [argument](../../GLOSSARY.md#argument) is any one of the words typed after a program's name, flags included, and the whole run of them is the argument list. A [wrapper](../../GLOSSARY.md#wrapper) is a program that builds and runs another program's command line for you, which is what LGE is doing every time it calls one of these tools.

So what should you do with this? Read the section for the tool you are about to wrap, check that LGE's flags match what your protocol expects, and read the reproducibility section before you promise anyone a rerun that matches the first run down to every character.

## The consolidated caveat list

Every reproducibility defect the 2026-09 campaign found is listed here, grouped by tool, with what it means for you and a link to the chapter that works it through. Read this list before you promise a rerun. It is the one section on this page a reader who never opens a terminal should read in full, because most of these defects are reachable from the window.

Two names appear only here. Medaka and Clair3 are Nanopore variant callers. Nextflow and Snakemake are workflow languages, and LGE can export a run as a script in either one so that another machine can repeat it.

**iVar.** Minimum Allele Frequency and Minimum Depth reach [iVar](../../GLOSSARY.md#ivar) and are recorded as `caller-default` for every other caller with no warning, so check the sidecar before you assume a threshold applied. The codon merger applies a fixed 0.40 to 0.60 band that no setting controls, so a merged row near half frequency was merged by a rule you cannot change. Both are in [Calling Variants](../05-variants/01-calling-variants-from-amplicons.md). A wrong primer scheme trims with [exit status](../../GLOSSARY.md#exit-status) 0 and no warning, so confirm the scheme matches the alignment's reference rather than trusting a clean finish. iVar's own summary is captured into provenance and never shown, so read the sidecar to see it. Both are in [Primer Trimming an Alignment](../04-alignments/03-primer-trimming.md).

**LoFreq.** [LoFreq](../../GLOSSARY.md#lofreq) rejects `--version`, so its provenance version field holds an error message rather than a number and cannot be parsed as a version, in [Calling Variants](../05-variants/01-calling-variants-from-amplicons.md).

**Medaka and Clair3.** Every Medaka run fails in Preview 2026.9.13 because the pipeline calls a subcommand Medaka 2.2.2 removed, so use another caller for now. Clair3 stops on the Python already installed on the machine and cannot read a bundle path containing a space, so a space in a folder name is worth removing before you try. Both are in [Nanopore Variant Calling](../05-variants/04-nanopore-variant-calling.md).

**GATK.** Each `--execute` overwrites the previous run's provenance record because the sidecar has a fixed name per output folder, so copy a sidecar you want to keep before you rerun. An unrecognised `--preset` or `--type` falls back or is dropped silently, so check the recorded command rather than the one you typed. And `conda install --pack gatk-core` reports an unknown pack, so install GATK by another route. All three are in [Filtering, Selecting, and Metrics](../06-human-germline-variants/03-filtering-selecting-and-metrics.md) and [HaplotypeCaller](../06-human-germline-variants/01-haplotype-caller.md).

**samtools.** The consensus chain masks by depth twice and rewrites every `*` as `N`, so raw samtools output does not match LGE's and the two should not be compared base for base, in [Extracting a Consensus Sequence](../05-variants/05-consensus-and-lineage.md). Duplicate marking has two further caveats, both in [Alignment Quality](../04-alignments/04-alignment-quality.md). The `markdup` command marks in place while the Inspector button writes new tracks and deletes the old ones, so the two routes leave a bundle in different states. And the Inspector's marking run registers nothing with the Operations panel and takes no lock, so it can start while another operation is changing the same bundle and it posts no row you could watch. Do not run it alongside anything else on that bundle.

**Kraken 2.** An all-unclassified run exits 64 with `Empty Kraken2 report` before Bracken runs, rather than reporting a fully unclassified result, so read that failure as a real answer about the sample rather than a broken run, in [Running Kraken 2](../06-classification/02-running-kraken2.md).

**Assemblers.** MEGAHIT fails most runs on Apple Silicon, so expect to rerun or to use SPAdes instead. The `--memory-gb` and `--min-contig-length` settings are accepted and ignored for Flye and hifiasm, and the SPAdes Min Contig control is editable but never reaches the command, so do not rely on any of the three to bound an assembly. All are in [Running SPAdes](../07-assembly/02-running-spades.md) and [Running Flye or hifiasm](../07-assembly/03-running-flye-or-hifiasm.md).

**Genotyping.** Min Reads and `--min-support` are recorded but never filter a genotype-only run, so filter the exported table yourself, in [Running Amplicon MHC Genotyping](../09-genotyping/02-running-genotyping.md). Two [pivot workbook](../../GLOSSARY.md#pivot-workbook) exports differ in an embedded timestamp, so compare the sheets rather than the files, in [Exporting Genotypes](../09-genotyping/04-haplotype-definitions-and-export.md).

**Workflow export.** The Nextflow emitter calls a three-input step with one channel and the Snakemake emitter lists one BAM as both an input and an output, which makes a loop, so both exported scripts need hand repair before they run. Every emitted command carries absolute host paths, so an exported script does not move to another machine unedited. All are in [Exporting as Nextflow or Snakemake](../08-workflows/02-exporting-as-nextflow-or-snakemake.md).

**Provenance.** `lungfish-cli provenance verify` exits 64 with an error line on an ordinary unsigned record, and since signing is off by default that is the state of nearly every sidecar you own. Read a nonzero status from it as "not signed" rather than "not valid", in [Exporting as Nextflow or Snakemake](../08-workflows/02-exporting-as-nextflow-or-snakemake.md).

**Variant filters.** A per-sample filter clause reads a `FORMAT DP` field, the per-sample read depth, that bcftools does not write, so such a clause matches nothing on a bcftools track and returns an empty table rather than an error. This applies in the Variants tab as well as from a script, so check which caller made a track before you filter it on depth, in [Reading the Variants Table](../05-variants/02-reading-the-variant-browser.md).

**Paths.** A command whose working directory sits under `/private/tmp`, the folder macOS uses for temporary files, fails with a provenance publication artifact error and writes nothing, because two spellings of one path are compared through a [symlink](../../GLOSSARY.md#symlink). An ordinary project folder in your Home folder or on the Desktop is never affected, so run commands from there. See [CLI Reference](cli-reference.md).

## Reading a command out of the source

This section is for readers who have a checkout of the LGE source code. Everyone else can skip to [iVar variant calling](#ivar-variant-calling) without losing anything, since every argument list below is quoted in full on this page.

Every argument list below cites the source file and line that emits it. A line such as `ViralVariantCallingPipeline.swift:1229` names a file under `Sources/LungfishWorkflow/` and the line where the first argument of that list is written. The code that builds an argument list only assembles text and runs nothing, so reading one tells you the whole command without running anything.

Two habits of those builders matter when you read them. Some place your own extra arguments before the arguments LGE builds, which means LGE's value wins on any flag you both set, and some place them after. And several builders add an argument only when a condition holds, so a flag missing from one run may still be a flag LGE passes on another.

## iVar variant calling

An [iVar](../../GLOSSARY.md#ivar) variant call in LGE is three programs run one after another rather than one. First `samtools mpileup` walks the alignment and reports what every read says at each position, which is what a [pileup](../../GLOSSARY.md#pileup) is. That pileup is piped into `ivar variants`, meaning its output is handed straight to the next program without a file being saved in between, and `ivar variants` writes a tab-separated table. Then a converter built into LGE turns that table into a [VCF](../../GLOSSARY.md#vcf), the standard text format for recorded variants. LGE runs the converter for you as part of the same operation. All three appear as separate entries in the run's sidecar.

### samtools mpileup, as LGE calls it

The mpileup arguments are fixed. Nothing in the [dialog](../../GLOSSARY.md#dialog), meaning the settings window LGE shows before a run, and no command-line flag changes any of them (`ViralVariantCallingPipeline.swift:1227-1238`). The block below is here to be read rather than typed.

```bash
samtools mpileup -aa -A -d 600000 -B -Q 20 -q 0 -f reference.fasta alignment.bam
```

| Flag | Meaning | Why LGE sets it |
|---|---|---|
| `-aa` | Report every position, including those with no reads | iVar needs a complete pileup to emit a complete consensus |
| `-A` | Keep anomalous read pairs, meaning pairs whose mate is unmapped or oriented oddly | [Amplicon](../../GLOSSARY.md#amplicon) pairs often look anomalous after [primer trimming](../../GLOSSARY.md#primer-trim), and dropping them loses real evidence |
| `-d 600000` | Raise the per-position read cap from the tool default of 8000 | Amplicon panels routinely reach 10,000 to 50,000 reads deep at a position, and the default truncates without saying so |
| `-B` | Disable [BAQ](../../GLOSSARY.md#baq), a per-base penalty samtools applies near likely misalignments | BAQ assumes randomly fragmented reads, so on amplicon data it penalises bases near primer ends that are not misaligned at all |
| `-Q 20` | Ignore bases whose [Phred score](../../GLOSSARY.md#phred-score) is under 20, meaning a one-in-a-hundred chance of being wrong, where 30 would mean one in a thousand | Matches the minimum LGE passes to iVar itself, and no dialog control changes it |
| `-q 0` | Impose no [mapping quality](../../GLOSSARY.md#mapping-quality) minimum, mapping quality being the aligner's confidence that a read sits in the right place, which is a separate judgement from the base quality above | Mapping quality is judged later rather than here |

Depth here is measured in fold, meaning the number of reads covering one position, so a 20,000-fold position was read 20,000 times. The flag most often left out of a hand-built pipeline is `-d 600000`. Omit it and a 20,000-fold amplicon silently reports as 8000-fold, which makes every [allele frequency](../../GLOSSARY.md#allele-frequency) computed against that pileup wrong in the same direction.

### ivar variants, as LGE calls it

```bash
ivar variants -p ivar.tsv-prefix -q 20 -t 0.05 -m 10 -r reference.fasta -g annotations.gff3
```

The builder is at `ViralVariantCallingPipeline.swift:1240-1255`. Text you supply through `--extra-args`, the option that inserts your own words into the command LGE builds, is placed immediately after the `variants` subcommand and before every argument in that block. Because iVar reads the last value of a repeated flag, LGE's value is the one that takes effect, so a `-t` of your own has no effect at all here.

Two of those values are one setting under two names each. The `-t` value is the Minimum Allele Frequency setting, which reaches iVar and no other caller, and it defaults to 0.05. The `-m` value is Minimum Depth and defaults to 10. On the command line the same two settings are `--min-af` and `--min-depth`, so the dialog field, the setting name, and the flag all name one value. The `-q` floor of 20 is fixed in source. The `-p` prefix names the temporary output file and is set by LGE with no control over it.

The `-g` flag appears only when the [reference bundle](../../GLOSSARY.md#reference-bundle) carries gene annotations. LGE exports them from the bundle's annotation database to a GFF3 file first (`ViralVariantCallingPipeline.swift:1266-1301`). **Silent caveat.** If the bundle has no annotations, or the export fails, the flag is dropped and the run continues with no message. That is the difference between a run that reports [codon](../../GLOSSARY.md#codon) context and one that does not.

### The four iVar tuning flags do not reach iVar

The four flags named `--ivar-consensus-af` (default 0.75), `--ivar-merge-af-threshold` (default 0.25), `--ivar-bad-quality-threshold` (default 20), and `--ivar-no-ignore-strand-bias` all configure LGE's own table-to-VCF converter, which runs as a third step after iVar has finished (`ViralVariantCallingPipeline.swift:739-746` builds the options, `:790-801` records the step). Despite their names, none of them is passed to `ivar variants`. None has a dialog control either, so all four are command-line only. The converter's recorded command line makes this visible, since it reads `lungfish-internal ivar-tsv-to-vcf --consensus-af ... --merge-af-threshold ... --bad-quality-threshold ... --ignore-strand-bias ...`. That name is internal to LGE and cannot be typed at a prompt.

This affects only someone rebuilding the pipeline by hand. Running `ivar variants` yourself with the same flags LGE reports will not reproduce LGE's VCF, because the part those flags control never ran. To reproduce an LGE iVar call you need LGE. This is expected behaviour rather than a defect, and it costs a window user nothing.

The [strand-bias](../../GLOSSARY.md#strand-bias) flag deserves its own sentence. Strand bias is the situation where the reads carrying an alternate base come overwhelmingly from one strand of the DNA, which is often an artifact and on amplicon data is often just the primer layout. LGE's converter ignores strand bias by default, which is right for amplicons, and `--ivar-no-ignore-strand-bias` turns the filter on for data where the balance is meaningful.

### Codon merging

The converter folds two changes inside one codon into a single VCF row with a multi-base [REF and ALT](../../GLOSSARY.md#ref-alt), the reference bases and the observed bases, so that the row names the one amino acid the pair actually produces rather than two amino acids that never existed separately. Three tests decide whether a pair merges, and any one of them is enough (`IVarCodonMerger.swift:105-113`). Both frequencies above the consensus threshold merges. Both frequencies inside a fixed band from 0.40 to 0.60 merges, and that band is hard-coded with no setting behind it. Two frequencies closer together than the merge threshold merges.

The middle band is there because a pair of frequencies near one half suggests a site that is heterozygous or evenly mixed, where both changes plausibly sit on the same half of the sample.

None of this knows about [phase](../../GLOSSARY.md#phase), meaning which of a sample's two chromosome copies a change sits on. iVar has no way to know whether two changes ride the same physical DNA molecule. So a merged row asserts a codon boundary and asserts nothing about [linkage](../../GLOSSARY.md#linkage), the question of whether two changes travel together on one molecule. When you need real phased [haplotypes](../../GLOSSARY.md#haplotype), that is a different job, and [HaplotypeCaller](../06-human-germline-variants/01-haplotype-caller.md) covers where LGE stands on it.

## LoFreq variant calling

[LoFreq](../../GLOSSARY.md#lofreq) builds an error model from the base qualities themselves. At each position it counts the [alternate reads](../../GLOSSARY.md#alternate-read), the reads carrying a base other than the reference base, and compares that count against the number of wrong bases the measured error rate alone would produce there. A count clearly above that expectation becomes a call. LGE runs LoFreq as one program in the ordinary case and three when you ask for indels.

### The ordinary case is a single call

```bash
lofreq call -f reference.fasta -o variants.raw.vcf alignment.bam
```

That is the whole command (`ViralVariantCallingPipeline.swift:1217-1225`). Your `--extra-args` text lands between `call` and `-f`, which means LoFreq reads your value before LGE's own flags and any flag you both set resolves to LGE's. There is no window route for extra arguments on LoFreq, so this option is command-line only. There is no `call-parallel`, no `--pp-threads`, and no `--no-default-filter` anywhere in LGE, so a script that expects those is describing a different [wrapper](../../GLOSSARY.md#wrapper).

A real run bears this out. The LoFreq sidecar from the [HG002](../../GLOSSARY.md#hg002) chromosome 20 slice, HG002 being the widely used human reference sample this manual takes its human examples from, recorded exactly `lofreq call -f reference.fa -o lofreq.raw.vcf hg002-minimap2.bam` and nothing else. Six further steps follow it, all of them LGE tidying the output into the shape a bundle expects, and the sidecar's own `steps` array lists them.

### Indel calling is opt-in and adds two steps

LoFreq calls no [indels](../../GLOSSARY.md#indel), meaning insertions and deletions, unless you pass `--call-indels` through `--extra-args`. There is no dialog control for this, so indel calling with LoFreq is command-line only. LGE watches for that exact string (`ViralVariantCallingPipeline.swift:1188-1189`) and, when it sees it, runs two extra steps first. A complete invocation looks like this.

```bash
lungfish-cli variants call --caller lofreq --extra-args "--call-indels" alignment.bam
```

The three commands LGE then runs are these.

```bash
lofreq indelqual --dindel -f reference.fasta -o indelqual.bam alignment.bam
lofreq index indelqual.bam
lofreq call --call-indels -f reference.fasta -o variants.raw.vcf indelqual.bam
```

The `indelqual` pass writes per-base indel quality scores into a copy of the alignment. LoFreq's indel model expects those scores to be present, and an ordinary alignment carries none. So a hand-built pipeline that jumps straight to `lofreq call --call-indels` reports fewer indels than the data holds and says nothing about it. The size of that gap was not measured in this campaign. The argument builders are at `:1200-1215`.

One consequence of the opt-in design is worth stating for anyone comparing callers. Running LoFreq and bcftools on the same alignment with default settings gives a large row-count gap, most of which is simply that bcftools called indels and LoFreq did not. The worked comparison is in [Calling Variants](../05-variants/01-calling-variants-from-amplicons.md).

### LoFreq's version string is an error message

Your run is fine, and what follows is a labelling quirk rather than a failure. LoFreq 2.1.5 rejects `--version`, so LGE's version probe captures the tool's refusal instead of a number. Every LoFreq sidecar therefore records a `variantCallerVersion` reading `FATAL(lofreq_main.c|main:336): Unrecognized command '--version'`. Seeing that text in your own provenance file is expected. The field is simply not usable as a version.

## Primer trimming

Primer trimming runs `ivar trim` and then sorts and indexes the result (`BAMPrimerTrimPipeline.swift:29-49`).

```bash
ivar trim -b scheme.bed -i input.bam -p output-prefix -q 20 -m 30 -s 4 -x 0 -e
```

The `-b` value is a [BED](../../GLOSSARY.md#bed) file, a plain-text table listing where each primer sits on the reference.

Four of those values are settings, and three of them describe one quality-trimming method. [Sliding-window trimming](../../GLOSSARY.md#sliding-window-trimming) averages the quality scores of a small run of neighbouring bases and cuts the read where that average first drops below a threshold, so one miscalled base does not truncate an otherwise good read. `-q` is `--ivar-min-quality` at 20, the [Phred score](../../GLOSSARY.md#phred-score) that average must stay above. `-s` is `--ivar-sliding-window` at 4, the width of that run in bases, so a narrower window cuts on a shorter run of bad bases. `-m` is `--ivar-min-length` at 30, the shortest read kept after trimming. `-x` is `--ivar-primer-offset` at 0, which shifts the primer coordinates when a scheme's BED disagrees with where the primers really sat. The symptom that points at a nonzero offset is primer sequence surviving at read ends after a trim that reported success.

The `-e` at the end is fixed and is the flag most worth understanding, because it tells iVar to keep reads that matched no primer at all rather than discarding them. Without it a read from a shotgun library, meaning a library made by fragmenting DNA at random rather than amplifying named regions, would be dropped from the output entirely when it passed through an amplicon bundle.

One further flag exists for a specific failure. `--target-reference` overrides the reference name used to resolve the primer scheme against the alignment's own `@SQ SN` header line, the line inside a BAM that names the reference it was aligned to. That is the fix when a scheme was built against one accession and the alignment names another. A mismatched scheme otherwise trims with [exit status](../../GLOSSARY.md#exit-status) 0, which is the number a tool returns to say it succeeded, and no warning. [Primer Trimming an Alignment](../04-alignments/03-primer-trimming.md) documents it.

## Mapping

The four mappers get four different argument shapes, all built in `MappingCommandBuilder.swift`. BBMap is shown alongside them as a fifth command, since LGE runs it the same way.

```bash
minimap2 -a -x sr -t 8 -R '@RG\tID:...' --secondary=no -o out.sam reference.fasta reads.fastq
bwa-mem2 mem -t 8 -R '@RG\tID:...' index-prefix reads.fastq
bowtie2 -x index-prefix -p 8 --rg-id ... --rg SM:... -S out.sam -1 r1.fastq -2 r2.fastq
bbmap.sh ref=reference.fasta out=out.sam threads=8 nodisk=t overwrite=t secondary=f
```

The `\t` and the `...` in those blocks stand for values LGE fills in itself, a tab character and the sample's own identifiers, so neither is text you would ever type.

The minimap2 builder is at `:76-101`, bwa-mem2 at `:104-124`, bowtie2 at `:127-158`, and BBMap at `:161-200`. Three things generalise across them. The `-x` preset for minimap2 defaults to `sr` for short reads and follows the read type you choose in the mapping dialog. A [read group](../../GLOSSARY.md#read-group), the `@RG` header line naming the sample and platform, is always written, so every LGE-produced alignment carries sample identity. And [secondary alignments](../../GLOSSARY.md#secondary-alignment), meaning additional lower-scoring placements of the same read, are off unless you ask, which for minimap2 means `--secondary=no` is added and for BBMap means `secondary=f`.

Extra arguments land in a different place per mapper, and every one of these tools reads the last value of a repeated flag. So whichever value sits later in the command line is the one that takes effect. On minimap2 your arguments sit after the read group and before `-o`, so they take effect on any flag LGE set earlier and cannot override the output path. On BBMap they are placed first, ahead of everything LGE sets, so LGE's value takes effect instead of yours. The two mappers therefore resolve the same conflict in opposite directions.

## Kraken 2 classification

```bash
kraken2 --db database/ --threads 8 --confidence 0.0 --minimum-hit-groups 2 \
    --output out.kraken --report out.kreport --report-minimizer-data reads.fastq
```

The builder is at `ClassificationConfig.swift:365-405`.

| Flag | Meaning | Where it comes from |
|---|---|---|
| `--confidence 0.0` | The share of a read's matches that must agree before Kraken 2 keeps the assignment, at the tool's own default of none required | The Confidence setting, raised to drop weakly supported calls |
| `--minimum-hit-groups 2` | Requires at least two separate stretches of matching sequence rather than one, at the tool's own default | Fixed by LGE, and a second stretch makes a chance match much less likely |
| `--memory-mapping` | Runs the database from disk instead of loading it into memory | Added only when you ask, to fit a large database on a small machine |
| `--quick` | Stops examining a read at its first match | Added only when you ask, which is faster and less careful |
| `--paired` and `--fasta-input` | Declare a paired read set and a FASTA rather than FASTQ input | Added automatically from the input you chose |

The always-present `--report-minimizer-data` is the one to know about, because it adds two columns to the [Kraken 2](../../GLOSSARY.md#kraken2) report that the standard six-column format does not have. LGE requires them so that [Bracken](../../GLOSSARY.md#bracken), the tool that redistributes reads assigned at broad taxonomic levels down to species, has what it needs. It also means an LGE report is eight columns wide. The LGE window reads that format correctly, so this affects only a reader who loads the report file into another program expecting six columns. [Running Kraken 2](../06-classification/02-running-kraken2.md) covers what the columns hold.

Your extra arguments are appended after every LGE flag and before the input files, so on Kraken 2 your value is the one that takes effect.

## Assembly

The five assemblers are built in `ManagedAssemblyPipeline.swift`, and the differences between them are larger than the dialog suggests. [Running SPAdes](../07-assembly/02-running-spades.md) and [Running Flye or hifiasm](../07-assembly/03-running-flye-or-hifiasm.md) cover how to choose between them.

Three sequencing technologies decide which assembler fits. Illumina instruments produce short, accurate reads. Nanopore instruments, also written ONT, produce long reads at lower per-base accuracy, and `nano-hq` names Nanopore's higher-accuracy mode. PacBio HiFi reads are long and accurate. SPAdes, MEGAHIT, and SKESA take short reads. Flye and hifiasm take long ones.

```bash
spades.py --isolate -1 r1.fastq -2 r2.fastq -o out/ --threads 8 --memory 16
megahit -1 r1.fastq -2 r2.fastq -o out/ --num-cpu-threads 8 --min-contig-len 200 --no-hw-accel
skesa --reads r1.fastq,r2.fastq --contigs_out contigs.fasta --cores 8 --min_count 2
flye --nano-hq reads.fastq --out-dir out/ --threads 8
hifiasm -o out/prefix -t 8 reads.fastq
```

SPAdes is at `:177-208`, MEGAHIT at `:211-243`, SKESA at `:246-275`, Flye at `:278-296`, and hifiasm at `:299-321`. The leading profile argument varies, and here LGE's own option name and the tool's flag are not the same word. SPAdes takes `--isolate` for a single cultured organism, `--meta` for a mixed community sample, or `--plasmid` for plasmid recovery, and defaults to `--isolate`. Flye's read mode becomes the flag itself, so choosing the `nano-hq` profile in LGE produces `flye --nano-hq` as the command's opening, exactly as the block above shows, and the profile defaults to `nano-hq`. Hifiasm gets `--ont` added at the front when the reads are Nanopore.

Two of these carry a workaround. MEGAHIT is given `--no-hw-accel`, which turns off its use of processor-specific fast instructions, on Apple Silicon Macs where LGE limits how many [threads](../../GLOSSARY.md#thread) it may use, unless your own extra arguments already set it (`:236-239`). SKESA is pinned to `--min_count 2`, its own documented default, because leaving it automatic can produce an assembly with no contigs at all on a small input (`:268-272`). Both are LGE decisions rather than tool defaults.

### Two dialog settings are ignored on some assemblers

This is the most consequential paragraph in the section for anyone using the window. Minimum contig length reaches MEGAHIT and SKESA and never reaches SPAdes, Flye, or hifiasm. Memory reaches SPAdes, MEGAHIT, and SKESA and never reaches Flye or hifiasm. In each case the control accepts your value, the run proceeds, and nothing says the value went nowhere. [Running SPAdes](../07-assembly/02-running-spades.md) and [Running Flye or hifiasm](../07-assembly/03-running-flye-or-hifiasm.md) record where each one lands.

## GATK

The GATK HaplotypeCaller command is built at `GATKCommandBuilder.swift:384-395`.

```bash
gatk HaplotypeCaller -R reference.fasta -I input.bam -O output.g.vcf.gz \
    --sample-ploidy 2 --max-alternate-alleles 6 --pcr-indel-model CONSERVATIVE \
    --native-pair-hmm-threads 8 -ERC GVCF
```

Three of those arguments are always present and carry dialog settings. `--sample-ploidy` is how many copies of each chromosome the sample carries, 2 for a human and 1 for a virus, and it defaults to 2. `--max-alternate-alleles` caps how many different alternate bases GATK considers at one position, which bounds the work at messy sites, and it defaults to 6. `--pcr-indel-model` tells GATK how much insertion and deletion noise to expect from the library's PCR step, and it defaults to `CONSERVATIVE`. All three are the tool's own defaults.

`--native-pair-hmm-threads` carries the thread count. `-ERC` selects the reference-confidence mode. A [GVCF](../../GLOSSARY.md#gvcf) is a VCF that holds a record for every position rather than only the variant ones, recording at each matching position how confident the caller is that the sample matches the reference, which is what lets several samples be genotyped together later. So `-ERC` chooses between an ordinary VCF and a GVCF. A separate phasing plan builder at `PhasedVariantCallingPlan.swift:92-97` composes the same tool with `-ERC NONE`.

GATK is a storage exception in this manual. A GATK variant track is written to `variants/gatk/<track-id>.vcf.gz` inside the [bundle](../../GLOSSARY.md#bundle), which is a folder macOS shows as one icon and LGE treats as one object, with a SQLite sidecar. Every other caller writes to the ordinary `variants/<name>.vcf.gz` path. The Call Variants dialog offers two GATK entries, HaplotypeCaller and the joint-genotyping route, and its two Thresholds fields are discarded on both rather than recorded. LGE never creates the `.dict` sequence dictionary GATK requires, so a first run fails until you make it yourself with `gatk CreateSequenceDictionary`, which has no window route. All three are worked through in [HaplotypeCaller](../06-human-germline-variants/01-haplotype-caller.md).

## The provenance sidecar

A provenance sidecar is a JSON file LGE writes beside a result recording exactly how that result was made. [JSON](../../GLOSSARY.md#json) is a plain-text format of named keys and their values, nested inside curly braces, that both people and programs can read. LGE names one `<filename>.lungfish-provenance.json` beside a loose file, gathers a bundle's sidecars under a `provenance/` folder, and writes a bare `.lungfish-provenance.json` at a bundle root for the bundle as a whole. This section is the authoritative field list, and [File Formats](file-formats.md) and [Running in CI](06-running-in-ci.md) both repeat parts of it.

### The full envelope

A sidecar written by a CLI operation carries the top-level keys below, read from the `lungfish translate` sidecar of the HBB gene record produced for this campaign and cross-checked against `ProvenanceEnvelope.swift:52-72`. The block is abridged, and the three `...` lines mark where repeated entries of the same shape were cut. Four keys carry most of the value for a reader checking a run. Read `reproducibleCommand` for what was run, `files` for what went in, `outputs` for what came out, and `status` for whether it worked.

```json
{
  "schemaVersion": 1,
  "id": "1BD0378D-EDA9-47CE-826A-EF811019E763",
  "name": "lungfish translate",
  "createdAt": "2026-09-07T04:21:08Z",
  "workflowName": "lungfish translate",
  "workflowVersion": "Lungfish dev (0)",
  "toolName": "lungfish translate",
  "toolVersion": "lungfish-cli 2026.9.13",
  "tool": { "kind": "cli", "name": "lungfish translate", "version": "lungfish-cli 2026.9.13" },
  "appVersion": "Lungfish dev (0)",
  "hostOS": "macOS 26.6.2 (arm64)",
  "argv": ["lungfish-cli", "translate", "sequence.fa.gz", "--frame", "1"],
  "durableReplayArgv": ["lungfish-cli", "translate", "sequence.fa.gz", "--frame", "1"],
  "reproducibleCommand": "lungfish-cli translate 'sequence.fa.gz' --frame 1",
  "runtimeIdentity": {
    "appVersion": "Lungfish dev (0)",
    "architecture": "arm64",
    "dependencySet": "2026.2",
    "executablePath": "/path/to/lungfish-cli",
    "operatingSystemVersion": "macOS 26.6.2 (arm64)",
    "processIdentifier": 33381,
    "user": "dho"
  },
  "runtime": { "startedAt": "2026-09-07T04:21:08Z", "finishedAt": "2026-09-07T04:21:08Z" },
  "options": {
    "explicit": { "frame": "1" },
    "defaults": { "table": "standard" }
  },
  "parameters": {
    "frame": { "type": "int", "value": "1" },
    "...": "four further parameter entries of the same shape"
  },
  "files": [
    { "path": "sequence.fa.gz", "role": "input", "format": "fasta",
      "sha256": "a3faac89...", "sizeBytes": 24227, "checksumSHA256": "a3faac89...", "fileSize": 24227 },
    "... one further file entry of the same shape"
  ],
  "output": { "path": "hbb-frame1.faa", "format": "fasta" },
  "outputs": [
    { "path": "hbb-frame1.faa", "role": "output", "format": "fasta",
      "sha256": "7c1e40b2...", "sizeBytes": 149, "checksumSHA256": "7c1e40b2...", "fileSize": 149 }
  ],
  "steps": [
    { "id": "translate", "command": ["lungfish-cli", "translate", "sequence.fa.gz", "--frame", "1"],
      "exitCode": 0, "toolName": "lungfish translate", "wallTime": 0.11 }
  ],
  "startTime": "2026-09-07T04:21:08Z",
  "endTime": "2026-09-07T04:21:08Z",
  "status": "completed",
  "exitStatus": 0,
  "wallTimeSeconds": 0.11473691463470459,
  "signatures": []
}
```

Five things about that block are worth calling out. `schemaVersion` is `1` and is spelled in [camelCase](../../GLOSSARY.md#camel-case), running the words together and capitalising each one after the first, like every other key here, so a reader looking for `schema_version` finds nothing. The `options` block splits what you typed from what you accepted, under `explicit` and `defaults`.

Three pairs of keys hold nearly the same thing, because the part of LGE that writes these files emits both an older and a newer spelling of each. Read the newer spelling in each pair and treat the older as legacy. Every entry in `files` carries `sha256` and `checksumSHA256` holding the same [checksum](../../GLOSSARY.md#checksum), and `sizeBytes` and `fileSize` holding the same count. And `durableReplayArgv` holds the command as a list of separate words for a program to run, while `reproducibleCommand` holds the same command as one quoted line you can paste into a terminal, which is the one to read.

Two smaller notes. `signatures` is empty unless a signer is configured, which is off by default. And `appVersion` reads `Lungfish dev (0)` in this example because it was produced by a locally built binary, while a copy of the shipped app writes its release version there, so your own file will differ. `wallTimeSeconds` is recorded at full decimal precision, and only the leading digits mean anything.

### The workflow-run shape

Some operations write a second, older shape. Its top-level keys are `id`, `name`, `appVersion`, `hostOS`, `startTime`, `endTime`, `status`, `runtime`, `parameters`, and `steps`. The absence of `schemaVersion` is what tells the two apart at a glance, and the variant-calling sidecars are the ones that use it. The reader in LGE decodes both, which is why the envelope above lists keys from each.

Its `parameters` block records every setting including the ones you left alone, each as an object with a `type` and a `value`. A setting a caller ignores is written as the string `caller-default`. That entry means your chosen value never reached the tool and had no effect on the result, which is how a LoFreq run records a Minimum Depth field LoFreq never saw.

### The steps array

Each entry in `steps` holds the fields below.

| Field | What it holds |
|---|---|
| `id` and `dependsOn` | The step's own name and the names of the steps that had to finish first |
| `command` | The exact argument list, one word per entry |
| `startTime`, `endTime`, `wallTime` | When the step ran and how long it took |
| `exitCode` | The number the tool returned, where 0 means success |
| `toolName`, `toolVersion` | Which tool ran and which build of it |
| `stderr` | The tool's [standard error](../../GLOSSARY.md#stderr) text, meaning its progress notes and complaints, present only when something was captured |
| `inputs`, `outputs` | File entries carrying a `path`, a `role`, a `format`, a `sha256`, and a `sizeBytes` |

The `toolVersion` field is more informative than it looks, because LGE writes the runtime identity into it. A real one reads `1.24 (managed conda environment samtools; executable samtools; package bioconda::samtools=1.24=h36b3a25_1)`. That names the version first, then the [conda](../../GLOSSARY.md#conda) environment and the executable, then the exact package string, where `bioconda` is the channel it came from, `samtools` the package, `1.24` the version, and `h36b3a25_1` the build. That last part is what makes a step reconstructible.

A step model field named `peakMemoryBytes` exists and is optional. None of the sidecars produced for this campaign carried it, so treat a missing peak-memory figure as normal rather than as a fault.

### Summarising cost across a project

`lungfish-cli ops stats <project-or-bundle>` walks a folder and reports the sidecar count, the completed run count, the total [wall time](../../GLOSSARY.md#wall-time), then a per-operation table of run count, total, average, and peak RAM. The angle brackets mark a value you replace with your own path. No panel in the LGE window shows these totals, so this section is command-line only.

```bash
lungfish-cli ops stats "My Project.lungfish"
```

Three limits apply, and each one changes what the numbers mean.

It counts only files named exactly this:

```text
.lungfish-provenance.json
```

It never reads the per-output sidecars, which are named like this, with the file's own name in front of the dot:

```text
hbb-frame1.faa.lungfish-provenance.json
```

So a project holding nothing but per-output sidecars reports a sidecar count of zero (`OperationStatsAggregator.swift:73-96`). A zero here almost always means the wrong filenames rather than a project where nothing has run.

It also counts only runs whose `status` is `completed`, so failed and cancelled runs contribute nothing (`:38`). And peak RAM reads `unknown` whenever no step recorded it, which is the usual case.

One further caveat concerns the output format. The `--format json` and `--format tsv` options the help text advertises are not implemented, so the command prints its text table whatever you pass and still exits 0. A value the parser does not recognise, such as `--format bogus`, is refused with exit status 64. So a script must read the output rather than infer the format from the status.

## Reproducibility, honestly

[Determinism](../../GLOSSARY.md#determinism) here means running the same command on the same inputs and getting the same output. LGE can promise that in some places and not in others, and this section separates them.

### What the campaign measured

Everything in this list was measured during the 2026-09 campaign, and nothing outside it is claimed. Two of these are LGE's own behaviour and the rest are the wrapped tools behaving as they always do.

The MHC genotyping route matched across two runs, which is weak evidence but is the only recorded pair in this manual. The whole 30-sample Williams plate and a three-bundle rerun of three of its samples both produced 104 allele rows for the sample `WD1_S148_L001` against the same library. The point is that the two counts agree, not the value 104 itself.

The pivot workbook export does not produce byte-identical files. Two exports of the same subcommand on the same bundle differ in `docProps/core.xml`. An xlsx file is a zip archive of separate parts, and that part holds a timestamp, so the sheets themselves are byte-identical and only the timestamp part differs.

MEGAHIT 1.2.9 is not reliable on Apple Silicon in this release. It fails most runs with both shipped workarounds active, those being the thread cap and `--no-hw-accel`. The failure is loud rather than silent, appearing as a nonzero exit in the Operations panel with no [contigs](../../GLOSSARY.md#contig) written, so a completed MEGAHIT run is correct and never quietly wrong. Rerunning is the only workaround, and SPAdes is the assembler to reach for instead on the same short-read data.

Flye 2.9.6 rarely doubles a small circular genome on identical input, and hifiasm does so consistently on the mitochondrial fixture. Doubling means the assembler walked all the way around a circular chromosome and kept going, so the contig holds the whole genome twice end to end. The [assembly](../../GLOSSARY.md#assembly-graph) viewport shows no circularity and no multiplicity column, so a doubled contig looks healthy until you compare its length against the known genome length.

Multi-threaded tools can differ between runs at different thread counts, which is why pinning `--threads` to a fixed number is the first step of any reproducible rerun. One command is an exception. On `variants phase` the thread count you give is ignored and the run uses one thread, which the sidecar records honestly as one.

### Cross-architecture and cross-version drift

Some tools ship processor-specific fast instructions, and those can produce files that differ in their bytes on Intel and on Apple Silicon while the results agree scientifically. So a byte-for-byte file comparison is the wrong check between two processors. The `runtimeIdentity.architecture` field exists so an auditor can see when two runs came off different processors before comparing anything.

Version drift is the other half. A minor release of a wrapped tool can change small details of how reads are trimmed and placed without announcing it. The `toolVersion` field on each step is how a rerunner catches that. This release pins every tool it wraps under one dependency set, and [Tool Versions](tool-versions.md) holds the full table with the versions. A sidecar recording anything else came from a different installation.

## Pinning an environment

Reproducing a run months later means installing the same tools at the same versions, and this section is about how well LGE can do that. It is command-line only, and angle brackets in the commands below mark values you replace with your own.

A [plugin pack](../../GLOSSARY.md#plugin-pack) is a versioned recipe for a [conda](../../GLOSSARY.md#conda) environment, conda being the installer LGE uses to put bioinformatics tools on your machine and an environment being one isolated folder of installed tools. The pack version pins the recipe, meaning which tools at which versions from which channels. It does not pin the further packages those tools depend on underneath, so reinstalling the same pack version months later can resolve slightly different versions of those as the upstream channels move. That is the problem the three commands below address, and only the first pair solves it.

`lungfish-cli conda offline-export --pack <id> --output <dir>` writes the installed environments out as a directory holding an `offline-pack-manifest.json` with a checksum and byte size for every file, and `lungfish-cli conda offline-install <pack-directory>` installs one back with no network access. That pair is the reproducibility path that works today, and [Running in CI](06-running-in-ci.md) uses it.

`lungfish-cli conda lock --pack <name> --output <file>` writes a requested environment specification in JSON, recording the environment names, the requested packages, the platforms, the channels, the source overlays, and the post-install hooks. It records what was asked for rather than a list of what was actually installed, it is not compatible with the separate conda-lock tool, and it does not by itself guarantee an identical rebuild. This part of LGE is unfinished. Its companion `lungfish-cli conda install --from-lockfile <file>` always fails by design, refusing before it creates or changes an environment, because exact reconstruction is not supported in this release. The `conda lock` command does leave a provenance sidecar beside its output.

`lungfish-cli bundle export --format container` is documented as writing a deterministic [OCI layout](../../GLOSSARY.md#oci-layout) tarball. In Preview 2026.9.13 you cannot reach it. Every LGE command carries a `--format` option at the top level, and a subcommand that declares its own `--format` is overruled by that top-level one. So `--format container` is refused as an invalid value and omitting the flag fails as a missing argument. The exporter itself is complete, building an `oci-layout` file, an `index.json`, config and manifest blobs, a single layer blob holding the bundle's files, and a provenance record for the export (`BundleContainerExportService.swift:73-81`). Until the collision is fixed, use an offline conda pack and share the bundle itself as a zip archive.

## The conda mutation lock

A lock here is a marker one program leaves on a file to make other programs wait their turn. Anything that changes the managed conda root takes an exclusive [advisory lock](../../GLOSSARY.md#advisory-lock) on a file at `<conda-root>/.install.lock` before it touches anything, so two installs cannot corrupt one root (`CondaRootMutationLock.swift:22`). A single person working in one LGE window never meets this. It matters only when several installs run at once, which happens in scripts and on servers.

A second program that finds the lock held writes `waiting for conda lock held by pid <n>` to [standard error](../../GLOSSARY.md#stderr), where the [pid](../../GLOSSARY.md#process-id) is the number macOS gives each running program, and then waits until the first finishes (`:95`). A root that cannot be written at all fails with `conda root is read-only; reinstall as the admin user` (`:12`). And a lock that cannot be opened or taken for some other reason reports the underlying system error with the lock's path.

The practical rule follows from this. Run installs one after another rather than at the same time, and never let two [continuous integration](../../GLOSSARY.md#continuous-integration) jobs, meaning automated jobs that run your commands on a fresh machine after each change, restore and update the same cached conda root. [Running in CI](06-running-in-ci.md) says this at greater length.

## Asserting an installation

`lungfish-cli tools update --plan` compares the machine against the dependency manifest bundled with the build and prints the installs, reinstalls, removals, and database updates needed to bring it into line, changing nothing.

```bash
lungfish-cli tools update --plan
```

This section is for readers who run automated jobs. The reason `--plan` belongs in a script is its [exit status](../../GLOSSARY.md#exit-status).

| Exit status | What it means |
|---|---|
| 0 | Nothing to do, the installation matches the pinned tool list |
| 10 | Work is pending, so the installation no longer matches that list |
| 2 | A usage error, such as `--apply` without `--yes` |
| 1 | An item failed to install |

A job that treats 10 as a failure stops the moment the installation stops matching the versions LGE was built against. Three further options shape the run. `--json` prints machine-readable output. `--required-only` restricts databases to the ones you cannot defer, a required database being one a tool cannot run without, while an advisory one only makes results better or more current, so deferring an advisory database costs accuracy rather than the ability to run. `--include-databases` adds the advisory ones and has no effect alongside `--required-only`. A failure to record the file noting which dependency set was installed warns on standard error and still exits 0, because the tools did install.

## Debugging from the Operations panel

This section needs no terminal. The Operations panel opens with **Operations > Show Operations Panel** (Cmd-Shift-P) and lists every operation LGE is running or has finished. Two surfaces on it matter for debugging, and they are not the same surface.

Expanding a row shows four sections, each built only when it has content (`OperationsPanelController.swift:954-1005`). CLI Command holds the exact resolved invocation with a copy button. Output Files lists the paths written with a Reveal button. Log holds the operation's timestamped log entries with View Log and Reveal in Finder buttons. Error appears on a failed operation with the message, the detail, and a pointer to the failure report.

Right-clicking a row opens a context menu that is built fresh for the clicked row (`:1500-1566`). Run Again appears when the operation can be replayed. Copy CLI Command appears when a command was recorded. Copy Log, View Log, and Reveal Log in Finder appear when log entries exist. A failed row additionally offers Copy Failure Report, Open GitHub Issue, and Reveal Failure Report in Finder.

The debugging order that follows is to read the Error section first, then the Command. Without a terminal, stop there and use Run Again, which repeats the operation exactly as recorded, then Copy Failure Report and Open GitHub Issue to report what happened. With a terminal, the further step is Copy CLI Command and running it in a fresh shell.

### Failure reports outlive the session

LGE writes a diagnostic report to disk as each failure happens, at `~/Library/Logs/<app name>/Operations/Failures`, so the first debugging step can be reading a file rather than driving the window (`OperationFailureReportStore.swift:56-77`). The leading tilde stands for your Home folder, and because Library is hidden in Finder the reliable way in is Reveal Failure Report in Finder from the panel's own context menu.

Three properties of that store are worth knowing. The directory is keyed on app identity, so a Debug build's reports never interleave with a shipped build's (`:52-54`). Fifty reports are kept in total, regardless of age, and older ones are pruned on each write, so a long-running app cannot fill the disk (`:20-22`). And a failed write of a report is discarded on purpose rather than reported, on the reasoning that a full logs directory must not turn one failed operation into two (`:73-78`). So a missing report means only that the report is missing, and says nothing about the operation.

## Reaching a flag LGE does not wrap

No dialog exposes every flag of the tool underneath it. Three routes around that exist, in increasing order of how much provenance they cost. A file with no sidecar cannot be summarised by `ops stats`, cannot have its exact command recovered later, and cannot be checked by `provenance verify`, so you lose the record of how it was made.

The first route is `--extra-args`, which most tool-running commands accept and which inserts your text into the underlying command. Where it lands differs per tool, as the sections above record. Two option names differ by one letter, and they behave differently.

| Option | What it does |
|---|---|
| `--extra-args` | Takes one quoted string holding all your extra text at once |
| `--extra-arg` | Repeatable, meaning you give it once per argument and the values accumulate in order |

A useful example on iVar is a flag the pipeline does not already set, such as `ivar variants -c`, which makes iVar count and report the total depth at each position alongside the allele counts. Setting `-t` or `-m` yourself has no effect, since LGE's value takes effect instead.

The second route is `lungfish-cli conda run [--env <name>] <tool> [args...]`, which runs a tool from its managed environment and passes standard output, standard error, and the exit status straight through. This is the supported way to call a wrapped tool by hand, and it costs you the provenance record, since nothing about the run is written down.

The third route is running the tool from the environment yourself with no LGE involvement at all. That costs the same record. It also means a later `lungfish-cli bam adopt-mapping` cannot confirm the alignment came from the pipeline it expected. That command wants a `lungfish map` result directory rather than a loose BAM, and a hand-run tool produces the second. Use the second route before the third.

## Querying variants without the window

Two subcommands read a bundle's variant database from a script. `lungfish-cli variants query` applies a per-sample [smart filter](../../GLOSSARY.md#smart-filter-token) over bundle variants, the smart filters being the same named filter chips the Variants tab offers behind its Presets button. And `lungfish-cli variants extract-sample` pulls one sample's calls out of the database. Both are listed under `lungfish-cli variants --help`.

One caveat carries over from the window, and it is in the consolidated caveat list above for that reason. A per-sample filter clause reads a `FORMAT DP` field, the per-sample read depth, that bcftools does not write, so such a clause matches nothing on a bcftools track. That is true in the Variants tab as much as from a script, and [Reading the Variants Table](../05-variants/02-reading-the-variant-browser.md) explains it.

## Next

See [CLI Reference](cli-reference.md) for the full command surface, [File Formats](file-formats.md) for the bundle and sidecar formats, [Tool Versions](tool-versions.md) for the pinned dependency set, [Running in CI](06-running-in-ci.md) for headless runs, and [Troubleshooting](troubleshooting.md) for failure modes.
