# Glossary sweep, Phase 6

Date: 2026-09-07
File: `docs/user-manual/GLOSSARY.md`
Role: brand copy editor

## What this sweep did

The lint rules went strict, and `GLOSSARY.md` reported 417 warnings. This sweep cleared all of them without renaming, removing, reordering away, or otherwise disturbing a single anchor. All 441 anchors in the file are byte identical to the ones the chapters link to, and the file still holds exactly 440 entries. No entry was added and none was deleted.

The warnings fell into four groups.

- 432 came from the `See also:` trailer every entry carries, since a colon inside a sentence is now banned. The colon is dropped, so the trailer now reads `See also term, term.`
- 5 came from a colon used inside a definition to introduce a list of parts.
- 79 came from semicolons joining two clauses inside a definition.
- 1 came from the overused word "determines".

## Lint result

Command.

    bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/GLOSSARY.md

Output, verbatim.

    /Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/GLOSSARY.md: no issues found

## Structural fixes

- Added the missing `## Y` heading. **YAML** was stranded at the bottom of the `## X` section, which put it under the wrong letter. The entry itself is untouched and its `{#yaml}` anchor is unchanged.
- The `## Z` section already existed and holds **Zero-based**, so none was added.
- **12S** (`{#twelve-s}`) stays in `## T`, sorted as "twelve S", which is how it was filed and how its slug spells it.

## Definitions rewritten (82 entries)

Every rewrite splits a definition at a colon or a semicolon into two sentences, or restructures the clause, and keeps the meaning. The term, the slug, and the `See also` list are unchanged in every case below.

### Allele frequency `{#allele-frequency}`

Before.

> The proportion of sequencing reads at a position that carry the alternate base. A clinical isolate usually shows allele frequencies near 0 or 1; a mixed-population sample (for example, wastewater) shows a full spectrum.

After.

> The proportion of sequencing reads at a position that carry the alternate base. A clinical isolate usually shows allele frequencies near 0 or 1. A mixed-population sample (for example, wastewater) shows a full spectrum.

### Assembly bundle `{#assembly-bundle}`

Before.

> A `.lungfishref` bundle that holds a de novo assembly produced inside the project, typically by SPAdes or MEGAHIT, and lives under the project's `Analyses/` folder alongside every other result. The internal structure is identical to a reference bundle; only the folder placement distinguishes the two. See also: reference bundle, bundle.

After.

> A `.lungfishref` bundle that holds a de novo assembly produced inside the project, typically by SPAdes or MEGAHIT, and lives under the project's `Analyses/` folder alongside every other result. The internal structure is identical to a reference bundle, and only the folder placement distinguishes the two. See also reference bundle, bundle.

### BAI `{#bai}`

Before.

> The companion index file for a BAM that lets viewers jump to a specific reference position without reading the whole file; conventionally named `<sample>.bam.bai` and kept in the same folder as the BAM. See also: BAM.

After.

> The companion index file for a BAM that lets viewers jump to a specific reference position without reading the whole file. It is conventionally named `<sample>.bam.bai` and kept in the same folder as the BAM. See also BAM.

### BAM `{#bam}`

Before.

> The binary, indexed form of the SAM alignment format, with one row per aligned read and a header listing reference contigs; Lungfish always reads and writes BAMs rather than SAMs because of size and random-access requirements. See also: BAI, alignment, CIGAR.

After.

> The binary, indexed form of the SAM alignment format, with one row per aligned read and a header listing reference contigs. Lungfish always reads and writes BAMs rather than SAMs because of size and random-access requirements. See also BAI, alignment, CIGAR.

### BAQ `{#baq}`

Before.

> Base Alignment Quality, samtools' per-base recalibration that lowers the quality of bases sitting near indel-prone regions; useful for shotgun random-fragment data and counterproductive for amplicon data, which is why Lungfish disables BAQ (`-B`) for amplicon variant calling. See also: pileup.

After.

> Base Alignment Quality, samtools' per-base recalibration that lowers the quality of bases sitting near indel-prone regions. It is useful for shotgun random-fragment data and counterproductive for amplicon data, which is why Lungfish disables BAQ (`-B`) for amplicon variant calling. See also pileup.

### Barcode `{#barcode}`

Before.

> A short oligonucleotide sequence (typically 8 to 24 bases) ligated onto a sample's reads during library prep so that pooled samples can be sorted back to their wells after multiplexed sequencing; ONT runs identify barcodes during basecalling and write one subfolder per barcode. See also: basecaller.

After.

> A short oligonucleotide sequence (typically 8 to 24 bases) ligated onto a sample's reads during library prep so that pooled samples can be sorted back to their wells after multiplexed sequencing. ONT runs identify barcodes during basecalling and write one subfolder per barcode. See also basecaller.

### BED `{#bed}`

Before.

> A plain-text table listing regions of a genome, one region per line, giving a contig name, a start coordinate, an end coordinate, and usually a name for the region; a primer scheme stores its primer positions as a BED file inside its `.lungfishprimers` bundle. See also: primer scheme, contig.

After.

> A plain-text table listing regions of a genome, one region per line, giving a contig name, a start coordinate, an end coordinate, and usually a name for the region. A primer scheme stores its primer positions as a BED file inside its `.lungfishprimers` bundle. See also primer scheme, contig.

### Basecaller `{#basecaller}`

Before.

> The program that converts a sequencer's raw signal into base-called reads with quality scores; for Oxford Nanopore data, Guppy and Dorado are the two basecallers in current use, and the model used to call a run determines which Medaka model is appropriate downstream. See also: simplex read, duplex read.

After.

> The program that converts a sequencer's raw signal into base-called reads with quality scores. For Oxford Nanopore data, Guppy and Dorado are the two basecallers in current use, and the model used to call a run sets which Medaka model is appropriate downstream. See also simplex read, duplex read.

### BioSample `{#biosample}`

Before.

> An NCBI record describing one biological sample; Lungfish can export a BioSample submission TSV from a project's sample metadata. See also: sample metadata.

After.

> An NCBI record describing one biological sample. Lungfish can export a BioSample submission TSV from a project's sample metadata. See also sample metadata.

### Bootstrap `{#bootstrap}`

Before.

> A way of measuring confidence in a phylogenetic grouping by rebuilding the tree many times from alignments resampled column by column and reporting, as a percentage, how often each grouping came back; IQ-TREE's ultrafast bootstrap is the fast approximation Lungfish Genome Explorer exposes. See also: support value, IQ-TREE, SH-aLRT.

After.

> A way of measuring confidence in a phylogenetic grouping by rebuilding the tree many times from alignments resampled column by column and reporting, as a percentage, how often each grouping came back. IQ-TREE's ultrafast bootstrap is the fast approximation Lungfish Genome Explorer exposes. See also support value, IQ-TREE, SH-aLRT.

### CDS (coding sequence) `{#cds}`

Before.

> The portion of a gene that is translated into protein; Lungfish can annotate a best-match CDS on a sequence. See also: open reading frame, reading frame.

After.

> The portion of a gene that is translated into protein. Lungfish can annotate a best-match CDS on a sequence. See also open reading frame, reading frame.

### CIGAR `{#cigar}`

Before.

> A compact string in each BAM row that describes, base by base, how the read aligns to the reference: `M` for aligned positions, `I` and `D` for insertions and deletions, `S` for soft-clipped ends, and `H` for hard-clipped ends. See also: BAM, soft-clip.

After.

> A compact string in each BAM row that describes, base by base, how the read aligns to the reference. It writes `M` for aligned positions, `I` and `D` for insertions and deletions, `S` for soft-clipped ends, and `H` for hard-clipped ends. See also BAM, soft-clip.

### Circular consensus sequencing (CCS) `{#circular-consensus-sequencing}`

Before.

> The PacBio protocol that circularises a DNA fragment, reads it repeatedly, and reports the consensus of those passes as one read, which is why HiFi reads carry both long lengths and Q30+ quality strings; a HiFi read's quality is a consensus confidence, not a raw signal measurement. See also: read length, Phred score.

After.

