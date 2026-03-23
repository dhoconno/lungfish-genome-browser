# Feature: NCBI Taxonomy Links + BLAST Verification

## Status: Expert Investigation

## Description
Two related features for the taxonomy classification view:

### 1. NCBI Taxonomy Link
Right-click a taxon → "Visit NCBI Taxonomy" → opens https://www.ncbi.nlm.nih.gov/datasets/taxonomy/{taxid}/

**Design question**: Should this:
- (a) Open in the system web browser (simplest)
- (b) Parse NCBI data into the Inspector panel
- (c) Introduce a WebView concept in the Inspector for embedded web content
- The experts should consider that this won't be the only external link (BLAST, GenBank, PubMed, etc.)

### 2. BLAST Verification of Classified Reads
Right-click a taxon → "BLAST Matching Reads..." → submits matching reads to NCBI BLAST
filtered to that taxon's core_nt database to evaluate classification specificity.

**Implementation approach**: Use Biopython/Entrez BLAST API (or NCBI BLAST+ REST API) to:
1. Get the matching reads (already extracted or extract on-the-fly)
2. Submit to BLAST with organism filter (taxid:XXXXX)
3. Display results in the bottom drawer or a dedicated panel

**Design questions**:
- How many reads to BLAST? (subsample — BLAST is slow for many sequences)
- Which BLAST parameters? (blastn, core_nt, megablast, etc.)
- Where to show results? (bottom drawer, new panel, Inspector)
- Should BLAST be async with a progress indicator?

## Test Data
Use existing Kraken2 classification results with the viral database.

## Expert Team
- **Bioinformatics**: BLAST API integration, parameter defaults, result interpretation
- **UX/HIG**: Where to show external links, BLAST UI design, Inspector WebView concept
- **Swift/macOS**: WebView in Inspector, BLAST REST API client, WKWebView or SFSafariView
