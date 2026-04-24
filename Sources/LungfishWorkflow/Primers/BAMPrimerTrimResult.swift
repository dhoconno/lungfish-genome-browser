// BAMPrimerTrimResult.swift - Outputs from the BAM primer-trim pipeline
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

/// Outputs produced by a successful BAM primer-trim pipeline run.
///
/// Returned by `BAMPrimerTrimPipeline` alongside the sidecar JSON file it
/// writes next to the trimmed BAM. The `provenance` struct and the file at
/// `provenanceURL` encode the same content; callers that need to re-verify
/// the recorded run can prefer whichever is more convenient.
public struct BAMPrimerTrimResult: Sendable {
    /// URL of the primer-trimmed, coordinate-sorted output BAM.
    public let outputBAMURL: URL

    /// URL of the BAI index created for `outputBAMURL`.
    public let outputBAMIndexURL: URL

    /// URL of the JSON provenance sidecar written next to the output BAM.
    public let provenanceURL: URL

    /// In-memory copy of the provenance record written to `provenanceURL`.
    public let provenance: BAMPrimerTrimProvenance
}
