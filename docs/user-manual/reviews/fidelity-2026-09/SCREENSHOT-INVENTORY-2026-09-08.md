# Screenshot inventory — 2026-09-08

Capture work is paused at the user’s request for prioritization.

- 207 manifest rows total.
- 189 captured rows, representing 184 unique part/shot images.
- 18 remaining rows, all unique.
- 11 are currently deferred. The other 7 need capture work or prerequisite preparation.

“Captured” means an image and recipe exist and the campaign marked the row captured. It does not certify the underlying workflow as scientifically validated. Most new screenshots remain uncommitted. The full final site/browser verification and Read the Docs check are not complete.

## Remaining screenshots

- **`02-sequences/import-center-annotation-track-alert`** — Pending — An annotation file dropped onto the Import Center.
  - Requested view: The Import Annotation Track alert, showing the Reference popup above the Track Name and Track ID fields.
- **`03-reads/sidebar-after-merge`** — Pending — A merge run completed.
  - Requested view: The sidebar after a merge run, showing the new bundle under Analyses.
- **`04-alignments/extract-reads-region-menu`** — Pending — A region selected on the alignment track.
  - Requested view: The context menu over a selected stretch of the alignment track, with Extract Reads in Selected Region... showing beneath Copy Visible Region, Copy Visible Region as FASTA, and Extract Visible Region...
- **`04-alignments/primer-trim-track-result`** — Deferred — missing pathogen alignment/primer-trimming result; no new execution.
  - Requested view: The sidebar after the run, showing the new track named minimap2 mapping, a bullet, Primer-trimmed, and the scheme name in parentheses.
- **`04-alignments/viral-recon-inspector-outputs`** — Deferred — missing pathogen reconstruction result; no new execution.
  - Requested view: The Inspector after a finished run, listing the Consensus, Lineage, Variants, Quality, and Provenance sections with one row per output file.
- **`05-variants/imported-benchmark-in-variants-tab`** — Pending — The HG002 benchmark VCF imported.
  - Requested view: The Variants tab of the table drawer after the benchmark import, with the Source column separating the benchmark rows from the bcftools and LoFreq rows.
- **`05-variants/name-imported-variant-bundle`** — Pending — No reference bundle open when the VCF is imported.
  - Requested view: The Name Imported Variant Bundle prompt that appears when no reference bundle is open, with the project path in its message and the file's base name filled into the text field.
- **`06-classification/esviritu-database-missing`** — Pending — Needs the database absent, so capture this before installing it, or on a fresh profile.
  - Requested view: The dialog's Database section reading Database not installed, with the Download Database... button beside it.
- **`06-classification/esviritu-result-viewport`** — Deferred — missing pathogen analysis result.
  - Requested view: The EsViritu viewport after detecting viruses in SRR36291587, with the detection table on the left showing its Coverage column sparkline and the detail pane on the right showing the metric pills.
- **`06-classification/esviritu-alignment-evidence`** — Deferred — depends on that missing result.
  - Requested view: The full alignment viewer filling the detail pane after a detection row is selected, showing the read pileup over the matched viral reference.
- **`06-classification/taxtriage-result-table`** — Deferred — missing pathogen workflow result.
  - Requested view: The TaxTriage viewport after a single-sample run of SRR36291587, with the summary cards along the top, the organism table on the right showing its TASS Score and Confidence columns, and the alignment pane on the left.
- **`06-classification/taxtriage-batch-overview`** — Deferred — missing pathogen batch result.
  - Requested view: The batch overview shown when the sample filter is set to All Samples on a two-sample run, with the menu that chooses the cell values above the cross-sample table and one column per sample.
- **`06-classification/blast-results-drawer`** — Deferred — missing completed BLAST verification result.
  - Requested view: The BLAST Results drawer after a verification, showing the summary bar with its supporting and contradicting counts and confidence word, above the per-read rows in their six default columns.
- **`06-classification/nvd-blast-drawer`** — Deferred — existing teaching report has no loaded sequence/completed verification result.
  - Requested view: The BLAST results drawer open across the bottom of the NVD viewport below the outline and above the action bar, with the BLAST Verify button in the action bar at lower left.
- **`06-human-germline-variants/operations-panel-gatk-run`** — Deferred — delegated GATK pack-readiness/reinstall task was rejected by the tool safety gate before a result. This was a human-data task, not a finding that human variant calling is prohibited.
  - Requested view: The Operations panel row for a finished GATK HaplotypeCaller run, expanded to show the GATK command and the provenance the run recorded.
- **`08-workflows/workflow-builder-canvas`** — Deferred — blank experimental canvas; palette interaction did not add visible nodes.
  - Requested view: The canvas with the five-step read-cleanup chain composed by hand, running from FASTQ Bundle Input through to the pinned Project output anchor.
- **`08-workflows/workflow-builder-node-inspector`** — Deferred — depends on a visible, selectable node.
  - Requested view: An Adapter + quality trim node selected, showing its Label field, the tool it runs, and the Configure... button in the right-hand inspector.
- **`appendices/primer-scheme-inspector`** — Pending — Gate: a scheme selected, and a shipped scheme shows more fields than an imported one.
  - Requested view: A primer scheme selected in the sidebar, with the Inspector showing the display name, the primer and amplicon counts, and the reference and equivalent accessions.

## Completed screenshots

Every completed part/shot is listed once below. Some figures appear in more than one chapter, which accounts for the difference between 189 rows and 184 unique figures.

