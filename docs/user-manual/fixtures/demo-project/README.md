# Demo project

`build-demo-project.sh` builds the project that every screenshot recipe in
the manual opens. It drives `lungfish-cli` over the committed fixtures in
`docs/user-manual/fixtures/` and writes one Lungfish project containing a
reference sequence, a mapping with two variant tracks, an assembly, an
alignment with its tree, a Kraken 2 classification, and an NVD import.

Run it from anywhere.

```bash
bash docs/user-manual/fixtures/demo-project/build-demo-project.sh
```

The script is idempotent. Every step checks for its own output first and
skips when it is already there, so a re-run after a failure resumes rather
than rebuilding. A second run over a finished project takes under a second.

## What the project contains

The project is `LGE Manual Demo.lungfish` under the demo root. The path has
to end in `.lungfish` because the CLI rejects a `--project` that does not.

| Folder | Contents |
| --- | --- |
| `Imports/` | `HG002` and `HG002-chrM` paired Illumina samples, plus `SRR36291587` |
| `Reference Sequences/` | `HBB.lungfishref` and `chr20_10.0-10.5Mb.lungfishref` |
| `Analyses/mapping-HG002/` | minimap2 short-read mapping of HG002 against chr20 |
| `Analyses/Multiple Sequence Alignments/` | the primate mitochondrial MSA and its IQ-TREE tree |
| `Analyses/kraken2-SRR36291587/` | Kraken 2 classification of the SARS-CoV-2 reads |
| `Analyses/nvd-demo/` | the NVD BLAST demo import |
| `Analyses/HG002-chrM/` | SPAdes assembly of the mitochondrial reads |
| `_scratch/` | the generated sample sheet and, under `_scratch/sra/`, the fetched SARS-CoV-2 reads, not part of the manual |

The chr20 bundle carries three tracks. The alignment track `hg002-minimap2`
is named "HG002 minimap2" in the interface, and two variant tracks sit on
top of it, "HG002 bcftools" with 1,056 variants and "HG002 LoFreq" with 862.
The track identifier is pinned with `--track-id` so later steps and the
screenshot recipes can name it without reading it back.

## Environment variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `LUNGFISH_CLI` | `.build/debug/lungfish-cli` in the primary checkout | The CLI binary to drive |
| `LUNGFISH_DEMO_ROOT` | `$HOME/Desktop/lge-docs` | Directory that will hold the project |
| `LUNGFISH_KRAKEN_DB` | `Viral` | Name of an installed Kraken 2 database |

`lungfish-cli conda db list` shows which databases are installed. This run
used `Viral`, which was already present and is the right size for a
SARS-CoV-2 sample.

## How long each step takes

Measured on the development Mac over one run from an empty project, with the
fixtures and the Kraken 2 database already on disk. The whole script is
about a hundred seconds, and nothing in it is slow enough to need a
background run.

| Step | Time | Notes |
| --- | --- | --- |
| 0 SARS-CoV-2 reads | 5s | Only on the first run, skipped afterwards |
| 1 reads | 15s | Three samples through `import-fastq` |
| 2 references | under 1s | Two `import fasta` calls |
| 3 mapping and variants | 17s | minimap2 plus bcftools plus LoFreq |
| 4 assembly | 26s | SPAdes on the mitochondrial reads |
| 5 alignment and tree | 38s | MAFFT then IQ-TREE |
| 6 classification | 3s | Kraken 2 against the Viral database |
| 7 NVD import | under 1s | Ten BLAST hits across three samples |
| 8 Viral Recon | not run | See below |

Total for a full build is 100 seconds once the reads are cached. A re-run
over the finished project is a second.

## The reads that are not committed

The SARS-CoV-2 fixture commits no FASTQ. Step 0 fetches run SRR36291587
with `fetch sra download ... --use-toolkit`, which writes the uncompressed
`SRR36291587_1.fastq` and `SRR36291587_2.fastq` into `_scratch/sra` inside
the project. They stay there and every later run skips the download. The
files are about 56 MB each and are deliberately kept out of the repository,
which is why they live in the project rather than in the fixture directory.

## Viral Recon is a manual step

Step 8 does not run Viral Recon. It checks whether Docker is reachable,
prints a note, and stops. Run the pipeline once by hand so the Viral Recon
chapter has a result to photograph.

1. Start Docker Desktop and wait for it to report that the engine is running.
2. Open the demo project in the app.
3. Choose Tools then Mapping then Viral Recon.
4. Pick the `SRR36291587` sample and the MN908947.3 reference.
5. Run the wizard and leave the app open until the operation finishes.

The run takes far longer than anything the script does, so start it when
you can leave the machine alone. Record the wall-clock time here once it
has been run, because the manual quotes it to set the reader's expectation.

## Corrections made to the drafted commands

Every command was checked against the help dumps in
`docs/user-manual/reviews/fidelity-2026-09/cli-help/` before it was run, and
five of them needed changing.

`import fasta -o` takes the project directory, not the reference folder. It
creates its own `Reference Sequences` subfolder inside whatever it is
given, so passing the reference folder produced a nested
`Reference Sequences/Reference Sequences/`. The script now passes the
project. The same command sanitises the bundle filename, so the reference
named "chr20 10.0-10.5Mb" lands as `chr20_10.0-10.5Mb.lungfishref` and the
skip check has to use the sanitised name.

`tree infer iqtree` requires `--output` with an explicit
`.lungfishtree` path. `--project` alone is not enough.

`variants call --alignment-track` wants a track identifier rather than a
name. `bam adopt-mapping` accepts `--track-id`, so the script sets
`hg002-minimap2` rather than reading an identifier back. The idempotency
checks still read `manifest.json` inside the `.lungfishref` bundle, where
`alignments[]` and `variants[]` each carry an `id` and a `name`.

`import-fastq` pairs R1 with R2 only for the underscore-delimited
conventions `_R1_001`, `_R1`, and `_1`. The `hg002-chr20` and `human-mito`
fixtures use dot-delimited `.R1` and `.R2`, which the detector read as four
separate single-end samples. The script now writes a `sample,r1,r2` sample
sheet into `_scratch` and imports through `--samplesheet`, which states the
pairing and also gives the samples the short names the manual uses.

## Steps that did not complete

Nothing failed outright, but one step finished in a degraded state.

Kraken 2 classification succeeds and writes both `classification.kreport`
and `classification.kraken.gz`. It classifies 98.3 percent of the 85,199
reads and names *Betacoronavirus pandemicum* as the dominant species, which
is the correct answer for this sample. Bracken profiling does not produce a
`classification.bracken` file, and because of that `conda classify` exits
with status 64 even though the classification itself is sound. The Viral
database does carry the `kmer_distrib` files Bracken needs, so this is not a
missing install. The likely cause is that the sample resolves to a single
species at the profiled rank, which leaves Bracken with nothing to
redistribute.

The script treats that case as a warning. It checks for the Kraken 2 report
and continues when the report is there, and fails only when no report was
written. Before that guard was added, the non-zero exit killed the script
under `set -e` and step 7 never ran.

Anyone writing the Kraken 2 chapter should screenshot the Kraken 2 report
rather than a Bracken abundance column, because there is no Bracken output
in this project.
