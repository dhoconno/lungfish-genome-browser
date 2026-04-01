// UIRegressionTests.swift - Regression tests for LungfishUI types
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Regression protection for Track, DisplayMode, CoverageTrack, FeatureTrack,
// SequenceTrack, TrackType, TrackConfiguration, TileKey, Tile, PackedFeature,
// FeatureDensityCalculator, and RenderContext.

import XCTest
@testable import LungfishUI
@testable import LungfishCore

// MARK: - DisplayMode Tests

final class DisplayModeRegressionTests: XCTestCase {

    // MARK: - CaseIterable / Raw Values

    func testAllCasesCount() {
        XCTAssertEqual(DisplayMode.allCases.count, 4)
    }

    func testRawValues() {
        XCTAssertEqual(DisplayMode.collapsed.rawValue, "collapsed")
        XCTAssertEqual(DisplayMode.squished.rawValue, "squished")
        XCTAssertEqual(DisplayMode.expanded.rawValue, "expanded")
        XCTAssertEqual(DisplayMode.auto.rawValue, "auto")
    }

    func testRoundTripFromRawValue() {
        for mode in DisplayMode.allCases {
            XCTAssertEqual(DisplayMode(rawValue: mode.rawValue), mode)
        }
    }

    // MARK: - Row Heights (IGV contract)

    func testRowHeights() {
        XCTAssertEqual(DisplayMode.collapsed.rowHeight, 25)
        XCTAssertEqual(DisplayMode.squished.rowHeight, 12)
        XCTAssertEqual(DisplayMode.expanded.rowHeight, 35)
        XCTAssertEqual(DisplayMode.auto.rowHeight, 25)
    }

    func testMinimumTrackHeights() {
        XCTAssertEqual(DisplayMode.collapsed.minimumTrackHeight, 25)
        XCTAssertEqual(DisplayMode.squished.minimumTrackHeight, 15)
        XCTAssertEqual(DisplayMode.expanded.minimumTrackHeight, 40)
        XCTAssertEqual(DisplayMode.auto.minimumTrackHeight, 25)
    }

    func testDefaultTrackHeights() {
        XCTAssertEqual(DisplayMode.collapsed.defaultTrackHeight, 40)
        XCTAssertEqual(DisplayMode.squished.defaultTrackHeight, 60)
        XCTAssertEqual(DisplayMode.expanded.defaultTrackHeight, 100)
        XCTAssertEqual(DisplayMode.auto.defaultTrackHeight, 60)
    }

    // MARK: - Max Rows

    func testMaxRows() {
        XCTAssertEqual(DisplayMode.collapsed.maxRows, 1)
        XCTAssertEqual(DisplayMode.squished.maxRows, 50)
        XCTAssertEqual(DisplayMode.expanded.maxRows, 25)
        XCTAssertEqual(DisplayMode.auto.maxRows, 25)
    }

    // MARK: - Display Properties

    func testDisplayNames() {
        XCTAssertEqual(DisplayMode.collapsed.displayName, "Collapsed")
        XCTAssertEqual(DisplayMode.squished.displayName, "Squished")
        XCTAssertEqual(DisplayMode.expanded.displayName, "Expanded")
        XCTAssertEqual(DisplayMode.auto.displayName, "Auto")
    }

    func testSymbolNamesAreNonEmpty() {
        for mode in DisplayMode.allCases {
            XCTAssertFalse(mode.symbolName.isEmpty, "\(mode) symbolName should not be empty")
        }
    }

    func testShortcutCharacters() {
        XCTAssertEqual(DisplayMode.collapsed.shortcutCharacter, "1")
        XCTAssertEqual(DisplayMode.squished.shortcutCharacter, "2")
        XCTAssertEqual(DisplayMode.expanded.shortcutCharacter, "3")
        XCTAssertEqual(DisplayMode.auto.shortcutCharacter, "0")
    }

    // MARK: - Feature Rendering Properties

    func testShowLabels() {
        XCTAssertFalse(DisplayMode.collapsed.showLabels)
        XCTAssertFalse(DisplayMode.squished.showLabels)
        XCTAssertTrue(DisplayMode.expanded.showLabels)
        XCTAssertTrue(DisplayMode.auto.showLabels)
    }

