# MHC Reference Completeness-Aware Classification Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Classify full-reference, zero-SNP genomic MHC matches with only terminal soft-clipped flank as known when reference annotations prove that the allele is biologically complete.

**Architecture:** Extend the MHC reference catalog with a conservative, annotation-derived completeness projection and a small locus-topology policy. Consume that projection in the existing genomic exact-match predicate, and expose both the input annotation database and resolved decision policy through existing scientific provenance.

**Tech Stack:** Swift 6.2, XCTest, SQLite3, Swift Package Manager, Lungfish `.lungfishref`/`.lungfishgenotype` bundles.

**Spec:** `docs/superpowers/specs/2026-09-08-mhc-reference-completeness-design.md`

## Global Constraints

- Missing or ambiguous annotation evidence must remain conservative and must not promote a partial extension to known.
- cDNA references remain governed by the existing structural-extension algorithm.
- MHC class I accepts terminal exon 7 or 8; class-II terminal exon counts are resolved by locus family.
- Every scientific input and resolved default introduced here must be represented in output provenance with checksums, paths, sizes, exit status, wall time, and reproducible argv.
- Existing user changes outside this worktree must remain untouched.

---

### Task 1: Reference completeness projection

**Files:**
- Modify: `Sources/LungfishIO/Bundles/MHCReferenceRecordCatalog.swift`
- Modify: `Tests/LungfishIOTests/MHCReferenceRecordCatalogTests.swift`

**Interfaces:**
- Consumes: `.lungfishref` manifest genome, record-store, and annotation-database paths.
- Produces: `MHCReferenceCompletenessAssessment`, `MHCReferenceCompletenessStatus`, `MHCReferenceCompletenessReason`, and `MHCReferenceRecord.completeness`.

- [x] **Step 1: Write failing catalog tests**

Add literal annotation fixtures for a complete eight-exon Mamu-E record, a complete seven-exon Mamu-E record, a complete six-exon DRB record, a genomic record missing an intervening intron, a cDNA record, and a bundle without an annotation database. Assert the exact status, reason, observed exon/intron numbers, and accepted terminal exon numbers.

```swift
XCTAssertEqual(record.completeness.status, .complete)
XCTAssertEqual(record.completeness.reason, .annotationTopology)
XCTAssertEqual(record.completeness.observedExons, Array(1...8))
XCTAssertEqual(record.completeness.acceptedTerminalExons, [7, 8])
```

- [x] **Step 2: Run the catalog suite and verify RED**

Run: `swift test --skip-update --filter MHCReferenceRecordCatalogTests`

Expected: compilation fails because the completeness API does not exist.

- [x] **Step 3: Implement the minimal catalog assessment**

Add backward-compatible Codable types and a default unknown assessment to the public record initializer. Decode annotation database paths from the manifest, open them read-only, read exon/intron/CDS rows, parse the `number` and `_lf_raw_genbank_location` attributes, and evaluate the approved topology and boundary rules.

```swift
public enum MHCReferenceCompletenessStatus: String, Codable, Equatable, Sendable {
    case complete, incomplete, unknown
}

public struct MHCReferenceCompletenessAssessment: Codable, Equatable, Sendable {
    public let status: MHCReferenceCompletenessStatus
    public let reason: MHCReferenceCompletenessReason
    public let observedExons: [Int]
    public let observedIntrons: [Int]
    public let acceptedTerminalExons: [Int]
}
```

- [x] **Step 4: Run the catalog suite and verify GREEN**

Run: `swift test --skip-update --filter MHCReferenceRecordCatalogTests`

Expected: all catalog tests pass.

### Task 2: Completeness-aware known classification

**Files:**
- Modify: `Sources/LungfishWorkflow/ONTGenotyping/FullLengthONTMHCCandidateClassifier.swift`
- Modify: `Tests/LungfishWorkflowTests/FullLengthONTMHCCandidateClassifierTests.swift`

**Interfaces:**
- Consumes: `MHCReferenceRecord.completeness`.
- Produces: known classification for complete full-reference genomic matches with terminal soft clips only.

- [x] **Step 1: Write failing Mamu-E regression tests**

Construct complete seven- and eight-exon genomic records and classify literal CIGARs `218S3186=286S` and `189S2551=300S`. Assert known calls. Add controls asserting partial extension for unknown/incomplete references and no promotion for `218S1500=1I1686=286S`.

```swift
guard case .known(let calls) = try classifier.classify(cluster) else {
    return XCTFail("Expected complete genomic reference with terminal flank to remain known")
}
XCTAssertEqual(calls.map(\.reference.sequenceID), ["PROV014ff"])
```

- [x] **Step 2: Run the classifier suite and verify RED**

Run: `swift test --skip-update --filter FullLengthONTMHCCandidateClassifierTests`

Expected: the Mamu-E soft-clipped cases are returned as partial extensions.

