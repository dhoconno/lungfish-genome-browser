# Author record, 06-human-germline-variants/03-filtering-selecting-and-metrics

Roster row 44. Registry id `variants.gatk-plans`. Fixture hg002-chr20.
Rewritten against Preview 2026.9.13 on 2026-09-07.

Scratch directory for every run below:
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/gatk-filter/`

CLI binary: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
(the primary checkout's debug build, as directed by the assignment).

## Inputs

The `gatk-core` environment was already present from the chapter 02 author's
work, created with the vendored micromamba as
`gatk4-4.6.2.0-py310hdfd78af_0`. Verified before use with
`~/.lungfish/conda/envs/gatk-core/bin/gatk --version` (exit 0), which printed
`The Genome Analysis Toolkit (GATK) v4.6.2.0`, HTSJDK 4.2.0, Picard 3.4.0.

Copied into this chapter's scratch directory:

- `cohort.vcf.gz` and `cohort.vcf.gz.tbi` from the chapter 02 scratch at
  `.../scratchpad/gatk-joint/`. This is the cohort VCF the joint-genotyping
  chapter produced, and the chapter describes it as such and links to
  `02-joint-genotyping.md`.
- `GRCh38.chr20.10.0-10.5Mb.fasta`, its `.fai`, and the `.dict` the chapter 02
  author built with `CreateSequenceDictionary`.
- `HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz` and its `.tbi` from
  `docs/user-manual/fixtures/hg002-chr20/`, copied as `known-sites.vcf.gz` and
  used as the known-variants file for the metrics plan, because the fixture
  tree holds no dbSNP file and none was fetched.

Nothing was written to the fixture tree or to `~/Desktop/lge-docs/`.

## Commands run

| # | Command | Exit | Figures taken |
|---|---|---|---|
| 1 | `lungfish-cli gatk filter --vcf cohort.vcf.gz --preset best-practices-both --output cohort.filtered.vcf.gz` (preview) | 0 | The full `VariantFiltration` line quoted verbatim in Procedure step 1, showing all ten `--filter-expression`/`--filter-name` pairs and the duplicated `QD2`. |
| 2 | same with `--execute` | 0 | `GATK execution completed with exit code 0.` plus a `Provenance:` line. Provenance status `completed`, one step, `gatk-variant-filtration` 4.6.2.0, exit 0, step `wallTime` **1.24 s**, CLI wall 1.31 s. Output `cohort.filtered.vcf.gz` 62,533 B plus a `.tbi` LGE did not have to ask for. |
| 3 | `bcftools view -H cohort.vcf.gz \| wc -l` and the same on the filtered file | 0 | **1,026 rows in, 1,026 rows out.** Basis for the "the filter changes no row count" claim. |
| 4 | `bcftools query -f '%FILTER\n' cohort.filtered.vcf.gz \| tr ';' '\n' \| sort \| uniq -c` | 0 | **1,013 PASS, 12 SOR3, 2 QD2.** |
| 5 | `bcftools view -H -i 'FILTER!="PASS"' cohort.filtered.vcf.gz` | 0 | **13 distinct failing rows**, one of them (`496668`) carrying `QD2;SOR3`, which reconciles 12+2=14 labels against 13 rows. The two `QD2` rows had QUAL **32.64** and **32.6**, both quoted. |
| 6 | `bcftools view -h cohort.filtered.vcf.gz \| grep '^##FILTER'` | 0 | Ten `##FILTER` header lines plus `PASS`, each carrying its expression in the description. Also revealed a `LowQual` line carried over from the caller, not quoted in the chapter. |
| 7 | `... gatk select --vcf cohort.filtered.vcf.gz --sample HG002 --type SNP --output HG002.snps.vcf.gz --execute` | 0 | `gatk-select-variants` 4.6.2.0, step `wallTime` **1.18 s**. **842 rows**, 836 PASS, 5 SOR3, 1 QD2. `bcftools query -l` returned the single sample `HG002`. |
| 8 | same with `--type INDEL` | 0 | Step `wallTime` **1.18 s**. **182 rows**, 175 PASS, 7 SOR3, 1 QD2. |
| 9 | same with `--type MIXED` | 0 | **2 rows**, positions 29,224 (`A -> G,AGG`) and 490,194 (`C -> *,CTT`). 842+182+2 = 1,026 exactly, which is the arithmetic the chapter states. |
| 10 | `comm` of the three selections against the full position list | 0 | Zero overlap between the SNP and indel selections, and exactly the 2 MIXED positions in neither. GATK's classes partition the file. Note that `bcftools view -v snps/indels` gives 843 and 184 on the same file, because bcftools counts a mixed site under both. The chapter quotes the GATK figures only. |
| 11 | `... gatk leftalign --reference ... --vcf cohort.filtered.vcf.gz --output cohort.leftaligned.vcf.gz --split-multi-allelics --execute` | 0 | `gatk-leftalign` 4.6.2.0, step `wallTime` **1.23 s**. **1,045 rows out of 1,026 in.** Multi-allelic rows went from **19 to 0**. Position 29,224 quoted before and after. |
| 12 | `... gatk variants-to-table --vcf cohort.filtered.vcf.gz --output cohort.table.tsv --execute` | 0 | `gatk-variants-to-table` 4.6.2.0, step `wallTime` **1.16 s**. **1,013 data rows, 7 columns.** The default table drops filtered rows, which is exactly the PASS count. First data row quoted. |
| 13 | same plus `--extra-args "--show-filtered"` | 0 | **1,026 data rows.** Proves both that filtered rows are dropped by default and that `--extra-args` reaches the command. |
| 14 | `... gatk collect-metrics --vcf cohort.filtered.vcf.gz --dbsnp known-sites.vcf.gz --sequence-dictionary ... --output-prefix metrics/cohort` (preview) | 0 | Confirmed `-O` receives the bare prefix and `--SEQUENCE_DICTIONARY` appears only because it was supplied. Provenance for this subcommand lands in `metrics/`, not the input folder, confirming the working directory follows the output prefix. |
| 15 | same with `--execute` | non-zero | **First recorded failure.** `Error: GATK command failed with exit code 3.` Provenance status `failed`, stderr held `Sequence dictionary for (DBSNP) does not match sequence dictionary for (INPUT)` and `Sequence dictionaries are not the same size (195, 1)`. Quoted in Reading the results. |
| 16 | rebuilt the known-sites header to one contig at length 500000, re-ran | non-zero | **Second recorded failure.** `Sequences at index 0 don't match: 0/500000/... 0/500001/...`. The reference contig is 500,001 bases. Quoted. |
| 17 | rebuilt at length 500001 as `dbsnp.slice.vcf.gz` (961 rows), re-ran with `--execute` | 0 | `gatk-collect-metrics` 4.6.2.0, step `wallTime` **1.16 s**, status `completed`. Wrote `metrics/cohort.variant_calling_summary_metrics` (1,628 B) and `metrics/cohort.variant_calling_detail_metrics` (1,734 B), proving the prefix-plus-suffix behaviour. |
| 18 | read both metrics files | 0 | Every figure in the Reading the results table: TOTAL_SNPS **835**, NUM_IN_DB_SNP **799**, NOVEL_SNPS **36**, PCT_DBSNP **0.956886**, DBSNP_TITV **2.247967**, NOVEL_TITV **1.769231**, TOTAL_INDELS **159**, FILTERED_SNPS **6**, FILTERED_INDELS **7**, and from the detail file HET_HOMVAR_RATIO **1.458738**, SAMPLE_ALIAS `HG002`. 6+7 = 13 reconciles with command 5. |
| 19 | `--preset best-practices-snp`, `best-practices-indel`, `custom` (previews) | 0 each | Six SNP expressions, four indel expressions, and for `custom` a bare `gatk VariantFiltration -V ... -O ...` with no filter expression at all. Quoted in Settings. |
| 20 | `--preset bestpractices-snp` (deliberate typo, preview) | 0 | Printed the full ten-expression `best-practices-both` list with no warning. Confirms the silent fallback. Quoted in Settings and in What good looks like. |
| 21 | `--type SUBSTITUTION` (preview) | 0 | Printed a `SelectVariants` line carrying **no** `-select-type` at all. Second lenient parse, recorded as a defect. |
| 22 | `--type snp` lowercase (preview) | 0 | Printed `-select-type SNP`, so the value is uppercased before matching. Not stated in the chapter, since the help documents the uppercase forms. |
| 23 | `leftalign` with no optional flags (preview) | 0 | Printed `--split-multi-allelics false --max-indel-length 200 --max-leading-bases 1000`, confirming all three are always written with explicit values. Basis for the corrected wording of drift row 70. |
| 24 | `leftalign --intervals first100kb.bed --max-indel-length 400 --max-leading-bases 2000` (preview) | 0 | `-L first100kb.bed` appended after the three always-present arguments. Covers the Missing row for `leftalign --intervals`. |
| 25 | `select --intervals first100kb.bed --execute` | 0 | **258 rows, last position 99,174.** Covers the Missing row for `select --intervals` and is quoted in On the command line. |
| 26 | `variants-to-table --fields "CHROM,POS,REF,ALT,QUAL,FILTER,AC,AN"` (preview) | 0 | Printed one `-F <name>` per field, eight in all. Covers the Missing row about comma splitting. |
| 27 | `filter --execute --dry-run` | 0 | Printed the command, wrote no file (`never.vcf.gz` absent), CLI wall 0.06 s. Confirms `--dry-run` overrides `--execute`. |
| 28 | `filter --vcf missing.vcf.gz --output failtest/fail.vcf.gz --execute` | non-zero | `Error: GATK command failed with exit code 2.` The folder held only `.lungfish-provenance.json` afterwards, status `failed`, exit 2. Confirms the executor removes what it created. |
| 29 | inspected `.lungfish-provenance.json` after the `select` runs | 0 | The record read `name: GATK SelectVariants`, so the earlier `VariantFiltration` record had been overwritten. Recorded as a defect and stated plainly in Reading the results. |
| 30 | full six-plan rerun through `timeruns.py` | 0 all | Every runtime in the chapter. filter 1.24 s, select SNP 1.18 s, select INDEL 1.18 s, leftalign 1.23 s, variants-to-table 1.16 s, collect-metrics 1.16 s, all `status: completed`, all tool version 4.6.2.0. Counts re-verified after the rerun and reproduced exactly. |
| 31 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/06-human-germline-variants/03-filtering-selecting-and-metrics.md` | 0 | `no issues found` on the first pass after the rewrite, and again after the `glossary_refs` trim. |

## Source files consulted for behaviour claims

- `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift`. Lines 125-129 for the four preset raw values including `custom`, 131-142 for the preset-to-list mapping and the `custom` empty list, 144-152 for the six SNP filters, 153-158 for the four indel filters (the shared `QD2` at 145 and 154 is the duplicate), 181-185 for the three selected variant types, 221 for the default field list, 428-438 for `variantFiltration`, 440-457 for `selectVariants` including `-L` at 453-455, 459-471 for `variantsToTable` emitting one `-F` per field at 466-468, 546-566 for `leftAlignAndTrimVariants` with the always-emitted `--split-multi-allelics` at 553, 567-584 for `collectVariantCallingMetrics` with `-O` taking the bare prefix at 570 and the conditional `--SEQUENCE_DICTIONARY` and `--GVCF_INPUT`, and each builder's `workingDirectory` derived from its own output path.
- `Sources/LungfishCLI/Commands/GATKCommand.swift`. Line 366 for `GATKVariantFiltrationPreset(rawValue: preset) ?? .bestPracticesBoth`, the lenient preset parse behind command 20. The `SelectSubcommand` `executionRequest` for `type.flatMap { GATKSelectedVariantType(rawValue: $0.uppercased()) }`, which both uppercases and silently yields nil on an unknown value, behind commands 21 and 22. The `VariantsToTableSubcommand` `executionRequest` for the comma split with whitespace trimming. `GATKCLICommand.parseExtraArgs` for the tokenizing behind the corrected wording of drift row 80.
- `Sources/LungfishWorkflow/Variants/GATKPipelineExecutor.swift` for the failure branch that removes new outputs and writes a `failed` record before throwing, exercised at command 28.
- `Sources/LungfishApp/Views/BAM/BAMVariantCallingCatalog.swift:9-16`. The seven-case `BAMVariantCallingToolID` enum names none of these five tools. A grep for `VariantFiltration`, `SelectVariants`, `VariantsToTable`, `LeftAlignAndTrim`, and `CollectVariantCallingMetrics` across `Sources/LungfishApp/` and `Sources/LungfishKit/` returned nothing at all, which is the direct evidence for the "no dialog, no menu item" claim.
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/gatk.txt`, the whole file, re-verified live against commands 1, 14, 19, 23, 24, and 26.
- `docs/user-manual/parameters.yaml`, the `variants.gatk-plans` entry, for the flag inventory the Settings section covers.
- `docs/user-manual/chapters/04-alignments/04-alignment-quality.md` to confirm that the samtools `markdup` documented there is a different tool from the Picard `gatk markdup`, which the chapter now says explicitly.

