# Capture session: 05-variants (2026-09-07)

12 of 17 shots captured, 3 skipped per instruction, 2 failed to reach the exact composition the caption describes but were captured in the best achievable state (noted below, not counted as failed).

## Captured

- `call-variants-dialog-bcftools` — 1600x1134, region crop `242 102 982 696`. bcftools selected in the tool sidebar, Overview/Thresholds/bcftools Settings all visible, Cancel/Run in frame.
- `call-variants-dialog-ivar` — 1600x1134, same crop. iVar selected, primer-trim checkbox ticked by hand (see discrepancy below), iVar Options section showing.
- `variants-tab-two-callers` — 1600x338, region crop `0 590 1468 310`. Both bcftools and LoFreq tracks loaded (1,918 variants total), Presets chip counts confirm both tracks present. Source column values are truncated at this window width.
- `variants-tab-twelve-columns` — 1600x981, full window. Both tracks loaded; only ID, Chrom, Position, Type, Ref, Alt columns could be brought into frame (see discrepancy below).
- `variants-inspector-row` — 676x780, region crop `1130 510 338 390`. One variant row selected, Inspector shows ID/Type/Position/Alleles/Quality/Genotype Summary/INFO Fields.
- `variants-preset-chips` — 1600x127, region crop `0 660 1130 90`. Biological Effect, Quality/QC, and Population/Frequency groups visible; Sample/Genotype group off-frame (see discrepancy below).
- `variants-search-builder` — 1400x760, region crop `385 266 700 380`. Two rules and Match All shown; both rules ended up categorized as Call Quality rather than one Call Quality + one INFO Field (see discrepancy below).
- `call-variants-dialog-medaka` — 1600x1134, same crop as bcftools. Medaka selected, Medaka Settings section with empty Medaka Model field and placeholder text, Run disabled.
- `medaka-model-field` — 1600x1134, same crop. Model `r1041_e82_400bps_hac_v5.0.0` typed in, Readiness line reads it back, Run enabled.
- `analysis-consensus-tab` — 616x1320, region crop `1160 40 308 660`. Inspector Analysis > Consensus tab with all described controls and Extract Consensus... beneath the divider.
- `consensus-masking-sliders` — 756x1180, region crop `1090 165 378 590`. Hide high-gap sites on, Gap threshold and Masking minimum depth sliders revealed between the depth and MAPQ sliders.
- `consensus-destination-dialog` — 850x690, region crop `520 270 425 345`. Extract Sequence dialog, Save as Bundle selected by default, Name field prefilled, Cancel/Create Bundle in frame.
- `import-center-vcf-card` — 1600x1064, full Import Center window. Variants tab, VCF Variants card, Import... button.

## Skipped (per instruction)

- `tools-mapping-submenu` — full-screen menu-open pass, out of scope for background-only session.
- `imported-benchmark-in-variants-tab` — needs a VCF import (data-changing action, prerequisite not built this session).
- `name-imported-variant-bundle` — needs a VCF import with no reference bundle open (same reason).

## Notable discrepancies / tool limitations found in this session

1. **`variants-tab-twelve-columns` / `variants-source-column`**: the Variants table's `Quality`, `Filter`, `Samples`, `Source`, `Consequence`, and `AA Change` columns could not be brought into the visible frame. Every background-automation path tried (dragging the header body, dragging the bottom horizontal scrollbar, dragging inside the Configure Columns reorder popover, "Size columns to fit", collapsing the sidebar/Inspector for width) either had no effect or was refused as a foreground-only interaction. The table appears to reserve a large blank strip between `Ref` and `Alt`, with `Alt` anchored at the far right regardless of window width — this may be worth a manual look by someone with full mouse control, since it is unclear whether this is a genuine rendering/layout issue in the app or simply a side effect of a very wide table with a stretched `Ref` column. Both shot ids currently point at the same PNG (ID through Alt visible) as the closest achievable state.
2. **`variants-preset-chips`**: the chip strip's `Sample / Genotype` group (`Het Only`, `Bookmarked`) sits past the right edge of the window even with the sidebar and Inspector collapsed for width. Captured the `Biological Effect`, `Quality / QC`, and `Population / Frequency` groups (3 of 4).
3. **`variants-search-builder`**: the rule category `AXPopUpButton` refuses to open under background automation (the harness explicitly blocks it, since opening it would foreground the app). Used the built-in "Quality Review" preset instead of hand-building two rules, which gives `Call Quality/Quality < 30` and `Call Quality/DP >= 10` — both tagged Call Quality rather than one Call Quality + one INFO Field as the caption asks. `DP` is listed under both categories in the chapter's own field table, so this is a close but not exact match.
4. **`call-variants-dialog-ivar`**: the demo project's HG002 minimap2 track is shotgun, not primer-trimmed, so the primer-trim checkbox opens unticked and Run disabled ("Confirm the BAM was primer-trimmed before running iVar."), matching the chapter's own description of that state. Ticked the checkbox by hand for the shot rather than using a genuinely primer-trimmed track (none exists in this project), so the checkbox in the PNG is a normal enabled checkbox rather than the greyed, auto-derived one the chapter describes for a track LGE actually primer-trimmed.
5. **`variants-inspector-row`**: the Inspector's Variant Detail section shows ID, Type, Position, Alleles, Quality, Genotype Summary, and INFO Fields, but no separate `Filter` line — the chapter caption expects "quality and filter" broken out. Worth a second look at whether Filter is meant to appear elsewhere in this same panel.
6. **`call-variants-dialog-medaka` / `medaka-model-field`**: captured using the HG002 minimap2 (Illumina, shotgun) alignment track, since the demo project has no nanopore alignment track. The Call Variants dialog and its fields render identically regardless of the underlying track's platform, so this does not affect what the shot shows, but it means the caller's own dialog was not exercised against real nanopore data in this pass.

## check-shots output for 05-variants

```
missing png 05-variants/tools-mapping-submenu
missing recipe 05-variants/tools-mapping-submenu
missing png 05-variants/imported-benchmark-in-variants-tab
missing recipe 05-variants/imported-benchmark-in-variants-tab
missing png 05-variants/name-imported-variant-bundle
missing recipe 05-variants/name-imported-variant-bundle
```

## Fable review (2026-09-07)

- The Variants table's column widths had been disturbed by header drags during the session (widths are runtime state, only visibility and order persist). After relaunching the app the default layout returned with ID through Source visible at 1400 points, so `variants-tab-twelve-columns`, `variants-tab-two-callers`, and `variants-source-column` were recaptured; the last one at chr20_10.0-10.5Mb:250500-250560 in Region scope, showing the bcftools and LoFreq rows for 250,527.
- `analysis-consensus-tab` recaptured with the whole Inspector column (the first crop cut the labels).
- `variants-preset-chips` (fourth group off-frame), `variants-search-builder` (INFO field rule needs the category popup), and the iVar and Medaka rows (no primer-trimmed or nanopore track) are noted for the full-screen pass or a caption change.

- 2026-09-07 completion pass `tools-mapping-submenu` captured via authorized System Events menu control. Display crop (380, 0, 460, 490), 920×980px. PNG read back and all named menu entries checked.
