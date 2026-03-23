# Design Specification: Taxa Collections Drawer

**Document ID**: DESIGN-006
**Component**: TaxaCollectionsDrawerView, TaxaCollectionManager, TaxonomyViewController
**Owner**: UX Research / UI Lead
**Status**: Design Review
**Date**: 2026-03-23
**Depends On**: DESIGN-005 (Taxonomy Visualization)

---

## 1. Overview

This specification defines a bottom drawer within the taxonomy classification view for managing **taxa collections** -- predefined or user-created sets of organisms that can be extracted as a batch from metagenomic classification results. The drawer sits between the NSSplitView (sunburst + table) and the existing TaxonomyActionBar, following the established drawer patterns used by AnnotationTableDrawerView and FASTQMetadataDrawerView.

### Design Goals

- Enable batch extraction of multiple taxa in a single operation
- Provide curated built-in collections for common surveillance workflows (respiratory, enteric, wastewater)
- Allow users to create, edit, and share custom collections at app-wide and project-specific scopes
- Maintain visual consistency with existing drawer patterns (annotation drawer, FASTQ metadata drawer)
- Follow macOS Human Interface Guidelines (Tahoe / macOS 26)
- Remain classifier-agnostic (works with Kraken2, STAT, GOTTCHA2 results)

### Design Constraints

- Must not use deprecated macOS 26 APIs (no `NSSplitViewController` delegate overrides, no `runModal`, no `lockFocus`)
- Must use the same drawer animation pattern as `ViewerViewController+AnnotationDrawer.swift` (constraint-based slide with `NSAnimationContext`)
- Must use the same divider drag-to-resize pattern as `DrawerDividerView` / `FASTQDrawerDividerView`
- TaxonomyViewController uses raw `NSSplitView` (not `NSSplitViewController`) per macOS 26 rules; the drawer inserts between `splitView` and `actionBar` using Auto Layout constraint changes
- Background-to-MainActor dispatch must use the `scheduleTaxonomyOnMainRunLoop` + `MainActor.assumeIsolated` pattern, never `Task { @MainActor in }` from detached contexts

---

## 2. Information Architecture

### Collection Data Model

```
TaxaCollection
    id: UUID
    name: String                    -- "Respiratory Viruses"
    icon: String                    -- SF Symbol name ("lungs.fill")
    scope: CollectionScope          -- .builtIn | .appWide | .project
    taxa: [TaxaCollectionEntry]
    description: String?            -- Optional longer description
    createdDate: Date
    modifiedDate: Date

TaxaCollectionEntry
    taxId: Int                      -- NCBI taxonomy ID
    name: String                    -- "Influenza A virus"
    rank: TaxonomicRank?            -- .species, .genus, etc.
    includeChildren: Bool           -- Whether to include descendant taxa
    isEnabled: Bool                 -- Checkbox state (default true)

CollectionScope
    .builtIn                        -- Hardcoded in app, read-only
    .appWide                        -- ~/Library/Application Support/Lungfish/taxa-collections/
    .project                        -- .lungfish project directory
```

### Three Tiers of Collections

| Tier | Storage | Editable | Scope |
|------|---------|----------|-------|
| Built-in | Bundled JSON in `LungfishApp/Resources/` | No (read-only) | All projects |
| App-wide | `~/Library/Application Support/Lungfish/taxa-collections/*.json` | Yes | All projects |
| Project | `<project>.lungfish/taxa-collections/*.json` | Yes | Current project only |

### Built-in Collections (Initial Set)

| Collection | Icon | Taxa Count | Description |
|------------|------|------------|-------------|
| Respiratory Viruses | `lungs.fill` | 12 | Influenza A/B, RSV, SARS-CoV-2, hCoV-229E/OC43/NL63/HKU1, hMPV, rhinovirus, adenovirus, parainfluenza |
| Enteric Viruses | `stomach` | 8 | Norovirus GI/GII, rotavirus A, sapovirus, astrovirus, adenovirus F, hepatitis A/E |
| Wastewater Surveillance | `drop.fill` | 6 | SARS-CoV-2, poliovirus 1/2/3, mpox virus, influenza A |
| AMR Bacteria | `pills.fill` | 10 | MRSA, VRE, CRE, ESBL-producing Enterobacterales, etc. |
| Foodborne Pathogens | `fork.knife` | 9 | Salmonella, Listeria, E. coli O157, Campylobacter, Vibrio, etc. |
| STI Panel | `shield.lefthalf.filled` | 7 | Chlamydia, Neisseria gonorrhoeae, Treponema pallidum, etc. |

---

## 3. Layout Architecture

### Placement Within TaxonomyViewController