### 01-foundations — 27 captured manifest rows

- [import-center-reference-card](../../assets/screenshots/01-foundations/import-center-reference-card.png) — [recipe](../../assets/recipes/01-foundations/import-center-reference-card.yaml)
- [hbb-record-in-sequence-viewport](../../assets/screenshots/01-foundations/hbb-record-in-sequence-viewport.png) — [recipe](../../assets/recipes/01-foundations/hbb-record-in-sequence-viewport.yaml)
- [go-to-location-hbb-codon](../../assets/screenshots/01-foundations/go-to-location-hbb-codon.png) — [recipe](../../assets/recipes/01-foundations/go-to-location-hbb-codon.yaml)
- [fastq-viewport-summary-cards](../../assets/screenshots/01-foundations/fastq-viewport-summary-cards.png) — [recipe](../../assets/recipes/01-foundations/fastq-viewport-summary-cards.yaml)
- [fastq-viewport-reads-tab](../../assets/screenshots/01-foundations/fastq-viewport-reads-tab.png) — [recipe](../../assets/recipes/01-foundations/fastq-viewport-reads-tab.yaml)
- [primer-scheme-picker-built-in](../../assets/screenshots/01-foundations/primer-scheme-picker-built-in.png) — [recipe](../../assets/recipes/01-foundations/primer-scheme-picker-built-in.yaml)
- [bam-viewport-coverage-and-pileup](../../assets/screenshots/01-foundations/bam-viewport-coverage-and-pileup.png) — [recipe](../../assets/recipes/01-foundations/bam-viewport-coverage-and-pileup.yaml)
- [variants-tab-hg002-bcftools](../../assets/screenshots/01-foundations/variants-tab-hg002-bcftools.png) — [recipe](../../assets/recipes/01-foundations/variants-tab-hg002-bcftools.yaml)
- [variants-pass-chip-and-tokens](../../assets/screenshots/01-foundations/variants-pass-chip-and-tokens.png) — [recipe](../../assets/recipes/01-foundations/variants-pass-chip-and-tokens.yaml)
- [inspector-variant-selected](../../assets/screenshots/01-foundations/inspector-variant-selected.png) — [recipe](../../assets/recipes/01-foundations/inspector-variant-selected.yaml)
- [welcome-window](../../assets/screenshots/01-foundations/welcome-window.png) — [recipe](../../assets/recipes/01-foundations/welcome-window.yaml)
- [empty-project-window](../../assets/screenshots/01-foundations/empty-project-window.png) — [recipe](../../assets/recipes/01-foundations/empty-project-window.yaml)
- [sidebar-folder-conventions](../../assets/screenshots/01-foundations/sidebar-folder-conventions.png) — [recipe](../../assets/recipes/01-foundations/sidebar-folder-conventions.yaml)
- [file-export-menu](../../assets/screenshots/01-foundations/file-export-menu.png) — [recipe](../../assets/recipes/01-foundations/file-export-menu.yaml)
- [inspector-fastq-selected](../../assets/screenshots/01-foundations/inspector-fastq-selected.png) — [recipe](../../assets/recipes/01-foundations/inspector-fastq-selected.yaml)
- [inspector-fastq-detail](../../assets/screenshots/01-foundations/inspector-fastq-detail.png) — [recipe](../../assets/recipes/01-foundations/inspector-fastq-detail.yaml)
- [operations-panel-row](../../assets/screenshots/01-foundations/operations-panel-row.png) — [recipe](../../assets/recipes/01-foundations/operations-panel-row.yaml)
- [operations-panel-right-click-menu](../../assets/screenshots/01-foundations/operations-panel-right-click-menu.png) — [recipe](../../assets/recipes/01-foundations/operations-panel-right-click-menu.yaml)
- [plugin-manager-window](../../assets/screenshots/01-foundations/plugin-manager-window.png) — [recipe](../../assets/recipes/01-foundations/plugin-manager-window.yaml)
- [plugin-manager-offline-commands](../../assets/screenshots/01-foundations/plugin-manager-offline-commands.png) — [recipe](../../assets/recipes/01-foundations/plugin-manager-offline-commands.yaml)
- [plugin-manager-installed-tab](../../assets/screenshots/01-foundations/plugin-manager-installed-tab.png) — [recipe](../../assets/recipes/01-foundations/plugin-manager-installed-tab.yaml)
- [plugin-manager-databases-tab](../../assets/screenshots/01-foundations/plugin-manager-databases-tab.png) — [recipe](../../assets/recipes/01-foundations/plugin-manager-databases-tab.yaml)
- [inspector-provenance-section](../../assets/screenshots/01-foundations/inspector-provenance-section.png) — [recipe](../../assets/recipes/01-foundations/inspector-provenance-section.yaml)
- [provenance-lineage-step-expanded](../../assets/screenshots/01-foundations/provenance-lineage-step-expanded.png) — [recipe](../../assets/recipes/01-foundations/provenance-lineage-step-expanded.yaml)
- [provenance-export-folder](../../assets/screenshots/01-foundations/provenance-export-folder.png) — [recipe](../../assets/recipes/01-foundations/provenance-export-folder.yaml)
- [provenance-signing-settings](../../assets/screenshots/01-foundations/provenance-signing-settings.png) — [recipe](../../assets/recipes/01-foundations/provenance-signing-settings.yaml)

### 02-sequences — 20 captured manifest rows

