// FASTQDerivatives.swift - Pointer-based FASTQ derivative datasets
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

/// Field used for read lookup operations.
public enum FASTQSearchField: String, Codable, Sendable, CaseIterable {
    case id
    case description
}

/// Deduplication key strategy.
public enum FASTQDeduplicateMode: String, Codable, Sendable, CaseIterable {
    case identifier
    case description
    case sequence
}

/// Adapter location for trimming.
public enum FASTQAdapterLocation: String, Codable, Sendable, CaseIterable {
    case fivePrime
    case threePrime
    case both
}

/// Contaminant reference mode for bbduk filtering.
public enum FASTQContaminantFilterMode: String, Codable, Sendable, CaseIterable {
    /// PhiX spike-in (bundled with bbtools).
    case phix
    /// User-supplied reference FASTA.
    case custom
}

/// Primer source for bbduk primer removal.
public enum FASTQPrimerSource: String, Codable, Sendable, CaseIterable {
    /// User-provided literal nucleotide sequence.
    case literal
    /// User-provided reference FASTA file.
    case reference
}

/// Interleave/deinterleave direction for reformat.sh.
public enum FASTQInterleaveDirection: String, Codable, Sendable, CaseIterable {
    /// Two files -> one interleaved file.
    case interleave
    /// One interleaved file -> two files.
    case deinterleave
}

/// PE merge strictness mode.
public enum FASTQMergeStrictness: String, Codable, Sendable, CaseIterable {
    /// Standard merge (default bbmerge behaviour).
    case normal
    /// Strict merge — fewer false positive merges.
    case strict
}

/// Quality trimming directionality.
public enum FASTQQualityTrimMode: String, Codable, Sendable, CaseIterable {
    /// Scan from 3' end inward (fastp --cut_right, Trimmomatic SLIDINGWINDOW).
    case cutRight
    /// Scan from 5' end inward (fastp --cut_front).
    case cutFront
    /// Trim low-quality tails only (fastp --cut_tail).
    case cutTail
    /// Trim from both ends.
    case cutBoth
}

/// Adapter removal detection mode.
public enum FASTQAdapterMode: String, Codable, Sendable, CaseIterable {
    /// Auto-detect adapters from read overlap patterns.
    case autoDetect
    /// User-specified adapter sequence(s).
    case specified
    /// Adapter sequences from a FASTA file.
    case fastaFile
}

/// What a derivative bundle stores on disk — enforces correct filename pairing.
public enum FASTQDerivativePayload: Codable, Sendable, Equatable {
    /// Stores a read ID list file (subset operations).
    case subset(readIDListFilename: String)
    /// Stores a trim positions TSV file (trim operations).
    case trim(trimPositionFilename: String)
    /// Stores a full materialized FASTQ file (content-transforming operations like PE merge/repair).
    case full(fastqFilename: String)
    /// Stores paired R1/R2 FASTQ files (deinterleave produces two files from one).
    case fullPaired(r1Filename: String, r2Filename: String)
    /// Stores multiple FASTQ files with classified roles (after merge/repair producing mixed read types).
    case fullMixed(ReadClassification)
    /// A virtual demuxed barcode bundle: stores a read ID list and a small preview FASTQ,
    /// referencing the root FASTQ for full materialization on demand.
    case demuxedVirtual(barcodeID: String, readIDListFilename: String, previewFilename: String)
    /// The demux group directory containing all per-barcode bundles.
    case demuxGroup(barcodeCount: Int)

    /// The category for display purposes.
    public var category: String {
        switch self {
        case .subset: return "subset"
        case .trim: return "trim"
        case .full: return "full"
        case .fullPaired: return "full-paired"
        case .fullMixed: return "full-mixed"
        case .demuxedVirtual: return "demuxed-virtual"
        case .demuxGroup: return "demux-group"
        }
    }
}

/// Transformation used to create a derived FASTQ pointer dataset.
public enum FASTQDerivativeOperationKind: String, Codable, Sendable, CaseIterable {
    // Subset operations (produce read ID list)
    case subsampleProportion
    case subsampleCount
    case lengthFilter
    case searchText
    case searchMotif
    case deduplicate

    // Trim operations (produce trim position records)
    case qualityTrim
    case adapterTrim
    case fixedTrim

    // BBTools operations
    case contaminantFilter
    case pairedEndMerge
    case pairedEndRepair
    case primerRemoval
    case errorCorrection
    case interleaveReformat

    // Demultiplexing
    case demultiplex

