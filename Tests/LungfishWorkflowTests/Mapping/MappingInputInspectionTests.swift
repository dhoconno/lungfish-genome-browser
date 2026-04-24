import XCTest
@testable import LungfishIO
@testable import LungfishCore
@testable import LungfishWorkflow

final class MappingInputInspectionTests: XCTestCase {

    func testInspectDetectsReadClassAndObservedMaxReadLength() throws {
        let fixture = try MappingFASTQFixture()
        defer { fixture.cleanup() }

        let illuminaFASTQ = try fixture.writeFASTQ(
            name: "illumina.fastq",
            header: "@A00488:385:HKGCLDRXX:1:1101:1000:1000 1:N:0:1",
            sequenceLength: 151
        )

        let inspection = MappingInputInspection.inspect(urls: [illuminaFASTQ])

        XCTAssertEqual(inspection.readClass, .illuminaShortReads)
        XCTAssertEqual(inspection.observedMaxReadLength, 151)
        XCTAssertFalse(inspection.mixedReadClasses)
    }

    func testInspectFlagsMixedReadClasses() throws {
        let fixture = try MappingFASTQFixture()
        defer { fixture.cleanup() }

        let illuminaFASTQ = try fixture.writeFASTQ(
            name: "illumina.fastq",
            header: "@A00488:385:HKGCLDRXX:1:1101:1000:1000 1:N:0:1",
            sequenceLength: 151
        )
        let ontFASTQ = try fixture.writeFASTQ(
            name: "ont.fastq",
            header: "@0d4c6f0e-1234-5678-9abc-def012345678 runid=test flow_cell_id=FLO-MIN106 start_time=2026-04-19T00:00:00Z",
            sequenceLength: 1_200
        )

        let inspection = MappingInputInspection.inspect(urls: [illuminaFASTQ, ontFASTQ])

        XCTAssertNil(inspection.readClass)
        XCTAssertEqual(inspection.observedMaxReadLength, 1_200)
        XCTAssertTrue(inspection.mixedReadClasses)
    }

    func testInspectResolvesLungfishFASTQBundleInputs() throws {
        let fixture = try MappingFASTQFixture()
        defer { fixture.cleanup() }

        let illuminaFASTQ = try fixture.writeFASTQ(
            name: "illumina.fastq",
            header: "@A00488:385:HKGCLDRXX:1:1101:1000:1000 1:N:0:1",
            sequenceLength: 151
        )
        let bundleURL = try fixture.wrapInBundle(
            fastqURL: illuminaFASTQ,
            bundleName: "illumina"
        )

        let inspection = MappingInputInspection.inspect(urls: [bundleURL])

        XCTAssertEqual(inspection.readClass, .illuminaShortReads)
        XCTAssertEqual(inspection.observedMaxReadLength, 151)
        XCTAssertFalse(inspection.mixedReadClasses)
    }

    func testInspectUsesPersistedAssemblyReadTypeWhenFASTQHeaderIsGeneric() throws {
        let fixture = try MappingFASTQFixture()
        defer { fixture.cleanup() }

        let genericFASTQ = try fixture.writeFASTQ(
            name: "generic.fastq",
            header: "@2891_MCP53H_1",
            sequenceLength: 1_200
        )
        let bundleURL = try fixture.wrapInBundle(
            fastqURL: genericFASTQ,
            bundleName: "generic-ont"
        )
        let primaryFASTQURL = try XCTUnwrap(FASTQBundle.resolvePrimaryFASTQURL(for: bundleURL))
        FASTQMetadataStore.save(
            PersistedFASTQMetadata(assemblyReadType: .ontReads),
            for: primaryFASTQURL
        )

        let inspection = MappingInputInspection.inspect(urls: [bundleURL])

        XCTAssertEqual(inspection.readClass, .ontReads)
        XCTAssertEqual(inspection.observedMaxReadLength, 1_200)
        XCTAssertFalse(inspection.mixedReadClasses)
    }

