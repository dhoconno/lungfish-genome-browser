# VCF Variant Track Rendering Research

## Research Date: 2026-02-07
## Scope: IGV, Geneious, UCSC, JBrowse 2 approaches + architecture recommendations for Lungfish

---

## 1. IGV (Integrative Genomics Viewer) VCF Rendering

### 1.1 File Loading and Indexing

IGV uses **tabix-indexed VCF.gz** files as its primary VCF data source. The architecture
works as follows:

- VCF files must be bgzip-compressed and tabix-indexed (.vcf.gz + .vcf.gz.tbi)
- IGV implements a **visibility window** -- data loads only when the viewed region is
  smaller than a configurable threshold. Regions exceeding this threshold display
  "Zoom in to see features"
- For local files, IGV reads directly from disk using tabix random access
- For remote files, IGV fetches only the BGZF blocks needed for the viewed region via
  HTTP range requests

The tabix index uses a dual-index strategy:
- **Binning index**: For fast overlap queries on genomic intervals
- **Linear index**: For efficient sequential scanning within regions
- Virtual file offsets (48-bit compressed offset + 16-bit uncompressed offset) enable
  seeking directly to any position without full decompression
- Standard .tbi index handles chromosomes up to 512 Mbp; CSI index required for larger

### 1.2 Display Modes

IGV's VariantTrack (Java class: `org.broad.igv.variant.VariantTrack`) supports three
display modes:

| Mode | Variant Band | Genotypes | Row Height |
|------|-------------|-----------|------------|
| **COLLAPSED** | Single row, all calls | Hidden | 25px (variant band) |
| **SQUISHED** | Multi-row | Shown, compressed | 4px per sample |
| **EXPANDED** (default) | Multi-row | Shown, full detail | 15px per sample |

The track visually has two main regions:
1. **Variant band** (top): Two-color stacked bar per variant site showing allele proportions
2. **Genotype grid** (below): One row per sample, colored by zygosity

### 1.3 Color Coding

**Variant Band (allele frequency bar):**
- Blue = reference allele proportion
- Red = alternate allele proportion
- Bar height indicates frequency/fraction
- Default metric: allele frequency (configurable to allele fraction)

**Genotype Colors (default IGV palette):**
- Homozygous alternate (HomVar): **Cyan** `rgb(17, 248, 254)`
- Heterozygous (Het): **Dark blue** `rgb(34, 12, 253)`
- Homozygous reference (HomRef): **Light gray** `rgb(200, 200, 200)`
- No call: **Near-white** `rgb(250, 250, 250)`

**Color-by modes in IGV (genotypeColorMode):**
- GENOTYPE: Default zygosity-based coloring
- ALLELE_FREQUENCY: Population frequency gradient
- ALLELE_FRACTION: Per-variant fraction gradient
- METHYLATION_RATE: Activated when FORMAT field "MR" is detected

**Site-level coloring (siteColorMode):**
- Can color by any INFO field value using colorBy + colorTable configuration
- Custom color functions supported in igv.js (takes variant object, returns color)

### 1.4 INFO/FORMAT Field Display

When hovering over a variant in IGV:
- **Variant popup** shows: CHROM, POS, ID, REF, ALT, QUAL, FILTER, and all INFO fields
- Annotation-specific fields are grouped (e.g., VEP's CSQ block, SnpEff's ANN tag)
- **Genotype popup** shows: Sample name, GT, GQ, DP, and all FORMAT fields for that sample

### 1.5 Multi-Sample VCF Handling

IGV's architecture for multi-sample VCFs:

- Each sample gets its own horizontal row in the genotype grid
- Sample names displayed in a left-side panel
- **Sorting options** (right-click on genotype column):
  - By genotype at clicked locus
  - By sample name (alphabetical)
  - By read depth (DP field)
  - By genotype quality (GQ field)
  - Reverse toggle on repeated clicks
- **Grouping** by sample attributes (requires external attribute file)
- Sample groups separated by 3-pixel borders with alternating band colors

### 1.6 Zoom-Level Behavior

IGV does NOT use density histograms for VCF tracks at zoomed-out views. Instead:
- At wide zoom: variants are rendered as thin vertical lines; if too dense (< 3px apart),
  they merge visually but remain individual elements
- Minimum 3px spacing enforced between variant markers
- Gaps drawn when pixel width exceeds 5px
- At base-pair zoom: individual nucleotide changes visible with full genotype detail
- The visibility window mechanism prevents rendering at very wide zooms entirely

