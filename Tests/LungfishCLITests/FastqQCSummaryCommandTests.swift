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

    func testFastqCommandRegistersQCSummarySubcommand() {
        let names = FastqCommand.configuration.subcommands.map { $0.configuration.commandName }
        XCTAssertTrue(names.contains("qc-summary"))
    }
}
