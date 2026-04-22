// AlignmentFilterCommandBuilderTests.swift - Tests for workflow-layer BAM filter planning
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Testing
@testable import LungfishWorkflow

@Suite("AlignmentFilterCommandBuilder")
struct AlignmentFilterCommandBuilderTests {

    @Test("Build adds mapped and primary exclusion flags plus exact-match requirements")
    func buildMappedPrimaryExactMatchPlan() throws {
        let request = AlignmentFilterRequest(
            mappedOnly: true,
            primaryOnly: true,
            identityFilter: .exactMatch
        )

        let plan = try AlignmentFilterCommandBuilder.build(from: request)

        #expect(plan.executable == "samtools")
        #expect(plan.subcommand == "view")
        #expect(plan.arguments == ["-b", "-F", "0x904", "-e", "[NM] == 0"])
        #expect(plan.trailingArguments.isEmpty)
        #expect(plan.preprocessingSteps.isEmpty)
        #expect(plan.duplicateMode == nil)
        #expect(plan.identityFilterExpression == "[NM] == 0")
        #expect(plan.requiredSAMTags == ["NM"])
    }

    @Test("Remove-duplicates requests markdup preprocessing and preserves identity requirements")
    func buildRemoveDuplicatesPlan() throws {
        let request = AlignmentFilterRequest(
            duplicateMode: .remove,
            identityFilter: .minimumPercentIdentity(99)
        )

        let plan = try AlignmentFilterCommandBuilder.build(from: request)

        #expect(plan.arguments == [
            "-b",
            "-F", "0x400",
            "-e", "(qlen > sclen) && (((qlen - sclen - [NM]) / (qlen - sclen)) * 100 >= 99)"
        ])
        #expect(plan.preprocessingSteps == [.samtoolsMarkdup(removeDuplicates: false)])
        #expect(plan.duplicateMode == .remove)
        #expect(plan.identityFilterExpression == "(qlen > sclen) && (((qlen - sclen - [NM]) / (qlen - sclen)) * 100 >= 99)")
        #expect(plan.requiredSAMTags == ["NM"])
    }

    @Test("Negative MAPQ validation fails")
    func rejectsNegativeMAPQ() throws {
        let request = AlignmentFilterRequest(minimumMAPQ: -1)

        #expect(throws: AlignmentFilterError.invalidMinimumMAPQ(-1)) {
            try AlignmentFilterCommandBuilder.build(from: request)
        }
    }

    @Test("Percent identity above 100 fails validation")
    func rejectsPercentIdentityAboveOneHundred() throws {
        let request = AlignmentFilterRequest(identityFilter: .minimumPercentIdentity(100.1))

        #expect(throws: AlignmentFilterError.invalidMinimumPercentIdentity(100.1)) {
            try AlignmentFilterCommandBuilder.build(from: request)
        }
    }
}
