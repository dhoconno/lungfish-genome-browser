# Completing the manual's screenshots: handoff specification

Written 2026-09-07 for whichever assistant finishes the screenshot pass. Everything referenced here is on `main`. Read this file, then `captures/README.md` (counts, open rows by blocker, findings), then `SHOTS.md` (the manifest, one row per marker), then the per-part reports under `captures/`.

## 1. State you are starting from

- The manual under `docs/user-manual/` is rewritten to Lungfish Genome Explorer Preview 2026.9.13 and lint-clean. Its chapters carry `<!-- SHOT: id -->` markers. The mkdocs hook `build/hooks/shots.py` turns a marker into the image plus a visible caption when `assets/screenshots/<part>/<id>.png` exists, and leaves it invisible otherwise, so the site builds either way.
- 127 of the 207 manifest rows are captured (124 PNGs, three ids shared across parts). 80 rows are open. `captures/README.md` groups them by what unblocks them; that grouping is the work plan below.
- Every capture has a recipe under `assets/recipes/<part>/<id>.yaml` (schema `build/scripts/shot/schema.json`) recording the app state and the clicks as prose steps.
- The demo project lives at `~/Desktop/lge-docs/LGE Manual Demo.lungfish` and is built by `fixtures/demo-project/build-demo-project.sh` from the fixtures under `fixtures/`. The Williams project at `~/Desktop/lge-docs/32566_MS267_Williams1.lungfish` is the user's real macaque data and is read only.

## 2. Ground rules from the user (binding)

- Any project you create or copy for a screenshot goes under `~/Desktop/lge-docs/`. Nothing else writes there.
- The Williams project is read only. Do not run anything in it, do not import into it, and never name an animal beyond what the screenshot itself shows. One artifact from an earlier accidental run, `Analyses/Amplicon genotyping results/amplicon-genotyping_4.lungfishgenotype`, is awaiting the user's decision; leave it alone.
- Never click Run, Install, Download, Delete, Accept, or Save in the app except where a row below says so, and then only on the demo project or a copy of it.
- Leave every API key field empty. Keep no real signing key in `provenance-signing-settings`. Haplotyping stays a placeholder in the manual.
- Only the Preview app (`/Applications/Lungfish Preview.app`, bundle id `com.lungfish.browser.preview`) appears in a screenshot. Light appearance. Menu bar and Dock stay out of frame except in the menu shots, where the menu bar is the subject.
- Human and macaque examples are preferred over viral ones in prose. Shots of viral fixtures (SRR36291587, the Viral Recon chapter) are fine where the chapter is about a viral tool.
- Prose rules for any chapter edit: no em dashes, no semicolons, no colons inside a sentence, "Lungfish Genome Explorer (LGE)" on first use then "LGE". Run `bash docs/user-manual/build/scripts/lint-chapter.sh <file>` (strict by default) before committing a chapter.
- Do not put the word "git" in any ledger file under `.superpowers/`.

## 3. Tools and mechanics

### Scripts

| Script | Use |
|---|---|
| `build/scripts/campaign/capture-window.sh <CGWindowID> <part> <id> [max]` | Capture one window at 2x, cap at 1600 px wide. `CROP="x y w h"` in window points keeps a region. Activates the app first (`ACTIVATE=0` to skip). |
| `build/scripts/campaign/capture-region.sh <part> <id> <x> <y> <w> <h>` | Capture a display rectangle in display points. For open menus, submenus, pop-up pickers, context menus, popovers. |
| `build/scripts/campaign/write-recipe.py <part> <chapter.md> <id> --crop window\|region [--region x y w h] --fixture demo-project\|williams\|none --state "..." --step "..." [--open key=path] [--viewport-class ...]` | Writes the recipe and flips the manifest row to `captured`. Run once per chapter file for a shot two chapters share. |
| `build/scripts/campaign/shot-worklist.py <part> [out.md]` | Open rows of one part with caption, fixture, state, prerequisites. |
| `node build/scripts/campaign/check-shots.mjs docs/user-manual` (from the repo root) | Lists every marker without a PNG or a recipe and every orphan recipe. |
| `build/scripts/campaign/refresh-shots-manifest.py` | Rewrites the checker section and counts at the foot of `SHOTS.md`. Run before each commit. |
| `fixtures/demo-project/build-demo-project.sh` | Rebuilds the demo project idempotently (each step skips when its output exists). Extend it for the fixture rows. |

