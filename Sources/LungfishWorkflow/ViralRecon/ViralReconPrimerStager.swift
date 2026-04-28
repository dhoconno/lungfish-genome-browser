import Foundation
import LungfishIO

public enum ViralReconPrimerStager {
    public enum StageError: Error, Sendable, Equatable {
        case emptyReference
        case invalidBEDLine(String)
        case invalidBEDCoordinate(String)
    }

    public static func stage(
        primerBundleURL: URL,
        referenceFASTAURL: URL,
        referenceName: String,
        destinationDirectory: URL
    ) throws -> ViralReconPrimerSelection {
        let bundle = try PrimerSchemeBundle.load(from: primerBundleURL)
        let resolved = try PrimerSchemeResolver.resolve(bundle: bundle, targetReferenceName: referenceName)

        let primersDirectory = destinationDirectory.appendingPathComponent("primers", isDirectory: true)
        try FileManager.default.createDirectory(at: primersDirectory, withIntermediateDirectories: true)

        let stagedBEDURL = primersDirectory.appendingPathComponent("primers.bed")
        try replaceItem(at: stagedBEDURL, withCopyOf: resolved.bedURL)

        let stagedFASTAURL = primersDirectory.appendingPathComponent("primers.fasta")
        let derivedFasta: Bool
        if let bundledFASTAURL = bundle.fastaURL {
            try replaceItem(at: stagedFASTAURL, withCopyOf: bundledFASTAURL)
            derivedFasta = false
        } else {
            try derivePrimerFASTA(
                bedURL: stagedBEDURL,
                referenceFASTAURL: referenceFASTAURL,
                outputURL: stagedFASTAURL
            )
            derivedFasta = true
        }

        return ViralReconPrimerSelection(
            bundleURL: primerBundleURL,
            displayName: bundle.manifest.displayName,
            bedURL: stagedBEDURL,
            fastaURL: stagedFASTAURL,
            leftSuffix: inferSuffix(in: stagedBEDURL, fallback: "_LEFT"),
            rightSuffix: inferSuffix(in: stagedBEDURL, fallback: "_RIGHT"),
            derivedFasta: derivedFasta
        )
    }

    private static func replaceItem(at destination: URL, withCopyOf source: URL) throws {
        if FileManager.default.fileExists(atPath: destination.path) {
            try FileManager.default.removeItem(at: destination)
        }
        try FileManager.default.copyItem(at: source, to: destination)
    }

    private static func derivePrimerFASTA(
        bedURL: URL,
        referenceFASTAURL: URL,
        outputURL: URL
    ) throws {
        let reference = try loadReferenceSequence(from: referenceFASTAURL)
        guard !reference.isEmpty else { throw StageError.emptyReference }
        let bed = try String(contentsOf: bedURL, encoding: .utf8)
        var records: [String] = []

        for rawLine in bed.split(separator: "\n", omittingEmptySubsequences: false) {
            let line = String(rawLine).trimmingCharacters(in: .whitespacesAndNewlines)
            guard !line.isEmpty, !line.hasPrefix("#") else { continue }
            let columns = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
            guard columns.count >= 4 else { throw StageError.invalidBEDLine(line) }
            guard let start = Int(columns[1]), let end = Int(columns[2]),
                  start >= 0, end > start, end <= reference.count else {
                throw StageError.invalidBEDCoordinate(line)
            }

            let name = columns[3]
            var sequence = slice(reference, start: start, end: end)
            if columns.count >= 6, columns[5] == "-" {
                sequence = reverseComplement(sequence)
            }
            records.append(">\(name)\n\(sequence)")
        }

        try (records.joined(separator: "\n") + "\n").write(to: outputURL, atomically: true, encoding: .utf8)
    }

    private static func loadReferenceSequence(from url: URL) throws -> String {
        let contents = try String(contentsOf: url, encoding: .utf8)
        return contents
            .split(separator: "\n")
            .filter { !$0.hasPrefix(">") }
            .joined()
            .uppercased()
    }

    private static func slice(_ sequence: String, start: Int, end: Int) -> String {
        let startIndex = sequence.index(sequence.startIndex, offsetBy: start)
        let endIndex = sequence.index(sequence.startIndex, offsetBy: end)
        return String(sequence[startIndex..<endIndex])
    }

    private static func reverseComplement(_ sequence: String) -> String {
        String(sequence.reversed().map { base in
            switch base {
            case "A": return "T"
            case "C": return "G"
            case "G": return "C"
            case "T": return "A"
            default: return "N"
            }
        })
    }

    private static func inferSuffix(in bedURL: URL, fallback: String) -> String {
        guard let bed = try? String(contentsOf: bedURL, encoding: .utf8) else { return fallback }
        let candidate = fallback.uppercased()
        for line in bed.split(separator: "\n") {
            let columns = line.split(separator: "\t", omittingEmptySubsequences: false)
            guard columns.count >= 4 else { continue }
            let name = String(columns[3])
            if name.uppercased().hasSuffix(candidate),
               let range = name.range(of: candidate, options: [.caseInsensitive, .backwards]) {
                return String(name[range.lowerBound...])
            }
        }
        return fallback
    }
}
