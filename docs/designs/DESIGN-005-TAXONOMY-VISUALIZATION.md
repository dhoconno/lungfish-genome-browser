# Design Specification: Taxonomy Classification Visualization

**Document ID**: DESIGN-005
**Component**: TaxonomyViewController, SunburstChartView, TaxonomyTableView, Kraken2DatabaseManagerView
**Owner**: UX Research / UI Lead
**Status**: Design Review
**Date**: 2026-03-22

---

## 1. Overview

This specification defines a native macOS taxonomy visualization system that replaces the Krona HTML sunburst chart with a CoreGraphics-rendered, fully interactive sunburst plus a companion taxonomy table. The visualization displays Kraken2 metagenomic classification results: a hierarchical taxonomy tree with read counts at each node. Users explore taxonomy interactively and extract sequences matching specific taxa.

### Design Goals

- Replace web-based Krona with a native, performant CoreGraphics implementation
- Provide instant orientation within complex taxonomy hierarchies (8 ranks deep, thousands of taxa)
- Enable fluid exploration: zoom, filter, multi-select, extract
- Maintain visual consistency with existing dataset view controllers (FASTQ, VCF, FASTA)
- Follow macOS Human Interface Guidelines (Tahoe / macOS 26)
- Support accessibility (VoiceOver, keyboard navigation, colorblind-safe palette)

### Design Constraints

- Must fit within the existing three-panel MainSplitViewController architecture
- Must follow the same controller pattern as FASTQDatasetViewController and VCFDatasetViewController
- Must use the SemanticColors system and existing GenomicSummaryCardBar for summary metrics
- Must render at 60 fps during zoom animations on Apple Silicon

---

## 2. Information Architecture

### Data Model

```
TaxonomyTree
  +-- TaxonomyNode
        taxId: Int
        name: String
        rank: TaxonomyRank  (Domain, Kingdom, Phylum, Class, Order, Family, Genus, Species)
        readCount: Int       (reads classified directly at this node)
        cladeCount: Int      (reads at this node + all descendants)
        parent: TaxonomyNode?
        children: [TaxonomyNode]
```

### Key Metrics (Summary Bar)

| Metric | Description |
|--------|-------------|
| Total Reads | Sum of all classified + unclassified |
| Classified | Reads assigned to any taxon |
| Unclassified | Reads matching no taxon |
| Species | Count of distinct species detected |
| Genera | Count of distinct genera detected |
| Top Hit | Name + percentage of dominant taxon |
| Shannon | Shannon diversity index |
| Simpson | Simpson diversity index |

---

## 3. Layout Architecture

### Placement in the App

The taxonomy visualization occupies the **main viewport** (the center panel of `MainSplitViewController`), replacing the sequence viewer when a Kraken2 classification result is selected in the sidebar. This follows the identical pattern used by:

- `FASTQDatasetViewController` (replaces viewer for FASTQ files)
- `VCFDatasetViewController` (replaces viewer for standalone VCF files)
- `FASTACollectionViewController` (replaces viewer for multi-sequence FASTA)

The controller is `TaxonomyViewController`, instantiated and managed by `ViewerViewController` as a child, hidden/shown based on sidebar selection type.

### Overall Layout (Three Zones)

```
+-------------------------------------------------------------------+
| [Classification Summary Bar]  48px                                |
|  Total: 2.4M | Classified: 89.2% | Species: 347 | H': 3.21 ...  |
+-------------------------------------------------------------------+
| [Breadcrumb Trail]  28px                                          |
|  root > Bacteria > Proteobacteria > [Gammaproteobacteria]         |
+---------------------------+---------------------------------------+
|                           |                                       |
|    SUNBURST CHART         |    TAXONOMY TABLE                     |
|    (primary viz)          |    (filterable, hierarchical)          |
|                           |                                       |
|    CoreGraphics           |    NSOutlineView                      |
|    Interactive             |    with disclosure triangles          |
|    ~60% width             |    ~40% width                         |
|                           |                                       |
|                           |                                       |
+---------------------------+---------------------------------------+
| [Action Bar]  36px                                                |
|  [Extract Sequences...]  [Export Report...]  [Copy Chart]         |
+-------------------------------------------------------------------+
```

### Resizable Split

The sunburst and table panes are separated by an `NSSplitView` (raw, not `NSSplitViewController` -- see macos26-api-rules). The split is user-resizable. Default ratio: 60% chart / 40% table. Minimum chart width: 300px. Minimum table width: 260px.

---

## 4. Zone 1: Classification Summary Bar

Extends `GenomicSummaryCardBar` (the same base class used by `FASTQSummaryBar` and `FASTACollectionSummaryBar`). Height: 48px.

### Cards

