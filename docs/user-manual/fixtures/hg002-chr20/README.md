# HG002 chromosome 20 slice fixture

Human reference and Illumina reads over a 500 kb, gene-rich slice of
chromosome 20 with no known assembly gaps, plus the matching GIAB
benchmark variant calls. Supports the mapping, alignment-reading,
variant-calling, and variant-browser chapters.

## Region

`chr20:10,000,000-10,500,000` (GRCh38), 500,001 bp. The FASTA header is
rewritten to `chr20_10.0-10.5Mb` and every coordinate in the benchmark
VCF is shifted by subtracting 9,999,999, so the fixture is self-contained
(1-based fixture coordinates run 1-500,001) and never depends on the
original chromosome numbering.

## Sources

**Reference**

UCSC `hg38` chromosome 20 (identical sequence to GRCh38 chr20).

`https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr20.fa.gz`

**Reads**

HG002/NA24385 (Ashkenazim son), NIST/GIAB Illumina 2x250bp PCR-free novoalign BAM against GRCh38.

`https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/NIST_Illumina_2x250bps/novoalign_bams/HG002.GRCh38.2x250.bam`

`fetch.sh` reads only the `chr20:10000000-10500000` region over HTTPS via samtools' built-in remote-BAM support (htslib range GETs).
The multi-hundred-GB whole-genome BAM is never downloaded.

**Benchmark calls**

GIAB NISTv4.2.1 small-variant benchmark for HG002 against GRCh38.

`https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/NISTv4.2.1/GRCh38/HG002_GRCh38_1_22_v4.2.1_benchmark.vcf.gz`

All three URLs were checked live (`HTTP/1.1 200 OK`) on 2026-09-06.

## License and citation

GIAB/NIST reference materials are public domain (U.S. government work with no usage restriction).
UCSC's hg38 assembly download is likewise freely redistributable.
Check your local jurisdiction if redistributing outside the U.S.

Cite:

```bibtex
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
| `GRCh38.chr20.10.0-10.5Mb.fasta` | 500 KB |
| `GRCh38.chr20.10.0-10.5Mb.fasta.fai` | <1 KB |
| `HG002.chr20.10.0-10.5Mb_R1.fastq.gz` | 8.3 MB |
| `HG002.chr20.10.0-10.5Mb_R2.fastq.gz` | 8.9 MB |
| `HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz` | 40 KB |
| `HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz.tbi` | <1 KB |

Total committed ~18 MB, under the 50 MB fixture-set cap.
Every file is under the 10 MB per-file cap.

## Downsampling

The full-depth region slice from the GIAB BAM is roughly 40x over 500 kb with 2x250bp reads, which produced 13.4 MB (R1) and 14.3 MB (R2) gzipped FASTQ.
This exceeded the 10 MB per-file cap.
`fetch.sh` downsamples with `samtools view -b -s 42.65` (65% of read pairs kept, seed 42) before converting to FASTQ, bringing R1/R2 to 8.3 MB / 8.9 MB.
The kept fraction is recorded as `DOWNSAMPLE_FRACTION` at the top of `fetch.sh`.
The resulting read set is 45,574 read pairs (91,148 reads, 182,296 lines per file) after downsampling and BAM-to-FASTQ singleton filtering.

## Internal consistency

- The reads were re-mapped with `regenerate.sh` (managed minimap2 via `lungfish-cli map --paired --mapper minimap2 --preset sr`) against `GRCh38.chr20.10.0-10.5Mb.fasta`.
  Results show 91,148 primary reads, 90,935 of them mapped (99.77%), mean depth 44.7x, mean identity 99.4%, coverage breadth 99.99% of the 500,001 bp slice.
  `samtools flagstat` reports 91,203 records in total because 55 reads also carry a supplementary alignment.
  That supplementary count is what `mapping-result.json` counts as `totalReads`.
  The reads align to the included reference as expected.
- The benchmark VCF has 961 variant records inside the slice and is the truth set the variant-calling and variant-browser chapters compare their own calls against.
  It was NOT derived from the fixture's own reads. It comes independently from NIST's benchmark pipeline.
  Chapters should treat it purely as ground truth, not as "calls from these reads."
- `regenerate.sh` output (`expected/mapping/`, including `HG002.sorted.bam` at 13 MB) exceeds the 10 MB per-file cap and is **not committed**.
  It is reproducible by running `regenerate.sh` and is listed in `.gitignore` alongside `cache/`.
  The numbers above were captured from a real run of that script on 2026-09-06 so the manual can quote real figures.

## Regenerating

```bash
bash docs/user-manual/fixtures/hg002-chr20/fetch.sh       # rebuilds the committed files
bash docs/user-manual/fixtures/hg002-chr20/regenerate.sh  # remaps into expected/ (gitignored)
```

`fetch.sh` needs the managed `samtools`, `bcftools`, and `htslib`
(`bgzip`, `tabix`) environments under `~/.lungfish/conda/envs/`.
`regenerate.sh` needs a built `lungfish-cli`
(`.build/debug/lungfish-cli`) with the managed minimap2 read-mapping
plugin pack installed.