Window ids come from `mcp__computer-use__app_list_windows` (main window titles are withheld, so tell windows apart by size or a screenshot). CROP coordinates are window points with the origin at the window's top-left.

### Mechanics that cost a day to learn

- The `app_screenshot` coordinate frame is not window points. A 1400x900 window reports 1372x882, 1468x900 reports 1400x858, and a window with side panes hidden reports 1212x900. Convert per axis with (window size / frame size) before cropping, and read every PNG back with the Read tool before writing its recipe.
- The app must be frontmost when `screencapture` runs or toggles and segmented controls paint grey. `capture-window.sh` activates it. In a full-screen session you are already frontmost.
- Hiding the sidebar or the Inspector, and View > Focus Viewer, shrink the window. Set the size again: `osascript -e 'tell application "System Events" to tell process "Lungfish Preview" to set size of window 1 to {1400, 900}'`.
- Table column widths are runtime state. Never drag table headers. If a table looks wrong, relaunch the app.
- The app restores every previously open project on launch. After `open -a "Lungfish Preview" <project>` close the extra window through System Events (`click button 1 of window "<title>"`), never with Cmd-W while a dialog might be open.
- A Return keypress inside a dialog presses its default button, which is Run. Never send Return to a dialog. Use Escape or the Cancel button.
- Background tools (`app_*`) cannot open menus, pop-up pickers, context menus, file panels, or drag. Those rows need `request_full_control` (the user must be present and approve it) and the `computer_batch` tools: `left_click`, `right_click`, `left_click_drag`, `key`, `screenshot`, `zoom`. Call `app_release` before switching from background to full-screen tools in a turn.
- The full-screen `screenshot` frame is also scaled (a 0.5-scale screenshot of the Studio Display reported a 1456x819 frame). Convert to display points before `capture-region.sh` and before clicking. Take a `zoom` of the region first to confirm the crop.
- Menus: click the menu title, then move to the submenu item so it opens, then run `capture-region.sh` from Bash while the menu is up. The menu stays open because the click sequence ends inside it. Press Escape twice afterwards.

### Shot size ruling (from `SHOTS.md`)

Stored PNG at most 1600 px wide. Full-window shots: main window 1400x900 points captured at 2x and downscaled to 1600. Dialogs and panels: their own window at 2x, unscaled unless wider than 1600. Region crops keep 2x unless wider than 1600.

### Per-shot procedure

1. Put the app in the state the row's caption describes. Read the chapter text around the marker line first so the picture matches the sentence before it.
2. Capture (`capture-window.sh` or `capture-region.sh`).
3. Read the PNG back. Every control the caption names must be in frame and legible, and a dialog's Cancel and Run must be visible when the caption calls it a dialog or sheet.
4. Write the recipe with `write-recipe.py` (one call per chapter that carries the id).
5. Restore the app state (Cancel, close extra windows, undo any toggle you flipped).
6. Append a line to the part's report under `captures/` (pixel size, crop, anything odd), then run `refresh-shots-manifest.py`, run `check-shots.mjs`, and commit the part: PNGs, recipes, `SHOTS.md`, the report. One commit per part, message in the style of the existing ones ("Capture <n> <Part> screenshots ..."). Push `main` when a part is done.

## 4. Group A: rows that need a full-screen session (33 rows)

Prepare: relaunch the app on the demo project only, one window at 1400x900 at position {360, 200}, Inspector on its Bundle tab, sidebar visible. Grant `request_access` for Lungfish Preview (already granted in the last session; ask again in a new one), plus Finder and TextEdit for the two rows that need them. Then `request_full_control`.

### A1. Menu bar menus and submenus (`capture-region.sh`)

Open the menu, hover the submenu, capture a rectangle from the menu title down to the last item with a small margin. Chapter file after each id.

