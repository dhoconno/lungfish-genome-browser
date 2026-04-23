import Foundation
import LungfishCore
import LungfishIO

enum BAMVariantCallingEligibility {
    static func eligibleAlignmentTracks(in bundle: ReferenceBundle) -> [AlignmentTrackInfo] {
        bundle.alignmentTrackIds.compactMap { trackID in
            guard let track = bundle.alignmentTrack(id: trackID),
                  track.format == .bam,
                  (try? bundle.resolveAlignmentPath(track)) != nil,
                  (try? bundle.resolveAlignmentIndexPath(track)) != nil else {
                return nil
            }
            return track
        }
    }

    static func defaultTrackID(
        in eligibleAlignmentTracks: [AlignmentTrackInfo],
        preferredAlignmentTrackID: String?
    ) -> String {
        if let preferredAlignmentTrackID,
           eligibleAlignmentTracks.contains(where: { $0.id == preferredAlignmentTrackID }) {
            return preferredAlignmentTrackID
        }
        return eligibleAlignmentTracks.first?.id ?? ""
    }
}
