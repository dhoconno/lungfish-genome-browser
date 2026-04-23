import Foundation

enum LungfishProjectFixtureBuilder {
    private struct ProjectMetadataFixture: Encodable {
        let author: String?
        let createdAt: Date
        let customMetadata: [String: String]
        let description: String?
        let formatVersion: String
        let modifiedAt: Date
        let name: String
        let version: String
    }

    private struct AnalysisMetadataFixture: Encodable {
        let created: Date
        let isBatch: Bool
        let tool: String
    }

    private struct ReferenceBundleManifestFixture: Encodable {
        let formatVersion: String
        let name: String
        let identifier: String
        let createdDate: Date
        let modifiedDate: Date
        let source: ReferenceBundleSourceFixture
        let genome: ReferenceBundleGenomeFixture
        let annotations: [String]
        let variants: [String]
        let tracks: [String]
        let alignments: [String]
        let browserSummary: ReferenceBundleBrowserSummaryFixture

        enum CodingKeys: String, CodingKey {
            case formatVersion = "format_version"
            case name
            case identifier
            case createdDate = "created_date"
            case modifiedDate = "modified_date"
            case source
            case genome
            case annotations
            case variants
            case tracks
            case alignments
            case browserSummary = "browser_summary"
        }
    }

    private struct ReferenceBundleSourceFixture: Encodable {
        let organism: String
        let assembly: String
        let database: String
        let notes: String
    }

    private struct ReferenceBundleGenomeFixture: Encodable {
        let path: String
        let indexPath: String
        let totalLength: Int
        let chromosomes: [ReferenceBundleChromosomeFixture]

        enum CodingKeys: String, CodingKey {
            case path
            case indexPath = "index_path"
            case totalLength = "total_length"
            case chromosomes
        }
    }

    private struct ReferenceBundleChromosomeFixture: Encodable {
        let name: String
        let length: Int
        let offset: Int
        let lineBases: Int
        let lineWidth: Int
        let aliases: [String]
        let isPrimary: Bool
        let isMitochondrial: Bool

        enum CodingKeys: String, CodingKey {
            case name
            case length
            case offset
            case lineBases = "line_bases"
            case lineWidth = "line_width"
            case aliases
            case isPrimary = "is_primary"
            case isMitochondrial = "is_mitochondrial"
        }
    }

    private struct ReferenceBundleBrowserSummaryFixture: Encodable {
        let schemaVersion: Int
        let aggregate: ReferenceBundleBrowserAggregateFixture
        let sequences: [ReferenceBundleBrowserSequenceFixture]
    }

    private struct ReferenceBundleBrowserAggregateFixture: Encodable {
        let annotationTrackCount: Int
        let variantTrackCount: Int
        let alignmentTrackCount: Int
        let totalMappedReads: Int?
    }

    private struct ReferenceBundleBrowserSequenceFixture: Encodable {
        let name: String
        let displayDescription: String?
        let length: Int
        let aliases: [String]
        let isPrimary: Bool
        let isMitochondrial: Bool
        let metrics: String?
    }

    private enum FixtureCopyTarget {
        case projectRoot
        case directory(name: String)
    }

    static func makeAnalysesProject(named name: String = "FixtureProject") throws -> URL {
        let fileManager = FileManager.default
        let root = fileManager.temporaryDirectory.appendingPathComponent(
            "lungfish-xcui-project-\(UUID().uuidString)",
            isDirectory: true
        )
        let projectURL = root.appendingPathComponent("\(name).lungfish", isDirectory: true)
        let analysesDirectory = projectURL.appendingPathComponent("Analyses", isDirectory: true)
        let source = LungfishFixtureCatalog.analyses.appendingPathComponent(
            "spades-2026-01-15T13-00-00",
            isDirectory: true
        )
        let destination = analysesDirectory.appendingPathComponent(
            "spades-2026-01-15T13-00-00",
            isDirectory: true
        )

        try fileManager.createDirectory(at: analysesDirectory, withIntermediateDirectories: true)
        try fileManager.copyItem(at: source, to: destination)
        try writeProjectMetadata(to: projectURL, name: name)
        try writeAnalysisMetadata(to: destination, tool: "spades")
        return projectURL
    }

    static func makeIlluminaAssemblyProject(named name: String = "IlluminaAssemblyFixture") throws -> URL {
        try makeProject(
            named: name,
            fixtures: [
                (LungfishFixtureCatalog.sarscov2.appendingPathComponent("test_1.fastq.gz"), .projectRoot),
                (LungfishFixtureCatalog.sarscov2.appendingPathComponent("test_2.fastq.gz"), .projectRoot),
            ]
        )
    }

