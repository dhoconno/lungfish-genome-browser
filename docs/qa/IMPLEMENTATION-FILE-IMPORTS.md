# Lungfish Genome Browser - File Import Implementation Guide

## Overview

This document provides step-by-step implementation instructions for the 20 experts to fix file import and display issues. It includes specific code changes and automated debugging workflows using MCP servers.

---

## Current Architecture Analysis

### What's Already Working

1. **Single File Import Flow**:
   - `AppDelegate.openDocument(at:)` → `DocumentManager.loadDocument(at:)` → notification → `MainSplitViewController.handleDocumentLoaded` → `SidebarViewController.addLoadedDocument`
   - `SidebarViewController.outlineViewSelectionDidChange` → notification → `MainSplitViewController.handleSidebarSelectionChanged` → `ViewerViewController.displayDocument`

2. **Drag & Drop Flow**:
   - `SequenceViewerView.performDragOperation` → `ViewerViewController.handleFileDrop` → `DocumentManager.loadDocument` → display

3. **Supported Formats**:
   - FASTA (.fa, .fasta, .fna, .fas)
   - FASTQ (.fq, .fastq)
   - GFF3 (.gff, .gff3)
   - BED (.bed)
   - VCF (.vcf)

### What's Missing

1. **Project Folder Loading**: No method to recursively load a folder of files
2. **Folder Hierarchy in Sidebar**: Sidebar only shows flat file list
3. **Multiple Document Selection**: Sidebar selection only handles single items

---

## Implementation Tasks

### Task 1: Add Project Folder Loading to DocumentManager

**File**: `Sources/LungfishApp/App/DocumentManager.swift`

**Add after line 206** (after `setActiveDocument` method):

```swift
// MARK: - Project Folder Loading

/// Loads all supported documents from a folder recursively.
///
/// - Parameter folderURL: The folder URL to scan
/// - Returns: Array of loaded documents
/// - Throws: Error if folder cannot be accessed
public func loadProjectFolder(at folderURL: URL) async throws -> [LoadedDocument] {
    logger.info("loadProjectFolder: Scanning \(folderURL.path, privacy: .public)")

    let fileManager = FileManager.default

    // Verify folder exists and is a directory
    var isDirectory: ObjCBool = false
    guard fileManager.fileExists(atPath: folderURL.path, isDirectory: &isDirectory),
          isDirectory.boolValue else {
        logger.error("loadProjectFolder: Not a valid directory: \(folderURL.path, privacy: .public)")
        throw DocumentLoadError.fileNotFound(folderURL)
    }

    var loadedDocuments: [LoadedDocument] = []

    // Enumerate all files recursively
    guard let enumerator = fileManager.enumerator(
        at: folderURL,
        includingPropertiesForKeys: [.isRegularFileKey, .isDirectoryKey],
        options: [.skipsHiddenFiles, .skipsPackageDescendants]
    ) else {
        logger.error("loadProjectFolder: Failed to create enumerator for \(folderURL.path, privacy: .public)")
        throw DocumentLoadError.accessDenied(folderURL)
    }

    var filesToLoad: [URL] = []

    for case let fileURL as URL in enumerator {
        // Check if it's a regular file with supported extension
        if let type = DocumentType.detect(from: fileURL) {
            logger.debug("loadProjectFolder: Found supported file \(fileURL.lastPathComponent, privacy: .public) (\(type.rawValue, privacy: .public))")
            filesToLoad.append(fileURL)
        }
    }

    logger.info("loadProjectFolder: Found \(filesToLoad.count) supported files")

    // Load each file
    for fileURL in filesToLoad {
        do {
            let document = try await loadDocument(at: fileURL)
            loadedDocuments.append(document)
            logger.debug("loadProjectFolder: Loaded \(fileURL.lastPathComponent, privacy: .public)")
        } catch {
            // Log warning but continue with other files
            logger.warning("loadProjectFolder: Skipped \(fileURL.lastPathComponent, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }

    logger.info("loadProjectFolder: Successfully loaded \(loadedDocuments.count) documents")

    // Post notification for project loaded
    NotificationCenter.default.post(
        name: Self.projectLoadedNotification,
        object: self,
        userInfo: [
            "folderURL": folderURL,
            "documents": loadedDocuments
        ]
    )

    return loadedDocuments
}

/// Notification posted when a project folder is loaded
public static let projectLoadedNotification = Notification.Name("DocumentManagerProjectLoaded")
```

---

### Task 2: Add Folder Hierarchy Support to SidebarViewController

