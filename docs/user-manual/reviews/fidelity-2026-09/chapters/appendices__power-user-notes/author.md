# Author record, appendices/power-user-notes.md

Rewritten 2026-09-07 against Preview 2026.9.13, dependency set 2026.2.
Lint result: `no issues found` under `LUNGFISH_MANUAL_STRICT=1`.

The appendix holds 16 topic sections (H2s between the primer and Next): reading a
command out of the source, iVar, LoFreq, primer trimming, mapping, Kraken 2,
assembly, GATK, the provenance sidecar, reproducibility, pinning an
environment, the conda mutation lock, asserting an installation, debugging
from the Operations panel, reaching an unwrapped flag, and querying variants.

## Source lines behind every flag

Every argument list in the chapter cites a file under `Sources/` and the
line where its first argument is emitted. These are the lines I read.

| Claim in the chapter | Source line |
|---|---|
| `samtools mpileup -aa -A -d 600000 -B -Q 20 -q 0 -f` | `LungfishWorkflow/Variants/ViralVariantCallingPipeline.swift:1227-1238` (`ivarMpileupArguments`). Every value is a literal in source. Nothing overrides them. |
| `ivar variants -p <prefix> -q 20 -t <minAF> -m <minDepth> -r <ref> [-g <gff>]` | `ViralVariantCallingPipeline.swift:1240-1255` (`ivarVariantArguments`). `-t` defaults `request.minimumAlleleFrequency ?? 0.05`, `-m` defaults `?? 10`, `-q` is the literal `"20"`. |
| `--extra-args` on iVar is inserted after `variants` and before LGE's own arguments | `:1243-1244`, `args.append(contentsOf: request.advancedArguments)` precedes the `-p/-q/-t/-m/-r` append. |
| `-g` appears only when the bundle carries annotations, and its absence is silent | `:1266-1301` (`exportBundleGFFIfAvailable`) returns nil on a missing manifest, no annotations, no database path, or a failed export, each with a comment saying it is not surfaced. |
| The four `--ivar-*` flags never reach `ivar variants` | `:739-746` builds `IVarTSVToVCFConverter.Options` from them, `:790-801` records the step as `lungfish-internal ivar-tsv-to-vcf --consensus-af ... --merge-af-threshold ... --bad-quality-threshold ... --ignore-strand-bias ...`. None appears in `ivarVariantArguments`. |
| Codon merge is three tests, one of them a fixed 0.40 to 0.60 band | `LungfishWorkflow/Variants/IVarCodonMerger.swift:105-113` (`mergeRuleCheck`). Line 106 is the consensus test, 107 the literal `>= 0.4 && <= 0.6` band, 113 the merge-threshold distance test. |
| `lofreq call -f <ref> -o <vcf> <bam>` is the whole ordinary command | `ViralVariantCallingPipeline.swift:1217-1225` (`lofreqCallArguments`). |
| No `call-parallel`, `--pp-threads`, or `--no-default-filter` anywhere | `grep -rn "call-parallel\|pp-threads\|no-default-filter" Sources/` returns nothing. |
| indelqual runs only when `--call-indels` is present | `:1188-1189`, `lofreqRequiresIndelQualityPreprocessing` is `request.advancedArguments.contains("--call-indels")`. Branch at `:580`. |
| `lofreq indelqual --dindel -f <ref> -o <bam> <bam>` and `lofreq index <bam>` | `:1200-1215` (`lofreqIndelqualArguments`, `lofreqIndexArguments`). |
| `ivar trim -b -i -p -q -m -s -x -e` | `LungfishWorkflow/Primers/BAMPrimerTrimPipeline.swift:29-49` (`buildIvarTrimArgv`). The doc comment at `:18-19` states `-e` keeps unmatched reads. |
| Primer-trim defaults 20 / 30 / 4 / 0 and `--target-reference` | `cli-help/bam.txt`, `==== bam primer-trim ====`. |
| minimap2 `-a -x <preset> -t -R [--secondary=no] -o <sam> <ref> <fastq>` | `LungfishWorkflow/Mapping/MappingCommandBuilder.swift:76-101`. Preset default `"sr"` at `:85`. |
| bwa-mem2 `mem -t -R <index> <fastq>` | `MappingCommandBuilder.swift:104-124`. |
| bowtie2 `-x -p --rg-id --rg ... -S` | `MappingCommandBuilder.swift:127-158`. |
| BBMap `ref= out= threads= nodisk=t overwrite=t secondary=` and extras placed first | `MappingCommandBuilder.swift:161-200`. Line 166, `var arguments = request.advancedArguments + [...]`, is the placement claim. |
| Kraken 2 `--db --threads --confidence --minimum-hit-groups --output --report --report-minimizer-data` | `LungfishWorkflow/Metagenomics/ClassificationConfig.swift:365-405` (`kraken2Arguments`). `--report-minimizer-data` is unconditional at the end, extras appended after it. |
| SPAdes `--isolate\|--meta\|--plasmid -1/-2 or -s -o --threads [--memory]` | `LungfishWorkflow/Assembly/ManagedAssemblyPipeline.swift:177-208`. Profile default `"isolate"` at `:180`. |
| MEGAHIT `-1/-2 or -r -o --num-cpu-threads [--min-contig-len] [--presets] [--memory] [--no-hw-accel]` | `ManagedAssemblyPipeline.swift:211-243`. The `--no-hw-accel` condition is `:236-239`. |
| SKESA pinned to `--min_count 2` with the reason in a comment | `ManagedAssemblyPipeline.swift:268-272`. |
| Flye `--<readmode> <input> --out-dir --threads`, default `nano-hq` | `ManagedAssemblyPipeline.swift:278-296`, read mode at `:283`. |
| hifiasm `-o <prefix> -t <n>` with `--ont` prepended for ONT | `ManagedAssemblyPipeline.swift:299-321`, the `--ont` insert at `:314-316`. |
| Min contig length reaches MEGAHIT and SKESA only; memory reaches SPAdes, MEGAHIT, SKESA only | Read from the five builders. Flye's and hifiasm's builders contain neither `effectiveMinContigLength` nor `memoryGB`. Confirmed by the 07-assembly gate findings. |
| GATK `HaplotypeCaller ... --native-pair-hmm-threads -ERC` | `LungfishWorkflow/Variants/GATKCommandBuilder.swift:384-395`. The phasing plan variant is `PhasedVariantCallingPlan.swift:92-97` with `-ERC NONE`. |
| `ops stats` reads only files named exactly `.lungfish-provenance.json` | `LungfishWorkflow/Provenance/OperationStatsAggregator.swift:73-96` compares `url.lastPathComponent == ProvenanceRecorder.provenanceFilename`, and that constant is `".lungfish-provenance.json"` at `ProvenanceRecorder.swift:202`. |
| `ops stats` counts only `status == .completed` | `OperationStatsAggregator.swift:38`. |
| `ops stats` peak RAM is the max over step `peakMemoryBytes` | `OperationStatsAggregator.swift:105-110`. |
| `ops stats --format` is advertised but unimplemented | `LungfishCLI/Commands/OpsCommand.swift:32-67`. `globalOptions` is declared but `run()` never branches on `--format`. Help text advertising it is `cli-help/ops.txt`. |
| Provenance envelope key list | `LungfishWorkflow/Provenance/ProvenanceEnvelope.swift:52-72` (properties) and `:76-112` (CodingKeys, including the legacy `name`/`status` aliases). `schemaVersion` default is `1` at `:117`. |
| Conda mutation lock file name and its three messages | `LungfishWorkflow/Conda/CondaRootMutationLock.swift:22` (`.install.lock`), `:12` (read-only root), `:95` (`waiting for conda lock held by pid`). |
| Failure reports at `~/Library/Logs/<app name>/Operations/Failures` | `LungfishKit/OperationFailureReportStore.swift:56-77` (path construction), `:20-22` (`defaultRetentionLimit = 50` and the pruning rationale), `:52-54` (keyed on app identity), `:73-78` (a failed write returns nil rather than raising). |
| OCI tarball members | `LungfishWorkflow/Containers/BundleContainerExportService.swift:73-81`. |
| Operations panel expanded row has four sections | `LungfishApp/Views/Operations/OperationsPanelController.swift:954-1005`, calling `buildCLICommandSection` (`:1046`), `buildOutputFilesSection` (`:1110`), `buildLogEntriesSection` (`:1179`), `buildErrorSection` (`:1285`). |
| Operations panel context menu items | `OperationsPanelController.swift:1500-1566` (`menuNeedsUpdate`). |
| Pinned tool versions | `LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`, `packageSpec` fields. |

