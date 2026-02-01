# Lungfish Genome Browser

A next-generation **macOS-native genome browser** built in Swift, combining the visualization strengths of IGV with the rich editing capabilities of Geneious.

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![macOS 14+](https://img.shields.io/badge/macOS-14+-blue.svg)](https://www.apple.com/macos)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Features

### Core Capabilities
- **High-performance sequence visualization** with Metal GPU acceleration
- **Memory-efficient storage** using 2-bit DNA encoding
- **IGV-style track system** for annotations, alignments, and coverage
- **Rich sequence editing** with base-level selection and modification
- **Diff-based version control** for sequence history

### File Format Support
| Category | Formats |
|----------|---------|
| Sequences | FASTA, FASTQ, GenBank, 2bit |
| Alignments | BAM, CRAM, SAM (via htslib) |
| Annotations | GFF3, GTF, BED, VCF, BigBed |
| Coverage | BigWig, bedGraph |

### Integration
- **NCBI/ENA data access** - Download sequences with full annotations
- **Nextflow/Snakemake workflows** - Run and monitor bioinformatics pipelines
- **Multi-language plugin system** - Python, Rust, Swift, and CLI tool plugins
- **Built-in assembly** - SPAdes and MEGAHIT integration
- **Primer design** - Full Primer3 + PrimalScheme multiplex support

## Requirements

- **macOS 14 Sonoma** or later
- **Apple Silicon** (M1/M2/M3+) - native ARM64
- **8GB RAM** minimum (16GB+ recommended for large genomes)
- **SSD** required for optimal index performance

## Installation

### From Source

```bash
git clone https://github.com/yourusername/lungfish-genome-browser.git
cd lungfish-genome-browser
swift build -c release
```

### Using Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/lungfish-genome-browser.git", from: "0.1.0")
]
```

## Quick Start

```swift
import LungfishCore
import LungfishIO

// Read a FASTA file
let reader = try FASTAReader(url: fastaURL)
for try await sequence in reader.sequences() {
    print("\(sequence.name): \(sequence.length) bp")
}

// Random access with index
let indexed = try IndexedFASTAReader(url: fastaURL)
let region = GenomicRegion(chromosome: "chr1", start: 1000, end: 2000)
let subsequence = try await indexed.fetch(region: region)
```

## Architecture

Lungfish is organized into five Swift modules:

| Module | Purpose |
|--------|---------|
| **LungfishCore** | Core data models (Sequence, Annotation, Document) |
| **LungfishIO** | File format parsing and indexing |
| **LungfishUI** | Rendering, tracks, and visualization |
| **LungfishPlugin** | Multi-language plugin system |
| **LungfishWorkflow** | Nextflow/Snakemake integration |

## Design Philosophy

Lungfish follows **Apple Human Interface Guidelines** for a native macOS experience:

- Native AppKit controls (NSOutlineView, NSTableView, NSToolbar)
- SF Symbols for iconography
- Full Dark Mode and accessibility support
- Keyboard navigation and menu bar integration
- System integration (Spotlight, Quick Look, Services)

## Development

See [PLAN.md](PLAN.md) for the comprehensive development roadmap.

### Building

```bash
swift build           # Debug build
swift build -c release  # Release build
swift test            # Run tests (requires Xcode)
```

### Project Structure

```
LungfishGenomeBrowser/
├── Sources/
│   ├── LungfishCore/      # Core models and services
│   ├── LungfishIO/        # File format handlers
│   ├── LungfishUI/        # Rendering and tracks
│   ├── LungfishPlugin/    # Plugin system
│   └── LungfishWorkflow/  # Workflow integration
├── Tests/
├── roles/                 # Team role specifications
└── Package.swift
```

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **IGV** - Inspiration for track-based visualization architecture
- **Geneious** - Inspiration for sequence editing workflows
- **htslib** - BAM/CRAM/VCF file format support
- **Primer3** - Primer design algorithms
- **PrimalScheme** - Multiplex primer panel design

---

*Named after the Australian lungfish, one of the oldest living vertebrate species with a remarkably large genome (~43 Gb).*