The drawer inserts between the existing `splitView` and `actionBar`. The current layout:

```
+------------------------------------------+
| Summary Bar (48pt)                       |    summaryBar
+------------------------------------------+
| Breadcrumb Bar (28pt)                    |    breadcrumbBar
+------------------------------------------+
|  Sunburst  |  Taxonomy Table             |    splitView
|            |                             |
+------------------------------------------+
| Action Bar (36pt)                        |    actionBar
+------------------------------------------+
```

Becomes:

```
+------------------------------------------+
| Summary Bar (48pt)                       |    summaryBar
+------------------------------------------+
| Breadcrumb Bar (28pt)                    |    breadcrumbBar
+------------------------------------------+
|  Sunburst  |  Taxonomy Table             |    splitView
|            |                             |
+------------------------------------------+
| [===== Drag Handle =====] (8pt)          |    drawerDividerView
+------------------------------------------+
| Taxa Collections Drawer                  |    taxaCollectionsDrawerView
|   (variable height, collapsible)         |
+------------------------------------------+
| Action Bar (36pt)                        |    actionBar
+------------------------------------------+
```

### Constraint Changes on Toggle

When the drawer is **closed** (default state):
- `splitView.bottomAnchor == actionBar.topAnchor` (original constraint)
- Drawer view exists but is positioned below the action bar via `bottomConstraint.constant = drawerHeight`

When the drawer is **opened**:
- `splitView.bottomAnchor == drawerDividerView.topAnchor`
- `drawerDividerView` sits on top of the drawer
- `taxaCollectionsDrawerView.bottomAnchor == actionBar.topAnchor`
- Animated via `NSAnimationContext.runAnimationGroup` with 0.25s ease-in-ease-out

This matches the exact pattern in `ViewerViewController+AnnotationDrawer.swift` lines 39-47.

---

## 4. Drawer Dimensions

### Height

| Property | Value | Rationale |
|----------|-------|-----------|
| Default height | 220pt | Fits 3 collapsed collections + header without scrolling |
| Minimum height | 140pt | Shows header bar + scope filter + at least 1.5 collection rows |
| Maximum height | 50% of parent | Prevents drawer from consuming the sunburst/table entirely |
| Divider drag handle | 8pt | Matches `DrawerDividerView` in AnnotationTableDrawerView.swift |
| Persisted via | `UserDefaults("taxaCollectionsDrawerHeight")` | Matches annotation/FASTQ drawer persistence pattern |

### Resize Behavior

The drag handle uses the identical `DrawerDividerView` pattern from the annotation drawer:
- `mouseDown`: captures `NSEvent.mouseLocation.y` as `dragStartY`
- `mouseDragged`: computes delta, calls delegate `didDragDivider(_:deltaY:)`
- `mouseUp`: calls delegate `didFinishDraggingDivider()`
- Height save debounced at 300ms via `DispatchWorkItem` (matching `_drawerHeightSaveWorkItem` pattern)

---

## 5. Drawer Content Layout (Detailed Wireframes)

### 5.1 Header Bar (32pt)

```
+---------------------------------------------------------------+
|  Taxa Collections                   [+ New Collection] [    ] |
|                                                     [Import ^]|
+---------------------------------------------------------------+
```

- **Title**: "Taxa Collections" in `.headline` system font, left-aligned, 12pt leading
- **"+ New Collection" button**: `NSButton` with `.accessoryBarAction` bezel, SF Symbol `plus.circle` before text
- **Import button**: `NSPopUpButton` (pull-down) with SF Symbol `square.and.arrow.down`, containing:
  - "Import Collection from File..." (JSON)
  - "Import from Clipboard" (JSON or newline-delimited tax IDs)
  - (separator)
  - "Export Selected Collection..." (JSON)

### 5.2 Scope Filter Bar + Search (28pt)

```
+---------------------------------------------------------------+
| [Built-in] [App-wide] [Project]  [All]     [magnifying glass] |
|  (6)        (2)        (1)       (9)       [____________    ] |
+---------------------------------------------------------------+
```

- **Scope buttons**: `NSSegmentedControl` with `.texturedRounded` style, four segments
  - Each segment shows the scope label and a count badge in parentheses
  - "All" is the default selection, showing all collections from all scopes
  - Selecting a scope filters the list below
- **Search field**: `NSSearchField`, right-aligned, filters collections by name or contained taxon name
  - Placeholder: "Filter collections..."
  - Instant filtering as user types (no debounce needed, list is small)

### 5.3 Collection List (Scrollable, fills remaining space)

The list is an `NSOutlineView` (not `NSTableView`) because each collection is expandable to show its taxa. This matches the hierarchical pattern used by `TaxonomyTableView`.