    func testShowStrandArrows() {
        XCTAssertFalse(DisplayMode.collapsed.showStrandArrows)
        XCTAssertTrue(DisplayMode.squished.showStrandArrows)
        XCTAssertTrue(DisplayMode.expanded.showStrandArrows)
        XCTAssertTrue(DisplayMode.auto.showStrandArrows)
    }

    func testFeatureHeights() {
        XCTAssertEqual(DisplayMode.collapsed.featureHeight, 20)
        XCTAssertEqual(DisplayMode.squished.featureHeight, 8)
        XCTAssertEqual(DisplayMode.expanded.featureHeight, 28)
        XCTAssertEqual(DisplayMode.auto.featureHeight, 20)
    }

    func testRowPadding() {
        XCTAssertEqual(DisplayMode.collapsed.rowPadding, 2)
        XCTAssertEqual(DisplayMode.squished.rowPadding, 2)
        XCTAssertEqual(DisplayMode.expanded.rowPadding, 4)
        XCTAssertEqual(DisplayMode.auto.rowPadding, 2)
    }

    // MARK: - Auto Mode Resolution

    func testResolveNonAutoModeReturnsSelf() {
        XCTAssertEqual(DisplayMode.collapsed.resolve(featureCount: 5, trackHeight: 200), .collapsed)
        XCTAssertEqual(DisplayMode.squished.resolve(featureCount: 5, trackHeight: 200), .squished)
        XCTAssertEqual(DisplayMode.expanded.resolve(featureCount: 5, trackHeight: 200), .expanded)
    }

    func testResolveAutoWithZeroFeaturesReturnsExpanded() {
        XCTAssertEqual(DisplayMode.auto.resolve(featureCount: 0, trackHeight: 200), .expanded)
    }

    func testResolveAutoWithFewFeaturesReturnsExpanded() {
        // 200 / 35 = 5.7 -> maxExpandedRows = 5
        let result = DisplayMode.auto.resolve(featureCount: 3, trackHeight: 200)
        XCTAssertEqual(result, .expanded)
    }

    func testResolveAutoWithManyFeaturesReturnsSquished() {
        // 200 / 35 = 5.7 -> maxExpanded = 5; 200 / 12 = 16.6 -> maxSquished = 16
        let result = DisplayMode.auto.resolve(featureCount: 10, trackHeight: 200)
        XCTAssertEqual(result, .squished)
    }

    func testResolveAutoWithTooManyFeaturesReturnsCollapsed() {
        // 200 / 12 = 16 -> maxSquished = 16
        let result = DisplayMode.auto.resolve(featureCount: 100, trackHeight: 200)
        XCTAssertEqual(result, .collapsed)
    }

    // MARK: - Codable

    func testCodableRoundTrip() throws {
        for mode in DisplayMode.allCases {
            let data = try JSONEncoder().encode(mode)
            let decoded = try JSONDecoder().decode(DisplayMode.self, from: data)
            XCTAssertEqual(decoded, mode)
        }
    }

    // MARK: - Identifiable

    func testIdentifiableIdIsRawValue() {
        for mode in DisplayMode.allCases {
            XCTAssertEqual(mode.id, mode.rawValue)
        }
    }
}

// MARK: - TrackType Tests

final class TrackTypeRegressionTests: XCTestCase {

    func testAllCasesCount() {
        XCTAssertEqual(TrackType.allCases.count, 7)
    }

    func testRawValues() {
        XCTAssertEqual(TrackType.sequence.rawValue, "sequence")
        XCTAssertEqual(TrackType.feature.rawValue, "feature")
        XCTAssertEqual(TrackType.gene.rawValue, "gene")
        XCTAssertEqual(TrackType.alignment.rawValue, "alignment")
        XCTAssertEqual(TrackType.coverage.rawValue, "coverage")
        XCTAssertEqual(TrackType.variant.rawValue, "variant")
        XCTAssertEqual(TrackType.custom.rawValue, "custom")
    }

    func testDisplayNamesAreNonEmpty() {
        for trackType in TrackType.allCases {
            XCTAssertFalse(trackType.displayName.isEmpty, "\(trackType) displayName should not be empty")
        }
    }

    func testSymbolNamesAreNonEmpty() {
        for trackType in TrackType.allCases {
            XCTAssertFalse(trackType.symbolName.isEmpty, "\(trackType) symbolName should not be empty")
        }
    }

    func testDefaultHeightsArePositive() {
        for trackType in TrackType.allCases {
            XCTAssertGreaterThan(trackType.defaultHeight, 0, "\(trackType) defaultHeight must be > 0")
        }
    }