    /// Whether this operation produces a subset (read IDs) or trim (positions).
    public var isSubsetOperation: Bool {
        switch self {
        case .subsampleProportion, .subsampleCount, .lengthFilter,
             .searchText, .searchMotif, .deduplicate, .contaminantFilter:
            return true
        case .qualityTrim, .adapterTrim, .fixedTrim:
            return false
        case .pairedEndMerge, .pairedEndRepair, .primerRemoval,
             .errorCorrection, .interleaveReformat, .demultiplex:
            return false
        }
    }

    /// Whether this operation produces a full materialized FASTQ (content-transforming).
    public var isFullOperation: Bool {
        switch self {
        case .pairedEndMerge, .pairedEndRepair, .primerRemoval,
             .errorCorrection, .interleaveReformat, .demultiplex:
            return true
        default:
            return false
        }
    }
}

/// Serializable operation configuration for derived FASTQ datasets.
public struct FASTQDerivativeOperation: Codable, Sendable, Equatable {
    public let kind: FASTQDerivativeOperationKind
    public let createdAt: Date

    // Generic optional parameter payload for lightweight persistence.

    // Subset parameters
    public var proportion: Double?
    public var count: Int?
    public var minLength: Int?
    public var maxLength: Int?
    public var query: String?
    public var searchField: FASTQSearchField?
    public var useRegex: Bool?
    public var deduplicateMode: FASTQDeduplicateMode?
    public var pairedAware: Bool?

    // Quality trim parameters
    public var qualityThreshold: Int?
    public var windowSize: Int?
    public var qualityTrimMode: FASTQQualityTrimMode?

    // Adapter trim parameters
    public var adapterMode: FASTQAdapterMode?
    public var adapterSequence: String?
    public var adapterSequenceR2: String?
    public var adapterFastaFilename: String?

    // Fixed trim parameters
    public var trimFrom5Prime: Int?
    public var trimFrom3Prime: Int?

    // Contaminant filter parameters
    public var contaminantFilterMode: FASTQContaminantFilterMode?
    public var contaminantReferenceFasta: String?
    public var contaminantKmerSize: Int?
    public var contaminantHammingDistance: Int?

    // PE merge parameters
    public var mergeStrictness: FASTQMergeStrictness?
    public var mergeMinOverlap: Int?

    // Primer removal parameters
    public var primerSource: FASTQPrimerSource?
    public var primerLiteralSequence: String?
    public var primerReferenceFasta: String?
    public var primerKmerSize: Int?
    public var primerMinKmer: Int?
    public var primerHammingDistance: Int?

    // Error correction parameters
    public var errorCorrectionKmerSize: Int?

    // Interleave parameters
    public var interleaveDirection: FASTQInterleaveDirection?

    // Demultiplex parameters
    public var barcodeID: String?
    public var sampleName: String?
    public var demuxRunID: UUID?

    /// Which external tool performed the operation (for provenance).
    public var toolUsed: String?

    /// Raw command-line invocation for full reproducibility.
    public var toolCommand: String?

    public init(
        kind: FASTQDerivativeOperationKind,
        createdAt: Date = Date(),
        proportion: Double? = nil,
        count: Int? = nil,
        minLength: Int? = nil,
        maxLength: Int? = nil,
        query: String? = nil,
        searchField: FASTQSearchField? = nil,
        useRegex: Bool? = nil,
        deduplicateMode: FASTQDeduplicateMode? = nil,
        pairedAware: Bool? = nil,
        qualityThreshold: Int? = nil,
        windowSize: Int? = nil,
        qualityTrimMode: FASTQQualityTrimMode? = nil,
        adapterMode: FASTQAdapterMode? = nil,
        adapterSequence: String? = nil,
        adapterSequenceR2: String? = nil,
        adapterFastaFilename: String? = nil,
        trimFrom5Prime: Int? = nil,
        trimFrom3Prime: Int? = nil,
        contaminantFilterMode: FASTQContaminantFilterMode? = nil,
        contaminantReferenceFasta: String? = nil,
        contaminantKmerSize: Int? = nil,
        contaminantHammingDistance: Int? = nil,
        mergeStrictness: FASTQMergeStrictness? = nil,
        mergeMinOverlap: Int? = nil,
        primerSource: FASTQPrimerSource? = nil,
        primerLiteralSequence: String? = nil,
        primerReferenceFasta: String? = nil,
        primerKmerSize: Int? = nil,
        primerMinKmer: Int? = nil,
        primerHammingDistance: Int? = nil,
        errorCorrectionKmerSize: Int? = nil,
        interleaveDirection: FASTQInterleaveDirection? = nil,
        barcodeID: String? = nil,
        sampleName: String? = nil,
        demuxRunID: UUID? = nil,
        toolUsed: String? = nil,
        toolCommand: String? = nil
    ) {
        self.kind = kind
        self.createdAt = createdAt
        self.proportion = proportion
        self.count = count
        self.minLength = minLength
        self.maxLength = maxLength
        self.query = query
        self.searchField = searchField
        self.useRegex = useRegex
        self.deduplicateMode = deduplicateMode
        self.pairedAware = pairedAware
        self.qualityThreshold = qualityThreshold
        self.windowSize = windowSize
        self.qualityTrimMode = qualityTrimMode
        self.adapterMode = adapterMode
        self.adapterSequence = adapterSequence
        self.adapterSequenceR2 = adapterSequenceR2
        self.adapterFastaFilename = adapterFastaFilename
        self.trimFrom5Prime = trimFrom5Prime
        self.trimFrom3Prime = trimFrom3Prime
        self.contaminantFilterMode = contaminantFilterMode
        self.contaminantReferenceFasta = contaminantReferenceFasta
        self.contaminantKmerSize = contaminantKmerSize
        self.contaminantHammingDistance = contaminantHammingDistance
        self.mergeStrictness = mergeStrictness
        self.mergeMinOverlap = mergeMinOverlap
        self.primerSource = primerSource
        self.primerLiteralSequence = primerLiteralSequence
        self.primerReferenceFasta = primerReferenceFasta
        self.primerKmerSize = primerKmerSize
        self.primerMinKmer = primerMinKmer
        self.primerHammingDistance = primerHammingDistance
        self.errorCorrectionKmerSize = errorCorrectionKmerSize
        self.interleaveDirection = interleaveDirection
        self.barcodeID = barcodeID
        self.sampleName = sampleName
        self.demuxRunID = demuxRunID
        self.toolUsed = toolUsed
        self.toolCommand = toolCommand
    }

