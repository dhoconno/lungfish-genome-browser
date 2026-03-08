# SPAdes Assembly Implementation Plan

## Consensus from Two Independent Expert Panels

### Panel 1: Swift/macOS Architect + Bioinformatics Pipeline Engineer + Genomics Assembly Specialist
### Panel 2: DevOps/Container Specialist + Genomics/Assembly Quality Expert + macOS UX/HIG Specialist

---

## 1. Runtime Strategy: Apple Containers Only (arm64-native)

**Decision: Apple Containerization is the sole container runtime.**

**Rationale:**
- Lungfish targets macOS 26 (Tahoe) on Apple Silicon -- Apple Containerization is always available
- Rosetta 2 deprecated in macOS 26.4, removed in macOS 28 -- amd64 containers have no future
- Apple Containers are 30% faster than Docker for arm64 workloads (19.4s vs 25.3s)
- Single runtime path eliminates dual-path testing complexity
- All target bioinformatics tools have arm64 bioconda packages (verified March 2026)

**Requirements:**
- macOS 26+ (Tahoe) on Apple Silicon -- this IS the minimum deployment target
- `com.apple.security.virtualization` entitlement + codesigning
- Bundled vmlinux kernel (15 MB) + init.rootfs.tar.gz (82 MB) already in app resources

---

## 2. Existing Infrastructure (Already Built)

The codebase has substantial scaffolding:

| Component | Status | Location |
|-----------|--------|----------|
| `AssemblyConfigurationView` (SwiftUI sheet) | Complete UI with presets, file drag-and-drop, k-mer config, progress/log | `Sources/LungfishApp/Views/Assembly/` |
| `AssemblyConfigurationViewModel` | Has `simulateAssembly()` placeholder | Same directory |
| `AppleContainerRuntime` | Apple Containerization implementation | `Sources/LungfishWorkflow/Engines/` |
| `ContainerConfiguration` with `MountBinding` | Resource limits, volume mounts | Same directory |
| `ContainerProcess` with async streams | stdout/stderr streaming | Same directory |
| Menu wiring (`runSPAdes` action) | Connected through AppDelegate | `AppDelegate.swift` |
| `DefaultContainerImages` | Image catalog (SPAdes entry missing) | `Sources/LungfishWorkflow/Containers/` |
| `AssemblyAlgorithm` enum | Defines `dockerImage` for SPAdes | `Sources/LungfishApp/Views/Assembly/` |

**The key missing piece is `SPAdesAssemblyPipeline`** -- the engine connecting configuration to container execution to bundle creation.

---

## 3. Architecture Decision: Pipeline Class Pattern

**Both panels agree:** Follow the `GenomeDownloadViewModel` pattern.

- `@unchecked Sendable` class (NOT `@MainActor`) -- required for `Task.detached` contexts
- Progress via `@Sendable (Double, String) -> Void` callback
- UI updates via `DispatchQueue.main.async { MainActor.assumeIsolated { ... } }`
- This is the proven pattern per MEMORY.md for background pipelines

---

## 4. Container Image Strategy

### REVISED: arm64-Native Images (Post-Containerization Testing)

**Hands-on testing (March 2026) established critical findings:**

1. **Rosetta 2 is being deprecated:** Warnings in macOS 26.4, full removal expected macOS 28 (Fall 2027)
2. **BioContainers images are amd64-only** despite bioconda having linux-aarch64 packages
3. **arm64-native is 4-6x faster** than amd64/Rosetta emulation

**Performance benchmarks (SPAdes --test):**
| Runtime | Architecture | Time | Relative |
|---------|-------------|------|----------|
| Apple Containers | arm64-native | 19.4s | 1.0x (fastest) |
| Docker | arm64-native | 25.3s | 1.3x |
| Docker | amd64/Rosetta | 112s | 5.8x slower |

**Strategy: Build arm64-native images from bioconda**

```dockerfile
FROM condaforge/miniforge3:latest
RUN mamba install -y -c conda-forge -c bioconda spades=4.0.0 && \
    mamba clean -afy
RUN spades.py --version
CMD ["/bin/bash"]
```

