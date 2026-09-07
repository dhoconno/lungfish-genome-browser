# Author log, appendices/bibliography.md

Roster row 60. Rewritten 2026-09-07 against Preview 2026.9.13. No registry ids, no fixture.

## Commands run

All runs used `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli` (prints `2026.9.13`). Working directory was the worktree root, never `/private/tmp`, since the campaign defect only affects a command whose working directory is under `/private/tmp`. `SP` below abbreviates `/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad`.

| # | Command | Exit | Result |
|---|---|---|---|
| 1 | `lungfish-cli --version` | 0 | `2026.9.13` |
| 2 | `lungfish-cli provenance bibliography --help` | 0 | One argument `<bundle>`, no options beyond `--version` and `-h`. Matches `cli-help/provenance.txt` exactly. |
| 3 | `lungfish-cli provenance bibliography $SP/mapping/minimap2-out` | 0 | Two citations, minimap2 and SAMtools. Quoted verbatim in the chapter. |
| 4 | `lungfish-cli provenance bibliography $SP/alignment-quality` | 0 | One citation, SAMtools. |
| 5 | `lungfish-cli provenance bibliography $SP/gatk-hc` | 0 | No citations matched. Unmatched `gatk-haplotype-caller 4.6.2.0`. Quoted verbatim. |
| 6 | `lungfish-cli provenance bibliography $SP/assembly-spades/out-spades` | 0 | No citations matched. Unmatched `spades 4.3.0`. |
| 7 | `lungfish-cli provenance bibliography $SP/freyja/demix-run` | 0 | No citations matched. Unmatched `lungfish freyja demix lungfish-cli 2026.9.13`. |
| 8 | `lungfish-cli provenance bibliography $SP/kraken2` | 0 | No citations matched. Unmatched `lungfish extract reads Lungfish dev (0)`. |
| 9 | `lungfish-cli provenance bibliography $SP/rev-export` | 0 | No citations matched. Unmatched `lungfish genotype export-pivot-xlsx Lungfish dev (0)`. |
| 10 | `lungfish-cli provenance bibliography $SP/mapping` | 64 | `Error: Workflow execution failed: No Lungfish provenance sidecar found in <path>` |
| 11 | `lungfish-cli provenance bibliography $SP/workflow-builder` | 64 | Same error. |
| 12 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/bibliography.md` | 0 | `docs/user-manual/chapters/appendices/bibliography.md: no issues found` |

Verbatim output of run 3, which is what the chapter quotes.

```
Bibliography for bundle: <SP>/mapping/minimap2-out

- minimap2: Li H. Minimap2: pairwise alignment for nucleotide sequences. Bioinformatics. 2018. DOI: 10.1093/bioinformatics/bty191 https://github.com/lh3/minimap2
- SAMtools: Danecek P, Bonfield JK, Liddle J, et al. Twelve years of SAMtools and BCFtools. GigaScience. 2021. DOI: 10.1093/gigascience/giab008 https://www.htslib.org/
```

This is the same two-entry result the run-verified chapter `08-workflows/02-exporting-as-nextflow-or-snakemake.md` reports for the HG002 mapping run, so the two chapters agree.

Verbatim output of run 5.

```
Bibliography for bundle: <SP>/gatk-hc

No known tool citations were matched from this provenance record.