## Facts taken from a run rather than from source

- The real LoFreq sidecar quoted in the chapter is
  `prov-export/chr20.lungfishref/variants/vc-7ed9726c-de61-4735-80cf-0735eee621ec.lungfish-provenance.json`
  in the campaign scratchpad. Read only. It shows `lofreq call -f ... -o ... <bam>`
  with no other flags, `samtools 1.24`, `bcftools 1.24`, `htslib 1.24` in the
  `toolVersion` strings, and `variantCallerVersion` holding LoFreq's
  `--version` refusal.
- The full provenance envelope block is modelled on
  `scratchpad/hbb-frame1.faa.lungfish-provenance.json`, a `lungfish translate`
  run of the HBB gene record. It carries `schemaVersion: 1`,
  `runtimeIdentity.dependencySet: "2026.2"`, and both the old and new
  spellings of the checksum and size keys in `files[]`.
- `bundle export --format container` was run against a nonexistent path on
  `.build/debug/lungfish-cli` and refused with
  `Error: The value 'container' is invalid for '--format <format>'.` before
  reaching the bundle, which confirms the collision independently of
  file-formats.md.
- `ops stats --help` was run and printed the `--format` option that
  `OpsCommand.swift` does not implement.

## Facts taken from a committed chapter or a gate file