> The PacBio protocol that circularises a DNA fragment, reads it repeatedly, and reports the consensus of those passes as one read, which is why HiFi reads carry both long lengths and Q30+ quality strings. A HiFi read's quality is a consensus confidence, not a raw signal measurement. See also read length, Phred score.

### Clade `{#clade}`

Before.

> A group on a phylogenetic tree consisting of one internal node and every tip descended from it; the unit a phylogeneticist points to when claiming "these isolates share a recent common ancestor". See also: phylogram.

After.

> A group on a phylogenetic tree consisting of one internal node and every tip descended from it. It is the unit a phylogeneticist points to when claiming "these isolates share a recent common ancestor". See also phylogram.

### Cladogram `{#cladogram}`

Before.

> A phylogenetic tree drawn with every tip at the same depth so that only the branching order is shown and branch lengths carry no meaning; one of the two layouts the Lungfish Genome Explorer tree viewport offers, useful when one very long branch would otherwise squash the rest. See also: phylogram, topology, clade.

After.

> A phylogenetic tree drawn with every tip at the same depth so that only the branching order is shown and branch lengths carry no meaning. It is one of the two layouts the Lungfish Genome Explorer tree viewport offers, useful when one very long branch would otherwise squash the rest. See also phylogram, topology, clade.

### Clair3 `{#clair3}`

Before.

> A deep-learning variant caller for Oxford Nanopore reads, run in Lungfish as an alternative to Medaka for ONT variant calling; it reads the sorted BAM directly and takes a model path matched to the basecaller. See also: variant-caller, Medaka.

After.

> A deep-learning variant caller for Oxford Nanopore reads, run in Lungfish as an alternative to Medaka for ONT variant calling. It reads the sorted BAM directly and takes a model path matched to the basecaller. See also variant-caller, Medaka.

### Codon `{#codon}`

Before.

> A run of three consecutive bases inside a protein-coding gene that together encode one amino acid. Three adjacent SNPs falling inside one codon describe one amino acid change, not three; iVar can group them into a single VCF row when given a GFF annotation. See also: VCF.

After.

> A run of three consecutive bases inside a protein-coding gene that together encode one amino acid. Three adjacent SNPs falling inside one codon describe one amino acid change, not three. iVar can group them into a single VCF row when given a GFF annotation. See also VCF.

### Consensus FASTA `{#consensus-fasta}`

Before.

> The reference sequence with high-confidence sample variants applied in place; positions with insufficient evidence are masked as `N`. The format Pangolin and Nextclade expect for SARS-CoV-2 lineage assignment, and the format used for GISAID and NCBI surveillance submissions. See also: VCF, allele frequency.

After.

> The reference sequence with high-confidence sample variants applied in place, where positions with insufficient evidence are masked as `N`. The format Pangolin and Nextclade expect for SARS-CoV-2 lineage assignment, and the format used for GISAID and NCBI surveillance submissions. See also VCF, allele frequency.

### Contig `{#contig}`

Before.

> A contiguous stretch of assembled sequence emitted by an assembler, representing the longest path through the assembly graph that the algorithm could resolve unambiguously; one assembly bundle holds many contigs, ranked by length in the assembly viewport. See also: assembly bundle, N50.

After.

> A contiguous stretch of assembled sequence emitted by an assembler, representing the longest path through the assembly graph that the algorithm could resolve unambiguously. One assembly bundle holds many contigs, ranked by length in the assembly viewport. See also assembly bundle, N50.

### Contig (in a reference) `{#contig-reference}`

Before.

> One named sequence in a multi-record FASTA; in `.lungfishref` bundles the contig list comes from FASTA headers and matches the BAM, VCF, and GFF3 contig fields.

After.

> One named sequence in a multi-record FASTA. In `.lungfishref` bundles the contig list comes from FASTA headers and matches the BAM, VCF, and GFF3 contig fields.

### Coordinate `{#coordinate}`

Before.

> A 1-based position on a reference, named as `chrom:position` (for example, `MN908947.3:21618`). Lungfish presents 1-based inclusive coordinates to the user everywhere; underlying file formats may use 0-based half-open (BED) or 1-based inclusive (VCF, GFF3, SAM/BAM displayed). See also: chromosome.

After.

> A 1-based position on a reference, named as `chrom:position` (for example, `MN908947.3:21618`). Lungfish presents 1-based inclusive coordinates to the user everywhere. Underlying file formats may use 0-based half-open (BED) or 1-based inclusive (VCF, GFF3, SAM/BAM displayed). See also chromosome.

### Coverage `{#coverage}`

Before.

> The number of reads that align across a given reference position; used interchangeably with depth in this manual. See also: pileup.

After.

> The number of reads that align across a given reference position, used interchangeably with depth in this manual. See also pileup.

### Ct (cycle threshold) `{#ct}`

Before.

> The qPCR cycle number at which a sample's amplification signal crosses the detection threshold; a lower Ct means more starting template, so for a viral diagnostic a low Ct predicts a higher viral fraction in the sequencing reads and a smaller host-removal rate.

After.

> The qPCR cycle number at which a sample's amplification signal crosses the detection threshold. A lower Ct means more starting template, so for a viral diagnostic a low Ct predicts a higher viral fraction in the sequencing reads and a smaller host-removal rate.

### Duplex read `{#duplex-read}`

Before.

> An Oxford Nanopore read produced by basecalling both strands of the same DNA molecule and reconciling them into a single high-accuracy consensus; duplex Q30+ approximates Illumina-grade accuracy and is the basis for modern Medaka-duplex models. See also: simplex read, basecaller.

After.

> An Oxford Nanopore read produced by basecalling both strands of the same DNA molecule and reconciling them into a single high-accuracy consensus. Duplex Q30+ approximates Illumina-grade accuracy and is the basis for modern Medaka-duplex models. See also simplex read, basecaller.

### E-value `{#e-value}`

Before.

> The number of database alignments of equal or better score expected by chance for a given query length and database size; in BLAST results, smaller is better, with values at or below `1e-30` indicating an essentially unmistakable match for a typical viral read. See also: BLAST, percent identity.

After.

> The number of database alignments of equal or better score expected by chance for a given query length and database size. In BLAST results, smaller is better, with values at or below `1e-30` indicating an essentially unmistakable match for a typical viral read. See also BLAST, percent identity.

### ENA (European Nucleotide Archive) `{#ena}`

Before.

> The European mirror of the SRA, hosted at EMBL-EBI; one of three INSDC partners (with NCBI SRA and DDBJ) that share deposited sequencing data. Lungfish downloads SRA runs from ENA first because ENA serves pre-converted FASTQs directly, and falls back to the NCBI SRA Toolkit when ENA is unavailable. See also: SRA.

After.

> The European mirror of the SRA, hosted at EMBL-EBI, and one of three INSDC partners (with NCBI SRA and DDBJ) that share deposited sequencing data. Lungfish downloads SRA runs from ENA first because ENA serves pre-converted FASTQs directly, and falls back to the NCBI SRA Toolkit when ENA is unavailable. See also SRA.

### Error correction `{#error-correction}`

Before.

> A stage some assemblers run before building their graph, in which reads are compared against each other and a base that only one read carries where its neighbours agree on another is rewritten, on the reasoning that a base seen once is more likely a sequencing mistake than a real difference; SPAdes runs it by default and the assembly sheet's Skip error correction toggle turns it off. See also: de Bruijn graph, de novo assembly, read.

After.

> A stage some assemblers run before building their graph, in which reads are compared against each other and a base that only one read carries where its neighbours agree on another is rewritten, on the reasoning that a base seen once is more likely a sequencing mistake than a real difference. SPAdes runs it by default and the assembly sheet's Skip error correction toggle turns it off. See also de Bruijn graph, de novo assembly, read.

### FAI (FASTA index) `{#fai}`

Before.

> A small text index file (typically `<sequence>.fasta.fai`) produced by `samtools faidx` that lets tools jump to a specific position in a FASTA without reading the whole file; required for variant calling and many other reference-keyed operations. See also: FASTA.

After.