- Build with: `docker build --platform linux/arm64 -t lungfish/spades:4.0.0-arm64 .`
- This pattern works for ANY bioconda tool with `linux-aarch64` support
- Pin version for reproducibility
- Add `ContainerImageSpec` to `DefaultContainerImages.swift`

**Runtime: Apple Containerization only (arm64-native)**

**Constraints (confirmed by testing):**
- `ContainerManager.create()` hardcodes `Platform.current` -- arm64 images only
- OCI layout import via `ImageStore.load(from: URL)` works for arm64 images
- NAT networking works without `com.apple.vm.networking` entitlement
- Requires `com.apple.security.virtualization` entitlement + codesigning
- Bundled vmlinux kernel (15 MB) + init.rootfs.tar.gz (82 MB) already in app resources

**Critical gotcha (Team 2):** SPAdes `--memory` flag MUST match or be less than container memory limit. If the container gets 16 GB but SPAdes is told `--memory 32`, it will be OOM-killed silently.

---

## 5. SPAdes Mode Support

| Preset | SPAdes Flag | K-mer Strategy | Memory | Notes |
|--------|------------|---------------|--------|-------|
| Bacterial Isolate | `--isolate` | Auto | 16 GB | Primary use case |
| Metagenome | `--meta` | 21,33,55,77 | 32+ GB | MetaSPAdes mode |
| Viral | `--isolate` | Auto | 4-8 GB | Small genome, fast |
| Plasmid | `--plasmid` | Auto | 8 GB | **Add this preset** |
| RNA (transcriptome) | `--rna` | Auto | 16 GB | **Add this preset** |

**Important (Team 2):** The `--careful` flag is deprecated in SPAdes 4.0. Remove the "Careful mode" checkbox from the UI. `--isolate` provides similar mismatch correction.

---

## 6. File Structure

### New Files to Create

| File | Module | Purpose |
|------|--------|---------|
| `Sources/LungfishWorkflow/Assembly/SPAdesAssemblyPipeline.swift` | LungfishWorkflow | Core pipeline: container execution, command construction, output collection |
| `Sources/LungfishWorkflow/Assembly/AssemblyBundleBuilder.swift` | LungfishWorkflow | Creates `.lungfishref` bundle from assembly output |
| `Sources/LungfishWorkflow/Assembly/SPAdesOutputParser.swift` | LungfishWorkflow | Parses spades.log for progress, statistics, errors |
| `Sources/LungfishWorkflow/Assembly/AssemblyProvenance.swift` | LungfishWorkflow | Reproducibility metadata: checksums, versions, parameters |
| `Sources/LungfishIO/Assembly/AssemblyStatistics.swift` | LungfishIO | Pure Swift N50/L50/GC computation from FASTA |
| `Tests/LungfishWorkflowTests/SPAdesAssemblyPipelineTests.swift` | Tests | Mock container runtime tests |
| `Tests/LungfishWorkflowTests/SPAdesOutputParserTests.swift` | Tests | Log parsing tests |
| `Tests/LungfishWorkflowTests/AssemblyBundleBuilderTests.swift` | Tests | Bundle creation tests |

### Existing Files to Modify

| File | Change |
|------|--------|
| `AssemblyConfigurationViewModel.swift` | Replace `simulateAssembly()` with real pipeline |
| `AssemblyConfigurationView.swift` | Add runtime status pill, SPAdes mode picker, remove `--careful`, add elapsed time, "Create Bundle" button |
| `DefaultContainerImages.swift` | Add SPAdes `ContainerImageSpec` |
| `BundleManifest.swift` | Add optional `assembly: AssemblyInfo?` with backward-compatible decoding |
| `AppDelegate.swift` | Wire `onAssemblyComplete` to open bundle in sidebar |

---

## 7. Data Flow

