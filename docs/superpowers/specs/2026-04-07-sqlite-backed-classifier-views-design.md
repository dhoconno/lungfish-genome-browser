# SQLite-Backed Classifier Views

**Date:** 2026-04-07
**Status:** Draft

## Overview

Replace the JSON manifest / in-memory parsing approach for TaxTriage and EsViritu batch views with SQLite databases. The databases are built by the CLI as a post-processing step after pipeline completion, or by the app on first open if the DB is missing. Unique reads are computed from BAM files during DB construction, not during browsing. The app queries the DB directly for instant display.

## Schema

### TaxTriage — `taxtriage.sqlite`

```sql
CREATE TABLE taxonomy_rows (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sample TEXT NOT NULL,
    organism TEXT NOT NULL,
    tax_id INTEGER,
    status TEXT,
    tass_score REAL NOT NULL,
    reads_aligned INTEGER NOT NULL,
    unique_reads INTEGER,
    pct_reads REAL,
    pct_aligned_reads REAL,
    coverage_breadth REAL,
    mean_coverage REAL,
    mean_depth REAL,
    confidence TEXT,
    k2_reads INTEGER,
    parent_k2_reads INTEGER,
    gini_coefficient REAL,
    mean_baseq REAL,
    mean_mapq REAL,
    mapq_score REAL,
    disparity_score REAL,
    minhash_score REAL,
    diamond_identity REAL,
    k2_disparity_score REAL,
    siblings_score REAL,
    breadth_weight_score REAL,
    hhs_percentile REAL,
    is_annotated INTEGER,
    ann_class TEXT,
    microbial_category TEXT,
    high_consequence INTEGER,
    is_species INTEGER,
    pathogenic_substrains TEXT,
    sample_type TEXT,
    bam_path TEXT,
    bam_index_path TEXT,
    primary_accession TEXT,
    accession_length INTEGER,
    UNIQUE(sample, organism)
);

CREATE INDEX idx_tt_sample ON taxonomy_rows(sample);
CREATE INDEX idx_tt_organism ON taxonomy_rows(organism);
CREATE INDEX idx_tt_tass ON taxonomy_rows(tass_score);

CREATE TABLE metadata (
    key TEXT PRIMARY KEY,
    value TEXT
);
```

All columns sourced from `report/multiqc_data/multiqc_confidences.txt` (34 TSV columns). `unique_reads` computed from BAM deduplication. BAM pointer columns (`bam_path`, `bam_index_path`, `primary_accession`, `accession_length`) resolved during DB construction.

### EsViritu — `esviritu.sqlite`

```sql
CREATE TABLE detection_rows (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sample TEXT NOT NULL,
    virus_name TEXT NOT NULL,
    description TEXT,
    contig_length INTEGER,
    segment TEXT,
    accession TEXT NOT NULL,
    assembly TEXT NOT NULL,
    assembly_length INTEGER,
    kingdom TEXT,
    phylum TEXT,
    tclass TEXT,
    torder TEXT,
    family TEXT,
    genus TEXT,
    species TEXT,
    subspecies TEXT,
    rpkmf REAL,
    read_count INTEGER NOT NULL,
    unique_reads INTEGER,
    covered_bases INTEGER,
    mean_coverage REAL,
    avg_read_identity REAL,
    pi REAL,
    filtered_reads_in_sample INTEGER,
    bam_path TEXT,
    bam_index_path TEXT,
    UNIQUE(sample, accession)
);

CREATE INDEX idx_ev_sample ON detection_rows(sample);
CREATE INDEX idx_ev_virus ON detection_rows(virus_name);
CREATE INDEX idx_ev_assembly ON detection_rows(assembly);
CREATE INDEX idx_ev_reads ON detection_rows(read_count);

CREATE TABLE metadata (
    key TEXT PRIMARY KEY,
    value TEXT
);
```

All columns sourced from `<sample>.detected_virus.info.tsv` (23 TSV columns). `unique_reads` computed from BAM deduplication. BAM at `<sample>_temp/<sample>.third.filt.sorted.bam`.

