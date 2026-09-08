# Capture session results: 06-classification

Session captured against the demo project (`~/Desktop/lge-docs/LGE Manual Demo.lungfish`),
main window CGWindowID 59496 (1400x900 points, Retina). Fixtures used: the demo
project's `Analyses/kraken2-SRR36291587` (Kraken2 result, no Bracken sidecar),
`Analyses/nvd-demo` (NVD result), and `Imports/SRR36291587` (FASTQ bundle).

## Captured (20 this session, plus 1 already captured = 21/42)

| Id | Pixel size | Crop | Notes |
|---|---|---|---|
| `plugin-manager-wastewater-pack` | (pre-existing) | window | Already captured before this session, skipped per instructions. |
| `import-center-classification-tab` | 1600x1469 | window (Import Center resized to 980x900) | All six cards (NAO-MGS, Kraken2, EsViritu, TaxTriage, NVD, CZ-ID) visible without scrolling. |
| `nao-mgs-import-card` | 1176x210 | region of Import Center window | Cropped to the NAO-MGS Results card only. No "NM badge" is visible on the card — see discrepancies below. |
| `nvd-import-card` | 1176x220 | region of Import Center window | Cropped to the NVD Results card only. |
| `czid-import-card` | 1176x220 | region of Import Center window | Cropped to the CZ-ID Results card only. |
| `kraken2-databases-tab` | 1600x2000 | window (Plugin Manager resized to 800x1000, scrolled) | Recommended-database banner, all 11 Kraken2 rows (EuPathDB46 through Viral), storage readout all in frame. |
| `classification-dialog-tool-sidebar` | 1600x1134 | region 208,102,982,696 | FASTQ/FASTA Operations sheet from Tools > Classification > Kraken2..., Kraken2/EsViritu/TaxTriage tool sidebar visible. |
| `kraken2-dialog` | 1600x1134 | region 208,102,982,696 | Same sheet; dataset line, Database picker (SILVA, 24GB RAM readout), Sensitivity segmented control (Balanced). |
| `kraken2-advanced-settings` | 1600x1134 | region 208,102,982,696 | Advanced Settings expanded: Confidence slider, Min hit groups, Threads, Memory mapping, Extra arguments. |
| `taxonomy-viewport-overview` | 1600x1028 | window | Kraken2 result open: sunburst, Root breadcrumb, per-taxon table with Filter taxa field. |
| `kraken2-taxonomy-viewport` | 1600x1028 | window | Same viewport. **No Bracken column present** — see discrepancies below. |
| `kraken2-drilldown-coronaviridae` | 1600x1028 | window | Double-clicked the Coronaviridae wedge; sunburst re-centred, full breadcrumb path Root > Viruses > ... > Coronaviridae shown. |
| `esviritu-dialog` | 1600x1134 | region 208,102,982,696 | Sample section (SRR36291587, single-end), Database section (green dot, EsViritu v3.2.4, 0.8GB — already installed), fastp checkbox checked. |
| `esviritu-advanced-settings` | 1600x1134 | region 208,102,982,696 | Min read length, Threads, Extra arguments fields. |
| `taxtriage-dialog` | 1600x1134 | region 208,102,982,696 | Prerequisites row, Samples section, Kraken2 Database picker, Sequencing Platform. See discrepancy on Docker indicator below. |
| `taxtriage-advanced-settings` | 1600x1134 | region 208,102,982,696 | K2 Confidence, Top hits, Max memory, Max CPUs, Skip Krona visualization, Extra arguments. |
| `nvd-result-viewport` | 1600x1028 | window | nvd-demo open, four summary cards, By Sample/By Taxon control, Search contigs field, NODE_1 (500bp) row expanded to Hit #1-#3, detail pane with contig alignment. |
| `twelve-s-workflow-library` | 1600x192 | region 10,365,1540,185 (of Workflow Library resized to 780x1000) | 12S Amplicon Matching card, Specialized badge, Third-Party Tools dependency, Enabled switch (off, default state). |
| `twelve-s-dialog-inputs` | 1600x1600 | window | Workflow Operations dialog on 12S Amplicon Matching with SRR36291587 selected; Reference picker + Create 12S Reference..., Analysis Metadata picker, FASTQ Bundles (1 selected). |
| `twelve-s-dialog-options` | 1600x1600 | window | Same dialog; Read Platform segmented picker, Result Name, Min Soft Clip, Advanced Options expanded (Max Indels, Run vsearch chimera review). |
| `blast-verify-popover` | 1600x1028 | window | Verify "Riboviria" via NCBI BLAST popover opened from the plain BLAST Verify button in the Kraken2 taxonomy viewport action bar. Reads to submit slider, NCBI warning, Run BLAST button all visible. **Run BLAST was never clicked**; popover dismissed with Escape afterward. |

