# VCF Variant Visualization Research

## Comparative Analysis of Genome Browser VCF Rendering

Research date: 2026-02-12
Scope: IGV, Geneious Prime, JBrowse 2, UCSC Genome Browser, Ensembl

---

## 1. IGV (Integrative Genomics Viewer)

### 1.1 Track Architecture

IGV renders VCF data as a two-part track:

1. **Variant bar region** (top): A summary row showing variant calls as stacked
   color bars representing allele frequency/fraction.
2. **Genotype matrix** (below): One row per sample, colored by genotype call.

### 1.2 Variant Bar Rendering

Each variant locus is drawn as a vertical bar split into two colors proportional
to allele frequency:

| Component        | Color | Purpose                      |
|------------------|-------|------------------------------|
| Reference allele | Blue  | Proportion matching reference |
| Alternate allele | Red   | Proportion of alternate allele |

The bar height ratio encodes frequency: if AF=0.3, the red section occupies
30% of the bar and blue occupies 70%.

Two coloring modes are available:
- **Allele Frequency** (default): Uses the AF annotation from the VCF INFO field.
- **Allele Fraction**: Computed from the actual genotype calls in the loaded
  samples, rather than a pre-annotated value.

### 1.3 Genotype Color Scheme

#### igv.js (web) defaults:

| Genotype         | Color                  | RGB             | Hex     |
|------------------|------------------------|-----------------|---------|
| Homozygous ALT   | Cyan                   | (17, 248, 254)  | #11F8FE |
| Heterozygous     | Dark blue              | (34, 12, 253)   | #220CFD |
| Homozygous REF   | Light gray             | (200, 200, 200) | #C8C8C8 |
| No call          | Near-white             | (250, 250, 250) | #FAFAFA |

#### IGV Desktop defaults (configurable in Preferences > Variants):

| Genotype         | Color                  | RGB             |
|------------------|------------------------|-----------------|
| Homozygous REF   | Green                  | (0, 235, 0)     |
| Heterozygous     | Magenta/pink           | (255, 0, 255)   |
| Homozygous ALT   | Blue                   | (30, 30, 255)   |
| No call          | Magenta                | (255, 0, 255)   |

All genotype colors are user-configurable through the Preferences dialog
(View > Preferences > Variants) or via programmatic configuration in igv.js.

### 1.4 Display Modes

| Mode       | Description                                         | Row Height (igv.js) |
|------------|-----------------------------------------------------|---------------------|
| Collapsed  | Variant bars only, no genotype rows shown            | N/A                 |
| Expanded   | Full genotype rows, one per sample, labels visible   | 10px per call       |
| Squished   | Compressed genotype rows to fit many samples         | 1px per call        |

- `squishedCallHeight` default: **1 pixel** per genotype row
- `expandedCallHeight` default: **10 pixels** per genotype row
- Squished row height is adjustable via right-click > "Change Squished Row Height..."

### 1.5 Structural Variant Colors

IGV uses a color table for SV types derived from the SVTYPE INFO field:

| SV Type | Color      | Hex     |
|---------|------------|---------|
| DEL     | Red        | #FF2101 |
| INS     | Dark blue  | #001888 |
| DUP     | Green      | #028401 |
| INV     | Teal       | #008688 |
| CNV     | Purple     | #8931FF |
| BND     | Brown      | #891100 |

Custom SV color tables can be provided via the `colorTable` configuration
parameter in igv.js:

```json
{
  "colorTable": {
    "DEL": "#ff2101",
    "INS": "#001888",
    "DUP": "#028401",
    "INV": "#008688",
    "CNV": "#8931ff",
    "BND": "#891100",
    "*": "#c83bba"
  }
}
```

### 1.6 Multi-Sample VCF Display

- Genotype rows are rendered below the variant summary bar.
- Each row represents one sample; sample names appear in the left name panel.
- In **Squished** mode at 1px per sample, hundreds of samples can be visualized
  simultaneously, creating a heatmap-like appearance.