> A small text index file (typically `<sequence>.fasta.fai`) produced by `samtools faidx` that lets tools jump to a specific position in a FASTA without reading the whole file. It is required for variant calling and many other reference-keyed operations. See also FASTA.

### FASTQ `{#fastq}`

Before.

> A plain-text format for sequencing reads, with each read taking exactly four lines: a `@`-prefixed header, the read sequence, a `+` separator, and a same-length quality string in the standard ASCII offset 33 encoding. The input format for every workflow that starts from raw sequencing data. See also: paired-end, Phred score.

After.

> A plain-text format for sequencing reads, with each read taking exactly four lines. Those lines are a `@`-prefixed header, the read sequence, a `+` separator, and a same-length quality string in the standard ASCII offset 33 encoding. The input format for every workflow that starts from raw sequencing data. See also paired-end, Phred score.

### FLAG (in a BAM) `{#flag}`

Before.

> A bitwise integer field in each BAM row encoding facts about the read in twelve canonical bits: paired, properly paired, unmapped, mate unmapped, reverse strand, mate reverse strand, first of pair, second of pair, secondary alignment, low quality, duplicate, supplementary alignment. The decoded value `99` is the sum of bits 1+2+32+64. See also: BAM, supplementary alignment.

After.

> A bitwise integer field in each BAM row encoding facts about the read in twelve canonical bits. Those bits are paired, properly paired, unmapped, mate unmapped, reverse strand, mate reverse strand, first of pair, second of pair, secondary alignment, low quality, duplicate, and supplementary alignment. The decoded value `99` is the sum of bits 1+2+32+64. See also BAM, supplementary alignment.

### Genetic code `{#genetic-code}`

Before.

> The mapping from codons to amino acids; Lungfish lets you pick the code (for example the vertebrate mitochondrial code) when translating a sequence. See also: codon, reading frame.

After.

> The mapping from codons to amino acids. Lungfish lets you pick the code (for example the vertebrate mitochondrial code) when translating a sequence. See also codon, reading frame.

### GenomicsDB `{#genomicsdb}`

Before.

> GATK's on-disk multi-sample variant store that scales joint genotyping to large cohorts better than a single combined GVCF; Lungfish builds one with `GenomicsDBImport` when a cohort exceeds 50 samples. See also: GVCF, joint genotyping.

After.

> GATK's on-disk multi-sample variant store that scales joint genotyping to large cohorts better than a single combined GVCF. Lungfish builds one with `GenomicsDBImport` when a cohort exceeds 50 samples. See also GVCF, joint genotyping.

### GFA (Graphical Fragment Assembly) `{#gfa}`

Before.

> A tab-separated text format for assembly graphs in which each `S` line carries one sequence segment and each `L` line records an overlap between two segments, so a GFA holds the branching structure an assembler resolved rather than only the sequences it emitted; hifiasm writes its assembly as GFA rather than FASTA, and Lungfish Genome Explorer converts the primary contig graph to FASTA before the assembly viewport can list it. See also: assembly graph, contig, unitig.

After.

> A tab-separated text format for assembly graphs in which each `S` line carries one sequence segment and each `L` line records an overlap between two segments, so a GFA holds the branching structure an assembler resolved rather than only the sequences it emitted. hifiasm writes its assembly as GFA rather than FASTA, and Lungfish Genome Explorer converts the primary contig graph to FASTA before the assembly viewport can list it. See also assembly graph, contig, unitig.

### GFF (General Feature Format) `{#gff}`

Before.

> A tab-separated table format for genomic features (genes, CDS, mature peptides, regulatory elements). GFF3 is the current spec; Lungfish accepts GFF3 paired with a FASTA at bundle creation. See also: FASTA, reference bundle.

After.

> A tab-separated table format for genomic features (genes, CDS, mature peptides, regulatory elements). GFF3 is the current spec. Lungfish accepts GFF3 paired with a FASTA at bundle creation. See also FASTA, reference bundle.

### GVCF (genomic VCF) `{#gvcf}`

Before.

> A VCF variant that records, at every position rather than only at variant sites, the confidence that the sample matches the reference, so per-sample GVCFs can later be combined and genotyped together; the form GATK HaplotypeCaller emits by default in Lungfish. See also: VCF, joint genotyping, GenomicsDB.

After.

> A VCF variant that records, at every position rather than only at variant sites, the confidence that the sample matches the reference, so per-sample GVCFs can later be combined and genotyped together. It is the form GATK HaplotypeCaller emits by default in Lungfish. See also VCF, joint genotyping, GenomicsDB.

### Haplotype `{#haplotype}`

Before.

> A set of alleles across linked loci that are inherited together as one block, because the loci sit close enough on a chromosome that they rarely separate; a genotyping run observes alleles rather than haplotypes, so a haplotype call is an interpretation built on top of the allele calls. See also: allele, MHC, locus.

After.

> A set of alleles across linked loci that are inherited together as one block, because the loci sit close enough on a chromosome that they rarely separate. A genotyping run observes alleles rather than haplotypes, so a haplotype call is an interpretation built on top of the allele calls. See also allele, MHC, locus.

### Immunogenetics `{#immunogenetics}`

Before.

> The study of genetic variation in immune-system loci such as the MHC; the domain of Lungfish's amplicon genotyping feature. See also: MHC.

After.

> The study of genetic variation in immune-system loci such as the MHC, and the domain of Lungfish's amplicon genotyping feature. See also MHC.

### INSDC (International Nucleotide Sequence Database Collaboration) `{#insdc}`

Before.

> The three-way partnership of NCBI (USA), EMBL-EBI (Europe), and DDBJ (Japan) that mirrors deposited nucleotide sequences and assigns a single globally-unique accession to each record; ENA, NCBI SRA, and DDBJ Sequence Read Archive are the SRA tier of this partnership. See also: ENA, SRA.

After.

> The three-way partnership of NCBI (USA), EMBL-EBI (Europe), and DDBJ (Japan) that mirrors deposited nucleotide sequences and assigns a single globally-unique accession to each record. ENA, NCBI SRA, and DDBJ Sequence Read Archive are the SRA tier of this partnership. See also ENA, SRA.

### Insert size `{#insert-size}`

Before.

> The length of the original DNA fragment that a paired-end read pair came from, measured end to end including both reads; when the insert is shorter than twice the read length the two mates overlap and can be merged. See also: paired-end, read length.

After.

> The length of the original DNA fragment that a paired-end read pair came from, measured end to end including both reads. When the insert is shorter than twice the read length the two mates overlap and can be merged. See also paired-end, read length.

### Internal node `{#internal-node}`

Before.

> Any point on a phylogenetic tree where branches meet, standing for an inferred common ancestor that was never sequenced and no longer exists; a tree of five tips can hold at most three of them. See also: tip, clade, topology.

After.

> Any point on a phylogenetic tree where branches meet, standing for an inferred common ancestor that was never sequenced and no longer exists. A tree of five tips can hold at most three of them. See also tip, clade, topology.

### IUPAC ambiguity code `{#iupac-ambiguity-code}`

Before.

> A single letter standing for two or more possible bases at one position, defined by the International Union of Pure and Applied Chemistry so that uncertainty can be written inside a sequence rather than alongside it; `R` means A or G, `Y` means C or T, `M` means A or C, `K` means G or T, `S` means C or G, `W` means A or T, and `N` means any base at all. See also: consensus sequence, consensus FASTA, pileup.

After.

> A single letter standing for two or more possible bases at one position, defined by the International Union of Pure and Applied Chemistry so that uncertainty can be written inside a sequence rather than alongside it. `R` means A or G, `Y` means C or T, `M` means A or C, `K` means G or T, `S` means C or G, `W` means A or T, and `N` means any base at all. See also consensus sequence, consensus FASTA, pileup.

### Joint genotyping `{#joint-genotyping}`

Before.

> The GATK step that calls genotypes across a whole cohort at once by combining per-sample GVCFs and running `GenotypeGVCFs`, rather than genotyping each sample in isolation; run in Lungfish through `lungfish gatk joint-genotype`. See also: GVCF, GenomicsDB.

After.

