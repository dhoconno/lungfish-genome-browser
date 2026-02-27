# Amino Acid Translation Support — Implementation Plan

## Summary

Add amino acid translation to the Document Viewer: a translation track below the nucleotide sequence, full translation display in the Inspector with copy support, a Geneious-style multi-frame translation tool, and multi-sequence translation toggle.

---

## Phase 1: Core Translation Engine (LungfishCore)

Move/consolidate translation logic from LungfishPlugin into LungfishCore so the app can use it directly without the plugin layer.

### 1.1 Create `Sources/LungfishCore/Translation/CodonTable.swift`
- Move `CodonTable` struct and the three private translation dictionaries (`standardTranslations`, `vertebrateMitoTranslations`, `yeastMitoTranslations`) from `TranslationPlugin.swift`
- Keep all four tables: standard, vertebrate_mito, bacterial, yeast_mito
- All methods: `translate(_:)`, `isStartCodon(_:)`, `isStopCodon(_:)`, `table(named:)`, `table(id:)`

### 1.2 Create `Sources/LungfishCore/Translation/AminoAcidColors.swift`
- `AminoAcidColorScheme` enum with `.zappo` (default), `.clustal`, `.taylor`, `.hydrophobicity`
- Each scheme: `func color(for aminoAcid: Character) -> (red: Double, green: Double, blue: Double)`
- Zappo scheme: aliphatic(AILMFWV)=salmon, aromatic(FWY)=orange, positive(KRH)=blue, negative(DE)=red, hydrophilic(STNQ)=green, special(PG)=magenta, cysteine(C)=yellow

### 1.3 Create `Sources/LungfishCore/Translation/TranslationResult.swift`
```swift
public struct TranslationResult: Sendable {
    public let protein: String
    public let codingSequence: String  // concatenated exon nucleotides
    public let aminoAcidPositions: [AminoAcidPosition]
    public let codonTable: CodonTable
    public let phaseOffset: Int
}

public struct AminoAcidPosition: Sendable {
    public let index: Int
    public let aminoAcid: Character
    public let codon: String
    public let genomicRanges: [(start: Int, end: Int)]  // usually 1, 2 if codon spans intron
    public let isStart: Bool
    public let isStop: Bool
}
```

### 1.4 Create `Sources/LungfishCore/Translation/TranslationEngine.swift`
Pure `Sendable` struct with static methods:
- `translate(_:offset:table:showStopAsAsterisk:trimToFirstStop:) -> String` — basic nucleotide→protein
- `reverseComplement(_:) -> String`
- `translateCDS(annotation:sequenceProvider:table:) -> TranslationResult?` — handles discontiguous CDS:
  1. Sort intervals by start (ascending for forward strand, descending for reverse)
  2. Extract nucleotides for each interval via `sequenceProvider` closure
  3. Apply phase from first interval's `.phase` or `codon_start` qualifier
  4. Concatenate exon sequences, reverse-complement if reverse strand
  5. Translate and build `AminoAcidPosition` coordinate mapping
- `translateFrames(_:sequence:table:) -> [(ReadingFrame, String)]` — multi-frame translation

### 1.5 Modify `Sources/LungfishCore/Models/SequenceAlphabet.swift`
- Replace the 3-frame `ReadingFrame` enum (lines 88-95) with a 6-frame version:
  - Cases: `.plus1`, `.plus2`, `.plus3`, `.minus1`, `.minus2`, `.minus3`
  - Properties: `.offset` (0/1/2), `.isReverse`, `.forwardFrames`, `.reverseFrames`
- Update existing call sites (SequenceTrack.swift uses `translationFrames: [Int]` — change to `[ReadingFrame]`)

### 1.6 Modify `Sources/LungfishPlugin/BuiltIn/TranslationPlugin.swift`
- Remove `CodonTable`, translation tables, and `translate()` method (now in LungfishCore)
- Import from LungfishCore and delegate: `TranslationEngine.translate(...)`, `TranslationEngine.reverseComplement(...)`

### 1.7 Modify `Sources/LungfishPlugin/BuiltIn/ORFFinderPlugin.swift`
- Remove local `ReadingFrame` enum (lines 240-274)
- Import `ReadingFrame` from LungfishCore

### 1.8 Write tests: `Tests/LungfishCoreTests/TranslationEngineTests.swift`
- Basic translation (standard table)
- Alternative codon tables
- Six reading frames
- Discontiguous CDS: 3-exon gene with introns, verify correct protein and coordinate mapping
- Phase offset handling (phase 0, 1, 2)
- Reverse strand CDS
- Edge cases: stop codons, partial codons, single-exon CDS
- AminoAcidColorScheme: every amino acid returns valid color

---

## Phase 2: Inspector Translation Display

### 2.1 Modify `Sources/LungfishApp/Views/Inspector/Sections/SelectionSection.swift`

**SelectionSectionViewModel** additions:
- `fullTranslation: String?` — full amino acid sequence (not truncated)
- `onShowTranslation: ((SequenceAnnotation) -> Void)?` — callback to show translation track in viewer
- `isTranslationVisible: Bool = false` — tracks whether translation track is showing