- `01-foundations/file-export-menu` (06-the-lungfish-project.md and 08-provenance-and-reproducibility.md, one PNG, two recipe calls): File > Export with its submenu open.
- `08-workflows/export-provenance-submenu` (02-exporting-as-nextflow-or-snakemake.md): File > Export > Provenance open, six targets with the separator after the fourth.
- `04-alignments/tools-mapping-submenu` (01-mapping-reads.md) and `05-variants/tools-mapping-submenu` (01-calling-variants-from-amplicons.md): Tools > Mapping open with minimap2, BWA-MEM2, Bowtie2, BBMap, Viral Recon. One capture, copy the PNG to both part folders, one recipe each.
- `04-alignments/viral-recon-menu-item` (05-viral-recon.md): the same submenu, caption names Viral Recon as the fifth item. Reuse the capture.
- `06-classification/classification-submenu` (01-what-is-classification.md): Tools > Classification with Kraken2, EsViritu, TaxTriage.
- `03-reads/search-subsetting-menu` (06-subsetting-and-extraction.md): Tools > Search & Subsetting, five items.
- `03-reads/read-processing-menu` (08-read-processing.md): Tools > Read Processing, six items.
- `07-assembly/assembly-submenu` (01-when-to-assemble.md): Tools > Assembly, five assemblers.
- `09-genotyping/genotyping-submenu` (01-what-is-mhc-genotyping.md): Tools > Genotyping with the three workflows; the caption says disabled ones read "Enable in Library". Capture with the demo project open, no Williams data needed.

### A2. Pop-up pickers and popovers

- `01-foundations/primer-scheme-picker-built-in` (04-tools-and-plugin-packs.md) and `04-alignments/primer-trim-scheme-menu` (03-primer-trimming.md): select the chr20 bundle, Inspector > Analysis > Primer Trim > Primer-trim BAM... (or Tools > Trimming & Filtering > Primer Trimming...), click the Primer Scheme pop-up so its menu opens showing the eight built-in schemes under the Built-in heading, capture the region covering the dialog's popup and the open menu. Then choose a scheme, and recapture `04-alignments/primer-trim-dialog-target` (already captured without a scheme) so the Output Track Name field is pre-filled, then Cancel.
- `03-reads/remove-duplicates-preset-picker` (04-trimming-and-filtering.md): select Imports/HG002, Tools > Decontamination > Remove Duplicates..., open the Preset pop-up, capture the pane with the six choices open and Exact PCR selected, Cancel.
- `06-classification/twelve-s-export` (10-twelve-s-metabarcoding.md): needs a 12S result (group B). Once one exists, open its viewport, click Export, capture the open menu.

### A3. Context menus (right-click)

- `02-sequences/hbb-annotation-context-menu` (01-importing-and-viewing.md and 03-extracting-and-comparing.md): open HBB, right-click the HBB gene feature in the annotation lane, hover Copy so its submenu opens, capture the region.
- `04-alignments/extract-reads-region-menu` (04-extracting-reads.md): open the chr20 bundle, drag-select a stretch of the alignment track, right-click inside it, capture the menu showing Extract Reads in Selected Region... beneath the Copy items.
- `06-classification/kraken2-extract-reads` (02-running-kraken2.md): open Analyses/kraken2-SRR36291587, right-click a taxon row, capture with Extract Reads... above Copy Taxon Name and Copy Taxonomy Path.
- `07-assembly/contig-context-menu` (04-extracting-contigs.md): open Analyses/HG002-chrM, right-click the contig row, capture the menu (Extract Sequence..., BLAST Contig..., Copy FASTA, Export FASTA..., Extract to New Bundle..., separator, Run Operation...).
- `06-classification/nvd-column-menu` (09-novel-virus-detection.md): open Analyses/nvd-demo, right-click the contig outline's column header, capture the Standard Columns checklist, Reset Column Widths, Sample Metadata section. Confirm metadata columns survive closing and reopening the result, as the manifest's prerequisites note asks.
- `01-foundations/operations-panel-right-click-menu` (06-the-lungfish-project.md) and `appendices/operations-panel-failed-row` (troubleshooting chapter, see group C): right-click a row in Operations > Show Operations Panel.

### A4. Right-click routes to dialogs

- `02-sequences/iqtree-dialog` (05-building-trees.md): open Analyses/Multiple Sequence Alignments/Primate-mitochondria, click the first name in the gutter, Shift-click the last, right-click inside the alignment, Build Tree with IQ-TREE..., set Output Name to `primate-mito`, leave Model on MFP, capture the Phylogenetic Tree Operations dialog (own window or sheet), Cancel.
- `02-sequences/export-alignment-sheet` (04-aligning-sequences.md): same alignment, right-click, Export Alignment..., capture the sheet with Destination choices, gap choice, Format popup, Cancel.

### A5. Drag and drop in the Workflow Builder

Turn on Show Experimental Features (Settings > Advanced) first and off at the end.