#### Sorting options (right-click context menu on genotype area):
- Sort by Genotype (at clicked position)
- Sort by Sample Name
- Sort by Depth
- Sort by Quality
- Selecting the same sort option reverses the order.

#### Grouping:
- Requires a loaded sample attribute file
- Right-click > "Group By..." with dropdown of available attributes

### 1.7 Sample Attribute Files

Format: Tab-delimited text file with:
- First column: sample identifier (must match VCF sample names)
- Subsequent columns: arbitrary attributes (phenotype, population, etc.)
- Header row with attribute names

```
Sample	Population	Gender	Disease_Status
NA12878	CEU	Female	Control
NA19240	YRI	Male	Case
```

When loaded, attributes appear as colored columns in an attribute panel between
the sample names and the genotype data. Clicking an attribute header sorts
samples by that attribute. Used for:
- Sorting tracks by attribute values
- Grouping tracks into sections
- Color-coding tracks by attribute category

### 1.8 Variant Tooltip/Inspector

Hovering over a variant displays a popup showing:

**For the variant bar (top section):**
- Chromosome, position (CHROM:POS)
- Variant ID (rs number if available)
- Reference allele (REF)
- Alternate allele(s) (ALT)
- Quality score (QUAL)
- Filter status (FILTER)
- All INFO field key-value pairs
- Allele frequency / allele count

**For a genotype cell (sample row):**
- Sample name
- Genotype call (GT field, e.g., "0/1")
- Genotype quality (GQ)
- Read depth (DP)
- Allelic depth (AD)
- Phred-scaled likelihoods (PL)
- Any other FORMAT fields present in the VCF

Popup behavior is configurable: hover (default) or click-to-show.

### 1.9 VCF Indexing and Performance

**Indexing requirements:**
- VCF must be bgzip-compressed and tabix-indexed (.vcf.gz + .vcf.gz.tbi)
- Tabix index (.tbi) enables random access by genomic region
- Index limitation: chromosomes up to 512 Mbp (2^29 bases)

**Visibility window strategy:**
- Default: 1 MB for single-sample VCF
- Auto-reduced for multi-sample VCFs (inversely proportional to sample count)
- When viewing region exceeds visibility window, data is not loaded
- User can override via right-click > "Set Feature Visibility Window..."
- Without explicit visibility window, large files (e.g., dbSNP) can freeze the browser

**Performance strategy:**
- On-demand loading: only fetch data for the visible region via tabix
- Visibility window prevents loading excessive data at zoom-out
- Index-based random access: O(log n) region queries

---

## 2. Geneious Prime

### 2.1 Variant Display on Alignments

Geneious takes an alignment-centric approach rather than a standalone VCF track:

- **Highlighting mode**: Toggle "Disagreements to Consensus" or "Disagreements
  to Reference" in the viewer options.
- When enabled, matching bases are **grayed out** and disagreeing bases remain
  **colored** (using standard nucleotide coloring: A=green, T=red, C=blue, G=black
  or similar scheme).
- Navigation: Ctrl+D / Cmd+D jumps between disagreement positions.

### 2.2 Variant Types Detected

| Type              | Description                                      |
|-------------------|--------------------------------------------------|
| SNP (Transition)  | Purine-purine or pyrimidine-pyrimidine change    |
| SNP (Transversion)| Purine-pyrimidine interchange                     |
| SNP (Multiple)    | Multiple variants at a single position            |
| Substitution      | 2+ adjacent nucleotide changes                    |
| Insertion         | 1+ nucleotides inserted relative to reference     |
| Deletion          | 1+ nucleotides deleted relative to reference      |
| Mixture           | Multiple variations of different lengths          |

### 2.3 Variant Table Columns

The Find Variations/SNPs tool (Annotate & Predict menu) produces an annotation
table with these columns:

| Column               | Description                                           |
|----------------------|-------------------------------------------------------|
| Change               | Reference nucleotides -> variant (e.g., "C -> A")     |
| Coverage             | Total reads covering the variant position              |
| Reference Frequency  | % of reads matching reference                          |
| Variant Frequency    | % of reads containing the variant                      |
| Polymorphism Type    | SNP, Insertion, Deletion, etc.                         |
| P-Value              | Probability of sequencing error producing observation  |
| Codon Change         | Original -> mutant codon (coding regions only)         |
| Amino Acid Change    | Original -> mutant amino acid (coding regions only)    |
| Protein Effect       | Silent / Non-silent (coding regions only)              |

### 2.4 Filtering Capabilities

- **Column-based filtering**: Filter box at top-right of annotation table
- Logical operators: "Greater than", "Less than", "Equal to", etc.
- Example: "Average Quality :: Greater than :: 30"
- Filtered variants turn **gray** in the table (remain visible but distinguished)
- **P-value threshold**: Set maximum P-value to show only statistically
  significant variants
- **Coding region restriction**: Limit analysis to CDS-annotated regions
- **Strand bias detection**: Filters false positives from strand-specific errors

### 2.5 Structural Variant Annotations

- Junction annotations colored from **blue to green** based on supporting read
  count (fully green at >=5 reads)
- Insertion annotations for short insertions
- Deletion annotations for deletions up to 1000 bp

### 2.6 Metadata Management

- CSV/TSV metadata import (Geneious Prime 2020.1+)
- Requires one shared field (name or sequence ID) for matching
- Custom metadata fields can be added to any document
- Metadata displayed in customizable table columns

### 2.7 VCF Import

- Drag-and-drop import of VCF files alongside BAM, GFF, BED, FASTA
- Smart NGS import: auto-matches files by sequence ID
- VCF annotations mapped onto reference sequences in local database
- Bulk import of mixed file types in a single operation

### 2.8 Export

- Annotation tables exportable as CSV
- Rich text export with formatting preserved
- Sequence views exportable as formatted text

---

## 3. JBrowse 2

### 3.1 Single-Sample Variant Track

Standard variant features are rendered as colored rectangles at genomic
positions. Clicking opens a **Feature Detail Widget** showing:
- All standard VCF fields (CHROM, POS, ID, REF, ALT, QUAL, FILTER)
- All INFO annotations
- Genotype calls table for all samples
- Genotype frequency table (percentage breakdown of genotype calls)

### 3.2 Multi-Sample Display Types

JBrowse 2 provides two specialized display types for multi-sample VCFs:

#### Normal Mode (MultiLinearVariantDisplay)
- Each variant drawn at its genomic position
- Multiple rows rendered for each sample
- Supports overlapping SVs with **alpha-transparency** for distinction
- Structural variants rendered with transparency to show overlaps
- Filters (JEXL expressions) can manage complex overlap situations

#### Matrix Mode (LinearVariantMatrixDisplay)
- Grid layout: **rows = samples**, **columns = variants**
- Variants NOT drawn at exact genomic positions; instead placed in a
  dense grid
- **Black connector lines** drawn from matrix columns to their actual
  genomic positions
- Designed for sparse variation patterns across many samples
- Excels at population-level pattern visualization

### 3.3 Matrix Mode Color Scheme

| Genotype Pattern       | Color         | Interpretation                    |
|------------------------|---------------|-----------------------------------|
| ALT === 1 (hom alt)    | Darker blue   | Darkness increases with dosage    |
| ALT !== 1 (other alt)  | Darker red    | Multi-allelic alternate           |
| Uncalled               | Darker yellow | No genotype call                  |
| Reference              | Gray          | (when showReferenceAlleles=true)  |

The color intensity scales with allele dosage, making it suitable for
polyploid organisms.

### 3.4 Rendering Modes