- [import-center-reference-card](../../assets/screenshots/02-sequences/import-center-reference-card.png) — [recipe](../../assets/recipes/02-sequences/import-center-reference-card.yaml)
- [hbb-record-in-sequence-viewport](../../assets/screenshots/02-sequences/hbb-record-in-sequence-viewport.png) — [recipe](../../assets/recipes/02-sequences/hbb-record-in-sequence-viewport.yaml)
- [go-to-location-hbb-codon](../../assets/screenshots/02-sequences/go-to-location-hbb-codon.png) — [recipe](../../assets/recipes/02-sequences/go-to-location-hbb-codon.yaml)
- [hbb-annotation-context-menu](../../assets/screenshots/02-sequences/hbb-annotation-context-menu.png) — [recipe](../../assets/recipes/02-sequences/hbb-annotation-context-menu.yaml)
- [translation-tool-hbb-cds](../../assets/screenshots/02-sequences/translation-tool-hbb-cds.png) — [recipe](../../assets/recipes/02-sequences/translation-tool-hbb-cds.yaml)
- [ncbi-search-dialog](../../assets/screenshots/02-sequences/ncbi-search-dialog.png) — [recipe](../../assets/recipes/02-sequences/ncbi-search-dialog.yaml)
- [ncbi-advanced-filters](../../assets/screenshots/02-sequences/ncbi-advanced-filters.png) — [recipe](../../assets/recipes/02-sequences/ncbi-advanced-filters.yaml)
- [ncbi-results-download-selected](../../assets/screenshots/02-sequences/ncbi-results-download-selected.png) — [recipe](../../assets/recipes/02-sequences/ncbi-results-download-selected.yaml)
- [ncbi-bundle-in-sidebar](../../assets/screenshots/02-sequences/ncbi-bundle-in-sidebar.png) — [recipe](../../assets/recipes/02-sequences/ncbi-bundle-in-sidebar.yaml)
- [pathoplexus-pane](../../assets/screenshots/02-sequences/pathoplexus-pane.png) — [recipe](../../assets/recipes/02-sequences/pathoplexus-pane.yaml)
- [extract-region-dialog](../../assets/screenshots/02-sequences/extract-region-dialog.png) — [recipe](../../assets/recipes/02-sequences/extract-region-dialog.yaml)
- [find-orfs-dialog](../../assets/screenshots/02-sequences/find-orfs-dialog.png) — [recipe](../../assets/recipes/02-sequences/find-orfs-dialog.yaml)
- [mafft-dialog](../../assets/screenshots/02-sequences/mafft-dialog.png) — [recipe](../../assets/recipes/02-sequences/mafft-dialog.yaml)
- [alignment-viewport-primate-mito](../../assets/screenshots/02-sequences/alignment-viewport-primate-mito.png) — [recipe](../../assets/recipes/02-sequences/alignment-viewport-primate-mito.yaml)
- [export-alignment-sheet](../../assets/screenshots/02-sequences/export-alignment-sheet.png) — [recipe](../../assets/recipes/02-sequences/export-alignment-sheet.yaml)
- [iqtree-dialog](../../assets/screenshots/02-sequences/iqtree-dialog.png) — [recipe](../../assets/recipes/02-sequences/iqtree-dialog.yaml)
- [tree-viewport-primate-mito](../../assets/screenshots/02-sequences/tree-viewport-primate-mito.png) — [recipe](../../assets/recipes/02-sequences/tree-viewport-primate-mito.yaml)

### 03-reads — 29 captured manifest rows

