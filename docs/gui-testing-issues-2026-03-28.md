# Lungfish GUI Testing Report - 2026-03-28

**Project**: VSP2
**FASTQ Dataset**: School001-20260216_S132_L008 (16.35M reads, 1.79 Gb)
**Classifiers Tested**: EsViritu (completed 4m37s), Kraken2/Bracken (DB detection bug prevented run), TaxTriage (completed 9.6m, 27 organisms)
**Expert Assessment**: Immunology/clinical microbiology review completed
**GUI Test Suite**: 21 regression tests created (Tests/LungfishAppTests/GUIRegressionTests.swift)
**Branch**: metagenomics-workflows

---

## 1. SIDEBAR / FILE BROWSER ISSUES

### 1.1 [AESTHETIC/UX] Pervasive text truncation in sidebar
- **Severity**: Medium
- **Location**: Left sidebar file browser
- **Description**: Nearly all text in the sidebar is truncated with ellipsis:
  - Search placeholder: "Search project c..." (truncated)
  - FASTQ filename: "School001-20260..." (truncated)
  - Child items: "Viral Detection (1..." (truncated)
- **Expected**: File names should show meaningful portions. At minimum, the search placeholder should fully read "Search project contents" or similar.
- **Bioinformatics perspective**: Researchers often have similarly-named samples (School001, School002...) — seeing only the prefix makes it impossible to distinguish samples without hovering/clicking.

### 1.2 [UX] Sidebar width too narrow by default
- **Severity**: Medium
- **Description**: The default sidebar width (~160px) is too narrow for typical genomic filenames which tend to be long (instrument_date_flowcell_lane patterns). The sidebar should default to at least 220-250px.

### 1.3 [UX] No tooltip on hover for truncated sidebar items
- **Severity**: Low
- **Description**: When hovering over truncated filenames in the sidebar, there should be a tooltip showing the full name. Currently, the full path only appears as an overlay when clicking certain items.

---

## 2. FASTQ OPERATIONS PANEL ISSUES

### 2.1 [AESTHETIC/UX] Severe text truncation in operations list
- **Severity**: High
- **Location**: FASTQ Operations panel (left column when FASTQ file selected)
- **Description**: Nearly EVERY operation name is truncated:
  - "Compute Qu..." (Compute Quality?)
  - "Subsample..." (appears twice — identical labels, no way to distinguish)
  - "Adapter Re..." (Adapter Removal?)
  - "Fixed Trim (..."
  - "PCR Primer..."
  - "Filter by Rea..." (Filter by Read?)
  - "Contaminant..."
  - "Human Read..."
  - "Remove Dup..."
  - "Filter by Seq..."
  - "Error Correc..."
  - "Demultiplex..."
  - "Merge Overl..."
  - "Repair Paire..."
  - "Find by ID/D..."
  - "Find by Seq..."
- **Expected**: Operation names should be fully readable. Either widen the operations column, use a different layout (e.g., grid with icons and full names below), or use a two-line cell layout.
- **Bioinformatics perspective**: A researcher new to the tool cannot tell what most operations do without clicking each one. "Subsample..." appearing twice with no distinguishing info is especially confusing — are these different subsampling methods?

### 2.2 [UX] Two "Subsample..." entries are visually identical
- **Severity**: Medium
- **Description**: Under SAMPLING, there are two entries both showing "Subsample..." with different icons (clock and hash). Without visible full names, users cannot distinguish between subsample-by-count and subsample-by-fraction (or whatever the difference is).

### 2.3 [UX] Operations panel requires excessive scrolling
- **Severity**: Medium
- **Description**: The operations panel lists ~18+ operations in a single scrollable column. Categories visible: REPORTS, SAMPLING, TRIMMING, FILTERING, CORRECTION, PREPROCESSING, DEMULTIPLEXING, REFORMATTING, SEARCH. Users must scroll extensively to find what they need. Classification tools (Kraken2, EsViritu, TaxTriage) are NOT in this panel at all — they're under Tools > Classify & Profile Reads, which is discoverable but breaks the mental model of "all FASTQ operations in one place."
- **Bioinformatics perspective**: Researchers expect classification to be alongside other FASTQ operations. Having to go to a separate menu is unexpected.

