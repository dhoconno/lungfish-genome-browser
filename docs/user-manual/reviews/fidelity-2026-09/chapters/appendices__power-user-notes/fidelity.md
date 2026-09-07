# Fidelity review, appendices/power-user-notes.md

Reviewed 2026-09-07 against the Swift source, `.build/debug/lungfish-cli`,
the campaign scratchpad sidecars (read only), the committed chapters, the 60
`fable-gate.md` files, CONSISTENCY.md, and DRIFT.md `### appendices.md/power-user-notes.md`.

The chapter is in unusually good shape. Every argument list the author cites
was read at the cited line and every one matches. The two corrections below
are both narrow, and one of them is an app defect the author found and then
described one step too generously.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| `samtools mpileup -aa -A -d 600000 -B -Q 20 -q 0 -f ref bam`, all fixed, nothing overrides | true | `ViralVariantCallingPipeline.swift:1226-1238`. Every value is a string literal in `ivarMpileupArguments`, which takes only `plan`. | |
| `ivar variants -p ivar.tsv-prefix -q 20 -t 0.05 -m 10 -r ref -g gff` | true | `:1240-1255`. Prefix literal `"ivar.tsv-prefix"`, `-q` literal `"20"`, `-t` is `minimumAlleleFrequency ?? 0.05`, `-m` is `minimumDepth ?? 10`. | |
| Extra-args on iVar sit after `variants` and before LGE's arguments, so LGE wins | true | `:1242-1244`. `args.append(contentsOf: request.advancedArguments)` precedes the `-p/-q/-t/-m/-r` append. | |
| `-g` appears only with bundle annotations, and its absence is silent | true | `:1266-1301` returns nil on a missing manifest, no annotation with a non-empty `databasePath`, or a failed export, with no user-facing message. | |
| The four `--ivar-*` flags never reach `ivar variants` and configure LGE's converter | true | `:739-746` builds `IVarTSVToVCFConverter.Options` from them, `:790-801` records the `lungfish-internal ivar-tsv-to-vcf` step. None appears in `ivarVariantArguments`. | |
| Codon merge is three tests, any one sufficient, one a fixed 0.40 to 0.60 band | true | `IVarCodonMerger.swift:105-113`. Line 106 consensus, 107 the literal `>= 0.4 && <= 0.6`, 113 the merge-threshold distance. | |
| `lofreq call -f ref -o vcf bam` is the whole ordinary command | true | `:1217-1225`, and the real sidecar's LoFreq step carries exactly `lofreq call -f ... -o ... <bam>`. | |
| Extra-args on LoFreq land between `call` and `-f` | true | `:1218-1220`, `["call"] + request.advancedArguments + ["-f", ...]`. | |
| No `call-parallel`, `--pp-threads`, or `--no-default-filter` anywhere in LGE | true | `grep -rn "call-parallel\|pp-threads\|no-default-filter" Sources/` returns nothing. | |
| indelqual and index run only under `--call-indels` | true | `:1188-1189`, `lofreqRequiresIndelQualityPreprocessing` is `advancedArguments.contains("--call-indels")`. Builders at `:1200-1215`. | |
| The LoFreq sidecar recorded the bare call "then six further steps" | true | The chr20 sidecar holds 10 steps. Two staging steps and `samtools faidx` precede the call, and exactly six follow it (bcftools reheader, bcftools sort, bgzip, tabix, variant-sqlite-import, the CLI wrapper). | |
| Every LoFreq sidecar records `variantCallerVersion` holding LoFreq's `--version` refusal | true | Quoted verbatim in the chr20 sidecar's `parameters`: `FATAL(lofreq_main.c\|main:336): Unrecognized command '--version'`. | |
| `ivar trim -b -i -p -q 20 -m 30 -s 4 -x 0 -e`, `-e` fixed and keeping unmatched reads | true | `BAMPrimerTrimPipeline.swift:29-49`, and the doc comment at `:18-19` states the `-e` rationale. Defaults from `cli-help/bam.txt`. | |
| `--target-reference` overrides the reference name resolving the scheme against `@SQ SN` | true | `cli-help/bam.txt` `==== bam primer-trim ====`, and the 04-alignments__03 gate records the silent exit-0 mistrim. | |
| minimap2 `-a -x sr -t -R --secondary=no -o ref fastq`, preset defaults `sr` | true | `MappingCommandBuilder.swift:76-101`, preset `mode.commandPresetValue ?? "sr"` at `:85`. | |
| minimap2 extras sit after the read group and before `-o` | true | `:88-92`. `--secondary=no` is appended between them, which the sentence does not contradict. | |
| A read group is always written on all four mappers | true | `:75, :108, :131, :175`. Every builder calls `resolvedReadGroup` unconditionally and emits `-R`, `--rg-id`, or `rgid=`. | |
| BBMap places extras first, ahead of everything LGE sets | true | `:166`, `var arguments = request.advancedArguments + [...]`. | |
| Secondary alignments off unless asked, `--secondary=no` and `secondary=f` | true | `:86-88` and `:180`. | |
| Kraken 2 flag list, four conditional flags, `--report-minimizer-data` always present | true | `ClassificationConfig.swift:365-405`. The four conditionals are `--memory-mapping`, `--quick`, `--paired`, `--fasta-input`. | |
| An LGE kreport is eight columns wide | true | `--report-minimizer-data` unconditional at `:399`, and `06-classification/02-running-kraken2.md:276` states six by default plus two. | |
| Kraken 2 extras are appended after every LGE flag and before the inputs | true | `:400-405`. `args += extraArguments` then the input loop. | |
| SPAdes profile is `--isolate`/`--meta`/`--plasmid`, default `--isolate` | true | `ManagedAssemblyPipeline.swift:178-190`, `selectedProfileID ?? "isolate"`. | |
| MEGAHIT gets `--no-hw-accel` where threads are capped, unless extras set it | true | `:236-239`, guarded on `host.capsMegahitThreads` and `!containsArgument(named:"--no-hw-accel",...)`. | |
| SKESA pinned to `--min_count 2`, its documented default, to avoid zeroing a small assembly | true | `:268-272`, with the reason in the source comment. | |
| Flye read mode becomes the flag itself, defaulting to `nano-hq` | true | `:283-286`, `"--\(readMode)"` with `selectedProfileID ?? "nano-hq"`. | |
| A `nano-hq` profile "is passed as `--flye --nano-hq`" | **false** | `:285` builds `["--\(readMode)", inputURL.path, ...]` on executable `flye` (`:292`). The command is `flye --nano-hq <input>`. There is no `--flye` argument anywhere, and the chapter's own bash block one screen earlier shows `flye --nano-hq reads.fastq`, so the sentence contradicts its own example. | "so a `nano-hq` profile is passed as `--nano-hq`, and it defaults to `nano-hq`" |
| hifiasm gets `--ont` prepended for Nanopore reads | true | `:314-316`, `arguments.insert("--ont", at: 0)` when `readType == .ontReads`. | |
| Min contig length reaches MEGAHIT and SKESA only | true | `--min-contig-len` at `:224-226`, `--min_contig` at `:262-264`. Neither `buildFlyeCommand` nor `buildHifiasmCommand` nor `buildSpadesCommand` reads `effectiveMinContigLength`. | |
| Memory reaches SPAdes, MEGAHIT, and SKESA and never Flye or hifiasm | true | `--memory` at `:199-201`, `:230-232`, `:259-261`. Absent from the Flye and hifiasm builders. | |
| GATK `HaplotypeCaller -R -I -O --native-pair-hmm-threads -ERC GVCF` | **false** | `GATKCommandBuilder.swift:384-395` always also emits `--sample-ploidy`, `--max-alternate-alleles`, and `--pcr-indel-model` between `-O` and `--native-pair-hmm-threads`. The block is presented as the built command and omits three arguments LGE passes on every run, which is exactly the omission this appendix exists to prevent. | Add the three to the block, as `gatk HaplotypeCaller -R reference.fasta -I input.bam -O output.g.vcf.gz --sample-ploidy 2 --max-alternate-alleles 6 --pcr-indel-model CONSERVATIVE --native-pair-hmm-threads 8 -ERC GVCF`, taking the three values from the dialog's defaults, or say in the prose that three further arguments carry dialog settings. |
| `-ERC` selects reference-confidence mode, and the phasing plan uses `-ERC NONE` | true | `:396-403` emits `-ERC` only when `emitReferenceConfidence != .none`, and `PhasedVariantCallingPlan.swift:92-97` passes `-ERC NONE` literally. | |
| GATK writes to `variants/gatk/<track-id>.vcf.gz` with a SQLite sidecar | true | `GATKBundleVariantAttachmentService.swift:124-129, :266`. | |
| The Thresholds fields are discarded on both GATK entries, and LGE never creates the `.dict` | true | The `06-human-germline-variants__01` gate's Findings record both. | |
| Sidecar naming, the `provenance/` folder, and the bare root sidecar | true | `ProvenanceRecorder.provenanceFilename` is `".lungfish-provenance.json"`, and the scratchpad holds all three shapes (`hbb-frame1.faa.lungfish-provenance.json`, `prov-export/out-json/provenance/source/...`, and bundle-root files). | |
| The quoted envelope block came from the `lungfish translate` HBB sidecar | **false** | The file exists and the quoted values are real, but the block is not what the file holds. The real sidecar carries three further top-level keys the block omits (`createdAt`, `output`, `runtime`), and it shows `options`, `parameters`, `outputs`, and `steps` as empty (`{}` and `[]`) when all four are populated in the file. `parameters` holds five entries, `outputs` one file record, and `steps` one step. A reader checking the block against a sidecar of their own will conclude their file is wrong. | Either quote the file as it stands, or keep the abridgement and label it, replacing the four emptied values with an elision comment and adding the three missing keys. The claim that follows it, that `options` splits `explicit` from `defaults`, is true and is better served by a populated block. |
| `schemaVersion` is `1` and camelCase, so `schema_version` finds nothing | true | `schemaVersion: 1` in the real file, and no snake_case key anywhere in it. | |
| Every `files[]` entry carries `sha256` and `checksumSHA256`, `sizeBytes` and `fileSize`, pairwise equal | true | Both `files[]` entries in the HBB sidecar carry all four, with the members of each pair identical. | |
| `signatures` is empty unless a signer is configured, off by default | true | `"signatures": []` in the real file. | |
| The workflow-run shape's ten top-level keys | true | The chr20 LoFreq sidecar's top level is exactly `id, name, appVersion, hostOS, startTime, endTime, status, runtime, parameters, steps`. | |
| Its `parameters` record every setting, each with a `type` and a `value` | true | 24 entries in the chr20 sidecar, each an object with `type` and `value`. | |
| A setting a caller ignores is written as `caller-default` | true | `minimumAlleleFrequency` and `minimumDepth` both read `caller-default` in that LoFreq run. | |
| The `steps` field list | true | Each chr20 step carries `id, command, dependsOn, startTime, endTime, exitCode, toolName, toolVersion, wallTime, inputs, outputs`, with `stderr` optional. | |
| The quoted `toolVersion` string | true | Byte-identical to the chr20 samtools step: `1.24 (managed conda environment samtools; executable samtools; package bioconda::samtools=1.24=h36b3a25_1)`. | |
| `peakMemoryBytes` exists, is optional, and no campaign sidecar carried it | true | `OperationStatsAggregator.swift:105-110` reads `compactMap(\.peakMemoryBytes)`, and no step in either sidecar holds the key. | |
| `ops stats` reports sidecar count, completed runs, total wall time, then a per-operation table | true | `OpsCommand.swift:37-66`, and confirmed by running it. | |
| It counts only files named exactly `.lungfish-provenance.json` | true | `OperationStatsAggregator.swift:73-96`. Confirmed by running `ops stats` on a folder holding one real `hbb-frame1.faa.lungfish-provenance.json`, which reported `Provenance sidecars: 0`. | |
| It counts only `status == .completed` | true | `:38`, `runs.filter { $0.status == .completed }`. | |
| Peak RAM reads `unknown` when no step recorded it | true | `formatBytes` returns `"unknown"` on nil, and the run above printed it. | |
| `--format json` and `--format tsv` are advertised and unimplemented | true | `cli-help/ops.txt` advertises all three, and `OpsCommand.StatsSubcommand.run()` never reads `globalOptions.outputFormat`. Running `--format json` printed the text table and exited 0. | |
| "an option it does not recognise produces an error line and exit status 0. A script must read the output rather than trust the status" | **false** | `lungfish-cli ops stats <dir> --format bogus` prints `Error: The value 'bogus' is invalid for '--format <format>'` and exits **64**, not 0. `OutputFormat` is a `CaseIterable` `ExpressibleByArgument` enum (`GlobalOptions.swift:14-17, :247`), so ArgumentParser rejects an unknown value before `run()` is entered. The advice inverts the real hazard, which is that an accepted-but-ignored `--format json` exits 0 with text on stdout. | "The `--format json` and `--format tsv` options the help text advertises are not implemented, so the command prints its text table whatever you pass and still exits 0. A value the parser does not recognise is refused with exit status 64. So a script must read the output rather than infer the format from the status." |
| The genotyping determinism pair, 104 rows for `WD1_S148_L001` in both runs | true | `09-genotyping/02-running-genotyping.md:222` states exactly this, and its gate passed. | |
| The pivot workbook differs only in `docProps/core.xml` | true | The `09-genotyping__04` gate's Findings record the embedded-timestamp difference. | |
| MEGAHIT fails most runs on Apple Silicon, rerunning the only workaround, a completed run correct | true | CONSISTENCY.md:201-206 fixes this wording for every chapter that offers MEGAHIT. The chapter matches it. | |
| Flye "occasionally" doubles a small circular genome, hifiasm "consistently" on the mitochondrial fixture | true, with a wording note | `07-assembly/03-running-flye-or-hifiasm.md:170-172` records one doubling in four runs and calls it rare, and says hifiasm's doubling is not rare and rerunning will not clear it. "Occasionally" reads as more frequent than "rarely". | Prefer "rarely doubles", matching the chapter and the gate. Not a false claim. |
| The assembly viewport shows no circularity column | true, incomplete | `:160` of that chapter says the table shows neither circularity nor multiplicity. The appendix names only circularity, and multiplicity is the field that actually exposed Flye's doubling. | Optionally "no circularity or multiplicity column". |
| Multi-threaded tools can differ between runs at different thread counts | true | `cli-reference.md:171` states it, and GLOSSARY determinism carries the same qualification. | |
| The global `--threads` is consumed by the root command, so `variants phase` records one thread | true | `cli-reference.md:169` and the `06-human-germline-variants__01` gate. | |
| Every consolidated caveat traces to a gate finding | true | All ten paragraphs check out against the gates named in the author's report. See Consistency below for the two caveats that could have been added. | |
| `runtimeIdentity.architecture` exists for auditing cross-processor runs | true | Present in the HBB sidecar with value `arm64`. | |
| The twelve pinned tool versions | true | All twelve match `third-party-tools-lock.json` `packageSpec` values, GATK included at `gatk4=4.6.2.0`. | |
| A plugin pack pins the recipe and not every transitive dependency | true | `cli-reference.md:660` states the `--pack` route re-solves and can land on newer versions. | |
| `conda offline-export` writes `offline-pack-manifest.json` with a checksum and size per file, and `offline-install` restores with no network | true | `CondaOfflinePackService.swift:79`, and `cli-help/conda.txt`. | |
| `conda lock` writes a requested specification in JSON, not conda-lock compatible, no byte-identical rebuild | true | `CondaCommand.swift:226-256`, whose abstract reads "not a resolved lock". Aligned with `cli-reference.md:658`. | |
| `conda lock` leaves a provenance sidecar beside its output | true | `:250-255` prints `result.provenanceURL`. | |
| `conda install --from-lockfile` exists only to refuse, failing before it changes an environment | true | `:93-94` help text, `:111-121` validation, and the subcommand abstract at `:26`. | |
| The OCI tarball members | true | `BundleContainerExportService.swift:74-81` lists `oci-layout`, `index.json`, the config blob, the manifest blob, one layer blob, and the provenance record. | |
| `bundle export --format container` is unreachable, refused as invalid, and omitting the flag fails as missing | true | Ran both. `--format container` gives `The value 'container' is invalid for '--format <format>'` (exit 64), and omitting it gives `Missing expected argument '--format <format>'` (exit 64). | |
| The conda mutation lock at `<conda-root>/.install.lock`, exclusive, taken before anything is touched | true | `CondaRootMutationLock.swift:22` for the filename, `:90` for `flock(fd, LOCK_EX \| LOCK_NB)`. | |
| Its three outcomes and their exact messages | true | `:95` writes `waiting for conda lock held by pid <n>` then blocks on `LOCK_EX`; `:12` is `conda root is read-only; reinstall as the admin user`; `:15-17` report the underlying errno with the path. | |
| `tools update --plan` compares against the bundled manifest and changes nothing | true | `cli-help/tools.txt` `==== tools update ====`. | |
| Exit 10 pending, 0 nothing needed, 2 usage, 1 install failure, and receipt failure warns and exits 0 | true | All five stated verbatim in that help text. | |
| `--json`, `--required-only`, `--include-databases`, and the no-effect combination | true | Same help text, which states the no-effect note explicitly. | |
| The Operations panel opens with **Operations > Show Operations Panel** (Cmd-Shift-P) | true | CONSISTENCY.md:33-34. | |
| An expanded row shows four sections, each built only when it has content | true | `OperationsPanelController.swift:952-1005`. Each of the four is inside a guard on `cliCommand`, `outputURLs`, `logEntries`, or the failed state. | |
| The context menu is built fresh per clicked row, with the six items described | true | `:1502-1566`. Run Again is gated on a replay source, Copy CLI Command on a recorded command, the three log items on log entries, and the three failure items on the failed state. | |
| Failure reports at `~/Library/Logs/<app name>/Operations/Failures` | true | `OperationFailureReportStore.swift:56-77`. | |
| Keyed on app identity, fifty kept and pruned on each write, a failed write swallowed | true | `:52-54`, `:20-22` (`defaultRetentionLimit = 50`), `:73-78`. | |
| `--extra-args` and the repeatable `--extra-arg` both exist on some commands | true | Both spellings appear across the CLI help dumps. | |
| `conda run [--env <name>] <tool> [args...]` passes stdout, stderr, and exit status through and records no provenance | true | `cli-help/conda.txt`, and DRIFT row 45's own corrected wording. | |
| `bam adopt-mapping` wants a `lungfish map` result directory rather than a loose BAM | true | DRIFT row 46 settles it and asks that the warning be kept. | |
| `variants query` and `variants extract-sample` read a bundle's variant database | true | `cli-help/variants.txt` `==== variants ====`. | |
| A per-sample filter clause reads a `FORMAT DP` bcftools does not write | true | The `05-variants__02` gate's Findings. | |

