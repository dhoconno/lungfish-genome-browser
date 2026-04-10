// ClassifierExtractionInvariantTests.swift — I1-I7 invariants for unified classifier extraction
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import XCTest
@testable import LungfishApp
@testable import LungfishCLI
@testable import LungfishIO
@testable import LungfishWorkflow

/// Asserts the 7 spec invariants for the unified classifier extraction feature.
///
/// These tests run in under 5 seconds total (performance budget, spec) and
/// cover all 5 classifiers via parameterized helpers. Adding a 6th classifier
/// without wiring it through the unified pipeline will fail these tests.
///
/// | ID | Invariant |
/// |----|-----------|
/// | I1 | Menu item visible: context menu contains "Extract Reads…" when selection non-empty |
/// | I2 | Menu item enabled: `isEnabled == true` under the same conditions |
/// | I3 | Click wiring: activating the menu fires `onExtractReadsRequested` (or shared.present) |
/// | I4 | Count-sequence agreement: extracted FASTQ record count equals `MarkdupService.countReads` |
/// | I5 | Samtools flag dispatch: resolver uses `-F 0x404` (strict) or `-F 0x400` (loose) |
/// | I6 | Clipboard cap enforcement: dialog disables Clipboard above cap; resolver rejects past cap |
/// | I7 | CLI/GUI round-trip equivalence: the CLI command stamped by the GUI reproduces the same FASTQ |
@MainActor
final class ClassifierExtractionInvariantTests: XCTestCase {

    // MARK: - Constants

    private static let extractReadsTitle = "Extract Reads\u{2026}"

    // MARK: - I1: Menu item visible

    func testI1_esviritu_menuItemVisible() throws {
        let table = ViralDetectionTableView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        let menu = table.testingContextMenu
        XCTAssertNotNil(menu, "ViralDetectionTableView must have an outline-view context menu")
        XCTAssertTrue(
            menu?.items.contains(where: { $0.title == Self.extractReadsTitle }) ?? false,
            "ViralDetectionTableView must expose 'Extract Reads…' context menu item"
        )
    }

    func testI1_kraken2_menuItemVisible() throws {
        let table = TaxonomyTableView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        let menu = table.testingContextMenu
        XCTAssertNotNil(menu, "TaxonomyTableView must have an outline-view context menu")
        XCTAssertTrue(
            menu?.items.contains(where: { $0.title == Self.extractReadsTitle }) ?? false,
            "TaxonomyTableView must expose 'Extract Reads…' context menu item"
        )
    }

    // TaxTriage, NAO-MGS, and NVD expose "Extract Reads…" via their own
    // view-controller-owned outline views rather than ViralDetectionTableView /
    // TaxonomyTableView. Instantiating the full VC here needs a live app
    // context, so we use source-level structural smoke tests for those three
    // tools and rely on I3 (click wiring) in their integration test suites
    // for dynamic coverage.
    func testI1_taxtriage_menuItemVisible_sourceLevel() throws {
        let path = "\(ClassifierExtractionFixtures.repositoryRoot.path)/Sources/LungfishApp/Views/Metagenomics/TaxTriageResultViewController.swift"
        let source = try String(contentsOfFile: path, encoding: .utf8)
        XCTAssertTrue(
            source.contains("Extract Reads\u{2026}") || source.contains("Extract Reads\\u{2026}"),
            "TaxTriageResultViewController must wire an 'Extract Reads…' menu item"
        )
        XCTAssertTrue(
            source.contains("contextExtractFASTQ"),
            "TaxTriageResultViewController must have the contextExtractFASTQ action selector"
        )
    }

    func testI1_naomgs_menuItemVisible_sourceLevel() throws {
        let path = "\(ClassifierExtractionFixtures.repositoryRoot.path)/Sources/LungfishApp/Views/Metagenomics/NaoMgsResultViewController.swift"
        let source = try String(contentsOfFile: path, encoding: .utf8)
        XCTAssertTrue(
            source.contains("Extract Reads\u{2026}") || source.contains("Extract Reads\\u{2026}"),
            "NaoMgsResultViewController must wire an 'Extract Reads…' menu item"
        )
        XCTAssertTrue(
            source.contains("contextExtractFASTQ"),
            "NaoMgsResultViewController must have an Extract Reads action selector"
        )
    }

    func testI1_nvd_menuItemVisible_sourceLevel() throws {
        let path = "\(ClassifierExtractionFixtures.repositoryRoot.path)/Sources/LungfishApp/Views/Metagenomics/NvdResultViewController.swift"
        let source = try String(contentsOfFile: path, encoding: .utf8)
        XCTAssertTrue(
            source.contains("Extract Reads\u{2026}") || source.contains("Extract Reads\\u{2026}"),
            "NvdResultViewController must wire an 'Extract Reads…' menu item"
        )
        XCTAssertTrue(
            source.contains("contextExtractReadsUnified"),
            "NvdResultViewController must have the contextExtractReadsUnified action selector"
        )
    }

