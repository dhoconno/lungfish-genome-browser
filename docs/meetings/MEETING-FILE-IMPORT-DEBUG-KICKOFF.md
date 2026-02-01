# Meeting Summary: File Import Debug Kickoff

**Date**: 2026-02-01
**Meeting Type**: Technical Coordination Meeting
**Project**: Lungfish Genome Browser
**Subject**: File Import and Display Issues - Debugging Initiative

---

## Attendees

| Role | Title | Area of Expertise |
|------|-------|-------------------|
| Role 1 | Swift Architecture Lead | Code architecture, async patterns, Swift best practices |
| Role 2 | UI/UX Lead | Sidebar/viewer interactions, user interface |
| Role 3 | Sequence Viewer Specialist | Sequence visualization, viewer rendering |
| Role 6 | File Format Expert | File parsing, format validation |
| Role 19 | Testing & QA Lead | Test execution, validation, automated testing |

---

## Problem Statement

Files can be imported into the Lungfish Genome Browser but may not display correctly in the sidebar and/or viewer. Based on code analysis documented in the debugging plan, the following specific issues have been identified:

### Issue 1: No Project/Folder Loading Support
- `DocumentManager` only supports single-file loading via `loadDocument(at: URL)`
- No method exists to load a project folder and recursively parse all supported files
- The sidebar does not support folder hierarchy display

### Issue 2: Sidebar Not Updating on Document Load
- `SidebarViewController.addLoadedDocument()` exists but may not be properly connected
- `DocumentManager.documentLoadedNotification` is posted but requires verification that sidebar subscribes

### Issue 3: Selection to Viewer Display Flow
- `sidebarSelectionChanged` notification is posted when sidebar item is selected
- Need to verify `MainSplitViewController` handles this to call `viewerController.displayDocument()`

### Issue 4: Missing Folder/Project Item Type in Sidebar
- `SidebarItemType.folder` exists but no code creates folder hierarchies from disk

---

## Current Architecture (Working Components)

### Single File Import Flow
```
AppDelegate.openDocument(at:)
    -> DocumentManager.loadDocument(at:)
    -> notification
    -> MainSplitViewController.handleDocumentLoaded
    -> SidebarViewController.addLoadedDocument
```

### Drag and Drop Flow
```
SequenceViewerView.performDragOperation
    -> ViewerViewController.handleFileDrop
    -> DocumentManager.loadDocument
    -> display
```

### Supported Formats
- FASTA (.fa, .fasta, .fna, .fas)
- FASTQ (.fq, .fastq)
- GFF3 (.gff, .gff3)
- BED (.bed)
- VCF (.vcf)

---

## Task Assignments

### Swift Architecture Lead (Role 1)

**Primary Tasks:**
1. **Task 1: Add Project Folder Loading to DocumentManager**
   - File: `Sources/LungfishApp/App/DocumentManager.swift`
   - Implement `loadProjectFolder(at folderURL: URL) async throws -> [LoadedDocument]`
   - Add recursive folder scanning with support for all file types
   - Add `projectLoadedNotification` for folder load events
   - Ensure proper error handling and logging

2. **Task 3: Add "Open Project Folder" Menu Item**
   - Add menu item with Cmd+Shift+O keyboard shortcut
   - Implement `openProjectFolder(_:)` handler in AppDelegate
   - Handle empty folder case with user alert
   - Show progress indicator during folder loading

3. **Task 4: Optimize Selection Handling**
   - File: `Sources/LungfishApp/Views/MainWindow/MainSplitViewController.swift`
   - Check if document is already loaded before re-loading
   - Use `DocumentManager.shared.documents` to find existing documents
   - Reduce unnecessary file I/O operations

**Supporting Role:** File Format Expert (Role 6) for document type detection

---

### UI/UX Lead (Role 2)

