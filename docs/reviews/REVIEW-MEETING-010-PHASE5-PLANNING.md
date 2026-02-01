# Expert Review Meeting #010 - Phase 5 Planning

**Date:** 2026-02-01
**Phase:** 5 - Database Integration (INSDC + Pathoplexus)
**Status:** PLANNING

---

## Meeting Attendees (All 21 Experts)

All experts present and contributing to Phase 5 planning.

---

## Phase 5 Overview

Phase 5 implements comprehensive database integration services for:
1. **NCBI** - GenBank, SRA via Entrez E-utilities
2. **ENA** - European Nucleotide Archive via Portal/Browser APIs
3. **Pathoplexus** - First-class support for viral pathogen genomic data sharing

### Key Features
- Browse, search, and import sequences from all three databases
- Submit sequences to Pathoplexus
- Create new data repositories following Pathoplexus format
- Preserve annotations during import/export
- Async streaming for large datasets

---

## Database Service Research Summary

### 1. NCBI Entrez E-utilities

**Base URL:** `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/`

**Key Endpoints:**
| Endpoint | Purpose |
|----------|---------|
| `esearch.fcgi` | Search databases, return UIDs |
| `efetch.fcgi` | Retrieve records in various formats |
| `einfo.fcgi` | Database statistics and field info |
| `esummary.fcgi` | Document summaries |
| `elink.fcgi` | Related records across databases |

**Databases:** nucleotide, protein, sra, biosample, bioproject, gene, taxonomy

**Formats:** FASTA, GenBank (gb), XML, JSON

**Rate Limiting:** 3 requests/second (10 with API key)

### 2. ENA Portal/Browser API

**Base URL:** `https://www.ebi.ac.uk/ena/browser/api/`

**Key Features:**
- REST API for record retrieval
- Advanced search via Portal API
- FASTA, EMBL, XML formats
- FTP/Aspera for bulk downloads
- enaBrowserTools CLI utility

**Rate Limiting:** 50 requests/second

### 3. Pathoplexus (Loculus-based)

**Backend URL:** `https://backend.pathoplexus.org/`
**LAPIS URL:** `https://lapis.pathoplexus.org/`
**Auth URL:** `https://authentication.pathoplexus.org/`

**Key Endpoints:**

#### Search & Download (LAPIS API)
| Endpoint | Purpose |
|----------|---------|
| `/<organism>/sample/aggregated` | Count matching sequences |
| `/<organism>/sample/details` | Metadata as JSON |
| `/<organism>/sample/alignedNucleotideSequences` | Aligned FASTA |
| `/<organism>/sample/unalignedNucleotideSequences` | Unaligned FASTA |

**Organisms:** ebola-zaire, ebola-sudan, marburg, mpox, rsv-a, rsv-b, measles, hmpv, west-nile, cchf

**Search Parameters:**
- Geographic: `geoLocCountry`
- Temporal: `sampleCollectionDate`, `sampleCollectionDateFrom/To`
- Sequence: `length`, `lengthFrom/To`
- Accession: `accession`, `accessionVersion`, `versionStatus`
- Mutations: `nucleotideMutations`, `aminoAcidMutations`

#### Submission (Backend API)
| Endpoint | Purpose |
|----------|---------|
| `/<organism>/submit` | Submit sequences (POST, multipart) |
| `/<organism>/get-group-ids` | List user groups |
| `/<organism>/revise` | Revise existing submissions |
| `/<organism>/approve` | Approve pending submissions |

**Authentication:** JWT tokens via Keycloak (10-hour expiry)

**Submission Format:**
- Sequences: FASTA (unique IDs per sequence)
- Metadata: TSV (required) or XLSX (web only)
- Compression: .zst, .gz, .zip, .xz supported

---

## Expert Task Delegation

### Core Infrastructure (Week 1-2)

#### Swift Architecture Lead (Role 01)
- Design service protocol hierarchy
- Define async networking patterns
- Establish error handling strategy

#### NCBI Integration Lead (Role 12)
- Implement `NCBIService` with Entrez E-utilities
- ESearch, EFetch, ESummary integration
- GenBank format preservation

