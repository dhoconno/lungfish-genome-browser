import Foundation
import XCTest
@testable import LungfishIO

final class MHCAlleleDisplayOrderTests: XCTestCase {
    func testCustomOrderRecognizesLociBehindNumericPrefixes() throws {
        let order = try MHCAlleleDisplayOrder.validatedLocusDisplayOrder(["F", "A1", "B"])
        let names = ["02_Mafa-B_001:01", "05_M4_A1", "09_Mafa-F_001:01", "01_control"]
        XCTAssertEqual(names.sorted { MHCAlleleDisplayOrder.lessThan($0, $1, locusDisplayOrder: order) },
                       [names[2], names[1], names[0], names[3]])
        XCTAssertEqual(names.sorted(by: MHCAlleleDisplayOrder.lessThan),
                       [names[3], names[0], names[1], names[2]])
    }

    func testCustomMiSeqOrderGroupsAliasesAndRetainsUnlistedFallback() throws {
        let order = try MHCAlleleDisplayOrder.validatedLocusDisplayOrder(MHCAlleleDisplayOrder.miseqLocusDisplayOrder)
        let labels = ["Mafa-DPB1_1", "Mafa-B21Ps_1", "Mafa-A3_1", "Mafa-F_1", "Mafa-DRB1_1", "Mafa-AG5_1", "Mafa-A1_1", "Mafa-DQA1_1", "Mafa-K_1", "Mafa-A2_1", "Mafa-L_1", "Mafa-E_1", "Mafa-G_1", "Mafa-DQB1_1", "Mafa-DPA1_1", "Mafa-Z_1"]
        XCTAssertEqual(labels.sorted { MHCAlleleDisplayOrder.lessThan($0, $1, locusDisplayOrder: order) }, [
            "Mafa-F_1", "Mafa-G_1", "Mafa-AG5_1", "Mafa-A1_1", "Mafa-A2_1", "Mafa-A3_1", "Mafa-K_1", "Mafa-L_1", "Mafa-E_1", "Mafa-B21Ps_1", "Mafa-DRB1_1", "Mafa-DQA1_1", "Mafa-DQB1_1", "Mafa-DPA1_1", "Mafa-DPB1_1", "Mafa-Z_1",
        ])
        XCTAssertEqual(MHCAlleleDisplayOrder.compare("Mafa-B_1", "Mafa-B_1", lhsStableID: "raw1", rhsStableID: "raw2", locusDisplayOrder: order), .orderedAscending)
        XCTAssertThrowsError(try MHCAlleleDisplayOrder.validatedLocusDisplayOrder(["MHC-DQA", "DQA1"]))
        XCTAssertThrowsError(try MHCAlleleDisplayOrder.validatedLocusDisplayOrder(["A2//A3"]))
    }

    func testMiSeqEAndNumberedAGStayWithClassI() {
        let names = ["Mafa-DQA1_01:04", "Mafa-K_07:01", "Mafa-AG1_03:01", "Mafa-G_01:01", "Mafa-F_01:01", "Mafa-E_02:17", "Mafa-I_01:01"]
        XCTAssertEqual(names.sorted(by: MHCAlleleDisplayOrder.lessThan), [
            "Mafa-I_01:01", "Mafa-E_02:17", "Mafa-F_01:01", "Mafa-G_01:01", "Mafa-AG1_03:01", "Mafa-K_07:01", "Mafa-DQA1_01:04",
        ])
    }

    func testUnderscoreAllelesUseBiologicalOrder() {
        XCTAssertEqual(["Mafa-DQA1_01:04", "Mafa-B_002", "Mafa-A1_063:01"].sorted(by: MHCAlleleDisplayOrder.lessThan),
                       ["Mafa-A1_063:01", "Mafa-B_002", "Mafa-DQA1_01:04"])
        XCTAssertEqual(MHCAlleleDisplayOrder.compare("Mafa-K_001", "Mafa-DRB_001"), .orderedAscending)
    }

    func testSortsCompleteMamuDisplayOrder() {
        let names = [
            "",
            "Mamu-DRB*001",
            "Mamu-K*001",
            "Mamu-J*001",
            "Mamu-AG*001",
            "Mamu-G*001",
            "Mamu-F*001",
            "Mamu-I*001",
            "Mamu-B16*001",
            "Mamu-B02ps*001",
            "Mamu-B*010",
            "Mamu-B*002",
            "Mamu-A10*001",
            "Mamu-A2*001",
            "Mamu-A1*001",
        ]

        XCTAssertEqual(names.sorted(by: MHCAlleleDisplayOrder.lessThan), [
            "Mamu-A1*001",
            "Mamu-A2*001",
            "Mamu-A10*001",
            "Mamu-B*002",
            "Mamu-B*010",
            "Mamu-B02ps*001",
            "Mamu-B16*001",
            "Mamu-I*001",
            "Mamu-F*001",
            "Mamu-G*001",
            "Mamu-AG*001",
            "Mamu-J*001",
            "Mamu-K*001",
            "Mamu-DRB*001",
            "",
        ])
    }

    func testSortsMafaLociByTheSameBiologicalOrder() {
        let names = [
            "Mafa-B14*001",
            "Mafa-A10*001",
            "Mafa-B*001",
            "Mafa-A2*001",
            "Mafa-A1*001",
        ]

        XCTAssertEqual(names.sorted(by: MHCAlleleDisplayOrder.lessThan), [
            "Mafa-A1*001",
            "Mafa-A2*001",
            "Mafa-A10*001",
            "Mafa-B*001",
            "Mafa-B14*001",
        ])
    }

