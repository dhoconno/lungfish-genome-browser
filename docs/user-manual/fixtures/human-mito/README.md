# Human mitochondrial genome fixture

The revised Cambridge Reference Sequence (rCRS) for human mitochondrial
DNA plus HG002 Illumina reads mapped to chrM, sliced from the same GIAB
BAM the chr20 fixture uses. Supports the assembly chapters (a real 16.5
kb genome assembles in seconds) and stands as the human entry in the
primate reference set.

## Genome

`NC_012920.1`, Homo sapiens mitochondrion, complete genome, 16,569 bp.
The FASTA header and coordinates are used as published.
Nothing is renamed or shifted.

## Sources

**Reference**

NCBI Nucleotide `NC_012920.1` (rCRS), fetched via NCBI eutils efetch.

`https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_012920.1&rettype=fasta&retmode=text`

**Reads**

HG002/NA24385 (Ashkenazim son), NIST/GIAB Illumina 2x250bp PCR-free novoalign BAM against GRCh38.

`https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/NIST_Illumina_2x250bps/novoalign_bams/HG002.GRCh38.2x250.bam`

`fetch.sh` reads only the `chrM` contig over HTTPS via samtools' built-in remote-BAM support (htslib range GETs).
The multi-hundred-GB whole-genome BAM is never downloaded.

Both URLs were checked live (`HTTP 200`) on 2026-09-06.

## License and citation

The rCRS and GIAB/NIST reference materials are public domain (U.S.
government work, no usage restriction). Check your local jurisdiction if
redistributing outside the U.S.

Cite:

```bibtex
@article{andrews1999reanalysis,
  author  = {Andrews, Richard M. and Kubacka, Iwona and Chinnery,
             Patrick F. and Lightowlers, Robert N. and Turnbull,
             Douglass M. and Howell, Neil},
  title   = {Reanalysis and revision of the Cambridge reference
             sequence for human mitochondrial DNA},
  journal = {Nature Genetics},
  year    = {1999},
  volume  = {23},
  pages   = {147},
  doi     = {10.1038/13779}
}
@article{zook2019giab,
  author  = {Zook, Justin M. and McDaniel, Jennifer and Olson, Nathan D.
             and Wagner, Justin and Parikh, Hemang and Heaton, Haynes
             and Irvine, Sean A. and Trigg, Len and Truty, Rebecca
             and McLean, Cory Y. and De La Vega, Francisco M.
             and Xiao, Chunlin and Sherry, Stephen and Salit, Marc},
  title   = {An open resource for accurately benchmarking small variant
             and reference calls},
  journal = {Nature Biotechnology},
  year    = {2019},
  volume  = {37},
  pages   = {561--566},
  doi     = {10.1038/s41587-019-0074-6}
}
```

## Committed files

| File | Size |
| --- | --- |
| `NC_012920.1.fasta` | 17 KB |
| `NC_012920.1.fasta.fai` | <1 KB |
| `HG002.chrM.R1.fastq.gz` | 1.9 MB |
| `HG002.chrM.R2.fastq.gz` | 2.1 MB |
| `expected/spades/contigs.fasta` | 17 KB |

Total committed ~4.1 MB, well under the 50 MB fixture-set cap.
Every file is under the 10 MB per-file cap.

## Downsampling

The GIAB BAM carries roughly 2.6 million reads on `chrM` alone.
Mitochondrial DNA sits at very high copy number per cell, so a whole-genome Illumina library massively over-covers it relative to nuclear chromosomes.
A naive slice would produce FASTQs far larger than needed for a 16.5 kb genome.
`fetch.sh` downsamples straight to approximately 300x coverage with `samtools view -b -s 42.0077` (seed 42, keep fraction 0.0077) before converting to FASTQ.
The resulting read set is 9,958 read pairs (19,925 reads total after downsampling, minus 9 singletons discarded during BAM-to-FASTQ conversion).
R1/R2 total 1.9 MB / 2.1 MB gzipped, or about 300x coverage of the 16,569 bp genome.

## Assembly result

`regenerate.sh` runs the managed SPAdes assembler through `lungfish-cli assemble --assembler spades --read-type illumina-short-reads --paired`.
Observed on 2026-09-06, the assembly produced **1 contig, 16,697 bp** (`NODE_1_length_16697_cov_121.957333`), with 121.96x reported k-mer coverage and wall time 13.7 seconds.
The assembled length is 128 bp (0.8%) longer than the 16,569 bp rCRS.
This is consistent with normal short-read assembly overlap artifacts at a circular genome's junction, not a fixture defect.
The full SPAdes working directory (k-mer graphs, logs, alternate FASTAs) is reproducible but not committed.
Only `contigs.fasta` is kept as the expected result.

## Internal consistency

The reads were assembled with `regenerate.sh` into a single contig
covering the whole mitochondrial genome, at a length within 1% of the
16,569 bp reference. This confirms the downsampled read set retains
enough coverage and pairing structure to reconstruct the genome
end-to-end, even though the reads were never directly aligned back to
`NC_012920.1.fasta` as part of this fixture (that comparison belongs to
the alignment and variant-calling chapters, which use the chr20 fixture
instead).

## Regenerating

```bash
bash docs/user-manual/fixtures/human-mito/fetch.sh       # rebuilds the committed reference and reads
bash docs/user-manual/fixtures/human-mito/regenerate.sh  # reassembles into expected/spades (only contigs.fasta committed)
```

`fetch.sh` needs the managed `samtools` environment under
`~/.lungfish/conda/envs/`. `regenerate.sh` needs a built `lungfish-cli`
(`.build/debug/lungfish-cli`) with the managed Genome Assembly pack
installed (SPAdes under `~/.lungfish/conda/envs/spades`).
