// DatabaseRegistry.swift - Bundled bioinformatics reference database management
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import os.log
import LungfishCore
import CryptoKit

private let dbLogger = Logger(subsystem: LogSubsystem.workflow, category: "DatabaseRegistry")

// MARK: - HumanScrubberDatabaseError

/// User-actionable errors for the managed human-scrubber database.
public enum HumanScrubberDatabaseError: Error, LocalizedError, Sendable {
    case installRequired(databaseID: String, displayName: String)
    case installationCancelled(databaseID: String, displayName: String)
    case installationFailed(databaseID: String, displayName: String, reason: String)

    public var errorDescription: String? {
        switch self {
        case .installRequired(_, let displayName):
            return "\(displayName) is required before running human-read scrubbing. Install it and try again."
        case .installationCancelled(_, let displayName):
            return "\(displayName) installation was cancelled. Human-read scrubbing remains unavailable."
        case .installationFailed(_, let displayName, let reason):
            return "Failed to install \(displayName): \(reason)"
        }
    }

    public var isInstallRequired: Bool {
        if case .installRequired = self {
            return true
        }
        return false
    }
}

// MARK: - HumanScrubberDatabaseInstaller

/// Focused installer for the managed human-scrubber database.
public actor HumanScrubberDatabaseInstaller {
    public static let databaseID = "human-scrubber"
    public static let shared = HumanScrubberDatabaseInstaller()

    private let registry: DatabaseRegistry

    public init(registry: DatabaseRegistry = .shared) {
        self.registry = registry
    }

    public func install(
        progress: (@Sendable (Double, String) -> Void)? = nil
    ) async throws -> URL {
        try await registry.installManagedDatabase(Self.databaseID, progress: progress)
    }
}

// MARK: - BundledDatabase

/// Metadata for a reference database advertised by the app bundle.
///
/// Manifests live in `Resources/Databases/<id>/manifest.json`.
/// Some databases also ship a bundled payload file in the same directory.
/// Others, such as `human-scrubber`, use bundled metadata only and expect the
/// payload itself to be managed in user data.
public struct BundledDatabase: Sendable, Codable {
    /// Machine-readable identifier (e.g. "human-scrubber").
    public let id: String
    /// Human-readable name shown in UI.
    public let displayName: String
    /// Which tool uses this database.
    public let tool: String
    /// Version string derived from the filename (e.g. "20250916v2").
    public let version: String
    /// Filename of the database file (e.g. "human_filter.db.20250916v2").
    public let filename: String
    /// ISO 8601 date when this version was released.
    public let releaseDate: String
    /// Human-readable description of what this database covers.
    public let description: String
    /// URL to the source project.
    public let sourceUrl: String
    /// URL to the releases page for checking for updates.
    public let releasesUrl: String
}

// MARK: - DatabaseRegistry