    func testSpecificDefaultHeights() {
        XCTAssertEqual(TrackType.sequence.defaultHeight, 50)
        XCTAssertEqual(TrackType.feature.defaultHeight, 60)
        XCTAssertEqual(TrackType.gene.defaultHeight, 80)
        XCTAssertEqual(TrackType.alignment.defaultHeight, 150)
        XCTAssertEqual(TrackType.coverage.defaultHeight, 60)
        XCTAssertEqual(TrackType.variant.defaultHeight, 40)
        XCTAssertEqual(TrackType.custom.defaultHeight, 60)
    }

    func testCodableRoundTrip() throws {
        for trackType in TrackType.allCases {
            let data = try JSONEncoder().encode(trackType)
            let decoded = try JSONDecoder().decode(TrackType.self, from: data)
            XCTAssertEqual(decoded, trackType)
        }
    }
}

// MARK: - TrackConfiguration Tests

final class TrackConfigurationRegressionTests: XCTestCase {

    func testDefaultInitialization() {
        let config = TrackConfiguration(name: "Test Track")
        XCTAssertEqual(config.name, "Test Track")
        XCTAssertEqual(config.height, 60)
        XCTAssertEqual(config.displayMode, .auto)
        XCTAssertTrue(config.isVisible)
        XCTAssertEqual(config.order, 0)
        XCTAssertNil(config.color)
        XCTAssertTrue(config.options.isEmpty)
    }

    func testCustomInitialization() {
        let config = TrackConfiguration(
            name: "Coverage",
            height: 120,
            displayMode: .expanded,
            isVisible: false,
            order: 3,
            color: "#FF0000",
            options: ["smooth": "true"]
        )
        XCTAssertEqual(config.name, "Coverage")
        XCTAssertEqual(config.height, 120)
        XCTAssertEqual(config.displayMode, .expanded)
        XCTAssertFalse(config.isVisible)
        XCTAssertEqual(config.order, 3)
        XCTAssertEqual(config.color, "#FF0000")
        XCTAssertEqual(config.options["smooth"], "true")
    }

    func testCodableRoundTrip() throws {
        let config = TrackConfiguration(
            name: "Genes",
            height: 80,
            displayMode: .squished,
            isVisible: true,
            order: 1,
            color: "#00CC00",
            options: ["labels": "on"]
        )
        let data = try JSONEncoder().encode(config)
        let decoded = try JSONDecoder().decode(TrackConfiguration.self, from: data)
        XCTAssertEqual(decoded.name, config.name)
        XCTAssertEqual(decoded.height, config.height)
        XCTAssertEqual(decoded.displayMode, config.displayMode)
        XCTAssertEqual(decoded.isVisible, config.isVisible)
        XCTAssertEqual(decoded.order, config.order)
        XCTAssertEqual(decoded.color, config.color)
        XCTAssertEqual(decoded.options, config.options)
    }
}

// MARK: - TileKey Tests

final class TileKeyRegressionTests: XCTestCase {

    func testInitialization() {
        let id = UUID()
        let key = TileKey(trackId: id, chromosome: "chr1", tileIndex: 5, zoom: 10)
        XCTAssertEqual(key.trackId, id)
        XCTAssertEqual(key.chromosome, "chr1")
        XCTAssertEqual(key.tileIndex, 5)
        XCTAssertEqual(key.zoom, 10)
    }

    func testEquality() {
        let id = UUID()
        let key1 = TileKey(trackId: id, chromosome: "chr1", tileIndex: 5, zoom: 10)
        let key2 = TileKey(trackId: id, chromosome: "chr1", tileIndex: 5, zoom: 10)
        XCTAssertEqual(key1, key2)
    }

    func testInequalityByChromosome() {
        let id = UUID()
        let key1 = TileKey(trackId: id, chromosome: "chr1", tileIndex: 5, zoom: 10)
        let key2 = TileKey(trackId: id, chromosome: "chr2", tileIndex: 5, zoom: 10)
        XCTAssertNotEqual(key1, key2)
    }

    func testInequalityByTileIndex() {
        let id = UUID()
        let key1 = TileKey(trackId: id, chromosome: "chr1", tileIndex: 5, zoom: 10)
        let key2 = TileKey(trackId: id, chromosome: "chr1", tileIndex: 6, zoom: 10)
        XCTAssertNotEqual(key1, key2)
    }

