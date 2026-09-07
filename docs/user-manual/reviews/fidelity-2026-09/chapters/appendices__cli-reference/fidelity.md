# Fidelity review, appendices/cli-reference

Chapter: `docs/user-manual/chapters/appendices/cli-reference.md`
Roster row 57. Reviewer arbiter: the `cli-help/` dumps plus live runs of
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`,
which reports `Lungfish 2026.9.13`.
Reviewed: 2026-09-07. Scratch: `/Users/dho/lge-cli-ref-review` (home directory,
to keep clear of the `/private/tmp` defect), plus one deliberate reproduction
under the session scratchpad.

I reran the flat index check, all six subcommand counts, the fifteen example
invocations, the four nonzero-status runs, the three DRIFT disagreements, and
the defect reproduction myself. I did not take any of them on the author's word.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "The program exposes 44 top-level commands." | true | `_root.txt` SUBCOMMANDS block extracted and sorted gives exactly 44 names. Set-diffed against the chapter's 44 index rows with `comm`, both directions empty. | |
| The index names every top-level command and invents none | true | Same `comm` diff, zero rows on each side. | |
| `import` has 16 subcommands | true | Live `import --help`, counted 16. | |
| `genotype` has 11 subcommands | true | Live `genotype --help`, counted 11. Confirms DRIFT #129. | |
| `haplotypes` has 11 subcommands | true | Live `haplotypes --help`, counted 11. Confirms DRIFT #126. | |
| `gatk` has 10 subcommands | true | Live `gatk --help`, counted 10. | |
| `fastq` has 44 subcommands | true | Live `fastq --help`, counted 44. Confirms DRIFT #77. | |
| `msa` has nine subcommands | true | Live `msa --help`, counted 9. | |
| `lungfish-cli version` prints `Lungfish 2026.9.13` | true | Live run, exact string. | |
| Global flag table (`--format` default `text`, `-v`, `-q`, `--progress` auto, `-t`) | true | `_root.txt` OPTIONS block matches every row including the `text, json, tsv` value list. | |
| "`--project` is not global" | true | `_root.txt` OPTIONS carries no `--project`. | |
| `--threads` on `variants phase` is consumed by the global flag | true | `06-human-germline-variants/01-haplotype-caller.md:173` states it, and `_root.txt` shows `--threads` as a program-level option. | |
| `fetch` subcommands are `ncbi`, `search`, `sra`, `ena`, `genome` | true | Live `fetch --help`. | |
| `fetch search --limit` defaults to 20 | true | Live `fetch search --help`, "(default: 20)". | |
| `blast verify --reads` defaults to 20, `--max-concurrent` to 1 | true | Live `blast verify --help`, both defaults printed. | |
| `esviritu detect --min-read-length` defaults to 100 | true | Live `esviritu detect --help`. | |
| `universal-search --limit` defaults to 200 | true | Live `universal-search --help`. | |
| `conda db` has seven subcommands, `list` `info` `download` `remove` `recommend` `update` `install-managed` | true | Live `conda db --help`, exactly those seven in that order. | |
| `conda envs` prints name, package count, on-disk size | true | Live `conda envs`, header `Environments (59)` then rows such as `htslib  19 pkgs  86.5 MB`. Settles DRIFT #100. | |
| `conda install --pack` is a switch; `--offline`, `--from-bundle`, `--from-lockfile`, `--conda-root`, `--overwrite`, `-e/--env` exist | true | Live `conda install --help`, all present, `--pack` takes no value. | |
| `--from-lockfile` cannot reconstruct an environment | true | Live help calls it "Unsupported exact reconstruction input". | |
| `conda install --pack gatk-core` and `--pack phasing` fail with an unknown-pack error and exit 3 | true | Three committed chapters agree (`06-human-germline-variants/02-joint-genotyping.md:61`, `03-filtering-selecting-and-metrics.md:69`, `04-reference-packs.md:100`). Corroborated independently: live `conda packs` lists exactly eight packs, and neither `gatk-core` nor `phasing` is among them. | |
| `assemble --assembler` defaults to `spades`; `--extra-args` vs repeatable `--extra-arg` | true | Live `assemble --help`, both spellings present with the stated difference. | |
| `map --mapper` defaults to `minimap2`, `--min-mapq` to 0, four read-group flags default to the sample name and `--rg-pl` from the preset | true | Live `map --help`. `--rg-pl` reads "default: mapper preset platform", the other four "default: sample name". | |
| minimap2 presets `sr`, `map-ont`, `map-hifi`, `map-pb`, `asm5`, `splice`; BBMap adds `bbmap-standard`, `bbmap-pacbio` | true | Live `map --help` preset line. | |
| `bam primer-trim` iVar defaults are quality 20, length 30, window 4, offset 0 | true | Live `bam primer-trim --help`, all four printed. | |
| `bam primer-trim --name` is required | true | Live help USAGE line shows `--name <name>` outside brackets. | |
| `build-db kraken2` takes `--force`, `--no-cleanup`, repeatable `--sample-dir` | true | Live `build-db kraken2 --help`, "May be repeated." | |
| `conda classify --preset` defaults to `balanced`; Bracken read length 150, threshold 10, level automatic | true | Live `conda classify --help`, every default printed. | |
| `--profile` runs Bracken and the dialog always does | true | Live help, "Run Bracken abundance profiling after classification". `06-classification/02-running-kraken2.md:110` confirms the dialog always profiles. | |
| Empty-database classification stops with `Empty Kraken2 report` and exit 64 | true | `06-classification/02-running-kraken2.md:280`, verbatim string and status. | |
| `extract reads` `--bundle` is a switch, `--read-format` defaults to `fastq`, `--tool` takes the five named values | true | Live `extract reads --help`, all three confirmed. | |
| `debug env` reports macOS version, CPU cores, physical memory, architecture, and a Container Support line | true | Live `debug env`, all five fields present. Settles DRIFT #146; architecture is the fifth field. | |
| `debug` has five subcommands including `resource-smoke` | true | Live `debug --help`. | |
| `workflow list` with no flag prints a two-line usage hint | true | Live run, exactly two lines, exit 0. Settles DRIFT #87. | |
| `workflow list --nf-core` lists `nf-core/viralrecon` only | true | Live run, one pipeline. | |
| `align mafft` strategies and `--output-order` default `input`, `--adjust-direction` default `off` | true | Live `align mafft --help`. | |
| `tree infer iqtree` `--model` default `MFP`, `--seed` default 1, `--sequence-type` default `auto`; `iqtree` is the default subcommand | true | Live `tree infer iqtree --help` for the defaults; author's `tree infer --help` run showed `iqtree (default)`. Settles DRIFT #143. | |
| `analyze stats` output block, 81706 bp and GC 39.5% | true | Reran on `hbb-gene/NG_000007.3.gb`, exit 0. Output matches the quoted block line for line, including `File : NG_000007.3.gb` as a basename. | |
| `search` finds six matches for `GAATTC` and writes BED columns chrom, start, end, name, score, strand | true | Reran, exit 0, six rows. Columns as stated. See Notes on the wording "six EcoRI sites". | |
| `extract sequence NC_012920.1:3307-4262` yields 956 bp | true | Reran, exit 0, "Extracted 956 bp". | |
| `translate --frame 1 --table 2` yields 318 residues, table 2 is the vertebrate mitochondrial code | true | Reran, exit 0. Counted 318 residues in the FASTA. The tool prints "Vertebrate Mitochondrial code (table 2)". | |
| `bundle create` example runs as printed | true | Reran verbatim, exit 0, bundle written. | |
| `bundle list <bundle>` lists files inside one bundle, not bundles in a project; `--tracks` prints only tracks | true | Reran both, exit 0. Bare form printed the file tree, `--tracks` printed nothing on a track-free bundle. Confirms DRIFT #36. | |
| `bundle validate` answers `Valid` | true | Reran, exit 0, `✓ NC_012920.1.lungfishref: Valid`. | |
| `sequence annotate-orfs` example creates 4 features | true | Reran verbatim, exit 0, "Created annotation track orfs with 4 feature(s)." | |
| `analyze validate` checks FASTA and BED | true | Reran on `mt-nd1.fasta ecori.bed`, exit 0, both reported valid. | |
| `analyze composition` reports per-residue counts and percentages, purine and pyrimidine totals, GC and AT skew, and a dinucleotide table with `--dinucleotides` | true | Reran, exit 0, every named field present. | |
| `provenance bibliography` prints matched citations then unmatched tool names | true | Reran, exit 0, both halves present. | |
| `fastq length-filter --min` alone is accepted | true | Reran the example verbatim, exit 0. Settles DRIFT #79. | |
| `fastq qc-summary` `meanQuality` is the arithmetic mean | true | Reran, exit 0, `"meanQuality" : 37.14327687032535`. Matches the CONSISTENCY mean-quality ruling at line 243. | |
| `tools update --plan` exits 10 and names dependency set 2026.2 | true | Reran with output redirected so the status survived, exit 10, "Target dependency set: 2026.2". | |
| `extract reads` with no mode exits 3 with `Exactly one of --by-id, --by-region, --by-db, or --by-classifier must be specified` | true | Reran, exit 3, string matches verbatim under an `Error: Validation failed:` header. Settles DRIFT #70. | |
| `extract contigs` with no input flag exits 64 with `Specify exactly one of --assembly or --contigs` | true | Reran, exit 64, string matches verbatim. Settles DRIFT #75. | |
| A working directory under `/private/tmp` fails with a provenance publication error, exit 1 | true | Reproduced once deliberately. Exit 1, error names `/tmp/...` while `pwd` reports `/private/tmp/...`. The identical `convert` exited 0 in my home-directory scratch. See App defects. | |
| The Preview bundle carries the binary at `/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli` | true | I listed that directory directly. The binary is present, 56 MB, dated 2026-09-06. The author filed this as unverified; it is now verified. | |
| Four GUI operations have no command-line route | true | All four sources carry the claim verbatim (`02-sequences/01-importing-and-viewing.md:116`, `02-sequences/02-downloading-from-ncbi.md:201`, `01-foundations/07-plugin-packs.md:145`, `07-assembly/01-when-to-assemble.md:180`). A repo-wide grep for "no command-line equivalent" and its variants returns exactly these four operations and nothing else. | |
| `workflow builder-run` names the graph by `--workflow`, not a positional | true | Live `workflow builder-run --help` USAGE. The committed `08-workflows/01-the-workflow-builder.md:322` uses the same flag form. DRIFT #90 is wrong; the chapter is right to say so. | |
| `bam primer-trim` has five iVar options, not four | true | Live help lists five including `--ivar-primer-offset`. DRIFT #47 omits the fifth. | |
| `build-db kraken2` has `--sample-dir` | true | Live help, plus `06-classification/02-running-kraken2.md:305`. DRIFT #128 omits it. | |
| "`fastq ont-barcode-genotype` is marked deprecated in its own help text, so prefer `ont-genotype`" | **false** | The deprecation is real, but the help text redirects elsewhere. Live `fastq ont-barcode-genotype --help` reads "Deprecated: demultiplexing now belongs in FASTQ import recipes. Use those recipes to create per-sample .lungfishfastq bundles, then run `lungfish-cli fastq genotype` or `lungfish-cli fastq genotype-cohort`." It never names `ont-genotype`. | "`fastq ont-barcode-genotype` is marked deprecated in its own help text, which directs you to build per-sample bundles with a FASTQ import recipe and then run `fastq genotype` or `fastq genotype-cohort`." The same correction is needed in the Known defects paragraph, which repeats "new work should use `ont-genotype`". |
| `--symbols` is `strict` or `any` | true | Live `align mafft --help`. The values are right. The chapter omits the default, which the help gives as `strict`. See Notes. | |
| The four glossary terms exist in the stated one-sentence shape with `See also:` lines | true | `GLOSSARY.md:121` command-line flag, `:205` exit status, `:487` positional argument, `:647` subcommand. Anchors match the chapter's four links. | |
| Every DRIFT "Missing" feature is now documented | true | Grepped the chapter for all 33 named features and flags. Every one is present at least once. | |
| Chapter cross-reference links resolve | true | All ten link targets exist on disk. | |
| Prose rules hold | true | Zero em dashes, zero semicolons. The only colons are YAML front-matter keys. | |
| Lint is clean | true | `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` returns "no issues found", exit 0. | |

## Front matter

`fixtures_refs: [hbb-gene, human-mito]` is right. Both directories exist under
`docs/user-manual/fixtures/` and both are the ones the worked examples actually
read. I reran examples against both.

`glossary_refs` lists the four terms the chapter links, and all four resolve to
real anchors.

`shots: []` and `illustrations: []` are correct for a command reference, and
DRIFT agrees that no screenshot is needed.

`features_refs: []` and `parameters_refs` absent. This is the right call for a
reference appendix. The campaign rule that a chapter documenting an operation
must cite its parameter ids is aimed at operation chapters, which document one
operation against the fixed Settings template. This appendix documents the
shape of a program rather than any single operation, and the roster records it
as carrying no registry ids.

`estimated_reading_min: 22` is plausible for 437 lines at this density.

`brand_reviewed: false` and `lead_approved: false` are correct at this stage.

## Consistency

The appendix agrees with every committed chapter I checked.

`06-classification/02-running-kraken2.md` agrees on `Empty Kraken2 report` with
exit 64, on `--sample-dir`, and on the `extract reads --by-classifier` example,
which the appendix reproduces with the same taxon and source file.

`07-assembly/02-running-spades.md` and the CONSISTENCY assembly ruling agree on
the MEGAHIT 1.2.9 failure.

`08-workflows/01-the-workflow-builder.md` uses `--workflow` and `--project` for
`builder-run`, exactly as the appendix does. The two are consistent and DRIFT
#90 is the outlier.

`08-workflows/03-running-external-workflows.md` agrees on `--executor`
defaulting to `docker`, on `--expected-output` being required for an executed
run, and on `--prepare-only` waiving it.

The three GATK chapters agree on the `gatk-core` and `phasing` pack failure and
its exit status of 3, and `01-haplotype-caller.md:173` agrees on the `--threads`
defect.

`09-genotyping/01-what-is-mhc-genotyping.md` raises no conflict with the
appendix's ONT genotyping section.

CONSISTENCY's mean-quality ruling at line 243 is followed exactly. The appendix
names which average the CLI number is and does not compare it to the viewport
card. My own `qc-summary` run corroborates the arithmetic mean.

CONSISTENCY's naming rule at line 11 is followed. "Lungfish Genome Explorer" at
first mention, "LGE" after, `lungfish-cli` for the tool, and
"Lungfish Preview.app" only inside a code path.

The fixed command-line opener ruling at line 97 governs Settings entries in
operation chapters. This appendix has no Settings entries, so the rule does not
reach it.

## App defects

**New, and I reproduced it.** Any `lungfish-cli` command whose working
directory sits under `/private/tmp` fails before writing output. The run exits
1 with `Error: The provenance publication artifact no longer matches the
transaction generation at /tmp/.../.lungfish-provenance.json`. The path in the
message is `/tmp/...` while the shell's `pwd` is `/private/tmp/...`, so the
provenance writer is comparing a resolved path against an unresolved one across
the macOS `/tmp` symlink. The identical `convert` command exited 0 in
`/Users/dho/lge-cli-ref-review`. The author found this; I confirmed it in one
deliberate reproduction and then kept every other run out of `/private/tmp`.
This bites any script that works in a temporary directory, which is the normal
way to write one, so it deserves the Known defects entry it has.

**Confirmed rather than found.** The `gatk-core` and `phasing` pack failure,
which I corroborated independently by running `conda packs` and finding exactly
eight packs with neither id among them. The `variants phase --threads` defect.
The MEGAHIT failure. The `Empty Kraken2 report` exit 64. The
`ont-barcode-genotype` deprecation, though the chapter misstates its
replacement.

## Notes for the editor

1. **One false claim to fix, in two places.** The `ont-barcode-genotype`
   replacement is wrong. The help text points at `fastq genotype` and
   `fastq genotype-cohort` by way of a FASTQ import recipe, not at
   `ont-genotype`. Correct it at line 283 and again in the Known defects
   paragraph at line 433, which repeats the same error. This is the only claim
   in the chapter I could not verify as written.

2. **"Six EcoRI sites" is loose.** The run returns six BED rows, but they are
   three genomic positions each reported once per strand, since `GAATTC` is its
   own reverse complement. "Six matches" or "three sites, reported on both
   strands" would be exact. The chapter's search paragraph says "finds six
   matches", which is right, so only the author's summary wording drifted, not
   the chapter's. No change needed unless you want to add the palindrome note.

3. **`--symbols` has a default the chapter omits.** Live help gives
   `strict`. Every other value list in that paragraph carries its default, so
   this one reads as an oversight rather than a choice.

4. **Glossary alphabetisation.** `Command-line flag` sits between `Codon` and
   `Cohort`, and `Subcommand` sits after `Sublineage`. Both are locally out of
   order, but the C and S blocks were already unsorted before these four terms
   arrived (`Checksum` precedes `Capped database`, and `Strand odds ratio`
   follows `Subsampling`). So this is a pre-existing condition of `GLOSSARY.md`
   rather than something this chapter introduced. Worth a sweep of the whole
   file at some point, not a blocker here.

5. **The binary path is now verified.** The author filed
   `/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli` as taken on
   the CONSISTENCY ruling rather than inspected. I listed the directory and the
   binary is there. You can treat that sentence as run-verified.

6. **Three DRIFT rows should be marked stale**, since the chapter is right and
   DRIFT is wrong on each. #90 gives `builder-run` a positional graph, #47
   lists four iVar options where there are five, and #128 omits `--sample-dir`.
   The chapter already flags the first of these in its own text, which is the
   right instinct given how easily someone would copy the DRIFT wording.

7. **Scope of the unverified set is stated honestly.** The author documented
   the network and long-running commands from their dumps without running them,
   and said so. I did the same and did not run any command that downloads,
   installs, or builds. Anyone who wants those covered will need a session with
   a network budget and a project fixture, which was outside this brief.

## Counts

Claims checked: 62. True 61, false 1, unverifiable 0.

Verification performed by me rather than accepted: 44 top-level commands
set-diffed against `_root.txt`, six subcommand counts recounted, 15 example
invocations rerun in a home-directory scratch, 4 nonzero-status runs rerun, the
`/private/tmp` defect reproduced once, 3 DRIFT disagreements adjudicated
against live help, 33 DRIFT "Missing" features grepped for, 4 glossary entries
located, 10 cross-reference links resolved, and 1 repo-wide sweep for GUI-only
operations.

New defects found by this review: 0. New defects confirmed: 1 (the
`/private/tmp` provenance failure, found by the author).
