// MappingFASTAInputStager.swift - Runtime FASTA staging for SAM-safe query names
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import CryptoKit
import Foundation
import LungfishIO

struct StagedMappingInputArtifacts: Sendable, Equatable {
    let inputURLs: [URL]
    let cleanupURLs: [URL]
}

enum MappingFASTAInputStager {
    static let maximumSAMQueryNameLength = 254

    private struct ResolvedInput: Sendable, Equatable {
        let originalURL: URL
        let executionURL: URL
        let format: SequenceFormat?
        let requiresStaging: Bool
    }

    static func stageSAMSafeFASTAInputsIfNeeded(
        inputURLs: [URL],
        projectURL: URL?
    ) async throws -> StagedMappingInputArtifacts {
        var resolvedInputs: [ResolvedInput] = []
        var requiresStaging = false

        for inputURL in inputURLs {
            let executionURL = SequenceInputResolver.resolvePrimarySequenceURL(for: inputURL) ?? inputURL
            let format = SequenceInputResolver.inputSequenceFormat(for: inputURL)
                ?? SequenceFormat.from(url: executionURL)
            let shouldStage = format == .fasta
                ? try await fastaRequiresSAMSafeStaging(at: executionURL)
                : false
            requiresStaging = requiresStaging || shouldStage
            resolvedInputs.append(
                ResolvedInput(
                    originalURL: inputURL,
                    executionURL: executionURL,
                    format: format,
                    requiresStaging: shouldStage
                )
            )
        }

        guard requiresStaging else {
            return StagedMappingInputArtifacts(inputURLs: inputURLs, cleanupURLs: [])
        }

        let workspace = try ProjectTempDirectory.create(prefix: "mapping-fasta-stage-", in: projectURL)
        var stagedURLs: [URL] = []
        stagedURLs.reserveCapacity(resolvedInputs.count)

        for (index, input) in resolvedInputs.enumerated() {
            guard input.requiresStaging else {
                stagedURLs.append(input.originalURL)
                continue
            }

            let outputURL = workspace.appendingPathComponent("query-\(index + 1).fasta")
            try await rewriteFASTAWithSAMSafeQueryNames(
                inputURL: input.executionURL,
                outputURL: outputURL
            )
            stagedURLs.append(outputURL)
        }

        return StagedMappingInputArtifacts(
            inputURLs: stagedURLs,
            cleanupURLs: [workspace]
        )
    }

    static func fastaRequiresSAMSafeStaging(at inputURL: URL) async throws -> Bool {
        for try await line in inputURL.linesAutoDecompressing() {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.hasPrefix(">") else { continue }
            if !isSAMSafeQueryName(parseIdentifier(fromHeader: String(trimmed.dropFirst()))) {
                return true
            }
        }
        return false
    }

    private static func rewriteFASTAWithSAMSafeQueryNames(
        inputURL: URL,
        outputURL: URL
    ) async throws {
        let manager = FileManager.default
        if manager.fileExists(atPath: outputURL.path) {
            try manager.removeItem(at: outputURL)
        }
        manager.createFile(atPath: outputURL.path, contents: nil)

        let handle = try FileHandle(forWritingTo: outputURL)
        defer { try? handle.close() }

        var currentHeader: String?
        var sequenceLines: [String] = []
        var seenNames: Set<String> = []
        var recordIndex = 0

        func flushCurrentRecord() throws {
            guard let currentHeader else { return }

            recordIndex += 1
            let originalName = parseIdentifier(fromHeader: currentHeader)
            let stagedName = makeSAMSafeQueryName(
                from: originalName,
                recordIndex: recordIndex,
                seenNames: &seenNames
            )
            try writeFASTARecord(
                name: stagedName,
                sequenceLines: sequenceLines,
                to: handle
            )
        }

        for try await line in inputURL.linesAutoDecompressing() {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                continue
            }

            if trimmed.hasPrefix(">") {
                try flushCurrentRecord()
                currentHeader = String(trimmed.dropFirst())
                sequenceLines.removeAll(keepingCapacity: true)
            } else {
                sequenceLines.append(trimmed)
            }
        }

        try flushCurrentRecord()
    }

    private static func writeFASTARecord(
        name: String,
        sequenceLines: [String],
        to handle: FileHandle
    ) throws {
        try handle.write(contentsOf: Data(">\(name)\n".utf8))
        for line in sequenceLines {
            try handle.write(contentsOf: Data("\(line)\n".utf8))
        }
    }

    private static func parseIdentifier(fromHeader header: String) -> String {
        guard let whitespaceIndex = header.firstIndex(where: \.isWhitespace) else {
            return header
        }
        return String(header[..<whitespaceIndex])
    }

    private static func makeSAMSafeQueryName(
        from rawName: String,
        recordIndex: Int,
        seenNames: inout Set<String>
    ) -> String {
        if isSAMSafeQueryName(rawName), seenNames.insert(rawName).inserted {
            return rawName
        }

        let sanitized = sanitize(rawName)
        let hash = shortHash(of: rawName)
        let prefix = "q\(recordIndex)_"
        let reservedCount = prefix.count + 1 + hash.count
        let maxPayloadCount = max(0, maximumSAMQueryNameLength - reservedCount)
        let payload = String(sanitized.prefix(maxPayloadCount))

        let candidate = "\(prefix)\(payload)_\(hash)"
        seenNames.insert(candidate)
        return candidate
    }

    private static func sanitize(_ rawName: String) -> String {
        let sanitizedScalars = rawName.unicodeScalars.map { scalar -> UnicodeScalar in
            let value = scalar.value
            if value >= 33, value <= 126, value != 64 {
                return scalar
            }
            return "_"
        }
        let sanitized = String(String.UnicodeScalarView(sanitizedScalars))
        return sanitized.isEmpty ? "query" : sanitized
    }

    private static func shortHash(of rawName: String) -> String {
        let digest = SHA256.hash(data: Data(rawName.utf8))
        return digest.prefix(6).map { String(format: "%02x", $0) }.joined()
    }

    private static func isSAMSafeQueryName(_ rawName: String) -> Bool {
        guard !rawName.isEmpty else { return false }
        guard rawName.utf8.count <= maximumSAMQueryNameLength else { return false }

        for scalar in rawName.unicodeScalars {
            let value = scalar.value
            guard value >= 33, value <= 126, value != 64 else {
                return false
            }
        }
        return true
    }
}