### 2.4 [FUNCTIONAL] No classification operations in the FASTQ Operations panel
- **Severity**: High
- **Description**: The FASTQ Operations panel does not include classification tools. Classifiers are only accessible via Tools > Classify & Profile Reads (Cmd+Shift+K). A bioinformatician would naturally look in the operations panel first since it contains all other FASTQ operations.
- **Recommendation**: Add a CLASSIFICATION section to the operations panel, or at minimum add a prominent "Classify Reads..." button/link that opens the wizard.

---

## 3. METAGENOMICS WIZARD ISSUES

### 3.1 [UX] Wizard shows "step_3_lengthFilter.fastq.gz" instead of user-friendly name
- **Severity**: Medium
- **Location**: Wizard title bar (top right)
- **Description**: The wizard header shows the internal derivative filename "step_3_lengthFilter.fastq.gz" rather than the original sample name or a human-readable label. This is confusing for users who may not know what "step_3" refers to.
- **Expected**: Show the original sample name (e.g., "School001-20260216_S132_L008") or the bundle display name.

### 3.2 [AESTHETIC] Kraken2 "Run" button appears red/destructive when disabled
- **Severity**: Low
- **Location**: Kraken2 configuration wizard
- **Description**: When no database is installed, the Run button appears with a red/orange tint, which in macOS conventions signals a destructive action. A disabled/grayed state would be more appropriate.

### 3.3 [UX] No guidance on how to install Kraken2 database
- **Severity**: Medium
- **Description**: The wizard shows "No databases installed" and a "Download Database..." button, but doesn't explain what a Kraken2 database is, how large it is, or how long the download will take. First-time users need context.
- **Bioinformatics perspective**: Kraken2 databases range from 8GB (standard) to 70GB+ (complete). Users need to know the size before downloading.

---

## 4. VIRAL DETECTION RESULTS VIEW ISSUES

### 4.1 [AESTHETIC/UX] Pervasive virus name truncation in results table
- **Severity**: High
- **Location**: Viral Detection results — Virus Name column (right table)
- **Description**: All virus names are truncated:
  - "Human mastadenovirus..." → should show "Human mastadenovirus F"
  - "Human alphaherpesviru..."
  - "Human herpesvirus 4 ty..."
  - "Merkel cell polyomaviru..."
  - "Influenza C virus (C/Ann..."
  - 7x "Influenza C virus (C/A..." — ALL IDENTICAL, impossible to distinguish strains
  - "Human respiratory sync..."
- **Bioinformatics perspective**: This is the most critical issue. Virus strain differentiation is essential for clinical and epidemiological decisions. When all Influenza C virus entries show the same truncated text, a clinical microbiologist cannot identify which strain was detected without clicking each one individually.

### 4.2 [AESTHETIC/UX] Bar chart species labels truncated
- **Severity**: High
- **Location**: Detected Viruses Overview bar chart (left side)
- **Description**: All species labels in the horizontal bar chart are truncated:
  - "s__Simplexvirus..."
  - "s__Lymphocryp..."
  - "s__Alphapolyo..."
  - "s__Gammainflu..."
  - "s__Orthopneum..."
  - "s__Tobamovirus..."
  - etc.
- **Expected**: Either make the label area wider, use horizontal scrolling, or show labels on hover.

### 4.3 [UX] "Top Virus" header stat is truncated
- **Severity**: Medium
- **Location**: Header statistics bar
- **Description**: The "Top Virus" stat shows "n mastadeno..." (or "an mastadenovi") — truncated. This is the primary summary stat and should show the full name or use a tooltip.

### 4.4 [UX] Duplicate "Result Summary" heading in Inspector
- **Severity**: Low
- **Location**: Right inspector panel when viewing Viral Detection results
- **Description**: The inspector shows "Result Summary" as both the section title and as bold body text directly below — appears duplicated.

### 4.5 [UX] Path tooltip overlay on Detected Viruses Overview
- **Severity**: Low
- **Location**: Bar chart area
- **Description**: A file path tooltip ("/Volumes/nvd_remote/VSP2/VSP2.lungfish/School001-20260216_S132_L008/2.lungfishfastq/esviritu-186BDC58") appears overlaid on the bar chart. This appears to be a debug/development artifact or an unintended tooltip trigger.

