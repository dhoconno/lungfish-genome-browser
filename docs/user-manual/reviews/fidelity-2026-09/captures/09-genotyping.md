# Capture session: 09-genotyping

Worklist: `shots/09-genotyping.md` (13 rows). Fixture: Williams project
`32566_MS267_Williams1`, window CGWindowID **60494** (confirmed by title bar
— this is the OPPOSITE assignment from the task brief, which guessed 60496
for Williams; 60496 is actually "LGE Manual Demo"). All captures below used
60494 at 1400x900 (Retina 2x -> 2800x1800 native).

## Captured (9)

- **genotype-matrix-overview** — 1600x1028 (window crop). The Genotype
  Matrix view of `amplicon-genotyping_3` (the Williams 30-sample, 2109-call
  MiSeq run under `Analyses/Amplicon genotyping results/`), allele-target
  rows down the left named by reference record, one column per sample
  across the top.
- **genotype-matrix-reading** — 1600x1028 (window crop). Same view,
  captured a second time for chapter 03 per the shared-shot rule (one PNG
  per part directory, one recipe per chapter file).
- **genotype-call-evidence** — region crop, 1600x1119 before final size
  (region 355,165,1045,735 pt). Selected the `WD10_S157_L001` sample column
  (its checkbox, not the header text — the header text button only
  scrolled the table) via the Selected Item Inspector, showing Retained
  Unique Reads 713, Passed Alignments 713, Call-support check "Low
  support", and the Read support / Allele list (the chapter calls this the
  "Supported Alleles" list; the app labels each entry "Read support" /
  "Allele" rather than under a "Supported Alleles" heading — worth a
  wording check).
- **genotype-inspector-display** — region crop 690x1330 (region
  1055,195,345,665 pt). Inspector View tab, Genotype Display section:
  Alleles/Samples filters, Min reads, Min percent, Percent Basis
  (Viewed Locus / Sample Retained), Cell Color (Support/Highlights/None).
  No filter row on the matrix itself, confirmed.
