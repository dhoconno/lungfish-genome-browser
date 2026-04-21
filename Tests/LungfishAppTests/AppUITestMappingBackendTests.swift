import XCTest
@testable import LungfishApp
import LungfishWorkflow

final class AppUITestMappingBackendTests: XCTestCase {
    func testWriteResultProducesLoadableMappingResultForEachMapper() throws {
        let fileManager = FileManager.default
        let tempRoot = fileManager.temporaryDirectory
            .appendingPathComponent("mapping-backend-\(UUID().uuidString)", isDirectory: true)
        defer { try? fileManager.removeItem(at: tempRoot) }
        try fileManager.createDirectory(at: tempRoot, withIntermediateDirectories: true)

        let referenceURL = tempRoot.appendingPathComponent("ref.fasta")
        let referenceFASTA = """
            >chr1 test reference
            ACGTACGTACGTACGTACGTACGTACGT
            ACGTACGTACGTACGTACGT
            """
        try referenceFASTA.write(to: referenceURL, atomically: true, encoding: .utf8)
        let expectedContigLength: Int = {
            var total = 0
            for line in referenceFASTA.split(whereSeparator: { $0 == "\n" }).dropFirst() {
                total += line.count
            }
            return total
        }()

        let inputURL = tempRoot.appendingPathComponent("reads.fastq.gz")
        try Data().write(to: inputURL)

        for tool in MappingTool.allCases {
            let outputDirectory = tempRoot.appendingPathComponent("out-\(tool.rawValue)", isDirectory: true)
            let request = MappingRunRequest(
                tool: tool,
                modeID: "short-read-default",
                inputFASTQURLs: [inputURL],
                referenceFASTAURL: referenceURL,
                projectURL: nil,
                outputDirectory: outputDirectory,
                sampleName: "sample",
                threads: 4
            )

            let written = try AppUITestMappingBackend.writeResult(for: request)
            XCTAssertEqual(written.mapper, tool)
            XCTAssertEqual(written.contigs.count, 1)
            XCTAssertEqual(written.contigs.first?.contigName, "chr1")
            XCTAssertEqual(written.contigs.first?.contigLength, expectedContigLength)

            let loaded = try MappingResult.load(from: outputDirectory)
            XCTAssertEqual(loaded.mapper, tool)
            XCTAssertEqual(loaded.contigs.count, 1)
            XCTAssertEqual(loaded.contigs.first?.contigName, "chr1")
            XCTAssertEqual(loaded.totalReads, written.totalReads)
            XCTAssertEqual(loaded.mappedReads, written.mappedReads)
        }
    }
}
