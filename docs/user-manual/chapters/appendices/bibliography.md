---
title: Tool Bibliography
chapter_id: appendices/bibliography
audience: power-user
prereqs: []
estimated_reading_min: 26
task: Cite the upstream tools a Lungfish Genome Explorer run used, and cite the app itself.
tags: [reference, bibliography, citations, doi, provenance]
tools: []
entry_points:
  - "CLI: lungfish-cli provenance bibliography <bundle>"
shots: []
illustrations: []
glossary_refs: [alias-table, bundle, checksum, citation, conda, container, dependency-set, doi, exit-status, host-depletion, json, operations-panel, pinned, plugin-pack, positional-argument, preprint, provenance, provenance-sidecar, reference-manager, tool-lock-manifest]
features_refs: []
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

<a id="appendix-bibliography"></a>

## What it is

The command this appendix teaches runs in the Terminal application, and it is the only way to produce a citation list from a finished run. No window in Lungfish Genome Explorer (LGE) prints one. If you would rather not open a terminal at all, the four tables below are your route, and you look up each tool your run used by name and copy its reference by hand. A student writing a methods section is exactly who this appendix is for.

Journals require you to credit the software that produced each number. You owe a citation to the authors of every tool that ran, not to LGE. Most of the analysis in LGE is done by other people's tools. A mapping run is usually minimap2, a variant call is usually GATK or LoFreq, and a classification is usually Kraken 2, though these are examples rather than fixed choices, and the command below prints the tools your own run actually used. A **[citation](../../GLOSSARY.md#citation)** is the formal reference to the paper or the project page that describes a tool, in the same form you would use for any other reference in the paper.

This appendix holds two things.

1. A command that reads one finished run and prints the citations for exactly the tools that ran in it.

2. Four tables covering every tool this release of LGE ships or installs, with its citation, so you can look one up without having a run in front of you.

Be warned on both counts. The command's built-in list of tool names is smaller than the tool set LGE ships, so it will miss tools your run used, and in three cases it prints a confident citation for the wrong tool. The section on tools the command mishandles says which, and the tables are what you fill the gaps from.

