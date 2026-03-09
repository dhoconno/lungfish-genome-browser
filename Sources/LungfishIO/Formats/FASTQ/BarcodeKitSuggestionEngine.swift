// BarcodeKitSuggestionEngine.swift - FASTQ barcode kit inference helpers
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

/// Suggested barcode kit detected from a FASTQ sample.
public struct BarcodeKitSuggestion: Sendable, Equatable {
    public let kitID: String
    public let displayName: String
    public let matchingReadCount: Int
    public let sampledReadCount: Int

    public var hitFraction: Double {
        guard sampledReadCount > 0 else { return 0 }
        return Double(matchingReadCount) / Double(sampledReadCount)
    }

    public init(
        kitID: String,
        displayName: String,
        matchingReadCount: Int,
        sampledReadCount: Int
    ) {
        self.kitID = kitID
        self.displayName = displayName
        self.matchingReadCount = matchingReadCount
        self.sampledReadCount = sampledReadCount
    }
}

/// Detects likely barcode kits and dominant barcode IDs from sampled FASTQ reads.
public enum BarcodeKitSuggestionEngine {

    /// Suggest built-in kits by scanning the first N reads.
    ///
    /// A kit is suggested when the fraction of reads containing at least one
    /// compatible barcode signal exceeds `minimumHitFraction`.
    public static func suggestKits(
        in fastqURL: URL,
        kits: [IlluminaBarcodeDefinition] = IlluminaBarcodeKitRegistry.builtinKits(),
        sampleReadLimit: Int = 1_000,
        minimumHitFraction: Double = 0.25
    ) async throws -> [BarcodeKitSuggestion] {
        let reads = try await sampleReadSequences(from: fastqURL, limit: sampleReadLimit)
        guard !reads.isEmpty else { return [] }

        var suggestions: [BarcodeKitSuggestion] = []
        for kit in kits {
            var hits = 0
            for read in reads where !read.isEmpty {
                if !matchedBarcodeIDs(in: read, for: kit).isEmpty {
                    hits += 1
                }
            }
            let suggestion = BarcodeKitSuggestion(
                kitID: kit.id,
                displayName: kit.displayName,
                matchingReadCount: hits,
                sampledReadCount: reads.count
            )
            if suggestion.hitFraction >= minimumHitFraction {
                suggestions.append(suggestion)
            }
        }

        return suggestions.sorted {
            if $0.hitFraction == $1.hitFraction {
                return $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending
            }
            return $0.hitFraction > $1.hitFraction
        }
    }

    /// Finds dominant barcode IDs for a specific kit by sampling reads.
    ///
    /// Useful for narrowing combinatorial pair space before full demultiplexing.
    public static func dominantBarcodeIDs(
        in fastqURL: URL,
        kit: IlluminaBarcodeDefinition,
        sampleReadLimit: Int = 1_000,
        minimumHitFraction: Double = 0.01,
        maxCandidates: Int = 48
    ) async throws -> [String] {
        let reads = try await sampleReadSequences(from: fastqURL, limit: sampleReadLimit)
        guard !reads.isEmpty else { return [] }

        var counts: [String: Int] = [:]
        for read in reads where !read.isEmpty {
            for barcodeID in matchedBarcodeIDs(in: read, for: kit) {
                counts[barcodeID, default: 0] += 1
            }
        }

        if counts.isEmpty { return [] }

        let minHits = max(1, Int(Double(reads.count) * minimumHitFraction))
        var ranked = counts
            .filter { $0.value >= minHits }
            .sorted { lhs, rhs in
                if lhs.value == rhs.value {
                    return lhs.key.localizedStandardCompare(rhs.key) == .orderedAscending
                }
                return lhs.value > rhs.value
            }
            .map(\.key)

        if ranked.isEmpty {
            ranked = counts
                .sorted { lhs, rhs in
                    if lhs.value == rhs.value {
                        return lhs.key.localizedStandardCompare(rhs.key) == .orderedAscending
                    }
                    return lhs.value > rhs.value
                }
                .map(\.key)
        }

        return Array(ranked.prefix(max(1, maxCandidates)))
    }

