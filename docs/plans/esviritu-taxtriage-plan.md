# EsViritu and TaxTriage Integration Plan

## Status: In Progress — Phase 1 (EsViritu Core)

## Summary

### EsViritu (HIGH FEASIBILITY — Conda)
- Read-mapping pipeline for virus detection from metagenomic samples
- Available on bioconda as `noarch` Python package — native arm64
- Dependencies: minimap2, samtools, fastp, seqkit, R (all arm64-ready)
- Database: ~400 MB curated viral database from Zenodo
- Output: TSV files (detection, assembly, taxonomy, coverage) + HTML report
- Runtime: 5-30 min per sample

### TaxTriage (MODERATE FEASIBILITY — Nextflow + Containers)
- End-to-end Nextflow pipeline from JHU APL
- Requires Nextflow + container runtime (Docker/Apple Containerization)
- Container images primarily linux/amd64 (needs Rosetta 2 emulation)
- Output: PDF reports, confidence metrics, Krona plots
- Runtime: 30 min to several hours

## Implementation Phases

### Phase 1: EsViritu Core Infrastructure
- Add esviritu to metagenomics plugin pack
- Database download from Zenodo
- Pipeline actor (CondaManager.runTool)
- Config and result structs

### Phase 2: EsViritu Parsers
- TSV parsers for detection, tax profile, coverage
- Value types (ViralDetection, ViralAssembly, etc.)
- Parser tests

### Phase 3: EsViritu CLI + UI
- CLI command
- Wizard sheet
- Detection table + sunburst adaptation
- Coverage sparklines

### Phase 4: TaxTriage Core
- Nextflow integration via NextflowRunner
- Samplesheet generation
- Config and result structs

### Phase 5: TaxTriage UI
- PDF viewer, confidence dashboard, Krona embed

### Phase 6: Cross-Tool Integration
- BLAST verification from EsViritu/TaxTriage results
- Multi-sample batch processing
- Result comparison view

## Key Files
See docs/plans/esviritu-taxtriage-plan.md for full detail.
