# Fable gate: 08-workflows/03-running-external-workflows

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter, `GLOSSARY.md`,
`parameters.yaml`, and `mkdocs.yml`.

## Checks

| Check | Result |
|---|---|
| Template order | Pass. What it is, Why you would do this, Before you start, Procedure (four steps), Settings with a command-line subsection, Reading the results, What good looks like with the defects under the shared heading, On the command line, Next. |
| Every registry setting present | Pass. Seven window settings and fifteen cli_only flags, each with effect, default, allowed values, when to change, and its flag or the no-flag sentence. |
| Every number traceable | Pass. Nextflow 26.04.6 and Snakemake 9.25.2, viralrecon 3.0.0, the four-base FASTA, two and nine seconds, exit 64, the three status entries, the four replayIdentity files, the quoted Readiness and retained-settings strings, all from the author's runs and the fidelity review's reruns. |
| Menu paths and surfaces | Pass. Tools > Workflow Library..., the Link Workflow Package chooser text, the card rows, the "(not enabled)" suffix, Tools > Templates > Hello World Nextflow..., the six window sections with their corrected Primary Settings and Advanced Settings names, Run Again... on the Operations row. |
| Fidelity false claims corrected | Pass. Three of three, and the nav row is fixed at the gate. |
| Defects disclosed | Pass. Three under the shared heading, plus the `ops stats` exit status and the `workflow list` name in the command-line section. |
| Reader consensus | Pass. Forty of forty applied, about thirty others. |
| Registry | Pass after the gate edit. The FASTQ Bundles row said several bundles pool into one batch, which the editor disproved in source for a linked package. The Cores row gained the Run Again sentence. The docker gating removed, since a linked package needs no container runtime. |
| Nav | Pass after the gate edit. The chapter's entry moved from the Genotyping block into the Workflows block. |
| Command-line opener | Pass after the gate edit. The "nothing here unlocks" clause replaced, since a bare pipeline file runs only from the command line. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The defects heading aligned with chapter 51's "Known defects in this release" at the third level.
2. The fixed opener's clause replaced with the one command-line-only capability.
3. The Next paragraph links the three appendices by file instead of a folder link.
4. Reading time raised to 30 minutes.
5. Registry: FASTQ Bundles row rewritten to one bundle per linked package, Cores row gains the Run Again sentence, gating cleared.
6. `mkdocs.yml`: the Running External Workflows entry moved into the Workflows block. The Genotyping block the chapter 53 author added rides along in this commit.

## Rulings

The editor settled the Cmd-Shift-P shortcut from source rather than hedging it, which stands. The chapter says plainly that neither example needs Docker or Apple Containers. The Snakemake example's empty manifest is described as an incompleteness in the shipped example rather than an app fault.

## Findings for RESULTS.md

The no-output error advises `--dry-run` as a planning route the check does not implement. `workflow run` detects Nextflow by a lower-case `.nf` extension only while `workflow validate` lowercases first. `ops stats` reports an unknown option and exits zero. The Snakemake example package declares a `.lungfishref` output and writes a `{}` manifest. `workflow list` prints a usage hint without `--nf-core`.

## Phase 5 notes

Two shots, none captured. The library shot needs the hello-world-nextflow package linked with its Execution row reading Runnable. The runner shot needs a reference bundle and a read bundle selected in the sidebar before the window opens.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