## Front matter

Correct and complete. `chapter_id` matches the path, `audience: power-user`
suits the material, `tools` lists the fourteen wrapped tools the body
documents, and `entry_points`, `shots`, `illustrations`, `features_refs`, and
`fixtures_refs` are all legitimately empty for a reference appendix with no
procedure and no window of its own. `parameters_refs` is absent, which is
right here, since the appendix documents argument lists rather than owning any
operation's settings. All 29 `glossary_refs` resolve to a `{#anchor}` in
GLOSSARY.md, including the three new ones. `brand_reviewed` and
`lead_approved` are both false, which is correct at this stage.

`estimated_reading_min: 24` is plausible for a body of this length.

## Consistency

No claim in the chapter contradicts a committed chapter. Three of the
caveat-list paragraphs quote gate findings almost verbatim, and the rest
compress a gate finding without changing it.

Two caveats the gates recorded are absent from the consolidated list, and both
are arguably in scope for a page whose stated subject is reproducibility.

The first is from the `04-alignments__04` gate. `runMarkDuplicatesWorkflow`
and `runCreateDeduplicatedBundleWorkflow` have no `canStartOperation` guard
and never register with OperationCenter, so a marking run can start on a
bundle another operation is mutating and posts no row at all. That is a
reproducibility hazard of the concurrency kind the chapter already covers
under the conda mutation lock, and the samtools paragraph cites that same gate
for its `markdup` sentence while leaving this one out.

