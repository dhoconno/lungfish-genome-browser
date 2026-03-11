import XCTest
@testable import LungfishIO

final class FASTQDerivativesTests: XCTestCase {

    private func makeTempBundle() throws -> (tempDir: URL, bundleURL: URL) {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("FASTQDerivativesTests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        let bundleURL = tempDir.appendingPathComponent("example.\(FASTQBundle.directoryExtension)", isDirectory: true)
        try FileManager.default.createDirectory(at: bundleURL, withIntermediateDirectories: true)
        return (tempDir, bundleURL)
    }

    // MARK: - Subset Manifest Round-Trip

    func testSubsetManifestRoundTrip() throws {
        let (tempDir, bundleURL) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let op = FASTQDerivativeOperation(kind: .subsampleCount, count: 1000)
        let manifest = FASTQDerivedBundleManifest(
            name: "example-derivative",
            parentBundleRelativePath: "../example.lungfishfastq",
            rootBundleRelativePath: "../example.lungfishfastq",
            rootFASTQFilename: "example.fastq.gz",
            payload: .subset(readIDListFilename: "read-ids.txt"),
            lineage: [op],
            operation: op,
            cachedStatistics: .empty,
            pairingMode: .interleaved
        )

        try FASTQBundle.saveDerivedManifest(manifest, in: bundleURL)
        let loaded = FASTQBundle.loadDerivedManifest(in: bundleURL)

        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.name, manifest.name)
        XCTAssertEqual(loaded?.operation.kind, .subsampleCount)
        XCTAssertEqual(loaded?.operation.count, 1000)
        XCTAssertEqual(loaded?.lineage.count, 1)
        if case .subset(let filename) = loaded?.payload {
            XCTAssertEqual(filename, "read-ids.txt")
        } else {
            XCTFail("Expected subset payload")
        }
        XCTAssertTrue(FASTQBundle.isDerivedBundle(bundleURL))
    }

    // MARK: - Trim Manifest Round-Trip

    func testTrimManifestRoundTrip() throws {
        let (tempDir, bundleURL) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let op = FASTQDerivativeOperation(
            kind: .qualityTrim,
            qualityThreshold: 20,
            windowSize: 4,
            qualityTrimMode: .cutRight,
            toolUsed: "fastp",
            toolCommand: "fastp -i input.fq -o output.fq --cut_right -W 4 -M 20"
        )
        let manifest = FASTQDerivedBundleManifest(
            name: "example-qtrim",
            parentBundleRelativePath: "../example.lungfishfastq",
            rootBundleRelativePath: "../example.lungfishfastq",
            rootFASTQFilename: "example.fastq.gz",
            payload: .trim(trimPositionFilename: "trim-positions.tsv"),
            lineage: [op],
            operation: op,
            cachedStatistics: .empty,
            pairingMode: .singleEnd
        )

        try FASTQBundle.saveDerivedManifest(manifest, in: bundleURL)
        let loaded = FASTQBundle.loadDerivedManifest(in: bundleURL)

        XCTAssertNotNil(loaded)
        if case .trim(let filename) = loaded?.payload {
            XCTAssertEqual(filename, "trim-positions.tsv")
        } else {
            XCTFail("Expected trim payload")
        }
        XCTAssertEqual(loaded?.operation.kind, .qualityTrim)
        XCTAssertEqual(loaded?.operation.qualityThreshold, 20)
        XCTAssertEqual(loaded?.operation.windowSize, 4)
        XCTAssertEqual(loaded?.operation.qualityTrimMode, .cutRight)
        XCTAssertEqual(loaded?.operation.toolUsed, "fastp")
        XCTAssertNotNil(loaded?.operation.toolCommand)
    }

    // MARK: - Operation Labels

    func testOperationSummaryFormatting() {
        let op = FASTQDerivativeOperation(
            kind: .lengthFilter,
            minLength: 100,
            maxLength: 200
        )
        XCTAssertTrue(op.shortLabel.contains("len-"))
        XCTAssertTrue(op.displaySummary.contains("Length filter"))
    }