    public var shortLabel: String {
        switch kind {
        case .subsampleProportion:
            if let proportion {
                return String(format: "subsample-p%.4f", proportion)
            }
            return "subsample-proportion"
        case .subsampleCount:
            if let count {
                return "subsample-n\(count)"
            }
            return "subsample-count"
        case .lengthFilter:
            let minString = minLength.map(String.init) ?? "any"
            let maxString = maxLength.map(String.init) ?? "any"
            return "len-\(minString)-\(maxString)"
        case .searchText:
            return "search-text"
        case .searchMotif:
            return "search-motif"
        case .deduplicate:
            return "dedup"
        case .qualityTrim:
            let q = qualityThreshold ?? 20
            return "qtrim-Q\(q)"
        case .adapterTrim:
            return "adapter-trim"
        case .fixedTrim:
            let f = trimFrom5Prime ?? 0
            let t = trimFrom3Prime ?? 0
            return "trim-\(f)-\(t)"
        case .contaminantFilter:
            let mode = contaminantFilterMode ?? .phix
            return "contaminant-\(mode.rawValue)"
        case .pairedEndMerge:
            let s = mergeStrictness ?? .normal
            return "merge-\(s.rawValue)"
        case .pairedEndRepair:
            return "repair"
        case .primerRemoval:
            let src = primerSource ?? .literal
            let k = primerKmerSize ?? 23
            return "primer-\(src.rawValue)-k\(k)"
        case .errorCorrection:
            let k = errorCorrectionKmerSize ?? 50
            return "ecc-k\(k)"
        case .interleaveReformat:
            let dir = interleaveDirection ?? .interleave
            return "\(dir.rawValue)"
        case .demultiplex:
            if let barcodeID {
                return "demux-\(barcodeID)"
            }
            return "demultiplex"
        }
    }

