import Foundation
import LungfishCore
import LungfishIO
import LungfishWorkflow

enum MappingConsensusExportRequestBuilderError: Error {
    case noTargetChromosome
}

struct MappingConsensusExportRequest: Equatable {
    let chromosome: String
    let start: Int
    let end: Int
    let recordName: String
    let suggestedName: String
    let mode: AlignmentConsensusMode
    let minDepth: Int
    let minMapQ: Int
    let minBaseQ: Int
    let excludeFlags: UInt16
    let useAmbiguity: Bool
    let showDeletions: Bool
    let showInsertions: Bool
}

enum MappingConsensusExportRequestBuilder {
    static func build(
        sampleName: String,
        selectedContig: MappingContigSummary?,
        fallbackChromosome: ChromosomeInfo?,
        consensusMode: AlignmentConsensusMode,
        consensusMinDepth: Int,
        consensusMinMapQ: Int,
        consensusMinBaseQ: Int,
        excludeFlags: UInt16,
        useAmbiguity: Bool
    ) throws -> MappingConsensusExportRequest {
        if let contig = selectedContig {
            return MappingConsensusExportRequest(
                chromosome: contig.contigName,
                start: 0,
                end: contig.contigLength,
                recordName: "\(sampleName) \(contig.contigName) consensus",
                suggestedName: "\(sampleName)-\(contig.contigName)-consensus",
                mode: consensusMode,
                minDepth: consensusMinDepth,
                minMapQ: consensusMinMapQ,
                minBaseQ: consensusMinBaseQ,
                excludeFlags: excludeFlags,
                useAmbiguity: useAmbiguity,
                showDeletions: false,
                showInsertions: true
            )
        }

        guard let chromosome = fallbackChromosome else {
            throw MappingConsensusExportRequestBuilderError.noTargetChromosome
        }

        return MappingConsensusExportRequest(
            chromosome: chromosome.name,
            start: 0,
            end: Int(chromosome.length),
            recordName: "\(sampleName) \(chromosome.name) consensus",
            suggestedName: "\(sampleName)-\(chromosome.name)-consensus",
            mode: consensusMode,
            minDepth: consensusMinDepth,
            minMapQ: consensusMinMapQ,
            minBaseQ: consensusMinBaseQ,
            excludeFlags: excludeFlags,
            useAmbiguity: useAmbiguity,
            showDeletions: false,
            showInsertions: true
        )
    }
}
