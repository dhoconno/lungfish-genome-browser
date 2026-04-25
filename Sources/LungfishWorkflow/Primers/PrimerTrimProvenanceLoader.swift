// PrimerTrimProvenanceLoader.swift - Shared lookup for primer-trim provenance sidecars
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

/// Loads `BAMPrimerTrimProvenance` records from sidecar JSON files written
/// next to primer-trimmed BAMs.
///
/// `BAMPrimerTrimPipeline` writes the sidecar at `<bam-sans-ext>.primer-trim-provenance.json`
/// (e.g., `trimmed.primer-trim-provenance.json` next to `trimmed.bam`). This
/// loader is the single source of truth for that path convention; multiple
/// callers (the variant-calling auto-confirm in `BAMVariantCallingDialogState`
/// and the Inspector's "Primer-trim Derivation" section in
/// `ReadStyleSectionViewModel`) reach the same sidecar through here.
public enum PrimerTrimProvenanceLoader {
    /// Sidecar filename suffix paired with `<bam-sans-ext>`.
    public static let sidecarExtension = "primer-trim-provenance.json"

    /// Returns the canonical sidecar URL paired with `bamURL`, regardless of
    /// whether the file exists. Useful for callers that need the path without
    /// loading.
    public static func sidecarURL(forBAMAt bamURL: URL) -> URL {
        bamURL.deletingPathExtension().appendingPathExtension(sidecarExtension)
    }

    /// Attempts to load and decode the sidecar paired with `bamURL`.
    ///
    /// Returns nil when:
    /// - the sidecar file is absent,
    /// - the JSON fails to decode as `BAMPrimerTrimProvenance`,
    /// - the decoded record has an `operation` field other than `"primer-trim"`.
    ///
    /// The third case keeps the loader's contract operation-scoped: callers can
    /// rely on a non-nil return meaning "this BAM was primer-trimmed by Lungfish".
    public static func load(forBAMAt bamURL: URL) -> BAMPrimerTrimProvenance? {
        let sidecar = sidecarURL(forBAMAt: bamURL)
        guard FileManager.default.fileExists(atPath: sidecar.path) else { return nil }
        guard let data = try? Data(contentsOf: sidecar) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let provenance = try? decoder.decode(BAMPrimerTrimProvenance.self, from: data) else {
            return nil
        }
        guard provenance.operation == "primer-trim" else { return nil }
        return provenance
    }
}
