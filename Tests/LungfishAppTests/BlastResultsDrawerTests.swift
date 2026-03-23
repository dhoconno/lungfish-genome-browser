// BlastResultsDrawerTests.swift - Tests for BLAST verification results drawer tab
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishApp
@testable import LungfishCore
@testable import LungfishIO
@testable import LungfishWorkflow

// MARK: - Test Helpers

/// Builds a high-confidence BLAST verification result (18/20 verified = 90%).
@MainActor
private func makeHighConfidenceResult() -> BlastVerificationResult {
    var reads: [BlastReadResult] = []

    // 16 verified reads
    for i in 0..<16 {
        reads.append(BlastReadResult(
            id: "SRR123456.\(1000 + i)",
            verdict: .verified,
            topHitOrganism: "Escherichia coli",
            topHitAccession: "NZ_CP012345.\(i)",
            percentIdentity: 98.5 + Double.random(in: -1.0...1.0),
            eValue: 0.0
        ))
    }

    // 2 verified reads with slightly different organism names
    reads.append(BlastReadResult(
        id: "SRR123456.2000",
        verdict: .verified,
        topHitOrganism: "Escherichia coli K-12",
        topHitAccession: "U00096.3",
        percentIdentity: 99.8,
        eValue: 0.0
    ))
    reads.append(BlastReadResult(
        id: "SRR123456.2001",
        verdict: .verified,
        topHitOrganism: "Escherichia coli O157:H7",
        topHitAccession: "NC_002695.2",
        percentIdentity: 97.1,
        eValue: 0.0
    ))

    // 1 ambiguous read (related genus)
    reads.append(BlastReadResult(
        id: "SRR123456.3000",
        verdict: .ambiguous,
        topHitOrganism: "Shigella flexneri",
        percentIdentity: 97.1,
        eValue: 1e-120
    ))

    // 1 unverified read (no hit)
    reads.append(BlastReadResult(
        id: "SRR123456.4000",
        verdict: .unverified
    ))

    return BlastVerificationResult(
        taxonName: "Escherichia coli",
        taxId: 562,
        readResults: reads,
        submittedAt: Date(),
        completedAt: Date(),
        rid: "ABCD1234",
        blastProgram: "megablast",
        database: "core_nt"
    )
}

/// Builds a low-confidence BLAST verification result (3/20 verified = 15%).
@MainActor
private func makeLowConfidenceResult() -> BlastVerificationResult {
    var reads: [BlastReadResult] = []

    // 3 verified reads
    for i in 0..<3 {
        reads.append(BlastReadResult(
            id: "SRR999999.\(i)",
            verdict: .verified,
            topHitOrganism: "Oxbow virus",
            percentIdentity: 95.0 + Double(i),
            eValue: 1e-45
        ))
    }

    // 7 ambiguous reads
    for i in 3..<10 {
        reads.append(BlastReadResult(
            id: "SRR999999.\(i)",
            verdict: .ambiguous,
            topHitOrganism: "Bunyaviridae sp.",
            percentIdentity: 82.0 + Double(i),
            eValue: 1e-12
        ))
    }

    // 5 unverified reads
    for i in 10..<15 {
        reads.append(BlastReadResult(
            id: "SRR999999.\(i)",
            verdict: .unverified
        ))
    }

    // 5 error reads
    for i in 15..<20 {
        reads.append(BlastReadResult(
            id: "SRR999999.\(i)",
            verdict: .error
        ))
    }

    return BlastVerificationResult(
        taxonName: "Oxbow virus",
        taxId: 2559587,
        readResults: reads,
        submittedAt: Date(),
        completedAt: Date(),
        rid: "EFGH5678",
        blastProgram: "megablast",
        database: "core_nt"
    )
}

/// Builds a result with an empty RID (simulating local BLAST or missing RID).
@MainActor
private func makeResultWithEmptyRID() -> BlastVerificationResult {
    BlastVerificationResult(
        taxonName: "Test taxon",
        taxId: 1,
        readResults: [
            BlastReadResult(
                id: "read_1",
                verdict: .verified,
                topHitOrganism: "Test organism",
                percentIdentity: 99.0,
                eValue: 0.0
            ),
        ],
        submittedAt: Date(),
        completedAt: Date(),
        rid: "",
        blastProgram: "megablast",
        database: "core_nt"
    )
}

// MARK: - BlastResultsDrawerTests

@MainActor
final class BlastResultsDrawerTests: XCTestCase {

    // MARK: - Empty State

    func testEmptyState() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        tab.layoutSubtreeIfNeeded()

