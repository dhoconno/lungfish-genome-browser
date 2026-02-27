# Code Review Report: Bundle Load UX + Variant Reliability

Date: 2026-02-27  
Branch baseline: `8a26b0c` (checkpoint commit before this review/fix pass)

## Scope

Reviewed and fixed:

1. Missing visual feedback when selecting large `.lungfishref` bundles.
2. Missing variants in some regions (example: `GZMB`) despite variant data being expected.
3. Performance risks on bundle open that block the main thread.

## Primary Findings

### P0: Main-thread work during bundle open can stall UI feedback

- `SequenceViewerView.setReferenceBundle` built variant chromosome aliases synchronously and could execute expensive `chromosomeMaxPositions()` scans on large variant DBs.
- This happens in the same user interaction path as bundle selection, so the app can appear unresponsive during load.

### P0: Variant lookup used a single chromosome alias candidate

- `fetchVariantsAsync` and `fetchGenotypesAsync` used one resolved chromosome string for all tracks.
- If that alias was absent or incorrect for a given track/database, region queries returned zero variants/genotypes for that region.
- This created false "No variants in this region" states for valid regions.

### P1: Viewport sync could over-trust variant DB chromosome names

- Drawer coordinate sync preferred `variantChromosome` over reference chromosome labels.
- Combined with single-candidate resolution, this could amplify alias mismatches.

## Adversarial Review and Consensus

Roles used in review:

- Performance reviewer: remove expensive work from the selection critical path.
- Variant correctness reviewer: never trust one chromosome translation; use candidate fallback.
- UI reliability reviewer: ensure immediate visual acknowledgment of user selection.

Debate outcomes:

- Full async bundle-open refactor was rejected for this pass due higher surface area and risk.
- Consensus fix: keep current control flow but force immediate visual feedback, move expensive alias inference off main, and make variant/genotype queries resilient via multi-candidate chromosome resolution.

## Implemented Changes

### 1) Immediate visual load feedback on bundle selection

- `MainSplitViewController.displayReferenceBundle` now shows shared `activityIndicator` before starting heavy bundle display work and defers execution to the next runloop tick.
- `ViewerViewController+BundleDisplay.displayBundle` now flushes layout/display immediately after `showProgress("Loading genome…")`.

### 2) Removed expensive alias inference from main-thread critical path

- Added a fast alias path during bundle set (`includeMaxPositionFallback: false`), using name/alias/contig-length matching only.
- Added asynchronous background warmup for expensive alias inference (`includeMaxPositionFallback: true`) and merge-back to live state when ready.

### 3) Robust multi-candidate chromosome resolution for variants/genotypes

- Added shared helpers:
  - `canonicalVariantChromosomeLookupKey`
  - `resolveVariantChromosomeCandidates`
- Updated `fetchVariantsAsync` and `fetchGenotypesAsync` to resolve ordered candidates per track and query until a matching candidate returns records.
- Added per-track chromosome set cache (`variantTrackChromosomeMap`) for efficient candidate selection.
- Variant annotations are normalized to the active reference chromosome namespace for rendering consistency.

### 4) Drawer sync hardening

- Drawer coordinate sync now uses reference chromosome labels as the canonical coordinate source.
- Drawer query context now reuses the shared chromosome-candidate resolver.

### 5) Minor safety fix

- `displayBundle` now hides progress if no chromosomes are available before early return.

## Tests Added

New test file:

- `Tests/LungfishAppTests/VariantChromosomeResolutionTests.swift`

Coverage:

- exact match precedence
- alias-based fallback
- `chr` prefix canonical fallback
- accession version stripping fallback
- reverse alias lookup
- unknown chromosome-set fallback behavior

## Validation Run

Executed:

- `swift test --filter VariantChromosomeResolutionTests`
- `swift test --filter AlignmentChromosomeAliasingTests`

Result: all selected tests passed.

