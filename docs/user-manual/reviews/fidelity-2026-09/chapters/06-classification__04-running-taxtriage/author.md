# Author report, 06-classification/04-running-taxtriage

Chapter 35 of the campaign roster. Registry id `classify.taxtriage`, fixture
`sarscov2-srr36291587`. Rewritten in place on 2026-09-07 against Preview
2026.9.13.

Lint result, verbatim:

```
docs/user-manual/chapters/06-classification/04-running-taxtriage.md: no issues found
```

## Machine state

TaxTriage could run on this machine, so the chapter is written from real runs
rather than from source alone.

- `lungfish-cli taxtriage check-prerequisites` reported Nextflow v26.04.6 and a
  container runtime of Docker, closing with "All prerequisites met. Ready to run
  TaxTriage."
- Docker Desktop was installed and running (`docker info` succeeded).
- `lungfish-cli conda db list` showed four ready Kraken 2 databases, Viral
  (0.5 GB), Standard-16, SILVA, and NCBI Taxonomy. `conda db info Viral` gave
  the on-disk path `/Users/dho/.lungfish/databases/kraken2/viral`, version
  20260626, 1.17 GB on disk.
- `lungfish-cli conda db install-managed --list` printed only `human-scrubber`,
  `deacon-panhuman`, and `deacon-ribokmers`, which are host-depletion helper
  datasets, none of them a TaxTriage database. This is one more piece of
  evidence that TaxTriage has no database of its own.

## Runs made

Both runs used the reads copied from the chapter 33 scratch, 83,591 read pairs
(334,364 lines in R1). Everything was written under the chapter 35 scratch at
`.../scratchpad/taxtriage/`. Nothing was written to `~/Desktop/lge-docs`.

### Run 1, single sample

```
lungfish-cli taxtriage run --input extract_1_R1.fastq.gz \
  --input2 extract_1_R2.fastq.gz --sample SRR36291587 \
  --platform illumina --db ~/.lungfish/databases/kraken2/viral \
  --output ./run-viral
```

Exit 0. Runtime 72.2s. Samples 1, Reports 5, Metrics 8, Krona visualizations 1,
Total output files 106. Container images were already cached from earlier work
on this machine, so this figure is a warm-cache figure and the chapter says so.

Counts from `report/SRR36291587.odr.txt`, one row only:

| Field | Value |
|---|---|
| Detected Organism | Severe acute respiratory syndrome coronavirus 2 |
| Taxonomic ID | 2697049 |
| TASS Score | 99 |
| % Reads | 97.5171 |
| # Reads Aligned | 163,031 |
| Breadth % | 100.0 |
| Mean Depth | 1249.7 |
| K2 Reads | 82,234 |
| Genome Length | 29,903 |
| TASS Threshold | 75.0, Passes Threshold TRUE |

From `kraken2/SRR36291587.kraken2.report.txt`, 82,234 read pairs assigned to
the species and 1 read unclassified.

`build-db taxtriage run-viral` reported "Parsed 15 taxonomy rows, 2 accession
entries from top report fallback", built 15 rows, marked duplicates in 1 BAM,
and freed 267 MB on cleanup. Querying the resulting SQLite gave the SARS-CoV-2
row at 165,500 reads aligned and 5,690 unique reads after deduplication, with
primary accession NC_045512.2.

### Run 2, two samples

A second sample was made by taking the first 10,000 read pairs of the same
library, so the batch is one full library plus one thinner copy of it. Both were
declared through a samplesheet CSV.

Exit 0. Runtime 85.5s. Samples 2, Reports 9, Metrics 10, Krona visualizations 1,
Total output files 135.

Per-sample organism detection reports:

| Sample | TASS | Breadth % | Mean Depth | K2 Reads | % Reads |
|---|---|---|---|---|---|
| SRR36291587 | 99 | 100.0 | 1249.7 | 82,234 | 97.5171 |
| SRR36291587sub | 99 | 100.0 | 149.5 | 9,851 | 97.5400 |

