# Fable gate: 04-alignments/05-viral-recon-wizard

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`, and
`parameters.yaml`. The first author was killed by a usage limit before
writing and a second author ran the chapter.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start (fixed opener), Procedure, Settings, Reading the results, What good looks like, On the command line, Next. |
| Every registry setting present | Pass. Five workflow.viral-recon settings in the three-sentence shape with the registry labels verbatim, the colon-terminated one included. The Scheme flag corrected in the registry to primer_bed plus the two suffixes. |
| Every number traceable | Pass with a stated gap. The scheme caption figures, the 86,281 read pairs, the refused-parameter list, and the SRR11140748 consensus figures are sourced, and the latter are labelled as another sample's. No pipeline run of the fixture exists yet, so the chapter quotes no figure it cannot source and names each gap. Phase 5 fills them. |
| Menu paths and surfaces | Pass. Tools > Mapping > Viral Recon..., the sheet's heading and sections, the four controls and the Advanced disclosure, the Readiness messages, the run bundle, the Operations Panel row, the results folder and Inspector sections, and every CLI option. |
| Fidelity false claims corrected | Pass. Four refused primer parameters, the Scheme flag, two link titles. The hand-written command block is labelled as such with its two differences named. |
| Defects disclosed | Pass. Freyja skipped for the Intel-only container, and the wizard's parameter validation before a first run left out as unverifiable. |
| Glossary alphabetised | Pass. Eight new entries in place, and the Lineage entry corrected at the gate. |
| Nav and help-ids | Pass. Title unchanged. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. "Every Mac sold since 2020 carries an Apple Silicon chip" was false (Intel Macs sold into 2023). Reworded.
2. The Lineage glossary entry said LGE does not assign lineages. It now says the Viral Recon pipeline does, through Pangolin and Nextclade.
3. Chapter 7's Required Setup paragraph now names Nextflow, since this chapter sends the reader there for it.

## Rulings

The chapter names each unquoted figure and why rather than staying silent. The SRR11140748 figures stay, labelled as another sample's.

## Phase 5

Run the pipeline on SRR36291587 in the demo project and fill in the mapped-read count and rate, per-amplicon depth and any dropout, the consensus length and N count, the Pangolin lineage and Nextclade clade, the runtime, and the Inspector filenames. Pose the Advanced disclosure open for its shot.

## Findings for RESULTS.md

`ViralReconWizardSheet.loadKnownParameters` falls back to `overridableAdvancedKeys` before the schema is pulled, so a valid Extra parameter is refused with a spelling message on a fresh install. `features.yaml` `align.viral-recon` names a retired menu path and a moved source file. Freyja is skipped because the pinned container is Intel-only.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