### 4.6 [UX] Identical Influenza C virus children — no strain differentiation
- **Severity**: Critical
- **Location**: Virus Name tree view
- **Description**: Under "Influenza C virus (C/Ann..." there are 7 child entries all showing "Influenza C virus (C/A..." — completely indistinguishable. They use slightly different shades of green/yellow dots but no text differentiation.
- **Expected**: Show the full strain designation for each (e.g., "C/Ann Arbor/1/50", "C/Johannesburg/66") or at minimum show accession numbers.
- **Bioinformatics perspective**: This defeats the purpose of strain-level identification. A researcher cannot determine which strains were detected without clicking each entry individually.

---

## 5. OPERATIONS PANEL / PROGRESS TRACKING ISSUES

### 5.1 [UX] No inline progress indicator when classification is running
- **Severity**: Medium
- **Location**: Main viewport
- **Description**: When EsViritu is launched, the wizard closes and the user returns to the FASTQ view with no visible indication that a job is running. The only way to see progress is via Operations > menu bar or by opening the Operations Panel (Cmd+Opt+P).
- **Expected**: Show a progress banner or spinner in the main viewport area, or at minimum a status bar indicator.

### 5.2 [UX] Operations Panel table has a truncated column
- **Severity**: Low
- **Location**: Operations Panel (bottom drawer)
- **Description**: The Operations Panel table has columns Type, Operation, Progress, Elapsed, and what appears to be another column that is cut off by the edge. This column likely shows a Cancel/Action button.

### 5.3 [AESTHETIC] Operations Panel overlaps with FASTQ Operations list
- **Severity**: Low
- **Description**: When the Operations Panel drawer is open, the FASTQ Operations list on the left is still visible but partially hidden. The two "operations" concepts (FASTQ operations panel vs. Operations progress panel) could be confusing to users.

---

## 6. GENERAL WINDOW / LAYOUT ISSUES

### 6.1 [AESTHETIC] Window title bar shows generic "Lungfish Genome Explorer"
- **Severity**: Low
- **Description**: The window title always shows "Lungfish Genome Explorer" regardless of the open project. It should show the project name (e.g., "VSP2 — Lungfish Genome Explorer").

### 6.2 [UX] "Click to Compute" charts lack context
- **Severity**: Low
- **Location**: Top area — Q/Position and Q Score Dist. charts
- **Description**: Two chart placeholders show "Click to Compute" but don't explain what will be computed or why a user would want to. Brief descriptions (e.g., "Per-base quality distribution") would help.

### 6.3 [UX] "1.0 bp/px" in status bar when no sequence loaded
- **Severity**: Low
- **Location**: Bottom status bar (initial FASTQ view before selecting a file)
- **Description**: Shows "1.0 bp/px" even when no sequence is loaded. This metric is meaningless without a loaded sequence.

---

## 7. DOCUMENT INSPECTOR ISSUES

### 7.1 [UX] Inspector "Add Annotation from Sel..." button text truncated
- **Severity**: Low
- **Location**: Inspector > Selection section
- **Description**: Button reads "Add Annotation from Sel..." — truncated. Should show full text or use an icon + shorter label.

### 7.2 [UX] Inspector shows genomic controls for FASTQ dataset
- **Severity**: Medium
- **Description**: When viewing a FASTQ dataset, the inspector shows genomic-oriented controls (Sequence Style, Track Height, Annotation Style, Show Annotations toggle) that are not relevant to FASTQ data. The inspector should be context-aware and show FASTQ-specific options (e.g., quality filter thresholds, display mode).

---

## 8. TAXTRIAGE WIZARD / EXECUTION ISSUES

### 8.1 [UX] Nextflow process overlay obscures bar chart
- **Severity**: Medium
- **Location**: Bar chart area during TaxTriage execution
- **Description**: When TaxTriage (Nextflow) is running, process status messages like "[1c/e42799] Submitted process > NFCORE_TAXTRIAGE:TA..." are displayed as a semi-transparent overlay on top of the bar chart. This obscures the chart content. A loading spinner also appears.
- **Expected**: Progress should be shown in a dedicated area (bottom bar, operations panel, or sidebar badge) rather than overlaying the data visualization.

