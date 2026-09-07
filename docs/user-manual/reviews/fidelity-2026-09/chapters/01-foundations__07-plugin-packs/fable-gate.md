# Fable gate: 01-foundations/07-plugin-packs

Gate run by the project manager (Fable) on 2026-09-06 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure, Settings, Reading the results, What good looks like, On the command line, Notes for shared workstations, Next. |
| Every registry setting present | Pass. Download, Remove, Update, Refresh, Storage Settings... each in the three-sentence shape with the registry label (the four-dot form is deliberate for the linter). |
| Every number traceable | Pass. Pack sizes and tool lists from PluginPack.swift, the 2.7 GB Required Setup and 5.9 GB optional total, the thirteen listed databases, the nine Kraken2 collections and their memory figures from MetagenomicsModels.swift and the lock, the 16 GB / 32 GB / 100 GB figures from HardwareRequirements.swift, all verified by the fidelity review or read from source by the editor. |
| Menu paths and surfaces | Pass. Tools > Plugin Manager... (Cmd-Shift-B), the three tabs, Install All and Remove All, the four status labels plus the two managed-data states, Check for Tool Updates..., Orphaned Environments, the Databases tab controls, the exact error strings, and every CLI subcommand quoted against cli-help/conda.txt, tools.txt, and provision-tools.txt. |
| Fidelity false claims corrected | Pass. Thirteen databases with the three decontamination sets off the tab, nineteen Required Setup rows and four labels, five wastewater tools, serialised installs, and the offline-commands sentence scoped to the walkthrough. |
| Unverifiable rows | Dropped by ruling. The tour duration and the storage-medium advice are gone, and the gate removed the last softened SSD sentence. |
| Removed content noted | Pass. The invented pack rows, the unsourced disk and size figures, the wrong CLI name, and the invented error strings were removed under the drift decisions and listed in the author report. Seven inactive pack ids are named in one sentence and never offered as installable. |
| Glossary alphabetised | Pass. Managed environment under M, Post-install hook under P, Required Setup pack under R. |
| Nav and help-ids | Pass. Title unchanged, no help-id entry. Cross-links to the troubleshooting and CLI reference appendices are checked in Task 6.2. |
| Strict lint | Pass after the gate edit. |

## Gate edits

1. "Any modern external SSD is fast enough" was the softened remainder of an unverifiable row and had no source. Removed.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