Tools without known citations
- gatk-haplotype-caller 4.6.2.0
```

The chapter reproduces both blocks with the scratch path shortened to `/Users/you/scratch/...`, since the real path is a session temp directory that no reader will have.

## Sources consulted

| Source | What it settled |
|---|---|
| `Sources/LungfishWorkflow/ToolReference/ToolBibliographyCatalog.swift` | The alias table itself. 29 `ToolCitation` entries, each with `id`, `displayName`, `aliases`, `citation`, optional `doi`, optional `url`. Also the matching algorithm (normalise to lowercase alphanumerics, exact alias match scores 0, substring either direction scores 1, shared token scores 2, best score wins, ties broken by display name) and the sort and dedup behaviour. |
| `Sources/LungfishCLI/Commands/ProvenanceCommand.swift`, `BibliographySubcommand` and `printBibliography` | Sidecar search order, the exact printed line shapes, the `Tools without known citations` heading, the `DOI: ` prefix, the space-joined DOI and URL suffix, and that a matched-nothing run still exits 0 while a missing sidecar throws `CLIError.workflowFailed`. |
| `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json` | Every version, pack id, and source URL in the four tables. Top-level `version` 2026.9.13, `dependencySet` 2026.2, `dependencySetDate` 2026-08-18, `bootstrap.micromamba.version` 2.9.0-0. |
| `docs/user-manual/chapters/appendices/tool-versions.md` | Cross-check. See the disagreement noted below. |
| `docs/user-manual/chapters/08-workflows/02-exporting-as-nextflow-or-snakemake.md` | The run-verified two-entry bibliography result and the fixed command-line opener paragraph. |
| `docs/user-manual/chapters/appendices/cli-reference.md` | That `provenance bibliography` has no menu equivalent, and the `/private/tmp` working-directory defect. |
| `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md` | Naming, the fixed Terminal opener, menu path form for the Plugin Manager. |
| `docs/user-manual/reviews/fidelity-2026-09/DRIFT.md`, lines 3217 to 3269 | The 9 changed rows and the 15 Missing rows, all applied. |
| `docs/user-manual/STYLE.md`, `ARCHITECTURE.md`, the persona file | Prose rules, chapter template, front matter schema. |

## Table rows and their sources

There are four tables, 51 data rows in total.

**Table 1, tools installed with every copy of LGE, 18 rows.** Seventeen come from the lock's `tools[]` array, one row per entry, with `version` and `sourceUrl` copied straight from it. The eighteenth is micromamba at 2.9.0-0, from the lock's `bootstrap.micromamba.version`, since micromamba is the bootstrap binary rather than a `tools[]` entry. DOIs and citation wording for Nextflow, Snakemake, BBTools, fastp, Deacon, SAMtools, BCFtools, HTSlib, SeqKit, Cutadapt, VSEARCH, pigz, SRA Tools, bedGraphToBigWig, and micromamba are quoted from the alias table's `citation` and `doi` fields. Trim Galore came from DRIFT's Missing row and the lock URL. pysam and openpyxl came from DRIFT's Missing row, and since neither has a paper the project URL from the lock is given as the citation.

**Table 2, plugin-pack tools, 23 rows.** One row per `packTools[]` entry in the lock, in lock order, with `version`, `packID`, and `sourceUrl` copied from it. minimap2, Bowtie 2, LoFreq, iVar, Medaka, and Kraken 2 quote the alias table. BWA-MEM2, MAFFT, and IQ-TREE take the corrected citations DRIFT rows 24, 27, and 28 specify. BLAST+, Bracken, Clair3, GATK4, WhatsHap, and Freyja take the citations DRIFT's Missing rows supply. Savont and EsViritu have no paper in either source, so the lock's project URL is the citation. SPAdes, MEGAHIT, SKESA, Flye, hifiasm, and RiboDetector are named by DRIFT's Missing rows without a citation string, so their canonical papers are given with DOIs.

**Table 3, pinned external pipelines, 2 rows.** From the lock's `pipelines[]`. viralrecon quotes the alias table verbatim including the Zenodo DOI. TaxTriage comes from DRIFT's Missing row, and the lock gives the repository, so the project page is the citation.

**Table 4, reference databases, 8 rows.** From the lock's `databases[]`, 16 entries collapsed to 8 rows by grouping the nine Kraken 2 builds that share a version and the two special builds that share theirs. Every version string is copied exactly.

## App defects found

These are LGE defects, found by running the command, and each is stated in the chapter's "Tools the command does not recognise" section.

1. **The alias table does not cover the tool set LGE ships.** Fourteen tools that LGE installs and runs have no entry, so a run using any of them produces an unmatched line rather than a citation. Missing entirely are Trim Galore, BLAST, Savont, Clair3, GATK4, WhatsHap, all five assemblers (SPAdes, MEGAHIT, SKESA, Flye, hifiasm), Bracken, EsViritu, RiboDetector, Freyja, and TaxTriage. Confirmed live for SPAdes (run 6), GATK4 (run 5), and Freyja (run 7). The GATK and assembly lanes are large enough that this will be noticed by anyone writing a methods section.
2. **Recorded step names do not resemble their tools, so even an added alias would miss.** GATK steps record as `gatk-haplotype-caller`, `gatk-joint-genotype`, `gatk-variant-filtration`, `gatk-variants-to-table`, `gatk-bqsr`, and `gatk-collect-metrics`. Freyja records as `lungfish freyja demix`. IQ-TREE records as `iqtree3`, which the alias table's `iqtree` entry does match by substring, so that one is fine. An alias table fix would need the wrapper spellings as well as the tool names.
3. **A matched-nothing run exits 0.** Runs 5 through 9 all printed no citations and still exited 0, so a script cannot use the exit status to detect that the bibliography is empty. Only a missing sidecar (runs 10 and 11) exits nonzero, with 64. The chapter warns readers to read the output rather than the status.
4. **The alias table's DOI for the tool LGE actually installs is wrong in one case, and stale in two.** The `bwa` entry cites Li and Durbin 2009 while LGE installs BWA-MEM2 2.3. The `mafft` entry cites Katoh 2002 while LGE installs MAFFT 7.526. The `iqtree` entry cites the 2015 IQ-TREE 1 paper while LGE installs IQ-TREE 3.1.3. These are the DRIFT rows 24, 27, and 28 corrections, and the chapter uses the corrected citations while keeping the originals as secondary references.
5. **Four tools carry alias table entries for tools LGE does not manage.** BEDTools, MultiQC, Pangolin, and Nextclade have entries and appear in no lock array. They reach a result only inside an external pipeline's own containers. DRIFT rows 26, 29, 30, and 31 asked for them to move to a clearly labeled section or be dropped. The chapter moves them into a paragraph under "Pinned external pipelines" that says plainly that LGE does not install, version, or manage any of the four.

## Documentation defect found, not fixed by me

`docs/user-manual/chapters/appendices/tool-versions.md` is stale against the lock it claims to be generated from. Its Managed Tools table gives Nextflow 25.10.4, Snakemake 9.19.0, BBTools 39.80, Fastp 1.3.2, Deacon 0.15.0, Samtools 1.23.1, BCFtools 1.23.1, HTSlib 1.23.1, and VSEARCH 2.30.5, while the lock at this commit gives 26.04.6, 9.25.2, 40.02, 1.3.6, 0.16.0, 1.24, 1.24, 1.24, and 2.31.0. It also omits Trim Galore. My brief said the bibliography table must agree with tool-versions.md, but the campaign's ground-truth order puts the lock above a committed chapter, so I followed the lock. tool-versions.md is its own roster row and has not been rewritten yet, and its rewrite should reconcile to the same lock. Until it does, the two appendices disagree on nine version numbers.

## What I could not verify

- **IQ-TREE 3's own citation.** DRIFT row 28 asked whether IQ-TREE 3 has published its own paper before finalising. I have no network access in this run and did not search. The chapter uses the IQ-TREE 2 paper and says in prose that this is worth rechecking before submission. This is DRIFT's first unverifiable item.
- **Whether every DOI resolves.** I did not resolve any DOI over the network. Every DOI in the chapter is either quoted from the alias table's `doi` field, copied from a DRIFT Missing row's supplied citation, or, for the six tools neither source covered (SPAdes, MEGAHIT, SKESA, Flye, hifiasm, RiboDetector), the canonical paper for that tool. None was invented or altered from what a source carried, and none of the alias table's DOIs was changed. The six unsourced ones are the second unverifiable item and should be checked by the reviewer.
- **The four container-only tools' real provenance appearance.** I have no viralrecon or TaxTriage run bundle in the scratch folders, so I could not confirm what step names BEDTools, MultiQC, Pangolin, or Nextclade record when they run inside a pipeline, or whether their steps reach LGE's sidecar at all. The chapter therefore says only that they reach a result through the pipeline's own containers and belong in a methods section when the pipeline says so.
- **The GUI.** This command has no menu equivalent, confirmed by the CLI reference and the workflows chapter, so there was nothing to check in the app window.

## Glossary

Three terms added to `docs/user-manual/GLOSSARY.md`, alphabetically, in the file's existing entry shape, and listed in the chapter's `glossary_refs`.

- **Alias table** `{#alias-table}`, inserted after Alias map.
- **Citation** `{#citation}`, inserted before Clade.
- **DOI** `{#doi}`, inserted before Download Center.

`glossary_refs` also cites four terms that already existed, namely dependency-set, plugin-pack, provenance, and provenance-sidecar. Linting GLOSSARY.md reports one sentence-colon warning per entry from the file's standing `See also:` shape, 428 in total across 348 entries, and my three entries each contribute exactly one of those, so they match the file's established form.

## Lint

```
docs/user-manual/chapters/appendices/bibliography.md: no issues found
```

One structural note on how that was reached. The sentence-colon rule counts colons inside every table cell, and a published article title such as "fastp: an ultra-fast all-in-one FASTQ preprocessor" carries one. Altering a published title to satisfy a prose rule would be worse than the warning, so the citation strings moved out of the tables into fenced code blocks beside them, where they are transcribed exactly and the rule does not apply. The tables keep tool, version, pack, and DOI. The rule also counts the `:` in a Markdown right-alignment marker (`|---|---:|---|`), so those were changed to plain `|---|---|---|`.
