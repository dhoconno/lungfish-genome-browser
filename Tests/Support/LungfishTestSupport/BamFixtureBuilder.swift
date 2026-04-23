import Foundation
import LungfishIO

public enum BamFixtureBuilder {
    public struct Reference: Sendable, Equatable {
        public let name: String
        public let length: Int

        public init(name: String, length: Int) {
            self.name = name
            self.length = length
        }
    }

    public struct Read: Sendable, Equatable {
        public let qname: String
        public let flag: Int
        public let rname: String
        public let pos: Int
        public let mapq: Int
        public let cigar: String
        public let seq: String
        public let qual: String
        public let optionalFields: [String]

        public init(
            qname: String,
            flag: Int,
            rname: String,
            pos: Int,
            mapq: Int,
            cigar: String,
            seq: String,
            qual: String,
            optionalFields: [String] = []
        ) {
            self.qname = qname
            self.flag = flag
            self.rname = rname
            self.pos = pos
            self.mapq = mapq
            self.cigar = cigar
            self.seq = seq
            self.qual = qual
            self.optionalFields = optionalFields
        }
    }

    public enum FixtureError: Error, LocalizedError {
        case samtoolsNotFound
        case samtoolsFailed(subcommand: String, stderr: String)

        public var errorDescription: String? {
            switch self {
            case .samtoolsNotFound:
                return "samtools is not available for BAM fixture generation."
            case .samtoolsFailed(let subcommand, let stderr):
                return "samtools \(subcommand) failed: \(stderr)"
            }
        }
    }

    public static func makeBAM(
        at outputURL: URL,
        references: [Reference],
        reads: [Read],
        samtoolsPath: URL
    ) throws {
        let fileManager = FileManager.default
        let parentDirectory = outputURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: parentDirectory, withIntermediateDirectories: true)

        let samURL = outputURL.deletingPathExtension().appendingPathExtension("sam")
        try makeSAM(references: references, reads: reads)
            .write(to: samURL, atomically: true, encoding: .utf8)
        defer { try? fileManager.removeItem(at: samURL) }

        try runSamtools(
            executableURL: samtoolsPath,
            arguments: ["sort", "-o", outputURL.path, samURL.path],
            subcommand: "sort"
        )
        try runSamtools(
            executableURL: samtoolsPath,
            arguments: ["index", outputURL.path],
            subcommand: "index"
        )
    }

    public static func makeBAM(
        at outputURL: URL,
        references: [Reference],
        reads: [Read],
        samtoolsPath: String
    ) throws {
        try makeBAM(
            at: outputURL,
            references: references,
            reads: reads,
            samtoolsPath: URL(fileURLWithPath: samtoolsPath)
        )
    }

    public static func locateSamtools(
        searchPath: String? = ProcessInfo.processInfo.environment["PATH"]
    ) -> String? {
        if let managed = SamtoolsLocator.locate(searchPath: searchPath) {
            return managed
        }

        let fileManager = FileManager.default
        if let searchPath, !searchPath.isEmpty {
            for directory in searchPath.split(separator: ":") {
                let candidate = String(directory) + "/samtools"
                if fileManager.isExecutableFile(atPath: candidate) {
                    return candidate
                }
            }
        }

        for candidate in ["/opt/homebrew/bin/samtools", "/usr/local/bin/samtools", "/usr/bin/samtools"] {
            if fileManager.isExecutableFile(atPath: candidate) {
                return candidate
            }
        }

        return nil
    }

    private static func makeSAM(references: [Reference], reads: [Read]) -> String {
        var sam = "@HD\tVN:1.6\tSO:coordinate\n"
        for reference in references {
            sam += "@SQ\tSN:\(reference.name)\tLN:\(reference.length)\n"
        }
        for read in reads {
            var fields = [
                read.qname,
                String(read.flag),
                read.rname,
                String(read.pos),
                String(read.mapq),
                read.cigar,
                "*",
                "0",
                "0",
                read.seq,
                read.qual,
            ]
            fields.append(contentsOf: read.optionalFields)
            sam += fields.joined(separator: "\t") + "\n"
        }
        return sam
    }

    private static func runSamtools(
        executableURL: URL,
        arguments: [String],
        subcommand: String
    ) throws {
        let process = Process()
        process.executableURL = executableURL
        process.arguments = arguments
        process.standardOutput = FileHandle.nullDevice
        let stderrPipe = Pipe()
        process.standardError = stderrPipe
        try process.run()
        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            let stderr = String(data: stderrData, encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            throw FixtureError.samtoolsFailed(subcommand: subcommand, stderr: stderr)
        }
    }
}
