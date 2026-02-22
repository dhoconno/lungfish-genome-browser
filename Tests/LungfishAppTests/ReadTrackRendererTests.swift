// ReadTrackRendererTests.swift - Tests for alignment read track rendering
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishApp
@testable import LungfishCore

@MainActor
final class ReadTrackRendererTests: XCTestCase {

    // MARK: - Test Helpers

    /// Creates a simple forward read at a given position with a match-only CIGAR.
    private func makeRead(
        name: String = "read1",
        flag: UInt16 = 99,   // paired, proper pair, mate reverse, first in pair
        chromosome: String = "chr1",
        position: Int = 100,
        mapq: UInt8 = 60,
        cigarLength: Int = 150,
        sequence: String? = nil
    ) -> AlignedRead {
        let cigar = [CIGAROperation(op: .match, length: cigarLength)]
        let seq = sequence ?? String(repeating: "A", count: cigarLength)
        return AlignedRead(
            name: name,
            flag: flag,
            chromosome: chromosome,
            position: position,
            mapq: mapq,
            cigar: cigar,
            sequence: seq,
            qualities: Array(repeating: 30, count: seq.count)
        )
    }

    /// Creates a ReferenceFrame for testing.
    private func makeFrame(
        start: Double = 0,
        end: Double = 10000,
        pixelWidth: Int = 1000
    ) -> ReferenceFrame {
        ReferenceFrame(
            chromosome: "chr1",
            start: start,
            end: end,
            pixelWidth: pixelWidth
        )
    }

    // MARK: - Zoom Tier Detection

