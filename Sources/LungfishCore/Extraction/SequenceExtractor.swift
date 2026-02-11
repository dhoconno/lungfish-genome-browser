// SequenceExtractor.swift - Sequence extraction from annotations and regions
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

// MARK: - Extraction Request

/// Describes what sequence to extract and how.
public struct ExtractionRequest: Sendable {

    /// The source of the extraction.
    public enum Source: Sendable {
        /// A genomic region defined by coordinates.
        case region(chromosome: String, start: Int, end: Int)
        /// An annotation (may be discontiguous).
        case annotation(SequenceAnnotation)
    }

    /// Where to extract from.
    public let source: Source

    /// Bases of 5' flanking sequence to include.
    public let flank5Prime: Int

    /// Bases of 3' flanking sequence to include.
    public let flank3Prime: Int

    /// Whether to reverse-complement the extracted sequence.
    public let reverseComplement: Bool

    /// For discontiguous annotations: if true, concatenate exons (remove introns).
    public let concatenateExons: Bool

    public init(
        source: Source,
        flank5Prime: Int = 0,
        flank3Prime: Int = 0,
        reverseComplement: Bool = false,
        concatenateExons: Bool = false
    ) {
        self.source = source
        self.flank5Prime = max(0, flank5Prime)
        self.flank3Prime = max(0, flank3Prime)
        self.reverseComplement = reverseComplement
        self.concatenateExons = concatenateExons
    }
}

// MARK: - Extraction Result

/// The result of a sequence extraction.
public struct ExtractionResult: Sendable {

    /// FASTA header line (without the leading ">").
    public let fastaHeader: String

    /// The extracted nucleotide sequence.
    public let nucleotideSequence: String

    /// The translated protein sequence (CDS annotations only).
    public let proteinSequence: String?

    /// Name of the source (annotation name or region description).
    public let sourceName: String

    /// Chromosome the extraction came from.
    public let chromosome: String

    /// Effective start coordinate (including flanking, clamped).
    public let effectiveStart: Int

    /// Effective end coordinate (including flanking, clamped).
    public let effectiveEnd: Int

    /// Whether the sequence was reverse-complemented.
    public let isReverseComplement: Bool

    public init(
        fastaHeader: String,
        nucleotideSequence: String,
        proteinSequence: String?,
        sourceName: String,
        chromosome: String,
        effectiveStart: Int,
        effectiveEnd: Int,
        isReverseComplement: Bool
    ) {
        self.fastaHeader = fastaHeader
        self.nucleotideSequence = nucleotideSequence
        self.proteinSequence = proteinSequence
        self.sourceName = sourceName
        self.chromosome = chromosome
        self.effectiveStart = effectiveStart
        self.effectiveEnd = effectiveEnd
        self.isReverseComplement = isReverseComplement
    }
}

// MARK: - Extraction Errors

public enum ExtractionError: Error, LocalizedError {
    case emptyRegion
    case sequenceNotAvailable(String)
    case chromosomeLengthUnknown(String)

    public var errorDescription: String? {
        switch self {
        case .emptyRegion:
            return "The extraction region is empty."
        case .sequenceNotAvailable(let detail):
            return "Sequence not available: \(detail)"
        case .chromosomeLengthUnknown(let chrom):
            return "Chromosome length unknown for '\(chrom)'."
        }
    }
}

// MARK: - Sequence Extractor

/// Pure extraction logic — no AppKit, testable, reusable by CLI.
public enum SequenceExtractor {

    /// A closure that provides nucleotide sequence for a genomic region.
    /// Parameters: chromosome, start (0-based inclusive), end (0-based exclusive).
    /// Returns the sequence string or nil if unavailable.
    public typealias SequenceProvider = (String, Int, Int) -> String?