## CLI Commands

```
lungfish build-db taxtriage <result-dir>
lungfish build-db esviritu <result-dir>
```

### TaxTriage Build Flow

1. Parse `report/multiqc_data/multiqc_confidences.txt` (or `report/all.organisms.report.txt`) for all rows
2. For each sample, locate BAM at `minimap2/<sample>.<sample>.dwnld.references.bam` and index (`.csi` or `.bai`)
3. For each sample, parse `combine/<sample>.combined.gcfmap.tsv` to map organisms to accessions
4. For each (sample, organism), run `samtools idxstats` on the BAM to get accession lengths, then fetch reads and deduplicate (position-strand fingerprint) for `unique_reads`
5. Resolve `primary_accession` (first accession for the organism from gcfmap) and `accession_length`
6. Write all rows plus metadata to `<result-dir>/taxtriage.sqlite`

### EsViritu Build Flow

1. Enumerate sample subdirectories
2. For each sample, parse `<sample>.detected_virus.info.tsv` for all contig-level rows
3. Locate BAM at `<sample>_temp/<sample>.third.filt.sorted.bam` and index `.bai`
4. For each (sample, accession), fetch reads from BAM and deduplicate for `unique_reads`
5. Write all rows plus metadata to `<result-dir>/esviritu.sqlite`

### Common CLI Behavior

- Progress reported to stdout (for Operations Panel capture)
- Exit 0 on success, non-zero on failure
- If DB already exists, skip (use `--force` to rebuild)
- Metadata table stores: tool version, build timestamp, source file paths, row count, sample count

## App Integration

### Opening a Result

1. Sidebar click triggers display method
2. Check for `taxtriage.sqlite` / `esviritu.sqlite` in the result directory
3. **If DB exists:** Open it, create the VC, call `configureFromDatabase(_:)`. Instant.
4. **If DB missing:** Show placeholder viewport, run `lungfish build-db` as subprocess via Operations Panel. When complete, replace placeholder with DB-backed view.

### Placeholder Viewport

When the user clicks a result that lacks a SQLite DB:

- Viewport shows a centered placeholder (same pattern as "Select an organism to view details"):
  - Icon: `gearshape.2` SF Symbol
  - Title: "Building database for TaxTriage results..."
  - Subtitle: "Check the Operations Panel for progress."
- Operations Panel shows live progress: "Building TaxTriage database (42/149 samples...)"
- User can navigate away freely — the build continues in background
- When build completes and user is still viewing this result, placeholder is replaced with the full DB-backed view
- On failure, placeholder shows error message with "Retry" button

### View Controller Changes

**TaxTriageResultViewController:**
- New `configureFromDatabase(_ db: TaxTriageDatabase)` method replaces `configure(result:)` for multi-sample and `configureBatchGroup()`
- Queries `db.fetchRows(samples:)` filtered by `ClassifierSamplePickerState.selectedSamples`
- Row selection provides `bam_path`, `bam_index_path`, `primary_accession`, `accession_length` directly from the row — no lookups needed for miniBAM

**EsVirituResultViewController:**
- New `configureFromDatabase(_ db: EsVirituDatabase)` method replaces `configureBatch()`
- Same query/filter/display pattern

### What Gets Replaced

- JSON manifests: `taxtriage-batch-manifest.json`, `esviritu-batch-aggregated.json`, `batch-unique-reads.json`
- In-memory TSV parsing in `configureBatch`/`configureBatchGroup`/`enableMultiSampleFlatTableMode`
- Background unique reads computation in the app (`scheduleBatchPerSampleUniqueReadComputation`, `scheduleBatchUniqueReadComputation`)
- `perSampleDeduplicatedReadCounts` dictionary and `syncUniqueReadsToFlatTable`
- `persistDeduplicatedReadCounts`, `persistBatchUniqueReads`, `updateBatchManifestUniqueReads`
- "Recompute Unique Reads" button (replaced by `lungfish build-db --force`)

### What Stays

