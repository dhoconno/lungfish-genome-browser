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
  That supplementary count is what `mapping-result.json` counts as `totalReads`. The same file reports 90,990 mapped, which counts those supplementary records too, while 90,935 is the primary-mapped count. Both round to 99.77%.
  The reads align to the included reference as expected.
- The benchmark VCF has 961 variant records inside the slice and is the truth set the variant-calling and variant-browser chapters compare their own calls against.
  It was NOT derived from the fixture's own reads. It comes independently from NIST's benchmark pipeline.
  Chapters should treat it purely as ground truth, not as "calls from these reads."
- `regenerate.sh` output (`expected/mapping/`, including `HG002.sorted.bam` at 13 MB) exceeds the 10 MB per-file cap and is **not committed**.
  It is reproducible by running `regenerate.sh` and is listed in `.gitignore` alongside `cache/`.
  The numbers above were captured from a real run of that script on 2026-09-06 so the manual can quote real figures.

## Variant calls

`regenerate.sh` also calls variants from `expected/mapping/HG002.sorted.bam` against `GRCh38.chr20.10.0-10.5Mb.fasta` with default settings, once for bcftools and once for LoFreq, inside a scratch project (variant calling only operates on a bundle-owned alignment track, never a loose BAM).

```bash
lungfish-cli variants call --bundle <bundle> --alignment-track hg002-minimap2 --caller bcftools --name "HG002 bcftools"
lungfish-cli variants call --bundle <bundle> --alignment-track hg002-minimap2 --caller lofreq --name "HG002 LoFreq"
```

Caller versions, from the provenance sidecars written alongside each VCF, were bcftools 1.24 (managed conda environment `bcftools`, package `bioconda::bcftools=1.24=h6bd33b9_2`) and LoFreq 2.1.5 (the LoFreq binary itself does not accept `--version`, so this came from running `lofreq version` directly).

The bcftools VCF holds 1,056 records with `bcftools view -H | wc -l`.
Every record's FILTER column reads `.` rather than `PASS`, because a default `variants call --caller bcftools` run applies no hard filter, so there are 1,056 unset-FILTER records and zero PASS records.
The FORMAT column carries `GT:PL:AD` for the single `HG002` sample column.
A representative row (REF `G`, ALT `A`, unset FILTER) reads:

```
chr20_10.0-10.5Mb	2078	.	G	A	225.417	.	DP=62;VDB=0.240996;SGB=-0.693147;MQSBZ=0;MQ0F=0;AC=2;AN=2;DP4=0,0,24,27;MQ=60	GT:PL:AD	1/1:255,154,0:0,51
```

Because every bcftools record shares the same unset FILTER value, there is no second, differently filtered row to quote from this caller.

The LoFreq VCF holds 862 records with `bcftools view -H | wc -l`.
Every record's FILTER column reads `PASS`, giving 862 PASS records and zero records under any other FILTER value.
LoFreq's default output carries no FORMAT or per-sample column at all, since it reports allele frequency and depth as INFO fields rather than genotypes.
A representative row (the same position as the bcftools example above) reads:

```
chr20_10.0-10.5Mb	2078	.	G	A	2370	PASS	DP=62;AF=1;SB=0;DP4=0,0,31,31
```

Because every LoFreq record is already PASS, there is no non-PASS row to quote from this caller either.

Comparing each caller's records against the 961-record benchmark VCF inside the slice, by matching CHROM and POS only, gives a first look at agreement.
bcftools has no PASS records to compare, so this counts its full call set instead. 954 of its 1,053 distinct positions match a benchmark position.
LoFreq's 861 distinct PASS positions include 808 that match a benchmark position.
These counts are position matches only, not full-genotype concordance, and are not a substitute for a proper benchmarking pipeline such as `hap.py`.

The bcftools VCF is 46 KB with a 4 KB index, and its provenance sidecar is 28 KB.
The LoFreq VCF is 16 KB with a 4 KB index, and its provenance sidecar is 24 KB.
All six files live under `expected/variants/` alongside `expected/mapping/`. The two `.vcf.gz` files and their `.tbi` indexes are committed because they are small, while the provenance sidecars carry machine paths and stay out of git. `regenerate.sh` rebuilds all six.

## Regenerating

```bash
bash docs/user-manual/fixtures/hg002-chr20/fetch.sh       # rebuilds the committed files
bash docs/user-manual/fixtures/hg002-chr20/regenerate.sh  # remaps and recalls into expected/
```

`fetch.sh` needs the managed `samtools`, `bcftools`, and `htslib`
(`bgzip`, `tabix`) environments under `~/.lungfish/conda/envs/`.
`regenerate.sh` needs a built `lungfish-cli`
(`.build/debug/lungfish-cli`) with the managed minimap2 read-mapping
plugin pack installed.