## Skipped (21)

| Id | Reason |
|---|---|
| `classification-submenu` | Open Tools > Classification submenu screenshot — needs the full-screen pass. |
| `kraken2-extract-reads` | Right-click menu on a taxon row — needs the full-screen pass. |
| `esviritu-database-missing` | EsViritu database is already installed in this demo profile (green dot, v3.2.4, 0.8GB shown in `esviritu-dialog`); this shot needs the database absent, which cannot be captured without uninstalling it. |
| `esviritu-result-viewport` | No EsViritu result in the demo project. |
| `esviritu-alignment-evidence` | No EsViritu result in the demo project. |
| `taxtriage-result-table` | No TaxTriage result in the demo project. |
| `taxtriage-batch-overview` | No TaxTriage result in the demo project. |
| `nao-mgs-import-sheet` | Needs a NAO-MGS results file to hand through a file panel. |
| `nao-mgs-result-viewport` | No NAO-MGS result in the demo project. |
| `nao-mgs-taxon-detail` | No NAO-MGS result in the demo project. |
| `blast-results-drawer` | No completed BLAST verification present (never ran BLAST Verify, per the never-submit-to-network-services rule). |
| `czid-import-sheet` | Needs a CZ-ID export file to hand through a file panel. |
| `czid-result-viewport` | No CZ-ID result in the demo project. |
| `czid-provenance-popover` | No CZ-ID result in the demo project. |
| `nvd-import-preview` | Needs a file panel (NVD run folder scan through Browse...). |
| `nvd-blast-drawer` | No BLAST verification has been run from the NVD viewport (only a BLAST Verify button, no existing drawer state, and running one would submit data to NCBI). |
| `nvd-column-menu` | Right-click menu on the contig outline's column header — needs the full-screen pass. |
| `twelve-s-result-species-table` | No 12S result in the demo project (needs primate-12s fixture, not present). |
| `twelve-s-unresolved-clusters` | No 12S result in the demo project. |
| `twelve-s-blast-review` | No 12S result in the demo project. |
| `twelve-s-export` | Open Export menu — needs the full-screen pass (and no 12S result to open it from). |

## Failed

None. All attempted captures succeeded on the first or second try (a couple needed a coordinate-frame correction for CROP or a resize before the target content was fully visible).

## Discrepancies between the chapter text and the running app

- **`nao-mgs-import-card`**: the chapter caption calls out "its NM badge," but the NAO-MGS Results card in the Import Center's Classification Results tab shows no badge of any kind next to the title (only the title "NAO-MGS Results," description text, and file-hint line). Worth a chapter fidelity check.
- **`kraken2-taxonomy-viewport`**: the chapter caption specifically calls for "its Bracken column," but the demo project's `Analyses/kraken2-SRR36291587` run has no `.bracken` sidecar on disk (confirmed via `find` — only `kraken2.sqlite`, `classification.kraken.gz`, and their provenance JSON files exist) and the per-taxon table shows only Sample and Taxon Name columns, no Bracken column. Captured the shot as-is with a note in its recipe; a Bracken-enabled Kraken2 run would be needed to capture the column faithfully.
- **`taxtriage-dialog`** / **`taxtriage-advanced-settings`**: the chapter caption says the Prerequisites row shows "Nextflow and Docker indicators," but the running dialog's Prerequisites row reads "Nextflow" and "Apple Containerization: Available" — there is no separate Docker indicator. This looks like a chapter-vs-app naming drift (Apple Containerization appears to have replaced or supplemented a Docker-labeled indicator).

## check-shots output (06-classification lines only)