- [import-center-sequencing-reads-tab](../../assets/screenshots/03-reads/import-center-sequencing-reads-tab.png) — [recipe](../../assets/recipes/03-reads/import-center-sequencing-reads-tab.yaml)
- [import-fastq-configuration-sheet](../../assets/screenshots/03-reads/import-fastq-configuration-sheet.png) — [recipe](../../assets/recipes/03-reads/import-fastq-configuration-sheet.yaml)
- [sidebar-after-import](../../assets/screenshots/03-reads/sidebar-after-import.png) — [recipe](../../assets/recipes/03-reads/sidebar-after-import.yaml)
- [fastq-viewport-summary-cards](../../assets/screenshots/03-reads/fastq-viewport-summary-cards.png) — [recipe](../../assets/recipes/03-reads/fastq-viewport-summary-cards.yaml)
- [sra-runs-pane](../../assets/screenshots/03-reads/sra-runs-pane.png) — [recipe](../../assets/recipes/03-reads/sra-runs-pane.yaml)
- [sra-results-download-selected](../../assets/screenshots/03-reads/sra-results-download-selected.png) — [recipe](../../assets/recipes/03-reads/sra-results-download-selected.yaml)
- [sra-import-configuration-sheet](../../assets/screenshots/03-reads/sra-import-configuration-sheet.png) — [recipe](../../assets/recipes/03-reads/sra-import-configuration-sheet.yaml)
- [sra-bundle-in-sidebar](../../assets/screenshots/03-reads/sra-bundle-in-sidebar.png) — [recipe](../../assets/recipes/03-reads/sra-bundle-in-sidebar.yaml)
- [fastq-sparkline-popover](../../assets/screenshots/03-reads/fastq-sparkline-popover.png) — [recipe](../../assets/recipes/03-reads/fastq-sparkline-popover.yaml)
- [refresh-qc-summary-dialog](../../assets/screenshots/03-reads/refresh-qc-summary-dialog.png) — [recipe](../../assets/recipes/03-reads/refresh-qc-summary-dialog.yaml)
- [fastq-viewport-reads-tab](../../assets/screenshots/03-reads/fastq-viewport-reads-tab.png) — [recipe](../../assets/recipes/03-reads/fastq-viewport-reads-tab.yaml)
- [trimming-dialog](../../assets/screenshots/03-reads/trimming-dialog.png) — [recipe](../../assets/recipes/03-reads/trimming-dialog.yaml)
- [trim-operation-row](../../assets/screenshots/03-reads/trim-operation-row.png) — [recipe](../../assets/recipes/03-reads/trim-operation-row.yaml)
- [length-filter-readiness](../../assets/screenshots/03-reads/length-filter-readiness.png) — [recipe](../../assets/recipes/03-reads/length-filter-readiness.yaml)
- [primer-trimming-literal-pane](../../assets/screenshots/03-reads/primer-trimming-literal-pane.png) — [recipe](../../assets/recipes/03-reads/primer-trimming-literal-pane.yaml)
- [human-scrub-dialog](../../assets/screenshots/03-reads/human-scrub-dialog.png) — [recipe](../../assets/recipes/03-reads/human-scrub-dialog.yaml)
- [low-complexity-pane](../../assets/screenshots/03-reads/low-complexity-pane.png) — [recipe](../../assets/recipes/03-reads/low-complexity-pane.yaml)
- [remove-duplicates-preset-picker](../../assets/screenshots/03-reads/remove-duplicates-preset-picker.png) — [recipe](../../assets/recipes/03-reads/remove-duplicates-preset-picker.yaml)
- [search-subsetting-menu](../../assets/screenshots/03-reads/search-subsetting-menu.png) — [recipe](../../assets/recipes/03-reads/search-subsetting-menu.yaml)
- [subsample-by-count-pane](../../assets/screenshots/03-reads/subsample-by-count-pane.png) — [recipe](../../assets/recipes/03-reads/subsample-by-count-pane.yaml)
- [select-reads-by-sequence-pane](../../assets/screenshots/03-reads/select-reads-by-sequence-pane.png) — [recipe](../../assets/recipes/03-reads/select-reads-by-sequence-pane.yaml)
- [ont-import-configuration-sheet](../../assets/screenshots/03-reads/ont-import-configuration-sheet.png) — [recipe](../../assets/recipes/03-reads/ont-import-configuration-sheet.yaml)
- [ont-barcode-sheet-controls](../../assets/screenshots/03-reads/ont-barcode-sheet-controls.png) — [recipe](../../assets/recipes/03-reads/ont-barcode-sheet-controls.yaml)
- [sidebar-after-ont-import](../../assets/screenshots/03-reads/sidebar-after-ont-import.png) — [recipe](../../assets/recipes/03-reads/sidebar-after-ont-import.yaml)
- [demultiplex-barcodes-pane](../../assets/screenshots/03-reads/demultiplex-barcodes-pane.png) — [recipe](../../assets/recipes/03-reads/demultiplex-barcodes-pane.yaml)
- [read-processing-menu](../../assets/screenshots/03-reads/read-processing-menu.png) — [recipe](../../assets/recipes/03-reads/read-processing-menu.yaml)
- [merge-overlapping-pairs-pane](../../assets/screenshots/03-reads/merge-overlapping-pairs-pane.png) — [recipe](../../assets/recipes/03-reads/merge-overlapping-pairs-pane.yaml)
- [orient-reads-pane](../../assets/screenshots/03-reads/orient-reads-pane.png) — [recipe](../../assets/recipes/03-reads/orient-reads-pane.yaml)

### 04-alignments — 17 captured manifest rows

- [tools-mapping-submenu](../../assets/screenshots/04-alignments/tools-mapping-submenu.png) — [recipe](../../assets/recipes/04-alignments/tools-mapping-submenu.yaml)
- [mapping-wizard-overview](../../assets/screenshots/04-alignments/mapping-wizard-overview.png) — [recipe](../../assets/recipes/04-alignments/mapping-wizard-overview.yaml)
- [mapping-wizard-advanced](../../assets/screenshots/04-alignments/mapping-wizard-advanced.png) — [recipe](../../assets/recipes/04-alignments/mapping-wizard-advanced.yaml)
- [alignment-inspector-stats](../../assets/screenshots/04-alignments/alignment-inspector-stats.png) — [recipe](../../assets/recipes/04-alignments/alignment-inspector-stats.yaml)
- [bam-viewport-overview](../../assets/screenshots/04-alignments/bam-viewport-overview.png) — [recipe](../../assets/recipes/04-alignments/bam-viewport-overview.yaml)
- [pileup-zoom](../../assets/screenshots/04-alignments/pileup-zoom.png) — [recipe](../../assets/recipes/04-alignments/pileup-zoom.yaml)
- [view-settings-alignment-tab](../../assets/screenshots/04-alignments/view-settings-alignment-tab.png) — [recipe](../../assets/recipes/04-alignments/view-settings-alignment-tab.yaml)
- [view-settings-reads-tab](../../assets/screenshots/04-alignments/view-settings-reads-tab.png) — [recipe](../../assets/recipes/04-alignments/view-settings-reads-tab.yaml)
- [primer-trim-scheme-menu](../../assets/screenshots/04-alignments/primer-trim-scheme-menu.png) — [recipe](../../assets/recipes/04-alignments/primer-trim-scheme-menu.yaml)
- [primer-trim-dialog-target](../../assets/screenshots/04-alignments/primer-trim-dialog-target.png) — [recipe](../../assets/recipes/04-alignments/primer-trim-dialog-target.yaml)
- [inspector-alignment-stats](../../assets/screenshots/04-alignments/inspector-alignment-stats.png) — [recipe](../../assets/recipes/04-alignments/inspector-alignment-stats.yaml)
- [analysis-filtering-tab](../../assets/screenshots/04-alignments/analysis-filtering-tab.png) — [recipe](../../assets/recipes/04-alignments/analysis-filtering-tab.yaml)
- [filter-panel-controls](../../assets/screenshots/04-alignments/filter-panel-controls.png) — [recipe](../../assets/recipes/04-alignments/filter-panel-controls.yaml)
- [analysis-export-tab](../../assets/screenshots/04-alignments/analysis-export-tab.png) — [recipe](../../assets/recipes/04-alignments/analysis-export-tab.yaml)
- [viral-recon-menu-item](../../assets/screenshots/04-alignments/viral-recon-menu-item.png) — [recipe](../../assets/recipes/04-alignments/viral-recon-menu-item.yaml)
- [viral-recon-wizard-overview](../../assets/screenshots/04-alignments/viral-recon-wizard-overview.png) — [recipe](../../assets/recipes/04-alignments/viral-recon-wizard-overview.yaml)
- [viral-recon-advanced-open](../../assets/screenshots/04-alignments/viral-recon-advanced-open.png) — [recipe](../../assets/recipes/04-alignments/viral-recon-advanced-open.yaml)

