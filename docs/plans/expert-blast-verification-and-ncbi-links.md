# Expert Plan: NCBI Taxonomy Links + BLAST Verification

**Author**: Bioinformatics Expert Agent
**Date**: 2026-03-23
**Status**: Draft -- ready for implementation review

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Feature 1: NCBI Links](#feature-1-ncbi-links)
3. [Feature 2: BLAST Verification](#feature-2-blast-verification)
4. [Architecture](#architecture)
5. [Implementation Phases](#implementation-phases)
6. [Testing Strategy](#testing-strategy)

---

## Executive Summary

This plan covers two features for the metagenomic classification view:

1. **NCBI Links**: A submenu of curated NCBI pages accessible per taxon from the
   context menu (right-click on sunburst segment or taxonomy table row).

2. **BLAST Verification**: An async pipeline that subsamples reads classified to a
   taxon, submits them to NCBI BLAST with an organism filter, polls for results,
   and presents a verification summary showing whether the Kraken2 classifications
   are corroborated by sequence similarity.

Both features are accessed from the existing `showContextMenu(for:at:)` method on
`TaxonomyViewController`.

---

## Feature 1: NCBI Links

### 1.1 URL Catalog

All URLs take a `taxId: Int` parameter and open in the default browser via
`NSWorkspace.shared.open(url)`.

| Menu Item | URL Template | Notes |
|-----------|-------------|-------|
| NCBI Taxonomy | `https://www.ncbi.nlm.nih.gov/datasets/taxonomy/{taxid}/` | Primary taxonomy page with lineage, names |
| GenBank Sequences | `https://www.ncbi.nlm.nih.gov/nuccore/?term=txid{taxid}[Organism:exp]` | All nucleotide records for this organism |
| PubMed Literature | `https://pubmed.ncbi.nlm.nih.gov/?term=txid{taxid}[Organism]` | Publications referencing this organism |
| NCBI Genome | `https://www.ncbi.nlm.nih.gov/datasets/genome/?taxon={taxid}` | Genome assemblies if available |

### 1.2 Context Menu Integration

Add a new submenu "Look Up on NCBI" to the existing taxon context menu, positioned
between the "Copy Taxonomy Path" item and the "Zoom to" separator:

```
Extract Sequences for Oxbow virus...
Extract Sequences for Oxbow virus and Children...
---
Copy Taxon Name
Copy Taxonomy Path
---
Look Up on NCBI                    >  NCBI Taxonomy
                                      GenBank Sequences
                                      PubMed Literature
                                      ---
                                      NCBI Genome
---
BLAST Matching Reads...
---
Zoom to Oxbow virus
Zoom Out to Root
```

### 1.3 Implementation

Add to `TaxonomyViewController.showContextMenu(for:at:)`:

- A new `NSMenu` with title "Look Up on NCBI" containing 4 items.
- Genome link is disabled when `taxId == 0` (unclassified) or for very high-level
  ranks (root, domain) where the genome page returns nothing useful.
- All items call `NSWorkspace.shared.open(url)`, which is the correct pattern for
  a desktop app -- never use WKWebView for NCBI pages (they are JavaScript-heavy
  and render poorly in embedded views).

### 1.4 Table Context Menu

Add the same submenu to `TaxonomyTableView.buildContextMenu()` for consistency.
The table already has "Copy Taxon Name" -- add "Look Up on NCBI" and
"BLAST Matching Reads..." after it.

### 1.5 Rationale: System Browser, Not Embedded WebView

A WKWebView inside the Inspector was considered and rejected for these reasons:

- NCBI pages use heavy JavaScript frameworks that perform poorly in embedded contexts.
- The Taxonomy page includes interactive lineage trees, external CSS, and cookie
  consent banners that break in constrained WebViews.
- Opening in the default browser gives the user full bookmarking, tab management,
  and authentication (some NCBI features require login).
- This is the standard pattern used by other scientific desktop apps (IGV, Geneious,
  CLC Workbench) for NCBI lookups.

---

## Feature 2: BLAST Verification

### 2.1 API Selection: NCBI BLAST URL API (REST)

**Chosen**: The NCBI Common URL API (`https://blast.ncbi.nlm.nih.gov/Blast.cgi`).

**Rationale**:

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| **NCBI BLAST URL API** | No dependencies, works offline from any machine with internet, no conda required, well-documented | Slow (30s-5min per job), rate-limited | **Selected** |
| Local BLAST+ via conda | Fast, no rate limits, offline-capable | Requires 80+ GB nt database download, conda env setup, disk space | Future enhancement |
| Biopython `NCBIWWW` | Familiar to Python bioinformaticians | Requires Python runtime, adds dependency layer | Not for Swift app |

The NCBI URL API is the right choice for a desktop genome browser because:

1. It requires zero local database setup -- the user can verify reads immediately.
2. The verification use case involves only 10-50 reads, well within API limits.
3. It integrates naturally with the app's existing `NCBIService` actor pattern.
4. A future "local BLAST" option can be added behind the same `BlastVerificationService`
   protocol when containerized bioinformatics support matures.

### 2.2 BLAST Parameters

#### Submission Parameters (CMD=Put)

| Parameter | Value | Rationale |
|-----------|-------|-----------|
| `PROGRAM` | `blastn` | Nucleotide-to-nucleotide search |
| `MEGABLAST` | `on` | Use megablast algorithm for fast, high-identity matches. Verification of correctly classified reads expects >90% identity. |
| `DATABASE` | `nt` | Full non-redundant nucleotide collection. `core_nt` is too restrictive -- it excludes many viral and environmental sequences that are important for verification. |
| `ENTREZ_QUERY` | `txid{taxid}[Organism:exp]` | Restricts search to the target taxon and all descendants. The `[Organism:exp]` qualifier expands the taxonomy tree. |
| `EXPECT` | `1e-10` | Stringent E-value for verification. We want genuine homology, not spurious matches. Reads that cannot produce hits at this threshold against the target organism are suspect. |
| `MAX_NUM_SEQ` | `10` | Per-query sequence. Keep low to reduce result payload. |
| `WORD_SIZE` | `28` | Default for megablast. Good for expected high-identity matches. |
| `HITLIST_SIZE` | `10` | Same as MAX_NUM_SEQ. |
| `QUERY` | FASTA-formatted reads | Concatenated multi-FASTA of subsampled reads. |
| `FORMAT_TYPE` | `JSON2` | Structured JSON output for programmatic parsing. |

#### Why `nt` and Not `core_nt`

`core_nt` is a curated subset that excludes:
- Newly deposited sequences (lag of weeks to months)
- Environmental/metagenomic sequences
- Many viral isolates from surveillance studies
- Partial/draft sequences

For classification verification, completeness matters more than curation. A read
classified as "Oxbow virus" must be checked against ALL known Oxbow virus sequences,
including partial segments and surveillance isolates that may only exist in `nt`.

#### Why `ENTREZ_QUERY` Filtering

Restricting to `txid{taxid}[Organism:exp]` is critical for two reasons:

1. **Speed**: Searching all of `nt` without a filter is extremely slow. The organism
   filter reduces the search space by orders of magnitude.
2. **Interpretation**: We want to know "does this read match sequences from this
   organism?" If the best hit within the target taxon has high identity, the
   classification is verified. If no hits are found within the taxon (even at
   relaxed thresholds), the classification is suspect.

**Important**: For the "unverified" case, a follow-up unrestricted BLAST is needed
to determine the TRUE best hit. This is Phase 2 (see Implementation Phases).

### 2.3 Read Subsampling Strategy

NCBI BLAST has a practical query limit of roughly 100 sequences per submission
(larger submissions are throttled or rejected). More critically, result
interpretation becomes unwieldy with too many reads.

**Strategy**: Subsample **20 reads** by default, using a two-tier approach:

1. **Priority selection (top 5)**: The 5 longest reads classified to this taxon.
   Longer reads produce more informative alignments and higher-confidence BLAST
   hits. For short amplicon reads (150 bp), length variation is minimal and this
   degenerates to random selection.

2. **Random sample (remaining 15)**: Randomly sample from the remaining reads to
   capture the diversity of the classified read pool. Use a fixed seed derived from
   the taxon ID for reproducibility.

**Edge cases**:
- If fewer than 20 reads exist, use all of them.
- If fewer than 5 reads exist, skip the priority tier and send all reads.
- Minimum: 1 read (never submit an empty query).

**Configuration**: The user can adjust the count (5, 10, 20, 50) in the BLAST
verification sheet before submission.

### 2.4 Read Retrieval

Reads must be retrieved from the original FASTQ file using the Kraken2 per-read
output (`ClassificationResult.outputURL`) to identify which reads belong to the
taxon.

**Pipeline**:

1. Parse `outputURL` using `Kraken2OutputParser` to get read IDs for the target
   taxon (and descendants if the node has children).
2. Subsample the read ID list per section 2.3.
3. Extract the actual sequences from the source FASTQ using the existing
   `BufferedFASTQReader` (already used by `TaxonomyExtractionPipeline`).
4. Format as multi-FASTA for BLAST submission (BLAST does not accept FASTQ).

**FASTA conversion**: Strip quality scores. Header is the read ID. Sequence is the
nucleotide string. This conversion is trivial and does not require a separate tool.

### 2.5 Async Job Lifecycle

The NCBI BLAST URL API is asynchronous: submit -> poll -> retrieve.

```
User clicks "BLAST Matching Reads..."
    |
    v
[BlastVerificationSheet] - shows parameters, read count, subsample size
    |  user clicks "Submit"
    v
[Phase 1: Read Extraction] (0.0 - 0.15)
    Parse Kraken2 output -> subsample -> extract from FASTQ -> format FASTA
    |
    v
[Phase 2: Submit] (0.15 - 0.20)
    POST to blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Put
    Receive RID (Request ID) + RTOE (estimated time)
    |
    v
[Phase 3: Poll] (0.20 - 0.90)
    GET blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Get&RID=xxx&FORMAT_TYPE=JSON2
    Poll every max(RTOE, 15) seconds, then every 15 seconds
    Status: WAITING -> READY (or ERROR)
    |
    v
[Phase 4: Parse + Display] (0.90 - 1.0)
    Parse JSON2 results -> build verification summary -> display
```

**Timeout**: 10 minutes maximum. If the job has not completed, show a warning with
the RID so the user can check results manually at
`https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Get&RID=xxx`.

**Cancellation**: The user can cancel at any point. Cancellation is cooperative --
the polling Task is cancelled, but the NCBI job continues running server-side
(there is no NCBI API to cancel a submitted job).

**Rate limiting**: Follow NCBI guidelines:
- Maximum 1 submission per 10 seconds.
- Maximum 1 poll per 60 seconds per RID.
- Include `tool=lungfish` and `email=<user-configured>` parameters.

### 2.6 Result Interpretation

#### Per-Read Verdict

Each read receives one of three verdicts:

| Verdict | Criteria | Meaning |
|---------|----------|---------|
| **Verified** | Top hit has >= 90% identity AND alignment length >= 80% of read length AND E-value <= 1e-10 | The read genuinely matches sequences from the classified organism. |
| **Ambiguous** | Top hit meets identity threshold but alignment coverage < 80%, OR multiple organisms have nearly equal scores (within 5% of top bit score) | The read partially matches but is not definitive. |
| **Unverified** | No hits found within the target taxon at E-value <= 1e-10 | The read does NOT match any known sequence from this organism. May be a Kraken2 misclassification. |

#### Summary Verdict

The overall taxon classification is summarized as:

| Summary | Criteria |
|---------|----------|
| **High confidence** | >= 80% of reads verified |
| **Moderate confidence** | 50-79% of reads verified |
| **Low confidence** | 20-49% of reads verified |
| **Suspect** | < 20% of reads verified |

#### Interpreting "Unverified" Reads

An "unverified" result means no BLAST hit was found within the target taxon. This
does NOT necessarily mean misclassification. Possible explanations:

1. **True misclassification**: The read actually belongs to a different organism.
   A follow-up unrestricted BLAST (Phase 2 feature) would reveal the true match.
2. **Novel sequence**: The read is from a genuine member of this taxon but represents
   a genomic region not yet in GenBank. Common for newly described viruses.
3. **Divergent strain**: The read is from a highly divergent strain with < 90%
   identity to known references. Lower the identity threshold to check.
4. **Short/low-complexity read**: The read is too short or repetitive to produce a
   significant BLAST hit.

The UI should present these possibilities to help non-expert users interpret results.

### 2.7 Result Format and Display

#### Results Placement: Bottom Drawer Tab

BLAST results are displayed in a **new tab** within the existing bottom drawer
infrastructure, alongside the "Taxa Collections" tab. This follows the established
drawer pattern used by `TaxaCollectionsDrawerView` and is consistent with the
information hierarchy -- BLAST verification is supplementary information about a
selected taxon, not a primary view.

**Drawer layout with BLAST tab**:

```
+------------------------------------------------------------------+
| [===== Drag Handle =====] (8pt)                                  |
+------------------------------------------------------------------+
| [Collections] [BLAST Results]                    [Clear Results]  |
+------------------------------------------------------------------+
| Summary: 18/20 reads verified (High confidence)                  |
| Taxon: Oxbow virus (taxid: 2560178)                              |
| Database: nt | Program: blastn (megablast)                       |
+------------------------------------------------------------------+
|  Read ID          | Top Hit              | % ID | E-value | Verdict   |
|  read_4821        | Oxbow virus seg 1    | 99.3 | 0.0     | Verified  |
|  read_9102        | Oxbow virus seg 2    | 98.7 | 0.0     | Verified  |
|  read_1337        | (no hit)             | --   | --      | Unverified|
|  ...              |                      |      |         |           |
+------------------------------------------------------------------+
```

#### Summary Section

At the top of the BLAST results view:

- Verification fraction: "18 of 20 reads verified"
- Confidence badge: colored indicator (green/yellow/orange/red) with text
- Taxon name and tax ID
- BLAST parameters used (database, program, E-value threshold)
- Submission time and RID for reference

#### Results Table

An `NSTableView` (not `NSOutlineView` -- results are flat) with columns:

| Column | Width | Content |
|--------|-------|---------|
| Read ID | 200px | Truncated read identifier |
| Top Hit | flex | Organism + accession of best hit |
| % Identity | 60px | Percent identity of best alignment |
| E-value | 80px | E-value of best hit |
| Alignment Length | 80px | Length of the alignment |
| Query Coverage | 70px | Percent of read aligned |
| Verdict | 80px | Verified / Ambiguous / Unverified |

Verdict column uses color-coded text:
- Verified: system green
- Ambiguous: system yellow
- Unverified: system red

#### Detail View

Double-clicking a row in the results table shows a popover with:
- Full read ID
- Complete BLAST hit list (all 10 hits, not just top)
- Alignment visualization (text-based pairwise alignment for the top hit)
- Link to view this hit on NCBI: `https://www.ncbi.nlm.nih.gov/nuccore/{accession}`

### 2.8 JSON2 Response Parsing

The BLAST JSON2 format returns structured results. Key fields:

```
BlastOutput2[].report.results.search
  .query_title    -> read ID
  .query_len      -> read length
  .hits[]
    .description[].title     -> hit organism + description
    .description[].accession -> GenBank accession
    .hsps[]
      .bit_score      -> alignment score
      .evalue         -> E-value
      .identity       -> number of identical positions
      .align_len      -> alignment length
      .query_from     -> alignment start on query
      .query_to       -> alignment end on query
      .qseq           -> query alignment string
      .hseq           -> hit alignment string
      .midline         -> midline string
```

Create a `BlastResult` model in LungfishCore:

```swift
public struct BlastResult: Sendable {
    public let queryId: String
    public let queryLength: Int
    public let hits: [BlastHit]
}

public struct BlastHit: Sendable {
    public let accession: String
    public let title: String
    public let organism: String
    public let hsps: [BlastHSP]
}

public struct BlastHSP: Sendable {
    public let bitScore: Double
    public let evalue: Double
    public let identity: Int
    public let alignLength: Int
    public let queryFrom: Int
    public let queryTo: Int
    public let queryCoverage: Double  // computed
    public let percentIdentity: Double  // computed
}
```

---

## Architecture

### 3.1 New Files

| Module | File | Purpose |
|--------|------|---------|
| LungfishCore | `Services/NCBI/BlastService.swift` | NCBI BLAST URL API client (actor) |
| LungfishCore | `Models/BlastResult.swift` | BLAST result data models |
| LungfishCore | `Models/BlastVerificationSummary.swift` | Verification logic and summary |
| LungfishApp | `Views/Metagenomics/BlastVerificationSheet.swift` | SwiftUI parameter configuration sheet |
| LungfishApp | `Views/Metagenomics/BlastResultsDrawerView.swift` | Bottom drawer tab for results |
| LungfishApp | `Views/Metagenomics/BlastResultDetailPopover.swift` | Per-read detail popover |
| LungfishApp | `Views/Metagenomics/TaxonomyViewController+Blast.swift` | Extension wiring BLAST into the VC |
| LungfishApp | `Views/Metagenomics/TaxonomyViewController+NCBILinks.swift` | Extension for NCBI link menu items |

### 3.2 BlastService Actor

```swift
public actor BlastService {
    private let httpClient: HTTPClient
    private let blastBaseURL = URL(string: "https://blast.ncbi.nlm.nih.gov/Blast.cgi")!
    private var lastSubmitTime: Date?

    // Submit a BLAST job. Returns the RID.
    public func submit(
        query: String,             // Multi-FASTA
        program: String,           // "blastn"
        database: String,          // "nt"
        entrezQuery: String?,      // "txid12345[Organism:exp]"
        evalue: Double,            // 1e-10
        maxTargetSeqs: Int,        // 10
        megablast: Bool            // true
    ) async throws -> BlastJobSubmission

    // Poll for job status. Returns .waiting, .ready, or .error.
    public func checkStatus(rid: String) async throws -> BlastJobStatus

    // Retrieve results in JSON2 format.
    public func getResults(rid: String) async throws -> [BlastResult]

    // High-level: submit, poll, return results.
    public func submitAndWait(
        query: String,
        program: String,
        database: String,
        entrezQuery: String?,
        evalue: Double,
        maxTargetSeqs: Int,
        megablast: Bool,
        progress: @Sendable (Double, String) -> Void,
        timeout: TimeInterval
    ) async throws -> [BlastResult]
}
```

The actor enforces NCBI rate limits internally (minimum 10s between submissions,
minimum 60s between polls for the same RID).

### 3.3 Integration with TaxonomyViewController

The `TaxonomyViewController+Blast.swift` extension:

1. Adds the "BLAST Matching Reads..." menu item to `showContextMenu(for:at:)`.
2. On click, presents `BlastVerificationSheet` as a sheet (same pattern as
   `TaxonomyExtractionSheet`).
3. On confirmation, starts a `Task.detached` that:
   a. Extracts and subsamples reads (using `Kraken2OutputParser` + `BufferedFASTQReader`).
   b. Calls `BlastService.submitAndWait(...)`.
   c. On completion, dispatches to main thread via `scheduleTaxonomyOnMainRunLoop`
      + `MainActor.assumeIsolated` (per project conventions).
   d. Populates the `BlastResultsDrawerView`.
4. Registers the operation with `OperationCenter` for progress tracking and
   cancellation.

### 3.4 Drawer Tab Architecture

Currently `TaxonomyViewController` has a single drawer (`TaxaCollectionsDrawerView`).
To support a second tab, introduce a lightweight tab switcher:

**Option A (recommended)**: Add an `NSSegmentedControl` to the drawer's header bar
that switches between "Collections" and "BLAST Results" content views. Only one
content view is visible at a time, but both retain state. This is the minimal
change to the existing drawer architecture.

**Option B**: Replace the drawer with a full `NSTabView`. This is more invasive
and introduces layout complexity with the existing divider/resize infrastructure.

Option A is recommended because it preserves the working drawer pattern and only
adds a content-switching mechanism.

### 3.5 Concurrency Pattern

Follow the established project pattern for long-running operations from the
taxonomy view:

```
User action
  -> Present sheet (MainActor)
  -> Sheet callback
  -> OperationCenter.shared.start(...)
  -> Task.detached {
       // All work happens off-main
       BlastService.submitAndWait(...)
       // Progress via DispatchQueue.main.async { MainActor.assumeIsolated { ... } }
       // Completion via scheduleTaxonomyOnMainRunLoop { MainActor.assumeIsolated { ... } }
     }
```

This matches `ViewerViewController+Taxonomy.swift`'s extraction pipeline pattern
exactly.

---

## Implementation Phases

### Phase 1: NCBI Links (1-2 hours)

- Add "Look Up on NCBI" submenu to both context menus.
- Add "BLAST Matching Reads..." placeholder (disabled, with tooltip "Coming soon").
- 4 NCBI link items open in system browser.
- Tests: verify menu items are created, URLs are correct for known taxIds.

### Phase 2: BLAST Core (4-6 hours)

- Implement `BlastService` actor with submit/poll/retrieve.
- Implement `BlastResult` models and JSON2 parsing.
- Implement `BlastVerificationSummary` with verdict logic.
- Unit tests with mock HTTP responses (captured from real NCBI BLAST JSON2 output).

### Phase 3: Read Subsampling + FASTA Conversion (2-3 hours)

- Implement read subsampling logic (longest-N + random).
- FASTQ-to-FASTA conversion for BLAST submission.
- Integration test: given a Kraken2 output + FASTQ, produce a multi-FASTA of
  subsampled reads.

### Phase 4: BLAST Verification Sheet (2-3 hours)

- SwiftUI sheet with parameter controls (sample size, E-value, database).
- Shows estimated read count, taxon name, subsample strategy.
- "Submit to NCBI BLAST" button.

### Phase 5: Results Drawer (3-4 hours)

- `BlastResultsDrawerView` with summary bar and results table.
- Tab switcher in drawer header (Collections / BLAST Results).
- Color-coded verdict column.
- Detail popover on double-click.

### Phase 6: Full Integration + Polish (2-3 hours)

- Wire everything through `TaxonomyViewController+Blast.swift`.
- OperationCenter integration for progress and cancellation.
- Error handling (network failures, NCBI errors, timeout).
- Accessibility labels on all new views.
- Log messages at appropriate levels.

### Phase 7 (Future): Unrestricted Follow-Up BLAST

When reads are "unverified" (no hits within target taxon), offer a one-click
"BLAST against all organisms" to find the TRUE best hit. This is Phase 2 because
it requires a second BLAST submission and more complex result comparison.

### Phase 8 (Future): Local BLAST+ via Container

When the containerization infrastructure matures, add a local BLAST+ option:
- Download and cache the nt database (or a subset).
- Run blast+ inside the Linux container.
- Same `BlastVerificationService` protocol, different backend.
- Advantage: instant results, no rate limits, works offline.

---

## Testing Strategy

### Unit Tests

| Test | Module | What it covers |
|------|--------|----------------|
| `BlastServiceSubmitTests` | LungfishCoreTests | PUT request construction, parameter encoding |
| `BlastServicePollTests` | LungfishCoreTests | Status parsing (WAITING, READY, ERROR) |
| `BlastJSON2ParserTests` | LungfishCoreTests | JSON2 response parsing into BlastResult models |
| `BlastVerificationSummaryTests` | LungfishCoreTests | Verdict logic: verified/ambiguous/unverified thresholds |
| `ReadSubsamplingTests` | LungfishWorkflowTests | Longest-N + random sampling, edge cases |
| `FASTQToFASTAConversionTests` | LungfishIOTests | Quality score stripping, header preservation |
| `NCBILinkURLTests` | LungfishAppTests | URL construction for all 4 NCBI link types |
| `TaxonomyContextMenuBlastTests` | LungfishAppTests | Menu items present, enabled/disabled state |
| `BlastResultsDrawerTests` | LungfishAppTests | Table population, verdict colors, summary text |

### Integration Tests (Network-Dependent)

| Test | Notes |
|------|-------|
| `testBlastSubmitAndPoll` | Submit a small FASTA to NCBI BLAST, verify RID returned. Mark as network-dependent like `testSRASearch`. |
| `testBlastEndToEnd` | Submit 3 reads of known origin (e.g., SARS-CoV-2), wait for results, verify top hits. Long timeout (5 min). |

### Mock Data

Capture real NCBI BLAST JSON2 responses for:
- A successful search with 10 hits per query.
- A search with zero hits (unverified case).
- A search with mixed results (some verified, some not).
- A search with multiple equally-good hits (ambiguous case).

Store in `Tests/LungfishCoreTests/Resources/blast-mock-responses/`.

---

## Answers to Specific Questions

### Q1: Which BLAST API?

NCBI BLAST URL API (REST). See section 2.1 for full rationale.

### Q2: Parameters for verification BLAST?

megablast against `nt` with `ENTREZ_QUERY=txid{taxid}[Organism:exp]`,
E-value 1e-10, 10 max target sequences. See section 2.2 for full parameter table.

### Q3: Read subsampling?

20 reads: top 5 longest + 15 random. User-adjustable (5/10/20/50). See section 2.3.

### Q4: Result interpretation?

Three-tier per-read verdict (verified/ambiguous/unverified) based on identity
(>= 90%), alignment coverage (>= 80% of read length), and E-value (<= 1e-10).
Summary confidence levels at 80/50/20% thresholds. See section 2.6.

### Q5: Result format?

Summary bar + NSTableView in a bottom drawer tab. Double-click for detail popover
with full hit list and alignment. See section 2.7.

### Q6: Async handling?

Submit -> poll (every 15s after initial RTOE wait) -> retrieve. 10-minute timeout.
RID displayed so user can check manually. OperationCenter integration for progress
bar and cancellation. See section 2.5.

### Q7: Other useful NCBI links?

Yes: Taxonomy, GenBank Sequences, PubMed, Genome. Exposed as a submenu "Look Up
on NCBI" with all four links. See section 1.1.

### Q8: Where should BLAST results live?

A new "BLAST Results" tab in the existing bottom drawer, alongside the
"Collections" tab. Switched via NSSegmentedControl in the drawer header. See
section 3.4.
