// RecipeIntegrationTests.swift
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishWorkflow

final class RecipeIntegrationTests: XCTestCase {

    func testVSP2RecipeLoadsAndValidates() throws {
        let recipes = RecipeRegistryV2.builtinRecipes()
        let vsp2 = try XCTUnwrap(recipes.first { $0.id == "vsp2-target-enrichment" })
        let engine = RecipeEngine()
        XCTAssertNoThrow(try engine.validate(recipe: vsp2, inputFormat: .pairedR1R2))
    }

    func testVSP2RecipePlanFusesDedupAndTrim() throws {
        let recipes = RecipeRegistryV2.builtinRecipes()
        let vsp2 = try XCTUnwrap(recipes.first { $0.id == "vsp2-target-enrichment" })
        let engine = RecipeEngine()
        let plan = try engine.plan(recipe: vsp2, inputFormat: .pairedR1R2)

        // Expected plan for VSP2 (5 steps in recipe):
        // 1. fusedFastp (dedup + trim) — two consecutive fastp steps fuse
        // 2. singleStep (deacon-scrub)
        // 3. singleStep (fastp-merge)
        // 4. formatConversion (merged → single)
        // 5. singleStep (seqkit-length-filter)
        XCTAssertEqual(plan.count, 5)

        if case .fusedFastp(let args, _, _) = plan[0] {
            XCTAssertTrue(args.contains("--dedup"), "Fused args should include --dedup")
            XCTAssertTrue(args.contains("--detect_adapter_for_pe"), "Should include adapter detection")
            XCTAssertTrue(args.contains("-q"), "Should include quality threshold")
            XCTAssertTrue(args.contains("15"), "Quality should be 15")
        } else {
            XCTFail("First planned step should be fusedFastp, got \(plan[0])")
        }
    }

    func testVSP2RecipeRejectsSingleEndInput() throws {
        let recipes = RecipeRegistryV2.builtinRecipes()
        let vsp2 = try XCTUnwrap(recipes.first { $0.id == "vsp2-target-enrichment" })
        let engine = RecipeEngine()
        XCTAssertThrowsError(try engine.validate(recipe: vsp2, inputFormat: .single))
    }
}