| Mode         | Description                                           |
|--------------|-------------------------------------------------------|
| alleleCount  | Default. Shows dosage; darker colors = more ALT alleles |
| phased       | Splits each sample into separate haplotype rows        |

### 3.5 Configuration Parameters

```json
{
  "type": "VariantTrack",
  "displays": [{
    "type": "MultiLinearVariantDisplay",
    "showReferenceAlleles": false,
    "showSidebarLabels": true,
    "showTree": true,
    "renderingMode": "alleleCount",
    "minorAlleleFrequencyFilter": 0,
    "colorBy": "population"
  }]
}
```

Key parameters:
- `showReferenceAlleles` (boolean, default false): Show ref alleles with color
  vs. solid gray background
- `showSidebarLabels` (boolean, default true): Sample name visibility
- `showTree` (boolean, default true): Clustering dendrogram
- `renderingMode` ("alleleCount" | "phased")
- `minorAlleleFrequencyFilter` (0-0.5, default 0): MAF threshold
- `colorBy` (string): Metadata attribute for sample coloring

### 3.6 Sample Metadata

- Configured via `samplesTsvLocation` on the VcfTabixAdapter
- TSV file with sample attributes
- `colorBy` configuration auto-colors samples by metadata attribute on load

### 3.7 Feature Detail Widget

Specialized for variants:
- Complete VCF record display
- **Genotype call table**: All samples with GT, GQ, DP, AD, etc.
- **Genotype frequency table**: Percentage breakdown (e.g., 45% 0/1, 30% 1/1)
- **Genotype column** in variant sample grid
- Filterable by genotype value (exact match or dosage-based)
- Sample name search/filter

### 3.8 Performance

- VcfTabixAdapter: bgzip + tabix (TBI or CSI index)
- CSI index support for large chromosomes (>512 Mbp)
- Matrix display handles thousands of samples over 5 Mbp+ regions
  (demonstrated with 1000 Genomes data)
- Lazy rendering: only variants in the visible region are drawn
- Web worker architecture for parsing VCF data off the main thread

### 3.9 Filtering

- JEXL expression filters on variant properties
- Minor allele frequency threshold filter
- Genotype-based filtering in feature detail widget
- Both exact genotype match and dosage-based filtering

---

## 4. UCSC Genome Browser

### 4.1 Default Variant Rendering

Variants displayed with **base-specific coloring**:
- Homozygotes: shown as a single letter
- Heterozygotes: shown with both letters
- Standard nucleotide colors apply to the base letters

### 4.2 Haplotype Sorting Display

Available when VCF contains >= 2 samples (4 haplotypes):

**Algorithm:**
1. Each sample's phased/homozygous genotypes split into haplotypes
2. Central variant selected as clustering anchor
3. Distance function applied: differences penalized with weights that
   **decrease** for each successive variant away from center
4. Hierarchical clustering sorts haplotypes by similarity
5. Leaf clusters (identical haplotypes) highlighted

**Rendering:**
- Each variant = vertical column
- Each haplotype = horizontal row
- Leaf clusters colored **purple**
- Leaf cluster shapes: **triangles** (default) or **rectangles** (configurable)

### 4.3 Color Schemes

Three modes available:

| Mode    | Reference    | Alternate    | Mixed          | Undefined      |
|---------|-------------|-------------|----------------|----------------|
| Default | Invisible   | Black       | Grayscale      | Pale yellow    |
| Blue/Red| Blue        | Red         | Purple         | Pale yellow    |
| ACGT    | Per-base    | Per-base    | Gray           | Pale yellow    |

**ACGT color scheme:**
- A = Red
- C = Blue
- G = Green
- T = Magenta

Variants used in the clustering calculation are marked with **purple** shading.
When multiple haplotypes collapse into the same pixel row, **grayscale** shading
encodes the proportion of reference vs. alternate alleles.

### 4.4 Lollipop Display

