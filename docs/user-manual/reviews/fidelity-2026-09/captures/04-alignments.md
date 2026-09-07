# Capture session: 04-alignments

Session against the running Lungfish Preview app (window 57698, 1468x900), demo project
`~/Desktop/lge-docs/LGE Manual Demo.lungfish` already open.

## Captured (14)

- **bam-viewport-overview** — 1600x981, crop `window` — the chr20_10.0-10.5Mb reference bundle
  selected in the sidebar at its whole-region (1-500,001 bp) zoom. Coverage curve above the
  HG002 minimap2 track's compact overview row; Depth key, percent-covered figure, max/mean
  labels all present at the strip edges as the caption names.
- **pileup-zoom** — 1600x1002, crop region `252 90 830 520` — Focus mode on the chr20 alignment,
  zoomed to chr20_10.0-10.5Mb:2,055-2,095, centered on position 2,078 where the reads disagree
  with the reference. Reference letters, coverage curve, and the read pileup with the alternate
  column highlighted on both strand colors (pale blue forward, pale pink reverse) are all in
  frame. See the discrepancy note below about letter vs. block rendering.
- **view-settings-alignment-tab** — 650x1600, crop region `1143 55 325 800` — Inspector View tab,
  Alignment sub-tab: Visible Alignment picker, Show reads, Minimum alignment confidence,
  Coverage scale, and the three Read Inclusion toggles all visible.
- **view-settings-reads-tab** — 650x1600, crop region `1143 55 325 800` — Inspector View tab,
  Reads sub-tab: Maximum rows / Limit visible rows, Read display budget slider, and the base and
  strand toggles beneath them.
- **alignment-inspector-stats** — 656x800, crop region `1140 500 328 400` — Inspector Bundle tab,
  Alignment Summary section (Total Mapped 91.0K, Total Unmapped 213, Mapped % 99.8%,
  Chromosomes 1, Est. Coverage 27.3x) above the collapsed Flag Statistics disclosure.
- **inspector-alignment-stats** — 656x800, crop region `1140 470 328 400` — same Alignment
  Summary figures with Flag Statistics expanded (total 91.2K, primary 91.1K, secondary 0,
  supplementary 55, duplicates 0, mapped 91.0K, …).
- **analysis-filtering-tab** — 760x1400, crop region `1090 55 380 700` — Inspector Analysis tab,
  Filtering sub-tab: "Mark Duplicates in Bundle Tracks" above the divider, Create Filtered
  Alignment panel (Starting Alignment, both keep toggles, MAPQ 0 stepper, Duplicate handling,
  Name field) below it.
- **filter-panel-controls** — 760x660, crop region `1090 425 380 330` — same panel with the
  Minimum alignment confidence stepper raised to MAPQ 20 (20 clicks on the up-arrow); Name for
  New Alignment field shows the auto-filled "MAPQ >= 20".
- **analysis-export-tab** — 760x700, crop region `1090 55 380 350` — Inspector Analysis tab,
  Export sub-tab: "Create Deduplicated Bundle" button with its two explanatory lines above it.
- **mapping-wizard-overview** — 1600x1134, crop region `242 102 982 696` — Map Reads (minimap2)
  wizard opened from Tools > Mapping > minimap2... with HG002 selected; chr20_10.0-10.5Mb
  reference and Short-read preset already chosen, Input Compatibility reporting
  "Ready: minimap2 is compatible with Illumina short reads.", Read Group and Advanced Settings
  collapsed, Cancel/Run both visible.
- **mapping-wizard-advanced** — 1600x1134, crop region `242 102 982 696` — same wizard with
  Advanced Settings expanded: Threads 14, Secondary alignments (off), Supplementary (on), Min
  mapping quality 0, and the Extra arguments label (its input field is just below the visible
  frame, but the label itself is in shot).
- **primer-trim-dialog-target** — 1078x958, crop region `465 210 539 479` — Primer Trim dialog's
  Target section opened from the Inspector's Analysis > Primer Trim tab on the chr20_10.0-10.5Mb
  bundle (no SARS-CoV-2 alignment track existed in this project — see discrepancy note). Shows
  the Alignment Track menu (HG002 minimap2), the Output Track Name field, and the "reads without
  matching primers are retained" note. The field is NOT pre-filled because selecting a primer
  scheme (a native popup menu) is not reachable from the background automation tools used this
  session; Readiness correctly reads "Select a primer scheme."
