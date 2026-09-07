# Fidelity review, appendices/bibliography.md

Reviewer pass, 2026-09-07, against Preview 2026.9.13 and the lock at this commit.

All 11 bibliography runs were reproduced independently. I copied the author's
scratch fixtures to `/Users/dho/lge-review-bib` (never `/private/tmp` as the
working directory) and ran
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli` from
the worktree root. Every quoted output block and every exit status reproduced
byte for byte. I also built 26 synthetic single-step sidecars under
`/Users/dho/lge-review-bib/probes/` to test the alias table against the real
binary rather than by reading the Swift, which is how the two new false claims
below were caught.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| Front matter `chapter_id: appendices/bibliography`, `audience: power-user`, `entry_points` naming only the CLI command | true | Matches the sibling appendix `tool-versions.md:1-19` and `ARCHITECTURE.md:99-105` | |
| Anchor `<a id="appendix-bibliography"></a>` present above the first H2 | true | `bibliography.md:21` | |
| "A **DOI** ... the string beginning `10.` that ... resolves at `https://doi.org/`" | true | Definitional, and matches `GLOSSARY.md:201` | |
| "The version numbers in this appendix are those of Preview 2026.9.13, whose **dependency set** is `2026.2`" | true | Lock top-level `version` 2026.9.13, `dependencySet` 2026.2 | |
| "The command lives only on the command line and has no menu item" | true | `MainMenu.swift` has no bibliography item; `08-workflows/02-...md:239` says the same | |
| Sidecar search order, root `.lungfish-provenance.json` then `provenance/bundle.lungfish-provenance.json` then `bundle.lungfish-provenance.json` then remaining JSON in path order | true | `ProvenanceCommand.swift:206-245`, `loadProvenance` and `provenanceCandidates` | |
| "Matching ignores case and punctuation and accepts a partial overlap, which is why `samtools sort` matches SAMtools" | true but incomplete | `ToolBibliographyCatalog.swift:316-348`. Exact alias scores 0, substring scores 1, and a **shared token scores 2**. The third tier is unstated and is what produces the wrong-citation bug below | Add a sentence: "Matching also accepts a single shared word, which is loose enough to reach a wrong entry." |
| "Every step whose name matches contributes one citation, deduplicated and sorted by tool name" | true | `bibliography(for:)` keys a dictionary by `citation.id` and sorts with `compareCitations` on `displayName` | |
| The minimap2 run output block, verbatim, and "the whole output is four lines" | true | Reproduced exactly. Output is 4 lines, 3 non-blank | |
| "This is the same pair the workflow export chapter reports" | true | `08-workflows/02-exporting-as-nextflow-or-snakemake.md:246` reports the same two entries | |
| The GATK output block, verbatim, with unmatched `gatk-haplotype-caller 4.6.2.0` | true | Reproduced exactly, exit 0 | |
| "The command exits with status 0 in all three of those cases, including the case where it matched nothing" | true | Runs on gatk-hc, spades, freyja, kraken2, rev-export all exited 0. `printBibliography` returns without throwing | |
| "a folder with no sidecar ... prints `Error: Workflow execution failed: No Lungfish provenance sidecar found in <path>` and exits 64" | true | Reproduced on two sidecar-less folders. `ProvenanceCommand.swift:197-200` throws `CLIError.workflowFailed` | |
| "Every assembler, every GATK entry, Clair3, WhatsHap, Freyja, BLAST, Bracken, EsViritu, RiboDetector, Savont, **Trim Galore**, and TaxTriage have no entry, so a run using any of them prints the tool under the unmatched heading" | **false** | Trim Galore has no entry but does **not** print unmatched. A probe sidecar with `toolName` `trim_galore`, `trim-galore`, or `Trim Galore` returns a full **iVar** citation, because normalising drops the underscore and the shared token `trim` scores 2 against the iVar alias `ivar trim`. Same class of failure for `gatk-variant-filtration`, which returns **Medaka** (shared token `variant`, alias `medaka variant`), and `gatk-variants-to-table`, which returns **iVar** (shared token `variants`) | Split the sentence. Keep the unmatched list as SPAdes, MEGAHIT, SKESA, Flye, hifiasm, BLAST, Savont, Clair3, WhatsHap, Bracken, EsViritu, RiboDetector, Freyja, TaxTriage, GATK4 under `gatk-haplotype-caller`, `gatk-joint-genotype`, `gatk-bqsr`, and `gatk-collect-metrics`, plus pysam and openpyxl. Then add a separate warning that Trim Galore, `gatk-variant-filtration`, and `gatk-variants-to-table` are worse than unmatched, because they print a confident citation for a tool that never ran. |
| "GATK steps are recorded as `gatk-haplotype-caller`, `gatk-joint-genotype`, `gatk-variant-filtration`, and similar ... so even an alias table entry named for the tool would need the wrapper spelling too" | true | Live sidecar `gatk-hc/.lungfish-provenance.json` records `toolName: gatk-haplotype-caller`. Probes confirm the other spellings | |
| "Freyja is recorded as `lungfish freyja demix`" | true | Run 7 printed `- lungfish freyja demix lungfish-cli 2026.9.13` | |
| "LGE's own steps ... recorded under names like `lungfish extract reads` or `lungfish genotype export-pivot-xlsx`" | true | Runs 8 and 9 printed both verbatim | |
| Table 1, 18 rows, every version | true | All 18 match. 17 from lock `tools[]` one-to-one, micromamba 2.9.0-0 from `bootstrap.micromamba.version` | |
| "Eight of these tools have never published a paper" and the eight URL rows | true | BBTools, Deacon, Trim Galore, pigz, SRA Tools, pysam, openpyxl, micromamba carry URLs. Six of the eight have `doi: nil` in the alias table; pysam and openpyxl have no entry at all | |
| Table 1 citation block wording for the 16 tools the alias table covers | true | Each string is character-identical to the `citation` field in `ToolBibliographyCatalog.swift` | |
| Table 2, 23 rows, version and pack for each | true | All 23 match lock `packTools[]` on both `version` and `packID`, in lock order | |
| "either from the Plugin Manager at **Tools > Plugin Manager...** or from `lungfish-cli conda install --pack <name>`" | **false** | Two errors. `--pack` is an `@Flag`, not an option taking a value (`CondaCommand.swift:84`), so it takes no `<name>`. And three of the eight packs in this table are experimental and hidden from the CLI, so the command fails for them. Live: `conda install --pack gatk-core` prints `✗ Unknown tool pack: gatk-core` and lists eight available packs, excluding `gatk-core`, `phasing`, and `wastewater-surveillance` (`PluginPack.swift:625,651,840` mark all three `isExperimental: true`; `visibleForCLI` filters them out) | "either from the Plugin Manager at **Tools > Plugin Manager...** or from `lungfish-cli conda install --pack read-mapping`, where `--pack` is a switch that changes how the names after it are read. Three packs in this table, `gatk-core`, `phasing`, and `wastewater-surveillance`, install only through the Plugin Manager, because the command-line installer does not list them." |
| BWA-MEM2 note, cite the 2019 architecture paper, keep Li and Durbin 2009 secondary | true | Implements DRIFT row 24. Alias `bwa` entry cites Li and Durbin 2009 with DOI `10.1093/bioinformatics/btp324` while lock installs `bwa-mem2` 2.3 | |
| MAFFT note, cite the 2013 version 7 paper, keep 2002 as original method | true | Implements DRIFT row 27. Alias `mafft` cites Katoh 2002, `10.1093/nar/gkf436`, while lock installs 7.526 | |
| "IQ-TREE 3 had not published its own paper when this release was built" | unverifiable | No network access. DRIFT row 28 left this open. The chapter already flags it in prose as worth rechecking, which is the right disposition. Settled by a literature search at submission time | |
| Table 3, viralrecon 3.0.0 and TaxTriage v3.3.8 | true | Lock `pipelines[]` gives `releaseVersion` 3.0.0 and v3.3.8 | |
| viralrecon citation and Zenodo DOI quoted from the alias table | true | `ToolBibliographyCatalog.swift:260-267`, string and `10.5281/zenodo.3901628` both identical | |
| "BEDTools, MultiQC, Pangolin, and Nextclade ... LGE does not install, version, or manage any of the four" | true | All four have alias entries and appear in no lock array. Implements DRIFT rows 26, 29, 30, 31 | |
| Table 4, 8 rows covering 16 lock database entries | true | Grouping is correct. Eight Kraken 2 builds share 20260626, SILVA and Greengenes share `kraken2-special-v1`, and the remaining six are one-to-one. Every version string matches | |
| "Ribosomal RNA Removal Data, **for RiboDetector**" | **false** | The lock entry `deacon-ribokmers` records `"tool": "deacon"` and describes a "Deacon minimizer index built from BBMap's ribokmers.fa.gz". It is the database for `lungfish-cli fastq deacon-ribo`, not for RiboDetector. `03-reads/05-decontamination.md:228,237` confirms the same | "Ribosomal RNA Removal Data, for Deacon" |
| "Human Read Removal Data, for Deacon" | true | Lock `deacon-panhuman` records `"tool": "deacon"` | |
| "The NCBI taxonomy is pinned to `live`, which means LGE fetches whatever NCBI is serving rather than a fixed snapshot" | true | Lock `ncbi-taxonomy` version is the literal string `live` | |
| "LGE has no published paper and no DOI of its own as of Preview 2026.9.13" | true | No LGE entry in the alias table and no DOI anywhere in the lock for the app itself | |
| "`lungfish-cli --version` prints the app version alone, reporting `2026.9.13`" | true | Ran it. Output is exactly `2026.9.13`, exit 0 | |
| "run `provenance export --format methods` against the same folder" | true | `provenance export --help` accepts `methods` among six formats | |
| Chapter DOIs appear in the alias table or in a DRIFT-supplied citation | true, with 14 outside both | 35 DOIs in the chapter. 20 are character-identical to alias-table `doi` fields. 14 come from DRIFT Missing rows or are the canonical paper for a tool neither source covered (SPAdes, MEGAHIT, SKESA, Flye, hifiasm, RiboDetector). One alias DOI, `10.1093/molbev/msu300` for IQ-TREE 1, is deliberately absent, superseded per DRIFT row 28. No DOI in the chapter is invented relative to what a source carried | |
| `glossary_refs` lists seven slugs that all resolve | true | `GLOSSARY.md:23` alias-table, `:115` citation, `:201` doi, `:189` dependency-set, `:509` plugin-pack, `:529` provenance, `:531` provenance-sidecar | |
| The three new glossary entries sit alphabetically in the file's entry shape | true | Alias table after Alias map and before Alignment. Citation after Circular consensus sequencing and before Clade. DOI after Docker and before Download Center | |
| "tool-versions.md ... gives Nextflow 25.10.4 ... while the lock gives 26.04.6", nine versions, and omits Trim Galore | true, all nine | `tool-versions.md:49-63`. Nextflow 25.10.4 vs 26.04.6, Snakemake 9.19.0 vs 9.25.2, BBTools 39.80 vs 40.02, Fastp 1.3.2 vs 1.3.6, Deacon 0.15.0 vs 0.16.0, Samtools 1.23.1 vs 1.24, BCFtools 1.23.1 vs 1.24, HTSlib 1.23.1 vs 1.24, VSEARCH 2.30.5 vs 2.31.0. No Trim Galore row (zero case-insensitive matches for "trim"). The other seven managed tools agree with the lock | |
| Lint clean under `LUNGFISH_MANUAL_STRICT=1` | true | Reran it. `no issues found`, exit 0 | |

