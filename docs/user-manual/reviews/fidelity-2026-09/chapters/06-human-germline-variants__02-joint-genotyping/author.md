# Author record, 06-human-germline-variants/02-joint-genotyping

Roster row 43. Registry id `variants.gatk-plans`. Fixture hg002-chr20.
Rewritten against Preview 2026.9.13 on 2026-09-07.

Scratch directory for every run below:
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/gatk-joint/`

CLI binary: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
(the primary checkout's debug build, as directed by the assignment).

## Environment preparation

The `gatk-core` conda environment did not exist on this machine, and the
documented CLI installer refuses to create it (see Defects). I created it
directly with the vendored micromamba, pinned to the version the tool lock
names.

| # | Command | Exit | Result |
|---|---|---|---|
| E1 | `lungfish-cli conda install --pack gatk-core` | non-zero | `✗ Unknown tool pack: gatk-core` plus a list of eight packs excluding it. Recorded as a defect. |
| E2 | `micromamba create -n gatk-core --yes --override-channels -c conda-forge -c bioconda "gatk4=4.6.2.0"` | 0 | Installed `gatk4-4.6.2.0-py310hdfd78af_0`. The tool lock pins build `_1`; only `_0` resolved from the current channel. Same upstream version, different conda build string. |
| E3 | `~/.lungfish/conda/envs/gatk-core/bin/gatk --version` | 0 | `The Genome Analysis Toolkit (GATK) v4.6.2.0`, HTSJDK 4.2.0, Picard 3.4.0. Matches the smoke test string the pack declares. |

Inputs copied into the scratch directory (nothing was written to the fixture
tree or to `~/Desktop/lge-docs/`):

- `docs/user-manual/fixtures/hg002-chr20/expected/mapping/HG002.sorted.bam` and its `.bai`
- `docs/user-manual/fixtures/hg002-chr20/GRCh38.chr20.10.0-10.5Mb.fasta` and its `.fai`

The demo project's `Analyses/mapping-HG002/` holds only three JSON files and no
BAM, so the fixture's `expected/mapping/` BAM was used instead. Read-only
access to the demo project throughout.

BAM header confirmed a read group with `SM:HG002`, which GATK requires.

## Commands run

| # | Command | Exit | Figures taken |
|---|---|---|---|
| 1 | `lungfish-cli gatk joint-genotype --help` | 0 | Confirmed the flag set matches `cli-help/gatk.txt:62-82` exactly, including `--intermediate` being required. |
| 2 | `gatk CreateSequenceDictionary -R GRCh38.chr20.10.0-10.5Mb.fasta` | 0 | Wrote `GRCh38.chr20.10.0-10.5Mb.dict` (252 bytes). Documented in Before you start, because GATK will not run without it and LGE never creates it. |
| 3 | `lungfish-cli gatk haplotype-caller --reference ... --bam HG002.sorted.bam --output HG002.g.vcf.gz --emit-ref-confidence GVCF --execute` | 0 | Produced the chapter's own GVCF, so this chapter does not depend on the chapter-01 author's scratch. Printed `GATK execution completed with exit code 0.` and a `Provenance:` line. Provenance recorded one step, `gatk-haplotype-caller` 4.6.2.0, exit 0, wall **27.32 s**. Output `HG002.g.vcf.gz` 851,405 bytes plus `.tbi`. **48,057 GVCF rows.** |
| 4 | `lungfish-cli gatk joint-genotype --reference ... --gvcf HG002.g.vcf.gz --intermediate cohort.combined.g.vcf.gz --output cohort.vcf.gz` (no `--execute`) | 0 | The preview quoted verbatim in step 1 of the chapter. Confirmed `auto` resolved to `CombineGVCFs`, and confirmed the always-on `--standard-min-confidence-threshold-for-calling 30.0` and `-G AS_StandardAnnotation` on the `GenotypeGVCFs` line. No files written. |
| 5 | `... --execute` (same options) | 0 | Printed `GATK execution completed with exit code 0.` and `Provenance: .../.lungfish-provenance.json`. **Wall 3.30 s real** by `/usr/bin/time -p`, split in provenance as **1.61 s** for CombineGVCFs and **1.62 s** for GenotypeGVCFs. Provenance status `completed`, two steps. Outputs `cohort.combined.g.vcf.gz` 809,306 B, `cohort.vcf.gz` 61,798 B, both with `.tbi`. |
| 6 | `bcftools view -H cohort.vcf.gz \| wc -l` | 0 | **1,026 cohort rows.** |
| 7 | `bcftools view -H -v snps` / `-v indels` | 0 | **843 SNPs, 184 indels.** |
| 8 | `bcftools query -l cohort.vcf.gz` | 0 | One sample column, `HG002`. Header line ends `FORMAT  HG002`. |
| 9 | `bcftools view -H cohort.vcf.gz \| head -3` | 0 | The first row quoted in Reading the results, `chr20_10.0-10.5Mb 2078 . G A 2175.06 . AC=2;AF=1;AN=2;AS_QD=25.36;DP=62;...;QD=28.73;SOR=0.76 GT:AD:DP:GQ:PL 1/1:0,60:60:99:2189,180,0`. |
| 10 | `bcftools view -h cohort.vcf.gz \| grep -c "ID=AS_"` | 0 | **8 `AS_` header keys**, confirming the allele-specific annotations landed. |
| 11 | `bcftools query -f '%INFO/DP\n' \| awk` | 0 | **Mean DP 39.39** over 1,026 rows. Quoted as 39.4. |
| 12 | `bcftools query -f '%FILTER\n' \| sort \| uniq -c` | 0 | **All 1,026 rows carry `.`**, no filter applied. Basis for the FILTER warning and the What good looks like item. |
| 13 | `bcftools query -f '%QUAL\n' \| sort -n \| head -1` | 0 | **Minimum QUAL 31.6**, just above the fixed 30.0 threshold. |
| 14 | `... --combine-strategy genomics-db` (deliberate typo, no `--execute`) | 0 | Printed `CombineGVCFs`, confirming the silent fallback to `auto` with no warning. Quoted in Settings. |
| 15 | `... --combine-strategy genomicsdb --intermediate gdb-workspace --output cohort.gdb.vcf.gz --intervals first100kb.bed --execute` | 0 | Wall **4.54 s real**, provenance steps `GenomicsDBImport` 2.20 s and `GenotypeGVCFs` 2.27 s, status `completed`. Workspace held `__tiledb_workspace.tdb`, `callset.json`, `chr20_10.0-10.5Mb$1$100000`, `vcfheader.vcf`, `vidmap.json`. |
| 16 | `bcftools view -H cohort.gdb.vcf.gz \| wc -l` and `query -f '%POS\n' \| tail -1` | 0 | **258 rows, last position 99,174.** Proves `--intervals` restricted both steps, not only genotyping. |
| 17 | `... --extra-args "--max-alternate-alleles 3"` (no `--execute`) | 0 | The extra argument appeared only at the end of the `GenotypeGVCFs` line and never on `CombineGVCFs`. Confirms drift row 54. |
| 18 | `... --output x.vcf.gz` with `--intermediate` omitted | non-zero | `Error: Missing expected argument '--intermediate <intermediate>'`. Confirms the corrected wording for drift row 53 that `--intermediate` is required either way. |
| 19 | `... --gvcf missing.g.vcf.gz ... --execute` | non-zero | `Error: GATK command failed with exit code 2. Provenance was written to .../.lungfish-provenance.json.` Provenance status `failed`, one step, exit 2. `ls fail.*` found nothing, confirming the executor removed the outputs it created. |
| 20 | `... --execute --dry-run` | 0 | Printed both commands and wrote no files, confirming `--dry-run` overrides `--execute`. |
| 21 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/06-human-germline-variants/02-joint-genotyping.md` | 0 | `no issues found` on the first pass after the rewrite. |

