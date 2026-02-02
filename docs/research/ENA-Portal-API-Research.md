# ENA (European Nucleotide Archive) Portal API Research

**Research Date:** 2026-02-02
**Purpose:** Documenting ENA Portal API for downloading SRA datasets in FASTQ format

---

## 1. ENA Portal API Endpoints

### Base URLs

| Service | URL |
|---------|-----|
| Portal API | `https://www.ebi.ac.uk/ena/portal/api/` |
| FTP Server (Read Data) | `ftp://ftp.sra.ebi.ac.uk/vol1/` |
| FTP Server (HTTP) | `http://ftp.sra.ebi.ac.uk/vol1/` |

### Core Endpoints

#### Search Endpoint
```
https://www.ebi.ac.uk/ena/portal/api/search
```
Performs advanced searches across the ENA database.

**Parameters:**
| Parameter | Description | Example |
|-----------|-------------|---------|
| `result` | Data type to search | `read_run`, `analysis`, `study`, `sample` |
| `query` | Search query string | `library_layout="PAIRED"` |
| `fields` | Comma-separated return fields | `run_accession,fastq_ftp,fastq_bytes` |
| `format` | Output format | `tsv` (default), `json` |
| `limit` | Max results (0 = unlimited) | `100`, `0` |

**Example:**
```
https://www.ebi.ac.uk/ena/portal/api/search?result=read_run&query=library_layout="PAIRED"&fields=run_accession,fastq_ftp,fastq_bytes&format=json&limit=10
```

#### File Report Endpoint (Recommended for Downloads)
```
https://www.ebi.ac.uk/ena/portal/api/filereport
```
Fast, cached access to file metadata. **Bypasses advanced search** for increased speed.

**Parameters:**
| Parameter | Description | Example |
|-----------|-------------|---------|
| `accession` | ENA/SRA accession | `SRR000001`, `ERR000001`, `PRJNA339914` |
| `result` | Report type | `read_run` or `analysis` |
| `fields` | Optional field selection | `run_accession,fastq_ftp,fastq_bytes,fastq_md5` |

**Example:**
```
https://www.ebi.ac.uk/ena/portal/api/filereport?accession=ERR000001&result=read_run&fields=run_accession,fastq_ftp,fastq_bytes,fastq_md5,library_layout,scientific_name
```

#### Metadata Discovery Endpoints
```
# List available result types
https://www.ebi.ac.uk/ena/portal/api/results?dataPortal=ena

# List searchable fields for a result type
https://www.ebi.ac.uk/ena/portal/api/searchFields?result=read_run

# List returnable fields for a result type
https://www.ebi.ac.uk/ena/portal/api/returnFields?result=read_run
```

### Key Fields for `read_run` Result Type

**File-related fields:**
- `fastq_ftp` - FTP URLs for FASTQ files
- `fastq_bytes` - File sizes in bytes
- `fastq_md5` - MD5 checksums
- `fastq_aspera` - Aspera download paths
- `submitted_ftp` - Original submitted file URLs
- `sra_ftp` - SRA format file URLs

**Metadata fields:**
- `run_accession` - Run ID (SRR/ERR/DRR)
- `study_accession` - Study ID
- `sample_accession` - Sample ID
- `experiment_accession` - Experiment ID
- `library_layout` - SINGLE or PAIRED
- `library_strategy` - WGS, RNA-Seq, etc.
- `instrument_platform` - ILLUMINA, PACBIO, etc.
- `scientific_name` - Organism name
- `read_count` - Number of reads
- `base_count` - Total bases

---

## 2. FASTQ Download Process

### File Types Available

| Type | Description | FTP Path |
|------|-------------|----------|
| **Submitted** | Original files as submitted | `/vol1/run/<prefix>/<accession>/` |
| **FASTQ** | ENA-processed/standardized FASTQ | `/vol1/fastq/<prefix>/<suffix>/<accession>/` |
| **SRA** | NCBI SRA format | `/vol1/err/<prefix>/<accession>/` |

**Recommendation:** Use ENA-processed FASTQ files (from `/vol1/fastq/`) for standardized format and naming.

### FTP URL Path Structure

The path structure depends on the accession number length:

#### Standard Accessions (6-digit suffix, e.g., ERR164407)
```
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/<first-6-chars>/<full-accession>/
```
**Example:**
```
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR164/ERR164407/ERR164407.fastq.gz
```

#### Extended Accessions (7+ digit suffix, e.g., ERR6090701)
```
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/<first-6-chars>/<00X>/<full-accession>/
```
Where `<00X>` is the last digit(s) of the accession padded to 3 digits.

**Example:**
```
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR609/001/ERR6090701/ERR6090701_1.fastq.gz
```

### File Naming Conventions

| Layout | Files | Naming Pattern |
|--------|-------|----------------|
| Single-end | 1 file | `<accession>.fastq.gz` |
| Paired-end | 2 files | `<accession>_1.fastq.gz`, `<accession>_2.fastq.gz` |

**Note:** Some paired-end datasets may also have a merged file without `_1`/`_2` suffix.

### Download Methods (by preference)

