// PluginProtocolTests.swift - Tests for base plugin protocol types
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishPlugin

// MARK: - PluginCategory Tests

final class PluginCategoryTests: XCTestCase {

    func testAllCasesCount() {
        XCTAssertEqual(PluginCategory.allCases.count, 8)
    }

    func testRawValues() {
        XCTAssertEqual(PluginCategory.sequenceAnalysis.rawValue, "Sequence Analysis")
        XCTAssertEqual(PluginCategory.sequenceOperations.rawValue, "Sequence Operations")
        XCTAssertEqual(PluginCategory.annotationTools.rawValue, "Annotation Tools")
        XCTAssertEqual(PluginCategory.visualization.rawValue, "Visualization")
        XCTAssertEqual(PluginCategory.dataImport.rawValue, "Data Import")
        XCTAssertEqual(PluginCategory.dataExport.rawValue, "Data Export")
        XCTAssertEqual(PluginCategory.workflow.rawValue, "Workflow")
        XCTAssertEqual(PluginCategory.utility.rawValue, "Utility")
    }

    func testIconNamesAreNonEmpty() {
        for category in PluginCategory.allCases {
            XCTAssertFalse(
                category.iconName.isEmpty,
                "Category '\(category.rawValue)' should have a non-empty icon name"
            )
        }
    }

    func testIconNamesAreDistinct() {
        let icons = PluginCategory.allCases.map(\.iconName)
        let unique = Set(icons)
        XCTAssertEqual(icons.count, unique.count, "Each category should have a unique icon")
    }

    func testCodableRoundTrip() throws {
        for category in PluginCategory.allCases {
            let encoded = try JSONEncoder().encode(category)
            let decoded = try JSONDecoder().decode(PluginCategory.self, from: encoded)
            XCTAssertEqual(decoded, category)
        }
    }
}

// MARK: - PluginCapabilities Tests

final class PluginCapabilitiesTests: XCTestCase {

    func testIndividualCapabilities() {
        let selection: PluginCapabilities = .worksOnSelection
        XCTAssertTrue(selection.contains(.worksOnSelection))
        XCTAssertFalse(selection.contains(.worksOnWholeSequence))
    }

    func testCapabilityCombination() {
        let combined: PluginCapabilities = [.worksOnSelection, .worksOnWholeSequence, .producesReport]
        XCTAssertTrue(combined.contains(.worksOnSelection))
        XCTAssertTrue(combined.contains(.worksOnWholeSequence))
        XCTAssertTrue(combined.contains(.producesReport))
        XCTAssertFalse(combined.contains(.generatesAnnotations))
    }

    func testStandardAnalysisPreset() {
        let preset: PluginCapabilities = .standardAnalysis
        XCTAssertTrue(preset.contains(.worksOnSelection))
        XCTAssertTrue(preset.contains(.worksOnWholeSequence))
        XCTAssertTrue(preset.contains(.producesReport))
        XCTAssertFalse(preset.contains(.generatesAnnotations))
    }

    func testNucleotideAnnotatorPreset() {
        let preset: PluginCapabilities = .nucleotideAnnotator
        XCTAssertTrue(preset.contains(.worksOnWholeSequence))
        XCTAssertTrue(preset.contains(.generatesAnnotations))
        XCTAssertTrue(preset.contains(.requiresNucleotide))
        XCTAssertFalse(preset.contains(.worksOnSelection))
    }

    func testEmptyCapabilities() {
        let empty = PluginCapabilities()
        XCTAssertTrue(empty.isEmpty)
        XCTAssertFalse(empty.contains(.worksOnSelection))
    }

    func testCodableRoundTrip() throws {
        let capabilities: PluginCapabilities = [.worksOnSelection, .generatesAnnotations, .supportsCancellation]
        let encoded = try JSONEncoder().encode(capabilities)
        let decoded = try JSONDecoder().decode(PluginCapabilities.self, from: encoded)
        XCTAssertEqual(decoded, capabilities)
    }
}

