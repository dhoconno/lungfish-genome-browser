# Editor pass, appendices/bibliography.md

Brand copy editor, 2026-09-07. Roster row 60. Reference appendix, own shape and
its `<a id="appendix-bibliography"></a>` anchor both kept. `brand_reviewed` and
`lead_approved` left at false.

## False claims fixed

Three, each with the reviewer's wording.

1. **Trim Galore prints an iVar citation, not an unmatched line.** The section
   heading changed from "Tools the command does not recognise" to "Tools the
   command mishandles", since the section now covers a case where the command
   recognises too much. Trim Galore, `gatk-variant-filtration`, and
   `gatk-variants-to-table` are removed from the genuinely-unmatched list and
   given their own fifth cause, which states that each prints a complete and
   confident citation for a tool that never ran, names which wrong tool each
   reaches (iVar, Medaka, iVar), and tells the reader to delete it. The
   unmatched list itself is now stated as a list rather than a count, per the
   reviewer's scope correction, and includes pysam and openpyxl. The matching
   description gained the third tier, so the fifth cause no longer arrives
   unexplained. The chapter also warns about this in "What it is", so a reader
   meets the caveat before the tables.

2. **`--pack` takes no value, and three packs are Plugin Manager only.** The
   sentence now reads that `--pack` is a switch that takes no value of its own
   and changes how the names after it are read, with the complete example
   `lungfish-cli conda install --pack read-mapping`, matching
   `cli-reference.md:560`. A following paragraph names `gatk-core`, `phasing`,
   and `wastewater-surveillance` as Plugin Manager only. The three-pack figure
   is the reviewer's, verified live and confirmed by me against
   `PluginPack.swift` lines 625, 651, and 840, all three `isExperimental: true`.
   Note `cli-reference.md:562` and `:621` name only two packs and are stale by
   one, which is that chapter's row to fix.

3. **The ribosomal index belongs to Deacon.** Table 4's row now reads
   "Ribosomal RNA Removal Data, for Deacon", and the prose beneath it says
   Deacon serves both the host-depletion and the ribosomal-removal rows.

The six unverified DOIs are untouched and unmarked, and no DOI anywhere in the
chapter was altered. The IQ-TREE 3 question is left as prose advice to recheck,
now with a site named.

## Project manager rulings

| Ruling | Where applied |
|---|---|
| (a) Terminal-first opener before any command | First paragraph of "What it is". Says the command runs in the Terminal application, that no window prints a citation list, and that the four tables are the window reader's route. Also answers the `audience: power-user` row by naming a student writing a methods section as an intended reader. |
| (b) Terminal paragraph split into performable steps, path quoted for the space, exit statuses glossed | "What the bibliography command prints" opens with five numbered steps (open Terminal and find the prompt, type `cd` plus a space, drag the folder in, press Return, type the command). Step 3 says a path containing a space arrives with quotation marks around it and should be left alone. `lungfish-cli` is named as the command-line copy of LGE per `CONSISTENCY.md:13`, with the `command not found` case routed to the CLI Reference. Exit status is glossed in full at first use, then 0 as success and 64 as failure, with the hand-use and script-use advice separated. |
| (c) One worked example of a finished reference | New H3 "One worked example" under the first table. Shows the command's own minimap2 output line, then the same reference rearranged into an author-date entry using only the fields the line and the table carry, then the no-paper case for Trim Galore with `n.d.` A second, shorter worked example sits under "Citing LGE itself" for the app's own citation. |
| (d) The "eight tools" count | Dropped. The sentence now says rows carrying a project page rather than a DOI belong to tools that never published a paper, with no number to check against the rows. |
| (e) Versions come from the tool lock, said once, naming Tool Versions | Last paragraph of "What it is" names the tool lock manifest as the source of every version in the appendix, says Tool Versions regenerates from the same manifest, and rules that the manifest governs when the two disagree. Bracken checked against the lock directly: `packTools[]` carries `version` 1.0.0 with a separate `sourceBuild` of 3.1, so the row stays at 1.0.0 as the lock says, and the pointer to the source of truth answers the readers' question without changing a number. |
| (f) Which tools you actually need to cite, with a window route | New H2 "Which tools you actually need to cite", stating the sidecar is authoritative and giving three routes. Route 2 is the Operations panel, opened with **Operations > Show Operations Panel** (Cmd-Shift-P), the row selected and **More** clicked to expand, taken from `08-workflows/01-the-workflow-builder.md:289`. Route 3 is `.lungfish-provenance.json` opened in a text editor, taken from `09-genotyping/02-running-genotyping.md:236`. The plugin pack section's "cite only the tools your own sidecar names" now points forward to it. |
| (g) Idioms out | "wrapped" (of a tool), "noise", "wholesale", and "keep the result honest" all removed. Replacements are "the tool it ran", "you can ignore those lines", "cite only the tools your own sidecar names", and "Three rules keep your citations accurate". One further literal use of "wrapped" introduced in the Terminal steps was rewritten to "with quotation marks around it". |
| (h) Gloss every term the consensus lists | Glossed at first use: citation, DOI (with a real DOI as the example and the `https://doi.org/` prefix rule), provenance sidecar, JSON, checksum, dependency set, pin, tool lock manifest, exit status, alias table, positional argument, bundle, HG002, plugin pack, conda, pack name, MHC, preprint, container, pipeline, reference manager, host depletion, ribosomal RNA removal, read scrubber, secondary citation, and `n.d.` |

