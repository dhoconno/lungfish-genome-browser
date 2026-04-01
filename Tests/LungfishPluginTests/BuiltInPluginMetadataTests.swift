// BuiltInPluginMetadataTests.swift - Tests for built-in plugin metadata and edge cases
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishCore
@testable import LungfishPlugin

// MARK: - ORFFinderPlugin Metadata Tests

final class ORFFinderPluginMetadataTests: XCTestCase {

    func testPluginMetadata() {
        let plugin = ORFFinderPlugin()
        XCTAssertEqual(plugin.id, "com.lungfish.orf-finder")
        XCTAssertEqual(plugin.name, "ORF Finder")
        XCTAssertEqual(plugin.version, "1.0.0")
        XCTAssertFalse(plugin.description.isEmpty)
        XCTAssertEqual(plugin.category, .annotationTools)
        XCTAssertEqual(plugin.minimumSequenceLength, 30)
        XCTAssertEqual(plugin.iconName, "rectangle.3.group")
    }

    func testCapabilities() {
        let plugin = ORFFinderPlugin()
        XCTAssertTrue(plugin.capabilities.contains(.worksOnWholeSequence))
        XCTAssertTrue(plugin.capabilities.contains(.generatesAnnotations))
        XCTAssertTrue(plugin.capabilities.contains(.requiresNucleotide))
        XCTAssertTrue(plugin.capabilities.contains(.producesReport))
        XCTAssertFalse(plugin.capabilities.contains(.worksOnSelection))
    }

    func testDefaultOptions() {
        let plugin = ORFFinderPlugin()
        let options = plugin.defaultOptions
        XCTAssertEqual(options.integer(for: "minimumLength"), 100)
        XCTAssertEqual(options.stringArray(for: "startCodons"), ["ATG"])
        XCTAssertFalse(options.bool(for: "allowAlternativeStarts"))
        XCTAssertFalse(options.bool(for: "includePartial"))
        XCTAssertEqual(
            options.stringArray(for: "frames"),
            ["+1", "+2", "+3", "-1", "-2", "-3"]
        )
    }

    func testAcceptsRNASequence() async {
        let plugin = ORFFinderPlugin()
        // RNA should be accepted (isNucleotide is true for RNA)
        let input = AnnotationInput(sequence: "AUGAUGAUGUGA", alphabet: .rna)
        do {
            let _ = try await plugin.generateAnnotations(input)
            // Should not throw -- RNA isNucleotide
        } catch {
            XCTFail("RNA should be accepted as nucleotide: \(error)")
        }
    }

    func testLowercaseSequence() async throws {
        let plugin = ORFFinderPlugin()
        let sequence = "atg" + String(repeating: "gca", count: 5) + "taa"
        var options = AnnotationOptions()
        options["minimumLength"] = .integer(15)
        options["frames"] = .stringArray(["+1"])

        let input = AnnotationInput(sequence: sequence, alphabet: .dna, options: options)
        let annotations = try await plugin.generateAnnotations(input)
        XCTAssertEqual(annotations.count, 1)
    }
}

// MARK: - PatternSearchPlugin Metadata Tests

final class PatternSearchPluginMetadataTests: XCTestCase {

    func testPluginMetadata() {
        let plugin = PatternSearchPlugin()
        XCTAssertEqual(plugin.id, "com.lungfish.pattern-search")
        XCTAssertEqual(plugin.name, "Pattern Search")
        XCTAssertEqual(plugin.version, "1.0.0")
        XCTAssertFalse(plugin.description.isEmpty)
        XCTAssertEqual(plugin.category, .sequenceAnalysis)
        XCTAssertEqual(plugin.iconName, "magnifyingglass")
    }

    func testCapabilities() {
        let plugin = PatternSearchPlugin()
        XCTAssertTrue(plugin.capabilities.contains(.worksOnWholeSequence))
        XCTAssertTrue(plugin.capabilities.contains(.generatesAnnotations))
        XCTAssertTrue(plugin.capabilities.contains(.producesReport))
        XCTAssertFalse(plugin.capabilities.contains(.requiresNucleotide))
    }

    func testDefaultOptions() {
        let plugin = PatternSearchPlugin()
        let options = plugin.defaultOptions
        XCTAssertEqual(options.string(for: "pattern"), "")
        XCTAssertEqual(options.string(for: "patternType"), "exact")
        XCTAssertFalse(options.bool(for: "caseSensitive"))
        XCTAssertTrue(options.bool(for: "searchBothStrands"))
        XCTAssertEqual(options.integer(for: "maxMismatches"), 0)
    }

