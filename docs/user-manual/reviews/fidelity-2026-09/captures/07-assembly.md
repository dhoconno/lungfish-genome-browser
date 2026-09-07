# Capture session: 07-assembly (2026-09-07)

Fixture: demo project (`~/Desktop/lge-docs/LGE Manual Demo.lungfish`), main window `Lungfish Preview`, window id 60042, 1400x900. Reads used: `Imports/HG002-chrM` (Illumina paired). Assembly used: `Analyses/HG002-chrM`, a finished SPAdes run (contigs.fasta + assembly-result.json; no `.lungfishref` bundle file present).

## Captured (7)

- **assembly-wizard-spades** — 07-assembly/02-running-spades.md. Region crop of the whole FASTQ/FASTA Operations sheet opened from Tools > Assembly > SPAdes... with Imports/HG002-chrM selected: Inputs (Dataset/Read Layout/Detected), Assembler/Read Type at top of Primary Settings, Isolate profile, footer reading "Ready to configure output." with Cancel/Run. 1120x1128ish (region 206,100,984,694 pts). Matches caption.
- **assembly-sheet-assembler-picker** — 07-assembly/01-when-to-assemble.md. Region crop of Primary Settings: segmented Assembler picker (SPAdes/MEGAHIT/SKESA) above the locked Read Type row reading "Illumina short reads" / "Locked from FASTQ header detection." Matches caption exactly.
- **assembly-advanced-settings** — 07-assembly/02-running-spades.md. Region crop of Advanced Settings with Curated extra arguments expanded: Careful mode and Skip error correction checkboxes above the Extra arguments field. Matches caption. Note: the Extra arguments field was NOT empty — it already held `--meta --tmp-dir '/Volumes/Fast Scratch'` in this demo project's stored sheet state, though the chapter says the field "is empty by default." Left as found (never typed into the field).
- **assembly-bundle-in-analyses** — 07-assembly/01-when-to-assemble.md. Full window, Analyses/HG002-chrM row selected in the sidebar with the assembly viewport open. **Discrepancy noted below**: there is no nested `.lungfishref` bundle to expand into; the sidebar row is a leaf.
- **assembly-viewport** — 07-assembly/02-running-spades.md. Full window, same state. assembly-result.json confirms contigCount 1, totalLengthBP 16697, n50 16697 — matches the chapter's quoted figures exactly. **Discrepancy noted below** about where these figures are actually shown.
- **contig-detail-pane** — 07-assembly/02-running-spades.md. Region crop of the detail pane with the sole contig row selected: header `NODE_1_length_16697_cov_121.957333`, 16697 bp, 44.4%, #1, 100.00% of assembly, and sequence. Matches caption.
- **create-bundle-action-bar** — 07-assembly/04-extracting-contigs.md. Region crop of the action bar with the (only, hence longest) contig selected: "1 contig selected", BLAST Contig / Copy FASTA / Export FASTA / Create Bundle all enabled. **Substitution**: the caption names the MEGAHIT run; the demo project has no MEGAHIT run, so this uses the SPAdes run instead, per instructions, and the recipe/state note says so.

## Skipped (7)

- **assembly-sheet-flye** — no nanopore or HiFi bundle in the demo project.
- **assembly-sheet-hifiasm** — no nanopore or HiFi bundle in the demo project.
- **flye-contig-table** — no nanopore or HiFi bundle in the demo project.
- **assembly-sheet-curated-arguments** — no nanopore or HiFi bundle in the demo project.
- **derived-bundle-in-sidebar** — needs an extraction run.
- **assembly-submenu** — needs the full-screen pass.
- **contig-context-menu** — needs the full-screen pass.

## Discrepancies between the app and the chapter text

1. **No top "summary strip."** `02-running-spades.md` (and `01-when-to-assemble.md`) describe the assembly viewport as having "a summary strip along the top" carrying assembler, read type, contig count, total bp, N50, L50, longest contig, and global GC, plus tool version and wall time. In the actual app, the strip along the top of the viewport shows **only the wall time** (e.g. "25.6s"). All of the other figures — Assembler, Read Type, Version, Wall Time (again), Contigs, Total Assembled bp, N50, L50, Longest Contig, Global GC — appear instead in the right-hand **Inspector's "Assembly Context" section**, not across the top of the viewport. The figures themselves are correct (1 contig, 16697 bp, N50 16697, L50 1, 44.4% GC, SPAdes 4.3.0, wall time 25.6s — all matching the chapter's numbers to the exact base), only their on-screen location differs from the description.
2. **Sidebar Analyses row is a leaf, not an expandable folder holding a nested `.lungfishref` bundle.** `01-when-to-assemble.md` describes "An assembly run folder under the project's Analyses folder in the sidebar, with the .lungfishref bundle inside it selected." In the demo project, `Analyses/HG002-chrM` is a single non-expandable sidebar row (no disclosure triangle) that opens the assembly viewport directly; on disk the run folder holds `contigs.fasta` / `assembly-result.json` etc. but no `.lungfishref` file. `assembly-bundle-in-analyses` was captured against this actual single-row state rather than an expand-then-select-bundle interaction, since the latter is not available with this project's data.
3. **Extra arguments field pre-filled.** For `assembly-advanced-settings`, the SPAdes sheet's Extra arguments field already contained `--meta --tmp-dir '/Volumes/Fast Scratch'` rather than being empty, contradicting the chapter's "It is empty by default." This may be leftover demo-build state rather than an app defect; flagging for the review to confirm which.

## check-shots output (07-assembly only)

```
missing png 07-assembly/assembly-submenu
missing recipe 07-assembly/assembly-submenu
missing png 07-assembly/assembly-sheet-flye
missing recipe 07-assembly/assembly-sheet-flye
missing png 07-assembly/assembly-sheet-hifiasm
missing recipe 07-assembly/assembly-sheet-hifiasm
missing png 07-assembly/flye-contig-table
missing recipe 07-assembly/flye-contig-table
missing png 07-assembly/assembly-sheet-curated-arguments
missing recipe 07-assembly/assembly-sheet-curated-arguments
missing png 07-assembly/contig-context-menu
missing recipe 07-assembly/contig-context-menu
missing png 07-assembly/derived-bundle-in-sidebar
missing recipe 07-assembly/derived-bundle-in-sidebar
```

App left on the demo project main window, 1400x900, no sheets or extra windows open.
