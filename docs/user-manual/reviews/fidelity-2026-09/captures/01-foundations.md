# Capture report: 01-foundations

25 shots from `01-foundations.md` worklist. Status per shot below.

## Captured

- **import-center-reference-card** — 1600x1064, window crop. Import Center window already open on the Reference Sequences tab with the card visible.
- **hbb-record-in-sequence-viewport** — 1600x1028, window crop. HBB reference bundle open in the sequence viewport with the annotation lane over the base ruler.
- **go-to-location-hbb-codon** — 1100x520, region crop of the Go to Location sheet holding `NG_000007:70613-70615`.
- **fastq-viewport-summary-cards** — 1600x1028, window crop. HG002 FASTQ bundle, nine summary cards above the three sparklines.
- **fastq-viewport-reads-tab** — 1600x1028, window crop. Reads tab of the same bundle.
- **bam-viewport-coverage-and-pileup** — 1600x1028, window crop. chr20_10.0-10.5Mb bundle zoomed to ~28bp around position 250,516 in Focus mode, Depth coverage above the stacked read pileup.
- **variants-tab-hg002-bcftools** — 1600x1028, window crop. chr20 bundle at full width, Variants tab open, genome track + table rows visible (bcftools rows, Filter = `.`).
- **variants-pass-chip-and-tokens** — 1564x200, region crop of the filter chip strip with PASS active (862 of 1,918) and Presets/tokens line.
- **inspector-variant-selected** — 664x680, region crop of the Inspector's Variant Detail block for one selected row.
- **sidebar-folder-conventions** — 1600x1028, window crop. Fresh main window sidebar showing Analyses above Imports, Phylogenetic Trees, Primer Schemes, Reference Sequences. **Gate note carried into the recipe**: the demo project's Analyses subfolders (HG002-chrM, kraken2-SRR36291587, mapping-HG002, nvd-demo) carry script-chosen names rather than the app's own `<tool>-<timestamp>` shape; not renamed for this capture.
- **plugin-manager-window** — 1600x1368, window crop. Packs tab scrolled to show the tail of Required Setup above Optional Tools, with the full Read Mapping card (minimap2, BWA-MEM2, Bowtie2).
- **plugin-manager-offline-commands** — 1540x120, region crop of the Read Mapping card's offline strip (two greyed commands + Copy button).
- **plugin-manager-installed-tab** — 1600x1368, window crop. Installed tab, bcftools row expanded to list 30 packages/versions, Check for Tool Updates... above.
- **plugin-manager-databases-tab** — 1600x1368, window crop. Databases tab scrolled to show installed rows (SILVA, Standard-16) beside Download rows, recommended banner at top, storage readout at foot.
- **inspector-provenance-section** — 1600x1028, window crop. chr20 bundle selected, Inspector Provenance section open (Run Summary, Lineage, Files & Outputs; no Warnings block since this run had none).
- **provenance-signing-settings** — 1600x429, region crop of Settings > General > Provenance Signing (Off selected, empty key fields, greyed Save/Clear buttons, "Provenance signing is off." status line). No real signing key in the fields, as required.

## Skipped (per worklist instructions)

- **primer-scheme-picker-built-in** — subject is an open pop-up menu (Primer Scheme popup in the primer-trim dialog). Opening it brings the app to the foreground and the background click tools cannot select an item inside it once open, so it was left for the full-screen-control pass. The primer-trim dialog itself (Primer Scheme "Choose a primer scheme" popup, Choose Scheme..., Alignment Track = HG002 minimap2) was reached and confirmed reachable from Tools > Trimming & Filtering > Primer Trimming... with the chr20_10.0-10.5Mb alignment track's own Inspector > Analysis > Primer Trim > "Primer-trim BAM..." button.
- **file-export-menu** (appears for both 06-the-lungfish-project.md and 08-provenance-and-reproducibility.md) — subject is an open File > Export submenu; same open-menu constraint as above.
- **operations-panel-row** — needs a genuinely running operation; instructions prohibit clicking Run.
- **operations-panel-right-click-menu** — needs a right-click context menu, which the background click tools refuse (would bring the app to the foreground).

## Failed (app gap, not a tool constraint)

