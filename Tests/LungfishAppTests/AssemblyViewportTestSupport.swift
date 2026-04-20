import AppKit
import Foundation
@testable import LungfishApp
import LungfishIO
import LungfishWorkflow
import XCTest

@MainActor
final class RecordingPasteboard: PasteboardWriting {
    private(set) var lastString: String?

    func setString(_ string: String) {
        lastString = string
    }
}

func makeAssemblyResult() throws -> AssemblyResult {
    let projectRoot = FileManager.default.temporaryDirectory
        .appendingPathComponent("assembly-viewport-test-\(UUID().uuidString).lungfish", isDirectory: true)
    let root = projectRoot
        .appendingPathComponent("Analyses", isDirectory: true)
        .appendingPathComponent("spades-2026-04-19T21-40-00", isDirectory: true)
    try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)

    let contigsURL = root.appendingPathComponent("contigs.fasta")
    try """
    >contig_7
    AACCGGTT
    >contig_9
    ATATAT
    """.write(to: contigsURL, atomically: true, encoding: .utf8)
    try FASTAIndexBuilder.buildAndWrite(for: contigsURL)

    let result = AssemblyResult(
        tool: .spades,
        readType: .illuminaShortReads,
        contigsPath: contigsURL,
        graphPath: nil,
        logPath: root.appendingPathComponent("spades.log"),
        assemblerVersion: "4.0.0",
        commandLine: "spades.py -o \(root.path)",
        outputDirectory: root,
        statistics: try AssemblyStatisticsCalculator.compute(from: contigsURL),
        wallTimeSeconds: 15
    )
    try result.save(to: root)
    return result
}