### 8.2 [UX] TaxTriage wizard shows "Kraken2 Database: Viral" but no explanation
- **Severity**: Low
- **Description**: The TaxTriage wizard has a "Kraken2 Database" dropdown set to "Viral" but doesn't explain why this is needed or what alternatives exist. First-time users may not understand the relationship between TaxTriage and Kraken2.

### 8.3 [UX] "Clinical Sample" dropdown not explained
- **Severity**: Low
- **Location**: TaxTriage wizard > Samples section
- **Description**: Each sample has a "Clinical Sample" dropdown but there's no label or explanation of what this affects or what the alternatives are.

### 8.4 [GOOD] TaxTriage wizard has good prerequisite visibility
- **Note**: The TaxTriage wizard shows green checkmarks for "Nextflow" and "Apple Containerization: Available" — this is a well-designed pattern that gives users confidence before running.

---

## 9. WINDOW SIZE / RESPONSIVENESS ISSUES

### 9.1 [FUNCTIONAL] Severe layout degradation at default/small window sizes
- **Severity**: High
- **Description**: At default window size (~830px wide), the app suffers from pervasive text truncation across ALL panels (sidebar, operations, virus list, bar chart labels, family names). When the window is expanded to ~1200px+, most text becomes readable. The app needs a minimum window width enforcement or responsive layout that adapts to narrower windows (e.g., collapsing columns, using tooltips, or wrapping text).
- **Bioinformatics perspective**: Genomic data inherently has long identifiers. The app MUST accommodate these at default window sizes.

### 9.2 [AESTHETIC] Family column truncated in virus list
- **Severity**: Medium
- **Location**: Virus Name table, Family column (visible at wider window)
- **Description**: Family names are truncated even at moderate window widths: "f__Orthoherpesvi...", "f__Polymavirida...", "f__Orthomyxoviri...", "f__Pneumoviridae...". These are standard taxonomic family names that should be fully visible.

### 9.3 [GOOD] Wider window shows much better layout
- **Note**: At wider window sizes (fullscreen/near-fullscreen), the layout works well: bar chart labels show full species names, virus names are fully readable, family column is mostly visible. The app should target this as the minimum usable width.

---

## 10. OPERATIONS PANEL ISSUES (Additional)

### 10.1 [FUNCTIONAL] Operations Panel difficult to dismiss
- **Severity**: Medium
- **Description**: After opening the Operations Panel (via menu or Cmd+Opt+P), it's difficult to close. The traffic light buttons (red/yellow/green) on the panel don't dismiss it. The keyboard shortcut Cmd+Opt+P doesn't toggle it closed. The panel persists even after clearing completed operations, leaving an empty table header row taking up valuable viewport space.

### 10.2 [UX] Operations Panel covers virus list when open
- **Severity**: Medium
- **Description**: The Operations Panel bottom drawer covers the virus name table (right side of the viewport) when open. Users cannot see both the progress of a running operation AND the virus detection results simultaneously.

### 10.3 [UX] Completed operation status "125 viruses detected in 20 families" is informative
- **Note**: When EsViritu completes, the operations panel shows "125 viruses detected in 20 families" which is a useful summary. This is good design.

---

## 11. POST-COMPLETION BEHAVIOR

### 11.1 [UX] EsViritu results auto-display is good but sidebar doesn't update
- **Severity**: Medium
- **Description**: When EsViritu completes, the viewport automatically switches to show the Detected Viruses Overview. However, the sidebar doesn't update to show the new Viral Detection child node under the FASTQ bundle — the bundle appears collapsed with no indication that results are ready.
- **Expected**: The sidebar should either auto-expand to show the new result node, or show a badge/indicator on the FASTQ file.

### 11.2 [UX] No notification when TaxTriage (long-running) completes
- **Severity**: Medium (estimated — not yet verified)
- **Description**: TaxTriage takes 20-45 min. If the user navigates away or switches to another app, there should be a system notification (macOS banner) when the job completes.

---

## 12. KRAKEN2 DATABASE DETECTION BUG (CONFIRMED)

