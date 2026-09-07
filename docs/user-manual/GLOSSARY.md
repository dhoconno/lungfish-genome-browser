# Glossary

**Ownership:** Bioinformatics Educator only.

Terms appear in alphabetical order. Each entry is a one-sentence definition, followed by an explicit anchor ID in `{#anchor-id}` form so chapters can deep-link from inline references and the in-app Help system can resolve term lookups directly to this page. Anchor IDs match the `glossary_refs:` slugs declared in chapter frontmatter.

## A

**Accession**{#accession}. The permanent identifier a public sequence database assigns to one record, such as the RefSeqGene record `NG_000007.3`. The trailing number after the dot is a version that increments when a curator revises the deposited sequence, so a published coordinate should always name the version it was measured against. See also: INSDC, reference genome.

**AI assistant**{#ai-assistant}. An in-app chat panel that answers questions about the active dataset and suggests workflows through a bring-your-own-key AI provider; it interprets and explains but does not modify your project.

**Alias map**{#alias-map}. The internal table Lungfish consults during VCF import to recognise that two reference accessions (for example, the GenBank record `MN908947.3` and the RefSeq record `NC_045512.2`) name the same underlying sequence, so a VCF keyed against one resolves cleanly to a project bundle keyed against the other. See also: VCF, reference bundle.

**Alignment**{#alignment}. The mapping of one read against a reference genome, recorded as one row in a BAM file with a position, strand, CIGAR string, and quality scores. See also: BAM, mapping.

**Alignment column**{#alignment-column}. One vertical slice through a multiple sequence alignment, holding one residue or one gap character from every row, taken to represent a single inferred homologous position across all the aligned sequences. See also: MSA, gap, homologous.

**Allele**{#allele}. One of the alternative sequences observed at a locus; in Lungfish MHC genotyping an allele is an individual MiSeq target identity, distinct from a named haplotype that spans several loci. See also: haplotype, MHC.

**Allele frequency**{#allele-frequency}. The proportion of sequencing reads at a position that carry the alternate base. A clinical isolate usually shows allele frequencies near 0 or 1; a mixed-population sample (for example, wastewater) shows a full spectrum.

**Amplicon**{#amplicon}. A target region of a genome amplified by PCR, used as the unit of an amplicon-based sequencing protocol such as ARTIC or QIASeqDIRECT. A run produces many overlapping amplicons that together tile the region of interest.

**Annotation track**{#annotation-track}. One named set of features stored together inside a reference bundle and drawn as a single layer in the annotation lane of the sequence viewport, carrying both a display name and a stable track ID, so a GenBank import creates one named Imported Annotations and a bundle can hold several tracks at once. See also: reference bundle, GFF, sequence viewport.

**Assembly bundle**{#assembly-bundle}. A `.lungfishref` bundle that holds a de novo assembly produced inside the project, typically by SPAdes or MEGAHIT, and lives under the project's `Analyses/` folder alongside every other result. The internal structure is identical to a reference bundle; only the folder placement distinguishes the two. See also: reference bundle, bundle.

## B

**BAI**{#bai}. The companion index file for a BAM that lets viewers jump to a specific reference position without reading the whole file; conventionally named `<sample>.bam.bai` and kept in the same folder as the BAM. See also: BAM.

**BAM**{#bam}. The binary, indexed form of the SAM alignment format, with one row per aligned read and a header listing reference contigs; Lungfish always reads and writes BAMs rather than SAMs because of size and random-access requirements. See also: BAI, alignment, CIGAR.

**BAQ**{#baq}. Base Alignment Quality, samtools' per-base recalibration that lowers the quality of bases sitting near indel-prone regions; useful for shotgun random-fragment data and counterproductive for amplicon data, which is why Lungfish disables BAQ (`-B`) for amplicon variant calling. See also: pileup.

**Barcode**{#barcode}. A short oligonucleotide sequence (typically 8 to 24 bases) ligated onto a sample's reads during library prep so that pooled samples can be sorted back to their wells after multiplexed sequencing; ONT runs identify barcodes during basecalling and write one subfolder per barcode. See also: basecaller.

**Barcode kit**{#barcode-kit}. The named set of barcode sequences a sequencing kit uses to tag samples, which Lungfish reads to demultiplex a run. See also: barcode, demultiplex.

**BCF**{#bcf}. The compact binary form of VCF, holding the same rows and header but packed for machines. Lungfish Genome Explorer reads an imported BCF with a CSI index beside it, but stores the variant tracks it writes as a bgzip-compressed VCF with a tabix index under the bundle's `variants/` folder, alongside a SQLite sidecar that indexes the same rows. See also: VCF, CSI, tabix.

**Benchmark VCF**{#benchmark-vcf}. A variant call set produced independently of the reads under study and treated as an answer key, such as the Genome in a Bottle small-variant benchmark for HG002 that this manual compares its own calls against. See also: VCF, variant-caller.

**Basecaller**{#basecaller}. The program that converts a sequencer's raw signal into base-called reads with quality scores; for Oxford Nanopore data, Guppy and Dorado are the two basecallers in current use, and the model used to call a run determines which Medaka model is appropriate downstream. See also: simplex read, duplex read.

**BioSample**{#biosample}. An NCBI record describing one biological sample; Lungfish can export a BioSample submission TSV from a project's sample metadata. See also: sample metadata.

**BLAST (Basic Local Alignment Search Tool)**{#blast}. NCBI's nucleotide and protein sequence search service that ranks database entries by local-alignment score against a query, used in Lungfish to verify a classifier's hit by sending a representative read to NCBI's `nt` database. See also: e-value, percent identity, query coverage.

**Bootstrap**{#bootstrap}. A way of measuring confidence in a phylogenetic grouping by rebuilding the tree many times from alignments resampled column by column and reporting, as a percentage, how often each grouping came back; IQ-TREE's ultrafast bootstrap is the fast approximation Lungfish Genome Explorer exposes. See also: support value, IQ-TREE, SH-aLRT.

**BQSR (Base Quality Score Recalibration)**{#bqsr}. The GATK preprocessing step that corrects systematic errors in a sequencer's per-base quality scores by modelling them against a set of known-variant sites, run in Lungfish through `lungfish gatk bqsr` ahead of germline calling. See also: VCF, HaplotypeCaller.

**Branch length**{#branch-length}. The number attached to one branch of a phylogenetic tree, in the default phylogram drawing the estimated substitutions per site accumulated along that branch, so a long branch means a lot of inferred change rather than a long span of time. See also: phylogram, cladogram, topology.

**Bundle**{#bundle}. A folder that the macOS Finder shows as a single icon with an extension and that Lungfish treats as one logical object, with a manifest, primary data files, optional indexes and annotations, and a `provenance/` subfolder. Lungfish bundle types include `.lungfishref` for references and assemblies and `.lungfishprimers` for primer schemes. See also: reference bundle, assembly bundle, primer scheme.

## C

**CDS (coding sequence)**{#cds}. The portion of a gene that is translated into protein; Lungfish can annotate a best-match CDS on a sequence. See also: open reading frame, reading frame.

**Checksum**{#checksum}. A short fingerprint computed from a file's exact bytes, recorded by Lungfish as SHA-256 in every provenance record so two people can confirm they hold the identical file. See also: provenance, reproducibility.

**CIGAR**{#cigar}. A compact string in each BAM row that describes, base by base, how the read aligns to the reference: `M` for aligned positions, `I` and `D` for insertions and deletions, `S` for soft-clipped ends, and `H` for hard-clipped ends. See also: BAM, soft-clip.

**Circular consensus sequencing (CCS)**{#circular-consensus-sequencing}. The PacBio protocol that circularises a DNA fragment, reads it repeatedly, and reports the consensus of those passes as one read, which is why HiFi reads carry both long lengths and Q30+ quality strings; a HiFi read's quality is a consensus confidence, not a raw signal measurement. See also: read length, Phred score.

**Clade**{#clade}. A group on a phylogenetic tree consisting of one internal node and every tip descended from it; the unit a phylogeneticist points to when claiming "these isolates share a recent common ancestor". See also: phylogram.

**Cladogram**{#cladogram}. A phylogenetic tree drawn with every tip at the same depth so that only the branching order is shown and branch lengths carry no meaning; one of the two layouts the Lungfish Genome Explorer tree viewport offers, useful when one very long branch would otherwise squash the rest. See also: phylogram, topology, clade.

**Clair3**{#clair3}. A deep-learning variant caller for Oxford Nanopore reads, run in Lungfish as an alternative to Medaka for ONT variant calling; it reads the sorted BAM directly and takes a model path matched to the basecaller. See also: variant-caller, Medaka.

**Clustering**{#clustering}. Grouping near-identical reads into representative consensus sequences before genotyping, used for full-length ONT MHC amplicons. See also: pbAA, savONT.

**Codon**{#codon}. A run of three consecutive bases inside a protein-coding gene that together encode one amino acid. Three adjacent SNPs falling inside one codon describe one amino acid change, not three; iVar can group them into a single VCF row when given a GFF annotation. See also: VCF.

**Cohort**{#cohort}. A set of samples genotyped and compared together, presented across the columns of the genotype comparison matrix. See also: genotype matrix.

**Conda**{#conda}. A package manager that handles compiled non-Python dependencies cleanly, used in Lungfish to install bioinformatics tools from the bioconda channel into per-tool environments under `~/.lungfish/conda`. See also: micromamba, plugin pack.

**Consensus FASTA**{#consensus-fasta}. The reference sequence with high-confidence sample variants applied in place; positions with insufficient evidence are masked as `N`. The format Pangolin and Nextclade expect for SARS-CoV-2 lineage assignment, and the format used for GISAID and NCBI surveillance submissions. See also: VCF, allele frequency.

**Consensus sequence**{#consensus-sequence}. A single sequence built from a multiple sequence alignment by taking each column's most common residue, with columns whose rows disagree too weakly or are too heavily gapped written as a mask character instead of a base. See also: MSA, alignment column, conservation.

**Conservation**{#conservation}. At one alignment column, the share of the non-gap rows that carry that column's most common residue, so a column where every row agrees scores 1 and a column split evenly between two residues scores 0.5. See also: alignment column, MSA.

**Contig**{#contig}. A contiguous stretch of assembled sequence emitted by an assembler, representing the longest path through the assembly graph that the algorithm could resolve unambiguously; one assembly bundle holds many contigs, ranked by length in the assembly viewport. See also: assembly bundle, N50.

**Contig (in a reference)**{#contig-reference}. One named sequence in a multi-record FASTA; in `.lungfishref` bundles the contig list comes from FASTA headers and matches the BAM, VCF, and GFF3 contig fields.

**Coordinate**{#coordinate}. A 1-based position on a reference, named as `chrom:position` (for example, `MN908947.3:21618`). Lungfish presents 1-based inclusive coordinates to the user everywhere; underlying file formats may use 0-based half-open (BED) or 1-based inclusive (VCF, GFF3, SAM/BAM displayed). See also: chromosome.

**Coverage**{#coverage}. The number of reads that align across a given reference position; used interchangeably with depth in this manual. See also: pileup.

**CSI (coordinate-sorted index)**{#csi}. The alternative BAM index format for a reference sequence longer than the 512-megabase limit a BAI index can address, serving the same purpose of letting a viewer jump straight to a chosen position. Lungfish Genome Explorer writes BAI for the BAMs it produces and reads a CSI that arrives beside an imported BAM. See also: BAI, BAM.

**Ct (cycle threshold)**{#ct}. The qPCR cycle number at which a sample's amplification signal crosses the detection threshold; a lower Ct means more starting template, so for a viral diagnostic a low Ct predicts a higher viral fraction in the sequencing reads and a smaller host-removal rate.

## D

**Demultiplex**{#demultiplex}. Separating a mixed sequencing run into per-sample read sets by their barcode. See also: barcode, barcode kit.

**Depth**{#depth}. Synonym for coverage in this manual. The number of reads stacked at one reference position. See also: coverage.

**Download Center**{#download-center}. The surface that reports the progress of anything Lungfish fetches from the internet, whether a reference record from NCBI or a sequencing run from the SRA, and the place to look when a download does not appear where you expected it. See also: Operations Panel, SRA.

**Duplex read**{#duplex-read}. An Oxford Nanopore read produced by basecalling both strands of the same DNA molecule and reconciling them into a single high-accuracy consensus; duplex Q30+ approximates Illumina-grade accuracy and is the basis for modern Medaka-duplex models. See also: simplex read, basecaller.

## E

**E-value**{#e-value}. The number of database alignments of equal or better score expected by chance for a given query length and database size; in BLAST results, smaller is better, with values at or below `1e-30` indicating an essentially unmistakable match for a typical viral read. See also: BLAST, percent identity.

**ENA (European Nucleotide Archive)**{#ena}. The European mirror of the SRA, hosted at EMBL-EBI; one of three INSDC partners (with NCBI SRA and DDBJ) that share deposited sequencing data. Lungfish downloads SRA runs from ENA first because ENA serves pre-converted FASTQs directly, and falls back to the NCBI SRA Toolkit when ENA is unavailable. See also: SRA.

**Exon**{#exon}. One of the stretches of a gene that survives splicing and contributes to the mature transcript, so a protein-coding sequence split across three exons is written in a GenBank record as a `join()` of three ranges. See also: CDS, GFF.

**Extraction**{#extraction}. A bundle pulled out of a larger dataset by a Lungfish operation, either a chosen set of reads taken from a FASTQ or BAM or a chosen stretch of a reference sequence, written into the project's `Extractions/` folder with its own provenance sidecar. See also: bundle, project, provenance sidecar.

## F

**FAI (FASTA index)**{#fai}. A small text index file (typically `<sequence>.fasta.fai`) produced by `samtools faidx` that lets tools jump to a specific position in a FASTA without reading the whole file; required for variant calling and many other reference-keyed operations. See also: FASTA.

**FASTA**{#fasta}. A plain-text format for nucleotide or protein sequences, with each record introduced by a `>` header line followed by sequence lines containing the bases. Lungfish accepts plain FASTA, multi-record FASTA, and bgzipped FASTA at every reference picker. See also: FAI, FASTQ.

**FASTQ**{#fastq}. A plain-text format for sequencing reads, with each read taking exactly four lines: a `@`-prefixed header, the read sequence, a `+` separator, and a same-length quality string in the standard ASCII offset 33 encoding. The input format for every workflow that starts from raw sequencing data. See also: paired-end, Phred score.

**FILTER (in a VCF)**{#filter}. The seventh standard VCF column, holding `PASS` where the row cleared every filter the caller applied, a semicolon-separated list of the named filter flags it failed, or a bare `.` where no filter was applied at all. Flag names are caller-specific and are declared in the file's own header, so LoFreq writes names such as `min_dp_10` and `sb_fdr` while iVar writes `ft` and `bq`. See also: VCF, INFO, FORMAT.

**Filter profile**{#filter-profile}. A named set of smart-filter tokens applied together to a variant track, either one of the four built into Lungfish (Clinical, Research, QC, High Confidence) or a combination the user assembles and saves per bundle. See also: smart-filter token, VCF.

**FLAG (in a BAM)**{#flag}. A bitwise integer field in each BAM row encoding facts about the read in twelve canonical bits: paired, properly paired, unmapped, mate unmapped, reverse strand, mate reverse strand, first of pair, second of pair, secondary alignment, low quality, duplicate, supplementary alignment. The decoded value `99` is the sum of bits 1+2+32+64. See also: BAM, supplementary alignment.

**FORMAT (in a VCF)**{#format}. The ninth VCF column, declaring a colon-separated list of keys that describe the per-sample payload columns following it, such as the `GT:PL:AD` that bcftools writes. The column is optional, and LoFreq output has no FORMAT and no sample column at all. See also: VCF, INFO.

**Freyja**{#freyja}. A tool that estimates the relative abundance of each viral lineage in a mixed sample (typically wastewater) by demixing the sample's variant and depth profiles against known lineage definitions, run in Lungfish through `lungfish freyja demix`. See also: lineage, consensus FASTA.

## G

**Gap**{#gap}. The `-` character an aligner writes into one row of a multiple sequence alignment at a column where that sequence has no residue, standing for an insertion in the other sequences or a deletion in this one, and letting rows of unequal length share a rectangular grid. See also: alignment column, MSA.

**Genetic code**{#genetic-code}. The mapping from codons to amino acids; Lungfish lets you pick the code (for example the vertebrate mitochondrial code) when translating a sequence. See also: codon, reading frame.

**GenomicsDB**{#genomicsdb}. GATK's on-disk multi-sample variant store that scales joint genotyping to large cohorts better than a single combined GVCF; Lungfish builds one with `GenomicsDBImport` when a cohort exceeds 50 samples. See also: GVCF, joint genotyping.

**Genotype**{#genotype}. A compact notation for which alleles are observed at a variant position, written diploid-style as `0/1` (heterozygous) or `1/1` (homozygous alternate), where `0` is the reference allele and `1` the first alternate. The Lungfish Genome Explorer iVar pipeline writes the bare haploid `1` instead, which is the honest notation for an organism carrying one genome copy. See also: heterozygous, homozygous, FORMAT.

**Genotype matrix**{#genotype-matrix}. The Lungfish dashboard that presents genotype calls as allele-target rows by sample columns, with a haplotype tape, cohort summary, and per-sample evidence; it is not one of the five genomic viewport classes. See also: haplotype, cohort.

**GFF (General Feature Format)**{#gff}. A tab-separated table format for genomic features (genes, CDS, mature peptides, regulatory elements). GFF3 is the current spec; Lungfish accepts GFF3 paired with a FASTA at bundle creation. See also: FASTA, reference bundle.

**GVCF (genomic VCF)**{#gvcf}. A VCF variant that records, at every position rather than only at variant sites, the confidence that the sample matches the reference, so per-sample GVCFs can later be combined and genotyped together; the form GATK HaplotypeCaller emits by default in Lungfish. See also: VCF, joint genotyping, GenomicsDB.

## H

**Haplotype**{#haplotype}. A set of alleles across linked loci that tend to travel together; in Lungfish MHC genotyping these are the named M1 to M7 families spanning the MHC-A, MHC-E, MHC-B, MHC-DR, MHC-DQ, and MHC-DP loci. See also: allele, MHC.

**Heterozygous**{#heterozygous}. Carrying two different alleles at one position, one on each copy of a chromosome, written `0/1` in a VCF genotype field. See also: homozygous, genotype.

**Homologous**{#homologous}. Descended from the same position in a shared ancestral sequence, which is what a column of a multiple sequence alignment claims about the residues stacked in it, and which is an inference from similarity rather than something the data states directly. See also: alignment column, MSA.

**Homozygous**{#homozygous}. Carrying the same allele on both copies of a chromosome at one position, written `0/0` for the reference allele and `1/1` for the alternate. See also: heterozygous, genotype.

## I

**Immunogenetics**{#immunogenetics}. The study of genetic variation in immune-system loci such as the MHC; the domain of Lungfish's amplicon genotyping feature. See also: MHC.

**Import Center**{#import-center}. The tabbed import window opened with **File > Import Center...** (`Cmd-Shift-I`), holding one tab per data kind (Sequencing Reads, Alignments, Variants, Classification Results, Reference Sequences, Application Exports) and one card per import inside each tab, every card a drop target. See also: reference bundle, provenance.

**INFO (in a VCF)**{#info}. The eighth standard VCF column, holding semicolon-separated `KEY=VALUE` pairs of per-row metadata such as depth (`DP`), allele frequency (`AF`), strand bias (`SB`), and per-allele depths (`AD`). See also: VCF, FILTER, FORMAT.

**INSDC (International Nucleotide Sequence Database Collaboration)**{#insdc}. The three-way partnership of NCBI (USA), EMBL-EBI (Europe), and DDBJ (Japan) that mirrors deposited nucleotide sequences and assigns a single globally-unique accession to each record; ENA, NCBI SRA, and DDBJ Sequence Read Archive are the SRA tier of this partnership. See also: ENA, SRA.

**Insert size**{#insert-size}. The length of the original DNA fragment that a paired-end read pair came from, measured end to end including both reads; when the insert is shorter than twice the read length the two mates overlap and can be merged. See also: paired-end, read length.

**Inspector**{#inspector}. The right-hand pane of a Lungfish project window that shows context-sensitive metadata and analysis actions for whatever is selected in the sidebar or main viewport. Toggle with `Cmd-Opt-I`. See also: sidebar, project.

**Internal node**{#internal-node}. Any point on a phylogenetic tree where branches meet, standing for an inferred common ancestor that was never sequenced and no longer exists; a tree of five tips can hold at most three of them. See also: tip, clade, topology.

**Interleaved FASTQ**{#interleaved-fastq}. A single FASTQ file holding a paired-end run with the two mates of each fragment written as consecutive records, forward then reverse, rather than split across an R1 and an R2 file. Lungfish stores a paired-end sample inside its bundle as one interleaved file, and offers Interleave and Deinterleave as explicit operations on files outside a bundle. See also: paired-end, FASTQ.

**IQ-TREE**{#iqtree}. A maximum-likelihood phylogenetic inference program with a built-in ModelFinder step and ultrafast bootstrap support estimation, used by Lungfish to produce `.lungfishtree` bundles from MSA bundles. See also: MSA, phylogram, support value.

## J

**Joint genotyping**{#joint-genotyping}. The GATK step that calls genotypes across a whole cohort at once by combining per-sample GVCFs and running `GenotypeGVCFs`, rather than genotyping each sample in isolation; run in Lungfish through `lungfish gatk joint-genotype`. See also: GVCF, GenomicsDB.

## L

**LabKey**{#labkey}. A laboratory data management platform; Lungfish can export genotype results as LabKey-ready CSV files.

**Library prep**{#library-prep}. The bench procedure that turns extracted nucleic acid into a form a sequencing instrument can read, and the step that decides whether reads land at random positions (shotgun), at designed primer coordinates (amplicon), or on probe-selected regions (target enrichment). See also: amplicon, shotgun, target enrichment.

**Library layout**{#library-layout}. The archive field recording whether a sequencing run read each fragment from one end or from both, reported as SINGLE or PAIRED, which is how an SRA search can be restricted to runs whose reads come in mate pairs. See also: paired-end, single-end, SRA.

**Library strategy**{#library-strategy}. The archive field recording what a sequencing library was built to do, with values such as WGS for whole-genome shotgun, AMPLICON for targeted PCR product, WXS for whole-exome capture, and RNA-Seq for transcript sequencing. See also: amplicon, shotgun, SRA.

**Lineage**{#lineage}. A named subgroup within a viral species, defined by a characteristic set of variants and assigned by a domain-specific tool (Pangolin for SARS-CoV-2, Nextclade for many viruses). Lungfish does not assign lineages itself; it produces consensus FASTAs that downstream tools call lineages from. See also: consensus FASTA.

## M

**MAFFT**{#mafft}. A multiple sequence alignment program that auto-selects an algorithm by input size and is the default aligner Lungfish runs when producing a `.lungfishmsa` bundle. See also: MSA.

**Mapper**{#mapper}. A program that places sequencing reads onto a reference genome and emits an alignment file (BAM); Lungfish ships minimap2, BWA-MEM2, Bowtie2, and BBMap. See also: alignment, mapping.

**Mapping**{#mapping}. The act of finding, for each read, the reference position where it best fits and recording the alignment in a BAM. See also: alignment, mapper.

**Managed environment**{#managed-environment}. The private folder conda builds for one tool under `~/.lungfish/conda`, holding that tool and the libraries it depends on, so two tools needing different versions of the same library never collide, with the Plugin Manager's Installed tab listing one row per managed environment. See also: conda, plugin pack.

**Mapping preset**{#mapping-preset}. A named bundle of mapper settings tuned for one kind of input, chosen alongside the mapper itself, where minimap2 offers `sr` for short reads, `map-ont`, `map-hifi`, and `map-pb` for long reads, `asm5` for assembled contigs, and `splice` for spliced alignment, while BBMap offers a standard and a PacBio mode. See also: mapper, mapping.

**MAPQ (mapping quality)**{#mapq}. A per-read confidence score in each BAM row, encoding how unambiguously the mapper placed the read at the recorded position; 0 means no confidence (the read fits multiple places equally well), 60 is the maximum for most mappers and means the placement is well above the second-best alternative. See also: BAM, mapper.

**Mark duplicates**{#mark-duplicates}. The step that finds BAM rows sharing a start and end position, which are usually PCR copies of one original fragment, and flags the extras so a variant caller counts them once, run in Lungfish as `samtools markdup` through `lungfish-cli bam markdup`. The step is inappropriate for amplicon data, where every fragment is designed to start at the same place. See also: BAM, FLAG.

**Maximum likelihood**{#maximum-likelihood}. The method IQ-TREE uses to choose a phylogenetic tree, which scores every candidate tree by how probable it makes the observed alignment columns under an assumed substitution model and keeps the highest-scoring one. See also: IQ-TREE, substitution model, topology.

**Metabarcoding**{#metabarcoding}. Identifying which species are present in a mixed sample by matching a short marker amplicon (such as 12S) against a reference of known sequences. See also: 12S.

**Methods export**{#methods-export}. The Lungfish provenance export that emits a plain-prose Markdown paragraph naming each tool and its resolved version in the order the workflow ran them, suitable for pasting into a paper's methods section. See also: provenance sidecar.

**MHC (Major Histocompatibility Complex)**{#mhc}. A gene-dense immune region genotyped here by amplicon sequencing, using the Mauritian cynomolgus macaque as the running example. See also: haplotype, immunogenetics.

**Micromamba**{#micromamba}. A small standalone bootstrap that speaks the conda protocol without requiring a full Anaconda installation, used by Lungfish as the engine for plugin pack installs. See also: conda, plugin pack.

**Mitochondrial genome**{#mitochondrial-genome}. The small circular DNA molecule carried inside the mitochondrion, the compartment that supplies a cell's chemical energy, separate from the nuclear chromosomes and present in many copies per cell, the human one being the 16,569-base record `NC_012920.1` known as the revised Cambridge Reference Sequence. See also: reference genome, accession.

**Minimizer**{#minimizer}. The smallest k-mer within a sliding window of a sequence, picked as a compact fingerprint so a tool can match reads quickly without comparing every base; Kraken2 classifies on minimizers and Deacon counts minimizer hits to flag host reads. See also: Kraken2, Deacon.

**MSA (Multiple Sequence Alignment)**{#msa}. A rectangular arrangement of two or more related sequences in which each column represents an inferred homologous position, with `-` gap characters padding insertions; in Lungfish stored as a `.lungfishmsa` bundle. See also: MAFFT.

## N

**N50**{#n50}. A summary statistic for a set of assembled contigs: the length such that contigs of at least that length together hold half of the assembly's total bases; a higher N50 indicates a less fragmented assembly. See also: contig, assembly bundle.

**NAO-MGS**{#nao-mgs}. A wastewater metagenomic surveillance pipeline from SecureBio that runs externally and whose `virus_hits_final.tsv(.gz)` output Lungfish imports (it does not run the pipeline) through `lungfish nao-mgs import` or the Import Center, presenting one run's viral taxa in a sortable table with a taxon detail pane and BLAST verification workflow. See also: BLAST.

**Newick**{#newick}. A compact parenthesised text format for phylogenetic trees, with branch lengths after colons and optional support values at internal nodes; the lingua franca for moving trees between FigTree, iTOL, ete3, and Lungfish. See also: phylogram.

**NVD (Novel Virus Diagnostics)**{#nvd}. An external Snakemake wastewater-surveillance pipeline that assembles reads into contigs and BLASTs each contig, whose `*_blast_concatenated.csv(.gz)` output Lungfish imports (it does not run the pipeline) through `lungfish nvd import` or the Import Center and presents as a contig-keyed browser of best and secondary BLAST hits. See also: contig, BLAST.

## O

**Open reading frame**{#open-reading-frame}. A stretch of codons from a start to a stop with no internal stop, a candidate protein-coding region Lungfish can auto-detect. See also: reading frame, CDS.

**Operations Panel**{#operations-panel}. A separate Lungfish window that lists every long-running operation of the current session with its state, elapsed time, command line, and log, and that offers Clear Completed and a per-row context menu. Open it with **Operations > Show Operations Panel** (`Cmd-Shift-P`). The durable audit trail lives in the provenance sidecars rather than in the panel. See also: provenance, project.

**ORF (open reading frame)**{#orf}. A stretch of sequence running from a start codon to an in-frame stop codon without interruption, so it could in principle encode a protein; Lungfish finds ORFs and stores them as an annotation track, but ORF length is only a weak proxy for a real gene. See also: codon.

**Orient Reads**{#orient-reads}. A Lungfish operation that aligns ONT reads against a reference and flips reverse-strand reads so every read in the bundle ends up in the same orientation, useful for amplicon protocols and consensus building. See also: basecaller, simplex read.

**Outgroup**{#outgroup}. A sequence included in a phylogenetic analysis because you are confident it falls outside the group under study, used to place the root so the rest of the tree can be read as a sequence of descent. See also: rooting, topology, clade.

## P

**Paired-end**{#paired-end}. A sequencing protocol that reads each DNA fragment from both ends, producing two reads per fragment; the two halves of a pair travel as separate FASTQ files with `_1`/`_2` or `_R1`/`_R2` suffixes. See also: FASTQ, single-end.

**Pathoplexus**{#pathoplexus}. An open pathogen-genome database Lungfish can search and import reference sequences from.

**pbAA**{#pbaa}. A read-clustering tool that derives high-accuracy amplicon consensus sequences, one of the clustering options for full-length ONT MHC genotyping. See also: clustering, savONT.

**p-distance**{#p-distance}. The simplest genetic distance between two aligned sequences: the proportion of positions at which they differ, with no model correction. One of the distance models Lungfish's `msa distance` can compute. See also: MSA.

**Phred score**{#phred-score}. A logarithmic per-base quality value defined as `Q = -10 * log10(P)` where P is the error probability; Q20 = 1% error, Q30 = 0.1% error, Q40 = 0.01% error. Encoded in FASTQ files as ASCII characters offset by 33 (so `!` = Q0, `F` = Q37). See also: FASTQ.

**Phylogram**{#phylogram}. A phylogenetic tree drawn so that branch length is proportional to the inferred amount of evolutionary change (substitutions per site); the default tree-viewport layout in Lungfish. See also: clade, IQ-TREE.

**Percent identity**{#percent-identity}. In a BLAST or other pairwise alignment, the fraction of aligned positions where the query and the subject sequence agree, calculated only over the aligned region; read together with query coverage to gauge how much of the read aligned and how well. See also: BLAST, query coverage.

**Pileup**{#pileup}. The column of bases observed at one reference position across every read that covers it, together with their qualities and strands; the unit of evidence a variant caller weighs at each position. See also: coverage, variant-caller.

**Plugin pack**{#plugin-pack}. A themed group of related bioinformatics tools that Lungfish installs on demand into per-tool conda environments, named for the workflow it supports (for example, `read-mapping`, `variant-calling`, `assembly`). See also: conda, micromamba.

**Post-install hook**{#post-install-hook}. A follow-up command a plugin pack declares for itself and Lungfish runs after the pack's tools are installed, such as downloading the lineage data a surveillance tool needs, with the count of hooks shown on the pack's card in the Plugin Manager. See also: plugin pack.

**Primer**{#primer}. A short oligonucleotide, typically 18 to 30 bases, that binds a specific position on a target genome and primes DNA synthesis from that position; the building block of every amplicon protocol. See also: amplicon, primer scheme.

**Primer scheme**{#primer-scheme}. The set of primer coordinate pairs that define an amplicon protocol, listing where each forward and reverse primer binds on the reference. In Lungfish, a primer scheme is packaged as a `.lungfishprimers` bundle that carries the BED coordinates, the primer sequences in FASTA, and provenance.

**Primer trim**{#primer-trim}. The step that removes primer-derived bases from the ends of aligned reads in amplicon data, so those bases do not contaminate variant calls. In Lungfish the trim runs as a BAM-level operation using `ivar trim` against a selected primer scheme. See also: amplicon, primer scheme.

**Project**{#project}. A `.lungfish` directory bundle that holds every input, output, bundle, and provenance record for one Lungfish analysis, with a top-level layout of `Imports/`, `Downloads/`, `Reference Sequences/`, `Primer Schemes/`, `Extractions/`, `Haplotype Definitions/`, and `Analyses/`, plus a hidden `.project.db` catalog and a `metadata.json`. Only the app creates the project store, so a folder built by `lungfish-cli` alone opens read only. See also: bundle, sidebar, project lock.

**Project lock**{#project-lock}. The record Lungfish writes inside a project bundle naming the user, host, process, app version, and time of whoever currently holds it, so the app and the CLI can coordinate access to a project on shared storage. A lock left behind by a crashed process is called stale and is cleared through an explicit recovery that archives the old record. See also: project.

**Provenance**{#provenance}. The record Lungfish keeps alongside every download and every operation describing where a file came from or how it was produced, including source URL or accession, exact tool version, full command line, input checksums, and output checksums. See also: Operations Panel.

**Provenance sidecar**{#provenance-sidecar}. The JSON file Lungfish writes alongside every output (or into a bundle's `provenance/` subdirectory), recording the workflow name, resolved command, input and output checksums, runtime identity, and per-step exit status for one operation. See also: provenance, methods export.

## Q

**Quality binning**{#quality-binning}. The lossy compression step that rounds each base's Phred score to one of a small set of values before the reads are stored, offered by Lungfish at import as Illumina 4-level, 8-level, or None; Illumina instruments from the NovaSeq onward already report binned scores in hardware, so binning such a run discards little that was not already lost. See also: Phred score, FASTQ.

**Query coverage**{#query-coverage}. In a BLAST result, the fraction of the query sequence that participated in the alignment to the subject; a high percent identity over only a fraction of the read is much weaker evidence than a moderate identity over most of the read. See also: BLAST, percent identity.

## R

**Read**{#read}. One fragment of DNA reported by a sequencing instrument, stored as a string of bases beside an equal-length string of per-base quality scores, and written as one four-line record in a FASTQ file. See also: FASTQ, read length, Phred score.

**Read clumping**{#read-clumping}. The reordering of a read file so that reads sharing sequence content sit next to each other, which lets a general-purpose compressor find far more repetition and shrink the stored file; Lungfish applies it at import as the "Optimize storage" option, using BBTools clumpify or Trim Galore, and the reordering means the stored bundle no longer matches the source file's read order. See also: FASTQ.

**Read length**{#read-length}. The number of bases in a sequencing read; Illumina reads are typically 75-300 bp (fixed per run), Oxford Nanopore reads range from 1 kb to 100 kb (variable per run with mean 5-15 kb), PacBio HiFi reads are 10-25 kb. See also: FASTQ.

**Reading frame**{#reading-frame}. One of the three ways to divide a nucleotide sequence into codons on a given strand, selected when translating a sequence to protein. See also: genetic code, codon.

**Reference bundle**{#reference-bundle}. A `.lungfishref` bundle stored under a project's `Reference Sequences/` folder, containing a primary FASTA, an index, optional annotations such as GFF3 or GTF, any tracks attached to that reference (alignments, variants, classifications), and a manifest. See also: bundle, assembly bundle.

**Reference genome**{#reference-genome}. A specific, community-agreed sequence used as the comparison point for samples; for SARS-CoV-2 the standard reference is `MN908947.3` (the Wuhan-Hu-1 isolate). Variants are described relative to a chosen reference, so reference choice affects which variants are reported and at what positions. See also: reference bundle.

**RefSeq**{#refseq}. The curated subset of NCBI's sequence records, holding one reviewed, non-redundant record per sequence rather than every entry submitters deposited, recognisable by accession prefixes such as `NC_`, `NG_`, and `NM_` for records and `GCF_` for assemblies. See also: accession, INSDC, RefSeqGene.

**RefSeqGene**{#refseqgene}. An NCBI RefSeq record covering one gene or gene cluster as a curated slice of a chromosome, given its own coordinate system starting at 1 and its own accession (for example `NG_000007.3` for the human beta-globin cluster), so gene-focused work does not have to carry whole-chromosome coordinates. See also: accession, reference genome.

**REF, ALT**{#ref-alt}. REF is the base or bases present in the reference genome at a variant position; ALT is the base or bases observed in the sample. A one-base REF and one-base ALT describe a SNP; longer REF or ALT describe insertions and deletions.

**Representative reads**{#representative-read}. The coverage-stratified sample of reads (default 20, up to 50) that Lungfish automatically selects from a taxon's assigned reads and submits to NCBI BLAST during verification, chosen to span the taxon's coverage rather than picked one at a time by the user. See also: BLAST.

**Required Setup pack**{#required-setup-pack}. The one plugin pack Lungfish installs as a unit and cannot run without, shown in the Plugin Manager as Third-Party Tools, holding the seventeen everyday utilities the rest of the app assumes are present, among them samtools, bcftools, htslib, fastp, Deacon, seqkit, BBTools, Nextflow, and Snakemake. See also: plugin pack, managed environment.

**Reproducibility**{#reproducibility}. The property that a workflow re-run with the same inputs, the same plugin pack version, and the same Lungfish build produces output that matches the original by checksum (bit-identical) or by content (logically equivalent); the provenance sidecar carries every field needed to verify this. See also: provenance sidecar.

**Reverse complement**{#reverse-complement}. The sequence read from the opposite DNA strand, obtained by reading the bases backwards and swapping each for its pairing partner (A for T, C for G), so reading frames -1, -2, and -3 are the three frames counted along it and Lungfish runs the transformation from **Sequence > Reverse Complement...**. See also: strand, reading frame.

**Rooting**{#rooting}. Choosing which point on a phylogenetic tree stands for the oldest ancestor, which is what turns a statement about who groups with whom into a statement about which lineage came first; IQ-TREE produces unrooted trees, so rooting in Lungfish Genome Explorer is the separate **Re-root Here** step. See also: outgroup, topology, internal node.

**Run accession**{#run-accession}. The identifier naming one pass of one sequencing library through one instrument in a public read archive, written `SRR`, `ERR`, or `DRR` followed by digits according to which INSDC partner took the deposit, and the only accession level that resolves directly to FASTQ files. See also: accession, SRA, INSDC.

**Run record**{#run-record}. The provenance a single Lungfish operation left behind, read in the Inspector's Provenance section as seven blocks (Run Summary, Warnings, Lineage, Files & Outputs, Invocation & Options, Runtime, and Raw JSON) and stored on disk as one provenance sidecar. See also: provenance sidecar, workflow lineage.

## S

**Sample metadata**{#sample-metadata}. Structured per-sample fields (collection date, source, and so on) imported from a CSV or TSV sheet and attached to samples in a project. See also: BioSample.

**Sample sheet**{#sample-sheet}. A CSV listing one sequencing sample per row with the sample's name and the paths to its read files, used at import to pair reads and name bundles explicitly instead of matching mate suffixes in filenames; Lungfish requires the columns `sample`, `r1`, and `r2`, and carries any further columns through as per-sample metadata. See also: sample metadata, paired-end.

**savONT**{#savont}. A clustering option for full-length ONT MHC amplicons, an alternative to pbAA. See also: clustering, pbAA.

**Sequence viewport**{#sequence-viewport}. The centre pane of a Lungfish project window when a reference bundle is open, drawing one sequence along a horizontal axis as three stacked lanes rather than three separate panes, with the numbered position ruler on top, the bases in the middle, and the annotation features as coloured blocks below. See also: reference bundle, annotation track, Inspector.

**SH-aLRT**{#sh-alrt}. The Shimodaira-Hasegawa approximate likelihood ratio test, a fast branch-support measure IQ-TREE reports as a percentage at each internal node; read alongside bootstrap support, with values at or above 80 treated as reliable. See also: support value, IQ-TREE.

**Shotgun sequencing**{#shotgun}. A library preparation strategy in which sample nucleic acid is fragmented at random and sequenced without targeted amplification; each read lands at an essentially arbitrary position on the genome. Shotgun data does not require primer trimming. See also: amplicon.

**Sidebar**{#sidebar}. The left-hand pane of a Lungfish project window that shows the project's contents as a folder tree, with a search field above it and a synthetic Analyses group prepended whenever the project holds results. Toggle with `Ctrl-Cmd-S`. See also: project, Inspector.

**Simplex read**{#simplex-read}. An Oxford Nanopore read produced by basecalling one strand of a DNA molecule passing through a pore once; modern R10.4.1 simplex with super-accuracy basecallers achieves Q20+ per-base quality. See also: duplex read, basecaller.

**Single-end**{#single-end}. A sequencing protocol that reads each DNA fragment from one end only, producing one FASTQ file per sample; common for Oxford Nanopore and for some Illumina shotgun protocols. See also: FASTQ, paired-end.

**Smart-filter token**{#smart-filter-token}. One of the named filter chips revealed by the Presets button above the Variants tab, such as PASS, SNV, or DP >= 10, that applies a common variant filter with a single click and appears only when the loaded track carries the field it needs. See also: filter profile, FILTER.

**Soft-clip**{#soft-clip}. A flag in a BAM record (the `S` letter in a CIGAR string) marking bases at the start or end of a read that are present in the record but excluded from pileup, coverage, and variant calling; primer trimming works by soft-clipping primer-derived bases rather than deleting them. See also: primer trim, CIGAR.

**SRA (Sequence Read Archive)**{#sra}. The NCBI public archive of raw sequencing reads, identified by accession numbers that start with `SRR` for runs and `SRP` for projects. Lungfish downloads SRA reads via the ENA mirror first and falls back to the SRA Toolkit if ENA refuses. See also: ENA.

**Strand**{#strand}. Whether a read aligned to the reference as sequenced (forward) or as its reverse complement (reverse); recorded as a flag bit in every BAM row. See also: strand bias.

**Strand bias**{#strand-bias}. A pattern where reads supporting a variant come predominantly from one strand of the reference, often as an artifact of primer placement in amplicon protocols rather than a genuine biological signal. Variant callers apply a strand-bias filter to flag suspect calls; for amplicon data the filter is usually disabled because the imbalance is structural. See also: amplicon.

**Substitution model**{#substitution-model}. The set of assumed rates at which one base or residue changes into another, which a maximum-likelihood method needs before it can score a tree; IQ-TREE's default `MFP` setting is an instruction to test many models and use the best-fitting one rather than a model itself. See also: maximum likelihood, IQ-TREE.

**Supplementary alignment**{#supplementary-alignment}. A secondary record for a read that maps in pieces (split-read or chimeric alignment), with the full read mapped at the primary position and supplementary records covering the other pieces; flag bit 2048 marks supplementary alignments. See also: BAM, FLAG.

**Support value**{#support-value}. A number annotated at an internal node of a phylogenetic tree giving the percentage of bootstrap or replicate trees that recovered that exact split; values above 95 indicate a well-supported clade and values below 70 should not be relied on. See also: IQ-TREE, phylogram.

## T

**Tabix**{#tabix}. A position-aware index for a bgzipped tab-delimited genomic file (typically `.vcf.gz` or `.bed.gz`), conventionally named with a `.tbi` suffix and kept beside the data file, that lets viewers and callers fetch records for a region without scanning the whole file. See also: VCF.

**Target enrichment**{#target-enrichment}. A library preparation that pulls chosen regions out of a randomly sheared sample using complementary probes, so reads concentrate on the targets without carrying primer sequence at their ends and without needing a primer trim. See also: library prep, amplicon, shotgun.

**Tiling**{#tiling}. An amplicon design in which many primer pairs produce overlapping amplicons laid end to end, so that together they cover a whole region of interest rather than one locus. See also: amplicon, primer scheme.

**Tip**{#tip}. The end point of a branch on a phylogenetic tree, standing for one of the sequences that went in, so five aligned sequences give five tips and a missing tip means an input was dropped. See also: internal node, clade, topology.

**Topology**{#topology}. The branching pattern of a phylogenetic tree, meaning which tips group with which and in what order, considered apart from the branch lengths; it is the tree's main claim and the part a support value measures confidence in. See also: tip, internal node, support value, branch length.

**12S**{#twelve-s}. A short mitochondrial 12S rRNA amplicon used to identify vertebrate species; Lungfish matches merged 12S reads exactly against a deduplicated reference FASTA. See also: metabarcoding.

## V

**Variant-caller**{#variant-caller}. The program that compares aligned reads to a reference and emits a VCF describing positions where the sample differs. Lungfish offers five viral callers (LoFreq for short-read viral data, iVar for primer-trimmed amplicon data, Medaka and Clair3 for Oxford Nanopore data, and bcftools as a general cross-check) plus two GATK germline options for human work. See also: pileup, VCF.

**VCF (Variant Call Format)**{#vcf}. A tab-separated file format that lists positions in a reference genome where a sample differs, with per-call confidence and metadata. See also: REF, ALT, genotype, allele frequency.

## W

**Workflow lineage**{#workflow-lineage}. The ordered chain of tool invocations a Lungfish run record holds, shown as the Lineage block of the Inspector's Provenance section, where each numbered step expands to its own command, inputs, outputs, exit status, and wall time. Distinct from a viral lineage, which names a subgroup of a virus species. See also: run record, provenance sidecar.