`build-db taxtriage run-batch` reported "Parsed 29 taxonomy rows, 4 accession
entries from top report fallback". SQLite gave 165,500 / 5,690 reads for the
full sample and 19,805 / 1,785 for the subsample.

The batch run is what let me describe the batch overview and the multi-sample
export items with confidence rather than from source reading alone.

## App defect found

**Every TASS score in the viewport reads 0.000 on the pinned pipeline
revision.** This is the most important finding of the chapter and it is
documented in a dedicated subsection of Reading the results.

The evidence chain:

1. The pipeline scores the SARS-CoV-2 call at 99 in
   `report/<sample>.odr.txt`, on a 0 to 100 scale.
2. `BuildDbCommand.parseSingleTaxTriageResult` looks first for
   `report/multiqc_data/multiqc_confidences.txt`. That file is absent from both
   runs. The pinned revision `e10bfeb...` (release v3.3.8) does not emit it, and
   the code comment at `BuildDbCommand.swift:816-819` already anticipates
   "newer pipeline revisions that no longer emit multiqc_confidences.txt".
3. LGE therefore takes the `top/*.top_report.tsv` fallback, whose schema carries
   no TASS column, and both builds announce that in their own output with the
   phrase "from top report fallback".
4. `SELECT DISTINCT tass_score FROM taxonomy_rows` returns exactly one value,
   `0.0`, on both the single-sample and the two-sample database.

The consequence is that the viewport's TASS Score column, its Confidence bar,
the High Confidence summary card, the batch overview's default TASS facet, and
the exported organism matrix's Mean TASS column are all uniformly zero, and the
tooltip on every row therefore reads the "Low confidence (<0.40)" text. The
counts, unique-read counts, accession, and taxonomy identifier are all correct,
so only the score is affected.

A secondary observation that would matter if the primary file were restored:
`TaxTriageMetricsParser` normalises coverage from a 0-1 fraction to a
percentage (`normalizeCoverage`, line 251) but performs no equivalent
normalisation on `tassScore`, while its own doc comment at line 311 declares the
field to be "0.0 to 1.0". The pipeline's own report writes 99. Whichever file
LGE ends up reading, the scale needs checking against the 0.80 and 0.40 band
boundaries in `TaxTriageResultViewController.confidenceLabel` and
`TaxTriageConfidenceCellView.color(for:)`.

## What was removed from the old chapter, and why

The old chapter was substantially fictional. The following claims were deleted.

- **A separate TaxTriage database and a TaxTriage Plugin Manager entry.** There
  is none. `TaxTriageWizardSheet.swift:426-450` renders a picker headed
  "Kraken2 Database" fed from the installed Kraken 2 collections, `--db` is
  documented as "Path to existing Kraken2 database", and `PluginPack.swift`
  defines no TaxTriage pack and no "Classification" plugin category. Replaced
  with a Before-you-start paragraph pointing at the Kraken 2 chapter's database
  step.
- **"tens of gigabytes" for the database.** Replaced with the real range, 0.5 GB
  for Viral to 72 GB for PlusPF, since the size is entirely the user's choice.
- **The "Database not installed" warning text.** The wizard shows "No Kraken2
  databases installed". Corrected verbatim.
- **`Tools > FASTQ/FASTA Operations > Classification...` as a menu path.**
  That is a dialog title, never a menu, per CONSISTENCY.md. Replaced with
  **Tools > Classification > TaxTriage...**, matching the sibling chapters.
- **The batch overview as a tab.** It is not a tab. It appears when the sample
  filter's All Samples segment is selected and more than one sample is loaded,
  and it replaces the per-sample table
  (`TaxTriageResultViewController.applyCurrentSampleFilter`, around line 1373).
  Rewritten as a filter, and the shot caption no longer implies a tab.
- **The cross-sample SNP table.** Deleted entirely. `StrainComparisonView` is
  `internal` and instantiated only from a test target, so it is unreachable in
  the shipping app.
- **"The exporter writes two files to a folder you choose."** It does not. The
  Export button opens a menu with Export as CSV..., Export as TSV..., Copy
  Summary, and, only on a multi-sample result, Export Organism Matrix (CSV)...
  and Export Batch Report.... Each writes one file through its own save panel.
  Rewritten from `buildExportMenu`.