Every entry in the consolidated caveat list is a gate finding, quoted from
`reviews/fidelity-2026-09/chapters/*/fable-gate.md` under Findings for
RESULTS.md, and each is linked to the chapter that documents it. The
specific sources are the gates for `05-variants__01`, `05-variants__02`,
`05-variants__04`, `05-variants__05`, `04-alignments__03`,
`04-alignments__04`, `06-classification__02`, `06-human-germline-variants__01`,
`06-human-germline-variants__03`, `07-assembly__01`, `07-assembly__02`,
`07-assembly__03`, `08-workflows__02`, `09-genotyping__02`, and
`09-genotyping__04`.

Other borrowed facts:

- The determinism pair (104 allele rows for `WD1_S148_L001` in both the
  whole Williams plate and the three-bundle rerun) is from
  `chapters/09-genotyping/02-running-genotyping.md` line 222, which the gate
  passed.
- The pivot workbook timestamp finding is from the `09-genotyping__04`
  fidelity report lines 231-235, which byte-compared two workbooks and found
  only `docProps/core.xml` differing.
- The conda lock and `--from-lockfile` wording is aligned to
  `chapters/appendices/cli-reference.md` line 520, which settled it first.
- The `--threads` shadowing on `variants phase` is from `cli-reference.md`
  line 169.
- The GATK storage exception, the `.dict`, and the discarded Thresholds
  fields are the CONSISTENCY ruling plus the `06-human-germline-variants__01`
  gate.
- The `/private/tmp` provenance publication failure is from `cli-reference.md`
  line 573.
- MEGAHIT's failure rate and the "rerunning is the only workaround" phrasing
  follow the CONSISTENCY assembly ruling verbatim in substance.
- The `--format json` gap on `ops stats` was independently confirmed here and
  matches the `08-workflows__03` gate's "reports an unknown option and exits
  zero".
- `Operations > Show Operations Panel` (Cmd-Shift-P) matches CONSISTENCY and
  `chapters/appendices/keyboard-shortcuts.md` line 137.

## The ten unverifiable claims

Nine were settled and one was dropped.

| DRIFT row | Disposition |
|---|---|
| 2, iVar is a two-process pipeline | Settled and corrected. It is three processes, because LGE's TSV-to-VCF converter is a recorded step of its own. |
| 5, the canonical `ivar variants` block | Settled from `ivarVariantArguments`. The chapter now names the real prefix and states that `--min-af` and `--min-depth` supply `-t` and `-m`. |
| 14, the sidecar sample must be reconciled against a real one | Settled. The invented sample was replaced wholesale by a block read from a real sidecar, and the chapter now describes both the envelope and the workflow-run shape because both exist. |
| 21, the `ops stats` skip rule and columns | Settled from `OperationStatsAggregator.swift` and `OpsCommand.swift`, and the chapter adds the three limits DRIFT did not know about. |
| 22, `peakMemoryBytes` and its camelCase oddity | Settled. The field exists on the step model but no campaign sidecar carried it, and the surrounding keys are camelCase too, so there is no oddity. The chapter says a missing figure is normal. |
| 26, what `conda lock` writes | Settled by aligning to `cli-reference.md` line 520, which lists the same contents from the same command. |
| 30, 31, the per-tool determinism table | Dropped. The table asserted per-tool determinism for nine tools with no evidence behind any row, and the campaign has evidence for only a few of them. The section now states what was actually measured and lets the rest go unclaimed. |
| 33, samtools indel realignment in 1.20 | Settled by replacing the unverifiable historical claim with the pinned-version statement DRIFT's own corrected wording asked for. |
| 35, the OCI tarball members | Settled from `BundleContainerExportService.swift:73-81`, and the chapter adds that the command cannot be reached in this release. |
| 37, which commands consume `--threads` | Settled the other way. The global `--threads` is accepted by every command because it is a root option, so the old two-list split was meaningless. The chapter states the one behaviour that matters, the shadowing on `variants phase`. |

