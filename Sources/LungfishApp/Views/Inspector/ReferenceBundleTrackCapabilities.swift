import Foundation
import LungfishIO

struct ReferenceActionAvailability: Equatable {
    let isEnabled: Bool
    let disabledReason: String?

    static let enabled = ReferenceActionAvailability(isEnabled: true, disabledReason: nil)

    static func disabled(_ reason: String) -> ReferenceActionAvailability {
        ReferenceActionAvailability(isEnabled: false, disabledReason: reason)
    }
}

struct ReferenceBundleTrackCapabilities: Equatable {
    struct MappedReads: Equatable {
        let hasTracks: Bool
        let canFilterBAM: ReferenceActionAvailability
        let canPrimerTrim: ReferenceActionAvailability
    }

    struct Variants: Equatable {
        let hasTracks: Bool
        let canCallVariants: ReferenceActionAvailability
    }

    struct Annotations: Equatable {
        let hasTracks: Bool
        let canCreateFromMappedReads: ReferenceActionAvailability
    }

    let mappedReads: MappedReads
    let variants: Variants
    let annotations: Annotations

    init(bundle: ReferenceBundle) {
        let hasAlignments = !bundle.manifest.alignments.isEmpty
        let hasVariants = !bundle.manifest.variants.isEmpty
        let hasAnnotations = !bundle.manifest.annotations.isEmpty
        let noAlignments = "No alignment tracks are available."
        let noAnalysisReadyBAM = "No analysis-ready BAM tracks are available."

        mappedReads = MappedReads(
            hasTracks: hasAlignments,
            canFilterBAM: hasAlignments ? .enabled : .disabled(noAlignments),
            canPrimerTrim: hasAlignments ? .enabled : .disabled(noAnalysisReadyBAM)
        )
        variants = Variants(
            hasTracks: hasVariants,
            canCallVariants: hasAlignments ? .enabled : .disabled(noAnalysisReadyBAM)
        )
        annotations = Annotations(
            hasTracks: hasAnnotations,
            canCreateFromMappedReads: hasAlignments ? .enabled : .disabled(noAlignments)
        )
    }
}
