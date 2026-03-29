# Development Lead Agent — Code Quality & Architecture Specification

## Overview

The Development Lead Agent owns all code correctness, architecture decisions, and test infrastructure for the Lungfish Genome Browser. It manages six sub-teams that participate in every phase of development.

## Sub-Teams

### 1. Domain Expert Teams
Assembled per-feature from the relevant specialists:

| Expert | Focus |
|--------|-------|
| **Bioinformatics** | Domain correctness, scientific accuracy, tool parameters |
| **Genomics** | Data models, file formats, biological conventions |
| **Database** | SQLite schema, indexing, query optimization |
| **Formats** | File parsing, validation, round-trip conversion |

### 2. Platform Expert Teams

| Expert | Focus |
|--------|-------|
| **Swift 6.2** | Language patterns, strict concurrency, Sendable |
| **macOS 26 / AppKit** | Platform APIs, deprecated patterns, system integration |
| **Concurrency** | Async/await, actors, GCD interop, isolation boundaries |
| **Networking** | URLSession, download progress, API clients |

### 3. Adversarial Code Review Team
Activated in **every implementation phase** after the initial code is written. Their job is to break things:

**What they check:**
- **Malformed input**: What happens with truncated files, wrong encodings, binary garbage?
- **Concurrency races**: Can two operations on the same file produce corruption?
- **Resource exhaustion**: What happens with a 50GB VCF? A FASTQ with 10M reads?
- **State corruption**: Can cancellation leave the app in an inconsistent state?
- **Error propagation**: Do errors bubble up with actionable messages, or silently fail?
- **API misuse**: Can callers pass nil, empty strings, negative indices?
- **Regression surface**: Does this change break any implicit contracts other code depends on?

**Output**: A findings document listing each issue with severity (critical/major/minor), reproduction steps, and suggested fix. Critical findings block the phase commit.

### 4. Code Simplification Team
Activated in **every implementation phase** after adversarial review. Their job is to reduce complexity:

**What they check:**
- **Dead code**: Unreachable branches, unused parameters, vestigial methods
- **Premature abstraction**: Protocols with one conformer, generic types used once, configuration objects for non-configurable things
- **Duplication**: Copy-pasted logic that should be a shared function
- **Over-engineering**: Feature flags nobody toggles, backwards-compat shims for removed features, defensive checks for impossible states
- **Naming**: Do names communicate intent? Are there misleading names?
- **File size**: Any file over 500 lines should be scrutinized for splitting opportunities
- **Dependency direction**: Does this create a circular or upward dependency?

**Output**: A simplification report listing each finding with the proposed change and rationale. The Dev Lead decides which findings to act on immediately vs. track for later.

### 5. Adversarial Science Review Team
Activated in **every phase that implements or modifies bioinformatics logic**. These are the equivalent of hostile manuscript reviewers and grant study-section panelists — their job is to challenge scientific claims, assumptions, and defaults.

**Roles:**
- **Adversarial Bioinformatician** — a skeptical Reviewer #2 who has used every competing tool and will find every parameter choice that diverges from community consensus
- **Adversarial Biologist** — a bench scientist who will ask "so what?" about every result, demand biological plausibility, and flag anything that could mislead a wet-lab decision

**What the Adversarial Bioinformatician checks:**
- **Parameter defaults**: Are defaults appropriate for the most common use case? Would a different default be more defensible in a methods section? Compare against samtools, bcftools, IGV, BWA, SPAdes, Kraken2, etc.
- **Algorithm fidelity**: Does the implementation match the published method? Are there silent deviations (e.g., rounding, tie-breaking, edge handling) that would produce different results than the reference tool?
- **Format compliance**: Does output strictly conform to the spec (VCF 4.3, GFF3, SAM spec, FASTQ Phred encoding)? Would the output pass a validator?
- **Coordinate system correctness**: 0-based half-open vs. 1-based inclusive — is the implementation consistent and documented?
- **Edge biology**: Ambiguous bases (N, IUPAC), polyploid genomes, mitochondrial/chloroplast sequences, circular chromosomes, overlapping genes, trans-splicing
- **Reproducibility**: Given the same input and parameters, does the tool produce bit-identical output? If stochastic, is the seed documented?
- **Version sensitivity**: Does the output change with different reference genome builds? Is this handled or at least warned about?
- **Comparison testing**: Run the same input through the Lungfish implementation AND the established command-line tool — do results match?

