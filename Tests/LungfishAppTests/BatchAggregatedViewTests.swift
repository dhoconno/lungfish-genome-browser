// BatchAggregatedViewTests.swift - Tests for BatchClassificationRow and BatchEsVirituRow
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishApp
@testable import LungfishIO

// MARK: - BatchClassificationRow Tests

final class BatchClassificationRowTests: XCTestCase {

    // MARK: - Init

    func testBatchClassificationRowInit() {
        let row = BatchClassificationRow(
            sample: "sample-A",
            taxonName: "Escherichia coli",
            taxId: 562,
            rank: "S",
            rankDisplayName: "Species",
            readsDirect: 1000,
            readsClade: 1200,
            percentage: 12.0
        )

        XCTAssertEqual(row.sample, "sample-A")
        XCTAssertEqual(row.taxonName, "Escherichia coli")
        XCTAssertEqual(row.taxId, 562)
        XCTAssertEqual(row.rank, "S")
        XCTAssertEqual(row.rankDisplayName, "Species")
        XCTAssertEqual(row.readsDirect, 1000)
        XCTAssertEqual(row.readsClade, 1200)
        XCTAssertEqual(row.percentage, 12.0, accuracy: 0.001)
    }

    // MARK: - fromTree

    func testFromTreeProducesRowsForNonRootNonUnclassified() throws {
        // Minimal kreport with root, one domain, one species, and unclassified.
        // Columns: pct TAB clade TAB direct TAB rank TAB taxId TAB name(indented)
        let kreport = "10.00\t1000\t0\tU\t0\tunclassified\n" +
                      "90.00\t9000\t0\tR\t1\troot\n" +
                      "80.00\t8000\t100\tD\t2\t  Bacteria\n" +
                      "50.00\t5000\t5000\tS\t562\t    Escherichia coli\n"

        let tree = try KreportParser.parse(text: kreport)
        let rows = BatchClassificationRow.fromTree(tree, sampleId: "test-sample")

        // root (taxId 1) and unclassified should be excluded
        XCTAssertFalse(rows.contains(where: { $0.taxId == 1 }), "Root node should be excluded")
        XCTAssertFalse(rows.contains(where: { $0.rank == "U" }), "Unclassified should be excluded")

        // Domain Bacteria should be present
        let bacteriaRow = rows.first(where: { $0.taxonName == "Bacteria" })
        XCTAssertNotNil(bacteriaRow, "Bacteria row should be present")
        XCTAssertEqual(bacteriaRow?.sample, "test-sample")
        XCTAssertEqual(bacteriaRow?.rank, "D")
        XCTAssertEqual(bacteriaRow?.rankDisplayName, "Domain")
        XCTAssertEqual(bacteriaRow?.readsDirect, 100)
        XCTAssertEqual(bacteriaRow?.readsClade, 8000)
        XCTAssertEqual(bacteriaRow?.percentage ?? 0, 80.0, accuracy: 0.01)

        // Species E. coli should be present
        let ecoliRow = rows.first(where: { $0.taxId == 562 })
        XCTAssertNotNil(ecoliRow, "E. coli row should be present")
        XCTAssertEqual(ecoliRow?.taxonName, "Escherichia coli")
        XCTAssertEqual(ecoliRow?.rank, "S")
        XCTAssertEqual(ecoliRow?.rankDisplayName, "Species")
        XCTAssertEqual(ecoliRow?.readsDirect, 5000)
        XCTAssertEqual(ecoliRow?.readsClade, 5000)
        XCTAssertEqual(ecoliRow?.percentage ?? 0, 50.0, accuracy: 0.01)
    }

    func testFromTreeSampleIdPropagated() throws {
        let kreport = "0.00\t0\t0\tU\t0\tunclassified\n" +
                      "100.00\t1000\t0\tR\t1\troot\n" +
                      "80.00\t800\t800\tD\t2\t  Bacteria\n"

        let tree = try KreportParser.parse(text: kreport)
        let rows = BatchClassificationRow.fromTree(tree, sampleId: "my-sample-id")

        XCTAssertTrue(rows.allSatisfy { $0.sample == "my-sample-id" })
    }

    func testFromTreePercentageCalculation() throws {
        let kreport = "0.00\t0\t0\tU\t0\tunclassified\n" +
                      "100.00\t10000\t0\tR\t1\troot\n" +
                      "25.00\t2500\t2500\tS\t9606\t  Homo sapiens\n"

        let tree = try KreportParser.parse(text: kreport)
        let rows = BatchClassificationRow.fromTree(tree, sampleId: "pct-test")

        let humanRow = rows.first(where: { $0.taxId == 9606 })
        XCTAssertNotNil(humanRow)
        // fractionClade is 0.25, so percentage = 25.0
        XCTAssertEqual(humanRow?.percentage ?? 0, 25.0, accuracy: 0.01)
    }
}

// MARK: - BatchEsVirituRow Tests

final class BatchEsVirituRowTests: XCTestCase {

