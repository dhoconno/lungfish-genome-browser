import Foundation
import SQLite3
import XCTest
@testable import LungfishIO

final class MHCReferenceRecordCatalogTests: XCTestCase {
    private var workspace: URL!

    override func setUpWithError() throws {
        workspace = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent(".build", isDirectory: true)
            .appendingPathComponent("mhc-reference-catalog-tests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: workspace, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        if let workspace {
            try? FileManager.default.removeItem(at: workspace)
        }
    }

    func testAnnotatedRecordStoreOverridesLengthFallbackForGenomicDNAAndCDNA() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >NHP01222 Wrong-A*001:01, fallback description
            AAAAAAAAAAAA
            >NHP01638 Wrong-B*001:01, fallback description
            CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
            """,
            annotations: [
                .init(
                    sequenceID: "NHP01222",
                    sequenceLength: 12,
                    fields: [
                        "feature.allele": ["Mafa-A1*006:01:01:01"],
                        "feature.gene": ["A1"],
                        "feature.mol_type": ["genomic DNA"],
                    ]
                ),
                .init(
                    sequenceID: "NHP01638",
                    sequenceLength: 30,
                    fields: [
                        "feature.allele": ["Mafa-B*018:01:01:01"],
                        "feature.gene": ["B"],
                        "feature.mol_type": ["mRNA"],
                    ]
                ),
            ]
        )

        let catalog = try MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 20)

        XCTAssertEqual(
            catalog.records,
            [
                MHCReferenceRecord(
                    sequenceID: "NHP01222",
                    alleleName: "Mafa-A1*006:01:01:01",
                    locus: "Mafa-A1",
                    moleculeClass: .genomicDNA,
                    classEvidence: .annotatedMetadata,
                    sequenceLength: 12,
                    completeness: .init(
                        status: .unknown,
                        reason: .missingAnnotationDatabase,
                        acceptedTerminalExons: [7, 8]
                    )
                ),
                MHCReferenceRecord(
                    sequenceID: "NHP01638",
                    alleleName: "Mafa-B*018:01:01:01",
                    locus: "Mafa-B",
                    moleculeClass: .cDNA,
                    classEvidence: .annotatedMetadata,
                    sequenceLength: 30,
                    completeness: .init(
                        status: .incomplete,
                        reason: .nonGenomicReference,
                        acceptedTerminalExons: [7, 8]
                    )
                ),
            ]
        )
        XCTAssertEqual(catalog.record(sequenceID: "NHP01222"), catalog.records[0])
    }

    func testCompleteEightExonClassIAnnotationTopologyIsComplete() throws {
        let bundleURL = try makeAnnotatedTopologyBundle(
            sequenceID: "PROV014ff",
            alleleName: "Mamu-E*02:05:ext01",
            moleculeType: "genomic DNA",
            exonCount: 8
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 100)
                .record(sequenceID: "PROV014ff")
        )

        XCTAssertEqual(record.completeness.status, .complete)
        XCTAssertEqual(record.completeness.reason, .annotationTopology)
        XCTAssertEqual(record.completeness.observedExons, [1, 2, 3, 4, 5, 6, 7, 8])
        XCTAssertEqual(record.completeness.observedIntrons, [1, 2, 3, 4, 5, 6, 7])
        XCTAssertEqual(record.completeness.acceptedTerminalExons, [7, 8])
    }

    func testAnnotationTrackResolvesCuratedAlleleWithoutRecordStoreOrFASTADescription() throws {
        let bundleURL = try makeAnnotatedTopologyBundle(
            sequenceID: "Mamu-E*02:28_ext1|PV815705",
            alleleName: "Mamu-E*02:28_ext1",
            moleculeType: "genomic DNA",
            exonCount: 8,
            includeRecordMetadata: false,
            includeFASTADescription: false
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 100)
                .record(sequenceID: "Mamu-E*02:28_ext1|PV815705")
        )

        XCTAssertEqual(record.alleleName, "Mamu-E*02:28_ext1")
        XCTAssertEqual(record.locus, "Mamu-E")
        XCTAssertEqual(record.completeness.status, .complete)
        XCTAssertEqual(record.completeness.observedExons, [1, 2, 3, 4, 5, 6, 7, 8])
    }

    func testCompleteSevenExonClassIAnnotationTopologyIsComplete() throws {
        let bundleURL = try makeAnnotatedTopologyBundle(
            sequenceID: "PROV34221",
            alleleName: "Mamu-E*02:13:ext01",
            moleculeType: "genomic DNA",
            exonCount: 7
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 100)
                .record(sequenceID: "PROV34221")
        )

        XCTAssertEqual(record.completeness.status, .complete)
        XCTAssertEqual(record.completeness.acceptedTerminalExons, [7, 8])
    }

    func testCompleteSixExonDRBAnnotationTopologyIsComplete() throws {
        let bundleURL = try makeAnnotatedTopologyBundle(
            sequenceID: "NHP00448",
            alleleName: "Mamu-DRB1*03:03:01:01",
            moleculeType: "genomic DNA",
            exonCount: 6
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 100)
                .record(sequenceID: "NHP00448")
        )

        XCTAssertEqual(record.completeness.status, .complete)
        XCTAssertEqual(record.completeness.acceptedTerminalExons, [6])
    }

    func testUnsupportedLocusBeginningWithClassILetterRemainsUnknown() throws {
        let bundleURL = try makeAnnotatedTopologyBundle(
            sequenceID: "B2M-record",
            alleleName: "Mamu-B2M*01:01",
            moleculeType: "genomic DNA",
            exonCount: 8
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 100)
                .record(sequenceID: "B2M-record")
        )

        XCTAssertEqual(record.completeness.status, .unknown)
        XCTAssertEqual(record.completeness.reason, .unsupportedLocusTopology)
        XCTAssertTrue(record.completeness.acceptedTerminalExons.isEmpty)
    }

    func testFeaturesFromSeparateAnnotationTracksCannotFabricateCompleteTopology() throws {
        let sequenceID = "PROV-track-split"
        let alleleName = "Mamu-E*02:99:ext01"
        let exonCount = 8
        let sequenceLength = exonCount * 20 - 10
        let fasta = ">\(sequenceID) \(alleleName)\n\(String(repeating: "A", count: sequenceLength))"
        let bundleURL = try makeBundle(
            fasta: fasta,
            annotations: [
                .init(
                    sequenceID: sequenceID,
                    sequenceLength: sequenceLength,
                    fields: [
                        "feature.allele": [alleleName],
                        "feature.gene": ["E"],
                        "feature.mol_type": ["genomic DNA"],
                    ]
                ),
            ]
        )
        let annotationDirectory = bundleURL.appendingPathComponent("annotations", isDirectory: true)
        try FileManager.default.createDirectory(at: annotationDirectory, withIntermediateDirectories: true)
        let exonFeatures = (1...exonCount).map { exonNumber in
            FeatureFixture(
                sequenceID: sequenceID,
                type: "exon",
                start: (exonNumber - 1) * 20,
                end: (exonNumber - 1) * 20 + 10,
                attributes: "number=\(exonNumber)"
            )
        }
        let intronAndCDSFeatures = (1..<exonCount).map { intronNumber in
            FeatureFixture(
                sequenceID: sequenceID,
                type: "intron",
                start: (intronNumber - 1) * 20 + 10,
                end: intronNumber * 20,
                attributes: "number=\(intronNumber)"
            )
        } + [
            FeatureFixture(
                sequenceID: sequenceID,
                type: "CDS",
                start: 0,
                end: sequenceLength,
                attributes: "_lf_raw_genbank_location=1..\(sequenceLength)"
            ),
        ]
        try writeFeatureStore(at: annotationDirectory.appendingPathComponent("exons.db"), features: exonFeatures)
        try writeFeatureStore(
            at: annotationDirectory.appendingPathComponent("introns-and-cds.db"),
            features: intronAndCDSFeatures
        )
        let manifestURL = bundleURL.appendingPathComponent("manifest.json")
        var manifest = try XCTUnwrap(
            JSONSerialization.jsonObject(with: Data(contentsOf: manifestURL)) as? [String: Any]
        )
        manifest["annotations"] = [
            ["id": "exons", "database_path": "annotations/exons.db"],
            ["id": "introns-and-cds", "database_path": "annotations/introns-and-cds.db"],
        ]
        try JSONSerialization.data(withJSONObject: manifest, options: [.sortedKeys])
            .write(to: manifestURL, options: .atomic)

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 100)
                .record(sequenceID: sequenceID)
        )

        XCTAssertEqual(record.completeness.status, .unknown)
        XCTAssertEqual(record.completeness.reason, .ambiguousAnnotationEvidence)
        XCTAssertEqual(record.completeness.annotationTrackIDs, ["exons", "introns-and-cds"])
    }

    func testGenomicAnnotationTopologyMissingInterveningIntronIsIncomplete() throws {
        let bundleURL = try makeAnnotatedTopologyBundle(
            sequenceID: "NHP01629",
            alleleName: "Mamu-E*02:10:01:01",
            moleculeType: "genomic DNA",
            exonCount: 8,
            omittedIntron: 4
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 100)
                .record(sequenceID: "NHP01629")
        )

        XCTAssertEqual(record.completeness.status, .incomplete)
        XCTAssertEqual(record.completeness.reason, .missingInterveningIntrons)
        XCTAssertEqual(record.completeness.observedIntrons, [1, 2, 3, 5, 6, 7])
    }

    func testCompleteExonChainAnnotatedAsCDNARemainsNonGenomic() throws {
        let bundleURL = try makeAnnotatedTopologyBundle(
            sequenceID: "NHP00581",
            alleleName: "Mamu-E*02:01:01:01",
            moleculeType: "mRNA",
            exonCount: 8
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 100)
                .record(sequenceID: "NHP00581")
        )

        XCTAssertEqual(record.completeness.status, .incomplete)
        XCTAssertEqual(record.completeness.reason, .nonGenomicReference)
    }

    func testFuzzyCompleteLengthCDSIsIncomplete() throws {
        let bundleURL = try makeAnnotatedTopologyBundle(
            sequenceID: "fuzzy",
            alleleName: "Mamu-E*02:31",
            moleculeType: "genomic DNA",
            exonCount: 8,
            fuzzyCDS: true
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 100)
                .record(sequenceID: "fuzzy")
        )

        XCTAssertEqual(record.completeness.status, .incomplete)
        XCTAssertEqual(record.completeness.reason, .fuzzyOrIncompleteCDS)
    }

    func testMissingAnnotationDatabaseLeavesCompletenessUnknown() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >no-features Mamu-E*02:05:ext01
            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            """,
            annotations: [
                .init(
                    sequenceID: "no-features",
                    sequenceLength: 128,
                    fields: [
                        "feature.allele": ["Mamu-E*02:05:ext01"],
                        "feature.gene": ["E"],
                        "feature.mol_type": ["genomic DNA"],
                    ]
                )
            ]
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 100)
                .record(sequenceID: "no-features")
        )

        XCTAssertEqual(record.completeness.status, .unknown)
        XCTAssertEqual(record.completeness.reason, .missingAnnotationDatabase)
    }

    func testFASTAOnlyFallbackUsesDescriptionAndStrictLengthThreshold() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >short Mafa-A1*006:01:02, A1 locus allele.
            AAAAAAAAAAA
            >boundary Mafa-B*018:01, B locus allele.
            CCCCCCCCCCCC
            """,
            annotations: nil
        )

        let first = try MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 12)
        let second = try MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 12)

        XCTAssertEqual(first, second)
        XCTAssertEqual(first.records.map(\.sequenceID), ["short", "boundary"])
        XCTAssertEqual(first.records[0].alleleName, "Mafa-A1*006:01:02")
        XCTAssertEqual(first.records[0].locus, "Mafa-A1")
        XCTAssertEqual(first.records[0].moleculeClass, .cDNA)
        XCTAssertEqual(first.records[0].classEvidence, .lengthThresholdFallback)
        XCTAssertEqual(first.records[0].sequenceLength, 11)
        XCTAssertEqual(first.records[1].moleculeClass, .genomicDNA)
        XCTAssertEqual(first.records[1].sequenceLength, 12)
    }

    func testFASTAOnlyFallbackAcceptsStructuredLegacyIPDMHCSequenceIDs() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >01_Mamu-A1_001_05_01_01
            AAAAAAAAAA
            >09_Mamu-DQA1_26g2|DQA1_26_02_01,DQA1_26_02_02,DQA1_26_06,DQA1_26_09
            CCCCCCCCCC
            >08_Mamu-DRB_W006_06
            GGGGGGGGGG
            >01_Mamu-A1_123|A1_123_01,A1_123_03_01_01,A1_123_04
            TTTTTTTTTT
            >08_Mamu-DRB_W006g|DRB_W006_09_02,DRB_W006_09_03
            ACACACACAC
            >04_Mamu-B_035_B049g|B_035_01_01_01,B_049_01_01_01
            GTGTGTGTGT
            """,
            annotations: nil
        )

        let records = try MHCReferenceRecordCatalog.load(from: bundleURL).records

        XCTAssertEqual(
            records.map(\.alleleName),
            [
                "01_Mamu-A1_001_05_01_01",
                "09_Mamu-DQA1_26g2|DQA1_26_02_01,DQA1_26_02_02,DQA1_26_06,DQA1_26_09",
                "08_Mamu-DRB_W006_06",
                "01_Mamu-A1_123|A1_123_01,A1_123_03_01_01,A1_123_04",
                "08_Mamu-DRB_W006g|DRB_W006_09_02,DRB_W006_09_03",
                "04_Mamu-B_035_B049g|B_035_01_01_01,B_049_01_01_01",
            ]
        )
        XCTAssertEqual(
            records.map(\.locus),
            ["Mamu-A1", "Mamu-DQA1", "Mamu-DRB", "Mamu-A1", "Mamu-DRB", "Mamu-B"]
        )
        XCTAssertTrue(records.allSatisfy { $0.moleculeClass == .cDNA })
        XCTAssertTrue(records.allSatisfy { $0.classEvidence == .lengthThresholdFallback })
    }

    func testFASTAOnlyFallbackRejectsMalformedLegacyIPDMHCSequenceIDs() throws {
        let malformedSequenceIDs = [
            "08_Mamu-A1_W006_06",
            "01_Mamu-A1_001_bad",
            "08_Mamu-DRB_Wfoo",
            "08_Mamu-DRB_W006_extra",
            "08_Mamu-A1_W006g|A1_006_01",
            "09_Mamu-DQA1_26g2|DQA1_26_bad",
        ]

        for sequenceID in malformedSequenceIDs {
            let bundleURL = try makeBundle(
                fasta: """
                >\(sequenceID)
                AAAAAAAAAA
                """,
                annotations: nil
            )

            XCTAssertThrowsError(try MHCReferenceRecordCatalog.load(from: bundleURL)) { error in
                XCTAssertEqual(
                    error as? MHCReferenceRecordCatalogError,
                    .unresolvedAlleleOrLocus(sequenceID: sequenceID)
                )
            }
        }
    }

    func testMissingRecordFieldsFallBackIndependentlyToFASTAAndLength() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >NHP10000 Mafa-I*001:02, I locus allele.
            AAAAAAAAAA
            """,
            annotations: [
                .init(
                    sequenceID: "NHP10000",
                    sequenceLength: 10,
                    fields: ["feature.gene": ["I"]]
                )
            ]
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 20)
                .record(sequenceID: "NHP10000")
        )

        XCTAssertEqual(record.alleleName, "Mafa-I*001:02")
        XCTAssertEqual(record.locus, "Mafa-I")
        XCTAssertEqual(record.moleculeClass, .cDNA)
        XCTAssertEqual(record.classEvidence, .lengthThresholdFallback)
    }

    func testConflictingAnnotatedMoleculeClassesThrowTypedActionableError() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >NHP-conflict Mafa-A1*001:01, A1 locus allele.
            AAAAAAAAAA
            """,
            annotations: [
                .init(
                    sequenceID: "NHP-conflict",
                    sequenceLength: 10,
                    fields: [
                        "feature.allele": ["Mafa-A1*001:01"],
                        "feature.gene": ["A1"],
                        "feature.mol_type": ["genomic DNA", "mRNA"],
                    ]
                )
            ]
        )

        XCTAssertThrowsError(try MHCReferenceRecordCatalog.load(from: bundleURL)) { error in
            guard case let MHCReferenceRecordCatalogError.conflictingMoleculeClasses(sequenceID, values) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(sequenceID, "NHP-conflict")
            XCTAssertEqual(values, ["genomic DNA", "mRNA"])
            XCTAssertTrue(error.localizedDescription.contains("NHP-conflict"))
        }
    }

    func testUnknownAnnotatedMoleculeTypeDoesNotFallBackToLength() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >NHP-unknown-mol Mafa-A1*001:01, A1 locus allele.
            AAAAAAAAAA
            """,
            annotations: [
                .init(
                    sequenceID: "NHP-unknown-mol",
                    sequenceLength: 10,
                    fields: [
                        "feature.allele": ["Mafa-A1*001:01"],
                        "feature.gene": ["A1"],
                        "feature.mol_type": ["synthetic construct"],
                    ]
                )
            ]
        )

        XCTAssertThrowsError(try MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 20)) { error in
            guard case let MHCReferenceRecordCatalogError.unsupportedMoleculeTypeValues(sequenceID, values) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(sequenceID, "NHP-unknown-mol")
            XCTAssertEqual(values, ["synthetic construct"])
        }
    }

    func testRecognizedAndUnknownMoleculeTypesDoNotSilentlyUseRecognizedValue() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >NHP-mixed-mol Mafa-A1*001:01, A1 locus allele.
            AAAAAAAAAA
            """,
            annotations: [
                .init(
                    sequenceID: "NHP-mixed-mol",
                    sequenceLength: 10,
                    fields: [
                        "feature.allele": ["Mafa-A1*001:01"],
                        "feature.gene": ["A1"],
                        "feature.mol_type": ["mRNA", "not classified"],
                    ]
                )
            ]
        )

        XCTAssertThrowsError(try MHCReferenceRecordCatalog.load(from: bundleURL, cdnaThreshold: 20)) { error in
            guard case let MHCReferenceRecordCatalogError.unsupportedMoleculeTypeValues(sequenceID, values) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(sequenceID, "NHP-mixed-mol")
            XCTAssertEqual(values, ["not classified"])
        }
    }

    func testMalformedAnnotatedAlleleDoesNotFallBackToValidHeaderAllele() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >NHP-malformed Mafa-A1*001:01, valid fallback must not mask malformed metadata.
            AAAAAAAAAA
            """,
            annotations: [
                .init(
                    sequenceID: "NHP-malformed",
                    sequenceLength: 10,
                    fields: [
                        "feature.allele": ["123-456*789"],
                        "feature.gene": ["A1"],
                        "feature.mol_type": ["mRNA"],
                    ]
                )
            ]
        )

        XCTAssertThrowsError(try MHCReferenceRecordCatalog.load(from: bundleURL)) { error in
            guard case let MHCReferenceRecordCatalogError.invalidAlleleAnnotations(sequenceID, values) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(sequenceID, "NHP-malformed")
            XCTAssertEqual(values, ["123-456*789"])
        }
    }

    func testAmbiguousFASTAHeaderAllelesThrowInsteadOfChoosingFirstToken() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >NHP-ambiguous Mafa-A1*001:01 compared with Mafa-B*002:01.
            AAAAAAAAAA
            """,
            annotations: nil
        )

        XCTAssertThrowsError(try MHCReferenceRecordCatalog.load(from: bundleURL)) { error in
            guard case let MHCReferenceRecordCatalogError.ambiguousFASTAAlleles(sequenceID, candidates) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(sequenceID, "NHP-ambiguous")
            XCTAssertEqual(candidates, ["Mafa-A1*001:01", "Mafa-B*002:01"])
        }
    }

    func testRealisticNullAlleleSuffixIsAcceptedFromFASTAHeader() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >NHP-null Mafa-B*086:01:02:01N, B locus allele.
            AAAAAAAAAA
            """,
            annotations: nil
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL)
                .record(sequenceID: "NHP-null")
        )

        XCTAssertEqual(record.alleleName, "Mafa-B*086:01:02:01N")
        XCTAssertEqual(record.locus, "Mafa-B")
    }

    func testEstablishedDRBWAlleleIsAcceptedFromAnnotations() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >NHP00524 Mamu-DRB*W001:01, DRB locus allele.
            AAAAAAAAAA
            """,
            annotations: [
                .init(
                    sequenceID: "NHP00524",
                    sequenceLength: 10,
                    fields: [
                        "feature.allele": ["Mamu-DRB*W001:01"],
                        "feature.gene": ["DRB"],
                        "feature.mol_type": ["genomic DNA"],
                    ]
                )
            ]
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL)
                .record(sequenceID: "NHP00524")
        )

        XCTAssertEqual(record.alleleName, "Mamu-DRB*W001:01")
        XCTAssertEqual(record.locus, "Mamu-DRB")
    }

    func testEstablishedDRBWAlleleIsAcceptedFromFASTAHeader() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >NHP00527 Mamu-DRB*W020:02:01:01, DRB locus allele.
            AAAAAAAAAA
            """,
            annotations: nil
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL)
                .record(sequenceID: "NHP00527")
        )

        XCTAssertEqual(record.alleleName, "Mamu-DRB*W020:02:01:01")
        XCTAssertEqual(record.locus, "Mamu-DRB")
    }

    func testUnknownAlphabeticPrimaryAllelePrefixRemainsRejected() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >unknown-prefix reference record
            AAAAAAAAAA
            """,
            annotations: [
                .init(
                    sequenceID: "unknown-prefix",
                    sequenceLength: 10,
                    fields: [
                        "feature.allele": ["Mamu-DRB*X001:01"],
                        "feature.gene": ["DRB"],
                        "feature.mol_type": ["genomic DNA"],
                    ]
                )
            ]
        )

        XCTAssertThrowsError(try MHCReferenceRecordCatalog.load(from: bundleURL)) { error in
            guard case let MHCReferenceRecordCatalogError.invalidAlleleAnnotations(sequenceID, values) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(sequenceID, "unknown-prefix")
            XCTAssertEqual(values, ["Mamu-DRB*X001:01"])
        }
    }

    func testWPrimaryAllelePrefixRemainsRestrictedToDRBLoci() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >wrong-locus reference record
            AAAAAAAAAA
            """,
            annotations: [
                .init(
                    sequenceID: "wrong-locus",
                    sequenceLength: 10,
                    fields: [
                        "feature.allele": ["Mamu-A1*W001:01"],
                        "feature.gene": ["A1"],
                        "feature.mol_type": ["genomic DNA"],
                    ]
                )
            ]
        )

        XCTAssertThrowsError(try MHCReferenceRecordCatalog.load(from: bundleURL)) { error in
            guard case let MHCReferenceRecordCatalogError.invalidAlleleAnnotations(sequenceID, values) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(sequenceID, "wrong-locus")
            XCTAssertEqual(values, ["Mamu-A1*W001:01"])
        }
    }

    func testControlledProvisionalAlleleFieldsAreAcceptedFromAnnotations() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >PROV-ext provisional extension
            AAAAAAAAAA
            >PROV-new provisional sequence
            CCCCCCCCCC
            >PROV-unassigned provisional sequence
            GGGGGGGGGG
            """,
            annotations: [
                .init(
                    sequenceID: "PROV-ext",
                    sequenceLength: 10,
                    fields: [
                        "feature.allele": ["Mamu-E*02:16:ext01"],
                        "feature.gene": ["E"],
                        "feature.mol_type": ["genomic DNA"],
                    ]
                ),
                .init(
                    sequenceID: "PROV-new",
                    sequenceLength: 10,
                    fields: [
                        "feature.allele": ["Mamu-E*02:new14:new01"],
                        "feature.gene": ["E"],
                        "feature.mol_type": ["genomic DNA"],
                    ]
                ),
                .init(
                    sequenceID: "PROV-unassigned",
                    sequenceLength: 10,
                    fields: [
                        "feature.allele": ["Mamu-E*000:new01"],
                        "feature.gene": ["E"],
                        "feature.mol_type": ["genomic DNA"],
                    ]
                ),
            ]
        )

        let records = try MHCReferenceRecordCatalog.load(from: bundleURL).records

        XCTAssertEqual(
            records.map(\.alleleName),
            ["Mamu-E*02:16:ext01", "Mamu-E*02:new14:new01", "Mamu-E*000:new01"]
        )
        XCTAssertEqual(records.map(\.locus), ["Mamu-E", "Mamu-E", "Mamu-E"])
    }

    func testControlledProvisionalAlleleFieldIsAcceptedFromFASTAHeader() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >PROV-header Mamu-E*02:new14:new01, E locus provisional allele.
            AAAAAAAAAA
            """,
            annotations: nil
        )

        let record = try XCTUnwrap(
            MHCReferenceRecordCatalog.load(from: bundleURL)
                .record(sequenceID: "PROV-header")
        )

        XCTAssertEqual(record.alleleName, "Mamu-E*02:new14:new01")
        XCTAssertEqual(record.locus, "Mamu-E")
    }

    func testMalformedProvisionalAlleleFieldsRemainRejected() throws {
        let malformedValues = [
            "Mamu-E*ext01",
            "Mamu-E*02:ext",
            "Mamu-E*02:other01",
            "Mamu-E*02::new01",
        ]

        for malformedValue in malformedValues {
            let bundleURL = try makeBundle(
                fasta: """
                >PROV-malformed provisional sequence
                AAAAAAAAAA
                """,
                annotations: [
                    .init(
                        sequenceID: "PROV-malformed",
                        sequenceLength: 10,
                        fields: [
                            "feature.allele": [malformedValue],
                            "feature.gene": ["E"],
                            "feature.mol_type": ["genomic DNA"],
                        ]
                    )
                ]
            )

            XCTAssertThrowsError(
                try MHCReferenceRecordCatalog.load(from: bundleURL),
                "Expected \(malformedValue) to be rejected"
            ) { error in
                guard case let MHCReferenceRecordCatalogError.invalidAlleleAnnotations(
                    sequenceID,
                    values
                ) = error else {
                    return XCTFail("Unexpected error for \(malformedValue): \(error)")
                }
                XCTAssertEqual(sequenceID, "PROV-malformed")
                XCTAssertEqual(values, [malformedValue])
            }
        }
    }

    func testNoResolvableAlleleOrLocusThrowsTypedActionableError() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >NHP-unnamed sequence without allele metadata
            AAAAAAAAAA
            """,
            annotations: [
                .init(
                    sequenceID: "NHP-unnamed",
                    sequenceLength: 10,
                    fields: ["feature.mol_type": ["genomic DNA"]]
                )
            ]
        )

        XCTAssertThrowsError(try MHCReferenceRecordCatalog.load(from: bundleURL)) { error in
            guard case let MHCReferenceRecordCatalogError.unresolvedAlleleOrLocus(sequenceID) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(sequenceID, "NHP-unnamed")
            XCTAssertTrue(error.localizedDescription.contains("NHP-unnamed"))
        }
    }

    func testRecordStoreIsOpenedReadOnlyAndDoesNotCreateSQLiteSidecars() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >read-only Mafa-A4*001:01, A4 locus allele.
            AAAAAAAAAA
            """,
            annotations: [
                .init(
                    sequenceID: "read-only",
                    sequenceLength: 10,
                    fields: [
                        "feature.allele": ["Mafa-A4*001:01"],
                        "feature.gene": ["A4"],
                        "feature.mol_type": ["mRNA"],
                    ]
                )
            ]
        )
        let databaseURL = bundleURL.appendingPathComponent("metadata/records.sqlite")
        let attributesBefore = try FileManager.default.attributesOfItem(atPath: databaseURL.path)
        try FileManager.default.setAttributes([.posixPermissions: 0o444], ofItemAtPath: databaseURL.path)

        let catalog = try MHCReferenceRecordCatalog.load(from: bundleURL)

        XCTAssertEqual(catalog.records.count, 1)
        XCTAssertFalse(FileManager.default.fileExists(atPath: databaseURL.path + "-wal"))
        XCTAssertFalse(FileManager.default.fileExists(atPath: databaseURL.path + "-shm"))
        let attributesAfter = try FileManager.default.attributesOfItem(atPath: databaseURL.path)
        XCTAssertEqual(attributesBefore[.size] as? NSNumber, attributesAfter[.size] as? NSNumber)
    }

    func testRejectsReferencePayloadSymlinkThatEscapesBundle() throws {
        let bundleURL = try makeBundle(
            fasta: """
            >inside Mafa-A1*001:01, A1 locus allele.
            AAAAAAAAAA
            """,
            annotations: nil
        )
        let outsideFASTA = workspace.appendingPathComponent("outside.fa")
        try Data(">outside Mafa-B*001:01\nAAAAAAAAAA\n".utf8).write(to: outsideFASTA)
        let fastaURL = bundleURL.appendingPathComponent("genome/reference.fa")
        try FileManager.default.removeItem(at: fastaURL)
        try FileManager.default.createSymbolicLink(at: fastaURL, withDestinationURL: outsideFASTA)

        XCTAssertThrowsError(try MHCReferenceRecordCatalog.load(from: bundleURL)) { error in
            guard case let MHCReferenceRecordCatalogError.unsafeBundlePath(field, path) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(field, "genome.path")
            XCTAssertEqual(path, "genome/reference.fa")
        }
    }

    private struct AnnotationFixture {
        let sequenceID: String
        let sequenceLength: Int
        let fields: [String: [String]]
    }

    private struct FeatureFixture {
        let sequenceID: String
        let type: String
        let start: Int
        let end: Int
        let attributes: String
    }

    private func makeAnnotatedTopologyBundle(
        sequenceID: String,
        alleleName: String,
        moleculeType: String,
        exonCount: Int,
        omittedIntron: Int? = nil,
        fuzzyCDS: Bool = false,
        includeRecordMetadata: Bool = true,
        includeFASTADescription: Bool = true
    ) throws -> URL {
        let sequenceLength = exonCount * 20 - 10
        let description = includeFASTADescription ? " \(alleleName)" : ""
        let fasta = ">\(sequenceID)\(description)\n" + String(repeating: "A", count: sequenceLength)
        var features: [FeatureFixture] = []
        for exonNumber in 1...exonCount {
            let exonStart = (exonNumber - 1) * 20
            features.append(.init(
                sequenceID: sequenceID,
                type: "exon",
                start: exonStart,
                end: exonStart + 10,
                attributes: "gene=\(alleleName.split(separator: "*").first?.split(separator: "-").last ?? "");number=\(exonNumber)"
            ))
            if exonNumber < exonCount, exonNumber != omittedIntron {
                features.append(.init(
                    sequenceID: sequenceID,
                    type: "intron",
                    start: exonStart + 10,
                    end: exonStart + 20,
                    attributes: "number=\(exonNumber)"
                ))
            }
        }
        let rawCDSStart = fuzzyCDS ? "%3C1" : "1"
        features.append(.init(
            sequenceID: sequenceID,
            type: "CDS",
            start: 0,
            end: sequenceLength,
            attributes: "_lf_raw_genbank_location=\(rawCDSStart)..\(sequenceLength);allele=\(alleleName);gene=\(alleleName.split(separator: "*").first?.split(separator: "-").last ?? "")"
        ))
        return try makeBundle(
            fasta: fasta,
            annotations: includeRecordMetadata ? [
                .init(
                    sequenceID: sequenceID,
                    sequenceLength: sequenceLength,
                    fields: [
                        "feature.allele": [alleleName],
                        "feature.gene": [String(alleleName.split(separator: "*").first?.split(separator: "-").last ?? "")],
                        "feature.mol_type": [moleculeType],
                    ]
                )
            ] : nil,
            features: features
        )
    }

    private func makeBundle(
        fasta: String,
        annotations: [AnnotationFixture]?,
        features: [FeatureFixture]? = nil
    ) throws -> URL {
        let bundleURL = workspace.appendingPathComponent("fixture-\(UUID().uuidString).lungfishref", isDirectory: true)
        let genomeDirectory = bundleURL.appendingPathComponent("genome", isDirectory: true)
        try FileManager.default.createDirectory(at: genomeDirectory, withIntermediateDirectories: true)
        try Data((fasta + "\n").utf8).write(to: genomeDirectory.appendingPathComponent("reference.fa"))

        var manifest: [String: Any] = [
            "genome": ["path": "genome/reference.fa"],
        ]

        if let annotations {
            let metadataDirectory = bundleURL.appendingPathComponent("metadata", isDirectory: true)
            try FileManager.default.createDirectory(at: metadataDirectory, withIntermediateDirectories: true)
            let databaseURL = metadataDirectory.appendingPathComponent("records.sqlite")
            try writeRecordStore(at: databaseURL, records: annotations)
            manifest["record_store"] = ["database_path": "metadata/records.sqlite"]
        }

        if let features {
            let annotationDirectory = bundleURL.appendingPathComponent("annotations", isDirectory: true)
            try FileManager.default.createDirectory(at: annotationDirectory, withIntermediateDirectories: true)
            let databaseURL = annotationDirectory.appendingPathComponent("features.db")
            try writeFeatureStore(at: databaseURL, features: features)
            manifest["annotations"] = [[
                "id": "imported_annotations",
                "database_path": "annotations/features.db",
            ]]
        }

        let manifestData = try JSONSerialization.data(withJSONObject: manifest, options: [.sortedKeys])
        try manifestData.write(to: bundleURL.appendingPathComponent("manifest.json"))
        return bundleURL
    }

    private func writeFeatureStore(at url: URL, features: [FeatureFixture]) throws {
        var database: OpaquePointer?
        XCTAssertEqual(sqlite3_open(url.path, &database), SQLITE_OK)
        guard let database else {
            throw NSError(domain: "MHCReferenceRecordCatalogTests", code: 3)
        }
        defer { sqlite3_close(database) }

        try execute(
            """
            CREATE TABLE annotations (
                name TEXT NOT NULL,
                type TEXT NOT NULL,
                chromosome TEXT NOT NULL,
                start INTEGER NOT NULL,
                end INTEGER NOT NULL,
                strand TEXT NOT NULL DEFAULT '.',
                attributes TEXT,
                block_count INTEGER,
                block_sizes TEXT,
                block_starts TEXT,
                gene_name TEXT
            );
            """,
            in: database
        )
        for feature in features {
            try execute(
                "INSERT INTO annotations (name,type,chromosome,start,end,strand,attributes) VALUES (\(quoted(feature.sequenceID)),\(quoted(feature.type)),\(quoted(feature.sequenceID)),\(feature.start),\(feature.end),'.',\(quoted(feature.attributes)));",
                in: database
            )
        }
    }

    private func writeRecordStore(at url: URL, records: [AnnotationFixture]) throws {
        var database: OpaquePointer?
        XCTAssertEqual(sqlite3_open(url.path, &database), SQLITE_OK)
        guard let database else {
            throw NSError(domain: "MHCReferenceRecordCatalogTests", code: 1)
        }
        defer { sqlite3_close(database) }

        try execute(
            """
            CREATE TABLE records (
                id INTEGER PRIMARY KEY,
                sequence_name TEXT NOT NULL UNIQUE,
                sequence_length INTEGER NOT NULL,
                source_ordinal INTEGER NOT NULL
            );
            CREATE TABLE field_values (
                record_id INTEGER NOT NULL,
                field_key TEXT NOT NULL,
                value_ordinal INTEGER NOT NULL,
                value TEXT NOT NULL,
                PRIMARY KEY (record_id, field_key, value_ordinal)
            );
            """,
            in: database
        )

        for (recordOffset, record) in records.enumerated() {
            let recordID = recordOffset + 1
            try execute(
                "INSERT INTO records VALUES (\(recordID), \(quoted(record.sequenceID)), \(record.sequenceLength), \(recordOffset));",
                in: database
            )
            for fieldKey in record.fields.keys.sorted() {
                for (valueOrdinal, value) in (record.fields[fieldKey] ?? []).enumerated() {
                    try execute(
                        "INSERT INTO field_values VALUES (\(recordID), \(quoted(fieldKey)), \(valueOrdinal), \(quoted(value)));",
                        in: database
                    )
                }
            }
        }
    }

    private func execute(_ sql: String, in database: OpaquePointer) throws {
        var errorMessage: UnsafeMutablePointer<CChar>?
        guard sqlite3_exec(database, sql, nil, nil, &errorMessage) == SQLITE_OK else {
            let message = errorMessage.map { String(cString: $0) } ?? "SQLite error"
            sqlite3_free(errorMessage)
            throw NSError(domain: "MHCReferenceRecordCatalogTests", code: 2, userInfo: [NSLocalizedDescriptionKey: message])
        }
    }

    private func quoted(_ value: String) -> String {
        "'\(value.replacingOccurrences(of: "'", with: "''"))'"
    }
}