1. **wget/curl** - Simple command-line tools
   ```bash
   wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR000/ERR000001/ERR000001_1.fastq.gz
   # or use HTTP
   curl -O http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR000/ERR000001/ERR000001_1.fastq.gz
   ```

2. **Aspera** - Faster for large files
   ```bash
   ascp -QT -l 300m -P33001 \
     era-fasp@fasp.sra.ebi.ac.uk:/vol1/fastq/ERR000/ERR000001/ERR000001_1.fastq.gz .
   ```

3. **enaBrowserTools** - Python utilities for batch downloads

4. **Globus** - For very large transfers

---

## 3. Query Examples

### Search by Run Accession (SRR/ERR/DRR)

**File Report (fastest):**
```
https://www.ebi.ac.uk/ena/portal/api/filereport?accession=SRR000001&result=read_run&fields=run_accession,fastq_ftp,fastq_bytes,fastq_md5
```

**Search API:**
```
https://www.ebi.ac.uk/ena/portal/api/search?result=read_run&query=run_accession="ERR000001"&fields=run_accession,fastq_ftp,fastq_bytes
```

### Search by BioProject/Study Accession

Study accessions accept multiple formats: `PRJNA*`, `ERP*`, `SRP*`, `DRP*`

```
https://www.ebi.ac.uk/ena/portal/api/filereport?accession=PRJNA339914&result=read_run&fields=run_accession,fastq_ftp,fastq_bytes,library_layout

# Or via search
https://www.ebi.ac.uk/ena/portal/api/search?result=read_run&query=study_accession="PRJNA339914"&fields=run_accession,fastq_ftp
```

### Filter by Library Layout (Paired/Single-end)

**Paired-end only:**
```
https://www.ebi.ac.uk/ena/portal/api/search?result=read_run&query=library_layout="PAIRED"&fields=run_accession,fastq_ftp,fastq_bytes,library_layout&limit=10
```

**Single-end only:**
```
https://www.ebi.ac.uk/ena/portal/api/search?result=read_run&query=library_layout="SINGLE"&fields=run_accession,fastq_ftp,fastq_bytes,library_layout&limit=10
```

### Combined Queries

**Paired-end Illumina RNA-Seq from a specific organism:**
```
https://www.ebi.ac.uk/ena/portal/api/search?result=read_run&query=library_layout="PAIRED" AND instrument_platform="ILLUMINA" AND library_strategy="RNA-Seq" AND tax_eq(9606)&fields=run_accession,fastq_ftp,fastq_bytes,scientific_name&limit=10
```

**Taxonomy-based search (all species under a taxon):**
```
https://www.ebi.ac.uk/ena/portal/api/search?result=read_run&query=tax_tree(4930)&fields=run_accession,fastq_ftp,scientific_name&limit=10
```
(4930 = Saccharomyces genus)

### Query Operators

| Operator | Usage | Example |
|----------|-------|---------|
| `AND` | Combine conditions | `library_layout="PAIRED" AND instrument_platform="ILLUMINA"` |
| `OR` | Alternative conditions | `study_accession="ERP001" OR study_accession="SRP002"` |
| `tax_eq(id)` | Exact taxon match | `tax_eq(9606)` (human) |
| `tax_tree(id)` | All descendants of taxon | `tax_tree(4930)` (all Saccharomyces) |
| `*` | Wildcard | `sample_alias="ZMB:*"` |

---

## 4. Best Practices

### Rate Limiting

- **Limit:** 50 requests per second
- **Response:** HTTP 429 (Too Many Requests) when exceeded
- **Recommendation:** Implement exponential backoff for retries

```swift
// Example rate limiting approach
let requestsPerSecond = 50
let minDelayBetweenRequests = 1.0 / Double(requestsPerSecond) // 20ms
```

### Recommended Download Approach