### 12.1 [FUNCTIONAL/BLOCKER] Kraken2 wizard does not detect installed databases
- **Severity**: Critical
- **Location**: ClassificationWizardSheet.swift / MetagenomicsDatabaseRegistry
- **Description**: The Kraken2 wizard shows "No databases installed" even though the Viral Kraken2 database (512 MB, "RefSeq viral genomes only") IS installed and visible in the Plugin Manager's Databases tab with a green "Installed" checkmark. The TaxTriage wizard correctly detects and uses the same "Viral" database in its dropdown. This is a disconnect between the Plugin Manager's database registry and the Kraken2 wizard's database query.
- **Impact**: Complete blocker for the most widely-used classifier in clinical metagenomics. A biologist who installs the database through Plugin Manager and sees "No databases installed" in the wizard will assume the software is broken.
- **Root cause**: CONFIRMED — `UnifiedMetagenomicsWizard.swift` (line ~345) instantiates `ClassificationWizardSheet` **without passing the `installedDatabases` parameter**, which defaults to `[]`. The TaxTriage wizard works because `TaxTriageWizardSheet` loads databases itself via `onAppear` → `checkPrerequisites()` → `MetagenomicsDatabaseRegistry.shared.availableDatabases()`. The Kraken2 wizard has no such loading logic — it expects databases to be passed in, but the caller never passes them.
- **Fix**: Add `@State private var installedDatabases` and an `onAppear` handler to `ClassificationWizardSheet` that loads from `MetagenomicsDatabaseRegistry.shared`, matching TaxTriageWizardSheet's pattern. See `TaxTriageWizardSheet.swift` lines 40, 459-466 for the working pattern.

---

## 13. BIOLOGICAL EXPERT ASSESSMENT — MISSING DATA FIELDS

### 13.1 [FUNCTIONAL] EsViritu results missing genome coverage percentage
- **Severity**: Critical
- **Description**: The EsViritu results show read counts but no genome coverage percentage. 2203 reads hitting Human mastadenovirus F is meaningless without knowing what fraction of the ~35 kb genome is covered. 2203 reads covering 3% suggests contamination; 2203 covering 85% suggests true infection. This is the single most important missing metric.
- **Note**: Coverage data IS computed by EsViritu but may not be displayed prominently in the results table.

### 13.2 [FUNCTIONAL] Missing RPM normalization
- **Severity**: High
- **Description**: Reads per million (RPM) is the universal normalization metric in metagenomics. Raw read counts are uninterpretable across samples of different depths. 2203 reads / 16.35M total = 134.7 RPM — this should be computed and displayed as a column.

### 13.3 [FUNCTIONAL] Missing NCBI Taxonomy ID (taxid)
- **Severity**: High
- **Description**: No taxonomy ID is displayed. Taxids are essential for cross-referencing with any database and for programmatic downstream analysis. Every metagenomics tool uses taxids internally.

### 13.4 [FUNCTIONAL] Missing accession numbers in results table
- **Severity**: High
- **Description**: Biologists think in accession numbers (NC_001454.1). The results table shows organism names but not the reference accession the reads mapped to.

### 13.5 [UX] TASS score has no interpretation guide
- **Severity**: High
- **Location**: TaxTriage results table
- **Description**: TASS scores (0.710-1.000) have no legend, threshold line, or tooltip explaining what they mean. A biologist unfamiliar with TASS cannot determine if 0.740 means "probably real" or "probably artifact." The colored bars help but cutoff values for green/yellow/red are not stated.

### 13.6 [UX] Bar chart uses s__ prefix notation
- **Severity**: Medium
- **Description**: Species labels use GTDB-style prefix notation (s__Simplexvirus..., s__Lymphocryp...) which is an internal bioinformatics convention. Biologists expect common clinical names (HSV-1, EBV, CMV) or full binomial names.

### 13.7 [UX] PCR duplicate rate buried in status bar
- **Severity**: Medium
- **Description**: "832 unique, 1371 PCR dups hidden" (62% duplicate rate) is excellent QC info but buried in the status bar. This should be a visible badge or column — high duplicate rates flag library quality concerns.

### 13.8 [FUNCTIONAL] Missing per-segment coverage for segmented viruses
- **Severity**: Medium
- **Description**: Influenza and other segmented viruses need per-segment coverage breakdown. "25% coverage" of a segmented virus could mean 2 of 8 segments fully covered, which is significant for surveillance.

---

## 14. MISSING CROSS-PIPELINE FEATURES