### 1.7 Rendering Architecture (from VariantTrack.java)

Key implementation details from the IGV Java source:
- `renderFeatureImpl()` coordinates variant band + genotype grid rendering
- Position calculation: `pX = (start - origin) / locScale`
- `renderSamples()` iterates through sample groups, delegates to
  `renderer.renderGenotypeBandSNP()` for actual drawing
- `hideFiltered` flag suppresses filtered variants from display
- Background alternates between `BAND1_COLOR` and `BAND2_COLOR` for readability
- Selected samples highlighted with `SELECTED_BAND_COLOR`

---

## 2. UCSC Genome Browser VCF Rendering

The UCSC browser takes a different approach:

**Three color schemes available:**
1. **Invisible reference**: Reference alleles invisible; alternates black with grayscale mixing
2. **Blue/red scheme**: Reference = blue, alternate = red, purple for mixtures
3. **Base coloring**: A=red, C=blue, G=green, T=magenta, gray for mixed

**Haplotype sorting** for multi-sample VCFs:
- Splits into haplotypes
- Clusters by similarity around a central variant
- Identical haplotype clusters shown in purple
- Hierarchical sorting within clusters

**Filtering:**
- QUAL score thresholds
- FILTER column values from VCF headers
- Minor allele frequency (using AF or AC+AN INFO fields)

---

## 3. JBrowse 2 Variant Track Rendering

JBrowse 2 offers the most modern multi-sample approach:

- **Standard position-based view**: Traditional per-variant display
- **Matrix/heatmap display**: Dense visualization for population VCFs
  - Puts all variants in a matrix-style grid
  - Each cell represents a genotype call
  - Reveals population-scale patterns
- **Phased rendering mode**: Renders each phase as individual row
- **Feature density calculation**: `maxFeatureScreenDensity` controls zoom behavior
- Supports SVLEN-based END inference for structural variants (VCF 4.5)

---

## 4. Geneious Approach

Geneious Prime takes a database-centric approach:

- **Import model**: VCF files are imported into Geneious's internal database
- Annotations from VCF stored as tracks on reference sequences
- If VCF lacks sequence data, user is prompted for reference on import
- Variant properties shown as tooltip on hover: Name, Type, Length, Interval, Sequence
- Annotations table displays: Change, Coverage, Reference Frequency
- **Polymorphism types**: SNP (Transition), SNP (Transversion), multi-SNP, Substitution,
  Insertion, Deletion, Mixture
- All data organized in Geneious's folder-based project structure (proprietary format)
- Uses internal database rather than direct file access for querying

---

## 5. GenomeBrowse (Golden Helix) Approach

GenomeBrowse provides a clean reference for zoom-level behavior:

- **Chromosome scale**: Gray-scale density plot showing variant locations
- **Gene scale**: Individual colored dots overlaid on genome annotation tracks
- **Base-pair scale**: Full variant detail with VCF information popups
- **Zygosity display**: Each sample row split vertically; single color = homozygous alt,
  two colors = heterozygous
- Reference-matching data downplayed at close zoom; optionally hidden at all zooms

---

## 6. Architecture Recommendations for Lungfish

### 6.1 Tabix-Indexed VCF.gz vs SQLite -- Tradeoff Analysis

| Criterion | Tabix VCF.gz | SQLite Database |
|-----------|-------------|-----------------|
| **Region queries** | Excellent (purpose-built) | Good with spatial index |
| **Complex queries** | Poor (must scan all records) | Excellent (full SQL) |
| **File compatibility** | Standard bioinformatics format | Proprietary to app |
| **Memory usage** | Minimal (stream decompression) | Moderate (index in memory) |
| **Write performance** | Read-only | Read-write |
| **Multi-sample filtering** | Must parse FORMAT fields | Pre-indexed columns |
| **Setup cost** | Zero (read existing files) | Import step required |
| **Portability** | Universal (IGV, UCSC, JBrowse) | App-specific |
| **Large file support** | Excellent (handles GB-scale VCFs) | Good but import is slow |

### 6.2 Recommended Hybrid Architecture

**Primary recommendation: Tabix VCF.gz for reading + optional SQLite cache for analysis.**

**Phase 1 -- Direct tabix VCF.gz access (implement first):**

