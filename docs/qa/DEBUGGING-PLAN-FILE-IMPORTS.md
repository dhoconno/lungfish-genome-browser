# Lungfish Genome Browser - File Import Debugging Plan

## Executive Summary

This document outlines an automated debugging strategy for fixing file import and display issues in the Lungfish Genome Browser. The plan uses MCP (Model Context Protocol) servers and automated tools to observe GUI behavior, capture console logs, and iteratively fix issues without manual intervention.

---

## Current Issues Identified

Based on code analysis, the following gaps exist:

### 1. No Project/Folder Loading Support
- **DocumentManager** only supports single-file loading via `loadDocument(at: URL)`
- No method exists to load a project folder and recursively parse all supported files
- The sidebar doesn't support folder hierarchy display

### 2. Sidebar Not Updating on Document Load
- `SidebarViewController.addLoadedDocument()` exists but may not be properly connected
- `DocumentManager.documentLoadedNotification` is posted but needs verification that sidebar subscribes

### 3. Selection → Viewer Display Flow
- `sidebarSelectionChanged` notification is posted when sidebar item selected
- Need to verify `MainSplitViewController` handles this to call `viewerController.displayDocument()`

### 4. Missing Folder/Project Item Type in Sidebar
- `SidebarItemType.folder` exists but no code creates folder hierarchies from disk

---

## Recommended MCP Servers & Tools

### 1. **Peekaboo MCP Server** (Primary - macOS Screenshot & OCR)
- **Repository**: https://github.com/steipete/peekaboo-mcp
- **Purpose**: Capture screenshots of the Lungfish app window and perform OCR to validate UI state
- **Capabilities**:
  - Take screenshots of specific windows by app name
  - Extract text from UI via OCR
  - Observe sidebar contents, viewer state, alerts
- **Usage**:
  ```json
  {
    "mcpServers": {
      "peekaboo": {
        "command": "npx",
        "args": ["-y", "@anthropic/peekaboo-mcp"]
      }
    }
  }
  ```

### 2. **Console Log MCP Server** (Custom - macOS Unified Logging)
- **Purpose**: Stream and filter os.log output from `com.lungfish.browser` subsystem
- **Implementation**: Use `log stream` command with MCP wrapper
- **Capabilities**:
  - Real-time log capture during operations
  - Filter by category (DocumentManager, SidebarViewController, ViewerViewController)
  - Detect errors and warnings automatically

### 3. **Accessibility Inspector MCP** (UI State Validation)
- **Purpose**: Query accessibility tree to validate UI element states
- **Capabilities**:
  - Verify sidebar items exist with correct labels
  - Check viewer accessibility identifiers
  - Validate focus/selection state

### 4. **AppleScript/Automation MCP** (UI Interaction)
- **Purpose**: Simulate user interactions programmatically
- **Capabilities**:
  - Open files via menu
  - Click sidebar items
  - Trigger drag & drop operations

---

## Debugging Workflow

### Phase 1: Setup Logging Infrastructure

```bash
# Terminal 1: Stream Lungfish logs in real-time
log stream --predicate 'subsystem == "com.lungfish.browser"' --style compact
```

The app already has extensive logging via `os.log`:
- **DocumentManager**: File loading, type detection, sequence counts
- **SidebarViewController**: Item addition, selection changes
- **ViewerViewController**: Document display, rendering

### Phase 2: Automated Test Scenarios

#### Scenario A: Single File Import
1. Launch Lungfish app
2. Use File > Open to select `/Users/dho/Desktop/test/KF015279.fasta`
3. **Validate**:
   - Log shows: "loadDocument: Successfully completed loading"
   - Log shows: "displayDocument: Starting to display"
   - Screenshot shows: Sidebar has "OPEN DOCUMENTS" group with file
   - Screenshot shows: Viewer displays sequence (not placeholder)

#### Scenario B: Drag & Drop Import
1. Drag `/Users/dho/Desktop/test/test.fasta` onto viewer
2. **Validate**:
   - Log shows: "handleFileDrop: Received 1 URLs"
   - Log shows: "performDragOperation" success
   - UI updates correctly

#### Scenario C: Project Folder Import (NEW - To Be Implemented)
1. Use File > Open Project Folder (new menu item)
2. Select `/Users/dho/Desktop/test/`
3. **Validate**:
   - Sidebar shows folder hierarchy
   - Both FASTA files appear as children
   - Selecting a file displays it in viewer

### Phase 3: Iterative Fix Cycle

```
┌─────────────────┐
│ Run Test        │
│ Scenario        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌─────────────────┐
│ Capture Logs    │────▶│ Capture         │
│ via os.log      │     │ Screenshot      │
└────────┬────────┘     └────────┬────────┘
         │                       │
         ▼                       ▼
┌─────────────────────────────────────────┐
│ Analyze: Compare Expected vs Actual     │
│ - Check log for errors/warnings         │
│ - OCR screenshot for UI state           │
│ - Identify failure point                │
└────────────────────┬────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│ PASS: Next      │     │ FAIL: Generate  │
│ Scenario        │     │ Fix & Rebuild   │
└─────────────────┘     └────────┬────────┘
                                 │
                                 ▼
                        ┌─────────────────┐
                        │ Repeat Test     │
                        └─────────────────┘
```

---

## Required Code Changes

### 1. Add Project Folder Loading to DocumentManager