#### ENA Integration Specialist (Role 13)
- Implement `ENAService` with Portal/Browser APIs
- EMBL format parsing
- Bulk download support

### Pathoplexus Integration (Week 2-3)

#### Product Fit Expert (Role 21) + NCBI Lead (Role 12)
- Implement `PathoplexusService` for browse/search
- LAPIS API integration
- Organism-specific handling

#### Workflow Integration Lead (Role 14)
- Implement submission workflow
- Authentication via Keycloak
- Group management

#### File Format Expert (Role 06)
- Metadata template handling
- TSV/XLSX parsing
- Format conversion utilities

### UI Integration (Week 3-4)

#### UI/UX Lead (Role 02)
- Database browser design
- Search interface
- Submission workflow UI

#### Sequence Viewer Specialist (Role 03)
- Import preview
- Annotation display from imported sequences

### Testing & Documentation (Week 4)

#### Testing & QA Lead (Role 19)
- Comprehensive unit tests
- Mock services for offline testing
- Integration test suite

#### Documentation Lead (Role 20)
- API documentation
- User guide updates
- Submission workflow guide

---

## Technical Specifications

### Service Protocol Design

```swift
// Base protocol for all database services
public protocol DatabaseService: Sendable {
    var name: String { get }
    var baseURL: URL { get }

    func search(_ query: SearchQuery) async throws -> SearchResults
    func fetch(accession: String) async throws -> DatabaseRecord
    func fetchBatch(accessions: [String]) async throws -> AsyncThrowingStream<DatabaseRecord, Error>
}

// NCBI-specific
public protocol NCBIServiceProtocol: DatabaseService {
    func esearch(database: NCBIDatabase, term: String, retmax: Int) async throws -> [String]
    func efetch(database: NCBIDatabase, ids: [String], format: NCBIFormat) async throws -> Data
    func esummary(database: NCBIDatabase, ids: [String]) async throws -> [DocumentSummary]
}

// ENA-specific
public protocol ENAServiceProtocol: DatabaseService {
    func search(query: String, result: ENAResultType, fields: [String]) async throws -> [ENARecord]
    func fetchFASTA(accession: String) async throws -> String
    func fetchEMBL(accession: String) async throws -> String
}

// Pathoplexus-specific
public protocol PathoplexusServiceProtocol: DatabaseService {
    // Search & Browse
    func listOrganisms() async throws -> [PathoplexusOrganism]
    func search(organism: String, filters: PathoplexusFilters) async throws -> PathoplexusSearchResults
    func fetchSequences(organism: String, filters: PathoplexusFilters) async throws -> AsyncThrowingStream<FASTARecord, Error>
    func fetchMetadata(organism: String, filters: PathoplexusFilters) async throws -> [PathoplexusMetadata]

    // Submission
    func authenticate(username: String, password: String) async throws -> PathoplexusToken
    func refreshToken(_ token: PathoplexusToken) async throws -> PathoplexusToken
    func listGroups(token: PathoplexusToken) async throws -> [PathoplexusGroup]
    func submit(organism: String, sequences: URL, metadata: URL, group: String, dataUse: DataUseTerms, token: PathoplexusToken) async throws -> SubmissionResult
    func approveSubmission(id: String, token: PathoplexusToken) async throws
    func reviseSubmission(id: String, sequences: URL?, metadata: URL?, token: PathoplexusToken) async throws
}
```

### Data Models