## Consensus rows

All 30 applied.

The two that reshaped the most text are the Terminal-disclosure row, which
produced ruling (a)'s opener, and the sidecar row, which produced ruling (f)'s
new section. Beyond those: `provenance export --format methods` gained a full
command block and a described first output line. `lungfish-cli --version` gained
the About window as its window route and moved behind it. The database version
strings are now sorted into dates and release names with an instruction to copy
them exactly. The pipeline section names the CITATIONS file at the top of an
nf-core repository as where a pipeline states its requirements, and gives the
viralrecon answer directly. The three-things-to-cite sentence became three
sentences. IQ-TREE gained `http://www.iqtree.org` as the place to check.
Secondary citation is defined, with both papers going in the list. The
eight-tools count went. The defect aside names the issue tracker. The workflow
export cross-reference is now a link. "Four lines" became "two citations". The
sidecar search-order paragraph collapsed to one sentence saying the command
finds the file itself. `./Analyses/mapping-HG002` is stated as an example to
replace, and one path is used throughout. `lungfish-cli` is said to work from
any folder, with the `command not found` case routed. The four opening tool
names are marked as examples. The reviewer-wondering sentence leads with the
rule. The eight Kraken 2 builds point at the sidecar. The Pack column is
explained and ruled out of a methods section. The "LGE's own wording" clause
went. The DOI prefix rule is stated above the first table. "These tools install
without any plugin pack" became "are present in every copy of LGE". The twelve
tool names are grouped by what they do before being listed. The matching rule is
stated in three tiers including when it mismatches.

## Other merged rows

Fifty-seven rows outside the Consensus section. Fifty-two applied, five skipped.

Applied in bulk: the parse-difficulty rows (the double negative, "the journal
expects", "straightforward", "executable", "This appendix holds two things" as a
real list, the differently-named-taxa sentence, "on its own", "the last row",
"Three notes belong with this table" split into three paragraphs, "Each of these
arrives with the pack named beside it"), the missing-gloss rows (BAM readouts
named, `n.d.` for yearless entries, bedGraphToBigWig's build number, the
`lungfish` prefix on LGE's own steps, the mechanism paragraph marked as needing
no action, the SPAdes line stated as the only line under its heading), the
citation-mechanics rows (a software citation with no DOI is normal, the preprint
note on WhatsHap, the viralrecon missing year, the table-and-block join stated
and worked), and the ambiguity rows ("it" replaced with "the dependency set",
pin used in one sense with the taxonomy said plainly not to be pinned, the
Plugin Manager said to install tools but produce no citations, the alias table
said not to be displayable, which of the two BWA papers the shared entry
prints).

Skipped, with reasons.

1. **"Use a tool that appears in the tables as the example" for the alias
   table.** Skipped. `bwa`/`bwa-mem`/`bwa-mem2` is the alias table's own
   example and the reviewer verified the entry, so substituting a different tool
   would make the sentence untrue. The conflict the reader felt is resolved
   instead by saying which paper that shared entry prints and pointing at the
   correction below.

2. **"Say whether a window route is planned."** Partly skipped. The chapter now
   says no window route is planned for this release, which is what the source
   supports. I did not promise a future one, since nothing in the app or the
   campaign's ground truth speaks to a roadmap.

3. **"Confirm the shipped Bracken version, or add a note explaining the
   discrepancy."** Skipped as written. Ruling (e) governs, so the number stays
   at what the lock's `version` field says and the chapter points at the
   manifest as the source of truth rather than annotating the row.

4. **"Say which chapter is authoritative when versions differ."** Applied for
   the manifest, skipped for the chapter-versus-chapter framing. Neither
   appendix is authoritative over the other, so the chapter names the manifest
   as what governs. Naming one chapter as the winner would be false while
   `tool-versions.md` is stale.

5. **"Add a note explaining the discrepancy" for the nine versions against
   tool-versions.md.** Skipped. The fidelity reviewer explicitly rules this
   correct behaviour rather than an error, and roster row 66 owns the
   reconciliation. Ruling (e)'s pointer at the manifest is the disclosure the
   chapter owes.

## Glossary changes

Four entries added to `docs/user-manual/GLOSSARY.md`, alphabetically, in the
file's existing `**Term**{#anchor}. Definition. See also: ...` shape.

- **Pinned** `{#pinned}`, between Ploidy and Plugin pack.
- **Preprint** `{#preprint}`, between Post-install hook and Primer.
- **Reference manager** `{#reference-manager}`, before Reference bundle.
- **Tool lock manifest** `{#tool-lock-manifest}`, between Tip and Topology.

`glossary_refs` grew from 7 slugs to 20, adding bundle, checksum, conda,
container, exit-status, host-depletion, json, operations-panel, pinned,
positional-argument, preprint, reference-manager, and tool-lock-manifest to the
seven the author declared. All 20 verified to resolve against GLOSSARY.md.

`estimated_reading_min` raised from 12 to 14 for the added sections.

## Lint

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/bibliography.md: no issues found
```

## Status

brand_reviewed: false
lead_approved: false
