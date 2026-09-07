# Fidelity review, 06-human-germline-variants/03-filtering-selecting-and-metrics

Roster row 44. Registry id `variants.gatk-plans`. Reviewed 2026-09-07 against
Preview 2026.9.13, `Sources/`, `cli-help/gatk.txt`, `parameters.yaml`, and the
author's scratch outputs at
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/gatk-filter/`.

Every count in the chapter was re-measured from the author's retained artifacts
rather than taken from the author record. Every preview command was re-run
against the live binary at
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.
Nothing was written to the fixture tree or to `~/Desktop/lge-docs/`.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "Every operation in this chapter runs from the command line ... LGE has no dialog and no menu item for any of the five" | true | `grep` for `VariantFiltration`, `SelectVariants`, `VariantsToTable`, `LeftAlignAndTrim`, `CollectVariantCallingMetrics` across `Sources/LungfishApp/` and `Sources/LungfishKit/` returns 0 hits. `BAMVariantCallingCatalog.swift:9-16` lists seven callers, none of them these five | |
| Step 1 preview quoted verbatim, all ten `--filter-expression`/`--filter-name` pairs in that order | true | Re-run live. Output matches the quoted line token for token, including the `QD2` duplicate. Backed by `GATKCommandBuilder.swift:144-158` | |
| "`QD2` appears twice ... the SNP list followed by the indel list, and both lists open with the same quality-by-depth test" | true | `GATKCommandBuilder.swift:137-138` concatenates `snpFilters + indelFilters`; `:145` and `:154` are both `QD2`/`QD < 2.0` | |
| The six SNP expressions and four indel expressions as printed | true | `GATKCommandBuilder.swift:144-151` (QD2, FS60, MQ40, MQRankSum-12.5, ReadPosRankSum-8, SOR3) and `:153-158` (QD2, FS200, ReadPosRankSum-20, SOR10) | |
| "It prints two lines when it finishes" (`exit code 0.` plus `Provenance:`) | true | Author record command 2. Root sidecar present and well formed | |
| "The filter changes no row count at all ... 1,026 rows and came out with 1,026" | true | Re-measured: raw 1026, filtered 1026 | |
| FILTER table: `PASS` 1,013, `SOR3` 12, `QD2` 2 | true | Re-measured tally on `cohort.filtered.vcf.gz`: 1013 PASS, 12 SOR3, 2 QD2 | |
| "add to 14 rather than 13 because one row failed both tests and carries `QD2;SOR3`" | true | Re-measured: 13 distinct non-PASS rows, position 496668 carries `QD2;SOR3` | |
| "13 distinct rows out of 1,026 were marked, or 1.3 percent" | true | 13/1026 = 1.267 percent, rounds to 1.3 | |
| "The recorded run's two `QD2` rows had quality scores of 32.64 and 32.6" | true | Re-measured: positions 378270 (QUAL 32.64) and 496668 (QUAL 32.60) | |
| "The output also carries a full set of `##FILTER` header lines, one per test" | **false** | The filtered VCF holds 10 `##FILTER` lines, but one is `LowQual` carried over from the caller, so only 9 describe tests. The 10 expressions collapse to 9 unique names because `QD2` is duplicated. "One per test" is wrong in both directions at once | "The output also carries a `##FILTER` header line for each distinct test name, nine in all, because the duplicated `QD2` is declared once. A tenth line, `LowQual`, came from the caller rather than from this step." |
| "A reader who receives the file six months later can find out what `SOR3` meant without asking you" | true | `##FILTER=<ID=SOR3,Description="SOR > 3.0">` present in the header | |
| "`select` ... pulled 842 SNP rows and 182 indel rows out of the 1,026, and a third run with `--type MIXED` pulled the remaining 2" | true | Re-measured: SNP file 842 rows, indel file 182 rows. 842+182+2 = 1026 | |
| "GATK puts every row in exactly one class" | true | Author's `comm` check (command 10) plus the exact partition arithmetic re-verified here | |
| "the SNP file holds 836 `PASS` rows and the indel file 175" | true | Re-measured: SNP 836 PASS / 1 QD2 / 5 SOR3; indel 175 PASS / 6 SOR3 / 1 `QD2;SOR3` | |
| "`leftalign` with `--split-multi-allelics` ... from 1,026 to 1,045" | true | Re-measured: leftaligned file holds 1045 rows | |
| "All 19 of the input's multi-allelic rows became two rows each, and none remained" | true | Re-measured: 19 comma-bearing ALT rows in the filtered file, 0 in the leftaligned file. 1026 + 19 = 1045 | |
| Position 29,224 read `A` to `G,AGG` before and `A` to `G` plus `A` to `AGG` after | true | Re-measured on both files, exactly as quoted | |
| "`variants-to-table` produced 1,013 data rows from a 1,026-row input" | true | Re-measured: `cohort.table.tsv` holds 1013 data rows | |
| "`VariantsToTable` drops filtered rows by default ... add `--extra-args "--show-filtered"`, which a recorded run confirmed by producing all 1,026" | true | Re-measured: `cohort.all.tsv` holds 1026 data rows | |
| Default seven columns and the quoted first data row | true | Re-measured header `CHROM POS REF ALT QUAL AF DP` and first row `chr20_10.0-10.5Mb 2078 G A 2175.06 1.00 62`. Default matches `GATKCommandBuilder.swift:221` and `cli-help/gatk.txt:133-134` | |
| "On a single-sample cohort the two carry the same numbers, and the detail file adds a few per-sample figures the summary leaves out" | true | Both files re-read. Shared metrics identical; detail adds `SAMPLE_ALIAS` and `HET_HOMVAR_RATIO` | |
| Metrics table: TOTAL_SNPS 835, NUM_IN_DB_SNP 799, NOVEL_SNPS 36, PCT_DBSNP 0.9569, DBSNP_TITV 2.248, NOVEL_TITV 1.769, TOTAL_INDELS 159, FILTERED_SNPS 6, FILTERED_INDELS 7 | true | Re-read from `metrics/cohort.variant_calling_summary_metrics`: 835, 799, 36, 0.956886, 2.247967, 1.769231, 159, 6, 7. Every rounding is correct | |
| `HET_HOMVAR_RATIO` 1.459, detail file only | true | Detail file gives 1.458738; the field is absent from the summary file's header | |
| "`FILTERED_SNPS` plus `FILTERED_INDELS` is 13, matching the 13 rows the filter marked" | true | 6 + 7 = 13, and 13 non-PASS rows re-measured independently | |
| "genuine human variation runs at roughly 2 to 3, while random sequencing error ... runs near 0.5" | true | Standard background fact, consistent with the reported 2.248 | |
| First metrics failure: exit code 3, `Sequence dictionary for (DBSNP) does not match sequence dictionary for (INPUT)`, `not the same size (195, 1)` | true | Author record command 15. The benchmark VCF re-counted here holds exactly 195 `##contig` lines | |
| Second failure: `Sequences at index 0 don't match`, "the reference is 500,001 bases" | true | `GRCh38.chr20.10.0-10.5Mb.dict` reads `LN:500001` | |
| "Picard insists that the known-variants file and the input describe exactly the same contigs ... Nothing else in this chapter is that strict" | true | No other subcommand in `GATKCommandBuilder.swift` imposes a dictionary check | |
| "Every `--execute` run writes a provenance sidecar named `.lungfish-provenance.json`" | true | Present in the scratch root, in `metrics/`, and in `failtest/` | |
| Sidecar holds command, exit code, wall time, tool version `4.6.2.0`, conda env path, resolved options, SHA-256 and byte size per file | true | Re-read `metrics/.lungfish-provenance.json`. Step carries `command`, `exitCode`, `wallTime` 1.156, `toolVersion` 4.6.2.0; `parameters` holds `condaEnvironment` and `option.*` keys; every input and output entry carries `sha256` and `sizeBytes` (1628 matches the file on disk) | |
| "running two of these steps into one folder leaves you with the second one's record and no trace of the first" | true | Confirmed more strongly than the author recorded. The root sidecar now reads `GATK VariantsToTable`, the last step run into that folder, so both the `VariantFiltration` and `SelectVariants` records are gone | |
| "A failed run leaves a usable record and no partial output ... exit code 2" | true | `failtest/` holds only `.lungfish-provenance.json`, with `name: GATK VariantFiltration` and `status: failed` | |
| "`--dry-run` ... overrides `--execute` when both are given" | true | `GATKCommand.swift:84` computes `!execute || dryRun`, and every subcommand passes `execute: execute && !dryRun` | |
| "An unrecognised `--preset` value falls back to `best-practices-both`" | true | Re-run live with `--preset bestpractices-snp`: printed the full ten-expression list, no warning. `GATKCommand.swift:366` is `GATKVariantFiltrationPreset(rawValue: preset) ?? .bestPracticesBoth` | |
| "An unrecognised `--type` value is dropped ... carrying no `-select-type` at all" | true | Re-run live with `--type SUBSTITUTION`: printed `SelectVariants` with no `-select-type`. `GATKCommand.swift:453` is `type.flatMap { GATKSelectedVariantType(rawValue: $0.uppercased()) }` | |
| "`--preset custom` ... printed `gatk VariantFiltration -V ... -O ...` and nothing more" | true | Re-run live: bare command, no filter expression. `GATKCommandBuilder.swift:139-141` returns an empty list for `.custom` | |
| "LGE writes this argument into the GATK command with an explicit `true` or `false` every time" (`--split-multi-allelics`) | true | Re-run `leftalign` with no optional flags: printed `--split-multi-allelics false --max-indel-length 200 --max-leading-bases 1000` | |
| "A recorded `select` run restricted to the first 100 kb ... returned 258 rows ending at position 99,174" | true | Re-measured `first100kb.vcf.gz`: 258 rows, last position 99174 | |
| "Installing it from the command line does not work and answers `Unknown tool pack: gatk-core`" | true | Re-run live: `✗ Unknown tool pack: gatk-core`, and the available-pack list does not include it | |
| "Each of the six recorded runs below finished in about 1.2 seconds" | true | Provenance wall times 1.16 to 1.24 s. The metrics record re-read here gives 1.156 | |
| "`gatk markdup` ... `--create-index` (default true), `--remove-duplicates`, `--validation-stringency`" and "different tool from the top-level `lungfish-cli markdup`, which wraps `samtools`" | true | `cli-help/gatk.txt:170-192` confirms every flag and the default. The samtools one is documented in `docs/user-manual/chapters/04-alignments/04-alignment-quality.md` | |
| "`gatk validate-sam` ... `--mode` (`SUMMARY` or `VERBOSE`, default `SUMMARY`), `--validate-index` (default true), `--ignore-warnings` (default false)" | true | `cli-help/gatk.txt:195-216` confirms all three defaults | |
| "the `.fai` index the fixture ships and the `.dict` sequence dictionary you make once with GATK's own `CreateSequenceDictionary`" | true | `docs/user-manual/fixtures/hg002-chr20/` ships the `.fasta` and `.fasta.fai` but no `.dict` | |
| Download instructions naming `GRCh38.chr20.10.0-10.5Mb.fasta` and `HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz` plus `.tbi` | true | All three files present in `docs/user-manual/fixtures/hg002-chr20/` | |
| "Turn on **Show Experimental Features** in **Settings > Advanced** ... **Tools > Plugin Manager...** (Cmd-Shift-B), go to the Packs tab" | unverifiable | Not driven in the GUI. `parameters.yaml` gating `[gatk-core, experimental]` is consistent with it, and chapter 02 carries the same claim, but only a GUI run settles the menu path and the shortcut | Settle by driving Plugin Manager in Preview 2026.9.13, or inherit chapter 02's gate ruling |
| "A whole human genome takes minutes rather than seconds for these steps" | unverifiable | No whole-genome run was made. Plausible and low-risk, but unmeasured | Settle with one whole-genome timing, or soften to a statement about the fixture only |

