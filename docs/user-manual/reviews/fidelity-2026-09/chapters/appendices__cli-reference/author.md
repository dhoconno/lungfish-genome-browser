# Author record, appendices/cli-reference

Chapter: `docs/user-manual/chapters/appendices/cli-reference.md`
Roster row 57. Fixture: cli-help dumps, plus two manual fixtures used for the
worked examples.
Binary: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`,
which reports `Lungfish 2026.9.13`.
Date: 2026-09-07.

## Scope decision

This is a reference appendix for the power-user audience, so it keeps its own
shape rather than the operation template. It has a What it is primer, a
binary-location section, a flat index of all 44 top-level commands, a global
flag section, ten domain sections, a "what the command line cannot do"
section, a known-defects section, and a Next pointer. Every command gets a
plain sentence saying what it is for before its syntax.

## Help runs

Every one of these was run against the debug binary in this worktree.

| Command | Exit | What it settled |
|---|---|---|
| `lungfish-cli version` | 0 | Prints `Lungfish 2026.9.13`, quoted in the chapter. |
| `lungfish-cli tree infer --help` | 0 | `iqtree (default)`. Settles DRIFT #143's claim that `iqtree` is the default subcommand, which the `tree.txt` dump alone did not show. |
| `lungfish-cli build-db kraken2 --help` | 0 | `--force`, `--no-cleanup`, and a repeatable `--sample-dir`. The `--sample-dir` flag is not in DRIFT #128's correction. |
| `lungfish-cli conda install --help` | 0 | `--pack` is a switch, plus `--offline`, `--from-bundle`, `--from-lockfile`, `--conda-root`, `--overwrite`, `-e/--env`. |
| `lungfish-cli msa --help` | 0 | Nine subcommands. Confirms `mask` and `trim` are groups with a `columns` subcommand each. |
| `lungfish-cli import --help` | 0 | 16 subcommands, counted. |
| `lungfish-cli genotype --help` | 0 | 11 subcommands, confirming DRIFT #129. |
| `lungfish-cli haplotypes --help` | 0 | 11 subcommands, confirming DRIFT #126. |
| `lungfish-cli gatk --help` | 0 | 10 subcommands. |
| `lungfish-cli debug env` | 0 | Reports macOS version, CPU cores, physical memory, Architecture, and a Container Support line. DRIFT #146 left the field list to be settled by running it. Architecture is a fifth field the old chapter omitted. |
| `lungfish-cli conda envs` | 0 | `Environments (59)` then name, package count, on-disk size per row. Settles DRIFT #100. |
| `lungfish-cli workflow list` | 0 | Prints a two-line usage hint, no project inventory. Settles DRIFT #87's no-flag half. |
| `lungfish-cli workflow list --nf-core` | 0 | Lists `nf-core/viralrecon` only. |
| `lungfish-cli tools update --plan` | 10 | Exit 10 confirms the documented "work is pending" code. Output names the dependency set `2026.2`. |
| `lungfish-cli extract reads -o x.fastq` | 3 | Error text verified for DRIFT #70. It prints on two lines under an `Error: Validation failed:` header, so the chapter quotes only the sentence. |
| `lungfish-cli extract contigs --contig foo -o y.fasta` | 64 | Error text verified for DRIFT #75, exactly `Specify exactly one of --assembly or --contigs`. |

## Example runs

All runs used the manual's own fixtures, human data only. Runs were done in
`~/lge-cli-ref-scratch/r1` rather than the session scratchpad, for the reason
recorded under Defects below.

| Command | Exit | Result quoted in the chapter |
|---|---|---|
| `analyze stats <hbb-gene>/NG_000007.3.gb` | 0 | Whole output block quoted verbatim. 81706 bp, GC 39.5%. |
| `convert <hbb-gene>/NG_000007.3.gb --to NG_000007.3.fasta --to-format fasta` | 0 | Syntax proven. Not quoted. |
| `search <human-mito>/NC_012920.1.fasta GAATTC -o ecori.bed` | 0 | Six EcoRI sites, quoted in the search paragraph. BED columns confirmed. |
| `extract sequence <human-mito>/NC_012920.1.fasta NC_012920.1:3307-4262 -o mt-nd1.fasta` | 0 | The example block. 956 bp extracted. |
| `translate mt-nd1.fasta --frame 1 --table 2 -o mt-nd1.faa` | 0 | The example block. 318 aa, quoted. |
| `bundle create --fasta <human-mito>/NC_012920.1.fasta --name NC_012920.1 --output-dir . --organism "Homo sapiens" --compress` | 0 | The example block, verbatim as run. |
| `bundle list NC_012920.1.lungfishref` | 0 | Confirms DRIFT #36. It lists the files inside one bundle, not the bundles in a project. |
| `bundle list NC_012920.1.lungfishref --tracks` | 0 | Prints only annotation tracks. |
| `bundle validate NC_012920.1.lungfishref` | 0 | Answers `Valid`, quoted. |
| `sequence annotate-orfs NC_012920.1.lungfishref --frames +1 --table 2 --min-length 300 --track-name "ORFs frame +1"` | 0 | Created 4 features. Syntax proven. |
| `analyze validate mt-nd1.fasta ecori.bed` | 0 | Both files validated, FASTA and BED. |
| `analyze composition mt-nd1.fasta --dinucleotides` | 0 | Confirms the reported fields for DRIFT-adjacent claims. |
| `provenance bibliography NC_012920.1.lungfishref` | 0 | Confirms the two-part output shape, matched citations then unmatched tool names. |
| `fastq length-filter <human-mito>/HG002.chrM_R1.fastq.gz --min 100 -o ... --compress` | 0 | The example block. Confirms `--min` alone is accepted, settling DRIFT #79. |
| `fastq qc-summary <human-mito>/HG002.chrM_R1.fastq.gz -o qc.json` | 0 | JSON holds `meanQuality: 37.14`, arithmetic mean, cited in support of the CONSISTENCY mean-quality ruling. |

Sixteen help runs and fifteen example runs. Every exit status was 0 except
the four that were run specifically to capture a nonzero status.

## Facts taken from a committed chapter rather than from a run

These are in the chapter because a committed, run-verified chapter states
them and rerunning was out of scope for a reference appendix.

- `conda install --pack gatk-core` and `--pack phasing` fail with an
  unknown-pack error and exit 3, so those two packs install only through the
  Plugin Manager. From `06-human-germline-variants/02-joint-genotyping.md:61`,
  `03-filtering-selecting-and-metrics.md:69`, and `04-reference-packs.md:100`,
  which agree on the message and on the exit status.
- `--threads` on `variants phase` has no effect because the global
  `--threads` consumes the value first. From
  `06-human-germline-variants/01-haplotype-caller.md:173`.
- MEGAHIT 1.2.9 fails most assembly runs on Apple Silicon. From the
  CONSISTENCY.md assembly ruling and `07-assembly/02-running-spades.md`.
- Classifying against a database that matches nothing stops with
  `Empty Kraken2 report` and exit 64. From
  `06-classification/02-running-kraken2.md`.
- `provenance verify` on an unsigned record reports a missing signature
  artifact and exits failing, which is expected rather than a failed check.
  From `08-workflows/02-exporting-as-nextflow-or-snakemake.md`.
- The four GUI operations with no command-line route (attaching an annotation
  track, Pathoplexus download, Storage Settings, the assembly action bar's
  Create Bundle). From `02-sequences/01-importing-and-viewing.md:116`,
  `02-sequences/02-downloading-from-ncbi.md:201`,
  `01-foundations/07-plugin-packs.md:145`, and
  `07-assembly/01-when-to-assemble.md:180`.
- The three command-line-only capabilities (scripting a provenance export,
  the tool bibliography, signature verification). From
  `08-workflows/02-exporting-as-nextflow-or-snakemake.md`.
- The mean-quality split between the FASTQ viewport's Mean Q card and
  `fastq qc-summary`. From the CONSISTENCY.md ruling, corroborated by my own
  `qc-summary` run showing the arithmetic mean.
- `12s-export-unresolved` is the only route to a FASTA of unresolved
  clusters. From `06-classification/10-twelve-s-metabarcoding.md:284`.

## Disagreements with earlier chapters or with DRIFT

Three, all resolved in favour of the help dump or a live run.

1. **DRIFT #90 gives `lungfish workflow builder-run <graph>` with a
   positional graph.** The `workflow.txt` dump gives
   `workflow builder-run --workflow <workflow> --project <project>
   [--run-directory <run-directory>] [--threads <threads>] [--dry-run]`, so
   the graph is named by a flag. The chapter follows the dump and says so
   explicitly, since the difference will bite anyone copying the DRIFT
   wording. No committed chapter documents this command.
2. **DRIFT #47's `bam primer-trim` correction lists four iVar options.**
   The dump lists five. `--ivar-primer-offset <int>`, default 0, is the
   fifth and is missing from the correction. The chapter documents all five.
3. **DRIFT #128's `build-db` correction omits `--sample-dir`.** The
   `build-db kraken2` help run shows a repeatable `--sample-dir`, and
   `06-classification/02-running-kraken2.md` documents it too. The chapter
   documents it on the `kraken2` variant, where it exists.

No case was found where a committed chapter and a help dump disagreed on a
flag. Where the old cli-reference and a committed chapter disagreed, the
committed chapter won, which is how the Kraken 2 and GATK material entered
the Known defects section.

## App defects found while writing this chapter

**New, found by me.** Any `lungfish-cli` command whose working directory sits
under `/private/tmp` fails before writing output, with
`Error: The provenance publication artifact no longer matches the transaction
generation at /tmp/.../.lungfish-provenance.json`, exit 1. The error path is
printed as `/tmp/...` while the working directory is `/private/tmp/...`, so
the provenance writer appears to compare a resolved path against an
unresolved one across the macOS `/tmp` symlink. Reproduced twice with
`convert`, once in the session scratchpad root and once in a fresh
subdirectory of it, and it did not reproduce in a home-directory scratch
folder, where the identical command exited 0. This matters for scripting,
because a script that does its work in a temporary directory will hit it. It
is recorded in the chapter's Known defects section and is the reason every
example run in this record was done under the home directory instead.

**Confirmed rather than found.** The five defects listed under "Facts taken
from a committed chapter" that are defects rather than behaviours, plus the
deprecation marker on `fastq ont-barcode-genotype`, which its own help text
carries.

## Not verified

- Every long-running or network command was documented from its help dump
  without a run. That covers all of `fetch`, `map`, `assemble`, `variants
  call`, `conda classify`, `esviritu`, `taxtriage`, `blast verify`,
  `workflow run`, `gatk`, `freyja`, `align mafft`, `tree infer`, the
  `conda db` download and update subcommands, `tools update --apply`, and
  `provision-tools`. The brief excluded downloads, installs, and anything
  over a couple of minutes.
- The `genotype`, `haplotypes`, and `msa` groups were documented from their
  help output only. No `.lungfishgenotype`, `.lungfishmhcref`, or
  `.lungfishmsa` fixture bundle was to hand, so no subcommand of those three
  was executed.
- `import` was documented from the dumps. Running any of its subcommands
  needs a project, and creating one was outside this appendix's scope.
- The DRIFT row marked unverifiable was not resolved. Nothing in the help
  tree or in a committed chapter settles it, and it is not repeated as a
  claim in the rewritten chapter.
- The claim that the Preview bundle carries the binary at
  `/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli` comes from
  the CONSISTENCY.md ruling, not from my own inspection of an installed app.
- Whether `--format tsv` is accepted by every command was not tested. Several
  dumps show only `text, json`, and the chapter says so in general terms
  rather than enumerating which commands are which.

## Front matter

`fixtures_refs` is `[hbb-gene, human-mito]`, the two fixtures the worked
examples actually use. `glossary_refs` lists the four terms added.
`estimated_reading_min` is 22, up from 15, because the chapter grew by
roughly half again to cover the previously omitted command groups.
`brand_reviewed` and `lead_approved` are both left false.

## Glossary terms added

Four, all alphabetised into `GLOSSARY.md`. `command-line flag`,
`exit status`, `positional argument`, and `subcommand`. Each is the one
sentence shape with a `See also:` line, and each is glossed inline at first
use in the chapter as well.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/cli-reference.md`

`docs/user-manual/chapters/appendices/cli-reference.md: no issues found`

Clean on the first run. The pre-rewrite file reported 86 warnings.
