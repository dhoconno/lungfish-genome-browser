import XCTest
@testable import LungfishApp
@testable import LungfishWorkflow

@MainActor
final class MappingWizardSheetTests: XCTestCase {
    func testAdvancedOptionsPlaceholderUsesRealToolSpecificOptions() {
        XCTAssertEqual(
            MappingWizardSheet.advancedOptionsPlaceholder(for: .minimap2),
            "--eqx -N 5"
        )
        XCTAssertEqual(
            MappingWizardSheet.advancedOptionsPlaceholder(for: .bwaMem2),
            "-M -Y"
        )
        XCTAssertEqual(
            MappingWizardSheet.advancedOptionsPlaceholder(for: .bowtie2),
            "--very-sensitive -N 1"
        )
        XCTAssertEqual(
            MappingWizardSheet.advancedOptionsPlaceholder(for: .bbmap),
            "minid=0.97 local=t"
        )

        XCTAssertFalse(
            MappingWizardSheet.advancedOptionsPlaceholder(for: .minimap2).contains("minid="),
            "minid is BBMap-specific and should not be shown for minimap2"
        )
    }
}