    func testQualityTrimLabels() {
        let op = FASTQDerivativeOperation(
            kind: .qualityTrim,
            qualityThreshold: 25,
            windowSize: 5,
            qualityTrimMode: .cutBoth
        )
        XCTAssertEqual(op.shortLabel, "qtrim-Q25")
        XCTAssertTrue(op.displaySummary.contains("Quality trim Q25 w5"))
        XCTAssertTrue(op.displaySummary.contains("cutBoth"))
    }

    func testAdapterTrimLabels() {
        let autoOp = FASTQDerivativeOperation(kind: .adapterTrim, adapterMode: .autoDetect)
        XCTAssertEqual(autoOp.shortLabel, "adapter-trim")
        XCTAssertTrue(autoOp.displaySummary.contains("auto-detect"))

        let specifiedOp = FASTQDerivativeOperation(
            kind: .adapterTrim,
            adapterMode: .specified,
            adapterSequence: "AGATCGGAAGAGC"
        )
        XCTAssertTrue(specifiedOp.displaySummary.contains("AGATCGGAAGAGC"))
    }

    func testFixedTrimLabels() {
        let op = FASTQDerivativeOperation(kind: .fixedTrim, trimFrom5Prime: 10, trimFrom3Prime: 5)
        XCTAssertEqual(op.shortLabel, "trim-10-5")
        XCTAssertTrue(op.displaySummary.contains("5': 10 bp"))
        XCTAssertTrue(op.displaySummary.contains("3': 5 bp"))
    }

    func testDefaultLabelFallbacks() {
        // Operations with nil optional params should still produce labels
        let subsampleOp = FASTQDerivativeOperation(kind: .subsampleProportion)
        XCTAssertEqual(subsampleOp.shortLabel, "subsample-proportion")
        XCTAssertEqual(subsampleOp.displaySummary, "Subsample by proportion")

        let countOp = FASTQDerivativeOperation(kind: .subsampleCount)
        XCTAssertEqual(countOp.shortLabel, "subsample-count")

        let searchOp = FASTQDerivativeOperation(kind: .searchText)
        XCTAssertTrue(searchOp.displaySummary.contains("Search"))
    }

    // MARK: - Operation Category

    func testSubsetOperationKinds() {
        XCTAssertTrue(FASTQDerivativeOperationKind.subsampleProportion.isSubsetOperation)
        XCTAssertTrue(FASTQDerivativeOperationKind.subsampleCount.isSubsetOperation)
        XCTAssertTrue(FASTQDerivativeOperationKind.lengthFilter.isSubsetOperation)
        XCTAssertTrue(FASTQDerivativeOperationKind.searchText.isSubsetOperation)
        XCTAssertTrue(FASTQDerivativeOperationKind.searchMotif.isSubsetOperation)
        XCTAssertTrue(FASTQDerivativeOperationKind.deduplicate.isSubsetOperation)
    }

    func testTrimOperationKinds() {
        XCTAssertFalse(FASTQDerivativeOperationKind.qualityTrim.isSubsetOperation)
        XCTAssertFalse(FASTQDerivativeOperationKind.adapterTrim.isSubsetOperation)
        XCTAssertFalse(FASTQDerivativeOperationKind.fixedTrim.isSubsetOperation)
    }

    func testBBToolsOperationKinds() {
        // Contaminant filter is a subset operation (removes reads)
        XCTAssertTrue(FASTQDerivativeOperationKind.contaminantFilter.isSubsetOperation)
        XCTAssertFalse(FASTQDerivativeOperationKind.contaminantFilter.isFullOperation)

        // PE merge and repair are full operations (produce new content)
        XCTAssertFalse(FASTQDerivativeOperationKind.pairedEndMerge.isSubsetOperation)
        XCTAssertTrue(FASTQDerivativeOperationKind.pairedEndMerge.isFullOperation)

        XCTAssertFalse(FASTQDerivativeOperationKind.pairedEndRepair.isSubsetOperation)
        XCTAssertTrue(FASTQDerivativeOperationKind.pairedEndRepair.isFullOperation)
    }

