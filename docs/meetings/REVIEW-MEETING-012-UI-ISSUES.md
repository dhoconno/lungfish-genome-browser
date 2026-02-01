# Expert Review Meeting #012: UI Functionality Issues
## User Feedback Analysis and Remediation Plan

**Date:** 2026-02-01
**Phase:** UI Integration Review
**Status:** IN PROGRESS

---

## Meeting Participants

### Present
- **Role 1: Swift Architecture Lead** - Overall architecture review
- **Role 2: UI/UX Lead - HIG Expert** - UI behavior assessment
- **Role 3: Sequence Viewer Specialist** - Viewer functionality
- **Role 19: Testing & QA Lead** - UI testing strategy

---

## User Feedback Summary

The user launched the app and reported:
1. **Drag-and-drop doesn't work** - Dragging a FASTA file into the viewer does nothing
2. **Sequence viewer is empty** - Shows placeholder text "Drop files here or use File > Open"
3. **No visible sequence data** - Even after attempting to load files

Screenshot analysis shows:
- Three-pane layout renders correctly
- Sidebar shows expected structure (Favorites, Project sections)
- Track labels show (Reference, Genes, Coverage)
- Status bar is present but shows no data

---

## Root Cause Analysis

### Issue 1: Drag-and-Drop Not Implemented

**Finding:** The `SequenceViewerView` class does not implement `NSDraggingDestination` protocol.

**Code Reference:** [ViewerViewController.swift:161-217](Sources/LungfishApp/Views/Viewer/ViewerViewController.swift#L161-L217)

```swift
public class SequenceViewerView: NSView {
    // Missing:
    // - registerForDraggedTypes()
    // - draggingEntered()
    // - performDragOperation()
}
```

**Required Changes:**
1. Register for dragged file types (FASTA, GenBank, etc.)
2. Implement `NSDraggingDestination` protocol
3. Call document loading when files are dropped

### Issue 2: Document Opening Not Implemented

**Finding:** `AppDelegate.openDocument(at:)` only prints and returns true - it doesn't actually load the file.

**Code Reference:** [AppDelegate.swift:101-106](Sources/LungfishApp/App/AppDelegate.swift#L101-L106)

```swift
private func openDocument(at url: URL) -> Bool {
    // TODO: Implement document opening
    // For now, just return true to indicate we handled it
    print("Opening document: \(url.path)")
    return true
}
```

**Required Changes:**
1. Detect file type from extension
2. Use appropriate reader (FASTAReader, GenBankReader, etc.)
3. Create document model
4. Pass to viewer for display

### Issue 3: Sequence Viewer Rendering Not Connected

**Finding:** The viewer has no way to receive sequence data. It only displays a placeholder.

**Code Reference:** [ViewerViewController.swift:165-193](Sources/LungfishApp/Views/Viewer/ViewerViewController.swift#L165-L193)

The `SequenceViewerView.draw()` method only draws placeholder text - there's no code to render actual sequence data.

**Required Changes:**
1. Add `setSequence()` method to `SequenceViewerView`
2. Implement sequence rendering at various zoom levels
3. Connect tracks to data sources

### Issue 4: No Document State Management

**Finding:** There's no central document state that connects file loading to UI display.

**Required Changes:**
1. Create document model that holds loaded sequences
2. Implement observer pattern for UI updates
3. Connect sidebar, viewer, and inspector to document state

---

## Prioritized Fix Plan

### Priority 1: Basic File Loading (Critical)
1. Implement `openDocument(at:)` with actual file parsing
2. Create document state management
3. Display loaded sequence in viewer

### Priority 2: Drag-and-Drop Support (High)
1. Implement `NSDraggingDestination` in `SequenceViewerView`
2. Support FASTA, GenBank, GFF3 file types

### Priority 3: Sequence Rendering (High)
1. Replace placeholder with actual sequence rendering
2. Support zoom levels (overview → base-level)
3. Connect to ReferenceFrame coordinate system

### Priority 4: Track System Integration (Medium)
1. Create track data source connections
2. Render sequence track with bases
3. Render annotation tracks

---

## UI Testing Strategy

### Option 1: XCUITest (Apple's Framework)
- Pros: Native, reliable, CI/CD friendly
- Cons: Requires separate test target, limited to what accessibility exposes

### Option 2: MCP Server for UI Automation
- Could create custom MCP server using:
  - `pyautogui` for mouse/keyboard simulation
  - `Accessibility` framework for element queries
- Would require:
  - MCP server implementation
  - UI element accessibility identifiers

### Option 3: AppleScript/Accessibility API
- Use macOS Accessibility API directly
- Script-based testing

### Recommendation
**Use XCUITest** for automated testing as it's the standard macOS approach. Additionally, add comprehensive accessibility identifiers to enable screen reader testing and potential MCP automation.

---

## Accessibility Requirements

Per the screenshot, the app should be VoiceOver accessible. Current gaps:

1. **Missing accessibility identifiers** on key views
2. **Missing accessibility labels** for custom views
3. **No rotor navigation** setup for sequence regions

**Required Additions:**
```swift
// Example for SequenceViewerView
view.setAccessibilityElement(true)
view.setAccessibilityRole(.group)
view.setAccessibilityLabel("Sequence viewer")
view.setAccessibilityIdentifier("sequence-viewer")
```

---

## Action Items

| # | Action | Owner | Priority |
|---|--------|-------|----------|
| 1 | Implement document loading pipeline | Role 1 | Critical |
| 2 | Implement drag-and-drop | Role 2 | High |
| 3 | Implement sequence rendering | Role 3 | High |
| 4 | Add accessibility identifiers | Role 2 | High |
| 5 | Create XCUITest target | Role 19 | Medium |
| 6 | Document state management | Role 1 | Critical |

---

## Technical Approach

### Document Loading Pipeline

```
User Action (Open/Drop)
        ↓
    AppDelegate
        ↓
    FileTypeDetector
        ↓
    Appropriate Reader (FASTAReader, etc.)
        ↓
    Document Model
        ↓
    DocumentManager (shared state)
        ↓
    UI Update Notifications
        ↓
    ViewerViewController receives sequence
        ↓
    SequenceViewerView renders
```

### Sequence Display Architecture

```swift
// New protocol for sequence display
protocol SequenceDisplayable {
    var sequence: Sequence { get }
    var annotations: [SequenceAnnotation] { get }
}

// ViewerViewController addition
func displayDocument(_ document: SequenceDisplayable) {
    // Update reference frame
    // Set sequence on viewer
    // Trigger redraw
}
```

---

## Next Steps

1. Implement fixes in priority order
2. Add XCUITest target for regression testing
3. Verify with VoiceOver
4. Re-test with user

**Meeting Adjourned - Implementation to Begin**
