import Foundation
import LungfishCore
import LungfishWorkflow

public struct BundleAlignmentFixture: Sendable {
    public let bundleURL: URL
    public let mappingResultURL: URL?
    public let sourceTrackID: String
    public let sourceTrackName: String
    public let sourceBAMURL: URL
    public let sourceIndexURL: URL

    public init(
        bundleURL: URL,
        mappingResultURL: URL?,
        sourceTrackID: String,
        sourceTrackName: String,
        sourceBAMURL: URL,
        sourceIndexURL: URL
    ) {
        self.bundleURL = bundleURL
        self.mappingResultURL = mappingResultURL
        self.sourceTrackID = sourceTrackID
        self.sourceTrackName = sourceTrackName
        self.sourceBAMURL = sourceBAMURL
        self.sourceIndexURL = sourceIndexURL
    }

    public static func make(
        rootURL: URL,
        samtoolsPath: URL,
        includeMappingResult: Bool
    ) throws -> BundleAlignmentFixture {
        let fileManager = FileManager.default
        let bundleURL = rootURL.appendingPathComponent(
            "BundleAlignmentFixture-\(UUID().uuidString).lungfishref",
            isDirectory: true
        )
        let alignmentsURL = bundleURL.appendingPathComponent("alignments", isDirectory: true)
        try fileManager.createDirectory(at: alignmentsURL, withIntermediateDirectories: true)

        let sourceTrackID = "aln-source"
        let sourceTrackName = "Fixture BAM"
        let sourceBAMURL = alignmentsURL.appendingPathComponent("source.bam")
        let sourceIndexURL = alignmentsURL.appendingPathComponent("source.bam.bai")
        try BamFixtureBuilder.makeBAM(
            at: sourceBAMURL,
            references: [BamFixtureBuilder.Reference(name: "chr1", length: 1000)],
            reads: makeReads(),
            samtoolsPath: samtoolsPath
        )

        let manifest = BundleManifest(
            formatVersion: "1.0",
            name: "Bundle Alignment Fixture",
            identifier: "bundle-alignment-fixture.\(UUID().uuidString)",
            source: SourceInfo(
                organism: "Fixture organism",
                assembly: "Fixture assembly",
                database: "Fixture database"
            ),
            genome: nil,
            alignments: [
                AlignmentTrackInfo(
                    id: sourceTrackID,
                    name: sourceTrackName,
                    format: .bam,
                    sourcePath: "alignments/source.bam",
                    indexPath: "alignments/source.bam.bai"
                )
            ]
        )
        try manifest.save(to: bundleURL)

        let mappingResultURL: URL?
        if includeMappingResult {
            let resultDirectory = rootURL.appendingPathComponent(
                "mapping-result-\(UUID().uuidString)",
                isDirectory: true
            )
            try fileManager.createDirectory(at: resultDirectory, withIntermediateDirectories: true)
            try makeMappingResult(
                bundleURL: bundleURL,
                sourceBAMURL: sourceBAMURL,
                sourceIndexURL: sourceIndexURL
            ).save(to: resultDirectory)
            mappingResultURL = resultDirectory
        } else {
            mappingResultURL = nil
        }

        return BundleAlignmentFixture(
            bundleURL: bundleURL,
            mappingResultURL: mappingResultURL,
            sourceTrackID: sourceTrackID,
            sourceTrackName: sourceTrackName,
            sourceBAMURL: sourceBAMURL,
            sourceIndexURL: sourceIndexURL
        )
    }

    private static func makeReads() -> [BamFixtureBuilder.Read] {
        let sequence = String(repeating: "A", count: 50)
        let quality = String(repeating: "I", count: 50)

        return [
            BamFixtureBuilder.Read(
                qname: "mapped-primary-highmapq",
                flag: 0,
                rname: "chr1",
                pos: 100,
                mapq: 60,
                cigar: "50M",
                seq: sequence,
                qual: quality,
                optionalFields: ["NM:i:0"]
            ),
            BamFixtureBuilder.Read(
                qname: "mapped-primary-lowmapq",
                flag: 0,
                rname: "chr1",
                pos: 200,
                mapq: 20,
                cigar: "50M",
                seq: sequence,
                qual: quality,
                optionalFields: ["NM:i:1"]
            ),
            BamFixtureBuilder.Read(
                qname: "mapped-secondary",
                flag: 0x100,
                rname: "chr1",
                pos: 300,
                mapq: 50,
                cigar: "50M",
                seq: sequence,
                qual: quality,
                optionalFields: ["NM:i:0"]
            ),
            BamFixtureBuilder.Read(
                qname: "unmapped-read",
                flag: 0x4,
                rname: "*",
                pos: 0,
                mapq: 0,
                cigar: "*",
                seq: sequence,
                qual: quality
            ),
        ]
    }

    private static func makeMappingResult(
        bundleURL: URL,
        sourceBAMURL: URL,
        sourceIndexURL: URL
    ) -> MappingResult {
        MappingResult(
            mapper: .minimap2,
            modeID: MappingMode.defaultShortRead.id,
            sourceReferenceBundleURL: bundleURL,
            viewerBundleURL: bundleURL,
            bamURL: sourceBAMURL,
            baiURL: sourceIndexURL,
            totalReads: 4,
            mappedReads: 3,
            unmappedReads: 1,
            wallClockSeconds: 0.25,
            contigs: [
                MappingContigSummary(
                    contigName: "chr1",
                    contigLength: 1000,
                    mappedReads: 3,
                    mappedReadPercent: 75.0,
                    meanDepth: 0.15,
                    coverageBreadth: 0.15,
                    medianMAPQ: 50,
                    meanIdentity: 99.0
                )
            ]
        )
    }
}