- **The hypothetical four-sample clinical batch** (`patient-A.fastq.gz` and
  friends). Replaced with the campaign fixture and real runs, since the campaign
  forbids invented data and the old walkthrough quoted no measured value at all.
- **"A four-sample batch takes a few minutes per sample on Apple Silicon."**
  Replaced with the two measured runtimes and an explicit note that a cold first
  run is slower because Nextflow must pull container images.
- **The Skip Krona toggle described as sitting beside Skip assembly.** It is
  inside Advanced Settings and defaults to off. Moved and corrected.
- **`lungfish taxtriage run` and `lungfish conda db ...` as command names.** The
  binary is `lungfish-cli`. Corrected throughout.

## How each DRIFT unverifiable row was settled

| Row | Claim | Settlement |
|---|---|---|
| 1 | "the TASS score (the TaxTriage Aggregate Scoring System)" | **Corrected, not deleted.** The old expansion is wrong. `TaxTriageMetricsParser.swift:9` and `:311` expand TASS as the **Taxonomic Assignment Scoring System**, and that is a citable in-app source, which the ground-truth map had not found. The chapter uses that expansion, attributes it to LGE's own parser rather than to the upstream project, and says plainly that the upstream project publishes no expansion the app can cite. |
| 28 | "Reference-dependent controls are enabled only when Lungfish can validate the exact downloaded reference record against the BAM; otherwise the Inspector reports reference-free mode." | **Deleted.** "reference-free" appears nowhere in `Sources/`, and I could not reproduce the state from a real run. The chapter now says only what the alignment pane does, which is to load the selected row's supporting reads against the reference the pipeline mapped them to, and refers the reader to the general alignment viewer for its controls. Nothing is asserted about a mode that could not be observed. |
| 35 | "A four-sample batch takes a few minutes per sample on Apple Silicon." | **Replaced with measured figures.** 72.2s for one sample and 85.5s for two, both warm-cache, both stated as such, with the cold-start caveat about image pulling stated separately and without a number, since I did not measure a cold start. |

The DRIFT row 29 instruction to "verify the row context menu in the running app
before naming a right-click item" was settled from source instead, since the
campaign forbids me launching the GUI. `TaxTriageOrganismTableView.setupContextMenu`
(around `TaxTriageResultViewController.swift:4579`) builds a menu whose first
item is titled "Verify with BLAST\u{2026}", followed by Copy Organism Name, Copy
Accession Number, Copy TaxID, and Copy Row as TSV. The action bar's button is
"BLAST Verify" (`ClassifierActionBar.swift:24`). The chapter names both, which
resolves the apparent contradiction in the drift report. A screenshot pass
should confirm the menu.

## Missing features now covered

Every row of the DRIFT "Missing" table is now in the chapter. The per-sample
role picker with all five values, the Add Sample and Remove buttons, the
Prerequisites indicators with their green and orange dots and the runtime named
by detection, the Max CPUs stepper, the Extra arguments field, the batch
overview's value-facet control with its four facets, the sample-filter
segmented control as the route to the batch overview, `--rank`, `--max-cpus`,
`--revision`, `--extra-args`, `--recursive`, and both `import taxtriage` and
`build-db taxtriage`.

## Shot markers

Four markers, four matching `shots` entries. The old front matter's four
`planned_shots` were reworked rather than carried over.

| id | Change from the old planned shot |
|---|---|
| `taxtriage-dialog` | Renamed from `taxtriage-wizard-tool-step`. Recaptioned to name the FASTQ/FASTA Operations dialog and to frame the Prerequisites indicators and the per-sample role pickers, as the drift report asked. Sits in step 1, beside the prerequisites text. |
| `taxtriage-advanced-settings` | New, matching the sibling chapters' pattern of showing the Advanced Settings disclosure. Names all six controls inside it. |
| `taxtriage-result-table` | Kept. Moved out of the batch-blank step and placed at the end of the procedure, where the viewport first opens, per the drift report's placement note. Recaptioned to the real three-part layout. |
| `taxtriage-batch-overview` | Kept, recaptioned so it no longer implies a tab, and framed to include the value-facet control. |
| `taxtriage-batch-export` | Dropped. The exporter is a menu of five items rather than a screen worth a shot, and the matrix it writes is a CSV file rather than a UI surface. The prose describes both instead. |

