# Author log, 06-human-germline-variants/01-haplotype-caller

Chapter rewritten in place against Preview 2026.9.13 behaviour. Roster row 42.
Registry ids `variants.call-gatk-haplotypecaller` and
`variants.call-gatk-whatshap-phased`. Fixture hg002-chr20.

Scratch directory for every run:
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/gatk-hc/`

Binary under test: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
GATK version installed and used: 4.6.2.0. WhatsHap version: 2.3.

## Inputs staged

Copied read-only, never modified in place.

- Reference and index from `docs/user-manual/fixtures/hg002-chr20/GRCh38.chr20.10.0-10.5Mb.fasta{,.fai}`.
- Benchmark VCF from the same fixture folder, used only for the 961-record count.
- Alignment `hg002-minimap2.bam` and its `.bai` from the demo project at
  `~/Desktop/lge-docs/LGE Manual Demo.lungfish/Reference Sequences/chr20_10.0-10.5Mb.lungfishref/alignments/mapped/`.
  Note the BAM lives inside the reference bundle, not under `Analyses/mapping-HG002/`,
  which holds only the three provenance and result JSON files. This matches the
  CONSISTENCY variant-track storage ruling that tracks live inside the bundle.

BAM header read with `samtools view -H`. It carries
`@RG ID:HG002 SM:HG002 LB:HG002 PL:ILLUMINA PU:HG002` and one contig
`chr20_10.0-10.5Mb` of length 500001. That read group is the basis for the
chapter's claim that LGE's mapper writes one and that GATK uses the name as
the VCF sample column.

## Commands run, in order

| # | Command | Exit | Runtime | What it gave the chapter |
|---|---|---|---|---|
| 1 | `lungfish-cli conda list` | 0 | instant | 58 environments, no `gatk-core`, `phasing` present. Established that `gatk-core` was absent before this session. |
| 2 | `lungfish-cli conda packs` | 0 | instant | Eight packs listed, `gatk-core` and `phasing` absent from the list. Evidence for the experimental-pack visibility claim. |
| 3 | `lungfish-cli conda install --pack gatk-core` | non-zero | instant | Printed "Unknown tool pack: gatk-core" plus the eight available packs. Confirms the documented install defect. Chapter states this without quoting the colon-bearing string, per the prose rule. |
| 4 | `lungfish-cli gatk haplotype-caller --reference ... --bam ... --output HG002.chr20.g.vcf.gz` (preview) | 0 | 0.07 s | The one printed GATK line quoted verbatim in the chapter's `text` block. Source of the `-ERC GVCF` and `--native-pair-hmm-threads` spellings. |
| 5 | `lungfish-cli conda install gatk4 --env gatk-core` (first attempt) | non-zero | 35 s | FAILED. micromamba could not create `.../envs/gatk-core/conda-meta`, rolled the transaction back. Recorded as a defect below. |
| 6 | `rm -rf ~/.lungfish/conda/envs/gatk-core` then re-ran #5 | 0 | ~5 min | Succeeded on the clean retry. GATK 4.6.2.0 present at `envs/gatk-core/bin/gatk`. |
| 7 | `lungfish-cli gatk haplotype-caller ... --execute` (no `.dict` present) | non-zero | 1.2 s | FAILED with GATK's "A USER ERROR has occurred: Fasta dict file ... does not exist". Failure provenance was still written with `status: failed`, `exitCode: 2`, `wallTime: 1.08`. This is the evidence for both the missing-`.dict` prerequisite and the failure-provenance claim in What good looks like. |
| 8 | `gatk CreateSequenceDictionary -R GRCh38.chr20.10.0-10.5Mb.fasta` | 0 | ~20 s | Produced the 249-byte `.dict`. This is the exact command the chapter's shell block gives as the fix. |
| 9 | `lungfish-cli gatk haplotype-caller ... --execute` (GVCF) | 0 | **25.4 s** | Printed exactly the two documented lines, "GATK execution completed with exit code 0." and "Provenance: <path>". Wrote `HG002.chr20.g.vcf.gz` (851,397 bytes) and a `.tbi`. |
| 10 | `lungfish-cli gatk haplotype-caller ... --emit-ref-confidence NONE --execute` | 0 | **23.1 s** | Wrote `HG002.chr20.vcf.gz`, the genotyped VCF matching the dialog's mode. |
| 11 | `lungfish-cli variants phase ... --output-dir phased` (preview) | 0 | instant | Printed the two-command plan. Confirms `-ERC NONE` hard-coded, `gatk-unphased.vcf.gz` intermediate, and `--native-pair-hmm-threads 1`. |
| 12 | `lungfish-cli variants phase ... --threads 4 --execute` | 0 | **26.0 s** | Printed both commands then "Phased variant calling complete." Provenance records two tool steps, gatk 23.2 s and whatshap 2.8 s. |
| 13 | `lungfish-cli variants phase ... --threads 8` and `--threads=6` and `--threads 6` first (previews) | 0 | instant | All three still printed `--native-pair-hmm-threads 1`. Evidence for the `--threads` defect. |
| 14 | `bcftools view/query` counts over both outputs, `samtools depth` over the BAM | 0 | seconds | Every figure in Reading the results. |

## Figures taken from those runs

All counts come from run 9, run 10, or run 12 output, computed with bcftools
1.x from the managed `bcftools` environment.

Genotyped VCF (`HG002.chr20.vcf.gz`, from run 10):

- 1,026 total records.
- 843 SNVs, 184 indels (`bcftools view -H -v snps|indels`).
- Genotype breakdown 589 `0/1`, 418 `1/1`, 19 `1/2`.
- Mean QUAL 902.9, rounded to 903 in prose. Mean per-sample DP 38.3, rounded to 38.
- First record `chr20_10.0-10.5Mb 2078 . G A 2175.06`, the source of the
  "first row reads 2175.06" sentence.

GVCF (`HG002.chr20.g.vcf.gz`, from run 9):

- 48,057 total records.
- 46,858 rows whose only ALT is `<NON_REF>`, that is reference blocks.
- 1,199 rows carrying a real alternate allele. 46,858 + 1,199 = 48,057, checks out.
- First row `chr20_10.0-10.5Mb 1 . G <NON_REF> . . END=3`, confirming the block form.

Phased VCF (`phased/HG002.phased.vcf.gz`, from run 12):

- 1,026 records, same as the unphased genotyped VCF.
- Genotypes 418 `1/1`, 216 `0/1`, 188 `0|1`, 185 `1|0`, 19 `1/2`.
- 188 + 185 = 373 phased heterozygous calls out of 589, leaving 216 unphased.
- 125 distinct `PS` values, that is 125 phase sets.

Alignment and benchmark:

- Mean depth 44.7 across all 500,001 reference positions (`samtools depth -a`).
  Prose rounds to 44.7 and the CONSISTENCY sheet's "mean depth is 45" is the
  same number.
- Benchmark VCF holds 961 records on contig `chr20_10.0-10.5Mb`.

Provenance record fields confirmed by reading `.lungfish-provenance.json`:
`appVersion`, `endTime`, `hostOS`, `id`, `name`, `parameters`, `runtime`,
`startTime`, `status`, `steps`. Each step carries `command`, `dependsOn`,
`endTime`, `exitCode`, `id`, `inputs`, `outputs`, `startTime`, `stderr`,
`toolName`, `toolVersion`, `wallTime`. The chapter's list of what provenance
holds is drawn from these keys, not from the ground-truth table alone.

## Source files consulted for window claims

Every GUI sentence in the chapter traces to one of these, read directly.

- `Sources/LungfishApp/Views/BAM/BAMVariantCallingCatalog.swift`. Lines 15-16
  register both tool ids. Lines 30-33 give the display names "GATK
  HaplotypeCaller" and "GATK + WhatsHap Phased". Lines 168-170 give the two
  subtitles, quoted verbatim including their trailing periods. Lines 47-55
  give the pack gates, `gatk-core`/`gatk4` for the first and both
  `gatk-core`/`gatk4` and `phasing`/`whatshap` for the second.
- `Sources/LungfishApp/Views/BAM/BAMVariantCallingToolPanes.swift`. Line 31
  the `Picker("Alignment Track", ...)`. Line 39 the
  `TextField("Output Variant Track Name", ...)`. Lines 46-70 render the
  Thresholds fields unconditionally, which is why they are drawn for GATK.
  Line 80 the GATK settings line "GATK HaplotypeCaller will write a standard
  genotype VCF for the selected BAM." Line 83 the phased line "GATK
  HaplotypeCaller and WhatsHap will be assembled as a phase-aware command
  plan." Line 139 the section heading "Extra arguments".
- `Sources/LungfishApp/Views/BAM/BAMVariantCallingDialogState.swift`. Line 170
  the readiness string "Ready to run GATK HaplotypeCaller on <track>." Lines
  255-269 `prepareForRun`, showing the phased branch sets both
  `pendingRequest` and `pendingGATKRequest` to nil. Lines 403-405 the output
  path `variants/gatk/<generatedTrackID>.vcf.gz`. Line 411
  `emitReferenceConfidence: .none`, the basis for the "the dialog always asks
  for a plain VCF" claim. Confirmed by grep that
  `minimumAlleleFrequency`/`minimumDepth` are never read on the GATK path.
- `Sources/LungfishApp/Views/Inspector/InspectorViewController+VariantWorkflow.swift`.
  Lines 81-99 the launcher, which reads only `pendingGATKRequest` then
  `pendingRequest` and otherwise raises the "Variant Calling Not Ready" alert.
  Lines 26-33 the "No Analysis-Ready BAM Tracks" guard, lines 35-42 the
  "Operation in Progress" guard.
- `Sources/LungfishWorkflow/Variants/GATKBundleVariantAttachmentService.swift`
  line 177, the track description "GATK HaplotypeCaller variants from
  <alignment>".
- `Sources/LungfishWorkflow/Variants/PhasedVariantCallingPlan.swift` lines
  38-66 the configuration struct, lines 89-98 the hard-coded `-ERC NONE` and
  the `gatk-unphased.vcf.gz` intermediate, line 97 the threads interpolation.
- `Sources/LungfishCLI/Commands/VariantsCommand.swift` lines 353-400 the
  `PhaseSubcommand` option declarations, lines 453-470 `buildPlan`.
- `Sources/LungfishWorkflow/Conda/PluginPack.swift` line 332 onward for
  `isExperimental`.
- CLI help under `reviews/fidelity-2026-09/cli-help/gatk.txt` and
  `variants.txt` for every flag name, default, and help string.

Grep evidence for the orphaned phased plan: `pendingPhasedVariantPlan` occurs
only at `BAMVariantCallingDialogState.swift` lines 48, 92, 260, 264 and 267.
No file outside that one reads it. This independently reproduces ground-truth
row 35.

## Defects found

Four, three of them new relative to the reality map.

1. **The phased GUI entry cannot run** (already in the reality map as row 35,
   reconfirmed here by grep). Selecting **GATK + WhatsHap Phased** and
   clicking Run raises "Variant Calling Not Ready" and writes nothing, because
   the dialog stores the plan in `pendingPhasedVariantPlan` and no consumer
   exists. Documented in Step 5 as a limitation with the CLI route given.

2. **`lungfish-cli variants phase --threads` is silently ignored** (new).
   Verified with `--threads 4`, `--threads 6` in first position,
   `--threads=6`, and `--threads 8`. Every one still emits
   `--native-pair-hmm-threads 1`, and the plan JSON's `options.threads`, the
   provenance `parameters.threads`, and the executed command all record 1.
   The source path looks correct end to end
   (`VariantsCommand.swift:460` passes `threads` into
   `PhasedVariantCallingConfiguration`, whose init at
   `PhasedVariantCallingPlan.swift:62` stores `max(1, threads)`, and line 97
   interpolates it), so the value is being lost at parse or dispatch time in
   the shipped binary rather than in the plan builder. I did not chase it
   further because the chapter documents observed behaviour. Documented in the
   `--threads` settings paragraph as not working in this release.

3. **LGE never creates the GATK sequence dictionary** (new). A `--execute`
   run against a reference that has a `.fai` but no `.dict` always fails with
   GATK's user error. Nothing in the CLI or the pipeline executor generates
   one, and the GUI path takes its reference from the bundle, which also
   carries no `.dict`. This is a hard blocker on a first run and the fix is
   one Picard command the user must know to issue. Documented in Before you
   start and given as the second command in the shell block.

4. **First `conda install gatk4 --env gatk-core` failed on a filesystem
   error** (new, and possibly environmental). micromamba reported
   `filesystem error: in create_directory: No such file or directory
   [".../envs/gatk-core/conda-meta"]` and rolled the transaction back. Disk
   had 115 GB free and the parent `envs/` directory was writable. Removing the
   partial `envs/gatk-core` directory and re-running succeeded. I have not
   reproduced it a second time, so I record it as a flake worth watching
   rather than a certain defect, and the chapter does not mention it.

## What I could not verify

- **The two screenshots.** `<!-- SHOT: call-variants-dialog-gatk -->` and
  `<!-- SHOT: operations-panel-gatk-run -->` are declared with captions but no
  images exist. Capturing them belongs to the Screenshot Scout at gate 2.
  Everything the captions describe is verified from source, so the captions
  should not need revision when the shots are taken.
- **The GUI run end to end.** I did not launch the app. Every window claim in
  the chapter is traced to a named source file and line above, which is the
  arbiter the brief specifies, but no claim here rests on my having watched
  the dialog. In particular the wording of the readiness line, the disabled
  badge text, and the two blocking alerts are read from source strings rather
  than seen on screen.
- **Whether the `--threads` defect also affects the GUI phased path.** Moot,
  since that path cannot run at all.
- **`features.yaml`'s `variants.gatk-germline` entry is stale.** The reality
  map records that it names a nonexistent `lungfish gatk genotype` and omits
  the GUI entry point. I cite the id in `features_refs` as the reality map
  directs but did not edit `features.yaml`, which the Code Cartographer owns.
- **The mkdocs nav label.** Reality map row 42 asks for the nav label in
  `build/mkdocs.yml:117` to change from "HaplotypeCaller Dry Runs" to
  "HaplotypeCaller". That file is not mine to edit and I left it alone. The
  chapter's own `title` is already "HaplotypeCaller".

## Glossary terms added

Six, inserted alphabetically into `docs/user-manual/GLOSSARY.md` and listed in
the chapter's `glossary_refs`.

`genotype-quality`, `germline`, `local-reassembly`, `phase-set`,
`read-backed-phasing`, `sequence-dictionary`.

All six use the existing entry shape, one sentence plus a "See also:" line.
Every anchor in `glossary_refs` and every inline `GLOSSARY.md#` link in the
chapter was checked to resolve against a real `{#anchor}`.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/06-human-germline-variants/01-haplotype-caller.md`

Final result:

```
docs/user-manual/chapters/06-human-germline-variants/01-haplotype-caller.md: no issues found
```

Two warnings were fixed to reach it. A colon inside a sentence, caused by
quoting GATK's "Unknown tool pack: gatk-core" message, rewritten to report the
unknown pack without quoting the string. And the word "stalling", on the
overused-word list, replaced in the `--max-alternate-alleles` paragraph.

## Structure

Section order follows the ARCHITECTURE template. What it is, Why you would do
this, Before you start, Procedure, Settings, Reading the results, What good
looks like, On the command line, Next.

Nineteen Settings paragraphs. Five cover the controls both registry entries
share, in the registry's label order and with labels copied verbatim. Nine
cover `variants.call-gatk-haplotypecaller`'s `cli_only` flags. Five cover
`variants.call-gatk-whatshap-phased`'s `cli_only` flags. Each closes with its
command-line flag or with "This setting has no command-line flag."

Front matter keeps `estimated_reading_min: 6`, `brand_reviewed: false`, and
`lead_approved: false`. `parameters_refs` names both registry ids.
`features_refs` set to `[variants.gatk-germline]` and `fixtures_refs` to
`[hg002-chr20]` per the reality map. `entry_points` corrected to the
**Tools > Call Variants...** route.