The Lungfish project already has bgzip decompression infrastructure in
`BgzipIndexedFASTAReader.swift`. The same BGZF block reading and GZI index parsing
can be adapted for tabix-indexed VCF files. The approach:

1. Parse the .tbi tabix index to build a chromosome-to-block mapping
2. For a given genomic region, find relevant BGZF blocks via the tabix index
3. Decompress only those blocks (using existing BGZF infrastructure)
4. Parse the decompressed text lines as VCF records using existing `VCFReader`
5. Filter to the exact requested region

This leverages existing code in the project:
- `GZIIndex` struct and BGZF decompression (BgzipIndexedFASTAReader.swift)
- `VCFReader` parser with full header, variant, and genotype parsing
- `VCFVariant`, `VCFGenotype`, `VCFHeader` data models
- `VariantTrack` with display settings and region filtering

Key implementation tasks:
- Write a `TabixIndex` parser (binary format: magic number, sequence dictionary,
  binning + linear index per chromosome)
- Write a `TabixVCFReader` that wraps `VCFReader` with random-access capability
- Implement a `VariantTrackDataSource` conforming to `TrackDataSource` protocol

**Phase 2 -- SQLite cache (optional, for analysis features):**

For features like cross-chromosome queries, allele frequency filtering, and sample
subsetting, add an optional SQLite import layer:

```
Table: variants
  - id INTEGER PRIMARY KEY
  - chrom TEXT
  - pos INTEGER
  - ref TEXT
  - alt TEXT
  - qual REAL
  - filter TEXT
  - variant_type TEXT (SNP, INS, DEL, MNP, COMPLEX)

Table: genotypes
  - variant_id INTEGER FK
  - sample_name TEXT
  - gt TEXT
  - dp INTEGER
  - gq INTEGER
  - is_het BOOLEAN
  - is_hom_alt BOOLEAN

Indices: (chrom, pos), (variant_type), (sample_name, chrom)
```

### 6.3 Minimal VCF Parsing Requirements

The existing `VCFReader.swift` already covers all essential parsing. What is needed
additionally for a rendering-ready implementation:

1. **Tabix index parsing** -- Read .tbi binary format
2. **BGZF random access for VCF** -- Adapt existing BgzipIndexedFASTAReader
3. **Variant type classification** -- Already implemented in `VariantTrack.swift`
   (`VariantType` enum with SNP, MNP, INS, DEL, COMPLEX, REF)
4. **Genotype classification** -- Already implemented in `VCFGenotype` struct
   (isHomRef, isHomAlt, isHet, isPhased)
5. **Region windowing** -- Already implemented in `VariantTrack.variants(inRegion:)`

---

## 7. Variant Rendering Design Specification

### 7.1 Three-Tier Zoom Model

The variant track should render differently at three zoom levels, following the
GenomeBrowse/IGV hybrid approach:

#### Tier 1: Chromosome Scale (> 1 Mbp visible)

**Appearance**: Density histogram
- Bin variants into windows (e.g., 10kb bins)
- Render as a bar chart where bar height = variant count per bin
- Color bars by dominant variant type in each bin:
  - Green-dominant bin = mostly SNPs
  - Red-dominant bin = mostly deletions
  - Purple-dominant bin = mostly insertions
  - Gray = mixed types
- Alternatively: uniform color density plot (dark = dense, light = sparse)
- No individual variant markers visible
- No genotype grid shown

**Purpose**: Overview of variant distribution across the chromosome. Identify
hotspots, deserts, and structural patterns.

**Implementation**:
```
let binSize = max(1000, Int(visibleBases / 500))  // ~500 bins across screen
var bins: [Int: (snp: Int, ins: Int, del: Int, other: Int)] = [:]
for variant in visibleVariants {
    let binIndex = variant.position / binSize
    bins[binIndex, default: (0,0,0,0)].snp += variant.isSNP ? 1 : 0
    // ... etc
}
// Render bars proportional to max bin count
```

#### Tier 2: Gene Scale (1 kbp -- 1 Mbp visible)

**Appearance**: Lollipop or tick-mark plot
- Each variant rendered as a small vertical mark (2-4px wide)
- Height indicates quality score or allele frequency
- Color by variant type:
  - SNP: **Green** `(0, 153, 0)`
  - Insertion: **Purple** `(153, 0, 153)`
  - Deletion: **Red** `(204, 0, 0)`
  - MNP: **Teal** `(0, 128, 128)`
  - Complex: **Orange** `(230, 128, 0)`
