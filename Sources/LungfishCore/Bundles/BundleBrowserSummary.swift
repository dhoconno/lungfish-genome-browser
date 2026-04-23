// BundleBrowserSummary.swift - Typed browser summary persisted in bundle manifests
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

public struct BundleBrowserSummary: Codable, Sendable, Equatable {
    public let schemaVersion: Int
    public let aggregate: Aggregate
    public let sequences: [BundleBrowserSequenceSummary]

    public init(
        schemaVersion: Int,
        aggregate: Aggregate,
        sequences: [BundleBrowserSequenceSummary]
    ) {
        self.schemaVersion = schemaVersion
        self.aggregate = aggregate
        self.sequences = sequences
    }

    public struct Aggregate: Codable, Sendable, Equatable {
        public let annotationTrackCount: Int
        public let variantTrackCount: Int
        public let alignmentTrackCount: Int
        public let totalMappedReads: Int64?

        public init(
            annotationTrackCount: Int,
            variantTrackCount: Int,
            alignmentTrackCount: Int,
            totalMappedReads: Int64?
        ) {
            self.annotationTrackCount = annotationTrackCount
            self.variantTrackCount = variantTrackCount
            self.alignmentTrackCount = alignmentTrackCount
            self.totalMappedReads = totalMappedReads
        }
    }
}

public struct BundleBrowserSequenceSummary: Codable, Sendable, Equatable, Identifiable {
    public let name: String
    public var id: String { name }
    public let displayDescription: String?
    public let length: Int64
    public let aliases: [String]
    public let isPrimary: Bool
    public let isMitochondrial: Bool
    public let metrics: BundleBrowserSequenceMetrics?

    public init(
        name: String,
        displayDescription: String?,
        length: Int64,
        aliases: [String],
        isPrimary: Bool,
        isMitochondrial: Bool,
        metrics: BundleBrowserSequenceMetrics?
    ) {
        self.name = name
        self.displayDescription = displayDescription
        self.length = length
        self.aliases = aliases
        self.isPrimary = isPrimary
        self.isMitochondrial = isMitochondrial
        self.metrics = metrics
    }
}

public struct BundleBrowserSequenceMetrics: Codable, Sendable, Equatable {
    public let mappedReads: Int64?
    public let mappedPercent: Double?
    public let meanDepth: Double?
    public let coverageBreadth: Double?
    public let medianMAPQ: Double?
    public let meanIdentity: Double?

    public init(
        mappedReads: Int64?,
        mappedPercent: Double?,
        meanDepth: Double?,
        coverageBreadth: Double?,
        medianMAPQ: Double?,
        meanIdentity: Double?
    ) {
        self.mappedReads = mappedReads
        self.mappedPercent = mappedPercent
        self.meanDepth = meanDepth
        self.coverageBreadth = coverageBreadth
        self.medianMAPQ = medianMAPQ
        self.meanIdentity = meanIdentity
    }
}
