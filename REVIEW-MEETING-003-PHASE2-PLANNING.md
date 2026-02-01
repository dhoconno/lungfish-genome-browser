# Expert Review Meeting #003 - Phase 2 Planning

**Date**: Phase 2 Kickoff
**Attendees**: All 20 Experts
**Chair**: Swift Architecture Lead (Role 01)
**Agenda**: Phase 2 task assignment and ownership

---

## Phase 1 Status: COMPLETE

| Deliverable | Status | Owner |
|-------------|--------|-------|
| Package.swift with 6 modules | ✅ | Swift Architect |
| Core models (Sequence, Annotation, Region, Document) | ✅ | Bioinformatics Architect |
| FASTA reader with index support | ✅ | File Format Expert |
| Three-pane UI shell | ✅ | UI/UX Lead |
| 29 tests passing | ✅ | Testing & QA Lead |

---

## Phase 2 Task Ownership

### Track Rendering Engineer (Role 04) - PRIMARY

**Deliverables**:
1. `LungfishUI/Rendering/ReferenceFrame.swift` - Coordinate system (IGV pattern)
2. `LungfishUI/Tracks/Track.swift` - Track protocol definition
3. `LungfishUI/Tracks/DisplayMode.swift` - Display mode enum
4. `LungfishUI/Rendering/RenderContext.swift` - Render context for tracks

**Technical Decisions**:
- Follow IGV's ReferenceFrame.java pattern exactly
- `binsPerTile = 700`, `maxZoom = 23`, `minBP = 40`
- Use retained mode rendering with dirty rectangle tracking
- Display modes: collapsed, squished, expanded, auto

**Acceptance Criteria**:
- ReferenceFrame correctly converts between screen and genomic coordinates
- Track protocol supports async loading and rendering
- All track height calculations match IGV behavior

---

### Sequence Viewer Specialist (Role 03) - PRIMARY

**Deliverables**:
1. `LungfishUI/Rendering/TileCache.swift` - LRU tile cache
2. `LungfishUI/Rendering/TileKey.swift` - Cache key structure
3. `LungfishUI/Rendering/Tile.swift` - Rendered tile data

**Technical Decisions**:
- Actor-based cache for thread safety
- LRU eviction with configurable capacity
- Prefetch adjacent tiles during pan/zoom
- Tile invalidation on data change

**Acceptance Criteria**:
- Cache correctly evicts least-recently-used tiles
- Thread-safe access via Swift actors
- Memory usage stays within configurable bounds

---

### File Format Expert (Role 06) - PRIMARY

**Deliverables**:
1. `LungfishIO/Formats/FASTQ/FASTQReader.swift` - FASTQ parser
2. `LungfishIO/Formats/FASTQ/FASTQWriter.swift` - FASTQ writer
3. `LungfishIO/Formats/FASTQ/QualityScore.swift` - Quality encoding

**Technical Decisions**:
- Support Phred+33 (Sanger/Illumina 1.8+) and Phred+64 (Illumina 1.3-1.7)
- Auto-detect quality encoding from file
- Streaming via AsyncSequence for large files
- Preserve read pairing information in metadata

**Acceptance Criteria**:
- Parse standard FASTQ with quality scores
- Auto-detect Phred encoding
- Round-trip read-write produces identical output
- Handle multi-line sequences

---

### Bioinformatics Architect (Role 05) - ADVISORY

**Guidance Provided**:
- Verify ReferenceFrame coordinate math matches IGV
- Ensure Track protocol can support all planned track types
- Review FASTQ quality score encoding decisions

---

### UI/UX Lead (Role 02) - ADVISORY

**Guidance Provided**:
- Ensure TileCache respects system memory pressure notifications
- ReferenceFrame should be observable for SwiftUI bindings
- Track heights should be user-adjustable via drag

---

### Testing & QA Lead (Role 19) - VERIFICATION

**Test Requirements**:
1. ReferenceFrame coordinate conversion tests
2. TileCache eviction behavior tests
3. FASTQ parser tests with sample files
4. Track protocol conformance tests

---

## Implementation Order

Based on dependencies, experts will implement in this order:

```
Week 1:
├── Track Rendering Engineer → ReferenceFrame.swift
├── Track Rendering Engineer → Track.swift protocol
└── File Format Expert → FASTQReader.swift

Week 2:
├── Sequence Viewer Specialist → TileCache.swift
├── Track Rendering Engineer → RenderContext.swift
└── File Format Expert → FASTQWriter.swift

Week 3:
├── Integration testing
└── QA sign-off
```

---

## Expert Assignments Summary

| Expert | Files | Priority |
|--------|-------|----------|
| Track Rendering Engineer (04) | ReferenceFrame, Track, DisplayMode, RenderContext | HIGH |
| Sequence Viewer Specialist (03) | TileCache, TileKey, Tile | HIGH |
| File Format Expert (06) | FASTQReader, FASTQWriter, QualityScore | HIGH |
| Testing & QA Lead (19) | Test cases for all deliverables | HIGH |
| Bioinformatics Architect (05) | Code review, algorithm validation | MEDIUM |
| UI/UX Lead (02) | API design review | MEDIUM |

---

## Questions for Resolution

### Q1: ReferenceFrame - Class or Struct?

**Track Rendering Engineer**: I recommend `class` with `@Observable` macro for SwiftUI binding support. The frame is shared across tracks and needs reference semantics.

**UI/UX Lead**: Agreed. Use `@Observable` (not ObservableObject) for modern SwiftUI.

**Swift Architect**: Approved. Use `@Observable class ReferenceFrame`.

**Decision**: ✅ `@Observable class`

---

### Q2: TileCache - Generic or Specific?

**Sequence Viewer Specialist**: Should TileCache be generic `TileCache<T>` or specific to rendered images?

**Swift Architect**: Make it generic. We'll need caches for rendered tiles, feature data, and coverage data.

**Decision**: ✅ Generic `actor TileCache<Key: Hashable, Value>`

---

### Q3: FASTQ Quality - Separate Type or Inline?

**File Format Expert**: Should quality scores be a separate `QualityScore` type or just `[UInt8]`?

**Bioinformatics Architect**: Separate type for type safety and encoding information.

**Decision**: ✅ Separate `QualityScore` type with encoding enum

---

## Meeting Conclusion

All experts have accepted their Phase 2 assignments. Implementation begins immediately.

**Next Review**: Upon completion of Week 1 deliverables.

---

*Meeting adjourned. Experts proceed with implementation.*