    func testInspectFallsBackToPersistedSequencingPlatformWhenFASTQHeaderIsGeneric() throws {
        let fixture = try MappingFASTQFixture()
        defer { fixture.cleanup() }

        let genericFASTQ = try fixture.writeFASTQ(
            name: "generic.fastq",
            header: "@2891_MCP53H_1",
            sequenceLength: 1_200
        )
        let bundleURL = try fixture.wrapInBundle(
            fastqURL: genericFASTQ,
            bundleName: "generic-ont-platform"
        )
        let primaryFASTQURL = try XCTUnwrap(FASTQBundle.resolvePrimaryFASTQURL(for: bundleURL))
        FASTQMetadataStore.save(
            PersistedFASTQMetadata(sequencingPlatform: .oxfordNanopore),
            for: primaryFASTQURL
        )

        let inspection = MappingInputInspection.inspect(urls: [bundleURL])

        XCTAssertEqual(inspection.readClass, .ontReads)
        XCTAssertFalse(inspection.mixedReadClasses)
    }

    func testInspectFlagsMixedDetectedAndUnclassifiedFASTQInputs() throws {
        let fixture = try MappingFASTQFixture()
        defer { fixture.cleanup() }

        let knownFASTQ = try fixture.writeFASTQ(
            name: "known.fastq",
            header: "@2891_MCP53H_1",
            sequenceLength: 1_200
        )
        let unknownFASTQ = try fixture.writeFASTQ(
            name: "unknown.fastq",
            header: "@2891_MCP53H_2",
            sequenceLength: 1_100
        )
        let knownBundleURL = try fixture.wrapInBundle(
            fastqURL: knownFASTQ,
            bundleName: "known-ont"
        )
        let unknownBundleURL = try fixture.wrapInBundle(
            fastqURL: unknownFASTQ,
            bundleName: "unknown"
        )
        let knownPrimaryURL = try XCTUnwrap(FASTQBundle.resolvePrimaryFASTQURL(for: knownBundleURL))
        FASTQMetadataStore.save(
            PersistedFASTQMetadata(assemblyReadType: .ontReads),
            for: knownPrimaryURL
        )

        let inspection = MappingInputInspection.inspect(urls: [knownBundleURL, unknownBundleURL])

        XCTAssertEqual(inspection.readClass, .ontReads)
        XCTAssertFalse(inspection.mixedReadClasses)
        XCTAssertTrue(inspection.hasUnclassifiedFASTQInputs)
        XCTAssertTrue(inspection.mixesDetectedAndUnclassifiedReadClasses)
    }

    func testInspectUsesCachedMaxReadLengthWhenFASTQPrefixIsShort() throws {
        let fixture = try MappingFASTQFixture()
        defer { fixture.cleanup() }

        let fastqURL = try fixture.writeFASTQ(
            name: "long-reads.fastq",
            header: "@2891_MCP53H_1",
            sequenceLength: 80
        )
        let bundleURL = try fixture.wrapInBundle(
            fastqURL: fastqURL,
            bundleName: "long-reads"
        )
        let primaryFASTQURL = try XCTUnwrap(FASTQBundle.resolvePrimaryFASTQURL(for: bundleURL))
        FASTQMetadataStore.save(
            PersistedFASTQMetadata(
                computedStatistics: FASTQDatasetStatistics(
                    readCount: 12,
                    baseCount: 60_000,
                    meanReadLength: 5_000,
                    minReadLength: 500,
                    maxReadLength: 10_363,
                    medianReadLength: 4_800,
                    n50ReadLength: 6_000,
                    meanQuality: 18,
                    q20Percentage: 40,
                    q30Percentage: 15,
                    gcContent: 0.45,
                    readLengthHistogram: [:],
                    qualityScoreHistogram: [:],
                    perPositionQuality: []
                )
            ),
            for: primaryFASTQURL
        )

        let inspection = MappingInputInspection.inspect(urls: [bundleURL])

        XCTAssertEqual(inspection.observedMaxReadLength, 10_363)
    }

