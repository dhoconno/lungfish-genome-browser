# Glossary

**Ownership:** Bioinformatics Educator only.

Terms appear in alphabetical order. Each entry is a one-sentence definition, followed by an explicit anchor ID in `{#anchor-id}` form so chapters can deep-link from inline references and the in-app Help system can resolve term lookups directly to this page. Anchor IDs match the `glossary_refs:` slugs declared in chapter frontmatter.

## A

**Accession**{#accession}. The permanent identifier a public sequence database assigns to one record, such as the RefSeqGene record `NG_000007.3`. The trailing number after the dot is a version that increments when a curator revises the deposited sequence, so a published coordinate should always name the version it was measured against. See also: INSDC, reference genome.

**Adapter**{#adapter}. The short synthetic DNA sequence that library preparation attaches to each end of a fragment so the instrument can bind and read it, which appears at the end of a read whenever the fragment was shorter than the read length and the instrument read straight through it. See also: library prep, FASTQ, fastp.

**AI assistant**{#ai-assistant}. An in-app chat panel that answers questions about the active dataset and suggests workflows through a bring-your-own-key AI provider; it interprets and explains but does not modify your project.

**Alu element**{#alu-element}. The most abundant repeated sequence in the human genome, a roughly 300-base insertion present in about a million copies and making up over a tenth of the genome, so a shotgun library from human DNA carries recognisable Alu sequence in a small but steady percentage of its reads. See also: sequence motif, shotgun sequencing.

**Alias map**{#alias-map}. The internal table Lungfish consults during VCF import to recognise that two reference accessions (for example, the GenBank record `MN908947.3` and the RefSeq record `NC_045512.2`) name the same underlying sequence, so a VCF keyed against one resolves cleanly to a project bundle keyed against the other. See also: VCF, reference bundle.

**Alignment**{#alignment}. The mapping of one read against a reference genome, recorded as one row in a BAM file with a position, strand, CIGAR string, and quality scores. See also: BAM, mapping.

**Alignment column**{#alignment-column}. One vertical slice through a multiple sequence alignment, holding one residue or one gap character from every row, taken to represent a single inferred homologous position across all the aligned sequences. See also: MSA, gap, homologous.

**Alignment track**{#alignment-track}. One named BAM attached to a reference bundle and drawn as its own read stack and coverage curve in the alignment viewport, so a bundle can carry several alignments side by side, whether of different read sets or of one read set before and after trimming. See also: BAM, reference bundle, mapping.

**Allele**{#allele}. One of the alternative sequences observed at a locus; in Lungfish MHC genotyping an allele is an individual MiSeq target identity, distinct from a named haplotype that spans several loci. See also: haplotype, MHC.

**Allele depth**{#allele-depth}. The pair of read counts a caller writes in a VCF's per-sample `AD` field, giving the number of reads supporting the reference allele and the number supporting the alternate, so a value of `20,33` at a depth of 53 means a third more reads carried the change than carried the reference. Lungfish Genome Explorer derives a per-sample allele frequency from this pair whenever a filter asks for one, which is why a per-sample `AF` clause matches nothing on a caller that writes no `AD`. See also: allele frequency, depth, FORMAT.

**Allele frequency**{#allele-frequency}. The proportion of sequencing reads at a position that carry the alternate base. A clinical isolate usually shows allele frequencies near 0 or 1; a mixed-population sample (for example, wastewater) shows a full spectrum.

**Amplicon**{#amplicon}. A target region of a genome amplified by PCR, used as the unit of an amplicon-based sequencing protocol such as ARTIC or QIASeqDIRECT. A run produces many overlapping amplicons that together tile the region of interest.

**Amplicon dropout**{#amplicon-dropout}. The failure of one amplicon in a tiled protocol to amplify, so no reads cover the stretch of genome it should have carried and a variant caller reports nothing there, which is indistinguishable from a genuinely unchanged region unless you read the per-amplicon coverage table. See also: amplicon, coverage, mosdepth.

**Annotation track**{#annotation-track}. One named set of features stored together inside a reference bundle and drawn as a single layer in the annotation lane of the sequence viewport, carrying both a display name and a stable track ID, so a GenBank import creates one named Imported Annotations and a bundle can hold several tracks at once. See also: reference bundle, GFF, sequence viewport.

**Assembly bundle**{#assembly-bundle}. A `.lungfishref` bundle that holds a de novo assembly produced inside the project, typically by SPAdes or MEGAHIT, and lives under the project's `Analyses/` folder alongside every other result. The internal structure is identical to a reference bundle; only the folder placement distinguishes the two. See also: reference bundle, bundle.

## B

**BAI**{#bai}. The companion index file for a BAM that lets viewers jump to a specific reference position without reading the whole file; conventionally named `<sample>.bam.bai` and kept in the same folder as the BAM. See also: BAM.

**BAM**{#bam}. The binary, indexed form of the SAM alignment format, with one row per aligned read and a header listing reference contigs; Lungfish always reads and writes BAMs rather than SAMs because of size and random-access requirements. See also: BAI, alignment, CIGAR.

**BAQ**{#baq}. Base Alignment Quality, samtools' per-base recalibration that lowers the quality of bases sitting near indel-prone regions; useful for shotgun random-fragment data and counterproductive for amplicon data, which is why Lungfish disables BAQ (`-B`) for amplicon variant calling. See also: pileup.

**Barcode**{#barcode}. A short oligonucleotide sequence (typically 8 to 24 bases) ligated onto a sample's reads during library prep so that pooled samples can be sorted back to their wells after multiplexed sequencing; ONT runs identify barcodes during basecalling and write one subfolder per barcode. See also: basecaller.

**Barcode kit**{#barcode-kit}. The named set of barcode sequences a sequencing kit uses to tag samples, which Lungfish reads to demultiplex a run. See also: barcode, demultiplex.

**Barcode scout**{#barcode-scout}. A command-line step that scans a subset of a read set against a barcode kit and reports how many reads hit each barcode, writing a `scout-result.json` that marks each barcode accepted, rejected, or undecided, so a wrong kit is caught before a full demultiplex is run. See also: barcode kit, demultiplex.

**BCF**{#bcf}. The compact binary form of VCF, holding the same rows and header but packed for machines. Lungfish Genome Explorer reads an imported BCF with a CSI index beside it, but stores the variant tracks it writes as a bgzip-compressed VCF with a tabix index under the bundle's `variants/` folder, alongside a SQLite sidecar that indexes the same rows. See also: VCF, CSI, tabix.

**BED**{#bed}. A plain-text table listing regions of a genome, one region per line, giving a contig name, a start coordinate, an end coordinate, and usually a name for the region; a primer scheme stores its primer positions as a BED file inside its `.lungfishprimers` bundle. See also: primer scheme, contig.

**Benchmark VCF**{#benchmark-vcf}. A variant call set produced independently of the reads under study and treated as an answer key, such as the Genome in a Bottle small-variant benchmark for HG002 that this manual compares its own calls against. See also: VCF, variant-caller.

**Basecaller**{#basecaller}. The program that converts a sequencer's raw signal into base-called reads with quality scores; for Oxford Nanopore data, Guppy and Dorado are the two basecallers in current use, and the model used to call a run determines which Medaka model is appropriate downstream. See also: simplex read, duplex read.

**bbduk**{#bbduk}. A read-filtering and trimming program from the BBTools suite that matches a supplied sequence against reads as k-mers, used in Lungfish Genome Explorer for read-level primer trimming with a literal primer sequence and for contaminant filtering. See also: k-mer, Hamming distance, primer trim.

**bcftools**{#bcftools}. A command-line toolkit for reading and writing VCF and BCF files that also contains a variant caller, whose `mpileup` and `call` subcommands together model which genotype best explains the reads at each position, making it a reasonable general caller for a sample with a fixed small number of genome copies. It ships in Lungfish Genome Explorer's Required Setup pack rather than the Variant Calling pack, so it is available in every project. See also: variant-caller, mpileup, VCF, genotype.

**bgzip**{#bgzip}. A compression program from HTSlib that writes a gzip-compatible file in independently compressed blocks, so a reader with an index can jump straight to one region instead of decompressing everything before it, which is why a `.vcf.gz` inside a bundle is bgzipped rather than plain-gzipped. See also: tabix, VCF.

**BioSample**{#biosample}. An NCBI record describing one biological sample; Lungfish can export a BioSample submission TSV from a project's sample metadata. See also: sample metadata.

**BLAST (Basic Local Alignment Search Tool)**{#blast}. NCBI's nucleotide and protein sequence search service that ranks database entries by local-alignment score against a query, used in Lungfish to verify a classifier's hit by sending a representative read to NCBI's `nt` database. See also: e-value, percent identity, query coverage.

**Bootstrap**{#bootstrap}. A way of measuring confidence in a phylogenetic grouping by rebuilding the tree many times from alignments resampled column by column and reporting, as a percentage, how often each grouping came back; IQ-TREE's ultrafast bootstrap is the fast approximation Lungfish Genome Explorer exposes. See also: support value, IQ-TREE, SH-aLRT.

**BQSR (Base Quality Score Recalibration)**{#bqsr}. The GATK preprocessing step that corrects systematic errors in a sequencer's per-base quality scores by modelling them against a set of known-variant sites, run in Lungfish through `lungfish gatk bqsr` ahead of germline calling. See also: VCF, HaplotypeCaller.

**Bracken**{#bracken}. A companion program to Kraken 2 that re-estimates how abundant each species really was, by redistributing the reads Kraken 2 parked at a broad rank down onto the species those reads most likely came from, using how much the database's reference genomes overlap one another. Lungfish Genome Explorer always runs it after a Kraken 2 classification started from the dialog, and its numbers appear as the taxonomy table's Bracken column. See also: Kraken 2, read classification, clade count, taxon.

**Branch length**{#branch-length}. The number attached to one branch of a phylogenetic tree, in the default phylogram drawing the estimated substitutions per site accumulated along that branch, so a long branch means a lot of inferred change rather than a long span of time. See also: phylogram, cladogram, topology.

**Bundle**{#bundle}. A folder that the macOS Finder shows as a single icon with an extension and that Lungfish treats as one logical object, with a manifest, primary data files, optional indexes and annotations, and a `provenance/` subfolder. Lungfish bundle types include `.lungfishref` for references and assemblies and `.lungfishprimers` for primer schemes. See also: reference bundle, assembly bundle, primer scheme.

## C

**CDS (coding sequence)**{#cds}. The portion of a gene that is translated into protein; Lungfish can annotate a best-match CDS on a sequence. See also: open reading frame, reading frame.

**Checksum**{#checksum}. A short fingerprint computed from a file's exact bytes, recorded by Lungfish as SHA-256 in every provenance record so two people can confirm they hold the identical file. See also: provenance, reproducibility.

**Capped database**{#capped-database}. A reference database deliberately shrunk to a target memory size by discarding most of its stored sequence fragments, so a machine too small to hold the full collection can still run the classifier against it. The cost falls on sensitivity, since a read the full collection would have named at species level is more often left unclassified or reported at a broader rank, and the loss is heaviest for whichever organism the sample is actually full of. See also: Kraken 2, minimizer, read classification.

**CIGAR**{#cigar}. A compact string in each BAM row that describes, base by base, how the read aligns to the reference: `M` for aligned positions, `I` and `D` for insertions and deletions, `S` for soft-clipped ends, and `H` for hard-clipped ends. See also: BAM, soft-clip.

**Circular consensus sequencing (CCS)**{#circular-consensus-sequencing}. The PacBio protocol that circularises a DNA fragment, reads it repeatedly, and reports the consensus of those passes as one read, which is why HiFi reads carry both long lengths and Q30+ quality strings; a HiFi read's quality is a consensus confidence, not a raw signal measurement. See also: read length, Phred score.

**Clade**{#clade}. A group on a phylogenetic tree consisting of one internal node and every tip descended from it; the unit a phylogeneticist points to when claiming "these isolates share a recent common ancestor". See also: phylogram.

**Clade count**{#clade-count}. The number of reads a classifier assigned to one taxon together with every taxon beneath it in the hierarchy, reported as the Reads column of the taxonomy table and set against the Direct count, which holds only the reads assigned to that exact taxon and no lower. A family row with a large clade count and a Direct count of zero means every one of those reads was resolved to something more specific. See also: taxon, taxonomic rank, kreport, Bracken.

**Cladogram**{#cladogram}. A phylogenetic tree drawn with every tip at the same depth so that only the branching order is shown and branch lengths carry no meaning; one of the two layouts the Lungfish Genome Explorer tree viewport offers, useful when one very long branch would otherwise squash the rest. See also: phylogram, topology, clade.

**Clair3**{#clair3}. A deep-learning variant caller for Oxford Nanopore reads, run in Lungfish as an alternative to Medaka for ONT variant calling; it reads the sorted BAM directly and takes a model path matched to the basecaller. See also: variant-caller, Medaka.

**Clumpify**{#clumpify}. A program from the BBTools suite that reorders reads so that reads sharing sequence content sit next to each other, and that can collapse those matching reads into one, which is what backs the Remove Duplicates operation in Lungfish Genome Explorer. See also: PCR duplicate, optical duplicate, read clumping.

**Clustering**{#clustering}. Grouping near-identical reads into representative consensus sequences before genotyping, used for full-length ONT MHC amplicons. See also: pbAA, savONT.

**Codon**{#codon}. A run of three consecutive bases inside a protein-coding gene that together encode one amino acid. Three adjacent SNPs falling inside one codon describe one amino acid change, not three; iVar can group them into a single VCF row when given a GFF annotation. See also: VCF.

**Cohort**{#cohort}. A set of samples genotyped and compared together, presented across the columns of the genotype comparison matrix. See also: genotype matrix.

**Conda**{#conda}. A package manager that handles compiled non-Python dependencies cleanly, used in Lungfish to install bioinformatics tools from the bioconda channel into per-tool environments under `~/.lungfish/conda`. See also: micromamba, plugin pack.

**Consensus FASTA**{#consensus-fasta}. The reference sequence with high-confidence sample variants applied in place; positions with insufficient evidence are masked as `N`. The format Pangolin and Nextclade expect for SARS-CoV-2 lineage assignment, and the format used for GISAID and NCBI surveillance submissions. See also: VCF, allele frequency.

**Consensus sequence**{#consensus-sequence}. A single sequence built from a multiple sequence alignment by taking each column's most common residue, with columns whose rows disagree too weakly or are too heavily gapped written as a mask character instead of a base. See also: MSA, alignment column, conservation.

**Consequence**{#consequence}. The predicted effect of one variant on the protein a gene encodes, written as a controlled term such as `missense_variant` for a change that swaps one amino acid or `synonymous_variant` for one that leaves the protein unchanged. Lungfish Genome Explorer shows it in the Variants tab's own `Consequence` column and in the Inspector, and it appears only where an annotation supplies it, since no caller writes it on its own. See also: AA change, GFF, variant-caller.

**Conservation**{#conservation}. At one alignment column, the share of the non-gap rows that carry that column's most common residue, so a column where every row agrees scores 1 and a column split evenly between two residues scores 0.5. See also: alignment column, MSA.

**Container**{#container}. A packaged copy of a program together with the libraries and files it needs to run, so the program behaves identically on every machine that runs the package, which is how a published pipeline guarantees that its results do not depend on whose computer produced them. See also: Docker, Nextflow, plugin pack.

**Contig**{#contig}. A contiguous stretch of assembled sequence emitted by an assembler, representing the longest path through the assembly graph that the algorithm could resolve unambiguously; one assembly bundle holds many contigs, ranked by length in the assembly viewport. See also: assembly bundle, N50.

**Contig (in a reference)**{#contig-reference}. One named sequence in a multi-record FASTA; in `.lungfishref` bundles the contig list comes from FASTA headers and matches the BAM, VCF, and GFF3 contig fields.

**Coordinate**{#coordinate}. A 1-based position on a reference, named as `chrom:position` (for example, `MN908947.3:21618`). Lungfish presents 1-based inclusive coordinates to the user everywhere; underlying file formats may use 0-based half-open (BED) or 1-based inclusive (VCF, GFF3, SAM/BAM displayed). See also: chromosome.

**Coverage**{#coverage}. The number of reads that align across a given reference position; used interchangeably with depth in this manual. See also: pileup.

**Coverage breadth**{#coverage-breadth}. The fraction of reference positions covered by at least one read, reported per contig in a mapping run's `mapping-result.json` and distinct from depth, which counts how many reads sit over a position rather than whether any do. See also: coverage, mapping.

**CSI (coordinate-sorted index)**{#csi}. The alternative BAM index format for a reference sequence longer than the 512-megabase limit a BAI index can address, serving the same purpose of letting a viewer jump straight to a chosen position. Lungfish Genome Explorer writes BAI for the BAMs it produces and reads a CSI that arrives beside an imported BAM. See also: BAI, BAM.

**Ct (cycle threshold)**{#ct}. The qPCR cycle number at which a sample's amplification signal crosses the detection threshold; a lower Ct means more starting template, so for a viral diagnostic a low Ct predicts a higher viral fraction in the sequencing reads and a smaller host-removal rate.

**cutadapt**{#cutadapt}. A program that finds a short known sequence inside a read and either trims it away or uses it to sort the read, tolerating a set fraction of mismatched bases so it still matches when the sequencing was imperfect, and the default engine behind demultiplexing in Lungfish Genome Explorer. See also: barcode, demultiplex, adapter.

**CZ-ID**{#cz-id}. A hosted metagenomics service used through a web browser, whose exported taxon report Lungfish Genome Explorer imports as a taxonomy result and stores as a `.lungfishtax` bundle under the project's `Classifications/` folder, since LGE reads a CZ-ID result but never runs one. See also: read classification, Import Center, taxon.

## D

**Deacon**{#deacon}. A host-depletion program that matches a read's minimizers against a prebuilt index and drops the read when enough of them hit, used in Lungfish Genome Explorer for both human read removal and ribosomal RNA removal. See also: host depletion, minimizer, ribosomal RNA.

**Demultiplex**{#demultiplex}. Separating a mixed sequencing run into per-sample read sets by their barcode. See also: barcode, barcode kit.

**Depth**{#depth}. Synonym for coverage in this manual. The number of reads stacked at one reference position. See also: coverage.

**Docker**{#docker}. The container software that nf-core pipelines run their tool steps inside, installed on a Mac as the separate Docker Desktop application rather than through the Lungfish Genome Explorer Plugin Manager, and the only execution profile the Viral Recon wizard will accept. See also: container, nf-core, Nextflow.

**Download Center**{#download-center}. An older name for the Operations Panel that survives in some documentation and in the source as an alias. Downloads from NCBI and the SRA report as rows in the Operations Panel, which is the place to look when a download does not appear where you expected it. See also: Operations Panel, SRA.

**Duplex read**{#duplex-read}. An Oxford Nanopore read produced by basecalling both strands of the same DNA molecule and reconciling them into a single high-accuracy consensus; duplex Q30+ approximates Illumina-grade accuracy and is the basis for modern Medaka-duplex models. See also: simplex read, basecaller.

**Duplicate rate**{#duplicate-rate}. The share of an alignment's records that duplicate marking flagged as copies of another record, read as a judgement on the library rather than on the sequencing, so a few percent on a PCR-free shotgun library is healthy while a fifth or more means the library was amplified from too few distinct starting molecules. See also: PCR duplicate, mark duplicates, library prep.

## E

**E-value**{#e-value}. The number of database alignments of equal or better score expected by chance for a given query length and database size; in BLAST results, smaller is better, with values at or below `1e-30` indicating an essentially unmistakable match for a typical viral read. See also: BLAST, percent identity.

**Edit distance**{#edit-distance}. The number of single-base substitutions, insertions, and deletions separating an aligned read from the reference stretch it sits on, written into the read's optional `NM` tag by the mapper, so a read with `NM` of 0 matches the reference perfectly and is what the zero-mismatch alignment filter keeps. See also: BAM, percent identity, alignment.

**ENA (European Nucleotide Archive)**{#ena}. The European mirror of the SRA, hosted at EMBL-EBI; one of three INSDC partners (with NCBI SRA and DDBJ) that share deposited sequencing data. Lungfish downloads SRA runs from ENA first because ENA serves pre-converted FASTQs directly, and falls back to the NCBI SRA Toolkit when ENA is unavailable. See also: SRA.

**EsViritu**{#esviritu}. A read classifier built around a curated collection of viral genomes, which reports not only how many reads matched each virus but how much of that virus's genome those reads covered, shipped in Lungfish Genome Explorer's `metagenomics` plugin pack and run from **Tools > Classification > EsViritu...**. See also: read classification, coverage breadth, plugin pack.

**Exon**{#exon}. One of the stretches of a gene that survives splicing and contributes to the mature transcript, so a protein-coding sequence split across three exons is written in a GenBank record as a `join()` of three ranges. See also: CDS, GFF.

**Extraction**{#extraction}. A bundle pulled out of a larger dataset by a Lungfish operation, either a chosen set of reads taken from a FASTQ or BAM or a chosen stretch of a reference sequence, written into the project's `Extractions/` folder with its own provenance sidecar. See also: bundle, project, provenance sidecar.

## F

**FAI (FASTA index)**{#fai}. A small text index file (typically `<sequence>.fasta.fai`) produced by `samtools faidx` that lets tools jump to a specific position in a FASTA without reading the whole file; required for variant calling and many other reference-keyed operations. See also: FASTA.

**FASTA**{#fasta}. A plain-text format for nucleotide or protein sequences, with each record introduced by a `>` header line followed by sequence lines containing the bases. Lungfish accepts plain FASTA, multi-record FASTA, and bgzipped FASTA at every reference picker. See also: FAI, FASTQ.

**FASTQ**{#fastq}. A plain-text format for sequencing reads, with each read taking exactly four lines: a `@`-prefixed header, the read sequence, a `+` separator, and a same-length quality string in the standard ASCII offset 33 encoding. The input format for every workflow that starts from raw sequencing data. See also: paired-end, Phred score.

**fastp**{#fastp}. A fast read-preprocessing program that trims low-quality bases with a sliding window, detects and removes adapters, and trims a fixed number of bases from either read end, and that backs four of the six Trimming and Filtering operations in Lungfish Genome Explorer. See also: adapter, sliding-window trimming, Phred score.

**FILTER (in a VCF)**{#filter}. The seventh standard VCF column, holding `PASS` where the row cleared every filter the caller applied, a semicolon-separated list of the named filter flags it failed, or a bare `.` where no filter was applied at all. Flag names are caller-specific and are declared in the file's own header, so LoFreq writes names such as `min_dp_10` and `sb_fdr` while iVar writes `ft` and `bq`. See also: VCF, INFO, FORMAT.

**Filter profile**{#filter-profile}. A named set of smart-filter tokens applied together to a variant track, either one of the four built into Lungfish (Clinical, Research, QC, High Confidence) or a combination the user assembles and saves per bundle. See also: smart-filter token, VCF.

**FLAG (in a BAM)**{#flag}. A bitwise integer field in each BAM row encoding facts about the read in twelve canonical bits: paired, properly paired, unmapped, mate unmapped, reverse strand, mate reverse strand, first of pair, second of pair, secondary alignment, low quality, duplicate, supplementary alignment. The decoded value `99` is the sum of bits 1+2+32+64. See also: BAM, supplementary alignment.

**FORMAT (in a VCF)**{#format}. The ninth VCF column, declaring a colon-separated list of keys that describe the per-sample payload columns following it, such as the `GT:PL:AD` that bcftools writes. The column is optional, and LoFreq output has no FORMAT and no sample column at all. See also: VCF, INFO.

**Flagstat**{#flagstat}. The per-category tally `samtools flagstat` produces by decoding the FLAG field of every record in a BAM, giving counts for total, primary, secondary, supplementary, mapped, properly paired, and singleton records, and shown in the alignment Inspector as a collapsed Flag Statistics list. See also: FLAG, BAM, primary alignment.

**Fluidigm sample barcode**{#fluidigm-sample-barcode}. The sample-identifying sequence carried between the fixed CS1 and CS2 primer sequences in a library built with Fluidigm Access Array primers, which Lungfish Genome Explorer reads to split one bulk Oxford Nanopore bundle into per-sample bundles of the insert lying between those two primers. See also: barcode, demultiplex, amplicon.

**Freyja**{#freyja}. A tool that estimates the relative abundance of each viral lineage in a mixed sample (typically wastewater) by demixing the sample's variant and depth profiles against known lineage definitions, run in Lungfish through `lungfish freyja demix`. See also: lineage, consensus FASTA.

## G

**Gap**{#gap}. The `-` character an aligner writes into one row of a multiple sequence alignment at a column where that sequence has no residue, standing for an insertion in the other sequences or a deletion in this one, and letting rows of unequal length share a rectangular grid. See also: alignment column, MSA.

**GC content**{#gc-content}. The percentage of bases in a sequence or a read set that are G or C rather than A or T, reported by Lungfish as one of the nine FASTQ summary cards, and a property of the source organism rather than of the sequencing run, so a figure far from the expected value usually means another species is present. See also: read, quality control.

**Genetic code**{#genetic-code}. The mapping from codons to amino acids; Lungfish lets you pick the code (for example the vertebrate mitochondrial code) when translating a sequence. See also: codon, reading frame.

**GenomicsDB**{#genomicsdb}. GATK's on-disk multi-sample variant store that scales joint genotyping to large cohorts better than a single combined GVCF; Lungfish builds one with `GenomicsDBImport` when a cohort exceeds 50 samples. See also: GVCF, joint genotyping.

**Genotype**{#genotype}. A compact notation for which alleles are observed at a variant position, written diploid-style as `0/1` (heterozygous) or `1/1` (homozygous alternate), where `0` is the reference allele and `1` the first alternate. The Lungfish Genome Explorer iVar pipeline writes the bare haploid `1` instead, which is the honest notation for an organism carrying one genome copy. See also: heterozygous, homozygous, FORMAT.

**Genotype matrix**{#genotype-matrix}. The Lungfish dashboard that presents genotype calls as allele-target rows by sample columns, with a haplotype tape, cohort summary, and per-sample evidence; it is not one of the five genomic viewport classes. See also: haplotype, cohort.

**GFF (General Feature Format)**{#gff}. A tab-separated table format for genomic features (genes, CDS, mature peptides, regulatory elements). GFF3 is the current spec; Lungfish accepts GFF3 paired with a FASTA at bundle creation. See also: FASTA, reference bundle.

**GVCF (genomic VCF)**{#gvcf}. A VCF variant that records, at every position rather than only at variant sites, the confidence that the sample matches the reference, so per-sample GVCFs can later be combined and genotyped together; the form GATK HaplotypeCaller emits by default in Lungfish. See also: VCF, joint genotyping, GenomicsDB.

## H

**Hamming distance**{#hamming-distance}. The number of positions at which two sequences of the same length differ, used by bbduk as the mismatch tolerance when deciding whether a stretch of a read matches a supplied primer or contaminant sequence. See also: bbduk, k-mer, primer trim.

**Haplogroup**{#haplogroup}. A branch of the human maternal family tree, defined by the set of mitochondrial positions its members share and named with a letter and digits such as H or U5b, so a mitochondrial call set that recovers a coherent haplogroup marker set is evidence the calling worked. See also: mitochondrial genome, SNV.

**Haplotype**{#haplotype}. A set of alleles across linked loci that tend to travel together; in Lungfish MHC genotyping these are the named M1 to M7 families spanning the MHC-A, MHC-E, MHC-B, MHC-DR, MHC-DQ, and MHC-DP loci. See also: allele, MHC.

**Heterozygous**{#heterozygous}. Carrying two different alleles at one position, one on each copy of a chromosome, written `0/1` in a VCF genotype field. See also: homozygous, genotype.

**Homologous**{#homologous}. Descended from the same position in a shared ancestral sequence, which is what a column of a multiple sequence alignment claims about the residues stacked in it, and which is an inference from similarity rather than something the data states directly. See also: alignment column, MSA.

**Homopolymer**{#homopolymer}. A run of the same base repeated, such as `AAAAAA`, which nanopore basecalling resolves poorly because the electrical signal barely changes as each identical base passes through the pore, making homopolymer length the single largest source of insertion and deletion errors in Oxford Nanopore reads. See also: basecaller, indel, Medaka.

**Homozygous**{#homozygous}. Carrying the same allele on both copies of a chromosome at one position, written `0/0` for the reference allele and `1/1` for the alternate. See also: heterozygous, genotype.

## I

**Host depletion**{#host-depletion}. The removal of reads that came from the organism the sample was taken from rather than from the organism being studied, done before analysis both to save work on reads no one will look at and to keep a patient's own genome out of a shared dataset. See also: Deacon, decontamination.

**Immunogenetics**{#immunogenetics}. The study of genetic variation in immune-system loci such as the MHC; the domain of Lungfish's amplicon genotyping feature. See also: MHC.

**Import Center**{#import-center}. The tabbed import window opened with **File > Import Center...** (`Cmd-Shift-I`), holding one tab per data kind (Sequencing Reads, Alignments, Variants, Classification Results, Reference Sequences, Application Exports) and one card per import inside each tab, every card a drop target. See also: reference bundle, provenance.

**INFO (in a VCF)**{#info}. The eighth standard VCF column, holding semicolon-separated `KEY=VALUE` pairs of per-row metadata such as depth (`DP`), allele frequency (`AF`), strand bias (`SB`), and per-allele depths (`AD`). See also: VCF, FILTER, FORMAT.

**INSDC (International Nucleotide Sequence Database Collaboration)**{#insdc}. The three-way partnership of NCBI (USA), EMBL-EBI (Europe), and DDBJ (Japan) that mirrors deposited nucleotide sequences and assigns a single globally-unique accession to each record; ENA, NCBI SRA, and DDBJ Sequence Read Archive are the SRA tier of this partnership. See also: ENA, SRA.

**Indel**{#indel}. A variant that inserts bases the reference lacks or deletes bases the reference has, rather than substituting one base for another, written in a VCF as a REF and ALT of different lengths. Indels are harder to call than substitutions because reads spanning one can often be aligned in more than one equally good way, and some callers report none at all by default. See also: SNV, REF and ALT, variant-caller.

**Insert size**{#insert-size}. The length of the original DNA fragment that a paired-end read pair came from, measured end to end including both reads; when the insert is shorter than twice the read length the two mates overlap and can be merged. See also: paired-end, read length.

**Inspector**{#inspector}. The right-hand pane of a Lungfish project window that shows context-sensitive metadata and analysis actions for whatever is selected in the sidebar or main viewport. Toggle with `Cmd-Opt-I`. See also: sidebar, project.

**Internal node**{#internal-node}. Any point on a phylogenetic tree where branches meet, standing for an inferred common ancestor that was never sequenced and no longer exists; a tree of five tips can hold at most three of them. See also: tip, clade, topology.

**Interleaved FASTQ**{#interleaved-fastq}. A single FASTQ file holding a paired-end run with the two mates of each fragment written as consecutive records, forward then reverse, rather than split across an R1 and an R2 file. Lungfish stores a paired-end sample inside its bundle as one interleaved file, and offers Interleave and Deinterleave as explicit operations on files outside a bundle. See also: paired-end, FASTQ.

**IQ-TREE**{#iqtree}. A maximum-likelihood phylogenetic inference program with a built-in ModelFinder step and ultrafast bootstrap support estimation, used by Lungfish to produce `.lungfishtree` bundles from MSA bundles. See also: MSA, phylogram, support value.

**IUPAC ambiguity code**{#iupac-ambiguity-code}. A single letter standing for two or more possible bases at one position, defined by the International Union of Pure and Applied Chemistry so that uncertainty can be written inside a sequence rather than alongside it; `R` means A or G, `Y` means C or T, `M` means A or C, `K` means G or T, `S` means C or G, `W` means A or T, and `N` means any base at all. See also: consensus sequence, consensus FASTA, pileup.

**iVar**{#ivar}. A toolkit written for amplicon sequencing data that soft-clips primer bases out of an aligned BAM using a primer scheme's BED coordinates and can then call variants from the trimmed result, shipped inside Lungfish Genome Explorer's Variant Calling pack. See also: primer trim, primer scheme, soft-clip, variant-caller.

## J

**Joint genotyping**{#joint-genotyping}. The GATK step that calls genotypes across a whole cohort at once by combining per-sample GVCFs and running `GenotypeGVCFs`, rather than genotyping each sample in isolation; run in Lungfish through `lungfish gatk joint-genotype`. See also: GVCF, GenomicsDB.

## K

**k-mer**{#k-mer}. A substring of exactly k bases taken from a longer sequence, the unit several tools match on because comparing short fixed-length words is far faster than comparing whole sequences. bbduk spots a primer in a read by looking for the primer's k-mers. See also: bbduk, minimizer, Hamming distance.

**Kraken 2**{#kraken2}. A read classifier that assigns each read to a taxon by matching the read's minimizers against a database of reference genomes, chosen for breadth rather than depth and run in Lungfish Genome Explorer from **Tools > Classification > Kraken2...**, usually with Bracken estimating abundances from its assignments afterwards. See also: read classification, minimizer, lowest common ancestor, taxon.

**Kreport**{#kreport}. The six-column summary file Kraken 2 writes beside its per-read output, holding one row per taxon with the percentage of reads under it, its clade count, its direct count, a one-letter rank code, its numeric taxonomy identifier, and its name indented by depth. It is the file the taxonomy viewport reads, and the file `lungfish-cli import kraken2` takes when you bring in a classification produced elsewhere. See also: Kraken 2, clade count, taxon, taxonomic rank.

## L

**LabKey**{#labkey}. A laboratory data management platform; Lungfish can export genotype results as LabKey-ready CSV files.

**Library prep**{#library-prep}. The bench procedure that turns extracted nucleic acid into a form a sequencing instrument can read, and the step that decides whether reads land at random positions (shotgun), at designed primer coordinates (amplicon), or on probe-selected regions (target enrichment). See also: amplicon, shotgun, target enrichment.

**Library layout**{#library-layout}. The archive field recording whether a sequencing run read each fragment from one end or from both, reported as SINGLE or PAIRED, which is how an SRA search can be restricted to runs whose reads come in mate pairs. See also: paired-end, single-end, SRA.

**Library strategy**{#library-strategy}. The archive field recording what a sequencing library was built to do, with values such as WGS for whole-genome shotgun, AMPLICON for targeted PCR product, WXS for whole-exome capture, and RNA-Seq for transcript sequencing. See also: amplicon, shotgun, SRA.

**LoFreq**{#lofreq}. A variant caller that builds an error model from the base and mapping qualities of the reads and reports a position when the alternate reads are more numerous than that error model alone would produce, which lets it find variants present in a small fraction of the reads without assuming any fixed number of genome copies. Its default output carries no genotype or sample column and reports no indels unless indel calling is switched on. See also: variant-caller, allele frequency, INFO.

**Lineage**{#lineage}. A named subgroup within a viral species, defined by a characteristic set of variants and assigned by a domain-specific tool (Pangolin for SARS-CoV-2, Nextclade for many viruses). LGE assigns lineages only through the Viral Recon pipeline, which runs Pangolin and Nextclade on the consensus it builds. Its other consensus paths produce FASTAs that downstream tools call lineages from. See also: consensus FASTA.

**Lowest common ancestor**{#lowest-common-ancestor}. The most specific taxon that every organism matching a read belongs to, which a classifier reports instead of guessing when a read's sequence fits several relatives equally well, so a read shared across a whole genus is labelled with the genus rather than with one of its species. See also: taxon, taxonomic rank, read classification.

## M

**MAFFT**{#mafft}. A multiple sequence alignment program that auto-selects an algorithm by input size and is the default aligner Lungfish runs when producing a `.lungfishmsa` bundle. See also: MSA.

**Mapper**{#mapper}. A program that places sequencing reads onto a reference genome and emits an alignment file (BAM); Lungfish ships minimap2, BWA-MEM2, Bowtie2, and BBMap. See also: alignment, mapping.

**Mapping**{#mapping}. The act of finding, for each read, the reference position where it best fits and recording the alignment in a BAM. See also: alignment, mapper.

**Materialization**{#materialization}. The step that rebuilds a virtual bundle's full read file from its stored manifest, run automatically as the first stage of any operation that needs the actual reads and cleared away when that operation ends, or performed deliberately with `lungfish-cli fastq materialize` when a program outside Lungfish Genome Explorer needs a plain FASTQ. See also: virtual bundle, bundle.

**Managed environment**{#managed-environment}. The private folder conda builds for one tool under `~/.lungfish/conda`, holding that tool and the libraries it depends on, so two tools needing different versions of the same library never collide, with the Plugin Manager's Installed tab listing one row per managed environment. See also: conda, plugin pack.

**Mapping preset**{#mapping-preset}. A named bundle of mapper settings tuned for one kind of input, chosen alongside the mapper itself, where minimap2 offers `sr` for short reads, `map-ont`, `map-hifi`, and `map-pb` for long reads, `asm5` for assembled contigs, and `splice` for spliced alignment, while BBMap offers a standard and a PacBio mode. See also: mapper, mapping.

**MAPQ (mapping quality)**{#mapq}. A per-read confidence score in each BAM row, encoding how unambiguously the mapper placed the read at the recorded position; 0 means no confidence (the read fits multiple places equally well), 60 is the maximum for most mappers and means the placement is well above the second-best alternative. See also: BAM, mapper.

**Mark duplicates**{#mark-duplicates}. The step that finds BAM rows sharing a start and end position, which are usually PCR copies of one original fragment, and flags the extras so a variant caller counts them once, run in Lungfish as `samtools markdup` through `lungfish-cli bam markdup`. The step is inappropriate for amplicon data, where every fragment is designed to start at the same place. See also: BAM, FLAG.

**Maximum likelihood**{#maximum-likelihood}. The method IQ-TREE uses to choose a phylogenetic tree, which scores every candidate tree by how probable it makes the observed alignment columns under an assumed substitution model and keeps the highest-scoring one. See also: IQ-TREE, substitution model, topology.

**Medaka**{#medaka}. Oxford Nanopore's own variant caller and consensus tool, which scores reads against a neural-network model named for the pore chemistry and basecaller version that produced them, run in Lungfish Genome Explorer from the Call Variants dialog against a FASTQ rebuilt from the chosen alignment rather than against the BAM. See also: Clair3, basecaller, variant-caller.

**Metabarcoding**{#metabarcoding}. Identifying which species are present in a mixed sample by matching a short marker amplicon (such as 12S) against a reference of known sequences. See also: 12S.

**Metagenomics**{#metagenomics}. The study of all the nucleic acid present in a mixed sample at once, rather than of one cultured organism, which is the setting read classification was built for and the reason its tools ask for large reference databases and a great deal of memory. See also: read classification, metabarcoding, shotgun.

**Methods export**{#methods-export}. The Lungfish provenance export that emits a plain-prose Markdown paragraph naming each tool and its resolved version in the order the workflow ran them, suitable for pasting into a paper's methods section. See also: provenance sidecar.

**MHC (Major Histocompatibility Complex)**{#mhc}. A gene-dense immune region genotyped here by amplicon sequencing, using the Mauritian cynomolgus macaque as the running example. See also: haplotype, immunogenetics.

**Micromamba**{#micromamba}. A small standalone bootstrap that speaks the conda protocol without requiring a full Anaconda installation, used by Lungfish as the engine for plugin pack installs. See also: conda, plugin pack.

**Mitochondrial genome**{#mitochondrial-genome}. The small circular DNA molecule carried inside the mitochondrion, the compartment that supplies a cell's chemical energy, separate from the nuclear chromosomes and present in many copies per cell, the human one being the 16,569-base record `NC_012920.1` known as the revised Cambridge Reference Sequence. See also: reference genome, accession.

**Minimizer**{#minimizer}. The smallest k-mer within a sliding window of a sequence, picked as a compact fingerprint so a tool can match reads quickly without comparing every base; Kraken2 classifies on minimizers and Deacon counts minimizer hits to flag host reads. See also: Kraken2, Deacon.

**MinKNOW**{#minknow}. The control software that runs an Oxford Nanopore sequencer, calls bases as the run proceeds, and writes the reads out as numbered FASTQ chunks under a `fastq_pass` folder, placing each barcode's reads in its own subfolder when the library was barcoded. See also: basecaller, barcode, unclassified reads.

**mosdepth**{#mosdepth}. A fast coverage-depth calculator that reports how many reads sit over each position of a genome, run inside the nf-core/viralrecon pipeline to produce both a whole-genome depth table and a per-amplicon one, the second of which is what reveals amplicon dropout. See also: coverage, depth, amplicon dropout.

**mpileup**{#mpileup}. The samtools and bcftools subcommand that walks a reference position by position and reports, for each one, the stack of read bases covering it together with their qualities, which is the raw summary a variant caller then judges. Its flags change what the caller sees, so the depth cap and base-quality floor a pileup is built with are part of why two callers on one alignment disagree. See also: pileup, bcftools, variant-caller.

**MSA (Multiple Sequence Alignment)**{#msa}. A rectangular arrangement of two or more related sequences in which each column represents an inferred homologous position, with `-` gap characters padding insertions; in Lungfish stored as a `.lungfishmsa` bundle. See also: MAFFT.

**MultiQC**{#multiqc}. A reporting tool that gathers the quality output of every step of a pipeline run into one browsable HTML page, so a reader checks a whole run in one place instead of opening a report per tool, and the nf-core/viralrecon run writes one that Lungfish Genome Explorer catalogues as Full Run Report. See also: nf-core, FastQC.

## N

**N50**{#n50}. A summary statistic for a set of assembled contigs: the length such that contigs of at least that length together hold half of the assembly's total bases; a higher N50 indicates a less fragmented assembly. See also: contig, assembly bundle.

**NAO-MGS**{#nao-mgs}. A wastewater metagenomic surveillance pipeline from SecureBio that runs externally and whose `virus_hits_final.tsv(.gz)` output Lungfish imports (it does not run the pipeline) through `lungfish nao-mgs import` or the Import Center, presenting one run's viral taxa in a sortable table with a taxon detail pane and BLAST verification workflow. See also: BLAST.

**Newick**{#newick}. A compact parenthesised text format for phylogenetic trees, with branch lengths after colons and optional support values at internal nodes; the lingua franca for moving trees between FigTree, iTOL, ete3, and Lungfish. See also: phylogram.

**Nextflow**{#nextflow}. A language and runner for describing an analysis as a set of steps and the files that flow between them, which then executes those steps in the right order and inside containers, shipped with the Required Setup pack and used by Lungfish Genome Explorer to run the nf-core/viralrecon pipeline. See also: nf-core, container, run bundle.

**nf-core**{#nf-core}. A community that curates, versions, and tests openly published Nextflow pipelines to a common standard, so a pipeline named by release runs the same steps for everyone who runs that release, and Lungfish Genome Explorer supports one of them, nf-core/viralrecon, pinned at release 3.0.0. See also: Nextflow, container.

**NVD (Novel Virus Diagnostics)**{#nvd}. An external Snakemake wastewater-surveillance pipeline that assembles reads into contigs and BLASTs each contig, whose `*_blast_concatenated.csv(.gz)` output Lungfish imports (it does not run the pipeline) through `lungfish nvd import` or the Import Center and presents as a contig-keyed browser of best and secondary BLAST hits. See also: contig, BLAST.

## O

**Open reading frame**{#open-reading-frame}. A stretch of codons from a start to a stop with no internal stop, a candidate protein-coding region Lungfish can auto-detect. See also: reading frame, CDS.

**Operations Panel**{#operations-panel}. A separate Lungfish window that lists every long-running operation of the current session with its state, elapsed time, command line, and log, and that offers Clear Completed and a per-row context menu. Open it with **Operations > Show Operations Panel** (`Cmd-Shift-P`). The durable audit trail lives in the provenance sidecars rather than in the panel. See also: provenance, project.

**Optical duplicate**{#optical-duplicate}. A read counted twice because one cluster on the flowcell was read as two neighbouring clusters during imaging, rather than because the fragment was copied during amplification, which is why it is recognised by how close two clusters sit rather than by sequence alone. See also: PCR duplicate, clumpify.

**ORF (open reading frame)**{#orf}. A stretch of sequence running from a start codon to an in-frame stop codon without interruption, so it could in principle encode a protein; Lungfish finds ORFs and stores them as an annotation track, but ORF length is only a weak proxy for a real gene. See also: codon.

**Orient Reads**{#orient-reads}. A Lungfish operation that aligns ONT reads against a reference and flips reverse-strand reads so every read in the bundle ends up in the same orientation, useful for amplicon protocols and consensus building. See also: basecaller, simplex read.

**Outgroup**{#outgroup}. A sequence included in a phylogenetic analysis because you are confident it falls outside the group under study, used to place the root so the rest of the tree can be read as a sequence of descent. See also: rooting, topology, clade.

## P

**Paired-end**{#paired-end}. A sequencing protocol that reads each DNA fragment from both ends, producing two reads per fragment; the two halves of a pair travel as separate FASTQ files with `_1`/`_2` or `_R1`/`_R2` suffixes. See also: FASTQ, single-end.

**PCR duplicate**{#pcr-duplicate}. A read that is a copy of another read because both came from the same original DNA fragment amplified during library preparation, so the two carry one observation between them rather than two. Amplicon protocols produce identical read starts by design, so duplicates there are expected rather than artifacts. See also: optical duplicate, mark duplicates, clumpify.

**Pathoplexus**{#pathoplexus}. An open pathogen-genome database Lungfish can search and import reference sequences from.

**pbAA**{#pbaa}. A read-clustering tool that derives high-accuracy amplicon consensus sequences, one of the clustering options for full-length ONT MHC genotyping. See also: clustering, savONT.

**p-distance**{#p-distance}. The simplest genetic distance between two aligned sequences: the proportion of positions at which they differ, with no model correction. One of the distance models Lungfish's `msa distance` can compute. See also: MSA.

**Phred score**{#phred-score}. A logarithmic per-base quality value defined as `Q = -10 * log10(P)` where P is the error probability; Q20 = 1% error, Q30 = 0.1% error, Q40 = 0.01% error. Encoded in FASTQ files as ASCII characters offset by 33 (so `!` = Q0, `F` = Q37). See also: FASTQ.

**PhiX**{#phix}. The small bacteriophage genome Illumina spikes into a sequencing run as a control, which is never part of the sample's biology and so is a standard thing to filter out, and which Lungfish Genome Explorer ships as the default reference for contaminant filtering. See also: bbduk, decontamination.

**Phylogram**{#phylogram}. A phylogenetic tree drawn so that branch length is proportional to the inferred amount of evolutionary change (substitutions per site); the default tree-viewport layout in Lungfish. See also: clade, IQ-TREE.

**Percent identity**{#percent-identity}. In a BLAST or other pairwise alignment, the fraction of aligned positions where the query and the subject sequence agree, calculated only over the aligned region; read together with query coverage to gauge how much of the read aligned and how well. See also: BLAST, query coverage.

**Pileup**{#pileup}. The column of bases observed at one reference position across every read that covers it, together with their qualities and strands; the unit of evidence a variant caller weighs at each position. See also: coverage, variant-caller.

**Ploidy**{#ploidy}. The number of copies of each chromosome an organism carries, which is two for a human and one for a virus or a bacterium, and which decides what genotypes a caller is allowed to propose at a position. A caller assuming two copies will force a viral sample into `0/1` and `1/1` genotypes that mean nothing, which is why a haploid genome is usually called with an explicit ploidy setting. See also: genotype, heterozygous, variant-caller.

**Plugin pack**{#plugin-pack}. A themed group of related bioinformatics tools that Lungfish installs on demand into per-tool conda environments, named for the workflow it supports (for example, `read-mapping`, `variant-calling`, `assembly`). See also: conda, micromamba.

**Post-install hook**{#post-install-hook}. A follow-up command a plugin pack declares for itself and Lungfish runs after the pack's tools are installed, such as downloading the lineage data a surveillance tool needs, with the count of hooks shown on the pack's card in the Plugin Manager. See also: plugin pack.

**Primary alignment**{#primary-alignment}. The one record a mapper designates as a read's real placement, so counting primary alignments counts reads rather than records and gives a total that matches the input FASTQ even when the mapper also emitted secondary or supplementary rows for the same reads. See also: secondary alignment, supplementary alignment, flagstat.

**Primer**{#primer}. A short oligonucleotide, typically 18 to 30 bases, that binds a specific position on a target genome and primes DNA synthesis from that position; the building block of every amplicon protocol. See also: amplicon, primer scheme.

**Primer scheme**{#primer-scheme}. The set of primer coordinate pairs that define an amplicon protocol, listing where each forward and reverse primer binds on the reference. In Lungfish, a primer scheme is packaged as a `.lungfishprimers` bundle that carries the BED coordinates, a manifest naming the protocol and the reference accessions it was designed against, an optional FASTA of the primer sequences, and provenance. See also: primer, BED, primer trim.

**Primer trim**{#primer-trim}. The step that removes primer-derived bases from the ends of aligned reads in amplicon data, so those bases do not contaminate variant calls. In Lungfish the trim runs as a BAM-level operation using `ivar trim` against a selected primer scheme. See also: amplicon, primer scheme.

**Project**{#project}. A `.lungfish` directory bundle that holds every input, output, bundle, and provenance record for one Lungfish analysis, with a top-level layout of `Imports/`, `Downloads/`, `Reference Sequences/`, `Primer Schemes/`, `Extractions/`, `Haplotype Definitions/`, and `Analyses/`, plus a hidden `.project.db` catalog and a `metadata.json`. Only the app creates the project store, so a folder built by `lungfish-cli` alone opens read only. See also: bundle, sidebar, project lock.

**Project lock**{#project-lock}. The record Lungfish writes inside a project bundle naming the user, host, process, app version, and time of whoever currently holds it, so the app and the CLI can coordinate access to a project on shared storage. A lock left behind by a crashed process is called stale and is cleared through an explicit recovery that archives the old record. See also: project.

**Properly paired**{#properly-paired}. The state of a paired-end read whose mate was placed on the same reference sequence at the separation and orientation the library preparation implies, marked by FLAG bit 2 and counted as its own row in a flagstat report, so a fraction well below the mapped fraction points at a library or reference problem rather than at poor sequencing. See also: FLAG, paired-end, flagstat.

**Provenance**{#provenance}. The record Lungfish keeps alongside every download and every operation describing where a file came from or how it was produced, including source URL or accession, exact tool version, full command line, input checksums, and output checksums. See also: Operations Panel.

**Provenance sidecar**{#provenance-sidecar}. The JSON file Lungfish writes alongside every output (or into a bundle's `provenance/` subdirectory), recording the workflow name, resolved command, input and output checksums, runtime identity, and per-step exit status for one operation. See also: provenance, methods export.

## Q

**Quality binning**{#quality-binning}. The lossy compression step that rounds each base's Phred score to one of a small set of values before the reads are stored, offered by Lungfish at import as Illumina 4-level, 8-level, or None; Illumina instruments from the NovaSeq onward already report binned scores in hardware, so binning such a run discards little that was not already lost. See also: Phred score, FASTQ.

**Quality control**{#quality-control}. The step of judging whether a set of reads is fit to analyse before anything is computed from it, which in Lungfish has no separate screen and is read instead from the nine summary cards and three sparkline charts the FASTQ viewport shows for every read bundle. See also: Phred score, sparkline, GC content.

**Query coverage**{#query-coverage}. In a BLAST result, the fraction of the query sequence that participated in the alignment to the subject; a high percent identity over only a fraction of the read is much weaker evidence than a moderate identity over most of the read. See also: BLAST, percent identity.

## R

**Read**{#read}. One fragment of DNA reported by a sequencing instrument, stored as a string of bases beside an equal-length string of per-base quality scores, and written as one four-line record in a FASTQ file. See also: FASTQ, read length, Phred score.

**Read classification**{#read-classification}. Assigning each read in a sequencing run to the organism it most likely came from, by comparing the read against a reference database of known genomes, which turns a FASTQ into a census of the taxa present and the share of reads at each one. See also: taxon, taxonomic rank, lowest common ancestor, metagenomics.

**Read clumping**{#read-clumping}. The reordering of a read file so that reads sharing sequence content sit next to each other, which lets a general-purpose compressor find far more repetition and shrink the stored file; Lungfish applies it at import as the "Optimize storage" option, using BBTools clumpify or Trim Galore, and the reordering means the stored bundle no longer matches the source file's read order. See also: FASTQ.

**Read group**{#read-group}. A labelled block written into a BAM header as an `@RG` line, naming the identifier, sample, library, sequencing platform, and platform unit a set of reads came from, which Lungfish Genome Explorer fills in for every mapping run so that tools grouping reads by sample, such as joint variant callers, can do so. See also: BAM, mapping.

**Read length**{#read-length}. The number of bases in a sequencing read; Illumina reads are typically 75-300 bp (fixed per run), Oxford Nanopore reads range from 1 kb to 100 kb (variable per run with mean 5-15 kb), PacBio HiFi reads are 10-25 kb. See also: FASTQ.

**Read identifier**{#read-identifier}. The name a sequencer gives one read, written on the FASTQ record's first line after the `@` character and running up to the first space, which for an Illumina run encodes the instrument, run, flowcell, lane, tile, and position of the cluster that produced it. See also: FASTQ, read length.

**Read merging**{#read-merging}. Joining the two mates of a paired-end read into one longer sequence, possible only when the DNA fragment was shorter than the two reads combined so that the mates overlap in the middle, where the doubly measured bases also let the merger correct disagreements between the two reads. See also: paired-end, insert size, interleaved FASTQ.

**Reading frame**{#reading-frame}. One of the three ways to divide a nucleotide sequence into codons on a given strand, selected when translating a sequence to protein. See also: genetic code, codon.

**Regular expression**{#regular-expression}. A compact pattern language for describing text to search for rather than spelling out the exact text, where writing a plain word already means "contains this anywhere" and square brackets such as `[GA]` mean "any one of these characters here". See also: read identifier, sequence motif.

**Reference bundle**{#reference-bundle}. A `.lungfishref` bundle stored under a project's `Reference Sequences/` folder, containing a primary FASTA, an index, optional annotations such as GFF3 or GTF, any tracks attached to that reference (alignments, variants, classifications), and a manifest. See also: bundle, assembly bundle.

**Reference genome**{#reference-genome}. A specific, community-agreed sequence used as the comparison point for samples; for SARS-CoV-2 the standard reference is `MN908947.3` (the Wuhan-Hu-1 isolate). Variants are described relative to a chosen reference, so reference choice affects which variants are reported and at what positions. See also: reference bundle.

**RefSeq**{#refseq}. The curated subset of NCBI's sequence records, holding one reviewed, non-redundant record per sequence rather than every entry submitters deposited, recognisable by accession prefixes such as `NC_`, `NG_`, and `NM_` for records and `GCF_` for assemblies. See also: accession, INSDC, RefSeqGene.

**RefSeqGene**{#refseqgene}. An NCBI RefSeq record covering one gene or gene cluster as a curated slice of a chromosome, given its own coordinate system starting at 1 and its own accession (for example `NG_000007.3` for the human beta-globin cluster), so gene-focused work does not have to carry whole-chromosome coordinates. See also: accession, reference genome.

**REF, ALT**{#ref-alt}. REF is the base or bases present in the reference genome at a variant position; ALT is the base or bases observed in the sample. A one-base REF and one-base ALT describe a SNP; longer REF or ALT describe insertions and deletions.

**Representative reads**{#representative-read}. The coverage-stratified sample of reads (default 20, up to 50) that Lungfish automatically selects from a taxon's assigned reads and submits to NCBI BLAST during verification, chosen to span the taxon's coverage rather than picked one at a time by the user. See also: BLAST.

**Required Setup pack**{#required-setup-pack}. The one plugin pack Lungfish installs as a unit and cannot run without, shown in the Plugin Manager as Third-Party Tools, holding the seventeen everyday utilities the rest of the app assumes are present, among them samtools, bcftools, htslib, fastp, Deacon, seqkit, BBTools, Nextflow, and Snakemake. See also: plugin pack, managed environment.

**Reproducibility**{#reproducibility}. The property that a workflow re-run with the same inputs, the same plugin pack version, and the same Lungfish build produces output that matches the original by checksum (bit-identical) or by content (logically equivalent); the provenance sidecar carries every field needed to verify this. See also: provenance sidecar.

**Reverse complement**{#reverse-complement}. The sequence read from the opposite DNA strand, obtained by reading the bases backwards and swapping each for its pairing partner (A for T, C for G), so reading frames -1, -2, and -3 are the three frames counted along it and Lungfish runs the transformation from **Sequence > Reverse Complement...**. See also: strand, reading frame.

**Ribosomal RNA (rRNA)**{#ribosomal-rna}. The structural RNA of the ribosome, which is by far the most abundant RNA in a cell, so an RNA sequencing library that was not depleted of it returns mostly ribosomal reads and very little of whatever else was in the sample. See also: Deacon, decontamination.

**Rooting**{#rooting}. Choosing which point on a phylogenetic tree stands for the oldest ancestor, which is what turns a statement about who groups with whom into a statement about which lineage came first; IQ-TREE produces unrooted trees, so rooting in Lungfish Genome Explorer is the separate **Re-root Here** step. See also: outgroup, topology, internal node.

**Run accession**{#run-accession}. The identifier naming one pass of one sequencing library through one instrument in a public read archive, written `SRR`, `ERR`, or `DRR` followed by digits according to which INSDC partner took the deposit, and the only accession level that resolves directly to FASTQ files. See also: accession, SRA, INSDC.

**Run bundle**{#run-bundle}. A `.lungfishrun` folder Lungfish Genome Explorer writes before it launches a workflow, recording the pipeline name, the requested release, the executor, the inputs, every parameter, and the outputs that must receive provenance, so the run can be described or repeated without being rerun first. See also: Nextflow, provenance, run record.

**Run record**{#run-record}. The provenance a single Lungfish operation left behind, read in the Inspector's Provenance section as seven blocks (Run Summary, Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON) and stored on disk as one provenance sidecar. See also: provenance sidecar, workflow lineage.

## S

**Sample metadata**{#sample-metadata}. Structured per-sample fields (collection date, source, and so on) imported from a CSV or TSV sheet and attached to samples in a project. See also: BioSample.

**Sample sheet**{#sample-sheet}. A CSV listing one sequencing sample per row with the sample's name and the paths to its read files, used at import to pair reads and name bundles explicitly instead of matching mate suffixes in filenames; Lungfish requires the columns `sample`, `r1`, and `r2`, and carries any further columns through as per-sample metadata. See also: sample metadata, paired-end.

**samtools**{#samtools}. The standard toolkit for reading and writing alignment files, whose subcommands index a BAM, count its records, build a pileup, and call a consensus from one, and which Lungfish Genome Explorer installs and runs for you behind the alignment surfaces rather than asking you to type it. See also: BAM, pileup, consensus sequence, mpileup.

**savONT**{#savont}. A clustering option for full-length ONT MHC amplicons, an alternative to pbAA. See also: clustering, pbAA.

**seqkit**{#seqkit}. A general-purpose toolkit for FASTA and FASTQ manipulation, used in Lungfish Genome Explorer for the read-length filter and for several sequence statistics. See also: FASTQ, read length.

**Secondary alignment**{#secondary-alignment}. An extra record reporting another place a read could plausibly have come from, marked by FLAG bit 256 and produced in quantity by repeated regions, which Lungfish Genome Explorer excludes from a mapping run's BAM by default because the duplicate rows inflate read counts. See also: FLAG, primary alignment, supplementary alignment.

**Sequence motif**{#sequence-motif}. A short run of bases whose presence in a read is the thing being looked for, such as a primer footprint, a restriction site, or a repeat, matched against the read's sequence rather than against its name. See also: read identifier, regular expression, Alu element.

**Sequence viewport**{#sequence-viewport}. The centre pane of a Lungfish project window when a reference bundle is open, drawing one sequence along a horizontal axis as three stacked lanes rather than three separate panes, with the numbered position ruler on top, the bases in the middle, and the annotation features as coloured blocks below. See also: reference bundle, annotation track, Inspector.

**SH-aLRT**{#sh-alrt}. The Shimodaira-Hasegawa approximate likelihood ratio test, a fast branch-support measure IQ-TREE reports as a percentage at each internal node; read alongside bootstrap support, with values at or above 80 treated as reliable. See also: support value, IQ-TREE.

**Shannon entropy**{#shannon-entropy}. A measure of how varied a stretch of sequence is, running from 0 when one base repeats to 1 when all four appear in even proportion, used by the low-complexity filter to score a read window by window so that a repeat inside an otherwise ordinary read is still caught. See also: bbduk, k-mer.

**Shotgun sequencing**{#shotgun}. A library preparation strategy in which sample nucleic acid is fragmented at random and sequenced without targeted amplification; each read lands at an essentially arbitrary position on the genome. Shotgun data does not require primer trimming. See also: amplicon.

**Sidebar**{#sidebar}. The left-hand pane of a Lungfish project window that shows the project's contents as a folder tree, with a search field above it and a synthetic Analyses group prepended whenever the project holds results. Toggle with `Ctrl-Cmd-S`. See also: project, Inspector.

**Simplex read**{#simplex-read}. An Oxford Nanopore read produced by basecalling one strand of a DNA molecule passing through a pore once; modern R10.4.1 simplex with super-accuracy basecallers achieves Q20+ per-base quality. See also: duplex read, basecaller.

**Single-end**{#single-end}. A sequencing protocol that reads each DNA fragment from one end only, producing one FASTQ file per sample; common for Oxford Nanopore and for some Illumina shotgun protocols. See also: FASTQ, paired-end.

**Singleton read**{#singleton-read}. A read from a paired-end run whose mate is no longer present in the file, usually because an upstream filtering step discarded one member of the pair, and which a repair operation sets aside as unpaired rather than discarding. See also: paired-end, interleaved FASTQ.

**Sliding-window trimming**{#sliding-window-trimming}. A quality-trimming method that averages the quality scores of a small run of neighbouring bases and cuts the read where that average first falls below a threshold, so a single miscalled base does not truncate an otherwise good read. See also: fastp, Phred score.

**Smart-filter token**{#smart-filter-token}. One of the named filter chips revealed by the Presets button above the Variants tab, such as PASS, SNV, or DP >= 10, that applies a common variant filter with a single click and appears only when the loaded track carries the field it needs. See also: filter profile, FILTER.

**SNV (single-nucleotide variant)**{#snv}. A variant in which one reference base is read as one different base, written in a VCF as a REF and an ALT that are each a single character, and the commonest kind of difference between any two genomes. See also: indel, REF and ALT, VCF.

**Soft-clip**{#soft-clip}. A flag in a BAM record (the `S` letter in a CIGAR string) marking bases at the start or end of a read that are present in the record but excluded from pileup, coverage, and variant calling; primer trimming works by soft-clipping primer-derived bases rather than deleting them. See also: primer trim, CIGAR.

**Sparkline**{#sparkline}. A small chart drawn without axes or labels, sized to sit inside a strip rather than to be read precisely, of which Lungfish draws three under a FASTQ bundle's summary cards, labelled Length Dist., Q / Position, and Q Score Dist., with a click on any one opening the full-size chart in a popover. See also: quality control, FASTQ.

**SRA (Sequence Read Archive)**{#sra}. The NCBI public archive of raw sequencing reads, identified by accession numbers that start with `SRR` for runs and `SRP` for projects. Lungfish downloads SRA reads via the ENA mirror first and falls back to the SRA Toolkit if ENA refuses. See also: ENA.

**Strand**{#strand}. Whether a read aligned to the reference as sequenced (forward) or as its reverse complement (reverse); recorded as a flag bit in every BAM row. See also: strand bias.

**Strand bias**{#strand-bias}. A pattern where reads supporting a variant come predominantly from one strand of the reference, often as an artifact of primer placement in amplicon protocols rather than a genuine biological signal. Variant callers apply a strand-bias filter to flag suspect calls; for amplicon data the filter is usually disabled because the imbalance is structural. See also: amplicon.

**Subsampling**{#subsampling}. Drawing a smaller set of reads at random from a larger one, so the smaller set keeps the composition of the original without anyone choosing which reads survive, used to make a fast test slice or to cut two libraries to a common depth before comparing them. See also: FASTQ, read length.

**Substitution model**{#substitution-model}. The set of assumed rates at which one base or residue changes into another, which a maximum-likelihood method needs before it can score a tree; IQ-TREE's default `MFP` setting is an instruction to test many models and use the best-fitting one rather than a model itself. See also: maximum likelihood, IQ-TREE.

**Supplementary alignment**{#supplementary-alignment}. A secondary record for a read that maps in pieces (split-read or chimeric alignment), with the full read mapped at the primary position and supplementary records covering the other pieces; flag bit 2048 marks supplementary alignments. See also: BAM, FLAG.

**Support value**{#support-value}. A number annotated at an internal node of a phylogenetic tree giving the percentage of bootstrap or replicate trees that recovered that exact split; values above 95 indicate a well-supported clade and values below 70 should not be relied on. See also: IQ-TREE, phylogram.

## T

**Tabix**{#tabix}. A position-aware index for a bgzipped tab-delimited genomic file (typically `.vcf.gz` or `.bed.gz`), conventionally named with a `.tbi` suffix and kept beside the data file, that lets viewers and callers fetch records for a region without scanning the whole file. See also: VCF.

**Table drawer**{#table-drawer}. The panel that slides up from the bottom edge of a reference bundle viewport carrying one tab per kind of table, Annotations, Variants, and Samples, which opens by itself whenever the loaded bundle holds an annotation or variant track. It starts 250 points tall, resizes by dragging its top edge, and remembers the height you set. See also: reference bundle, variant track, sequence viewport.

**Target enrichment**{#target-enrichment}. A library preparation that pulls chosen regions out of a randomly sheared sample using complementary probes, so reads concentrate on the targets without carrying primer sequence at their ends and without needing a primer trim. See also: library prep, amplicon, shotgun.

**Taxon**{#taxon}. Any named group on the tree of life, at any level of the naming hierarchy, so *Homo sapiens*, *Streptococcus*, and *Coronaviridae* are each one taxon, and a classifier's answer for a single read is the name of one of them. See also: taxonomic rank, lowest common ancestor, read classification.

**Taxonomic rank**{#taxonomic-rank}. The level of the biological naming hierarchy a taxon belongs to, running from domain down through phylum, class, order, family, and genus to species, which is what a classifier's result table reports in its Rank column and what each ring of a sunburst chart stands for. See also: taxon, clade, read classification.

**TaxTriage**{#taxtriage}. A pathogen-detection workflow run as a Nextflow pipeline inside a container, which classifies reads against an installed Kraken 2 database and scores each organism it reports for confidence, opened in Lungfish Genome Explorer from **Tools > Classification > TaxTriage...**. See also: read classification, Nextflow, container, Kraken 2.

**Tiling**{#tiling}. An amplicon design in which many primer pairs produce overlapping amplicons laid end to end, so that together they cover a whole region of interest rather than one locus. See also: amplicon, primer scheme.

**Tip**{#tip}. The end point of a branch on a phylogenetic tree, standing for one of the sequences that went in, so five aligned sequences give five tips and a missing tip means an input was dropped. See also: internal node, clade, topology.

**Topology**{#topology}. The branching pattern of a phylogenetic tree, meaning which tips group with which and in what order, considered apart from the branch lengths; it is the tree's main claim and the part a support value measures confidence in. See also: tip, internal node, support value, branch length.

**12S**{#twelve-s}. A short mitochondrial 12S rRNA amplicon used to identify vertebrate species; Lungfish matches merged 12S reads exactly against a deduplicated reference FASTA. See also: metabarcoding.

## U

**UMI (unique molecular identifier)**{#umi}. A short random barcode added to each original DNA molecule before amplification, so that PCR copies of one molecule can be recognised as copies rather than counted as independent observations. Where a protocol places a UMI at a fixed position at the read start, Trim Fixed Bases is the operation that removes it. See also: barcode, mark duplicates.

**Unclassified reads**{#unclassified-reads}. The reads a barcoded Oxford Nanopore run produced whose barcode the basecaller could not read confidently, which MinKNOW collects in a folder named `unclassified` beside the numbered barcode folders and which the run-folder importer skips unless you ask for them. See also: barcode, MinKNOW, demultiplex.

## V

**Variant-caller**{#variant-caller}. The program that compares aligned reads to a reference and emits a VCF describing positions where the sample differs. Lungfish offers five viral callers (LoFreq for short-read viral data, iVar for primer-trimmed amplicon data, Medaka and Clair3 for Oxford Nanopore data, and bcftools as a general cross-check) plus two GATK germline options for human work. See also: pileup, VCF.

**Variant-only bundle**{#variant-only-bundle}. A `.lungfishref` bundle built around one or more imported VCFs and holding no reference sequence of its own, which is what Lungfish Genome Explorer creates when you import a VCF with no reference bundle open and name the result at the Name Imported Variant Bundle prompt. It records the ploidy it assumed under an Import Settings group and tries to fetch a matching reference from NCBI in the background. See also: reference bundle, variant track, VCF.

**Variant track**{#variant-track}. One named set of variant calls stored inside a reference bundle, written as a bgzip-compressed VCF with a tabix index and a SQLite copy of the same rows that the Variants tab queries when you sort or filter. A bundle can hold several, and when it does they all load into the one table at once with the Source column naming which track each row came from. See also: reference bundle, table drawer, VCF.

**VCF (Variant Call Format)**{#vcf}. A tab-separated file format that lists positions in a reference genome where a sample differs, with per-call confidence and metadata. See also: REF, ALT, genotype, allele frequency.

**Virtual bundle**{#virtual-bundle}. A read bundle that stores a short manifest naming its parent bundle and the operation to apply rather than a second copy of the reads, keeping only a preview of about a thousand reads on disk, so that many subsets of one sample cost about as much storage as one. See also: materialization, bundle, subsampling.

## W

**Workflow lineage**{#workflow-lineage}. The ordered chain of tool invocations a Lungfish run record holds, shown as the Lineage block of the Inspector's Provenance section, where each numbered step expands to its own command, inputs, outputs, exit status, and wall time. Distinct from a viral lineage, which names a subgroup of a virus species. See also: run record, provenance sidecar.