/// Resolves the runtime path of reference databases.
///
/// Resolution priority:
/// 1. User-installed copy in `~/Library/Application Support/Lungfish/databases/<id>/`
/// 2. Bundled payload in the app's `Resources/Databases/<id>/` directory, but only
///    for databases that actually ship a bundled payload
///
/// Managed user-data databases such as `human-scrubber` keep their manifest metadata
/// in the bundle but do not fall back to bundled payload resolution.
///
/// To update a database without a full app update:
/// - Place the new database file in the override directory
/// - Update UserDefaults key `database.<id>.overrideFilename` with the new filename
///
/// Future releases can update bundled metadata and any bundled-payload databases
/// automatically.
public actor DatabaseRegistry {

    public static let shared = DatabaseRegistry()
    private static let databaseIDAliases: [String: String] = [
        "sra-human-scrubber": "human-scrubber",
    ]

    private static let managedUserDataIDs: Set<String> = [
        "human-scrubber"
    ]

    /// Loaded manifests indexed by database ID.
    private var manifests: [String: BundledDatabase] = [:]

    /// Root directory of bundled databases in Resources/Databases/.
    private var bundledDatabasesRoot: URL?

    /// User-managed database directory base.
    private let userDatabasesRootProvider: @Sendable () -> URL?
    private static let databaseStorageLocationKey = "DatabaseStorageLocation"

    private init() {
        self.userDatabasesRootProvider = {
            if let customPath = UserDefaults.standard.string(forKey: Self.databaseStorageLocationKey),
               !customPath.isEmpty
            {
                return URL(fileURLWithPath: customPath, isDirectory: true)
            }
            return FileManager.default.homeDirectoryForCurrentUser
                .appendingPathComponent(".lungfish/databases")
        }
    }

    init(bundledDatabasesRoot: URL?, userDatabasesRoot: URL?) {
        self.bundledDatabasesRoot = bundledDatabasesRoot
        self.userDatabasesRootProvider = { userDatabasesRoot }
    }

    // MARK: - Public API

    /// All known bundled database IDs.
    public static let knownIDs: [String] = [
        "human-scrubber",
    ]

    /// Returns the canonical ID for a database, mapping legacy aliases when needed.
    public static func canonicalDatabaseID(for id: String) -> String {
        normalizedDatabaseID(id)
    }

    /// Returns the manifest for a database, loading it if needed.
    public func manifest(for id: String) -> BundledDatabase? {
        let resolvedID = Self.normalizedDatabaseID(id)
        if let cached = manifests[resolvedID] { return cached }
        guard let url = bundledManifestURL(for: resolvedID) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let db = try JSONDecoder().decode(BundledDatabase.self, from: data)
            manifests[resolvedID] = db
            return db
        } catch {
            dbLogger.error("Failed to load database manifest for '\(resolvedID)': \(error)")
            return nil
        }
    }

    /// Resolves the effective runtime database file path for a given ID.
    ///
    /// Checks for a user-installed copy first.
    /// Falls back to a bundled payload only when that database ships with one.
    /// Managed user-data databases such as `human-scrubber` return `nil` when no
    /// installed copy exists, even though bundled manifest metadata is still available.
    public func effectiveDatabasePath(for id: String) -> URL? {
        let resolvedID = Self.normalizedDatabaseID(id)

        // 1. Check user-managed database directory
        if let installedPath = userInstalledPath(for: resolvedID) {
            dbLogger.info("Using user-installed database for '\(resolvedID)': \(installedPath.lastPathComponent)")
            return installedPath
        }

        if Self.managedUserDataIDs.contains(resolvedID) {
            dbLogger.error("Managed database '\(resolvedID)' is not installed")
            return nil
        }

        // 2. Fall back to bundled database
        if let bundledPath = bundledDatabasePath(for: resolvedID) {
            dbLogger.debug("Using bundled database for '\(resolvedID)': \(bundledPath.lastPathComponent)")
            return bundledPath
        }

        dbLogger.error("No database found for '\(resolvedID)'")
        return nil
    }

    /// Returns a human-readable version string for a database.
    public func versionString(for id: String) -> String {
        let resolvedID = Self.normalizedDatabaseID(id)
        guard let db = manifest(for: resolvedID) else { return "unknown" }
        if userInstalledPath(for: resolvedID) != nil {
            let suffix = Self.managedUserDataIDs.contains(resolvedID) ? "installed" : "user override"
            return "\(db.version) (\(suffix))"
        }
        return db.version
    }

    /// Returns the manifest for a required managed database, when available.
    public func requiredDatabaseManifest(for id: String) -> BundledDatabase? {
        manifest(for: id)
    }

    /// Returns whether a managed database is installed and resolvable.
    public func isDatabaseInstalled(_ id: String) -> Bool {
        effectiveDatabasePath(for: id) != nil
    }

    /// Resolves a managed database path or throws an actionable install-required error.
    public func requiredDatabasePath(for id: String) throws -> URL {
        let resolvedID = Self.normalizedDatabaseID(id)
        if let path = effectiveDatabasePath(for: id) {
            return path
        }

        let displayName = manifest(for: resolvedID)?.displayName ?? resolvedID
        throw HumanScrubberDatabaseError.installRequired(databaseID: resolvedID, displayName: displayName)
    }

    /// Downloads and installs a managed database into user storage.
    ///
    /// This is intentionally narrow for the human-scrubber database shipped by this branch.
    public func installManagedDatabase(
        _ id: String,
        progress: (@Sendable (Double, String) -> Void)? = nil
    ) async throws -> URL {
        let resolvedID = Self.normalizedDatabaseID(id)
        if let existing = effectiveDatabasePath(for: id) {
            progress?(1.0, "Using installed database")
            return existing
        }

        guard Self.managedUserDataIDs.contains(resolvedID),
              let manifest = manifest(for: resolvedID) else {
            throw HumanScrubberDatabaseError.installationFailed(
                databaseID: resolvedID,
                displayName: resolvedID,
                reason: "Unsupported managed database"
            )
        }

        guard let artifactURLs = managedDatabaseArtifactURLs(for: manifest) else {
            throw HumanScrubberDatabaseError.installationFailed(
                databaseID: resolvedID,
                displayName: manifest.displayName,
                reason: "No download URL is available"
            )
        }
        let downloadURL = artifactURLs.databaseURL
        let md5URL = artifactURLs.md5URL

        guard let installDirectory = managedDatabaseDirectory(for: resolvedID) else {
            throw HumanScrubberDatabaseError.installationFailed(
                databaseID: resolvedID,
                displayName: manifest.displayName,
                reason: "No writable database storage location is configured"
            )
        }

        let fileManager = FileManager.default
        try fileManager.createDirectory(at: installDirectory, withIntermediateDirectories: true, attributes: nil)

        let tempDownloadURL = installDirectory.appendingPathComponent("\(manifest.filename).download")
        let tempMD5URL = installDirectory.appendingPathComponent("\(manifest.filename).md5.download")
        let destinationURL = installDirectory.appendingPathComponent(manifest.filename)

        try? fileManager.removeItem(at: tempDownloadURL)
        try? fileManager.removeItem(at: tempMD5URL)

        progress?(0.05, "Downloading \(manifest.displayName)…")

        do {
            let (downloadedURL, response) = try await URLSession.shared.download(from: downloadURL)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw HumanScrubberDatabaseError.installationFailed(
                    databaseID: resolvedID,
                    displayName: manifest.displayName,
                    reason: "Server returned an unexpected response"
                )
            }

            let (downloadedMD5URL, md5Response) = try await URLSession.shared.download(from: md5URL)
            guard let md5HTTPResponse = md5Response as? HTTPURLResponse,
                  (200...299).contains(md5HTTPResponse.statusCode) else {
                throw HumanScrubberDatabaseError.installationFailed(
                    databaseID: resolvedID,
                    displayName: manifest.displayName,
                    reason: "MD5 checksum file returned an unexpected response"
                )
            }

            progress?(0.85, "Installing \(manifest.displayName)…")

            let expectedMD5 = try parseExpectedMD5(from: downloadedMD5URL)
            let actualMD5 = try md5Hex(of: downloadedURL)
            guard actualMD5.lowercased() == expectedMD5.lowercased() else {
                throw HumanScrubberDatabaseError.installationFailed(
                    databaseID: resolvedID,
                    displayName: manifest.displayName,
                    reason: "MD5 mismatch: expected \(expectedMD5), got \(actualMD5)"
                )
            }

            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.moveItem(at: downloadedURL, to: tempDownloadURL)
            try fileManager.moveItem(at: tempDownloadURL, to: destinationURL)
            try? fileManager.removeItem(at: downloadedMD5URL)
            try? fileManager.removeItem(at: tempMD5URL)
            UserDefaults.standard.set(
                manifest.filename,
                forKey: overrideFilenameKey(for: resolvedID)
            )
            progress?(1.0, "Installed \(manifest.displayName)")
            return destinationURL
        } catch is CancellationError {
            try? fileManager.removeItem(at: tempDownloadURL)
            try? fileManager.removeItem(at: tempMD5URL)
            throw HumanScrubberDatabaseError.installationCancelled(
                databaseID: resolvedID,
                displayName: manifest.displayName
            )
        } catch let error as HumanScrubberDatabaseError {
            try? fileManager.removeItem(at: tempDownloadURL)
            try? fileManager.removeItem(at: tempMD5URL)
            throw error
        } catch {
            try? fileManager.removeItem(at: tempDownloadURL)
            try? fileManager.removeItem(at: tempMD5URL)
            throw HumanScrubberDatabaseError.installationFailed(
                databaseID: resolvedID,
                displayName: manifest.displayName,
                reason: error.localizedDescription
            )
        }
    }

    // MARK: - Private Helpers

    private func bundledManifestURL(for id: String) -> URL? {
        databasesRoot()?
            .appendingPathComponent(id)
            .appendingPathComponent("manifest.json")
    }

    private func bundledDatabasePath(for id: String) -> URL? {
        guard let db = manifest(for: id) else { return nil }
        let url = databasesRoot()?
            .appendingPathComponent(id)
            .appendingPathComponent(db.filename)
        guard let url, FileManager.default.fileExists(atPath: url.path) else { return nil }
        return url
    }

    private func userInstalledPath(for id: String) -> URL? {
        guard let base = userDatabasesRootProvider() else { return nil }
        let dir = base.appendingPathComponent(id)

        // Check UserDefaults for a specific override filename
        let overrideKey = overrideFilenameKey(for: id)
        if let filename = UserDefaults.standard.string(forKey: overrideKey) {
            let url = dir.appendingPathComponent(filename)
            if FileManager.default.fileExists(atPath: url.path) { return url }
        }

        // Fall back: scan directory for any file matching the database ID pattern
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: dir, includingPropertiesForKeys: nil
        ) else { return nil }

        return contents
            .filter { !$0.lastPathComponent.hasPrefix(".") }
            .sorted { $0.lastPathComponent > $1.lastPathComponent }  // newest first by name
            .first
    }

    private func managedDatabaseDirectory(for id: String) -> URL? {
        userDatabasesRootProvider()?.appendingPathComponent(id, isDirectory: true)
    }

    func managedDatabaseArtifactURLs(for manifest: BundledDatabase) -> (databaseURL: URL, md5URL: URL)? {
        guard manifest.id == "human-scrubber" else { return nil }
        // The human-scrubber database is distributed by NCBI under this stable path.
        guard let databaseURL = URL(string: "https://ftp.ncbi.nlm.nih.gov/sra/dbs/human_filter/\(manifest.filename)") else {
            return nil
        }
        return (databaseURL, databaseURL.appendingPathExtension("md5"))
    }

    private func parseExpectedMD5(from md5URL: URL) throws -> String {
        let contents = try String(contentsOf: md5URL, encoding: .utf8)
        for token in contents
            .split(whereSeparator: { $0.isWhitespace || $0 == "(" || $0 == ")" || $0 == "=" || $0 == "*" })
        {
            if token.count == 32, token.allSatisfy(\.isHexDigit) {
                return String(token)
            }
        }
        throw HumanScrubberDatabaseError.installationFailed(
            databaseID: "human-scrubber",
            displayName: "Human Read Scrubber Database",
            reason: "Could not parse MD5 file \(md5URL.lastPathComponent)"
        )
    }

    private func md5Hex(of fileURL: URL) throws -> String {
        let handle = try FileHandle(forReadingFrom: fileURL)
        defer { try? handle.close() }

        var hasher = Insecure.MD5()
        while true {
            let data = try handle.read(upToCount: 1_048_576)
            guard let data, !data.isEmpty else { break }
            hasher.update(data: data)
        }

        return hasher.finalize().map { String(format: "%02x", $0) }.joined()
    }

    private func overrideFilenameKey(for id: String) -> String {
        "database.\(id).overrideFilename"
    }

    private static func normalizedDatabaseID(_ id: String) -> String {
        databaseIDAliases[id] ?? id
    }

    private func databasesRoot() -> URL? {
        if let cached = bundledDatabasesRoot { return cached }

        if let candidate = RuntimeResourceLocator.path("Databases", in: .workflow) {
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: candidate.path, isDirectory: &isDir), isDir.boolValue {
                bundledDatabasesRoot = candidate
                dbLogger.info("DatabaseRegistry root: \(candidate.path)")
                return candidate
            }
        }

        dbLogger.error("DatabaseRegistry: Could not find bundled Databases directory")
        return nil
    }
}
