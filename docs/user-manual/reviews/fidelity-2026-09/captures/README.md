# Background capture pass (2026-09-07)

The Foundations, Sequences, Reads, Alignments, Variants, Classification, Human Germline, Assembly, Workflows, Genotyping and Appendices parts were captured by sonnet agents driving Lungfish Preview 2026.9.13 through the background computer-use tools, with Fable reviewing every PNG and recapturing where a crop or a state was wrong. Every capture has a recipe under `assets/recipes/<part>/` and every part has a report in this folder.

## Counts

| Part | Captured | Open |
|---|---|---|
| 01-foundations | 18 | 9 |
| 02-sequences | 13 | 8 |
| 03-reads | 19 | 11 |
| 04-alignments | 14 | 6 |
| 05-variants | 14 | 3 |
| 06-classification | 21 | 21 |
| 06-human-germline-variants | 3 | 1 |
| 07-assembly | 7 | 7 |
| 08-workflows | 4 | 7 |
| 09-genotyping | 9 | 4 |
| appendices | 5 | 3 |
| all | 127 | 80 |

Rows counted per chapter marker, so a shot shared by two chapters counts twice. The stored PNGs number 124 and the checker reports 78 distinct ids without a PNG.

## Still open, by what unblocks them

### Open menus, submenus and pop-up pickers (full-screen pass)

- `01-foundations/file-export-menu`
- `01-foundations/operations-panel-right-click-menu`
- `01-foundations/primer-scheme-picker-built-in`
- `02-sequences/hbb-annotation-context-menu`
- `03-reads/read-processing-menu`
- `03-reads/remove-duplicates-preset-picker`
- `03-reads/search-subsetting-menu`
- `04-alignments/extract-reads-region-menu`
- `04-alignments/primer-trim-scheme-menu`
- `04-alignments/tools-mapping-submenu`
- `04-alignments/viral-recon-menu-item`
- `05-variants/tools-mapping-submenu`
- `06-classification/classification-submenu`
- `06-classification/kraken2-extract-reads`
- `06-classification/nvd-column-menu`
- `06-classification/twelve-s-export`
- `07-assembly/assembly-submenu`
- `07-assembly/contig-context-menu`
- `08-workflows/export-provenance-submenu`
- `09-genotyping/genotyping-submenu`

### Right-click routes and drag and drop (full-screen pass)

- `02-sequences/export-alignment-sheet`
- `02-sequences/iqtree-dialog`
- `08-workflows/workflow-builder-canvas`
- `08-workflows/workflow-builder-node-inspector`

### File and save panels (full-screen pass)

- `01-foundations/empty-project-window`
- `02-sequences/import-center-annotation-track-alert`
- `03-reads/import-fastq-configuration-sheet`
- `03-reads/ont-barcode-sheet-controls`
- `03-reads/ont-import-configuration-sheet`
- `06-classification/czid-import-sheet`
- `06-classification/nao-mgs-import-sheet`
- `06-classification/nvd-import-preview`
- `08-workflows/export-provenance-complete-alert`
- `08-workflows/export-provenance-save-panel`
- `09-genotyping/genotype-export-save-panel`

### Window management (full-screen pass)

- `01-foundations/provenance-export-folder`
- `01-foundations/welcome-window`
- `08-workflows/nextflow-export-main-nf`
- `09-genotyping/genotype-pivot-workbook`
- `appendices/shared-projects-read-only-banner`

### Results and fixtures the demo project lacks

- `02-sequences/ncbi-bundle-in-sidebar`
- `02-sequences/pathoplexus-pane`
- `03-reads/sidebar-after-merge`
- `03-reads/sidebar-after-ont-import`
- `03-reads/sra-bundle-in-sidebar`
- `03-reads/sra-import-configuration-sheet`
- `03-reads/trim-operation-row`
- `04-alignments/primer-trim-track-result`
- `04-alignments/viral-recon-inspector-outputs`
- `05-variants/imported-benchmark-in-variants-tab`
- `05-variants/name-imported-variant-bundle`
- `06-classification/blast-results-drawer`
- `06-classification/czid-provenance-popover`
- `06-classification/czid-result-viewport`
- `06-classification/esviritu-alignment-evidence`
- `06-classification/esviritu-database-missing`
- `06-classification/esviritu-result-viewport`
- `06-classification/nao-mgs-result-viewport`
- `06-classification/nao-mgs-taxon-detail`
- `06-classification/nvd-blast-drawer`
- `06-classification/taxtriage-batch-overview`
- `06-classification/taxtriage-result-table`
- `06-classification/twelve-s-blast-review`
- `06-classification/twelve-s-result-species-table`
- `06-classification/twelve-s-unresolved-clusters`
- `07-assembly/assembly-sheet-curated-arguments`
- `07-assembly/assembly-sheet-flye`
- `07-assembly/assembly-sheet-hifiasm`
- `07-assembly/derived-bundle-in-sidebar`
- `07-assembly/flye-contig-table`
- `08-workflows/workflow-library-linked-package`
- `appendices/primer-scheme-inspector`