    func testInspectObservesReadLengthFromFASTAInputs() throws {
        let fixture = try MappingFASTQFixture()
        defer { fixture.cleanup() }

        let fastaURL = try fixture.writeFASTA(
            name: "contigs.fasta",
            identifier: "contig-1",
            sequenceLength: 1_200
        )

        let inspection = MappingInputInspection.inspect(urls: [fastaURL])

        XCTAssertNil(inspection.readClass)
        XCTAssertEqual(inspection.observedMaxReadLength, 1_200)
        XCTAssertFalse(inspection.mixedReadClasses)
    }

    func testInspectResolvesReferenceBundleInputsAsFASTA() throws {
        let fixture = try MappingFASTQFixture()
        defer { fixture.cleanup() }

        let bundleURL = try fixture.writeReferenceBundle(
            bundleName: "reference-input",
            fastaRelativePath: "genome/sequence.fa.gz",
            sequenceLength: 1_200
        )

        let inspection = MappingInputInspection.inspect(urls: [bundleURL])

        XCTAssertNil(inspection.readClass)
        XCTAssertEqual(inspection.sequenceFormat, .fasta)
        XCTAssertEqual(inspection.observedMaxReadLength, 1_200)
        XCTAssertFalse(inspection.mixedReadClasses)
        XCTAssertFalse(inspection.mixedSequenceFormats)
    }
}

private struct MappingFASTQFixture {
    let root: URL

    init() throws {
        root = FileManager.default.temporaryDirectory.appendingPathComponent(
            "mapping-fastq-fixture-\(UUID().uuidString)",
            isDirectory: true
        )
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
    }

    func cleanup() {
        try? FileManager.default.removeItem(at: root)
    }

    func writeFASTQ(name: String, header: String, sequenceLength: Int) throws -> URL {
        let url = root.appendingPathComponent(name)
        let sequence = String(repeating: "A", count: sequenceLength)
        let quality = String(repeating: "I", count: sequenceLength)
        let text = "\(header)\n\(sequence)\n+\n\(quality)\n"
        try text.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    func writeFASTA(name: String, identifier: String, sequenceLength: Int) throws -> URL {
        let url = root.appendingPathComponent(name)
        let sequence = String(repeating: "A", count: sequenceLength)
        let text = ">\(identifier)\n\(sequence)\n"
        try text.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    func wrapInBundle(fastqURL: URL, bundleName: String) throws -> URL {
        let bundleURL = root.appendingPathComponent("\(bundleName).lungfishfastq", isDirectory: true)
        try FileManager.default.createDirectory(at: bundleURL, withIntermediateDirectories: true)
        try FileManager.default.copyItem(
            at: fastqURL,
            to: bundleURL.appendingPathComponent(fastqURL.lastPathComponent)
        )
        return bundleURL
    }

    func writeReferenceBundle(
        bundleName: String,
        fastaRelativePath: String,
        sequenceLength: Int
    ) throws -> URL {
        let bundleURL = root.appendingPathComponent("\(bundleName).lungfishref", isDirectory: true)
        try FileManager.default.createDirectory(at: bundleURL, withIntermediateDirectories: true)

        let fastaURL = bundleURL.appendingPathComponent(fastaRelativePath)
        try FileManager.default.createDirectory(
            at: fastaURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        let sequence = String(repeating: "A", count: sequenceLength)
        try ">contig1\n\(sequence)\n".write(to: fastaURL, atomically: true, encoding: .utf8)
        try "contig1\t\(sequenceLength)\t9\t\(sequenceLength)\t\(sequenceLength + 1)\n".write(
            to: bundleURL.appendingPathComponent("\(fastaRelativePath).fai"),
            atomically: true,
            encoding: .utf8
        )

        let manifest = BundleManifest(
            name: bundleName,
            identifier: "org.lungfish.\(bundleName)",
            source: SourceInfo(organism: "Test organism", assembly: "Test assembly"),
            genome: GenomeInfo(
                path: fastaRelativePath,
                indexPath: "\(fastaRelativePath).fai",
                totalLength: Int64(sequenceLength),
                chromosomes: []
            )
        )
        try manifest.save(to: bundleURL)
        return bundleURL
    }
}
