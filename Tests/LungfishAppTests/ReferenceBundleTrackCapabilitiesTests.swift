import XCTest
@testable import LungfishApp
@testable import LungfishCore
@testable import LungfishIO

final class ReferenceBundleTrackCapabilitiesTests: XCTestCase {
    func testReferenceOnlyBundleDisablesMappedReadAndVariantActionsWithReasons() throws {
        let bundle = ReferenceBundle(
            url: URL(fileURLWithPath: "/tmp/reference.lungfishref", isDirectory: true),
            manifest: BundleManifest(
                name: "Reference",
                identifier: "org.lungfish.reference",
                source: SourceInfo(organism: "Reference organism", assembly: "reference"),
                genome: nil,
                annotations: [],
                variants: [],
                tracks: [],
                alignments: []
            )
        )

        let capabilities = ReferenceBundleTrackCapabilities(bundle: bundle)

        XCTAssertFalse(capabilities.mappedReads.hasTracks)
        XCTAssertFalse(capabilities.mappedReads.canFilterBAM.isEnabled)
        XCTAssertEqual(capabilities.mappedReads.canFilterBAM.disabledReason, "No alignment tracks are available.")
        XCTAssertFalse(capabilities.variants.canCallVariants.isEnabled)
        XCTAssertEqual(capabilities.variants.canCallVariants.disabledReason, "No analysis-ready BAM tracks are available.")
    }

    func testBundleWithAlignmentTracksEnablesMappedReadAndVariantActions() throws {
        let bundle = ReferenceBundle(
            url: URL(fileURLWithPath: "/tmp/aligned.lungfishref", isDirectory: true),
            manifest: BundleManifest(
                name: "Aligned Reference",
                identifier: "org.lungfish.aligned-reference",
                source: SourceInfo(organism: "Reference organism", assembly: "aligned"),
                genome: nil,
                annotations: [],
                variants: [],
                tracks: [],
                alignments: [
                    AlignmentTrackInfo(
                        id: "reads",
                        name: "Reads",
                        sourcePath: "alignments/reads.bam",
                        indexPath: "alignments/reads.bam.bai"
                    )
                ]
            )
        )

        let capabilities = ReferenceBundleTrackCapabilities(bundle: bundle)

        XCTAssertTrue(capabilities.mappedReads.hasTracks)
        XCTAssertTrue(capabilities.mappedReads.canFilterBAM.isEnabled)
        XCTAssertNil(capabilities.mappedReads.canFilterBAM.disabledReason)
        XCTAssertTrue(capabilities.variants.canCallVariants.isEnabled)
        XCTAssertNil(capabilities.variants.canCallVariants.disabledReason)
    }
}