## Drift coverage

Every changed row applied. Row 63 is now two sentences and the semicolon is
gone. Row 65 carries the corrected preset wording including the `custom`
warning, backed by command 19. Row 70 carries the corrected
`--split-multi-allelics` wording about the explicit `true` or `false`, backed
by command 23. Row 80 now says LGE splits the quoted string into arguments and
appends them unchanged, backed by command 13. Row 83 expands `glossary_refs`
from one term to eighteen. Row 84 adds `features_refs: [variants.gatk-germline]`.

Every Missing row covered. `gatk markdup` and `gatk validate-sam` are
documented in a closing paragraph of On the command line with their full flag
sets and the note that the Picard `markdup` is a different tool from the
samtools one in chapter 04. `select --intervals` and `leftalign --intervals`
share one Settings paragraph that names both, with command 25 as the worked
run. All ten filter expressions are quoted verbatim in the Procedure preview
rather than described, which is what the drift report's screenshot note asked
for. The duplicated `QD2` from `best-practices-both` is called out in the
paragraph beneath that preview. The silent `--preset` fallback has a paragraph
in Settings and a line in What good looks like. The comma splitting into one
`-F` per field is in the Fields paragraph. The `--output-prefix` prefix
behaviour is in the Output prefix paragraph and demonstrated by the two files
command 17 wrote. The absence of any GUI surface is the chapter's opening
sentence and is repeated in Before you start and Settings.

