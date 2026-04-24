// MappingCompatibilityPresentation.swift - UI adapter for mapping compatibility state
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import LungfishIO
import LungfishWorkflow

struct MappingCompatibilityPresentation {
    let message: String
    let color: Color
    let isReady: Bool

    static func make(
        compatibility: MappingCompatibilityEvaluation?,
        hasReference: Bool,
        hasInputs: Bool,
        detectedSequenceFormat: SequenceFormat?,
        detectedReadClass: MappingReadClass?,
        mixedReadClasses: Bool,
        mixedSequenceFormats: Bool,
        mixesDetectedAndUnclassifiedReadClasses: Bool = false
    ) -> MappingCompatibilityPresentation {
        guard hasInputs else {
            return .init(message: "Select at least one sequence dataset.", color: .secondary, isReady: false)
        }
        guard hasReference else {
            return .init(message: "Select a reference sequence to continue.", color: Color.lungfishOrangeFallback, isReady: false)
        }
        if mixedSequenceFormats {
            return .init(
                message: "Selected sequence inputs mix FASTA and FASTQ formats. Select one format per mapping run.",
                color: Color.lungfishOrangeFallback,
                isReady: false
            )
        }
        if mixedReadClasses {
            return .init(
                message: "Selected FASTQ inputs mix incompatible read classes. Select one read class per mapping run.",
                color: Color.lungfishOrangeFallback,
                isReady: false
            )
        }
        if mixesDetectedAndUnclassifiedReadClasses {
            return .init(
                message: "Selected FASTQ inputs mix classified and unclassified read types. Re-import or edit the read type metadata so every selected FASTQ has the same read type.",
                color: Color.lungfishOrangeFallback,
                isReady: false
            )
        }
        if detectedSequenceFormat == .fasta {
            guard let compatibility else {
                return .init(
                    message: "Detected FASTA sequence input.",
                    color: .secondary,
                    isReady: true
                )
            }
            switch compatibility.state {
            case .allowed:
                return .init(
                    message: "Ready: \(compatibility.tool.displayName) is compatible with FASTA sequence input.",
                    color: Color.lungfishSecondaryText,
                    isReady: true
                )
            case .blocked(let message):
                return .init(message: message, color: Color.lungfishOrangeFallback, isReady: false)
            }
        }
        if let compatibility, case .blocked(let message) = compatibility.state {
            return .init(message: message, color: Color.lungfishOrangeFallback, isReady: false)
        }
        guard let detectedReadClass else {
            return .init(
                message: "Unable to detect a supported read class from the selected FASTQ inputs.",
                color: Color.lungfishOrangeFallback,
                isReady: false
            )
        }
        guard let compatibility else {
            return .init(
                message: "Detected \(detectedReadClass.displayName).",
                color: .secondary,
                isReady: true
            )
        }
        switch compatibility.state {
        case .allowed:
            return .init(
                message: "Ready: \(compatibility.tool.displayName) is compatible with \(detectedReadClass.displayName).",
                color: Color.lungfishSecondaryText,
                isReady: true
            )
        case .blocked(let message):
            return .init(message: message, color: Color.lungfishOrangeFallback, isReady: false)
        }
    }
}
