import Foundation
import LungfishWorkflow

enum AppUITestMappingBackend {
    static func writeResult(for request: MappingRunRequest) throws -> MappingResult {
        let fileManager = FileManager.default
        try fileManager.createDirectory(
            at: request.outputDirectory,
            withIntermediateDirectories: true
        )

        let bamURL = request.outputDirectory.appendingPathComponent("\(request.sampleName).sorted.bam")
        let baiURL = request.outputDirectory.appendingPathComponent("\(request.sampleName).sorted.bam.bai")

        if !fileManager.fileExists(atPath: bamURL.path) {
            try Data().write(to: bamURL)
        }
        if !fileManager.fileExists(atPath: baiURL.path) {
            try Data().write(to: baiURL)
        }

        let contigName = referenceContigName(for: request.referenceFASTAURL) ?? "ref"
        let contigLength = referenceContigLength(for: request.referenceFASTAURL) ?? 30000
        let totalReads = 200
        let mappedReads = 190
        let unmappedReads = totalReads - mappedReads

        let contig = MappingContigSummary(
            contigName: contigName,
            contigLength: contigLength,
            mappedReads: mappedReads,
            mappedReadPercent: Double(mappedReads) / Double(totalReads) * 100,
            meanDepth: 22.5,
            coverageBreadth: 0.95,
            medianMAPQ: 60,
            meanIdentity: 99.0
        )

        let result = MappingResult(
            mapper: request.tool,
            modeID: request.modeID,
            sourceReferenceBundleURL: request.sourceReferenceBundleURL,
            viewerBundleURL: nil,
            bamURL: bamURL,
            baiURL: baiURL,
            totalReads: totalReads,
            mappedReads: mappedReads,
            unmappedReads: unmappedReads,
            wallClockSeconds: 0.5,
            contigs: [contig]
        )
        try result.save(to: request.outputDirectory)
        return result
    }

    private static func referenceContigName(for referenceURL: URL) -> String? {
        guard let handle = try? FileHandle(forReadingFrom: referenceURL) else { return nil }
        defer { try? handle.close() }
        guard let data = try? handle.read(upToCount: 4096),
              let text = String(data: data, encoding: .utf8) else { return nil }
        let firstHeader = text
            .split(separator: "\n")
            .first { $0.hasPrefix(">") }
        guard let header = firstHeader else { return nil }
        let trimmed = String(header.dropFirst())
            .split(whereSeparator: { $0.isWhitespace })
            .first
            .map(String.init)
        return trimmed
    }

    private static func referenceContigLength(for referenceURL: URL) -> Int? {
        guard let raw = try? String(contentsOf: referenceURL, encoding: .utf8) else { return nil }
        var total = 0
        var inRecord = false
        for line in raw.split(separator: "\n", omittingEmptySubsequences: false) {
            if line.hasPrefix(">") {
                if inRecord { break }
                inRecord = true
                continue
            }
            if inRecord {
                total += line.count
            }
        }
        return total > 0 ? total : nil
    }
}
