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
Export). In body prose write "the Inspector's Consensus tab", not "Inspector
> Analysis > Consensus". The path form stays in front-matter `entry_points`
and in the registry, which are metadata rather than prose (ruled 2026-09-07
at the chapter 30 review). The Operations panel opens with **Operations > Show Operations
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
`Reference Sequences/`, extractions under `Extractions/` (with one
exception settled 2026-09-07 at the chapter 23 review: Extract Reads in
Selected Region from the alignment track writes its bundle to an
`alignment-read-extractions/` folder inside the mapping run's own folder
under `Analyses/`, or under the project root when the track has no run
folder, with no save panel, per
`AlignmentScientificActionCoordinator.defaultDestination`), and analysis
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
while the CLI's `tree infer --output` writes wherever you point it. An
imported ONT run folder is different again. Its bundle lands at the
project root, not under `Imports/`, with a run-named sibling folder at the
root only when a previous ONT output already sits there
(`ONTImportOperationCoordinator.resolvedOutputDirectory`, settled
2026-09-07 at the chapter 20 review). There
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
no flag, say "This setting has no command-line flag." A group of viewer
display settings that all lack a flag may say so once in the group's lead
paragraph instead of once per setting (ruled 2026-09-07 at the chapter 23
gate).

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

When a fixture is a whole folder rather than one file (nvd-demo, primate-mito,
human-mito, and any fixture whose data is several files), the sentence after
the GitHub link is fixed as well, because a GitHub folder page offers no
download button and three readers of chapter 40 stopped there: "GitHub
offers no download for a single folder, so open the repository's front page
at https://github.com/dhoconno/lungfish-genome-explorer, click the green
**Code** button, choose **Download ZIP**, double-click the downloaded file
to unpack it, and find the folder inside it under
`docs/user-manual/fixtures/`." Chapters committed before this ruling get the
sentence in the Phase 6 sweep.

## Where imported classifier results land (settled by the chapter 36, 39, and 40 fidelity reviews)

The import routes do not share one destination, and each chapter states
its own plainly rather than appealing to the Analyses rule for named-tool
runs. The Import Center writes an NVD bundle into the project's `Imports`
folder (`AppDelegate+ToolsMenu.swift:636`), a NAO-MGS bundle into
`Analyses` (`AppDelegate+ImportCenter.swift:694-712`), and a CZ ID result
into `Classifications/<sample>.lungfishtax` (`AppDelegate+ToolsMenu.swift:860-867`).
Every command-line import writes wherever `--output-dir` points, defaulting
to the current directory, so a headless example passes a folder inside the
project. The demo project's `Analyses/nvd-demo` copy came from the command
line with `Analyses` as the destination. A chapter may say the sidebar
shows the result wherever it landed, since `AnalysesFolder` lists nvd and
naomgs among both its known tools and its imported-result tools.
Imported-result bundles are named `<tool>-<input stem>` rather than with a
timestamp, so the NAO-MGS fixture imports as `naomgs-virus_hits_final`.
The `cz-id` entry in `knownTools` is dead for the import. No CZ ID path
calls `createAnalysisDirectory`, and both routes write
`Classifications/<sample>.lungfishtax` (`AppDelegate+ToolsMenu.swift:860-867`),
while the import sheet's Project Destination readout composes an
`Analyses/cz-id-<timestamp>` path nothing writes to.

A 12S Amplicon Matching run writes a fixed category folder rather than a
timestamped one. The result lands at
`Analyses/12S amplicon results/<Result Name>.lungfish12s` (settled by the
chapter 41 fidelity review), so that part of the manual names the folder
by that string.

The GATK entries of the Call Variants dialog are a second exception to the
variant track storage ruling. They write `variants/gatk/<track-id>.vcf.gz`
inside the bundle with a SQLite sidecar (settled by the chapter 42 fidelity
review), and the dialog's two Thresholds fields are discarded on both GATK
entries rather than recorded. Variant counts across the manual follow the
Part V convention, LGE's Type column judged on the first ALT allele, so the
HG002 chromosome 20 HaplotypeCaller VCF holds 844 SNVs and 182 indels of
1,026 rows, and a bcftools tally that reads 843 and 184 is explained in one
sentence rather than adopted.

## Assembly rulings (settled by the chapter 46 and 47 reviews)