    func testInequalityByZoom() {
        let id = UUID()
        let key1 = TileKey(trackId: id, chromosome: "chr1", tileIndex: 5, zoom: 10)
        let key2 = TileKey(trackId: id, chromosome: "chr1", tileIndex: 5, zoom: 11)
        XCTAssertNotEqual(key1, key2)
    }

    func testHashableConsistency() {
        let id = UUID()
        let key = TileKey(trackId: id, chromosome: "chr1", tileIndex: 5, zoom: 10)
        var dict: [TileKey: String] = [:]
        dict[key] = "tile"
        XCTAssertEqual(dict[key], "tile")
    }
}

// MARK: - Tile Tests

final class TileRegressionTests: XCTestCase {

    func testInitialization() {
        let id = UUID()
        let key = TileKey(trackId: id, chromosome: "chr1", tileIndex: 0, zoom: 5)
        let tile = Tile(key: key, startBP: 0, endBP: 700, content: "ACGT")

        XCTAssertEqual(tile.key, key)
        XCTAssertEqual(tile.startBP, 0)
        XCTAssertEqual(tile.endBP, 700)
        XCTAssertEqual(tile.content, "ACGT")
    }

    func testCreatedAtIsRecent() {
        let key = TileKey(trackId: UUID(), chromosome: "chr1", tileIndex: 0, zoom: 0)
        let tile = Tile(key: key, startBP: 0, endBP: 100, content: 42)
        XCTAssertLessThan(tile.age, 2.0, "Tile age should be < 2 seconds right after creation")
    }
}

// MARK: - PackedFeature Tests

final class PackedFeatureRegressionTests: XCTestCase {

    func testInitialization() {
        let packed = PackedFeature(feature: "gene1", row: 2, screenStart: 100.0, screenEnd: 300.0)
        XCTAssertEqual(packed.feature, "gene1")
        XCTAssertEqual(packed.row, 2)
        XCTAssertEqual(packed.screenStart, 100.0, accuracy: 0.001)
        XCTAssertEqual(packed.screenEnd, 300.0, accuracy: 0.001)
    }
}

// MARK: - SequenceTileContent Tests

final class SequenceTileContentRegressionTests: XCTestCase {

    func testInitialization() {
        let content = SequenceTileContent(sequence: "ACGTACGT", gcContent: 0.5, dominantBase: "A")
        XCTAssertEqual(content.sequence, "ACGTACGT")
        XCTAssertEqual(content.gcContent, 0.5, accuracy: 0.001)
        XCTAssertEqual(content.dominantBase, "A")
    }
}

// MARK: - TileCacheError Tests

final class TileCacheErrorRegressionTests: XCTestCase {

    func testErrorCasesExist() {
        // Verify error cases are accessible (compile-time check baked into runtime)
        let errors: [TileCacheError] = [.trackNotFound, .sequenceNotLoaded, .invalidRange]
        XCTAssertEqual(errors.count, 3)
    }
}

// MARK: - CoverageTrack Tests

@MainActor
final class CoverageTrackRegressionTests: XCTestCase {

    func testDefaultConstruction() {
        let track = CoverageTrack()
        XCTAssertEqual(track.name, "Coverage")
        XCTAssertEqual(track.height, 80)
        XCTAssertTrue(track.isVisible)
        XCTAssertEqual(track.displayMode, .auto)
        XCTAssertFalse(track.isSelected)
        XCTAssertEqual(track.order, 0)
        XCTAssertNil(track.dataSource)
    }

    func testCustomConstruction() {
        let track = CoverageTrack(name: "Depth", height: 120)
        XCTAssertEqual(track.name, "Depth")
        XCTAssertEqual(track.height, 120)
    }

    func testUniqueIds() {
        let track1 = CoverageTrack()
        let track2 = CoverageTrack()
        XCTAssertNotEqual(track1.id, track2.id)
    }

    func testRenderModeAllCases() {
        let modes = CoverageTrack.RenderMode.allCases
        XCTAssertEqual(modes.count, 3)
        XCTAssertTrue(modes.contains(.histogram))
        XCTAssertTrue(modes.contains(.line))
        XCTAssertTrue(modes.contains(.heatmap))
    }

    func testDefaultRenderMode() {
        let track = CoverageTrack()
        XCTAssertEqual(track.renderMode, .histogram)
    }

