// RecipeRegistry.swift
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import os.log
import LungfishCore

// MARK: - RecipeRegistryV2

/// Loads built-in and user-defined recipes.
///
/// Named `RecipeRegistryV2` to avoid collision with the legacy `RecipeRegistry`
/// enum in `LungfishIO/Formats/FASTQ/ProcessingRecipe.swift`.
public enum RecipeRegistryV2 {

    private static let logger = Logger(
        subsystem: LogSubsystem.workflow,
        category: "RecipeRegistryV2"
    )

    // MARK: - Built-in recipes

    /// Load built-in recipes from the `LungfishWorkflow` module bundle.
    ///
    /// Recipe JSON files are stored under `Resources/Recipes/` in the
    /// `LungfishWorkflow` Swift package target.  `RecipeBundleAccessor.bundle`
    /// exposes `Bundle.module` from that target, ensuring the correct bundle is
    /// used even when called from a test target.
    public static func builtinRecipes() -> [Recipe] {
        guard let recipesDir = RecipeBundleAccessor.bundle.url(
            forResource: "Recipes",
            withExtension: nil
        ) else {
            logger.error("RecipeRegistryV2: Recipes directory not found in LungfishWorkflow bundle")
            return []
        }

        return loadRecipes(from: recipesDir)
    }

    // MARK: - User recipes

    /// Load user recipes from `~/Library/Application Support/Lungfish/recipes/`.
    public static func userRecipes() -> [Recipe] {
        guard let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            return []
        }
        let userRecipesDir = appSupport
            .appendingPathComponent("Lungfish")
            .appendingPathComponent("recipes")
        guard FileManager.default.fileExists(atPath: userRecipesDir.path) else {
            return []
        }
        return loadRecipes(from: userRecipesDir)
    }

    // MARK: - Combined access

    /// All recipes (built-in + user), optionally filtered by platform.
    ///
    /// - Parameter platform: When non-nil, only recipes that list this platform
    ///   are returned.
    public static func allRecipes(platform: SequencingPlatform? = nil) -> [Recipe] {
        var recipes = builtinRecipes() + userRecipes()
        if let platform {
            recipes = recipes.filter { $0.platforms.contains(platform) }
        }
        return recipes
    }

    /// Find a recipe by its unique ID.
    ///
    /// Searches both built-in and user recipes; user recipes shadow built-in
    /// ones if their IDs collide.
    public static func recipe(id: String) -> Recipe? {
        allRecipes().first { $0.id == id }
    }

    // MARK: - Private helpers

    private static func loadRecipes(from directory: URL) -> [Recipe] {
        let fm = FileManager.default
        guard let contents = try? fm.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        ) else {
            return []
        }

        let decoder = JSONDecoder()
        var recipes: [Recipe] = []

        for url in contents where url.pathExtension.lowercased() == "json" {
            do {
                let data = try Data(contentsOf: url)
                let recipe = try decoder.decode(Recipe.self, from: data)
                recipes.append(recipe)
            } catch {
                logger.warning("RecipeRegistryV2: Failed to decode recipe at \(url.lastPathComponent): \(error.localizedDescription)")
            }
        }

        return recipes
    }
}
