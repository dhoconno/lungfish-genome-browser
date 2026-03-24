# EsViritu Viewport Design — Expert Consensus

## Layout: Split View with Scrolling Detail Inspector

```
+================================================================+
| SUMMARY BAR (48pt)                                              |
+================================================================+
| DETAIL INSPECTOR (40%) | DETECTION TABLE (60%)                  |
|                        |                                        |
| Scrolling stack:       | NSOutlineView with assemblies/contigs  |
| 1. Virus Name (bold)   | Sparklines in Coverage column          |
|    Family badge        | Confidence badges in leading column    |
| 2. Metrics pills       |                                        |
| 3. Segment strip       |                                        |
|    (segmented only)    |                                        |
| 4. Coverage chart      |                                        |
|    (160px)             |                                        |
| 5. Mini BAM pileup     |                                        |
|    (200px, Phase 2)    |                                        |
| 6. Action buttons      |                                        |
|    [BLAST] [Extract]   |                                        |
|    [Open Full Viewer]  |                                        |
+================================================================+
| ACTION BAR (36pt)                                               |
+================================================================+
```

## Key Design Decisions

1. **Inline inspector, not navigation** — clicking a virus updates the left pane in place (0.15s crossfade). Full BAM viewer is a separate "Open in Full Viewer" action.

2. **Coverage chart first, reads second** — 100-window coverage is sufficient for 80% of review. Mini BAM pileup (Phase 2) shows 10-15 packed reads for verification.

3. **Segment completeness strip** — for segmented viruses, shows all segments with color-coded coverage (green ≥5x, yellow 1-5x, gray 0x).

4. **Confidence badges** — High (green ✓), Medium (yellow △), Low (red !) based on reads + identity + breadth.

5. **Multi-sample comparison** — separate "Compare Samples" viewport (Phase 3), not inline.

## Phases

### Phase 1 (Current)
- Segment completeness strip for segmented viruses
- Confidence badges in table + inspector
- BLAST/Extract action buttons in inspector

### Phase 2
- Mini BAM pileup (MiniAlignmentView)
- Keep BAM file handle open for fast contig switching
- "Open in Full Viewer" wired to SequenceViewerView

### Phase 3
- Multi-sample comparison heatmap
- SampleComparisonViewController
