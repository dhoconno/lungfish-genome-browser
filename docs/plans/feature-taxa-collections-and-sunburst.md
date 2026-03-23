# Feature: Taxa Collection Drawer + Sunburst Fix + Outline Shortcuts

## Status: Planning

## Description
Three related improvements to the taxonomy classification view:

### 1. Taxa Collection Drawer (Bottom Drawer)
A new bottom drawer associated with the classification view for defining collections
of taxa to extract simultaneously. Each taxon in a collection extracts to its own
virtual FASTQ file.

**Three tiers of collections:**
- **Built-in**: Pre-defined sets available to all users (Respiratory Viruses, Enteric Viruses, etc.)
- **App-wide**: User-defined sets saved in app preferences, available across all projects
- **Project-specific**: Sets saved within the project, only for that project

**Must be classifier-agnostic** — same collections work with Kraken2, STAT, GOTTCHA2.

### 2. Sunburst Visualization Not Visible
The CoreGraphics sunburst chart was built but doesn't appear in the taxonomy view.
Need to verify the NSSplitView layout shows both the sunburst (left) and table (right).

### 3. NSOutlineView Keyboard Shortcuts
Add standard macOS tree navigation shortcuts:
- Cmd-Shift-Right Arrow: Expand all
- Cmd-Shift-Left Arrow: Collapse all
- Option-Right Arrow: Expand all below current selection
- Right Arrow: Expand selected
- Left Arrow: Collapse selected

## Test Data
Use existing classification results from the viral database test.

## Expert Team
- **Bioinformatics**: Define built-in taxa collections (respiratory, enteric, etc.)
- **UX/HIG**: Drawer design, collection management UI
- **Swift/macOS**: NSSplitView debugging, outline view shortcuts, drawer architecture
- **QA**: Multi-taxa extraction testing