    func testLocusPrecedesSpeciesPrefixForMixedSpecies() {
        let names = ["Mafa-A2*001", "Mamu-A1*001"]

        XCTAssertEqual(names.sorted(by: MHCAlleleDisplayOrder.lessThan), [
            "Mamu-A1*001",
            "Mafa-A2*001",
        ])
    }

    func testExactBPrecedesNumberedAndSuffixedBLoci() {
        let names = ["Mamu-B02ps*001", "Mamu-B16*001", "Mamu-B*001"]

        XCTAssertEqual(names.sorted(by: MHCAlleleDisplayOrder.lessThan), [
            "Mamu-B*001",
            "Mamu-B02ps*001",
            "Mamu-B16*001",
        ])
    }

    func testAllelesUseNaturalNumericOrder() {
        let names = [
            "Mamu-B*100000000000000000000",
            "Mamu-B*010",
            "Mamu-B*99999999999999999999",
            "Mamu-B*002",
            "Mamu-B*100",
        ]

        XCTAssertEqual(names.sorted(by: MHCAlleleDisplayOrder.lessThan), [
            "Mamu-B*002",
            "Mamu-B*010",
            "Mamu-B*100",
            "Mamu-B*99999999999999999999",
            "Mamu-B*100000000000000000000",
        ])
    }

    func testASCIINaturalOrderPlacesExtensionBeforeSuffixLetter() {
        let names = [
            "Mamu-B*001:10",
            "Mamu-B*001:01N",
            "Mamu-B*001:2",
            "Mamu-B*001:01_ext",
        ]

        XCTAssertEqual(names.sorted(by: MHCAlleleDisplayOrder.lessThan), [
            "Mamu-B*001:01_ext",
            "Mamu-B*001:01N",
            "Mamu-B*001:2",
            "Mamu-B*001:10",
        ])
    }

    func testNumberedLociUseOnlyASCIIDigitsAndSuffixLetters() {
        let names = [
            "Mamu-B1é*001",
            "Mamu-A١*001",
            "Mamu-K*001",
            "Mamu-A2*001",
        ]

        XCTAssertEqual(names.sorted(by: MHCAlleleDisplayOrder.lessThan), [
            "Mamu-A2*001",
            "Mamu-K*001",
            "Mamu-A١*001",
            "Mamu-B1é*001",
        ])
    }

    func testMalformedNamesPrecedeBlankNamesButFollowBiologicalLoci() {
        let names = ["not-an-allele", "", "Mamu-K*001", "Mamu-A1*001"]

        XCTAssertEqual(names.sorted(by: MHCAlleleDisplayOrder.lessThan), [
            "Mamu-A1*001",
            "Mamu-K*001",
            "not-an-allele",
            "",
        ])
    }

    func testBlankNamesNormalizeCompleteNameBeforeStableIDComparison() {
        XCTAssertEqual(
            MHCAlleleDisplayOrder.compare(
                "   ",
                "",
                lhsStableID: "cluster-z",
                rhsStableID: "cluster-a"
            ),
            .orderedDescending
        )
        XCTAssertEqual(
            MHCAlleleDisplayOrder.compare(
                "   ",
                "",
                lhsStableID: "cluster-a",
                rhsStableID: "cluster-z"
            ),
            .orderedAscending
        )
    }

    func testSameDisplayNameUsesStableIDAsFinalTieBreaker() {
        let displayName = "Mamu-A1*001"

        XCTAssertEqual(
            MHCAlleleDisplayOrder.compare(
                displayName,
                displayName,
                lhsStableID: "record-2",
                rhsStableID: "record-10"
            ),
            .orderedAscending
        )
        XCTAssertEqual(
            MHCAlleleDisplayOrder.compare(
                displayName,
                displayName,
                lhsStableID: "record-2",
                rhsStableID: "record-2"
            ),
            .orderedSame
        )
    }

    func testStableIDNaturalTiesUseExactDeterministicFallback() {
        let displayName = "Mamu-A1*001"

        for (lhsStableID, rhsStableID) in [
            ("record-2", "record-02"),
            ("record-a", "record-A"),
        ] {
            XCTAssertEqual(
                MHCAlleleDisplayOrder.compare(
                    displayName,
                    displayName,
                    lhsStableID: lhsStableID,
                    rhsStableID: rhsStableID
                ),
                .orderedDescending
            )
            XCTAssertEqual(
                MHCAlleleDisplayOrder.compare(
                    displayName,
                    displayName,
                    lhsStableID: rhsStableID,
                    rhsStableID: lhsStableID
                ),
                .orderedAscending
            )
        }
    }

    func testFullNameNaturalTiesUseExactDeterministicFallback() {
        for (lhs, rhs) in [
            ("Mamu-A1*2", "Mamu-A1*02"),
            ("Mamu-A1*abc", "Mamu-A1*ABC"),
        ] {
            XCTAssertEqual(
                MHCAlleleDisplayOrder.compare(
                    lhs,
                    rhs,
                    lhsStableID: "record-1",
                    rhsStableID: "record-1"
                ),
                .orderedDescending
            )
            XCTAssertEqual(
                MHCAlleleDisplayOrder.compare(
                    rhs,
                    lhs,
                    lhsStableID: "record-1",
                    rhsStableID: "record-1"
                ),
                .orderedAscending
            )
        }
    }

    func testStableIDNaturalOrderPrecedesExactFullNameFallback() {
        XCTAssertEqual(
            MHCAlleleDisplayOrder.compare(
                "Mamu-A1*2",
                "Mamu-A1*02",
                lhsStableID: "record-1",
                rhsStableID: "record-2"
            ),
            .orderedAscending
        )
    }

    func testCompareDefaultsStableIDsToEmptyStrings() {
        XCTAssertEqual(
            MHCAlleleDisplayOrder.compare("Mamu-A1*001", "Mamu-A2*001"),
            .orderedAscending
        )
    }
}
