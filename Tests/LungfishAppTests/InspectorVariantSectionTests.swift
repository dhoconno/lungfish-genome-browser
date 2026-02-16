// InspectorVariantSectionTests.swift - Tests for VariantSection inspector view model
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishApp
@testable import LungfishCore
@testable import LungfishIO

// MARK: - VariantSectionViewModelTests

@MainActor
final class VariantSectionViewModelTests: XCTestCase {

    private func makeViewModel() -> VariantSectionViewModel {
        VariantSectionViewModel()
    }

    private func makeSearchResult(
        name: String = "rs12345",
        chromosome: String = "chr1",
        start: Int = 1000,
        end: Int = 1001,
        type: String = "SNP",
        ref: String? = "A",
        alt: String? = "G",
        quality: Double? = 30.0,
        filter: String? = "PASS",
        variantRowId: Int64? = 42
    ) -> AnnotationSearchIndex.SearchResult {
        AnnotationSearchIndex.SearchResult(
            name: name,
            chromosome: chromosome,
            start: start,
            end: end,
            trackId: "variants",
            type: type,
            strand: ".",
            ref: ref,
            alt: alt,
            quality: quality,
            filter: filter,
            sampleCount: 10,
            variantRowId: variantRowId
        )
    }

    // MARK: - Initial State

    func testInitialState() {
        let vm = makeViewModel()
        XCTAssertNil(vm.selectedVariant)
        XCTAssertEqual(vm.homRefCount, 0)
        XCTAssertEqual(vm.hetCount, 0)
        XCTAssertEqual(vm.homAltCount, 0)
        XCTAssertEqual(vm.noCallCount, 0)
        XCTAssertTrue(vm.infoFields.isEmpty)
        XCTAssertFalse(vm.hasGenotypes)
        XCTAssertNil(vm.variantDatabase)
        XCTAssertTrue(vm.isExpanded)
        XCTAssertFalse(vm.hasVariant)
    }

    // MARK: - Selection

    func testSelectVariant() {
        let vm = makeViewModel()
        let variant = makeSearchResult()

        vm.select(variant: variant)
        XCTAssertNotNil(vm.selectedVariant)
        XCTAssertEqual(vm.selectedVariant?.name, "rs12345")
        XCTAssertTrue(vm.hasVariant)
    }

    func testClearVariant() {
        let vm = makeViewModel()
        let variant = makeSearchResult()

        vm.select(variant: variant)
        XCTAssertTrue(vm.hasVariant)

        vm.clear()
        XCTAssertNil(vm.selectedVariant)
        XCTAssertFalse(vm.hasVariant)
        XCTAssertEqual(vm.homRefCount, 0)
        XCTAssertEqual(vm.hetCount, 0)
        XCTAssertEqual(vm.homAltCount, 0)
        XCTAssertEqual(vm.noCallCount, 0)
        XCTAssertTrue(vm.infoFields.isEmpty)
        XCTAssertFalse(vm.hasGenotypes)
    }

    func testSelectReplacesExisting() {
        let vm = makeViewModel()
        let v1 = makeSearchResult(name: "rs111")
        let v2 = makeSearchResult(name: "rs222")

        vm.select(variant: v1)
        XCTAssertEqual(vm.selectedVariant?.name, "rs111")

        vm.select(variant: v2)
        XCTAssertEqual(vm.selectedVariant?.name, "rs222")
    }

    // MARK: - Computed Properties

    func testTotalSamples() {
        let vm = makeViewModel()
        vm.homRefCount = 5
        vm.hetCount = 3
        vm.homAltCount = 1
        vm.noCallCount = 2
        XCTAssertEqual(vm.totalSamples, 11)
    }

    func testAlleleFrequencyZeroCalled() {
        let vm = makeViewModel()
        vm.homRefCount = 0
        vm.hetCount = 0
        vm.homAltCount = 0
        vm.noCallCount = 5
        XCTAssertNil(vm.alleleFrequency)
    }

    func testAlleleFrequencyAllHomRef() {
        let vm = makeViewModel()
        vm.homRefCount = 10
        vm.hetCount = 0
        vm.homAltCount = 0
        vm.noCallCount = 0
        XCTAssertEqual(vm.alleleFrequency, 0.0)
    }

    func testAlleleFrequencyAllHomAlt() {
        let vm = makeViewModel()
        vm.homRefCount = 0
        vm.hetCount = 0
        vm.homAltCount = 10
        vm.noCallCount = 0
        XCTAssertEqual(vm.alleleFrequency, 1.0)
    }