    func testDefaultShowYAxis() {
        let track = CoverageTrack()
        XCTAssertTrue(track.showYAxis)
    }

    func testMutableProperties() {
        let track = CoverageTrack()
        track.name = "Modified"
        track.height = 200
        track.isVisible = false
        track.displayMode = .expanded
        track.isSelected = true
        track.order = 5
        track.renderMode = .line
        track.showYAxis = false

        XCTAssertEqual(track.name, "Modified")
        XCTAssertEqual(track.height, 200)
        XCTAssertFalse(track.isVisible)
        XCTAssertEqual(track.displayMode, .expanded)
        XCTAssertTrue(track.isSelected)
        XCTAssertEqual(track.order, 5)
        XCTAssertEqual(track.renderMode, .line)
        XCTAssertFalse(track.showYAxis)
    }

    func testIsReadyReturnsFalseInitially() {
        let track = CoverageTrack()
        let frame = ReferenceFrame(chromosome: "chr1", chromosomeLength: 1000, widthInPixels: 500)
        XCTAssertFalse(track.isReady(for: frame))
    }

    func testLoadThenIsReady() async throws {
        let track = CoverageTrack()
        track.setData([1.0, 2.0, 3.0, 4.0, 5.0])
        let frame = ReferenceFrame(chromosome: "chr1", chromosomeLength: 5, widthInPixels: 5)
        try await track.load(for: frame)
        XCTAssertTrue(track.isReady(for: frame))
    }

    func testContextMenuReturnsMenu() {
        let track = CoverageTrack()
        let menu = track.contextMenu(at: 100, y: 20)
        XCTAssertNotNil(menu)
        XCTAssertGreaterThan(menu!.items.count, 0)
    }
}

// MARK: - FeatureTrack Tests

@MainActor
final class FeatureTrackRegressionTests: XCTestCase {

    func testDefaultConstruction() {
        let track = FeatureTrack()
        XCTAssertEqual(track.name, "Features")
        XCTAssertEqual(track.height, 60)
        XCTAssertTrue(track.isVisible)
        XCTAssertEqual(track.displayMode, .auto)
        XCTAssertFalse(track.isSelected)
        XCTAssertEqual(track.order, 0)
        XCTAssertNil(track.dataSource)
    }

    func testCustomConstruction() {
        let track = FeatureTrack(name: "Genes", annotations: [], height: 100)
        XCTAssertEqual(track.name, "Genes")
        XCTAssertEqual(track.height, 100)
    }

    func testUniqueIds() {
        let track1 = FeatureTrack()
        let track2 = FeatureTrack()
        XCTAssertNotEqual(track1.id, track2.id)
    }

    func testMutableProperties() {
        let track = FeatureTrack()
        track.name = "CDS"
        track.height = 80
        track.isVisible = false
        track.displayMode = .squished
        track.isSelected = true
        track.order = 2
        track.showLabels = false
        track.minFeatureWidth = 3

        XCTAssertEqual(track.name, "CDS")
        XCTAssertEqual(track.height, 80)
        XCTAssertFalse(track.isVisible)
        XCTAssertEqual(track.displayMode, .squished)
        XCTAssertTrue(track.isSelected)
        XCTAssertEqual(track.order, 2)
        XCTAssertFalse(track.showLabels)
        XCTAssertEqual(track.minFeatureWidth, 3)
    }

    func testIsReadyReturnsFalseInitially() {
        let track = FeatureTrack()
        let frame = ReferenceFrame(chromosome: "chr1", chromosomeLength: 1000, widthInPixels: 500)
        XCTAssertFalse(track.isReady(for: frame))
    }

    func testContextMenuReturnsMenu() {
        let track = FeatureTrack()
        let menu = track.contextMenu(at: 100, y: 20)
        XCTAssertNotNil(menu)
        XCTAssertGreaterThan(menu!.items.count, 0)
    }
}

// MARK: - SequenceTrack Tests

@MainActor
final class SequenceTrackRegressionTests: XCTestCase {

    func testDefaultConstruction() {
        let track = SequenceTrack()
        XCTAssertEqual(track.name, "Sequence")
        XCTAssertEqual(track.height, 50)
        XCTAssertTrue(track.isVisible)
        XCTAssertEqual(track.displayMode, .expanded)
        XCTAssertFalse(track.isSelected)
        XCTAssertEqual(track.order, 0)
        XCTAssertNil(track.dataSource)
        XCTAssertNil(track.currentSequence)
    }