**`extractEnrichment(from:)`** changes (line 189-191):
- Store full translation in `fullTranslation` instead of truncating
- Still show truncated preview in `qualifierPairs` for the general list

**SelectionSection SwiftUI view** additions (after qualifier pairs, before delete button):
- When `type == .cds` or `fullTranslation != nil`:
  - "Translation" `DisclosureGroup`:
    - Full amino acid sequence in a scrollable `Text` with `.textSelection(.enabled)` and monospaced font
    - "Copy Translation" button (copies `fullTranslation` to pasteboard)
    - "Translate in Viewer" toggle button → calls `onShowTranslation?(annotation)`
    - If no stored translation: "Translate from Sequence" button (compute on-the-fly)

### 2.2 Wire callbacks through InspectorViewController → ViewerViewController
- InspectorViewController sets `viewModel.onShowTranslation` to forward to `ViewerViewController.showCDSTranslation(for:)`

---

## Phase 3: Translation Track Rendering

### 3.1 Create `Sources/LungfishApp/Views/Viewer/TranslationTrackRenderer.swift`

Static rendering methods:

**`drawCDSTranslation(result:frame:context:yOffset:trackHeight:colorScheme:)`**
- For each `AminoAcidPosition` whose genomic ranges overlap the visible window:
  - Calculate screen X from `frame.screenPosition(for:)`
  - Fill colored rectangle (amino acid color from scheme)
  - If `pixelsPerBase >= 8`: draw single-letter code centered, white text
  - For intron-spanning codons: draw two rectangles + thin connector line
  - Stop codons: dark rectangle with `*`
  - Start codons (M): optional green indicator
  - Thin vertical separators between codons

**`drawFrameTranslations(frames:sequence:frame:context:yOffset:trackHeight:table:colorScheme:)`**
- For each frame, translate visible portion of sequence on-the-fly
- Draw each frame as a sub-track (stacked vertically)
- Left-edge label: "+1", "+2", "+3", "-1", "-2", "-3"

### 3.2 Modify `Sources/LungfishApp/Views/Viewer/ViewerViewController.swift`

**New properties on SequenceViewerView:**
```swift
var showTranslationTrack: Bool = false
var activeTranslationResult: TranslationResult?
var translationColorScheme: AminoAcidColorScheme = .zappo
var frameTranslationFrames: [ReadingFrame] = []  // for tool mode
let translationTrackHeight: CGFloat = 20
```

**Modify `annotationTrackY`** (line 1574):
```swift
private var annotationTrackY: CGFloat {
    var y = trackY + trackHeight + 4
    if showTranslationTrack {
        let numTracks = frameTranslationFrames.isEmpty ? 1 : frameTranslationFrames.count
        y += CGFloat(numTracks) * translationTrackHeight + 4
    }
    return y
}
```

**Modify `drawBundleContent()`** — insert between line 2146 (sequence drawn) and line 2148 (variant fetch):
```swift
// Draw translation track if active and zoomed in enough
if showTranslationTrack && scale < showLettersThreshold {
    let transY = trackY + trackHeight + 4
    if let result = activeTranslationResult {
        TranslationTrackRenderer.drawCDSTranslation(...)
    } else if !frameTranslationFrames.isEmpty, let seq = cachedBundleSequence {
        TranslationTrackRenderer.drawFrameTranslations(...)
    }
}
```

**Modify `drawSequence()`** (line 3220) — insert between sequence rendering and `drawSelectionHighlight`:
- Same translation track rendering for single-sequence mode

**New methods:**
- `showCDSTranslation(for annotation: SequenceAnnotation)` — computes `TranslationResult` via `TranslationEngine.translateCDS()`, sets `activeTranslationResult`, `showTranslationTrack = true`, invalidates tile, triggers redraw
- `hideTranslation()` — clears state
- `applyFrameTranslation(frames: [ReadingFrame], table: CodonTable)` — for tool mode

**Tile invalidation:** When `showTranslationTrack` changes, clear `annotationTile` (line 1642) since annotation Y positions shift.

---

## Phase 4: Annotation Table

### 4.1 Modify `Sources/LungfishApp/Views/Viewer/AnnotationTableDrawerView.swift`

- Add right-click context menu on table rows: "Copy Translation" (only enabled for CDS rows with translation data)
- The translation data comes from the SQLite `AnnotationDatabase` attributes (same source as Inspector enrichment)
- Keep implementation minimal: just a context menu item, not a new column (avoids complexity for now)

---

## Phase 5: Multi-Sequence Translation Toggle

### 5.1 Modify `Sources/LungfishApp/Views/Viewer/MultiSequenceSupport.swift`
- Add `showTranslation: Bool = false` and `translationFrames: [ReadingFrame] = [.plus1, .plus2, .plus3]` to `StackedSequenceInfo`
- Update height calculation to include translation track when enabled