    func testAlleleFrequencyMixed() {
        let vm = makeViewModel()
        vm.homRefCount = 5  // 0 alt alleles
        vm.hetCount = 3     // 3 alt alleles
        vm.homAltCount = 2  // 4 alt alleles
        vm.noCallCount = 0
        // alt alleles = 3 + 2*2 = 7, total alleles = 2*(5+3+2) = 20
        let expected = 7.0 / 20.0
        XCTAssertEqual(vm.alleleFrequency!, expected, accuracy: 0.001)
    }

    func testAlleleFrequencyExcludesMissing() {
        let vm = makeViewModel()
        vm.homRefCount = 4
        vm.hetCount = 4
        vm.homAltCount = 2
        vm.noCallCount = 10  // Not counted
        // alt alleles = 4 + 2*2 = 8, total alleles = 2*(4+4+2) = 20
        let expected = 8.0 / 20.0
        XCTAssertEqual(vm.alleleFrequency!, expected, accuracy: 0.001)
    }

    // MARK: - Genotype Summary Without Database

    func testSelectWithoutDatabase() {
        let vm = makeViewModel()
        XCTAssertNil(vm.variantDatabase)

        let variant = makeSearchResult()
        vm.select(variant: variant)

        // Should select but not load genotypes
        XCTAssertTrue(vm.hasVariant)
        XCTAssertFalse(vm.hasGenotypes)
    }

    func testSelectWithoutVariantRowId() {
        let vm = makeViewModel()
        let variant = makeSearchResult(variantRowId: nil)

        vm.select(variant: variant)
        XCTAssertTrue(vm.hasVariant)
        XCTAssertFalse(vm.hasGenotypes)
    }

    // MARK: - Callbacks

    func testZoomToVariantCallback() {
        let vm = makeViewModel()
        var calledWith: AnnotationSearchIndex.SearchResult?
        vm.onZoomToVariant = { variant in
            calledWith = variant
        }

        let variant = makeSearchResult(name: "rs999")
        vm.onZoomToVariant?(variant)
        XCTAssertEqual(calledWith?.name, "rs999")
    }

    func testCopyVariantInfoCallback() {
        let vm = makeViewModel()
        var copiedInfo: String?
        vm.onCopyVariantInfo = { info in
            copiedInfo = info
        }

        vm.onCopyVariantInfo?("test info")
        XCTAssertEqual(copiedInfo, "test info")
    }

    // MARK: - Expansion State

    func testExpansionToggle() {
        let vm = makeViewModel()
        XCTAssertTrue(vm.isExpanded)

        vm.isExpanded = false
        XCTAssertFalse(vm.isExpanded)

        vm.isExpanded = true
        XCTAssertTrue(vm.isExpanded)
    }

    // MARK: - SearchResult Properties

    func testSearchResultVariantFields() {
        let variant = makeSearchResult(
            name: "rs12345",
            chromosome: "chr1",
            start: 1000,
            end: 1001,
            type: "SNP",
            ref: "A",
            alt: "G",
            quality: 30.0,
            filter: "PASS"
        )

        XCTAssertTrue(variant.isVariant)
        XCTAssertEqual(variant.ref, "A")
        XCTAssertEqual(variant.alt, "G")
        XCTAssertEqual(variant.quality, 30.0)
        XCTAssertEqual(variant.filter, "PASS")
    }

    func testSearchResultAnnotationFields() {
        let annotation = AnnotationSearchIndex.SearchResult(
            name: "BRCA1",
            chromosome: "chr17",
            start: 43044295,
            end: 43125364,
            trackId: "annotations",
            type: "gene",
            strand: "+"
        )

        XCTAssertFalse(annotation.isVariant)
        XCTAssertNil(annotation.ref)
        XCTAssertNil(annotation.alt)
    }
}

// MARK: - VariantSectionViewModelGenotypeTests

@MainActor
final class VariantSectionViewModelGenotypeTests: XCTestCase {

