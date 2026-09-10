import Foundation

public enum MHCAlleleDisplayOrder {
    public static let miseqLocusDisplayOrder = [
        "MHC-F", "MHC-G", "MHC-AG", "MHC-A1", "MHC-A2/A3/A4/A5",
        "MHC-K", "MHC-L", "MHC-E", "MHC-B", "MHC-DRB", "MHC-DQA",
        "MHC-DQB", "MHC-DPA", "MHC-DPB",
    ]

    public enum LocusDisplayOrderError: Error, LocalizedError {
        case invalid(String)
        case duplicate(String)
        public var errorDescription: String? {
            switch self {
            case .invalid(let value): return "Invalid genotype locus display order entry: \(value)"
            case .duplicate(let value): return "Genotype locus appears more than once in the display order: \(value)"
            }
        }
    }

    /// Canonicalizes ordered loci and slash-delimited groups without selecting haplotyping loci.
    public static func validatedLocusDisplayOrder(_ order: [String]) throws -> [String] {
        var seen = Set<String>()
        return try order.map { group in
            let members = group.split(separator: "/", omittingEmptySubsequences: false)
            let normalized = try members.map { member -> String in
                let token = displayLocus(String(member))
                guard !token.isEmpty,
                      token.range(of: "^[A-Z][A-Z0-9]*$", options: .regularExpression) != nil else {
                    throw LocusDisplayOrderError.invalid(group)
                }
                guard seen.insert(token).inserted else { throw LocusDisplayOrderError.duplicate(token) }
                return "MHC-" + token
            }
            return normalized.joined(separator: "/")
        }
    }

    private static func displayLocus(_ input: String) -> String {
        let token = input.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            .components(separatedBy: "-").last ?? ""
        for prefix in ["AG", "DRB", "DQA", "DQB", "DPA", "DPB", "B"] {
            if token == prefix || token.range(of: "^" + prefix + "[0-9]+[A-Z]*$", options: .regularExpression) != nil {
                return prefix
            }
        }
        return token
    }

    private static func customRank(_ locus: String, order: [String]) -> Int {
        let target = displayLocus(locus)
        return order.firstIndex { group in
            group.split(separator: "/").contains { displayLocus(String($0)) == target }
        } ?? order.count
    }

    /// Numeric FASTA prefixes control the default view, but an explicit locus
    /// order addresses the underlying allele (05_Mafa-F_...) or locus token
    /// (05_M4_A1). Only custom group assignment uses this interpretation.
    private static func customRank(_ name: String, parsedLocus: String, order: [String]) -> Int {
        let ordinaryRank = customRank(parsedLocus, order: order)
        guard ordinaryRank == order.count, name.first?.isASCII == true,
              name.first?.isNumber == true else { return ordinaryRank }
        let withoutNumber = name.drop(while: { $0.isASCII && $0.isNumber })
            .drop(while: { $0 == "_" || $0 == "-" || $0 == " " })
        let parsedRank = customRank(ParsedName(String(withoutNumber)).locus, order: order)
        if parsedRank != order.count { return parsedRank }
        for token in withoutNumber.split(whereSeparator: { $0 == "_" || $0 == "|" || $0 == " " }) {
            let locus = token.prefix(while: { $0 != "*" })
            let rank = customRank(String(locus), order: order)
            if rank != order.count { return rank }
        }
        return order.count
    }

    /// Compares two MHC allele display names in biological display order.
    /// Natural fields are tokenized into ASCII digit and non-digit runs. Digit runs sort
    /// before non-digit runs and compare by overflow-free numeric magnitude; non-digit
    /// runs compare by ASCII-lowercased Unicode scalar value.
    ///
    /// - Parameters:
    ///   - lhs: The left display name.
    ///   - rhs: The right display name.
    ///   - lhsStableID: A stable identifier used to break display-name ties. Defaults to `""`.
    ///   - rhsStableID: A stable identifier used to break display-name ties. Defaults to `""`.
    public static func compare(
        _ lhs: String,
        _ rhs: String,
        lhsStableID: String = "",
        rhsStableID: String = "",
        locusDisplayOrder: [String]? = nil
    ) -> ComparisonResult {
        let left = ParsedName(lhs)
        let right = ParsedName(rhs)

        if let locusDisplayOrder, !locusDisplayOrder.isEmpty {
            let leftRank = customRank(lhs, parsedLocus: left.locus, order: locusDisplayOrder)
            let rightRank = customRank(rhs, parsedLocus: right.locus, order: locusDisplayOrder)
            if leftRank != rightRank {
                return leftRank < rightRank ? .orderedAscending : .orderedDescending
            }
        }

        if left.groupRank != right.groupRank {
            return left.groupRank < right.groupRank ? .orderedAscending : .orderedDescending
        }

        for (leftValue, rightValue) in [
            (left.locus, right.locus),
            (left.allele, right.allele),
            (left.speciesPrefix, right.speciesPrefix),
            (left.completeName, right.completeName),
            (lhsStableID, rhsStableID),
        ] {
            let result = naturalCompare(leftValue, rightValue)
            if result != .orderedSame {
                return result
            }
        }

        for (leftValue, rightValue) in [
            (left.completeName, right.completeName),
            (lhsStableID, rhsStableID),
        ] {
            let result = exactCompare(leftValue, rightValue)
            if result != .orderedSame {
                return result
            }
        }

        return .orderedSame
    }

    public static func lessThan(_ lhs: String, _ rhs: String) -> Bool {
        compare(lhs, rhs, lhsStableID: "", rhsStableID: "") == .orderedAscending
    }