MEGAHIT 1.2.9 fails most runs on Apple Silicon in this release with both
shipped workarounds active (five reruns, four failures at different k
values). Every chapter that offers MEGAHIT carries the same caution in one
paragraph: it fails most runs, the failure is a nonzero exit in the
Operations panel with no contigs written, a run that completes is correct,
and rerunning is the only workaround. No chapter says the two-thread cap
fixes it. SPAdes on the human-mito fixture is quoted at the fixture's
committed 13.7 seconds, with the 110.7 second run under load named once
to show runtime is not a check. Align with MAFFT is absent from the
assembly contig context menu rather than greyed out. A contig extraction's
derived bundle lands in `Reference Sequences/` as `<assembly>-subset`,
a second exception to the Extractions rule.

The command-line section of every procedure chapter opens with chapter 33's
fixed paragraph. "This section is optional. If you do your work in the LGE
window, everything above is complete without it, and nothing here unlocks a
result the dialog cannot produce. It is here for readers who want to script a
run or repeat one on a server. The whole procedure runs headless, meaning with
no window at all, by typing commands into the Terminal application." Swap
"the dialog" for the surface the chapter uses.

## Variant track storage (settled by the chapter 5 fidelity review)

A variant track lives under the reference bundle's `variants/` folder as
`<name>.vcf.gz` with a `.vcf.gz.tbi` index and a `.db` SQLite sidecar that
the Variants tab uses for fast filtering
(`BundleVariantTrackAttachmentService.swift:71-74`). There is no BCF and no
CSI index on that path, whatever the drift report's row 3 for chapter 5
said. One exception, found at the chapter 28 review on 2026-09-07:
`lungfish-cli bundle create --variant` writes `.bcf` plus `.csi`, so a
track made that way is stored differently from one attached by `variants
call` or the Call Variants dialog. The filter
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

## Genotyping sample status (settled by the chapter 54 fidelity review)

The manual splits a genotyping plate the way the app labels it. A sample
whose retained unique reads number fewer than 1,000 carries the app's
`lowSupport` label and one at 1,000 or more carries `ok`
(`InspectorViewController+PublicAPI.swift:743-748`), which on the Williams
plate gives 23 `ok` and 7 `lowSupport`, with `ok` running from 1,976 to
58,370 reads and `lowSupport` from 2 to 713. No chapter draws its own
line at a different count. The Call-support check in the sample
workbench uses 1,000 reads and 20 alignments, and the cohort summary's
default `Below 5.0K reads` threshold belongs to a haplotyped result, so
the three numbers are three different checks and a chapter that names
more than one says so. The manual invents no further read thresholds. A
genotype-only result hides the cohort summary panel and the Smart
Cohorts section, so chapters written against the Williams project take
the cohort-level depth judgement from `genotype list-samples`.

## Shortcut spelling (settled by the chapter 62 fidelity review)

Modifiers are written Cmd, Shift, Opt, and Ctrl, joined by hyphens, in
the order the committed chapters use most. The Option key is Opt, never
Option, so the Inspector opens with Cmd-Opt-I. Where Control takes part
it comes first, so the sidebar toggles with Ctrl-Cmd-S and the side
panes restore with Ctrl-Cmd-Opt-F, matching the source comments in
MainMenu.swift. Symbol keys are named by the key a US keyboard prints on
them, so Help is Cmd-Shift-slash, written Cmd-? only with that gloss
beside it. A greyed menu item's shortcut does nothing until the item is
enabled. Chapters committed with Cmd-Option or Cmd-Ctrl are a Phase 6
sweep item.

## Exit statuses and the Deacon indexes (settled by the chapter 67 fidelity review)

`lungfish-cli` exits 2 for a usage error, 3 for an unknown pack, 10 when
`tools update --plan` finds pending work, and 64 for a workflow error,
which is the status behind the missing expected output refusal, the
empty Kraken 2 report, and `provenance verify` on an unsigned record
(`LungfishCLI.swift:154`). No chapter calls 64 a usage refusal. Both
Deacon indexes (`deacon-panhuman` and the ribosomal index) are managed
data entries the tool lock folds into Required Setup, so they install
with the app and no chapter says the command line is the only route to
them. The Plugin Manager's Databases tab still lists only the Kraken 2
catalogue, which is why they do not appear there.
