import Foundation
import LungfishIO

public struct ViralReconResolvedInput: Sendable, Equatable {
    public let bundleURL: URL
    public let sampleName: String
    public let fastqURLs: [URL]
    public let platform: ViralReconPlatform
    public let barcode: String?
    public let sequencingSummaryURL: URL?

    public init(
        bundleURL: URL,
        sampleName: String,
        fastqURLs: [URL],
        platform: ViralReconPlatform,
        barcode: String?,
        sequencingSummaryURL: URL?
    ) {
        self.bundleURL = bundleURL
        self.sampleName = sampleName
        self.fastqURLs = fastqURLs
        self.platform = platform
        self.barcode = barcode
        self.sequencingSummaryURL = sequencingSummaryURL
    }
}

public enum ViralReconInputResolver {
    public enum ResolveError: Error, Sendable, Equatable {
        case noInputs
        case noFASTQ(URL)
        case unsupportedPlatform(URL)
        case mixedPlatforms
    }

    public static func makeSamples(from resolvedInputs: [ViralReconResolvedInput]) throws -> [ViralReconSample] {
        guard !resolvedInputs.isEmpty else { throw ResolveError.noInputs }
        let platforms = Set(resolvedInputs.map(\.platform))
        guard platforms.count == 1 else { throw ResolveError.mixedPlatforms }

        return resolvedInputs.enumerated().map { index, input in
            let barcode: String?
            if input.platform == .nanopore {
                barcode = input.barcode ?? String(format: "%02d", index + 1)
            } else {
                barcode = input.barcode
            }
            return ViralReconSample(
                sampleName: input.sampleName,
                sourceBundleURL: input.bundleURL,
                fastqURLs: input.fastqURLs,
                barcode: barcode,
                sequencingSummaryURL: input.sequencingSummaryURL
            )
        }
    }

    public static func resolveInputs(from urls: [URL]) throws -> [ViralReconResolvedInput] {
        guard !urls.isEmpty else { throw ResolveError.noInputs }
        var resolved: [ViralReconResolvedInput] = []
        for url in urls {
            resolved.append(try resolveInput(from: url))
        }
        _ = try makeSamples(from: resolved)
        return resolved
    }

    private static func resolveInput(from url: URL) throws -> ViralReconResolvedInput {
        let fastqURLs: [URL]
        let sourceURL: URL
        if FASTQBundle.isBundleURL(url) {
            guard let urls = FASTQBundle.resolveAllFASTQURLs(for: url), !urls.isEmpty else {
                throw ResolveError.noFASTQ(url)
            }
            fastqURLs = urls
            sourceURL = url
        } else if FASTQBundle.isFASTQFileURL(url) {
            fastqURLs = [url]
            sourceURL = url
        } else {
            throw ResolveError.noFASTQ(url)
        }

        guard let platform = resolvePlatform(for: sourceURL, fastqURLs: fastqURLs) else {
            throw ResolveError.unsupportedPlatform(url)
        }

        return ViralReconResolvedInput(
            bundleURL: sourceURL,
            sampleName: sampleName(for: sourceURL),
            fastqURLs: fastqURLs,
            platform: platform,
            barcode: barcode(for: sourceURL),
            sequencingSummaryURL: sequencingSummaryURL(in: sourceURL)
        )
    }

    private static func resolvePlatform(for sourceURL: URL, fastqURLs: [URL]) -> ViralReconPlatform? {
        if FASTQBundle.isBundleURL(sourceURL),
           let metadata = FASTQBundleCSVMetadata.load(from: sourceURL) {
            for key in ["sequencing_platform", "platform", "vendor", "read_type"] {
                if let value = metadata.value(forKey: key),
                   let platform = normalize(platform: LungfishIO.SequencingPlatform(vendor: value)) {
                    return platform
                }
            }
        }

        for fastqURL in fastqURLs {
            if let detected = LungfishIO.SequencingPlatform.detect(fromFASTQ: fastqURL),
               let platform = normalize(platform: detected) {
                return platform
            }
        }
        return nil
    }

    private static func normalize(platform: LungfishIO.SequencingPlatform) -> ViralReconPlatform? {
        switch platform {
        case .illumina, .element, .ultima, .mgi:
            return .illumina
        case .oxfordNanopore:
            return .nanopore
        case .pacbio, .unknown:
            return nil
        }
    }

    private static func sampleName(for sourceURL: URL) -> String {
        if FASTQBundle.isBundleURL(sourceURL),
           let metadata = FASTQBundleCSVMetadata.load(from: sourceURL),
           let label = metadata.displayLabel, !label.isEmpty {
            return label
        }
        var name = sourceURL.deletingPathExtension().lastPathComponent
        if name.hasSuffix(".fastq") || name.hasSuffix(".fq") {
            name = URL(fileURLWithPath: name).deletingPathExtension().lastPathComponent
        }
        return name.isEmpty ? "sample" : name
    }

    private static func barcode(for sourceURL: URL) -> String? {
        guard FASTQBundle.isBundleURL(sourceURL),
              let metadata = FASTQBundleCSVMetadata.load(from: sourceURL) else {
            return nil
        }
        return metadata.value(forKey: "barcode")
            ?? metadata.value(forKey: "barcode_id")
            ?? metadata.value(forKey: "barcode_alias")
    }

    private static func sequencingSummaryURL(in sourceURL: URL) -> URL? {
        guard FASTQBundle.isBundleURL(sourceURL) else { return nil }
        let candidateNames = ["sequencing_summary.txt", "sequencing_summary.tsv"]
        for name in candidateNames {
            let url = sourceURL.appendingPathComponent(name)
            if FileManager.default.fileExists(atPath: url.path) {
                return url
            }
        }
        return nil
    }
}