## Glossary additions

Three terms added to `GLOSSARY.md` in the existing shape, alphabetised, and
declared in `glossary_refs`.

- **Negative control** `{#negative-control}`, placed in N between Newick and
  Nextflow.
- **Samplesheet** `{#samplesheet}`, placed in S before samtools. Deliberately
  distinct from the existing **Sample sheet** entry, which is the FASTQ-import
  CSV requiring `sample`, `r1`, `r2` columns. The TaxTriage samplesheet is a
  Nextflow input with `sample`, `fastq_1`, `fastq_2`, `platform`, so the two
  are different files and the entries cross-reference each other.
- **TASS score** `{#tass-score}`, placed in T after Tabix. Carries the LGE
  expansion, the two band boundaries, and the warning that it is a ranking
  rather than a calibrated probability.

**TaxTriage** already existed and needed no change. **Nextflow**, **Container**,
and **Docker** already existed and are linked rather than redefined.

## Consistency notes

- The fixed Before-you-start opener is used verbatim, adapted to the SRA fixture
  the way chapters 33 and 34 adapt it.
- The fixed Docker sentence from CONSISTENCY.md is used verbatim.
- The run lands under `Analyses/taxtriage-<timestamp>/`, matching the
  consistency sheet's `knownTools` rule.
- The chapter states that TaxTriage classifies against an installed Kraken 2
  database, which is what chapters 01 and 02 already say, so the part now agrees
  with itself on tools, databases, and dialog.
- No per-classifier colour is claimed anywhere, since none exists in the app.
- `prereqs` gained `06-classification/02-running-kraken2`, because the database
  step genuinely lives there now.

## Open items for later phases

- Phase 5 should confirm the TASS-zero defect against the GUI, since everything
  above was established from the CLI and the built SQLite. If the app is fixed
  before the manual ships, the "A reporting gap you must know about" subsection
  and the last paragraph of What good looks like both need revisiting.
- A cold-start runtime figure would be worth measuring once, since a first-run
  container pull is the slowest part of the experience and the chapter can
  currently only say it is slower without saying by how much.
- The row context menu should be confirmed by screenshot when the Screenshot
  Scout captures `taxtriage-dialog` and `taxtriage-result-table`.

## Rerun on the raw reads (2026-09-07)

The two runs recorded above were made against `extract_1_R1.fastq.gz` and
`extract_1_R2.fastq.gz`, which are the 83,591 read pairs that Kraken 2 had
already pulled out of SRR36291587 as SARS-CoV-2. That is not the file the
reader has in hand at this point in the manual. The reader arrives at the
TaxTriage chapter holding the raw SRA bundle, 85,199 pairs of 251 bp reads,
and runs the tool on that. Feeding TaxTriage a set of reads a classifier has
already filtered changes every count in the chapter, and it also changes the
shape of the result, because a pre-filtered library contains almost no
unclassified reads while the raw library contains 770 of them. Every figure
the chapter quotes must therefore come from the raw-read runs recorded below,
not from the runs above. The original sections are kept for the record.

### Inputs

Both raw FASTQ files were gzipped first, since the CLI expects compressed
input.

```
gzip -c .../scratchpad/kraken2/reads/SRR36291587_1.fastq \
  > .../scratchpad/taxtriage/raw-inputs/SRR36291587_R1.fastq.gz
gzip -c .../scratchpad/kraken2/reads/SRR36291587_2.fastq \
  > .../scratchpad/taxtriage/raw-inputs/SRR36291587_R2.fastq.gz
```

| Property | Value |
|---|---|
| Read pairs | 85,199 |
| Lines in R1 | 340,796 |
| Read length | 251 bp |
| R1 gzipped size | 12,197,009 bytes |
| R2 gzipped size | 13,899,717 bytes |

