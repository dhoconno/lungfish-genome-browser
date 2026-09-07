# NVD import fixture

A minimal NVD (Nucleotide Viral Diversity) BLAST results directory,
structured exactly as the CLI's `import nvd` command expects, so the
NVD import chapter can show a real import run against a small,
deterministic dataset.

## Layout

```
results/
  05_labkey_bundling/
    demo_blast_concatenated.csv
```

`import nvd <results-dir>` requires the input directory to contain a
`05_labkey_bundling/` subdirectory holding a `*_blast_concatenated.csv`
(or `.csv.gz`) file. That is the only file the importer reads. No other
NVD pipeline stage directories (`01_` through `04_`) are required for
import, so none are included here.

## Source

`docs/user-manual/fixtures/nvd-demo/results/05_labkey_bundling/demo_blast_concatenated.csv`
is a copy of `Tests/Fixtures/nvd/test_blast_concatenated.csv`. It is renamed
to match the `*_blast_concatenated.csv` naming pattern the importer
scans for. It contains 10 BLAST hit rows across 3 samples (`SampleA`,
`SampleB`, `SampleC`) and 4 contigs, all SARS-CoV-2 hits, used
elsewhere in the test suite as a synthetic NVD parser fixture.

## Verifying the import

```bash
mkdir -p /tmp/nvd-import-check
.build/debug/lungfish-cli import nvd docs/user-manual/fixtures/nvd-demo/results \
  -o /tmp/nvd-import-check --name nvd-demo
```

No layout adjustment was needed. The directory above imported cleanly
on the first attempt. Confirmed on 2026-09-06 against
`lungfish-cli` 2026.9.13 (`.build/debug/lungfish-cli` in the primary
checkout). Output:

```
NVD Import

ℹ Parsing NVD CSV...
ℹ Preparing NVD bundle...
ℹ Creating NVD database...
ℹ Schema created
ℹ Inserting hits 1/10...
...
ℹ Inserting sample metadata...
ℹ Building indices...
ℹ Finalizing...
ℹ Complete
ℹ Copying NVD BAM files...
ℹ Copying NVD FASTA files...
ℹ Writing NVD manifest...
ℹ Writing NVD provenance...
Total hits: 10
Samples   : 3
Contigs   : 4
Output    : nvd-demo

✓ NVD import complete: nvd-demo
```

The resulting bundle (`nvd-demo/`) contains `manifest.json`,
`hits.sqlite`, `analysis-metadata.json`, `.lungfish-provenance.json`,
and empty `bam/`/`fasta/` directories. This fixture's CSV has no
per-sample BAM/FASTA assets on disk to copy, so those steps are
no-ops.

## Committed files

| File | Size |
| --- | --- |
| `results/05_labkey_bundling/demo_blast_concatenated.csv` | 2.7 KB |

Total committed is under 3 KB, well under the fixture-set cap.

## Regenerating

Re-copy from the source of truth if the shared test fixture changes.

```bash
cp Tests/Fixtures/nvd/test_blast_concatenated.csv \
  docs/user-manual/fixtures/nvd-demo/results/05_labkey_bundling/demo_blast_concatenated.csv
```
