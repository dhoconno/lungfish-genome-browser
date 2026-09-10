import XCTest
import AppKit
@testable import LungfishGenotypeUI
import LungfishIO
import LungfishWorkflow
import LungfishTestSupport

@MainActor
final class GenotypeDiagnosticAlleleDisplayTests: GenotypeResultViewportTestCase {
    func testDiagnosticScopeSurvivesCallsMatrixCallsAndPreservesReadTotals() throws {
        let root = try TestTempDirectory.make(prefix: "DiagnosticAlleleScope")
        defer { TestTempDirectory.cleanup(root) }
        let bundleURL = root.appendingPathComponent("result.lungfishgenotype", isDirectory: true)
        try FileManager.default.createDirectory(at: bundleURL, withIntermediateDirectories: true)
        let diagnostic = "Mafa-DQA1_01:01"
        let supplemental = "Mafa-DQA1_99:99"
        let calls = [makeCall(sample: "animal", genotype: diagnostic, reads: 40),
                     makeCall(sample: "animal", genotype: supplemental, reads: 10)]
        let sample = ONTGenotypeSampleResult(sample: "animal", passedAlignments: 50, passedUniqueReads: 50,
            sampleTotalReads: 100, sampleUniqueRetainedPercent: 50, calls: calls)
        let analysis = GenotypeHaplotypeAnalysis(assayID: "MHC-exon2-miSeq", definitionSetID: "diagnostic-scope-custom",
            definitionSetName: "Diagnostic scope custom", speciesName: "Macaque", samples: [
                .init(sample: "animal", calls: [.init(locus: "MHC-DQ", sourceLocus: "MHC-DQ", haplotype1: "DQ-custom",
                    haplotype2: "-", status: .called,
                    matchedHaplotypes: [.init(name: "DQ-custom", diagnosticAlleles: [diagnostic], observedDiagnosticAlleles: [diagnostic])],
                    observedGenotypeCount: 2, observedGenotypes: [diagnostic, supplemental])])
            ])
        let controller = GenotypeResultViewController()
        _ = controller.view
        controller.configure(result: makeResult(bundleURL: bundleURL, samples: [sample], calls: calls, haplotypeAnalysis: analysis))
        controller.testingSelectCellEvidence(animalId: "animal", locus: "MHC-DQ")
        let initialEvidence = try XCTUnwrap(controller.testingCurrentCallEvidence)
        XCTAssertEqual(initialEvidence.animalGenotypes.count, 2)
        XCTAssertEqual(initialEvidence.locusReadTotal, 50)

        var state = controller.testingDisplayState
        state.diagnosticAllelesOnly = true
        controller.testingApplyDisplayStateImmediately(state)
        let filteredEvidence = try XCTUnwrap(controller.testingCurrentCallEvidence)
        XCTAssertEqual(filteredEvidence.animalGenotypes.map(\.genotype), [diagnostic])
        XCTAssertEqual(filteredEvidence.observedGenotypes, [diagnostic])
        XCTAssertEqual(filteredEvidence.locusReadTotal, initialEvidence.locusReadTotal)
        XCTAssertEqual(filteredEvidence.sampleAssignedGenotypeReads, initialEvidence.sampleAssignedGenotypeReads)
        XCTAssertEqual(filteredEvidence.callName, initialEvidence.callName)

        state.summaryViewMode = .matrix
        controller.testingApplyDisplayStateImmediately(state)
        XCTAssertEqual(controller.testingVisibleMatrixGenotypes, [diagnostic])
        state.summaryViewMode = .outline
        controller.testingApplyDisplayStateImmediately(state)
        controller.testingSelectCellEvidence(animalId: "animal", locus: "MHC-DQ")
        XCTAssertEqual(controller.testingCurrentCallEvidence?.animalGenotypes.map(\.genotype), [diagnostic])

        state.diagnosticAllelesOnly = false
        controller.testingApplyDisplayStateImmediately(state)
        XCTAssertEqual(controller.testingCurrentCallEvidence?.animalGenotypes.count, 2)
        XCTAssertEqual(controller.testingCurrentCallEvidence?.locusReadTotal, 50)
    }
    func testRecordedCompleteReferenceRestoresAllDiagnosticsAfterProjectMoveWithoutRecalling() throws {
        let root = try TestTempDirectory.make(prefix: "CompleteDiagnosticReference")
        defer { TestTempDirectory.cleanup(root) }
        let project = root.appendingPathComponent("Copied.lungfish", isDirectory: true)
        let bundleURL = project.appendingPathComponent("Analyses/Amplicon genotyping results/result.lungfishgenotype", isDirectory: true)
        let reference = project.appendingPathComponent("Reference allele databases/Complete.lungfishmhcref", isDirectory: true)
        try FileManager.default.createDirectory(at: bundleURL, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: reference, withIntermediateDirectories: true)
        let ids = (1...218).map { String(format: "MCM_MHC_MiSeq_%04d", $0) }
        let diagnosticIDs = Array(ids.prefix(64))
        let definition = GenotypeHaplotypeDefinitionSet(id: "complete-custom", assayID: "MHC-exon2-miSeq",
            displayName: "Complete reference", speciesName: "Macaque", speciesCode: "Mafa", prefix: "",
            locusDefinitions: [.init(locus: "MHC-A", sourceLocus: "MHC-A", haplotypes: [
                .init(name: "M1A", diagnosticAlleles: diagnosticIDs)
            ])])
        try JSONEncoder().encode(definition).write(to: reference.appendingPathComponent("definition.json"))
        try MHCAmpliconReferenceBundle.writeManifest(.init(name: "Complete", referenceFastaPath: "reference.fasta",
            haplotypeDefinitionPaths: ["definition.json"], defaultHaplotypeDefinitionID: definition.id,
            metrics: .init(referenceCount: 218, haplotypeDefinitionCount: 1), createdAt: "2026-09-09T00:00:00Z"), to: reference)
        let observedIDs = Array(ids.prefix(41)) + Array(ids.dropFirst(64).prefix(77))
        let calls = observedIDs.map { id in
            makeCall(sample: "animal", genotype: id + "|source_loci=MHC-A1|haplotype_groups=MHC-A|alleles=Mafa-A1_01", reads: 10)
        }
        let sample = ONTGenotypeSampleResult(sample: "animal", passedAlignments: 1180, passedUniqueReads: 1180,
            sampleTotalReads: 1180, sampleUniqueRetainedPercent: 100, calls: calls)
        let analysis = GenotypeHaplotypeAnalysis(assayID: definition.assayID, definitionSetID: definition.id,
            definitionSetName: definition.displayName, speciesName: definition.speciesName, samples: [
                .init(sample: "animal", calls: [.init(locus: "MHC-A", sourceLocus: "MHC-A", haplotype1: "M1A",
                    haplotype2: "-", status: .called,
                    matchedHaplotypes: [.init(name: "M1A", diagnosticAlleles: Array(diagnosticIDs.prefix(26)),
                                              observedDiagnosticAlleles: Array(diagnosticIDs.prefix(26)))],
                    observedGenotypeCount: calls.count, observedGenotypes: calls.map(\.genotype))])
            ])
        let result = makeResult(bundleURL: bundleURL, samples: [sample], calls: calls, haplotypeAnalysis: analysis)
        let recordedPath = "/Volumes/Unavailable/Original.lungfish/Reference allele databases/Complete.lungfishmhcref"
        try JSONSerialization.data(withJSONObject: ["argv": ["lungfish-cli", "fastq", "genotype-cohort", "--reference", recordedPath]])
            .write(to: bundleURL.appendingPathComponent(result.manifest.provenancePath))
        let recovered = try XCTUnwrap(GenotypeHaplotypeAnalysisResolver.recordedReferenceDefinition(
            for: result, definitionSetID: definition.id, assayID: definition.assayID))
        XCTAssertEqual(recovered.locusDefinitions.flatMap(\.haplotypes).flatMap(\.diagnosticAlleles).count, 64)
        XCTAssertNil(GenotypeHaplotypeAnalysisResolver.recordedReferenceDefinition(
            for: result, definitionSetID: "different-definition", assayID: definition.assayID))
        let controller = GenotypeResultViewController()
        _ = controller.view
        controller.configure(result: result)
        controller.testingSelectCellEvidence(animalId: "animal", locus: "MHC-A")
        let initial = try XCTUnwrap(controller.testingCurrentCallEvidence)
        XCTAssertEqual(initial.animalGenotypes.count, 118)
        var state = controller.testingDisplayState
        state.diagnosticAllelesOnly = true
        state.summaryViewMode = .matrix
        controller.testingApplyDisplayStateImmediately(state)
        XCTAssertEqual(controller.testingVisibleMatrixGenotypes.count, 41)
        state.summaryViewMode = .outline
        controller.testingApplyDisplayStateImmediately(state)
        controller.testingSelectCellEvidence(animalId: "animal", locus: "MHC-A")
        let filtered = try XCTUnwrap(controller.testingCurrentCallEvidence)
        XCTAssertEqual(filtered.animalGenotypes.count, 41)
        XCTAssertEqual(filtered.callName, initial.callName)
        XCTAssertEqual(filtered.locusReadTotal, initial.locusReadTotal)
    }