- **genotype-inspector-export** — region crop 690x200 (region
  1055,800,345,100 pt). The Export block at the foot of Genotype Display:
  "Filtered Pivot..." button and its full caption ("Writes a copy of the
  result workbook whose pivot sheet has the Min Reads and Min Percent
  filters above applied. Every other sheet is unchanged. The copy is a
  one-way export: edits made to it in Excel do not flow back into this
  result."). Filtered Pivot... was NOT clicked.
- **genotyping-run-dialog** — 1600x1159 (window crop). Workflow Operations
  dialog opened from Tools > Genotyping > miSeq amplicon MHC genotyping...
  with `WD1_S148_L001` selected: Reference group (Project Reference =
  `26128_ipd-mhc-mamu-2021-07-09.lungfishref`), FASTQ Bundles (1 selected),
  Report group (Report Name `amplicon-genotyping`), Run Parameters
  (Threads 14, Min Reads 1) above the "Illumina sample bundles" caption.
- **genotyping-analysis-mode** — region crop 920x180 (region
  277,458,460,90 pt, raw dialog capture at native 2x). Haplotyping group,
  Analysis Mode segmented picker on Genotype only, AI preset segment
  visibly greyed. Caption discrepancy: the caption under the picker reads
  "Maps reads and reports genotypes without haplotyping" (describing the
  selected Genotype-only mode), not a caption about configured API access
  for the greyed AI preset segment as the chapter text implies.
- **genotyping-advanced-options** — 1600x1159 (window crop). Advanced
  Options disclosure expanded (chevron click on the actual sub-row, not
  the "Advanced Settings" section header which has no clickable chevron)
  showing minimap2 arguments field and Keep Intermediates checkbox, above
  a group titled **"Output"** in the running app (the chapter text calls
  this group "Directory" — naming discrepancy worth a doc check).
- **genotyping-full-length-dialog** — 1600x1159 (window crop). Enabled
  "Full-length ONT MHC genotyping" in Tools > Workflow Library... first,
  then opened via Tools > Genotyping > Full-length ONT MHC genotyping...
  with `WD17_S164_L001` selected. One scroll position fit Length Filter
  (Min Length 2,000 / Max Length 4,000), Call Thresholds (Locus % 1), and
  the expanded Advanced Options (Keep Intermediates, Orient Reference,
  Forward Primers, Reverse Primers, all "None") in a single frame.
  Disabled the workflow again in the Workflow Library afterward, restoring
  the original state.

## Skipped (4, as instructed)

- **genotyping-submenu** — reason: open menu, full-screen pass.
- **genotyping-operations-row** — reason: needs a running batch.
- **genotype-export-save-panel** — reason: needs a save panel.
- **genotype-pivot-workbook** — reason: needs a spreadsheet application.

## Incident: accidental genotyping run triggered

While trying to expand the Advanced Options disclosure in the miSeq
Workflow Operations dialog, a background `app_key return` sent to the
window (intended as a fallback trigger for the disclosure) was instead
delivered to the dialog's default **Run** button and the run actually
executed on the single selected sample `WD1_S148_L001`. This produced a
new, real result bundle `amplicon-genotyping_4.lungfishgenotype` under
`Analyses/Amplicon genotyping results/` in the Williams project (Samples 1,
Calls 104, Total Reads 158,160, Retained Reads 36,042, created
2026-09-07T21:35:56Z). This violates the instruction never to click
Run/trigger anything that changes project data. It was not intentional —
the window had unexpectedly gone off-Space and I mis-diagnosed a stale
focus state — and once noticed, no further Return keypresses were used
anywhere near a Workflow Operations dialog for the rest of the session
(Cancel was always clicked explicitly by coordinate thereafter). Per the
no-destructive-action rule the new bundle was left in place rather than
deleted. A second, similar-looking log line later in the session
("AXPress on AXButton 'Run'" while restoring the sidebar selection to
`amplicon-genotyping_3`) was checked against the filesystem and did **not**
correspond to a second real run — no new `amplicon-genotyping_5` folder
was created, and the visible matrix state after that action was the
correct, unrun 30-sample `amplicon-genotyping_3` view; that log line
appears to be a stale/misattributed accessibility report rather than an
actual second Run.

**The user should be told about `amplicon-genotyping_4.lungfishgenotype`
and asked whether to keep or remove it**; this agent did not delete it.

## Other things noticed that disagree with the chapter text

- The Workflow Operations dialog's disclosure section is visually split
  into a static bold header **"Advanced Settings"** (not itself a
  disclosure — clicking it does nothing) and a separate, actually
  clickable sub-row **"Advanced Options"** with its own chevron just below
  it. The chapter text (`02-running-genotyping.md`) refers to a single
  "Advanced Options disclosure" — accurate for the clickable control, but
  a reader following the visible bold "Advanced Options" heading text
  alone could easily click the wrong (inert) row first.
- The group that follows Advanced Options in both genotyping dialogs is
  labeled **"Output"** in the running Preview build, not **"Directory"**
  as the chapter text says.
- `genotype-call-evidence`: the app's Supported-Alleles-equivalent list in
  the Inspector's Selection panel is organized as repeated "Read support" /
  "Allele" field pairs, not under a heading literally reading "Supported
  Alleles". The bottom-left in-canvas detail pane (which the chapter's
  screenshot marker most likely refers to) does carry the sample header
  metrics (Selected Sample, Retained Unique Reads, Passed Alignments,
  Call-support check) but its own allele list is not visible without
  scrolling past a "Haplotype Assignments" block that sits between the
  metrics and any allele list in that pane — the crop used here instead
  combines the bottom-left metrics with the right-hand Inspector's
  Read support/Allele list, which together supply everything the caption
  asks for.

## check-shots output (09-genotyping only)

```
missing png 09-genotyping/genotyping-submenu
missing recipe 09-genotyping/genotyping-submenu
missing png 09-genotyping/genotyping-operations-row
missing recipe 09-genotyping/genotyping-operations-row
missing png 09-genotyping/genotype-export-save-panel
missing recipe 09-genotyping/genotype-export-save-panel
missing png 09-genotyping/genotype-pivot-workbook
missing recipe 09-genotyping/genotype-pivot-workbook
```

- 2026-09-07 completion pass `genotyping-submenu` captured with authorized System Events menu control. Crop dimensions are in the recipe. PNG read back and every named entry verified.

- `genotyping-operations-row` captured at 1600 × 760 pixels in Preview build 4673. Actual two-sample simulated MHC run with annotated reference, Genotype only and Keep Intermediates completed in 2 seconds. Caption now describes the completed row rather than claiming a running-stage screenshot. Initial run against unannotated reference failed during workbook writing and remains preserved. Corrected reference route is independently validated by the fixture builder.

- `genotype-export-save-panel` captured at 1350 × 364 pixels, compact panel region 822,577,675,182. Explicit teaching filename SIMULATED-MHC-filtered-pivot.xlsx avoids a long clipped prefix. Export wrote the workbook, native provenance sidecar, and view-projection JSON to Desktop/lge-docs.
- `genotype-pivot-workbook` captured at 1580 × 990 pixels in Numbers at 125% with crop 15,60,790,495. Actual unmodified exported workbook, three public macaque targets and two simulated samples. Total 376, per-sample 204 and 172, six expected counts visible. All haplotype rows remain blank. No data or formatting edits in Numbers.