## Front matter

Complete and correct. All seventeen keys match the schema in `ARCHITECTURE.md:99-105`
and the shape of the sibling appendix. `entry_points` names the one CLI command
the chapter teaches, in the campaign's `"CLI: ..."` form. `shots`, `illustrations`,
`features_refs`, and `fixtures_refs` are empty, which DRIFT's screenshot section
explicitly endorses for this chapter. `brand_reviewed` and `lead_approved` are
both false, correct for a chapter that has not reached those gates.

## Consistency

Naming follows `CONSISTENCY.md:11-12`. "Lungfish Genome Explorer (LGE)" appears
at first mention in the body at line 25 and "LGE" thereafter. The one bare
"Lungfish" at line 69 sits inside a verbatim error string, which is correct to
leave alone.

The Terminal opener at line 37 is the fixed paragraph from `CONSISTENCY.md:215`,
reproduced word for word from `08-workflows/02-exporting-as-nextflow-or-snakemake.md:227`.

The Plugin Manager menu path `**Tools > Plugin Manager...**` matches
`CONSISTENCY.md:34-35` and the real menu title at `MainMenu.swift:775`. Note the
path form is permitted here because it names a window-opening menu item, not a
navigation path inside a viewport.

Prose rules pass. Zero em dashes, zero semicolons, zero sentence-internal colons
outside code blocks and table cells. Bullet and list caps are not reached, since
the chapter uses tables and fenced blocks rather than bullet lists throughout.