A newer display mode showing allele frequency as vertical bar height:
- Each variant rendered as a vertical "lollipop" stick
- Height proportional to allele frequency
- Available for VCF and bigBed tracks

### 4.5 Filtering Options

| Filter                    | Description                                       |
|---------------------------|---------------------------------------------------|
| FILTER column exclusion   | Checkbox per FILTER code defined in VCF header    |
| Quality threshold         | Exclude variants with QUAL < specified value       |
| Minor allele frequency    | Exclude variants with MAF < threshold              |

Configuration parameters for track hubs:
- `applyMinQual` (true|false)
- `minQual` (numeric threshold)
- `minFreq` (MAF threshold, default 0.0)

### 4.6 Display Density

Visibility modes: `squish | pack | full | dense | hide`

Track height adjustable in pixels. Display density automatically adjusted
based on the number of variants in the visible region.

### 4.7 VCF Requirements

- Must be bgzip-compressed and tabix-indexed
- Sorted by start position
- Tabix index handles chromosomes up to 512 Mbp
- Random access via tabix for region-specific queries

---

## 5. Ensembl Genome Browser

### 5.1 Variant Display Conventions

Ensembl uses a **consequence-based** color coding system rather than
genotype-based coloring. Variants are classified by their predicted
functional impact, and each consequence type has an assigned color.

#### Visual encoding:
- **SNPs**: Rendered as colored **boxes/rectangles**
- **Insertions**: Small colored **triangle/arrow** beneath the position
- Color determined by the most severe consequence predicted for the variant

### 5.2 Consequence Color Table

Colors are ordered by severity (most severe first). From the Ensembl VEP
source code and web display conventions:

| Consequence              | Impact | Color    | Hex      |
|--------------------------|--------|----------|----------|
| Transcript ablation      | HIGH   | Red      | #FF0000  |
| Stop gained              | HIGH   | Red      | #FF0000  |
| Stop lost                | HIGH   | Red      | #FF0000  |
| Frameshift variant       | HIGH   | Hot pink | #FF69B4  |
| Transcript amplification | HIGH   | Hot pink | #FF69B4  |
| Inframe insertion        | MOD    | Hot pink | #FF69B4  |
| Inframe deletion         | MOD    | Hot pink | #FF69B4  |
| Splice acceptor variant  | HIGH   | Coral    | #FF7F50  |
| Splice donor variant     | HIGH   | Coral    | #FF7F50  |
| Splice region variant    | LOW    | Coral    | #FF7F50  |
| Missense variant         | MOD    | Gold     | #FFD700  |
| Initiator codon variant  | MOD    | Gold     | #FFD700  |
| Synonymous variant       | LOW    | Lime     | #76EE00  |
| Stop retained variant    | LOW    | Lime     | #76EE00  |
| 5' UTR variant           | MOD    | Cyan     | #7AC5CD  |
| 3' UTR variant           | MOD    | Cyan     | #7AC5CD  |
| Intron variant           | MOD    | (varies) | -        |
| Intergenic variant       | MOD    | (varies) | -        |
| Regulatory region variant| MOD    | Brown    | -        |

General severity gradient: Red (HIGH) -> Pink (HIGH/MOD) -> Coral (splice)
-> Gold (missense) -> Green (synonymous) -> Cyan (UTR) -> Forest green/gray
(non-coding/intergenic).

### 5.3 Display Styles

| Window Size | Style                   | Description                      |
|-------------|-------------------------|----------------------------------|
| > 200 kb    | Collapsed               | All variants on single line      |
| < 200 kb    | Expanded without name   | Variants spaced across rows      |
| < 10 kb     | Expanded with name      | Variants with rs-number labels   |

### 5.4 Variant Detail Page

Clicking a variant opens a dedicated page showing:
- Variant ID (rsID), location, alleles
- Consequence predictions with color indicators
- Population allele frequencies (1000 Genomes, gnomAD, etc.)
- Clinical significance (ClinVar)
- Phenotype/disease associations
- Citation links
- Pie chart of consequence distribution (color-matched to the table)
- Linkage disequilibrium data
- Regulatory feature overlaps

