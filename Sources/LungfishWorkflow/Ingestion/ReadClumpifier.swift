// ReadClumpifier.swift - Native Swift read reordering and quality binning
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishIO
import os.log

private let logger = Logger(subsystem: "com.lungfish.workflow", category: "ReadClumpifier")

// MARK: - QualityBinningScheme

/// Quality score binning schemes for FASTQ compression optimization.
///
/// Binning reduces the alphabet of quality characters from ~42 possible values
/// to a small number of bins. This dramatically improves gzip compression
/// because the quality string becomes much more repetitive.
///
/// All schemes preserve enough resolution for variant calling and QC.
public enum QualityBinningScheme: String, Sendable, CaseIterable, Codable {

    /// Illumina NovaSeq/NovaSeqX native binning (4 levels).
    /// Bins: 2 (low), 12 (medium-low), 23 (medium), 37 (high)
    case illumina4

    /// 8-level binning — good balance of compression and resolution.
    /// Preserves Q20/Q30 boundaries important for variant calling.
    case eightLevel

    /// No binning — preserve original quality scores.
    case none

    /// Maps a Phred quality value (0-93) to its binned representative.
    func bin(_ quality: UInt8) -> UInt8 {
        switch self {
        case .none:
            return quality

        case .illumina4:
            // NovaSeq-style 4-bin scheme
            // 0-9 → 2, 10-19 → 12, 20-29 → 23, 30+ → 37
            if quality < 10 { return 2 }
            if quality < 20 { return 12 }
            if quality < 30 { return 23 }
            return 37

        case .eightLevel:
            // 8-bin scheme preserving Q20/Q30 thresholds
            // 0-5 → 2, 6-9 → 6, 10-14 → 10, 15-19 → 15,
            // 20-24 → 20, 25-29 → 27, 30-34 → 33, 35+ → 37
            if quality < 6 { return 2 }
            if quality < 10 { return 6 }
            if quality < 15 { return 10 }
            if quality < 20 { return 15 }
            if quality < 25 { return 20 }
            if quality < 30 { return 27 }
            if quality < 35 { return 33 }
            return 37
        }
    }

    /// Builds a 94-element lookup table for fast binning.
    func buildLookupTable() -> [UInt8] {
        (0..<94).map { bin(UInt8($0)) }
    }

    /// Display name for UI.
    public var displayName: String {
        switch self {
        case .illumina4: return "Illumina 4-bin (NovaSeq)"
        case .eightLevel: return "8-level"
        case .none: return "None (preserve original)"
        }
    }
}

// MARK: - ReadClumpifier

/// Reorders FASTQ reads by k-mer similarity and applies quality binning
/// to maximize gzip compression ratio.
///
/// **Algorithm:**
/// 1. Read all FASTQ records, extracting a canonical k-mer hash per read
/// 2. Optionally bin quality scores to reduce alphabet size
/// 3. Sort reads by k-mer hash so similar sequences are adjacent
/// 4. Write sorted (and optionally binned) reads
///
/// Similar reads placed adjacently let gzip's LZ77 sliding window find
/// long repeated matches, dramatically improving compression.
///
/// **Memory:** Loads all reads into memory. For a typical FASTQ (~10M reads,
/// ~150bp each), this uses ~3-4 GB. The pipeline already caps ingestion at
/// reasonable file sizes via the caller.
public final class ReadClumpifier: @unchecked Sendable {

    /// K-mer size for hashing. 31 is standard for short reads.
    private let kmerSize: Int

    /// Quality binning scheme.
    public let binningScheme: QualityBinningScheme

    /// Pre-computed 2-bit encoding table for bases.
    /// A=0, C=1, G=2, T=3, other=0xFF (invalid)
    private static let baseTable: [UInt8] = {
        var table = [UInt8](repeating: 0xFF, count: 256)
        table[Int(UInt8(ascii: "A"))] = 0
        table[Int(UInt8(ascii: "a"))] = 0
        table[Int(UInt8(ascii: "C"))] = 1
        table[Int(UInt8(ascii: "c"))] = 1
        table[Int(UInt8(ascii: "G"))] = 2
        table[Int(UInt8(ascii: "g"))] = 2
        table[Int(UInt8(ascii: "T"))] = 3
        table[Int(UInt8(ascii: "t"))] = 3
        return table
    }()

    /// Creates a ReadClumpifier.
    ///
    /// - Parameters:
    ///   - kmerSize: K-mer size for hashing (default: 31)
    ///   - binningScheme: Quality binning scheme (default: .illumina4)
    public init(
        kmerSize: Int = 31,
        binningScheme: QualityBinningScheme = .illumina4
    ) {
        self.kmerSize = kmerSize
        self.binningScheme = binningScheme
    }

    // MARK: - Public API