    static func makeIlluminaMappingProject(named name: String = "IlluminaMappingFixture") throws -> URL {
        try makeProject(
            named: name,
            fixtures: [
                (LungfishFixtureCatalog.sarscov2.appendingPathComponent("test_1.fastq.gz"), .projectRoot),
                (LungfishFixtureCatalog.sarscov2.appendingPathComponent("test_2.fastq.gz"), .projectRoot),
                (LungfishFixtureCatalog.sarscov2.appendingPathComponent("genome.fasta"), .projectRoot),
            ]
        )
    }

    static func makeMappingInspectorNavigationProject(named name: String = "MappingInspectorNavigationFixture") throws -> URL {
        try makeProject(
            named: name,
            fixtures: [
                (LungfishFixtureCatalog.sarscov2.appendingPathComponent("test_1.fastq.gz"), .projectRoot),
                (LungfishFixtureCatalog.sarscov2.appendingPathComponent("test_2.fastq.gz"), .projectRoot),
                (LungfishFixtureCatalog.repoRoot.appendingPathComponent("TestData/TestGenome.lungfishref"), .projectRoot),
            ]
        )
    }

    static func makeBundleBrowserProject(named name: String = "BundleBrowserFixture") throws -> URL {
        try makeProject(
            named: name,
            fixtures: [],
            referenceBundleRecords: [
                ("chr1", String(repeating: "A", count: 200)),
                ("chr2", String(repeating: "C", count: 120)),
                ("chrM", String(repeating: "G", count: 60)),
            ]
        )
    }

    static func makeOntAssemblyProject(named name: String = "OntAssemblyFixture") throws -> URL {
        try makeProject(
            named: name,
            fixtures: [
                (LungfishFixtureCatalog.assemblyUI.appendingPathComponent("ont/reads.fastq"), .projectRoot),
            ]
        )
    }

    static func makePacBioHiFiAssemblyProject(named name: String = "HiFiAssemblyFixture") throws -> URL {
        try makeProject(
            named: name,
            fixtures: [
                (LungfishFixtureCatalog.assemblyUI.appendingPathComponent("pacbio-hifi/reads.fastq"), .projectRoot),
            ]
        )
    }

    private static func makeProject(
        named name: String,
        fixtures: [(source: URL, target: FixtureCopyTarget)],
        referenceBundleRecords: [(name: String, sequence: String)] = []
    ) throws -> URL {
        let fileManager = FileManager.default
        let root = fileManager.temporaryDirectory.appendingPathComponent(
            "lungfish-xcui-project-\(UUID().uuidString)",
            isDirectory: true
        )
        let projectURL = root.appendingPathComponent("\(name).lungfish", isDirectory: true)
        try fileManager.createDirectory(at: projectURL, withIntermediateDirectories: true)
        try writeProjectMetadata(to: projectURL, name: name)

        for fixture in fixtures {
            let destinationDirectory: URL
            switch fixture.target {
            case .projectRoot:
                destinationDirectory = projectURL
            case .directory(let name):
                destinationDirectory = projectURL.appendingPathComponent(name, isDirectory: true)
                try fileManager.createDirectory(at: destinationDirectory, withIntermediateDirectories: true)
            }

            try fileManager.copyItem(
                at: fixture.source,
                to: destinationDirectory.appendingPathComponent(fixture.source.lastPathComponent)
            )
        }

        if !referenceBundleRecords.isEmpty {
            try writeReferenceBundle(
                named: "TestGenome",
                records: referenceBundleRecords,
                to: projectURL
            )
        }

        return projectURL
    }

    private static func writeProjectMetadata(to projectURL: URL, name: String) throws {
        let timestamp = Date()
        let metadata = ProjectMetadataFixture(
            author: nil,
            createdAt: timestamp,
            customMetadata: [:],
            description: nil,
            formatVersion: "1.0",
            modifiedAt: timestamp,
            name: name,
            version: "1.0"
        )
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let metadataURL = projectURL.appendingPathComponent("metadata.json")
        try encoder.encode(metadata).write(to: metadataURL, options: .atomic)
    }

    private static func writeAnalysisMetadata(to analysisURL: URL, tool: String) throws {
        let metadata = AnalysisMetadataFixture(
            created: Date(),
            isBatch: false,
            tool: tool
        )
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let metadataURL = analysisURL.appendingPathComponent("analysis-metadata.json")
        try encoder.encode(metadata).write(to: metadataURL, options: .atomic)
    }