## Front matter

| Field | Verdict | Evidence |
|---|---|---|
| `title`, `chapter_id` | true | Match the file path and `mkdocs.yml:119` |
| `prereqs: [06-human-germline-variants/02-joint-genotyping]` | true | The chapter starts from that chapter's cohort VCF |
| `parameters_refs: [variants.gatk-plans]` | true | `parameters.yaml:4010`. The only registry entry covering these subcommands |
| `entry_points` (five CLI lines) | true | All five subcommands exist with the quoted required flags, `cli-help/gatk.txt:86`, `:105`, `:125`, `:220`, `:245` |
| `shots: []`, `illustrations: []` | true | 0 `<!-- SHOT: -->` markers in the body. The ground-truth screenshot table rules this chapter needs none |
| `glossary_refs` (18 anchors) | true | Every one of the 18 resolves to exactly one anchor in `GLOSSARY.md`. Drift row 83 asked for expansion from `[VCF]`, and this delivers it |
| `features_refs: [variants.gatk-germline]` | true | `features.yaml:606`. Applies drift row 84 exactly |
| `fixtures_refs: [hg002-chr20]` | true | Fixture directory exists and holds the named files |
| `brand_reviewed: false`, `lead_approved: false` | true | Correct for a chapter at this stage |

## Settings coverage against parameters.yaml

