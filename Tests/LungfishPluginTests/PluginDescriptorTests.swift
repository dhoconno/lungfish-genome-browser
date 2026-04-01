// PluginDescriptorTests.swift - Tests for PluginDescriptor and RegistryError
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishPlugin

// MARK: - PluginDescriptor Tests

final class PluginDescriptorTests: XCTestCase {

    struct TestPlugin: Plugin {
        let id = "com.test.descriptor"
        let name = "Descriptor Test"
        let version = "2.0.0"
        let description = "A plugin for testing descriptors"
        let category = PluginCategory.sequenceAnalysis
        let capabilities: PluginCapabilities = [.worksOnSelection, .producesReport]
        let iconName = "star"
    }

    func testDescriptorFromPlugin() {
        let plugin = TestPlugin()
        let descriptor = PluginDescriptor(from: plugin)

        XCTAssertEqual(descriptor.id, "com.test.descriptor")
        XCTAssertEqual(descriptor.name, "Descriptor Test")
        XCTAssertEqual(descriptor.version, "2.0.0")
        XCTAssertEqual(descriptor.description, "A plugin for testing descriptors")
        XCTAssertEqual(descriptor.category, .sequenceAnalysis)
        XCTAssertEqual(descriptor.capabilities, [.worksOnSelection, .producesReport])
        XCTAssertEqual(descriptor.iconName, "star")
    }

    func testPluginDescriptorExtension() {
        let plugin = TestPlugin()
        let descriptor = plugin.descriptor

        XCTAssertEqual(descriptor.id, plugin.id)
        XCTAssertEqual(descriptor.name, plugin.name)
    }

    func testDescriptorIdentifiable() {
        let plugin = TestPlugin()
        let descriptor = plugin.descriptor
        XCTAssertEqual(descriptor.id, "com.test.descriptor")
    }

    func testDescriptorFromBuiltInPlugin() {
        let plugin = ORFFinderPlugin()
        let descriptor = plugin.descriptor

        XCTAssertEqual(descriptor.id, plugin.id)
        XCTAssertEqual(descriptor.name, plugin.name)
        XCTAssertEqual(descriptor.category, .annotationTools)
    }
}

// MARK: - RegistryError Tests

final class RegistryErrorTests: XCTestCase {

    func testDuplicatePluginIdDescription() {
        let error = RegistryError.duplicatePluginId("com.test.duplicate")
        XCTAssertEqual(
            error.errorDescription,
            "A plugin with ID 'com.test.duplicate' is already registered"
        )
    }

    func testPluginNotFoundDescription() {
        let error = RegistryError.pluginNotFound("com.test.missing")
        XCTAssertEqual(
            error.errorDescription,
            "Plugin with ID 'com.test.missing' not found"
        )
    }

    func testIncompatiblePluginDescription() {
        let error = RegistryError.incompatiblePlugin(reason: "requires macOS 15")
        XCTAssertEqual(
            error.errorDescription,
            "Plugin is incompatible: requires macOS 15"
        )
    }

    func testRegistryErrorConformsToLocalizedError() {
        let error: Error = RegistryError.pluginNotFound("test")
        XCTAssertNotNil((error as? LocalizedError)?.errorDescription)
    }
}