## Source files consulted for behaviour claims

Joint genotyping has no window, so the source reading below was to establish
the absence of a GUI surface and to pin behaviour the CLI help does not state.

- `Sources/LungfishWorkflow/Variants/GATKCommandBuilder.swift`. Lines 75-79 for the three strategy raw values, 100 for `alleleSpecificAnnotations = true`, 99 for the 30.0 confidence default, 380 for `jointGenotypingCombineGVCFsThreshold = 50`, 408-414 for the `<=` comparison that puts 50 itself on the CombineGVCFs side, 583-640 for the two command sequences, 607-610 and 636-639 for the per-step working directories, 616 for `--genomicsdb-workspace-path` and 627 for the `gendb://` prefix, 606 and 635 for `--extra-args` landing only on the genotyping step.
- `Sources/LungfishCLI/Commands/GATKCommand.swift`. Lines 31-35 and 46-51 for the preview-versus-execute branch and the two printed lines, 50 for `result.exitCode` being the last step's code, 282 for `GATKJointGenotypingStrategy(rawValue:) ?? .auto`, the lenient parse behind command 14.
- `Sources/LungfishWorkflow/Variants/GATKPipelineExecutor.swift`. Line 50 for the 24 hour default runner timeout, 755-805 for the ordered loop and the failure branch that removes new outputs and writes a `failed` provenance record before throwing, 804 for the last-command exit code, 830-875 for the one `WorkflowRun` with one `StepExecution` per command.
- `Sources/LungfishApp/Views/BAM/BAMVariantCallingCatalog.swift`. The seven-case `BAMVariantCallingToolID` enum lists no joint-genotype tool. A grep for `jointGenotype`, `joint-genotype`, and `JointGenotyp` across `Sources/LungfishApp/` and `Sources/LungfishKit/` returned nothing at all, which is the direct evidence for the "no dialog, no menu item" claim.
- `Sources/LungfishWorkflow/Conda/PluginPack.swift:617-642`. The `gatk-core` pack, `isExperimental: true`, `estimatedSizeMB: 600`, one `gatk4` requirement.
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json:40`. The pin `bioconda::gatk4=4.6.2.0=py310hdfd78af_1`.
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/gatk.txt:62-82`. Re-verified live against command 1.