| Card Label | Value Example | Abbreviated |
|------------|---------------|-------------|
| Total Reads | 2.4M | Reads |
| Classified | 89.2% | Class. |
| Unclassified | 10.8% | Unclass. |
| Species | 347 | Spp. |
| Genera | 142 | Gen. |
| Top Hit | E. coli (23.1%) | Top |
| Shannon (H') | 3.21 | H' |
| Simpson (1-D) | 0.92 | Simp. |

### Accessibility

- Role: `.group`
- Label: "Classification Summary Statistics"
- Value: Dynamic description of key metrics

---

## 5. Zone 2: Breadcrumb Trail

A 28px horizontal bar below the summary, showing the current zoom path through the taxonomy.

### Visual Design

```
+-------------------------------------------------------------------+
|  [house.fill]  root  >  Bacteria  >  Proteobacteria  > [Gamma...]|
+-------------------------------------------------------------------+
```

### Specifications

- Background: `NSColor.controlBackgroundColor` at 60% opacity
- Bottom border: 0.5px `NSColor.separatorColor`
- Each breadcrumb segment is a clickable label
- Font: `.systemFont(ofSize: 11, weight: .medium)`
- Active (current) segment: `.semibold`, `NSColor.labelColor`
- Ancestor segments: `.medium`, `NSColor.secondaryLabelColor`
- Chevron separator: SF Symbol `chevron.right` at 8pt, `NSColor.tertiaryLabelColor`
- Root icon: SF Symbol `house.fill` at 10pt
- Hover state: underline on ancestor segments
- Click: zooms the sunburst to that level

### Interaction

| Action | Behavior |
|--------|----------|
| Click ancestor segment | Zoom out to that taxonomic level |
| Click root icon | Reset to full taxonomy view |
| Cmd+click segment | No action (reserved) |
| Right-click segment | Context menu: "Copy Taxon Name", "Extract Sequences for [name]..." |

### Accessibility

- Role: `.toolbar`
- Each segment: `.button` with label "[rank]: [name]"
- Keyboard: Tab through segments, Enter to activate

---

## 6. Zone 3a: Sunburst Chart (Primary Visualization)

### Geometry

The sunburst is rendered in a custom `SunburstChartView: NSView` using CoreGraphics. The view fills the left pane of the inner split.

### Ring Structure

```
                         Species (outermost)
                        Genus
                       Family
                      Order
                     Class
                    Phylum
                   Kingdom
                  Domain (innermost)
                [Center Label]
```

- Center circle: displays the name and read count of the current zoom root
- Rings: 8 concentric rings, one per taxonomic rank
- Ring thickness: uniform, calculated as `(availableRadius - centerRadius) / visibleRankCount`
- Center radius: 15% of the available radius
- Available radius: `min(viewWidth, viewHeight) / 2 - outerPadding`
- Outer padding: 16px

### Segment Sizing

Each segment's angular span is proportional to its `cladeCount` relative to siblings:

```
segment.angle = (node.cladeCount / parent.cladeCount) * parent.angle
```

Minimum segment angle: 0.5 degrees. Segments below this threshold are aggregated into an "Other" slice at each rank level. The "Other" slice uses `NSColor.tertiaryLabelColor`.

### Segment Rendering

Each segment is a filled arc path (annular sector):

```
CGContext:
  1. Move to inner arc start
  2. Arc along inner radius
  3. Line to outer arc start
  4. Arc along outer radius (reversed)
  5. Close path
  6. Fill with phylum color (alpha varies by depth)
  7. Stroke with 0.5px separator (NSColor.separatorColor at 50% alpha)
```

### Label Rendering

- Labels are drawn inside segments when the segment is wide enough (arc length > 40px at midpoint radius and ring thickness > 14px)
- Label text: taxon name, truncated with ellipsis if needed
- Font: `.systemFont(ofSize: 9, weight: .medium)`
- Color: white or black, chosen for contrast against segment fill (use WCAG luminance ratio)
- Labels are rotated to follow the arc tangent at the segment midpoint
- For very small segments: no label (tooltip on hover instead)

### Center Label

```
+-------------------+
|     Bacteria      |  <- Name (.systemFont, 13pt, .semibold)
|    2,145,832      |  <- Read count (.monospacedDigit, 11pt)
|     (89.2%)       |  <- Percentage (.systemFont, 10pt, .secondary)
+-------------------+
```

When zoomed to root, the center shows "All Taxa" with total classified count.

### Color Palette

Colors are assigned by **phylum** (the third rank). All taxa within a phylum share the same hue. Deeper ranks use the same hue at progressively lighter tints (decreasing saturation, increasing brightness). This creates a natural visual grouping where each "wedge" of the sunburst has a coherent color family.

#### Phylum Color Assignments (20 slots)

The palette must be:
- Distinguishable from each other (minimum deltaE > 20 in CIELAB space)
- Legible in both light and dark mode
- Usable by people with protanopia, deuteranopia, and tritanopia
- Distinct from the UI chrome (no grays, no pure whites)

| Slot | Phylum (example) | Light Mode | Dark Mode | Hex (Light) |
|------|-------------------|------------|-----------|-------------|
| 0 | Pseudomonadota (Proteobacteria) | Medium blue | Bright blue | #4A90D9 |
| 1 | Bacillota (Firmicutes) | Warm orange | Light orange | #E8853D |
| 2 | Actinomycetota (Actinobacteria) | Forest green | Bright green | #4CAF50 |
| 3 | Bacteroidota (Bacteroidetes) | Crimson | Salmon | #D64541 |
| 4 | Cyanobacteriota | Teal | Bright teal | #26A69A |
| 5 | Chloroflexota | Gold | Bright gold | #F2B825 |
| 6 | Planctomycetota | Purple | Lavender | #9C5BB5 |
| 7 | Verrucomicrobiota | Rose pink | Light rose | #E57399 |
| 8 | Spirochaetota | Deep cyan | Cyan | #00ACC1 |
| 9 | Deinococcota | Brown | Light brown | #A07855 |
| 10 | Tenericutes | Slate blue | Periwinkle | #7986CB |
| 11 | Fusobacteriota | Coral | Light coral | #EF6C6C |
| 12 | Chlamydiota | Olive | Lime | #8BC34A |
| 13 | Euryarchaeota | Deep purple | Medium purple | #7B1FA2 |
| 14 | Ascomycota | Amber | Light amber | #FFB74D |
| 15 | Basidiomycota | Deep teal | Aqua | #009688 |
| 16 | Chordata | Steel blue | Light steel | #607D8B |
| 17 | Arthropoda | Magenta | Pink | #C2185B |
| 18 | Nematoda | Yellow-green | Chartreuse | #CDDC39 |
| 19 | Other / overflow | Neutral gray | Light gray | #9E9E9E |

#### Depth Tinting Formula

For a node at depth `d` below its phylum ancestor:

```
saturation = baseColor.saturation * (1.0 - 0.12 * d)
brightness = min(1.0, baseColor.brightness + 0.06 * d)
```

Clamped so saturation never drops below 0.15 and brightness never exceeds 0.95.

#### Dark Mode Adaptation

Colors are defined using `NSColor(name:)` with a dynamic provider block that returns the appropriate variant based on `NSAppearance.current.bestMatch`. The dark mode variants are brighter and slightly more saturated to maintain contrast against the dark background.

#### Colorblind Testing

The palette must pass simulation through:
- Protanopia (red-green, ~1% of males)
- Deuteranopia (red-green, ~6% of males)
- Tritanopia (blue-yellow, ~0.01%)

Verification: use Sim Daltonism or the Xcode accessibility inspector to confirm all 20 colors remain distinguishable. Where two phyla become confusable, the sunburst relies on spatial adjacency (they will never be neighbors) and the table view as a redundant channel.

---

## 7. Sunburst Interactions

### Hover (Mouse Tracking)

| State | Visual Feedback |
|-------|----------------|
| Hover over segment | Segment stroke becomes 2px `NSColor.controlAccentColor`; slight brightness boost (+10%) |
| Hover tooltip | Appears after `AppSettings.shared.tooltipDelay` (default 0.25s) |

#### Tooltip Content

```
+-----------------------------+
|  Escherichia coli           |  <- Name (13pt, semibold)
|  Species                    |  <- Rank (11pt, secondary)
|  __________________________ |
|  Reads: 145,832             |
|  % of classified: 6.8%     |
|  % of total: 6.1%          |
|  Clade reads: 152,401      |
+-----------------------------+
```

Tooltip is an `NSView` subclass (`TaxonomyTooltipView`) positioned adjacent to the cursor, following the existing `HoverTooltipView` pattern from `ViewerViewController`. It stays within the window bounds (flips if near edges).

### Click Interactions

| Action | Behavior |
|--------|----------|
| Single click | Select taxon: highlight in sunburst + select in table |
| Double click | Zoom in: clicked segment becomes center; its children become the innermost ring |
| Cmd+click | Toggle multi-select (add/remove from selection set) |
| Right-click | Context menu (see below) |
| Click center | Zoom out one level (to parent of current root) |
| Click empty space | Deselect all |

### Zoom Animation

When the user double-clicks a segment to zoom in:

1. The target node becomes the new "root" for the chart
2. Animate over 300ms (ease-in-out, `CAMediaTimingFunction`):
   - Target segment expands to fill the center circle
   - Its children's segments expand to fill the first ring
   - Ancestor segments fade out
   - New descendant rings appear from the outside
3. Breadcrumb trail updates to show the new path
4. Table scrolls to show the subtree rooted at the target

When the user clicks the center or a breadcrumb to zoom out:

1. Reverse animation: current center shrinks back to its original segment position
2. Ancestor rings reappear from the inside
3. Duration: 300ms

### Scroll Wheel

- Scroll up (toward user) on the sunburst: zoom out one level
- Scroll down (away from user): zoom in to the segment under the cursor
- Momentum scrolling is debounced (only one zoom per 200ms)

### Context Menu (Right-Click)

```
+------------------------------------+
|  Extract Sequences for "E. coli"...|  <- leaf.fill
|  __________________________________|
|  Select All in Clade               |  <- checkmark.circle
|  Deselect                          |  <- xmark.circle
|  __________________________________|
|  Zoom to "E. coli"                 |  <- arrow.up.left.and.arrow.down.right
|  Reset Zoom                        |  <- arrow.counterclockwise
|  __________________________________|
|  Copy Taxon Name                   |  <- doc.on.doc
|  Copy Statistics                   |  <- list.clipboard
+------------------------------------+
```

### Keyboard Navigation

| Key | Action |
|-----|--------|
| Tab | Move focus between sunburst and table |
| Arrow keys (when sunburst focused) | Move selection between sibling segments at current ring |
| Up/Down arrows | Move selection to parent/first child |
| Enter/Return | Zoom into selected segment |
| Escape | Zoom out one level, or deselect if at root |
| Space | Toggle selection (multi-select mode) |
| Cmd+A | Select all taxa in current view |

### Accessibility (VoiceOver)

- The sunburst view has role `.group` with label "Taxonomy Sunburst Chart"
- Each visible segment is an accessibility element with:
  - Role: `.button`
  - Label: "[Name], [Rank]"
  - Value: "[cladeCount] reads, [percentage]%"
  - Hint: "Double-click to zoom in. Right-click for options."
- Focus ring follows the selected segment's arc path
- The accessibility tree is flat (all visible segments), ordered by: ring (inner to outer), then clockwise

---

## 8. Zone 3b: Taxonomy Table

### Table Design

An `NSOutlineView` with hierarchical rows following the taxonomy tree. Uses disclosure triangles for expand/collapse.

### Columns

| Column | Width | Alignment | Content |
|--------|-------|-----------|---------|
| Taxon Name | flex (min 140) | left | Name with colored dot indicator (phylum color) |
| Rank | 70 | center | Domain, Phylum, Class, etc. |
| Reads | 80 | right | Direct read count at this node |
| Clade | 80 | right | Cumulative reads (node + all descendants) |
| % | 55 | right | Clade reads as % of total classified |

### Row Design

```
+---+----+----------------------------------+--------+--------+--------+-------+
|   | v  | [*] Escherichia coli             | Species| 145,832| 152,401|  6.8% |
+---+----+----------------------------------+--------+--------+--------+-------+
  ^    ^    ^
  |    |    +-- Colored dot (phylum color, 8px circle)
  |    +-- Disclosure triangle (expand/collapse children)
  +-- Indentation (16px per rank level)
```

- Row height: 22px
- Font: `.systemFont(ofSize: 12)` for name, `.monospacedDigitSystemFont(ofSize: 12)` for numbers
- Alternating row colors: `NSColor.alternatingContentBackgroundColors`
- Selected row: system selection highlight
- Hover: subtle highlight (`NSColor.unemphasizedSelectedContentBackgroundColor`)

### Bar Indicator

The "%" column includes a tiny horizontal bar behind the percentage text. The bar width is proportional to the percentage value. Color: phylum color at 20% opacity. This provides a visual sparkline effect within the table.

### Search / Filter

A search field above the table, matching the `VCFDatasetViewController` pattern:

```
+-------------------------------------------------------------------+
| [magnifyingglass] Filter taxa...           | 347 of 1,204 taxa    |
+-------------------------------------------------------------------+
```

- SF Symbol: `magnifyingglass`
- Placeholder: "Filter taxa..."
- Real-time filtering (as-you-type, 150ms debounce)
- Filters on taxon name (substring match, case-insensitive)
- When filtering: non-matching rows are hidden; ancestor rows of matches remain visible (grayed) to preserve hierarchy context
- Count label: `.monospacedDigitSystemFont(ofSize: 11)`, secondary color, right-aligned

### Table-Sunburst Synchronization

| Table Action | Sunburst Response |
|-------------|-------------------|
| Click row | Highlight corresponding segment (2px accent stroke) |
| Double-click row | Zoom sunburst to that taxon |
| Expand/collapse row | No sunburst change |
| Cmd+click row | Add/remove from multi-select |

| Sunburst Action | Table Response |
|----------------|----------------|
| Click segment | Select + scroll-to row |
| Double-click segment | Zoom + expand row, scroll to show subtree |
| Zoom in/out | Expand corresponding rows, scroll to root of current view |
| Multi-select | Multi-select corresponding rows |

### Sorting

Columns are sortable by clicking the header. Default sort: by Clade descending (most abundant first). Sort indicator: standard `NSTableView` sort arrow. Hierarchy is maintained during sort (children sorted within their parent group).

### Accessibility

- Standard `NSOutlineView` accessibility (automatic)
- Colored dots have accessible descriptions: "Phylum color: [phylum name]"
- Percentage bars are decorative (no additional a11y role)

---

## 9. Zone 4: Action Bar

A 36px bar at the bottom of the taxonomy view, visually matching the `runBar` pattern from `FASTQDatasetViewController`.

### Layout

```
+-------------------------------------------------------------------+
| [Extract Sequences...]  [Export Report...]  [Copy Chart]     [i]  |
+-------------------------------------------------------------------+
```

### Buttons

| Button | SF Symbol | Action | Enabled When |
|--------|-----------|--------|-------------|
| Extract Sequences... | `arrow.down.doc.fill` | Opens extraction sheet | >= 1 taxon selected |
| Export Report... | `doc.text` | Saves TSV/CSV classification report | Always |
| Copy Chart | `doc.on.doc` | Copies sunburst as PNG to clipboard | Always |
| Info toggle | `info.circle` | Toggles inspector panel for taxonomy detail | Always |

### Button Style

- `NSButton` with `.rounded` bezel style
- 11pt system font
- SF Symbol at 12pt, leading position
- "Extract Sequences..." uses `NSColor.controlAccentColor` tint when enabled, to draw attention as the primary action
- Disabled buttons: standard dimmed appearance

---

## 10. Sequence Extraction Flow

### Trigger

User selects one or more taxa (via click, Cmd+click, or "Select All in Clade") and then either:
- Clicks "Extract Sequences..." in the action bar
- Right-clicks and selects "Extract Sequences for [name]..."

### Extraction Sheet

Presented as a sheet attached to the main window (following the `ExtractionConfigurationView` pattern).

```
+-------------------------------------------------------------------+
|                                                                   |
|  [arrow.down.doc.fill]  Extract Classified Sequences              |
|  _______________________________________________________________  |
|                                                                   |
|  Selected Taxa:                                                   |
|  +-------------------------------------------------------------+ |
|  | [x] Escherichia coli (Species)          152,401 reads        | |
|  | [x] Klebsiella pneumoniae (Species)      87,234 reads        | |
|  | [x] Salmonella enterica (Species)        43,112 reads        | |
|  +-------------------------------------------------------------+ |
|                                                                   |
|  Total reads to extract: 282,747                                  |
|                                                                   |
|  Options:                                                         |
|  [x] Include child taxa             (toggle)                     |
|  [ ] Include unclassified reads     (toggle)                     |
|                                                                   |
|  Output Format:  (*) FASTQ   ( ) FASTA                           |
|                                                                   |
|  Output Name:  [extracted-taxa-2026-03-22  ]                      |
|                                                                   |
|  _______________________________________________________________  |
|                                              [Cancel]  [Extract]  |
+-------------------------------------------------------------------+
```

### Sheet Specifications

- Width: 520px, height: dynamic (based on selected taxa count, max 480px with scroll)
- Header: SF Symbol `arrow.down.doc.fill` + "Extract Classified Sequences" in `.headline`
- Taxa list: scrollable if > 5 items, each row shows checkbox + name + rank + read count
- "Include child taxa" toggle: when on, extraction includes all descendants of selected nodes (default: on)
- "Include unclassified reads" toggle: when on, adds unclassified reads to output (default: off)
- Output format: radio buttons, FASTQ default (preserves quality), FASTA for downstream alignment
- Output name: text field with auto-generated default based on date
- Total reads updates dynamically as toggles change
- Cancel: dismisses sheet, no action
- Extract: begins extraction, dismisses sheet, shows progress

### Extraction Progress

After clicking Extract, the action bar transforms into a progress view:

```
+-------------------------------------------------------------------+
| [spinner]  Extracting 282,747 reads...  [=============>    ] 67%  |
|                                                     [Cancel]      |
+-------------------------------------------------------------------+
```

- `NSProgressIndicator` (determinate, horizontal bar)
- Percentage label: `.monospacedDigitSystemFont(ofSize: 11)`
- Cancel button: stops extraction, cleans up partial output
- On completion: action bar returns to normal state, new FASTQ bundle appears in sidebar

### Result

- A new `.lungfishfastq` bundle is created in the project directory
- The bundle appears in the sidebar under the parent classification result
- The bundle's manifest includes provenance metadata linking to the source classification
- Selecting the new bundle in the sidebar opens the standard FASTQ dashboard

---

## 11. Kraken2 Database Management UI

### Location

A new tab in the Settings window: "Databases" tab, positioned after "AI Services".

### Tab Icon

SF Symbol: `externaldrive.badge.checkmark`

### Layout

```
+-------------------------------------------------------------------+
|  Databases                                                        |
|  _______________________________________________________________  |
|                                                                   |
|  Kraken2 Classification Databases                                 |
|                                                                   |
|  Storage: 45.2 GB used of 256 GB available                       |
|  [=================================>                          ]   |
|                                                                   |
|  Location: /Users/demo/Library/Application Support/Lungfish/dbs   |
|  [folder.badge.gearshape]  [Move To...]                          |
|                                                                   |
|  _______________________________________________________________  |
|                                                                   |
|  +-------------------------------------------------------------+ |
|  | Database                  | Size   | Status       | Actions  | |
|  |---------------------------|--------|--------------|----------| |
|  | Standard (2026-03)        | 70 GB  | [checkmark]  | [trash]  | |
|  | Standard-8 (2026-03)      |  8 GB  | Downloading  | [x.circ] | |
|  | PlusPF (2025-12)          | 120 GB | Not Installed| [arrow]  | |
|  | PlusPFP (2025-12)         | 150 GB | Not Installed| [arrow]  | |
|  | MiniKraken2 (2026-01)     |  4 GB  | [checkmark]  | [trash]  | |
|  | Viral (2026-03)           |  2 GB  | Not Installed| [arrow]  | |
|  | nt (2025-09)              | 500 GB | Not Installed| [arrow]  | |
|  | 16S_Greengenes (2026-01)  |  74 MB | [checkmark]  | [trash]  | |
|  | 16S_SILVA (2026-01)       |  112MB | Not Installed| [arrow]  | |
|  | EuPathDB (2025-06)        |  35 GB | Not Installed| [arrow]  | |
|  +-------------------------------------------------------------+ |
|                                                                   |
|  [plus.circle]  Add Custom Database...                            |
|  _______________________________________________________________  |
|                                                                   |
|  [info.circle.fill]  Databases are downloaded from the official   |
|  Kraken2 index repository. Large databases require significant    |
|  disk space and download time.                                    |
|                                                                   |
+-------------------------------------------------------------------+
```

### Table Columns

| Column | Width | Content |
|--------|-------|---------|
| Database | flex (min 180) | Name + date tag |
| Size | 70 | Download size |
| Status | 110 | Installed / Downloading / Not Installed / Error |
| Actions | 60 | Context-dependent button |

### Status Indicators

| Status | Visual |
|--------|--------|
| Installed | SF Symbol `checkmark.circle.fill` in `NSColor.systemGreen` |
| Downloading | `NSProgressIndicator` (determinate, small) + percentage |
| Not Installed | SF Symbol `arrow.down.circle` in `NSColor.controlAccentColor` (clickable) |
| Error | SF Symbol `exclamationmark.triangle.fill` in `NSColor.systemOrange` + retry button |
| Verifying | SF Symbol `gearshape.2` spinning + "Verifying..." |

### Action Buttons

| Status | Button | SF Symbol | Action |
|--------|--------|-----------|--------|
| Not Installed | Download | `arrow.down.circle` | Begin download |
| Downloading | Cancel | `xmark.circle` | Cancel download |
| Installed | Delete | `trash` | Confirm + delete |
| Error | Retry | `arrow.clockwise` | Retry download |

### Download Progress

When a download is in progress, the row expands to show:

```
| Standard-8 (2026-03)      |  8 GB  | [=======>    ] 63%    | [xmark] |
|                            |        | 5.0 GB of 8.0 GB     |         |
|                            |        | ~3 min remaining      |         |
```

- Determinate progress bar
- Bytes transferred / total
- Estimated time remaining
- Cancel button

### Storage Overview

The storage bar at the top shows:
- Used space by Lungfish databases (colored fill)
- Available disk space (empty fill)
- Numbers: `.monospacedDigitSystemFont(ofSize: 12)`
- Bar: 6px height, rounded corners, `NSColor.controlAccentColor` fill

### Location Management

- Current path displayed as a non-editable text field
- SF Symbol `folder.badge.gearshape` at 12pt
- "Move To..." button opens `NSOpenPanel` (directory selection)
- Moving databases: progress overlay during file move, databases remain usable from new location
- External volume indicator: if path is on a non-boot volume, show SF Symbol `externaldrive` + volume name

### Custom Database

"Add Custom Database..." opens a file panel to select a directory containing Kraken2 database files (hash.k2d, opts.k2d, taxo.k2d). The app validates the directory contents and adds it to the managed list.

### Delete Confirmation

```
+---------------------------------------------------+
|  [exclamationmark.triangle]                       |
|                                                   |
|  Delete "Standard (2026-03)"?                     |
|                                                   |
|  This will free 70 GB of disk space. The          |
|  database can be re-downloaded later.             |
|                                                   |
|              [Cancel]  [Delete]                    |
+---------------------------------------------------+
```

Presented as a sheet on the settings window using `beginSheetModal` (not `runModal`, per macos26-api-rules).

---

## 12. Toolbar Integration

### Toolbar Items (when taxonomy view is active)

The main window toolbar adapts when a classification result is displayed, following the pattern used when FASTQ views are active.

| Position | Item | SF Symbol | Action |
|----------|------|-----------|--------|
| Leading | Sidebar toggle | `sidebar.leading` | Toggle sidebar |
| Center | Zoom controls | `minus.magnifyingglass` / `plus.magnifyingglass` | Zoom out / zoom in |
| Center | Reset zoom | `arrow.counterclockwise` | Reset to full taxonomy |
| Center | View mode | `chart.pie` / `list.bullet` | Toggle sunburst / table-only |
| Trailing | Inspector toggle | `sidebar.trailing` | Toggle inspector |

### View Mode Toggle

A segmented control allowing the user to choose between:
- **Sunburst + Table** (default): the split view described above
- **Table Only**: the taxonomy table expands to fill the full viewport
- **Sunburst Only**: the chart expands to fill the full viewport

SF Symbols for segments:
- Sunburst + Table: `rectangle.split.2x1`
- Table Only: `list.bullet`
- Sunburst Only: `chart.pie`

---

## 13. Inspector Integration

When a taxonomy view is active and a taxon is selected, the inspector panel (right sidebar) shows contextual information.

### Inspector Tab: Document

Shows classification metadata:
- Source FASTQ file
- Kraken2 database used
- Classification date
- Confidence threshold
- Total reads processed
- Runtime duration

### Inspector Tab: Selection

Shows selected taxon detail:

```
+----------------------------------+
|  Selection                       |
|  ________________________________|
|                                  |
|  Escherichia coli                |
|  Species (Tax ID: 562)          |
|  ________________________________|
|                                  |
|  Lineage:                        |
|  Bacteria > Pseudomonadota >     |
|  Gammaproteobacteria >           |
|  Enterobacterales >              |
|  Enterobacteriaceae >            |
|  Escherichia > E. coli           |
|  ________________________________|
|                                  |
|  Direct Reads:    145,832        |
|  Clade Reads:     152,401        |
|  % of Classified:   6.8%        |
|  % of Total:        6.1%        |
|  ________________________________|
|                                  |
|  Children: 23 subspecies/strains |
|  Top child: E. coli K-12 (34%)  |
|  ________________________________|
|                                  |
|  [NCBI Taxonomy]                 |  <- Link button, opens browser
|  [View in Tree of Life]          |  <- Link button
|  ________________________________|
|                                  |
|  [Extract Sequences...]          |  <- Primary action button
+----------------------------------+
```

---

## 14. Rendering Performance

### Target

- 60 fps during zoom animations
- < 16ms per frame for static rendering
- Handles taxonomy trees with up to 50,000 nodes

### Strategy

1. **Offscreen tile cache**: Render the sunburst into a cached `CGLayer` (or `NSImage` bitmap). Invalidate only on zoom, resize, or selection change.
2. **Visible segment culling**: Only render segments whose angular span is >= 0.5 degrees. Aggregate smaller segments into "Other".
3. **Level-of-detail**: At low zoom levels (many rings visible), skip labels. Add labels progressively as the user zooms in.
4. **Animation frames**: During zoom animation, render at reduced fidelity (no labels, no stroke, simplified paths) and snap to full fidelity on animation end.
5. **Async path computation**: Segment geometry (arc paths) is computed on a background thread. The draw call only fills pre-computed paths.
6. **Hit testing**: Use a secondary lookup structure (array of `(path: CGPath, node: TaxonomyNode)`) for O(n) hit testing. For trees > 10,000 visible segments, use angular bisection for O(log n) lookup.

---

## 15. Empty States

### No Classification Result Selected

```
+-------------------------------------------------------------------+
|                                                                   |
|                                                                   |
|           [chart.pie]  (48pt, secondary color)                    |
|                                                                   |
|           No Classification Selected                              |
|                                                                   |
|           Select a Kraken2 classification result                  |
|           in the sidebar to view taxonomy.                        |
|                                                                   |
|           [Classify FASTQ...]                                     |
|                                                                   |
+-------------------------------------------------------------------+
```

### Classification In Progress

```
+-------------------------------------------------------------------+
|                                                                   |
|           [spinner]                                               |
|                                                                   |
|           Classifying reads...                                    |
|           Processing 2,400,000 reads with Standard-8              |
|                                                                   |
|           [=============>                              ] 34%      |
|           816,000 / 2,400,000 reads                               |
|                                                                   |
+-------------------------------------------------------------------+
```

### Classification Complete, No Hits

```
+-------------------------------------------------------------------+
|                                                                   |
|           [magnifyingglass]  (48pt, secondary color)              |
|                                                                   |
|           No Classified Reads                                     |
|                                                                   |
|           All 2,400,000 reads were unclassified.                  |
|           Consider using a different database or                  |
|           lowering the confidence threshold.                      |
|                                                                   |
+-------------------------------------------------------------------+
```

---

## 16. Export Capabilities

### Export Report (TSV/CSV)

"Export Report..." produces a tab-separated or comma-separated file with one row per taxon:

```
#taxid  name    rank    direct_reads    clade_reads percent
562     Escherichia coli    species 145832  152401  6.8
573     Klebsiella pneumoniae   species 87234   89012   4.0
...
```

Save panel with format selector: TSV (default) or CSV.

### Copy Chart (PNG)

Renders the sunburst view at 2x resolution into a PNG and copies to the system clipboard. Uses the same `copyViewToPasteboard` pattern from `FASTQChartViews.swift`.

### Print Support

The sunburst view responds to Cmd+P / File > Print. Renders at print resolution with white background and black text (adapts for print media).

---

## 17. SF Symbol Reference

Complete list of SF Symbols used in the taxonomy visualization:

| Context | Symbol Name | Usage |
|---------|-------------|-------|
| Breadcrumb root | `house.fill` | Root of taxonomy path |
| Breadcrumb separator | `chevron.right` | Between breadcrumb segments |
| Extract button | `arrow.down.doc.fill` | Extract sequences action |
| Export button | `doc.text` | Export report action |
| Copy chart | `doc.on.doc` | Copy sunburst to clipboard |
| Info toggle | `info.circle` | Toggle inspector detail |
| Zoom in | `plus.magnifyingglass` | Toolbar zoom in |
| Zoom out | `minus.magnifyingglass` | Toolbar zoom out |
| Reset zoom | `arrow.counterclockwise` | Reset to full view |
| View mode: split | `rectangle.split.2x1` | Sunburst + table |
| View mode: table | `list.bullet` | Table only |
| View mode: chart | `chart.pie` | Sunburst only |
| Sidebar toggle | `sidebar.leading` | Toggle sidebar |
| Inspector toggle | `sidebar.trailing` | Toggle inspector |
| DB: installed | `checkmark.circle.fill` | Database ready |
| DB: download | `arrow.down.circle` | Download database |
| DB: cancel | `xmark.circle` | Cancel download |
| DB: delete | `trash` | Delete database |
| DB: retry | `arrow.clockwise` | Retry failed download |
| DB: error | `exclamationmark.triangle.fill` | Download error |
| DB: verifying | `gearshape.2` | Verifying integrity |
| DB: location | `folder.badge.gearshape` | Database path |
| DB: external | `externaldrive` | External volume |
| DB: tab icon | `externaldrive.badge.checkmark` | Settings tab |
| DB: add custom | `plus.circle` | Add custom database |
| Context: select clade | `checkmark.circle` | Select all in clade |
| Context: deselect | `xmark.circle` | Deselect |
| Context: zoom to | `arrow.up.left.and.arrow.down.right` | Zoom to taxon |
| Context: copy name | `doc.on.doc` | Copy taxon name |
| Context: copy stats | `list.clipboard` | Copy statistics |
| Context: extract | `leaf.fill` | Extract for taxon |
| Empty: no result | `chart.pie` | Empty state icon |
| Empty: no hits | `magnifyingglass` | No hits icon |
| Filter field | `magnifyingglass` | Table search |
| NCBI link | `link` | External taxonomy link |

---

## 18. Accessibility Compliance

### WCAG 2.1 AA Targets

| Criterion | Requirement | Implementation |
|-----------|-------------|----------------|
| 1.1.1 Non-text Content | Alt text for chart | VoiceOver labels on all segments |
| 1.3.1 Info and Relationships | Hierarchy conveyed | Outline view + breadcrumb |
| 1.4.1 Use of Color | Not sole differentiator | Table provides redundant text channel |
| 1.4.3 Contrast | 4.5:1 minimum | Labels tested against segment fills |
| 1.4.11 Non-text Contrast | 3:1 for UI components | Segment borders, focus rings |
| 2.1.1 Keyboard | All functions keyboard-accessible | Full keyboard navigation spec above |
| 2.4.3 Focus Order | Logical tab order | Summary > Breadcrumb > Sunburst > Table > Action bar |
| 2.4.7 Focus Visible | Focus ring visible | Arc-following focus ring on segments |
| 4.1.2 Name, Role, Value | Programmatic semantics | NSAccessibility roles + labels |

### Reduced Motion

When the user has enabled "Reduce motion" in System Settings > Accessibility > Display:
- Zoom transitions are instant (no animation)
- Hover highlight changes are instant (no fade)
- Detected via `NSWorkspace.shared.accessibilityDisplayShouldReduceMotion`

### High Contrast

When the user has enabled "Increase contrast":
- Segment borders become 1.5px instead of 0.5px
- Phylum colors shift to higher saturation
- Background-to-segment contrast is verified >= 4.5:1
- Detected via `NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast`

---

## 19. File / Class Map

| File | Class / Struct | Responsibility |
|------|---------------|----------------|
| `TaxonomyViewController.swift` | `TaxonomyViewController` | Top-level controller (like `FASTQDatasetViewController`) |
| `SunburstChartView.swift` | `SunburstChartView: NSView` | CoreGraphics sunburst rendering + hit testing |
| `SunburstChartView+Drawing.swift` | Extension | `draw(_:)` implementation, path computation |
| `SunburstChartView+Interaction.swift` | Extension | Mouse tracking, click, context menu, keyboard |
| `SunburstChartView+Animation.swift` | Extension | Zoom animation state machine |
| `SunburstChartView+Accessibility.swift` | Extension | VoiceOver elements, keyboard focus |
| `TaxonomyTableView.swift` | `TaxonomyTableController` | `NSOutlineView` data source + delegate |
| `TaxonomyBreadcrumbBar.swift` | `TaxonomyBreadcrumbBar: NSView` | Breadcrumb trail rendering |
| `TaxonomySummaryBar.swift` | `TaxonomySummaryBar: GenomicSummaryCardBar` | Summary card strip |
| `TaxonomyTooltipView.swift` | `TaxonomyTooltipView: NSView` | Hover tooltip |
| `TaxonomyExtractionSheet.swift` | `TaxonomyExtractionSheet: View` (SwiftUI) | Extraction configuration |
| `TaxonomyActionBar.swift` | `TaxonomyActionBar: NSView` | Bottom action buttons |
| `TaxonomyPhylumPalette.swift` | `TaxonomyPhylumPalette` | Color assignment + depth tinting |
| `Kraken2DatabaseManagerView.swift` | `Kraken2DatabaseManagerView: View` (SwiftUI) | Settings tab for DB management |
| `ViewerViewController+Taxonomy.swift` | Extension | Show/hide taxonomy view, wiring |

### Module Placement

- `TaxonomyPhylumPalette` and data model types: `LungfishCore`
- All views and view controllers: `LungfishApp`
- Kraken2 runner and Kraken2 report parser: `LungfishWorkflow`

---

## 20. Open Questions

1. **Krona compatibility**: Should we support importing existing Krona HTML files, or only Kraken2 report format?
2. **Comparative view**: Should two classification results be viewable side-by-side (e.g., before/after decontamination)?
3. **Temporal tracking**: For longitudinal studies, should we support time-series taxonomy views?
4. **Minimum segment threshold**: 0.5 degrees aggregation -- does this need to be user-configurable?
5. **Database auto-update**: Should the app check for new database versions and prompt for updates?

---

## Appendix A: Interaction State Machine

```
                 +----------+
                 |   IDLE   |
                 +----+-----+
                      |
          +-----------+-----------+
          |           |           |
     [hover]    [click]    [dbl-click]
          |           |           |
     +----v----+ +----v----+ +----v------+
     | TOOLTIP | | SELECTED| | ANIMATING |
     +---------+ +----+----+ +-----+-----+
                      |             |
                 [right-click]  [anim end]
                      |             |
                 +----v----+   +----v----+
                 | CONTEXT |   | ZOOMED  |---[click center]---> ANIMATING
                 |  MENU   |   |  (new   |
                 +---------+   |  root)  |---[dbl-click]------> ANIMATING
                               +---------+
```

## Appendix B: Zoom Animation Keyframes

| Time (ms) | Property | From | To | Curve |
|-----------|----------|------|----|-------|
| 0-300 | target.innerRadius | ring_inner | 0 | ease-in-out |
| 0-300 | target.outerRadius | ring_outer | centerRadius | ease-in-out |
| 0-300 | target.startAngle | segment_start | 0 | ease-in-out |
| 0-300 | target.endAngle | segment_end | 2*pi | ease-in-out |
| 0-200 | ancestors.opacity | 1.0 | 0.0 | ease-out |
| 100-300 | children.opacity | 0.0 | 1.0 | ease-in |
| 0-300 | center.label | old_name | new_name | crossfade |

## Appendix C: Kraken2 Report Parsing

The Kraken2 standard report format (--report flag) produces TSV with columns:

```
%reads  clade_reads  direct_reads  rank_code  taxid  name
 23.10   152401       145832        S          562    Escherichia coli
```

Rank codes: U (unclassified), R (root), D (domain), K (kingdom), P (phylum), C (class), O (order), F (family), G (genus), S (species), S1/S2 (subspecies). Indentation of the name field (leading spaces) encodes hierarchy depth.

The parser must:
1. Parse all rows into flat list
2. Reconstruct tree from indentation + rank codes
3. Validate that clade_reads >= direct_reads
4. Handle subspecies ranks (S1, S2) as children of species
5. Create the "Unclassified" pseudo-node at root level