> The GATK step that calls genotypes across a whole cohort at once by combining per-sample GVCFs and running `GenotypeGVCFs`, rather than genotyping each sample in isolation, run in Lungfish through `lungfish gatk joint-genotype`. See also GVCF, GenomicsDB.

### LabKey `{#labkey}`

Before.

> A laboratory data management platform; Lungfish can export genotype results as LabKey-ready CSV files.

After.

> A laboratory data management platform. Lungfish can export genotype results as LabKey-ready CSV files.

### Locus `{#locus}`

Before.

> The place on a chromosome where one particular gene sits, so that the alternative sequences a population carries at that place are its alleles; MHC genotyping reports one group of calls per locus, and which loci appear depends on the allele library a run used. See also: allele, MHC, allele target.

After.

> The place on a chromosome where one particular gene sits, so that the alternative sequences a population carries at that place are its alleles. MHC genotyping reports one group of calls per locus, and which loci appear depends on the allele library a run used. See also allele, MHC, allele target.

### Mapper `{#mapper}`

Before.

> A program that places sequencing reads onto a reference genome and emits an alignment file (BAM); Lungfish ships minimap2, BWA-MEM2, Bowtie2, and BBMap. See also: alignment, mapping.

After.

> A program that places sequencing reads onto a reference genome and emits an alignment file (BAM). Lungfish ships minimap2, BWA-MEM2, Bowtie2, and BBMap. See also alignment, mapping.

### MAPQ (mapping quality) `{#mapq}`

Before.

> A per-read confidence score in each BAM row, encoding how unambiguously the mapper placed the read at the recorded position; 0 means no confidence (the read fits multiple places equally well), 60 is the maximum for most mappers and means the placement is well above the second-best alternative. See also: BAM, mapper.

After.

> A per-read confidence score in each BAM row, encoding how unambiguously the mapper placed the read at the recorded position. A value of 0 means no confidence (the read fits multiple places equally well), 60 is the maximum for most mappers and means the placement is well above the second-best alternative. See also BAM, mapper.

### Minimizer `{#minimizer}`

Before.

> The smallest k-mer within a sliding window of a sequence, picked as a compact fingerprint so a tool can match reads quickly without comparing every base; Kraken2 classifies on minimizers and Deacon counts minimizer hits to flag host reads. See also: Kraken2, Deacon.

After.

> The smallest k-mer within a sliding window of a sequence, picked as a compact fingerprint so a tool can match reads quickly without comparing every base. Kraken 2 classifies on minimizers and Deacon counts minimizer hits to flag host reads. See also Kraken 2, Deacon.

### MSA (Multiple Sequence Alignment) `{#msa}`

Before.

> A rectangular arrangement of two or more related sequences in which each column represents an inferred homologous position, with `-` gap characters padding insertions; in Lungfish stored as a `.lungfishmsa` bundle. See also: MAFFT.

After.

> A rectangular arrangement of two or more related sequences in which each column represents an inferred homologous position, with `-` gap characters padding insertions. Lungfish stores one as a `.lungfishmsa` bundle. See also MAFFT.

### N50 `{#n50}`

Before.

> A summary statistic for a set of assembled contigs: the length such that contigs of at least that length together hold half of the assembly's total bases; a higher N50 indicates a less fragmented assembly. See also: contig, assembly bundle.

After.

> A summary statistic for a set of assembled contigs, giving the length such that contigs of at least that length together hold half of the assembly's total bases. A higher N50 means a less fragmented assembly. See also contig, assembly bundle.

### Newick `{#newick}`

Before.

> A compact parenthesised text format for phylogenetic trees, with branch lengths after colons and optional support values at internal nodes; the lingua franca for moving trees between FigTree, iTOL, ete3, and Lungfish. See also: phylogram.

After.

> A compact parenthesised text format for phylogenetic trees, with branch lengths after colons and optional support values at internal nodes. It is the common format for moving trees between FigTree, iTOL, ete3, and Lungfish. See also phylogram.

### Nanopore sequencing `{#nanopore-sequencing}`

Before.

> The Oxford Nanopore method that reads a DNA strand by drawing it through a protein pore and measuring how the ionic current changes as each stretch of bases passes through, which puts no ceiling on read length and yields reads tens of thousands of bases long, at the cost of a per-base error rate far higher than a short-read instrument's; Flye and hifiasm both accept these reads, and Flye accepts nothing else. See also: basecaller, read length, circular consensus sequencing.

After.

> The Oxford Nanopore method that reads a DNA strand by drawing it through a protein pore and measuring how the ionic current changes as each stretch of bases passes through, which puts no ceiling on read length and yields reads tens of thousands of bases long, at the cost of a per-base error rate far higher than a short-read instrument's. Flye and hifiasm both accept these reads, and Flye accepts nothing else. See also basecaller, read length, circular consensus sequencing.

### ORF (open reading frame) `{#orf}`

Before.

> A stretch of sequence running from a start codon to an in-frame stop codon without interruption, so it could in principle encode a protein; Lungfish finds ORFs and stores them as an annotation track, but ORF length is only a weak proxy for a real gene. See also: codon.

After.

> A stretch of sequence running from a start codon to an in-frame stop codon without interruption, so it could in principle encode a protein. Lungfish finds ORFs and stores them as an annotation track, but ORF length is only a weak proxy for a real gene. See also codon.

### Paired-end `{#paired-end}`

Before.

> A sequencing protocol that reads each DNA fragment from both ends, producing two reads per fragment; the two halves of a pair travel as separate FASTQ files with `_1`/`_2` or `_R1`/`_R2` suffixes. See also: FASTQ, single-end.

After.

> A sequencing protocol that reads each DNA fragment from both ends, producing two reads per fragment. The two halves of a pair travel as separate FASTQ files with `_1`/`_2` or `_R1`/`_R2` suffixes. See also FASTQ, single-end.

### p-distance `{#p-distance}`

Before.

> The simplest genetic distance between two aligned sequences: the proportion of positions at which they differ, with no model correction. One of the distance models Lungfish's `msa distance` can compute. See also: MSA.

After.

> The simplest genetic distance between two aligned sequences, the proportion of positions at which they differ, with no model correction. One of the distance models Lungfish's `msa distance` can compute. See also MSA.

### Phred score `{#phred-score}`

Before.

> A logarithmic per-base quality value defined as `Q = -10 * log10(P)` where P is the error probability; Q20 = 1% error, Q30 = 0.1% error, Q40 = 0.01% error. Encoded in FASTQ files as ASCII characters offset by 33 (so `!` = Q0, `F` = Q37). See also: FASTQ.

After.

> A logarithmic per-base quality value defined as `Q = -10 * log10(P)` where P is the error probability. Q20 = 1% error, Q30 = 0.1% error, Q40 = 0.01% error. Encoded in FASTQ files as ASCII characters offset by 33 (so `!` = Q0, `F` = Q37). See also FASTQ.

### Phylogram `{#phylogram}`

Before.

> A phylogenetic tree drawn so that branch length is proportional to the inferred amount of evolutionary change (substitutions per site); the default tree-viewport layout in Lungfish. See also: clade, IQ-TREE.

After.

> A phylogenetic tree drawn so that branch length is proportional to the inferred amount of evolutionary change (substitutions per site). It is the default tree-viewport layout in Lungfish. See also clade, IQ-TREE.

### Percent identity `{#percent-identity}`

Before.

> In a BLAST or other pairwise alignment, the fraction of aligned positions where the query and the subject sequence agree, calculated only over the aligned region; read together with query coverage to gauge how much of the read aligned and how well. See also: BLAST, query coverage.

After.

> In a BLAST or other pairwise alignment, the fraction of aligned positions where the query and the subject sequence agree, calculated only over the aligned region. Read it together with query coverage to gauge how much of the read aligned and how well. See also BLAST, query coverage.

### Pileup `{#pileup}`

Before.

> The column of bases observed at one reference position across every read that covers it, together with their qualities and strands; the unit of evidence a variant caller weighs at each position. See also: coverage, variant-caller.

After.

