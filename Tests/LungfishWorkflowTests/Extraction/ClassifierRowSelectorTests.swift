// ClassifierRowSelectorTests.swift — Value-type tests for the selector + tool enum
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishWorkflow

final class ClassifierRowSelectorTests: XCTestCase {

    // MARK: - ClassifierTool

    func testClassifierTool_allCasesCovered() {
        let expected: Set<ClassifierTool> = [.esviritu, .taxtriage, .kraken2, .naomgs, .nvd]
        XCTAssertEqual(Set(ClassifierTool.allCases), expected)
    }

    func testClassifierTool_rawValuesAreStableAndLowercase() {
        XCTAssertEqual(ClassifierTool.esviritu.rawValue, "esviritu")
        XCTAssertEqual(ClassifierTool.taxtriage.rawValue, "taxtriage")
        XCTAssertEqual(ClassifierTool.kraken2.rawValue, "kraken2")
        XCTAssertEqual(ClassifierTool.naomgs.rawValue, "naomgs")
        XCTAssertEqual(ClassifierTool.nvd.rawValue, "nvd")
    }

    func testClassifierTool_usesBAMDispatch_forNonKraken2Tools() {
        XCTAssertTrue(ClassifierTool.esviritu.usesBAMDispatch)
        XCTAssertTrue(ClassifierTool.taxtriage.usesBAMDispatch)
        XCTAssertTrue(ClassifierTool.naomgs.usesBAMDispatch)
        XCTAssertTrue(ClassifierTool.nvd.usesBAMDispatch)
        XCTAssertFalse(ClassifierTool.kraken2.usesBAMDispatch)
    }

    // MARK: - ClassifierRowSelector

    func testSelector_initializesFields() {
        let sel = ClassifierRowSelector(
            sampleId: "S1",
            accessions: ["NC_001803", "NC_045512"],
            taxIds: []
        )
        XCTAssertEqual(sel.sampleId, "S1")
        XCTAssertEqual(sel.accessions, ["NC_001803", "NC_045512"])
        XCTAssertTrue(sel.taxIds.isEmpty)
    }

    func testSelector_isEmpty_whenNoAccessionsOrTaxIds() {
        let sel = ClassifierRowSelector(sampleId: nil, accessions: [], taxIds: [])
        XCTAssertTrue(sel.isEmpty)
    }

    func testSelector_isNotEmpty_withAccessions() {
        let sel = ClassifierRowSelector(sampleId: nil, accessions: ["NC_001803"], taxIds: [])
        XCTAssertFalse(sel.isEmpty)
    }

    func testSelector_isNotEmpty_withTaxIds() {
        let sel = ClassifierRowSelector(sampleId: nil, accessions: [], taxIds: [9606])
        XCTAssertFalse(sel.isEmpty)
    }

    func testSelector_nilSampleId_meansSingleSampleFixture() {
        let sel = ClassifierRowSelector(sampleId: nil, accessions: ["X"], taxIds: [])
        XCTAssertNil(sel.sampleId)
    }
}
