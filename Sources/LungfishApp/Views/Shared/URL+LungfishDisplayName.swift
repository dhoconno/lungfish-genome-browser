// URL+LungfishDisplayName.swift - Shared display name logic for FASTQ bundles
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

extension URL {
    /// A human-readable display name that strips `.lungfishfastq` and other
    /// file extensions so bundle names appear clean in wizard sheet headers.
    ///
    /// For example, `"SRR35520572.lungfishfastq"` becomes `"SRR35520572"`.
    var lungfishDisplayName: String {
        let name = deletingPathExtension().lastPathComponent
        if name.hasSuffix(".lungfishfastq") {
            return URL(fileURLWithPath: name).deletingPathExtension().lastPathComponent
        }
        return name
    }
}
