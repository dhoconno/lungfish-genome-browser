// TileCacheTests.swift - Tests for TileCache
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishUI

final class TileCacheTests: XCTestCase {

    // MARK: - Basic Operations

    func testSetAndGet() async {
        let cache = TileCache<String>(capacity: 10)
        let key = TileKey(trackId: UUID(), chromosome: "chr1", tileIndex: 0, zoom: 5)
        let tile = Tile(key: key, startBP: 0, endBP: 1000, content: "Test content")

        await cache.set(tile, for: key)
        let retrieved = await cache.get(key)

        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.content, "Test content")
    }

    func testCacheMiss() async {
        let cache = TileCache<String>(capacity: 10)
        let key = TileKey(trackId: UUID(), chromosome: "chr1", tileIndex: 0, zoom: 5)

        let retrieved = await cache.get(key)

        XCTAssertNil(retrieved)
    }

    func testContains() async {
        let cache = TileCache<String>(capacity: 10)
        let key = TileKey(trackId: UUID(), chromosome: "chr1", tileIndex: 0, zoom: 5)
        let tile = Tile(key: key, startBP: 0, endBP: 1000, content: "Test")

        let containsBefore = await cache.contains(key)
        XCTAssertFalse(containsBefore)

        await cache.set(tile, for: key)

        let containsAfter = await cache.contains(key)
        XCTAssertTrue(containsAfter)
    }

    func testRemove() async {
        let cache = TileCache<String>(capacity: 10)
        let key = TileKey(trackId: UUID(), chromosome: "chr1", tileIndex: 0, zoom: 5)
        let tile = Tile(key: key, startBP: 0, endBP: 1000, content: "Test")

        await cache.set(tile, for: key)
        let removed = await cache.remove(key)

        XCTAssertNotNil(removed)
        let containsAfterRemove = await cache.contains(key)
        XCTAssertFalse(containsAfterRemove)
    }

    // MARK: - Eviction Tests

    func testLRUEviction() async {
        let cache = TileCache<String>(capacity: 3, evictionPolicy: .lru)
        let trackId = UUID()

        // Add 3 tiles
        for i in 0..<3 {
            let key = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: i, zoom: 5)
            let tile = Tile(key: key, startBP: i * 1000, endBP: (i + 1) * 1000, content: "Tile \(i)")
            await cache.set(tile, for: key)
        }

        // Access tile 0 to make it most recently used
        let key0 = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: 0, zoom: 5)
        _ = await cache.get(key0)

        // Add tile 3, should evict tile 1 (least recently used)
        let key3 = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: 3, zoom: 5)
        let tile3 = Tile(key: key3, startBP: 3000, endBP: 4000, content: "Tile 3")
        await cache.set(tile3, for: key3)

        // Tile 0 should still be there (was accessed)
        let contains0 = await cache.contains(key0)
        XCTAssertTrue(contains0)

        // Tile 1 should be evicted
        let key1 = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: 1, zoom: 5)
        let contains1 = await cache.contains(key1)
        XCTAssertFalse(contains1)

        // Tile 3 should be there
        let contains3 = await cache.contains(key3)
        XCTAssertTrue(contains3)
    }

    func testCapacityEnforcement() async {
        let cache = TileCache<String>(capacity: 5)
        let trackId = UUID()

        // Add more tiles than capacity
        for i in 0..<10 {
            let key = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: i, zoom: 5)
            let tile = Tile(key: key, startBP: i * 1000, endBP: (i + 1) * 1000, content: "Tile \(i)")
            await cache.set(tile, for: key)
        }

        let stats = await cache.statistics()
        XCTAssertLessThanOrEqual(stats.currentSize, 5)
    }

    // MARK: - Batch Operations

    func testGetAll() async {
        let cache = TileCache<String>(capacity: 10)
        let trackId = UUID()

        // Add tiles
        var keys: [TileKey] = []
        for i in 0..<5 {
            let key = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: i, zoom: 5)
            keys.append(key)
            let tile = Tile(key: key, startBP: i * 1000, endBP: (i + 1) * 1000, content: "Tile \(i)")
            await cache.set(tile, for: key)
        }

        let results = await cache.getAll(keys)

        XCTAssertEqual(results.count, 5)
    }

    func testMissing() async {
        let cache = TileCache<String>(capacity: 10)
        let trackId = UUID()

        // Add some tiles
        for i in 0..<3 {
            let key = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: i, zoom: 5)
            let tile = Tile(key: key, startBP: i * 1000, endBP: (i + 1) * 1000, content: "Tile \(i)")
            await cache.set(tile, for: key)
        }

        // Check for missing tiles
        var keys: [TileKey] = []
        for i in 0..<5 {
            keys.append(TileKey(trackId: trackId, chromosome: "chr1", tileIndex: i, zoom: 5))
        }

        let missing = await cache.missing(keys)

        XCTAssertEqual(missing.count, 2)  // Tiles 3 and 4 are missing
    }

    // MARK: - Track/Chromosome Operations

    func testRemoveAllForTrack() async {
        let cache = TileCache<String>(capacity: 10)
        let trackId1 = UUID()
        let trackId2 = UUID()

        // Add tiles for track 1
        for i in 0..<3 {
            let key = TileKey(trackId: trackId1, chromosome: "chr1", tileIndex: i, zoom: 5)
            let tile = Tile(key: key, startBP: i * 1000, endBP: (i + 1) * 1000, content: "Track1 Tile \(i)")
            await cache.set(tile, for: key)
        }

        // Add tiles for track 2
        for i in 0..<3 {
            let key = TileKey(trackId: trackId2, chromosome: "chr1", tileIndex: i, zoom: 5)
            let tile = Tile(key: key, startBP: i * 1000, endBP: (i + 1) * 1000, content: "Track2 Tile \(i)")
            await cache.set(tile, for: key)
        }

        // Remove all tiles for track 1
        await cache.removeAll(for: trackId1)

        let stats = await cache.statistics()
        XCTAssertEqual(stats.currentSize, 3)  // Only track 2 tiles remain
    }

    func testRemoveAllForChromosome() async {
        let cache = TileCache<String>(capacity: 10)
        let trackId = UUID()

        // Add tiles for chr1
        for i in 0..<3 {
            let key = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: i, zoom: 5)
            let tile = Tile(key: key, startBP: i * 1000, endBP: (i + 1) * 1000, content: "Chr1 Tile \(i)")
            await cache.set(tile, for: key)
        }

        // Add tiles for chr2
        for i in 0..<3 {
            let key = TileKey(trackId: trackId, chromosome: "chr2", tileIndex: i, zoom: 5)
            let tile = Tile(key: key, startBP: i * 1000, endBP: (i + 1) * 1000, content: "Chr2 Tile \(i)")
            await cache.set(tile, for: key)
        }

        // Remove all tiles for chr1
        await cache.removeAll(chromosome: "chr1")

        let stats = await cache.statistics()
        XCTAssertEqual(stats.currentSize, 3)  // Only chr2 tiles remain
    }

    // MARK: - Statistics Tests

    func testStatistics() async {
        let cache = TileCache<String>(capacity: 10)
        let trackId = UUID()

        // Add a tile
        let key = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: 0, zoom: 5)
        let tile = Tile(key: key, startBP: 0, endBP: 1000, content: "Test")
        await cache.set(tile, for: key)

        // Hit
        _ = await cache.get(key)

        // Miss
        let missingKey = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: 1, zoom: 5)
        _ = await cache.get(missingKey)

        let stats = await cache.statistics()

        XCTAssertEqual(stats.hits, 1)
        XCTAssertEqual(stats.misses, 1)
        XCTAssertEqual(stats.currentSize, 1)
        XCTAssertEqual(stats.hitRate, 0.5)
    }

    // MARK: - Memory Pressure

    func testReduce() async {
        let cache = TileCache<String>(capacity: 10)
        let trackId = UUID()

        // Fill cache
        for i in 0..<10 {
            let key = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: i, zoom: 5)
            let tile = Tile(key: key, startBP: i * 1000, endBP: (i + 1) * 1000, content: "Tile \(i)")
            await cache.set(tile, for: key)
        }

        // Reduce to 50%
        await cache.reduce(to: 0.5)

        let stats = await cache.statistics()
        XCTAssertLessThanOrEqual(stats.currentSize, 5)
    }

    func testClear() async {
        let cache = TileCache<String>(capacity: 10)
        let trackId = UUID()

        // Add tiles
        for i in 0..<5 {
            let key = TileKey(trackId: trackId, chromosome: "chr1", tileIndex: i, zoom: 5)
            let tile = Tile(key: key, startBP: i * 1000, endBP: (i + 1) * 1000, content: "Tile \(i)")
            await cache.set(tile, for: key)
        }

        await cache.clear()

        let stats = await cache.statistics()
        XCTAssertEqual(stats.currentSize, 0)
    }
}