### 5.2 Modify `Sources/LungfishApp/Views/Viewer/SequenceViewerView+MultiSequence.swift`
- In `drawSequenceTrack()`: after drawing sequence bases, before annotation track, insert `TranslationTrackRenderer.drawFrameTranslations()` when `showTranslation == true` and render mode is `.bases`

### 5.3 Add toggle mechanism
- Context menu item on sequence tracks: "Show Translation" / "Hide Translation"
- Global toggle via toolbar or menu: applies to all stacked sequences via `MultiSequenceState`

---

## Phase 6: Translation Tool (Geneious-style)

### 6.1 Create `Sources/LungfishApp/Views/TranslationTool/TranslationToolView.swift`
SwiftUI view with:
- Mode picker: Single Frame, 3 Forward, 3 Reverse, All 6
- Frame picker (single mode only)
- Codon table picker (Standard, Vertebrate Mito, Bacterial, Yeast Mito)
- Options: stop codon display, selection-only toggle
- Color scheme picker
- Cancel / Apply buttons
- Apply → sends configuration to ViewerViewController

### 6.2 Modify `Sources/LungfishApp/Views/MainWindow/MainWindowController.swift`
- Add `translateTool` to `ToolbarIdentifier`
- Add toolbar button with SF symbol `character.textbox` or `text.line.first.and.arrowtriangle.forward`
- `@objc` action opens TranslationToolView as a sheet

### 6.3 Wire Apply action
- TranslationToolView calls callback → ViewerViewController.applyFrameTranslation(frames:table:)
- Sets `frameTranslationFrames`, `showTranslationTrack = true`, invalidates and redraws

---

## Discontiguous CDS Translation — Algorithm Detail

```
Input: CDS annotation with intervals [(100,200), (400,500), (700,800)], forward strand, phase=0

1. Sort intervals: [(100,200), (400,500), (700,800)] (already sorted for forward)
2. Build coding-to-genomic map:
   codingOffset 0..99   → genomic 100..199
   codingOffset 100..199 → genomic 400..499
   codingOffset 200..299 → genomic 700..799
3. Extract nucleotides via sequenceProvider for each interval
4. Concatenate: "ATCG...GCTA...TTAG..." (300 bp total)
5. Apply phase offset 0, translate → 100 amino acids
6. For amino acid at index i:
   codon bases at coding offsets [i*3, i*3+1, i*3+2]
   Map each back to genomic coords via the coding-to-genomic map
   If codon spans boundary (e.g., coding offsets 99,100,101):
     genomicRanges = [(199,200), (400,402)]  // split across intron
```

---

## Files Summary

**Create (7 files):**
1. `Sources/LungfishCore/Translation/CodonTable.swift`
2. `Sources/LungfishCore/Translation/AminoAcidColors.swift`
3. `Sources/LungfishCore/Translation/TranslationResult.swift`
4. `Sources/LungfishCore/Translation/TranslationEngine.swift`
5. `Sources/LungfishApp/Views/Viewer/TranslationTrackRenderer.swift`
6. `Sources/LungfishApp/Views/TranslationTool/TranslationToolView.swift`
7. `Tests/LungfishCoreTests/TranslationEngineTests.swift`

**Modify (9 files):**
1. `Sources/LungfishCore/Models/SequenceAlphabet.swift` — replace ReadingFrame with 6-frame version
2. `Sources/LungfishPlugin/BuiltIn/TranslationPlugin.swift` — delegate to TranslationEngine
3. `Sources/LungfishPlugin/BuiltIn/ORFFinderPlugin.swift` — use unified ReadingFrame
4. `Sources/LungfishApp/Views/Inspector/Sections/SelectionSection.swift` — full translation display
5. `Sources/LungfishApp/Views/Viewer/ViewerViewController.swift` — translation track state + drawing
6. `Sources/LungfishApp/Views/Viewer/AnnotationTableDrawerView.swift` — copy translation context menu
7. `Sources/LungfishApp/Views/Viewer/MultiSequenceSupport.swift` — translation state
8. `Sources/LungfishApp/Views/Viewer/SequenceViewerView+MultiSequence.swift` — translation rendering
9. `Sources/LungfishApp/Views/MainWindow/MainWindowController.swift` — toolbar button

---

## Verification

1. **Unit tests**: Run `swift test --filter TranslationEngine` — verify all core translation logic
2. **Build**: `swift build` — verify no compilation errors, ReadingFrame migration compiles everywhere
3. **Manual test (single sequence)**: Open a GenBank file with CDS features → select CDS → verify Inspector shows full translation with copy → click "Translate in Viewer" → verify amino acid track appears below nucleotide track with correct colors
4. **Manual test (bundle)**: Load a .lungfishref bundle → zoom into a CDS → translate → verify track renders correctly with discontiguous features
5. **Manual test (tool)**: Open translation tool → select 6-frame → apply → verify 6 translation tracks render
6. **Manual test (multi-sequence)**: Load multi-FASTA → toggle translation → verify all sequences show translation tracks
7. **Existing tests**: Run full `swift test` — verify no regressions from ReadingFrame migration
