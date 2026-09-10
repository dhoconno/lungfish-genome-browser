import Foundation

/// Analyst-facing labels for collapsed MHC reference targets. The original genotype
/// remains the identity for alignment evidence, annotations, and haplotype matching.
public enum MHCReferenceGenotypeDisplay {
    public static func alleleName(for genotype: String) -> String {
        let names = alleleNames(for: genotype)
        return names.isEmpty ? genotype : names.joined(separator: " / ")
    }

    /// All aliases must remain visible: a collapsed amplicon can represent more than
    /// one full-length allele, and choosing one would imply unsupported resolution.
    public static func alleleNames(for genotype: String) -> [String] {
        metadataValues(for: genotype, key: "alleles")
    }

    public static func sourceLocus(for genotype: String) -> String? {
        let loci = metadataValues(for: genotype, key: "source_loci")
        guard !loci.isEmpty else { return nil }
        if loci.count == 1 { return loci[0] }
        let families = Set(loci.compactMap {
            try? MHCAlleleDisplayOrder.validatedLocusDisplayOrder([$0]).first
        })
        // Shared AG paralogs can have one display family; genuine cross-family
        // targets remain explicitly unknown instead of inheriting the opaque ID.
        return families.count == 1 ? families.first : "Unknown"
    }

    private static func metadataValues(for genotype: String, key: String) -> [String] {
        guard let field = genotype.split(separator: "|", omittingEmptySubsequences: false)
            .dropFirst().first(where: { $0.hasPrefix("\(key)=") }) else { return [] }
        var seen = Set<String>()
        return field.dropFirst(key.count + 1).split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty && seen.insert($0).inserted }
    }
}
