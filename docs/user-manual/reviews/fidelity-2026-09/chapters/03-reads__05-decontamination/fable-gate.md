# Fable gate: 03-reads/05-decontamination

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`CONSISTENCY.md`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. All 14 settings across the five operations in the three-sentence shape with the registry labels verbatim, Output Strategy once for the four panes that carry it, and the ribosomal pane's absence of it stated. |
| Every number traceable | Pass. All twelve quoted counts recounted by the fidelity review from the FASTQ files, both Deacon log lines, the provenance sidecar values, and the entropy sweep. |
| Menu paths and surfaces | Pass. Tools > Decontamination > each of the five items, the Inputs rows and their Replace... and Clear buttons, the Retain Reads control, the Advanced disclosure, the six presets, the Operations panel, the Plugin Manager's Required Setup entries, and every CLI flag. |
| Fidelity false claims corrected | Pass. Direct `Analyses/` output, the SRR36291587 reads fetched from SRA rather than GitHub, two Deacon indexes with PhiX bundled inside BBTools, the button labels, and the four command-line-only flags. |
| Removed content noted | Pass. The old chapter's invented worked example, the unsourced entropy benchmark figures, the denied controls, and the Troubleshooting section, per the author report. |
| Glossary alphabetised | Pass. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The output bundle is named `<input stem>-<operation>`, not for the operation alone, per the naming ruling recorded at the Trimming and Filtering gate.
2. The NovaSeq optical distance of 12000 was attributed to Illumina's documentation. It is the clumpify recommendation, and the Optical NovaSeq preset sets it, so the sentence now says that.
3. CONSISTENCY.md said SRA reads go through the Import Center. The committed SRA chapter's route is the Database Browser under Tools > Search Online Databases, so the sheet now says that.

## Rulings

The `--subs 2` figure stays out of the results table. The 44,871 count is verified but adding a sixth row is a content change, not an editorial fix.

## Findings for RESULTS.md

`scrub-human --remove-reads` is accepted and ignored. Human read removal on an amplicon run removes almost nothing, so the manual has no high-removal worked example without a shotgun clinical fixture.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