The second is from the `08-workflows__02` gate. `provenance verify` exits 64
with an error line on an ordinary unsigned record. The chapter tells the
reader that `signatures` is empty by default, so the command that checks a
sidecar failing on exactly that default state belongs beside it.

Neither omission is an error. The list is explicitly "every reproducibility
defect", though, so both are worth a sentence or an explicit note that the
list is scoped to defects that change a result rather than defects in the
tooling around it.

One smaller drift. The chapter says `conda lock` records "the pack identity,
the requested packages, the platforms, the channels, and the post-install
hooks", where `cli-reference.md:658` says "the environment names, packages,
platforms, channels, source overlays, and post-install hooks". Source overlays
are dropped and environment names are rendered as pack identity. The two
chapters should name the same list.

The MEGAHIT wording follows CONSISTENCY.md rather than the `07-assembly__01`
gate's "about four runs in five", which is the right precedence.

## App defects

All five of the author's findings are confirmed, four of them by running the
CLI as well as by reading the source.

1. `ops stats` never reads a per-output sidecar. Confirmed by running it on a
   directory holding one genuine `hbb-frame1.faa.lungfish-provenance.json`,
   which reported `Provenance sidecars: 0`. `OperationStatsAggregator.swift:93`.
2. `ops stats --format json` and `--format tsv` are advertised and
   unimplemented. Confirmed by running `--format json` and getting the text
   table with exit 0. `OpsCommand.swift:32-67`.