> The column of bases observed at one reference position across every read that covers it, together with their qualities and strands. It is the unit of evidence a variant caller weighs at each position. See also coverage, variant-caller.

### Primer `{#primer}`

Before.

> A short oligonucleotide, typically 18 to 30 bases, that binds a specific position on a target genome and primes DNA synthesis from that position; the building block of every amplicon protocol. See also: amplicon, primer scheme.

After.

> A short oligonucleotide, typically 18 to 30 bases, that binds a specific position on a target genome and primes DNA synthesis from that position. It is the building block of every amplicon protocol. See also amplicon, primer scheme.

### Quality binning `{#quality-binning}`

Before.

> The lossy compression step that rounds each base's Phred score to one of a small set of values before the reads are stored, offered by Lungfish at import as Illumina 4-level, 8-level, or None; Illumina instruments from the NovaSeq onward already report binned scores in hardware, so binning such a run discards little that was not already lost. See also: Phred score, FASTQ.

After.

> The lossy compression step that rounds each base's Phred score to one of a small set of values before the reads are stored, offered by Lungfish at import as Illumina 4-level, 8-level, or None. Illumina instruments from the NovaSeq onward already report binned scores in hardware, so binning such a run discards little that was not already lost. See also Phred score, FASTQ.

### Query coverage `{#query-coverage}`

Before.

> In a BLAST result, the fraction of the query sequence that participated in the alignment to the subject; a high percent identity over only a fraction of the read is much weaker evidence than a moderate identity over most of the read. See also: BLAST, percent identity.

After.

> In a BLAST result, the fraction of the query sequence that participated in the alignment to the subject. A high percent identity over only a fraction of the read is much weaker evidence than a moderate identity over most of the read. See also BLAST, percent identity.

### Read clumping `{#read-clumping}`

Before.

> The reordering of a read file so that reads sharing sequence content sit next to each other, which lets a general-purpose compressor find far more repetition and shrink the stored file; Lungfish applies it at import as the "Optimize storage" option, using BBTools clumpify or Trim Galore, and the reordering means the stored bundle no longer matches the source file's read order. See also: FASTQ.

After.

> The reordering of a read file so that reads sharing sequence content sit next to each other, which lets a general-purpose compressor find far more repetition and shrink the stored file. Lungfish applies it at import as the "Optimize storage" option, using BBTools clumpify or Trim Galore, and the reordering means the stored bundle no longer matches the source file's read order. See also FASTQ.

### Read length `{#read-length}`

Before.

> The number of bases in a sequencing read; Illumina reads are typically 75-300 bp (fixed per run), Oxford Nanopore reads range from 1 kb to 100 kb (variable per run with mean 5-15 kb), PacBio HiFi reads are 10-25 kb. See also: FASTQ.

After.

> The number of bases in a sequencing read. Illumina reads are typically 75-300 bp (fixed per run), Oxford Nanopore reads range from 1 kb to 100 kb (variable per run with mean 5-15 kb), PacBio HiFi reads are 10-25 kb. See also FASTQ.

### Reference genome `{#reference-genome}`

Before.

> A specific, community-agreed sequence used as the comparison point for samples; for SARS-CoV-2 the standard reference is `MN908947.3` (the Wuhan-Hu-1 isolate). Variants are described relative to a chosen reference, so reference choice affects which variants are reported and at what positions. See also: reference bundle.

After.

> A specific, community-agreed sequence used as the comparison point for samples. For SARS-CoV-2 the standard reference is `MN908947.3` (the Wuhan-Hu-1 isolate). Variants are described relative to a chosen reference, so reference choice affects which variants are reported and at what positions. See also reference bundle.

### REF, ALT `{#ref-alt}`

Before.

> REF is the base or bases present in the reference genome at a variant position; ALT is the base or bases observed in the sample. A one-base REF and one-base ALT describe a SNP; longer REF or ALT describe insertions and deletions.

After.

> REF is the base or bases present in the reference genome at a variant position. ALT is the base or bases observed in the sample. A one-base REF and one-base ALT describe a SNP. A longer REF or ALT describes an insertion or a deletion.

### Reproducibility `{#reproducibility}`

Before.

> The property that a workflow re-run with the same inputs, the same plugin pack version, and the same Lungfish build produces output that matches the original by checksum (bit-identical) or by content (logically equivalent); the provenance sidecar carries every field needed to verify this. See also: provenance sidecar.

After.

> The property that a workflow re-run with the same inputs, the same plugin pack version, and the same Lungfish build produces output that matches the original by checksum (bit-identical) or by content (logically equivalent). The provenance sidecar carries every field needed to verify this. See also provenance sidecar.

### Retained read `{#retained-read}`

Before.

> In an MHC genotyping run, a read whose alignment spanned an allele target from its first base to its last with no substitutions, indels aside, and which therefore counts towards that allele target's support; reads failing any part of that test are discarded rather than counted weakly, so the retained fraction of a run is far smaller than a mapping workflow would report. See also: allele target, genotype matrix, bbmerge.

After.

> In an MHC genotyping run, a read whose alignment spanned an allele target from its first base to its last with no substitutions, indels aside, and which therefore counts towards that allele target's support. Reads failing any part of that test are discarded rather than counted weakly, so the retained fraction of a run is far smaller than a mapping workflow would report. See also allele target, genotype matrix, bbmerge.

### Rooting `{#rooting}`

Before.

> Choosing which point on a phylogenetic tree stands for the oldest ancestor, which is what turns a statement about who groups with whom into a statement about which lineage came first; IQ-TREE produces unrooted trees, so rooting in Lungfish Genome Explorer is the separate **Re-root Here** step. See also: outgroup, topology, internal node.

After.

> Choosing which point on a phylogenetic tree stands for the oldest ancestor, which is what turns a statement about who groups with whom into a statement about which lineage came first. IQ-TREE produces unrooted trees, so rooting in Lungfish Genome Explorer is the separate **Re-root Here** step. See also outgroup, topology, internal node.

### Sample sheet `{#sample-sheet}`

Before.

> A CSV listing one sequencing sample per row with the sample's name and the paths to its read files, used at import to pair reads and name bundles explicitly instead of matching mate suffixes in filenames; Lungfish requires the columns `sample`, `r1`, and `r2`, and carries any further columns through as per-sample metadata. See also: sample metadata, paired-end.

After.

> A CSV listing one sequencing sample per row with the sample's name and the paths to its read files, used at import to pair reads and name bundles explicitly instead of matching mate suffixes in filenames. Lungfish requires the columns `sample`, `r1`, and `r2`, and carries any further columns through as per-sample metadata. See also sample metadata, paired-end.

### SH-aLRT `{#sh-alrt}`

Before.

> The Shimodaira-Hasegawa approximate likelihood ratio test, a fast branch-support measure IQ-TREE reports as a percentage at each internal node; read alongside bootstrap support, with values at or above 80 treated as reliable. See also: support value, IQ-TREE.

After.

> The Shimodaira-Hasegawa approximate likelihood ratio test, a fast branch-support measure IQ-TREE reports as a percentage at each internal node. Read it alongside bootstrap support, with values at or above 80 treated as reliable. See also support value, IQ-TREE.

### Shotgun sequencing `{#shotgun}`

Before.

> A library preparation strategy in which sample nucleic acid is fragmented at random and sequenced without targeted amplification; each read lands at an essentially arbitrary position on the genome. Shotgun data does not require primer trimming. See also: amplicon.

After.

> A library preparation strategy in which sample nucleic acid is fragmented at random and sequenced without targeted amplification. Each read lands at an essentially arbitrary position on the genome. Shotgun data does not require primer trimming. See also amplicon.

### Simplex read `{#simplex-read}`

Before.

> An Oxford Nanopore read produced by basecalling one strand of a DNA molecule passing through a pore once; modern R10.4.1 simplex with super-accuracy basecallers achieves Q20+ per-base quality. See also: duplex read, basecaller.

After.

> An Oxford Nanopore read produced by basecalling one strand of a DNA molecule passing through a pore once. Modern R10.4.1 simplex with super-accuracy basecallers achieves Q20+ per-base quality. See also duplex read, basecaller.