- `08-workflows/workflow-builder-canvas` (01-the-workflow-builder.md): Tools > Workflow Builder..., New Workflow named `Mito read cleanup`, drag from the palette onto the canvas in order: FASTQ Bundle Input, Remove PCR duplicates, Adapter + quality trim, Remove short reads, Remove human reads, and connect them through to the pinned Project output anchor. Capture the Workflow Builder window. The chapter describes the chain; match it.
- `08-workflows/workflow-builder-node-inspector` (01-the-workflow-builder.md): select the Adapter + quality trim node, capture the right-hand inspector with Label, the tool it runs, and the Configure... button (crop the inspector column).
- The builder saves workflows inside the project under `Workflows/`. That folder is not part of the demo build; either delete `Workflows/` from the demo project afterwards or add a copy of the saved `.lungfishflow` bundle to `fixtures/demo-project/` and a copy step to the build script.

### A6. File and save panels

Fixture files to choose in the panels (all under `docs/user-manual/fixtures/`):

| Row | Files |
|---|---|
| `01-foundations/empty-project-window` (06-the-lungfish-project.md) | File > New Project, name `LGE Empty Demo`, location `~/Desktop/lge-docs/`, Create. Capture the fresh empty project window. Then reopen the demo project (File > Open Recent). |
| `02-sequences/import-center-annotation-track-alert` (01-importing-and-viewing.md) | Import Center > Reference Sequences > Annotation Track > Import..., choose `sarscov2-srr36291587/MN908947.3.gff3` or the hbb-gene GenBank's annotations; the alert with Reference popup, Track Name, Track ID appears. Capture it, Cancel. |
| `03-reads/import-fastq-configuration-sheet` (01-importing-fastq.md) | Import Center > Sequencing Reads > Sequencing Read Files, choose `hg002-chr20/HG002.chr20.10.0-10.5Mb_R1.fastq.gz` and `_R2`. Capture the sheet with R1 and R2 on separate lines above Platform, Pairing, Quality Binning, compression. Cancel (the demo already holds this bundle). |
| `03-reads/ont-import-configuration-sheet` and `ont-barcode-sheet-controls` (07-ont-runs.md) | ONT Run Folder card, choose `hg002-long-reads/ont-run`. Capture the sheet with Platform reading Oxford Nanopore and the recipe checkbox; tick a nanopore demultiplexing recipe so the Barcode Sheet and Demux Folder controls appear, capture those, then either Cancel or Import (Import produces `sidebar-after-ont-import`, group B). |
| `06-classification/nao-mgs-import-sheet` (05-running-nao-mgs.md) | Import Center > Classification Results > NAO-MGS Results, choose `Tests/Fixtures/naomgs/virus_hits_final.tsv.gz`. Capture the sheet with the path readout and the Validation section. Cancel or Import (group B). |
| `06-classification/czid-import-sheet` (08-importing-cz-id-results.md) | CZ-ID Results card, choose `Tests/Fixtures/czid/minimal_taxon_report.tsv`. Capture after the scan with the Preview panel and the Project Destination readout visible (the chapter documents that control as defective, keep it in frame). Cancel or Import (group B). |
| `06-classification/nvd-import-preview` (09-novel-virus-detection.md) | NVD Results card, choose `fixtures/nvd-demo/results`. Capture the Preview panel rows. Cancel (the demo already holds nvd-demo). |
| `08-workflows/export-provenance-save-panel` (02-exporting-as-nextflow-or-snakemake.md) | Select the chr20 bundle, File > Export > Provenance > the Nextflow item. Capture the save panel with its message and the folder name ending in `-provenance-nextflow`. |
| `08-workflows/export-provenance-complete-alert` | Save that export into the session scratch directory (not the project). Capture the Provenance Export Complete alert with OK and Show in Finder. |
| `08-workflows/nextflow-export-main-nf` | Open the exported `main.nf` in TextEdit (grant TextEdit) and capture the TextEdit window showing one process per recorded step. |
| `01-foundations/provenance-export-folder` (08-provenance-and-reproducibility.md) | Click Show in Finder on that alert (grant Finder), capture the Finder window listing the export folder. |
| `09-genotyping/genotype-export-save-panel` and `genotype-pivot-workbook` (04-haplotype-definitions-and-export.md) | Need a genotype result. Do not use the Williams project. Skip unless the user provides a demo genotype result, and say so in the report. |

