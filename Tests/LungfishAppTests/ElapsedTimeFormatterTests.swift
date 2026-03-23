// ElapsedTimeFormatterTests.swift - Unit tests for formatElapsedTime
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishApp

/// Unit tests for the ``formatElapsedTime(_:)`` free function used by the
/// operations panel to display elapsed time for running and completed items.
final class ElapsedTimeFormatterTests: XCTestCase {

    func testLessThanOneSecond() {
        XCTAssertEqual(formatElapsedTime(0.5), "<1s")
    }

    func testOneSecond() {
        XCTAssertEqual(formatElapsedTime(1.0), "1s")
    }

    func testSeconds() {
        XCTAssertEqual(formatElapsedTime(42.0), "42s")
    }

    func testMinutesAndSeconds() {
        // 3 * 60 + 12 = 192, plus fractional
        XCTAssertEqual(formatElapsedTime(192.7), "3m 12s")
    }

    func testExactMinute() {
        XCTAssertEqual(formatElapsedTime(60.0), "1m 0s")
    }

    func testHoursAndMinutes() {
        // 1 * 3600 + 23 * 60 = 4980
        XCTAssertEqual(formatElapsedTime(4980.0), "1h 23m")
    }

    func testNegativeInterval() {
        XCTAssertEqual(formatElapsedTime(-5.0), "<1s")
    }

    func testZero() {
        XCTAssertEqual(formatElapsedTime(0.0), "<1s")
    }

    func testVeryLarge() {
        // 24 hours = 86400 seconds
        XCTAssertEqual(formatElapsedTime(86400.0), "24h 0m")
    }
}