The registry entry carries `settings: []` and thirteen `cli_only` rows, because
this toolchain has no dialog. Ten of those rows name subcommands rather than
flags, and three name the shared flags.

Coverage of the rows in scope for this chapter is complete.

| Registry row | Covered | Where |
|---|---|---|
| `filter` (with `--preset` and its three values) | yes | **Filter** and **Preset**, plus the `custom` paragraph |
| `select` (with `--sample`, `--type`, `--intervals`) | yes | **Select**, **Sample**, **Type**, **Intervals** |
| `variants-to-table` (with `--fields` default) | yes | **Variants to table**, **Fields** |
| `leftalign` (with `--split-multi-allelics`, `--max-indel-length`, `--max-leading-bases`) | yes | **Left align**, **Split multi-allelics**, **Max indel length**, **Max leading bases** |
| `collect-metrics` (with `--output-prefix`, `--dbsnp`, `--sequence-dictionary`, `--gvcf-input`) | yes | **Collect metrics**, **Output prefix**, **dbSNP**, **Sequence dictionary**, **GVCF input** |
| `--execute`, `--dry-run`, `--extra-args` | yes | **Execute**, **Dry run**, **Extra args** |
| `markdup`, `validate-sam` | yes, by design | Named with full flag sets in a closing On the command line paragraph rather than given Settings entries. Reasonable, since both are BAM-preparation tools outside this chapter's VCF pipeline |
| `haplotype-caller`, `joint-genotype`, `bqsr` | out of scope | Documented in chapters 01, 02, and 04. The Settings lead-in says so and links both |