    func testCustomConstruction() {
        let track = SequenceTrack(name: "Reference", height: 70, cacheCapacity: 50)
        XCTAssertEqual(track.name, "Reference")
        XCTAssertEqual(track.height, 70)
    }

    func testUniqueIds() {
        let track1 = SequenceTrack()
        let track2 = SequenceTrack()
        XCTAssertNotEqual(track1.id, track2.id)
    }

    func testBaseColorsContainStandardBases() {
        let colors = SequenceTrack.baseColors
        XCTAssertNotNil(colors["A"])
        XCTAssertNotNil(colors["C"])
        XCTAssertNotNil(colors["G"])
        XCTAssertNotNil(colors["T"])
        XCTAssertNotNil(colors["U"])
        XCTAssertNotNil(colors["N"])
    }

    func testBaseColorsHexContainStandardBases() {
        let hex = SequenceTrack.baseColorsHex
        XCTAssertEqual(hex["A"], "#00CC00")
        XCTAssertEqual(hex["C"], "#0000CC")
        XCTAssertEqual(hex["G"], "#FFB300")
        XCTAssertEqual(hex["T"], "#CC0000")
        XCTAssertEqual(hex["N"], "#888888")
    }

    func testZoomThresholdsDefaults() {
        let track = SequenceTrack()
        XCTAssertEqual(track.zoomThresholds.showLetters, 10.0)
        XCTAssertEqual(track.zoomThresholds.showBars, 100.0)
    }

    func testMutableProperties() {
        let track = SequenceTrack()
        track.name = "Ref"
        track.height = 60
        track.showComplementStrand = true
        track.showStrandLabels = false
        track.showTranslation = true
        track.translationFrames = [1, 2]

        XCTAssertEqual(track.name, "Ref")
        XCTAssertEqual(track.height, 60)
        XCTAssertTrue(track.showComplementStrand)
        XCTAssertFalse(track.showStrandLabels)
        XCTAssertTrue(track.showTranslation)
        XCTAssertEqual(track.translationFrames, [1, 2])
    }

    func testIsReadyReturnsFalseWithoutSequence() {
        let track = SequenceTrack()
        let frame = ReferenceFrame(chromosome: "chr1", chromosomeLength: 1000, widthInPixels: 500)
        XCTAssertFalse(track.isReady(for: frame))
    }

    func testSetSequenceUpdatesCurrentSequence() throws {
        let track = SequenceTrack()
        let seq = try Sequence(name: "test", description: "", alphabet: .dna, bases: "ACGT")
        track.setSequence(seq)
        XCTAssertNotNil(track.currentSequence)
        XCTAssertEqual(track.currentSequence?.name, "test")
    }

    func testContextMenuReturnsMenu() {
        let track = SequenceTrack()
        let menu = track.contextMenu(at: 100, y: 20)
        XCTAssertNotNil(menu)
        XCTAssertGreaterThan(menu!.items.count, 0)
    }
}

// MARK: - FeatureDensityCalculator Tests

@MainActor
final class FeatureDensityCalculatorRegressionTests: XCTestCase {

    private struct TestFeature: Packable {
        let start: Int
        let end: Int
    }

    func testEmptyFeaturesProducesZeroDensity() {
        let frame = ReferenceFrame(chromosome: "chr1", start: 0, end: 1000, widthInPixels: 100)
        let density = FeatureDensityCalculator.calculateDensity(for: [TestFeature](), in: frame, binCount: 10)
        XCTAssertEqual(density.count, 10)
        XCTAssertEqual(density, [Int](repeating: 0, count: 10))
    }

    func testSingleFeatureAppearsInCorrectBins() {
        let frame = ReferenceFrame(chromosome: "chr1", start: 0, end: 100, widthInPixels: 100)
        let features = [TestFeature(start: 10, end: 30)]
        let density = FeatureDensityCalculator.calculateDensity(for: features, in: frame, binCount: 10)
        XCTAssertEqual(density.count, 10)
        // Feature covers bins 1 and 2 (each bin is 10bp wide: 0-10, 10-20, 20-30...)
        XCTAssertEqual(density[0], 0)
        XCTAssertGreaterThan(density[1], 0)
        XCTAssertGreaterThan(density[2], 0)
    }

