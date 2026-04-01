import UniformTypeIdentifiers

enum FASTAFileTypes {
    static let readableExtensions = ["fa", "fasta", "fna", "fsa", "fas", "faa", "ffn", "frn", "gb", "gbk", "gbff", "genbank", "embl"]
    static let compressionWrapperExtensions = ["gz", "gzip", "bgz", "bz2", "xz", "zst", "zstd"]

    /// Content types for reference sequence files, including common compressed wrappers.
    ///
    /// Includes plain FASTA/GenBank/EMBL extensions and compressed wrappers
    /// so NSOpenPanel accepts files like `sequence.fa.gz` and `reference.gbk.xz`.
    static let readableContentTypes: [UTType] = {
        var types = readableExtensions.compactMap { UTType(filenameExtension: $0) }
        types.append(.gzip)
        for wrapper in compressionWrapperExtensions {
            if let wrapperType = UTType(filenameExtension: wrapper) {
                types.append(wrapperType)
            }
        }
        return types
    }()
}