    func testZoomTierCoverageAboveThreshold() {
        // > 10 bp/px → coverage
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 11.0), .coverage)
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 100.0), .coverage)
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 1000.0), .coverage)
    }

    func testZoomTierCoverageAtThreshold() {
        // Exactly at threshold: > 10 → coverage
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 10.001), .coverage)
    }

    func testZoomTierPackedBetweenThresholds() {
        // 0.5 < scale <= 10 → packed
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 10.0), .packed)
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 5.0), .packed)
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 1.0), .packed)
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 0.51), .packed)
    }

    func testZoomTierBaseAtAndBelowThreshold() {
        // <= 0.5 → base
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 0.5), .base)
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 0.1), .base)
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 0.01), .base)
    }

    func testZoomTierBoundaryValues() {
        // Test the exact boundary between packed and base
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 0.500001), .packed)
        XCTAssertEqual(ReadTrackRenderer.zoomTier(scale: 0.5), .base)
    }

    // MARK: - Total Height Calculation

    func testTotalHeightCoverage() {
        // Coverage tier always returns the fixed coverage track height
        XCTAssertEqual(
            ReadTrackRenderer.totalHeight(rowCount: 0, tier: .coverage),
            ReadTrackRenderer.coverageTrackHeight
        )
        XCTAssertEqual(
            ReadTrackRenderer.totalHeight(rowCount: 50, tier: .coverage),
            ReadTrackRenderer.coverageTrackHeight
        )
    }

    func testTotalHeightPacked() {
        let rowCount = 10
        let expected = CGFloat(rowCount) * (ReadTrackRenderer.packedReadHeight + ReadTrackRenderer.rowGap)
        XCTAssertEqual(ReadTrackRenderer.totalHeight(rowCount: rowCount, tier: .packed), expected)
    }

    func testTotalHeightBase() {
        let rowCount = 5
        let expected = CGFloat(rowCount) * (ReadTrackRenderer.baseReadHeight + ReadTrackRenderer.rowGap)
        XCTAssertEqual(ReadTrackRenderer.totalHeight(rowCount: rowCount, tier: .base), expected)
    }

    func testTotalHeightZeroRows() {
        XCTAssertEqual(ReadTrackRenderer.totalHeight(rowCount: 0, tier: .packed), 0)
        XCTAssertEqual(ReadTrackRenderer.totalHeight(rowCount: 0, tier: .base), 0)
    }

    func testTotalHeightSingleRow() {
        let packedExpected = ReadTrackRenderer.packedReadHeight + ReadTrackRenderer.rowGap
        XCTAssertEqual(ReadTrackRenderer.totalHeight(rowCount: 1, tier: .packed), packedExpected)

        let baseExpected = ReadTrackRenderer.baseReadHeight + ReadTrackRenderer.rowGap
        XCTAssertEqual(ReadTrackRenderer.totalHeight(rowCount: 1, tier: .base), baseExpected)
    }

    // MARK: - Pack Reads

    func testPackReadsEmptyInput() {
        let frame = makeFrame()
        let (packed, overflow) = ReadTrackRenderer.packReads([], frame: frame)
        XCTAssertTrue(packed.isEmpty)
        XCTAssertEqual(overflow, 0)
    }

    func testPackReadsSingleRead() {
        let frame = makeFrame(start: 0, end: 10000, pixelWidth: 1000)
        let read = makeRead(position: 100, cigarLength: 150)
        let (packed, overflow) = ReadTrackRenderer.packReads([read], frame: frame)

        XCTAssertEqual(packed.count, 1)
        XCTAssertEqual(overflow, 0)
        XCTAssertEqual(packed[0].row, 0)
        XCTAssertEqual(packed[0].read.name, "read1")
    }

    func testPackReadsNonOverlappingSameRow() {
        // Two non-overlapping reads should go in the same row
        let frame = makeFrame(start: 0, end: 10000, pixelWidth: 1000)
        // scale = 10 bp/px, read 1 covers 100-250 (15 px), read 2 covers 1000-1150 (15 px)
        let read1 = makeRead(name: "r1", position: 100, cigarLength: 150)
        let read2 = makeRead(name: "r2", position: 1000, cigarLength: 150)

        let (packed, overflow) = ReadTrackRenderer.packReads([read1, read2], frame: frame)
        XCTAssertEqual(packed.count, 2)
        XCTAssertEqual(overflow, 0)

        // Both should be in row 0 since they don't overlap in pixel space
        let rows = packed.map(\.row)
        XCTAssertTrue(rows.allSatisfy { $0 == 0 })
    }

    func testPackReadsOverlappingDifferentRows() {
        // Overlapping reads should be placed in different rows
        // Scale: 1 bp/px (1000 bp over 1000 px)
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 1000)
        let read1 = makeRead(name: "r1", position: 100, cigarLength: 150)
        let read2 = makeRead(name: "r2", position: 120, cigarLength: 150)

        let (packed, overflow) = ReadTrackRenderer.packReads([read1, read2], frame: frame)
        XCTAssertEqual(packed.count, 2)
        XCTAssertEqual(overflow, 0)

        let rows = Set(packed.map(\.row))
        XCTAssertEqual(rows.count, 2, "Overlapping reads should be on different rows")
    }

    func testPackReadsOverflowWhenTooMany() {
        // Create more reads than maxRows allows
        let maxRows = 3
        // Scale: 1 bp/px so reads are wide enough to render
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 1000)

        // Place 5 fully overlapping reads at the same position
        var reads: [AlignedRead] = []
        for i in 0..<5 {
            reads.append(makeRead(name: "r\(i)", position: 100, cigarLength: 150))
        }

        let (packed, overflow) = ReadTrackRenderer.packReads(reads, frame: frame, maxRows: maxRows)
        XCTAssertEqual(packed.count, maxRows)
        XCTAssertEqual(overflow, 2, "2 reads should overflow with maxRows=3 and 5 overlapping reads")
    }

    func testPackReadsFiltersTooSmallReads() {
        // Reads that are less than minReadPixels wide should be filtered out
        // scale = 100 bp/px (100000 bp / 1000 px), so a 150bp read is 1.5px < minReadPixels (2)
        let frame = makeFrame(start: 0, end: 100000, pixelWidth: 1000)
        let read = makeRead(position: 100, cigarLength: 150)

        let (packed, overflow) = ReadTrackRenderer.packReads([read], frame: frame)
        XCTAssertTrue(packed.isEmpty, "A read smaller than minReadPixels should be skipped")
        XCTAssertEqual(overflow, 0, "Filtered reads should not count as overflow")
    }

    func testPackReadsSortsByPosition() {
        // Pack should work even if reads are given out of order
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 1000)
        let read1 = makeRead(name: "r_later", position: 500, cigarLength: 100)
        let read2 = makeRead(name: "r_earlier", position: 100, cigarLength: 100)

        let (packed, _) = ReadTrackRenderer.packReads([read1, read2], frame: frame)

        // Both should be packed (non-overlapping at these positions)
        XCTAssertEqual(packed.count, 2)

        // The first packed read should be the earlier one
        XCTAssertEqual(packed[0].read.name, "r_earlier")
        XCTAssertEqual(packed[1].read.name, "r_later")
    }

    func testPackReadsMaxRowsDefault() {
        // Default maxRows should be 75
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 1000)
        // Create 76 overlapping reads
        var reads: [AlignedRead] = []
        for i in 0..<76 {
            reads.append(makeRead(name: "r\(i)", position: 100, cigarLength: 150))
        }

        let (packed, overflow) = ReadTrackRenderer.packReads(reads, frame: frame)
        XCTAssertEqual(packed.count, 75)
        XCTAssertEqual(overflow, 1)
    }

    // MARK: - Layout Constants

    func testLayoutConstants() {
        // Verify the expected constants haven't changed unexpectedly
        XCTAssertEqual(ReadTrackRenderer.packedReadHeight, 6)
        XCTAssertEqual(ReadTrackRenderer.baseReadHeight, 14)
        XCTAssertEqual(ReadTrackRenderer.rowGap, 1)
        XCTAssertEqual(ReadTrackRenderer.coverageTrackHeight, 60)
        XCTAssertEqual(ReadTrackRenderer.maxReadRows, 75)
        XCTAssertEqual(ReadTrackRenderer.minReadPixels, 2)
    }

    func testZoomThresholdConstants() {
        XCTAssertEqual(ReadTrackRenderer.coverageThresholdBpPerPx, 10)
        XCTAssertEqual(ReadTrackRenderer.baseThresholdBpPerPx, 0.5)
    }

    // MARK: - ReferenceFrame Extension

    func testGenomicToPixel() {
        let frame = makeFrame(start: 1000, end: 2000, pixelWidth: 1000)
        // scale = (2000-1000)/1000 = 1 bp/px
        // genomicToPixel(pos) = (pos - start) / scale

        XCTAssertEqual(frame.genomicToPixel(1000), 0, accuracy: 0.01)
        XCTAssertEqual(frame.genomicToPixel(1500), 500, accuracy: 0.01)
        XCTAssertEqual(frame.genomicToPixel(2000), 1000, accuracy: 0.01)
    }

    func testGenomicToPixelWithDifferentScale() {
        // 10000 bp over 500 px = 20 bp/px
        let frame = makeFrame(start: 0, end: 10000, pixelWidth: 500)
        // genomicToPixel(5000) = (5000-0) / 20 = 250
        XCTAssertEqual(frame.genomicToPixel(5000), 250, accuracy: 0.01)
    }

    // MARK: - AlignedRead Properties Used by Renderer

    func testAlignedReadAlignmentEnd() {
        let read = makeRead(position: 100, cigarLength: 150)
        XCTAssertEqual(read.alignmentEnd, 250) // 100 + 150
    }

    func testAlignedReadIsReverse() {
        // Flag 99 = 0x63: paired + proper_pair + mate_reverse + first_in_pair → not reverse
        let forwardRead = makeRead(flag: 99)
        XCTAssertFalse(forwardRead.isReverse)

        // Flag 147 = 0x93: paired + proper_pair + reverse + second_in_pair
        let reverseRead = makeRead(flag: 147)
        XCTAssertTrue(reverseRead.isReverse)
    }

    func testAlignedReadWithDeletion() {
        // 50M5D100M → referenceLength = 50 + 5 + 100 = 155
        let cigar = [
            CIGAROperation(op: .match, length: 50),
            CIGAROperation(op: .deletion, length: 5),
            CIGAROperation(op: .match, length: 100)
        ]
        let read = AlignedRead(
            name: "r1", flag: 99, chromosome: "chr1", position: 100,
            mapq: 60, cigar: cigar,
            sequence: String(repeating: "A", count: 150),
            qualities: Array(repeating: 30, count: 150)
        )
        XCTAssertEqual(read.alignmentEnd, 255) // 100 + 155
    }

    func testAlignedReadWithInsertion() {
        // 50M3I97M → referenceLength = 50 + 97 = 147
        let cigar = [
            CIGAROperation(op: .match, length: 50),
            CIGAROperation(op: .insertion, length: 3),
            CIGAROperation(op: .match, length: 97)
        ]
        let read = AlignedRead(
            name: "r1", flag: 99, chromosome: "chr1", position: 100,
            mapq: 60, cigar: cigar,
            sequence: String(repeating: "A", count: 150),
            qualities: Array(repeating: 30, count: 150)
        )
        XCTAssertEqual(read.alignmentEnd, 247) // 100 + 147
        XCTAssertEqual(read.insertions.count, 1)
        XCTAssertEqual(read.insertions[0].position, 150) // refPos after 50M
        XCTAssertEqual(read.insertions[0].bases.count, 3)
    }

    // MARK: - Drawing Smoke Tests (verifies no crash, not visual output)

    func testDrawCoverageDoesNotCrash() {
        let frame = makeFrame(start: 0, end: 10000, pixelWidth: 200)
        let reads = (0..<20).map { i in
            makeRead(name: "r\(i)", position: i * 100, cigarLength: 150)
        }

        // Create a bitmap context
        let width = 200
        let height = 60
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        ReadTrackRenderer.drawCoverage(reads: reads, frame: frame, context: context, rect: rect)
        // If we reach here, no crash occurred
    }

    func testDrawPackedReadsDoesNotCrash() {
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 500)
        let reads = (0..<10).map { i in
            makeRead(name: "r\(i)", position: i * 50, cigarLength: 100)
        }

        let (packed, overflow) = ReadTrackRenderer.packReads(reads, frame: frame)

        let width = 500
        let height = 200
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        ReadTrackRenderer.drawPackedReads(
            packedReads: packed, overflow: overflow,
            frame: frame, context: context, rect: rect
        )
    }

    func testDrawBaseReadsDoesNotCrash() {
        // Scale < 0.5 bp/px for base tier
        let frame = makeFrame(start: 0, end: 200, pixelWidth: 1000)
        let read = makeRead(
            position: 50, cigarLength: 50,
            sequence: "ACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTAC"
                    + "G" // 50 bases
        )

        let (packed, overflow) = ReadTrackRenderer.packReads([read], frame: frame)

        let width = 1000
        let height = 100
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        ReadTrackRenderer.drawBaseReads(
            packedReads: packed, overflow: overflow,
            frame: frame, referenceSequence: nil, referenceStart: 0,
            context: context, rect: rect
        )
    }

    func testDrawCoverageEmptyReads() {
        let frame = makeFrame()
        let width = 200
        let height = 60
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        ReadTrackRenderer.drawCoverage(reads: [], frame: frame, context: context, rect: rect)
        // Should not crash with empty reads
    }

    func testDrawPackedWithOverflow() {
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 500)
        // Create enough overlapping reads to exceed maxRows=3
        var reads: [AlignedRead] = []
        for i in 0..<5 {
            reads.append(makeRead(name: "r\(i)", position: 100, cigarLength: 150))
        }

        let (packed, overflow) = ReadTrackRenderer.packReads(reads, frame: frame, maxRows: 3)
        XCTAssertEqual(overflow, 2)

        let width = 500
        let height = 200
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        ReadTrackRenderer.drawPackedReads(
            packedReads: packed, overflow: overflow,
            frame: frame, context: context, rect: rect
        )
        // Should draw the overflow indicator bar without crash
    }

    func testDrawCoverageZeroWidthRect() {
        let frame = makeFrame()
        let context = CGContext(
            data: nil, width: 1, height: 1,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        // Zero-width rect should return early without crash
        let rect = CGRect(x: 0, y: 0, width: 0, height: 60)
        ReadTrackRenderer.drawCoverage(reads: [makeRead()], frame: frame, context: context, rect: rect)
    }

    // MARK: - Strand-Based Read Colors

    func testForwardAndReverseReadsDifferentColors() {
        // Just verify the color constants are distinct
        XCTAssertNotEqual(
            ReadTrackRenderer.forwardReadColor,
            ReadTrackRenderer.reverseReadColor
        )
        XCTAssertNotEqual(
            ReadTrackRenderer.forwardCoverageColor,
            ReadTrackRenderer.reverseCoverageColor
        )
    }

    // MARK: - Mixed Forward/Reverse Read Packing

    func testPackReadsMixedStrands() {
        // Forward and reverse reads at same position should pack into different rows
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 1000)
        let forwardRead = makeRead(name: "fwd", flag: 99, position: 100, cigarLength: 150)
        let reverseRead = makeRead(name: "rev", flag: 147, position: 100, cigarLength: 150)

        let (packed, overflow) = ReadTrackRenderer.packReads([forwardRead, reverseRead], frame: frame)
        XCTAssertEqual(packed.count, 2)
        XCTAssertEqual(overflow, 0)

        // They overlap, so should be on different rows
        let rows = Set(packed.map(\.row))
        XCTAssertEqual(rows.count, 2)
    }

    // MARK: - Display Settings

    func testDisplaySettingsDefaultValues() {
        let settings = ReadTrackRenderer.DisplaySettings()
        XCTAssertTrue(settings.showMismatches)
        XCTAssertTrue(settings.showSoftClips)
        XCTAssertTrue(settings.showIndels)
    }

    func testDisplaySettingsCustomValues() {
        let settings = ReadTrackRenderer.DisplaySettings(
            showMismatches: false, showSoftClips: true, showIndels: false
        )
        XCTAssertFalse(settings.showMismatches)
        XCTAssertTrue(settings.showSoftClips)
        XCTAssertFalse(settings.showIndels)
    }

    // MARK: - Mismatch Color Constants

    func testMismatchColorConstantsExist() {
        // Verify the new color constants are present
        XCTAssertNotNil(ReadTrackRenderer.mismatchTickColor)
        XCTAssertNotNil(ReadTrackRenderer.softClipColor)
    }

    // MARK: - Packed Mode Rendering with Reference Sequence

    func testDrawPackedReadsWithMismatchesDoesNotCrash() {
        // Scale: 2 bp/px (packed mode range)
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 500)
        // Reference is all As, read has mismatches at known positions
        let refSeq = String(repeating: "A", count: 1000)
        var readSeqChars = Array(repeating: Character("A"), count: 100)
        readSeqChars[10] = "T"  // mismatch at position 110
        readSeqChars[30] = "G"  // mismatch at position 130
        readSeqChars[50] = "C"  // mismatch at position 150
        let readSeq = String(readSeqChars)

        let read = AlignedRead(
            name: "mismatch_read", flag: 99, chromosome: "chr1", position: 100,
            mapq: 60, cigar: [CIGAROperation(op: .match, length: 100)],
            sequence: readSeq, qualities: Array(repeating: 30, count: 100)
        )

        let (packed, overflow) = ReadTrackRenderer.packReads([read], frame: frame)
        let width = 500, height = 100
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        let settings = ReadTrackRenderer.DisplaySettings(showMismatches: true, showSoftClips: true, showIndels: true)

        ReadTrackRenderer.drawPackedReads(
            packedReads: packed, overflow: overflow, frame: frame,
            referenceSequence: refSeq, referenceStart: 0, settings: settings,
            context: context, rect: rect
        )
        // No crash = success
    }

    func testDrawPackedReadsWithMismatchesDisabledDoesNotCrash() {
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 500)
        let refSeq = String(repeating: "A", count: 1000)
        let read = makeRead(position: 100, cigarLength: 100)

        let (packed, overflow) = ReadTrackRenderer.packReads([read], frame: frame)
        let width = 500, height = 100
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        let settings = ReadTrackRenderer.DisplaySettings(showMismatches: false, showSoftClips: false, showIndels: false)

        ReadTrackRenderer.drawPackedReads(
            packedReads: packed, overflow: overflow, frame: frame,
            referenceSequence: refSeq, referenceStart: 0, settings: settings,
            context: context, rect: rect
        )
    }

    func testDrawPackedReadsWithoutReferenceSequence() {
        // When no reference sequence is available, mismatches should be skipped silently
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 500)
        let read = makeRead(position: 100, cigarLength: 100)

        let (packed, overflow) = ReadTrackRenderer.packReads([read], frame: frame)
        let width = 500, height = 100
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        // No referenceSequence → nil, should skip mismatch drawing gracefully
        ReadTrackRenderer.drawPackedReads(
            packedReads: packed, overflow: overflow, frame: frame,
            referenceSequence: nil, referenceStart: 0,
            settings: ReadTrackRenderer.DisplaySettings(showMismatches: true),
            context: context, rect: rect
        )
    }

    // MARK: - Soft Clip Rendering

    func testDrawPackedReadsWithSoftClipsDoesNotCrash() {
        // Read with leading and trailing soft clips: 5S90M5S
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 500)
        let cigar = [
            CIGAROperation(op: .softClip, length: 5),
            CIGAROperation(op: .match, length: 90),
            CIGAROperation(op: .softClip, length: 5),
        ]
        let read = AlignedRead(
            name: "clipped", flag: 99, chromosome: "chr1", position: 100,
            mapq: 60, cigar: cigar,
            sequence: String(repeating: "A", count: 100),
            qualities: Array(repeating: 30, count: 100)
        )

        let (packed, overflow) = ReadTrackRenderer.packReads([read], frame: frame)
        let width = 500, height = 100
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        ReadTrackRenderer.drawPackedReads(
            packedReads: packed, overflow: overflow, frame: frame,
            settings: ReadTrackRenderer.DisplaySettings(showSoftClips: true),
            context: context, rect: rect
        )
    }

    func testDrawPackedReadsWithSoftClipsDisabled() {
        let frame = makeFrame(start: 0, end: 1000, pixelWidth: 500)
        let cigar = [
            CIGAROperation(op: .softClip, length: 5),
            CIGAROperation(op: .match, length: 90),
            CIGAROperation(op: .softClip, length: 5),
        ]
        let read = AlignedRead(
            name: "clipped", flag: 99, chromosome: "chr1", position: 100,
            mapq: 60, cigar: cigar,
            sequence: String(repeating: "A", count: 100),
            qualities: Array(repeating: 30, count: 100)
        )

        let (packed, overflow) = ReadTrackRenderer.packReads([read], frame: frame)
        let width = 500, height = 100
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        ReadTrackRenderer.drawPackedReads(
            packedReads: packed, overflow: overflow, frame: frame,
            settings: ReadTrackRenderer.DisplaySettings(showSoftClips: false),
            context: context, rect: rect
        )
    }

    // MARK: - Base Mode with Display Settings

    func testDrawBaseReadsWithSettingsDoesNotCrash() {
        let frame = makeFrame(start: 0, end: 200, pixelWidth: 1000)
        let read = makeRead(
            position: 50, cigarLength: 50,
            sequence: String(repeating: "ACGT", count: 12) + "AC" // 50 bases
        )
        let refSeq = String(repeating: "A", count: 200)

        let (packed, overflow) = ReadTrackRenderer.packReads([read], frame: frame)
        let width = 1000, height = 100
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        let settings = ReadTrackRenderer.DisplaySettings(showMismatches: true, showSoftClips: true, showIndels: true)

        ReadTrackRenderer.drawBaseReads(
            packedReads: packed, overflow: overflow, frame: frame,
            referenceSequence: refSeq, referenceStart: 0, settings: settings,
            context: context, rect: rect
        )
    }

    func testDrawBaseReadsWithAllDisabled() {
        let frame = makeFrame(start: 0, end: 200, pixelWidth: 1000)
        let cigar = [
            CIGAROperation(op: .softClip, length: 5),
            CIGAROperation(op: .match, length: 40),
            CIGAROperation(op: .insertion, length: 3),
            CIGAROperation(op: .match, length: 10),
            CIGAROperation(op: .deletion, length: 2),
            CIGAROperation(op: .match, length: 5),
            CIGAROperation(op: .softClip, length: 5),
        ]
        let read = AlignedRead(
            name: "complex", flag: 99, chromosome: "chr1", position: 50,
            mapq: 60, cigar: cigar,
            sequence: String(repeating: "A", count: 68), // 5+40+3+10+5+5 = 68
            qualities: Array(repeating: 30, count: 68)
        )
        let refSeq = String(repeating: "A", count: 200)

        let (packed, overflow) = ReadTrackRenderer.packReads([read], frame: frame)
        let width = 1000, height = 100
        let context = CGContext(
            data: nil, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!

        let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        let settings = ReadTrackRenderer.DisplaySettings(showMismatches: false, showSoftClips: false, showIndels: false)

        ReadTrackRenderer.drawBaseReads(
            packedReads: packed, overflow: overflow, frame: frame,
            referenceSequence: refSeq, referenceStart: 0, settings: settings,
            context: context, rect: rect
        )
    }

    // MARK: - Mismatch Detection Logic

    func testForEachAlignedBaseDetectsMismatches() {
        // Read sequence "ACGTA" at position 0 with reference "AAGAA"
        // Mismatches at positions 1 (C vs A), 2 (G vs G) — match, 3 (T vs A)
        let read = AlignedRead(
            name: "test", flag: 0, chromosome: "chr1", position: 0,
            mapq: 60, cigar: [CIGAROperation(op: .match, length: 5)],
            sequence: "ACGTA", qualities: []
        )
        let reference = "AAGAA"
        let refChars = Array(reference)

        var mismatches: [(Int, Character, Character)] = []
        read.forEachAlignedBase { readBase, refPos, _ in
            let readChar = Character(String(readBase).uppercased())
            if refPos < refChars.count {
                let refChar = refChars[refPos]
                if readChar != refChar {
                    mismatches.append((refPos, readChar, refChar))
                }
            }
        }

        XCTAssertEqual(mismatches.count, 2)
        XCTAssertEqual(mismatches[0].0, 1) // position 1: C vs A
        XCTAssertEqual(mismatches[0].1, "C")
        XCTAssertEqual(mismatches[1].0, 3) // position 3: T vs A
        XCTAssertEqual(mismatches[1].1, "T")
    }

    func testForEachAlignedBaseSkipsDeletions() {
        // 3M2D3M — deletions don't yield read bases
        let read = AlignedRead(
            name: "test", flag: 0, chromosome: "chr1", position: 0,
            mapq: 60, cigar: [
                CIGAROperation(op: .match, length: 3),
                CIGAROperation(op: .deletion, length: 2),
                CIGAROperation(op: .match, length: 3),
            ],
            sequence: "AAATTT", qualities: []
        )

        var alignedPositions: [Int] = []
        read.forEachAlignedBase { _, refPos, _ in
            alignedPositions.append(refPos)
        }

        // Should yield: 0,1,2 (3M), skip 3,4 (2D), then 5,6,7 (3M)
        XCTAssertEqual(alignedPositions, [0, 1, 2, 5, 6, 7])
    }

    func testSoftClipPositionsInForEachAlignedBase() {
        // 3S5M2S — soft clips don't consume reference
        let read = AlignedRead(
            name: "test", flag: 0, chromosome: "chr1", position: 100,
            mapq: 60, cigar: [
                CIGAROperation(op: .softClip, length: 3),
                CIGAROperation(op: .match, length: 5),
                CIGAROperation(op: .softClip, length: 2),
            ],
            sequence: "AAACCCCCGG", qualities: []
        )

        var matchPositions: [Int] = []
        read.forEachAlignedBase { _, refPos, op in
            if op == .match {
                matchPositions.append(refPos)
            }
        }

        // Match bases should be at 100-104
        XCTAssertEqual(matchPositions, [100, 101, 102, 103, 104])
    }
}