Twenty Settings paragraphs counted in the body, matching the author's count.
Each follows the fixed three-sentence shape and ends by naming its flag. Every
default stated agrees with `cli-help/gatk.txt` and with the initialiser defaults
in `GATKCommandBuilder.swift` (`:221` fields, `:338` split, `:339` 200, `:340`
1000).

One registry gap worth reporting upward, not a chapter defect. The
`variants.gatk-plans` entry's `filter` row lists only three preset values and
omits `custom`, and its `select` row does not record that `--type` is parsed
leniently. The chapter is more accurate than the registry on both points.

## Consistency

Checked against `CONSISTENCY.md`, the committed Part V chapters, and siblings 01
and 02.

`CONSISTENCY.md` fixes fixture naming ("the HG002 chromosome 20 slice") and
depth wording, and the chapter follows both. It sets no convention for counting
SNVs against indels, which is the live question here.

**The gate ruling's premise does not match the siblings as committed.** The
assignment states that chapters 01 and 02 quote 844 SNVs and 182 indels by the
Part V first-ALT convention. They do not. Both quote **843 and 184**.

- `01-haplotype-caller.md:156` reads "1,026 rows, of which 843 are SNVs ... and 184 are indels".
- `02-joint-genotyping.md:155` reads "843 of them substitutions ... and 184 of them indels".

Measured three ways on the same `cohort.vcf.gz`:

| Convention | SNV | Indel | Other | Sums to |
|---|---|---|---|---|
| First ALT allele only | 844 | 182 | 0 | 1,026 |
| `bcftools view -v snps` / `-v indels` | 843 | 184 | n/a | 1,027 |
| GATK `SelectVariants` classes | 842 | 182 | 2 MIXED | 1,026 |

The siblings' 843 and 184 are the bcftools figures, and they sum to 1,027
against a 1,026-row file, because bcftools counts one MIXED row under both
classes. I verified that overlap directly: exactly one position appears in both
bcftools selections. So the sibling pair carries an internal arithmetic problem
of its own, independent of this chapter.

**This chapter is clean on the point it was asked about.** It presents 842, 182,
and 2 explicitly as GATK's typing, never as LGE's, and it never asserts a total
that conflicts with the siblings:

- "`select` splits the file by class. The recorded runs pulled 842 SNP rows and 182 indel rows" attributes the figures to the `select` runs.
- "because GATK puts every row in exactly one class" names GATK as the authority for the partition.
- The chapter's only SNV-versus-indel totals appear inside the `select` discussion, so a reader meets them as the output of a named GATK command rather than as a property of the file.

No sentence in this chapter reads as contradicting chapters 01 or 02. The three
numbers are reachable, correct, and correctly attributed. The one thing the
chapter does not do is warn the reader that these differ from the 843 and 184
they read two chapters earlier, and a reader who notices will have no way to
reconcile them.

