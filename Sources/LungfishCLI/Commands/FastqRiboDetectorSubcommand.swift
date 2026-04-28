import ArgumentParser
import Foundation
import LungfishIO
import LungfishWorkflow

struct RiboDetectorOutputPlan: Sendable, Equatable {
    let nonRRNAOutputURL: URL
    let rRNAOutputURL: URL?
    let retainedOutputURLs: [URL]
    let removeNonRRNAOutputAfterRun: Bool
}

struct FastqRiboDetectorSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "ribodetector",
        abstract: "Detect and remove ribosomal RNA sequences with RiboDetector CPU mode"
    )

    @Argument(help: "Input FASTA or FASTQ file")
    var input: String

    @Option(name: .customLong("retain"), help: "Read classes to retain: norrna, rrna, or both")
    var retain: String = FASTQRiboDetectorRetention.nonRRNA.rawValue

    @Option(name: .customLong("ensure"), help: "RiboDetector assurance mode: rrna, norrna, both, or none")
    var ensure: String = FASTQRiboDetectorEnsure.rrna.rawValue

    @Option(name: .customLong("read-length"), help: "Mean sequencing read length. Inferred from input when omitted.")
    var readLength: Int?

    @Option(name: .customLong("threads"), help: "CPU threads to use. Defaults to the active processor count.")
    var threads: Int?

    @Option(name: [.customLong("output"), .customShort("o")], help: "Output directory")
    var outputDirectory: String

    func run() async throws {
        let inputURL = try validateInput(input)
        let outputDirectoryURL = URL(fileURLWithPath: outputDirectory, isDirectory: true)
        try FileManager.default.createDirectory(at: outputDirectoryURL, withIntermediateDirectories: true)

        let retention = try parsedRetention(retain)
        let ensureMode = try parsedEnsure(ensure)
        let effectiveReadLength = try await resolvedReadLength(for: inputURL)
        let effectiveThreads = max(1, threads ?? ProcessInfo.processInfo.activeProcessorCount)
        let outputs = try Self.plannedOutputs(
            inputURL: inputURL,
            outputDirectory: outputDirectoryURL,
            retention: retention
        )

        var arguments = [
            "-t", "\(effectiveThreads)",
            "-l", "\(effectiveReadLength)",
            "-i", inputURL.path,
            "-e", ensureMode.rawValue,
            "-o", outputs.nonRRNAOutputURL.path,
        ]
        if let rRNAOutputURL = outputs.rRNAOutputURL {
            arguments += ["-r", rRNAOutputURL.path]
        }

        let result = try await CondaManager.shared.runTool(
            name: "ribodetector_cpu",
            arguments: arguments,
            environment: "ribodetector",
            workingDirectory: outputDirectoryURL,
            timeout: 7200
        )
        guard result.exitCode == 0 else {
            throw CLIError.conversionFailed(reason: "RiboDetector failed: \(result.stderr)")
        }

        if outputs.removeNonRRNAOutputAfterRun {
            try? FileManager.default.removeItem(at: outputs.nonRRNAOutputURL)
        }

        let retained = outputs.retainedOutputURLs.map(\.path).joined(separator: ", ")
        FileHandle.standardError.write(Data("RiboDetector outputs written to \(retained)\n".utf8))
    }

    static func plannedOutputs(
        inputURL: URL,
        outputDirectory: URL,
        retention: FASTQRiboDetectorRetention
    ) throws -> RiboDetectorOutputPlan {
        guard let format = SequenceFormat.from(url: inputURL) else {
            throw ValidationError("RiboDetector input must be FASTA or FASTQ: \(inputURL.path)")
        }

        let stem = sequenceStem(for: inputURL)
        let ext = format.fileExtension
        let normalNonRRNA = outputDirectory.appendingPathComponent("\(stem).norrna.\(ext)")
        let hiddenNonRRNA = outputDirectory.appendingPathComponent(".\(stem).norrna.discarded.\(ext)")
        let rRNAOutput = outputDirectory.appendingPathComponent("\(stem).rrna.\(ext)")

        switch retention {
        case .nonRRNA:
            return RiboDetectorOutputPlan(
                nonRRNAOutputURL: normalNonRRNA,
                rRNAOutputURL: nil,
                retainedOutputURLs: [normalNonRRNA],
                removeNonRRNAOutputAfterRun: false
            )
        case .rRNA:
            return RiboDetectorOutputPlan(
                nonRRNAOutputURL: hiddenNonRRNA,
                rRNAOutputURL: rRNAOutput,
                retainedOutputURLs: [rRNAOutput],
                removeNonRRNAOutputAfterRun: true
            )
        case .both:
            return RiboDetectorOutputPlan(
                nonRRNAOutputURL: normalNonRRNA,
                rRNAOutputURL: rRNAOutput,
                retainedOutputURLs: [normalNonRRNA, rRNAOutput],
                removeNonRRNAOutputAfterRun: false
            )
        }
    }

    private func parsedRetention(_ value: String) throws -> FASTQRiboDetectorRetention {
        guard let retention = FASTQRiboDetectorRetention(rawValue: value.lowercased()) else {
            throw ValidationError("Unsupported --retain value: \(value). Use norrna, rrna, or both.")
        }
        return retention
    }

    private func parsedEnsure(_ value: String) throws -> FASTQRiboDetectorEnsure {
        guard let ensure = FASTQRiboDetectorEnsure(rawValue: value.lowercased()) else {
            throw ValidationError("Unsupported --ensure value: \(value). Use rrna, norrna, both, or none.")
        }
        return ensure
    }

    private func resolvedReadLength(for inputURL: URL) async throws -> Int {
        if let readLength {
            guard readLength > 0 else {
                throw ValidationError("--read-length must be positive")
            }
            return readLength
        }
        return try await Self.inferMeanReadLength(from: inputURL)
    }

    private static func inferMeanReadLength(from inputURL: URL, sampleLimit: Int = 1000) async throws -> Int {
        guard let format = SequenceFormat.from(url: inputURL) else {
            throw ValidationError("RiboDetector input must be FASTA or FASTQ: \(inputURL.path)")
        }

        var totalLength = 0
        var sampledCount = 0
        switch format {
        case .fastq:
            let reader = FASTQReader(validateSequence: false)
            for try await record in reader.records(from: inputURL) {
                totalLength += record.sequence.count
                sampledCount += 1
                if sampledCount >= sampleLimit { break }
            }
        case .fasta:
            let reader = try FASTAReader(url: inputURL)
            for try await sequence in reader.sequences() {
                totalLength += sequence.length
                sampledCount += 1
                if sampledCount >= sampleLimit { break }
            }
        }

        guard sampledCount > 0 else {
            throw CLIError.conversionFailed(reason: "Cannot infer read length from an empty input file")
        }
        return max(1, Int((Double(totalLength) / Double(sampledCount)).rounded()))
    }

    private static func sequenceStem(for inputURL: URL) -> String {
        let baseURL = inputURL.pathExtension.lowercased() == "gz"
            ? inputURL.deletingPathExtension()
            : inputURL
        let stem = baseURL.deletingPathExtension().lastPathComponent
        return stem.isEmpty ? "ribodetector-output" : stem
    }
}