    /// Extracts sequence according to the request.
    ///
    /// - Parameters:
    ///   - request: What to extract and how.
    ///   - sequenceProvider: Provides raw nucleotide sequence for a region.
    ///   - chromosomeLength: Length of the chromosome (for clamping flanking).
    /// - Returns: The extraction result.
    /// - Throws: `ExtractionError` if extraction fails.
    public static func extract(
        request: ExtractionRequest,
        sequenceProvider: SequenceProvider,
        chromosomeLength: Int
    ) throws -> ExtractionResult {
        switch request.source {
        case .region(let chromosome, let start, let end):
            return try extractRegion(
                chromosome: chromosome,
                start: start,
                end: end,
                flank5Prime: request.flank5Prime,
                flank3Prime: request.flank3Prime,
                reverseComplement: request.reverseComplement,
                sequenceProvider: sequenceProvider,
                chromosomeLength: chromosomeLength,
                sourceName: "\(chromosome):\(start)-\(end)"
            )

        case .annotation(let annotation):
            return try extractAnnotation(
                annotation: annotation,
                flank5Prime: request.flank5Prime,
                flank3Prime: request.flank3Prime,
                reverseComplement: request.reverseComplement,
                concatenateExons: request.concatenateExons,
                sequenceProvider: sequenceProvider,
                chromosomeLength: chromosomeLength
            )
        }
    }

    /// Formats an extraction result as a FASTA string (nucleotide).
    public static func formatFASTA(_ result: ExtractionResult, lineWidth: Int = 70) -> String {
        var fasta = ">\(result.fastaHeader)\n"
        fasta += wrapSequence(result.nucleotideSequence, lineWidth: lineWidth)
        return fasta
    }

    /// Formats an extraction result as a protein FASTA string.
    /// Returns nil if no protein sequence is available.
    public static func formatProteinFASTA(_ result: ExtractionResult, lineWidth: Int = 70) -> String? {
        guard let protein = result.proteinSequence else { return nil }
        var fasta = ">\(result.fastaHeader) [protein]\n"
        fasta += wrapSequence(protein, lineWidth: lineWidth)
        return fasta
    }

    // MARK: - Private Helpers

    private static func extractRegion(
        chromosome: String,
        start: Int,
        end: Int,
        flank5Prime: Int,
        flank3Prime: Int,
        reverseComplement: Bool,
        sequenceProvider: SequenceProvider,
        chromosomeLength: Int,
        sourceName: String
    ) throws -> ExtractionResult {
        guard end > start else { throw ExtractionError.emptyRegion }

        // Apply flanking, clamped to chromosome bounds
        let effectiveStart = max(0, start - flank5Prime)
        let effectiveEnd = min(chromosomeLength, end + flank3Prime)

        guard let rawSequence = sequenceProvider(chromosome, effectiveStart, effectiveEnd) else {
            throw ExtractionError.sequenceNotAvailable(
                "\(chromosome):\(effectiveStart)-\(effectiveEnd)"
            )
        }

        let nucleotideSequence: String
        if reverseComplement {
            nucleotideSequence = TranslationEngine.reverseComplement(rawSequence)
        } else {
            nucleotideSequence = rawSequence
        }

        let header = buildHeader(
            name: sourceName,
            chromosome: chromosome,
            start: effectiveStart,
            end: effectiveEnd,
            length: nucleotideSequence.count,
            reverseComplement: reverseComplement,
            concatenated: false
        )

        return ExtractionResult(
            fastaHeader: header,
            nucleotideSequence: nucleotideSequence,
            proteinSequence: nil,
            sourceName: sourceName,
            chromosome: chromosome,
            effectiveStart: effectiveStart,
            effectiveEnd: effectiveEnd,
            isReverseComplement: reverseComplement
        )
    }