    public static func lessThan(_ lhs: String, _ rhs: String, locusDisplayOrder: [String]?) -> Bool {
        compare(lhs, rhs, locusDisplayOrder: locusDisplayOrder) == .orderedAscending
    }

    private static func naturalCompare(_ lhs: String, _ rhs: String) -> ComparisonResult {
        let leftTokens = asciiNaturalTokens(lhs)
        let rightTokens = asciiNaturalTokens(rhs)

        for (left, right) in zip(leftTokens, rightTokens) {
            if left.isDigits != right.isDigits {
                return left.isDigits ? .orderedAscending : .orderedDescending
            }
            if left.isDigits, left.values.count != right.values.count {
                return left.values.count < right.values.count ? .orderedAscending : .orderedDescending
            }
            let result = scalarCompare(left.values, right.values)
            if result != .orderedSame {
                return result
            }
        }

        if leftTokens.count != rightTokens.count {
            return leftTokens.count < rightTokens.count ? .orderedAscending : .orderedDescending
        }
        return .orderedSame
    }

    private static func exactCompare(_ lhs: String, _ rhs: String) -> ComparisonResult {
        scalarCompare(
            lhs.unicodeScalars.map(\.value),
            rhs.unicodeScalars.map(\.value)
        )
    }

    private static func scalarCompare(_ lhs: [UInt32], _ rhs: [UInt32]) -> ComparisonResult {
        if lhs.elementsEqual(rhs) {
            return .orderedSame
        }
        return lhs.lexicographicallyPrecedes(rhs) ? .orderedAscending : .orderedDescending
    }

    private static func asciiNaturalTokens(_ value: String) -> [ASCIINaturalToken] {
        var tokens: [ASCIINaturalToken] = []
        var currentValues: [UInt32] = []
        var currentIsDigits: Bool?

        func appendCurrentToken() {
            guard let isDigits = currentIsDigits else { return }
            let values: [UInt32]
            if isDigits {
                values = Array(currentValues.drop(while: { $0 == 48 }))
            } else {
                values = currentValues
            }
            tokens.append(ASCIINaturalToken(isDigits: isDigits, values: values))
        }

        for scalar in value.unicodeScalars {
            let isDigits = isASCIIDigit(scalar.value)
            if let currentIsDigits, currentIsDigits != isDigits {
                appendCurrentToken()
                currentValues.removeAll(keepingCapacity: true)
            }
            currentIsDigits = isDigits
            currentValues.append(isDigits ? scalar.value : asciiLowercased(scalar.value))
        }
        appendCurrentToken()
        return tokens
    }

    private static func isASCIIDigit(_ value: UInt32) -> Bool {
        value >= 48 && value <= 57
    }

    private static func asciiLowercased(_ value: UInt32) -> UInt32 {
        value >= 65 && value <= 90 ? value + 32 : value
    }

    private struct ASCIINaturalToken {
        let isDigits: Bool
        let values: [UInt32]
    }

    private struct ParsedName {
        let speciesPrefix: String
        let locus: String
        let allele: String
        let completeName: String
        let groupRank: Int

        init(_ name: String) {
            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                speciesPrefix = ""
                locus = ""
                allele = ""
                completeName = ""
                groupRank = 11
                return
            }

            guard
                let star = name.firstIndex(where: { $0 == "*" || $0 == "_" }),
                let separator = name[..<star].lastIndex(of: "-")
            else {
                speciesPrefix = ""
                locus = name
                allele = ""
                completeName = name
                groupRank = 10
                return
            }

            let parsedSpeciesPrefix = String(name[..<separator])
            let locusStart = name.index(after: separator)
            let parsedLocus = String(name[locusStart..<star])
            let alleleStart = name.index(after: star)
            let parsedAllele = String(name[alleleStart...])

            guard
                !parsedSpeciesPrefix.isEmpty,
                !parsedLocus.isEmpty,
                !parsedAllele.isEmpty
            else {
                speciesPrefix = ""
                locus = name
                allele = ""
                completeName = name
                groupRank = 10
                return
            }

            speciesPrefix = parsedSpeciesPrefix
            locus = parsedLocus
            allele = parsedAllele
            completeName = name
            groupRank = Self.groupRank(for: parsedLocus)
        }

        private static func groupRank(for locus: String) -> Int {
            if isNumberedLocus(locus, prefix: "A", allowsLetterSuffix: false) { return 0 }
            if locus == "B" { return 1 }
            if isNumberedLocus(locus, prefix: "B", allowsLetterSuffix: true) { return 2 }

            if locus.hasPrefix("AG"),
               !locus.dropFirst(2).isEmpty,
               locus.dropFirst(2).allSatisfy({ $0.isASCII && $0.isNumber }) {
                return 7
            }

            switch locus {
            case "I": return 3
            case "E": return 4
            case "F": return 5
            case "G": return 6
            case "AG": return 7
            case "J": return 8
            case "K": return 9
            default: return 10
            }
        }

        private static func isNumberedLocus(
            _ locus: String,
            prefix: Character,
            allowsLetterSuffix: Bool
        ) -> Bool {
            let prefixByte = String(prefix).utf8.first
            guard locus.utf8.first == prefixByte else { return false }
            let remainder = locus.utf8.dropFirst()
            let digits = remainder.prefix(while: { $0 >= 48 && $0 <= 57 })
            guard !digits.isEmpty else { return false }

            let suffix = remainder.dropFirst(digits.count)
            return suffix.isEmpty || (allowsLetterSuffix && suffix.allSatisfy {
                ($0 >= 65 && $0 <= 90) || ($0 >= 97 && $0 <= 122)
            })
        }
    }
}