    public var displaySummary: String {
        switch kind {
        case .subsampleProportion:
            if let proportion {
                return "Subsample by proportion (\(String(format: "%.4f", proportion)))"
            }
            return "Subsample by proportion"
        case .subsampleCount:
            if let count {
                return "Subsample \(count) reads"
            }
            return "Subsample by count"
        case .lengthFilter:
            let minString = minLength.map(String.init) ?? "-"
            let maxString = maxLength.map(String.init) ?? "-"
            return "Length filter (min: \(minString), max: \(maxString))"
        case .searchText:
            let fieldString = searchField?.rawValue ?? "id"
            let queryString = query ?? ""
            return "Search \(fieldString): \(queryString)"
        case .searchMotif:
            let queryString = query ?? ""
            return "Motif search: \(queryString)"
        case .deduplicate:
            let modeString = deduplicateMode?.rawValue ?? FASTQDeduplicateMode.identifier.rawValue
            if pairedAware == true {
                return "Deduplicate by \(modeString) (paired-aware)"
            }
            return "Deduplicate by \(modeString)"
        case .qualityTrim:
            let q = qualityThreshold ?? 20
            let w = windowSize ?? 4
            let mode = qualityTrimMode ?? .cutRight
            return "Quality trim Q\(q) w\(w) (\(mode.rawValue))"
        case .adapterTrim:
            let mode = adapterMode ?? .autoDetect
            switch mode {
            case .autoDetect:
                return "Adapter removal (auto-detect)"
            case .specified:
                let seq = adapterSequence ?? ""
                let preview = seq.prefix(20)
                return "Adapter removal (\(preview)\(seq.count > 20 ? "…" : ""))"
            case .fastaFile:
                return "Adapter removal (FASTA file)"
            }
        case .fixedTrim:
            let f = trimFrom5Prime ?? 0
            let t = trimFrom3Prime ?? 0
            return "Fixed trim (5': \(f) bp, 3': \(t) bp)"
        case .contaminantFilter:
            let mode = contaminantFilterMode ?? .phix
            switch mode {
            case .phix:
                return "Contaminant filter (PhiX)"
            case .custom:
                let ref = contaminantReferenceFasta ?? "custom"
                return "Contaminant filter (\(ref))"
            }
        case .pairedEndMerge:
            let s = mergeStrictness ?? .normal
            let o = mergeMinOverlap ?? 12
            return "PE merge (\(s.rawValue), min overlap: \(o))"
        case .pairedEndRepair:
            return "PE read repair"
        case .primerRemoval:
            let src = primerSource ?? .literal
            let k = primerKmerSize ?? 23
            switch src {
            case .literal:
                let seq = primerLiteralSequence ?? ""
                let preview = seq.prefix(20)
                return "Primer removal (literal: \(preview)\(seq.count > 20 ? "…" : ""), k=\(k))"
            case .reference:
                let ref = primerReferenceFasta ?? "reference"
                return "Primer removal (ref: \(ref), k=\(k))"
            }
        case .errorCorrection:
            let k = errorCorrectionKmerSize ?? 50
            return "Error correction (k=\(k))"
        case .interleaveReformat:
            let dir = interleaveDirection ?? .interleave
            switch dir {
            case .interleave:
                return "Interleave R1/R2"
            case .deinterleave:
                return "Deinterleave to R1/R2"
            }
        case .demultiplex:
            if let barcodeID {
                let label = sampleName ?? barcodeID
                return "Demultiplex → \(label)"
            }
            return "Demultiplex"
        }
    }
}

// MARK: - Trim Position Record

/// A single read's trim boundaries, referencing positions in the root FASTQ sequence.
public struct FASTQTrimRecord: Sendable, Equatable {
    /// Normalized read identifier.
    public let readID: String
    /// 0-based inclusive start position in the original sequence.
    public let trimStart: Int
    /// Exclusive end position in the original sequence.
    public let trimEnd: Int

    public init(readID: String, trimStart: Int, trimEnd: Int) {
        precondition(trimStart >= 0, "trimStart must be non-negative")
        precondition(trimEnd >= 0, "trimEnd must be non-negative")
        self.readID = readID
        self.trimStart = trimStart
        self.trimEnd = trimEnd
    }

    /// The length of the trimmed subsequence.
    public var trimmedLength: Int { max(0, trimEnd - trimStart) }
}

// MARK: - Trim Position File I/O

/// Reads and writes `trim-positions.tsv` files used by trim derivative bundles.
public enum FASTQTrimPositionFile {

    /// Writes trim records to a TSV file. Format: `readID\ttrimStart\ttrimEnd\n`
    ///
    /// Uses streaming FileHandle writes to avoid building the entire file in memory.
    public static func write(_ records: [FASTQTrimRecord], to url: URL) throws {
        FileManager.default.createFile(atPath: url.path, contents: nil)
        let handle = try FileHandle(forWritingTo: url)
        defer { try? handle.close() }
        for record in records {
            guard let data = "\(record.readID)\t\(record.trimStart)\t\(record.trimEnd)\n"
                .data(using: .utf8) else { continue }
            handle.write(data)
        }
    }

    /// Loads trim records from a TSV file into a dictionary keyed by read ID.
    /// Records with invalid ranges (start < 0, end < 0, or start > end) are skipped.
    public static func load(from url: URL) throws -> [String: (start: Int, end: Int)] {
        let content = try String(contentsOf: url, encoding: .utf8)
        var positions: [String: (Int, Int)] = [:]
        for line in content.split(separator: "\n", omittingEmptySubsequences: true) {
            let fields = line.split(separator: "\t")
            guard fields.count >= 3,
                  let start = Int(fields[1]),
                  let end = Int(fields[2]),
                  start >= 0, end >= 0, end > start else { continue }
            positions[String(fields[0])] = (start, end)
        }
        return positions
    }