1. **Query metadata first** using the File Report API
2. **Validate file sizes** before downloading
3. **Verify MD5 checksums** after download (`.md5` files available in directories)
4. **Use HTTP** instead of FTP (modern browsers don't support FTP)
5. **Implement resume capability** for large files

### Bulk Downloads

For downloading multiple files:

```bash
# 1. Get list of URLs
curl "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=PRJNA339914&result=read_run&fields=fastq_ftp" | \
  tail -n +2 | cut -f1 | tr ';' '\n' > urls.txt

# 2. Download with wget
wget -i urls.txt --continue

# 3. Or use parallel downloads (respect rate limits)
cat urls.txt | xargs -P 4 -I {} wget --continue "http://{}"
```

### Authentication

- **Public data:** No authentication required
- **Private data:** Requires ENA Webin credentials
- Most SRA data mirrored on ENA is publicly accessible

### Error Handling

| HTTP Code | Meaning | Action |
|-----------|---------|--------|
| 200 | Success | Process response |
| 400 | Bad request | Check query syntax |
| 404 | Not found | Verify accession exists |
| 429 | Rate limited | Wait and retry with backoff |
| 500 | Server error | Retry after delay |

---

## 5. Small Test Datasets

### Recommended Test Datasets (< 100MB total)

#### 1. ERR000001 (Paired-end, Yeast)
- **Organism:** Saccharomyces paradoxus W7
- **Layout:** PAIRED
- **Total Size:** ~37.7 MB
- **Files:**
  - `ERR000001_1.fastq.gz` - 31,131,066 bytes (29.7 MB)
  - `ERR000001_2.fastq.gz` - 8,419,976 bytes (8.0 MB)
- **MD5:** `faffa112615331d3a2ad386c42fc31f1`, `c52a4191b85cce2bee202352192d56fd`
- **URLs:**
  ```
  http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR000/ERR000001/ERR000001_1.fastq.gz
  http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR000/ERR000001/ERR000001_2.fastq.gz
  ```

#### 2. ERR000002 (Paired-end, Yeast)
- **Organism:** Saccharomyces paradoxus Y9.6
- **Layout:** PAIRED
- **Total Size:** ~24.6 MB
- **Files:**
  - `ERR000002_1.fastq.gz` - 20,188,278 bytes (19.3 MB)
  - `ERR000002_2.fastq.gz` - 5,639,553 bytes (5.4 MB)
- **MD5:** `05a3470c5ffe5e367dc9bfbaa09876ab`, `5b60e698a8dcb1caead8ee1e015e908c`
- **URLs:**
  ```
  http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR000/ERR000002/ERR000002_1.fastq.gz
  http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR000/ERR000002/ERR000002_2.fastq.gz
  ```

#### 3. DRR000021 (Single-end, Metagenome)
- **Organism:** Microbial mat metagenome
- **Layout:** SINGLE
- **Total Size:** ~43.6 MB
- **Files:**
  - `DRR000021.fastq.gz` - 45,695,271 bytes
- **MD5:** `1ee567af59a8a2e3291f89235da6ea0e`
- **URL:**
  ```
  http://ftp.sra.ebi.ac.uk/vol1/fastq/DRR000/DRR000021/DRR000021.fastq.gz
  ```

### Quick Test Download Commands

```bash
# Paired-end test (ERR000001)
wget http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR000/ERR000001/ERR000001_1.fastq.gz
wget http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR000/ERR000001/ERR000001_2.fastq.gz

# Single-end test (DRR000021)
wget http://ftp.sra.ebi.ac.uk/vol1/fastq/DRR000/DRR000021/DRR000021.fastq.gz

# Verify checksums
echo "faffa112615331d3a2ad386c42fc31f1  ERR000001_1.fastq.gz" | md5sum -c
echo "c52a4191b85cce2bee202352192d56fd  ERR000001_2.fastq.gz" | md5sum -c
echo "1ee567af59a8a2e3291f89235da6ea0e  DRR000021.fastq.gz" | md5sum -c
```

### API Query to Get Test Dataset Metadata

```bash
# Get metadata for all test datasets
curl "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=ERR000001&result=read_run&fields=run_accession,fastq_ftp,fastq_bytes,fastq_md5,library_layout,scientific_name"

curl "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=ERR000002&result=read_run&fields=run_accession,fastq_ftp,fastq_bytes,fastq_md5,library_layout,scientific_name"

curl "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=DRR000021&result=read_run&fields=run_accession,fastq_ftp,fastq_bytes,fastq_md5,library_layout,scientific_name"
```

---

## Quick Reference

### Workflow: Download FASTQ for a Known Accession

```bash
ACCESSION="ERR000001"

# 1. Get metadata
curl -s "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=${ACCESSION}&result=read_run&fields=fastq_ftp,fastq_bytes,fastq_md5"

# 2. Extract URLs (example output parsing)
URLS=$(curl -s "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=${ACCESSION}&result=read_run&fields=fastq_ftp" | tail -1 | tr ';' '\n')

# 3. Download each file
for url in $URLS; do
    wget "http://${url}"
done
```

### URL Templates

| Purpose | Template |
|---------|----------|
| File Report | `https://www.ebi.ac.uk/ena/portal/api/filereport?accession={ACC}&result=read_run&fields=fastq_ftp,fastq_bytes,fastq_md5` |
| Search | `https://www.ebi.ac.uk/ena/portal/api/search?result=read_run&query={QUERY}&fields={FIELDS}` |
| FASTQ Download | `http://ftp.sra.ebi.ac.uk/vol1/fastq/{PREFIX}/{ACCESSION}/{ACCESSION}.fastq.gz` |

---

## Sources

- [ENA Programmatic Access Documentation](https://ena-docs.readthedocs.io/en/latest/retrieval/programmatic-access.html)
- [ENA File Download Guide](https://ena-docs.readthedocs.io/en/latest/retrieval/file-download.html)
- [ENA SRA FTP Structure](https://ena-docs.readthedocs.io/en/latest/retrieval/file-download/sra-ftp-structure.html)
- [ENA Advanced Search Guide](https://ena-docs.readthedocs.io/en/latest/retrieval/programmatic-access/advanced-search.html)
- [ENA File Reports API](https://ena-docs.readthedocs.io/en/latest/retrieval/programmatic-access/file-reports.html)
- [ENA Portal API](https://www.ebi.ac.uk/ena/portal/api/)
- [ENA Browser Documentation](https://ena-browser-docs.readthedocs.io/)