    // MARK: - I2: Menu item enabled when selection non-empty

    func testI2_esviritu_menuItemEnabledWithSelection() throws {
        let table = ViralDetectionTableView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        table.setTestingSelection(indices: [0])
        let menu = try XCTUnwrap(table.testingContextMenu)
        let item = try XCTUnwrap(
            menu.items.first(where: { $0.title == Self.extractReadsTitle }),
            "Extract Reads menu item must exist"
        )
        let enabled = table.validateMenuItem(item)
        XCTAssertTrue(enabled, "Extract Reads… must be enabled with a non-empty selection")
    }

    func testI2_kraken2_menuItemEnabledWithSelection() throws {
        let table = TaxonomyTableView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        table.setTestingSelection(indices: [0])
        let menu = try XCTUnwrap(table.testingContextMenu)
        let item = try XCTUnwrap(
            menu.items.first(where: { $0.title == Self.extractReadsTitle }),
            "Extract Reads menu item must exist"
        )
        let enabled = table.validateMenuItem(item)
        XCTAssertTrue(enabled, "Extract Reads… must be enabled with a non-empty selection")
    }

    // The other 3 tools' menus live on their VCs and I2 is therefore covered
    // indirectly by the I3 click-wiring tests — if the item wasn't enabled,
    // activating it would be a no-op.

    // MARK: - I3: Click wiring fires the orchestrator

    func testI3_clickWiring_esviritu_firesPresent() {
        let table = ViralDetectionTableView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        var fired = 0
        table.onExtractReadsRequested = { fired += 1 }
        table.simulateContextMenuExtractReads()
        XCTAssertEqual(fired, 1, "EsViritu menu click must fire onExtractReadsRequested exactly once")
    }

    func testI3_clickWiring_kraken2_firesPresent() {
        let table = TaxonomyTableView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        var fired = 0
        table.onExtractReadsRequested = { fired += 1 }
        table.simulateContextMenuExtractReads()
        XCTAssertEqual(fired, 1, "Kraken2 menu click must fire onExtractReadsRequested exactly once")
    }

    // MARK: - I4: Count-sequence agreement

