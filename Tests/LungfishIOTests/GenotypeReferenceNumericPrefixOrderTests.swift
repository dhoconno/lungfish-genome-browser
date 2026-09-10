import XCTest
@testable import LungfishIO

final class GenotypeReferenceNumericPrefixOrderTests: XCTestCase {
    func testNumberedReferencesSortBeforeUnnumberedAndByIntegerPrefix() {
        let input = ["Mafa-A1*001", "12_M1_B_001", "05_M4_A1_031_01", "2_M1_G", "01_M1_F"]
        XCTAssertEqual(input.sorted { GenotypeReferenceNumericPrefixOrder.compare($0, $1) == .orderedAscending },
                       ["01_M1_F", "2_M1_G", "05_M4_A1_031_01", "12_M1_B_001", "Mafa-A1*001"])
    }

    func testArbitrarilyLargePrefixesCompareWithoutIntegerOverflow() {
        let shorter = String(repeating: "9", count: 90) + "_B"
        let longer = "1" + String(repeating: "0", count: 90) + "_A"
        XCTAssertEqual(GenotypeReferenceNumericPrefixOrder.compare(shorter, longer), .orderedAscending)
        XCTAssertEqual(GenotypeReferenceNumericPrefixOrder.compare("000" + shorter, longer), .orderedAscending)
    }

    func testEqualPrefixesUseNaturalNamesAndDeterministicExactTies() {
        XCTAssertEqual(GenotypeReferenceNumericPrefixOrder.compare("05_A2", "5_A10"), .orderedAscending)
        XCTAssertEqual(GenotypeReferenceNumericPrefixOrder.compare("05_A2", "5_A2"), .orderedAscending)
        XCTAssertEqual(GenotypeReferenceNumericPrefixOrder.compare("0_B", "000_B"), .orderedDescending)
        XCTAssertEqual(GenotypeReferenceNumericPrefixOrder.compare("05_A2", "05_A2"), .orderedSame)
    }

    func testOnlyInitialASCIIDigitsActivatePrefixOrder() {
        for text in ["", " 05_A", "Mafa-A1*001", "５_A", "-5_A"] {
            XCTAssertFalse(GenotypeReferenceNumericPrefixOrder.hasPrefix(text))
            XCTAssertNil(GenotypeReferenceNumericPrefixOrder.compare(text, "Mafa-B*001"))
        }
        XCTAssertTrue(GenotypeReferenceNumericPrefixOrder.hasPrefix("5"))
        XCTAssertEqual(GenotypeReferenceNumericPrefixOrder.compare("Mafa-A1*001", "05_B"), .orderedDescending)
    }
}
