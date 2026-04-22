import XCTest
@testable import LungfishWorkflow

final class MappingProvenanceTests: XCTestCase {
    private var tempDir: URL!

    override func setUp() {
        super.setUp()
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("mapping-provenance-\(UUID().uuidString)", isDirectory: true)
        try! FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDir)
        super.tearDown()
    }

    func testSaveAndLoadRoundTripPreservesCommandsAndPaths() throws {
        let inputFASTQ = try writeFASTQ(
            name: "reads.fastq",
            header: "@A00488:385:HKGCLDRXX:1:1101:1000:1000 1:N:0:1",
            sequenceLength: 151
        )
        let referenceFASTA = try writeText(
            name: "reference.fa",
            contents: """
            >chr1
            ACGTACGTACGT
            """
        )
        let sourceBundle = tempDir.appendingPathComponent("source.lungfishref", isDirectory: true)
        let viewerBundle = tempDir.appendingPathComponent("viewer.lungfishref", isDirectory: true)
        try FileManager.default.createDirectory(at: sourceBundle, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: viewerBundle, withIntermediateDirectories: true)

        let request = MappingRunRequest(
            tool: .minimap2,
            modeID: MappingMode.minimap2MapONT.id,
            inputFASTQURLs: [inputFASTQ],
            referenceFASTAURL: referenceFASTA,
            sourceReferenceBundleURL: sourceBundle,
            outputDirectory: tempDir,
            sampleName: "sample",
            threads: 8,
            includeSecondary: false,
            includeSupplementary: false,
            minimumMappingQuality: 17,
            advancedArguments: ["--eqx"]
        )

        let result = MappingResult(
            mapper: .minimap2,
            modeID: request.modeID,
            sourceReferenceBundleURL: sourceBundle,
            viewerBundleURL: viewerBundle,
            bamURL: tempDir.appendingPathComponent("sample.sorted.bam"),
            baiURL: tempDir.appendingPathComponent("sample.sorted.bam.bai"),
            totalReads: 100,
            mappedReads: 91,
            unmappedReads: 9,
            wallClockSeconds: 12.5,
            contigs: []
        )

        let mapperCommand = try MappingProvenance.mapperInvocation(
            for: request,
            referenceLocator: ReferenceLocator(
                referenceURL: referenceFASTA,
                indexPrefixURL: tempDir.appendingPathComponent("index/reference-index")
            )
        )
        let normalizationInvocations = MappingProvenance.normalizationInvocations(
            rawAlignmentURL: tempDir.appendingPathComponent("sample.raw.sam"),
            outputDirectory: tempDir,
            sampleName: request.sampleName,
            threads: request.threads,
            minimumMappingQuality: request.minimumMappingQuality,
            includeSecondary: request.includeSecondary,
            includeSupplementary: request.includeSupplementary
        )

        let provenance = MappingProvenance.build(
            request: request,
            result: result,
            mapperInvocation: mapperCommand,
            normalizationInvocations: normalizationInvocations,
            mapperVersion: "2.0.0",
            samtoolsVersion: "1.21"
        )

        try provenance.save(to: tempDir)
        let loaded = try XCTUnwrap(MappingProvenance.load(from: tempDir))

        XCTAssertEqual(loaded.mapper, provenance.mapper)
        XCTAssertEqual(loaded.modeID, provenance.modeID)
        XCTAssertEqual(loaded.sampleName, provenance.sampleName)
        XCTAssertEqual(loaded.pairedEnd, provenance.pairedEnd)
        XCTAssertEqual(loaded.threads, provenance.threads)
        XCTAssertEqual(loaded.minimumMappingQuality, provenance.minimumMappingQuality)
        XCTAssertEqual(loaded.includeSecondary, provenance.includeSecondary)
        XCTAssertEqual(loaded.includeSupplementary, provenance.includeSupplementary)
        XCTAssertEqual(loaded.advancedArguments, provenance.advancedArguments)
        XCTAssertEqual(loaded.inputFASTQPaths, provenance.inputFASTQPaths)
        XCTAssertEqual(loaded.referenceFASTAPath, provenance.referenceFASTAPath)
        XCTAssertEqual(loaded.sourceReferenceBundlePath, provenance.sourceReferenceBundlePath)
        XCTAssertEqual(loaded.viewerBundlePath, provenance.viewerBundlePath)
        XCTAssertEqual(loaded.mapperVersion, provenance.mapperVersion)
        XCTAssertEqual(loaded.samtoolsVersion, provenance.samtoolsVersion)
        XCTAssertEqual(loaded.wallClockSeconds, provenance.wallClockSeconds, accuracy: 0.000_001)
        XCTAssertEqual(loaded.mapperInvocation, provenance.mapperInvocation)
        XCTAssertEqual(loaded.normalizationInvocations, provenance.normalizationInvocations)
        XCTAssertEqual(loaded.recordedAt.timeIntervalSince1970, provenance.recordedAt.timeIntervalSince1970, accuracy: 0.001)
        XCTAssertEqual(loaded.readClassHints, ["Illumina short reads"])
        XCTAssertEqual(loaded.mapperInvocation.label, "minimap2")
        XCTAssertEqual(loaded.commandInvocations.map(\.label), ["minimap2", "samtools view", "samtools sort", "samtools index", "samtools flagstat"])
        XCTAssertTrue(loaded.viewerBundlePath?.hasSuffix("viewer.lungfishref") ?? false)
        XCTAssertTrue(loaded.sourceReferenceBundlePath?.hasSuffix("source.lungfishref") ?? false)
    }

    func testLoadReturnsNilWhenSidecarMissing() {
        XCTAssertNil(MappingProvenance.load(from: tempDir))
    }

    func testNormalizationInvocationsCaptureFilteringAndSortThreads() {
        let invocations = MappingProvenance.normalizationInvocations(
            rawAlignmentURL: tempDir.appendingPathComponent("reads.sam"),
            outputDirectory: tempDir,
            sampleName: "sample",
            threads: 8,
            minimumMappingQuality: 17,
            includeSecondary: false,
            includeSupplementary: false
        )

        XCTAssertEqual(invocations.map(\.label), ["samtools view", "samtools sort", "samtools index", "samtools flagstat"])
        XCTAssertEqual(invocations[0].argv, [
            "samtools", "view", "-b", "-o", tempDir.appendingPathComponent("reads.filtered.bam").path,
            "-q", "17", "-F", "2304",
            tempDir.appendingPathComponent("reads.sam").path
        ])
        XCTAssertEqual(invocations[1].argv, [
            "samtools", "sort", "-@", "4", "-o", tempDir.appendingPathComponent("reads.sorted.bam").path,
            tempDir.appendingPathComponent("reads.filtered.bam").path
        ])
    }

    func testMapperInvocationUsesProvidedReferenceLocator() throws {
        let request = MappingRunRequest(
            tool: .bwaMem2,
            modeID: MappingMode.defaultShortRead.id,
            inputFASTQURLs: [tempDir.appendingPathComponent("reads.fastq")],
            referenceFASTAURL: tempDir.appendingPathComponent("reference.fa"),
            outputDirectory: tempDir,
            sampleName: "sample",
            pairedEnd: false,
            threads: 8
        )
        let locator = ReferenceLocator(
            referenceURL: tempDir.appendingPathComponent("reference.fa"),
            indexPrefixURL: tempDir.appendingPathComponent("custom-index/reference-index")
        )

        let invocation = try MappingProvenance.mapperInvocation(for: request, referenceLocator: locator)

        XCTAssertEqual(invocation.label, "BWA-MEM2")
        XCTAssertTrue(invocation.argv.contains(locator.indexPrefixURL.path))
        XCTAssertEqual(invocation.argv.first, "bwa-mem2")
    }

    private func writeFASTQ(name: String, header: String, sequenceLength: Int) throws -> URL {
        let url = tempDir.appendingPathComponent(name)
        let sequence = String(repeating: "A", count: sequenceLength)
        let quality = String(repeating: "I", count: sequenceLength)
        let text = "\(header)\n\(sequence)\n+\n\(quality)\n"
        try text.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    private func writeText(name: String, contents: String) throws -> URL {
        let url = tempDir.appendingPathComponent(name)
        try contents.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
}