### Running or failed operations

- `01-foundations/operations-panel-row`
- `06-human-germline-variants/operations-panel-gatk-run`
- `09-genotyping/genotyping-operations-row`
- `appendices/operations-panel-failed-row`

### Product changes needed first

- `01-foundations/provenance-lineage-step-expanded`
- `02-sequences/translation-tool-hbb-cds`

## Findings for the chapter authors and the product

- 02-sequences/01-importing-and-viewing.md (translation-tool-hbb-cds): the toolbar Translate button is hidden for reference bundles opened from the sidebar (MainWindowController.updateToolbarForContentMode shows it only in .genomics/.empty mode; reference bundles open in mapping mode). Chapter says the toolbar button is the only route to the overlay tool. Needs either a product fix or chapter rewording.
- 02-sequences/05-building-trees.md (tree-viewport-primate-mito): caption says the Nodes drawer lists all eight nodes; the drawer shows two or three rows at a time. Reword caption.
- 02-sequences/03-extracting-and-comparing.md (extract-region-dialog): the Extract Sequence sheet is taller than the 900-point window and scrolls with no visible scrollbar.
- 01-foundations (provenance-lineage-step-expanded): no UI affordance to show one variant track's own provenance when a bundle has two tracks. Product gap.
- 01-foundations/02-sequences shared demo fixture: primate-mito FASTA was never imported as a reference bundle (build script aligns straight from the fixture file), so the MAFFT dialog route in 04-aligning-sequences.md cannot be followed in the demo project.
- Capture mechanics: the app_screenshot coordinate frame is NOT window points. For a 1400x1000 window the frame is 1294x924, for 1400x900 it is 1372x882. Convert frame coords to points with (window width / frame width) before passing CROP to capture-window.sh, and always read the PNG back.
- 02-sequences/04-aligning-sequences.md (mafft-dialog): with a reference bundle selected in the sidebar, the MAFFT pane's scope line reads "Aligning all 0 sequences." (MSASequenceScopePicker.summaryText gets allCount 0). Product defect; recapture after fix.
- Capture mechanics: the app must be frontmost when screencapture runs or toggles and segmented controls paint grey. capture-window.sh now activates the app first (ACTIVATE=0 disables).
- Full-screen pass list so far: welcome-window, empty-project-window, file-export-menu (x2), primer-scheme-picker-built-in, operations-panel-right-click-menu, hbb-annotation-context-menu (x2), iqtree-dialog, export-alignment-sheet, import-center-annotation-track-alert, provenance-export-folder.
- 03-reads (human-scrub-dialog): managed human database not installed on this machine, so the Database row shows Choose... rather than Replace.../Clear. Recapture after installing it (Plugin Manager > Databases) or reword the caption.
- 03-reads (orient-reads-pane): hint under Extra arguments still says "Select a reference sequence in the Inputs section" after a reference is chosen. Minor product text bug.
- 03-reads polish: fastq-sparkline-popover crop cuts the chart's left axis; widen on a later pass.
- Demo fixture gaps for later: SRR32909537 SRA download (sra-bundle-in-sidebar, sra-import-configuration-sheet), a merged bundle under Analyses (sidebar-after-merge), a nanopore run folder import (ont-* rows, sidebar-after-ont-import), a finished trim run (trim-operation-row).
- 04-alignments/02-reading-an-alignment.md (pileup-zoom): mismatched read bases render as solid coloured blocks at every zoom tested, never as coloured letters. Chapter says "drawn as a coloured letter". Check the letter threshold in the pileup renderer or reword.
- 04-alignments (primer-trim-dialog-target): captured on the chr20 HG002 track since the demo project has no SARS-CoV-2 alignment; Output Track Name not pre-filled because no scheme could be chosen in background mode. Redo in the full-screen pass with a scheme chosen.
- 05-variants (variants-inspector-row): the Inspector's Variant Detail block shows Quality but no Filter line. Chapter caption says "quality and filter". Reword caption or add the line.
- 05-variants (variants-preset-chips): the chip strip's fourth group (Sample / Genotype) sits past the right edge at 1468 points even with sidebar and Inspector collapsed. Caption says four groups; reword to "the first three groups" or capture wider.
- 05-variants (variants-search-builder): captured with the Quality Review preset (two Call Quality rules). Caption wants one Call Quality and one INFO field rule; the category popup needs the full-screen pass.
- 05-variants (call-variants-dialog-ivar, medaka rows): captured on the Illumina chr20 track; no primer-trimmed or nanopore track in the demo project.
- Capture mechanics: the variants table's column widths are runtime state (only visibility and order persist in ColumnPreferences_variantCalls). An agent's header drags survive for the session; relaunching the app resets them. Tell capture agents never to drag table headers.
- 06-classification: the Inspector Summary tab shows stale content for a taxonomy (Kraken2) result: after viewing nvd-demo it shows "NVD Result" fields, after the chr20 bundle it shows Organism/Assembly of the reference. Product defect.
- 06-classification/05-running-nao-mgs.md (nao-mgs-import-card): the Import Center card carries no NM badge. Reword caption or add the badge.
- 06-classification/02-running-kraken2.md (kraken2-taxonomy-viewport): the demo Kraken2 run has no Bracken sidecar, so no Bracken column. Either add bracken to the demo build or reword the caption.
- 06-classification/04-running-taxtriage.md (taxtriage-dialog): Prerequisites row reads "Nextflow" and "Apple Containerization: Available", not "Nextflow and Docker". Chapter text needs correcting.
- 06-classification (esviritu-database-missing): the EsViritu database is installed on this machine, so the missing-database state cannot be captured here.
- Demo fixture gaps for later: EsViritu, TaxTriage, NAO-MGS, CZ-ID, 12S and BLAST results (16 rows), plus the three import sheets that need a file panel.
- 07-assembly/02-running-spades.md and 01-when-to-assemble.md: the assembly viewport has no summary strip along the top (only wall time); assembler, contig count, N50, L50, GC and version live in the Inspector's Assembly Context block. Chapter text and captions (assembly-viewport, flye-contig-table) need rewording.
- 07-assembly/01-when-to-assemble.md (assembly-bundle-in-analyses): the Analyses/HG002-chrM row is a leaf, not a run folder with a nested .lungfishref bundle. Chapter text needs checking against the app.
- 07-assembly (assembly-advanced-settings): the SPAdes Extra arguments field is empty but its placeholder reads --meta --tmp-dir '/Volumes/Fast Scratch', a machine-specific path. Product polish: use a neutral placeholder.
- Demo fixture gaps for later: a nanopore (hg002-long-reads) bundle and a Flye run for the Flye and Hifiasm rows, and an extraction to a derived bundle.
- appendices (ai-assistant-panel): with the chr20 bundle loaded, the Inspector's AI Assistant says "No genome bundle is currently loaded" and offers one Getting started suggestion, not the six suggestion buttons the chapter promises. Product defect. Also the Assistant shows in the Inspector without any tab highlighted.
- 08-workflows: workflow-builder-canvas and workflow-builder-node-inspector need drag and drop (palette entries only accept drags). Full-screen pass.
- 08-workflows: the capture agent created a "Mito read cleanup" workflow inside the demo project (Workflows/Mito-read-cleanup.lungfishflow). Decide whether to keep it in the fixture build or remove it.

## Incident

During the Genotyping pass a background Return keypress meant for a disclosure landed on the Workflow Operations dialog's Run button and started a real miSeq genotyping run on one sample in the Williams project. It wrote `Analyses/Amplicon genotyping results/amplicon-genotyping_4.lungfishgenotype` plus lock and operation-history files. Nothing already in the project was changed. The bundle is left in place for the owner to remove, and capture prompts now forbid pressing Return inside a dialog.

## Mechanics that the full-screen pass should keep

- The app_screenshot coordinate frame is not window points. Convert with (window width / frame width) per axis before cropping, and read every PNG back.
- The app must be frontmost when screencapture runs, or toggles and segmented controls paint grey. capture-window.sh activates it first.
- Hiding the sidebar or Inspector shrinks the window. Set the size again afterwards.
- Table column widths are runtime state. Never drag headers; relaunch the app to reset them.
- Focus Viewer narrows the window rather than widening the content.