// MARK: - SequenceAlphabet Tests

final class SequenceAlphabetTests: XCTestCase {

    func testDNAIsNucleotide() {
        XCTAssertTrue(SequenceAlphabet.dna.isNucleotide)
    }

    func testRNAIsNucleotide() {
        XCTAssertTrue(SequenceAlphabet.rna.isNucleotide)
    }

    func testProteinIsNotNucleotide() {
        XCTAssertFalse(SequenceAlphabet.protein.isNucleotide)
    }

    func testDNAValidCharacters() {
        let valid = SequenceAlphabet.dna.validCharacters
        XCTAssertTrue(valid.contains("A"))
        XCTAssertTrue(valid.contains("T"))
        XCTAssertTrue(valid.contains("C"))
        XCTAssertTrue(valid.contains("G"))
        XCTAssertTrue(valid.contains("N"))
        XCTAssertTrue(valid.contains("a"))
        XCTAssertFalse(valid.contains("U"))
    }

    func testRNAValidCharacters() {
        let valid = SequenceAlphabet.rna.validCharacters
        XCTAssertTrue(valid.contains("A"))
        XCTAssertTrue(valid.contains("U"))
        XCTAssertTrue(valid.contains("C"))
        XCTAssertTrue(valid.contains("G"))
        XCTAssertFalse(valid.contains("T"))
    }

    func testProteinValidCharacters() {
        let valid = SequenceAlphabet.protein.validCharacters
        // Standard amino acids
        for aa in "ACDEFGHIKLMNPQRSTVWY" {
            XCTAssertTrue(valid.contains(aa), "Protein alphabet should include \(aa)")
        }
        XCTAssertTrue(valid.contains("*"), "Protein alphabet should include stop (*)")
        XCTAssertFalse(valid.contains("J"), "Protein alphabet should not include J")
    }

    func testDNAAmbiguityCodes() {
        let ambiguity = SequenceAlphabet.dna.ambiguityCodes
        for code in "RYSWKMBDHVN" {
            XCTAssertTrue(ambiguity.contains(code), "DNA ambiguity codes should include \(code)")
        }
        XCTAssertFalse(ambiguity.contains("A"), "A is not an ambiguity code")
    }

    func testProteinAmbiguityCodes() {
        let ambiguity = SequenceAlphabet.protein.ambiguityCodes
        XCTAssertTrue(ambiguity.contains("B"))
        XCTAssertTrue(ambiguity.contains("Z"))
        XCTAssertTrue(ambiguity.contains("X"))
    }

    func testRawValues() {
        XCTAssertEqual(SequenceAlphabet.dna.rawValue, "DNA")
        XCTAssertEqual(SequenceAlphabet.rna.rawValue, "RNA")
        XCTAssertEqual(SequenceAlphabet.protein.rawValue, "Protein")
    }

    func testCodableRoundTrip() throws {
        for alphabet in SequenceAlphabet.allCases {
            let encoded = try JSONEncoder().encode(alphabet)
            let decoded = try JSONDecoder().decode(SequenceAlphabet.self, from: encoded)
            XCTAssertEqual(decoded, alphabet)
        }
    }
}

// MARK: - KeyboardShortcut Tests

final class KeyboardShortcutTests: XCTestCase {

    func testBasicShortcut() {
        let shortcut = KeyboardShortcut(key: "S", modifiers: .command)
        XCTAssertEqual(shortcut.key, "S")
        XCTAssertTrue(shortcut.modifiers.contains(.command))
    }

    func testDefaultModifierIsCommand() {
        let shortcut = KeyboardShortcut(key: "T")
        XCTAssertTrue(shortcut.modifiers.contains(.command))
    }

    func testCompoundModifiers() {
        let shortcut = KeyboardShortcut(key: "N", modifiers: [.command, .shift])
        XCTAssertTrue(shortcut.modifiers.contains(.command))
        XCTAssertTrue(shortcut.modifiers.contains(.shift))
        XCTAssertFalse(shortcut.modifiers.contains(.option))
        XCTAssertFalse(shortcut.modifiers.contains(.control))
    }