#### Collapsed Collection Row (28pt)

```
+---------------------------------------------------------------+
| [>] [lungs] Respiratory Viruses          (12 taxa)  [Extract] |
+---------------------------------------------------------------+
```

- **Disclosure triangle**: Standard NSOutlineView disclosure
- **Icon**: SF Symbol rendered in the phylum palette color at 14pt
- **Collection name**: `.body` system font, primary label color
- **Taxa count badge**: `.caption` font, secondary label color, in parentheses
- **Scope badge** (for non-built-in only): Tiny pill badge "App" or "Project" in `.caption2`, tertiary label color
- **Extract button**: `NSButton` with `.accessoryBarAction` bezel, title "Extract", right-aligned
  - Transforms to a determinate progress indicator during extraction
  - Only visible on hover or when the collection is selected (prevents visual clutter)

#### Expanded Collection Row (showing individual taxa)

```
+---------------------------------------------------------------+
| [v] [lungs] Respiratory Viruses          (12 taxa)  [Extract] |
|     [x] Influenza A virus         taxid: 11320     [species]  |
|     [x] Influenza B virus         taxid: 11520     [species]  |
|     [x] RSV                       taxid: 12814     [species]  |
|     [x] SARS-CoV-2                taxid: 2697049   [species]  |
|     [x] Human coronavirus 229E    taxid: 11137     [species]  |
|     [x] Human coronavirus OC43    taxid: 31631     [species]  |
|     [x] Human coronavirus NL63    taxid: 290028    [species]  |
|     [x] Human coronavirus HKU1    taxid: 290029    [species]  |
|     [x] hMPV                      taxid: 162145    [species]  |
|     [x] Human rhinovirus A        taxid: 147711    [genus]    |
|     [x] Human adenovirus B        taxid: 108098    [species]  |
|     [x] Human parainfluenza 3     taxid: 11216     [species]  |
+---------------------------------------------------------------+
```

- **Checkbox**: `NSButton` with checkbox style, controls `isEnabled` on the entry
  - Unchecking a taxon excludes it from extraction but keeps it in the collection
  - Provides quick "I want respiratory viruses except RSV" workflow
- **Taxon name**: `.body` system font, primary label color
  - If the taxon is found in the current classification result, name is in regular weight
  - If the taxon is NOT found (0 reads), name is in secondary label color with strikethrough
- **Tax ID**: `.caption` monospaced font, tertiary label color
- **Rank badge**: `.caption` font, rounded rect background in `.quaternarySystemFill`

#### Column Layout for Outline View

| Column | ID | Width | Alignment |
|--------|----|-------|-----------|
| Disclosure + Icon + Name | `name` | flexible (min 200) | left |
| Tax ID | `taxId` | 80pt fixed | right |
| Rank | `rank` | 60pt fixed | center |
| Match Status | `match` | 40pt fixed | center |
| Action | `action` | 70pt fixed | right |

The "Match Status" column shows a small indicator of whether this taxon was detected in the current classification:
- Green circle (`circle.fill` in `.systemGreen`): Detected, with read count tooltip
- Gray circle (`circle` in `.tertiaryLabel`): Not detected
- This provides immediate visual feedback about which taxa in a collection are present in the sample

### 5.4 Empty States

#### No collections exist for selected scope

```
+---------------------------------------------------------------+
|                                                               |
|              [square.stack.3d.up]                              |
|                                                               |
|         No collections in this scope                          |
|                                                               |
|    Create a new collection or switch to a different scope     |
|                                                               |
|              [+ Create Collection]                             |
|                                                               |
+---------------------------------------------------------------+
```

#### Search yields no results

```
+---------------------------------------------------------------+
|                                                               |
|         No collections match "xyz"                            |
|                                                               |
+---------------------------------------------------------------+
```

---

## 6. Interaction Design

### 6.1 Toggle Behavior

**Entry points for opening the drawer:**
1. **Action bar button**: A new "Collections" button added to the left side of `TaxonomyActionBar`, with SF Symbol `rectangle.stack`
2. **View menu**: "View > Taxa Collections" menu item with keyboard shortcut Cmd-Shift-T
3. **Context menu**: Right-clicking a taxon in the sunburst or table includes "Add to Collection..." which opens the drawer if closed

**Toggle animation:**
- Same 0.25s ease-in-ease-out constraint animation as the annotation drawer
- `splitView.bottomAnchor` constraint target changes from `actionBar.topAnchor` to `drawerDividerView.topAnchor`
- The drawer slides up from behind the action bar

