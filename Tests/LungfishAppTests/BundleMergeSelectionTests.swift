import XCTest
@testable import LungfishApp

@MainActor
final class BundleMergeSelectionTests: XCTestCase {
    func testDetectsFASTQSelectionKindForHomogeneousMultiSelection() {
        let items = [
            SidebarItem(
                title: "Reads A",
                type: .fastqBundle,
                url: URL(fileURLWithPath: "/tmp/A.lungfishfastq")
            ),
            SidebarItem(
                title: "Reads B",
                type: .fastqBundle,
                url: URL(fileURLWithPath: "/tmp/B.lungfishfastq")
            ),
        ]

        XCTAssertEqual(BundleMergeSelection.detectKind(for: items), .fastq)
    }

    func testDetectsReferenceSelectionKindForHomogeneousMultiSelection() {
        let items = [
            SidebarItem(
                title: "Reference A",
                type: .referenceBundle,
                url: URL(fileURLWithPath: "/tmp/A.lungfishref")
            ),
            SidebarItem(
                title: "Reference B",
                type: .referenceBundle,
                url: URL(fileURLWithPath: "/tmp/B.lungfishref")
            ),
        ]

        XCTAssertEqual(BundleMergeSelection.detectKind(for: items), .reference)
    }

    func testRejectsMixedBundleTypes() {
        let items = [
            SidebarItem(
                title: "Reference",
                type: .referenceBundle,
                url: URL(fileURLWithPath: "/tmp/Reference.lungfishref")
            ),
            SidebarItem(
                title: "Reads",
                type: .fastqBundle,
                url: URL(fileURLWithPath: "/tmp/Reads.lungfishfastq")
            ),
        ]

        XCTAssertNil(BundleMergeSelection.detectKind(for: items))
    }

    func testRejectsSingleSelection() {
        let items = [
            SidebarItem(
                title: "Reads",
                type: .fastqBundle,
                url: URL(fileURLWithPath: "/tmp/Reads.lungfishfastq")
            ),
        ]

        XCTAssertNil(BundleMergeSelection.detectKind(for: items))
    }
}