### 05-variants — 15 captured manifest rows

- [call-variants-dialog-bcftools](../../assets/screenshots/05-variants/call-variants-dialog-bcftools.png) — [recipe](../../assets/recipes/05-variants/call-variants-dialog-bcftools.yaml)
- [variants-tab-two-callers](../../assets/screenshots/05-variants/variants-tab-two-callers.png) — [recipe](../../assets/recipes/05-variants/variants-tab-two-callers.yaml)
- [call-variants-dialog-ivar](../../assets/screenshots/05-variants/call-variants-dialog-ivar.png) — [recipe](../../assets/recipes/05-variants/call-variants-dialog-ivar.yaml)
- [variants-tab-twelve-columns](../../assets/screenshots/05-variants/variants-tab-twelve-columns.png) — [recipe](../../assets/recipes/05-variants/variants-tab-twelve-columns.yaml)
- [variants-inspector-row](../../assets/screenshots/05-variants/variants-inspector-row.png) — [recipe](../../assets/recipes/05-variants/variants-inspector-row.yaml)
- [variants-preset-chips](../../assets/screenshots/05-variants/variants-preset-chips.png) — [recipe](../../assets/recipes/05-variants/variants-preset-chips.yaml)
- [variants-search-builder](../../assets/screenshots/05-variants/variants-search-builder.png) — [recipe](../../assets/recipes/05-variants/variants-search-builder.yaml)
- [variants-source-column](../../assets/screenshots/05-variants/variants-source-column.png) — [recipe](../../assets/recipes/05-variants/variants-source-column.yaml)
- [tools-mapping-submenu](../../assets/screenshots/05-variants/tools-mapping-submenu.png) — [recipe](../../assets/recipes/05-variants/tools-mapping-submenu.yaml)
- [call-variants-dialog-medaka](../../assets/screenshots/05-variants/call-variants-dialog-medaka.png) — [recipe](../../assets/recipes/05-variants/call-variants-dialog-medaka.yaml)
- [medaka-model-field](../../assets/screenshots/05-variants/medaka-model-field.png) — [recipe](../../assets/recipes/05-variants/medaka-model-field.yaml)
- [analysis-consensus-tab](../../assets/screenshots/05-variants/analysis-consensus-tab.png) — [recipe](../../assets/recipes/05-variants/analysis-consensus-tab.yaml)
- [consensus-masking-sliders](../../assets/screenshots/05-variants/consensus-masking-sliders.png) — [recipe](../../assets/recipes/05-variants/consensus-masking-sliders.yaml)
- [consensus-destination-dialog](../../assets/screenshots/05-variants/consensus-destination-dialog.png) — [recipe](../../assets/recipes/05-variants/consensus-destination-dialog.yaml)
- [import-center-vcf-card](../../assets/screenshots/05-variants/import-center-vcf-card.png) — [recipe](../../assets/recipes/05-variants/import-center-vcf-card.yaml)

### 06-classification — 35 captured manifest rows

