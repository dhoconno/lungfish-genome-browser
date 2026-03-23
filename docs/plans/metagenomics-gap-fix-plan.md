# Metagenomics Gap Fix Plan — 2026-03-23

## Test Dataset
`/Users/dho/Desktop/test3.lungfish/01-WW-2-23-26_S57_L007.lungfishfastq`
Expected: human reads, viral reads, other organisms (wastewater sample)

## Phase Plan (10 phases, sequential, autonomous)

### Phase G1: Fix CondaManager pipe deadlock + blocking (Gaps 4, 5, 14)
- Replace `process.waitUntilExit()` + post-read with concurrent pipe reading
- Use `terminationHandler` + `CheckedContinuation` pattern
- Implement timeout enforcement
- Fix same pattern in `MetagenomicsDatabaseRegistry.extractTarball`
- Fix download delegate double-completion (Gap 16)
- **Tests**: Verify runTool works with large output, verify timeout fires

### Phase G2: Fix bundle URL resolution + wizard goal (Gaps 3, 11)
- Resolve `.lungfishfastq` bundle to actual FASTQ file inside
- Wire wizard goal selector to pipeline (classify vs profile)
- **Tests**: Bundle URL resolution, goal→pipeline mapping

### Phase G3: Wire extraction callback + create virtual FASTQ (Gaps 1, 8)
- Wire `onExtractConfirmed` in `displayTaxonomyResult`
- Run `TaxonomyExtractionPipeline` on confirmation
- Create `.lungfishfastq` virtual bundle from extraction output
- Add extracted bundle to sidebar
- **Tests**: Extraction end-to-end with simulated data

### Phase G4: Database download UI (Gap 2)
- Add "Databases" tab to Plugin Manager (or separate sheet)
- Show built-in catalog with sizes, RAM requirements
- Download with progress bar
- Verify database after extraction
- **Tests**: Catalog listing, download simulation

### Phase G5: Paired-end extraction support (Gap 6)
- Change `sourceFile` to `sourceFiles: [URL]`
- Filter R1 and R2 separately maintaining pairing
- Produce paired output files
- **Tests**: Paired-end extraction with R1/R2

### Phase G6: Real-time progress + cancellation (Gaps 7, 12)
- Stream stderr from kraken2 process in real-time
- Parse progress lines ("X sequences processed")
- Add cancel button to progress UI
- Store Task handle for cancellation
- Propagate cancellation to terminate subprocess
- **Tests**: Progress callback frequency, cancellation behavior

### Phase G7: Persist classification results + reload (Gap 13)
- Save classification result metadata to output directory
- Re-load when user navigates back to classified item
- Show classification status in sidebar
- **Tests**: Save/load round-trip

### Phase G8: CLI database + extraction commands (Gaps 17, 18)
- `lungfish conda db list/download/remove/recommend`
- `lungfish conda extract --kraken-output X --source Y --taxid Z`
- **Tests**: CLI argument parsing, execution

### Phase G9: Export + provenance viewer (Gaps 9, 23)
- Add provenance disclosure group to TaxonomyViewController
- Add export menu: CSV, TSV, top-N species table
- Copy summary to clipboard
- **Tests**: Export format validation

### Phase G10: Polish (Gaps 15, 19, 21, 22, 24, 25)
- Download cancellation UI
- RAM warning in wizard
- Precompute tree statistics
- Fix bracken version detection
- Consolidate sunburst right-click menus
- Add BrackenParser tests
- **Tests**: All remaining gaps

## Success Criteria
- Full end-to-end: select FASTQ → classify → view sunburst → extract taxa → see virtual FASTQ
- All tests pass including new ones
- CLI commands work with simulated data
- No pipe deadlocks with real datasets