### A7. Window states

- `01-foundations/welcome-window` (06-the-lungfish-project.md): File > Close on the project window with the app frontmost, capture the Welcome window that appears, reopen the demo project from its Recent Projects list.
- `appendices/shared-projects-read-only-banner` (shared projects chapter): with the demo project open, copy it: `cp -R "~/Desktop/lge-docs/LGE Manual Demo.lungfish" "~/Desktop/lge-docs/LGE Manual Demo Copy.lungfish"` (the copy carries the live `.lungfish/project.lock`), open the copy, capture the window with "(Read Only)" in the title and the yellow lock banner naming owner, host, process, and time. Delete the copy afterwards.

## 5. Group B: fixtures the demo project lacks (31 rows)

Extend `fixtures/demo-project/build-demo-project.sh` with a step per item, in the script's idempotent style (`done_if <output> || <command>`), then run the script against the live demo project so the new outputs appear, then capture. `$CLI` is `.build/debug/lungfish-cli` (build with `swift build --skip-update` if stale). Full CLI help is dumped under `cli-help/`; read the relevant file before writing a command.

| Item | Command sketch | Rows it unblocks |
|---|---|---|
| SRA download of SRR32909537 | `"$CLI" fetch sra download SRR32909537 --output-dir "$P/Imports"` then import the pair with `import-fastq --project "$P" --platform illumina`. Or do it in the app during the full-screen session so `sra-import-configuration-sheet` is captured live: Tools > Search Online Databases > SRA Runs, search, tick, Download Selected, capture the sheet as it opens, Import. | `03-reads/sra-import-configuration-sheet`, `03-reads/sra-bundle-in-sidebar` |
| Merge overlapping pairs | `"$CLI" fastq merge <R1> -o "$P/Analyses/<name>/merged.fastq.gz"` (see `cli-help/fastq.txt` line 315 for the exact form). The app's Tools > Read Processing > Merge Overlapping Pairs on Imports/HG002-chrM is the alternative and produces the sidebar shape the chapter shows. | `03-reads/sidebar-after-merge` |
| ONT run folder import | `"$CLI" fastq import-ont fixtures/hg002-long-reads/ont-run -o "$P"` or the app's ONT Run Folder card. The chapter expects a `barcode01` bundle at the top level. | `03-reads/sidebar-after-ont-import`, and the two ONT sheet rows above if done in the app |
| Trim run | `"$CLI" fastq trim` on Imports/HG002-chrM into `$P/Analyses/`, or Tools > Trimming & Filtering > fastp Adapter + Quality Trim in the app (its Operations row is the subject). | `03-reads/trim-operation-row` |
| Flye assembly | `"$CLI" assemble --assembler flye --read-type ont-reads --name HG002-chrM-flye -o "$P/Analyses/HG002-chrM-flye" fixtures/hg002-long-reads/HG002.chrM.ont.fastq.gz`; import the ONT reads (and the HiFi file) as bundles too so the Flye and Hifiasm sheets have a bundle to select. | `07-assembly/flye-contig-table`, `assembly-sheet-flye`, `assembly-sheet-hifiasm`, `assembly-sheet-curated-arguments` |
| Derived bundle from a contig | In the app: open Analyses/HG002-chrM, select the contig, Extract to New Bundle... (allowed on the demo project). | `07-assembly/derived-bundle-in-sidebar` |
| VCF import | `"$CLI" import vcf fixtures/sarscov2-srr36291587/lofreq.expected.vcf --output-dir "$P/Imports"` or, for the chapter's human example, a VCF for chr20 (look in `Tests/Fixtures/sarscov2` for a VCF with an index, and the chapter text for which benchmark it names). The Name Imported Variant Bundle prompt appears only when no reference bundle is open, so capture it in the app with nothing selected. | `05-variants/imported-benchmark-in-variants-tab`, `05-variants/name-imported-variant-bundle` |
| Primer trim run | Tools > Trimming & Filtering > Primer Trimming on a SARS-CoV-2 alignment. Needs a SARS-CoV-2 mapping first: `"$CLI" map --reference fixtures/sarscov2-srr36291587/MN908947.3.fasta` on the SRR36291587 pair, adopted into a reference bundle for MN908947.3 (`import fasta` the FASTA, then map with `-o` under Analyses and adopt as the chr20 step does). | `04-alignments/primer-trim-track-result`, and improves `primer-trim-dialog-target` |
| Viral Recon run | `"$CLI"` has no viral-recon subcommand listed; run it in the app (Tools > Mapping > Viral Recon... on Imports/SRR36291587, Docker Desktop running) and wait. Slow. | `04-alignments/viral-recon-inspector-outputs` |
| EsViritu | `"$CLI" esviritu detect -i <R1> -i <R2> --paired -s SRR36291587 -o "$P/Analyses/esviritu-SRR36291587"` (database is installed on this machine), then `import esviritu` if the app does not pick the folder up. | `06-classification/esviritu-result-viewport`, `esviritu-alignment-evidence` |
| EsViritu missing-database state | Cannot be captured on this machine without removing the database. Either capture on another profile or reword the caption. | `06-classification/esviritu-database-missing` |
| TaxTriage | `"$CLI" taxtriage check-prerequisites`, then `taxtriage run --input ... --output "$P/Analyses/taxtriage-SRR36291587"` for one sample and again for two samples for the batch overview. Needs Nextflow and the container runtime; slow. | `06-classification/taxtriage-result-table`, `taxtriage-batch-overview` |
| NAO-MGS | `"$CLI" nao-mgs import Tests/Fixtures/naomgs/virus_hits_final.tsv.gz ...` into the project (the manifest asks for a Taxa card reading 7). | `06-classification/nao-mgs-result-viewport`, `nao-mgs-taxon-detail` |
| CZ-ID | `"$CLI" cz-id import` with `Tests/Fixtures/czid/minimal_taxon_report.tsv`. | `06-classification/czid-result-viewport`, `czid-provenance-popover` |
| 12S | Enable 12S Amplicon Matching in the Workflow Library, build the reference from `fixtures/primate-12s` (`build_ref.py`, `regenerate.sh`), import `HG002-12S-amplicon.fastq.gz`, run the workflow in the app (Run is allowed on the demo project). | `06-classification/twelve-s-result-species-table`, `twelve-s-unresolved-clusters`, `twelve-s-export` |
| BLAST | In the app: BLAST Verify on a Kraken2 taxon (Run BLAST submits reads to NCBI, allowed with the user's consent), then capture the drawer. Same for the NVD viewport and the 12S unresolved cluster. | `06-classification/blast-results-drawer`, `nvd-blast-drawer`, `twelve-s-blast-review` |
| Linked workflow package | Link the hello-world Nextflow package the chapter names (`Workflow Library > Link Workflow...`); the package itself must be created or found first (the chapter `08-workflows/03-running-external-workflows.md` and `docs/user-manual/parameters.yaml` describe it; no package ships in the repo, so build a minimal Nextflow package with one process and link it). | `08-workflows/workflow-library-linked-package` |
| Primer scheme in the project | Import a scheme from `Tests/Fixtures/primerschemes/` through the Import Center's Primer Scheme card, then select it. | `appendices/primer-scheme-inspector` |
| NCBI download into the project | Tools > Search Online Databases, NC_012920.1, Download Selected (allowed on the demo project). | `02-sequences/ncbi-bundle-in-sidebar` |
| Pathoplexus | Accept the access and benefit sharing notice once (ask the user first, it is a terms acceptance), capture the pane. | `02-sequences/pathoplexus-pane` |

After extending the build script, rebuild the demo project from scratch once (`rm -rf` the demo project, then run the script) to prove the script reproduces everything, and record the run time in the script's header comment.

## 6. Group C: running or failed operations (4 rows)

- `01-foundations/operations-panel-row` (06-the-lungfish-project.md): start a fast operation on the demo project (Tools > QC & Reporting > Refresh QC Summary on Imports/HG002-chrM), open Operations > Show Operations Panel at once, capture the running row expanded with its progress and command line.
- `appendices/operations-panel-failed-row`: produce a failure deliberately on the demo project, for example Viral Recon with Docker Desktop quit, or Kraken2 with a database picked that is not installed. Expand the failed row, right-click, capture with Copy Failure Report highlighted.
- `06-human-germline-variants/operations-panel-gatk-run` (01-haplotype-caller.md): the GATK Core pack shows "Needs reinstall" in the Plugin Manager; reinstall it (with the user's consent, ~600 MB), run GATK HaplotypeCaller on the chr20 track, capture the finished Operations row expanded.
- `09-genotyping/genotyping-operations-row` (02-running-genotyping.md): needs a genotyping batch running. Do not use the Williams project. Only possible with a demo genotyping fixture; otherwise leave open and say so.

## 7. Group D: product fixes before the shot (2 rows)

- `01-foundations/provenance-lineage-step-expanded` (08-provenance-and-reproducibility.md): the Inspector's Provenance tab shows the bundle's own import provenance whenever a bundle carries more than one variant track; there is no per-track picker. Add one (a chip already suggests it, see `captures/01-foundations.md` for the source files: `ProvenanceInspectorViewModel.swift`, `ProvenanceRecorder.swift`, `AnnotationTableDrawerView.swift`), then capture the HG002 bcftools track's eleven-step lineage with one step expanded.
- `02-sequences/translation-tool-hbb-cds` (01-importing-and-viewing.md): `MainWindowController.updateToolbarForContentMode` hides the Translate toolbar item unless the content mode is `.genomics` or `.empty`, and a reference bundle opened from the sidebar uses another mode. Either show the item for that mode or rewrite the chapter's paragraph to the real route (Sequence > Translate... runs an operation, not the overlay). Then capture the overlay tool with Mode, Genetic Code, Color Scheme and Apply.
- Related product defects found while capturing, each worth a fix before its shot is final: the MAFFT scope line reads "Aligning all 0 sequences." from the sidebar route (`MSASequenceScopePicker.summaryText` fed by `mafftAllSequenceCount` in `FASTQOperationToolPanes.swift`, recapture `02-sequences/mafft-dialog` afterwards); the Inspector Summary tab keeps the previous selection's content for a Kraken2 result; the AI Assistant says no bundle is loaded when one is (`appendices/ai-assistant-panel`); pileup mismatches draw as blocks rather than letters (`04-alignments/pileup-zoom` and the chapter text).

## 8. Chapter and caption edits the pass surfaced

Apply these after the shots, one commit per chapter, lint each file. The full list with reasons is in `captures/README.md` under Findings.

- `02-sequences/05-building-trees.md`: `tree-viewport-primate-mito` caption says the Nodes drawer lists all eight nodes; it shows two or three rows.
- `03-reads/05-decontamination.md`: `human-scrub-dialog` caption describes Replace... and Clear buttons; on a machine without the managed human database it shows Choose... Either install the database and recapture or describe both states.
- `03-reads/08-read-processing.md`: Orient Reads pane's hint text is a product bug, not a chapter error.
- `04-alignments/02-reading-an-alignment.md`: mismatches described as coloured letters.
- `05-variants/02-reading-the-variant-browser.md`: `variants-inspector-row` caption mentions a filter line the Inspector lacks; `variants-preset-chips` caption says four groups but only three fit at 1400 points; `variants-search-builder` caption wants one Call Quality and one INFO rule (recapture once the category popup can be opened in the full-screen session).
- `06-classification/04-running-taxtriage.md`: Prerequisites row reads "Nextflow" and "Apple Containerization: Available", not "Nextflow and Docker".
- `06-classification/05-running-nao-mgs.md`: the import card carries no NM badge.
- `06-classification/02-running-kraken2.md`: the demo run has no Bracken sidecar, so either add bracken to the build script or drop the Bracken column from the caption.
- `07-assembly/01-when-to-assemble.md` and `02-running-spades.md`: no summary strip along the top of the assembly viewport (the figures live in the Inspector's Assembly Context block), and the Analyses row is a leaf, not a folder with a nested bundle.
- `08-workflows/03-running-external-workflows.md`: the group after Advanced Options is labelled Output, not Directory (from the genotyping report).
- `09-genotyping/03-reading-the-genotype-comparison.md`: the Supported Alleles list is the Inspector's Selection panel with Read support and Allele pairs.

## 9. Finishing

1. `refresh-shots-manifest.py`, `check-shots.mjs` clean except rows the user has agreed to leave open, `captures/README.md` counts updated.
2. Build the site: `scratchpad`-style build without the with-pdf plugin (`libpango` is missing locally; Read the Docs sets `ENABLE_PDF_EXPORT=1` itself) and open three chapters in a browser to confirm the images and captions render.
3. Update `RESULTS.md` with the final counts and push `main`. Confirm the Read the Docs build.
4. Two open questions for the user remain from the campaign: the "not ready for use" banner at the top of every page, and the two illustration briefs under `assets/illustrations-imagegen/`.