### 5.5 Population Frequency Display

- Pie charts showing allele frequency per population
- Color scheme matches the consequence color coding
- Available for 1000 Genomes Phase 3, gnomAD, and other datasets

---

## Cross-Tool Comparison

### Visual Encoding Summary

| Feature           | IGV            | Geneious       | JBrowse 2      | UCSC           | Ensembl        |
|-------------------|----------------|----------------|----------------|----------------|----------------|
| SNP encoding      | Colored bar    | Colored base   | Rectangle      | Letter         | Colored box    |
| Indel encoding    | Colored bar    | Colored region | Rectangle      | Letter pair    | Triangle/arrow |
| SV encoding       | Color by type  | Blue-green     | Transparent    | N/A            | N/A            |
| Color basis       | Genotype       | Base identity  | Genotype       | Base/haplotype | Consequence    |
| Multi-sample      | Row per sample | Per-alignment  | Matrix/rows    | Haplotype sort | Population AF  |

### Genotype Color Comparison

| Genotype    | IGV (js)     | IGV (desktop) | JBrowse 2 matrix |
|-------------|-------------|---------------|-------------------|
| Hom REF     | Gray #C8C8C8| Green (0,235,0)| Gray             |
| Het         | Blue #220CFD| Magenta       | Light blue/red    |
| Hom ALT     | Cyan #11F8FE| Blue (30,30,255)| Dark blue       |
| No call     | White #FAFAFA| Magenta      | Yellow            |

### Performance Strategies

| Strategy                | IGV              | JBrowse 2        | UCSC              |
|-------------------------|------------------|-------------------|--------------------|
| Index format            | Tabix (.tbi)     | Tabix/CSI         | Tabix (.tbi)       |
| Region query            | On-demand        | On-demand         | On-demand          |
| Visibility window       | Auto (1MB/samples)| Region-based     | Track density      |
| Large sample handling   | Squished mode    | Matrix display    | Haplotype clustering|
| Threading               | Single thread    | Web workers       | Server-side        |
| Max demonstrated samples| ~hundreds        | ~thousands (1KG)  | Tens of samples    |

### Multi-Sample Layout Strategies

1. **IGV Row-per-sample**: Each sample gets its own horizontal row. Squished
   mode (1px/row) allows hundreds of samples. Sorting by genotype at a clicked
   position reveals patterns. Grouping by metadata creates visual sections.

2. **JBrowse 2 Matrix**: Transposed layout (samples=rows, variants=columns).
   Black connector lines link matrix columns to genomic positions. Handles
   thousands of samples. Color intensity encodes allele dosage.

3. **UCSC Haplotype Clustering**: Splits diploid samples into haplotypes.
   Hierarchical clustering by similarity to a central variant. Purple leaf
   clusters identify identical haplotype groups. Triangle/rectangle shapes
   for cluster visualization.

4. **Ensembl Population View**: Does not show per-sample genotypes. Instead
   shows aggregated population allele frequencies as pie charts. Focus is on
   consequence annotation rather than individual genotypes.

### Novel/Effective UI Patterns

1. **IGV allele frequency bar** (top-row summary): Elegant two-color
   proportional bar showing AF at a glance before drilling into genotypes.

2. **JBrowse 2 connector lines**: Black lines from matrix columns to genomic
   positions solve the fundamental problem of showing dense variant grids
   while maintaining genomic context.

3. **JBrowse 2 dosage-intensity mapping**: Darker colors for higher dosage
   naturally encodes ploidy and allele count without additional symbols.

4. **UCSC distance-weighted clustering**: The decreasing-weight distance
   function that penalizes differences less as they get further from the
   center variant is elegant for local haplotype structure visualization.