## Defects found

1. **The provenance sidecar is overwritten by each run into the same folder.**
   LGE always writes `.lungfish-provenance.json` beside the output, under that
   fixed name, so a second `--execute` into the same directory destroys the
   first run's record with no warning. Reproduced at command 29, where the file
   left after two `select` runs described only `GATK SelectVariants` and the
   preceding `VariantFiltration` record was gone. This defeats the purpose of
   provenance for any multi-step workflow run into one folder, which is the
   natural way to work. The chapter warns about it and suggests per-step output
   folders as the workaround. Worth an upstream fix, most simply by naming the
   record after the output file.
2. **`--preset` is parsed leniently.** An unrecognised value falls back to
   `best-practices-both` with no error and no warning. Reproduced at command 20
   with `bestpractices-snp`. A user who mistypes gets both filter lists applied
   instead of the one they asked for.
3. **`--type` is parsed leniently.** An unrecognised value is dropped rather
   than rejected, so the composed `SelectVariants` command carries no
   `-select-type` at all and selects everything. Reproduced at command 21 with
   `SUBSTITUTION`. This is the more dangerous of the two, because the failure
   mode is a file that looks plausible and contains the wrong rows.
4. **`--preset custom` is reachable and useless from the CLI.** The enum case
   exists and produces an empty filter list, and the CLI exposes no companion
   flag for supplying filters, so the value can only ever build a
   `VariantFiltration` command that filters nothing. Reproduced at command 19.
   Either the CLI should reject it or it should gain a `--filter-expression`
   flag.
