# Capture session report: 03-reads

Session date 2026-09-07, against the running Lungfish Preview app (bundle
`com.lungfish.browser.preview`, main window CGWindowID 57698) with
`~/Desktop/lge-docs/LGE Manual Demo.lungfish` already open. All captures used
the background computer-use tools only (`app_screenshot`, `app_click`,
`app_menu`, `app_ax_find`); no full-screen tools were used. The main window's
actual size settled at 1468x900 rather than the requested 1400x900 (the app
appears to enforce that as its minimum width) — every full-window and region
crop below used the frame reported by the most recent `app_screenshot`, in
window points, not a fixed assumption.

## Captured (16)

All PNGs are under `docs/user-manual/assets/screenshots/03-reads/`, all
recipes under `docs/user-manual/assets/recipes/03-reads/`.

| Shot id | Crop | Pixel size | Notes |
|---|---|---|---|
| `import-center-sequencing-reads-tab` | window | 1600x1064 | Import Center, Sequencing Reads tab, three cards (Sequencing Read Files, FASTQ Sample Sheet, ONT Run Folder) — exact match to caption |
| `sidebar-after-import` | region 0,295,252,100 | 504x200 | Imports expanded: HG002-chrM, HG002 (selected), SRR36291587 |
| `sra-runs-pane` | region 280,135,910,630 | 1600x1107 | Database Browser, SRA Runs pane, Advanced Search Filters expanded (Platform/Strategy/Layout/Min Size/Publication Date/Max Results); dialog fully inside crop on all four edges |
| `sra-results-download-selected` | region 280,135,910,630 | 1600x1107 | SRR32909537 ticked, "1 selected", primary button reads Download Selected; live SRA search succeeded |
| `fastq-sparkline-popover` | region 474,155,653,416 | 1306x832 | Q / Position sparkline plus the expanded Per-Position Quality Scores panel; operations/Read-ID list at the left excluded |
| `refresh-qc-summary-dialog` | region 242,102,982,696 | 1600x1134 | FASTQ/FASTA Operations, Refresh QC Summary, HG002 input, Output Strategy |
| `trimming-dialog` | region 242,102,982,696 | 1600x1134 | fastp Adapter + Quality Trim at defaults: Threshold 20, Window Size 4, Mode Cut Right, Adapter Mode Auto-Detect — exact match |
| `length-filter-readiness` | region 242,102,982,696 | 1600x1134 | Filter by Read Length, both bounds empty, readiness line "Enter a minimum, a maximum, or both." — exact match |
| `primer-trimming-literal-pane` | region 242,102,982,696 | 1600x1134 | Primer Trimming, Primer Source on Literal Sequence (default), k=15/mink=11/hdist=1 |
| `human-scrub-dialog` | region 242,102,982,696 | 1600x1134 | Remove Human Reads pane — see discrepancy below: managed human database is NOT installed on this profile |
| `low-complexity-pane` | region 242,102,982,696 | 1600x1134 | Low-Complexity Filter, Entropy Threshold slider at 0.60, Advanced disclosure open on Window (50) and K-mer (5) — exact match |
| `subsample-by-count-pane` | region 242,102,982,696 | 1600x1134 | Subsample by Count, empty Count field, Output Strategy picker, readiness "Enter a positive read count." |
| `select-reads-by-sequence-pane` | region 242,102,982,696 | 1600x1134 | Select Reads by Sequence at defaults: Search End 5' End, Min Overlap 16, Error Rate 0.15, Keep Matched Reads on — exact match |
| `demultiplex-barcodes-pane` | region 242,102,982,696 | 1600x1134 | Demultiplex Barcodes pane, all named controls present (Barcode Source, Built-In Kit, Engine, Location, 5'/3' Distance, Error Rate, Trim Barcodes, Output Strategy). Input was HG002 (Illumina), since the demo project has no nanopore bundle — noted in the recipe |
| `merge-overlapping-pairs-pane` | region 242,102,982,696 | 1600x1134 | Merge Overlapping Pairs, Strictness Normal, Minimum Overlap 12 — exact match |
| `orient-reads-pane` | region 242,102,982,696 | 1600x1134 | Orient Reads pane, Word Length 12, Database Mask (dust/none), Extra arguments field, reference `before_rr (Analyses/HG002-chrM)` already chosen in Inputs |

Two rows (`fastq-viewport-summary-cards`, `fastq-viewport-reads-tab`) were
already `captured` in the manifest from an earlier pass and their PNGs already
existed under `03-reads/`; they were left untouched.

## Skipped (11, per instructions)

| Shot id | Reason |
|---|---|
| `import-fastq-configuration-sheet` | needs a file panel |
| `sra-import-configuration-sheet` | needs a completed download |
| `sra-bundle-in-sidebar` | demo project has no SRA bundle |
| `trim-operation-row` | needs a finished trim run |
| `remove-duplicates-preset-picker` | open picker needs full-screen control |
| `search-subsetting-menu` | open menu needs full-screen control (items confirmed via `app_menu list`: Subsample by Proportion, Subsample by Count, Extract Reads by ID, Extract Reads by Motif, Select Reads by Sequence) |
| `ont-import-configuration-sheet` | needs hg002-long-reads staged as a run folder |
| `ont-barcode-sheet-controls` | same sheet as above |
| `sidebar-after-ont-import` | demo project has no barcode01 bundle |
| `read-processing-menu` | open menu needs full-screen control (items confirmed via `app_menu list`: Merge Overlapping Pairs, Repair Paired-End Files, Reverse Complement, Translate, Orient Reads, Correct Sequencing Errors) |
| `sidebar-after-merge` | demo project has no merged bundle under Analyses |