The three cross-links in "Next" all resolve to existing files.

One consistency risk the editor should know about. This chapter and
`tool-versions.md` will disagree on nine version numbers until roster row 66
regenerates the latter from the lock. The author followed the lock, which is
correct under the campaign's ground-truth order. No change is needed here.

## App defects

Confirming the author's five, and adding two.

1. **Confirmed, with a correction to its scope.** The alias table covers 29
   tools and misses many LGE installs. Live probes show these return an
   unmatched line and no citation: SPAdes, MEGAHIT, SKESA, Flye, hifiasm, BLAST,
   Savont, Clair3, WhatsHap, Bracken, EsViritu, RiboDetector, Freyja, TaxTriage,
   pysam, openpyxl, and GATK4 under four of its six step names. The author's
   headline count of fourteen does not match the sixteen tools the same
   paragraph then lists, and both figures omit pysam and openpyxl. State the
   count as a list rather than a number.

2. **Confirmed.** Wrapper step names do not resemble their tools.
   `gatk-haplotype-caller` and `lungfish freyja demix` are recorded verbatim.
   The author is also right that `iqtree3` matches the `iqtree` entry by
   substring, scoring 1, so that one lane is fine.

3. **Confirmed.** A matched-nothing run exits 0. Five separate runs prove it.
   Only a missing sidecar exits 64.