```
User: Tools > Assembly > SPAdes
  |
  v
AppDelegate.showAssemblyConfigurationSheet(algorithm: .spades)
  |
  v
AssemblyConfigurationView (SwiftUI sheet)
  - User adds FASTQ files, configures mode/k-mers/memory/threads
  - Runtime status shows "Apple Containers" with availability check
  - User clicks "Start Assembly"
  |
  v
AssemblyConfigurationViewModel.startAssembly()
  - Validates config, computes input file SHA-256 checksums
  - Creates SPAdesAssemblyPipeline (@unchecked Sendable)
  - Runs in Task.detached
  |
  v
SPAdesAssemblyPipeline.run(config:progress:)
  1. Create temp workspace, symlink input files (NO copying of multi-GB files)
  2. Get AppleContainerRuntime instance (already initialized at app startup)
  3. Pull lungfish/spades:4.0.0-arm64 image via ImageStore
  4. Create container with read-only input mount + read-write output mount
  5. Run `spades.py --version` to capture version string
  6. Build and execute SPAdes command
  7. Stream stderr for progress parsing (SPAdesOutputParser)
  8. On success: collect outputs, compute assembly statistics (pure Swift)
  9. Stop + remove container (in defer block for cleanup on error)
  10. Call AssemblyBundleBuilder -> .lungfishref with provenance
  |
  v
onAssemblyComplete -> AppDelegate opens bundle in sidebar
```

---

## 8. Volume Mounting Strategy (Team 2 Critical Insight)

**Do NOT copy FASTQ files.** Mount the parent directory read-only:

```swift
MountBinding(source: inputParentDir, destination: "/input", readOnly: true)
MountBinding(source: outputDir, destination: "/output", readOnly: false)
MountBinding(source: tempDir, destination: "/tmp/spades", readOnly: false)
```

Apple Containerization virtiofs shares provide near-native I/O. For files with spaces/special characters in paths, fall back to copying.

---

## 9. Assembly Statistics (Pure Swift, No QUAST)

**Both panels agree:** Compute metrics in pure Swift from `contigs.fasta`. No QUAST container needed for initial implementation.

| Metric | Description |
|--------|-------------|
| Total assembly length | Sum of contig lengths |
| Number of contigs | Count of FASTA records |
| Largest contig | Max contig length |
| N50 | Standard N50 calculation |
| L50 | Number of contigs >= N50 |
| GC content (%) | G+C / total bases |

QUAST can be a follow-up "Run Quality Assessment" button.

---

## 10. Progress Reporting

Parse SPAdes stderr for stage transitions:

| Log Pattern | Stage | Progress |
|------------|-------|----------|
| `== Running read error correction ==` | Error correction | 10% |
| `== Running assembler ==` | Assembly start | 30% |
| `== K21 ==` through `== K127 ==` | K-mer iterations | 30-70% (interpolated) |
| `== Mismatch correction ==` | Post-assembly | 75% |
| `== Scaffolding ==` | Scaffolding | 85% |
| `== Writing output ==` | Writing results | 90% |
| `== SPAdes pipeline finished ==` | Done | 95% |

**UX decisions:**
- Show elapsed time ("Running for 14m 32s"), NOT estimated time (too variable)
- Indeterminate progress for container pull, determinate for assembly stages
- Post `NSUserNotification` on completion when app is backgrounded

---

## 11. Error Handling

| Error | Detection | User Message | Recovery |
|-------|-----------|-------------|----------|
| No runtime | `AppleContainerRuntime` init fails | "Container runtime unavailable" | "Requires macOS 26+ on Apple Silicon" |
| Image pull fail | `imagePullFailed` | "Could not download SPAdes image" | "Check internet connection" |
| OOM kill | Log: `not enough memory` | "Assembly ran out of memory" | "Increase memory allocation or reduce k-mer sizes" |
| Disk full | Log: `No space left` | "Insufficient disk space" | "SPAdes needs ~5-10x input size" |
| Bad input | Pre-flight validation | "Cannot read file: <path>" | Specific file path shown |
| SPAdes error | Non-zero exit code | "SPAdes failed (exit N)" | "Check log for details" |
| User cancel | `Task.isCancelled` | Container stopped + removed | Settings preserved for retry |

Container cleanup in `defer` block ensures stop/remove even on error.

---

## 12. Reproducibility (provenance.json)

Stored in bundle's `assembly/` subdirectory:

```json
{
    "assembler": "SPAdes",
    "assembler_version": "4.0.0",
    "container_image": "lungfish/spades:4.0.0-arm64",
    "container_image_digest": "sha256:abc123...",
    "container_runtime": "apple_containerization",
    "host_os": "macOS 26.0",
    "host_architecture": "arm64",
    "lungfish_version": "1.0.0",
    "assembly_date": "2026-03-06T14:30:00Z",
    "wall_time_seconds": 3847,
    "command_line": "spades.py --isolate -1 /input/R1.fq.gz -2 /input/R2.fq.gz ...",
    "parameters": { "mode": "isolate", "k_mer_sizes": "auto", "memory_gb": 16, "threads": 8 },
    "inputs": [
        { "filename": "reads_R1.fq.gz", "sha256": "abc123...", "size_bytes": 1234567890 }
    ],
    "statistics": { "total_contigs": 42, "n50": 250000, "total_length_bp": 4800000 }
}
```

Also visible in Inspector as `MetadataGroup` entries.

---

## 13. Bundle Format

```
MyAssembly.lungfishref/
  manifest.json               # Standard manifest + assembly field
  genome/
    contigs.fa.gz             # bgzip-compressed contigs (primary sequence)
    contigs.fa.gz.fai         # samtools faidx index
    contigs.fa.gz.gzi         # bgzip index
  assembly/
    scaffolds.fa.gz           # bgzip-compressed scaffolds (optional)
    scaffolds.fa.gz.fai
    scaffolds.fa.gz.gzi
    assembly_graph.gfa        # Assembly graph
    spades.log                # Full log
    params.txt                # SPAdes parameters
    provenance.json           # Full reproducibility record
```

---

## 14. Long-Running Operation Handling (Team 2 UX Insights)

- **Sheet dismissal:** Do NOT allow sheet close during assembly. Show alert if attempted.
- **App quit:** Register for `willTerminateNotification`, gracefully stop container.
- **Sleep/lid close:** Apple Containerization VMs pause/resume with system sleep.
- **Background completion:** Post `NSUserNotification` with assembly summary stats.
- **Cancellation:** "Cancel" button stops container, removes it, cleans up workspace.

---

## 15. Test Datasets

### Primary Integration Test: DRR187559 (MRSA, S. aureus)
- ~40-50 MB compressed paired-end FASTQ
- 2-4 minutes assembly on Apple Silicon
- Well-documented (Galaxy Training Network tutorial dataset)
- Reference: CP000255.1 (USA300 FPR3757)
- Stable Zenodo URLs available

### Smoke Test: SPAdes Bundled ecoli_1K
- ~50 KB, <5 seconds
- Ships with SPAdes in `share/spades/test_dataset/`
- Zero network dependency

### Unit Test Mock: Simulated phiX174
- ~150 KB, <10 seconds
- 5,386 bp genome -> single contig expected
- Generate with ART read simulator or include as test fixture

---

## 16. Implementation Phases

### Phase 1: Core Pipeline (Priority)
1. Create `SPAdesAssemblyPipeline.swift` with container lifecycle and command construction
2. Create `SPAdesOutputParser.swift` for log parsing and progress
3. Create `AssemblyStatistics.swift` for pure Swift N50/L50/GC computation
4. Add SPAdes `ContainerImageSpec` to `DefaultContainerImages.swift`
5. Unit tests for parser, statistics, and command construction

### Phase 2: Bundle Builder
6. Create `AssemblyBundleBuilder.swift` using NativeToolRunner for bgzip/samtools
7. Create `AssemblyProvenance.swift` for reproducibility metadata
8. Add `AssemblyInfo` to `BundleManifest.swift` (backward-compatible decoding)
9. Bundle builder tests

### Phase 3: ViewModel Integration
10. Replace `simulateAssembly()` with real pipeline invocation
11. Wire progress callbacks through to UI
12. Wire `onAssemblyComplete` to open bundle in sidebar
13. Add SPAdes mode selection, remove deprecated `--careful`

