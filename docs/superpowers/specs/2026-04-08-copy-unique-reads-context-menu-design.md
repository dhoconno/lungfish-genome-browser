# Copy Unique Reads Context Menu + Classifier Extract CLI Design

**Date:** 2026-04-08
**Status:** Approved, ready for implementation plan
**Branch:** `feature/batch-aggregated-classifier-views`

## Goal

When one or more rows are selected in any classifier result table (EsViritu, TaxTriage, Kraken2, NAO-MGS, NVD), a right-click context menu offers:

- **Copy Unique Reads as FASTA** — union-deduplicated reads mapped/assigned to all selected rows, serialized as FASTA, written to the system clipboard.
- **Copy Unique Reads as FASTQ** — same, but FASTQ (when quality scores are available).

Both actions are backed by a new `--by-classifier` strategy in `lungfish extract reads` so the exact same operation is reproducible from the CLI for debugging. The GUI stamps the reproducible CLI command onto the `OperationCenter` log via `OperationCenter.buildCLICommand`.

As part of the same change, fix a regression in EsViritu's "Extract FASTQ…" action-bar button: bundles created when the result was loaded from disk land in `.lungfish/.tmp/` instead of the project root, so they never appear in the sidebar.

## Non-Goals

- No change to the existing `ClassifierExtractionSheet` wizard (which writes a bundle and still exists alongside the new quick-copy items).
- No new viewport; this is a surgical addition to the existing taxonomy/virus/organism/BLAST-hit tables.
- Kraken2 gets the menu items but its "Unique Reads" concept is borrowed from the `cladeReads` count. No new column.

## Motivation