- **provenance-lineage-step-expanded** — the chapter's procedure says to select the `HG002 bcftools` variant track in the Variants tab so the Inspector's Provenance section shows that track's own 11-step lineage instead of the bundle's own import provenance. Investigated the source (`AnnotationTableDrawerView.swift`, `InspectorViewController+Notifications.swift`, `ProvenanceInspectorViewModel.swift`, `ProvenanceRecorder.swift`, `DocumentSection.swift`) and confirmed there is currently no UI affordance to do this: the Variants tab merges all attached tracks with no per-track picker, there is no per-track sidebar row (only a bulk "Delete Variant Tracks…" bundle-level menu item), and the existing "Alignment Tracks" track picker in the Inspector's Document tab does not drive the Provenance tab even for alignments. `ProvenanceRecorder`'s single-nested-sidecar shortcut that can auto-surface one track's own provenance only fires when exactly one variant/annotation/alignment sidecar is nested under the bundle; the demo project's chr20 bundle has two variant tracks (bcftools + LoFreq) attached, so that shortcut does not fire and selecting the bundle always shows the bundle's own top-level import provenance (3 steps), never a specific track's. This is a genuine product gap, not a background-tool limitation — flagging for a follow-up task rather than fabricating a workaround.

## Failed (environment constraint, not attempted-and-abandoned)

- **welcome-window** — `File > Close` stayed disabled every time it was tried (menu inspection reported "the app may need a document open, a selection, or to be frontmost for this item"), on both the original main window and a freshly reopened one. Closing a project window to reach the Welcome window requires the window to be truly OS-key/frontmost, which the background-only computer-use tools cannot grant (the task explicitly disallows `request_full_control`/`computer_batch`). Reopening the demo project via File > Open Recent afterwards was not needed since Close never actually fired.
- **empty-project-window** — `File > New Project` opens a working "Create New Project" sheet (project name field is fully interactive), but the sheet's location browser (an NSOpenPanel/NSSavePanel outline/table view) does not respond to the background tool's synthesized clicks: rows never highlight/select and folders never navigate open, confirmed across two separate dialog instances (one in a since-degraded window, one in a fresh healthy window) and multiple click strategies (row text, folder icon, disclosure triangle, search-result row, Return key). Only real AppKit buttons (Cancel, tab segments, menu items) responded reliably; the outline/table content did not. Navigating into `~/Desktop/lge-docs/` to create `LGE Empty Demo.lungfish` was therefore not possible without full-screen control, so the dialog was cancelled and no project was created.

## check-shots output (01-foundations only)

```
missing png 01-foundations/primer-scheme-picker-built-in
missing recipe 01-foundations/primer-scheme-picker-built-in
missing png 01-foundations/welcome-window
missing recipe 01-foundations/welcome-window
missing png 01-foundations/empty-project-window
missing recipe 01-foundations/empty-project-window
missing png 01-foundations/file-export-menu
missing recipe 01-foundations/file-export-menu
missing png 01-foundations/operations-panel-row
missing recipe 01-foundations/operations-panel-row
missing png 01-foundations/operations-panel-right-click-menu
missing recipe 01-foundations/operations-panel-right-click-menu
missing png 01-foundations/provenance-lineage-step-expanded
missing recipe 01-foundations/provenance-lineage-step-expanded
missing png 01-foundations/file-export-menu
missing recipe 01-foundations/file-export-menu
missing png 01-foundations/provenance-export-folder
missing recipe 01-foundations/provenance-export-folder
```

These 9 rows match the skipped/failed shots above exactly (file-export-menu counted twice, once per chapter).

## Notable environment issue encountered

Mid-session, after using `File > Close All` and toggling View > Focus Viewer/Show Sidebar/Restore Side Panes on the original main window (CGWindowID 56443), that window's accessibility tree went empty (sidebar rendered blank, `app_ax_find` returned nothing, `osascript`/System Events reported 0 windows for the process) while screenshots kept rendering its last-known content correctly and `File > Close` stayed disabled. The window was not used further. A fresh main window was reopened via `File > Open Recent > LGE Manual Demo` (new CGWindowID 57503) and all subsequent shots were captured from that healthy window. No project data appears to have been affected; the demo project's own files were not modified by this session.
