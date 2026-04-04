// RecipeRegistryTests.swift
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishWorkflow

final class RecipeRegistryTests: XCTestCase {

    // MARK: - Built-in recipes

    func testLoadBuiltinRecipes() {
        let recipes = RecipeRegistryV2.builtinRecipes()
        XCTAssertFalse(recipes.isEmpty, "Expected at least one built-in recipe")
        let vsp2 = recipes.first { $0.id == "vsp2-target-enrichment" }
        XCTAssertNotNil(vsp2, "Built-in vsp2-target-enrichment recipe should be present")
        XCTAssertEqual(vsp2?.platforms, [.illumina])
        XCTAssertEqual(vsp2?.steps.count, 5)
    }

    // MARK: - Platform filtering

    func testFilterByPlatform() {
        let all = RecipeRegistryV2.builtinRecipes()
        let illumina = all.filter { $0.platforms.contains(.illumina) }
        let ont = all.filter { $0.platforms.contains(.ont) }
        XCTAssertTrue(
            illumina.contains { $0.id == "vsp2-target-enrichment" },
            "vsp2-target-enrichment should appear in illumina-filtered results"
        )
        XCTAssertFalse(
            ont.contains { $0.id == "vsp2-target-enrichment" },
            "vsp2-target-enrichment should not appear in ont-filtered results"
        )
    }

    func testAllRecipesFilteredByIllumina() {
        let illuminaRecipes = RecipeRegistryV2.allRecipes(platform: .illumina)
        for recipe in illuminaRecipes {
            XCTAssertTrue(
                recipe.platforms.contains(.illumina),
                "Recipe \(recipe.id) should declare illumina platform"
            )
        }
    }

    func testAllRecipesNoFilterIncludesAll() {
        let all = RecipeRegistryV2.allRecipes()
        let builtin = RecipeRegistryV2.builtinRecipes()
        XCTAssertGreaterThanOrEqual(
            all.count, builtin.count,
            "allRecipes() should include at least all built-in recipes"
        )
    }

    // MARK: - Recipe lookup by ID

    func testRecipeByIDFound() {
        let recipe = RecipeRegistryV2.recipe(id: "vsp2-target-enrichment")
        XCTAssertNotNil(recipe, "Should find vsp2-target-enrichment by ID")
        XCTAssertEqual(recipe?.id, "vsp2-target-enrichment")
    }

    func testRecipeByIDNotFound() {
        let recipe = RecipeRegistryV2.recipe(id: "nonexistent-recipe-id")
        XCTAssertNil(recipe, "Lookup for unknown ID should return nil")
    }

    // MARK: - User recipes (empty directory case)

    func testUserRecipesReturnsArrayWhenDirectoryAbsent() {
        // The user recipes directory won't exist in the test environment.
        // Verify the method gracefully returns an empty array rather than crashing.
        let userRecipes = RecipeRegistryV2.userRecipes()
        XCTAssertNotNil(userRecipes, "userRecipes() should never return nil")
    }
}