**File**: `Sources/LungfishApp/Views/Sidebar/SidebarViewController.swift`

**Add after line 213** (after `addLoadedDocument` method):

```swift
/// Adds a project folder with all its documents to the sidebar.
///
/// - Parameters:
///   - folderURL: The root folder URL
///   - documents: The loaded documents from the folder
public func addProjectFolder(_ folderURL: URL, documents: [LoadedDocument]) {
    logger.info("addProjectFolder: Adding folder '\(folderURL.lastPathComponent, privacy: .public)' with \(documents.count) documents")

    // Create the project folder item
    let folderItem = SidebarItem(
        title: folderURL.lastPathComponent,
        type: .project,
        icon: "folder.badge.gearshape",
        children: [],
        url: folderURL
    )

    // Build folder hierarchy from document paths
    var subfolderItems: [String: SidebarItem] = [:]  // Relative path -> item

    for document in documents {
        // Calculate relative path
        let relativePath = document.url.deletingLastPathComponent().path
            .replacingOccurrences(of: folderURL.path, with: "")
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        // Determine item type
        let itemType: SidebarItemType
        let icon: String
        switch document.type {
        case .fasta, .fastq:
            itemType = .sequence
            icon = "doc.text"
        case .genbank:
            itemType = .sequence
            icon = "doc.richtext"
        case .gff3, .bed:
            itemType = .annotation
            icon = "list.bullet.rectangle"
        case .vcf:
            itemType = .annotation
            icon = "chart.bar.xaxis"
        case .bam:
            itemType = .alignment
            icon = "chart.bar"
        }

        // Create document item
        let docItem = SidebarItem(
            title: document.name,
            type: itemType,
            icon: icon,
            children: [],
            url: document.url
        )

        if relativePath.isEmpty {
            // File is directly in root folder
            folderItem.children.append(docItem)
        } else {
            // File is in a subfolder
            if subfolderItems[relativePath] == nil {
                // Create subfolder item
                let subfolderItem = SidebarItem(
                    title: URL(fileURLWithPath: relativePath).lastPathComponent,
                    type: .folder,
                    icon: "folder",
                    children: [],
                    url: folderURL.appendingPathComponent(relativePath)
                )
                subfolderItems[relativePath] = subfolderItem
                folderItem.children.append(subfolderItem)
            }
            subfolderItems[relativePath]?.children.append(docItem)
        }
    }

    // Sort children alphabetically (folders first, then files)
    folderItem.children.sort { item1, item2 in
        if item1.type == .folder && item2.type != .folder {
            return true
        } else if item1.type != .folder && item2.type == .folder {
            return false
        }
        return item1.title.localizedCaseInsensitiveCompare(item2.title) == .orderedAscending
    }

    // Add to root items
    rootItems.append(folderItem)

    logger.info("addProjectFolder: Reloading outline view")
    outlineView.reloadData()

    // Expand the folder
    outlineView.expandItem(folderItem)

    // Select the first document if any
    if let firstDoc = folderItem.children.first {
        let row = outlineView.row(forItem: firstDoc)
        if row >= 0 {
            outlineView.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
        }
    }
}
```

---

### Task 3: Add "Open Project Folder" Menu Item

**File**: Check for `Sources/LungfishApp/Menu/MainMenu.swift` or add to AppDelegate

**Add to File menu structure** (find where menu is created):

```swift
// Add after "Open..." menu item
NSMenuItem(
    title: "Open Project Folder...",
    action: #selector(AppDelegate.openProjectFolder(_:)),
    keyEquivalent: "O"
).then {
    $0.keyEquivalentModifierMask = [.command, .shift]
}
```

**Add to AppDelegate.swift** (after `openDocument` method around line 138):

```swift
@IBAction func openProjectFolder(_ sender: Any?) {
    let panel = NSOpenPanel()
    panel.title = "Open Project Folder"
    panel.message = "Select a folder containing genomic data files"
    panel.canChooseFiles = false
    panel.canChooseDirectories = true
    panel.allowsMultipleSelection = false
    panel.canCreateDirectories = false

    panel.begin { [weak self] response in
        guard response == .OK, let url = panel.url else { return }

        Task { @MainActor in
            let viewerController = self?.mainWindowController?.mainSplitViewController?.viewerController
            let sidebarController = self?.mainWindowController?.mainSplitViewController?.sidebarController

            viewerController?.showProgress("Loading project folder...")

            do {
                let documents = try await DocumentManager.shared.loadProjectFolder(at: url)

                viewerController?.hideProgress()

                if documents.isEmpty {
                    // Show alert that no supported files were found
                    let alert = NSAlert()
                    alert.messageText = "No Supported Files Found"
                    alert.informativeText = "The selected folder does not contain any supported genomic data files."
                    alert.alertStyle = .informational
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                } else {
                    // Add folder to sidebar
                    sidebarController?.addProjectFolder(url, documents: documents)

                    // Display the first document
                    if let firstDoc = documents.first {
                        viewerController?.displayDocument(firstDoc)
                    }
                }
            } catch {
                viewerController?.hideProgress()

                let alert = NSAlert()
                alert.messageText = "Failed to Load Project"
                alert.informativeText = error.localizedDescription
                alert.alertStyle = .warning
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
        }
    }
}
```