5. **`collect-metrics` gives no guidance when the sequence dictionaries
   disagree.** The CLI reports only `Error: GATK command failed with exit code
   3.` and the reader has to open the provenance JSON to find Picard's actual
   explanation. Commands 15 and 16. This is a general property of the executor
   rather than specific to this subcommand, but it bites hardest here because
   the dictionary match is a precondition no other subcommand imposes.
6. **`lungfish-cli conda install --pack gatk-core` still fails** with
   `Unknown tool pack: gatk-core`, as chapter 02 recorded. Restated in Before
   you start.

## Not verified

- **A real dbSNP release.** The metrics step ran against the HG002 GIAB
  benchmark VCF rebuilt to one contig, not against dbSNP. The known and novel
  figures are therefore measured against a per-sample truth set rather than
  against a population catalogue, which is why 95.7 percent known is high. The
  chapter names the file it used and says a real dbSNP release is what belongs
  there in real work. The mechanics of the step, the two output files, and the
  metric names are all real.
- **The Plugin Manager route for the GATK Core pack.** Not driven in the GUI,
  for the same reason chapter 02 gave. The claim rests on `PluginPack.swift`
  and on chapter 02's reading.
- **`gatk markdup` and `gatk validate-sam` were not run.** Their flags and
  defaults come from `cli-help/gatk.txt:170-216` and
  `GATKCommandBuilder.swift:509-543`. They are BAM-preparation tools rather
  than parts of this chapter's VCF pipeline, so they are named with their flag
  sets in On the command line rather than given a procedure, and no figure is
  quoted for either.