### Phase 4: UI Polish & Error Handling
14. Add container runtime status indicator
15. Add elapsed time display
16. Improve no-runtime error dialog
17. Add disk space pre-flight check
18. Add cancellation support (terminate container)
19. Add `NSUserNotification` on background completion
20. Integration testing with DRR187559 dataset

---

## Key Divergences Resolved

| Topic | Team 1 | Team 2 | Consensus |
|-------|--------|--------|-----------|
| Colima | Don't embed | Don't embed | **Don't embed** |
| Image | staphb/spades:4.0.0 | staphb/spades:4.0.0 (+ mambaforge option) | **arm64-native from bioconda** (Rosetta deprecated) |
| `--careful` flag | Included as option | Deprecated in SPAdes 4.0, remove | **Remove** (follow SPAdes 4.0) |
| QUAST | Not in initial scope | Not in initial scope | **Follow-up feature** |
| Stats computation | In pipeline | Separate pure Swift module | **Separate file** (cleaner) |
| Test dataset | Not specified | DRR187559 (MRSA) + phiX174 | **DRR187559 primary, phiX174 mock** |
| File copying | Symlink input | Mount parent dir read-only | **Mount read-only** (simpler) |
| Bundle structure | assembly/ subdir | Same | **assembly/ subdir** |

---

## Appendix A: Containerization Testing Results (March 2026)

### Test Environment
- macOS Tahoe 26.0, Apple M2 Max, 32 GB RAM
- Apple Containerization framework v0.26.5 (open-source SPM package)
- Docker Desktop 4.x with Docker Engine

### Tests Performed
1. **Alpine arm64 container** -- Apple Containers: works perfectly, sub-second startup
2. **Volume mounts (read + write)** -- Apple Containers: virtiofs shares work, host sees output
3. **amd64 SPAdes via Rosetta** -- Apple Containers: FAILS (`ContainerManager.create()` hardcodes `Platform.current`)
4. **arm64 SPAdes (bioconda build)** -- Apple Containers: 19.4s, Docker: 25.3s, Docker amd64/Rosetta: 112s

### arm64 Bioinformatics Tool Availability (bioconda linux-aarch64)

#### Individual Tools (all verified arm64-ready)
| Tool | bioconda arm64 | Type | Notes |
|------|:-:|------|-------|
| SPAdes 4.0.0-4.2.0 | Yes | C++ | Tested, works in Apple Containers |
| MEGAHIT | Yes | C++ | NEON SIMD replaces SSE |
| Flye | Yes | C++/Python | Long-read assembler |
| Minimap2 | Yes | C | NEON-optimized ARM build |
| BBTools (bbmap) | Yes | Java (JVM) | Arch-independent bytecode |
| SeqKit | Yes | Go binary | Compiled for aarch64 |
| MAFFT | Yes | C | No known ARM issues |
| vsearch | Yes | C++ | No known ARM issues |
| hifiasm | Yes | C | SIMD via NEON on ARM |

#### Workflow Orchestrators
| Tool | bioconda arm64 | Type | Notes |
|------|:-:|------|-------|
| Nextflow | Yes (noarch) | JVM | Runs anywhere Java 17+ runs |
| Snakemake | Yes (noarch) | Python | Pure Python, arch-independent |

#### Pipelines
| Pipeline | Framework | ARM64 Ready | Dependencies |
|----------|-----------|:-:|-------------|
| TaxTriage | Nextflow | Yes | Kraken2, minimap2, bowtie2, samtools, MEGAHIT, Flye, fastp -- all have aarch64 |
| EsViritu | Shell/conda | Yes | minimap2, samtools, BBTools, bowtie2, SeqKit -- all have aarch64 |

### Key Technical Details
- Apple Container memory must be a multiple of 1 MiB (use `1024 * 1024 * 1024`, not `1_000_000_000`)
- Binary must be codesigned: `codesign --force --sign - --entitlements entitlements.plist <binary>`
- OCI layout import: `ImageStore.load(from:)` imports OCI layout directories
- **Base image**: `condaforge/miniforge3:latest` (mambaforge deprecated July 2024)
- Container pattern: `mamba install -y -c bioconda -c conda-forge <tool>=<version> && mamba clean -afy`
