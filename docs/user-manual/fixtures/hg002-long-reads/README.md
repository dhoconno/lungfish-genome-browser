# HG002 long-read fixture

HG002/NA24385 Oxford Nanopore ultra-long and PacBio HiFi reads sliced to
chrM from public GIAB long-read BAMs, plus a minimal ONT run-folder
layout built from the ONT reads. Supports the ONT run import chapter,
the nanopore variant calling chapter, and the long-read assembly
chapter. The reference is the human-mito fixture's `NC_012920.1.fasta`
(rCRS) and is not duplicated here.

## Genome

`NC_012920.1`, Homo sapiens mitochondrion, complete genome, 16,569 bp.
Both source BAMs are aligned to GRCh38, so `chrM` in each is rCRS,
matching the reference used by the human-mito and chr20 fixtures.

## Sources

- **ONT reads.** HG002/NA24385 (Ashkenazim son), GIAB/UCSC ultra-long
  Oxford Nanopore PromethION run against GRCh38,
  `https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/UCSC_Ultralong_OxfordNanopore_Promethion/HG002_GRCh38_ONT-UL_UCSC_20200508.phased.bam`.
- **HiFi reads.** HG002/NA24385 (Ashkenazim son), GIAB PacBio Sequel II
  CCS 15 kb and 20 kb chemistry2 run against GRCh38,
  `https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_CCS_15kb_20kb_chemistry2/GRCh38/HG002.SequelII.merged_15kb_20kb.GRCh38.duplomap.bam`.

`fetch.sh` reads only the `chrM` contig over HTTPS via samtools' built-in
remote-BAM support (htslib range GETs) against each BAM's own remote
`.bai`. Neither multi-hundred-GB whole-genome BAM (187 GB ONT, 121 GB
HiFi) is ever downloaded.

Both URLs were checked live (`HTTP 200`, `Accept-Ranges: bytes`) on
2026-09-06.

## License and citation

The GIAB reference materials are public domain (U.S. government work,
no usage restriction) and the ONT-UL dataset is additionally released
under CC0. Check your local jurisdiction if redistributing outside the
U.S.

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
@article{shafin2020nanopore,
  author  = {Shafin, Kishwar and Pesout, Trevor and Lorig-Roach, Ryan
             and Haukness, Marina and Olsen, Hugh E. and Bosworth,
             Colleen and Armstrong, Joel and Tigyi, Kristof and Maurer,
             Nicholas and Koren, Sergey and Sedlazeck, Fritz J.
             and Marschall, Tobias and Mayes, Simon and Costa, Vania
             and Zook, Justin M. and Liu, Kelvin J. and Kilburn, Duncan
             and Sorensen, Melanie and Munson, Katy M.
             and Vollger, Mitchell R. and Eichler, Evan E.
             and Salama, Sofie and Haussler, David and Green, Richard E.
             and Akeson, Mark and Phillippy, Adam and Miga, Karen H.
             and Carnevali, Paolo and Jain, Miten and Paten, Benedict},
  title   = {Nanopore sequencing and the Shasta toolkit enable efficient
             de novo assembly of eleven human genomes},
  journal = {Nature Biotechnology},
  year    = {2020},
  volume  = {38},
  pages   = {1044--1053},
  doi     = {10.1038/s41587-020-0503-6}
}
```

## Committed files

| File | Size |
| --- | --- |
| `HG002.chrM.ont.fastq.gz` | 4.8 MB |
| `HG002.chrM.hifi.fastq.gz` | 3.7 MB |
| `ont-run/fastq_pass/barcode01/HG002_chrM_pass_barcode01_0.fastq.gz` | 4.8 MB |
| `expected/flye/assembly.fasta` | 20 KB |
| `expected/hifiasm/contigs.fasta` | 36 KB |

Total committed is about 14 MB, well under the 50 MB fixture-set cap. Every
file is under the 10 MB per-file cap. The run-folder copy of the ONT
FASTQ duplicates `HG002.chrM.ont.fastq.gz` on purpose, since the ONT
run import chapter needs a realistic `fastq_pass/barcode01/` layout to
demonstrate against.

## Downsampling

Both source BAMs carry mitochondrial DNA at very high copy number per
cell, so a whole-genome long-read library massively over-covers `chrM`
relative to nuclear chromosomes. After the remote region fetch and
name-sort, the ONT slice held 3,621 reads (17.46 Mb, about 1,054x over
the 16,569 bp genome) and the HiFi slice held 4,005 reads (55.15 Mb,
about 3,327x). `fetch.sh` downsamples each straight to approximately
300x coverage with `samtools view -b -s 42.0.28` (ONT) and
`samtools view -b -s 42.0.09` (HiFi), seed 42 in both cases, before
converting to FASTQ.

Resulting read sets from `seqkit stats -a`.

| File | Reads | Total bp | N50 | Coverage |
| --- | --- | --- | --- | --- |
| `HG002.chrM.ont.fastq.gz` | 950 | 4,348,051 | 10,615 bp | 262x |
| `HG002.chrM.hifi.fastq.gz` | 363 | 4,991,345 | 13,663 bp | 301x |

The ONT read set spans a wide length range (min 263 bp, max 39,647 bp,
average quality 7.9), typical of ultra-long nanopore output. The HiFi
read set is far more uniform (min 154 bp, max 18,168 bp, average
quality 29, 97.6% Q30+), typical of circular consensus sequencing.

## ONT run-folder layout

`ont-run/` is a minimal Oxford Nanopore instrument output directory:

```
ont-run/
  fastq_pass/
    barcode01/
      HG002_chrM_pass_barcode01_0.fastq.gz