- [x] **Step 3: Implement the minimal classifier branch**

Extend `isExactEndToEndGenomicMatch` so its legacy branch remains unchanged and its new branch requires `.complete`, reference start 1, full reference span, zero SNP/I/D/N/H, and permits only soft clipping outside the reference span.

```swift
let completeReferenceWithTerminalFlank = reference.completeness.status == .complete
    && hit.input.evidence.referenceStart == 1
    && hit.metrics.referenceSpan == reference.sequenceLength
    && hit.metrics.snps == 0
    && hit.metrics.insertedBases == 0
    && hit.metrics.deletedBases == 0
    && hit.metrics.skippedReferenceBases == 0
    && hit.metrics.hardClippedBases == 0
```

- [x] **Step 4: Run the classifier suite and verify GREEN**

Run: `swift test --skip-update --filter FullLengthONTMHCCandidateClassifierTests`

Expected: all classifier tests pass, including the pre-existing DRB partial-extension cases.

### Task 3: Catalog and classification provenance

**Files:**
- Modify: `Sources/LungfishWorkflow/ONTGenotyping/FullLengthONTMHCGenotypingSupportTypes.swift`
- Modify: `Sources/LungfishWorkflow/ONTGenotyping/FullLengthONTMHCGenotypingPipeline+References.swift`
- Modify: `Sources/LungfishWorkflow/ONTGenotyping/FullLengthONTMHCCandidateArtifactWriter.swift`
- Modify: `Tests/LungfishWorkflowTests/FullLengthONTMHCGenotypingPipelineTests.swift`
- Modify: `Tests/LungfishWorkflowTests/FullLengthONTMHCCandidateArtifactWriterTests.swift`

**Interfaces:**
- Consumes: manifest annotation-database URLs and catalog completeness assessments.
- Produces: reference projection schema version 2 and reproducibility-complete provenance options/inputs.

- [x] **Step 1: Write failing provenance tests**

Assert that the catalog-import step includes `--annotation-database`, checksums that database, reports completeness counts and the topology policy, and that candidate classification reports the new soft-clip-aware rule and precedence.

```swift
XCTAssertEqual(value(after: "--annotation-database", in: step.argv), annotationDatabaseURL.path)
XCTAssertEqual(step.resolvedOptions["referenceCompletenessPolicy"], .string("class-I=7,8;DRA=5;DRB,DPA,DPB,DQA,DQB=6"))
XCTAssertEqual(classification.resolvedOptions["completeReferenceTerminalSoftClipPolicy"], "known-when-full-reference-zero-snp-no-I-D-N-H")
```

- [x] **Step 2: Run the affected provenance tests and verify RED**

Run: `swift test --skip-update --filter 'FullLengthONTMHCGenotypingPipelineTests|FullLengthONTMHCCandidateArtifactWriterTests'`

Expected: assertions fail because annotation inputs and completeness options are absent.

- [x] **Step 3: Implement provenance and schema updates**

Add annotation database URLs to `FullLengthONTMHCReferenceCatalogInputs`, argv, and input descriptors; bump the catalog projection schema; add complete/incomplete/unknown counts and the resolved topology policy to import options; revise classification rule strings without removing threshold provenance.

- [x] **Step 4: Run the affected provenance tests and verify GREEN**

Run: `swift test --skip-update --filter 'FullLengthONTMHCGenotypingPipelineTests|FullLengthONTMHCCandidateArtifactWriterTests'`

Expected: all affected provenance tests pass with checksums and sizes populated.

### Task 4: Integrated verification and debug build

**Files:**
- Verify: all modified source and test files.
- Create: `build/Debug/Lungfish Debug.app` (ignored build artifact).

**Interfaces:**
- Consumes: completed tasks 1-3.
- Produces: a locally ad-hoc-signed, non-publishable debug app for user testing.

- [x] **Step 1: Run focused regression suites**

Run: `swift test --skip-update --filter 'MHCReferenceRecordCatalogTests|FullLengthONTMHCCandidateClassifierTests|FullLengthONTMHCGenotypingPipelineTests|FullLengthONTMHCCandidateArtifactWriterTests'`

Expected: zero failures.

- [ ] **Step 2: Run the package test gate**

Run: `scripts/full-suite-gate.sh`

Expected: zero failures and an exit status of 0.

- [x] **Step 3: Build the debug application**

Run: `python3 scripts/release/release.py debug --jobs 8`

Expected: exit status 0 and `build/Debug/Lungfish Debug.app` exists.

- [x] **Step 4: Verify branch state and artifact identity**

Run: `git diff --check && git status --short && /usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' 'build/Debug/Lungfish Debug.app/Contents/Info.plist'`

Expected: no whitespace errors, only intended source/test/docs changes, and bundle identifier `com.lungfish.browser.debug`.
