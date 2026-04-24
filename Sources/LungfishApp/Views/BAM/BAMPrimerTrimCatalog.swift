import Foundation
import LungfishWorkflow

/// Gates the BAM primer-trim operation on the readiness of the `variant-calling`
/// plugin pack, which installs the `ivar` and `samtools` executables that
/// primer trimming depends on.
struct BAMPrimerTrimCatalog: Sendable {
    private let statusProvider: any PluginPackStatusProviding

    init(statusProvider: any PluginPackStatusProviding = PluginPackStatusService.shared) {
        self.statusProvider = statusProvider
    }

    /// Returns `.available` when the variant-calling pack is in the `.ready`
    /// state, otherwise `.disabled` with a user-facing reason explaining which
    /// pack is required.
    func availability() async -> DatasetOperationAvailability {
        guard let status = await statusProvider.status(forPackID: "variant-calling"),
              status.state == .ready else {
            return .disabled(reason: disabledReason())
        }
        return .available
    }

    private func disabledReason() -> String {
        guard let pack = PluginPack.builtInPack(id: "variant-calling") else {
            return "No tools available"
        }
        return "Requires \(pack.name) Pack"
    }
}