    /// Processes a FASTQ file: reorders reads by k-mer hash and bins quality scores.
    ///
    /// - Parameters:
    ///   - inputFile: Input FASTQ file (plain or gzipped)
    ///   - outputFile: Output FASTQ file (plain text — caller handles compression)
    ///   - progress: Progress callback (fraction 0-1, status message)
    /// - Returns: Statistics about the processing
    public func process(
        inputFile: URL,
        outputFile: URL,
        progress: @escaping @Sendable (Double, String) -> Void
    ) async throws -> ClumpifyResult {
        let startTime = Date()

        let attrs = try FileManager.default.attributesOfItem(atPath: inputFile.path)
        let fileSize = (attrs[.size] as? Int64) ?? 0

        logger.info("Processing \(inputFile.lastPathComponent): \(fileSize) bytes")

        progress(0.0, "Reading FASTQ records...")

        // Phase 1: Read all records with k-mer hashes (40% of progress)
        let records = try await readRecords(from: inputFile, fileSize: fileSize, progress: { frac, msg in
            progress(frac * 0.4, msg)
        })

        try Task.checkCancellation()

        let readCount = records.count
        logger.info("Read \(readCount) records")

        // Phase 2: Sort by k-mer hash (20% of progress)
        progress(0.4, "Sorting \(readCount) reads by k-mer similarity...")
        let sorted = records.sorted { $0.kmerHash < $1.kmerHash }
        logger.info("Sorting complete")

        try Task.checkCancellation()

        // Phase 3: Write sorted records with binned quality (40% of progress)
        progress(0.6, "Writing sorted reads...")
        let qualityLUT = binningScheme.buildLookupTable()
        try writeRecords(sorted, to: outputFile, qualityLUT: qualityLUT, progress: { frac, msg in
            progress(0.6 + frac * 0.4, msg)
        })

        let elapsed = Date().timeIntervalSince(startTime)
        let outputAttrs = try? FileManager.default.attributesOfItem(atPath: outputFile.path)
        let outputSize = (outputAttrs?[.size] as? Int64) ?? 0

        logger.info("Clumpify complete: \(readCount) reads in \(String(format: "%.1f", elapsed))s")

        return ClumpifyResult(
            readCount: readCount,
            inputSizeBytes: fileSize,
            outputSizeBytes: outputSize,
            qualityBinningScheme: binningScheme,
            elapsedSeconds: elapsed
        )
    }

    // MARK: - Reading

    /// Reads all FASTQ records from a file, computing k-mer hash for each.
    private func readRecords(
        from url: URL,
        fileSize: Int64,
        progress: @escaping (Double, String) -> Void
    ) async throws -> [HashedRead] {
        var reads: [HashedRead] = []
        reads.reserveCapacity(1_000_000)

        var lineBuffer: [String] = []
        lineBuffer.reserveCapacity(4)
        var lineCount: Int64 = 0
        var bytesEstimate: Int64 = 0
        let kSize = kmerSize

        for try await line in url.linesAutoDecompressing() {
            try Task.checkCancellation()

            lineBuffer.append(line)
            lineCount += 1
            bytesEstimate += Int64(line.utf8.count + 1)

            if lineBuffer.count == 4 {
                let header = lineBuffer[0]
                let sequence = lineBuffer[1]
                let separator = lineBuffer[2]
                let quality = lineBuffer[3]

                guard header.hasPrefix("@") else {
                    throw ClumpifyError.invalidFASTQFormat(
                        "Expected '@' header at line \(lineCount - 3), got: \(String(header.prefix(20)))"
                    )
                }

                let hash = Self.canonicalKmerHash(
                    sequence: sequence,
                    kmerSize: kSize
                )

                reads.append(HashedRead(
                    header: header,
                    sequence: sequence,
                    separator: separator,
                    quality: quality,
                    kmerHash: hash
                ))

                lineBuffer.removeAll(keepingCapacity: true)

                // Report progress periodically
                if reads.count & 0x3FFFF == 0 { // Every ~262K reads
                    let frac = min(1.0, Double(bytesEstimate) / Double(max(1, fileSize)))
                    progress(frac, "Read \(reads.count) records...")
                }
            }
        }

        if !lineBuffer.isEmpty {
            logger.warning("Incomplete record at end of file (\(lineBuffer.count) trailing lines)")
        }

        progress(1.0, "Read \(reads.count) records")
        return reads
    }

    // MARK: - K-mer Hashing

    /// Computes the minimum canonical k-mer hash for a sequence.
    ///
    /// For each k-mer position, we hash both the forward and reverse complement
    /// k-mer and take the minimum (canonical form). The overall read hash is
    /// the minimum canonical k-mer hash across all positions.
    ///
    /// This ensures that a read and its reverse complement get the same hash,
    /// and that similar reads (sharing k-mers) are grouped together.
    static func canonicalKmerHash(sequence: String, kmerSize: Int) -> UInt64 {
        let bytes = Array(sequence.utf8)
        let n = bytes.count

        guard n >= kmerSize else {
            return murmurMix(simpleHash(bytes[...]))
        }

        var minHash: UInt64 = .max

        for i in 0...(n - kmerSize) {
            let kmerHash = hashKmer(bytes, start: i, length: kmerSize)
            if kmerHash < minHash {
                minHash = kmerHash
            }
        }

        return minHash
    }