**State persistence:**
- `UserDefaults("taxaCollectionsDrawerOpen")` stores whether the drawer was open when the user last viewed a taxonomy result
- On next taxonomy display, drawer auto-opens if it was previously open

### 6.2 Collection Selection

- **Single-click** on a collection row: Selects it (blue highlight), shows its taxa if expanded
- **Double-click** on a collection row: Toggles expanded/collapsed state
- **Click "Extract" button**: Initiates batch extraction for all enabled taxa in that collection

Selection does NOT affect the sunburst/table selection. The two are independent -- the drawer is for defining extraction targets, not for navigation.

### 6.3 Extract Action

When the user clicks "Extract" on a collection:

1. The "Extract" button transforms into a mini progress bar (determinate, same width)
2. For each enabled taxon in the collection, the system:
   a. Checks if the taxon exists in the current classification result (has reads > 0)
   b. Skips taxa with 0 reads (logs a skip message)
   c. Creates a `TaxonomyExtractionConfig` for each taxon with reads
   d. Registers a batch operation in `OperationCenter` with title "Extract [Collection Name]"
3. The extraction pipeline processes each taxon sequentially (to avoid I/O contention on the source FASTQ)
4. Progress updates in the Operations Panel show per-taxon progress within the batch:
   - "Extracting Influenza A virus (1 of 8)..."
   - "Extracting RSV (2 of 8)..."
5. On completion:
   - Each taxon's reads are in their own `.lungfishfastq` bundle
   - All bundles appear in the sidebar under the parent FASTQ
   - A summary notification: "Extracted 8 taxa from Respiratory Viruses (12,345 total reads)"
6. The "Extract" button returns to its normal state

**Error handling:**
- If extraction fails for one taxon, the others continue
- Failed taxa are reported in the Operations Panel
- The user can retry individual taxa via the taxonomy table's right-click menu

### 6.4 "Add to Collection" Flow (From Taxonomy Table/Sunburst)

Right-clicking a taxon in the taxonomy table or sunburst chart gains a new context menu section:

```
Extract Sequences for E. coli...
Extract Sequences for E. coli and Children...
---
Add to Collection >
    [+] New Collection...
    ---
    [App] My Surveillance Panel        (adds to existing)
    [Project] Sample 42 Targets        (adds to existing)
---
Copy Taxon Name
```

Selecting "New Collection..." opens the New Collection sheet (section 6.5) with the clicked taxon pre-populated.

Selecting an existing collection adds the taxon immediately with a brief "Added" confirmation (inline toast, not modal alert).

### 6.5 "New Collection" Flow

Triggered by:
- The "+ New Collection" button in the drawer header
- "Add to Collection > New Collection..." from a context menu

**Presentation**: Sheet attached to the main window (not a popover -- the form has enough fields to warrant a sheet). Uses `NSHostingController` wrapping a SwiftUI view, matching the `TaxonomyExtractionSheet` pattern.

```
+------------------------------------------+
| New Taxa Collection                      |
+------------------------------------------+
|                                          |
| Name:     [________________________]     |
|                                          |
| Icon:     [lungs.fill    ] [Change...]   |
|           (SF Symbol picker popover)     |
|                                          |
| Scope:    ( ) App-wide                   |
|           ( ) Project-specific           |
|                                          |
| Description:                             |
| [____________________________________]   |
| [____________________________________]   |
|                                          |
+------------------------------------------+
| Taxa:                                    |
| +--------------------------------------+ |
| | [x] E. coli (taxid: 562)    [Remove]| |
| | [x] Salmonella (taxid: 590) [Remove]| |
| |                                      | |
| | Search: [________________________]   | |
| | (type to search current taxonomy)    | |
| |                                      | |
| | Or enter tax ID: [_______] [+ Add]  | |
| +--------------------------------------+ |
+------------------------------------------+
|                  [Cancel]  [Create]      |
+------------------------------------------+
```

**Taxa picker** within the sheet:
- A search field that queries the current classification result's taxonomy tree
- Results appear in a dropdown list below the search field
- Clicking a result adds it to the taxa list
- Manual tax ID entry for taxa not in the current result (e.g., a surveillance target that is absent from this sample)
- Drag-and-drop from the taxonomy table into the sheet (via `NSPasteboardWriting` on `TaxonNode`)

**Sheet dimensions**: 480 x 520pt (fixed width, height adjusts to content)

### 6.6 Collection Editing

For user-defined collections (app-wide or project-specific):

**Right-click context menu on a collection row:**
```
Edit Collection...
Duplicate Collection
---
Export as JSON...
---
Delete Collection
```

**"Edit Collection..."**: Opens the same sheet as "New Collection" but pre-populated with the existing data. Title changes to "Edit Taxa Collection". The "Create" button becomes "Save".

