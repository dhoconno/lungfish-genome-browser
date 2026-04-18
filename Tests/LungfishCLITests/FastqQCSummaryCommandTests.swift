import XCTest
@testable import LungfishCLI

final class FastqQCSummaryCommandTests: XCTestCase {
    func testQCSummaryParsesInputAndOutput() throws {
        let command = try FastqQCSummarySubcommand.parse([
            "reads.fastq",
            "--output", "/tmp/qc-summary.json",
        ])

        XCTAssertEqual(command.inputs, ["reads.fastq"])
        XCTAssertEqual(command.output.output, "/tmp/qc-summary.json")
    }

    func testQCSummaryRunWritesJsonSummary() async throws {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent("fastq-qc-\(UUID().uuidString)", isDirectory: true)
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempDir) }

        let inputURL = tempDir.appendingPathComponent("reads.fastq")
        let outputURL = tempDir.appendingPathComponent("qc-summary.json")
        let fastq = """
        @read1
        ACGT
        +
        !!!!
        @read2
        GGTT
        +
        !!!!
        """
        guard let fastqData = fastq.data(using: .utf8) else {
            return XCTFail("Failed to encode FASTQ fixture")
        }
        try fastqData.write(to: inputURL)

        let command = try FastqQCSummarySubcommand.parse([
            inputURL.path,
            "--output", outputURL.path,
        ])

        try await command.run()

        let data = try Data(contentsOf: outputURL)
        let decoded = try JSONDecoder().decode(QCSummaryReport.self, from: data)

        XCTAssertEqual(decoded.inputs.count, 1)
        XCTAssertEqual(decoded.inputs[0].input, inputURL.path)
        XCTAssertEqual(decoded.inputs[0].statistics.readCount, 2)
        XCTAssertEqual(decoded.inputs[0].statistics.baseCount, 8)
        XCTAssertEqual(decoded.inputs[0].statistics.minReadLength, 4)
        XCTAssertEqual(decoded.inputs[0].statistics.maxReadLength, 4)
        XCTAssertEqual(decoded.inputs[0].statistics.meanQuality, 0.0, accuracy: 0.0001)
    }

    func testFastqCommandRegistersQCSummarySubcommand() {
        let names = FastqCommand.configuration.subcommands.map { $0.configuration.commandName }
        XCTAssertTrue(names.contains("qc-summary"))
    }
}

private struct QCSummaryReport: Decodable {
    struct Entry: Decodable {
        let input: String
        let statistics: Statistics
    }

    struct Statistics: Decodable {
        let readCount: Int
        let baseCount: Int64
        let minReadLength: Int
        let maxReadLength: Int
        let meanQuality: Double
    }

    let inputs: [Entry]
}