Flagged for the editor rather than corrected here, because the fix belongs to
the siblings and to the campaign's convention, not to this chapter. Two options:

1. Preferred. Correct chapters 01 and 02 to the first-ALT figures 844 and 182, which sum to 1,026, and add one sentence here noting that GATK's own typing moves 2 rows into MIXED. That makes all three chapters agree arithmetically.
2. Weaker. Leave the siblings and add a reconciling sentence here. This preserves a pair of sibling numbers that do not sum to their own stated total.

Other consistency checks pass. The app is "Lungfish Genome Explorer (LGE)" at
first mention and "LGE" after. The cross-reference to
`04-alignments/04-alignment-quality.md` for the samtools `markdup` is correct and
resolves. The forward reference to `04-reference-packs.md` for `bqsr` matches
where those flags are registered. No em dash, no semicolon, and no in-sentence
colon appears in the body, and `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` returns
"no issues found".

## App defects

All six the author reports reproduce. I re-ran five of them live.

1. **Provenance sidecar overwritten on each `--execute` into one folder.** Reproduced, and worse than recorded. The scratch root's `.lungfish-provenance.json` now reads `GATK VariantsToTable`, so both the `VariantFiltration` and the `SelectVariants` records are gone. Real, and it defeats provenance for the natural way to work. The chapter warns about it and gives the per-step-folder workaround.
2. **`--preset` parsed leniently.** Reproduced live. `--preset bestpractices-snp` printed the full ten-expression `best-practices-both` list with no warning. `GATKCommand.swift:366`.
3. **`--type` parsed leniently.** Reproduced live. `--type SUBSTITUTION` printed a `SelectVariants` command with no `-select-type`, which would select everything. `GATKCommand.swift:453`. Agreed that this is the more dangerous of the two, since the output looks plausible.
4. **`--preset custom` reachable and useless from the CLI.** Reproduced live. Bare `VariantFiltration` with no filter expression. `GATKCommandBuilder.swift:139-141`.
5. **`collect-metrics` hides Picard's explanation behind exit 3.** Confirmed from the author's two failure records. The terminal says only `Error: GATK command failed with exit code 3.` and Picard's actual message lives in the provenance JSON. General to the executor, sharpest here.
6. **`conda install --pack gatk-core` fails.** Reproduced live: `✗ Unknown tool pack: gatk-core`, and `gatk-core` is absent from the eight packs listed.

No new app defect found. One chapter defect found, the `##FILTER` header-line
claim in the Claim table.

## Notes for the editor

1. **Fix the `##FILTER` sentence.** The one false claim. There are 9 test header lines, not "one per test" for 10 tests, and a 10th `LowQual` line comes from the caller. Corrected wording is in the Claim table. Small edit, and it strengthens the surrounding point about self-documenting files rather than weakening it.
2. **Decide the SNV-versus-indel convention across Part V.** See Consistency. This chapter is not at fault, but shipping it beside siblings whose 843 and 184 sum to 1,027 leaves a reader with three different pairs of numbers for one file. The decision belongs above this chapter.
3. **Two unverifiable claims are both low-risk.** The Plugin Manager route inherits chapter 02's position, and the whole-genome timing is a general statement. Neither needs to block the chapter, but both should be recorded as inherited rather than measured.
4. **Consider one sentence on `--sample` on a single-sample file.** The chapter describes what `--sample` does correctly, but the worked run cannot demonstrate dropping other samples, because the fixture holds one. A reader following along sees a flag that appears to do nothing. The author noted this honestly in Not verified; a half-sentence in the chapter would close it for the reader.
5. **The registry is behind the chapter.** `variants.gatk-plans` omits `--preset custom` and says nothing about either lenient parse. Worth an update to `parameters.yaml` so the registry does not contradict a shipped chapter.
6. **Quality of the numbers is high.** Every one of the roughly thirty figures in this chapter re-measured exactly, including the two-decimal QUAL values, the six-decimal metrics, the byte size in the provenance record, and the before-and-after alleles at position 29,224. I found no rounding error and no transcription error.

## Counts

- Claims checked: **47**
- True: **44**
- False: **1**
- Unverifiable: **2**
- Front-matter fields checked: 9, all true
- Settings paragraphs: 20, all covered against `parameters.yaml`, no gap
- Glossary anchors checked: 18, all resolve exactly once
- Defects reproduced: 6 of 6, no new app defect
- Chapter defects found: 1