## Drift coverage

Every changed row applied. Row 44 split into two sentences. Row 45 dropped the
`isDryRun` code quotation entirely. Row 53 rewritten as three sentences with
the "Either way `--intermediate` is required" clause, verified by command 18.
Row 59 now says "the exit code of the last GATK step". Row 60 reordered so no
colon sits inside the sentence. Row 62 frontmatter now carries
`features_refs: [variants.gatk-germline]`.

Every Missing row covered. `--intervals` has its own Settings paragraph and a
worked run (commands 15 and 16) proving it reaches both steps. The always-on
`-G AS_StandardAnnotation` and the always-on `30.0` threshold share the
closing paragraph of Settings, together with the per-step working directory,
each stated as having no flag. The silent strategy fallback has its own
paragraph in Settings plus a recorded reproduction. The failure cleanup and
failure provenance are in Reading the results with the exact error text. The
24 hour timeout is in Before you start.

## Defects found

1. **`lungfish-cli conda install --pack gatk-core` fails.** The pack id is
   rejected with `✗ Unknown tool pack: gatk-core` because the CLI installer
   resolves ids only against the non-experimental pack list. This is the
   defect the ground-truth map flags as the largest in this part, and the
   chapter states it plainly and routes the reader to the Plugin Manager
   instead. Chapter 04 documents the failing command and needs the same fix.
2. **The strategy value is parsed leniently.** `--combine-strategy
   genomics-db` runs the `auto` behaviour with no error, no warning, and no
   indication in the printed commands other than the tool name itself.
   Reproduced at command 14. A user who mistypes gets a silently different
   pipeline. Worth an upstream fix so an unrecognised value is rejected.
3. **The tool lock's pinned conda build string no longer resolves.** The lock
   names `py310hdfd78af_1` and only `py310hdfd78af_0` was available from
   conda-forge plus bioconda on 2026-09-07. The upstream GATK version is
   identical, so this is a packaging drift rather than a behaviour change, but
   a pack install that demands the exact build string would fail today.

## Not verified

- **The Plugin Manager route for the GATK Core pack.** The chapter tells the
  reader to install the pack through **Tools > Plugin Manager...** with
  **Show Experimental Features** turned on. I did not drive the GUI to confirm
  the card renders and installs, because this chapter documents a command-line
  operation and I had no screenshot assignment. The claim rests on
  `PluginPack.swift:617-642` and on the pattern the Freyja chapter established
  for the same surface. A GUI reviewer should confirm the card is present and
  that Install All succeeds.
- **A genuine multi-sample cohort.** The fixture holds one sample, so the
  worked example is single-sample and the chapter says so in Why you would do
  this. The multi-sample commands in On the command line are extrapolated from
  the repeated `--gvcf` option, which command 4's preview shows LGE expanding
  one `--variant` argument per input. The comparison behaviour that joint
  genotyping exists for is therefore described but not demonstrated.
- **Behaviour above the 50-sample threshold.** `auto` selecting GenomicsDB was
  not observed, because that needs 51 GVCFs. The threshold and the `<=`
  comparison come from `GATKCommandBuilder.swift:380` and `:408-414`. The
  GenomicsDB path itself was run for real by forcing the strategy (command 15).
- **The 24 hour runner timeout.** Read from
  `GATKPipelineExecutor.swift:50`, not exercised.

## Counts

- Settings paragraphs in the fixed `**Label.**` shape: 9 (Reference, GVCF,
  Output, Intermediate, Combine strategy, Intervals, Extra args, Execute,
  Dry run), plus two closing paragraphs covering the three unchangeable GATK
  options and the lenient strategy parse.
- `<!-- SHOT: -->` markers: 0, matching `shots: []`. The drift report's
  screenshot table rules this chapter needs none, because the operation has no
  GUI surface.
- Glossary terms added to `GLOSSARY.md`: 4. Allele-specific annotation,
  CombineGVCFs, GenotypeGVCFs, Interval list. All four are listed in
  `glossary_refs` and linked from the chapter body.
