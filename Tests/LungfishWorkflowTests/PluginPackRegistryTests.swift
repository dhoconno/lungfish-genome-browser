import XCTest
@testable import LungfishWorkflow

final class PluginPackRegistryTests: XCTestCase {

    func testRequiredSetupPackIsLungfishTools() {
        let pack = PluginPack.requiredSetupPack

        XCTAssertEqual(pack.id, "lungfish-tools")
        XCTAssertEqual(pack.name, "Third-Party Tools")
        XCTAssertTrue(pack.isRequiredBeforeLaunch)
        XCTAssertTrue(pack.isActive)
        XCTAssertEqual(
            pack.packages,
            [
                "nextflow", "snakemake", "bbtools", "fastp", "deacon",
                "samtools", "bcftools", "htslib", "seqkit", "cutadapt",
                "vsearch", "pigz", "sra-tools", "ucsc-bedtobigbed", "ucsc-bedgraphtobigwig",
            ]
        )
    }

    func testRequiredSetupPackDefinesPerToolChecks() {
        let pack = PluginPack.requiredSetupPack
        let environments = pack.toolRequirements.map(\.environment)

        XCTAssertEqual(environments, [
            "nextflow", "snakemake", "bbtools", "fastp", "deacon",
            "samtools", "bcftools", "htslib", "seqkit", "cutadapt",
            "vsearch", "pigz", "sra-tools", "ucsc-bedtobigbed", "ucsc-bedgraphtobigwig",
            "deacon-panhuman",
        ])
        XCTAssertEqual(pack.estimatedSizeMB, 2600)
        XCTAssertEqual(
            pack.toolRequirements.first(where: { $0.environment == "bbtools" })?.installPackages,
            ["bioconda::bbmap=39.80=h2e3bd82_0"]
        )
        XCTAssertEqual(pack.toolRequirements.first(where: { $0.environment == "bbtools" })?.executables, [
            "clumpify.sh", "bbduk.sh", "bbmerge.sh",
            "repair.sh", "tadpole.sh", "reformat.sh", "java",
        ])
        XCTAssertEqual(pack.toolRequirements.first(where: { $0.environment == "fastp" })?.executables, ["fastp"])
        XCTAssertEqual(pack.toolRequirements.first(where: { $0.environment == "deacon" })?.executables, ["deacon"])
        XCTAssertEqual(
            pack.toolRequirements.first(where: { $0.environment == "deacon-panhuman" })?.displayName,
            "Human Read Removal Data"
        )
        XCTAssertEqual(pack.toolRequirements.first(where: { $0.environment == "deacon-panhuman" })?.executables, [])
    }

    func testRequiredSetupPackMatchesPinnedManagedToolLock() throws {
        let lock = try ManagedToolLock.loadFromBundle()
        let pack = PluginPack.requiredSetupPack

        XCTAssertEqual(lock.packID, "lungfish-tools")
        XCTAssertEqual(lock.displayName, "Third-Party Tools")
        XCTAssertEqual(pack.name, lock.displayName)
        XCTAssertEqual(pack.packages, lock.tools.map(\.environment))
        XCTAssertEqual(lock.tools.count, 15)
        XCTAssertEqual(lock.managedData.count, 1)
    }

    func testRequiredSetupPackExposesPinnedAboutMetadata() throws {
        let pack = PluginPack.requiredSetupPack

        let nextflow = try XCTUnwrap(pack.toolRequirements.first(where: { $0.id == "nextflow" }))
        XCTAssertEqual(nextflow.version, "25.10.4")
        XCTAssertEqual(nextflow.license, "Apache-2.0")
        XCTAssertEqual(nextflow.sourceURL, "https://github.com/nextflow-io/nextflow")

        let bcftools = try XCTUnwrap(pack.toolRequirements.first(where: { $0.id == "bcftools" }))
        XCTAssertEqual(bcftools.version, "1.23.1")
        XCTAssertEqual(bcftools.license, "GPL")
        XCTAssertEqual(bcftools.sourceURL, "https://github.com/samtools/bcftools")

        let ucscBedToBigBed = try XCTUnwrap(pack.toolRequirements.first(where: { $0.id == "ucsc-bedtobigbed" }))
        XCTAssertEqual(ucscBedToBigBed.version, "482")
        XCTAssertEqual(ucscBedToBigBed.license, "Varies; see https://genome.ucsc.edu/license")
        XCTAssertEqual(ucscBedToBigBed.sourceURL, "https://genome.ucsc.edu/goldenPath/help/bigBed.html")
    }

