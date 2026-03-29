# EsViritu Viewport Design - Expert Review Request

## Status: Needs Expert Consensus

## Current State
- Right pane: Detection table (NSOutlineView) with assemblies/contigs, sparklines, metrics — working well
- Left pane: Detail pane with coverage area chart + metrics pills — newly added
- BAM files available from --keep True (final alignment BAM with reads mapped to all detected viruses)
- Coverage window data (100 windows per contig) available for all detections

## Questions for Expert Teams

### For UX/HIG Experts
1. How should the viewport be organized for maximum discoverability?
2. Should selecting a virus in the table navigate to a BAM pileup view, or show it inline?
3. How do we handle the transition between "overview" and "deep dive" without losing context?
4. What's the right balance between information density and clarity for a biologist?

### For Bioinformatics/Genomics Experts
1. When a biologist sees "Human mastadenovirus F — 1,129 reads, 5.0x coverage" what do they want to see next?
2. Is the coverage sparkline sufficient, or do they need base-level resolution?
3. For segmented viruses (Influenza), what's the ideal visualization?
4. Should we show read-level alignments (IGV-style pileup) or just depth/coverage metrics?
5. How important is seeing individual read quality, mismatches, soft-clips?

### For macOS/Swift Experts
1. Can we embed a SequenceViewerView instance in the left pane for BAM viewing?
2. Performance implications of switching BAM references on each table row click?
3. Should we use a separate window/panel for the BAM viewer?

## Proposed Viewport Layouts

### Option A: Split with Inline BAM (Preferred)
```
+--------------------------------------------------+
| Summary Bar                                       |
+--------------------------------------------------+
| Left Pane (40%)      | Right Pane (60%)           |
|                      |                            |
| [Coverage Chart]     | [Detection Table]          |
| [Metrics]            | Assembly > Contig hierarchy |
| [Mini BAM Pileup]    | Sparklines, reads, RPKMF   |
|                      |                            |
+--------------------------------------------------+
| Action Bar                                        |
+--------------------------------------------------+
```

### Option B: Three-Panel Layout
```
+--------------------------------------------------+
| Summary Bar                                       |
+--------------------------------------------------+
| Detection  | Coverage + Metrics  | BAM Pileup     |
| Table      |                     | (full viewer)   |
| (30%)      | (30%)               | (40%)           |
+--------------------------------------------------+
| Action Bar                                        |
+--------------------------------------------------+
```

### Option C: Tab-Based Detail
```
+--------------------------------------------------+
| Summary Bar                                       |
+--------------------------------------------------+
| Left Pane            | Right Pane                 |
|                      |                            |
| [Overview | BAM]     | [Detection Table]          |
| tab-based switching  |                            |
|                      |                            |
+--------------------------------------------------+
| Action Bar                                        |
+--------------------------------------------------+
```