- [import-center-classification-tab](../../assets/screenshots/06-classification/import-center-classification-tab.png) — [recipe](../../assets/recipes/06-classification/import-center-classification-tab.yaml)
- [classification-submenu](../../assets/screenshots/06-classification/classification-submenu.png) — [recipe](../../assets/recipes/06-classification/classification-submenu.yaml)
- [classification-dialog-tool-sidebar](../../assets/screenshots/06-classification/classification-dialog-tool-sidebar.png) — [recipe](../../assets/recipes/06-classification/classification-dialog-tool-sidebar.yaml)
- [taxonomy-viewport-overview](../../assets/screenshots/06-classification/taxonomy-viewport-overview.png) — [recipe](../../assets/recipes/06-classification/taxonomy-viewport-overview.yaml)
- [kraken2-databases-tab](../../assets/screenshots/06-classification/kraken2-databases-tab.png) — [recipe](../../assets/recipes/06-classification/kraken2-databases-tab.yaml)
- [kraken2-dialog](../../assets/screenshots/06-classification/kraken2-dialog.png) — [recipe](../../assets/recipes/06-classification/kraken2-dialog.yaml)
- [kraken2-advanced-settings](../../assets/screenshots/06-classification/kraken2-advanced-settings.png) — [recipe](../../assets/recipes/06-classification/kraken2-advanced-settings.yaml)
- [kraken2-taxonomy-viewport](../../assets/screenshots/06-classification/kraken2-taxonomy-viewport.png) — [recipe](../../assets/recipes/06-classification/kraken2-taxonomy-viewport.yaml)
- [kraken2-extract-reads](../../assets/screenshots/06-classification/kraken2-extract-reads.png) — [recipe](../../assets/recipes/06-classification/kraken2-extract-reads.yaml)
- [kraken2-drilldown-coronaviridae](../../assets/screenshots/06-classification/kraken2-drilldown-coronaviridae.png) — [recipe](../../assets/recipes/06-classification/kraken2-drilldown-coronaviridae.yaml)
- [esviritu-dialog](../../assets/screenshots/06-classification/esviritu-dialog.png) — [recipe](../../assets/recipes/06-classification/esviritu-dialog.yaml)
- [esviritu-advanced-settings](../../assets/screenshots/06-classification/esviritu-advanced-settings.png) — [recipe](../../assets/recipes/06-classification/esviritu-advanced-settings.yaml)
- [taxtriage-dialog](../../assets/screenshots/06-classification/taxtriage-dialog.png) — [recipe](../../assets/recipes/06-classification/taxtriage-dialog.yaml)
- [taxtriage-advanced-settings](../../assets/screenshots/06-classification/taxtriage-advanced-settings.png) — [recipe](../../assets/recipes/06-classification/taxtriage-advanced-settings.yaml)
- [nao-mgs-import-card](../../assets/screenshots/06-classification/nao-mgs-import-card.png) — [recipe](../../assets/recipes/06-classification/nao-mgs-import-card.yaml)
- [nao-mgs-import-sheet](../../assets/screenshots/06-classification/nao-mgs-import-sheet.png) — [recipe](../../assets/recipes/06-classification/nao-mgs-import-sheet.yaml)
- [nao-mgs-result-viewport](../../assets/screenshots/06-classification/nao-mgs-result-viewport.png) — [recipe](../../assets/recipes/06-classification/nao-mgs-result-viewport.yaml)
- [nao-mgs-taxon-detail](../../assets/screenshots/06-classification/nao-mgs-taxon-detail.png) — [recipe](../../assets/recipes/06-classification/nao-mgs-taxon-detail.yaml)
- [blast-verify-popover](../../assets/screenshots/06-classification/blast-verify-popover.png) — [recipe](../../assets/recipes/06-classification/blast-verify-popover.yaml)
- [plugin-manager-wastewater-pack](../../assets/screenshots/06-classification/plugin-manager-wastewater-pack.png) — [recipe](../../assets/recipes/06-classification/plugin-manager-wastewater-pack.yaml)
- [czid-import-card](../../assets/screenshots/06-classification/czid-import-card.png) — [recipe](../../assets/recipes/06-classification/czid-import-card.yaml)
- [czid-import-sheet](../../assets/screenshots/06-classification/czid-import-sheet.png) — [recipe](../../assets/recipes/06-classification/czid-import-sheet.yaml)
- [czid-result-viewport](../../assets/screenshots/06-classification/czid-result-viewport.png) — [recipe](../../assets/recipes/06-classification/czid-result-viewport.yaml)
- [czid-provenance-popover](../../assets/screenshots/06-classification/czid-provenance-popover.png) — [recipe](../../assets/recipes/06-classification/czid-provenance-popover.yaml)
- [nvd-import-card](../../assets/screenshots/06-classification/nvd-import-card.png) — [recipe](../../assets/recipes/06-classification/nvd-import-card.yaml)
- [nvd-import-preview](../../assets/screenshots/06-classification/nvd-import-preview.png) — [recipe](../../assets/recipes/06-classification/nvd-import-preview.yaml)
- [nvd-result-viewport](../../assets/screenshots/06-classification/nvd-result-viewport.png) — [recipe](../../assets/recipes/06-classification/nvd-result-viewport.yaml)
- [nvd-column-menu](../../assets/screenshots/06-classification/nvd-column-menu.png) — [recipe](../../assets/recipes/06-classification/nvd-column-menu.yaml)
- [twelve-s-workflow-library](../../assets/screenshots/06-classification/twelve-s-workflow-library.png) — [recipe](../../assets/recipes/06-classification/twelve-s-workflow-library.yaml)
- [twelve-s-dialog-inputs](../../assets/screenshots/06-classification/twelve-s-dialog-inputs.png) — [recipe](../../assets/recipes/06-classification/twelve-s-dialog-inputs.yaml)
- [twelve-s-dialog-options](../../assets/screenshots/06-classification/twelve-s-dialog-options.png) — [recipe](../../assets/recipes/06-classification/twelve-s-dialog-options.yaml)
- [twelve-s-result-species-table](../../assets/screenshots/06-classification/twelve-s-result-species-table.png) — [recipe](../../assets/recipes/06-classification/twelve-s-result-species-table.yaml)
- [twelve-s-unresolved-clusters](../../assets/screenshots/06-classification/twelve-s-unresolved-clusters.png) — [recipe](../../assets/recipes/06-classification/twelve-s-unresolved-clusters.yaml)
- [twelve-s-blast-review](../../assets/screenshots/06-classification/twelve-s-blast-review.png) — [recipe](../../assets/recipes/06-classification/twelve-s-blast-review.yaml)
- [twelve-s-export](../../assets/screenshots/06-classification/twelve-s-export.png) — [recipe](../../assets/recipes/06-classification/twelve-s-export.yaml)

