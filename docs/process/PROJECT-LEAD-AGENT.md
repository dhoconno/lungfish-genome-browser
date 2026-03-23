# Project Lead Agent — Development Process Specification

## Overview

The Project Lead Agent orchestrates all feature development and bug fixing through a structured, multi-expert process. Every change — from single bug fixes to major features — follows the same workflow to ensure quality, correctness, and consistency.

## Development Workflow

### Phase 0: Persist Plans to Disk
Before any implementation begins, all plans, phase breakdowns, and expert recommendations MUST be written to `docs/plans/` or `docs/reviews/`. This ensures plans survive context compaction and can be referenced across sessions.

### Phase 1: Expert Investigation
Assemble a team of relevant experts to investigate the issue independently:

| Expert | Focus |
|--------|-------|
| **Bioinformatics** | Domain correctness, scientific accuracy, tool parameters |
| **Genomics** | Data models, file formats, biological conventions |
| **Swift/macOS** | Language patterns, concurrency, Swift 6.2 best practices |
| **macOS 26 / AppKit** | Platform APIs, deprecated patterns, system integration |
| **UX Designer** | User workflows, information architecture, interaction design |
| **UI/HIG Expert** | Apple Human Interface Guidelines, visual consistency |
| **Database Expert** | Data storage, indexing, query optimization |
| **QA/QC Expert** | Test coverage, edge cases, regression prevention |

Not all experts are needed for every issue — the Project Lead selects the relevant subset.

### Phase 2: Expert Consensus Meeting
Experts present findings and reach consensus on:
- Root cause analysis (for bugs)
- Architecture approach (for features)
- Risk assessment
- Test strategy

The consensus is written to disk as a plan document.

### Phase 3: Phase Breakdown
Project managers break the plan into logical phases where:
- Each phase is independently testable and committable
- No phase exceeds ~500 lines of new code
- Phases that touch different files can run in parallel
- **Collision prevention**: No two parallel tasks modify the same file
- Dependencies between phases are explicit

### Phase 4: Implementation
For each phase:
1. Expert agent implements the code
2. Build verification (zero errors)
3. Run existing tests (zero regressions)
4. Run new tests for the phase
5. Code review by expert team
6. Project manager sign-off
7. Commit with detailed message

### Phase 5: Expert Review
After all phases are complete:
- Expert teams reconvene to review the full implementation
- UX/UI experts evaluate the user experience
- QA/QC experts verify test coverage
- Bioinformatics experts validate scientific correctness
- If issues are found → iterate (return to Phase 1 for the specific issue)

### Phase 6: Integration Testing
- CLI implementations test the same code paths as GUI
- Simulated data tests provided by genomics experts
- End-to-end workflow tests
- Performance benchmarks for data transformation operations

---

## Fundamental Principles

### Platform
- **Target**: macOS 26 (Tahoe) exclusively. No backward compatibility needed.
- **Swift 6.2**: Use latest language features, strict concurrency.
- **SwiftUI preferred**, AppKit as fallback for:
  - Custom CoreGraphics rendering (sunburst, sequence viewer)
  - NSOutlineView (hierarchical tables)
  - NSTrackingArea (hover interactions)
  - Performance-critical views

### Apple HIG Compliance
- Follow current Apple Human Interface Guidelines at all times
- Use SF Symbols for all icons
- Use system colors (`.primary`, `.secondary`, `.accentColor`)
- Support Dark Mode in all views
- Use `beginSheetModal` for dialogs (NEVER `runModal()`)
- Standard keyboard shortcuts (Cmd-C, Cmd-V, Cmd-Z, etc.)
- Accessibility: VoiceOver labels on all custom views

### Operations Panel
Every data transformation operation MUST:
1. Register with `OperationCenter.shared.start()` before beginning
2. Report progress via `OperationCenter.shared.update()` during execution
3. Report completion via `OperationCenter.shared.complete()` or `.fail()`
4. Support cancellation via `OperationCenter.shared.setCancelCallback()`
5. Be visible in the Operations Panel with meaningful status messages

### Logging
All operations MUST log to os.log using `LogSubsystem` constants:
- `LogSubsystem.core` for data models and services
- `LogSubsystem.io` for file format parsing
- `LogSubsystem.ui` for rendering
- `LogSubsystem.workflow` for tool execution and pipelines
- `LogSubsystem.app` for UI and view controllers
- `LogSubsystem.plugin` for plugin system
- Use `.public` privacy for non-sensitive values
- Use `.debug` level for diagnostic info, `.info` for normal operations, `.error` for failures

### Provenance
All data transformations MUST record provenance:
- Tool name and version
- All parameters used
- Input file(s) with checksums where practical
- Output file(s)
- Database version (if applicable)
- Runtime and resource usage
- Provenance records saved as JSON sidecars

### Concurrency Patterns
Follow established patterns from MEMORY.md:
- `DispatchQueue.main.async { MainActor.assumeIsolated { } }` for UI updates from background
- `Task.detached` for long-running pipelines (NOT `Task { @MainActor in }`)
- `@unchecked Sendable` pattern for view models that run from detached contexts
- Generation counters for stale result prevention
- `nonisolated(unsafe)` for captures crossing isolation boundaries

### CLI Parity
Every data operation accessible through the GUI MUST also have a CLI equivalent:
- Same underlying code (shared pipeline actors)
- CLI tests validate the same code paths
- CLI can be used for automated testing without GUI

### Testing Requirements
- Every new feature requires tests BEFORE the feature ships
- Tests use simulated data provided by genomics experts
- Edge cases: empty files, special characters, very large inputs
- Regression tests for all bug fixes
- Performance tests for data-intensive operations

---

## File Organization

### Plans and Reviews
```
docs/plans/          — Implementation plans and phase breakdowns
docs/reviews/        — Expert review documents
docs/designs/        — UX/UI design specifications
docs/process/        — This file and process documentation
```

### Phase Tracking
Each major feature has a `phase-tracking.md` file in `docs/plans/` that records:
- Phase status (not started / in progress / complete / blocked)
- Test results per phase
- Sign-off status
- Commit hashes

---

## Expert Team Assembly Guide

### For Bug Fixes
Minimum team: Swift expert + domain expert (bioinformatics/genomics) + QA

### For UI Features
Full team: UX + UI/HIG + Swift + macOS + domain expert + QA

### For Pipeline Features
Full team: Bioinformatics + Genomics + Swift + Database + QA

### For Format Handling
Minimum team: Bioinformatics + Swift + QA

---

## Anti-Patterns to Avoid

1. **Never implement without a persisted plan** — Context can be compacted at any time
2. **Never skip expert review** — Even "simple" fixes can have domain implications
3. **Never modify files being edited by another agent** — Causes merge conflicts
4. **Never use `runModal()`** — Deprecated on macOS 26
5. **Never use `Task { @MainActor in }` from GCD** — Cooperative executor unreliable
6. **Never use paths with spaces for bioinformatics tools** — Many tools break
7. **Never skip Operations Panel registration** — Users need visibility into running tasks
8. **Never skip provenance recording** — Reproducibility is critical for scientific software
9. **Never create physical FASTQ copies when virtual derivatives suffice** — Wastes disk space
10. **Never hardcode tool versions** — Always detect dynamically
