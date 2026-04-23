import Foundation

enum BundleMergeSelectionKind: Equatable {
    case fastq
    case reference
}

enum BundleMergeSelection {
    static func detectKind(for items: [SidebarItem]) -> BundleMergeSelectionKind? {
        guard items.count >= 2 else { return nil }

        let itemTypes = Set(items.map(\.type))
        if itemTypes == [.fastqBundle] {
            return .fastq
        }
        if itemTypes == [.referenceBundle] {
            return .reference
        }
        return nil
    }
}