    func testCompleteReferenceDiagnosticCountsInOptInRealBundle() throws {
        guard let path = ProcessInfo.processInfo.environment["LUNGFISH_COMPLETE_MHC_RESULT"] else {
            throw XCTSkip("Set LUNGFISH_COMPLETE_MHC_RESULT to the complete 118-row validation result.")
        }
        let result = try ONTGenotypeResultBundle.loadResult(from: URL(fileURLWithPath: path))
        let analysis = try XCTUnwrap(result.haplotypeAnalysis)
        let definition = try XCTUnwrap(GenotypeHaplotypeAnalysisResolver.recordedReferenceDefinition(
            for: result, definitionSetID: analysis.definitionSetID, assayID: analysis.assayID))
        let diagnosticIDs = Set(definition.locusDefinitions.flatMap(\.haplotypes).flatMap(\.diagnosticAlleles))
        XCTAssertEqual(diagnosticIDs.count, 64)
        let index = GenotypeAlleleHaplotypeEvidenceIndex(calls: result.calls, definitionSet: definition, effectiveCalls: [])
        let positive = result.calls.filter { $0.passedUniqueReads > 0 }
        XCTAssertEqual(Set(positive.map(\.genotype)).count, 118)
        XCTAssertEqual(Set(positive.filter { index.isDiagnostic(locus: $0.locusGroup, genotype: $0.genotype) }.map(\.genotype)).count, 41)
    }

}
