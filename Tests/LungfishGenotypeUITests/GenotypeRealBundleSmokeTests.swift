// GenotypeRealBundleSmokeTests.swift - optional smoke against a local real bundle

import XCTest
import AppKit
import LungfishCore
import LungfishIO
@testable import LungfishGenotypeUI

@MainActor
final class GenotypeRealBundleSmokeTests: XCTestCase {
    private let realBundleEnvironmentKey = "LUNGFISH_GENOTYPE_REAL_BUNDLE"

    private func loadRealBundleOrSkip() throws -> ONTGenotypeResultBundleData {
        guard let realBundlePath = ProcessInfo.processInfo.environment[realBundleEnvironmentKey],
              !realBundlePath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw XCTSkip("Set \(realBundleEnvironmentKey) to run the optional real genotype bundle smoke test")
        }
        let url = URL(fileURLWithPath: realBundlePath)
        guard FileManager.default.fileExists(atPath: realBundlePath) else {
            throw XCTSkip("Real genotype bundle not found at \(realBundlePath)")
        }
        return try ONTGenotypeResultBundle.loadResult(from: url)
    }

    func testRealBundleLoadsAnalysisAndCalls() throws {
        let result = try loadRealBundleOrSkip()
        XCTAssertFalse(result.samples.isEmpty, "Expect samples in the real bundle")
        XCTAssertFalse(result.calls.isEmpty, "Expect raw calls in the real bundle")
        XCTAssertNotNil(result.haplotypeAnalysis, "Real bundle should carry a haplotype analysis")
    }

    func testMiSeqReferenceMatrixUsesConciseLabelsAndPreservesEvidence() throws {
        let result = try loadRealBundleOrSkip()
        guard result.calls.contains(where: { !MHCReferenceGenotypeDisplay.alleleNames(for: $0.genotype).isEmpty }) else {
            throw XCTSkip("Real bundle does not contain collapsed MHC reference headers")
        }
        GenotypeComparisonMatrixView.testingResetPersistedReferenceVisibility()
        defer { GenotypeComparisonMatrixView.testingResetPersistedReferenceVisibility() }
        let matrix = GenotypeComparisonMatrixView()
        matrix.configure(result: result)
        let rows = matrix.testingVisibleRows
        let expected = result.locusSummaries.flatMap(\.sharedCalls)
        XCTAssertEqual(rows.count, expected.count)
        XCTAssertEqual(Set(rows.map(\.genotype)), Set(result.calls.map(\.genotype)))
        XCTAssertEqual(rows.reduce(0) { $0 + $1.totalUniqueReads }, expected.reduce(0) { $0 + $1.totalUniqueReads })
        let names = rows.map { MHCReferenceGenotypeDisplay.alleleName(for: $0.genotype) }
        XCTAssertFalse(names.isEmpty)
        XCTAssertTrue(names.allSatisfy { !$0.contains("|alleles=") && $0.hasPrefix("Mafa-") })
        for (left, right) in zip(names, names.dropFirst()) {
            XCTAssertNotEqual(MHCAlleleDisplayOrder.compare(left, right), .orderedDescending)
        }
        for row in rows {
            XCTAssertEqual(matrix.testingReferenceValue(genotype: row.genotype, fieldKey: "feature.allele"), MHCReferenceGenotypeDisplay.alleleName(for: row.genotype))
        }
        XCTAssertTrue(matrix.testingPinnedColumnTitles.contains("Allele"))
        XCTAssertFalse(matrix.testingPinnedColumnTitles.contains("Full reference name"))
        print("MiSeq matrix smoke: \(rows.count) rows, \(result.samples.count) samples, \(rows.reduce(0) { $0 + $1.totalUniqueReads }) unique reads; all reference identities retained")
        if let screenshotPath = ProcessInfo.processInfo.environment["LUNGFISH_GENOTYPE_SMOKE_SCREENSHOT"] {
            matrix.frame = NSRect(x: 0, y: 0, width: 1500, height: 1250)
            let window = NSWindow(contentRect: matrix.frame, styleMask: [.titled], backing: .buffered, defer: false)
            window.contentView = matrix
            matrix.layoutSubtreeIfNeeded()
            let bitmap = try XCTUnwrap(matrix.bitmapImageRepForCachingDisplay(in: matrix.bounds))
            matrix.cacheDisplay(in: matrix.bounds, to: bitmap)
            let png = try XCTUnwrap(bitmap.representation(using: .png, properties: [:]))
            try png.write(to: URL(fileURLWithPath: screenshotPath))
        }
    }

    func testObservedLociIndexIncludesNonAnalyzedLoci() throws {
        let result = try loadRealBundleOrSkip()
        let index = GenotypeObservedLociIndex.build(from: result)
        let analyzed = (result.haplotypeAnalysis?.samples.first?.calls.map(\.locus)) ?? []
        let observedOnly = index.loci.filter { !analyzed.contains($0) }
        XCTAssertFalse(observedOnly.isEmpty,
            "Bundle observes non-analyzed loci (e.g. MHC-AG, MHC-F, MHC-G); the index must include them")
    }

    func testViewportConfiguresWithRealBundleWithoutCrash() throws {
        let result = try loadRealBundleOrSkip()
        let controller = GenotypeResultViewController()
        _ = controller.view
        controller.configure(result: result)
        // Force a layout pass to exercise the panel constraints.
        controller.view.frame = NSRect(x: 0, y: 0, width: 1400, height: 800)
        controller.view.layoutSubtreeIfNeeded()
        // Configure should populate the view hierarchy without crashing;
        // the view's accessibility label is set by the controller.
        XCTAssertEqual(controller.view.accessibilityLabel(), "Genotype result viewport")
    }

    func testLegacyMiSeqBundleUsesSynchronizedPresentationSelector() throws {
        let result = try loadRealBundleOrSkip()
        guard result.manifest.kind == "ont-barcode-genotype",
              result.manifest.workflowKind == nil,
              result.manifest.workflowMode == nil,
              result.haplotypeAnalysis?.assayID == "MHC-exon2-miSeq" else {
            throw XCTSkip("Real bundle is not the beta19 ONT-sample-bundle miSeq result shape")
        }
        guard case .ineligible = GenotypeManualHaplotypeEligibility.evaluate(result) else {
            return XCTFail("A result with persisted haplotype calls must not enter manual genotype-only mode")
        }
        let controller = GenotypeResultViewController()
        _ = controller.view
        controller.configure(result: result)
        XCTAssertEqual(
            controller.testingLensControlLabels,
            ["Haplotype Calls", "Genotype Matrix"]
        )
        XCTAssertEqual(controller.testingVisibleLensIdentifier, "summary")
        XCTAssertEqual(controller.testingSummaryViewMode, .outline)
    }

    func testCohortSubjectBuilderProducesOneSubjectPerSample() throws {
        let result = try loadRealBundleOrSkip()
        let sidecar = try ONTGenotypeResultBundleData
            .loadOrCreateAnnotationSidecar(forBundleAt: result.bundleURL)
        let subjects = GenotypeCohortSubjectBuilder.buildSubjects(result: result, sidecar: sidecar)
        XCTAssertEqual(subjects.count, result.samples.count)
    }

    func testNeedsReviewCohortReturnsAtLeastOneSubject() throws {
        let result = try loadRealBundleOrSkip()
        let sidecar = try ONTGenotypeResultBundleData
            .loadOrCreateAnnotationSidecar(forBundleAt: result.bundleURL)
        let subjects = GenotypeCohortSubjectBuilder.buildSubjects(result: result, sidecar: sidecar)
        let predicate: SmartCohortPredicate = .any([
            .hasErrorAtAnyLocus,
            .qcStatus([.review, .lowSupport]),
            .hasAnalystFlag(.needsReview),
        ])
        let matched = subjects.filter { predicate.evaluate($0) }
        XCTAssertFalse(matched.isEmpty,
            "Real bundle should have at least some samples in the Needs review cohort " +
            "(most carry ERR: TMH / ERR: TMG / ERR: NO HAP at one or more loci)")
    }

    func testManualHaplotypingDigestSurfacesObservedGenotypes() throws {
        let result = try loadRealBundleOrSkip()
        let digest = GenotypeManualHaplotypingDigest.build(from: result.calls)
        XCTAssertFalse(digest.observations.isEmpty,
            "Digest should surface observed genotypes across analyzed and non-analyzed loci")
        // Confirm at least one MHC-AG observation (non-analyzed locus in MCM set).
        let mhcAG = digest.observations.first { $0.locus == "MHC-AG" }
        XCTAssertNotNil(mhcAG, "Bundle observes MHC-AG genotypes")
    }
}
