# Fable gate: appendices/primer-schemes

Gate run by the project manager (Fable) on 2026-09-07 against the full
editor-pass text and the diff of the chapter and `GLOSSARY.md`.

## Checks

| Check | Result |
|---|---|
| Shape | Pass for a reference appendix. What it is, Shipped schemes, Bundle layout, BED expectations, Building a scheme with the window route, Manifest fields, On the command line with its verification subsection, What the provenance records, Keeping a scheme reproducible, Next. |
| Every number traceable | Pass. Eight schemes with primer and amplicon counts byte-checked against the manifests, the 58 and 29 of the minimal import, the 24-base subtraction, the nine PROVENANCE.md lines, exit 0 and exit 1, all from the author's runs and the fidelity review's reruns. |
| Fidelity false claim corrected | Pass. The variant tag sits before the suffix, and the created and imported reasoning is two clock reads. |
| Rulings | Pass. All nine, with the contig-name source named, the window's lack of an override stated inside the Procedure, the terminal checks moved under their own subheading with methods, one panel name throughout, the worked subtraction, the hidden-file clause, and eight glossary terms. |
| Reader consensus | Pass. Thirty-two of thirty-two applied, 55 others, 6 skipped. |
| Viral by design | Pass. Stated once with the reason. |
| Command-line opener | Pass after the gate edit. The clause names the two command-line-only capabilities. |
| Strict lint | Pass after gate edits. |

## Gate edits

1. The source-tree path for the shipped schemes removed, since a reader has no such path.
2. The fixed opener's clause replaced with the two command-line-only capabilities.
3. The Foundations chapter link uses its title.
4. Reading time raised to 28 minutes.

## Rulings

The chapter's DRIFT correction stands: an imported bundle carries a provenance folder with one sidecar per file plus a bundle sidecar. The lint rule that counts a table's right-align delimiter as a prose colon is a Phase 6 tooling item.

## Findings for RESULTS.md

The Import Primer Scheme sheet hard-codes empty attachments and writes no description, organism, source URL, or version. `primers` advertises inspection but has only `import`. The canonical-flag fallback to the first accession is silent. A variant tag after the LEFT or RIGHT suffix inflates the amplicon count silently. The lint rule counts `---:` as a prose colon.

## Phase 5 notes

Three shots. The Import Center card and sheet come from the demo project. The Inspector shot needs a scheme selected in the sidebar, and a shipped scheme shows more fields than an imported one.

## Verdict

Pass. `brand_reviewed: true`, `lead_approved: true`.
