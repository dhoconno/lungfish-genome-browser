// ProcessingRecipe.swift - Reusable multi-step FASTQ processing pipelines
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import os.log

private let logger = Logger(subsystem: "com.lungfish.io", category: "ProcessingRecipe")

// MARK: - Processing Recipe

/// A reusable, serializable pipeline definition.
///
/// Recipes capture an ordered sequence of FASTQ processing operations so they
/// can be applied uniformly across all barcodes in a demux group with a single
/// action. Each step reuses the existing `FASTQDerivativeOperation` type.
///
/// ```swift
/// let recipe = ProcessingRecipe.illuminaWGS
/// // → 3 steps: Quality Trim → Adapter Trim → PE Merge
/// ```
///
/// Recipes are stored as JSON in `~/Library/Application Support/Lungfish/recipes/`.
public struct ProcessingRecipe: Codable, Sendable, Identifiable, Equatable {
    public static let fileExtension = "recipe.json"

    public let id: UUID
    public var name: String
    public var description: String
    public let createdAt: Date
    public var modifiedAt: Date

    /// Ordered pipeline steps. Each step is a template whose `createdAt` is
    /// stamped with the real date at execution time.
    public var steps: [FASTQDerivativeOperation]

    /// Tags for organization (e.g., "amplicon", "wgs", "ont").
    public var tags: [String]

    /// Who created this recipe (for shared/built-in recipes).
    public var author: String?

    /// Minimum input requirements (e.g., must be paired-end for PE merge step).
    public var requiredPairingMode: IngestionMetadata.PairingMode?

    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        createdAt: Date = Date(),
        modifiedAt: Date = Date(),
        steps: [FASTQDerivativeOperation],
        tags: [String] = [],
        author: String? = nil,
        requiredPairingMode: IngestionMetadata.PairingMode? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.steps = steps
        self.tags = tags
        self.author = author
        self.requiredPairingMode = requiredPairingMode
    }

    /// Human-readable summary: "3 steps: Quality Trim → Adapter Trim → PE Merge".
    public var pipelineSummary: String {
        guard !steps.isEmpty else { return "Empty pipeline" }
        let stepNames = steps.map { $0.shortLabel }
        return "\(steps.count) steps: \(stepNames.joined(separator: " → "))"
    }

    // MARK: - Persistence

    /// Loads a recipe from a JSON file.
    public static func load(from url: URL) -> ProcessingRecipe? {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(ProcessingRecipe.self, from: data)
        } catch {
            logger.warning("Failed to load recipe from \(url.lastPathComponent): \(error)")
            return nil
        }
    }

    /// Saves the recipe to a JSON file.
    public func save(to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(self)
        try data.write(to: url, options: .atomic)
    }
}

// MARK: - Built-in Recipe Templates

extension ProcessingRecipe {
    /// Standard Illumina WGS preprocessing.
    public static let illuminaWGS = ProcessingRecipe(
        name: "Illumina WGS Standard",
        description: "Quality trim, adapter removal, PE merge",
        steps: [
            FASTQDerivativeOperation(
                kind: .qualityTrim,
                createdAt: .distantPast,
                qualityThreshold: 20,
                windowSize: 4,
                qualityTrimMode: .cutRight
            ),
            FASTQDerivativeOperation(
                kind: .adapterTrim,
                createdAt: .distantPast,
                adapterMode: .autoDetect
            ),
            FASTQDerivativeOperation(
                kind: .pairedEndMerge,
                createdAt: .distantPast,
                mergeStrictness: .normal,
                mergeMinOverlap: 12
            ),
        ],
        tags: ["illumina", "wgs", "paired-end"],
        author: "Lungfish Built-in",
        requiredPairingMode: .interleaved
    )

