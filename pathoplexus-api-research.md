# Pathoplexus & LAPIS API -- Comprehensive Research Report

**Date:** 2026-03-05

---

## 1. Overview

Pathoplexus is an open-source, non-profit pathogen sequence database focused on equitable data sharing, transparent governance, and global public health. It is built on the Loculus platform and uses LAPIS (Lightweight API for Sequences) as its query engine. The platform synchronizes bidirectionally with INSDC databases (NCBI GenBank, ENA, DDBJ).

- **Main site:** https://pathoplexus.org
- **API docs:** https://pathoplexus.org/api-documentation
- **Backend API:** https://backend.pathoplexus.org (Swagger UI at /swagger-ui/index.html)
- **Authentication:** Keycloak at https://authentication.pathoplexus.org
- **Demo instance:** https://demo.pathoplexus.org

---

## 2. Available Organisms (10 pathogens)

Each organism has its own LAPIS endpoint at `https://lapis.pathoplexus.org/{slug}/`.

| Organism | URL Slug | Approx. Sequences | Segments |
|----------|----------|-------------------|----------|
| Crimean-Congo Hemorrhagic Fever Virus | `cchf` | 2,875 | L, M, S |
| Ebola Sudan | `ebola-sudan` | 166 | single |
| Ebola Zaire | `ebola-zaire` | 3,794 | single |
| HMPV (Human Metapneumovirus) | `hmpv` | 14,851 | single |
| Marburg Virus | `marburg` | 403 | single |
| Measles Virus | `measles` | 28,135 | single |
| Mpox Virus | `mpox` | ~15,000 | single |
| RSV-A | `rsv-a` | 38,791 | single |
| RSV-B | `rsv-b` | 29,391 | single |
| West Nile Virus | `west-nile` | 8,772 | single |

**Total:** ~140,000+ sequences. Note: SARS-CoV-2 is NOT on Pathoplexus (it lives on cov-spectrum.org/GISAID).

Multi-segmented organisms (CCHF) have segment-specific sequences (L, M, S) and genes (RdRp, GPC, NP). Samples are grouped by isolate with shared metadata but segment-specific quality metrics and INSDC accessions.

---

## 3. LAPIS API Endpoints

**Base URL pattern:** `https://lapis.pathoplexus.org/{organism}/sample/`

All endpoints accept both GET and POST. POST is recommended for complex queries.

### 3.1 Metadata & Aggregation

| Endpoint | Description | Response |
|----------|-------------|----------|
| `/sample/details` | Full metadata for matching sequences | JSON/CSV/TSV with all metadata fields |
| `/sample/aggregated` | Counts, optionally stratified by fields | `{ count: N, field1: "value" }` |

### 3.2 Sequence Data (FASTA)

| Endpoint | Description | Format |
|----------|-------------|--------|
| `/sample/unalignedNucleotideSequences` | Raw submitted sequences | FASTA (`>PP_XXXXXX.1\nATCG...`) |
| `/sample/alignedNucleotideSequences` | Reference-aligned sequences | FASTA (with gaps) |
| `/sample/alignedAminoAcidSequences` | All genes, amino acid level | FASTA |
| `/sample/alignedAminoAcidSequences/{gene}` | Single gene AA sequence | FASTA |

FASTA headers contain the Pathoplexus accession version (e.g., `>PP_004F3X2.1`).

### 3.3 Mutation Analysis

| Endpoint | Description |
|----------|-------------|
| `/sample/nucleotideMutations` | Nucleotide mutations with counts/proportions |
| `/sample/aminoAcidMutations` | AA mutations with counts/proportions |
| `/sample/nucleotideInsertions` | Nucleotide insertions |
| `/sample/aminoAcidInsertions` | AA insertions |

Mutation response format:
```json
{
  "mutation": "C7A",
  "position": 7,
  "mutationFrom": "C",
  "mutationTo": "A",
  "count": 6,
  "coverage": 58,
  "proportion": 0.103
}
```

### 3.4 Phylogenetics

| Endpoint | Description |
|----------|-------------|
| `/sample/phyloSubtree` | Phylogenetic subtree (Newick format) |
| `/sample/mostRecentCommonAncestor` | MRCA identification |

### 3.5 Temporal Analysis (POST only)