    /// Finds dominant barcode pairs for combinatorial dual-index kits.
    ///
    /// Pair IDs are returned in canonical form `lhs--rhs` (sorted by ID).
    public static func dominantBarcodePairs(
        in fastqURL: URL,
        kit: IlluminaBarcodeDefinition,
        sampleReadLimit: Int = 1_000,
        minimumHitFraction: Double = 0.005,
        maxPairs: Int = 96
    ) async throws -> [String] {
        let reads = try await sampleReadSequences(from: fastqURL, limit: sampleReadLimit)
        guard !reads.isEmpty else { return [] }

        var counts: [String: Int] = [:]
        for read in reads where !read.isEmpty {
            let matches = matchedBarcodeOffsets(in: read, for: kit)
            guard matches.count >= 2 else { continue }

            let ordered = matches.sorted { lhs, rhs in
                if lhs.value == rhs.value {
                    return lhs.key.localizedStandardCompare(rhs.key) == .orderedAscending
                }
                return lhs.value < rhs.value
            }

            let first = ordered[0].key
            let second = ordered[1].key
            guard first != second else { continue }
            let pairID = canonicalPairName(first, second)
            counts[pairID, default: 0] += 1
        }

        guard !counts.isEmpty else { return [] }

        let minHits = max(1, Int(Double(reads.count) * minimumHitFraction))
        var ranked = counts
            .filter { $0.value >= minHits }
            .sorted { lhs, rhs in
                if lhs.value == rhs.value {
                    return lhs.key.localizedStandardCompare(rhs.key) == .orderedAscending
                }
                return lhs.value > rhs.value
            }
            .map(\.key)

        if ranked.isEmpty {
            ranked = counts
                .sorted { lhs, rhs in
                    if lhs.value == rhs.value {
                        return lhs.key.localizedStandardCompare(rhs.key) == .orderedAscending
                    }
                    return lhs.value > rhs.value
                }
                .map(\.key)
        }

        return Array(ranked.prefix(max(1, maxPairs)))
    }

    /// Reverse-complements a DNA sequence.
    public static func reverseComplement(_ sequence: String) -> String {
        let mapped = sequence.uppercased().reversed().map { base -> Character in
            switch base {
            case "A": return "T"
            case "T": return "A"
            case "C": return "G"
            case "G": return "C"
            case "N": return "N"
            case "R": return "Y"
            case "Y": return "R"
            case "S": return "S"
            case "W": return "W"
            case "K": return "M"
            case "M": return "K"
            case "B": return "V"
            case "V": return "B"
            case "D": return "H"
            case "H": return "D"
            default: return "N"
            }
        }
        return String(mapped)
    }

    // MARK: - Internal Matching

    private static func matchedBarcodeIDs(
        in read: String,
        for kit: IlluminaBarcodeDefinition
    ) -> Set<String> {
        Set(matchedBarcodeOffsets(in: read, for: kit).keys)
    }

    private static func matchedBarcodeOffsets(
        in read: String,
        for kit: IlluminaBarcodeDefinition
    ) -> [String: Int] {
        let normalizedRead = read.uppercased()
        let nsRead = normalizedRead as NSString
        var matched: [String: Int] = [:]

        func firstMatchOffset(_ sequence: String) -> Int? {
            let direct = nsRead.range(of: sequence)
            let rc = nsRead.range(of: reverseComplement(sequence))
            let directOffset = direct.location != NSNotFound ? direct.location : nil
            let rcOffset = rc.location != NSNotFound ? rc.location : nil
            switch (directOffset, rcOffset) {
            case let (lhs?, rhs?):
                return min(lhs, rhs)
            case let (lhs?, nil):
                return lhs
            case let (nil, rhs?):
                return rhs
            case (nil, nil):
                return nil
            }
        }

        for barcode in kit.barcodes {
            let i7 = barcode.i7Sequence.uppercased()
            let i7Offset = firstMatchOffset(i7)
            let i7Matched = i7Offset != nil

            switch kit.pairingMode {
            case .singleEnd:
                if i7Matched {
                    matched[barcode.id] = min(matched[barcode.id] ?? .max, i7Offset ?? .max)
                }

            case .fixedDual:
                guard let i5 = barcode.i5Sequence?.uppercased() else {
                    if i7Matched {
                        matched[barcode.id] = min(matched[barcode.id] ?? .max, i7Offset ?? .max)
                    }
                    continue
                }
                let i5Offset = firstMatchOffset(i5)
                if i7Matched, let i5Offset {
                    matched[barcode.id] = min(matched[barcode.id] ?? .max, min(i7Offset ?? .max, i5Offset))
                }

            case .combinatorialDual:
                if i7Matched {
                    matched[barcode.id] = min(matched[barcode.id] ?? .max, i7Offset ?? .max)
                }
            }
        }

        return matched
    }

    private static func sampleReadSequences(
        from fastqURL: URL,
        limit: Int
    ) async throws -> [String] {
        let reader = FASTQReader(validateSequence: false)
        var sampled: [String] = []
        sampled.reserveCapacity(max(1, limit))

        for try await record in reader.records(from: fastqURL) {
            sampled.append(record.sequence)
            if sampled.count >= limit {
                break
            }
        }

        return sampled
    }

    private static func canonicalPairName(_ lhs: String, _ rhs: String) -> String {
        if lhs.localizedStandardCompare(rhs) == .orderedDescending {
            return "\(rhs)--\(lhs)"
        }
        return "\(lhs)--\(rhs)"
    }
}