    func testInvalidPatternType() async {
        let plugin = PatternSearchPlugin()
        var options = AnnotationOptions()
        options["pattern"] = .string("ATCG")
        options["patternType"] = .string("invalid_type")

        let input = AnnotationInput(sequence: "ATCG", alphabet: .dna, options: options)
        do {
            _ = try await plugin.generateAnnotations(input)
            XCTFail("Should throw for invalid pattern type")
        } catch PluginError.invalidOptions(let reason) {
            XCTAssertTrue(reason.contains("invalid_type"))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testAnnotationTypeQualifier() async throws {
        let plugin = PatternSearchPlugin()
        var options = AnnotationOptions()
        options["pattern"] = .string("ATCG")
        options["patternType"] = .string("exact")
        options["annotationType"] = .string("primer_bind")
        options["searchBothStrands"] = .bool(false)

        let input = AnnotationInput(
            sequence: "ATCGATCG",
            alphabet: .dna,
            options: options
        )
        let annotations = try await plugin.generateAnnotations(input)
        XCTAssertFalse(annotations.isEmpty)
        XCTAssertEqual(annotations[0].type, "primer_bind")
    }

    func testSingleCharacterPattern() async throws {
        let plugin = PatternSearchPlugin()
        var options = AnnotationOptions()
        options["pattern"] = .string("A")
        options["patternType"] = .string("exact")
        options["searchBothStrands"] = .bool(false)

        let input = AnnotationInput(sequence: "AACAA", alphabet: .dna, options: options)
        let annotations = try await plugin.generateAnnotations(input)
        XCTAssertEqual(annotations.count, 4) // positions 0, 1, 3, 4
    }

    func testNoReverseStrandForProtein() async throws {
        let plugin = PatternSearchPlugin()
        var options = AnnotationOptions()
        options["pattern"] = .string("MV")
        options["patternType"] = .string("exact")
        options["searchBothStrands"] = .bool(true) // should be ignored for protein

        let input = AnnotationInput(
            sequence: "MVLSMV",
            alphabet: .protein,
            options: options
        )
        let annotations = try await plugin.generateAnnotations(input)
        // Both matches should be forward strand -- reverse complement not applied to protein
        XCTAssertEqual(annotations.count, 2)
        XCTAssertTrue(annotations.allSatisfy { $0.strand == .forward })
    }
}

// MARK: - RestrictionSiteFinderPlugin Metadata Tests

final class RestrictionSiteFinderPluginMetadataTests: XCTestCase {

    func testPluginMetadata() {
        let plugin = RestrictionSiteFinderPlugin()
        XCTAssertEqual(plugin.id, "com.lungfish.restriction-finder")
        XCTAssertEqual(plugin.name, "Restriction Site Finder")
        XCTAssertEqual(plugin.version, "1.0.0")
        XCTAssertFalse(plugin.description.isEmpty)
        XCTAssertEqual(plugin.category, .annotationTools)
        XCTAssertEqual(plugin.iconName, "scissors")
    }

    func testCapabilities() {
        let plugin = RestrictionSiteFinderPlugin()
        XCTAssertTrue(plugin.capabilities.contains(.worksOnWholeSequence))
        XCTAssertTrue(plugin.capabilities.contains(.generatesAnnotations))
        XCTAssertTrue(plugin.capabilities.contains(.requiresNucleotide))
        XCTAssertTrue(plugin.capabilities.contains(.producesReport))
    }

    func testDefaultOptions() {
        let plugin = RestrictionSiteFinderPlugin()
        let options = plugin.defaultOptions
        XCTAssertEqual(options.stringArray(for: "enzymes"), ["EcoRI", "BamHI", "HindIII"])
        XCTAssertTrue(options.bool(for: "showCutSites"))
        XCTAssertTrue(options.bool(for: "showFragments"))
        XCTAssertFalse(options.bool(for: "circular"))
    }

    func testUnknownEnzymeIsSkipped() async throws {
        let plugin = RestrictionSiteFinderPlugin()
        var options = AnnotationOptions()
        options["enzymes"] = .stringArray(["NonExistentEnzyme"])

        let input = AnnotationInput(sequence: "GAATTCGAATTC", alphabet: .dna, options: options)
        let annotations = try await plugin.generateAnnotations(input)
        XCTAssertTrue(annotations.isEmpty)
    }

    func testMixedKnownAndUnknownEnzymes() async throws {
        let plugin = RestrictionSiteFinderPlugin()
        var options = AnnotationOptions()
        options["enzymes"] = .stringArray(["EcoRI", "FakeEnzyme"])

        let input = AnnotationInput(sequence: "ATCGAATTCATCG", alphabet: .dna, options: options)
        let annotations = try await plugin.generateAnnotations(input)
        // Should find EcoRI site and silently skip FakeEnzyme
        XCTAssertEqual(annotations.count, 1)
        XCTAssertEqual(annotations[0].qualifiers["enzyme"], "EcoRI")
    }

    func testAnnotationQualifiers() async throws {
        let plugin = RestrictionSiteFinderPlugin()
        var options = AnnotationOptions()
        options["enzymes"] = .stringArray(["EcoRI"])

        let input = AnnotationInput(sequence: "GAATTC", alphabet: .dna, options: options)
        let annotations = try await plugin.generateAnnotations(input)

        XCTAssertEqual(annotations.count, 1)
        let ann = annotations[0]
        XCTAssertEqual(ann.type, "restriction_site")
        XCTAssertEqual(ann.qualifiers["enzyme"], "EcoRI")
        XCTAssertEqual(ann.qualifiers["recognition_site"], "GAATTC")
        XCTAssertNotNil(ann.qualifiers["cut_position"])
        XCTAssertEqual(ann.qualifiers["overhang"], OverhangType.fivePrime.rawValue)
    }

    func testFourCutterFindsMoreSites() async throws {
        let plugin = RestrictionSiteFinderPlugin()
        var options = AnnotationOptions()
        options["enzymes"] = .stringArray(["MspI"]) // CCGG - 4 cutter

        // Multiple CCGG sites
        let sequence = "CCGGAAACCGGAAACCGG"
        let input = AnnotationInput(sequence: sequence, alphabet: .dna, options: options)
        let annotations = try await plugin.generateAnnotations(input)
        XCTAssertEqual(annotations.count, 3)
    }
}

// MARK: - Restriction Enzyme Database Extended Tests

final class RestrictionEnzymeDatabaseExtendedTests: XCTestCase {

    func testAllEnzymesNonEmpty() {
        let db = RestrictionEnzymeDatabase.shared
        XCTAssertGreaterThan(db.allEnzymes.count, 10)
    }

    func testAllEnzymesAreSortedByName() {
        let db = RestrictionEnzymeDatabase.shared
        let enzymes = db.allEnzymes
        for i in 1..<enzymes.count {
            XCTAssertLessThanOrEqual(
                enzymes[i - 1].name, enzymes[i].name,
                "Enzymes should be sorted by name"
            )
        }
    }

    func testNonexistentEnzymeReturnsNil() {
        let db = RestrictionEnzymeDatabase.shared
        XCTAssertNil(db.enzyme(named: "ZzzNotReal"))
    }

    func testSearchCaseInsensitive() {
        let db = RestrictionEnzymeDatabase.shared
        let results = db.search("ecori")
        XCTAssertTrue(results.contains { $0.name == "EcoRI" })
    }

    func testSearchByRecognitionSite() {
        let db = RestrictionEnzymeDatabase.shared
        let results = db.search("GGATCC") // BamHI site
        XCTAssertTrue(results.contains { $0.name == "BamHI" })
    }

    func testSearchNoMatch() {
        let db = RestrictionEnzymeDatabase.shared
        let results = db.search("ZZZZZZZ")
        XCTAssertTrue(results.isEmpty)
    }

    func testPalindromicRecognition() {
        let db = RestrictionEnzymeDatabase.shared

        // EcoRI: GAATTC -- palindromic
        let ecoRI = db.enzyme(named: "EcoRI")!
        XCTAssertTrue(ecoRI.isPalindromic)

        // EcoRV: GATATC -- palindromic
        let ecoRV = db.enzyme(named: "EcoRV")!
        XCTAssertTrue(ecoRV.isPalindromic)
    }

    func testCompatibleEnzymesExcludesSelf() {
        let db = RestrictionEnzymeDatabase.shared
        let ecoRI = db.enzyme(named: "EcoRI")!
        let compatible = db.compatibleEnzymes(with: ecoRI)
        XCTAssertFalse(compatible.contains { $0.name == "EcoRI" })
    }

    func testOverhangTypes() {
        let db = RestrictionEnzymeDatabase.shared

        let fivePrime = db.enzyme(named: "EcoRI")!
        XCTAssertEqual(fivePrime.overhangType, .fivePrime)

        let blunt = db.enzyme(named: "SmaI")!
        XCTAssertEqual(blunt.overhangType, .blunt)

        let threePrime = db.enzyme(named: "KpnI")!
        XCTAssertEqual(threePrime.overhangType, .threePrime)
    }

    func testRestrictionEnzymeIdentifiable() {
        let enzyme = RestrictionEnzyme(
            name: "TestEnzyme",
            recognitionSite: "ATCG",
            cutPositionForward: 1,
            cutPositionReverse: 3
        )
        XCTAssertEqual(enzyme.id, "TestEnzyme")
    }

    func testRestrictionEnzymeCodable() throws {
        let enzyme = RestrictionEnzyme(
            name: "TestEnzyme",
            recognitionSite: "ATCG",
            cutPositionForward: 1,
            cutPositionReverse: 3,
            overhangType: .blunt,
            supplier: ["NEB"]
        )
        let encoded = try JSONEncoder().encode(enzyme)
        let decoded = try JSONDecoder().decode(RestrictionEnzyme.self, from: encoded)
        XCTAssertEqual(decoded.name, enzyme.name)
        XCTAssertEqual(decoded.recognitionSite, enzyme.recognitionSite)
        XCTAssertEqual(decoded.overhangType, enzyme.overhangType)
    }

    func testOverhangTypeRawValues() {
        XCTAssertEqual(OverhangType.fivePrime.rawValue, "5' overhang")
        XCTAssertEqual(OverhangType.threePrime.rawValue, "3' overhang")
        XCTAssertEqual(OverhangType.blunt.rawValue, "blunt")
    }

    func testNotISiteLength() {
        let enzyme = RestrictionEnzymeDatabase.shared.enzyme(named: "NotI")!
        // NotI is an 8-cutter (GCGGCCGC)
        XCTAssertEqual(enzyme.recognitionSite.count, 8)
    }
}

// MARK: - SequenceStatisticsPlugin Metadata Tests

final class SequenceStatisticsPluginMetadataTests: XCTestCase {

    func testPluginMetadata() {
        let plugin = SequenceStatisticsPlugin()
        XCTAssertEqual(plugin.id, "com.lungfish.sequence-statistics")
        XCTAssertEqual(plugin.name, "Sequence Statistics")
        XCTAssertEqual(plugin.version, "1.0.0")
        XCTAssertFalse(plugin.description.isEmpty)
        XCTAssertEqual(plugin.category, .sequenceAnalysis)
        XCTAssertEqual(plugin.iconName, "chart.bar")
    }

    func testCapabilities() {
        let plugin = SequenceStatisticsPlugin()
        XCTAssertTrue(plugin.capabilities.contains(.worksOnSelection))
        XCTAssertTrue(plugin.capabilities.contains(.worksOnWholeSequence))
        XCTAssertTrue(plugin.capabilities.contains(.producesReport))
        XCTAssertFalse(plugin.capabilities.contains(.requiresNucleotide))
    }

    func testDefaultOptions() {
        let plugin = SequenceStatisticsPlugin()
        let options = plugin.defaultOptions
        XCTAssertTrue(options.bool(for: "showCodonUsage"))
        XCTAssertFalse(options.bool(for: "showDinucleotides"))
        XCTAssertEqual(options.integer(for: "slidingWindowSize"), 100)
    }

    func testMeltingTemperatureForOligo() async throws {
        let plugin = SequenceStatisticsPlugin()
        // 20bp oligo with known composition
        let sequence = "ATCGATCGATCGATCGATCG" // 10 GC, 10 AT = 50% GC
        let input = AnalysisInput(sequence: sequence, alphabet: .dna)
        let result = try await plugin.analyze(input)

        // Wallace rule: Tm = 4*(G+C) + 2*(A+T) = 4*10 + 2*10 = 60
        let statsSection = result.sections.first { $0.title == "Basic Statistics" }
        XCTAssertNotNil(statsSection)
        if case .keyValue(let pairs) = statsSection?.content {
            let tm = pairs.first { $0.0.contains("Tm") }
            XCTAssertNotNil(tm, "Should calculate Tm for 20bp sequence")
            XCTAssertTrue(tm?.1.contains("60.0") ?? false)
        }
    }

    func testNoMeltingTemperatureForLongSequence() async throws {
        let plugin = SequenceStatisticsPlugin()
        // 52bp -- too long for Wallace rule
        let sequence = String(repeating: "ATCG", count: 13)
        let input = AnalysisInput(sequence: sequence, alphabet: .dna)
        let result = try await plugin.analyze(input)

        let statsSection = result.sections.first { $0.title == "Basic Statistics" }
        if case .keyValue(let pairs) = statsSection?.content {
            let tm = pairs.first { $0.0.contains("Tm") }
            XCTAssertNil(tm, "Should not calculate Tm for sequences > 30bp")
        }
    }

    func testMolecularWeightDNA() async throws {
        let plugin = SequenceStatisticsPlugin()
        let sequence = "ATCG" // 4 bp
        let input = AnalysisInput(sequence: sequence, alphabet: .dna)
        let result = try await plugin.analyze(input)

        let statsSection = result.sections.first { $0.title == "Basic Statistics" }
        if case .keyValue(let pairs) = statsSection?.content {
            let mw = pairs.first { $0.0.contains("Molecular Weight") }
            XCTAssertNotNil(mw)
            // 4 * 330 = 1320 Da
            XCTAssertTrue(mw?.1.contains("1320") ?? false)
        }
    }

    func testGCSkewForLongSequence() async throws {
        let plugin = SequenceStatisticsPlugin()
        // 100 bp with known composition: all G, no C
        let sequence = String(repeating: "AG", count: 50) // 50 A, 50 G
        let input = AnalysisInput(sequence: sequence, alphabet: .dna)
        let result = try await plugin.analyze(input)

        let statsSection = result.sections.first { $0.title == "Nucleotide Statistics" }
        if case .keyValue(let pairs) = statsSection?.content {
            let gcSkew = pairs.first { $0.0.contains("GC Skew") }
            XCTAssertNotNil(gcSkew, "Should show GC skew for sequences >= 100bp")
            // GC skew = (G-C)/(G+C) = (50-0)/(50+0) = 1.0
            XCTAssertTrue(gcSkew?.1.contains("1.0000") ?? false)
        }
    }

    func testSingleBaseSequence() async throws {
        let plugin = SequenceStatisticsPlugin()
        let input = AnalysisInput(sequence: "A", alphabet: .dna)
        let result = try await plugin.analyze(input)
        XCTAssertTrue(result.isSuccess)
        XCTAssertTrue(result.summary.contains("1 bp"))
    }
}

// MARK: - TranslationPlugin Metadata Tests

final class TranslationPluginMetadataTests: XCTestCase {

    func testPluginMetadata() {
        let plugin = TranslationPlugin()
        XCTAssertEqual(plugin.id, "com.lungfish.translation")
        XCTAssertEqual(plugin.name, "Translate")
        XCTAssertEqual(plugin.version, "1.0.0")
        XCTAssertFalse(plugin.description.isEmpty)
        XCTAssertEqual(plugin.category, .sequenceOperations)
        XCTAssertEqual(plugin.iconName, "character.textbox")
    }

    func testCapabilities() {
        let plugin = TranslationPlugin()
        XCTAssertTrue(plugin.capabilities.contains(.worksOnSelection))
        XCTAssertTrue(plugin.capabilities.contains(.worksOnWholeSequence))
        XCTAssertTrue(plugin.capabilities.contains(.producesSequence))
        XCTAssertTrue(plugin.capabilities.contains(.requiresNucleotide))
        XCTAssertTrue(plugin.capabilities.contains(.supportsLivePreview))
    }

    func testDefaultOptions() {
        let plugin = TranslationPlugin()
        let options = plugin.defaultOptions
        XCTAssertEqual(options.string(for: "codonTable"), "standard")
        XCTAssertEqual(options.string(for: "frame"), "+1")
        XCTAssertTrue(options.bool(for: "showStopAsAsterisk"))
        XCTAssertFalse(options.bool(for: "trimToFirstStop"))
    }

    func testUnknownCodonTable() async throws {
        let plugin = TranslationPlugin()
        var options = OperationOptions()
        options["codonTable"] = .string("nonexistent_table")

        let input = OperationInput(sequence: "ATGGCA", alphabet: .dna, options: options)
        let result = try await plugin.transform(input)

        XCTAssertFalse(result.isSuccess)
        XCTAssertNotNil(result.errorMessage)
        XCTAssertTrue(result.errorMessage?.contains("nonexistent_table") ?? false)
    }

    func testResultMetadata() async throws {
        let plugin = TranslationPlugin()
        var options = OperationOptions()
        options["frame"] = .string("+1")

        let input = OperationInput(
            sequence: "ATGGCA",
            sequenceName: "test.fasta",
            alphabet: .dna,
            options: options
        )
        let result = try await plugin.transform(input)

        XCTAssertEqual(result.metadata["codon_table"], "standard")
        XCTAssertEqual(result.metadata["frame"], "+1")
        XCTAssertEqual(result.metadata["source_length"], "6")
    }

    func testResultSequenceName() async throws {
        let plugin = TranslationPlugin()
        var options = OperationOptions()
        options["frame"] = .string("+2")

        let input = OperationInput(
            sequence: "NATGGCA",
            sequenceName: "myseq.fasta",
            alphabet: .dna,
            options: options
        )
        let result = try await plugin.transform(input)

        XCTAssertEqual(result.sequenceName, "myseq_+2_protein")
    }

    func testEmptySequenceTranslation() async throws {
        let plugin = TranslationPlugin()
        let input = OperationInput(sequence: "", alphabet: .dna)
        let result = try await plugin.transform(input)
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.sequence, "")
    }

    func testTranslateWithSelection() async throws {
        let plugin = TranslationPlugin()
        var options = OperationOptions()
        options["frame"] = .string("+1")

        // Select only the middle ATG GCA portion
        let input = OperationInput(
            sequence: "NNATGGCANN",
            alphabet: .dna,
            selection: 2..<8,
            options: options
        )
        let result = try await plugin.transform(input)
        // Selection is "ATGGCA" -> M A
        XCTAssertEqual(result.sequence, "MA")
    }
}

// MARK: - ReverseComplementPlugin Metadata Tests

final class ReverseComplementPluginMetadataTests: XCTestCase {