| Endpoint | Description |
|----------|-------------|
| `/component/nucleotideMutationsOverTime` | Mutation prevalence over date ranges |
| `/component/aminoAcidMutationsOverTime` | AA mutation trends over time |

### 3.6 Reference Data

| Endpoint | Description |
|----------|-------------|
| `/sample/referenceGenome` | Reference genome nucleotide + gene sequences |
| `/sample/lineageDefinition/{column}` | Lineage classification definitions |
| `/sample/info` | LAPIS version, data version, Silo version |
| `/sample/databaseConfig` | Full schema: all fields, types, indexing |

---

## 4. Query Parameters (Filtering)

### 4.1 Common Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `limit` | integer | Max entries returned |
| `offset` | integer | Pagination offset |
| `dataFormat` | enum | `json`, `csv`, `tsv` (default: json) |
| `downloadAsFile` | boolean | Trigger browser download |
| `compression` | enum | `gzip`, `zstd` |
| `orderBy` | string/object | Sort results |
| `fields` | string (comma-sep) | Select specific metadata fields (for `/details`) |

### 4.2 Sequence Filters (Metadata)

All indexed metadata fields can be used as query parameters directly. Key filterable fields:

**Geographic:**
- `geoLocCountry` -- Country name (e.g., "USA", "Democratic Republic of the Congo")
- `geoLocAdmin1` -- State/province
- `geoLocAdmin2` -- County/district
- `geoLocCity` -- City

**Temporal:**
- `sampleCollectionDate` -- Exact date (YYYY-MM-DD)
- `sampleCollectionDateFrom` -- Range start (YYYY-MM-DD)
- `sampleCollectionDateTo` -- Range end (YYYY-MM-DD)
- `releasedDate` -- When data was released on Pathoplexus
- `submittedDate` -- When data was submitted

**Classification:**
- `clade` -- Clade assignment (e.g., "IIb", "Ia", "Ib" for mpox)
- `lineage` -- Lineage assignment (e.g., "F.2" for mpox); supports phylogenetic sub-lineage queries
- `ncbiVirusName` -- NCBI virus taxonomy name
- `ncbiVirusTaxId` -- NCBI taxonomy ID

**Host:**
- `hostNameCommon` -- Common host name
- `hostNameScientific` -- Scientific host name (e.g., "Homo sapiens")
- `hostTaxonId` -- Host taxonomy ID

**Data Access:**
- `dataUseTerms` -- "OPEN" or "RESTRICTED"

**Submission:**
- `submitter` -- Submitter username
- `groupName` -- Submitting group name
- `authorAffiliations` -- Author institution

**Sequencing:**
- `sequencingInstrument` -- Instrument used
- `outbreak` -- Outbreak identifier

### 4.3 Mutation Filters

- `nucleotideMutations` -- Filter by specific nucleotide mutations (e.g., "C7A")
- `aminoAcidMutations` -- Filter by AA mutations (e.g., "S:N501Y")
- `nucleotideInsertions` -- Filter by insertions
- `aminoAcidInsertions` -- Filter by AA insertions

### 4.4 Aggregation Fields

For `/sample/aggregated`, use `fields=` to stratify counts:
```
/sample/aggregated?fields=geoLocCountry    --> counts per country
/sample/aggregated?fields=clade            --> counts per clade
/sample/aggregated?fields=clade,geoLocCountry  --> cross-tabulation
```

---

## 5. Response Formats

| Content-Type | Description |
|-------------|-------------|
| `application/json` | Default structured response |
| `text/csv` | Comma-separated values |
| `text/tab-separated-values` | TSV |
| `text/x-fasta` | FASTA (for sequence endpoints) |
| `application/x-ndjson` | Newline-delimited JSON (streaming) |
| `text/x-nh` | Newick format (phylogenetics) |

### JSON Response Structure

```json
{
  "data": [ ... ],
  "info": {
    "dataVersion": "1772731054",
    "requestId": "uuid",
    "requestInfo": "Mpox Virus on lapis.pathoplexus.org at 2026-03-06T...",
    "lapisVersion": "0.6.3",
    "siloVersion": "0.9.7"
  }
}
```

### Response Headers

- `X-Request-ID` -- Request tracking UUID
- `Lapis-Data-Version` -- Data version timestamp