3. The four `--ivar-*` flags configure LGE's own TSV-to-VCF converter rather
   than iVar. `ViralVariantCallingPipeline.swift:739-746` and `:790-801`.
4. `bundle export --format container` is unreachable in both directions.
   Confirmed by running both forms, each exiting 64.
5. Every `files[]` entry writes the checksum and the size twice, under an old
   and a new spelling. Confirmed in both scratchpad sidecars.

One new defect, small and documentation-adjacent rather than behavioural.

6. The `ops stats` `--format` option is a root-level `GlobalOptions` property
   (`GlobalOptions.swift:14-17`), so every `lungfish-cli` subcommand advertises
   `text, json, tsv` in its own help whether or not it implements any of them.
   `ops stats` is one instance of a general gap between the advertised global
   surface and the implemented one, which is worth recording once at the CLI
   level rather than per command. It is also the mechanism behind defect 4,
   since `bundle export`'s own `--format` is shadowed by this global one.

## Notes for the editor

Three fixes, in order of how much a reader is misled.

The GATK block is the one to fix first. A reader of this appendix is here
precisely because they want the whole argument list, and the block omits three
arguments LGE passes on every HaplotypeCaller run. It is the only place in the
chapter where a quoted command is incomplete rather than abridged-and-labelled.

The `ops stats` exit-status sentence is the only outright false statement about
behaviour, and its practical advice points the reader at the wrong hazard. The
correction is in the claim table and preserves the useful half of the sentence.

The Flye `--flye --nano-hq` phrase contradicts the chapter's own bash block two
paragraphs above it, so it reads as a typo rather than a misunderstanding, and
the fix is deleting three characters.

On the envelope block, the abridgement is defensible and the chapter would be
worse for quoting 200 lines of paths. The problem is only that it presents
itself as read from the file while showing four populated structures as empty.
A single elision line inside the block fixes it, and populating `options` with
one explicit and one default entry would also make the sentence about that
split land harder.

The two missing caveats under Consistency are the editor's call. If the list
stays as it is, the lead-in sentence should say what it is scoped to, because
"every reproducibility defect the 2026-09 campaign found" is a strong claim
and the campaign found two more that touch reproducibility.

Prose is clean. Lint passes under `LUNGFISH_MANUAL_STRICT=1` with no issues,
there are no em dashes, the two semicolons both sit inside verbatim quoted
strings from real output rather than in authored prose, no H2 exceeds the
bullet and list caps, "Lungfish Genome Explorer (LGE)" is introduced once and
"LGE" used after, and every internal link resolves.

## Counts

True 71, false 4, unverifiable 0.
