import ArgumentParser
import Foundation
import LungfishIO

struct FastqQCSummarySubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "qc-summary",
        abstract: "Compute a JSON QC summary for FASTQ input files"
    )

    @Argument(help: "Input FASTQ file(s)")
    var inputs: [String]

    @OptionGroup var output: OutputOptions

    func run() async throws {
        guard !inputs.isEmpty else {
            throw ValidationError("Specify at least one input FASTQ file")
        }

        try output.validateOutput()

        let reader = FASTQReader(validateSequence: false)
        var summaries: [FastqQCSummaryEntry] = []
        summaries.reserveCapacity(inputs.count)

        for input in inputs {
            let inputURL = try validateInput(input)
            let result = try await reader.computeStatistics(from: inputURL, sampleLimit: 0)
            summaries.append(FastqQCSummaryEntry(
                input: inputURL.path,
                statistics: result.statistics
            ))
        }

        let report = FastqQCSummaryReport(inputs: summaries)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(report)
        try data.write(to: URL(fileURLWithPath: output.output), options: [.atomic])
    }
}

private struct FastqQCSummaryReport: Codable, Equatable {
    let inputs: [FastqQCSummaryEntry]
}

private struct FastqQCSummaryEntry: Codable, Equatable {
    let input: String
    let statistics: FASTQDatasetStatistics
}