- **A genuine multi-sample cohort.** The fixture holds one sample, so
  `--sample HG002` selects the only column there is and cannot demonstrate
  dropping the others. The flag's behaviour is described from the help and the
  builder rather than shown.
- **Whether `--extra-args` reaches a second GATK command.** Each subcommand in
  this chapter builds exactly one command, so the per-step question that
  matters for `joint-genotype` and `bqsr` does not arise here.

## Counts

- Settings paragraphs in the fixed `**Label.**` shape: **20** (Filter, Preset,
  Select, Sample, Type, Intervals, Variants to table, Fields, Left align,
  Split multi-allelics, Max indel length, Max leading bases, Collect metrics,
  Output prefix, dbSNP, Sequence dictionary, GVCF input, Execute, Dry run,
  Extra args), plus two closing paragraphs, one on `--preset custom` and one on
  the two lenient parses.
- `<!-- SHOT: -->` markers: **0**, matching `shots: []`. The drift report's
  screenshot table rules this chapter needs none, because every operation is
  command line only.
- Glossary terms added to `GLOSSARY.md`: **8**. Hard filter, Left alignment,
  Multi-allelic, Novel variant, Quality by depth, Strand odds ratio,
  Transition to transversion ratio, TSV. All eight are listed in
  `glossary_refs` and linked from the chapter body. A ninth, dbSNP, was written
  and then withdrawn because a concurrent author had already added a fuller
  entry for the same anchor while this chapter was being written. Picard
  likewise already existed. Every anchor named in `glossary_refs` was checked
  to appear exactly once in `GLOSSARY.md`.