    /// Hashes a single k-mer at the given position, using canonical form.
    private static func hashKmer(_ bytes: [UInt8], start: Int, length: Int) -> UInt64 {
        var forwardHash: UInt64 = 0
        var reverseHash: UInt64 = 0

        for i in 0..<length {
            let base = baseTable[Int(bytes[start + i])]
            if base == 0xFF {
                // N or ambiguous base — return fallback hash for this k-mer
                return murmurMix(simpleHash(bytes[start..<(start + length)]))
            }
            forwardHash = (forwardHash << 2) | UInt64(base)
            reverseHash = reverseHash | (UInt64(3 - base) << (2 * i))
        }

        return murmurMix(min(forwardHash, reverseHash))
    }

    /// Simple byte-level hash for fallback (N-containing sequences).
    private static func simpleHash(_ bytes: ArraySlice<UInt8>) -> UInt64 {
        var h: UInt64 = 0x517cc1b727220a95
        for byte in bytes {
            h = h ^ UInt64(byte)
            h = h &* 0x2127599bf4325c37
        }
        return h
    }

    /// Murmur3 64-bit finalizer for hash mixing.
    private static func murmurMix(_ key: UInt64) -> UInt64 {
        var h = key
        h ^= h >> 33
        h &*= 0xff51afd7ed558ccd
        h ^= h >> 33
        h &*= 0xc4ceb9fe1a85ec53
        h ^= h >> 33
        return h
    }

    // MARK: - Writing

    /// Writes sorted reads to output file with optional quality binning.
    private func writeRecords(
        _ reads: [HashedRead],
        to url: URL,
        qualityLUT: [UInt8],
        progress: @escaping (Double, String) -> Void
    ) throws {
        let dir = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)

        FileManager.default.createFile(atPath: url.path, contents: nil)
        let handle = try FileHandle(forWritingTo: url)
        defer { try? handle.close() }

        let total = reads.count
        let doBinning = binningScheme != .none
        let asciiOffset: UInt8 = 33

        let batchSize = 10_000
        var buffer = Data()
        buffer.reserveCapacity(batchSize * 400)

        for (index, read) in reads.enumerated() {
            // Header
            buffer.append(contentsOf: read.header.utf8)
            buffer.append(0x0A) // \n

            // Sequence (unchanged)
            buffer.append(contentsOf: read.sequence.utf8)
            buffer.append(0x0A)

            // Separator
            buffer.append(contentsOf: read.separator.utf8)
            buffer.append(0x0A)

            // Quality (with optional binning)
            if doBinning {
                for byte in read.quality.utf8 {
                    let q = byte >= asciiOffset ? Int(byte - asciiOffset) : 0
                    let binnedQ = q < qualityLUT.count ? qualityLUT[q] : byte - asciiOffset
                    buffer.append(binnedQ + asciiOffset)
                }
            } else {
                buffer.append(contentsOf: read.quality.utf8)
            }
            buffer.append(0x0A)

            // Flush batch
            if (index + 1) % batchSize == 0 {
                try handle.write(contentsOf: buffer)
                buffer.removeAll(keepingCapacity: true)

                if (index + 1) % (batchSize * 10) == 0 {
                    let frac = Double(index + 1) / Double(total)
                    progress(frac, "Writing \(index + 1)/\(total) reads...")
                }
            }
        }

        if !buffer.isEmpty {
            try handle.write(contentsOf: buffer)
        }

        progress(1.0, "Wrote \(total) reads")
    }
}

// MARK: - HashedRead

/// A FASTQ record stored as raw strings with a pre-computed k-mer hash.
struct HashedRead: Sendable {
    let header: String
    let sequence: String
    let separator: String
    let quality: String
    let kmerHash: UInt64
}

// MARK: - ClumpifyResult

/// Results from the clumpify operation.
public struct ClumpifyResult: Sendable {
    public let readCount: Int
    public let inputSizeBytes: Int64
    public let outputSizeBytes: Int64
    public let qualityBinningScheme: QualityBinningScheme
    public let elapsedSeconds: Double
}

// MARK: - ClumpifyError

public enum ClumpifyError: Error, LocalizedError {
    case invalidFASTQFormat(String)
    case readFailed(String)

    public var errorDescription: String? {
        switch self {
        case .invalidFASTQFormat(let msg): return "Invalid FASTQ format: \(msg)"
        case .readFailed(let msg): return "Read failed: \(msg)"
        }
    }
}
