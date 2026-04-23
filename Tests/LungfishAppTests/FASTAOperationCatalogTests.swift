import XCTest
@testable import LungfishApp
@testable import LungfishCore
@testable import LungfishIO

@MainActor
final class FASTAOperationCatalogTests: XCTestCase {
    func testCatalogOnlyReturnsFASTACompatibleOperations() {
        let ids = Set(FASTAOperationCatalog.availableOperationKinds().map(\.rawValue))

        XCTAssertTrue(ids.contains(FASTQDerivativeOperationKind.searchMotif.rawValue))
        XCTAssertTrue(ids.contains(FASTQDerivativeOperationKind.orient.rawValue))
        XCTAssertTrue(ids.contains(FASTQDerivativeOperationKind.adapterTrim.rawValue))
        XCTAssertTrue(ids.contains(FASTQDerivativeOperationKind.primerRemoval.rawValue))
        XCTAssertTrue(ids.contains(FASTQDerivativeOperationKind.demultiplex.rawValue))
        XCTAssertTrue(ids.contains(FASTQDerivativeOperationKind.humanReadScrub.rawValue))
        XCTAssertFalse(ids.contains(FASTQDerivativeOperationKind.qualityTrim.rawValue))
    }

    func testDialogStateLimitsFASTACompatibleToolsToTheSelectedCategory() throws {
        let bundleURL = try FASTAOperationCatalog.createTemporaryInputBundle(
            fastaRecords: [">seq1\nAACCGGTT\n"],
            suggestedName: "seq1",
            projectURL: nil
        )
        let searchState = FASTQOperationDialogState(
            initialCategory: .searchSubsetting,
            selectedInputURLs: [bundleURL]
        )
        let mappingState = FASTQOperationDialogState(
            initialCategory: .mapping,
            selectedInputURLs: [bundleURL]
        )
        let classificationState = FASTQOperationDialogState(
            initialCategory: .classification,
            selectedInputURLs: [bundleURL]
        )

        XCTAssertTrue(searchState.isFASTAInputMode)
        XCTAssertEqual(
            Set(searchState.sidebarItems.map(\.id)),
            Set([
                FASTQOperationToolID.subsampleByProportion.rawValue,
                FASTQOperationToolID.subsampleByCount.rawValue,
                FASTQOperationToolID.extractReadsByID.rawValue,
                FASTQOperationToolID.extractReadsByMotif.rawValue,
                FASTQOperationToolID.selectReadsBySequence.rawValue,
            ])
        )
        XCTAssertEqual(
            Set(mappingState.sidebarItems.map(\.id)),
            Set([
                FASTQOperationToolID.minimap2.rawValue,
                FASTQOperationToolID.bwaMem2.rawValue,
                FASTQOperationToolID.bowtie2.rawValue,
                FASTQOperationToolID.bbmap.rawValue,
            ])
        )
        XCTAssertEqual(
            Set(classificationState.sidebarItems.map(\.id)),
            Set([
                FASTQOperationToolID.kraken2.rawValue,
                FASTQOperationToolID.esViritu.rawValue,
                FASTQOperationToolID.taxTriage.rawValue,
            ])
        )
        XCTAssertEqual(searchState.dialogTitle, "FASTQ/FASTA Operations")
    }

    func testDialogStateAllowsSelectingManagedFASTATools() throws {
        let bundleURL = try FASTAOperationCatalog.createTemporaryInputBundle(
            fastaRecords: [">seq1\nAACCGGTT\n"],
            suggestedName: "seq1",
            projectURL: nil
        )
        let state = FASTQOperationDialogState(
            initialCategory: .searchSubsetting,
            selectedInputURLs: [bundleURL]
        )

        state.selectTool(.adapterRemoval)
        XCTAssertEqual(state.selectedToolID, .adapterRemoval)

        state.selectTool(.minimap2)
        XCTAssertEqual(state.selectedToolID, .minimap2)

        state.selectTool(.spades)
        XCTAssertEqual(state.selectedToolID, .spades)

        state.selectTool(.kraken2)
        XCTAssertEqual(state.selectedToolID, .kraken2)
    }

    func testInputSequenceFormatResolvesReferenceBundleAsFASTA() throws {
        let bundleURL = try makeReferenceBundle(
            named: "lungfish-reference",
            fastaFilename: "genome/sequence.fa.gz"
        )

        XCTAssertEqual(FASTAOperationCatalog.inputSequenceFormat(for: bundleURL), .fasta)
    }

    private func makeReferenceBundle(
        named bundleName: String,
        fastaFilename: String
    ) throws -> URL {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(
            "fasta-operation-catalog-\(UUID().uuidString)",
            isDirectory: true
        )
        let bundleURL = root.appendingPathComponent("\(bundleName).lungfishref", isDirectory: true)
        try FileManager.default.createDirectory(at: bundleURL, withIntermediateDirectories: true)

        let fastaURL = bundleURL.appendingPathComponent(fastaFilename)
        try FileManager.default.createDirectory(
            at: fastaURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try ">contig1\nAACCGGTT\n".write(to: fastaURL, atomically: true, encoding: .utf8)
        try "contig1\t8\t9\t8\t9\n".write(
            to: bundleURL.appendingPathComponent("\(fastaFilename).fai"),
            atomically: true,
            encoding: .utf8
        )

        let manifest = BundleManifest(
            name: bundleName,
            identifier: "org.lungfish.\(bundleName)",
            source: SourceInfo(organism: "Test organism", assembly: "Test assembly"),
            genome: GenomeInfo(
                path: fastaFilename,
                indexPath: "\(fastaFilename).fai",
                totalLength: 8,
                chromosomes: []
            )
        )
        try manifest.save(to: bundleURL)
        addTeardownBlock {
            try? FileManager.default.removeItem(at: root)
        }
        return bundleURL
    }
}
