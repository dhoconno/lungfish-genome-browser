# Capture session: 02-sequences (2026-09-07)

16 open shots from the worklist. Results below.

## Captured (7)

- **ncbi-search-dialog** — 1600x1060, region crop `245 140 890 590`. GenBank & Genomes pane, Mode=Nucleotide, RefSeq Only unchecked, Include GFF3 Annotations checked, `NC_012920.1` typed into the query field. Chapter: `02-downloading-from-ncbi.md`.
- **ncbi-advanced-filters** — 1600x1114, region crop `245 140 890 620`. Advanced Search Filters panel expanded (Organism, Location, Gene, Author, Journal, Molecule Type, Sequence Length, Publication Date, Sequence Properties), all fields empty. Chapter: `02-downloading-from-ncbi.md`.
- **ncbi-results-download-selected** — 1600x1087, region crop `245 140 890 605`. Live NCBI search for `NC_012920.1` succeeded (network reachable), one result found and ticked, primary button reads Download Selected. Download Selected was never clicked. Chapter: `02-downloading-from-ncbi.md`.
- **extract-region-dialog** — 1020x800, region crop `432 240 510 400`. Extract Sequence sheet opened by Extract Visible Region on the HBB gene span (70545-72152 framed via Go to Location), Action picker set to New Bundle, scrolled to show the Flanking Sequence group (5'/3' Flank with preset buttons) and the Options group (Reverse Complement toggle) above Cancel/Extract. Dialog was Cancelled afterward, no bundle written. Chapter: `03-extracting-and-comparing.md`.
- **find-orfs-dialog** — 1600x1027, region crop `236 138 900 578`. Find ORFs panel on the HBB record showing all four groups (Reading Frames, Translation, Output, Options) at their shipped defaults. Cancelled afterward. Chapter: `03-extracting-and-comparing.md`.
- **alignment-viewport-primate-mito** — 1600x981 (window crop, actual window bounds 1468x900 — the alignment viewport's toolbar enforces a wider minimum than 1400 and would not go narrower). Primate-mitochondria alignment open showing the resizable name gutter, the pinned Consensus comparison row, the column header ruler, and the conservation overview strip above the five sequences. Chapter: `04-aligning-sequences.md`.
- **tree-viewport-primate-mito** — 1600x981 (window crop, same 1468x900 actual bounds). Primate mitochondria tree open showing the summary line (`Primate mitochondria 5 tips 3 internal nodes unrooted`), the Phylogram/Cladogram control, and the Nodes drawer scrolled to its top row. The drawer's own height only shows 2-3 rows at a time (no resize handle found), but its table holds all eight node rows, reachable by scrolling; a wider vertical crop was not available since the drawer does not appear resizable in this build. Chapter: `05-building-trees.md`.

## Skipped, as instructed (2 rows, both listed twice in the worklist = same PNG serves 2 chapters each)

- **hbb-annotation-context-menu** — needs an open right-click menu, which requires full-screen control (explicitly deferred to a later pass per the task). Applies to both `01-importing-and-viewing.md` and `03-extracting-and-comparing.md`.
- **ncbi-bundle-in-sidebar** — needs a completed download into the project sidebar; not attempted since Download Selected was never clicked (per instructions).
- **pathoplexus-pane** — needs the access-and-benefit-sharing notice accepted, which is a data/consent-changing action outside the allowed action set for this session.

## Failed / blocked by tooling or fixture gaps (4)

- **import-center-annotation-track-alert** — Opened Import Center > Reference Sequences > Annotation Track > Import..., which opens a standard macOS file-open panel as a sheet. Its sidebar (Desktop/Documents/etc.) would not respond to background clicks (`app_click` on the sidebar rows returned "unverified" and the selection never changed away from Desktop), and typeahead/path-jump into the file list is refused by the background tool set (no text field at that point, and `cmd+shift+g` has no background equivalent). No `.gff3`/`.gtf`/`.bed` fixture exists on the Desktop top level or elsewhere reachable without navigating away from Desktop, and creating one there was avoided since it is outside the described fixtures. Not captured.
- **translation-tool-hbb-cds** — The chapter's caption wants the window-toolbar Translate button (the overlay tool with Mode/Genetic Code/Color Scheme controls). In this Preview build the reference-bundle viewport's native toolbar shows only Sidebar/Operations/Inspector regardless of selection or Focus/File-list state — no Chromosomes/Translate/Drawer icon set renders for the HBB record, even with the CDS feature selected. `Sequence > Translate...` from the menu bar instead opens the FASTQ/FASTA Operations dialog (an operation run, confirmed by capturing it), which the chapter explicitly distinguishes from the toolbar overlay tool. This looks like a genuine app-state discrepancy worth flagging to Fable/the manual author, not a capture failure to retry.
- **mafft-dialog** — The demo project's `Reference Sequences/` folder holds only `chr20_10.0-10.5Mb` and `HBB`; there is no unaligned primate-mito FASTA bundle to select (only the finished `.lungfishmsa` alignment exists under Analyses, per the primate-mito fixture as described in the task). Selecting the finished alignment (or all 5 of its rows) and running `Tools > Multiple Sequence Alignment > MAFFT...` from the menu bar both produced "No FASTQ/FASTA Inputs Selected" — the menu path does not accept an already-open alignment selection as input. The chapter's route for realigning a selection (`Align with MAFFT...`) is a right-click-only menu item, which this session's tools cannot open in the background. Not captured.
- **iqtree-dialog** — Same root cause as mafft-dialog: `Build Tree with IQ-TREE...` is reachable only via right-click on an alignment selection (confirmed no equivalent exists anywhere in the Tools menu bar). Blocked by the same background right-click restriction. Not captured.
- **export-alignment-sheet** — `Export Alignment...` is reachable only via right-click inside the alignment viewport; no toolbar button or menu-bar equivalent exists (checked File > Export, which lists Annotations/FASTQ/Metadata/Image/Provenance items but nothing for alignments). Blocked by the same background right-click restriction. Not captured.

## Odd things noticed in the app

- The window toolbar's icon set (Sidebar / Chromosomes / Translate / Operations / Drawer / Inspector vs. just Sidebar / Operations / Inspector) is inconsistent between viewport types in this build: the alignment and tree viewports show the full 6-icon set, but the reference-sequence (HBB) viewport shows only 3 icons and never exposes the Translate overlay tool the chapter documents, in any state tried (Bundle/Selected Item tabs, Focus mode, with or without a CDS selected).
- The Extract Sequence sheet (New Bundle action) renders taller than its visible frame and needed manual scrolling inside the sheet to reach the Options group and Bundle Name field; nothing on screen hints that the sheet scrolls (no visible scrollbar until the pointer entered the content area).
- The tree viewport's Nodes drawer has a fixed height showing only 2-3 rows regardless of window size; no drag handle was found to resize it taller.

## check-shots output

```
missing png 02-sequences/import-center-annotation-track-alert
missing recipe 02-sequences/import-center-annotation-track-alert
missing png 02-sequences/hbb-annotation-context-menu
missing recipe 02-sequences/hbb-annotation-context-menu
missing png 02-sequences/translation-tool-hbb-cds
missing recipe 02-sequences/translation-tool-hbb-cds
missing png 02-sequences/ncbi-bundle-in-sidebar
missing recipe 02-sequences/ncbi-bundle-in-sidebar
missing png 02-sequences/pathoplexus-pane
missing recipe 02-sequences/pathoplexus-pane
missing png 02-sequences/hbb-annotation-context-menu
missing recipe 02-sequences/hbb-annotation-context-menu
missing png 02-sequences/mafft-dialog
missing recipe 02-sequences/mafft-dialog
missing png 02-sequences/export-alignment-sheet
missing recipe 02-sequences/export-alignment-sheet
missing png 02-sequences/iqtree-dialog
missing recipe 02-sequences/iqtree-dialog
```

This matches the failed/skipped list above exactly: 9 missing-PNG lines for the 8 distinct shot ids that were not captured (`hbb-annotation-context-menu` counted twice, once per chapter directory it appears under).

## Fable review (2026-09-07)

- `extract-region-dialog` and `find-orfs-dialog` recaptured with the app active (the first captures rendered toggles and segments grey because the window was not key; `capture-window.sh` now activates the app before capturing) and with crops converted from the screenshot frame to window points.
- `mafft-dialog` captured after importing the primate-mito FASTA into the demo project as `Reference Sequences/primate-mito.lungfishref` (build script updated). The scope line reads "Aligning all 0 sequences." for a five-record bundle, which is a product defect to fix before this shot is final.
- `iqtree-dialog`, `export-alignment-sheet`, and `hbb-annotation-context-menu` wait for the full-screen pass (right-click routes). `translation-tool-hbb-cds` is a chapter or product defect (toolbar Translate hidden for reference bundles). `import-center-annotation-track-alert` needs a file panel, so it also waits for the full-screen pass.

- Captured `translation-tool-hbb-cds`,840×960 region850,428,420,480. Toolbar route works with sidebar-opened HBB in local Preview2026.9.13 build4673 from product-fix commit9b767d3e4. All named controls and Cancel/Hide Translation/Apply visible.