    func testContaminantFilterLabels() {
        let phixOp = FASTQDerivativeOperation(
            kind: .contaminantFilter,
            contaminantFilterMode: .phix,
            contaminantKmerSize: 31,
            contaminantHammingDistance: 1
        )
        XCTAssertEqual(phixOp.shortLabel, "contaminant-phix")
        XCTAssertTrue(phixOp.displaySummary.contains("PhiX"))

        let customOp = FASTQDerivativeOperation(
            kind: .contaminantFilter,
            contaminantFilterMode: .custom,
            contaminantReferenceFasta: "contaminants.fa",
            contaminantKmerSize: 27,
            contaminantHammingDistance: 2
        )
        XCTAssertEqual(customOp.shortLabel, "contaminant-custom")
        XCTAssertTrue(customOp.displaySummary.contains("contaminants.fa"))
    }

    func testPairedEndMergeLabels() {
        let op = FASTQDerivativeOperation(
            kind: .pairedEndMerge,
            mergeStrictness: .strict,
            mergeMinOverlap: 15
        )
        XCTAssertEqual(op.shortLabel, "merge-strict")
        XCTAssertTrue(op.displaySummary.contains("strict"))
        XCTAssertTrue(op.displaySummary.contains("15"))
    }

    func testPairedEndRepairLabels() {
        let op = FASTQDerivativeOperation(kind: .pairedEndRepair)
        XCTAssertEqual(op.shortLabel, "repair")
        XCTAssertTrue(op.displaySummary.contains("repair"))
    }

    func testFullPayloadRoundTrip() throws {
        let (tempDir, bundleURL) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let op = FASTQDerivativeOperation(
            kind: .pairedEndMerge,
            mergeStrictness: .normal,
            mergeMinOverlap: 12,
            toolUsed: "bbmerge",
            toolCommand: "bbmerge.sh in=reads.fq out=merged.fq outu=unmerged.fq minoverlap=12"
        )
        let manifest = FASTQDerivedBundleManifest(
            name: "merged-reads",
            parentBundleRelativePath: "../example.lungfishfastq",
            rootBundleRelativePath: "../example.lungfishfastq",
            rootFASTQFilename: "example.fastq.gz",
            payload: .full(fastqFilename: "reads.fastq"),
            lineage: [op],
            operation: op,
            cachedStatistics: .empty,
            pairingMode: .interleaved
        )

        try FASTQBundle.saveDerivedManifest(manifest, in: bundleURL)
        let loaded = FASTQBundle.loadDerivedManifest(in: bundleURL)

        XCTAssertNotNil(loaded)
        if case .full(let filename) = loaded?.payload {
            XCTAssertEqual(filename, "reads.fastq")
        } else {
            XCTFail("Expected full payload")
        }
        XCTAssertEqual(loaded?.operation.kind, .pairedEndMerge)
        XCTAssertEqual(loaded?.operation.mergeStrictness, .normal)
        XCTAssertEqual(loaded?.operation.mergeMinOverlap, 12)
        XCTAssertEqual(loaded?.operation.toolUsed, "bbmerge")

        // Verify bundle helper resolves full payload
        XCTAssertNotNil(FASTQBundle.fullPayloadFASTQURL(forDerivedBundle: bundleURL))
        XCTAssertNil(FASTQBundle.readIDListURL(forDerivedBundle: bundleURL))
        XCTAssertNil(FASTQBundle.trimPositionsURL(forDerivedBundle: bundleURL))
    }

    // MARK: - Trim Position File I/O

    func testTrimPositionFileRoundTrip() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("TrimPosTest-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let records: [FASTQTrimRecord] = [
            FASTQTrimRecord(readID: "SRR001.1", trimStart: 0, trimEnd: 148),
            FASTQTrimRecord(readID: "SRR001.2", trimStart: 5, trimEnd: 142),
            FASTQTrimRecord(readID: "SRR001.3", trimStart: 12, trimEnd: 150),
        ]

        let url = tempDir.appendingPathComponent("trim-positions.tsv")
        try FASTQTrimPositionFile.write(records, to: url)

        let loaded = try FASTQTrimPositionFile.load(from: url)
        XCTAssertEqual(loaded.count, 3)
        XCTAssertEqual(loaded["SRR001.1"]?.start, 0)
        XCTAssertEqual(loaded["SRR001.1"]?.end, 148)
        XCTAssertEqual(loaded["SRR001.2"]?.start, 5)
        XCTAssertEqual(loaded["SRR001.2"]?.end, 142)
        XCTAssertEqual(loaded["SRR001.3"]?.start, 12)
        XCTAssertEqual(loaded["SRR001.3"]?.end, 150)