**Inline editing shortcuts:**
- Right-clicking a taxon within an expanded collection:
  ```
  Remove from Collection
  Toggle Include Children
  ---
  Copy Taxon Name
  Copy Tax ID
  ```
- Drag-and-drop reordering of taxa within a collection (optional, low priority)

**Built-in collections:**
- Cannot be edited or deleted
- Right-click menu only shows:
  ```
  Duplicate to App-wide Collection
  Duplicate to Project Collection
  ---
  Export as JSON...
  ```
- This allows users to create editable copies of built-in collections

### 6.7 Keyboard Navigation

| Key | Action |
|-----|--------|
| Up/Down Arrow | Navigate collection list |
| Right Arrow | Expand selected collection |
| Left Arrow | Collapse selected collection |
| Space | Toggle checkbox on selected taxon |
| Return | Execute Extract for selected collection |
| Delete | Remove selected taxon from collection (user-defined only) |
| Cmd-N | New collection (when drawer is focused) |
| Cmd-Shift-T | Toggle drawer open/closed (global) |
| Tab | Move focus between scope filter, search field, and list |

### 6.8 Drag and Drop

| Source | Target | Action |
|--------|--------|--------|
| Taxon row in taxonomy table | Collection in drawer | Add taxon to collection |
| Taxon row in taxonomy table | Empty area in drawer | Open "New Collection" with taxon pre-populated |
| Collection JSON file from Finder | Drawer | Import collection |

Drag types:
- `TaxonNode` exports as a custom `NSPasteboardType` containing `{ taxId: Int, name: String, rank: String }`
- Collection JSON files use `UTType.json`

---

## 7. Visual Design

### 7.1 Color and Typography

All colors use the system semantic palette per macOS HIG:

| Element | Color | Font |
|---------|-------|------|
| Drawer title | `.labelColor` | `.headline` (13pt bold) |
| Collection name | `.labelColor` | `.body` (13pt regular) |
| Collection name (selected) | `.selectedTextColor` on `.selectedContentBackgroundColor` | `.body` (13pt medium) |
| Taxa count badge | `.secondaryLabelColor` | `.caption` (10pt) |
| Taxon name (detected) | `.labelColor` | `.body` (13pt) |
| Taxon name (not detected) | `.tertiaryLabelColor` | `.body` (13pt) with strikethrough |
| Tax ID | `.tertiaryLabelColor` | `.caption` monospaced (10pt) |
| Scope badge "App" | `.systemBlue` background, white text | `.caption2` (9pt bold) |
| Scope badge "Project" | `.systemOrange` background, white text | `.caption2` (9pt bold) |
| Scope badge "Built-in" | `.quaternarySystemFill` background, secondary text | `.caption2` (9pt bold) |
| Drawer background | `.windowBackgroundColor` | -- |
| Divider handle | `.separatorColor` line + `.tertiaryLabelColor` grip dots | -- |

### 7.2 SF Symbols

| Purpose | Symbol | Size |
|---------|--------|------|
| Built-in collection icons | Domain-specific (see built-in table) | 14pt |
| User collection default icon | `square.stack.3d.up` | 14pt |
| New Collection button | `plus.circle` | 12pt |
| Import button | `square.and.arrow.down` | 12pt |
| Detected taxon indicator | `circle.fill` (green) | 8pt |
| Not-detected indicator | `circle` (gray) | 8pt |
| Scope filter: Built-in | `lock.fill` | 10pt |
| Scope filter: App-wide | `building.2` | 10pt |
| Scope filter: Project | `doc` | 10pt |
| Drag handle grip lines | Custom draw (3 horizontal lines) | -- |
| Toggle drawer button | `rectangle.stack` | 12pt |

### 7.3 Accessibility

| Requirement | Implementation |
|-------------|----------------|
| VoiceOver | All controls have `setAccessibilityLabel` / `setAccessibilityRole` |
| Outline view | Uses standard `NSOutlineView` which provides VoiceOver tree semantics automatically |
| Checkboxes | Labeled with "Enable [taxon name] for extraction" |
| Extract buttons | Labeled with "Extract all taxa in [collection name]" |
| Scope filter | Segmented control with per-segment accessibility labels |
| Color independence | Detection status uses both color AND icon shape (filled vs. outline circle) |
| Keyboard | Full keyboard navigation as specified in section 6.7 |
| Dynamic Type | Uses system font styles that respect user's text size preference |
| Reduced Motion | Drawer toggle respects `NSWorkspace.shared.accessibilityDisplayShouldReduceMotion` -- instant show/hide if true |

---

## 8. Persistence

### 8.1 Built-in Collections