    /// ONT amplicon preprocessing.
    public static let ontAmplicon = ProcessingRecipe(
        name: "ONT Amplicon",
        description: "Quality filter, length selection for expected amplicon size",
        steps: [
            FASTQDerivativeOperation(
                kind: .qualityTrim,
                createdAt: .distantPast,
                qualityThreshold: 10,
                windowSize: 10,
                qualityTrimMode: .cutBoth
            ),
            FASTQDerivativeOperation(
                kind: .lengthFilter,
                createdAt: .distantPast,
                minLength: 200,
                maxLength: 1500
            ),
        ],
        tags: ["ont", "amplicon", "nanopore"],
        author: "Lungfish Built-in"
    )

    /// PacBio HiFi minimal preprocessing.
    public static let pacbioHiFi = ProcessingRecipe(
        name: "PacBio HiFi",
        description: "Deduplicate HiFi consensus reads",
        steps: [
            FASTQDerivativeOperation(
                kind: .deduplicate,
                createdAt: .distantPast,
                deduplicateMode: .sequence
            ),
        ],
        tags: ["pacbio", "hifi", "long-read"],
        author: "Lungfish Built-in"
    )

    /// Primer removal + quality trim for targeted amplicon sequencing.
    public static let targetedAmplicon = ProcessingRecipe(
        name: "Targeted Amplicon",
        description: "Primer removal, quality trim, adapter trim, PE merge",
        steps: [
            FASTQDerivativeOperation(
                kind: .primerRemoval,
                createdAt: .distantPast,
                primerSource: .literal,
                primerReadMode: .paired,
                primerTrimMode: .paired,
                primerAnchored5Prime: true,
                primerAnchored3Prime: true,
                primerErrorRate: 0.12,
                primerMinimumOverlap: 12,
                primerAllowIndels: true,
                primerKeepUntrimmed: false,
                primerPairFilter: .any
            ),
            FASTQDerivativeOperation(
                kind: .qualityTrim,
                createdAt: .distantPast,
                qualityThreshold: 20,
                windowSize: 4,
                qualityTrimMode: .cutRight
            ),
            FASTQDerivativeOperation(
                kind: .adapterTrim,
                createdAt: .distantPast,
                adapterMode: .autoDetect
            ),
            FASTQDerivativeOperation(
                kind: .pairedEndMerge,
                createdAt: .distantPast,
                mergeStrictness: .strict,
                mergeMinOverlap: 10
            ),
        ],
        tags: ["amplicon", "targeted", "paired-end"],
        author: "Lungfish Built-in",
        requiredPairingMode: .interleaved
    )

    /// All built-in recipe templates.
    public static let builtinRecipes: [ProcessingRecipe] = [
        .illuminaWGS,
        .ontAmplicon,
        .pacbioHiFi,
        .targetedAmplicon,
    ]
}

// MARK: - Recipe Registry

/// Manages built-in and user-created recipes.
public enum RecipeRegistry {

    /// Returns the directory for user-created recipes.
    public static var userRecipesDirectory: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return appSupport
            .appendingPathComponent("Lungfish", isDirectory: true)
            .appendingPathComponent("recipes", isDirectory: true)
    }

    /// Loads all available recipes (built-in + user).
    public static func loadAllRecipes() -> [ProcessingRecipe] {
        var recipes = ProcessingRecipe.builtinRecipes

        let userDir = userRecipesDirectory
        guard FileManager.default.fileExists(atPath: userDir.path) else { return recipes }

        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: userDir,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )
            for url in contents where url.pathExtension == "json" || url.lastPathComponent.hasSuffix(".recipe.json") {
                if let recipe = ProcessingRecipe.load(from: url) {
                    recipes.append(recipe)
                }
            }
        } catch {
            logger.warning("Failed to scan user recipes directory: \(error)")
        }

        return recipes
    }

    /// Saves a user-created recipe to the recipes directory.
    public static func saveUserRecipe(_ recipe: ProcessingRecipe) throws {
        let dir = userRecipesDirectory
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)

        let sanitized = recipe.name
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
        let filename = sanitized.unicodeScalars.filter { scalar in
            CharacterSet.alphanumerics.contains(scalar) || scalar == "-" || scalar == "_"
        }.map(String.init).joined()
        let url = dir.appendingPathComponent("\(filename).\(ProcessingRecipe.fileExtension)")
        try recipe.save(to: url)
    }
}
