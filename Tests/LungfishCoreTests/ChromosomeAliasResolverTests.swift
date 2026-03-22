// ChromosomeAliasResolverTests.swift - Tests for unified chromosome aliasing
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Testing
@testable import LungfishCore

// MARK: - ChromosomeAliasResolverTests

@Suite("ChromosomeAliasResolver")
struct ChromosomeAliasResolverTests {

    // MARK: - Exact Match

    @Suite("Exact Match")
    struct ExactMatchTests {

        @Test("Returns empty resolver when all names match exactly")
        func allNamesMatch() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [("chr1", Int64(248_956_422)), ("chr2", Int64(242_193_529))],
                sourceChromosomes: [("chr1", Int64(248_956_422)), ("chr2", Int64(242_193_529))]
            )
            #expect(resolver.isEmpty)
            #expect(resolver.count == 0)
            #expect(resolver.resolve("chr1") == "chr1")
            #expect(resolver.resolve("chr2") == "chr2")
        }

        @Test("Returns empty resolver when source is a subset of reference")
        func sourceSubset() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    ("chr1", Int64(248_956_422)),
                    ("chr2", Int64(242_193_529)),
                    ("chrX", Int64(156_040_895)),
                ],
                sourceChromosomes: [("chr1", Int64(248_956_422))]
            )
            #expect(resolver.isEmpty)
        }

        @Test("Unknown source chromosome passes through unchanged")
        func unknownPassthrough() {
            let resolver = ChromosomeAliasResolver.empty
            #expect(resolver.resolve("chrUnknown") == "chrUnknown")
            #expect(resolver.reverseResolve("chrUnknown") == "chrUnknown")
        }
    }

    // MARK: - Case-Insensitive Match

    @Suite("Case-Insensitive Match")
    struct CaseInsensitiveMatchTests {

        @Test("Matches Chr1 to chr1 case-insensitively")
        func caseInsensitiveBasic() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                    .init(name: "chr2", length: 242_193_529),
                ],
                sourceChromosomes: [
                    .init(name: "Chr1", length: 248_956_422),
                    .init(name: "CHR2", length: 242_193_529),
                ]
            )
            #expect(resolver.resolve("Chr1") == "chr1")
            #expect(resolver.resolve("CHR2") == "chr2")
        }

        @Test("Case-insensitive match takes priority over length-based")
        func caseInsensitivePriority() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                ],
                sourceChromosomes: [
                    .init(name: "CHR1", length: 999),  // wrong length but name matches
                ]
            )
            #expect(resolver.resolve("CHR1") == "chr1")
        }
    }

    // MARK: - Alias Match

    @Suite("Alias Match")
    struct AliasMatchTests {

        @Test("Matches source name via reference chromosome aliases")
        func aliasMatch() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "NC_000001.11", length: 248_956_422, aliases: ["chr1", "1"]),
                    .init(name: "NC_000002.12", length: 242_193_529, aliases: ["chr2", "2"]),
                ],
                sourceChromosomes: [
                    .init(name: "chr1"),
                    .init(name: "chr2"),
                ]
            )
            #expect(resolver.resolve("chr1") == "NC_000001.11")
            #expect(resolver.resolve("chr2") == "NC_000002.12")
        }

        @Test("Alias match with numeric source names")
        func aliasMatchNumeric() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "NC_000001.11", length: 248_956_422, aliases: ["chr1", "1"]),
                ],
                sourceChromosomes: [
                    .init(name: "1"),
                ]
            )
            #expect(resolver.resolve("1") == "NC_000001.11")
        }
    }

    // MARK: - Version Stripping

    @Suite("Version Stripping")
    struct VersionStrippingTests {

        @Test("Strips version suffix from NCBI accessions")
        func stripNCBI() {
            #expect(ChromosomeAliasResolver.stripVersionSuffix("NC_000001.11") == "NC_000001")
            #expect(ChromosomeAliasResolver.stripVersionSuffix("MN908947.3") == "MN908947")
            #expect(ChromosomeAliasResolver.stripVersionSuffix("NC_045512.2") == "NC_045512")
        }

        @Test("Does not strip non-version suffixes")
        func noStripNonVersion() {
            #expect(ChromosomeAliasResolver.stripVersionSuffix("chr1") == "chr1")
            #expect(ChromosomeAliasResolver.stripVersionSuffix("scaffold_1") == "scaffold_1")
            #expect(ChromosomeAliasResolver.stripVersionSuffix("contig.abc") == "contig.abc")
        }

        @Test("Matches versioned source to unversioned reference")
        func versionedSourceToUnversionedRef() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "MN908947", length: 29_903),
                ],
                sourceChromosomes: [
                    .init(name: "MN908947.3", length: 29_903),
                ]
            )
            #expect(resolver.resolve("MN908947.3") == "MN908947")
            #expect(resolver.reverseResolve("MN908947") == "MN908947.3")
        }

        @Test("Matches unversioned source to versioned reference")
        func unversionedSourceToVersionedRef() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "NC_045512.2", length: 29_903),
                ],
                sourceChromosomes: [
                    .init(name: "NC_045512", length: 29_903),
                ]
            )
            #expect(resolver.resolve("NC_045512") == "NC_045512.2")
        }

        @Test("Version stripping checks alias list too")
        func versionStrippedAliasMatch() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422, aliases: ["NC_000001"]),
                ],
                sourceChromosomes: [
                    .init(name: "NC_000001.11"),
                ]
            )
            #expect(resolver.resolve("NC_000001.11") == "chr1")
        }
    }

    // MARK: - Chr Prefix Handling

    @Suite("Chr Prefix Handling")
    struct ChrPrefixTests {

        @Test("Adds chr prefix: 1 -> chr1")
        func addChrPrefix() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                    .init(name: "chr2", length: 242_193_529),
                    .init(name: "chrX", length: 156_040_895),
                    .init(name: "chrM", length: 16_569),
                ],
                sourceChromosomes: [
                    .init(name: "1", length: 248_956_422),
                    .init(name: "2", length: 242_193_529),
                    .init(name: "X", length: 156_040_895),
                    .init(name: "M", length: 16_569),
                ]
            )
            #expect(resolver.resolve("1") == "chr1")
            #expect(resolver.resolve("2") == "chr2")
            #expect(resolver.resolve("X") == "chrX")
            #expect(resolver.resolve("M") == "chrM")
        }

        @Test("Removes chr prefix: chr1 -> 1")
        func removeChrPrefix() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "1", length: 248_956_422),
                    .init(name: "2", length: 242_193_529),
                ],
                sourceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                    .init(name: "chr2", length: 242_193_529),
                ]
            )
            #expect(resolver.resolve("chr1") == "1")
            #expect(resolver.resolve("chr2") == "2")
        }

        @Test("Chr prefix toggle utility function")
        func toggleChrPrefix() {
            #expect(ChromosomeAliasResolver.toggleChrPrefix("chr1") == "1")
            #expect(ChromosomeAliasResolver.toggleChrPrefix("chrX") == "X")
            #expect(ChromosomeAliasResolver.toggleChrPrefix("1") == "chr1")
            #expect(ChromosomeAliasResolver.toggleChrPrefix("MT") == "chrMT")
        }
    }

    // MARK: - Well-Known Synonyms

    @Suite("Well-Known Synonyms")
    struct WellKnownSynonymTests {

        @Test("MT matches chrM via mitochondrial synonyms")
        func mtToChrM() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chrM", length: 16_569),
                ],
                sourceChromosomes: [
                    .init(name: "MT", length: 16_569),
                ]
            )
            #expect(resolver.resolve("MT") == "chrM")
        }

        @Test("chrM matches MT via mitochondrial synonyms")
        func chrMToMT() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "MT", length: 16_569),
                ],
                sourceChromosomes: [
                    .init(name: "chrM", length: 16_569),
                ]
            )
            #expect(resolver.resolve("chrM") == "MT")
        }

        @Test("chrMT matches chrM via mitochondrial synonyms")
        func chrMTToChrM() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chrM", length: 16_569),
                ],
                sourceChromosomes: [
                    .init(name: "chrMT", length: 16_569),
                ]
            )
            #expect(resolver.resolve("chrMT") == "chrM")
        }

        @Test("Well-known synonyms function returns correct values")
        func synonymsFunction() {
            let synonyms = ChromosomeAliasResolver.wellKnownSynonyms(for: "MT")
            #expect(synonyms.contains("chrM"))
            #expect(synonyms.contains("M"))
            #expect(synonyms.contains("chrMT"))
            #expect(!synonyms.contains("MT"))  // should not include self

            let noSynonyms = ChromosomeAliasResolver.wellKnownSynonyms(for: "chr1")
            #expect(noSynonyms.isEmpty)
        }
    }

    // MARK: - Combined Version + Chr Prefix

    @Suite("Combined Version + Chr Prefix")
    struct CombinedTests {

        @Test("Strips version then adds chr prefix")
        func versionThenChrPrefix() {
            // Source: "NC_000001.11", reference: "chrNC_000001"
            // This is contrived but tests the combination path
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chrNC_000001", length: 248_956_422),
                ],
                sourceChromosomes: [
                    .init(name: "NC_000001.11", length: 248_956_422),
                ]
            )
            #expect(resolver.resolve("NC_000001.11") == "chrNC_000001")
        }
    }

    // MARK: - Fuzzy Prefix Matching

    @Suite("Fuzzy Prefix Matching")
    struct FuzzyPrefixTests {

        @Test("Source with version suffix matches reference base name via prefix")
        func sourceVersionedPrefixMatch() {
            // This tests the fuzzy prefix: "MN908947.3".hasPrefix("MN908947" + ".")
            // (Version stripping should handle this too, but fuzzy is a backup.)
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "MN908947", length: 29_903),
                ],
                sourceChromosomes: [
                    .init(name: "MN908947.3"),
                ]
            )
            // Should be matched by version stripping (strategy 3) before fuzzy (strategy 7)
            #expect(resolver.resolve("MN908947.3") == "MN908947")
        }

        @Test("Reference with version suffix matches unversioned source via prefix")
        func refVersionedPrefixMatch() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "SCAFFOLD_123.2", length: 50_000),
                ],
                sourceChromosomes: [
                    .init(name: "SCAFFOLD_123"),
                ]
            )
            // Matched by reverse version stripping (strategy 3) or fuzzy prefix (strategy 7)
            #expect(resolver.resolve("SCAFFOLD_123") == "SCAFFOLD_123.2")
        }
    }

    // MARK: - FASTA Description Matching

    @Suite("FASTA Description Matching")
    struct FASTADescriptionTests {

        @Test("Matches numeric source to reference via FASTA description")
        func numericChromosomeFromDescription() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(
                        name: "NC_041754.1",
                        length: 223_616_942,
                        fastaDescription: "Macaca mulatta chromosome 1, whole genome shotgun sequence"
                    ),
                    .init(
                        name: "NC_041760.1",
                        length: 169_801_366,
                        fastaDescription: "Macaca mulatta chromosome 7, whole genome shotgun sequence"
                    ),
                ],
                sourceChromosomes: [
                    .init(name: "1"),
                    .init(name: "7"),
                ]
            )
            #expect(resolver.resolve("1") == "NC_041754.1")
            #expect(resolver.resolve("7") == "NC_041760.1")
        }

        @Test("Description match respects word boundaries")
        func descriptionWordBoundary() {
            // "chromosome 1" should not match source "17"
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(
                        name: "NC_000001.11",
                        length: 248_956_422,
                        fastaDescription: "Homo sapiens chromosome 1, GRCh38 primary assembly"
                    ),
                ],
                sourceChromosomes: [
                    .init(name: "17"),
                ]
            )
            // "chromosome 17" is not in "chromosome 1, GRCh38..." so no match
            #expect(resolver.resolve("17") == "17")  // passthrough, no match
        }

        @Test("Description match at end of string")
        func descriptionAtEnd() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(
                        name: "NC_041760.1",
                        length: 169_801_366,
                        fastaDescription: "Macaca mulatta chromosome 7"
                    ),
                ],
                sourceChromosomes: [
                    .init(name: "7"),
                ]
            )
            #expect(resolver.resolve("7") == "NC_041760.1")
        }

        @Test("Description match is case-insensitive")
        func descriptionCaseInsensitive() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(
                        name: "NC_041760.1",
                        length: 169_801_366,
                        fastaDescription: "Macaca mulatta Chromosome 7"  // capital C
                    ),
                ],
                sourceChromosomes: [
                    .init(name: "7"),
                ]
            )
            #expect(resolver.resolve("7") == "NC_041760.1")
        }
    }

    // MARK: - Length-Based Matching

    @Suite("Length-Based Matching")
    struct LengthBasedTests {

        @Test("Matches by exact length when names are completely different")
        func exactLengthMatch() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                    .init(name: "chr2", length: 242_193_529),
                ],
                sourceChromosomes: [
                    .init(name: "scaffold_A", length: 248_956_422),
                    .init(name: "scaffold_B", length: 242_193_529),
                ]
            )
            #expect(resolver.resolve("scaffold_A") == "chr1")
            #expect(resolver.resolve("scaffold_B") == "chr2")
        }

        @Test("Matches with small length tolerance (default 10 bp)")
        func lengthToleranceMatch() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                ],
                sourceChromosomes: [
                    .init(name: "contig_1", length: 248_956_415),  // 7 bp difference
                ]
            )
            #expect(resolver.resolve("contig_1") == "chr1")
        }

        @Test("Rejects length match beyond tolerance")
        func lengthBeyondTolerance() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                ],
                sourceChromosomes: [
                    .init(name: "contig_1", length: 248_956_000),  // 422 bp difference
                ]
            )
            #expect(resolver.isEmpty)
        }

        @Test("Strict length config requires exact match")
        func strictLengthConfig() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                ],
                sourceChromosomes: [
                    .init(name: "contig_1", length: 248_956_415),  // 7 bp difference
                ],
                lengthConfig: .strict
            )
            #expect(resolver.isEmpty)  // 7 bp > 0 tolerance
        }

        @Test("Relaxed config allows proportional matching")
        func relaxedLengthConfig() {
            // Source length is less than reference but within 5% for large chromosomes
            let refLength: Int64 = 248_956_422
            let sourceLength: Int64 = refLength - 10_000_000  // ~4% difference
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: refLength),
                ],
                sourceChromosomes: [
                    .init(name: "contig_1", length: sourceLength),
                ],
                lengthConfig: .relaxed
            )
            #expect(resolver.resolve("contig_1") == "chr1")
        }

        @Test("Proportional matching rejects source longer than reference")
        func proportionalRejectsLongerSource() {
            let refLength: Int64 = 248_956_422
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: refLength),
                ],
                sourceChromosomes: [
                    .init(name: "contig_1", length: refLength + 1_000_000),
                ],
                lengthConfig: .relaxed
            )
            #expect(resolver.isEmpty)
        }

        @Test("Length matching assigns first eligible reference in greedy order")
        func greedyLengthMatch() {
            // The algorithm iterates references in order, assigning each the best
            // available source. chr1 (delta 3) claims "A" before chr2 is considered.
            // This greedy-per-reference approach matches the original implementation.
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 100_000),
                    .init(name: "chr2", length: 100_005),
                ],
                sourceChromosomes: [
                    .init(name: "A", length: 100_003),  // 3 bp from chr1, 2 bp from chr2
                ]
            )
            // chr1 is iterated first and "A" is its best (only) candidate
            #expect(resolver.resolve("A") == "chr1")
        }

        @Test("Length matching picks best source when multiple candidates exist")
        func bestSourceMatch() {
            // When one reference has multiple source candidates, it picks the closest.
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 100_000),
                ],
                sourceChromosomes: [
                    .init(name: "A", length: 100_008),  // 8 bp delta
                    .init(name: "B", length: 100_002),  // 2 bp delta (closer)
                ]
            )
            #expect(resolver.resolve("B") == "chr1")   // closer match wins
            #expect(resolver.resolve("A") == "A")       // unmatched, passes through
        }

        @Test("Source chromosomes without length are skipped in length matching")
        func noLengthSkipped() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                ],
                sourceChromosomes: [
                    .init(name: "contig_1"),  // no length
                ]
            )
            #expect(resolver.isEmpty)
        }
    }

    // MARK: - Bidirectional Resolution

    @Suite("Bidirectional Resolution")
    struct BidirectionalTests {

        @Test("Forward and reverse resolution are consistent")
        func bidirectionalConsistency() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                    .init(name: "chr2", length: 242_193_529),
                    .init(name: "chrM", length: 16_569),
                ],
                sourceChromosomes: [
                    .init(name: "1", length: 248_956_422),
                    .init(name: "2", length: 242_193_529),
                    .init(name: "MT", length: 16_569),
                ]
            )
            // Forward
            #expect(resolver.resolve("1") == "chr1")
            #expect(resolver.resolve("2") == "chr2")
            #expect(resolver.resolve("MT") == "chrM")

            // Reverse
            #expect(resolver.reverseResolve("chr1") == "1")
            #expect(resolver.reverseResolve("chr2") == "2")
            #expect(resolver.reverseResolve("chrM") == "MT")
        }

        @Test("Reverse resolution passes through unaliased names")
        func reversePassthrough() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                ],
                sourceChromosomes: [
                    .init(name: "1", length: 248_956_422),
                ]
            )
            #expect(resolver.reverseResolve("chrX") == "chrX")
        }
    }

    // MARK: - Strategy Priority

    @Suite("Strategy Priority")
    struct StrategyPriorityTests {

        @Test("Name-based match takes priority over length-based")
        func nameOverLength() {
            // Source "1" matches ref "chr1" by chr prefix, not by length to "chrX"
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                    .init(name: "chrX", length: 248_956_422),  // same length as chr1
                ],
                sourceChromosomes: [
                    .init(name: "1", length: 248_956_422),
                ]
            )
            #expect(resolver.resolve("1") == "chr1")  // chr prefix match, not length
        }

        @Test("Alias match takes priority over version stripping")
        func aliasOverVersion() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "primary_1", length: 100_000, aliases: ["NC_000001.11"]),
                    .init(name: "NC_000001", length: 100_000),  // would match by version stripping
                ],
                sourceChromosomes: [
                    .init(name: "NC_000001.11"),
                ]
            )
            #expect(resolver.resolve("NC_000001.11") == "primary_1")  // alias match wins
        }
    }

    // MARK: - ChromosomeInfo Convenience

    @Suite("ChromosomeInfo Convenience")
    struct ChromosomeInfoConvenienceTests {

        @Test("Builds from ChromosomeInfo array")
        func buildFromChromosomeInfo() {
            let chromosomes = [
                ChromosomeInfo(
                    name: "NC_041754.1",
                    length: 223_616_942,
                    offset: 0,
                    lineBases: 80,
                    lineWidth: 81,
                    aliases: ["chr1", "1"],
                    fastaDescription: "Macaca mulatta chromosome 1"
                ),
            ]
            let resolver = ChromosomeAliasResolver.build(
                bundleChromosomes: chromosomes,
                sourceChromosomes: [.init(name: "1")]
            )
            #expect(resolver.resolve("1") == "NC_041754.1")
        }
    }

    // MARK: - Edge Cases

    @Suite("Edge Cases")
    struct EdgeCaseTests {

        @Test("Empty source list produces empty resolver")
        func emptySource() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                ],
                sourceChromosomes: []
            )
            #expect(resolver.isEmpty)
        }

        @Test("Empty reference list produces empty resolver")
        func emptyReference() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [] as [ChromosomeAliasResolver.ReferenceChromosome],
                sourceChromosomes: [.init(name: "chr1", length: 248_956_422)]
            )
            #expect(resolver.isEmpty)
        }

        @Test("One-to-one matching prevents duplicate assignments")
        func noDuplicateAssignments() {
            // Two sources with similar names; each should match exactly one reference
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                    .init(name: "chr2", length: 242_193_529),
                ],
                sourceChromosomes: [
                    .init(name: "1", length: 248_956_422),
                    .init(name: "2", length: 242_193_529),
                ]
            )
            #expect(resolver.count == 2)
            #expect(resolver.resolve("1") == "chr1")
            #expect(resolver.resolve("2") == "chr2")
        }

        @Test("Mixed matched and unmatched source chromosomes")
        func mixedMatchUnmatch() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                    .init(name: "chr2", length: 242_193_529),
                ],
                sourceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),  // exact match
                    .init(name: "2", length: 242_193_529),     // needs aliasing
                ]
            )
            #expect(resolver.count == 1)
            #expect(resolver.resolve("chr1") == "chr1")  // passthrough
            #expect(resolver.resolve("2") == "chr2")      // aliased
        }

        @Test("Resolver is Equatable")
        func equatable() {
            let r1 = ChromosomeAliasResolver(
                sourceToReference: ["1": "chr1"],
                referenceToSource: ["chr1": "1"]
            )
            let r2 = ChromosomeAliasResolver(
                sourceToReference: ["1": "chr1"],
                referenceToSource: ["chr1": "1"]
            )
            #expect(r1 == r2)
        }

        @Test("Resolver is Sendable")
        func sendable() {
            let resolver = ChromosomeAliasResolver.empty
            // This compiles only if ChromosomeAliasResolver is Sendable
            let task = Task { resolver.resolve("chr1") }
            _ = task
        }

        @Test("Large chromosome set performance")
        func largeChromosomeSet() {
            // Simulate a genome with many scaffolds
            let refChroms = (1...1000).map {
                ChromosomeAliasResolver.ReferenceChromosome(
                    name: "scaffold_\($0)",
                    length: Int64($0 * 10_000)
                )
            }
            let sourceChroms = (1...1000).map {
                ChromosomeAliasResolver.SourceChromosome(
                    name: "ctg_\($0)",
                    length: Int64($0 * 10_000)
                )
            }
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: refChroms,
                sourceChromosomes: sourceChroms
            )
            // Should match all by length
            #expect(resolver.count == 1000)
            #expect(resolver.resolve("ctg_1") == "scaffold_1")
            #expect(resolver.resolve("ctg_500") == "scaffold_500")
            #expect(resolver.resolve("ctg_1000") == "scaffold_1000")
        }
    }

    // MARK: - Real-World Scenarios

    @Suite("Real-World Scenarios")
    struct RealWorldTests {

        @Test("UCSC reference vs Ensembl VCF (chr prefix)")
        func ucscVsEnsembl() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                    .init(name: "chr2", length: 242_193_529),
                    .init(name: "chrX", length: 156_040_895),
                    .init(name: "chrY", length: 57_227_415),
                    .init(name: "chrM", length: 16_569),
                ],
                sourceChromosomes: [
                    .init(name: "1", length: 248_956_422),
                    .init(name: "2", length: 242_193_529),
                    .init(name: "X", length: 156_040_895),
                    .init(name: "Y", length: 57_227_415),
                    .init(name: "MT", length: 16_569),
                ]
            )
            #expect(resolver.count == 5)
            #expect(resolver.resolve("1") == "chr1")
            #expect(resolver.resolve("MT") == "chrM")
        }

        @Test("NCBI reference vs numeric VCF with FASTA descriptions")
        func ncbiRefVsNumericVCF() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(
                        name: "NC_041754.1",
                        length: 223_616_942,
                        fastaDescription: "Macaca mulatta chromosome 1, whole genome shotgun sequence"
                    ),
                    .init(
                        name: "NC_041760.1",
                        length: 169_801_366,
                        fastaDescription: "Macaca mulatta chromosome 7, whole genome shotgun sequence"
                    ),
                ],
                sourceChromosomes: [
                    .init(name: "1", length: 223_616_942),
                    .init(name: "7", length: 169_801_366),
                ]
            )
            #expect(resolver.resolve("1") == "NC_041754.1")
            #expect(resolver.resolve("7") == "NC_041760.1")
        }

        @Test("SARS-CoV-2: versioned BAM vs unversioned reference")
        func sarsCov2Versioned() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "MN908947", length: 29_903),
                ],
                sourceChromosomes: [
                    .init(name: "MN908947.3", length: 29_903),
                ]
            )
            #expect(resolver.resolve("MN908947.3") == "MN908947")
        }

        @Test("Mixed naming: some exact, some need aliasing")
        func mixedNaming() {
            let resolver = ChromosomeAliasResolver.build(
                referenceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),
                    .init(name: "chr2", length: 242_193_529),
                    .init(name: "chrM", length: 16_569),
                    .init(name: "chrUn_gl000220", length: 161_802),
                ],
                sourceChromosomes: [
                    .init(name: "chr1", length: 248_956_422),   // exact match
                    .init(name: "2", length: 242_193_529),      // chr prefix
                    .init(name: "MT", length: 16_569),          // well-known synonym
                    .init(name: "Un_gl000220", length: 161_802), // chr prefix
                ]
            )
            // Only non-exact matches should be in the resolver
            #expect(resolver.count == 3)
            #expect(resolver.resolve("chr1") == "chr1")  // passthrough
            #expect(resolver.resolve("2") == "chr2")
            #expect(resolver.resolve("MT") == "chrM")
            #expect(resolver.resolve("Un_gl000220") == "chrUn_gl000220")
        }
    }
}