        // Default state should be empty
        if case .empty = tab.displayState {
            // expected
        } else {
            XCTFail("Default state should be .empty, got: \(tab.displayState)")
        }

        // No result should be available
        XCTAssertNil(tab.currentResult, "No result should be available in empty state")
    }

    func testEmptyStateAfterExplicitShowEmpty() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))

        // Show results first, then reset to empty
        let result = makeHighConfidenceResult()
        tab.showResults(result)
        XCTAssertNotNil(tab.currentResult)

        tab.showEmpty()

        if case .empty = tab.displayState {
            // expected
        } else {
            XCTFail("State should be .empty after showEmpty()")
        }
    }

    // MARK: - Summary Bar: High Confidence

    func testSummaryBarWithHighConfidence() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let result = makeHighConfidenceResult()

        tab.showResults(result)
        tab.layoutSubtreeIfNeeded()

        // Verify summary text
        XCTAssertEqual(tab.summaryLabel.stringValue, "18 of 20 reads verified (90%)")

        // Verify confidence label (BlastVerificationResult.Confidence.high -> "High")
        XCTAssertEqual(tab.confidenceLabel.stringValue, "High")

        // Verify the result model
        XCTAssertEqual(result.verifiedCount, 18)
        XCTAssertEqual(result.ambiguousCount, 1)
        XCTAssertEqual(result.unverifiedCount, 1)
        XCTAssertEqual(result.errorCount, 0)
        XCTAssertEqual(result.verificationPercentage, 90)
    }

    // MARK: - Summary Bar: Low Confidence

    func testSummaryBarWithLowConfidence() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let result = makeLowConfidenceResult()

        tab.showResults(result)
        tab.layoutSubtreeIfNeeded()

        // Verify summary text
        XCTAssertEqual(tab.summaryLabel.stringValue, "3 of 20 reads verified (15%)")

        // Verify confidence label - 15% is "suspect" (< 20%), displayed as "Very Low"
        XCTAssertEqual(tab.confidenceLabel.stringValue, "Very Low")

        // Verify the result model
        XCTAssertEqual(result.verifiedCount, 3)
        XCTAssertEqual(result.ambiguousCount, 7)
        XCTAssertEqual(result.unverifiedCount, 5)
        XCTAssertEqual(result.errorCount, 5)
        XCTAssertEqual(result.verificationPercentage, 15)
    }

    // MARK: - Results Table Row Count

    func testResultsTableRowCount() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let result = makeHighConfidenceResult()

        tab.showResults(result)
        tab.layoutSubtreeIfNeeded()

        let rowCount = tab.resultsTableView.dataSource?.numberOfRows?(in: tab.resultsTableView) ?? 0
        XCTAssertEqual(rowCount, 20, "Table should have 20 rows (one per submitted read)")
    }

    func testResultsTableRowCountLowConfidence() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let result = makeLowConfidenceResult()

        tab.showResults(result)
        tab.layoutSubtreeIfNeeded()

        let rowCount = tab.resultsTableView.dataSource?.numberOfRows?(in: tab.resultsTableView) ?? 0
        XCTAssertEqual(rowCount, 20, "Table should have 20 rows")
    }

    // MARK: - Verdict Icons

    func testVerdictIcons() throws {
        // Verified
        XCTAssertEqual(BlastVerdict.verified.sfSymbolName, "checkmark.circle.fill")
        XCTAssertEqual(BlastVerdict.verified.displayColor, .systemGreen)
        XCTAssertEqual(BlastVerdict.verified.accessibilityDescription, "Verified")

        // Ambiguous
        XCTAssertEqual(BlastVerdict.ambiguous.sfSymbolName, "exclamationmark.triangle.fill")
        XCTAssertEqual(BlastVerdict.ambiguous.displayColor, .systemYellow)
        XCTAssertEqual(BlastVerdict.ambiguous.accessibilityDescription, "Ambiguous")

        // Unverified
        XCTAssertEqual(BlastVerdict.unverified.sfSymbolName, "xmark.circle.fill")
        XCTAssertEqual(BlastVerdict.unverified.displayColor, .systemRed)
        XCTAssertEqual(BlastVerdict.unverified.accessibilityDescription, "Unverified")

        // Error
        XCTAssertEqual(BlastVerdict.error.sfSymbolName, "exclamationmark.octagon.fill")
        XCTAssertEqual(BlastVerdict.error.displayColor, .systemGray)
        XCTAssertEqual(BlastVerdict.error.accessibilityDescription, "Error")
    }

    // MARK: - Open in BLAST URL

    func testOpenInBlastURL() throws {
        let result = makeHighConfidenceResult()

        XCTAssertNotNil(result.ncbiResultsURL)
        XCTAssertEqual(
            result.ncbiResultsURL?.absoluteString,
            "https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Get&RID=ABCD1234&FORMAT_TYPE=HTML"
        )
    }

    func testOpenInBlastURLWithEmptyRID() throws {
        let result = makeResultWithEmptyRID()

        // URL will still be constructed (it's valid syntactically), but button should be disabled
        XCTAssertNotNil(result.ncbiResultsURL)
    }

    func testOpenInBlastButtonDisabledWithEmptyRID() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let result = makeResultWithEmptyRID()

        tab.showResults(result)
        tab.layoutSubtreeIfNeeded()

        XCTAssertFalse(tab.openInBlastButton.isEnabled, "Button should be disabled when RID is empty")
    }

    func testOpenInBlastButtonEnabledWithRID() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let result = makeHighConfidenceResult()

        tab.showResults(result)
        tab.layoutSubtreeIfNeeded()

        XCTAssertTrue(tab.openInBlastButton.isEnabled, "Button should be enabled when RID is present")
    }

    // MARK: - Confidence Levels

    func testConfidenceLevelFromRate() throws {
        // Use the actual model's confidence property
        let highResult = BlastVerificationResult(
            taxonName: "Test", taxId: 1, totalReads: 10,
            verifiedCount: 9, ambiguousCount: 1, unverifiedCount: 0, errorCount: 0,
            readResults: [], submittedAt: Date(), completedAt: Date(),
            rid: "X", blastProgram: "megablast", database: "nt"
        )
        XCTAssertEqual(highResult.confidence, .high)

        let moderateResult = BlastVerificationResult(
            taxonName: "Test", taxId: 1, totalReads: 10,
            verifiedCount: 6, ambiguousCount: 2, unverifiedCount: 2, errorCount: 0,
            readResults: [], submittedAt: Date(), completedAt: Date(),
            rid: "X", blastProgram: "megablast", database: "nt"
        )
        XCTAssertEqual(moderateResult.confidence, .moderate)

        let lowResult = BlastVerificationResult(
            taxonName: "Test", taxId: 1, totalReads: 10,
            verifiedCount: 3, ambiguousCount: 3, unverifiedCount: 4, errorCount: 0,
            readResults: [], submittedAt: Date(), completedAt: Date(),
            rid: "X", blastProgram: "megablast", database: "nt"
        )
        XCTAssertEqual(lowResult.confidence, .low)

        let suspectResult = BlastVerificationResult(
            taxonName: "Test", taxId: 1, totalReads: 10,
            verifiedCount: 1, ambiguousCount: 1, unverifiedCount: 8, errorCount: 0,
            readResults: [], submittedAt: Date(), completedAt: Date(),
            rid: "X", blastProgram: "megablast", database: "nt"
        )
        XCTAssertEqual(suspectResult.confidence, .suspect)
    }

    func testConfidenceLevelLabels() throws {
        XCTAssertEqual(BlastVerificationResult.Confidence.high.displayLabel, "High")
        XCTAssertEqual(BlastVerificationResult.Confidence.moderate.displayLabel, "Mixed")
        XCTAssertEqual(BlastVerificationResult.Confidence.low.displayLabel, "Low")
        XCTAssertEqual(BlastVerificationResult.Confidence.suspect.displayLabel, "Very Low")
    }

    // MARK: - Confidence Dots

    func testConfidenceDotsAllVerified() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let dots = tab.buildConfidenceDots(verified: 20, total: 20)
        // All 10 dots should be filled
        let filledCount = dots.filter { $0 == "\u{25CF}" }.count
        let emptyCount = dots.filter { $0 == "\u{25CB}" }.count
        XCTAssertEqual(filledCount, 10)
        XCTAssertEqual(emptyCount, 0)
        XCTAssertEqual(dots.count, 10)
    }

    func testConfidenceDotsNoneVerified() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let dots = tab.buildConfidenceDots(verified: 0, total: 20)
        // All 10 dots should be empty
        let filledCount = dots.filter { $0 == "\u{25CF}" }.count
        let emptyCount = dots.filter { $0 == "\u{25CB}" }.count
        XCTAssertEqual(filledCount, 0)
        XCTAssertEqual(emptyCount, 10)
    }

    func testConfidenceDotsHalfVerified() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let dots = tab.buildConfidenceDots(verified: 10, total: 20)
        let filledCount = dots.filter { $0 == "\u{25CF}" }.count
        let emptyCount = dots.filter { $0 == "\u{25CB}" }.count
        XCTAssertEqual(filledCount, 5)
        XCTAssertEqual(emptyCount, 5)
    }

    func testConfidenceDotsEmptyTotal() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let dots = tab.buildConfidenceDots(verified: 0, total: 0)
        // All dots should be empty when total is 0
        let emptyCount = dots.filter { $0 == "\u{25CB}" }.count
        XCTAssertEqual(emptyCount, 10)
    }

    // MARK: - Loading State

    func testLoadingStateSubmitting() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))

        tab.showLoading(phase: .submitting, requestId: nil)

        if case .loading(let phase, let rid) = tab.displayState {
            XCTAssertEqual(phase, .submitting)
            XCTAssertNil(rid)
        } else {
            XCTFail("Should be in loading state")
        }
    }

    func testLoadingStateWaitingWithRID() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))

        tab.showLoading(phase: .waiting, requestId: "WXYZ9999")

        if case .loading(let phase, let rid) = tab.displayState {
            XCTAssertEqual(phase, .waiting)
            XCTAssertEqual(rid, "WXYZ9999")
        } else {
            XCTFail("Should be in loading state")
        }
    }

    // MARK: - E-Value Formatting

    func testEValueFormattingNil() throws {
        XCTAssertEqual(BlastResultsDrawerTab.formatEValue(nil), "--")
    }

    func testEValueFormattingZero() throws {
        XCTAssertEqual(BlastResultsDrawerTab.formatEValue(0.0), "0.0")
    }

    func testEValueFormattingSmall() throws {
        let formatted = BlastResultsDrawerTab.formatEValue(1e-45)
        XCTAssertEqual(formatted, "1e-45")
    }

    func testEValueFormattingLarger() throws {
        let formatted = BlastResultsDrawerTab.formatEValue(0.005)
        // Should use scientific notation for values >= 0.001
        XCTAssertTrue(formatted.contains("e") || formatted.contains("E") || formatted == "0.005",
                       "Expected scientific or decimal notation, got: \(formatted)")
    }

    // MARK: - Drawer Tab Integration

    func testDrawerTabSwitching() throws {
        let drawer = TaxaCollectionsDrawerView(frame: NSRect(x: 0, y: 0, width: 800, height: 220))
        drawer.layoutSubtreeIfNeeded()

        // Default tab should be collections
        XCTAssertEqual(drawer.selectedTab, .collections)

        // Switch to BLAST tab
        drawer.switchToTab(.blastResults)
        XCTAssertEqual(drawer.selectedTab, .blastResults)
        XCTAssertEqual(drawer.tabControl.selectedSegment, DrawerTab.blastResults.rawValue)

        // Switch back to collections
        drawer.switchToTab(.collections)
        XCTAssertEqual(drawer.selectedTab, .collections)
        XCTAssertEqual(drawer.tabControl.selectedSegment, DrawerTab.collections.rawValue)
    }

    func testDrawerShowBlastResultsSwitchesTab() throws {
        let drawer = TaxaCollectionsDrawerView(frame: NSRect(x: 0, y: 0, width: 800, height: 220))
        drawer.layoutSubtreeIfNeeded()

        // Start on collections tab
        XCTAssertEqual(drawer.selectedTab, .collections)

        // Show BLAST results
        let result = makeHighConfidenceResult()
        drawer.showBlastResults(result)

        // Should have switched to BLAST tab
        XCTAssertEqual(drawer.selectedTab, .blastResults)

        // BLAST tab should have the result
        XCTAssertNotNil(drawer.blastResultsTab.currentResult)
        XCTAssertEqual(drawer.blastResultsTab.currentResult?.taxonName, "Escherichia coli")
    }

    func testDrawerTabControlHasTwoSegments() throws {
        let drawer = TaxaCollectionsDrawerView(frame: NSRect(x: 0, y: 0, width: 800, height: 220))
        drawer.layoutSubtreeIfNeeded()

        XCTAssertEqual(drawer.tabControl.segmentCount, 2)
        XCTAssertEqual(drawer.tabControl.label(forSegment: 0), "Collections")
        XCTAssertEqual(drawer.tabControl.label(forSegment: 1), "BLAST Results")
    }

    // MARK: - Verification Result Model

    func testVerificationResultComputedProperties() throws {
        let result = makeHighConfidenceResult()

        XCTAssertEqual(result.taxonName, "Escherichia coli")
        XCTAssertEqual(result.taxId, 562)
        XCTAssertEqual(result.totalReads, 20)
        XCTAssertEqual(result.readResults.count, 20)
        XCTAssertEqual(result.blastProgram, "megablast")
        XCTAssertEqual(result.database, "core_nt")
        XCTAssertEqual(result.rid, "ABCD1234")

        // Computed counts
        XCTAssertEqual(result.verifiedCount, 18)
        XCTAssertEqual(result.ambiguousCount, 1)
        XCTAssertEqual(result.unverifiedCount, 1)
        XCTAssertEqual(result.errorCount, 0)

        // Rate calculations
        XCTAssertEqual(result.verificationRate, 0.9, accuracy: 0.001)
        XCTAssertEqual(result.verificationPercentage, 90)
        XCTAssertEqual(result.confidence, .high)
    }

    func testVerificationResultEmptyReads() throws {
        let result = BlastVerificationResult(
            taxonName: "Empty",
            taxId: 0,
            readResults: [],
            submittedAt: Date(),
            completedAt: nil,
            rid: "",
            blastProgram: "megablast",
            database: "core_nt"
        )

        XCTAssertEqual(result.verifiedCount, 0)
        XCTAssertEqual(result.verificationRate, 0.0)
        XCTAssertEqual(result.verificationPercentage, 0)
        XCTAssertEqual(result.confidence, .suspect)
    }

    // MARK: - BLAST Job Phase

    func testBlastJobPhaseLabels() throws {
        XCTAssertEqual(BlastJobPhase.submitting.label, "Submitting reads to NCBI BLAST...")
        XCTAssertEqual(BlastJobPhase.waiting.label, "Waiting for NCBI BLAST results...")
        XCTAssertEqual(BlastJobPhase.parsing.label, "Parsing BLAST results...")
        XCTAssertEqual(BlastJobPhase.totalPhases, 3)
    }

    func testBlastJobPhaseRawValues() throws {
        XCTAssertEqual(BlastJobPhase.submitting.rawValue, 1)
        XCTAssertEqual(BlastJobPhase.waiting.rawValue, 2)
        XCTAssertEqual(BlastJobPhase.parsing.rawValue, 3)
    }

    // MARK: - Drawer Tab Enum

    func testDrawerTabTitles() throws {
        XCTAssertEqual(DrawerTab.collections.title, "Collections")
        XCTAssertEqual(DrawerTab.blastResults.title, "BLAST Results")
    }

    func testDrawerTabRawValues() throws {
        XCTAssertEqual(DrawerTab.collections.rawValue, 0)
        XCTAssertEqual(DrawerTab.blastResults.rawValue, 1)
    }

    func testDrawerTabAllCases() throws {
        XCTAssertEqual(DrawerTab.allCases.count, 2)
    }

    // MARK: - Collections Tab Still Works

    func testCollectionsTabUnaffectedByBlastTab() throws {
        let drawer = TaxaCollectionsDrawerView(frame: NSRect(x: 0, y: 0, width: 800, height: 220))
        drawer.layoutSubtreeIfNeeded()

        // Collections should still load
        XCTAssertEqual(
            drawer.displayedCollectionCount,
            TaxaCollection.builtIn.count,
            "Collections should still be available after adding BLAST tab"
        )

        // Switch to BLAST and back
        drawer.switchToTab(.blastResults)
        drawer.switchToTab(.collections)

        // Collections should still be there
        XCTAssertEqual(drawer.displayedCollectionCount, TaxaCollection.builtIn.count)
    }

    // MARK: - Callback Wiring

    func testOpenInBrowserCallback() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let result = makeHighConfidenceResult()
        tab.showResults(result)

        var receivedURL: URL?
        tab.onOpenInBrowser = { url in
            receivedURL = url
        }

        // Simulate clicking the button by calling performClick
        tab.openInBlastButton.performClick(nil)

        XCTAssertNotNil(receivedURL, "Should have received a URL callback")
        XCTAssertEqual(receivedURL?.absoluteString,
                       "https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Get&RID=ABCD1234&FORMAT_TYPE=HTML")
    }

    func testRerunBlastCallback() throws {
        let tab = BlastResultsDrawerTab(frame: NSRect(x: 0, y: 0, width: 800, height: 300))
        let result = makeHighConfidenceResult()
        tab.showResults(result)

        var rerunCalled = false
        tab.onRerunBlast = {
            rerunCalled = true
        }

        tab.rerunBlastButton.performClick(nil)

        XCTAssertTrue(rerunCalled, "Re-run callback should have been called")
    }
}
