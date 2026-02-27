// VariantChromosomeResolutionTests.swift - Tests for variant chromosome candidate resolution
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishApp

final class VariantChromosomeResolutionTests: XCTestCase {

    func testResolveCandidatesPrefersExactMatch() {
        let candidates = resolveVariantChromosomeCandidates(
            requestedChromosome: "NC_048392.1",
            availableChromosomes: ["NC_048392.1", "12"],
            aliasMap: ["NC_048392.1": "12"]
        )
        XCTAssertEqual(candidates.first, "NC_048392.1")
        XCTAssertTrue(candidates.contains("12"))
    }

    func testResolveCandidatesUsesAliasWhenExactMissing() {
        let candidates = resolveVariantChromosomeCandidates(
            requestedChromosome: "NC_048392.1",
            availableChromosomes: ["12"],
            aliasMap: ["NC_048392.1": "12"]
        )
        XCTAssertEqual(candidates, ["12"])
    }

    func testResolveCandidatesFallsBackToCanonicalChrPrefix() {
        let candidates = resolveVariantChromosomeCandidates(
            requestedChromosome: "chr7",
            availableChromosomes: ["7"],
            aliasMap: [:]
        )
        XCTAssertEqual(candidates, ["7"])
    }

    func testResolveCandidatesFallsBackToCanonicalVersionStripping() {
        let candidates = resolveVariantChromosomeCandidates(
            requestedChromosome: "NC_048392.1",
            availableChromosomes: ["NC_048392"],
            aliasMap: [:]
        )
        XCTAssertEqual(candidates, ["NC_048392"])
    }

    func testResolveCandidatesSupportsReverseAliasLookup() {
        let candidates = resolveVariantChromosomeCandidates(
            requestedChromosome: "12",
            availableChromosomes: ["NC_048392.1"],
            aliasMap: ["NC_048392.1": "12"]
        )
        XCTAssertEqual(candidates, ["NC_048392.1"])
    }

    func testResolveCandidatesReturnsRequestedWhenAvailabilityUnknown() {
        let candidates = resolveVariantChromosomeCandidates(
            requestedChromosome: "NC_048392.1",
            availableChromosomes: [],
            aliasMap: [:]
        )
        XCTAssertEqual(candidates, ["NC_048392.1"])
    }
}