    /// Tests genotype summary with a temporary variant database.
    func testGenotypeSummaryWithDatabase() throws {
        let tmpDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tmpDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmpDir) }

        // Create a minimal VCF
        let vcfContent = """
        ##fileformat=VCFv4.2
        #CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tSample1\tSample2\tSample3\tSample4
        chr1\t1001\trs100\tA\tG\t30\tPASS\tAF=0.5;DP=100\tGT:DP\t0/0:10\t0/1:15\t1/1:20\t./.:0
        """

        let vcfURL = tmpDir.appendingPathComponent("test.vcf")
        try vcfContent.write(to: vcfURL, atomically: true, encoding: .utf8)

        let dbURL = tmpDir.appendingPathComponent("test.db")
        let _ = try VariantDatabase.createFromVCF(vcfURL: vcfURL, outputURL: dbURL, parseGenotypes: true)

        let db = try VariantDatabase(url: dbURL)

        let vm = VariantSectionViewModel()
        vm.variantDatabase = db

        // Create a search result that matches the variant
        let variant = AnnotationSearchIndex.SearchResult(
            name: "rs100",
            chromosome: "chr1",
            start: 1000, // 0-based
            end: 1001,
            trackId: "variants",
            type: "SNP",
            strand: ".",
            ref: "A",
            alt: "G",
            quality: 30.0,
            filter: "PASS",
            variantRowId: 1
        )

        vm.select(variant: variant)

        XCTAssertTrue(vm.hasGenotypes)
        XCTAssertEqual(vm.homRefCount, 1)  // 0/0
        XCTAssertEqual(vm.hetCount, 1)     // 0/1
        XCTAssertEqual(vm.homAltCount, 1)  // 1/1
        XCTAssertEqual(vm.noCallCount, 1)  // ./.
        XCTAssertEqual(vm.totalSamples, 4)

        // Check allele frequency: (1 het + 2 homAlt) / (2 * 3 called) = 3/6 = 0.5
        XCTAssertEqual(vm.alleleFrequency!, 0.5, accuracy: 0.001)
    }

    func testInfoFieldParsing() throws {
        let tmpDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tmpDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmpDir) }

        let vcfContent = """
        ##fileformat=VCFv4.2
        #CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tS1
        chr1\t500\trs50\tC\tT\t99\tPASS\tAF=0.3;DP=200;NS=100;DB\tGT\t0/1
        """

        let vcfURL = tmpDir.appendingPathComponent("test.vcf")
        try vcfContent.write(to: vcfURL, atomically: true, encoding: .utf8)

        let dbURL = tmpDir.appendingPathComponent("test.db")
        let _ = try VariantDatabase.createFromVCF(vcfURL: vcfURL, outputURL: dbURL, parseGenotypes: true)
        let db = try VariantDatabase(url: dbURL)

        let vm = VariantSectionViewModel()
        vm.variantDatabase = db

        let variant = AnnotationSearchIndex.SearchResult(
            name: "rs50",
            chromosome: "chr1",
            start: 499,
            end: 500,
            trackId: "variants",
            type: "SNP",
            strand: ".",
            ref: "C",
            alt: "T",
            quality: 99.0,
            filter: "PASS",
            variantRowId: 1
        )

        vm.select(variant: variant)

        // Check INFO fields were parsed
        XCTAssertFalse(vm.infoFields.isEmpty)
        let infoDict = Dictionary(uniqueKeysWithValues: vm.infoFields.map { ($0.key, $0.value) })
        XCTAssertEqual(infoDict["AF"], "0.3")
        XCTAssertEqual(infoDict["DP"], "200")
        XCTAssertEqual(infoDict["NS"], "100")
        XCTAssertEqual(infoDict["DB"], "true")  // Flag field
    }

    func testClearAfterSelect() throws {
        let tmpDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tmpDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmpDir) }

        let vcfContent = """
        ##fileformat=VCFv4.2
        #CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tS1\tS2
        chr1\t100\trs1\tA\tG\t30\tPASS\t.\tGT\t0/1\t1/1
        """

        let vcfURL = tmpDir.appendingPathComponent("test.vcf")
        try vcfContent.write(to: vcfURL, atomically: true, encoding: .utf8)
        let dbURL = tmpDir.appendingPathComponent("test.db")
        let _ = try VariantDatabase.createFromVCF(vcfURL: vcfURL, outputURL: dbURL, parseGenotypes: true)
        let db = try VariantDatabase(url: dbURL)

        let vm = VariantSectionViewModel()
        vm.variantDatabase = db

        let variant = AnnotationSearchIndex.SearchResult(
            name: "rs1", chromosome: "chr1", start: 99, end: 100,
            trackId: "variants", type: "SNP", strand: ".",
            ref: "A", alt: "G", quality: 30.0, filter: "PASS",
            variantRowId: 1
        )

        vm.select(variant: variant)
        XCTAssertTrue(vm.hasGenotypes)
        XCTAssertTrue(vm.hetCount + vm.homAltCount > 0)

        vm.clear()
        XCTAssertNil(vm.selectedVariant)
        XCTAssertEqual(vm.homRefCount, 0)
        XCTAssertEqual(vm.hetCount, 0)
        XCTAssertEqual(vm.homAltCount, 0)
        XCTAssertEqual(vm.noCallCount, 0)
        XCTAssertTrue(vm.infoFields.isEmpty)
        XCTAssertFalse(vm.hasGenotypes)
    }
}