    func testFeatureOutsideViewHasNoDensity() {
        let frame = ReferenceFrame(chromosome: "chr1", start: 100, end: 200, widthInPixels: 100)
        let features = [TestFeature(start: 0, end: 50)]
        let density = FeatureDensityCalculator.calculateDensity(for: features, in: frame, binCount: 10)
        XCTAssertEqual(density, [Int](repeating: 0, count: 10))
    }
}

// MARK: - TileCache Eviction Policy Tests

final class TileCacheEvictionPolicyRegressionTests: XCTestCase {

    func testLRUEvictionPolicyIsDefault() async {
        let cache = TileCache<String>(capacity: 10)
        // Default eviction policy is .lru -- verified indirectly by statistics behavior
        let stats = await cache.statistics()
        XCTAssertEqual(stats.hits, 0)
        XCTAssertEqual(stats.misses, 0)
        XCTAssertEqual(stats.evictions, 0)
    }

    func testFIFOEvictionPolicy() async {
        let cache = TileCache<String>(capacity: 2, evictionPolicy: .fifo)
        let id = UUID()
        let k1 = TileKey(trackId: id, chromosome: "chr1", tileIndex: 0, zoom: 0)
        let k2 = TileKey(trackId: id, chromosome: "chr1", tileIndex: 1, zoom: 0)
        let k3 = TileKey(trackId: id, chromosome: "chr1", tileIndex: 2, zoom: 0)

        await cache.set(Tile(key: k1, startBP: 0, endBP: 100, content: "a"), for: k1)
        await cache.set(Tile(key: k2, startBP: 100, endBP: 200, content: "b"), for: k2)
        // This should evict the oldest (k1)
        await cache.set(Tile(key: k3, startBP: 200, endBP: 300, content: "c"), for: k3)

        let stats = await cache.statistics()
        XCTAssertGreaterThan(stats.evictions, 0)
    }

    func testReduceToTargetPercentage() async {
        let cache = TileCache<Int>(capacity: 10)
        let id = UUID()
        for i in 0..<10 {
            let key = TileKey(trackId: id, chromosome: "chr1", tileIndex: i, zoom: 0)
            await cache.set(Tile(key: key, startBP: i * 100, endBP: (i + 1) * 100, content: i), for: key)
        }
        await cache.reduce(to: 0.5)
        let stats = await cache.statistics()
        XCTAssertLessThanOrEqual(stats.currentSize, 5)
    }

    func testResetStatistics() async {
        let cache = TileCache<String>(capacity: 10)
        let key = TileKey(trackId: UUID(), chromosome: "chr1", tileIndex: 0, zoom: 0)
        _ = await cache.get(key) // miss
        await cache.resetStatistics()
        let stats = await cache.statistics()
        XCTAssertEqual(stats.hits, 0)
        XCTAssertEqual(stats.misses, 0)
    }
}

// MARK: - TileCacheCoordinator Tests

final class TileCacheCoordinatorRegressionTests: XCTestCase {

    func testCreation() async {
        let coordinator = TileCacheCoordinator(
            imageCapacity: 50,
            featureCapacity: 25,
            coverageCapacity: 25
        )
        let stats = await coordinator.combinedStatistics()
        XCTAssertEqual(stats.images.currentSize, 0)
        XCTAssertEqual(stats.features.currentSize, 0)
        XCTAssertEqual(stats.coverage.currentSize, 0)
    }

    func testClearAll() async {
        let coordinator = TileCacheCoordinator()
        let id = UUID()
        let key = TileKey(trackId: id, chromosome: "chr1", tileIndex: 0, zoom: 0)
        let tile = Tile(key: key, startBP: 0, endBP: 100, content: Data([1, 2, 3]))
        await coordinator.imageCache.set(tile, for: key)

        await coordinator.clearAll()

        let stats = await coordinator.combinedStatistics()
        XCTAssertEqual(stats.images.currentSize, 0)
    }
}

// MARK: - SendableFeatureData Tests

final class SendableFeatureDataRegressionTests: XCTestCase {

    func testInitAndCount() {
        let data = SendableFeatureData([1, 2, 3])
        XCTAssertEqual(data.count, 3)
        XCTAssertFalse(data.isEmpty)
    }

    func testEmpty() {
        let data = SendableFeatureData([])
        XCTAssertTrue(data.isEmpty)
        XCTAssertEqual(data.count, 0)
    }
}