### 06-human-germline-variants — 3 captured manifest rows

- [call-variants-dialog-gatk](../../assets/screenshots/06-human-germline-variants/call-variants-dialog-gatk.png) — [recipe](../../assets/recipes/06-human-germline-variants/call-variants-dialog-gatk.yaml)
- [settings-advanced-experimental](../../assets/screenshots/06-human-germline-variants/settings-advanced-experimental.png) — [recipe](../../assets/recipes/06-human-germline-variants/settings-advanced-experimental.yaml)
- [plugin-manager-gatk-packs](../../assets/screenshots/06-human-germline-variants/plugin-manager-gatk-packs.png) — [recipe](../../assets/recipes/06-human-germline-variants/plugin-manager-gatk-packs.yaml)

### 07-assembly — 14 captured manifest rows

- [assembly-submenu](../../assets/screenshots/07-assembly/assembly-submenu.png) — [recipe](../../assets/recipes/07-assembly/assembly-submenu.yaml)
- [assembly-sheet-assembler-picker](../../assets/screenshots/07-assembly/assembly-sheet-assembler-picker.png) — [recipe](../../assets/recipes/07-assembly/assembly-sheet-assembler-picker.yaml)
- [assembly-bundle-in-analyses](../../assets/screenshots/07-assembly/assembly-bundle-in-analyses.png) — [recipe](../../assets/recipes/07-assembly/assembly-bundle-in-analyses.yaml)
- [assembly-wizard-spades](../../assets/screenshots/07-assembly/assembly-wizard-spades.png) — [recipe](../../assets/recipes/07-assembly/assembly-wizard-spades.yaml)
- [assembly-viewport](../../assets/screenshots/07-assembly/assembly-viewport.png) — [recipe](../../assets/recipes/07-assembly/assembly-viewport.yaml)
- [assembly-advanced-settings](../../assets/screenshots/07-assembly/assembly-advanced-settings.png) — [recipe](../../assets/recipes/07-assembly/assembly-advanced-settings.yaml)
- [contig-detail-pane](../../assets/screenshots/07-assembly/contig-detail-pane.png) — [recipe](../../assets/recipes/07-assembly/contig-detail-pane.yaml)
- [assembly-sheet-flye](../../assets/screenshots/07-assembly/assembly-sheet-flye.png) — [recipe](../../assets/recipes/07-assembly/assembly-sheet-flye.yaml)
- [assembly-sheet-hifiasm](../../assets/screenshots/07-assembly/assembly-sheet-hifiasm.png) — [recipe](../../assets/recipes/07-assembly/assembly-sheet-hifiasm.yaml)
- [flye-contig-table](../../assets/screenshots/07-assembly/flye-contig-table.png) — [recipe](../../assets/recipes/07-assembly/flye-contig-table.yaml)
- [assembly-sheet-curated-arguments](../../assets/screenshots/07-assembly/assembly-sheet-curated-arguments.png) — [recipe](../../assets/recipes/07-assembly/assembly-sheet-curated-arguments.yaml)
- [create-bundle-action-bar](../../assets/screenshots/07-assembly/create-bundle-action-bar.png) — [recipe](../../assets/recipes/07-assembly/create-bundle-action-bar.yaml)
- [contig-context-menu](../../assets/screenshots/07-assembly/contig-context-menu.png) — [recipe](../../assets/recipes/07-assembly/contig-context-menu.yaml)
- [derived-bundle-in-sidebar](../../assets/screenshots/07-assembly/derived-bundle-in-sidebar.png) — [recipe](../../assets/recipes/07-assembly/derived-bundle-in-sidebar.yaml)

### 08-workflows — 9 captured manifest rows

- [workflow-builder-experimental-toggle](../../assets/screenshots/08-workflows/workflow-builder-experimental-toggle.png) — [recipe](../../assets/recipes/08-workflows/workflow-builder-experimental-toggle.yaml)
- [workflow-builder-sidebar-library](../../assets/screenshots/08-workflows/workflow-builder-sidebar-library.png) — [recipe](../../assets/recipes/08-workflows/workflow-builder-sidebar-library.yaml)
- [workflow-builder-palette](../../assets/screenshots/08-workflows/workflow-builder-palette.png) — [recipe](../../assets/recipes/08-workflows/workflow-builder-palette.yaml)
- [export-provenance-submenu](../../assets/screenshots/08-workflows/export-provenance-submenu.png) — [recipe](../../assets/recipes/08-workflows/export-provenance-submenu.yaml)
- [export-provenance-save-panel](../../assets/screenshots/08-workflows/export-provenance-save-panel.png) — [recipe](../../assets/recipes/08-workflows/export-provenance-save-panel.yaml)
- [export-provenance-complete-alert](../../assets/screenshots/08-workflows/export-provenance-complete-alert.png) — [recipe](../../assets/recipes/08-workflows/export-provenance-complete-alert.yaml)
- [nextflow-export-main-nf](../../assets/screenshots/08-workflows/nextflow-export-main-nf.png) — [recipe](../../assets/recipes/08-workflows/nextflow-export-main-nf.yaml)
- [workflow-library-linked-package](../../assets/screenshots/08-workflows/workflow-library-linked-package.png) — [recipe](../../assets/recipes/08-workflows/workflow-library-linked-package.yaml)
- [workflow-operations-runner](../../assets/screenshots/08-workflows/workflow-operations-runner.png) — [recipe](../../assets/recipes/08-workflows/workflow-operations-runner.yaml)

