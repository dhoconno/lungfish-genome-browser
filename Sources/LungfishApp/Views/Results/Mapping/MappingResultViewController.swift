// MappingResultViewController.swift - Compatibility viewport for read mapping results
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit

@MainActor
public final class MappingResultViewController: ReferenceBundleViewportController {
    override var rootAccessibilityIdentifier: String { "mapping-result-view" }
    override var rootAccessibilityLabel: String { "Mapping result viewport" }
}