Three terms appear throughout. A **[DOI](../../GLOSSARY.md#doi)**, or digital object identifier, is the permanent address of a published article, a string like `10.1093/bioinformatics/bty191` that a journal prints on the first page and that resolves forever, even if the journal moves its website. To turn a bare DOI into a working link, put `https://doi.org/` in front of it. A **[provenance sidecar](../../GLOSSARY.md#provenance-sidecar)** is the file LGE writes next to every output it produces, in **[JSON](../../GLOSSARY.md#json)**, a plain text data format any text editor opens. It records which program file ran, its exact version, the full command line, the run date, and the [checksums](../../GLOSSARY.md#checksum) of what went in and came out. LGE writes it automatically, so if you have a result you already have one. The sidecar is what the bibliography command reads, and it is also where you look to see which tools ran when you do not want to open a terminal.

A **[dependency set](../../GLOSSARY.md#dependency-set)** is the named list of tool versions one LGE release was built and tested against. This appendix carries the versions of Preview 2026.9.13, whose dependency set is `2026.2`. Name the dependency set in a methods section alongside the app version, because a later release will [pin](../../GLOSSARY.md#pinned) different versions of the same tools, meaning it will lock them to different exact numbers. Your own copy reports both, and the section on citing LGE says how to read them.

Every version number in this appendix comes from LGE's **[tool lock manifest](../../GLOSSARY.md#tool-lock-manifest)**, the file inside the app that records the exact version of every tool a release installs. [Tool Versions](tool-versions.md) is generated from that same manifest. When the two appendices disagree on a number, the manifest governs, and neither chapter overrides it.

What you should do with this is simple. Run the command against the folder that holds your result. Copy the citations it prints into your reference manager by hand, since the output is plain text rather than a file a reference manager can import. Then use the tables below to fill in anything the command missed.

## What the bibliography command prints

The command lives only on the command line and has no menu item, and no window route is planned for this release. Terminal is in the Utilities folder inside Applications, and Spotlight finds it if you press Cmd-Space and type its name. If you have never opened one, these are the steps.

1. Open Terminal. A line of text ending in a `$` or `%` appears. That line is the prompt, and everything below is typed after it and finished with the Return key.

2. Type `cd` followed by one space. Do not press Return yet.

3. Drag your project folder from the Finder onto the Terminal window. Its path appears after the space, so the line now reads something like `cd /Users/you/Documents/HG002-project`. A path that contains a space arrives with quotation marks around it, which is correct and should be left alone.

4. Press Return. The prompt returns and you are now working inside that folder.

5. Type the command below, replacing the example path with your own result folder, and press Return.

`lungfish-cli` is the command-line copy of LGE, and it arrives with the app. Installed releases do not put it on your `PATH`, the list of places your shell searches for programs, so either type the quoted full path `"/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli"` in place of the bare name, or run first the one-line `export PATH` command that the [CLI Reference](cli-reference.md) gives, after which the bare name works for that Terminal session. The examples below write the bare name.

```bash
lungfish-cli provenance bibliography ./Analyses/mapping-HG002
```

`./Analyses/mapping-HG002` is an example that you replace with your own folder, and a path beginning with `./` is read from the folder you are currently in. Dragging the result folder onto the Terminal window after the command word fills the path in for you. HG002 is the standard human reference sample, a well-characterised genome that the community uses to check that a method works, and it is the example run throughout this appendix.

The single value after the command is a **[positional argument](../../GLOSSARY.md#positional-argument)**, meaning a value whose meaning comes from where it sits rather than from a label in front of it. Point it at a **[bundle](../../GLOSSARY.md#bundle)**, which is a folder LGE created and draws as one item, or at any output directory. The command finds the provenance sidecar inside that folder on its own, trying the root file first and then the `provenance/` subfolder, and you never need to hunt for the file yourself.

Then it walks the steps that sidecar recorded. For each step it takes the recorded tool name and looks it up in an **[alias table](../../GLOSSARY.md#alias-table)**, a fixed list built into LGE of the different names one tool can be recorded under, so that `bwa`, `bwa-mem`, and `bwa-mem2` all reach one entry. That shared entry prints the 2009 Li and Durbin paper, which is not the paper to cite for the BWA-MEM2 that LGE installs, and the note under the plugin pack table says what to use instead. There is no way to display the alias table from the app or the command line.

Matching works in three tiers, and the third is where it goes wrong. An exact name match wins first. Failing that, a name that contains the other wins, which is why `samtools sort` matches SAMtools. Failing that, a single shared word is enough, which is loose enough to reach a wrong entry entirely. Every step whose name matches contributes one citation, with duplicates removed and the list sorted by tool name. Every step whose name matches nothing is listed separately under a heading of its own.

On a minimap2 mapping run of the HG002 chromosome 20 reads, two citations come back.

```
Bibliography for bundle: /Users/you/scratch/mapping/minimap2-out

- minimap2: Li H. Minimap2: pairwise alignment for nucleotide sequences. Bioinformatics. 2018. DOI: 10.1093/bioinformatics/bty191 https://github.com/lh3/minimap2
- SAMtools: Danecek P, Bonfield JK, Liddle J, et al. Twelve years of SAMtools and BCFtools. GigaScience. 2021. DOI: 10.1093/gigascience/giab008 https://www.htslib.org/
```

Two tools ran and two citations came back, each with author list, title, journal, year, DOI, and project URL. [Exporting as Nextflow or Snakemake](../08-workflows/02-exporting-as-nextflow-or-snakemake.md) reports the same pair for the same run. A tool with no DOI in the table prints only its project URL after the citation sentence, and a tool with neither prints the citation sentence alone.

The second half of the output appears whenever a step matched nothing. On a GATK HaplotypeCaller run of the same reads, nothing matched at all, and this block is the command's entire output.

```
Bibliography for bundle: /Users/you/scratch/gatk-hc

No known tool citations were matched from this provenance record.

Tools without known citations
- gatk-haplotype-caller 4.6.2.0
```

Every command hands back an **[exit status](../../GLOSSARY.md#exit-status)** when it finishes, a number that a script can test. Zero means success and any other number means the command stopped for a reason it defines. This command reports success, exit status 0, in all three of the cases above, including the case where it matched nothing at all. Only a folder with no sidecar in it fails, and it prints `Error: Workflow execution failed: No Lungfish provenance sidecar found in <path>` and reports failure with exit status 64. If you run the command by hand you can ignore the number and read the output. If you call it from a script, do not test the exit status to decide whether citations came back, because an empty bibliography still reports success.

### Tools the command mishandles

The alias table is smaller than the tool set LGE ships, so a missing citation is common rather than exceptional. Five causes account for what you will see. Only the fifth means anything is wrong with what you would publish.

The first is a tool that is genuinely absent from the alias table. Broadly, most assembly and variant-calling tools are missing, along with several classification tools. By name, that is every assembler (SPAdes, MEGAHIT, SKESA, Flye, and hifiasm), most GATK steps, Clair3, WhatsHap, Freyja, BLAST, Bracken, EsViritu, RiboDetector, Savont, TaxTriage, pysam, and openpyxl. A run using any of them prints the tool under the unmatched heading. A SPAdes assembly, for instance, prints `- spades 4.3.0` as the only line under that heading. Take the citation for those from the tables below and add it by hand.

The second is a recorded step name that does not resemble the tool it ran. GATK steps are recorded as `gatk-haplotype-caller`, `gatk-joint-genotype`, `gatk-bqsr`, and similar, and Freyja is recorded as `lungfish freyja demix`, so even an alias table entry named for the tool would need the wrapper spelling too. This needs no action from you beyond adding the citation by hand.

The third is LGE's own steps, which are recorded under names like `lungfish extract reads` or `lungfish genotype export-pivot-xlsx`. Every one of LGE's own steps begins with `lungfish`, so they are easy to spot. These are the app's own code rather than an upstream tool, so no citation is owed and you can ignore those lines. Cite LGE once, as described at the end of this appendix.

The fourth is your own scripts, if a lab tool wrote into the project. Those need a citation you supply.

The fifth is the one to watch, because here the command recognises too much rather than too little. That third matching tier, a single shared word, reaches a wrong entry for three step names, and the result is a complete and confident citation for a tool that never ran. Trim Galore prints an iVar citation, because both names carry the word `trim`. So does `gatk-variants-to-table`, on the word `variants`. And `gatk-variant-filtration` prints a Medaka citation, on the word `variant`. Trim Galore installs with every copy of LGE, so this is reachable without any plugin pack. If your run used any of these three, delete the citation the command printed and take the right one from the tables below.

Three of these are LGE defects in this release rather than things to work around quietly, and the wrong-citation case is the serious one.

## Tools installed with every copy of LGE

These tools are present in every copy of LGE. They need no **[plugin pack](../../GLOSSARY.md#plugin-pack)**, which is a themed group of tools LGE installs on demand into its own [conda](../../GLOSSARY.md#conda) environment, described in the plugin pack chapter.

Rows carrying a project page rather than a DOI belong to tools that never published a paper, and for those the project page is what you cite. To turn a bare DOI in the last column into a working link, put `https://doi.org/` in front of it.

| Tool | Version | DOI or project page |
|---|---|---|
| Nextflow | 26.04.6 | 10.1038/nbt.3820 |
| Snakemake | 9.25.2 | 10.12688/f1000research.29032.2 |
| BBTools | 40.02 | <https://sourceforge.net/projects/bbmap/> |
| fastp | 1.3.6 | 10.1093/bioinformatics/bty560 |
| Deacon | 0.16.0 | <https://github.com/bede/deacon> |
| SAMtools | 1.24 | 10.1093/gigascience/giab008 |
| BCFtools | 1.24 | 10.1093/gigascience/giab008 |
| HTSlib | 1.24 | 10.1093/gigascience/giab008 |
| SeqKit | 2.13.0 | 10.1371/journal.pone.0163962 |
| Cutadapt | 5.2 | 10.14806/ej.17.1.200 |
| Trim Galore | 2.3.0 | <https://github.com/FelixKrueger/TrimGalore> |
| VSEARCH | 2.31.0 | 10.7717/peerj.2584 |
| pigz | 2.8 | <https://zlib.net/pigz/> |
| SRA Tools | 3.4.1 | <https://github.com/ncbi/sra-tools> |
| UCSC bedGraphToBigWig | 482 | 10.1093/bioinformatics/btq351 |
| pysam | 0.24.0 | <https://github.com/pysam-developers/pysam> |
| openpyxl | 3.1.5 | <https://openpyxl.readthedocs.io/> |
| micromamba | 2.9.0-0 | <https://mamba.readthedocs.io/> |

bedGraphToBigWig versions by build number rather than by a dotted release number, so the bare `482` is correct and is not a truncated figure.

The author, title, journal, and year for each of those follow. Article titles are transcribed exactly as published, punctuation and accented characters included. Each reference is completed by the DOI or project page in the table above, so a finished entry is built by joining the two.

```
Nextflow          Di Tommaso P, Chatzou M, Floden EW, et al. Nextflow enables reproducible computational workflows. Nature Biotechnology. 2017.
Snakemake         Moelder F, Jablonski KP, Letcher B, et al. Sustainable data analysis with Snakemake. F1000Research. 2021.
BBTools           Bushnell B. BBTools software package. Joint Genome Institute.
fastp             Chen S, Zhou Y, Chen Y, Gu J. fastp: an ultra-fast all-in-one FASTQ preprocessor. Bioinformatics. 2018.
Deacon            Deacon host-depletion toolkit.
SAMtools          Danecek P, Bonfield JK, Liddle J, et al. Twelve years of SAMtools and BCFtools. GigaScience. 2021.
BCFtools          Danecek P, Bonfield JK, Liddle J, et al. Twelve years of SAMtools and BCFtools. GigaScience. 2021.
HTSlib            Danecek P, Bonfield JK, Liddle J, et al. Twelve years of SAMtools and BCFtools. GigaScience. 2021.
SeqKit            Shen W, Le S, Li Y, Hu F. SeqKit: a cross-platform and ultrafast toolkit for FASTA/Q file manipulation. PLOS ONE. 2016.
Cutadapt          Martin M. Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet.journal. 2011.
Trim Galore       Krueger F. Trim Galore. Babraham Bioinformatics.
VSEARCH           Rognes T, Flouri T, Nichols B, Quince C, Mahe F. VSEARCH: a versatile open source tool for metagenomics. PeerJ. 2016.
pigz              Adler M. pigz: a parallel implementation of gzip.
SRA Tools         NCBI Sequence Read Archive Toolkit.
bedGraphToBigWig  Kent WJ, Zweig AS, Barber G, Hinrichs AS, Karolchik D. BigWig and BigBed: enabling browsing of large distributed datasets. Bioinformatics. 2010.
pysam             pysam, a Python interface to SAM, BAM, and VCF files.
openpyxl          openpyxl, a Python library to read and write Excel 2010 files.
micromamba        Mamba and micromamba package managers.
```

Several entries above carry no author and no year, because the tool has neither a paper nor a stated release date. A **[reference manager](../../GLOSSARY.md#reference-manager)** that requires a year takes `n.d.`, meaning no date, in that field. Deacon is one such tool, and its work is [host depletion](../../GLOSSARY.md#host-depletion), the removal of reads that came from the organism the sample was taken from.

### One worked example

Here is one finished reference, assembled from a table row and the command's own output, in a common author-date style. The command printed this line for the HG002 mapping run.

```
- minimap2: Li H. Minimap2: pairwise alignment for nucleotide sequences. Bioinformatics. 2018. DOI: 10.1093/bioinformatics/bty191 https://github.com/lh3/minimap2
```

Rearranged into a reference list entry, using only the fields that line and the table carry, it becomes this.

```
Li H. (2018). Minimap2: pairwise alignment for nucleotide sequences.
Bioinformatics. https://doi.org/10.1093/bioinformatics/bty191
```

A software tool with no paper follows the same shape with `n.d.` for the year and the project page in place of the DOI.

```
Krueger F. (n.d.). Trim Galore. Babraham Bioinformatics.
https://github.com/FelixKrueger/TrimGalore
```

A citation without a DOI is normal for software and journals accept it. Match the punctuation to whatever style your own journal asks for, and the fields above are all you need.

Remember to cite three rows that are easy to miss. pysam reads the BAM files that produce a viewport's coverage and depth readouts, openpyxl writes the genotyping workbooks, and micromamba is the package manager that installed every other tool named in this appendix. If a number in your figure came out of a genotyping workbook or a coverage readout, one of those three helped produce it.

## Tools installed by a plugin pack

The Pack column names the pack that installs each tool. A pack arrives either from the Plugin Manager at **Tools > Plugin Manager...**, which installs tools but produces no citations of its own, or from `lungfish-cli conda install --pack read-mapping`. `--pack` is a switch that takes no value of its own and changes how the names after it are read, so the example installs the whole `read-mapping` pack rather than a package called `read-mapping`.

Three packs in the table below install only through the Plugin Manager, because the command-line installer does not list them. They are `gatk-core`, `phasing`, and `wastewater-surveillance`, and asking for any of them on the command line stops with an unknown-pack error.

Cite only the tools your own sidecar names, not the whole table. The command's output is that list, and the next section gives a route to the same list without a terminal.

| Tool | Version | Pack | DOI or project page |
|---|---|---|---|
| minimap2 | 2.31 | read-mapping | 10.1093/bioinformatics/bty191 |
| BWA-MEM2 | 2.3 | read-mapping | 10.1109/IPDPS.2019.00041 |
| Bowtie 2 | 2.5.5 | read-mapping | 10.1038/nmeth.1923 |
| Savont | 0.6.3 | full-length-mhc-genotyping | <https://github.com/bluenote-1577/savont> |
| BLAST+ | 2.16.0 | full-length-mhc-genotyping | 10.1186/1471-2105-10-421 |
| LoFreq | 2.1.5 | variant-calling | 10.1093/nar/gks918 |
| iVar | 1.4.4 | variant-calling | 10.1186/s13059-018-1618-7 |
| Medaka | 2.2.2 | variant-calling | <https://github.com/nanoporetech/medaka> |
| Clair3 | 2.0.2 | variant-calling | 10.1038/s43588-022-00387-x |
| GATK4 | 4.6.2.0 | gatk-core | 10.1101/gr.107524.110 |
| WhatsHap | 2.3 | phasing | 10.1101/085050 |
| SPAdes | 4.3.0 | assembly | 10.1089/cmb.2012.0021 |
| MEGAHIT | 1.2.9 | assembly | 10.1093/bioinformatics/btv033 |
| SKESA | 2.5.1 | assembly | 10.1186/s13059-018-1540-z |
| Flye | 2.9.6 | assembly | 10.1038/s41587-019-0072-8 |
| hifiasm | 0.25.0 | assembly | 10.1038/s41592-020-01056-5 |
| MAFFT | 7.526 | multiple-sequence-alignment | 10.1093/molbev/mst010 |
| IQ-TREE | 3.1.3 | phylogenetics | 10.1093/molbev/msaa015 |
| Kraken 2 | 2.17.1 | metagenomics | 10.1186/s13059-019-1891-0 |
| Bracken | 1.0.0 | metagenomics | 10.7717/peerj-cs.104 |
| EsViritu | 1.3.3 | metagenomics | <https://github.com/cmmr/EsViritu> |
| RiboDetector | 0.3.3 | metagenomics | 10.1093/nar/gkac112 |
| Freyja | 2.0.3 | wastewater-surveillance | 10.1038/s41586-022-05049-6 |

A pack name is a label LGE uses to group tools for installation, not something a journal wants, so leave it out of a methods section. `full-length-mhc-genotyping` installs the tools for typing MHC genes, the major histocompatibility complex, the highly variable immune-system region that this pack's workflow genotypes. The WhatsHap DOI resolves to a bioRxiv **[preprint](../../GLOSSARY.md#preprint)**, an article posted before peer review, so check whether your journal accepts one before you use it.

The matching references follow, in the same order.

```
minimap2      Li H. Minimap2: pairwise alignment for nucleotide sequences. Bioinformatics. 2018.
BWA-MEM2      Vasimuddin Md, Misra S, Li H, Aluru S. Efficient architecture-aware acceleration of BWA-MEM for multicore systems. IEEE IPDPS. 2019.
Bowtie 2      Langmead B, Salzberg SL. Fast gapped-read alignment with Bowtie 2. Nature Methods. 2012.
Savont        Savont read clustering toolkit.
BLAST+        Camacho C, Coulouris G, Avagyan V, et al. BLAST+: architecture and applications. BMC Bioinformatics. 2009.
LoFreq        Wilm A, Aw PPK, Bertrand D, et al. LoFreq: a sequence-quality aware, ultra-sensitive variant caller. Nucleic Acids Research. 2012.
iVar          Grubaugh ND, Gangavarapu K, Quick J, et al. An amplicon-based sequencing framework for accurately measuring intrahost virus diversity using PrimalSeq and iVar. Genome Biology. 2019.
Medaka        Oxford Nanopore Technologies. Medaka sequence correction and consensus toolkit.
Clair3        Zheng Z, Li S, Su J, et al. Symphonizing pileup and full-alignment for deep learning-based long-read variant calling. Nature Computational Science. 2022.
GATK4         McKenna A, Hanna M, Banks E, et al. The Genome Analysis Toolkit. Genome Research. 2010.
WhatsHap      Martin M, Patterson M, Garg S, et al. WhatsHap: fast and accurate read-based phasing. bioRxiv. 2016.
SPAdes        Bankevich A, Nurk S, Antipov D, et al. SPAdes: a new genome assembly algorithm and its applications to single-cell sequencing. Journal of Computational Biology. 2012.
MEGAHIT       Li D, Liu CM, Luo R, Sadakane K, Lam TW. MEGAHIT: an ultra-fast single-node solution for large and complex metagenomics assembly. Bioinformatics. 2015.
SKESA         Souvorov A, Agarwala R, Lipman DJ. SKESA: strategic k-mer extension for scrupulous assemblies. Genome Biology. 2018.
Flye          Kolmogorov M, Yuan J, Lin Y, Pevzner PA. Assembly of long, error-prone reads using repeat graphs. Nature Biotechnology. 2019.
hifiasm       Cheng H, Concepcion GT, Feng X, Zhang H, Li H. Haplotype-resolved de novo assembly using phased assembly graphs with hifiasm. Nature Methods. 2021.
MAFFT         Katoh K, Standley DM. MAFFT multiple sequence alignment software version 7: improvements in performance and usability. Molecular Biology and Evolution. 2013.
IQ-TREE       Minh BQ, Schmidt HA, Chernomor O, et al. IQ-TREE 2: new models and efficient methods for phylogenetic inference in the genomic era. Molecular Biology and Evolution. 2020.
Kraken 2      Wood DE, Lu J, Langmead B. Improved metagenomic analysis with Kraken 2. Genome Biology. 2019.
Bracken       Lu J, Breitwieser FP, Thielen P, Salzberg SL. Bracken: estimating species abundance in metagenomics data. PeerJ Computer Science. 2017.
EsViritu      EsViritu read mapping and reporting for viral genomes.
RiboDetector  Deng ZL, Munch PC, Mreches R, McHardy AC. Rapid and accurate identification of ribosomal RNA sequences via deep learning. Nucleic Acids Research. 2022.
Freyja        Karthikeyan S, Levy JI, De Hoff P, et al. Wastewater sequencing reveals early cryptic SARS-CoV-2 variant transmission. Nature. 2022.
```

Three rows need a note, and each note names one paper you cite and one you may add beside it. A secondary citation is a second reference kept alongside the first for the original method, and both go in your reference list when you use one.

BWA-MEM2 is what LGE installs, so cite the 2019 architecture paper above. Keep Li and Durbin 2009 (`10.1093/bioinformatics/btp324`) as the secondary citation for the underlying Burrows-Wheeler algorithm, which is what a reviewer asking where the method came from wants.

MAFFT is version 7, so the 2013 paper is the one to cite. Katoh and colleagues 2002 (`10.1093/nar/gkf436`) is the secondary citation for the original method.

LGE installs IQ-TREE 3.1.3, and IQ-TREE 3 had not published its own paper when this release was built, so the IQ-TREE 2 paper above is correct for now. Check <http://www.iqtree.org> for a version 3 paper before you submit, since one may have appeared since.

## Pinned external pipelines

A pipeline is a program that runs many separate tools in a fixed order, so citing one commits you to citing what it contains as well. LGE pins one release of each of these two and launches it through Nextflow.

| Pipeline | Pinned release | DOI or project page |
|---|---|---|
| nf-core/viralrecon | 3.0.0 | 10.5281/zenodo.3901628 |
| TaxTriage | v3.3.8 | <https://github.com/jhuapl-bio/taxtriage> |

```
nf-core/viralrecon  Patel H, Varona S, Monzon S, et al. nf-core/viralrecon: assembly and intrahost/low-frequency variant calling for viral samples.
TaxTriage           TaxTriage, a Nextflow pipeline for pathogen identification from metagenomic reads. Johns Hopkins University Applied Physics Laboratory.
```

Neither entry carries a year, and neither pipeline publishes one for the release LGE pins, so use `n.d.` and the pinned release number above. Cite the pipeline itself, cite the Nextflow paper from the first table, and then cite the pipeline's own component tools. Each nf-core pipeline states its citation requirements in the CITATIONS file at the top of its own repository, and for viralrecon 3.0.0 that file names every tool the run touched.

Four tools reach a result only inside these pipelines, in [containers](../../GLOSSARY.md#container) the pipeline manages rather than through LGE's own installation. A container is a packaged copy of a program with everything it needs to run. BEDTools, MultiQC, Pangolin, and Nextclade are the four, and a viralrecon run's CITATIONS file lists all four, so a viralrecon methods section names them. Their citations are Quinlan and Hall 2010 for BEDTools (`10.1093/bioinformatics/btq033`), Ewels and colleagues 2016 for MultiQC (`10.1093/bioinformatics/btw354`), O'Toole and colleagues 2021 for Pangolin (`10.1093/ve/veab064`), and Aksamentov and colleagues 2021 for Nextclade (`10.21105/joss.03773`). LGE does not install, version, or manage any of the four.

## Reference databases

A classification result depends on the database as much as on the classifier, and a reviewer cannot reproduce a Kraken 2 report without knowing which version of the database you searched. Name the database and its version alongside the tool. These are the versions this release pins.

| Database | Version |
|---|---|
| Kraken 2 Standard, Standard-8, Standard-16, PlusPF, PlusPF-8, PlusPF-16, Viral, and MinusB | 20260626 |
| Kraken 2 EuPathDB46 | 20230407 |
| Kraken 2 SILVA and Greengenes | kraken2-special-v1 |
| EsViritu Viral DB | v3.2.4 |
| Human Read Scrubber Database | 20260706v2 |
| Human Read Removal Data, for Deacon | panhuman-1 |
| Ribosomal RNA Removal Data, for Deacon | bbmap-ribokmers-k31w15 |
| NCBI Taxonomy | live |

The first row names eight separate Kraken 2 builds that happen to share a version. Your own run used one of them, and your provenance sidecar names which. The Human Read Scrubber Database serves NCBI's read scrubber, a tool that strips human reads out of a sample before it is shared, and the last two data rows serve Deacon for host depletion and for ribosomal RNA removal, which discards the reads that came from ribosomal genes because they carry no information about the organism being studied.

Two of these version strings are dates written as year, month, and day, namely `20260626` and `20230407`, and `20260706v2` is such a date with a revision letter after it. The rest are release names rather than dates. Whichever kind you have, copy the string into your methods section exactly as it appears here, since that is what identifies the build.

The NCBI Taxonomy row is the important one. Its version is the word `live`, which means the taxonomy is not fixed at all. LGE fetches whatever NCBI is serving at the moment you run, so the same read can be given a different species name in a later run. Record the date you ran the classification, since that is the only thing that identifies which taxonomy you used. Your provenance sidecar records that date for you.

## Which tools you actually need to cite

Your provenance sidecar is the authoritative list. Cite what it names and nothing else. There are three routes to that list, and only the first needs a terminal.

1. Run `lungfish-cli provenance bibliography` against the result folder, as above, and read both the citation list and the unmatched heading below it. Both halves are tools that ran.

2. Open the [Operations panel](../../GLOSSARY.md#operations-panel) with **Operations > Show Operations Panel** (Cmd-Shift-P), select the row for the run, and click **More** to expand it. The expanded row shows the command that ran, with a Copy button beside it, and the history of each step below that.

3. Open the sidecar itself. It is the file named `.lungfish-provenance.json` beside your result, or inside the bundle's `provenance/` folder. It is plain text, so any text editor opens it, and the `toolName` entries are the tools that ran.

Routes 2 and 3 need no terminal, and route 3 is the one that gives the same complete list the command reads.

## Citing LGE itself

LGE has no published paper and no DOI of its own as of Preview 2026.9.13, so the citation is the project page together with the version string. Include the dependency set, because that is what lets somebody else install the same tool versions.

```
Lungfish Genome Explorer, version 2026.9.13, dependency set 2026.2.
https://github.com/dhoconno/lungfish-genome-explorer
```

That block is a usable default. Reshaped into the same author-date style as the worked example above, it reads like this.

```
Lungfish Genome Explorer. (2026). Version 2026.9.13, dependency set 2026.2.
https://github.com/dhoconno/lungfish-genome-explorer
```

To read your own version rather than the one printed here, open **Lungfish Genome Explorer > About Lungfish Genome Explorer**, which needs no terminal. From a terminal, `lungfish-cli --version` prints the same number and nothing else, reporting `2026.9.13` for this release. Both the version and the dependency set are recorded in every provenance sidecar, so a reader who has your sidecar can recover them without asking you.

## Using this with a methods section

Do not paste these tables into a paper. A citation says which tool you used and a provenance sidecar says which build of it ran with which arguments, and a methods section needs both. Run `provenance bibliography` against the finished run to get the citations, run `provenance export --format methods` against the same folder to get the commands and versions, and write the methods paragraph from the pair.

```bash
lungfish-cli provenance export ./Analyses/mapping-HG002 \
  --format methods \
  --output ./mapping-HG002-methods
```

A trailing backslash continues one command over several lines, so those three lines are typed as one instruction. The methods export writes a prose paragraph naming each tool, its exact version, and the arguments it ran with, opening on a line like `Reads were mapped with minimap2 2.31 using preset map-ont.` It is the half the bibliography does not cover.

Three rules keep your citations accurate.

1. Cite only the tools your own run used, not everything in the tables above. A reviewer who reads a citation for a tool that never ran will doubt the rest of your methods.

2. Add by hand every tool the command listed as unmatched, and delete the three wrong citations named earlier if your run produced one. Check each name against the tables here.

3. Name the database version and the run date for any classification result, because the tool version alone does not identify what it searched.

## Next

For citing tools, [Tool Versions](tool-versions.md) is the chapter that matters most after this one, giving the full version, license, and environment of every managed tool. See [Exporting as Nextflow or Snakemake](../08-workflows/02-exporting-as-nextflow-or-snakemake.md) for the methods export that pairs with this command, and [CLI Reference](cli-reference.md) for the rest of the `provenance` subcommands.