### 09-genotyping — 13 captured manifest rows

- [genotyping-submenu](../../assets/screenshots/09-genotyping/genotyping-submenu.png) — [recipe](../../assets/recipes/09-genotyping/genotyping-submenu.yaml)
- [genotype-matrix-overview](../../assets/screenshots/09-genotyping/genotype-matrix-overview.png) — [recipe](../../assets/recipes/09-genotyping/genotype-matrix-overview.yaml)
- [genotyping-run-dialog](../../assets/screenshots/09-genotyping/genotyping-run-dialog.png) — [recipe](../../assets/recipes/09-genotyping/genotyping-run-dialog.yaml)
- [genotyping-analysis-mode](../../assets/screenshots/09-genotyping/genotyping-analysis-mode.png) — [recipe](../../assets/recipes/09-genotyping/genotyping-analysis-mode.yaml)
- [genotyping-advanced-options](../../assets/screenshots/09-genotyping/genotyping-advanced-options.png) — [recipe](../../assets/recipes/09-genotyping/genotyping-advanced-options.yaml)
- [genotyping-operations-row](../../assets/screenshots/09-genotyping/genotyping-operations-row.png) — [recipe](../../assets/recipes/09-genotyping/genotyping-operations-row.yaml)
- [genotyping-full-length-dialog](../../assets/screenshots/09-genotyping/genotyping-full-length-dialog.png) — [recipe](../../assets/recipes/09-genotyping/genotyping-full-length-dialog.yaml)
- [genotype-matrix-reading](../../assets/screenshots/09-genotyping/genotype-matrix-reading.png) — [recipe](../../assets/recipes/09-genotyping/genotype-matrix-reading.yaml)
- [genotype-call-evidence](../../assets/screenshots/09-genotyping/genotype-call-evidence.png) — [recipe](../../assets/recipes/09-genotyping/genotype-call-evidence.yaml)
- [genotype-inspector-display](../../assets/screenshots/09-genotyping/genotype-inspector-display.png) — [recipe](../../assets/recipes/09-genotyping/genotype-inspector-display.yaml)
- [genotype-inspector-export](../../assets/screenshots/09-genotyping/genotype-inspector-export.png) — [recipe](../../assets/recipes/09-genotyping/genotype-inspector-export.yaml)
- [genotype-export-save-panel](../../assets/screenshots/09-genotyping/genotype-export-save-panel.png) — [recipe](../../assets/recipes/09-genotyping/genotype-export-save-panel.yaml)
- [genotype-pivot-workbook](../../assets/screenshots/09-genotyping/genotype-pivot-workbook.png) — [recipe](../../assets/recipes/09-genotyping/genotype-pivot-workbook.yaml)

### appendices — 7 captured manifest rows

- [ai-assistant-panel](../../assets/screenshots/appendices/ai-assistant-panel.png) — [recipe](../../assets/recipes/appendices/ai-assistant-panel.yaml)
- [ai-assistant-provider-setup](../../assets/screenshots/appendices/ai-assistant-provider-setup.png) — [recipe](../../assets/recipes/appendices/ai-assistant-provider-setup.yaml)
- [ai-assistant-azure-endpoint](../../assets/screenshots/appendices/ai-assistant-azure-endpoint.png) — [recipe](../../assets/recipes/appendices/ai-assistant-azure-endpoint.yaml)
- [primer-scheme-import-card](../../assets/screenshots/appendices/primer-scheme-import-card.png) — [recipe](../../assets/recipes/appendices/primer-scheme-import-card.yaml)
- [primer-scheme-import-sheet](../../assets/screenshots/appendices/primer-scheme-import-sheet.png) — [recipe](../../assets/recipes/appendices/primer-scheme-import-sheet.yaml)
- [shared-projects-read-only-banner](../../assets/screenshots/appendices/shared-projects-read-only-banner.png) — [recipe](../../assets/recipes/appendices/shared-projects-read-only-banner.yaml)
- [operations-panel-failed-row](../../assets/screenshots/appendices/operations-panel-failed-row.png) — [recipe](../../assets/recipes/appendices/operations-panel-failed-row.yaml)

## Current session state

- Preview candidate build 4673 remains installed for continued captures. Original build 4510 backup is retained at `/tmp/lge-manual-preview-backup-4510.app`; restoring it is still pending.
- Experimental Features was enabled for the builder attempt and still needs restoration to its original off setting.
- The main demo and isolated rebuild-check project remain available under `~/Desktop/lge-docs/`.
- Existing Williams project data and the earlier accidental result were left alone.
- Provenance audits found a missing native provenance record on the new NCBI download and a removed staging-path reference in otherwise checksum-valid trim provenance. These are recorded limitations, not repaired results.