4. **Confirmed.** The `bwa` entry cites Li and Durbin 2009 while the lock
   installs `bwa-mem2` 2.3. The `mafft` entry cites Katoh 2002 while the lock
   installs 7.526. The `iqtree` entry cites the 2015 IQ-TREE 1 paper while the
   lock installs 3.1.3.

5. **Confirmed.** BEDTools, MultiQC, Pangolin, and Nextclade carry entries and
   appear in no lock array. Three other alias ids also fail a literal lock-id
   comparison, namely `bwa`, `ucsc-bigbed-bigwig`, and `viralrecon`, but each
   covers a tool the lock does manage under a different id, so the author's
   figure of four is right.

6. **New, and the most serious defect in this chapter's surface.** The
   token-overlap tier of `matchScore` (`ToolBibliographyCatalog.swift:329-335`)
   returns a confident citation for the wrong tool. Verified against the real
   binary with synthetic sidecars:

   - `trim_galore`, `trim-galore`, and `Trim Galore` all print a full **iVar**
     citation with iVar's DOI, because normalising `trim_galore` yields the
     token `trim`, which the iVar alias `ivar trim` also carries.
   - `gatk-variant-filtration` prints a full **Medaka** citation, via the shared
     token `variant` in the alias `medaka variant`.
   - `gatk-variants-to-table` prints a full **iVar** citation, via `variants`.

   This is worse than a missing citation. A reader following this chapter's
   advice to "read the output rather than the exit status" still gets a wrong
   reference with no signal that anything failed, and Trim Galore is an
   always-installed tool, so it is reachable without any plugin pack. Worth
   filing above the alias-table gaps.

7. **New, smaller.** `lungfish-cli conda install --pack` cannot install three of
   the eight packs this chapter's table names. `gatk-core`, `phasing`, and
   `wastewater-surveillance` are marked `isExperimental: true` and filtered out
   of `visibleForCLI`, so the command exits with an unknown-pack error. This is
   already documented in `cli-reference.md:372-374` and
   `06-human-germline-variants/03-...md:69`, so the defect is known. Only this
   chapter's phrasing needs the fix.

## Notes for the editor

Three edits are required, and all three are small.

The Trim Galore correction at line 75 is the one that matters. As written, the
chapter tells a reader that a Trim Galore run prints an unmatched line, and the
reader will instead see an iVar citation and have no reason to doubt it. The
corrected wording in the claim table splits the paragraph into genuinely
unmatched tools and wrongly matched ones. Consider adding the wrongly matched
case as a fifth cause in the "Tools the command does not recognise" section, and
adjust the heading, since that section now covers a case where the command
recognises too much rather than too little. Line 45's matching description
should gain the shared-word tier so the fifth cause does not arrive unexplained.

The `--pack <name>` fix at line 139 should follow `cli-reference.md:372`, which
already gets this right, and should name the three Plugin-Manager-only packs.
The chapter's own table lists tools from all three, so a reader will hit this.

The RiboDetector-to-Deacon fix at line 225 is a one-word change.

Two things not to change. The nine-version disagreement with `tool-versions.md`
is correct behaviour here, not an error. And the six DOIs the author supplied
for tools neither the alias table nor DRIFT covers (SPAdes, MEGAHIT, SKESA,
Flye, hifiasm, RiboDetector) are the canonical papers for those tools, but I did
not resolve them over the network, so they remain unverified in the same sense
the author flagged. A single DOI-resolution pass before the chapter reaches the
brand gate would close both that and the IQ-TREE 3 question.

## Counts

Claims checked, 38. True, 34. False, 3. Unverifiable, 1.

Commands rerun and reproduced, 11 of 11, all outputs and exit statuses matching
the author's log. Synthetic probes run, 26.

Table rows checked against the lock, 51 of 51 correct, comprising 18, 23, 2, and
8. DOIs checked, 35, of which 20 are character-identical to alias-table fields,
14 come from DRIFT or are canonical papers, and 0 are unsourced inventions.

Author findings verified, 5 of 5, with a scope correction to finding 1. New
defects found, 2.