## Claims dropped rather than corrected

- The whole per-tool determinism table (nine rows). No evidence for any row,
  and several rows named commands LGE does not run, such as
  `lofreq call-parallel --pp-threads 1`.
- "`--pp-threads` defaults to 4; raise for high-coverage runs" and
  "`--no-default-filter`, Lungfish runs its own filter normalization
  downstream". Neither flag exists in LGE.
- "Lungfish runs indelqual in every LoFreq pipeline. Yours must too." False.
  It runs only under `--call-indels`.
- The LoFreq strand-bias section's claim that LGE hands LoFreq the un-trimmed
  BAM as a convention. Nothing in the pipeline chooses a BAM by trim state.
  The BAM is whichever alignment track you selected. The strand-bias
  discussion moved to iVar, where a real setting controls it.
- The eight-field Operations Panel disclosure table and the "Re-run as CLI"
  button. The real expanded row has four sections and the copy affordance is
  a button labelled from the CLI Command section plus a Copy CLI Command
  context-menu item.
- "Stderr, Last 100 lines". No such cap exists in the panel code.
- The `source ~/.lungfish/conda/envs/ivar/bin/activate` block, replaced by
  `conda run` per DRIFT row 45.
- The `--extra-args "--gff annotations.gff3 --pass_only"` example, which
  taught the reader to fight a flag the pipeline already sets, per row 43.
- "Apple Containers, default on supported Macs". The `workflow run` executor
  choices are docker, conda, and local, with docker the default
  (`cli-help/workflow.txt`), and Apple Containerization is a runtime
  preference inside the app rather than a `--executor` value. Because DRIFT's
  own corrected wording ("select it with `--executor`") is itself wrong, the
  container comparison table was dropped rather than reworded, and the OCI
  paragraph carries what remains true.
- "The schema holds steady across Lungfish versions. New fields only ever get
  added, never renamed or removed." No such guarantee is stated or testable
  anywhere in the source.
- `"schema_version": 2` and `"version": "0.5.0-alpha11"`. Both wrong, and
  file-formats.md already states there is no `schema_version` key at all.

## App defects found while writing

1. `ops stats` never reads a per-output sidecar. It matches only the exact
   filename `.lungfish-provenance.json`, so a project full of
   `<name>.lungfish-provenance.json` files reports a sidecar count of zero.
   `OperationStatsAggregator.swift:93`.
2. `ops stats --format json` and `--format tsv` are advertised in the help
   and not implemented. `OpsCommand.swift:32-67` never branches on the
   option. This is the same class of defect the `08-workflows__03` gate found
   from the outside.
3. The four `--ivar-*` flags are named for iVar and configure an LGE-internal
   converter instead, which makes an LGE iVar call unreproducible with iVar
   alone. Not previously recorded as a defect, only as a Missing row.
4. `bundle export --format container` is unreachable because the subcommand's
   `--format` collides with the root command's. Already found by the
   file-formats author, confirmed here independently.
5. Every `files[]` entry carries two spellings of the checksum
   (`sha256`, `checksumSHA256`) and two of the size (`sizeBytes`, `fileSize`),
   which a consumer must know not to treat as four distinct fields.

## Could not verify

- Whether `peakMemoryBytes` is ever written in practice. The field exists on
  the model and no sidecar in the campaign scratchpad carries it. The chapter
  says a missing figure is normal rather than claiming the field is dead.
- Cross-architecture byte divergence. No Intel Mac was available, so the
  chapter states the mechanism and points at `runtimeIdentity.architecture`
  rather than claiming a measured difference.
- The exact `-x` preset minimap2 receives for each read type. The chapter
  states the `sr` default and that the preset follows the declared read type,
  without enumerating a mapping I did not read end to end.
- Whether the fastp arguments belong in this appendix. `fastp` appears in the
  tool lock and in recipe JSON but I found no Swift argument builder for it
  under `Sources/LungfishWorkflow/`, so no fastp section was written rather
  than one built on a guess.
- Whether the genotyping Python scripts have a stable argument surface worth
  documenting. They are generated and staged per run
  (`GenotypeWorkbookRevisionService.swift:698`,
  `ONTBarcodeDemuxGenotypingPipeline+Scripts.swift`), so there is no fixed
  flag list to quote and none was invented.