- Variants too close together collapse into a colored block showing the count
- Variant ID labels shown if space permits (> 10px per variant)
- Single-sample mode: no genotype grid
- Multi-sample mode: simplified genotype grid (1px per sample row in SQUISHED mode)

**Purpose**: See individual variant positions in gene context, identify variant
clusters, compare variant density to gene structure.

#### Tier 3: Base-Pair Scale (< 1 kbp visible)

**Appearance**: Full detail view
- Each variant rendered as a colored rectangle at its exact position
- Width = reference allele length in screen pixels
- For SNPs at sufficient zoom: show the actual nucleotide change (e.g., "A>G")
- **Variant band** (top section, ~25px):
  - Two-color stacked bar: blue (ref) + red (alt) proportional to allele frequency
  - If no allele frequency data, render as solid colored rectangle by variant type
- **Genotype grid** (below variant band, if multi-sample):
  - One row per sample (10-15px in EXPANDED, 1-4px in SQUISHED)
  - Cell color:
    - HomRef: `rgb(200, 200, 200)` -- light gray
    - Het: `rgb(34, 12, 253)` -- dark blue
    - HomAlt: `rgb(17, 248, 254)` -- cyan
    - No call: `rgb(250, 250, 250)` -- near white
  - Sample names in left margin
- Tooltip on hover shows full VCF record details
- Filtered variants shown dimmed or hidden (configurable)

**Purpose**: Detailed variant inspection, genotype comparison across samples,
variant validation context.

### 7.2 Color Palette Summary

#### Variant Type Colors (for variant band and density views)

| Type | Color | RGB | Hex |
|------|-------|-----|-----|
| SNP | Green | (0, 153, 0) | #009900 |
| Insertion | Purple | (153, 0, 153) | #990099 |
| Deletion | Red | (204, 0, 0) | #CC0000 |
| MNP | Teal | (0, 128, 128) | #008080 |
| Complex | Orange | (230, 128, 0) | #E68000 |
| Reference | Gray | (128, 128, 128) | #808080 |

#### Genotype Colors (for genotype grid)

| Genotype | Color | RGB | Hex |
|----------|-------|-----|-----|
| Homozygous Alt | Cyan | (17, 248, 254) | #11F8FE |
| Heterozygous | Dark Blue | (34, 12, 253) | #220CFD |
| Homozygous Ref | Light Gray | (200, 200, 200) | #C8C8C8 |
| No Call | Near White | (250, 250, 250) | #FAFAFA |

#### Allele Frequency Bar Colors

| Allele | Color | RGB |
|--------|-------|-----|
| Reference | Blue | (50, 50, 200) |
| Alternate | Red | (200, 50, 50) |

### 7.3 Variant Track Shapes and Symbols

At gene-to-base-pair scale, use these shapes to distinguish variant types:

| Type | Shape | Rationale |
|------|-------|-----------|
| SNP | Diamond / vertical tick | Small, point-like variant |
| Insertion | Upward triangle / caret | Points to insertion site |
| Deletion | Horizontal bar / bracket | Spans the deleted region |
| MNP | Rectangle | Multi-base region |
| Complex | Star / asterisk | Unusual, attention-drawing |
| SV/BND | Arrow / connector | Indicates breakpoint connection |

### 7.4 Interaction Design

- **Hover**: Show tooltip with variant summary (type, position, alleles, quality)
- **Click**: Show detail popover with full VCF record (all INFO fields, all sample genotypes)
- **Right-click**: Context menu with:
  - Copy variant to clipboard
  - Sort samples by genotype at this locus
  - Filter by variant type
  - Change color scheme
  - Show/hide genotype grid
  - Jump to variant in external database (dbSNP, ClinVar)
- **Double-click**: Zoom to show variant in base-pair context

---

## 8. Implementation Roadmap

### Phase 1: Core VCF Track (MVP)

1. Implement `TabixIndex` parser (read .tbi binary format)
2. Implement `TabixVCFDataSource` (random-access VCF reading using tabix + existing BGZF)
3. Implement `VariantTrackRenderer` conforming to existing `Track` protocol
4. Render variants as colored tick marks at gene scale
5. Render variant detail at base-pair scale
6. Tooltip on hover with variant information

### Phase 2: Multi-Sample Support

1. Add genotype grid rendering below variant band
2. Implement sample sorting (by genotype, name, depth, quality)
3. SQUISHED and EXPANDED display modes for genotype grid
4. Color genotypes by zygosity (HomRef/Het/HomAlt)