Stored as a JSON file bundled in `LungfishApp/Resources/built-in-taxa-collections.json`:

```json
[
  {
    "id": "respiratory-viruses",
    "name": "Respiratory Viruses",
    "icon": "lungs.fill",
    "description": "Common respiratory viral pathogens including influenza, RSV, and coronaviruses",
    "taxa": [
      { "taxId": 11320, "name": "Influenza A virus", "rank": "species", "includeChildren": true },
      { "taxId": 11520, "name": "Influenza B virus", "rank": "species", "includeChildren": true }
    ]
  }
]
```

### 8.2 App-wide Collections

Stored in `~/Library/Application Support/Lungfish/taxa-collections/` as individual JSON files, one per collection. File naming: `<UUID>.json`.

The directory is created on first write. Collections are loaded lazily when the drawer opens.

### 8.3 Project-specific Collections

Stored in `<project>.lungfish/taxa-collections/` following the same format. Loaded when a project is opened.

### 8.4 Import/Export Format

The JSON format is the same for all tiers (minus the `scope` field, which is determined by where the file is saved). This means:
- Users can export a built-in collection and import it as an app-wide collection
- Users can share collections with colleagues as JSON files
- The CLI (`lungfish extract --collection respiratory-viruses.json`) can also consume these files

---

## 9. Action Bar Modifications

The existing `TaxonomyActionBar` (36pt) gains one new button on the left side:

### Updated Action Bar Layout

```
+---------------------------------------------------------------+
| [Collections] |  E. coli -- 1,234 reads (12.3%)  | [Extract] |
+---------------------------------------------------------------+
```

- **Collections button**: `NSButton` with SF Symbol `rectangle.stack` and title "Collections"
  - Bezel style: `.accessoryBarAction`
  - Toggles the drawer open/closed
  - Visual state indicator: when drawer is open, the button appears pressed (`.state = .on`)
  - Position: left side, before the info label
  - Keyboard shortcut: Cmd-Shift-T (also wired in View menu)

The existing info label and Extract button remain unchanged, shifted slightly right to accommodate the new button.

---

## 10. Integration Points

### 10.1 TaxonomyViewController Changes

New instance variables:
- `taxaCollectionsDrawerView: TaxaCollectionsDrawerView?`
- `taxaCollectionsDrawerBottomConstraint: NSLayoutConstraint?`
- `taxaCollectionsDrawerHeightConstraint: NSLayoutConstraint?`
- `isTaxaCollectionsDrawerOpen: Bool`
- `drawerDividerView: TaxaCollectionsDividerView?`

New methods:
- `toggleTaxaCollectionsDrawer()` -- mirrors `toggleAnnotationDrawer()` in ViewerViewController
- `configureTaxaCollectionsDrawer()` -- creates and constraints the drawer, called on first toggle

Layout change in `layoutSubviews()`:
- The `splitView.bottomAnchor` constraint target changes dynamically based on drawer state
- When drawer exists: `splitView.bottomAnchor == drawerDividerView.topAnchor`
- When drawer hidden: `splitView.bottomAnchor == actionBar.topAnchor` (original)

### 10.2 TaxonomyActionBar Changes

New callback:
- `onToggleCollections: (() -> Void)?` -- fired when the Collections button is clicked

New subview:
- `collectionsButton: NSButton` -- left-aligned, before the info label

### 10.3 Extraction Pipeline Integration

The drawer's "Extract" action for a collection creates a **batch extraction**. This is different from the existing single-taxon extraction flow:

Current flow (single taxon):
1. User clicks "Extract Sequences" in action bar
2. `TaxonomyExtractionSheet` presented
3. User confirms
4. Single `TaxonomyExtractionConfig` created
5. Single operation registered in `OperationCenter`

New flow (batch from collection):
1. User clicks "Extract" on a collection row in the drawer
2. Confirmation popover (not a full sheet) shows:
   - Collection name
   - Number of taxa with reads (e.g., "8 of 12 taxa detected in this sample")
   - Estimated total reads
   - "Include children" toggle (default: per-entry setting)
   - [Cancel] [Extract All]
3. On confirm, one `OperationCenter` operation is registered for the batch
4. The pipeline processes taxa sequentially, updating progress per-taxon
5. Each taxon produces its own `.lungfishfastq` bundle

### 10.4 Context Menu Extension

`TaxonomyViewController.showContextMenu(for:at:)` gains a new "Add to Collection" submenu after the existing extract items:

```
Extract Sequences for E. coli...
Extract Sequences for E. coli and Children...
---
Add to Collection >              <-- NEW
---
Copy Taxon Name
Copy Taxonomy Path
```

