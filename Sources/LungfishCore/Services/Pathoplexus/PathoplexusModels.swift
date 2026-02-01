// PathoplexusModels.swift - Data models for Pathoplexus integration
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: Product Fit Expert (Role 21)

import Foundation

// MARK: - Pathoplexus Organism

/// An organism tracked in Pathoplexus.
public struct PathoplexusOrganism: Sendable, Codable, Identifiable, Equatable {
    /// Unique identifier (e.g., "ebola-zaire", "mpox")
    public let id: String

    /// Human-readable name
    public let displayName: String

    /// Whether this organism has a segmented genome
    public let segmented: Bool

    /// Segment names for segmented genomes (e.g., ["S", "M", "L"] for CCHF)
    public let segments: [String]?

    public init(id: String, displayName: String, segmented: Bool, segments: [String]?) {
        self.id = id
        self.displayName = displayName
        self.segmented = segmented
        self.segments = segments
    }
}

// MARK: - Pathoplexus Filters

/// Search filters for Pathoplexus queries.
public struct PathoplexusFilters: Sendable, Equatable {
    /// Filter by specific accession
    public var accession: String?

    /// Filter by accession version
    public var accessionVersion: String?

    /// Filter by geographic location
    public var geoLocCountry: String?

    /// Filter by collection date (start)
    public var sampleCollectionDateFrom: Date?

    /// Filter by collection date (end)
    public var sampleCollectionDateTo: Date?

    /// Minimum sequence length
    public var lengthFrom: Int?

    /// Maximum sequence length
    public var lengthTo: Int?

    /// Filter by nucleotide mutations (format: "C180T")
    public var nucleotideMutations: [String]?

    /// Filter by amino acid mutations (format: "GP:440G")
    public var aminoAcidMutations: [String]?

    /// Version status filter
    public var versionStatus: VersionStatus?

    public init(
        accession: String? = nil,
        accessionVersion: String? = nil,
        geoLocCountry: String? = nil,
        sampleCollectionDateFrom: Date? = nil,
        sampleCollectionDateTo: Date? = nil,
        lengthFrom: Int? = nil,
        lengthTo: Int? = nil,
        nucleotideMutations: [String]? = nil,
        aminoAcidMutations: [String]? = nil,
        versionStatus: VersionStatus? = nil
    ) {
        self.accession = accession
        self.accessionVersion = accessionVersion
        self.geoLocCountry = geoLocCountry
        self.sampleCollectionDateFrom = sampleCollectionDateFrom
        self.sampleCollectionDateTo = sampleCollectionDateTo
        self.lengthFrom = lengthFrom
        self.lengthTo = lengthTo
        self.nucleotideMutations = nucleotideMutations
        self.aminoAcidMutations = aminoAcidMutations
        self.versionStatus = versionStatus
    }
}

// MARK: - Version Status

/// Version status for Pathoplexus records.
public enum VersionStatus: String, Sendable, Codable {
    case latestVersion = "LATEST_VERSION"
    case revisedVersion = "REVISED_VERSION"
}

// MARK: - Pathoplexus Metadata

/// Metadata for a sequence in Pathoplexus.
public struct PathoplexusMetadata: Sendable, Codable, Identifiable {
    public var id: String { accession }

    /// Primary accession
    public let accession: String

    /// Version of the accession
    public let accessionVersion: String?

    /// Organism name
    public let organism: String?

    /// Geographic location country
    public let geoLocCountry: String?

    /// Sample collection date (string format)
    public let sampleCollectionDate: String?

    /// Sequence length
    public let length: Int?

    /// Submitting laboratory
    public let submittingLab: String?

    /// Authors
    public let authors: String?

    /// Data use terms
    public let dataUseTerms: String?

    /// Version status
    public let versionStatus: String?

    /// Parsed collection date
    public var collectionDate: Date? {
        guard let dateStr = sampleCollectionDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateStr)
    }

    enum CodingKeys: String, CodingKey {
        case accession
        case accessionVersion
        case organism
        case geoLocCountry
        case sampleCollectionDate
        case length
        case submittingLab
        case authors
        case dataUseTerms
        case versionStatus
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accession = try container.decode(String.self, forKey: .accession)
        accessionVersion = try container.decodeIfPresent(String.self, forKey: .accessionVersion)
        organism = try container.decodeIfPresent(String.self, forKey: .organism)
        geoLocCountry = try container.decodeIfPresent(String.self, forKey: .geoLocCountry)
        sampleCollectionDate = try container.decodeIfPresent(String.self, forKey: .sampleCollectionDate)

        // Handle length as either int or string
        if let lengthInt = try? container.decodeIfPresent(Int.self, forKey: .length) {
            length = lengthInt
        } else if let lengthStr = try? container.decodeIfPresent(String.self, forKey: .length) {
            length = Int(lengthStr)
        } else {
            length = nil
        }

        submittingLab = try container.decodeIfPresent(String.self, forKey: .submittingLab)
        authors = try container.decodeIfPresent(String.self, forKey: .authors)
        dataUseTerms = try container.decodeIfPresent(String.self, forKey: .dataUseTerms)
        versionStatus = try container.decodeIfPresent(String.self, forKey: .versionStatus)
    }
}

// MARK: - Data Use Terms

/// Data use terms for Pathoplexus submissions.
public enum DataUseTerms: String, Sendable, Codable, CaseIterable {
    /// Immediately open and shared
    case open = "OPEN"

    /// Time-limited protection (up to one year)
    case restricted = "RESTRICTED"

    /// Human-readable description.
    public var description: String {
        switch self {
        case .open:
            return "Open - Immediately available for public access"
        case .restricted:
            return "Restricted - Time-limited protection for attribution"
        }
    }
}

// MARK: - Pathoplexus Group

/// A group/organization in Pathoplexus.
public struct PathoplexusGroup: Sendable, Codable, Identifiable {
    public let id: String
    public let name: String
    public let institution: String?
    public let contactEmail: String?

    public init(id: String, name: String, institution: String? = nil, contactEmail: String? = nil) {
        self.id = id
        self.name = name
        self.institution = institution
        self.contactEmail = contactEmail
    }
}

// MARK: - Submission Types

/// A submission request to Pathoplexus.
public struct PathoplexusSubmissionRequest: Sendable {
    /// The organism this submission is for
    public let organism: String

    /// URL to the FASTA file
    public let sequencesFile: URL

    /// URL to the TSV metadata file
    public let metadataFile: URL

    /// The group to submit under
    public let groupId: String

    /// Data use terms
    public let dataUseTerms: DataUseTerms

    public init(
        organism: String,
        sequencesFile: URL,
        metadataFile: URL,
        groupId: String,
        dataUseTerms: DataUseTerms
    ) {
        self.organism = organism
        self.sequencesFile = sequencesFile
        self.metadataFile = metadataFile
        self.groupId = groupId
        self.dataUseTerms = dataUseTerms
    }
}