    func testMetagenomicsPackDefinesSmokeChecksForVisibleTools() {
        let pack = try! XCTUnwrap(PluginPack.activeOptionalPacks.first(where: { $0.id == "metagenomics" }))
        let environments = pack.toolRequirements.map(\.environment)

        XCTAssertEqual(environments, ["kraken2", "bracken", "esviritu"])
        XCTAssertTrue(pack.toolRequirements.allSatisfy { $0.smokeTest != nil })
        XCTAssertEqual(pack.toolRequirements.first(where: { $0.environment == "esviritu" })?.executables, ["EsViritu"])
    }

    func testMetagenomicsPackPinsExactToolMetadata() throws {
        let pack = try XCTUnwrap(PluginPack.activeOptionalPacks.first(where: { $0.id == "metagenomics" }))

        let kraken2 = try XCTUnwrap(pack.toolRequirements.first(where: { $0.id == "kraken2" }))
        XCTAssertEqual(kraken2.installPackages, ["bioconda::kraken2=2.17.1"])
        XCTAssertEqual(kraken2.version, "2.17.1")
        XCTAssertEqual(kraken2.license, "GPL-3.0-or-later")
        XCTAssertEqual(kraken2.sourceURL, "https://github.com/DerrickWood/kraken2")

        let bracken = try XCTUnwrap(pack.toolRequirements.first(where: { $0.id == "bracken" }))
        XCTAssertEqual(bracken.installPackages, ["bioconda::bracken=1.0.0"])
        XCTAssertEqual(bracken.version, "1.0.0")
        XCTAssertEqual(bracken.license, "GPL-3.0")
        XCTAssertEqual(bracken.sourceURL, "https://github.com/jenniferlu717/Bracken")

        let esviritu = try XCTUnwrap(pack.toolRequirements.first(where: { $0.id == "esviritu" }))
        XCTAssertEqual(esviritu.installPackages, ["bioconda::esviritu=1.2.0"])
        XCTAssertEqual(esviritu.version, "1.2.0")
        XCTAssertEqual(esviritu.license, "MIT")
        XCTAssertEqual(esviritu.sourceURL, "https://github.com/cmmr/EsViritu")
    }

    func testRequiredSetupPackUsesLighterSnakemakeSmokeProbe() {
        let pack = PluginPack.requiredSetupPack

        XCTAssertEqual(
            pack.toolRequirements.first(where: { $0.environment == "snakemake" })?.smokeTest?.arguments,
            ["--help"]
        )
    }

    func testRequiredSetupPackUsesUsageSmokeProbeForUcscTools() {
        let pack = PluginPack.requiredSetupPack

        for environment in ["ucsc-bedtobigbed", "ucsc-bedgraphtobigwig"] {
            let smokeTest = pack.toolRequirements.first(where: { $0.environment == environment })?.smokeTest
            XCTAssertEqual(smokeTest?.arguments, [])
            XCTAssertEqual(smokeTest?.acceptedExitCodes, [255])
            XCTAssertEqual(smokeTest?.requiredOutputSubstring, "usage:")
        }
    }

    func testActiveOptionalPacksOnlyExposeMetagenomics() {
        XCTAssertEqual(PluginPack.activeOptionalPacks.map(\.id), ["metagenomics"])
    }

    func testActiveMetagenomicsPackUsesUnifiedClassifierDescription() throws {
        let pack = try XCTUnwrap(PluginPack.activeOptionalPacks.first(where: { $0.id == "metagenomics" }))

        XCTAssertEqual(
            pack.description,
            "Taxonomic classification and pathogen detection from metagenomic samples"
        )
    }

    func testVisibleCLIPacksIncludeRequiredAndActiveOptional() {
        XCTAssertEqual(PluginPack.visibleForCLI.map(\.id), ["lungfish-tools", "metagenomics"])
    }
}
