// AlignmentFilterCommandBuilderTests.swift - Tests for BAM filter command planning
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishApp

final class AlignmentFilterCommandBuilderTests: XCTestCase {

    func testBuildCombinesMappedPrimaryDuplicateExcludedAndExactMatchFilters() throws {
        let request = AlignmentFilterRequest(
            mappedOnly: true,
            primaryOnly: true,
            minimumMAPQ: 30,
            duplicateMode: .exclude,
            identityFilter: .exactMatch,
            region: "chr7"
        )

        let plan = try AlignmentFilterCommandBuilder.build(from: request)

        XCTAssertEqual(plan.executable, "samtools")
        XCTAssertEqual(plan.subcommand, "view")
        XCTAssertEqual(plan.arguments, [
            "-b",
            "-F", "0xD04",
            "-q", "30",
            "-e", "[NM] == 0"
        ])
        XCTAssertEqual(plan.region, "chr7")
        XCTAssertEqual(plan.duplicateMode, .exclude)
        XCTAssertEqual(plan.identityFilterExpression, "[NM] == 0")
    }

    func testBuildUsesPercentIdentityExpressionBasedOnNMAndQueryLength() throws {
        let request = AlignmentFilterRequest(
            mappedOnly: false,
            primaryOnly: false,
            minimumMAPQ: nil,
            duplicateMode: .remove,
            identityFilter: .minimumPercentIdentity(95),
            region: nil
        )

        let plan = try AlignmentFilterCommandBuilder.build(from: request)

        XCTAssertEqual(plan.arguments, [
            "-b",
            "-F", "0x400",
            "-e", "(qlen > 0) && (((qlen - [NM]) / qlen) * 100 >= 95)"
        ])
        XCTAssertNil(plan.region)
        XCTAssertEqual(plan.duplicateMode, .remove)
        XCTAssertEqual(
            plan.identityFilterExpression,
            "(qlen > 0) && (((qlen - [NM]) / qlen) * 100 >= 95)"
        )
    }
}