### 14.1 [FUNCTIONAL] No cross-pipeline concordance view
- **Severity**: High
- **Description**: Three classifiers produce three independent result sets but there is no unified view showing which organisms were detected by which pipeline(s). Clinical labs make calls based on concordance: an organism detected by all three pipelines is high confidence; detected by only one needs manual review. A Venn diagram or concordance matrix should be a primary navigation element.

### 14.2 [FUNCTIONAL] No co-infection pattern recognition
- **Severity**: Medium
- **Description**: Multiple virus co-detection (RSV + Influenza C + Adenovirus F) is clinically significant. The tool should flag potential co-infections and immunosuppression patterns (multiple polyomaviruses + CMV suggests immunocompromise).

---

## 15. MISSING EXPORT / INTEROP CAPABILITIES

### 15.1 [FUNCTIONAL] No TSV/CSV export with complete data
- **Severity**: Critical
- **Description**: The "Export" button exists but biologists need tabular export with complete, untruncated organism names, accession numbers, taxids, RPM, coverage, and all metrics. Must be importable via a single `read.csv()` in R or `pd.read_csv()` in Python.

### 15.2 [FUNCTIONAL] No BIOM format export
- **Severity**: High
- **Description**: BIOM (Biological Observation Matrix) is THE standard exchange format for metagenomics. Consumed by QIIME2, phyloseq, microViz. Without it, results are siloed.

### 15.3 [FUNCTIONAL] No per-organism read extraction
- **Severity**: High
- **Description**: Right-click should offer "Extract reads mapping to this organism" → FASTQ output for downstream assembly, phylogenetics, or validation. This is a fundamental metagenomics workflow.

### 15.4 [FUNCTIONAL] No Krona HTML export
- **Severity**: Medium
- **Description**: Krona interactive HTML plots are the standard way metagenomics results are visualized in publications. Should either integrate KronaTools or export in a format Krona can consume.

### 15.5 [FUNCTIONAL] No consensus FASTA export
- **Severity**: Medium
- **Description**: For each detected organism, export consensus/assembled sequences for phylogenetics (MEGA, Geneious, BLAST).

### 15.6 [FUNCTIONAL] No BAM per-organism export
- **Severity**: Medium
- **Description**: Export aligned reads per organism as BAM for manual inspection in IGV or Geneious.

### 15.7 [UX] Right-click context menu far too limited
- **Severity**: High
- **Description**: Only "Verify with BLAST..." and "Copy Organism Name" are available. Missing: Copy Accession/TaxID, Open in NCBI Taxonomy Browser, Extract reads, View coverage plot, Add to report, Mark as contaminant, Compare across samples.

---

## 16. QC AND CONTEXT GAPS

### 16.1 [FUNCTIONAL] No QC summary dashboard before classification results
- **Severity**: Medium
- **Description**: Before viewing classification results, biologists need: total/microbial/human read fractions, quality scores, adapter contamination rate, duplication rate, GC content. Without this, results are uninterpretable. (Note: some QC stats are shown in the FASTQ view but not carried into the results context.)

### 16.2 [UX] No sample metadata association
- **Severity**: Medium
- **Description**: Clinical metagenomics requires sample type (CSF, BAL, plasma, stool), collection date. Interpretation depends on context — Merkel cell polyomavirus in skin is expected; in CSF is alarming.

### 16.3 [UX] No contaminant / kitome flagging
- **Severity**: Medium
- **Description**: Laboratory and reagent contamination is the major source of false positives. Common contaminants (e.g., Merkel cell polyomavirus from certain cell lines) should be flaggable.

---

## TESTING STATUS

| Classifier | Status | Notes |
|-----------|--------|-------|
| Kraken2/Bracken | BLOCKED — database bug | Viral DB installed but wizard doesn't detect it (see 12.1) |
| EsViritu | Completed (4m 37s) | 106 assemblies, 20 families, 87 species detected |
| TaxTriage | Completed (9.6m) | 27 organisms, 13 high confidence, TASS scoring working |

---

## PRIORITY SUMMARY

### Critical (4)
- **12.1**: Kraken2 wizard does not detect installed databases (BLOCKER)
- **4.6**: Identical Influenza C virus children — no strain differentiation
- **13.1**: EsViritu results missing genome coverage percentage
- **15.1**: No TSV/CSV export with complete, untruncated data

