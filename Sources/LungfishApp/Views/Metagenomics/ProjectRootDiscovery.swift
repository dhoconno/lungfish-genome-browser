// ProjectRootDiscovery.swift — Shared utility for finding .lungfish project roots
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

/// Walks up from a URL to find the enclosing `.lungfish` project directory.
///
/// Handles both derivative paths (`project.lungfish/Downloads/bundle.lungfishfastq/derivatives/tool-*/`)
/// and import paths (`project.lungfish/Imports/naomgs-*/`).
///
/// - Parameter url: Any URL within a Lungfish project tree.
/// - Returns: The project root URL (ending in `.lungfish`), or `nil` if not found within 10 levels.
func findProjectRoot(_ url: URL) -> URL? {
    var candidate = url
    for _ in 0..<10 {
        if candidate.pathExtension == "lungfish" {
            return candidate
        }
        let parent = candidate.deletingLastPathComponent()
        if parent.path == candidate.path { break }  // hit filesystem root
        candidate = parent
    }
    return nil
}