### Single-end `{#single-end}`

Before.

> A sequencing protocol that reads each DNA fragment from one end only, producing one FASTQ file per sample; common for Oxford Nanopore and for some Illumina shotgun protocols. See also: FASTQ, paired-end.

After.

> A sequencing protocol that reads each DNA fragment from one end only, producing one FASTQ file per sample, and common for Oxford Nanopore and for some Illumina shotgun protocols. See also FASTQ, paired-end.

### Soft-clip `{#soft-clip}`

Before.

> A flag in a BAM record (the `S` letter in a CIGAR string) marking bases at the start or end of a read that are present in the record but excluded from pileup, coverage, and variant calling; primer trimming works by soft-clipping primer-derived bases rather than deleting them. In 12S amplicon matching the word names the same shape of thing without a BAM, the read's own bases hanging past each end of the matched reference stretch, which the Min Soft Clip setting counts to reject reads that only graze the target instead of containing it. See also: primer trim, CIGAR, 12S.

After.

> A flag in a BAM record (the `S` letter in a CIGAR string) marking bases at the start or end of a read that are present in the record but excluded from pileup, coverage, and variant calling. Primer trimming works by soft-clipping primer-derived bases rather than deleting them. In 12S amplicon matching the word names the same shape of thing without a BAM, the read's own bases hanging past each end of the matched reference stretch, which the Min Soft Clip setting counts to reject reads that only graze the target instead of containing it. See also primer trim, CIGAR, 12S.

### Strand `{#strand}`

Before.

> Whether a read aligned to the reference as sequenced (forward) or as its reverse complement (reverse); recorded as a flag bit in every BAM row. See also: strand bias.

After.

> Whether a read aligned to the reference as sequenced (forward) or as its reverse complement (reverse), recorded as a flag bit in every BAM row. See also strand bias.

### Strand bias `{#strand-bias}`

Before.

> A pattern where reads supporting a variant come predominantly from one strand of the reference, often as an artifact of primer placement in amplicon protocols rather than a genuine biological signal. Variant callers apply a strand-bias filter to flag suspect calls; for amplicon data the filter is usually disabled because the imbalance is structural. See also: amplicon.

After.

> A pattern where reads supporting a variant come predominantly from one strand of the reference, often as an artifact of primer placement in amplicon protocols rather than a genuine biological signal. Variant callers apply a strand-bias filter to flag suspect calls. For amplicon data the filter is usually disabled because the imbalance is structural. See also amplicon.

### Substitution model `{#substitution-model}`

Before.

> The set of assumed rates at which one base or residue changes into another, which a maximum-likelihood method needs before it can score a tree; IQ-TREE's default `MFP` setting is an instruction to test many models and use the best-fitting one rather than a model itself. See also: maximum likelihood, IQ-TREE.

After.

> The set of assumed rates at which one base or residue changes into another, which a maximum-likelihood method needs before it can score a tree. IQ-TREE's default `MFP` setting is an instruction to test many models and use the best-fitting one rather than a model itself. See also maximum likelihood, IQ-TREE.

### Supplementary alignment `{#supplementary-alignment}`

Before.

> A secondary record for a read that maps in pieces (split-read or chimeric alignment), with the full read mapped at the primary position and supplementary records covering the other pieces; flag bit 2048 marks supplementary alignments. See also: BAM, FLAG.

After.

> A secondary record for a read that maps in pieces (split-read or chimeric alignment), with the full read mapped at the primary position and supplementary records covering the other pieces. Flag bit 2048 marks supplementary alignments. See also BAM, FLAG.

### Support value `{#support-value}`

Before.

> A number annotated at an internal node of a phylogenetic tree giving the percentage of bootstrap or replicate trees that recovered that exact split; values above 95 indicate a well-supported clade and values below 70 should not be relied on. See also: IQ-TREE, phylogram.

After.

> A number annotated at an internal node of a phylogenetic tree giving the percentage of bootstrap or replicate trees that recovered that exact split. Values above 95 indicate a well-supported clade and values below 70 should not be relied on. See also IQ-TREE, phylogram.

### Topology `{#topology}`

Before.

> The branching pattern of a phylogenetic tree, meaning which tips group with which and in what order, considered apart from the branch lengths; it is the tree's main claim and the part a support value measures confidence in. See also: tip, internal node, support value, branch length.

After.

> The branching pattern of a phylogenetic tree, meaning which tips group with which and in what order, considered apart from the branch lengths. It is the tree's main claim and the part a support value measures confidence in. See also tip, internal node, support value, branch length.

### 12S `{#twelve-s}`

Before.

> A short mitochondrial 12S rRNA amplicon used to identify vertebrate species; Lungfish matches merged 12S reads exactly against a deduplicated reference FASTA. See also: metabarcoding.

After.

> A short mitochondrial 12S rRNA amplicon used to identify vertebrate species. Lungfish matches merged 12S reads exactly against a deduplicated reference FASTA. See also metabarcoding.

### Unitig `{#unitig}`

Before.

> A stretch of sequence that every read covering it agrees on and that the assembly graph joins to its neighbours in only one way, so it is the longest piece an assembler can emit without making a choice; contigs are then built by choosing paths that link unitigs together, which is why an assembler's unitig graph is more fragmented and more trustworthy than its contig set. See also: assembly graph, contig, GFA.

After.

> A stretch of sequence that every read covering it agrees on and that the assembly graph joins to its neighbours in only one way, so it is the longest piece an assembler can emit without making a choice. Contigs are then built by choosing paths that link unitigs together, which is why an assembler's unitig graph is more fragmented and more trustworthy than its contig set. See also assembly graph, contig, GFA.

## Trailer-only edits (355 entries)

These 355 entries had no other problem. The single change is `See also:` to `See also`, dropping the banned colon. Nothing else in the definition moved.

Slugs, in file order.

