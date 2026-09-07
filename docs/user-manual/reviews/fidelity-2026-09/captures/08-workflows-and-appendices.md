# Captures: 08-workflows and appendices (2026-09-07 session)

## 08-workflows (11 rows)

- `workflow-builder-experimental-toggle` — already done before this session (skipped per instructions).
- `workflow-builder-sidebar-library` — **captured**. Region crop 210x772pt -> 420x1544px. Shows the Workflows list (empty at capture time, before the workflow was created) above the node palette with its plus/duplicate/trash buttons.
- `workflow-builder-palette` — **captured**. Region crop 210x380pt -> 420x760px. Shows the Filter nodes field and all four category headers (Input, Trimming & Filtering, Decontamination, Read Processing), each expanded with its node types, after the "Mito read cleanup" workflow was created.
- `workflow-builder-canvas` — **skipped**, reason: needs drag and drop. Palette entries only support drag-and-drop placement onto the canvas; a single click selects the row (highlighted blue) and a double-click also only selects it — neither places a node. Confirmed no keyboard affordance (Return) places the selected node either. No nodes could be added to the canvas with plain clicks or double-clicks, matching the chapter's own description ("Click and hold a palette entry, drag it onto the canvas, and release").
- `workflow-builder-node-inspector` — **skipped**, same reason (needs drag and drop) — no node could be placed on the canvas to select and inspect.
- `export-provenance-submenu` — **skipped** per worklist, reason: needs a full-screen pass (menu-open capture requires the full-screen tools, which are out of scope for this session).
- `export-provenance-save-panel` — **skipped** per worklist, reason: needs a save panel.
- `export-provenance-complete-alert` — **skipped** per worklist, reason: needs a finished export.
- `nextflow-export-main-nf` — **skipped** per worklist, reason: needs an export and a text editor.
- `workflow-library-linked-package` — **skipped** per worklist, reason: no linked package on this machine.
- `workflow-operations-runner` — **captured**. Full window (1600x1159px, no crop). Selected `Imports/HG002` in the sidebar, opened via Tools > Genotyping > miSeq amplicon MHC genotyping..., which auto-selected `HG002.lungfishfastq` and Project Reference `chr20_10.0-10.5Mb.lungfishref`. Captured at a scroll position showing Overview, Inputs, Primary Settings, and Advanced Settings together, with the Readiness line reading "Ready to run." at the bottom. The Output section sits one further scroll step down and is not in this single frame (window is a single scrolling column; no way to fit all six named sections in one frame without additional shots, which the worklist did not ask for). Cancelled without running.

## appendices (8 rows)

- `ai-assistant-panel` — **captured**, but with a fidelity discrepancy worth flagging. Full window (1600x1028px). Selected the HG002 chr20_10.0-10.5Mb reference bundle in the sidebar (confirmed loaded via the Bundle inspector tab: Homo sapiens, 500.0 Kb, 1,918 variants), enabled AI-powered search in Settings > AI Services, then opened View > AI Assistant. **Discrepancy**: the chapter text says "With the HG002 chromosome 20 slice open, six of the buttons read 'Data overview', 'Explore current view', 'Search for a gene', 'Variant statistics', 'Find related research', and 'Chromosome guide'", but the Assistant tab instead showed the empty-project fallback state — "No genome bundle is currently loaded" and a single "Getting started" suggestion — even with the bundle plainly loaded and visible in the main viewport and the Bundle inspector tab confirming it. This was reproduced twice (reselecting the sidebar row, reselecting the table row, retriggering View > AI Assistant) with the same result each time. The captured shot still legibly shows the welcome message, the Data sent... and Clear header buttons, and one suggested-question button, satisfying the caption's other elements. Turned AI-powered search back off afterward.
- `ai-assistant-provider-setup` — **captured**. Region crop 820x365pt -> 1600x712px. Shows Enable AI-powered search (off), Default provider (Anthropic Claude), and the Anthropic API Key field empty (grey minus-sign status, `sk-ant-...` placeholder) with its Model picker. Note: the OpenAI and Google Gemini sections on this machine already carry entered keys (orange hourglass / grey minus with `Alza...` placeholder text) from prior state not created in this session — these were left untouched and excluded from the crop so the shot only shows an empty key field as required.
- `ai-assistant-azure-endpoint` — **captured**. Region crop 820x170pt -> 1600x331px, scrolled to the Azure AI section. Shows the Use Azure AI-hosted endpoint toggle (off) and the Endpoint/Deployment fields both empty, showing their placeholder text (`https://example.openai.azure.com`, `gpt-5-mini`).
- `primer-scheme-import-card` — **captured**. Region crop 611x87pt -> 1222x174px. Shows the Primer Scheme card on the Import Center's Reference Sequences tab with its file hint reading ".bed (+ optional .fasta/.fa/.fna)".
- `primer-scheme-import-sheet` — **captured**. Full window (1600x1028px). Clicking Import... on the Primer Scheme card first opened a native file-open panel (for the BED file) rather than going straight to the custom sheet; this was cancelled per instructions. On a later attempt the "Import Primer Scheme" sheet then appeared attached to the main project window, showing the Files section (BED required / FASTA optional rows, each with Choose...) and the Identity section (Name, Display name, Canonical reference accession, and the start of Equivalent accessions). Cancelled without importing.
- `primer-scheme-inspector` — **skipped** per worklist, reason: the demo project's Primer Schemes folder is empty.
- `shared-projects-read-only-banner` — **skipped** per worklist, reason: needs a second session holding the project open.
- `operations-panel-failed-row` — **skipped** per worklist, reason: needs a failed run and a right-click menu.

## Other app-state notes

- The Workflow Builder's own "New Workflow" prompt matches the chapter's step-1 description exactly (message text, prefilled `New Workflow` field, Create button). A workflow named "Mito read cleanup" was created during this session (needed to capture the palette shot in a more representative post-creation state) and was left in the project's Workflows list — it was not deleted because Delete is on the prohibited-click list even for a test artifact created in this session.
- Windows opened during this session (Settings, Workflow Builder, Workflow Operations, Import Center) repeatedly went "off-Space" after being closed via the traffic-light control instead of fully closing; this appears to be an artifact of the computer-use harness's Space tracking rather than app behavior, since a fresh `screencapture` always confirmed the intended dismissal (sheet cancelled, panel closed) even when the `app_screenshot` tool briefly returned a stale cached frame.

## check-shots output (08-workflows / appendices only)

```
missing png 08-workflows/workflow-builder-canvas
missing recipe 08-workflows/workflow-builder-canvas
missing png 08-workflows/workflow-builder-node-inspector
missing recipe 08-workflows/workflow-builder-node-inspector
missing png 08-workflows/export-provenance-submenu
missing recipe 08-workflows/export-provenance-submenu
missing png 08-workflows/export-provenance-save-panel
missing recipe 08-workflows/export-provenance-save-panel
missing png 08-workflows/export-provenance-complete-alert
missing recipe 08-workflows/export-provenance-complete-alert
missing png 08-workflows/nextflow-export-main-nf
missing recipe 08-workflows/nextflow-export-main-nf
missing png 08-workflows/workflow-library-linked-package
missing recipe 08-workflows/workflow-library-linked-package
missing png appendices/primer-scheme-inspector
missing recipe appendices/primer-scheme-inspector
missing png appendices/shared-projects-read-only-banner
missing recipe appendices/shared-projects-read-only-banner
missing png appendices/operations-panel-failed-row
missing recipe appendices/operations-panel-failed-row
```

All entries above correspond to rows intentionally skipped for the stated reasons; no unexpected gaps.
