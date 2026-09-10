import XCTest
@testable import LungfishIO

final class MHCReferenceGenotypeDisplayTests: XCTestCase {
    func testMultiSourceTargetsRetainSharedFamilyOrUnknown() {
        XCTAssertEqual(MHCReferenceGenotypeDisplay.sourceLocus(for: "id|source_loci=MHC-AG2,MHC-AG5"), "MHC-AG")
        XCTAssertEqual(MHCReferenceGenotypeDisplay.sourceLocus(for: "id|source_loci=MHC-A1,MHC-DQA1"), "Unknown")
    }

    func testAllCollapsedAlleleAliasesArePreserved() {
        let raw = "MCM_MHC_MiSeq_0015|source_loci=MHC-E|alleles=Mafa-E_02:17:01:01,Mafa-E_02:18:01:01|length=237"
        XCTAssertEqual(MHCReferenceGenotypeDisplay.alleleName(for: raw), "Mafa-E_02:17:01:01 / Mafa-E_02:18:01:01")
        XCTAssertEqual(MHCReferenceGenotypeDisplay.alleleNames(for: raw).count, 2)
        XCTAssertEqual(MHCReferenceGenotypeDisplay.sourceLocus(for: raw), "MHC-E")
    }

    func testAbsentOrEmptyAllelesKeepFullIdentityVisible() {
        for raw in ["Mafa-A1*001:01", "opaque|alleles=|source_loci=MHC-B", "opaque|source_loci=MHC-B"] {
            XCTAssertEqual(MHCReferenceGenotypeDisplay.alleleName(for: raw), raw)
        }
    }

    func testTrimsAndDeduplicatesAliasesWithoutRemovingExpressionSuffixes() {
        XCTAssertEqual(MHCReferenceGenotypeDisplay.alleleName(for: "id|alleles= Mafa-E_02:16:01:01N, Mafa-E_02:16:01:01N,Mafa-E_02:16:01:02N "),
                       "Mafa-E_02:16:01:01N / Mafa-E_02:16:01:02N")
    }
}