### High (11)
- **2.1**: Severe text truncation in operations list
- **2.4**: No classification operations in FASTQ Operations panel
- **4.1**: Pervasive virus name truncation in results table
- **4.2**: Bar chart species labels truncated
- **9.1**: Severe layout degradation at default/small window sizes
- **13.2**: Missing RPM normalization column
- **13.3**: Missing NCBI Taxonomy ID (taxid)
- **13.4**: Missing accession numbers in results table
- **13.5**: TASS score has no interpretation guide
- **14.1**: No cross-pipeline concordance view
- **15.2**: No BIOM format export
- **15.3**: No per-organism read extraction (FASTQ)
- **15.7**: Right-click context menu far too limited

### Medium (21)
- **1.1**: Pervasive text truncation in sidebar
- **1.2**: Sidebar width too narrow by default
- **2.2**: Two "Subsample..." entries visually identical
- **2.3**: Operations panel requires excessive scrolling
- **3.1**: Wizard shows internal derivative filename
- **3.3**: No guidance on Kraken2 database size before download
- **4.3**: "Top Virus" header stat truncated
- **5.1**: No inline progress indicator during classification
- **7.2**: Inspector shows genomic controls for FASTQ dataset
- **8.1**: Nextflow process overlay obscures bar chart
- **9.2**: Family column truncated in virus list
- **10.1**: Operations Panel difficult to dismiss
- **10.2**: Operations Panel covers virus list when open
- **11.1**: Sidebar doesn't update after EsViritu completion
- **11.2**: No system notification for long-running TaxTriage
- **13.6**: Bar chart uses s__ prefix notation (not biologist-friendly)
- **13.7**: PCR duplicate rate buried in status bar
- **13.8**: Missing per-segment coverage for segmented viruses
- **14.2**: No co-infection pattern recognition
- **15.4**: No Krona HTML export
- **15.5**: No consensus FASTA export
- **15.6**: No BAM per-organism export
- **16.1**: No QC summary dashboard before classification results
- **16.2**: No sample metadata association
- **16.3**: No contaminant / kitome flagging

### Low (12)
- **1.3**: No tooltip on hover for truncated sidebar items
- **3.2**: Run button appears red/destructive when disabled
- **4.4**: Duplicate "Result Summary" heading in inspector
- **4.5**: Path tooltip overlay on bar chart
- **5.2**: Operations Panel table has truncated column
- **5.3**: Operations Panel naming confusion with FASTQ Operations
- **6.1**: Generic window title (doesn't show project name)
- **6.2**: "Click to Compute" charts lack context descriptions
- **6.3**: "1.0 bp/px" shown in status bar when no sequence loaded
- **7.1**: Inspector "Add Annotation from Sel..." button text truncated
- **8.2**: TaxTriage Kraken2 Database dropdown unexplained
- **8.3**: "Clinical Sample" dropdown purpose not labeled

### Positive Design Observations
- **8.4**: TaxTriage prerequisite checkmarks are well-designed
- **9.3**: App layout works well at wider/fullscreen window sizes
- **10.3**: Completed operation summary text is informative
- Unified Metagenomics Wizard is intuitive and well-organized
- Three-tier analysis type selection maps well to researcher needs
- EsViritu pipeline stages are clearly communicated
- TaxTriage TASS scoring with colored confidence bars is a strong feature
- Alignment view with PCR duplicate tracking shows sophisticated engineering

---

## GUI REGRESSION TEST SUITE

**File**: `Tests/LungfishAppTests/GUIRegressionTests.swift`
**Tests**: 21 tests across 9 test classes
**All passing**: Yes (verified 2026-03-28)

| Test Class | Tests | What It Guards |
|-----------|-------|----------------|
| VirusNameDisplayTests | 3 | Strain names are distinguishable, not truncated in storage |
| ContextMenuCompletenessTests | 2 | Documents expected context menu items |
| ClassificationWizardDatabaseTests | 2 | Database detection works for installed DBs |
| TaxTriageResultsDisplayTests | 3 | Column formatting, expected columns |
| EsVirituHierarchyTests | 2 | Strain disambiguation, bar chart label length |
| ExportFeatureTests | 2 | Documents expected export formats |
| UnifiedWizardTests | 3 | All analysis types present with metadata |
| OperationsPanelTests | 2 | Operation type enum, status values |
| SidebarDisplayTests | 2 | Result node labels are differentiable |