        let orderedRecords = try FASTQTrimPositionFile.loadRecords(from: url)
        XCTAssertEqual(orderedRecords.count, 3)
        XCTAssertEqual(orderedRecords[0].readID, "SRR001.1")
        XCTAssertEqual(orderedRecords[1].trimmedLength, 137)
    }

    func testTrimPositionFileMalformedLinesSkipped() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("TrimPosMalformed-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let content = """
        read1\t0\t100
        malformed_line
        read2\tabc\t100
        read3\t5
        read4\t10\t90
        """
        let url = tempDir.appendingPathComponent("trim-positions.tsv")
        try content.write(to: url, atomically: true, encoding: .utf8)

        let loaded = try FASTQTrimPositionFile.load(from: url)
        XCTAssertEqual(loaded.count, 2) // Only read1 and read4 are valid
        XCTAssertEqual(loaded["read1"]?.start, 0)
        XCTAssertEqual(loaded["read4"]?.start, 10)
    }

    func testTrimPositionFileEmptyFile() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("TrimPosEmpty-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let url = tempDir.appendingPathComponent("trim-positions.tsv")
        try "".write(to: url, atomically: true, encoding: .utf8)

        let loaded = try FASTQTrimPositionFile.load(from: url)
        XCTAssertTrue(loaded.isEmpty)
    }

    func testTrimRecordLength() {
        let record = FASTQTrimRecord(readID: "test", trimStart: 5, trimEnd: 100)
        XCTAssertEqual(record.trimmedLength, 95)

        let empty = FASTQTrimRecord(readID: "test", trimStart: 100, trimEnd: 50)
        XCTAssertEqual(empty.trimmedLength, 0)
    }

    // MARK: - Trim Position Composition

    func testTrimCompositionBasic() {
        let parent: [String: (start: Int, end: Int)] = [
            "read1": (5, 142),
            "read2": (0, 150),
            "read3": (10, 100),
        ]
        let child: [String: (start: Int, end: Int)] = [
            "read1": (10, 130),   // relative to parent's [5,142) = absolute [15, 135)
            "read2": (0, 100),    // relative to parent's [0,150) = absolute [0, 100)
            // read3 absent from child = not in result
        ]

        let result = FASTQTrimPositionFile.compose(parent: parent, child: child)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result["read1"]?.start, 15)
        XCTAssertEqual(result["read1"]?.end, 135)
        XCTAssertEqual(result["read2"]?.start, 0)
        XCTAssertEqual(result["read2"]?.end, 100)
    }

    func testTrimCompositionClampsToParentEnd() {
        let parent: [String: (start: Int, end: Int)] = [
            "read1": (5, 50),
        ]
        let child: [String: (start: Int, end: Int)] = [
            "read1": (0, 100),
        ]

        let result = FASTQTrimPositionFile.compose(parent: parent, child: child)
        XCTAssertEqual(result["read1"]?.start, 5)
        XCTAssertEqual(result["read1"]?.end, 50)
    }

    func testTrimCompositionDropsEmptyRanges() {
        let parent: [String: (start: Int, end: Int)] = [
            "read1": (10, 20),
        ]
        let child: [String: (start: Int, end: Int)] = [
            "read1": (15, 20),
        ]

        let result = FASTQTrimPositionFile.compose(parent: parent, child: child)
        XCTAssertTrue(result.isEmpty)
    }

    func testTrimCompositionEmptyInputs() {
        let empty: [String: (start: Int, end: Int)] = [:]
        let nonEmpty: [String: (start: Int, end: Int)] = ["read1": (0, 100)]

        XCTAssertTrue(FASTQTrimPositionFile.compose(parent: empty, child: nonEmpty).isEmpty)
        XCTAssertTrue(FASTQTrimPositionFile.compose(parent: nonEmpty, child: empty).isEmpty)
        XCTAssertTrue(FASTQTrimPositionFile.compose(parent: empty, child: empty).isEmpty)
    }

    // MARK: - Bundle Helpers

    func testBundleTrimPositionsURL() throws {
        let (tempDir, bundleURL) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let op = FASTQDerivativeOperation(kind: .qualityTrim, qualityThreshold: 20)
        let manifest = FASTQDerivedBundleManifest(
            name: "trim-test",
            parentBundleRelativePath: "../parent.lungfishfastq",
            rootBundleRelativePath: "../parent.lungfishfastq",
            rootFASTQFilename: "reads.fastq.gz",
            payload: .trim(trimPositionFilename: "trim-positions.tsv"),
            lineage: [op],
            operation: op,
            cachedStatistics: .empty,
            pairingMode: nil
        )

        try FASTQBundle.saveDerivedManifest(manifest, in: bundleURL)

        XCTAssertNil(FASTQBundle.readIDListURL(forDerivedBundle: bundleURL))
        XCTAssertNotNil(FASTQBundle.trimPositionsURL(forDerivedBundle: bundleURL))
        XCTAssertEqual(
            FASTQBundle.trimPositionsURL(forDerivedBundle: bundleURL)?.lastPathComponent,
            "trim-positions.tsv"
        )
    }

    // MARK: - Trim with Record.trimmed()

    func testRecordTrimmedAppliesPositions() {
        let record = FASTQRecord(
            identifier: "read1",
            description: nil,
            sequence: "ACGTACGTACGT",
            quality: QualityScore(values: Array(repeating: UInt8(30), count: 12), encoding: .phred33)
        )

        // Trim from position 2 to 10
        let trimmed = record.trimmed(from: 2, to: 10)
        XCTAssertEqual(trimmed.sequence, "GTACGTAC")
        XCTAssertEqual(trimmed.length, 8)
        XCTAssertEqual(trimmed.identifier, "read1")
    }

    func testRecordTrimmedClampsToLength() {
        let record = FASTQRecord(
            identifier: "read1",
            description: nil,
            sequence: "ACGT",
            quality: QualityScore(values: [30, 30, 30, 30], encoding: .phred33)
        )

        let trimmed = record.trimmed(from: 0, to: 100)
        XCTAssertEqual(trimmed.sequence, "ACGT")
        XCTAssertEqual(trimmed.length, 4)
    }

    // MARK: - Phase 8: Primer Removal, Error Correction, Interleave Labels

    func testPrimerRemovalLabels() {
        let literalOp = FASTQDerivativeOperation(
            kind: .primerRemoval,
            primerSource: .literal,
            primerLiteralSequence: "AGATCGGAAGAGC",
            primerKmerSize: 23,
            primerMinKmer: 11,
            primerHammingDistance: 1
        )
        XCTAssertEqual(literalOp.shortLabel, "primer-literal-k23")
        XCTAssertTrue(literalOp.displaySummary.contains("AGATCGGAAGAGC"))
        XCTAssertTrue(literalOp.displaySummary.contains("literal"))

        let refOp = FASTQDerivativeOperation(
            kind: .primerRemoval,
            primerSource: .reference,
            primerReferenceFasta: "primers.fa",
            primerKmerSize: 27
        )
        XCTAssertEqual(refOp.shortLabel, "primer-reference-k27")
        XCTAssertTrue(refOp.displaySummary.contains("primers.fa"))
    }

    func testErrorCorrectionLabels() {
        let op = FASTQDerivativeOperation(kind: .errorCorrection, errorCorrectionKmerSize: 50)
        XCTAssertEqual(op.shortLabel, "ecc-k50")
        XCTAssertTrue(op.displaySummary.contains("Error correction"))
        XCTAssertTrue(op.displaySummary.contains("k=50"))

        let customOp = FASTQDerivativeOperation(kind: .errorCorrection, errorCorrectionKmerSize: 31)
        XCTAssertEqual(customOp.shortLabel, "ecc-k31")
    }

    func testInterleaveReformatLabels() {
        let interleaveOp = FASTQDerivativeOperation(kind: .interleaveReformat, interleaveDirection: .interleave)
        XCTAssertEqual(interleaveOp.shortLabel, "interleave")
        XCTAssertTrue(interleaveOp.displaySummary.contains("Interleave R1/R2"))

        let deinterleaveOp = FASTQDerivativeOperation(kind: .interleaveReformat, interleaveDirection: .deinterleave)
        XCTAssertEqual(deinterleaveOp.shortLabel, "deinterleave")
        XCTAssertTrue(deinterleaveOp.displaySummary.contains("Deinterleave"))
    }

    func testPhase8OperationCategories() {
        // Primer removal: full operation, not subset
        XCTAssertFalse(FASTQDerivativeOperationKind.primerRemoval.isSubsetOperation)
        XCTAssertTrue(FASTQDerivativeOperationKind.primerRemoval.isFullOperation)

        // Error correction: full operation, not subset
        XCTAssertFalse(FASTQDerivativeOperationKind.errorCorrection.isSubsetOperation)
        XCTAssertTrue(FASTQDerivativeOperationKind.errorCorrection.isFullOperation)

        // Interleave reformat: full operation, not subset
        XCTAssertFalse(FASTQDerivativeOperationKind.interleaveReformat.isSubsetOperation)
        XCTAssertTrue(FASTQDerivativeOperationKind.interleaveReformat.isFullOperation)
    }

    func testFullPairedPayloadRoundTrip() throws {
        let (tempDir, bundleURL) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let op = FASTQDerivativeOperation(
            kind: .interleaveReformat,
            interleaveDirection: .deinterleave,
            toolUsed: "reformat",
            toolCommand: "reformat.sh in=reads.fq out1=R1.fastq out2=R2.fastq"
        )
        let manifest = FASTQDerivedBundleManifest(
            name: "deinterleaved-reads",
            parentBundleRelativePath: "../example.lungfishfastq",
            rootBundleRelativePath: "../example.lungfishfastq",
            rootFASTQFilename: "example.fastq.gz",
            payload: .fullPaired(r1Filename: "R1.fastq", r2Filename: "R2.fastq"),
            lineage: [op],
            operation: op,
            cachedStatistics: .empty,
            pairingMode: .interleaved
        )

        try FASTQBundle.saveDerivedManifest(manifest, in: bundleURL)
        let loaded = FASTQBundle.loadDerivedManifest(in: bundleURL)

        XCTAssertNotNil(loaded)
        if case .fullPaired(let r1, let r2) = loaded?.payload {
            XCTAssertEqual(r1, "R1.fastq")
            XCTAssertEqual(r2, "R2.fastq")
        } else {
            XCTFail("Expected fullPaired payload")
        }
        XCTAssertEqual(loaded?.operation.kind, .interleaveReformat)
        XCTAssertEqual(loaded?.operation.interleaveDirection, .deinterleave)
        XCTAssertEqual(loaded?.operation.toolUsed, "reformat")
        XCTAssertEqual(loaded?.payload.category, "full-paired")

        // Verify bundle helpers
        XCTAssertNotNil(FASTQBundle.pairedFASTQURLs(forDerivedBundle: bundleURL))
        XCTAssertNil(FASTQBundle.fullPayloadFASTQURL(forDerivedBundle: bundleURL))
        XCTAssertNil(FASTQBundle.readIDListURL(forDerivedBundle: bundleURL))
        XCTAssertNil(FASTQBundle.trimPositionsURL(forDerivedBundle: bundleURL))
    }

    func testPayloadCategories() {
        XCTAssertEqual(FASTQDerivativePayload.subset(readIDListFilename: "ids.txt").category, "subset")
        XCTAssertEqual(FASTQDerivativePayload.trim(trimPositionFilename: "trim.tsv").category, "trim")
        XCTAssertEqual(FASTQDerivativePayload.full(fastqFilename: "reads.fq").category, "full")
        XCTAssertEqual(FASTQDerivativePayload.fullPaired(r1Filename: "R1.fq", r2Filename: "R2.fq").category, "full-paired")
        XCTAssertEqual(
            FASTQDerivativePayload.demuxedVirtual(barcodeID: "bc1", readIDListFilename: "ids.txt", previewFilename: "preview.fastq.gz").category,
            "demuxed-virtual"
        )
    }

    // MARK: - Demuxed Virtual Payload

    func testDemuxedVirtualManifestRoundTrip() throws {
        let (tempDir, bundleURL) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let op = FASTQDerivativeOperation(kind: .demultiplex, createdAt: Date())
        let stats = FASTQDatasetStatistics.placeholder(readCount: 5000, baseCount: 750_000)
        let manifest = FASTQDerivedBundleManifest(
            name: "bc1001",
            parentBundleRelativePath: "../root.lungfishfastq",
            rootBundleRelativePath: "../root.lungfishfastq",
            rootFASTQFilename: "reads.fastq.gz",
            payload: .demuxedVirtual(
                barcodeID: "bc1001",
                readIDListFilename: "read-ids.txt",
                previewFilename: "preview.fastq.gz"
            ),
            lineage: [op],
            operation: op,
            cachedStatistics: stats,
            pairingMode: nil
        )

        try FASTQBundle.saveDerivedManifest(manifest, in: bundleURL)
        let loaded = FASTQBundle.loadDerivedManifest(in: bundleURL)

        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.name, "bc1001")
        XCTAssertEqual(loaded?.rootFASTQFilename, "reads.fastq.gz")
        if case .demuxedVirtual(let barcodeID, let readIDFile, let previewFile, _) = loaded?.payload {
            XCTAssertEqual(barcodeID, "bc1001")
            XCTAssertEqual(readIDFile, "read-ids.txt")
            XCTAssertEqual(previewFile, "preview.fastq.gz")
        } else {
            XCTFail("Expected demuxedVirtual payload, got \(String(describing: loaded?.payload))")
        }
        XCTAssertEqual(loaded?.cachedStatistics.readCount, 5000)
        XCTAssertEqual(loaded?.cachedStatistics.baseCount, 750_000)
        XCTAssertEqual(loaded?.cachedStatistics.meanReadLength, 150.0)
    }

    func testPlaceholderStatistics() {
        let stats = FASTQDatasetStatistics.placeholder(readCount: 10_000, baseCount: 1_500_000)
        XCTAssertEqual(stats.readCount, 10_000)
        XCTAssertEqual(stats.baseCount, 1_500_000)
        XCTAssertEqual(stats.meanReadLength, 150.0)
        XCTAssertEqual(stats.minReadLength, 0)
        XCTAssertEqual(stats.maxReadLength, 0)
        XCTAssertTrue(stats.readLengthHistogram.isEmpty)
        XCTAssertTrue(stats.qualityScoreHistogram.isEmpty)

        let emptyStats = FASTQDatasetStatistics.placeholder(readCount: 0, baseCount: 0)
        XCTAssertEqual(emptyStats.meanReadLength, 0)
    }

    // MARK: - Trim Validation Edge Cases

    func testLoadRejectsReversedTrimPositions() throws {
        let (tempDir, _) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let tsvURL = tempDir.appendingPathComponent("invalid_trim.tsv")
        try "read1\t50\t10\n".write(to: tsvURL, atomically: true, encoding: .utf8)

        let loaded = try FASTQTrimPositionFile.load(from: tsvURL)
        XCTAssertTrue(loaded.isEmpty, "Reversed trim positions (start > end) should be rejected")
    }

    func testLoadRejectsNegativeTrimPositions() throws {
        let (tempDir, _) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let tsvURL = tempDir.appendingPathComponent("negative_trim.tsv")
        try "read1\t-5\t10\nread2\t0\t-1\n".write(to: tsvURL, atomically: true, encoding: .utf8)

        let loaded = try FASTQTrimPositionFile.load(from: tsvURL)
        XCTAssertTrue(loaded.isEmpty, "Negative trim positions should be rejected")
    }

    func testLoadRejectsZeroLengthTrimPositions() throws {
        let (tempDir, _) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let tsvURL = tempDir.appendingPathComponent("zero_trim.tsv")
        try "read1\t10\t10\n".write(to: tsvURL, atomically: true, encoding: .utf8)

        let loaded = try FASTQTrimPositionFile.load(from: tsvURL)
        XCTAssertTrue(loaded.isEmpty, "Zero-length trim positions (start == end) should be rejected")
    }

    func testLoadRecordsRejectsInvalidPositions() throws {
        let (tempDir, _) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let tsvURL = tempDir.appendingPathComponent("mixed_trim.tsv")
        try """
            valid\t0\t100
            reversed\t100\t0
            negative\t-5\t10
            zero_len\t50\t50
            also_valid\t10\t20
            """.write(to: tsvURL, atomically: true, encoding: .utf8)

        let records = try FASTQTrimPositionFile.loadRecords(from: tsvURL)
        XCTAssertEqual(records.count, 2, "Only valid and also_valid should load")
        XCTAssertEqual(records[0].readID, "valid")
        XCTAssertEqual(records[1].readID, "also_valid")
    }

    func testTrimCompositionChildCompletelyOutsideParent() {
        let parent: [String: (start: Int, end: Int)] = [
            "read1": (10, 20),
        ]
        let child: [String: (start: Int, end: Int)] = [
            "read1": (30, 40),
        ]
        let result = FASTQTrimPositionFile.compose(parent: parent, child: child)
        XCTAssertTrue(result.isEmpty, "Child range beyond parent should produce empty result")
    }

    func testTrimCompositionExactParentBounds() {
        let parent: [String: (start: Int, end: Int)] = [
            "read1": (10, 20),
        ]
        let child: [String: (start: Int, end: Int)] = [
            "read1": (0, 10),
        ]
        let result = FASTQTrimPositionFile.compose(parent: parent, child: child)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result["read1"]?.start, 10)
        XCTAssertEqual(result["read1"]?.end, 20)
    }

    func testTrimCompositionMultipleReads() {
        let parent: [String: (start: Int, end: Int)] = [
            "read1": (0, 100),
            "read2": (10, 50),
            "read3": (0, 200),
        ]
        let child: [String: (start: Int, end: Int)] = [
            "read1": (5, 90),
            "read2": (0, 40),
            "read4": (0, 10),  // not in parent
        ]
        let result = FASTQTrimPositionFile.compose(parent: parent, child: child)
        XCTAssertEqual(result.count, 2, "Only reads in both sets should appear")
        XCTAssertEqual(result["read1"]?.start, 5)
        XCTAssertEqual(result["read1"]?.end, 90)
        XCTAssertEqual(result["read2"]?.start, 10)
        XCTAssertEqual(result["read2"]?.end, 50)
        XCTAssertNil(result["read3"], "read3 not in child")
        XCTAssertNil(result["read4"], "read4 not in parent")
    }

    func testTrimPositionFileStreamingWrite() throws {
        let (tempDir, _) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let records = (0..<1000).map { i in
            FASTQTrimRecord(readID: "read_\(i)", trimStart: i * 10, trimEnd: i * 10 + 100)
        }

        let tsvURL = tempDir.appendingPathComponent("large_trim.tsv")
        try FASTQTrimPositionFile.write(records, to: tsvURL)

        let loaded = try FASTQTrimPositionFile.loadRecords(from: tsvURL)
        XCTAssertEqual(loaded.count, 1000, "All 1000 records should round-trip")
        XCTAssertEqual(loaded.first?.readID, "read_0")
        XCTAssertEqual(loaded.last?.readID, "read_999")
    }

    func testBundleSubsetHasNoTrimURL() throws {
        let (tempDir, bundleURL) = try makeTempBundle()
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let op = FASTQDerivativeOperation(kind: .subsampleCount, count: 100)
        let manifest = FASTQDerivedBundleManifest(
            name: "subset-test",
            parentBundleRelativePath: "../parent.lungfishfastq",
            rootBundleRelativePath: "../parent.lungfishfastq",
            rootFASTQFilename: "reads.fastq.gz",
            payload: .subset(readIDListFilename: "read-ids.txt"),
            lineage: [op],
            operation: op,
            cachedStatistics: .empty,
            pairingMode: nil
        )

        try FASTQBundle.saveDerivedManifest(manifest, in: bundleURL)

        XCTAssertNotNil(FASTQBundle.readIDListURL(forDerivedBundle: bundleURL))
        XCTAssertNil(FASTQBundle.trimPositionsURL(forDerivedBundle: bundleURL))
    }
}