```swift
// Search query that works across databases
public struct SearchQuery: Sendable {
    public var term: String
    public var organism: String?
    public var dateRange: ClosedRange<Date>?
    public var location: String?
    public var minLength: Int?
    public var maxLength: Int?
    public var limit: Int = 100
}

// Unified search results
public struct SearchResults: Sendable {
    public let totalCount: Int
    public let records: [SearchResultRecord]
    public let hasMore: Bool
    public let nextCursor: String?
}

// Pathoplexus-specific
public struct PathoplexusOrganism: Sendable, Codable, Identifiable {
    public let id: String  // e.g., "ebola-zaire"
    public let displayName: String
    public let segmented: Bool
    public let segments: [String]?  // For multi-segment viruses
}

public struct PathoplexusFilters: Sendable {
    public var accession: String?
    public var geoLocCountry: String?
    public var sampleCollectionDateFrom: Date?
    public var sampleCollectionDateTo: Date?
    public var lengthFrom: Int?
    public var lengthTo: Int?
    public var nucleotideMutations: [String]?
    public var aminoAcidMutations: [String]?
    public var versionStatus: VersionStatus?
}

public enum DataUseTerms: String, Sendable {
    case open = "OPEN"
    case restricted = "RESTRICTED"
}
```

### File Structure

```
Sources/LungfishCore/Services/
├── DatabaseService.swift       # Base protocols and common types
├── SearchQuery.swift           # Unified search query model
├── NCBI/
│   ├── NCBIService.swift       # NCBI Entrez implementation
│   ├── NCBIDatabase.swift      # Database enum
│   └── NCBIModels.swift        # NCBI-specific data models
├── ENA/
│   ├── ENAService.swift        # ENA Portal/Browser implementation
│   └── ENAModels.swift         # ENA-specific data models
└── Pathoplexus/
    ├── PathoplexusService.swift      # Main service implementation
    ├── PathoplexusAuth.swift         # Keycloak authentication
    ├── PathoplexusSubmission.swift   # Submission workflow
    └── PathoplexusModels.swift       # Data models

Tests/LungfishCoreTests/Services/
├── NCBIServiceTests.swift
├── ENAServiceTests.swift
├── PathoplexusServiceTests.swift
└── Mocks/
    ├── MockNCBIService.swift
    ├── MockENAService.swift
    └── MockPathoplexusService.swift
```

---

## Testing Strategy

### Unit Tests
- Mock HTTP responses for all services
- Test query building and URL construction
- Test response parsing
- Test error handling
- Test authentication flow

### Integration Tests (Optional, requires network)
- Real searches against test databases
- Pathoplexus demo instance testing
- Rate limiting verification

### Test Coverage Targets
| Component | Target |
|-----------|--------|
| NCBIService | 90% |
| ENAService | 90% |
| PathoplexusService | 95% |
| PathoplexusAuth | 95% |
| PathoplexusSubmission | 95% |
| Data models | 100% |

---

## QA Lead Requirements (Role 19)

The Testing & QA Lead has established the following requirements for Phase 5:

1. **Mock-based testing** - All services must be testable without network access
2. **Error coverage** - Every error path must have a test
3. **Async testing** - Proper testing of AsyncThrowingStream
4. **Authentication security** - No credentials in test code or logs
5. **Rate limiting** - Tests must not exceed API rate limits
6. **Documentation** - All public APIs must have doc comments
7. **Code review** - All PRs require QA sign-off

---

## Timeline

| Week | Activities |
|------|------------|
| Week 1 | Service protocols, NCBI implementation |
| Week 2 | ENA implementation, Pathoplexus search |
| Week 3 | Pathoplexus submission, authentication |
| Week 4 | Testing, documentation, review |

---

## Deliverables

1. **NCBIService** - Full Entrez E-utilities integration
2. **ENAService** - Portal/Browser API integration
3. **PathoplexusService** - Browse, search, import
4. **PathoplexusAuth** - Keycloak JWT authentication
5. **PathoplexusSubmission** - Sequence submission workflow
6. **Comprehensive tests** - Unit tests with mocks
7. **Documentation** - API docs and user guides

---

## Expert Consensus

All 21 experts have reviewed and approved the Phase 5 plan:

- Swift Architecture Lead (Role 01): Protocol design approved
- NCBI Integration Lead (Role 12): Entrez implementation scope confirmed
- ENA Integration Specialist (Role 13): Portal API scope confirmed
- Product Fit Expert (Role 21): Pathoplexus as first-class citizen approved
- Testing & QA Lead (Role 19): Testing strategy approved

---

**Meeting Conclusion:** Phase 5 plan APPROVED. Implementation begins immediately.