    func testEquality() {
        let a = KeyboardShortcut(key: "A", modifiers: [.command, .shift])
        let b = KeyboardShortcut(key: "A", modifiers: [.command, .shift])
        let c = KeyboardShortcut(key: "A", modifiers: .command)
        XCTAssertEqual(a, b)
        XCTAssertNotEqual(a, c)
    }

    func testCodableRoundTrip() throws {
        let shortcut = KeyboardShortcut(key: "F", modifiers: [.command, .option])
        let encoded = try JSONEncoder().encode(shortcut)
        let decoded = try JSONDecoder().decode(KeyboardShortcut.self, from: encoded)
        XCTAssertEqual(decoded, shortcut)
    }
}

// MARK: - Plugin Default Implementations Tests

final class PluginDefaultsTests: XCTestCase {

    struct MinimalPlugin: Plugin {
        let id = "com.test.minimal"
        let name = "Minimal"
        let version = "1.0.0"
        let description = "A minimal plugin"
        let category = PluginCategory.utility
        let capabilities: PluginCapabilities = []
    }

    func testDefaultRequiredAlphabetIsNil() {
        let plugin = MinimalPlugin()
        XCTAssertNil(plugin.requiredAlphabet)
    }

    func testDefaultMinimumSequenceLengthIsZero() {
        let plugin = MinimalPlugin()
        XCTAssertEqual(plugin.minimumSequenceLength, 0)
    }

    func testDefaultIconName() {
        let plugin = MinimalPlugin()
        XCTAssertEqual(plugin.iconName, "puzzlepiece.extension")
    }

    func testDefaultKeyboardShortcutIsNil() {
        let plugin = MinimalPlugin()
        XCTAssertNil(plugin.keyboardShortcut)
    }
}

// MARK: - PluginError Tests

final class PluginErrorTests: XCTestCase {

    func testInvalidInputDescription() {
        let error = PluginError.invalidInput(reason: "empty sequence")
        XCTAssertEqual(error.errorDescription, "Invalid input: empty sequence")
    }

    func testInvalidOptionsDescription() {
        let error = PluginError.invalidOptions(reason: "missing pattern")
        XCTAssertEqual(error.errorDescription, "Invalid options: missing pattern")
    }

    func testAnalysisErrorDescription() {
        let error = PluginError.analysisError(reason: "computation failed")
        XCTAssertEqual(error.errorDescription, "Analysis error: computation failed")
    }

    func testCancelledDescription() {
        let error = PluginError.cancelled
        XCTAssertEqual(error.errorDescription, "Analysis was cancelled")
    }

    func testUnsupportedAlphabetDescription() {
        let error = PluginError.unsupportedAlphabet(expected: .dna, got: .protein)
        XCTAssertEqual(error.errorDescription, "Unsupported alphabet: expected DNA, got Protein")
    }

    func testSequenceTooShortDescription() {
        let error = PluginError.sequenceTooShort(minimum: 100, actual: 5)
        XCTAssertEqual(error.errorDescription, "Sequence too short: minimum 100, actual 5")
    }

    func testErrorConformsToLocalizedError() {
        let error: Error = PluginError.cancelled
        XCTAssertNotNil(error as? LocalizedError)
        XCTAssertNotNil((error as? LocalizedError)?.errorDescription)
    }
}

// MARK: - Strand Tests

final class StrandTests: XCTestCase {

    func testRawValues() {
        XCTAssertEqual(Strand.forward.rawValue, "+")
        XCTAssertEqual(Strand.reverse.rawValue, "-")
        XCTAssertEqual(Strand.unknown.rawValue, ".")
    }

    func testCodableRoundTrip() throws {
        for strand in [Strand.forward, .reverse, .unknown] {
            let encoded = try JSONEncoder().encode(strand)
            let decoded = try JSONDecoder().decode(Strand.self, from: encoded)
            XCTAssertEqual(decoded, strand)
        }
    }
}