- `BatchTableView` base class and subclasses (display layer)
- Inspector sections (operation details, sample picker, source samples, metadata import)
- `ClassifierSamplePickerState` filtering
- Summary bars
- Single-sample Kraken2 (kreport tree view — no DB)
- MiniBAM viewer (receives data from DB rows instead of dictionary lookups)
- `MetadataColumnController` for dynamic columns

## Database Classes

### TaxTriageDatabase

Located in `Sources/LungfishIO/Formats/TaxTriage/TaxTriageDatabase.swift`. Follows the `NaoMgsDatabase` and `NvdDatabase` patterns:

- `init(at: URL)` — opens existing DB
- `static func create(at: URL)` — creates new DB with schema
- `func fetchRows(samples: [String]) -> [TaxTriageTaxonomyRow]`
- `func fetchSamples() -> [(sample: String, organismCount: Int)]`
- `func fetchMetadata() -> [String: String]`
- `func insertRow(_:)` / `func insertRows(_:)`
- `func setMetadata(key:value:)`

### EsVirituDatabase

Located in `Sources/LungfishIO/Formats/EsViritu/EsVirituDatabase.swift`. Same pattern:

- `init(at: URL)` / `static func create(at: URL)`
- `func fetchRows(samples: [String]) -> [EsVirituDetectionRow]`
- `func fetchSamples() -> [(sample: String, detectionCount: Int)]`
- `func fetchMetadata() -> [String: String]`
- `func insertRow(_:)` / `func insertRows(_:)`

## Testing Strategy

### Test Fixtures

Extract a small subset (3-5 samples) from the existing results at `/Volumes/nvd_remote/TGS-air-VSP2.lungfish/Analyses/`:

- `Tests/Fixtures/taxtriage-mini/`: confidence TSV, per-sample organism reports, gcfmap files, minimal BAM (subset to a few contigs)
- `Tests/Fixtures/esviritu-mini/`: per-sample detection TSVs, coverage windows, minimal BAM

Committed to the repo for reproducible testing.

### Test Levels

**1. Database unit tests** (`TaxTriageDatabaseTests`, `EsVirituDatabaseTests`):
- Schema creation
- Insert and query rows
- Sample filtering (`fetchRows(samples:)`)
- Sorting by each column
- Metadata round-trip
- Unique reads storage and retrieval
- BAM path storage and retrieval

**2. CLI integration tests** (`BuildDbCommandTests`):
- `lungfish build-db taxtriage <fixture-dir>` produces valid `taxtriage.sqlite`
- `lungfish build-db esviritu <fixture-dir>` produces valid `esviritu.sqlite`
- Row counts match expected
- Unique reads are non-zero where BAMs exist
- BAM paths correctly resolved
- `--force` rebuilds existing DB
- Skip when DB already exists

**3. VC integration tests** (`TaxTriageDatabaseViewTests`, `EsVirituDatabaseViewTests`):
- `configureFromDatabase` populates the flat table correctly
- Sample filtering via `ClassifierSamplePickerState` queries the DB
- Row selection provides correct BAM path for miniBAM
- Placeholder shown when DB missing
- Placeholder replaced when DB build completes

**4. Regression tests**:
- No viewport bounce
- Unique reads match between table and miniBAM
- No stale data issues
- Single-sample mode unaffected

## Scope

### In Scope

- SQLite databases for TaxTriage and EsViritu batch/multi-sample views
- CLI `build-db` commands for both tools
- App-side DB opening and querying
- Automatic DB build on first open (non-blocking, with placeholder)
- All fields from TSV output stored in DB
- BAM coordinate pointers in DB rows
- Unique reads computed from BAM during DB build
- Comprehensive test suite with real data fixtures
- Operations Panel progress during DB build
- Provenance metadata in DB

### Out of Scope

- Kraken2 SQLite (kreport tree view works differently — single-sample outline, not flat table)
- Pivot table feature (separate spec)
- NVD-style filter bars on all columns (separate spec)
- Changes to single-sample viewing