**Primary Tasks:**
1. **Task 2: Add Folder Hierarchy Support to SidebarViewController**
   - File: `Sources/LungfishApp/Views/Sidebar/SidebarViewController.swift`
   - Implement `addProjectFolder(_ folderURL: URL, documents: [LoadedDocument])`
   - Build folder hierarchy from document paths
   - Support subfolder nesting
   - Sort children (folders first, then files alphabetically)
   - Auto-expand folder and select first document

2. **Verify Sidebar Update Connections**
   - Ensure `handleDocumentLoaded` is called when files load
   - Verify `addLoadedDocument` creates items correctly
   - Confirm `outlineView.reloadData()` is called appropriately

**Supporting Role:** Sequence Viewer Specialist (Role 3) for viewer integration

---

### Sequence Viewer Specialist (Role 3)

**Primary Tasks:**
1. **Verify Viewer Display Pipeline**
   - Confirm `displayDocument` receives correct data
   - Verify `viewerView.sequence` is set properly
   - Check `referenceFrame` creation with valid dimensions
   - Ensure view bounds are non-zero (no layout issues)

2. **Troubleshoot Placeholder Issues**
   - If viewer shows placeholder instead of sequence, investigate:
     - Sequence data validity
     - Reference frame dimensions
     - View layout state

**Supporting Role:** File Format Expert (Role 6) for data validation

---

### File Format Expert (Role 6)

**Primary Tasks:**
1. **Validate File Parsing Correctness**
   - Verify FASTA reader produces correct sequence data
   - Confirm all supported format readers work correctly
   - Test edge cases (empty files, malformed data)

2. **Support Document Type Detection**
   - Ensure `DocumentType.detect(from: URL)` identifies all supported extensions
   - Add logging for file type detection during folder scanning

3. **Test Data Validation**
   - Verify test files at `/Users/dho/Desktop/test/` are valid
   - Confirm `KF015279.fasta` and `test.fasta` parse correctly

---

### Testing & QA Lead (Role 19)

**Primary Tasks:**
1. **Execute Test Scenarios**

   **Scenario 1: Single File Import (Menu)**
   - [ ] File > Open selects `/Users/dho/Desktop/test/KF015279.fasta`
   - [ ] File appears in sidebar under "OPEN DOCUMENTS"
   - [ ] Sequence displays in viewer
   - [ ] Console log shows successful load

   **Scenario 2: Single File Import (Drag and Drop)**
   - [ ] Drag `test.fasta` onto viewer
   - [ ] File appears in sidebar
   - [ ] Sequence displays correctly

   **Scenario 3: Project Folder Import**
   - [ ] File > Open Project Folder selects `/Users/dho/Desktop/test`
   - [ ] Both FASTA files appear in sidebar under project folder
   - [ ] First file automatically selected and displayed
   - [ ] Clicking second file switches viewer content

   **Scenario 4: Already-Loaded Document**
   - [ ] Open same file twice (via menu)
   - [ ] No duplicate in sidebar
   - [ ] No re-loading (check logs)

2. **Setup Debug Script**
   - Create `/Users/dho/Documents/lungfish-genome-browser/scripts/debug-capture.sh`
   - Configure automated state capture for debugging sessions
   - Enable log streaming during test execution

3. **Coordinate with Peekaboo Test Expert**
   - Configure Peekaboo MCP server for screenshot automation
   - Validate UI state through OCR analysis
   - Capture visual evidence of pass/fail states

---

## Success Criteria

The debugging initiative will be considered complete when all of the following criteria are met:

| Criterion | Description | Validation Method |
|-----------|-------------|-------------------|
| Single File Import | Any supported format opens via menu or drag-drop | Manual + Peekaboo screenshot |
| Sidebar Display | Opened files appear in "OPEN DOCUMENTS" group | Peekaboo OCR validation |
| Viewer Display | Selected sidebar items display in sequence viewer | Screenshot + visual inspection |
| Project Folder | `/Users/dho/Desktop/test/` loads both FASTA files | Automated test scenario |
| Folder Hierarchy | Subfolders within projects appear correctly nested | UI inspection |
| Console Logs | No errors or warnings during normal operation | Log stream analysis |