    /// Loads trim records as an array (preserving order).
    /// Records with invalid ranges (start < 0, end < 0, or start > end) are skipped.
    public static func loadRecords(from url: URL) throws -> [FASTQTrimRecord] {
        let content = try String(contentsOf: url, encoding: .utf8)
        var records: [FASTQTrimRecord] = []
        for line in content.split(separator: "\n", omittingEmptySubsequences: true) {
            let fields = line.split(separator: "\t")
            guard fields.count >= 3,
                  let start = Int(fields[1]),
                  let end = Int(fields[2]),
                  start >= 0, end >= 0, end > start else { continue }
            records.append(FASTQTrimRecord(readID: String(fields[0]), trimStart: start, trimEnd: end))
        }
        return records
    }

    /// Composes two sets of trim positions.
    ///
    /// When a trim-of-trim chain exists, child positions are relative to the parent's
    /// trimmed sequence. This computes absolute positions relative to the root FASTQ.
    ///
    /// - Parameters:
    ///   - parent: Trim positions from the parent operation (absolute, relative to root).
    ///   - child: Trim positions from the child operation (relative to parent's trimmed output).
    /// - Returns: Composed absolute positions for reads present in both sets.
    public static func compose(
        parent: [String: (start: Int, end: Int)],
        child: [String: (start: Int, end: Int)]
    ) -> [String: (start: Int, end: Int)] {
        var result: [String: (start: Int, end: Int)] = [:]
        for (readID, childPos) in child {
            guard let parentPos = parent[readID] else { continue }
            let absoluteStart = parentPos.start + childPos.start
            let absoluteEnd = min(parentPos.start + childPos.end, parentPos.end)
            guard absoluteEnd > absoluteStart else { continue }
            result[readID] = (absoluteStart, absoluteEnd)
        }
        return result
    }
}

// MARK: - Derived Bundle Manifest

/// Pointer manifest saved in derived `.lungfishfastq` bundles.
///
/// Derived bundles do not duplicate FASTQ payload bytes. They store either
/// a read ID list (subset operations) or trim position records (trim operations),
/// plus lineage metadata pointing back to a parent/root bundle.
public struct FASTQDerivedBundleManifest: Codable, Sendable, Equatable {
    public let id: UUID
    public let name: String
    public let createdAt: Date

    /// Relative path from this bundle to the immediate parent bundle.
    public let parentBundleRelativePath: String

    /// Relative path from this bundle to the root (physical FASTQ payload) bundle.
    public let rootBundleRelativePath: String

    /// FASTQ filename inside the root bundle.
    public let rootFASTQFilename: String

    /// What this derivative stores on disk (read ID list or trim positions).
    public let payload: FASTQDerivativePayload

    /// Sequence of operations from root to this dataset (inclusive of latest operation).
    public let lineage: [FASTQDerivativeOperation]

    /// Latest operation used to produce this dataset.
    public let operation: FASTQDerivativeOperation

    /// Cached dataset statistics for immediate dashboard/inspector rendering.
    public let cachedStatistics: FASTQDatasetStatistics

    /// Pairing mode inherited at generation time.
    public let pairingMode: IngestionMetadata.PairingMode?

    /// Read classification for mixed-type bundles (after merge/repair).
    /// Nil for homogeneous bundles.
    public let readClassification: ReadClassification?

    /// Batch operation ID linking this bundle to a batch processing run.
    /// Nil for individually-created derivatives.
    public let batchOperationID: UUID?

    public init(
        id: UUID = UUID(),
        name: String,
        createdAt: Date = Date(),
        parentBundleRelativePath: String,
        rootBundleRelativePath: String,
        rootFASTQFilename: String,
        payload: FASTQDerivativePayload = .subset(readIDListFilename: "read-ids.txt"),
        lineage: [FASTQDerivativeOperation],
        operation: FASTQDerivativeOperation,
        cachedStatistics: FASTQDatasetStatistics,
        pairingMode: IngestionMetadata.PairingMode?,
        readClassification: ReadClassification? = nil,
        batchOperationID: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.parentBundleRelativePath = parentBundleRelativePath
        self.rootBundleRelativePath = rootBundleRelativePath
        self.rootFASTQFilename = rootFASTQFilename
        self.payload = payload
        self.lineage = lineage
        self.operation = operation
        self.cachedStatistics = cachedStatistics
        self.pairingMode = pairingMode
        self.readClassification = readClassification
        self.batchOperationID = batchOperationID
    }

}