### Run 1 on the raw reads, single sample

```
lungfish-cli taxtriage run \
  --input raw-inputs/SRR36291587_R1.fastq.gz \
  --input2 raw-inputs/SRR36291587_R2.fastq.gz \
  --sample SRR36291587 \
  --platform illumina \
  --db /Users/dho/.lungfish/databases/kraken2/viral \
  --output ./run-raw
```

Exit 0. Output under `.../scratchpad/taxtriage/run-raw/`.

| Summary line | Raw reads | Was, extracted reads |
|---|---|---|
| Runtime | 73.4s | 72.2s |
| Samples | 1 | 1 |
| Reports | 5 | 5 |
| Metrics | 8 | 8 |
| Krona visualizations | 1 | 1 |
| Total output files | 106 | 106 |

Both are warm-cache figures, since the container images were already pulled on
this machine.

`report/SRR36291587.odr.txt` holds one detection row. Every field of it, in
file order.

| Field | Value |
|---|---|
| Index | 0 |
| index | 0 |
| Detected Organism | Severe acute respiratory syndrome coronavirus 2 |
| Specimen ID | SRR36291587 |
| Sample Type | unknown |
| % Reads | 96.9542 |
| # Reads Aligned | 165208 |
| % Aligned Reads | 96.9542 |
| Coverage | 100% |
| HHS Percentile | 100.0 |
| IsAnnotated | Yes |
| AnnClass | Derived |
| Microbial Category | Primary |
| High Consequence | True |
| Mol Type | rna |
| Taxonomic ID # | 2697049 |
| Status | established |
| Gini Coefficient | 1.00 |
| Mean BaseQ | 37.40 |
| Mean MapQ | 55.57 |
| Mean Depth | 1258.7 |
| Covered Bases | 33878 |
| Genome Length (bp) | 29903 |
| Breadth % | 100.0 |
| isSpecies | False |
| Pathogenic Subsp/Strains | (empty) |
| K2 Reads | 82983 |
| RPKM | 33441.460723004384 |
| RPM | 1000000.0 |
| Parent K2 Reads | 0 |
| MapQ Score | 1.00 |
| Disparity Score | 1.00 |
| Minhash Score | 1.00 |
| Diamond Identity | 0.0 |
| K2 Disparity Score | 0.0 |
| Siblings score | 0.0 |
| Breadth Weight Score | 1.00 |
| TASS Score | 99 |
| MicrobeRT Probability | 0.0000 |
| MicrobeRT Model | (empty) |
| Reads Aligned | 165208 |
| Group | 1 |
| Subkey | 3418604 |
| Superkingdom | (empty) |
| Phylum | Pisuviricota |
| Class | Pisoniviricetes |
| Order | Nidovirales |
| Family | Coronaviridae |
| Genus | Betacoronavirus |
| Flora Sites | (empty) |
| Passes Threshold | TRUE |
| TASS Threshold | 75.0 |

Two oddities in that row are worth a note before the chapter quotes any of it.
`Covered Bases` reads 33,878 against a `Genome Length (bp)` of 29,903, so the
covered figure exceeds the genome it is measured against and cannot be a plain
base count. `isSpecies` reads False on a row whose rank is plainly a species.
Neither field should be quoted in the chapter without checking what the
pipeline means by it.

`report/multiqc_data/multiqc_confidences.txt` is **absent** from this run as
well, so the TASS-zero defect described above reproduces unchanged on the raw
reads.

The full Kraken 2 report, `kraken2/SRR36291587.kraken2.report.txt`, is 15 lines.
All of them, with the percentage, clade-rooted read count, direct read count,
rank code, and taxonomy identifier.