```swift
// DocumentManager.swift - Add method
public func loadProjectFolder(at folderURL: URL) async throws -> [LoadedDocument] {
    logger.info("loadProjectFolder: Starting load for \(folderURL.path)")

    var documents: [LoadedDocument] = []
    let fileManager = FileManager.default

    guard let enumerator = fileManager.enumerator(
        at: folderURL,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles]
    ) else {
        throw DocumentLoadError.accessDenied(folderURL)
    }

    for case let fileURL as URL in enumerator {
        // Check if it's a supported file type
        if DocumentType.detect(from: fileURL) != nil {
            do {
                let doc = try await loadDocument(at: fileURL)
                documents.append(doc)
            } catch {
                logger.warning("Skipping \(fileURL.lastPathComponent): \(error.localizedDescription)")
            }
        }
    }

    logger.info("loadProjectFolder: Loaded \(documents.count) documents from folder")
    return documents
}
```

### 2. Add Folder Hierarchy to SidebarViewController

```swift
// SidebarViewController.swift - Add method
public func addProjectFolder(_ folderURL: URL, documents: [LoadedDocument]) {
    logger.info("addProjectFolder: Adding folder '\(folderURL.lastPathComponent)'")

    // Create folder item
    let folderItem = SidebarItem(
        title: folderURL.lastPathComponent,
        type: .folder,
        icon: "folder",
        children: [],
        url: folderURL
    )

    // Add documents as children, preserving subfolder structure
    for doc in documents {
        let relativePath = doc.url.path.replacingOccurrences(of: folderURL.path + "/", with: "")
        // ... build hierarchy based on relative path
    }

    rootItems.append(folderItem)
    outlineView.reloadData()
    outlineView.expandItem(folderItem)
}
```

### 3. Connect Sidebar Selection to Viewer

```swift
// MainSplitViewController.swift - Ensure this observer exists
NotificationCenter.default.addObserver(
    self,
    selector: #selector(handleSidebarSelection(_:)),
    name: .sidebarSelectionChanged,
    object: nil
)

@objc private func handleSidebarSelection(_ notification: Notification) {
    guard let item = notification.userInfo?["item"] as? SidebarItem,
          let url = item.url else { return }

    // Find document by URL
    if let document = DocumentManager.shared.documents.first(where: { $0.url == url }) {
        viewerController?.displayDocument(document)
    }
}
```

### 4. Add "Open Project Folder" Menu Item

```swift
// MainMenu.swift - Add to File menu
NSMenuItem(title: "Open Project Folder...", action: #selector(AppDelegate.openProjectFolder(_:)), keyEquivalent: "O")
    .keyEquivalentModifierMask([.command, .shift])

// AppDelegate.swift - Add handler
@objc func openProjectFolder(_ sender: Any?) {
    let panel = NSOpenPanel()
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    panel.allowsMultipleSelection = false
    panel.title = "Select Project Folder"

    panel.begin { response in
        if response == .OK, let url = panel.url {
            Task {
                let documents = try await DocumentManager.shared.loadProjectFolder(at: url)
                self.mainWindowController?.mainSplitViewController?.sidebarController?.addProjectFolder(url, documents: documents)
            }
        }
    }
}
```

---

## MCP Server Configuration

Add to `~/.config/claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "peekaboo": {
      "command": "npx",
      "args": ["-y", "@anthropic/peekaboo-mcp"],
      "description": "Screenshot and OCR for GUI validation"
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-filesystem", "/Users/dho/Desktop/test", "/Users/dho/Documents/lungfish-genome-browser"],
      "description": "Access to test data and project files"
    }
  }
}
```

---

## Automated Debug Script

Create a bash script that the experts can run to capture state:

```bash
#!/bin/bash
# debug-capture.sh - Capture debugging state for Lungfish

OUTPUT_DIR="$HOME/Desktop/lungfish-debug-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUTPUT_DIR"

# 1. Capture logs (last 5 minutes)
log show --predicate 'subsystem == "com.lungfish.browser"' --last 5m > "$OUTPUT_DIR/logs.txt"

# 2. Capture screenshot (requires screencapture)
screencapture -w "$OUTPUT_DIR/screenshot.png"

# 3. Capture accessibility tree
# Uses Accessibility Inspector command line if available

# 4. Capture process info
ps aux | grep -i lungfish > "$OUTPUT_DIR/process.txt"

echo "Debug capture saved to: $OUTPUT_DIR"
```

---

## Expert Roles Involved

| Role | Responsibility |
|------|----------------|
| **Testing & QA Lead** (Role 19) | Execute test scenarios, validate fixes |
| **UI/UX Lead** (Role 2) | Verify sidebar/viewer interactions |
| **File Format Expert** (Role 6) | Validate file parsing correctness |
| **Swift Architecture Lead** (Role 1) | Review code changes, async patterns |

---

## Success Criteria

1. **Single File Import**: Any supported format opens via menu or drag-drop
2. **Sidebar Display**: Opened files appear in "OPEN DOCUMENTS" group
3. **Viewer Display**: Selected sidebar items display in sequence viewer
4. **Project Folder**: `/Users/dho/Desktop/test/` loads both FASTA files
5. **Hierarchy**: Subfolders within projects appear correctly nested
6. **Console Logs**: No errors or warnings during normal operation

---

## Next Steps

1. Install Peekaboo MCP server for screenshot automation
2. Implement `loadProjectFolder()` in DocumentManager
3. Add folder hierarchy support to SidebarViewController
4. Connect MainSplitViewController to handle sidebar selections
5. Add "Open Project Folder" menu item
6. Run automated test scenarios
7. Iterate until all success criteria pass

---

## Appendix: Current os.log Categories

| Subsystem | Category | Purpose |
|-----------|----------|---------|
| com.lungfish.browser | DocumentManager | File loading, type detection |
| com.lungfish.browser | SidebarViewController | Item management, selection |
| com.lungfish.browser | ViewerViewController | Document display, rendering |
| com.lungfish.browser | MainSplitViewController | Panel coordination |

View logs with:
```bash
log stream --predicate 'subsystem == "com.lungfish.browser"' --level debug
```