### 10.5 View Menu Integration

`MainMenu.swift` gains a new item in the View menu:

```
View
  ...
  Show/Hide Inspector            Cmd-I
  Show/Hide Annotations          Cmd-Shift-A
  Show/Hide Taxa Collections     Cmd-Shift-T    <-- NEW
  ...
```

The menu item title toggles between "Show" and "Hide" based on drawer state, following the same pattern as the annotation drawer menu item.

---

## 11. State Management

### 11.1 TaxaCollectionManager

A singleton (or per-document) manager that loads, caches, and persists collections:

```
TaxaCollectionManager
    builtInCollections: [TaxaCollection]       -- loaded once from bundle
    appWideCollections: [TaxaCollection]        -- loaded from ~/Library/...
    projectCollections: [TaxaCollection]        -- loaded from project dir

    func allCollections() -> [TaxaCollection]
    func collections(for scope: CollectionScope) -> [TaxaCollection]
    func save(_ collection: TaxaCollection)
    func delete(_ collection: TaxaCollection)
    func importCollection(from url: URL, scope: CollectionScope) throws
    func exportCollection(_ collection: TaxaCollection, to url: URL) throws
```

### 11.2 Match Status Computation

When the drawer opens or the classification result changes, the drawer computes a match status for each taxon entry against the current `TaxonTree`:

```
for entry in collection.taxa {
    let node = tree.findNode(taxId: entry.taxId)
    entry.matchedReadCount = node?.readsClade ?? 0
    entry.isDetected = (node?.readsClade ?? 0) > 0
}
```

This is a lightweight operation (dictionary lookup per entry) and runs synchronously on the main thread. No background dispatch needed.

---

## 12. Testing Strategy

### Unit Tests

| Test | Description |
|------|-------------|
| `TaxaCollectionManagerTests` | Load/save/delete for all three scopes |
| `TaxaCollectionJSONTests` | Round-trip serialization of collections |
| `TaxaCollectionMatchTests` | Match status computation against mock TaxonTree |
| `TaxaCollectionFilterTests` | Scope and search filtering logic |

### UI Tests (via XCTest + NSOutlineView assertions)

| Test | Description |
|------|-------------|
| `testDrawerToggle` | Drawer opens/closes with animation; constraints update correctly |
| `testDrawerResize` | Drag handle changes height; height persisted to UserDefaults |
| `testCollectionExpand` | Expanding a collection shows its taxa entries |
| `testCheckboxToggle` | Unchecking a taxon updates `isEnabled`; re-checking restores |
| `testExtractButton` | Clicking Extract creates correct batch config |
| `testScopeFilter` | Selecting "App-wide" hides built-in and project collections |
| `testSearchFilter` | Typing "influenza" filters to collections containing influenza taxa |
| `testContextMenuAddToCollection` | Right-click taxon > Add to Collection adds correctly |
| `testBuiltInReadOnly` | Built-in collections cannot be edited or deleted |
| `testNewCollectionSheet` | Sheet opens, accepts input, saves collection |

### Integration Tests

| Test | Description |
|------|-------------|
| `testBatchExtraction` | Extract a 3-taxon collection; verify 3 bundles created |
| `testSkipZeroReadTaxa` | Collection with 5 taxa, 2 have 0 reads; verify only 3 extracted |
| `testProjectCollectionPersistence` | Save project collection; close/reopen project; verify loaded |

---

## 13. Performance Considerations

- **Collection loading**: Built-in collections are small (< 100 entries total) and loaded synchronously. No performance concern.
- **Match status**: Dictionary lookup in `TaxonTree` is O(1) per entry. Even 100 entries is negligible.
- **Drawer animation**: Standard Auto Layout constraint animation. No custom drawing during animation.
- **NSOutlineView**: Maximum ~50-100 rows visible at once (collections + expanded taxa). No virtualization concerns.
- **Batch extraction I/O**: Sequential processing (one taxon at a time) prevents I/O contention. Each extraction reads the source FASTQ once and the classification output once. The pipeline's progress callback rate is already throttled.

---

## 14. Migration and Backward Compatibility

- No existing data is affected. The drawer is purely additive.
- Projects created before this feature will have no project-specific collections (empty state).
- The classification result data model (`ClassificationResult`, `TaxonTree`, `TaxonNode`) is unchanged.
- The existing single-taxon extraction flow via `TaxonomyExtractionSheet` remains fully functional.

---

## 15. Open Questions for Stakeholder Review

1. **Collection sharing**: Should there be a "Share Collection" button that creates a sharable link or file? Or is JSON export sufficient?