| % | Clade reads | Direct reads | Rank | TaxID | Name |
|---|---|---|---|---|---|
| 0.92 | 770 | 770 | U | 0 | unclassified |
| 99.08 | 83009 | 0 | R | 1 | root |
| 99.08 | 83009 | 0 | R1 | 10239 | Viruses |
| 99.08 | 83009 | 0 | R2 | 2559587 | Riboviria |
| 99.08 | 83009 | 0 | K | 2732396 | Orthornavirae |
| 99.08 | 83009 | 0 | P | 2732408 | Pisuviricota |
| 99.08 | 83009 | 0 | C | 2732506 | Pisoniviricetes |
| 99.08 | 83009 | 0 | O | 76804 | Nidovirales |
| 99.08 | 83009 | 0 | O1 | 2499399 | Cornidovirineae |
| 99.08 | 83009 | 0 | F | 11118 | Coronaviridae |
| 99.08 | 83009 | 0 | F1 | 2501931 | Orthocoronavirinae |
| 99.08 | 83009 | 0 | G | 694002 | Betacoronavirus |
| 99.08 | 83009 | 9 | G1 | 2509511 | Sarbecovirus |
| 99.07 | 83000 | 17 | S | 3418604 | Betacoronavirus pandemicum |
| 99.05 | 82983 | 82983 | S1 | 2697049 | Severe acute respiratory syndrome coronavirus 2 |

There is exactly one species-rank row, `Betacoronavirus pandemicum` at 83,000
clade reads, and the SARS-CoV-2 call the chapter cares about sits one level
below it at rank S1 with 82,983 reads. The 770 unclassified reads are the
visible difference from the extracted-read run, which had only 1.

### Run 1 database build and queries

```
lungfish-cli build-db taxtriage run-raw
```

Exit 0. Output verbatim:

```
Parsed 15 taxonomy rows, 2 accession entries from top report fallback
Built database at .../run-raw/taxtriage.sqlite with 15 rows
Running markdup on 1 BAM file(s)...
  Marked duplicates in 1 BAM file(s)
Counting reads per organism...
  Updated accession lengths for 1 organisms
  Updated read counts for 1/1 organisms
Cleanup complete. Freed 268.2 MB
```

The "from top report fallback" phrase appears here too, so the fallback path
that zeroes the TASS score is taken on the raw reads exactly as it was on the
extracted reads.

| Query | Result |
|---|---|
| Rows parsed, from build output | 15 |
| `SELECT COUNT(*) FROM taxonomy_rows` | 15 |
| Organism rows for the viewport's Organisms card | 15 |
| `SELECT DISTINCT tass_score FROM taxonomy_rows` | `0.0`, a single value |
| SARS-CoV-2 `reads_aligned` | 168,265 |
| SARS-CoV-2 `unique_reads` | 6,865 |
| SARS-CoV-2 `k2_reads` | 82,983 |
| SARS-CoV-2 `primary_accession` | NC_045512.2 |
| SARS-CoV-2 `accession_length` | 29,903 |
| Accession entries | 2, NC_004718.3 and NC_045512.2 |

There is no `organisms` table in the schema. The tables are `taxonomy_rows`,
`accession_map`, `metadata`, and `lungfish_database_state`, and
`taxonomy_rows` is the organism table the viewport reads, so the Organisms
card count is the 15 above rather than a count of species-rank calls.

Two numbers in the chapter must not be conflated. The pipeline's own
`report/SRR36291587.odr.txt` says **165,208** reads aligned. The SQLite
database LGE builds from the same run says **168,265**. The database figure is
recounted from the BAM after duplicate marking, which is a different
measurement from the one the pipeline wrote, and it is the larger of the two.
Whichever the chapter quotes, it must name the source.

### Run 2 on the raw reads, two samples

The second sample is the first 10,000 read pairs of the same raw library, made
the same way the original Run 2 made its subsample, so the batch is one full
raw library plus one thinner copy of it. Both were declared through a
samplesheet CSV.

```
gzcat raw-inputs/SRR36291587_R1.fastq.gz | head -40000 | gzip \
  > batch-inputs-raw/sub_R1.fastq.gz
gzcat raw-inputs/SRR36291587_R2.fastq.gz | head -40000 | gzip \
  > batch-inputs-raw/sub_R2.fastq.gz

lungfish-cli taxtriage run \
  --samplesheet batch-samplesheet-raw.csv \
  --platform illumina \
  --db /Users/dho/.lungfish/databases/kraken2/viral \
  --output ./run-batch-raw
```