- **viral-recon-wizard-overview** — 1600x1134, crop region `242 102 982 696` — Viral Recon sheet
  opened from Tools > Mapping > Viral Recon... with SRR36291587 selected. Shows the header and
  Docker Desktop note, Inputs (Platform: Illumina), Primer Scheme (ARTIC SARS-CoV-2 V3), Minimum
  mapped reads (1,000), collapsed Advanced, and Readiness reading "Ready to run Viral Recon."
  (Docker Desktop is running in this environment).
- **viral-recon-advanced-open** — 1600x1134, crop region `242 102 982 696` — same sheet with
  Advanced expanded: annotation note, Choose GFF... button, Extra parameters field pre-filled
  with placeholder-style example text, and the schema-checking caption beneath it.

## Skipped (6, per task instructions)

- **tools-mapping-submenu** — needs an open menu captured on screen; open menus require
  full-screen control, reserved for a later pass.
- **extract-reads-region-menu** — same reason: a right-click context menu needs full-screen
  control (confirmed live: `app_click` with `button: right` is refused in background mode with
  the message "Opening a context (right-click) menu would bring the app to the front").
- **primer-trim-scheme-menu** — same reason: the Primer Scheme popup is a native pop-up menu,
  which the background `app_click` tool explicitly refuses to open ("this is a pop-up / pull-down
  menu control ... opening it would bring the app to the front").
- **primer-trim-track-result** — needs a finished primer-trim run; no SARS-CoV-2 alignment track
  exists in the demo project to trim, and Run was not clicked per the task's guardrails.
- **viral-recon-menu-item** — same open-submenu limitation as tools-mapping-submenu.
- **viral-recon-inspector-outputs** — needs a finished Viral Recon run; none was pre-run in this
  project ahead of the session.

## Failed

None. Every attempted shot produced a usable PNG on the first or second try.

## Discrepancies between the app and the chapter text

1. **Pileup mismatch rendering is a solid color block, not a colored letter.** Chapter
   `02-reading-an-alignment.md` (and the `pileup-zoom` caption) says a read base that disagrees
   with the reference "is drawn as a coloured letter." In this Preview build, at every zoom level
   tested — including well past the stated 0.25 bp/px letter threshold, down to roughly one base
   spanning ~74 screen points — the mismatched column renders as a solid green rectangle with no
   visible letter glyph inside it (confirmed by capturing and reading back 120x120 and 160x120
   pixel crops of the mismatch column). Toggling "Use compact row height" off and back on made no
   difference. This may be a rendering regression or a change since the chapter was written;
   worth a follow-up before trusting the manual's exact wording here.
2. **`primer-trim-dialog-target` fixture gap.** The task itself flagged this: the chapter's
   fixture is a SARS-CoV-2 track, but the only alignment track in the demo project is
   `HG002 minimap2` on the human chr20 bundle. The dialog opens and its Target section layout
   matches, but the Output Track Name field's pre-fill behavior (which needs a primer scheme
   selected first) could not be demonstrated, since selecting a scheme requires opening a native
   popup menu that background automation cannot drive. A live session with full screen control
   and the SARS-CoV-2 fixture imported would be needed to capture the field in its pre-filled
   state.
3. No other content disagreements were noticed; the Inspector figures (Total Mapped 91.0K, Total
   Unmapped 213, Mapped % 99.8%, Chromosomes 1, Est. Coverage 27.3x, mean coverage 44.x/max 68-79x
   depending on window) match the numbers quoted in the chapter text closely enough to be the same
   underlying fixture.

## check-shots output (04-alignments rows only)

```
missing png 04-alignments/tools-mapping-submenu
missing recipe 04-alignments/tools-mapping-submenu
missing png 04-alignments/extract-reads-region-menu
missing recipe 04-alignments/extract-reads-region-menu
missing png 04-alignments/primer-trim-scheme-menu
missing recipe 04-alignments/primer-trim-scheme-menu
missing png 04-alignments/primer-trim-track-result
missing recipe 04-alignments/primer-trim-track-result
missing png 04-alignments/viral-recon-menu-item
missing recipe 04-alignments/viral-recon-menu-item
missing png 04-alignments/viral-recon-inspector-outputs
missing recipe 04-alignments/viral-recon-inspector-outputs
```

All 14 captured shots no longer appear as missing (png or recipe) in the checker output above —
only the 6 deliberately skipped rows remain.