2. **NCBI Taxonomy ID validation**: When manually entering a tax ID in the "New Collection" sheet, should we validate against an NCBI taxonomy database? This would require network access or a local taxonomy dump.

3. **Collection versioning**: If a built-in collection is updated in a new app version, should we notify users who duplicated it? Or keep duplicates independent?

4. **Multi-classifier support**: The current design uses NCBI tax IDs, which are classifier-agnostic. However, should we display classifier-specific read counts (e.g., "Kraken2: 1,234 reads" vs. "STAT: 1,567 reads") if multiple classification results exist for the same sample?

5. **Batch extraction parallelism**: The current design processes taxa sequentially to avoid I/O contention. Should we offer a preference to process N taxa in parallel for users with fast storage (NVMe)?

---

## 16. Implementation Phases

### Phase 1: Core Drawer (MVP)
- `TaxaCollectionsDrawerView` with divider, scope filter, collection list
- Built-in collections (6 pre-defined sets)
- Drawer toggle via action bar button and View menu
- Expand/collapse collections to see taxa
- Match status indicators
- Single-collection Extract action
- Height persistence

### Phase 2: User Collections
- "New Collection" sheet
- App-wide collection persistence
- Project-specific collection persistence
- "Edit Collection" and "Delete Collection"
- "Duplicate Collection" (built-in to user-defined)

### Phase 3: Integration and Polish
- "Add to Collection" context menu in taxonomy table/sunburst
- Drag-and-drop from taxonomy table to drawer
- Import/Export JSON
- Keyboard navigation
- Accessibility audit
- VoiceOver testing
- Reduced motion support

---

## Appendix A: Precedent Analysis (Existing Drawer Patterns)

### AnnotationTableDrawerView (ViewerViewController+AnnotationDrawer.swift)

| Aspect | Implementation |
|--------|----------------|
| Default height | 250pt |
| Min height | 100pt (`max(100, ...)` in drag handler) |
| Max height | 70% of parent (`view.bounds.height * 0.7`) |
| Animation duration | 0.25s ease-in-ease-out |
| Height persistence | `UserDefaults("annotationDrawerHeight")` |
| Toggle method | `toggleAnnotationDrawer()` |
| Constraint pattern | Bottom constraint constant = height (hidden) or 0 (visible) |
| Divider | `DrawerDividerView` with 3 grip lines |
| Debounce | 300ms via `_drawerHeightSaveWorkItem` |

### FASTQMetadataDrawerView (ViewerViewController+FASTQDrawer.swift)

| Aspect | Implementation |
|--------|----------------|
| Default height | 360pt |
| Min height | 150pt |
| Max height | 70% of parent |
| Animation duration | 0.2s ease-in-ease-out |
| Height persistence | `UserDefaults("fastqMetadataDrawerHeight")` |
| Toggle method | `toggleFASTQMetadataDrawer()` |
| Constraint pattern | Same as annotation drawer |
| Divider | `FASTQDrawerDividerView` (identical to `DrawerDividerView`) |

### Taxa Collections Drawer (this design)

| Aspect | Implementation |
|--------|----------------|
| Default height | 220pt |
| Min height | 140pt |
| Max height | 50% of parent |
| Animation duration | 0.25s ease-in-ease-out |
| Height persistence | `UserDefaults("taxaCollectionsDrawerHeight")` |
| Toggle method | `toggleTaxaCollectionsDrawer()` on `TaxonomyViewController` |
| Constraint pattern | Same as annotation drawer |
| Divider | `TaxaCollectionsDividerView` (identical pattern) |

---

## Appendix B: File Structure (Anticipated)

```
Sources/LungfishApp/
    Views/Metagenomics/
        TaxaCollectionsDrawerView.swift          -- Main drawer NSView
        TaxaCollectionsDividerView.swift         -- Drag-to-resize handle
        TaxaCollectionListView.swift             -- NSOutlineView + data source
        TaxaCollectionRowView.swift              -- Custom row rendering
        TaxaCollectionNewSheet.swift             -- SwiftUI "New Collection" sheet
        TaxaCollectionConfirmPopover.swift        -- Batch extract confirmation
        TaxonomyViewController+Collections.swift -- Extension wiring drawer to VC

Sources/LungfishCore/
    Models/
        TaxaCollection.swift                     -- Data model + Codable
        TaxaCollectionManager.swift              -- Load/save/scope management

Sources/LungfishApp/Resources/
    built-in-taxa-collections.json               -- Bundled built-in collections

Tests/LungfishCoreTests/
    TaxaCollectionTests.swift
    TaxaCollectionManagerTests.swift

Tests/LungfishAppTests/
    TaxaCollectionsDrawerTests.swift
    TaxaCollectionNewSheetTests.swift
```
