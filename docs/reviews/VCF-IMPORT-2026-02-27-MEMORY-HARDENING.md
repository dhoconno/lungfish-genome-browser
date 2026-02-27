# VCF Import Memory Hardening (2026-02-27)

## Context
Large VCF imports (for example `32068-marmoset.snps.vcf.gz`) can exceed memory limits during import/index phases. A recent failure mode produced a truncated SQLite DB that was later marked complete.

## Specialist review (adversarial)

### Database engineering view
- Risk: very large write bursts during ingest can accumulate dirty pages and trigger memory pressure.
- Recommendation: use adaptive transaction sizing and smaller commit windows under pressure.

### SQLite view
- Risk: index creation and token materialization in the same long-lived process can amplify heap fragmentation.
- Recommendation: split import into phases and run indexing in a fresh process for ultra-low-memory workloads.

### macOS memory management view
- Risk: resident set + unified buffer cache pressure can rise faster than static thresholds during sustained writes.
- Recommendation: probe RSS frequently and force commit/shrink earlier with profile-specific watermarks.

## Consensus solution implemented
1. **Adaptive ingest commits**
- Added adaptive write budget controls in `VariantDatabase.createFromVCF`.
- Write budget now shrinks aggressively under RSS pressure and relaxes when pressure drops.
- Memory probes now run at profile-specific intervals.

2. **Safer ultra-low-memory tuning defaults**
- Reduced ultra-low-memory `writeBudget` from 50k to 12k writes.
- Enabled shrink-on-every-commit for ultra-low-memory.
- Increased frequency of memory probes and earlier pressure threshold.
- Reduced connection reset interval to fight fragmentation on prolonged imports.

3. **Two-phase staged import (ultra-low-memory helper path)**
- Added `deferIndexBuild` to `createFromVCF`.
- Helper-mode imports now stage ultra-low-memory imports: insert phase first (`import_state=indexing`), then index build via resume helper in a fresh process.
- App flow now automatically launches phase-2 indexing when insert phase completes.

4. **Backwards compatibility + validation**
- Preserved old `createFromVCF` symbol via overload to avoid cross-module link breakage.
- Added regression test for deferred index build + resume path.

## Verification
- `swift test --filter VariantDatabaseTests/testUltraLowMemoryDeferredIndexBuildThenResume` ✅
- `swift test --filter VariantDatabaseTests/testResume` ✅
- `swift test --filter VariantDatabaseTests/testUltraLowMemoryProducesSameVariants` ✅

## Expected operational outcome
- Fewer OOM terminations during large VCF ingest.
- Lower risk of memory spikes by isolating index build into a separate process for large-profile imports.
- Maintained data correctness guarantees through explicit phase state handling and resume semantics.
