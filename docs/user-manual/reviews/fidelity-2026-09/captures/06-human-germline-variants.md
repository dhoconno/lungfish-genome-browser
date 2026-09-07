# Capture session: 06-human-germline-variants (+ one 06-classification row)

## Captured

- `settings-advanced-experimental` (04-reference-packs.md) — 1600x1256, window crop. Settings > Advanced, Show Experimental Features toggle OFF with its warning text visible, matching the chapter's "before you turn it on" state. Toggle was then switched on for the next two shots.

- `plugin-manager-gatk-packs` (04-reference-packs.md) — 1600x1368, window crop. Packs tab scrolled to the Variant Calling category, GATK Core and Variant Phasing cards both in frame. **Disagreement with chapter text**: the chapter describes installing GATK Core as if from a clean state, but on this machine GATK Core shows "0 of 1 ready", the GATK4 row reads "Needs reinstall", and the card's button reads **Reinstall** rather than **Install**. This is a pre-existing environment state, not something this session changed (no Install/Reinstall button was clicked).

- `plugin-manager-wastewater-pack` (06-classification/07-running-freyja.md) — 1600x1368, window crop. Packs tab scrolled to the Wastewater Surveillance card, Install All button, and all five tools (Freyja, iVar, Pangolin, Nextclade, minimap2) in frame, showing "3 of 5 ready" (Pangolin and Nextclade need install). Matches the chapter's description; Install All was not clicked.

- `call-variants-dialog-gatk` (01-haplotype-caller.md) — 1600x1134, region crop (208,102,982,696 pt). The Call Variants dialog opened with the chr20 bundle selected; LoFreq is selected by default (not GATK). **GATK HaplotypeCaller's card is disabled** and shows the "Requires GATK4" badge — clicking it produced no change in the right-hand pane, i.e. the click was refused, consistent with the Plugin Manager reporting GATK4 as "Needs reinstall" rather than ready. Captured the dialog in this disabled state per the task's fallback instruction, then clicked Cancel. Note the verified crop region in the task prompt (`242 102 982 696`) cut off the left edge of the tool sidebar on this window; the correct region for this window was `208 102 982 696` (measured from the unscaled 1372x882 screenshot frame, scaled to points).

## Skipped

- `operations-panel-gatk-run` — requires a finished GATK HaplotypeCaller run, which this session could not produce (GATK4 needs reinstall and Run was never clicked, per the "never click Run/Install" restriction). No PNG or recipe written.

## check-shots.mjs output (filtered)

```
missing png 06-human-germline-variants/operations-panel-gatk-run
missing recipe 06-human-germline-variants/operations-panel-gatk-run
```

## End state

App left on the demo project main window (chr20 10.0-10.5Mb bundle), no sheets or extra windows open, Show Experimental Features toggled back off.
