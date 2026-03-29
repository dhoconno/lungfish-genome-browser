# GUI Fixes Master Plan — 2026-03-28

## Source: `docs/gui-testing-issues-2026-03-28.md` (48 issues)

## Approach: 6 Implementation Waves

Issues are grouped by module/file affinity to enable parallel execution within each wave.
Each wave's tasks are independently testable and committable.
Critical/High severity first, then Medium, then Low.

---

## WAVE 1: Critical Bugs & Blockers (4 issues)
**Priority**: MUST DO FIRST — blocks all other testing
**Parallel tracks**: 2 (no file collisions)

### Track 1A: Kraken2 Database Detection Bug [12.1]
- **Files**: `ClassificationWizardSheet.swift`, `UnifiedMetagenomicsWizard.swift`
- **Fix**: Add `@State private var installedDatabases` + `onAppear` loading from `MetagenomicsDatabaseRegistry.shared`, matching TaxTriageWizardSheet pattern
- **Tests**: Existing `ClassificationWizardTests.swift` + new test in `GUIRegressionTests.swift`
- **Expert team**: Swift/macOS, QA

### Track 1B: Strain Name Disambiguation [4.6]
- **Files**: `ViralDetectionTableView.swift`, `EsVirituResultViewController.swift`
- **Fix**: Show full strain name or accession-based suffix when siblings share prefix. Add tooltip on hover for truncated names.
- **Tests**: `GUIRegressionTests.swift` (VirusNameDisplayTests)
- **Expert team**: Bioinformatics, UX

---

## WAVE 2: Layout & Truncation Root Causes (8 issues)
**Priority**: HIGH — fixes ~15 downstream truncation issues
**Parallel tracks**: 3 (different UI areas)

### Track 2A: Window Minimum Width & Responsive Layout [9.1, 9.2]
- **Files**: `MainSplitViewController.swift`, `MainWindowController.swift` (or equivalent)
- **Fix**: Set minimum window width to ~1100px. Ensure virus name column and family column have adequate min widths.
- **Expert team**: macOS/AppKit, UX

### Track 2B: Operations Panel Text Truncation [2.1, 2.2, 2.3, 2.4]
- **Files**: `FASTQOperationsPanelView.swift` (or equivalent operations list)
- **Fix**: Widen operations column, use two-line cells, differentiate "Subsample..." entries, add CLASSIFICATION section with link to wizard
- **Expert team**: UX, SwiftUI

### Track 2C: Sidebar Width & Truncation [1.1, 1.2, 1.3]
- **Files**: `SidebarViewController.swift`, sidebar-related views
- **Fix**: Increase default sidebar width to 220px, add tooltips for truncated items, ensure search placeholder fits
- **Expert team**: AppKit, UX

---

## WAVE 3: Results Table Enhancements (11 issues)
**Priority**: HIGH — adds missing biological data fields
**Parallel tracks**: 3 (EsViritu, TaxTriage, shared)

### Track 3A: EsViritu Results Table — Missing Columns [13.1, 13.2, 13.3, 13.4, 4.1, 4.2]
- **Files**: `EsVirituResultViewController.swift`, `ViralDetectionTableView.swift`, bar chart view
- **Fix**: Add genome coverage %, RPM, taxid, accession columns to virus table. Fix bar chart labels (remove s__ prefix [13.6], show full names).
- **Data**: EsViritu already computes `coveredBases`, `meanCoverage`, `avgReadIdentity` in `ViralDetection` model — need to display them.
- **Expert team**: Bioinformatics, SwiftUI/AppKit

### Track 3B: TaxTriage Results Table — Missing Columns & TASS Legend [13.5, 4.3]
- **Files**: `TaxTriageResultViewController.swift`
- **Fix**: Add TASS score interpretation legend/tooltip (green >=0.95 high confidence, yellow 0.80-0.95 moderate, red <0.80 low). Ensure "Top Virus" stat and "Confidence" column headers not truncated.
- **Expert team**: Bioinformatics, UX

### Track 3C: Right-Click Context Menu Enhancement [15.7]
- **Files**: `EsVirituResultViewController.swift`, `TaxTriageResultViewController.swift`
- **Fix**: Add context menu items: Copy Accession, Copy TaxID, Copy Row as TSV, Extract Reads, Open in NCBI. Common menu builder shared between both views.
- **Expert team**: Swift/macOS, Bioinformatics

---

## WAVE 4: Export & Interop (5 issues)
**Priority**: HIGH — unblocks downstream analysis workflows
**Parallel tracks**: 2