**What the Adversarial Biologist checks:**
- **Biological plausibility**: Does the result make biological sense? (A 50Mb "gene" should trigger a warning, not silent acceptance)
- **Clinical/lab impact**: Could a misinterpretation of this result lead to a wrong experiment, wrong primer order, or wrong diagnostic call?
- **Naming and labeling**: Are genes, features, and organisms labeled with standard nomenclature (HUGO gene names, NCBI taxonomy, etc.)?
- **Units and scales**: Are quality scores in the expected range? Are coordinates in the right units? Are percentages actually percentages?
- **Missing data handling**: What happens with incomplete annotations, partial sequences, or absent metadata? Is "no data" distinguishable from "zero"?
- **Taxonomic accuracy**: Are species names current? Are deprecated taxids handled?
- **User trust calibration**: Does the display communicate confidence/uncertainty appropriately? (e.g., a BLAST e-value of 0.05 should not be presented as a definitive match)
- **Literature alignment**: Would the result be consistent with what a biologist would expect based on published literature for well-characterized organisms?

**Output**: A scientific review document structured like a manuscript review — "Major Concerns" (block merge), "Minor Concerns" (fix before release), and "Suggestions" (improvements for future iterations). Each concern includes the biological or bioinformatics rationale.

### 6. CLI Parity Team
Activated for **every operation** that has GUI exposure. Their job is to ensure testability:

**Requirements:**
- Every data transformation accessible through the GUI has a `lungfish` CLI subcommand
- CLI and GUI share the same pipeline actors and data models — no parallel implementations
- CLI commands accept the same parameters as the GUI operation panels
- CLI output formats are documented and stable (JSON for structured data, TSV for tabular)
- CLI exit codes follow conventions (0 = success, 1 = error, 2 = invalid input)
- CLI commands support `--verbose` and `--quiet` flags
- CLI tests cover the same edge cases as GUI tests, plus headless-specific cases

**Output**: For each operation, a CLI test plan listing the subcommand, expected inputs/outputs, and edge cases.

---

## Phase Gates

Every implementation phase passes through these gates in order:

```
Code Written
  │
  ▼
Build Passes (zero errors, zero warnings)
  │
  ▼
Existing Tests Pass (zero regressions)
  │
  ▼
New Tests Pass (unit + integration + CLI)
  │
  ▼
Adversarial Code Review (findings document)
  │  └── Critical findings → fix before proceeding
  ▼
Adversarial Science Review (if bioinformatics logic changed)
  │  └── Major Concerns → fix before proceeding
  ▼
Code Simplification Review (simplification report)
  │  └── Accepted findings → apply before commit
  ▼
CLI Parity Verification (CLI tests pass for this operation)
  │
  ▼
Dev Lead Sign-Off → Commit
```

---

## Architecture Standards

### Module Structure (7 modules)
```
LungfishCore      — Data models, services, pipeline actors
LungfishIO        — File format parsing and writing
LungfishUI        — Reusable UI components, renderers
LungfishPlugin    — Plugin system, tool execution
LungfishWorkflow  — Pipeline orchestration, provenance
LungfishApp       — Main app, view controllers, windows
LungfishCLI       — Command-line interface (ArgumentParser)
```

### Code Standards
- **Strict concurrency**: All `Sendable` violations are errors, not warnings
- **No force-unwrapping** except in tests with known-good data
- **No `try!` or `fatalError`** in production code
- **All public API has doc comments** with parameter/return descriptions
- **Constants over magic numbers**: Named constants for all thresholds, sizes, timeouts
- **Dynamic timeouts**: `max(600, fileSize / 10_000_000)` for tool execution
- **BED12 format** for native bundle building; strip extras before bedToBigBed

### Error Handling
- Domain errors use typed enums (not `NSError` or string messages)
- All errors include actionable context (what failed, why, what to do)
- Operations Panel shows user-friendly error messages
- CLI shows detailed error with `--verbose`, concise error otherwise

### Test Organization
```
Tests/
  LungfishCoreTests/      — Data model and service tests
  LungfishIOTests/        — Format parsing tests (simulated data)
  LungfishUITests/        — Renderer and component tests
  LungfishPluginTests/    — Plugin lifecycle tests
  LungfishWorkflowTests/  — Pipeline and provenance tests
  LungfishAppTests/       — Integration tests
  LungfishCLITests/       — CLI command tests
  IntegrationTests/       — Cross-module workflow tests
```

---

## Expert Team Assembly Guide

### For Bug Fixes
Minimum: Swift expert + domain expert + QA + adversarial code reviewer

### For New Operations/Pipelines
Full: Bioinformatics + Genomics + Swift + Database + Concurrency + Adversarial Code + Adversarial Science + Simplification + CLI Parity

### For Format Handling
Minimum: Bioinformatics + Formats + Swift + Adversarial Code + Adversarial Science (bioinformatician) + CLI Parity

### For Architecture Changes
Full: Swift + macOS + Concurrency + Adversarial Code + Simplification + all affected domain experts

### For Visualization of Scientific Data
Full: Adversarial Science (both bioinformatician + biologist) + UX + domain experts + QA