---

### Task 4: Handle Already-Loaded Documents in Selection

**File**: `Sources/LungfishApp/Views/MainWindow/MainSplitViewController.swift`

The current implementation at line 161-188 handles selection but re-loads the document every time. Optimize to check if already loaded:

**Replace lines 161-188** with:

```swift
// If the item has a URL, check if already loaded or load fresh
if let url = item.url {
    // First check if document is already loaded
    if let existingDocument = DocumentManager.shared.documents.first(where: { $0.url == url }) {
        logger.info("handleSidebarSelectionChanged: Document already loaded, displaying directly")
        viewerController.displayDocument(existingDocument)
        DocumentManager.shared.setActiveDocument(existingDocument)
        return
    }

    // Not loaded yet, load it
    logger.info("handleSidebarSelectionChanged: Loading document from '\(url.path, privacy: .public)'")
    Task { @MainActor in
        viewerController.showProgress("Loading \(url.lastPathComponent)...")
        do {
            let document = try await DocumentManager.shared.loadDocument(at: url)
            viewerController.hideProgress()
            viewerController.displayDocument(document)
            logger.info("handleSidebarSelectionChanged: Document loaded and displayed")
        } catch {
            viewerController.hideProgress()
            logger.error("handleSidebarSelectionChanged: Failed to load: \(error.localizedDescription, privacy: .public)")
            let alert = NSAlert()
            alert.messageText = "Failed to Open File"
            alert.informativeText = error.localizedDescription
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
}
```

---

## Automated Debugging Setup

### MCP Server Configuration

Create/update `~/.config/claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "peekaboo": {
      "command": "npx",
      "args": ["-y", "peekaboo-mcp"],
      "env": {}
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/dho/Desktop/test",
        "/Users/dho/Documents/lungfish-genome-browser"
      ],
      "env": {}
    }
  }
}
```

### Debug Script for Experts

Create `/Users/dho/Documents/lungfish-genome-browser/scripts/debug-capture.sh`:

```bash
#!/bin/bash
# debug-capture.sh - Automated state capture for Lungfish debugging

set -e

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
OUTPUT_DIR="$HOME/Desktop/lungfish-debug-$TIMESTAMP"
mkdir -p "$OUTPUT_DIR"

echo "📸 Capturing debug state to: $OUTPUT_DIR"

# 1. Capture console logs (last 10 minutes)
echo "📋 Capturing console logs..."
log show --predicate 'subsystem == "com.lungfish.browser"' --last 10m --style compact > "$OUTPUT_DIR/console-logs.txt" 2>/dev/null || echo "No logs found"

# 2. Capture screenshot of Lungfish window if running
echo "🖼️  Capturing screenshot..."
if pgrep -x "Lungfish" > /dev/null; then
    screencapture -l $(osascript -e 'tell app "Lungfish" to id of window 1') "$OUTPUT_DIR/lungfish-window.png" 2>/dev/null || screencapture "$OUTPUT_DIR/screen.png"
else
    echo "Lungfish not running, capturing full screen"
    screencapture "$OUTPUT_DIR/screen.png"
fi

# 3. Capture process info
echo "🔍 Capturing process info..."
ps aux | grep -i lungfish > "$OUTPUT_DIR/process-info.txt"

# 4. List test folder contents
echo "📁 Listing test folder..."
ls -laR /Users/dho/Desktop/test/ > "$OUTPUT_DIR/test-folder-contents.txt" 2>/dev/null || echo "Test folder not found"

# 5. Stream logs for 30 seconds (for interactive debugging)
echo "🔴 Streaming live logs for 30 seconds..."
echo "   (Perform your test actions now)"
timeout 30 log stream --predicate 'subsystem == "com.lungfish.browser"' --style compact > "$OUTPUT_DIR/live-logs.txt" 2>/dev/null &
LOG_PID=$!
sleep 30
kill $LOG_PID 2>/dev/null || true

echo ""
echo "✅ Debug capture complete!"
echo "📂 Output saved to: $OUTPUT_DIR"
echo ""
echo "Files captured:"
ls -la "$OUTPUT_DIR"
```