    private static func extractAnnotation(
        annotation: SequenceAnnotation,
        flank5Prime: Int,
        flank3Prime: Int,
        reverseComplement: Bool,
        concatenateExons: Bool,
        sequenceProvider: SequenceProvider,
        chromosomeLength: Int
    ) throws -> ExtractionResult {
        let chromosome = annotation.chromosome ?? ""
        let sortedIntervals = annotation.intervals.sorted { $0.start < $1.start }
        guard !sortedIntervals.isEmpty else { throw ExtractionError.emptyRegion }

        let boundingStart = sortedIntervals.first!.start
        let boundingEnd = sortedIntervals.last!.end

        let nucleotideSequence: String
        let effectiveStart: Int
        let effectiveEnd: Int
        let isConcatenated: Bool

        if annotation.isDiscontinuous && concatenateExons {
            // Concatenate exon sequences, add flanking to outer bounds
            let flankStart = max(0, boundingStart - flank5Prime)
            let flankEnd = min(chromosomeLength, boundingEnd + flank3Prime)
            effectiveStart = flankStart
            effectiveEnd = flankEnd

            var parts: [String] = []

            // 5' flanking
            if flank5Prime > 0 && flankStart < boundingStart {
                if let flankSeq = sequenceProvider(chromosome, flankStart, boundingStart) {
                    parts.append(flankSeq)
                }
            }

            // Exon sequences
            for interval in sortedIntervals {
                guard let exonSeq = sequenceProvider(chromosome, interval.start, interval.end) else {
                    throw ExtractionError.sequenceNotAvailable(
                        "\(chromosome):\(interval.start)-\(interval.end)"
                    )
                }
                parts.append(exonSeq)
            }

            // 3' flanking
            if flank3Prime > 0 && boundingEnd < flankEnd {
                if let flankSeq = sequenceProvider(chromosome, boundingEnd, flankEnd) {
                    parts.append(flankSeq)
                }
            }

            nucleotideSequence = parts.joined()
            isConcatenated = true
        } else {
            // Contiguous: fetch full bounding region + flanking
            effectiveStart = max(0, boundingStart - flank5Prime)
            effectiveEnd = min(chromosomeLength, boundingEnd + flank3Prime)

            guard let rawSequence = sequenceProvider(chromosome, effectiveStart, effectiveEnd) else {
                throw ExtractionError.sequenceNotAvailable(
                    "\(chromosome):\(effectiveStart)-\(effectiveEnd)"
                )
            }
            nucleotideSequence = rawSequence
            isConcatenated = false
        }

        // Apply reverse complement if requested
        let finalSequence: String
        if reverseComplement {
            finalSequence = TranslationEngine.reverseComplement(nucleotideSequence)
        } else {
            finalSequence = nucleotideSequence
        }

        // CDS translation
        let proteinSequence: String?
        if annotation.type == .cds {
            let result = TranslationEngine.translateCDS(
                annotation: annotation,
                sequenceProvider: { start, end in
                    sequenceProvider(chromosome, start, end)
                }
            )
            proteinSequence = result?.protein
        } else {
            proteinSequence = nil
        }

        let header = buildHeader(
            name: annotation.name,
            chromosome: chromosome,
            start: effectiveStart,
            end: effectiveEnd,
            length: finalSequence.count,
            reverseComplement: reverseComplement,
            concatenated: isConcatenated,
            strand: annotation.strand,
            annotationType: annotation.type
        )

        return ExtractionResult(
            fastaHeader: header,
            nucleotideSequence: finalSequence,
            proteinSequence: proteinSequence,
            sourceName: annotation.name,
            chromosome: chromosome,
            effectiveStart: effectiveStart,
            effectiveEnd: effectiveEnd,
            isReverseComplement: reverseComplement
        )
    }

    private static func buildHeader(
        name: String,
        chromosome: String,
        start: Int,
        end: Int,
        length: Int,
        reverseComplement: Bool,
        concatenated: Bool,
        strand: Strand? = nil,
        annotationType: AnnotationType? = nil
    ) -> String {
        var parts = [name]
        parts.append("[\(chromosome):\(start)-\(end)]")

        if let type = annotationType {
            parts.append("[\(type.rawValue)]")
        }

        if let strand = strand, strand != .unknown {
            parts.append("[strand: \(strand.rawValue)]")
        }

        if reverseComplement {
            parts.append("[reverse complement]")
        }

        if concatenated {
            parts.append("[exons concatenated]")
        }

        parts.append("[\(length) bp]")

        return parts.joined(separator: " ")
    }

    private static func wrapSequence(_ sequence: String, lineWidth: Int) -> String {
        guard lineWidth > 0 else { return sequence + "\n" }
        var result = ""
        var index = sequence.startIndex
        while index < sequence.endIndex {
            let end = sequence.index(index, offsetBy: lineWidth, limitedBy: sequence.endIndex) ?? sequence.endIndex
            result += sequence[index..<end]
            result += "\n"
            index = end
        }
        return result
    }
}