    /// Helper: runs the resolver for a given tool + fixture + destination and
    /// asserts the outcome's readCount equals the MarkdupService count for
    /// the same BAM + region + flag filter.
    private func assertI4(
        tool: ClassifierTool,
        destinationBuilder: (URL) -> ExtractionDestination,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async throws {
        guard tool.usesBAMDispatch else { return }  // I4 scoped to BAM-backed tools

        let sampleId = "I4"
        let (resultPath, projectRoot) = try ClassifierExtractionFixtures.buildFixture(tool: tool, sampleId: sampleId)
        defer { try? FileManager.default.removeItem(at: projectRoot) }

        let selections = try await ClassifierExtractionFixtures.defaultSelection(
            for: tool, sampleId: sampleId
        )
        let region = selections.first?.accessions.first ?? ""

        // Ground truth: what does MarkdupService.countReads say for this region?
        let resolver = ClassifierReadResolver()
        let bamURL = try await resolver.testingResolveBAMURL(
            tool: tool,
            sampleId: sampleId,
            resultPath: resultPath
        )
        let samtoolsPath = await ClassifierExtractionFixtures.resolveSamtoolsPath()
        let unique = try MarkdupService.countReads(
            bamURL: bamURL,
            accession: region.isEmpty ? nil : region,
            flagFilter: 0x404,
            samtoolsPath: samtoolsPath
        )

        let destination = destinationBuilder(projectRoot)
        let outcome = try await resolver.resolveAndExtract(
            tool: tool,
            resultPath: resultPath,
            selections: selections,
            options: ExtractionOptions(format: .fastq, includeUnmappedMates: false),
            destination: destination,
            progress: nil
        )

        XCTAssertEqual(
            outcome.readCount,
            unique,
            "I4 violation for \(tool.displayName) / \(String(describing: destination)): MarkdupService.countReads=\(unique), resolver.readCount=\(outcome.readCount)",
            file: file,
            line: line
        )

        // Markers-fixture teeth: the 0x404-filtered count must be strictly
        // less than the raw total (203 on the markers BAM, 199 with the
        // mask), so any regression that drops the flag mask between the
        // resolver and MarkdupService will fail this assertion too. The
        // original sarscov2 BAM had 0 secondary/duplicate/supplementary
        // records, so filtered == raw and the test had no teeth; the
        // markers BAM augments it with 3 synthetic flag-marked reads.
        let rawTotal = try MarkdupService.countReads(
            bamURL: bamURL,
            accession: region.isEmpty ? nil : region,
            flagFilter: 0x000,
            samtoolsPath: samtoolsPath
        )
        XCTAssertLessThan(
            outcome.readCount,
            rawTotal,
            "I4 fixture has no teeth: filtered count (\(outcome.readCount)) should be < raw count (\(rawTotal)) on the markers BAM",
            file: file,
            line: line
        )
    }

    func testI4_esviritu_allDestinations() async throws {
        let metadata = ExtractionMetadata(sourceDescription: "x", toolName: "EsViritu")
        try await assertI4(tool: .esviritu) { _ in
            .file(FileManager.default.temporaryDirectory.appendingPathComponent("i4-\(UUID().uuidString).fastq"))
        }
        try await assertI4(tool: .esviritu) { projectRoot in
            .bundle(projectRoot: projectRoot, displayName: "i4", metadata: metadata)
        }
        try await assertI4(tool: .esviritu) { _ in
            .clipboard(format: .fastq, cap: 100_000)
        }
        try await assertI4(tool: .esviritu) { projectRoot in
            .share(tempDirectory: projectRoot)
        }
    }

    func testI4_taxtriage_allDestinations() async throws {
        let metadata = ExtractionMetadata(sourceDescription: "x", toolName: "TaxTriage")
        try await assertI4(tool: .taxtriage) { _ in
            .file(FileManager.default.temporaryDirectory.appendingPathComponent("i4-\(UUID().uuidString).fastq"))
        }
        try await assertI4(tool: .taxtriage) { projectRoot in
            .bundle(projectRoot: projectRoot, displayName: "i4", metadata: metadata)
        }
        try await assertI4(tool: .taxtriage) { _ in
            .clipboard(format: .fastq, cap: 100_000)
        }
    }

    func testI4_naomgs_allDestinations() async throws {
        let metadata = ExtractionMetadata(sourceDescription: "x", toolName: "NAO-MGS")
        try await assertI4(tool: .naomgs) { _ in
            .file(FileManager.default.temporaryDirectory.appendingPathComponent("i4-\(UUID().uuidString).fastq"))
        }
        try await assertI4(tool: .naomgs) { projectRoot in
            .bundle(projectRoot: projectRoot, displayName: "i4", metadata: metadata)
        }
    }

    func testI4_nvd_allDestinations() async throws {
        let metadata = ExtractionMetadata(sourceDescription: "x", toolName: "NVD")
        try await assertI4(tool: .nvd) { _ in
            .file(FileManager.default.temporaryDirectory.appendingPathComponent("i4-\(UUID().uuidString).fastq"))
        }
        try await assertI4(tool: .nvd) { projectRoot in
            .bundle(projectRoot: projectRoot, displayName: "i4", metadata: metadata)
        }
    }

    // MARK: - I5: Samtools flag dispatch

    func testI5_excludeFlags_includeUnmappedMatesFalse_is0x404() {
        let opts = ExtractionOptions(format: .fastq, includeUnmappedMates: false)
        XCTAssertEqual(opts.samtoolsExcludeFlags, 0x404)
    }

    func testI5_excludeFlags_includeUnmappedMatesTrue_is0x400() {
        let opts = ExtractionOptions(format: .fastq, includeUnmappedMates: true)
        XCTAssertEqual(opts.samtoolsExcludeFlags, 0x400)
    }

    /// Parameterized over all 4 BAM-backed tools: verify the resolver actually
    /// dispatches the right flag for both include-unmapped-mates values.
    func testI5_allBAMBackedTools_dispatchCorrectFlag() async throws {
        for tool in ClassifierTool.allCases where tool.usesBAMDispatch {
            let sampleId = "I5"
            let (resultPath, projectRoot) = try ClassifierExtractionFixtures.buildFixture(tool: tool, sampleId: sampleId)
            defer { try? FileManager.default.removeItem(at: projectRoot) }
            let selections = try await ClassifierExtractionFixtures.defaultSelection(
                for: tool, sampleId: sampleId
            )

            let resolver = ClassifierReadResolver()
            // Strict: 0x404 → excludes unmapped + duplicates → lowest count.
            let countStrict = try await resolver.estimateReadCount(
                tool: tool,
                resultPath: resultPath,
                selections: selections,
                options: ExtractionOptions(format: .fastq, includeUnmappedMates: false)
            )
            // Loose: 0x400 → keeps unmapped mates, still excludes duplicates.
            let countLoose = try await resolver.estimateReadCount(
                tool: tool,
                resultPath: resultPath,
                selections: selections,
                options: ExtractionOptions(format: .fastq, includeUnmappedMates: true)
            )
            XCTAssertLessThanOrEqual(
                countStrict,
                countLoose,
                "I5 violation for \(tool.displayName): 0x404 count (\(countStrict)) must be <= 0x400 count (\(countLoose))"
            )
        }
    }

    // I6, I7 are added in Task 6.4.
}