    func testPluginMetadata() {
        let plugin = ReverseComplementPlugin()
        XCTAssertEqual(plugin.id, "com.lungfish.reverse-complement")
        XCTAssertEqual(plugin.name, "Reverse Complement")
        XCTAssertEqual(plugin.version, "1.0.0")
        XCTAssertFalse(plugin.description.isEmpty)
        XCTAssertEqual(plugin.category, .sequenceOperations)
        XCTAssertEqual(plugin.iconName, "arrow.uturn.backward")
    }

    func testCapabilities() {
        let plugin = ReverseComplementPlugin()
        XCTAssertTrue(plugin.capabilities.contains(.worksOnSelection))
        XCTAssertTrue(plugin.capabilities.contains(.worksOnWholeSequence))
        XCTAssertTrue(plugin.capabilities.contains(.producesSequence))
        XCTAssertTrue(plugin.capabilities.contains(.requiresNucleotide))
        XCTAssertTrue(plugin.capabilities.contains(.supportsLivePreview))
    }

    func testResultSequenceName() async throws {
        let plugin = ReverseComplementPlugin()
        let input = OperationInput(
            sequence: "ATCG",
            sequenceName: "myseq",
            alphabet: .dna
        )
        let result = try await plugin.transform(input)
        XCTAssertEqual(result.sequenceName, "myseq_rc")
    }

    func testResultAlphabet() async throws {
        let plugin = ReverseComplementPlugin()
        let input = OperationInput(sequence: "ATCG", alphabet: .rna)
        let result = try await plugin.transform(input)
        XCTAssertEqual(result.alphabet, .rna)
    }

    func testEmptySequence() async throws {
        let plugin = ReverseComplementPlugin()
        let input = OperationInput(sequence: "", alphabet: .dna)
        let result = try await plugin.transform(input)
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.sequence, "")
    }

    func testRejectsProtein() async {
        let plugin = ReverseComplementPlugin()
        let input = OperationInput(sequence: "MVLS", alphabet: .protein)
        do {
            _ = try await plugin.transform(input)
            XCTFail("Should throw for protein")
        } catch PluginError.unsupportedAlphabet {
            // Expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testWithSelection() async throws {
        let plugin = ReverseComplementPlugin()
        let input = OperationInput(
            sequence: "AAATCGAAA",
            alphabet: .dna,
            selection: 3..<6
        )
        let result = try await plugin.transform(input)
        // Selection is "TCG" -> reverse complement is "CGA"
        XCTAssertEqual(result.sequence, "CGA")
    }
}