Users routinely need a handful of reads for ad-hoc downstream work: sanity-check BLAST, paste into a multiple alignment, drop into a one-off script. The current path requires either the full extract-to-bundle wizard (heavyweight, persists in project tree) or the CLI by hand (requires knowing the classifier's on-disk layout). NAO-MGS already has a "Copy Unique Reads as FASTQ" single-row menu item, proving the ergonomic win; this design generalizes that pattern across all five classifier views and adds multi-row selection support everywhere.

The CLI-driven architecture (everything routes through `ClassifierReadResolver` with a matching `lungfish extract reads --by-classifier` surface) makes both paths testable and keeps GUI and CLI in lockstep.

## Architecture

Three layers, bottom-up.

### 1. Workflow layer — `ClassifierReadResolver`

New files in `Sources/LungfishWorkflow/Extraction/`:

- `ClassifierReadResolver.swift` — `public actor` that resolves a tool + row selection into an `ExtractionResult` by dispatching to the appropriate existing `ReadExtractionService` strategy.
- `ClassifierRowSelector.swift` — `public struct ClassifierRowSelector: Sendable` value type + `public enum ClassifierTool`.

```swift
public enum ClassifierTool: String, Sendable, CaseIterable {
    case esviritu, taxtriage, kraken2, naomgs, nvd
}

public struct ClassifierRowSelector: Sendable {
    public var sampleId: String?          // optional for single-sample results
    public var taxIds: [Int]              // kraken2, naomgs
    public var accessions: [String]       // esviritu, taxtriage, nvd
    public var organism: String?          // taxtriage fallback when taxId unknown
}

public actor ClassifierReadResolver {
    public init(toolRunner: NativeToolRunner = .shared)

    public func resolveAndExtract(
        tool: ClassifierTool,
        resultPath: URL,
        selections: [ClassifierRowSelector],
        outputDirectory: URL,
        outputBaseName: String,
        progress: (@Sendable (Double, String) -> Void)? = nil
    ) async throws -> ExtractionResult
}
```

Per-tool resolution:

| Tool | Strategy | Regions / IDs |
|---|---|---|
| EsViritu | `extractByBAMRegion` per sample BAM | accessions from selectors; group by `sampleId`, one invocation per sample, concat outputs |
| TaxTriage | `extractByBAMRegion` per sample BAM | accessions resolved from organism→accessions lookup (reuses `TaxTriageDatabase` queries), group by sample |
| Kraken2 | `TaxonomyExtractionPipeline.extract` | `taxIds` from selectors, `includeChildren: true`, sources = classified FASTQ from result directory |
| NAO-MGS | `extractFromDatabase` | DB query with taxIds / accessions, optional `sampleId` |
| NVD | `extractByBAMRegion` per sample BAM | `accessions` = contig names (which are BAM `@SQ` references), group by sample |

Dedup across multiple selected rows happens naturally because each underlying strategy operates on a set: `samtools view -F 1024` on the union of regions, `seqkit grep -f` on the union of IDs, SQL `DISTINCT` on the union of filters.

The resolver owns the per-sample grouping logic, delegates to `ReadExtractionService`, and concatenates per-sample outputs via the same merge helper already in `ReadExtractionService` (`convertBAMToFASTQSingleFile` was just introduced in the sibling commit on this branch).

When a selector has `sampleId == nil` (single-sample result, classic EsViritu), the resolver groups under a synthetic key and uses the single top-level BAM from the result directory (via the tool's existing convention: `<result>/<sample>.sorted.bam` for EsViritu, `<result>/bam/<sample>.bam` for TaxTriage, etc.). The GUI path always supplies a `sampleId` — it's available from the row in every classifier view — so the `nil` branch is primarily for CLI convenience when the user has one sample.

### 2. CLI layer — `--by-classifier` strategy

Modified file: `Sources/LungfishCLI/Commands/ExtractReadsCommand.swift`.

Adds a 4th flag alongside `--by-id`, `--by-region`, `--by-db`:

```
lungfish extract reads --by-classifier \
    --tool {esviritu|taxtriage|kraken2|naomgs|nvd} \
    --result <path-to-result-directory-or-db> \
    [--sample <sample-id>]...            # required for batch results; repeatable
    [--taxon <taxid>]...                 # repeatable; kraken2, naomgs
    [--accession <acc>]...               # repeatable; esviritu, taxtriage, nvd
    [--organism <name>]...               # taxtriage fallback
    [--format {fastq|fasta}]             # default fastq
    -o <output-file>
```

Selectors are assembled by pairing `--sample X` with the subsequent `--accession`/`--taxon`/`--organism` flags until the next `--sample` boundary (or from the start if no sample is specified in single-sample results). This gives `testParse_byClassifier_perSampleSelection` the behavior it needs.

Validation matrix extends the existing `func validate()`:

- Exactly one of `--by-id`, `--by-region`, `--by-db`, `--by-classifier` (existing mutual-exclusion extended).
- `--by-classifier` requires `--tool` and `--result`.
- `--tool esviritu` requires at least one `--accession`.
- `--tool taxtriage` requires at least one of `--accession`, `--taxon`, `--organism`.
- `--tool kraken2` requires at least one `--taxon`.
- `--tool naomgs` requires at least one `--taxon` or `--accession`.
- `--tool nvd` requires at least one `--accession`.
- `--format` defaults to `fastq`; `fasta` triggers an in-CLI FASTQ→FASTA conversion after resolver completes.

### 3. GUI layer — `TaxonomyReadClipboardAction`

New file: `Sources/LungfishApp/Views/Metagenomics/TaxonomyReadClipboardAction.swift`.

```swift
@MainActor
public final class TaxonomyReadClipboardAction {
    public static let shared = TaxonomyReadClipboardAction()

    /// Soft cap: more than this many reads triggers the size-guard dialog.
    public static let clipboardReadCap = 10_000

    public enum CopyFormat { case fasta, fastq }

    public func copy(
        tool: ClassifierTool,
        resultPath: URL,
        selections: [ClassifierRowSelector],
        estimatedReadCount: Int,
        format: CopyFormat,
        hostWindow: NSWindow?
    )

    // Test seams — injectable for unit tests
    var alertPresenter: AlertPresenting = DefaultAlertPresenter()
    var savePanelPresenter: SavePanelPresenting = DefaultSavePanelPresenter()
    var pasteboard: PasteboardWriting = DefaultPasteboard()
}
```

The three test-seam protocols (`AlertPresenting`, `SavePanelPresenting`, `PasteboardWriting`) and their default implementations live in the same file as `TaxonomyReadClipboardAction`. `AlertPresenting.present(_:on:) async -> NSApplication.ModalResponse` wraps `NSAlert.beginSheetModal(for:)` behind an async interface; the default implementation uses `withCheckedContinuation`. `SavePanelPresenting.present(suggestedName:on:) async -> URL?` wraps `NSSavePanel.beginSheetModal`. `PasteboardWriting.setString(_:)` wraps `NSPasteboard.general.setString(_:forType: .string)`. Tests inject mocks that capture inputs and return scripted responses without hitting AppKit.

The class owns:

- Size-guard dialog (10 000-read threshold, "Copy First N / Save to File… / Cancel").
- Temp directory management via `ProjectTempDirectory.create(prefix: "lungfish-copy-reads-", in: projectRoot)`, `defer`-cleaned on task completion or cancellation.
- `OperationCenter` wiring: `start` with `cliCommand` from `OperationCenter.buildCLICommand`, progress updates, `complete` / `fail` terminal states.
- FASTQ → FASTA conversion using `FASTQReader` streaming.
- Pasteboard write via `NSPasteboard.general.setString(_:forType:)`.
- Save-panel fallback for oversized results or closed host windows.
- Downloads-folder fallback for window-closed-mid-extraction.

Each classifier view controller gains:

1. Two menu items in its existing context menu (or a "Copy Unique Reads" submenu if the existing menu is crowded).
2. A glue method that builds `[ClassifierRowSelector]` from the selected rows and calls `TaxonomyReadClipboardAction.shared.copy(...)`.
3. `validateMenuItem` logic: enabled iff selection is non-empty and the tool's data source is available (BAM present for BAM-backed tools, DB present for DB-backed tools).

## Data Flow

```
User right-clicks in a classifier table with N rows selected
        │
        ▼
menuNeedsUpdate rebuilds menu with current selection context
        │
        ▼
"Copy Unique Reads as FASTQ (≈ Σ uniqueReads)" item enabled
        │
        ▼
Click → VC-level handler builds [ClassifierRowSelector]
        │
        ▼
Pre-flight size check: sum of uniqueReads across selected rows
  > 10 000? → NSAlert beginSheetModal:
                Buttons: [Copy First 10,000] [Save to File…] [Cancel]
  ≤ 10 000? → proceed
        │
        ▼
TaxonomyReadClipboardAction.shared.copy(...)
        │
        ▼
OperationCenter.start(
    title: "Copy Unique Reads — <Tool>",
    cliCommand: "lungfish extract reads --by-classifier --tool <x> --result <path>
                 --sample A --accession X --sample B --accession Y --format fastq -o <tmp>"
)
        │
        ▼
Task.detached:
  ClassifierReadResolver.resolveAndExtract(tool:resultPath:selections:...)
    Groups selections by sampleId
    Per group: dispatches appropriate ReadExtractionService strategy
    Concatenates per-sample outputs (BAM-backed tools)
    Reports progress through @Sendable callback
        │
        ▼
DispatchQueue.main.async { MainActor.assumeIsolated {
  Read FASTQ back via FASTQReader, cap at clipboardReadCap
  Convert to FASTA if format == .fasta
  NSPasteboard.general.setString(serialized, forType: .string)
  OperationCenter.complete(detail: "Copied N reads (M KB)")
  Clean up temp directory via defer
}}
```

Cancellation: `OperationCenter.setCancelCallback` wires to `task.cancel()`. The resolver's per-sample loop calls `Task.checkCancellation()`. The `defer` on the temp-dir removal fires on cancel too.

## Edge Cases

| Situation | Behavior |
|---|---|
| Mixed assembly + contig rows selected (EsViritu) | Assemblies expand to constituent contig accessions; union all per sample. |
| Rows from samples whose BAM is missing from the lookup | Skip with warning logged to Operation row. If all rows skipped → fail with "No BAM files available for the selected rows — EsViritu must be run with --keep True." |
| Kraken2 row at "root" or "unclassified" with millions of descendant reads | Pre-flight catches via `cladeReads` sum; size-guard dialog fires. |
| Empty selection at right-click time | Menu items disabled via `validateMenuItem`. |
| Batch multi-sample selection | One strategy dispatch per sample, outputs concatenated. Progress: `(samplesProcessed / totalSamples, "Extracting sample X…")`. |
| `samtools` missing or unusable | `ExtractionError.samtoolsFailed` bubbles up; NSAlert via `beginSheetModal` (not `runModal`, per macOS 26 rules). |
| Kraken2 `classified.fastq` missing | Fail with actionable message: "Kraken2 result is missing classified.fastq — rerun with default output settings." |
| Project directory not writable | `ProjectTempDirectory.create` throws; same alert path. |
| Task cancellation | `setCancelCallback → task.cancel()`, `Task.checkCancellation()` in resolver loop, `defer` cleans temp. |
| Zero reads extracted despite non-zero pre-flight estimate | Non-blocking "No reads extracted" alert; pasteboard untouched. |
| FASTQ post-cap still > ~100 MB | Auto-falls through to save-panel branch with explanatory message. |
| Host window closed mid-extraction | Fallback: write to `~/Downloads/lungfish-copied-reads-<timestamp>.fastq`, post user notification. |

Explicitly **not** handled (per user correction during brainstorm):

- NAO-MGS zero-unique-reads row — cannot exist by NAO-MGS invariant.
- NVD row whose sample FASTA has no BAM path recorded — corrupted import, surfaces as hard error rather than graceful skip.

## Bundle-Extract Regression Fix

Included in the same change set because it lives in the same file and involves the same `projectURL` plumbing.

**Root cause:** `EsVirituResultViewController.presentExtractionSheet` at line 1252:

```swift
let projectURL: URL? = self.esVirituConfig.flatMap {
    ProjectTempDirectory.findProjectRoot($0.outputDirectory)
}
```

`esVirituConfig` is populated only when the result was computed in the current session. Results loaded from disk via `configureFromDatabase(_:resultURL:)` leave `esVirituConfig` nil. The subsequent fallback `let bundleDir = projectURL ?? tempDir` then writes bundles to a `.lungfish/.tmp/` directory where the sidebar reload at line 1315 cannot find them.

**Fix:**

```swift
let projectURL: URL? = self.esVirituConfig
    .flatMap { ProjectTempDirectory.findProjectRoot($0.outputDirectory) }
    ?? self.batchURL.flatMap { ProjectTempDirectory.findProjectRoot($0) }
```

`batchURL` is already set by `configureFromDatabase` to the `resultURL` argument.

**Secondary fix — context-menu accession mismatch:** the newly-added (this branch) `onExtractReadsRequested` / `onExtractAssemblyReadsRequested` callbacks call `presentExtractionSheet` without passing the right-clicked row's accessions; the method re-reads `detectionTableView.selectedAssemblyAccessions()`, which is stale if the right-click didn't extend the selection. Fix: change the signature to `presentExtractionSheet(items:source:suggestedName:accessions:)`; each caller supplies accessions directly (context-menu callers pass the row's accessions, action-bar caller passes `selectedAssemblyAccessions()`).

## File Layout

### New source files (3)

```
Sources/LungfishWorkflow/Extraction/ClassifierReadResolver.swift
Sources/LungfishWorkflow/Extraction/ClassifierRowSelector.swift
Sources/LungfishApp/Views/Metagenomics/TaxonomyReadClipboardAction.swift
```

### New test files (6)

```
Tests/LungfishWorkflowTests/Extraction/ClassifierReadResolverTests.swift
Tests/LungfishCLITests/ExtractReadsByClassifierCLITests.swift
Tests/LungfishAppTests/EsVirituBundleExtractRegressionTests.swift
Tests/LungfishAppTests/TaxonomyReadClipboardActionTests.swift
Tests/LungfishAppTests/ClassifierContextMenuTests.swift
Tests/LungfishAppTests/ClassifierCLIRoundTripTests.swift
```

### Modified files (7)

```
Sources/LungfishCLI/Commands/ExtractReadsCommand.swift
  + --by-classifier flag and option group
  + validate() matrix extension
  + runByClassifier() strategy function
  + strategyLabel / strategyParameters new cases

Sources/LungfishApp/Views/Metagenomics/EsVirituResultViewController.swift
  FIX  presentExtractionSheet — projectURL fallback via batchURL
  FIX  presentExtractionSheet signature takes accessions parameter
  ADD  context-menu wiring to TaxonomyReadClipboardAction

Sources/LungfishApp/Views/Metagenomics/ViralDetectionTableView.swift
  ADD  "Copy Unique Reads as FASTA/FASTQ" menu items in buildContextMenu
  ADD  validateMenuItem cases
  ADD  contextCopyUniqueReadsFASTA / contextCopyUniqueReadsFASTQ handlers
  ADD  onCopyUniqueReadsRequested callback signature

Sources/LungfishApp/Views/Metagenomics/TaxonomyTableView.swift        (Kraken2)
  ADD  menu items, validation, callback

Sources/LungfishApp/Views/Metagenomics/TaxTriageResultViewController.swift
  ADD  menu items in setupContextMenu on TaxTriageOrganismTableView
  ADD  handler on VC using bamFilesBySample lookup

Sources/LungfishApp/Views/Metagenomics/NaoMgsResultViewController.swift
  EDIT populateContextMenu — replace existing "Copy Unique Reads as FASTQ" with
       unified helper (keeps label, gains multi-row support)
  ADD  FASTA counterpart

Sources/LungfishApp/Views/Metagenomics/NvdResultViewController.swift
  ADD  menu items in populateContextMenu for multi-row support
```

## Testing Strategy

Layered: workflow tests own correctness, CLI tests own parsing, GUI tests own the clipboard flow, round-trip tests lock CLI/GUI equivalence.

### ClassifierReadResolverTests (workflow layer)

- `testResolve_esviritu_singleSample_singleAssembly` — sarscov2 BAM fixture, one accession; output dedup count matches `samtools view -c -F 1024`.
- `testResolve_esviritu_singleSample_multipleAssemblies_unionDedup` — overlapping accession sets; assert union (no double-counts).
- `testResolve_esviritu_multiSample_batch` — two per-sample BAMs, one accession each; output concatenates both.
- `testResolve_esviritu_missingBAMForSample_skipsWithWarning` — two selectors, one sample missing from lookup; warning logged, output contains only available sample.
- `testResolve_esviritu_allBAMsMissing_throwsActionable` — specific error type assertion.
- `testResolve_taxtriage_organismToAccessions_viaDB` — fixture SQLite with `organism_to_accessions`; resolver maps correctly.
- `testResolve_taxtriage_taxIdFallback` — organism name miss, taxId hit.
- `testResolve_kraken2_includeChildren` — minimal Kraken2 output, species + subspecies reads; returns all.
- `testResolve_kraken2_noIncludeChildren` — same fixture, direct-only.
- `testResolve_naomgs_database` — in-memory NAO-MGS SQLite; dedup assertion.
- `testResolve_naomgs_multipleRowsUnion` — shared read across two taxIds emitted once.
- `testResolve_nvd_contigAsRegion` — BAM whose references are contig names; resolver maps contig → region.
- `testResolve_nvd_unknownContig_throws` — contig not in BAM header.
- `testResolve_nvd_missingBAMPath_throwsHardError` — corrupted import surfaces cleanly.
- `testResolve_cancellation_cleansTempDir` — mid-extraction cancel; no partial FASTQ left.

### FASTA conversion helpers

- `testFASTQToFASTA_convertsRecordsCorrectly` — golden file comparison.
- `testFASTQToFASTA_handlesWrappedQualityLines` — multi-line records.

### EsVirituBundleExtractRegressionTests

- `testPresentExtractionSheet_loadedFromDisk_writesBundleToProjectRoot` — VC constructed via `configureFromDatabase`; invoke extract sheet's onExtract directly; assert bundle under project root, not `.lungfish/.tmp/`.
- `testPresentExtractionSheet_useAccessionsFromCaller_notStaleSelection` — right-click without selecting; caller-supplied accessions drive extraction.

Both fail against branch-tip before the fix lands.

### ExtractReadsByClassifierCLITests

- `testParse_byClassifier_esviritu_requiresAccession`
- `testParse_byClassifier_kraken2_requiresTaxon`
- `testParse_byClassifier_naomgs_acceptsMixedTaxonAndAccession`
- `testParse_byClassifier_multipleStrategiesFails`
- `testParse_byClassifier_perSampleSelection` — `--sample A --accession X --sample B --accession Y` produces two distinct selectors.
- `testRun_byClassifier_esviritu_endToEnd` — full run against sarscov2, read count matches.
- `testRun_byClassifier_kraken2_endToEnd`
- `testRun_byClassifier_format_fasta` — FASTA output, record count matches.

All use `GlobalOptions.parse([])` per the project convention — no direct `GlobalOptions()` construction.

### TaxonomyReadClipboardActionTests

Test seams: `AlertPresenting`, `SavePanelPresenting`, `PasteboardWriting` protocols injected into the singleton for the test lifetime.

- `testCopy_belowCap_writesPasteboardAndReportsSuccess`
- `testCopy_aboveCap_presentsSizeGuardAlert`
- `testCopy_sizeGuard_copyFirstN_capsOutput`
- `testCopy_sizeGuard_saveToFile_writesAndSkipsPasteboard`
- `testCopy_sizeGuard_cancel_noPasteboardMutation` — prior content preserved.
- `testCopy_extractionFailure_preservesPriorPasteboard`
- `testCopy_zeroReadsExtracted_showsInfoAlertSkipsPasteboard`
- `testCopy_windowClosedMidExtraction_fallsBackToDownloadsFolder`
- `testCopy_operationCenterLogsExactCLIString` — logged cliCommand round-trips cleanly through `ExtractReadsSubcommand.parse`.
- `testCopy_cancellation_abortsExtractionAndCleansTempDir`

### ClassifierContextMenuTests

One test per classifier view controller — construct with fixture, select N rows, update menu, assert:

- Two new items present.
- `isEnabled` matches "selection + data source available" rule.
- Invocation fires `onCopyUniqueReadsRequested` with correctly-built `[ClassifierRowSelector]`.

Five tests total (EsViritu, TaxTriage, Kraken2, NAO-MGS, NVD).

### CLIRoundTripTests

```swift
func testEveryGUICopy_producesMatchingCLICommand()
```

Parametrized over all 5 tools. For each:

1. Construct a selection against a fixture result.
2. Run `TaxonomyReadClipboardAction` with an in-memory `OperationCenter` recorder.
3. Grab the logged `cliCommand` string.
4. Parse it via `ExtractReadsSubcommand.parse(...)` and `run()` against the same fixture.
5. Assert the two resulting FASTQs are record-set-identical after sorting by read ID.

This is the anti-regression harness for CLI/GUI equivalence. Any divergence in selector construction or CLI argument building fails loudly.

### Fixture additions

Minimal per-tool fixtures under `Tests/Fixtures/classifier-results/`:

- `esviritu/` — SQLite DB + one BAM+BAI, 10 reads across 2 accessions.
- `taxtriage/` — SQLite with organism_to_accessions + BAM, 5 organisms.
- `kraken2/` — classified.fastq + kraken2_output.txt + minimal taxonomy, 8 reads across 3 taxa.
- `naomgs/` — in-memory-constructible SQLite with 5 hits.
- `nvd/` — SQLite + BAM whose references are contig names, 4 contigs.

Each < 100 KB. Tests complete in < 100 ms apiece with no network.

**Total new tests: ~34.**

## Open Questions

None — all clarifications resolved during brainstorm.

## References

- Existing CLI command: `Sources/LungfishCLI/Commands/ExtractReadsCommand.swift`
- Existing extraction service: `Sources/LungfishWorkflow/Extraction/ReadExtractionService.swift`
- Existing Kraken2 extraction pipeline: `Sources/LungfishWorkflow/Metagenomics/TaxonomyExtractionPipeline.swift`
- Existing NAO-MGS "Copy Unique Reads" single-row reference implementation: `Sources/LungfishApp/Views/Metagenomics/NaoMgsResultViewController.swift:1979`
- `OperationCenter.buildCLICommand` for stamping reproducible commands.
- `ProjectTempDirectory.create(prefix:in:)` for temp directory management.
- macOS 26 API rules in MEMORY.md: `beginSheetModal` not `runModal`, GCD main queue dispatch pattern for background callbacks.
- Viewport interface classes: `docs/design/viewport-interface-classes.md` — this change extends the Taxonomy Browser viewport uniformly.