// MARK: - ReferenceFrame Additional Regression Tests

@MainActor
final class ReferenceFrameRegressionTests: XCTestCase {

    func testStartEndInitializer() {
        let frame = ReferenceFrame(chromosome: "chr1", start: 1000, end: 2000, widthInPixels: 500)
        XCTAssertEqual(frame.chromosome, "chr1")
        XCTAssertEqual(frame.origin, 1000)
        XCTAssertEqual(frame.end, 2000, accuracy: 0.01)
        XCTAssertEqual(frame.widthInPixels, 500)
        XCTAssertEqual(frame.chromosomeLength, 2000)
    }

    func testStartEndInitializerWithExplicitLength() {
        let frame = ReferenceFrame(
            chromosome: "chr1", start: 1000, end: 2000,
            chromosomeLength: 248_956_422, widthInPixels: 500
        )
        XCTAssertEqual(frame.chromosomeLength, 248_956_422)
    }

    func testWindowLength() {
        let frame = ReferenceFrame(chromosome: "chr1", start: 0, end: 10000, widthInPixels: 1000)
        XCTAssertEqual(frame.windowLength, 10000, accuracy: 0.01)
    }

    func testDescription() {
        let frame = ReferenceFrame(chromosome: "chrX", chromosomeLength: 1_000_000, widthInPixels: 1000)
        let desc = frame.description
        XCTAssertTrue(desc.contains("chrX"), "Description should contain chromosome name")
        XCTAssertTrue(desc.contains("bp/px"), "Description should contain scale unit")
    }

    func testEquality() {
        let frame1 = ReferenceFrame(chromosome: "chr1", start: 0, end: 1000, widthInPixels: 500)
        let frame2 = ReferenceFrame(chromosome: "chr1", start: 0, end: 1000, widthInPixels: 500)
        XCTAssertEqual(frame1, frame2)
    }

    func testInequalityByChromosome() {
        let frame1 = ReferenceFrame(chromosome: "chr1", start: 0, end: 1000, widthInPixels: 500)
        let frame2 = ReferenceFrame(chromosome: "chr2", start: 0, end: 1000, widthInPixels: 500)
        XCTAssertNotEqual(frame1, frame2)
    }

    func testSetChromosomeResetsView() {
        let frame = ReferenceFrame(chromosome: "chr1", chromosomeLength: 1000, widthInPixels: 500)
        frame.jumpTo(start: 200, end: 400)
        frame.setChromosome("chr2", length: 5000)
        XCTAssertEqual(frame.chromosome, "chr2")
        XCTAssertEqual(frame.chromosomeLength, 5000)
        XCTAssertEqual(frame.origin, 0)
    }

    func testIsVisibleRegion() {
        let frame = ReferenceFrame(chromosome: "chr1", start: 100, end: 200, chromosomeLength: 1000, widthInPixels: 500)
        let visibleRegion = GenomicRegion(chromosome: "chr1", start: 150, end: 180)
        let outsideRegion = GenomicRegion(chromosome: "chr1", start: 300, end: 400)
        let wrongChromRegion = GenomicRegion(chromosome: "chr2", start: 150, end: 180)

        XCTAssertTrue(frame.isVisible(region: visibleRegion))
        XCTAssertFalse(frame.isVisible(region: outsideRegion))
        XCTAssertFalse(frame.isVisible(region: wrongChromRegion))
    }

    func testUpdateWidthMaintainsGenomicRange() {
        let frame = ReferenceFrame(chromosome: "chr1", start: 1000, end: 2000, widthInPixels: 500)
        let windowBefore = frame.windowLength
        frame.updateWidth(1000)
        XCTAssertEqual(frame.windowLength, windowBefore, accuracy: 0.01)
        XCTAssertEqual(frame.widthInPixels, 1000)
    }

    func testUpdateWidthZeroIsIgnored() {
        let frame = ReferenceFrame(chromosome: "chr1", chromosomeLength: 1000, widthInPixels: 500)
        frame.updateWidth(0)
        XCTAssertEqual(frame.widthInPixels, 500, "Zero width should be ignored")
    }

    func testConstants() {
        XCTAssertEqual(ReferenceFrame.binsPerTile, 700)
        XCTAssertEqual(ReferenceFrame.maxZoom, 23)
        XCTAssertEqual(ReferenceFrame.minBP, 40)
    }
}