`absolute-path`, `accession`, `adapter`, `advisory-lock`, `api-access`, `api-key`
`alu-element`, `alias-map`, `alias-table`, `alignment`, `alignment-column`, `alignment-track`
`allele`, `allele-depth`, `allele-specific-annotation`, `alternate-read`, `allele-target`, `amplicon-dropout`
`annotation-track`, `argument`, `argv`, `assembler`, `assembly-graph`, `audit-log`
`barcode-kit`, `barcode-scout`, `bbmerge`, `bcf`, `benchmark-vcf`, `bbduk`
`bcftools`, `bgzip`, `bigbed`, `bigwig`, `bedgraph`, `bit-score`
`blast`, `bqsr`, `boolean`, `bracken`, `branch-length`, `bundle`
`bundle-migration`, `byte-offset`, `cdna`, `checksum`, `checkout`, `call`
`canonical-accession`, `camel-case`, `capped-database`, `cache`, `chimera`, `chord`
`citation`, `clade-count`, `classifier`, `clumpify`, `clustering`, `command-line-flag`
`cohort`, `commit`, `combinegvcfs`, `conda`, `consensus-sequence`, `class-i-mhc`
`class-ii-mhc`, `consequence`, `conservation`, `container`, `continuous-integration`, `coverage-breadth`
`cram`, `csi`, `csv`, `cutadapt`, `cz-id`, `de-bruijn-graph`
`de-novo-assembly`, `deacon`, `deduplicated-reference`, `demultiplex`, `demixing`, `dependency-set`
`depth`, `derived-bundle`, `determinism`, `dbsnp`, `dialog`, `directed-acyclic-graph`
`docker`, `doi`, `download-center`, `duplicate-rate`, `edit-distance`, `environment-variable`
`equivalent-accession`, `esviritu`, `executable`, `exit-status`, `embl`, `exon`
`extraction`, `failure-report`, `fasta`, `fastp`, `filter`, `filter-profile`
`fixture`, `format`, `flagstat`, `fluidigm-sample-barcode`, `format-registry`, `freyja`
`gap`, `glob`, `gc-content`, `genbank`, `genotype`, `genotypegvcfs`
`genotype-matrix`, `genotype-quality`, `genotype-result-bundle`, `germline`, `grounded-answer`, `gtf`
`hamming-distance`, `half-open`, `haplogroup`, `hard-filter`, `heterozygous`, `hg002`
`home-folder`, `homologous`, `homopolymer`, `homozygous`, `host-name`, `host-depletion`
`import-center`, `info`, `indel`, `inspector`, `interleaved-fastq`, `interval-list`
`ipd-mhc`, `iqtree`, `ivar`, `json`, `k-mer`, `keychain`
`key-equivalent`, `kilobase`, `kraken2`, `known-sites`, `kreport`, `l50`
`left-alignment`, `lens`, `library-prep`, `library-layout`, `library-strategy`, `lofreq`
`lineage`, `lineage-barcode`, `linkage`, `local-reassembly`, `long-format`, `lowest-common-ancestor`
`mafft`, `mapping`, `materialization`, `managed-environment`, `manifest`, `mapping-preset`
`mapping-quality`, `mark-duplicates`, `maximum-likelihood`, `medaka`, `metabarcoding`, `metadata`
`metagenomics`, `methods-export`, `mcm`, `mhc`, `micromamba`, `mitochondrial-genome`
`minibam`, `minimap2`, `minknow`, `miseq`, `mosdepth`, `modifier-key`
`mpileup`, `multi-allelic`, `multiqc`, `nao-mgs`, `ncbi`, `negative-control`
`nextflow`, `nf-core`, `node-port`, `novel-variant`, `nt-database`, `nvd`
`oci-layout`, `offline-pack`, `ont`, `open-reading-frame`, `operations-panel`, `optical-duplicate`
`orient-reads`, `outgroup`, `override`, `pcr`, `pcr-duplicate`, `pangenome`
`path`, `pbaa`, `pha4ge`, `phase`, `phase-set`, `phix`
`picard`, `pipeline`, `pinned`, `pivot-workbook`, `plate-map`, `ploidy`
`plugin-pack`, `positional-argument`, `post-install-hook`, `primary-alignment`, `preprint`, `primer-pool`
`primer-scheme`, `primer-trim`, `process`, `process-id`, `project`, `project-lock`
`project-store`, `properly-paired`, `provenance`, `provenance-sidecar`, `provider-fallback`, `push`
`quality-by-depth`, `quality-control`, `read`, `read-classification`, `read-backed-phasing`, `read-group`
`read-identifier`, `read-merging`, `read-orientation`, `reading-frame`, `reads-per-billion`, `reads-per-million`
`regular-expression`, `recalibration-table`, `reference-manager`, `reference-bundle`, `refseq`, `refseqgene`
`rpkmf`, `repeat-masking`, `report-slot`, `representative-read`, `required-setup-pack`, `repository`
`reverse-complement`, `residual`, `ribosomal-rna`, `rid`, `run-accession`, `run-bundle`
`run-record`, `runner`, `sam`, `shearing`, `shell`, `sample-metadata`
`samplesheet`, `samtools`, `savont`, `scaffold`, `schema-version`, `seqkit`
`secondary-alignment`, `sequence-dictionary`, `sequence-motif`, `sequence-viewport`, `shannon-entropy`, `sidebar`
`singleton-read`, `sliding-window-trimming`, `smart-cohort`, `smart-filter-token`, `snake-case`, `snakemake`
`snv`, `sparkline`, `spike-in-control`, `spliced-feature`, `sra`, `stale-lock`
`stderr`, `standard-error`, `sublineage`, `subcommand`, `subsampling`, `strand-odds-ratio`
`structural-variation`, `switch`, `symlink`, `tabix`, `tarball`, `tass-score`
`table-drawer`, `target-enrichment`, `taxon`, `taxon-report`, `taxonomic-rank`, `taxonomy-id`
`taxtriage`, `thread`, `tiling`, `tip`, `tool-lock-manifest`, `transformer`
`transition-transversion-ratio`, `tsv`, `two-bit`, `umi`, `unclassified-reads`, `variable-site`
`variant-caller`, `variant-only-bundle`, `variant-track`, `vcf`, `viewport`, `vsearch`
`virtual-bundle`, `wall-time`, `wastewater-surveillance`, `workflow-bundle`, `workflow-engine`, `workflow-lineage`
`workflow-package`, `workflow-library`, `working-directory`, `wrapper`, `xlsx`, `yaml`
`zero-based`

## Reordering (218 entries at a new position, across 21 sections)

Each letter section is now sorted letter by letter, ignoring case, punctuation, and any parenthetical gloss. The C and S blocks were the worst, as expected, and **Workflow Library** was indeed out of place in W. Sixty-two entries were genuinely misfiled. The rest of the count is the entries that shifted by one or two places to let those sixty-two land correctly. No slug changed and no entry left its letter section.