```

This matches the layout `ONTDirectoryImporter` and
`FASTQBatchImporter.detectPairsFromDirectoryRecursive` scan for (see
`Sources/LungfishIO/Formats/FASTQ/ONTDirectoryImporter.swift` and
`Sources/LungfishWorkflow/Ingestion/FASTQBatchImporter.swift`), a
`fastq_pass/` parent directory containing `barcode*` subdirectories of
FASTQ chunks. Neither importer requires a sidecar file alongside the
chunks.

Verified with a dry run against the built directory:

```
$ lungfish-cli import-fastq --dry-run --platform ont --recursive ont-run --project <anything>.lungfish

FASTQ Import

ℹ Detected 1 sample(s):
    1. HG002_chrM_pass_barcode01_0  [single-end]
        R1: HG002_chrM_pass_barcode01_0.fastq.gz

ℹ Dry-run mode — no files were imported.
```

The CLI's non-recursive directory scan does not descend into
`fastq_pass/barcode01/`, so `--recursive` is required when pointing the
importer at the `ont-run` root (pointing it directly at `barcode01/`
also works without `--recursive`). `--project` is a required argument
even in `--dry-run` mode and must end in `.lungfish`, though the dry
run never touches the path.

## Assembly results

`regenerate.sh` runs the managed Flye and hifiasm assemblers through
`lungfish-cli assemble`.

**Flye (ONT).** `--assembler flye --read-type ont-reads`. Observed on
2026-09-06, the result was **1 contig, 16,359 bp**, 43.9% GC, mean
coverage 256x, wall time 37.1 seconds. The assembled length is 210 bp
(1.3%) shorter than the 16,569 bp rCRS, consistent with normal
long-read assembly overlap trimming at a circular genome's junction
rather than a fixture defect.

**hifiasm (HiFi).** `--assembler hifiasm --read-type pacbio-hifi`.
Observed on 2026-09-06, the result was **1 contig, 33,140 bp**, 44.4%
GC, wall time 5.8 seconds. The assembled length is almost exactly
double the 16,569 bp rCRS (33,140 / 16,569 = 2.0002), a known hifiasm
artifact for a small circular replicon assembled alone. With no larger
nuclear genome to anchor against, the overlap graph walks around the
mitochondrial circle twice before hifiasm calls a boundary. The chapter
can still use this result to show the wizard and the resulting contig,
with a note that a circular-aware assembler setting or manual graph
inspection is needed to collapse it to unit length.

Both working directories carry repeat graphs, phased unitig GFAs, and
per-stage logs beyond the primary contigs FASTA. Only
`expected/flye/assembly.fasta` and `expected/hifiasm/contigs.fasta` are
committed.

## Internal consistency

Both assemblers reconstructed the whole mitochondrial genome from their
respective downsampled read sets, Flye within 1.3% of the 16,569 bp
reference and hifiasm at twice that length for the reason described
above. This confirms both read sets retain enough coverage and length
to reconstruct the genome end-to-end, even though the reads were never
directly aligned back to `NC_012920.1.fasta` as part of this fixture
(that comparison belongs to the alignment and variant-calling chapters,
which use the chr20 and human-mito fixtures instead).

## Regenerating

```bash
bash docs/user-manual/fixtures/hg002-long-reads/fetch.sh       # rebuilds the committed reads and ONT run folder
bash docs/user-manual/fixtures/hg002-long-reads/regenerate.sh  # reassembles into expected/flye and expected/hifiasm
```

`fetch.sh` needs the managed `samtools` environment under
`~/.lungfish/conda/envs/`. `regenerate.sh` needs a built `lungfish-cli`
(`.build/debug/lungfish-cli`) with the managed Genome Assembly pack
installed (Flye and hifiasm under `~/.lungfish/conda/envs/`).