### Track 4A: TSV/CSV Export with Complete Data [15.1]
- **Files**: New `MetagenomicsExporter.swift` (or extend existing exporter)
- **Fix**: Export all columns (organism, accession, taxid, reads, unique reads, RPM, coverage, TASS score, family) as TSV/CSV with untruncated names. Wire to Export button.
- **Expert team**: Swift, Bioinformatics

### Track 4B: BIOM Format Export [15.2]
- **Files**: New `BIOMExporter.swift`
- **Fix**: Export BIOM v2.1 JSON format for phyloseq/QIIME2 compatibility. Include taxonomy metadata and sample metadata.
- **Expert team**: Bioinformatics, Swift

---

## WAVE 5: UX Polish & Inspector Fixes (14 issues)
**Priority**: MEDIUM — improves user experience
**Parallel tracks**: 4

### Track 5A: Wizard UX Improvements [3.1, 3.2, 3.3, 8.2, 8.3]
- **Files**: `UnifiedMetagenomicsWizard.swift`, `ClassificationWizardSheet.swift`, `TaxTriageWizardSheet.swift`
- **Fix**: Show original sample name instead of derivative filename. Fix disabled Run button styling. Add database size guidance. Label "Clinical Sample" dropdown. Explain Kraken2 DB in TaxTriage.
- **Expert team**: UX, SwiftUI

### Track 5B: Operations Panel Behavior [5.1, 5.2, 5.3, 10.1, 10.2]
- **Files**: `OperationsPanelController.swift`, related panel views
- **Fix**: Add inline progress banner during classification. Fix panel dismiss behavior. Ensure panel doesn't cover results. Add keyboard toggle.
- **Expert team**: AppKit, UX

### Track 5C: Inspector & Window Fixes [4.4, 6.1, 6.2, 6.3, 7.1, 7.2]
- **Files**: Inspector section views, `MainWindowController.swift`, status bar views
- **Fix**: Remove duplicate "Result Summary" heading. Show project name in title. Add context descriptions to "Click to Compute" charts. Fix bp/px when no sequence. Truncated button text. Context-aware inspector.
- **Expert team**: AppKit, UX

### Track 5D: Post-Completion Behavior [8.1, 11.1, 11.2, 13.7]
- **Files**: `EsVirituResultViewController.swift`, `SidebarViewController.swift`, notification code
- **Fix**: Move Nextflow progress out of chart overlay. Auto-expand sidebar on completion. Add macOS notification for long-running jobs. Promote PCR dup rate to visible badge.
- **Expert team**: AppKit, UX

---

## WAVE 6: Advanced Features (10 issues — Future Sprint)
**Priority**: MEDIUM/LOW — valuable differentiators, not blocking
**Note**: These are larger features that may warrant their own project plans.

### Track 6A: Cross-Pipeline Concordance View [14.1]
- Design and implement Venn/matrix view comparing EsViritu, Kraken2, TaxTriage results
- Requires all three pipelines to have run on the same sample

### Track 6B: Additional Export Formats [15.3, 15.4, 15.5, 15.6]
- Per-organism FASTQ extraction, Krona HTML, consensus FASTA, BAM per-organism

### Track 6C: QC & Context Features [13.8, 14.2, 16.1, 16.2, 16.3]
- Per-segment coverage, co-infection recognition, QC dashboard, sample metadata, contaminant flagging

---

## Implementation Order

```
WAVE 1 (Critical Bugs)     ───── Track 1A + 1B in parallel
         │
WAVE 2 (Layout)            ───── Track 2A + 2B + 2C in parallel
         │
WAVE 3 (Results Tables)    ───── Track 3A + 3B + 3C in parallel
         │
WAVE 4 (Export)             ───── Track 4A + 4B in parallel
         │
WAVE 5 (UX Polish)         ───── Track 5A + 5B + 5C + 5D in parallel
         │
WAVE 6 (Advanced)          ───── Future sprint
```

## Expert Team Assignments

| Expert | Waves |
|--------|-------|
| Swift/macOS | 1A, 2A, 3C, 4A, 5B |
| Bioinformatics | 1B, 3A, 3B, 3C, 4A, 4B |
| UX Designer | 1B, 2A, 2B, 2C, 3B, 5A, 5B, 5C, 5D |
| AppKit/SwiftUI | 2A, 2B, 3A, 5B, 5C, 5D |
| QA/Testing | All waves (regression tests) |

## Success Criteria

- All 48 issues marked as resolved
- All 21 existing GUI regression tests still pass
- New regression tests added for each fix
- Build succeeds with zero errors
- Manual GUI testing confirms fixes via Claude Computer inspection
- Expert biological review confirms data fields are correct and useful