---

## 6. Accession Numbers & INSDC Identifiers

### Pathoplexus Accessions

- Format: `PP_` followed by alphanumeric ID (e.g., `PP_004F3X2`)
- Versioned: `PP_004F3X2.1` (dot + version number)
- Sequential but not strictly chronological

### INSDC Accessions

Available as metadata fields on every record (when the sequence originated from or was submitted to INSDC):

| Field | Example | Description |
|-------|---------|-------------|
| `insdcAccessionBase` | `PQ221693` | Base accession (no version) |
| `insdcAccessionFull` | `PQ221693.1` | Full accession with version |
| `insdcVersion` | `1` | Version number |

### Querying by Accession

```
# By Pathoplexus accession
/sample/details?accession=PP_004F3X2

# By accession version
/sample/details?accessionVersion=PP_004F3X2.1

# The fields parameter selects which fields to return:
/sample/details?accession=PP_004F3X2&fields=accession,insdcAccessionFull,clade,lineage
```

### Data Flow

- **Direct uploads** to Pathoplexus get a PP_ accession first; INSDC accession assigned later when Pathoplexus submits to ENA
- **INSDC-ingested sequences** retain their original INSDC accession and also receive a PP_ accession
- Most current sequences are ingested from NCBI Virus via the NCBI Datasets Virus Data Package
- Submitter for ingested data: `insdc_ingest_user`, groupName: `Automated Ingest from INSDC/NCBI Virus by Loculus`

---

## 7. Complete Metadata Field Inventory (Mpox, representative)

The `/sample/databaseConfig` endpoint reveals ~159 fields. Key categories:

### Indexed/Searchable Fields (28)
submitter, groupName, submittedDate, releasedDate, dataUseTerms, geoLocCountry, geoLocAdmin1, geoLocAdmin2, geoLocCity, hostNameCommon, hostNameScientific, clade, lineage (phylogenetic), ncbiVirusName, authorAffiliations, ncbiSourceDb, ncbiSubmitterCountry, cellLine, passageMethod, outbreak

### Identifiers
accession, accessionVersion, submissionId, specimenCollectorSampleId, insdcAccessionBase, insdcAccessionFull, insdcVersion

### Quality Metrics
completeness, length, depthOfCoverage, breadthOfCoverage, totalSnps, totalFrameShifts, totalStopCodons, totalAmbiguousNucs, totalDeletedNucs, totalInsertedNucs, totalUnknownNucs, frameShifts

### Dates
sampleCollectionDate, ncbiReleaseDate, earliestReleaseDate, dataBecameOpenAt, releasedDate, submittedDate, sequencingDate

### Host & Clinical
hostAge, hostGender, hostDisease, hostHealthOutcome, hostVaccinationStatus, sampleType, collectionMethod, anatomicalMaterial, anatomicalPart

### Sequencing
sequencingInstrument, sequencingProtocol, sequencingAssayType, consensusSequenceSoftwareName, pipelineVersion

### Display
displayName (format: `Country/AccessionVersion/Date`)

---

## 8. Example API Calls

### Get total sequence count for an organism
```
GET https://lapis.pathoplexus.org/mpox/sample/aggregated
--> {"data": [{"count": 15030}], ...}
```

### Get counts by clade
```
GET https://lapis.pathoplexus.org/mpox/sample/aggregated?fields=clade
--> {"data": [{"clade": "IIb", "count": 11453}, {"clade": "Ia", "count": 2029}, ...]}
```

### Search for specific sequences with metadata
```
GET https://lapis.pathoplexus.org/mpox/sample/details?clade=Ib&limit=10&fields=accession,accessionVersion,insdcAccessionFull,clade,lineage,geoLocCountry,sampleCollectionDate,hostNameScientific
```

### Download FASTA for specific accession
```
GET https://lapis.pathoplexus.org/mpox/sample/unalignedNucleotideSequences?accession=PP_004F3X2
--> >PP_004F3X2.1
    ATAAGTTTTAGTACATTAAT...
```

### Download aligned FASTA for a clade
```
GET https://lapis.pathoplexus.org/mpox/sample/alignedNucleotideSequences?clade=Ib&limit=100
```

