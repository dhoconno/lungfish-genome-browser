import Foundation

/// Factory helpers for authoring ephemeral on-disk fixtures used by IO-layer tests.
///
/// All directories are created under a single shared root (``root``) so that tests
/// can blow away the entire subtree from `tearDown` via ``cleanup()``.
enum TestWorkspace {
    /// Shared parent directory for every fixture produced by this enum.
    static let root: URL = FileManager.default.temporaryDirectory
        .appendingPathComponent("LungfishIOTests", isDirectory: true)

    /// Creates a uniquely-named directory under ``root`` and returns its URL.
    static func makeDirectory(name: String) throws -> URL {
        let dir = root
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
            .appendingPathComponent(name, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    /// Removes the entire shared root directory tree (if it exists).
    static func cleanup() throws {
        if FileManager.default.fileExists(atPath: root.path) {
            try FileManager.default.removeItem(at: root)
        }
    }

    /// Creates an empty `.lungfishprimers` directory (no manifest, no BED, no PROVENANCE).
    static func makeEmptyBundle(name: String) throws -> URL {
        return try makeDirectory(name: name)
    }

    /// Creates a `.lungfishprimers` bundle that has only a valid manifest.json
    /// (no primers.bed, no PROVENANCE.md).
    static func makeBundleWithOnlyManifest() throws -> URL {
        let url = try makeEmptyBundle(name: "only-manifest.lungfishprimers")
        let manifestURL = url.appendingPathComponent("manifest.json")
        try validManifestJSON().write(to: manifestURL, options: .atomic)
        return url
    }

    /// Creates a `.lungfishprimers` bundle with a malformed manifest.json
    /// plus the other required files, so the loader gets past file-existence checks
    /// and fails inside manifest decoding.
    static func makeBundleWithMalformedManifest() throws -> URL {
        let url = try makeEmptyBundle(name: "malformed-manifest.lungfishprimers")
        let manifestURL = url.appendingPathComponent("manifest.json")
        try Data("{ not valid json".utf8).write(to: manifestURL, options: .atomic)

        let bedURL = url.appendingPathComponent("primers.bed")
        try Data("ref\t0\t10\tname\t60\t+\n".utf8).write(to: bedURL, options: .atomic)

        let provenanceURL = url.appendingPathComponent("PROVENANCE.md")
        try Data("# PROVENANCE\n".utf8).write(to: provenanceURL, options: .atomic)

        return url
    }

    /// Produces a valid-shaped manifest whose `reference_accessions` array is empty,
    /// to verify the loader's semantic validation rejects it.
    static func makeBundleWithEmptyReferenceAccessions() throws -> URL {
        let url = try makeEmptyBundle(name: "empty-accessions.lungfishprimers")

        let manifestURL = url.appendingPathComponent("manifest.json")
        let json = """
        {
          "schema_version": 1,
          "name": "tmp-bundle",
          "display_name": "Temp Bundle",
          "reference_accessions": [],
          "primer_count": 0,
          "amplicon_count": 0
        }
        """
        try Data(json.utf8).write(to: manifestURL, options: .atomic)

        let bedURL = url.appendingPathComponent("primers.bed")
        try Data("ref\t0\t10\tname\t60\t+\n".utf8).write(to: bedURL, options: .atomic)

        let provenanceURL = url.appendingPathComponent("PROVENANCE.md")
        try Data("# PROVENANCE\n".utf8).write(to: provenanceURL, options: .atomic)

        return url
    }

    // MARK: - Internals

    private static func validManifestJSON() -> Data {
        let json = """
        {
          "schema_version": 1,
          "name": "tmp-bundle",
          "display_name": "Temp Bundle",
          "reference_accessions": [
            { "accession": "MN908947.3", "canonical": true }
          ],
          "primer_count": 0,
          "amplicon_count": 0
        }
        """
        return Data(json.utf8)
    }
}