5. **Ensembl consequence-first approach**: Using functional impact as the
   primary color axis (rather than genotype) is uniquely suited for clinical
   variant interpretation.

6. **Geneious disagreement highlighting**: Graying out matching bases and
   only coloring disagreements provides an instant visual signal for variant
   positions in dense alignments.

7. **JBrowse 2 phased rendering mode**: Splitting each sample into separate
   haplotype rows provides phase-aware visualization without requiring the
   UCSC-style clustering algorithm.

---

## Recommendations for Lungfish Genome Browser

Based on this research, the following patterns would be most applicable:

### Immediate Implementation Priorities

1. **Adopt IGV-style genotype colors** for the genotype matrix: cyan for
   hom-alt, blue for het, gray for hom-ref, near-white for no-call.

2. **Two-tier variant track**: Summary AF bar on top (two-color proportional)
   with expandable genotype rows below.

3. **Structural variant color table**: Use the IGV/dbVar conventions
   (DEL=red, INS=blue, DUP=green, INV=teal, CNV=purple, BND=brown).

4. **Three display modes**: Collapsed (variant bars only), Squished (1px rows),
   Expanded (10px rows with labels).

### Future Enhancements

5. **Sample attribute file support**: Tab-delimited metadata for sorting,
   grouping, and color-coding sample rows.

6. **Matrix display** (JBrowse 2 style): For population-scale VCFs with
   hundreds to thousands of samples.

7. **Consequence-based coloring** (Ensembl style): As an alternative color
   mode for clinical interpretation workflows.

8. **Haplotype clustering** (UCSC style): For phased genotype visualization.

---

## Sources

- IGV Desktop VCF Documentation: https://igv.org/doc/desktop/UserGuide/tracks/vcf/
- igv.js Variant Track: https://igv.org/doc/igvjs/tracks/Variant-Track/
- igv.js GitHub Wiki: https://github.com/igvteam/igv.js/wiki/Variant-Track
- IGV Genotype Color Issue: https://github.com/igvteam/igv/issues/164
- IGV Sample Attributes: https://software.broadinstitute.org/software/igv/SampleInformation
- IGV Visibility Window Issue: https://github.com/igvteam/igv.js/issues/940
- Inspecting Variants in IGV: https://bioinformatics-core-shared-training.github.io/intro-to-IGV/InspectingVariantsInIGV.html
- Dragen SV IGV Tutorial: https://help.dragen.illumina.com/product-guide/dragen-v4.4/dragen-dna-pipeline/sv-calling/sv-igv-tutorial
- JBrowse 2 Variant Tracks: https://jbrowse.org/jb2/docs/user_guides/variant_track/
- JBrowse 2 Multi-Sample: https://jbrowse.org/jb2/docs/user_guides/multivariant_track/
- JBrowse 2 Variant Config: https://jbrowse.org/jb2/docs/config_guides/variant_track/
- JBrowse 2 v3.0.0 Release: https://jbrowse.org/jb2/blog/2025/01/29/v3.0.0-release/
- UCSC VCF Track Help: https://genome.ucsc.edu/goldenPath/help/hgVcfTrackHelp.html
- UCSC VCF+tabix Format: https://genome.ucsc.edu/goldenpath/help/vcf.html
- Ensembl Predicted Data: https://www.ensembl.org/info/genome/variation/prediction/predicted_data.html
- Ensembl Variant Classification: https://www.ensembl.org/info/genome/variation/prediction/classification.html
- Ensembl Region in Detail: https://www.ensembl.org/Help/View?id=140
- Geneious Prime Manual (Analyses): https://manual.geneious.com/en/latest/Analyses.html
- Geneious NGS Features: https://www.geneious.com/features/ngs-visualization-downstream-analysis
- Geneious Annotations: https://manual.geneious.com/en/latest/Annotations.html
- VEP Color Source (cpipe): https://github.com/MelbourneGenomics/cpipe/blob/master/tools/vep/74/variant_effect_predictor.pl