```
missing png 06-classification/classification-submenu
missing recipe 06-classification/classification-submenu
missing png 06-classification/kraken2-extract-reads
missing recipe 06-classification/kraken2-extract-reads
missing png 06-classification/esviritu-database-missing
missing recipe 06-classification/esviritu-database-missing
missing png 06-classification/esviritu-result-viewport
missing recipe 06-classification/esviritu-result-viewport
missing png 06-classification/esviritu-alignment-evidence
missing recipe 06-classification/esviritu-alignment-evidence
missing png 06-classification/taxtriage-result-table
missing recipe 06-classification/taxtriage-result-table
missing png 06-classification/taxtriage-batch-overview
missing recipe 06-classification/taxtriage-batch-overview
missing png 06-classification/nao-mgs-import-sheet
missing recipe 06-classification/nao-mgs-import-sheet
missing png 06-classification/nao-mgs-result-viewport
missing recipe 06-classification/nao-mgs-result-viewport
missing png 06-classification/nao-mgs-taxon-detail
missing recipe 06-classification/nao-mgs-taxon-detail
missing png 06-classification/blast-results-drawer
missing recipe 06-classification/blast-results-drawer
missing png 06-classification/czid-import-sheet
missing recipe 06-classification/czid-import-sheet
missing png 06-classification/czid-result-viewport
missing recipe 06-classification/czid-result-viewport
missing png 06-classification/czid-provenance-popover
missing recipe 06-classification/czid-provenance-popover
missing png 06-classification/nvd-import-preview
missing recipe 06-classification/nvd-import-preview
missing png 06-classification/nvd-blast-drawer
missing recipe 06-classification/nvd-blast-drawer
missing png 06-classification/nvd-column-menu
missing recipe 06-classification/nvd-column-menu
missing png 06-classification/twelve-s-result-species-table
missing recipe 06-classification/twelve-s-result-species-table
missing png 06-classification/twelve-s-unresolved-clusters
missing recipe 06-classification/twelve-s-unresolved-clusters
missing png 06-classification/twelve-s-blast-review
missing recipe 06-classification/twelve-s-blast-review
missing png 06-classification/twelve-s-export
missing recipe 06-classification/twelve-s-export
```

## Fable review (2026-09-07)

- `blast-verify-popover` cropped to the viewport columns after capture because the Inspector still showed the NVD Result summary from the previously selected analysis.
- The Inspector's Summary tab keeps the previous selection's content when a Kraken2 result is selected (NVD Result fields, or the chr20 reference's Organism and Assembly lines). Product defect noted for follow-up.

- 2026-09-07 completion pass `classification-submenu` captured via authorized System Events menu control. Display crop (380, 0, 430, 490), 860×980px. PNG read back and all named menu entries checked.

- Captured `twelve-s-result-species-table` and `twelve-s-unresolved-clusters`,1600×1028. Sidebar and Inspector hidden and named window resized to1400×900 points so all named columns fit. Human teaching fixture has110 exact reads and56 unresolved clusters. The summary appears above the table, not below as the original caption states.

- Captured `twelve-s-blast-review`,1600×1028, after a real NCBI query of the public human fixture returned100% Homo sapiens hits. Captured `twelve-s-export`,350×200 region810,1135,175,100 showing CSV/TSV/Excel, then dismissed without exporting.

- Captured `nao-mgs-result-viewport` and `nao-mgs-taxon-detail`,1600×1028 with Inspector hidden. Summary does report7 taxa (sample/taxon rows), while overview reports4 unique taxa. Detail uses the6-hit Cressdnaviricota water-sample row with one existing miniBAM panel. Observed stale12S Detail Inspector on navigation, excluded by hiding Inspector and recorded here as a product defect.

- Captured `czid-result-viewport`,1600×1028 with side panels hidden and viewer divider at36% to show table columns. Captured `czid-provenance-popover`,772×692 region2088,557,386,346 with final stored source-file path and imported version metadata.

- `nao-mgs-import-sheet` 1040 × 960 pixels, region 934,226,520,480 in Preview build 4673. Existing test fixture validates. Read-only path, source name and Cancel/Run visible. No duplicate import.

- `czid-import-sheet` 1040 × 920 pixels, region 934,226,520,460 in Preview build 4673. All Preview rows and the complete Project Destination readout require scrolling the fixed-height form. Caption describes that state. Browse section is above the crop's scroll position. Existing test TSV, no duplicate import.