    // MARK: - Init

    func testBatchEsVirituRowInit() {
        let row = BatchEsVirituRow(
            sample: "sample-B",
            virusName: "SARS-CoV-2",
            family: "Coronaviridae",
            assembly: "GCF_009858895.2",
            readCount: 5000,
            uniqueReads: 4800,
            rpkmf: 123.4,
            coverageBreadth: 0.95,
            coverageDepth: 45.2
        )

        XCTAssertEqual(row.sample, "sample-B")
        XCTAssertEqual(row.virusName, "SARS-CoV-2")
        XCTAssertEqual(row.family, "Coronaviridae")
        XCTAssertEqual(row.assembly, "GCF_009858895.2")
        XCTAssertEqual(row.readCount, 5000)
        XCTAssertEqual(row.uniqueReads, 4800)
        XCTAssertEqual(row.rpkmf, 123.4, accuracy: 0.001)
        XCTAssertEqual(row.coverageBreadth, 0.95, accuracy: 0.0001)
        XCTAssertEqual(row.coverageDepth, 45.2, accuracy: 0.001)
    }

    func testBatchEsVirituRowInitWithNilFamily() {
        let row = BatchEsVirituRow(
            sample: "sample-C",
            virusName: "Unknown Virus",
            family: nil,
            assembly: "unknown-assembly",
            readCount: 10,
            uniqueReads: 0,
            rpkmf: 0.5,
            coverageBreadth: 0,
            coverageDepth: 1.0
        )

        XCTAssertNil(row.family)
    }

    // MARK: - fromAssemblies

    func testFromAssembliesProducesCorrectRows() {
        let assembly1 = ViralAssembly(
            assembly: "GCF_001",
            assemblyLength: 30_000,
            name: "SARS-CoV-2",
            family: "Coronaviridae",
            genus: "Betacoronavirus",
            species: "Severe acute respiratory syndrome-related coronavirus",
            totalReads: 8000,
            rpkmf: 200.0,
            meanCoverage: 55.0,
            avgReadIdentity: 0.99,
            contigs: []
        )

        let assembly2 = ViralAssembly(
            assembly: "GCF_002",
            assemblyLength: 11_000,
            name: "Influenza A",
            family: "Orthomyxoviridae",
            genus: "Alphainfluenzavirus",
            species: "Influenza A virus",
            totalReads: 3000,
            rpkmf: 75.0,
            meanCoverage: 20.0,
            avgReadIdentity: 0.97,
            contigs: []
        )

        let rows = BatchEsVirituRow.fromAssemblies([assembly1, assembly2], sampleId: "batch-sample")

        XCTAssertEqual(rows.count, 2)

        XCTAssertTrue(rows.allSatisfy { $0.sample == "batch-sample" })

        let covidRow = rows.first(where: { $0.assembly == "GCF_001" })
        XCTAssertNotNil(covidRow)
        XCTAssertEqual(covidRow?.virusName, "SARS-CoV-2")
        XCTAssertEqual(covidRow?.family, "Coronaviridae")
        XCTAssertEqual(covidRow?.readCount, 8000)
        XCTAssertEqual(covidRow?.rpkmf ?? 0, 200.0, accuracy: 0.001)
        XCTAssertEqual(covidRow?.coverageDepth ?? 0, 55.0, accuracy: 0.001)
        // uniqueReads and coverageBreadth are placeholders (0) in the current impl
        XCTAssertEqual(covidRow?.uniqueReads, 0)
        XCTAssertEqual(covidRow?.coverageBreadth ?? 0, 0.0, accuracy: 0.0001)

        let fluRow = rows.first(where: { $0.assembly == "GCF_002" })
        XCTAssertNotNil(fluRow)
        XCTAssertEqual(fluRow?.virusName, "Influenza A")
        XCTAssertEqual(fluRow?.family, "Orthomyxoviridae")
        XCTAssertEqual(fluRow?.readCount, 3000)
        XCTAssertEqual(fluRow?.rpkmf ?? 0, 75.0, accuracy: 0.001)
        XCTAssertEqual(fluRow?.coverageDepth ?? 0, 20.0, accuracy: 0.001)
    }

    func testFromAssembliesEmptyInput() {
        let rows = BatchEsVirituRow.fromAssemblies([], sampleId: "empty-sample")
        XCTAssertTrue(rows.isEmpty)
    }

    func testFromAssembliesSampleIdPropagated() {
        let assembly = ViralAssembly(
            assembly: "GCF_003",
            assemblyLength: 5_000,
            name: "Test Virus",
            family: nil,
            genus: nil,
            species: nil,
            totalReads: 100,
            rpkmf: 5.0,
            meanCoverage: 2.0,
            avgReadIdentity: 0.95,
            contigs: []
        )

        let rows = BatchEsVirituRow.fromAssemblies([assembly], sampleId: "propagation-test")
        XCTAssertEqual(rows.count, 1)
        XCTAssertEqual(rows[0].sample, "propagation-test")
    }
}
