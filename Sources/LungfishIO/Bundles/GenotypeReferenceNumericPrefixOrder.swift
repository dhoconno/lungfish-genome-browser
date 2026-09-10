import Foundation

/// Honors curator-supplied numeric FASTA prefixes without interpreting biological loci.
public enum GenotypeReferenceNumericPrefixOrder {
    public static func hasPrefix(_ name: String) -> Bool {
        guard let first = name.utf8.first else { return false }
        return first >= 48 && first <= 57
    }

    /// Returns nil when neither name is numbered, preserving the caller's normal ordering.
    public static func compare(_ lhs: String, _ rhs: String) -> ComparisonResult? {
        let leftHasPrefix = hasPrefix(lhs)
        let rightHasPrefix = hasPrefix(rhs)
        guard leftHasPrefix || rightHasPrefix else { return nil }
        if leftHasPrefix != rightHasPrefix {
            return leftHasPrefix ? .orderedAscending : .orderedDescending
        }
        let left = magnitude(lhs)
        let right = magnitude(rhs)
        if left.count != right.count {
            return left.count < right.count ? .orderedAscending : .orderedDescending
        }
        if left != right {
            return left.lexicographicallyPrecedes(right) ? .orderedAscending : .orderedDescending
        }
        let natural = lhs.compare(rhs, options: [.numeric, .caseInsensitive],
                                  range: nil, locale: Locale(identifier: "en_US_POSIX"))
        if natural != .orderedSame { return natural }
        let exactLeft = lhs.unicodeScalars.map(\.value)
        let exactRight = rhs.unicodeScalars.map(\.value)
        if exactLeft == exactRight { return .orderedSame }
        return exactLeft.lexicographicallyPrecedes(exactRight) ? .orderedAscending : .orderedDescending
    }

    private static func magnitude(_ name: String) -> [UInt8] {
        Array(name.utf8.prefix { $0 >= 48 && $0 <= 57 }.drop { $0 == 48 })
    }
}