### Get mutation profile for a clade
```
GET https://lapis.pathoplexus.org/mpox/sample/nucleotideMutations?clade=Ib&limit=10
```

### Filter by date range and location
```
GET https://lapis.pathoplexus.org/mpox/sample/details?sampleCollectionDateFrom=2024-01-01&sampleCollectionDateTo=2024-12-31&geoLocCountry=USA&limit=50
```

### Get reference genome
```
GET https://lapis.pathoplexus.org/mpox/sample/referenceGenome
--> {"nucleotideSequences": [{"name": "main", "sequence": "ATCG..."}], "genes": [...]}
```

### Multi-segment organism (CCHF)
```
GET https://lapis.pathoplexus.org/cchf/sample/referenceGenome
--> nucleotideSequences: [{name: "L"}, {name: "M"}, {name: "S"}]
    genes: [{name: "RdRp"}, {name: "GPC"}, {name: "NP"}]
```

### Compressed download
```
GET https://lapis.pathoplexus.org/mpox/sample/unalignedNucleotideSequences?clade=IIb&compression=gzip
```

---

## 9. Terms of Use & Access/Benefit Sharing

### Two Data Categories

**Open Data:**
- Freely usable for any purpose (publications, preprints, blog posts, reports)
- Attribution to data generators is strongly encouraged but NOT required
- Immediately submitted to INSDC (via ENA) by Pathoplexus on behalf of submitters
- Create a SeqSet of accessions and cite the DOI (recommended)
- When redistributing: communicate Data Use Terms, link to original Pathoplexus page

**Restricted-Use Data:**
- Freely accessible (can be downloaded) but usage is restricted for up to 1 year
- After restriction period, automatically becomes Open Data
- Submitters choose the restriction duration (max 1 year) and can release early

### Restricted Data Rules

**For publications/preprints using restricted sequences:**
- Must obtain permission from the submitting group
- Must create a SeqSet with DOI
- Sequences classified as either "Focal Set" or "Background Set":
  - **Focal Set** (essential to analysis): Must include submitters as co-authors OR obtain written "Authorship Waiver"
  - **Background Set** (replaceable/contextual): No authorship/waiver needed, but must be classified thoughtfully

**For unpublished work** (dashboards, blog posts, reports): Permitted with attribution

**Third-party redistribution:** Must preserve metadata columns, communicate Data Use Terms, link to original Pathoplexus pages

### Ethical Guidelines
- Avoid research scooping
- Consider involving authors from data-origin regions
- Ensure fair collaboration, especially when few submitters contributed sequences
- Always provide accession numbers

### Key Fields for Compliance
- `dataUseTerms`: "OPEN" or "RESTRICTED" -- filter API results accordingly
- `dataUseTermsRestrictedUntil`: Date when restricted data becomes open
- `dataUseTermsUrl`: Link to applicable terms
- `dataBecameOpenAt`: When data transitioned to open

---

## 10. Technical Notes

- **Software:** LAPIS v0.6.3, Silo v0.9.7 (as of March 2026)
- **Authentication:** Required for submission, NOT for read/query access
- **Rate limits:** Not documented in public API docs; likely standard web API limits apply
- **NDJSON caveat:** Swagger UI incorrectly displays NDJSON examples in JSON format
- **API stability:** "Loculus is under continuous development and the endpoints are subject to change"
- **Primary key:** `accessionVersion` for all organisms
- **Database config:** 64 Silo client threads, generalized advanced queries supported
- **Country names:** Use full country names (not ISO codes), e.g., "USA" not "US", "Democratic Republic of the Congo" not "CD"

---

## 11. Comparison with Other Pathogen Databases

| Feature | Pathoplexus | GISAID | NCBI GenBank |
|---------|-------------|--------|--------------|
| Open API | Yes (LAPIS) | No (restricted) | Yes (Entrez) |
| No login for queries | Yes | No | Yes |
| Restricted data option | Yes (1 year) | Yes (indefinite) | No (all open) |
| Mutation queries | Yes | Via covSPECTRUM | Limited |
| FASTA download | Direct API | Web only | API (efetch) |
| Phylogenetics | Built-in (Newick) | Audacity | No |
| SARS-CoV-2 | No | Yes | Yes |
| Real-time sync with INSDC | Yes (open data) | No | N/A |