## Failed

None.

## Discrepancies between the app and the chapter text

- **`human-scrub-dialog`**: the chapter caption describes the Database row
  holding "the managed human database beside Replace... and Clear buttons."
  On this profile the managed human database is **not installed** — the
  Database row instead reads "Required before this tool can run" with only a
  single "Choose..." button, and the Readiness line reads "Select a database
  to continue." The pane's other controls (Overview, Inputs, Primary
  Settings, Advanced Settings, Output, Readiness) all matched the chapter's
  structure. This shot may need re-capture once the managed human database is
  installed on this machine.
- **`orient-reads-pane`**: the pane text under Extra arguments reads "Select
  a reference sequence in the Inputs section" even though a reference
  (`before_rr (Analyses/HG002-chrM)`) is already chosen in the Reference
  popup above it — a minor inconsistency between the picked value and the
  hint text, not a blocking issue for the shot itself.
- **`demultiplex-barcodes-pane`**: captured with an Illumina bundle (HG002)
  selected rather than a nanopore bundle, since the demo project has none;
  the pane rendered with all the same named controls regardless of platform.

## check-shots output (03-reads only)

```
missing png 03-reads/import-fastq-configuration-sheet
missing recipe 03-reads/import-fastq-configuration-sheet
missing png 03-reads/sra-import-configuration-sheet
missing recipe 03-reads/sra-import-configuration-sheet
missing png 03-reads/sra-bundle-in-sidebar
missing recipe 03-reads/sra-bundle-in-sidebar
missing png 03-reads/trim-operation-row
missing recipe 03-reads/trim-operation-row
missing png 03-reads/remove-duplicates-preset-picker
missing recipe 03-reads/remove-duplicates-preset-picker
missing png 03-reads/search-subsetting-menu
missing recipe 03-reads/search-subsetting-menu
missing png 03-reads/ont-import-configuration-sheet
missing recipe 03-reads/ont-import-configuration-sheet
missing png 03-reads/ont-barcode-sheet-controls
missing recipe 03-reads/ont-barcode-sheet-controls
missing png 03-reads/sidebar-after-ont-import
missing recipe 03-reads/sidebar-after-ont-import
missing png 03-reads/read-processing-menu
missing recipe 03-reads/read-processing-menu
missing png 03-reads/sidebar-after-merge
missing recipe 03-reads/sidebar-after-merge
```

All remaining `missing` lines correspond exactly to the 11 skipped rows
above; no other 03-reads shot is reported missing.

## Redo (Fable review)

Thirteen shots whose first captures were clipped were redone on 2026-09-07:
the ten FASTQ/FASTA Operations panes, `sra-runs-pane`,
`sra-results-download-selected`, and `fastq-sparkline-popover`. Every crop
was converted from the `app_screenshot` coordinate frame (1400x858 for this
1468x900 window) to window points by multiplying by 1468/1400 before being
passed to `capture-window.sh`, so each region now frames its full dialog
(Cancel/Run visible, nothing cut on the right) instead of the earlier
clipped captures.

- 2026-09-07 completion pass `search-subsetting-menu` captured via authorized System Events menu control. Display crop (380, 0, 485, 490), 970×980px. PNG read back and all named menu entries checked.

- 2026-09-07 completion pass `read-processing-menu` captured via authorized System Events menu control. Display crop (380, 0, 530, 490), 1060×980px. PNG read back and all named menu entries checked.

- 2026-09-07 `import-fastq-configuration-sheet` captured at 1120×1040px, display crop 780,523,560,520. Verified mate names, detected Illumina/Paired-end, binning/compression and both buttons. Native sheet window capture includes parent, so used sheet-bounds region capture.

- Captured `ont-import-configuration-sheet` and `ont-barcode-sheet-controls` at 1120×1040 from region780,523,560,520. Correctly selected fastq_pass, yielding one barcode directory and5 MB. The optional recipe uses an illustrative sample/barcode CSV only for controls, disabled before import. Fixed-width sheet lets Barcode Sheet popup overflow and hides Choose, while both named controls and Cancel/Import remain visible.

- Captured `sra-bundle-in-sidebar`,1600×1028 full main window. Imports/SRR32909537 selected with115,776 reads, read table and cached statistics visible.

- Captured `sidebar-after-ont-import`,682×780,window-point crop0,400,341,390. barcode01 is inside ont-run after optional recipe was toggled on then off. Native provenance confirms unprocessed import and final payload paths/checksums. Chapter updated to this observed state.

- Replaced rejected `trim-operation-row` with1600×373 window crop0,1,1200,280 of1200×700 Operations panel. Local Preview build4673 wraps the complete command. Fresh demo fastp run completed7.7s,threshold20,window4,Cut Right,Auto-Detect,Per Input. sips cropOffset0,0 centers its crop,so usedy=1 to preserve the top of the window.

- `remove-duplicates-preset-picker` captured at 1600 × 1143 pixels, region 570,318,980,700 in Preview build 4673. All six choices, checked Exact PCR, and Cancel/Run are visible. Configuration only.
