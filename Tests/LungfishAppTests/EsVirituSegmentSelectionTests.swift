// EsVirituSegmentSelectionTests.swift - Regression tests for segmented-virus selection behavior
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishApp
@testable import LungfishIO

@MainActor
private func makeSegmentedDetection(
    segment: String,
    accession: String,
    readCount: Int,
    assembly: String
) -> ViralDetection {
    ViralDetection(
        sampleId: "sample-1",
        name: "Segmented Test Virus",
        description: "Segment \(segment)",
        length: 1_000,
        segment: segment,
        accession: accession,
        assembly: assembly,
        assemblyLength: 2_000,
        kingdom: "Viruses",
        phylum: nil,
        tclass: nil,
        order: nil,
        family: "TestFamily",
        genus: "TestGenus",
        species: "Test species",
        subspecies: nil,
        rpkmf: 10.0,
        readCount: readCount,
        coveredBases: 900,
        meanCoverage: 12.5,
        avgReadIdentity: 0.98,
        pi: 0.01,
        filteredReadsInSample: 100_000
    )
}

@MainActor
private func makeSegmentedResult() -> EsVirituResult {
    let assemblyAccession = "GCF_123456789.1"
    let segmentL = makeSegmentedDetection(
        segment: "L",
        accession: "NC_SEG_L",
        readCount: 700,
        assembly: assemblyAccession
    )
    let segmentS = makeSegmentedDetection(
        segment: "S",
        accession: "NC_SEG_S",
        readCount: 300,
        assembly: assemblyAccession
    )
    let assembly = ViralAssembly(
        assembly: assemblyAccession,
        assemblyLength: 2_000,
        name: "Segmented Test Virus",
        family: "TestFamily",
        genus: "TestGenus",
        species: "Test species",
        totalReads: 1_000,
        rpkmf: 15.0,
        meanCoverage: 10.0,
        avgReadIdentity: 0.97,
        contigs: [segmentL, segmentS]
    )

    let windows: [ViralCoverageWindow] = [
        ViralCoverageWindow(accession: segmentL.accession, windowIndex: 0, windowStart: 0, windowEnd: 500, averageCoverage: 8.0),
        ViralCoverageWindow(accession: segmentS.accession, windowIndex: 0, windowStart: 0, windowEnd: 500, averageCoverage: 6.0),
    ]

    return EsVirituResult(
        sampleId: "sample-1",
        detections: [segmentL, segmentS],
        assemblies: [assembly],
        taxProfile: [],
        coverageWindows: windows,
        totalFilteredReads: 100_000,
        detectedFamilyCount: 1,
        detectedSpeciesCount: 1,
        runtime: nil,
        toolVersion: "test"
    )
}

@MainActor
final class EsVirituSegmentSelectionTests: XCTestCase {

    func testSelectingSegmentTargetsSegmentInDetailPane() {
        let vc = EsVirituResultViewController()
        _ = vc.view

        let result = makeSegmentedResult()
        vc.configure(result: result)

        guard let segment = result.assemblies.first?.contigs.last else {
            XCTFail("Expected segmented assembly fixture to contain a second segment")
            return
        }

        vc.testDetectionTableView.onDetectionSelected?(segment)

        XCTAssertEqual(vc.testCurrentBAMAssemblyAccession, result.assemblies[0].assembly)
        XCTAssertEqual(vc.testCurrentBAMContigAccession, segment.accession)
        XCTAssertEqual(vc.testDetailPane.testSelectedBAMAccession, segment.accession)
        XCTAssertFalse(vc.testDetailPane.testIsShowingOverview)
    }
}

