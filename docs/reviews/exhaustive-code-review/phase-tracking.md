# Phase Implementation Tracker — Updated 2026-03-22

## Summary
- **Phases 1-3**: COMPLETE — bug fixes, tests, macOS 26 compliance, shared abstractions
- **Phases 4+6**: COMPLETE (partial) — scientific accuracy, CLI commands, annotation types
- **Phase 4 file splitting**: DEFERRED — requires careful manual extraction
- **Phases 5, 7, 8**: DEFERRED to next session

## Commits
1. `bc2dd1b` Phase 1: Bug fixes, 214 new tests, logging foundation
2. `96e838d` Phase 2: 57 runModal→beginSheetModal, concurrency fixes
3. `c41b7b2` Phase 3: SemanticColors, ChromosomeAliasResolver, LungfishError, sync readers
4. `731c046` Phases 4+6: Codon tables 4-6, annotation types, CLI commands
5. `9fb3267` Fix translate command flag collision

## Test Results
- Baseline: 3,615 tests
- Current: ~3,850+ tests
- 0 unexpected failures throughout all phases

## Completed Work

### Phase 1: Critical Bug Fixes & Safety Net Tests — COMPLETE
- [x] Yeast mito codon table ATA=Met
- [x] BED toAnnotation() chromosome field
- [x] Sequence.subsequence() try! fix
- [x] NSApp.activate() deprecated fix
- [x] WelcomeView version from bundle
- [x] 214 new safety-net tests (ReferenceFrame, RowPacker, FormatRegistry, PluginRegistry, GenomicRegion, Bgzip, FileType)
- [x] LogSubsystem constants, 100+ Logger standardized, debugLog/NSLog replaced

### Phase 2: macOS 26 API Compliance — COMPLETE
- [x] All 57 runModal() calls migrated to beginSheetModal
- [x] All DispatchQueue.main.async wrapped with MainActor.assumeIsolated
- [x] GenomicDocument Sendable conformance removed
- [x] objc_setAssociatedObject reduced to 1 legitimate use

### Phase 3: Shared Abstractions — COMPLETE
- [x] SemanticColors: centralized DNA base + status colors
- [x] ChromosomeAliasResolver: unified 7-strategy aliasing (51 tests)
- [x] LungfishError protocol: user-facing + technical descriptions
- [x] FASTAReader.readAllSync() + GenBankReader.readAllSync()
- [x] DocumentType → DocumentCategory rename

### Phases 4+6: Scientific Accuracy & CLI — COMPLETE (partial)
- [x] Genetic code tables 4 (Mold Mito), 5 (Invertebrate Mito), 6 (Ciliate)
- [x] Annotation types: tRNA, rRNA, pseudogene, mobileElement
- [x] Multi-allelic variant classification fix
- [x] GFF3 multi-parent attribute handling
- [x] CLI: `lungfish translate` (6-frame translation)
- [x] CLI: `lungfish search` (pattern search with BED output)
- [x] CLI: `lungfish extract` (region-based subsequence)
- [ ] ViewerViewController giant file splitting (deferred — 10.6K line multi-class file requires manual extraction)

## Remaining Work (Next Session)

### Phase 5: SwiftUI Migration & HIG
- [ ] BarcodeScoutSheet → SwiftUI
- [ ] FASTQImportConfigSheet → SwiftUI
- [ ] OperationsPanelController → SwiftUI
- [ ] FASTQ chart views → SwiftUI Charts
- [ ] ObservableObject → @Observable (13 classes)
- [ ] HIG fixes (Go to Gene shortcut, keyboard shortcuts, VoiceOver, etc.)

### Phase 7: Format Handling & Performance
- [ ] Streaming FASTA parser
- [ ] GTF format support
- [ ] Bgzipped VCF support
- [ ] VCFVariant type consolidation
- [ ] SequenceAnnotation bounding region caching

### Phase 8: Architecture & Polish
- [ ] LungfishApp module split (App, Datasets, GenomeBrowser)
- [ ] ViewerViewController file splitting
- [ ] Dependency injection for ViewerViewController
- [ ] Inspector contextual sections
- [ ] Menu bar reorganization