| Term | Section | Was position | Now position |
| --- | --- | --- | --- |
| API access | A | 6 | 21 |
| API key | A | 7 | 22 |
| Alu element | A | 8 | 17 |
| Alias map | A | 9 | 6 |
| Alias table | A | 10 | 7 |
| Alignment | A | 11 | 8 |
| Alignment column | A | 12 | 9 |
| Alignment track | A | 13 | 10 |
| Allele | A | 14 | 11 |
| Allele depth | A | 15 | 12 |
| Allele frequency | A | 16 | 13 |
| Allele-specific annotation | A | 17 | 15 |
| Alternate read | A | 18 | 16 |
| Allele target | A | 19 | 14 |
| Amplicon | A | 20 | 18 |
| Amplicon dropout | A | 21 | 19 |
| Annotation track | A | 22 | 20 |
| bbmerge | B | 7 | 9 |
| BCF | B | 8 | 10 |
| BED | B | 9 | 12 |
| Benchmark VCF | B | 10 | 14 |
| Basecaller | B | 11 | 7 |
| bbduk | B | 12 | 8 |
| bcftools | B | 13 | 11 |
| bgzip | B | 14 | 15 |
| BigBed | B | 15 | 16 |
| BigWig | B | 16 | 17 |
| bedGraph | B | 17 | 13 |
| Bootstrap | B | 21 | 22 |
| BQSR (Base Quality Score Recalibration) | B | 22 | 23 |
| Boolean | B | 23 | 21 |
| cDNA | C | 1 | 6 |
| CDS (coding sequence) | C | 2 | 7 |
| Checksum | C | 3 | 9 |
| Checkout | C | 4 | 8 |
| Call | C | 5 | 2 |
| Canonical accession | C | 6 | 4 |
| camelCase | C | 7 | 3 |
| Capped database | C | 8 | 5 |
| Cache | C | 9 | 1 |
| CIGAR | C | 10 | 12 |
| Chimera | C | 11 | 10 |
| Chord | C | 12 | 11 |
| Classifier | C | 19 | 21 |
| Clumpify | C | 20 | 22 |
| Clustering | C | 21 | 23 |
| Codon | C | 22 | 24 |
| Command-line flag | C | 23 | 27 |
| Cohort | C | 24 | 25 |
| Commit | C | 25 | 28 |
| Conda | C | 27 | 29 |
| Consensus FASTA | C | 28 | 30 |
| Consensus sequence | C | 29 | 31 |
| Class I MHC | C | 30 | 19 |
| Class II MHC | C | 31 | 20 |
| De Bruijn graph | D | 1 | 2 |
| De novo assembly | D | 2 | 3 |
| Deacon | D | 3 | 4 |
| Deduplicated reference | D | 4 | 5 |
| Demultiplex | D | 5 | 7 |
| Dependency set | D | 7 | 8 |
| Depth | D | 8 | 9 |
| Derived bundle | D | 9 | 10 |
| Determinism | D | 10 | 11 |
| dbSNP | D | 11 | 1 |
| E-value | E | 1 | 8 |
| Edit distance | E | 2 | 1 |
| Executable | E | 8 | 9 |
| Exit status | E | 9 | 10 |
| EMBL (sequence format) | E | 10 | 2 |
| FASTQ | F | 4 | 5 |
| fastp | F | 5 | 4 |
| FORMAT (in a VCF) | F | 10 | 12 |
| Flagstat | F | 11 | 10 |
| Fluidigm sample barcode | F | 12 | 11 |
| Glob | G | 2 | 14 |
| GC content | G | 3 | 2 |
| GenBank (sequence format) | G | 4 | 3 |
| Genetic code | G | 5 | 4 |
| GenomicsDB | G | 6 | 5 |
| Genotype | G | 7 | 6 |
| GenotypeGVCFs | G | 8 | 10 |
| Genotype matrix | G | 9 | 7 |
| Genotype quality | G | 10 | 8 |
| Genotype result bundle | G | 11 | 9 |
| Germline variant | G | 12 | 11 |
| GFA (Graphical Fragment Assembly) | G | 13 | 12 |
| GFF (General Feature Format) | G | 14 | 13 |
| Hamming distance | H | 1 | 2 |
| Half-open | H | 2 | 1 |
| Host name | I | 1 | 2 |
| Host depletion | I | 2 | 1 |
| INFO (in a VCF) | I | 5 | 6 |
| INSDC (International Nucleotide Sequence Database Collaboration) | I | 6 | 7 |
| Indel | I | 7 | 5 |
| Internal node | I | 10 | 11 |
| Interleaved FASTQ | I | 11 | 10 |
| JSON (JavaScript Object Notation) | J | 1 | 2 |
| Joint genotyping | J | 2 | 1 |
| k-mer | K | 1 | 4 |
| Key equivalent | K | 3 | 1 |
| Kilobase | K | 4 | 3 |
| Kraken 2 | K | 5 | 6 |
| Known sites | K | 6 | 5 |
| Library prep | L | 5 | 6 |
| Library layout | L | 6 | 5 |
| LoFreq | L | 8 | 13 |
| Lineage | L | 9 | 8 |
| Lineage barcode | L | 10 | 9 |
| Linkage | L | 11 | 10 |
| Local reassembly | L | 12 | 11 |
| Locus | L | 13 | 12 |
| Mapper | M | 2 | 4 |
| Mapping | M | 3 | 5 |
| Materialization | M | 4 | 10 |
| Managed environment | M | 5 | 2 |
| Manifest | M | 6 | 3 |
| Mapping preset | M | 7 | 6 |
| Mapping quality | M | 8 | 7 |
| MAPQ (mapping quality) | M | 9 | 8 |
| Mark duplicates | M | 10 | 9 |
| Medaka | M | 12 | 13 |
| Metabarcoding | M | 13 | 14 |
| Metadata | M | 14 | 15 |
| Metagenomics | M | 15 | 16 |
| Methods export | M | 16 | 17 |
| MCM (Mauritian cynomolgus macaque) | M | 17 | 12 |
| Mitochondrial genome | M | 20 | 25 |
| miniBAM | M | 21 | 20 |
| minimap2 | M | 22 | 21 |
| Minimizer | M | 23 | 22 |
| MinKNOW | M | 24 | 23 |
| MiSeq | M | 25 | 24 |
| mosdepth | M | 26 | 27 |
| Modifier key | M | 27 | 26 |
| NAO-MGS | N | 2 | 3 |
| Newick | N | 3 | 6 |
| Nanopore sequencing | N | 4 | 2 |
| NCBI (National Center for Biotechnology Information) | N | 5 | 4 |
| Negative control | N | 6 | 5 |
| PCR (Polymerase Chain Reaction) | P | 2 | 6 |
| PCR duplicate | P | 3 | 7 |
| Pangenome | P | 4 | 2 |
| Pathoplexus | P | 5 | 4 |
| PATH | P | 6 | 3 |
| pbAA | P | 7 | 5 |
| PHA4GE | P | 9 | 10 |
| Phase (in GFF3) | P | 10 | 11 |
| Phase set | P | 11 | 12 |
| Phred score | P | 12 | 14 |
| Phylogram | P | 14 | 15 |
| Percent identity | P | 15 | 9 |
| Pipeline | P | 17 | 19 |
| Pileup | P | 18 | 17 |
| Pinned | P | 19 | 18 |
| Primary alignment | P | 26 | 27 |
| Preprint | P | 27 | 26 |
| Read-backed phasing | R | 4 | 9 |
| Read group | R | 5 | 4 |
| Read identifier | R | 7 | 5 |
| Read merging | R | 8 | 7 |
| Read orientation | R | 9 | 8 |
| Regular expression | R | 13 | 20 |
| Recalibration table | R | 14 | 13 |
| Reference manager | R | 15 | 17 |
| Reference bundle | R | 16 | 15 |
| Reference genome | R | 17 | 16 |
| REF, ALT | R | 20 | 14 |
| RPKMF | R | 21 | 33 |
| Repeat masking | R | 22 | 21 |
| Report slot | R | 23 | 22 |
| Required Setup pack | R | 25 | 26 |
| Reproducibility | R | 26 | 25 |
| Repository | R | 27 | 23 |
| Residual | R | 30 | 27 |
| Ribosomal RNA (rRNA) | R | 31 | 30 |
| RID (Request ID) | R | 32 | 31 |
| Rooting | R | 33 | 32 |
| Shearing | S | 2 | 16 |
| Shell | S | 3 | 17 |
| Sample metadata | S | 4 | 2 |
| Sample sheet | S | 5 | 3 |
| Samplesheet | S | 6 | 4 |
| samtools | S | 7 | 5 |
| savONT | S | 8 | 6 |
| Scaffold | S | 9 | 7 |
| Schema version | S | 10 | 8 |
| seqkit | S | 11 | 10 |
| Secondary alignment | S | 12 | 9 |
| Sequence dictionary | S | 13 | 11 |
| Sequence motif | S | 14 | 12 |
| Sequence viewport | S | 15 | 13 |
| SH-aLRT | S | 16 | 14 |
| Shannon entropy | S | 17 | 15 |
| Sublineage | S | 39 | 42 |
| Subcommand | S | 40 | 41 |
| Subsampling | S | 41 | 43 |
| Strand odds ratio | S | 42 | 39 |
| Structural variation | S | 43 | 40 |
| Switch | S | 45 | 47 |
| Symlink | S | 46 | 48 |
| Supplementary alignment | S | 47 | 45 |
| Support value | S | 48 | 46 |
| Tarball | T | 2 | 3 |
| TASS score | T | 3 | 5 |
| Table drawer | T | 4 | 2 |
| Target enrichment | T | 5 | 4 |
| Two-bit (2bit) | T | 19 | 20 |
| 12S | T | 20 | 19 |
| Variant-caller | V | 2 | 3 |
| Variant-only bundle | V | 3 | 4 |
| Variant track | V | 4 | 2 |
| vsearch | V | 7 | 8 |
| Virtual bundle | V | 8 | 7 |
| Workflow lineage | W | 5 | 6 |
| Workflow package | W | 6 | 7 |
| Workflow Library | W | 7 | 5 |
| YAML | X to Y | 2 | 1 |

## Consistency check

Every definition that touches a ruling in `reviews/fidelity-2026-09/CONSISTENCY.md` was read against it. The definitions already agreed, so none needed a correction on those grounds.

- **AI assistant** names the Inspector's Assistant tab, per the ruling.
- **Assembly bundle** places a de novo assembly under `Analyses/`, and no entry anywhere in the file mentions an `Assemblies/` folder, which the rulings say does not exist.
- **Deacon** makes no claim that the command line is the only route to its indexes, and **Required Setup pack** lists Deacon among the tools that install with the app, which matches the ruling that both Deacon indexes fold into Required Setup.
- **Variant track** and **BCF** describe the bundle path as a bgzip-compressed VCF with a tabix index and a SQLite sidecar, per the variant track storage ruling, and **BCF** correctly limits BCF plus CSI to the imported case.
- **CZ-ID** writes to `Classifications/` and says LGE never runs one, per the imported classifier results ruling.

One spelling was corrected on the same grounds. **Minimizer** wrote the classifier as "Kraken2" in prose twice, where the glossary term and the rest of the manual use "Kraken 2". The literal menu item **Tools > Classification > Kraken2...** in the **Kraken 2** entry is left as it is, because that is the string the app draws.