### Phase 3: Density View

1. Implement variant density binning for chromosome-scale view
2. Render density histogram with type-based coloring
3. Smooth transition between density and individual variant views

### Phase 4: Advanced Features

1. Color-by-INFO-field (arbitrary field selection)
2. Allele frequency bar rendering
3. Filtering UI (quality, type, sample)
4. SQLite cache for complex queries
5. JBrowse-style matrix/heatmap view for population VCFs

---

## 9. Existing Codebase Assessment

The Lungfish project already has substantial VCF infrastructure:

**Ready to use:**
- `/Sources/LungfishIO/Formats/VCF/VCFReader.swift` -- Full VCF parser with header,
  variant, and genotype parsing. Async streaming support.
- `/Sources/LungfishCore/Models/VariantTrack.swift` -- Complete data model with
  VariantType enum, display settings, color schemes, region filtering, and
  annotation conversion.
- `/Sources/LungfishCore/Bundles/Converters/VariantConverter.swift` -- VCF validation
  and statistics analysis (BCF conversion is placeholder).
- `/Sources/LungfishIO/Formats/FASTA/BgzipIndexedFASTAReader.swift` -- BGZF block
  decompression and GZI index reading (reusable for tabix).
- `/Sources/LungfishUI/Tracks/Track.swift` -- Track protocol with render context,
  data source protocol, display modes, and all track types including .variant.

**Gaps to fill:**
- Tabix (.tbi) index parser
- Random-access VCF reading (TabixVCFDataSource)
- Concrete VariantTrack rendering implementation (implementing Track protocol)
- Density histogram rendering at chromosome scale
- Genotype grid rendering at base-pair scale
- Multi-sample sorting and grouping UI

---

## Sources

- [IGV.js Variant Track Documentation](https://igv.org/doc/igvjs/tracks/Variant-Track/)
- [IGV Desktop VCF Track Documentation](https://igv.org/doc/desktop/UserGuide/tracks/vcf/)
- [IGV GitHub Repository (Java source)](https://github.com/igvteam/igv)
- [IGV.js GitHub Repository](https://github.com/igvteam/igv.js)
- [UCSC Genome Browser VCF Track Help](https://genome.ucsc.edu/goldenPath/help/hgVcfTrackHelp.html)
- [UCSC VCF+tabix Track Format](https://www.genome.ucsc.edu/goldenPath/help/vcf.html)
- [JBrowse 2 Variant Track Documentation](https://jbrowse.org/jb2/docs/user_guides/variant_track/)
- [JBrowse 2 Paper (Genome Biology)](https://link.springer.com/article/10.1186/s13059-023-02914-z)
- [Geneious Prime Annotations](https://manual.geneious.com/en/latest/Annotations.html)
- [Geneious VCF Import Help](https://help.geneious.com/hc/en-us/articles/360044628192)
- [GenomeBrowse Variant Visualizations](https://www.goldenhelix.com/blog/getting-the-most-out-of-variant-visualizations-in-genomebrowse/)
- [Tabix Paper (Bioinformatics)](https://academic.oup.com/bioinformatics/article/27/5/718/262743)
- [HTSlib GitHub Repository](https://github.com/samtools/htslib)
- [Swift C-HTSlib Wrapper](https://github.com/jstjohn/swift-c-htslib)
- [VCF 4.3 Specification](https://samtools.github.io/hts-specs/VCFv4.3.pdf)
- [VCF 4.4 Specification](https://samtools.github.io/hts-specs/VCFv4.4.pdf)
- [Bioinformatics Data Skills Ch13: Tabix and SQLite](https://www.oreilly.com/library/view/bioinformatics-data-skills/9781449367480/ch13.html)
- [IGV Paper (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3603213/)
- [IGV Genotype Color Discussion (Biostars)](https://www.biostars.org/p/9525291/)
- [IGV Genotype Color Customization (GitHub Issue)](https://github.com/igvteam/igv/issues/164)
- [Inspecting Variants in IGV Tutorial](https://bioinformatics-core-shared-training.github.io/intro-to-IGV/InspectingVariantsInIGV.html)
- [Variant Classification (Genome Analysis Wiki)](https://genome.sph.umich.edu/wiki/Variant_classification)
- [SCI-VCF Visualization Tool](https://academic.oup.com/nargab/article/6/3/lqae083/7709543)
