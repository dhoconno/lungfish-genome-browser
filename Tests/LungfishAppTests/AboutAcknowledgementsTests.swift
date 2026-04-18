import XCTest
@testable import LungfishApp
@testable import LungfishWorkflow

final class AboutAcknowledgementsTests: XCTestCase {

    func testCurrentSectionsMatchBundledAndVisiblePackTools() throws {
        let sections = AboutAcknowledgements.currentSections()

        XCTAssertEqual(sections.map(\.title), ["Bundled Bootstrap", "Third-Party Tools", "Metagenomics"])

        let bundled = try XCTUnwrap(sections.first(where: { $0.title == "Bundled Bootstrap" }))
        XCTAssertEqual(bundled.entries.map(\.id), ["micromamba"])

        let required = try XCTUnwrap(sections.first(where: { $0.title == PluginPack.requiredSetupPack.name }))
        XCTAssertEqual(required.entries.map(\.id), try ManagedToolLock.loadFromBundle().tools.map(\.id))

        let metagenomics = try XCTUnwrap(sections.first(where: { $0.title == "Metagenomics" }))
        XCTAssertEqual(metagenomics.entries.map(\.id), ["kraken2", "bracken", "esviritu"])
    }

    func testCurrentSectionsRenderPinnedMetadataForManagedTools() throws {
        let sections = AboutAcknowledgements.currentSections()

        let required = try XCTUnwrap(sections.first(where: { $0.title == PluginPack.requiredSetupPack.name }))
        let nextflow = try XCTUnwrap(required.entries.first(where: { $0.id == "nextflow" }))
        XCTAssertEqual(nextflow.detail, "25.10.4")
        XCTAssertEqual(nextflow.secondaryDetail, "Apache-2.0")
        XCTAssertEqual(nextflow.sourceURL, "https://github.com/nextflow-io/nextflow")

        let bcftools = try XCTUnwrap(required.entries.first(where: { $0.id == "bcftools" }))
        XCTAssertEqual(bcftools.detail, "1.23.1")
        XCTAssertEqual(bcftools.secondaryDetail, "GPL")
        XCTAssertEqual(bcftools.sourceURL, "https://github.com/samtools/bcftools")

        let metagenomics = try XCTUnwrap(sections.first(where: { $0.title == "Metagenomics" }))
        let kraken2 = try XCTUnwrap(metagenomics.entries.first(where: { $0.id == "kraken2" }))
        XCTAssertEqual(kraken2.detail, "2.17.1")
        XCTAssertEqual(kraken2.secondaryDetail, "GPL-3.0-or-later")
        XCTAssertEqual(kraken2.sourceURL, "https://github.com/DerrickWood/kraken2")

        let esviritu = try XCTUnwrap(metagenomics.entries.first(where: { $0.id == "esviritu" }))
        XCTAssertEqual(esviritu.detail, "1.2.0")
        XCTAssertEqual(esviritu.secondaryDetail, "MIT")
        XCTAssertEqual(esviritu.sourceURL, "https://github.com/cmmr/EsViritu")
    }

    func testCurrentSectionsExcludeInactiveAndRemovedTools() {
        let entryIDs = Set(AboutAcknowledgements.currentSections().flatMap { $0.entries.map(\.id) })

        XCTAssertFalse(entryIDs.contains("metaphlan"))
        XCTAssertFalse(entryIDs.contains("bwa-mem2"))
        XCTAssertFalse(entryIDs.contains("spades"))
        XCTAssertFalse(entryIDs.contains("taxtriage"))
        XCTAssertFalse(entryIDs.contains("nao-mgs"))
    }
}