    private static func writeReferenceBundle(
        named bundleName: String,
        records: [(name: String, sequence: String)],
        to projectURL: URL
    ) throws {
        let fileManager = FileManager.default
        let bundleURL = projectURL.appendingPathComponent("\(bundleName).lungfishref", isDirectory: true)
        let genomeURL = bundleURL.appendingPathComponent("genome", isDirectory: true)
        try fileManager.createDirectory(at: genomeURL, withIntermediateDirectories: true)

        let fastaURL = genomeURL.appendingPathComponent("sequence.fa")
        let faiURL = genomeURL.appendingPathComponent("sequence.fa.fai")

        var fastaLines: [String] = []
        var faiLines: [String] = []
        var chromosomes: [ReferenceBundleChromosomeFixture] = []
        var browserSequences: [ReferenceBundleBrowserSequenceFixture] = []
        var offset = 0

        for record in records {
            let header = ">\(record.name)"
            let lineBases = max(1, record.sequence.utf8.count)
            let lineWidth = lineBases + 1
            let sequenceOffset = offset + header.utf8.count + 1
            let isMitochondrial = record.name.caseInsensitiveCompare("chrM") == .orderedSame
            let aliases = aliases(for: record.name)

            fastaLines.append(header)
            fastaLines.append(record.sequence)
            faiLines.append("\(record.name)\t\(record.sequence.utf8.count)\t\(sequenceOffset)\t\(lineBases)\t\(lineWidth)")

            chromosomes.append(
                ReferenceBundleChromosomeFixture(
                    name: record.name,
                    length: record.sequence.utf8.count,
                    offset: sequenceOffset,
                    lineBases: lineBases,
                    lineWidth: lineWidth,
                    aliases: aliases,
                    isPrimary: !isMitochondrial,
                    isMitochondrial: isMitochondrial
                )
            )
            browserSequences.append(
                ReferenceBundleBrowserSequenceFixture(
                    name: record.name,
                    displayDescription: nil,
                    length: record.sequence.utf8.count,
                    aliases: aliases,
                    isPrimary: !isMitochondrial,
                    isMitochondrial: isMitochondrial,
                    metrics: nil
                )
            )

            offset = sequenceOffset + record.sequence.utf8.count + 1
        }

        try (fastaLines.joined(separator: "\n") + "\n").write(
            to: fastaURL,
            atomically: true,
            encoding: .utf8
        )
        try (faiLines.joined(separator: "\n") + "\n").write(
            to: faiURL,
            atomically: true,
            encoding: .utf8
        )

        let timestamp = Date(timeIntervalSince1970: 1_713_744_000)
        let manifest = ReferenceBundleManifestFixture(
            formatVersion: "1.0",
            name: bundleName,
            identifier: "org.lungfish.xcui.\(bundleName.lowercased())",
            createdDate: timestamp,
            modifiedDate: timestamp,
            source: ReferenceBundleSourceFixture(
                organism: "Bundle Browser Fixture",
                assembly: "xcui",
                database: "UI Test",
                notes: "Deterministic multi-contig bundle browser fixture"
            ),
            genome: ReferenceBundleGenomeFixture(
                path: "genome/sequence.fa",
                indexPath: "genome/sequence.fa.fai",
                totalLength: records.reduce(0) { $0 + $1.sequence.utf8.count },
                chromosomes: chromosomes
            ),
            annotations: [],
            variants: [],
            tracks: [],
            alignments: [],
            browserSummary: ReferenceBundleBrowserSummaryFixture(
                schemaVersion: 1,
                aggregate: ReferenceBundleBrowserAggregateFixture(
                    annotationTrackCount: 0,
                    variantTrackCount: 0,
                    alignmentTrackCount: 0,
                    totalMappedReads: nil
                ),
                sequences: browserSequences
            )
        )
        try writeJSON(
            manifest,
            to: bundleURL.appendingPathComponent("manifest.json")
        )
    }

    private static func writeJSON<T: Encodable>(_ value: T, to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try encoder.encode(value).write(to: url, options: .atomic)
    }

    private static func aliases(for chromosomeName: String) -> [String] {
        switch chromosomeName {
        case "chr1":
            return ["1"]
        case "chr2":
            return ["2"]
        case "chrM":
            return ["MT"]
        default:
            return []
        }
    }
}