Make it executable:
```bash
chmod +x /Users/dho/Documents/lungfish-genome-browser/scripts/debug-capture.sh
```

---

## Testing Checklist

### Test Scenario 1: Single File Import (Menu)
- [ ] File > Open selects `/Users/dho/Desktop/test/KF015279.fasta`
- [ ] File appears in sidebar under "OPEN DOCUMENTS"
- [ ] Sequence displays in viewer
- [ ] Console log shows successful load

### Test Scenario 2: Single File Import (Drag & Drop)
- [ ] Drag `test.fasta` onto viewer
- [ ] File appears in sidebar
- [ ] Sequence displays correctly

### Test Scenario 3: Project Folder Import
- [ ] File > Open Project Folder selects `/Users/dho/Desktop/test`
- [ ] Both FASTA files appear in sidebar under project folder
- [ ] First file automatically selected and displayed
- [ ] Clicking second file switches viewer content

### Test Scenario 4: Already-Loaded Document
- [ ] Open same file twice (via menu)
- [ ] No duplicate in sidebar
- [ ] No re-loading (check logs)

---

## Expert Role Assignments

| Task | Primary Role | Supporting Roles |
|------|--------------|------------------|
| DocumentManager changes | Swift Architecture Lead (1) | File Format Expert (6) |
| SidebarViewController changes | UI/UX Lead (2) | Sequence Viewer Specialist (3) |
| Menu integration | Swift Architecture Lead (1) | UI/UX Lead (2) |
| Selection optimization | Swift Architecture Lead (1) | - |
| Testing & validation | Testing & QA Lead (19) | All |
| Debug script setup | Testing & QA Lead (19) | Documentation Lead (20) |

---

## Expected Log Output (Success Case)

```
[DocumentManager] loadProjectFolder: Scanning /Users/dho/Desktop/test
[DocumentManager] loadProjectFolder: Found 2 supported files
[DocumentManager] loadDocument: Starting load for .../KF015279.fasta
[DocumentManager] loadFASTA: Read 1 sequences
[DocumentManager] loadDocument: Successfully completed loading KF015279.fasta
[DocumentManager] loadDocument: Starting load for .../test.fasta
[DocumentManager] loadFASTA: Read X sequences
[DocumentManager] loadDocument: Successfully completed loading test.fasta
[DocumentManager] loadProjectFolder: Successfully loaded 2 documents
[SidebarViewController] addProjectFolder: Adding folder 'test' with 2 documents
[SidebarViewController] addProjectFolder: Reloading outline view
[ViewerViewController] displayDocument: Starting to display 'KF015279.fasta'
[ViewerViewController] displayDocument: First sequence length=XXXX
```

---

## Troubleshooting

### Issue: Files load but don't appear in sidebar
- Check `handleDocumentLoaded` is being called (add log breakpoint)
- Verify `addLoadedDocument` creates items correctly
- Check `outlineView.reloadData()` is called

### Issue: Sidebar selection doesn't update viewer
- Verify notification is posted in `outlineViewSelectionDidChange`
- Check `handleSidebarSelectionChanged` receives notification
- Verify URL is not nil on sidebar item

### Issue: Viewer shows placeholder instead of sequence
- Check `viewerView.sequence` is set (debug log exists)
- Verify `referenceFrame` is created with valid dimensions
- Check view bounds are non-zero (layout issue)

---

## MCP Server Usage Examples

### Using Peekaboo for Screenshot Validation

```
# In Claude conversation with Peekaboo MCP:
Take a screenshot of the Lungfish app window and tell me:
1. Is the sidebar visible?
2. Are there any items in the sidebar?
3. Does the viewer show a sequence or placeholder?
```

### Using Filesystem MCP

```
# In Claude conversation with Filesystem MCP:
1. List all files in /Users/dho/Desktop/test
2. Read the first 100 lines of KF015279.fasta to verify format
3. Check if the file is valid FASTA
```

---

## Build & Run Commands

```bash
# Build the app
cd /Users/dho/Documents/lungfish-genome-browser
swift build

# Run the app
swift run Lungfish

# Run with debug logging enabled
swift run Lungfish 2>&1 | tee debug-output.txt

# Or use Xcode for full debugging with breakpoints
open Package.swift  # Opens in Xcode
```
