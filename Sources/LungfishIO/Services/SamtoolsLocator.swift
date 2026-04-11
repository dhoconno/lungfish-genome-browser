// SamtoolsLocator.swift - Shared samtools discovery helper
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

/// Centralized samtools discovery used by import, materialization, and viewer code.
public enum SamtoolsLocator {

    /// Returns the first executable samtools path that can be found.
    ///
    /// Search order:
    /// 1. Bundled app resources.
    /// 2. Common system locations.
    /// 3. Directories from `searchPath` (defaults to the current environment's `PATH`).
    public static func locate(searchPath: String? = ProcessInfo.processInfo.environment["PATH"]) -> String? {
        let fm = FileManager.default

        if let searchPath, !searchPath.isEmpty {
            for dir in searchPath.split(separator: ":") {
                let candidate = String(dir) + "/samtools"
                if fm.isExecutableFile(atPath: candidate) {
                    return candidate
                }
            }
        }

        let bundledCandidates = [
            Bundle.main.resourceURL?.appendingPathComponent("Tools/samtools").path,
            Bundle.main.executableURL?.deletingLastPathComponent().appendingPathComponent("Tools/samtools").path,
        ]

        let fixedCandidates = [
            "/opt/homebrew/Cellar/samtools/1.23/bin/samtools",
            "/opt/homebrew/bin/samtools",
            "/usr/local/bin/samtools",
            "/usr/bin/samtools",
        ]

        for candidate in bundledCandidates.compactMap({ $0 }) + fixedCandidates {
            if fm.isExecutableFile(atPath: candidate) {
                return candidate
            }
        }

        return nil
    }
}