### Expected Log Output (Success Case)

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

## Feedback Loop with Peekaboo Test Expert

### MCP Server Configuration

The following MCP servers should be configured in `~/.config/claude/claude_desktop_config.json`:

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

### Iterative Debug Cycle

```
     +-------------------+
     | Run Test Scenario |
     +--------+----------+
              |
              v
+-------------+-------------+     +------------------+
| Capture Logs via os.log   |---->| Capture          |
+-------------+-------------+     | Screenshot       |
              |                   +--------+---------+
              v                            |
+----------------------------------------------+
| Analyze: Compare Expected vs Actual          |
| - Check log for errors/warnings              |
| - OCR screenshot for UI state                |
| - Identify failure point                     |
+---------------------+------------------------+
                      |
          +-----------+-----------+
          |                       |
          v                       v
+------------------+     +------------------+
| PASS: Next       |     | FAIL: Generate   |
| Scenario         |     | Fix & Rebuild    |
+------------------+     +--------+---------+
                                  |
                                  v
                         +------------------+
                         | Repeat Test      |
                         +------------------+
```

### Peekaboo Validation Prompts

When validating with Peekaboo MCP:
1. "Take a screenshot of the Lungfish app window and confirm the sidebar is visible"
2. "Verify there are items listed under OPEN DOCUMENTS in the sidebar"
3. "Check if the viewer shows sequence data or a placeholder"
4. "Capture the state after opening a project folder"

---

## Next Steps

1. **Immediate (Day 1)**
   - [ ] Swift Architecture Lead: Implement `loadProjectFolder()` in DocumentManager
   - [ ] Testing & QA Lead: Set up debug capture script and log streaming
   - [ ] Testing & QA Lead: Install and configure Peekaboo MCP server

2. **Short-term (Days 2-3)**
   - [ ] UI/UX Lead: Add folder hierarchy support to SidebarViewController
   - [ ] Swift Architecture Lead: Connect MainSplitViewController selection handling
   - [ ] Swift Architecture Lead: Add "Open Project Folder" menu item
   - [ ] File Format Expert: Validate test files and format readers

3. **Validation (Days 4-5)**
   - [ ] Testing & QA Lead: Execute all test scenarios
   - [ ] Testing & QA Lead: Coordinate Peekaboo validation with team
   - [ ] All: Review console logs for errors/warnings
   - [ ] All: Iterate on fixes until all success criteria pass

4. **Completion**
   - [ ] All success criteria verified
   - [ ] No console errors during normal operation
   - [ ] Documentation updated with any architectural changes

---

## Related Documents

- Debugging Plan: `/Users/dho/Documents/lungfish-genome-browser/docs/qa/DEBUGGING-PLAN-FILE-IMPORTS.md`
- Implementation Guide: `/Users/dho/Documents/lungfish-genome-browser/docs/qa/IMPLEMENTATION-FILE-IMPORTS.md`

---

## Key Files for Reference

| File | Purpose |
|------|---------|
| `Sources/LungfishApp/App/DocumentManager.swift` | File loading, project folder loading |
| `Sources/LungfishApp/App/AppDelegate.swift` | Menu handlers, app lifecycle |
| `Sources/LungfishApp/Views/Sidebar/SidebarViewController.swift` | Sidebar item management |
| `Sources/LungfishApp/Views/Viewer/ViewerViewController.swift` | Document display |
| `Sources/LungfishApp/Views/MainWindow/MainSplitViewController.swift` | Panel coordination |

---

## Log Monitoring Commands

```bash
# Stream all Lungfish logs in real-time
log stream --predicate 'subsystem == "com.lungfish.browser"' --style compact

# View recent logs (last 10 minutes)
log show --predicate 'subsystem == "com.lungfish.browser"' --last 10m

# Filter by specific category
log stream --predicate 'subsystem == "com.lungfish.browser" AND category == "DocumentManager"'
```

---

**Meeting Adjourned**

Next meeting to be scheduled upon completion of immediate tasks to review progress and coordinate validation phase.