The samplesheet carries the columns `sample,fastq_1,fastq_2,platform` with
`ILLUMINA` as the platform value for both rows.

Exit 0.

| Summary line | Raw reads | Was, extracted reads |
|---|---|---|
| Runtime | 86.2s | 85.5s |
| Samples | 2 | 2 |
| Reports | 9 | 9 |
| Metrics | 10 | 10 |
| Krona visualizations | 1 | 1 |
| Total output files | 135 | 135 |

Per-sample organism detection reports.

| Sample | TASS | Breadth % | Mean Depth | K2 Reads | % Reads | # Reads Aligned |
|---|---|---|---|---|---|---|
| SRR36291587 | 99 | 100.0 | 1258.7 | 82,983 | 96.9542 | 165,208 |
| SRR36291587sub | 99 | 100.0 | 147.7 | 9,748 | 96.9900 | 19,398 |

The full-library row is identical to the Run 1 row, which is the expected
result, since it is the same reads through the same pipeline.

The subsample's Kraken 2 report carries 92 unclassified reads against 9,754
classified, and its species-rank row is `Betacoronavirus pandemicum` at 9,752
clade reads with the SARS-CoV-2 S1 row at 9,748.

### Run 2 database build and queries

```
lungfish-cli build-db taxtriage run-batch-raw
```

Exit 0. Output verbatim:

```
Parsed 30 taxonomy rows, 4 accession entries from top report fallback
Built database at .../run-batch-raw/taxtriage.sqlite with 30 rows
Running markdup on 2 BAM file(s)...
  Marked duplicates in 2 BAM file(s)
Counting reads per organism...
  Updated accession lengths for 2 organisms
  Updated read counts for 2/2 organisms
Cleanup complete. Freed 271 MB
```

Note that this is **30** rows, 15 per sample, not the 29 the original Run 2
recorded. The chapter must use 30.

| Query | Result |
|---|---|
| Rows parsed | 30 |
| `SELECT COUNT(*) FROM taxonomy_rows` | 30 |
| Rows for SRR36291587 | 15 |
| Rows for SRR36291587sub | 15 |
| `SELECT DISTINCT tass_score FROM taxonomy_rows` | `0.0`, a single value |
| Accession entries | 4, two per sample |

| Sample | reads_aligned | unique_reads | k2_reads | primary_accession |
|---|---|---|---|---|
| SRR36291587 | 168,265 | 6,865 | 82,983 | NC_045512.2 |
| SRR36291587sub | 19,778 | 2,002 | 9,748 | NC_045512.2 |

### What changes in the chapter

Every count the chapter currently quotes came from the Kraken 2 extraction and
must be replaced with the raw-read figure beside it.

| Figure | Chapter currently says | Must say |
|---|---|---|
| Run 1 runtime | 72.2s | 73.4s |
| Run 2 runtime | 85.5s | 86.2s |
| % Reads | 97.5171 | 96.9542 |
| # Reads Aligned, from the report | 163,031 | 165,208 |
| Mean Depth | 1249.7 | 1258.7 |
| K2 Reads | 82,234 | 82,983 |
| Unclassified reads | 1 | 770 |
| Reads aligned, from SQLite | 165,500 | 168,265 |
| Unique reads, from SQLite | 5,690 | 6,865 |
| Run 2 subsample Mean Depth | 149.5 | 147.7 |
| Run 2 subsample K2 Reads | 9,851 | 9,748 |
| Run 2 subsample % Reads | 97.5400 | 96.9900 |
| Run 2 subsample SQLite reads | 19,805 / 1,785 | 19,778 / 2,002 |
| Run 2 rows parsed | 29 | 30 |

The TASS score of 99, the breadth of 100.0, the taxonomy identifier 2697049,
the primary accession NC_045512.2, the genome length of 29,903, the 15-row
organism count, and the whole TASS-zero defect chain are unchanged, so the
chapter's argument survives the correction intact. Only the counts move.
