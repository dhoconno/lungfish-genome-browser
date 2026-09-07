# Fidelity review, 06-human-germline-variants/01-haplotype-caller

Reviewed against Preview 2026.9.13, the Swift source in this worktree, the CLI
help dumps, `docs/user-manual/parameters.yaml`, and the author's scratch outputs
at
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/gatk-hc/`,
which were still on disk and so were recounted rather than taken on trust.

Every numeric figure in the chapter was recomputed from those files with
`bcftools` and `samtools` from the managed environments. Every GUI sentence was
traced to a source line. The `--threads` defect was reproduced against
`.build/debug/lungfish-cli` and its root cause identified, which the author's
report did not reach.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "GATK HaplotypeCaller is the Broad Institute's variant caller for germline variation" | true | Background fact, corroborated by `third-party-tools-lock.json` gatk4 `sourceUrl` pointing at `github.com/broadinstitute/gatk` | |
| 2 | Local reassembly description, "finds stretches where the reads look unsettled ... rebuilds the candidate sequences from the reads themselves" | true | Background fact, matches the new GLOSSARY entry `{#local-reassembly}` and GATK's documented behaviour | |
| 3 | "LGE ... assembles the GATK command, runs GATK inside a managed software environment, and files the result with a provenance record" | true | `GATKCommandBuilder.swift:16` (`environment: String = "gatk-core"`), `GATKPipelineExecutor.swift:786-798` | |
| 4 | "The command line runs the same tool on loose files and gives you the ten-subcommand GATK toolchain around it." | true | `cli-help/gatk.txt` carries exactly ten subcommand sections after the root banner, at lines 30, 62, 85, 104, 124, 143, 170, 195, 219, 244 | |
| 5 | "This feature is experimental. Turn on **Show Experimental Features** in **Settings > Advanced**" | true | `PluginPack.swift:625` (`isExperimental: true`), `AdvancedSettingsTab.swift:16-17`, `PluginManagerViewModel.swift:490-492` | |
| 6 | "only the command line writes the GVCF that step needs" | true | `BAMVariantCallingDialogState.swift:411` fixes `emitReferenceConfidence: .none`, `GATKCommand.swift:107-108` gives the CLI default `GVCF` | |
| 7 | "That consensus ships beside the reads as a benchmark VCF, and it holds 961 records over this window." | true | Recounted. `bcftools view -H HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz \| wc -l` returns 961 | |
| 8 | "A run on this slice takes well under a minute" | true | Recounted from provenance. The GVCF step's `wallTime` is 22.98 s, the genotyped run 23.1 s, the phased run 25.95 s total | |
| 9 | "choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window" | unverifiable | Not checked in this review. It is boilerplate repeated across committed Part V chapters and was verified there. Launching the app would settle it | |
| 10 | Fixture filenames `GRCh38.chr20.10.0-10.5Mb.fasta`, `HG002.chr20.10.0-10.5Mb_R1.fastq.gz`, `_R2.fastq.gz` | true | All three exist in `docs/user-manual/fixtures/hg002-chr20/` | |
| 11 | "The alignment LGE's mapper produces carries one already, reading `SM:HG002` on this fixture." | true | The staged BAM's `@RG` line reads `ID:HG002 SM:HG002 LB:HG002 PL:ILLUMINA PU:HG002`, per the author's `samtools view -H` and consistent with the GLOSSARY `{#read-group}` entry | |
| 12 | "LGE does not create that file, so a first `--execute` run against a bare FASTA fails with a GATK user error naming the missing `.dict`" | true | Author's run 7 failed with GATK's "Fasta dict file ... does not exist" against a FASTA that had a `.fai` but no `.dict`. No `.dict`-generating call exists anywhere under `Sources/`. The `.dict` in the scratch folder is dated after that failure, matching the recorded sequence | |
| 13 | "`lungfish-cli conda install --pack gatk-core` fails, reporting `gatk-core` as an unknown tool pack" | true | `CondaCommand.swift:159-166` resolves against `PluginPack.visibleForCLI`, which excludes experimental packs (`PluginPack.swift:958-971`), and `gatk-core` is experimental (`:625`). `PluginPackRegistryTests.swift:463-472` asserts the eight visible ids with gatk-core absent. Reality-map row 96 | |
| 14 | "install the underlying tool directly with `lungfish-cli conda install gatk4 --env gatk-core`" | true | The author's run 6 succeeded this way and `~/.lungfish/conda/envs/gatk-core` now exists with GATK 4.6.2.0 | |
| 15 | "an alert reading "No Analysis-Ready BAM Tracks" opens instead" | true | `InspectorViewController+VariantWorkflow.swift:26-33`, exact title string | |
| 16 | "an "Operation in Progress" alert opens instead" | true | `InspectorViewController+VariantWorkflow.swift:35-42`, exact title string | |
| 17 | "The same dialog opens from the Inspector's **Variant Calling** tab, where a **Call Variants...** button sits." | true | `InspectorView.swift:933`. The registry's second entry point reads "Inspector > Analysis > Variant Calling > Call Variants...", so the chapter's shorter path is a subset and not wrong | |
| 18 | Subtitle "Germline SNP and indel calling with standard VCF genotypes." | true | `BAMVariantCallingCatalog.swift:168`, exact string with trailing period | |
| 19 | "If the row is greyed out and badged "Requires GATK Core Pack"" | true | `BAMVariantCallingCatalog.swift:99` builds `"Requires \(pack.name) Pack"` and the pack name is "GATK Core" (`PluginPack.swift:619`). Note a second badge, "Requires GATK4", appears at `:103` when the pack is present but the tool is not ready, which the chapter does not mention. Not an error, only an omission | |
| 20 | "**Overview** holds an Alignment Track picker and an Output Variant Track Name field" | true | `BAMVariantCallingToolPanes.swift:23` heading "Overview", `:31` `Picker("Alignment Track", ...)`, `:39` `TextField("Output Variant Track Name", ...)` | |
| 21 | "**Thresholds** holds Minimum Allele Frequency and Minimum Depth." | true | `BAMVariantCallingToolPanes.swift:47` heading "Thresholds", `:50` and `:61` the two labels, rendered unconditionally | |
| 22 | "The section named for the tool comes next and holds no controls at all, only the line "GATK HaplotypeCaller will write a standard genotype VCF for the selected BAM."" | true | `BAMVariantCallingToolPanes.swift:74` builds the heading as `"\(state.selectedToolDisplayName) Settings"`, giving "GATK HaplotypeCaller Settings", and `:80` is the quoted line, exact | |
| 23 | "**Extra arguments** is a single text field." | true | `BAMVariantCallingToolPanes.swift:139` heading "Extra arguments", `:143` one `TextField` | |
| 24 | Readiness line "Ready to run GATK HaplotypeCaller on <track>." | true | `BAMVariantCallingDialogState.swift:169-170`, exact string | |
| 25 | "Both fields are drawn for every caller in the list, and neither reaches GATK." | true | `BAMVariantCallingToolPanes.swift:46-70` renders them unconditionally, and `makeGATKRequest` (`BAMVariantCallingDialogState.swift:392-418`) never reads `minimumAlleleFrequency` or `minimumDepth` | |
| 26 | "the two numbers are recorded with the run and then ignored" | **false** | They are not recorded. `prepareForRun` (`BAMVariantCallingDialogState.swift:255-269`) sets `pendingRequest = nil` on the GATK path, and `pendingRequest` is the only carrier of `minimumAlleleFrequency` and `minimumDepth` (`:280-281`). `makeGATKRequest` builds a `GATKHaplotypeCallerConfiguration` that has no such fields. Confirmed against the run's own provenance, whose `parameters` block holds `option.*` and `default.*` keys for reference confidence, ploidy, PCR indel model, max alternate alleles, threads, and confidence threshold, and no allele-frequency or depth key at all | "GATK decides which alleles to emit from its own genotype likelihoods, and the two numbers are discarded when the run starts. They reach neither GATK nor the provenance record." |
| 27 | "writes the VCF to `variants/gatk/<track-id>.vcf.gz` inside the bundle" | true | `BAMVariantCallingDialogState.swift:405-406`. This is a documented departure from the CONSISTENCY variant-track storage ruling, which describes `variants/<name>.vcf.gz` for tracks attached by `variants call`. See Consistency below | |
| 28 | "loads the rows into a small SQLite database beside it" | true | `GATKBundleVariantAttachmentService.swift:124-131` writes the `.db` sidecar, matching the CONSISTENCY ruling's `.db` sidecar | |
| 29 | Track description "GATK HaplotypeCaller variants from <alignment>" | true | `GATKBundleVariantAttachmentService.swift:177`, exact interpolation | |
| 30 | "A run that is taking too long can be cancelled from the Operations panel row." | true | `InspectorViewController+VariantWorkflow.swift:272-277`, `:296-298` | |
| 31 | "The dialog always asks GATK for a plain genotyped VCF of variant positions only." | true | `BAMVariantCallingDialogState.swift:411` (`emitReferenceConfidence: .none`) | |
| 32 | "the **Presets** button above the table reveals the filter chips" | true | CONSISTENCY.md:186-187 settles this, "The filter chips sit behind a **Presets** disclosure button above the Variants table" | |
| 33 | Phased subtitle "Phase-aware HaplotypeCaller plus WhatsHap command plan." | true | `BAMVariantCallingCatalog.swift:170`, exact string | |
| 34 | "It needs the `phasing` pack alongside `gatk-core`." | true | `BAMVariantCallingCatalog.swift:51-55`, two gates keyed to `gatk4` and `whatshap` | |
| 35 | "Selecting it and clicking Run raises an alert titled "Variant Calling Not Ready" and nothing is written." | true | Reproduced by grep. `pendingPhasedVariantPlan` occurs only at `BAMVariantCallingDialogState.swift` lines 48, 92, 260, 264, 267 and nothing outside that file reads it. `prepareForRun:261-264` nils both `pendingRequest` and `pendingGATKRequest` for this tool, and the launcher at `InspectorViewController+VariantWorkflow.swift:81-99` reads only those two before falling through to the alert at `:93-97`. Reality-map row 35 | |
| 36 | "The dialog builds the two-step plan correctly and then no part of the app reads it" | true | Same evidence as row 35. `makePhasedVariantPlan` (`:425-445`) builds a well-formed plan | |
| 37 | Settings, Alignment Track, "The default is the first analysis-ready BAM alignment track in the bundle, and any analysis-ready BAM track in that bundle is allowed" | true | `parameters.yaml:3705-3706` for both entries | |
| 38 | Settings, Alignment Track, "so the dialog does not preselect whichever track you arrived from" | unverifiable | Neither the registry nor `BAMVariantCallingDialogState` states how the initial selection interacts with the track the user opened the dialog from. Opening the dialog from a second track's row would settle it | |
| 39 | Settings, Alignment Track, "On the command line this is `--bam`." | true | `parameters.yaml:3709` and `:3797`, `cli-help/gatk.txt:38`, `cli-help/variants.txt` phase section | |
| 40 | Settings, Output Variant Track Name, "The default is the alignment name, then a bullet, then the tool name, and the app appends a number when that name is already taken" | true | `parameters.yaml:3712-3713`, `BAMVariantCallingDialogState.swift:300-320` | |
| 41 | Settings, Output Variant Track Name, "This setting has no command-line flag." | true | `parameters.yaml:3716` `cli_flag: null` | |
| 42 | Settings, Minimum Allele Frequency, "Records a frequency floor with the run without passing it to GATK" | **false** | Same defect as row 26. Nothing is recorded. The registry's own wording at `parameters.yaml:3721` ("Recorded with the run but not passed to GATK") is what the chapter followed, and the registry is wrong for the GATK entries specifically, since `pendingRequest` is nil on that path | "Sets a frequency floor that the GATK entries never use. GATK decides which alleles to emit from its own genotype likelihoods, and this number is discarded when the run starts rather than passed along or recorded." |
| 43 | Settings, Minimum Allele Frequency, "The default is 0.05, and a decimal between 0 and 1 or a blank field is allowed." | true | `parameters.yaml:3719-3720`, `BAMVariantCallingDialogState.swift:75` (`"0.05"`), validation at `:157-159` | |
| 44 | Settings, Minimum Depth, "Records a depth floor with the run without passing it to GATK." | **false** | Same defect as rows 26 and 42 | "Sets a depth floor that the GATK entries never use. The number is discarded when the run starts rather than passed along or recorded." |
| 45 | Settings, Minimum Depth, "the default here is 10, and any whole number or a blank field is allowed" | true | `parameters.yaml:3726-3727`, `BAMVariantCallingDialogState.swift:76` (`"10"`), validation at `:161-163` | |
| 46 | Settings, Extra arguments, "The default is empty and any HaplotypeCaller flags are allowed." | true | `parameters.yaml:3733-3734`, `BAMVariantCallingToolPanes.swift:143` (placeholder only, no initial value) | |
| 47 | Settings, Extra arguments, "On the GATK HaplotypeCaller entry this is `--extra-args` ... and on the phased entry it is `--extra-gatk-args`" | true | `parameters.yaml:3737` and `:3825`, `cli-help/gatk.txt` and `cli-help/variants.txt` | |
| 48 | "Nine more settings exist on `lungfish-cli gatk haplotype-caller` and have no control in the dialog." | true | `parameters.yaml:3738-3765` lists exactly nine `cli_only` flags, and the chapter documents all nine in registry order | |
| 49 | `--emit-ref-confidence`, "The default is `GVCF`, and `NONE` is the other accepted value." | true | `cli-help/gatk.txt:41-43`, `GATKCommand.swift:107-108`. Note `GATKCommand.swift:185` upper-cases and falls back to `.gvcf` on an unrecognised string, so a typo silently gives a GVCF. Not an error in the chapter, an omission | |
| 50 | `--ploidy`, "The default is 2" | true | `cli-help/gatk.txt:44`, `GATKCommand.swift:110-111` | |
| 51 | `--intervals`, "The default is none, so the whole reference is called" | true | `cli-help/gatk.txt:45`, `GATKCommandBuilder.swift:401` emits `-L` only when supplied | |
| 52 | `--pcr-indel-model`, "The default is `CONSERVATIVE`" | true | `cli-help/gatk.txt:46-48`, `GATKCommand.swift:116-117` | |
| 53 | `--stand-call-conf`, "The default is 30.0, and this threshold applies only when the run is not writing a GVCF" | true | `cli-help/gatk.txt:48-50`, `GATKCommandBuilder.swift:393-400` adds the threshold only in the non-GVCF branch. Reality-map row 28 | |
| 54 | `--max-alternate-alleles`, "The default is 6" | true | `cli-help/gatk.txt:51-52`, `GATKCommand.swift:122-123` | |
| 55 | `--pair-hmm-threads`, "The default is 4 and it is always emitted, in the dialog as well as on the command line" | true | `cli-help/gatk.txt:53-54`, `GATKCommandBuilder.swift:58` struct default and `:391` unconditional emission. Reproduced, `--pair-hmm-threads 7` prints `--native-pair-hmm-threads 7` | |
| 56 | `--execute`, "The default is off, which is why a first command prints and stops" | true | `GATKCommand.swift:42-45`, `:174`, `cli-help/gatk.txt:36` | |
| 57 | `--dry-run`, "passing it alongside `--execute` still produces a preview, since `--dry-run` wins whenever both are present" | true | `GATKCommand.swift:174` (`execute: execute && !dryRun`) | |
| 58 | "Five settings exist on `lungfish-cli variants phase` and have no control in the dialog." | **false** | `parameters.yaml:3826-3844` lists six `cli_only` flags for `variants.call-gatk-whatshap-phased`. The chapter documents `--output-dir`, `--sample`, `--threads`, `--extra-whatshap-args`, and `--extra-gatk-args`, but `--extra-gatk-args` is not a `cli_only` flag at all, it is the shared Extra arguments control's flag (`parameters.yaml:3825`) and is already covered in the shared paragraph. The two genuinely undocumented `cli_only` flags are `--execute` (`:3839`) and `--dry-run` (`:3842`), both confirmed in `cli-help/variants.txt` phase OPTIONS | "Six settings exist on `lungfish-cli variants phase` and have no control in the dialog." Then drop the `--extra-gatk-args` paragraph, which repeats the shared Extra arguments entry, and add paragraphs for `--execute` and `--dry-run`. That leaves the Settings section with twenty paragraphs, not nineteen |
| 59 | `--output-dir`, "The default is the folder holding the output VCF" | true | `parameters.yaml:3828`, `VariantsCommand.swift:409` (`outputDirectory ?? outputVCFURL.deletingLastPathComponent().path`) | |
| 60 | `--sample`, "The default is none" | true | `parameters.yaml:3831`, `VariantsCommand.swift:377-378` optional | |
| 61 | `--threads`, "Is documented as setting the GATK scoring threads, with a default of 1." | true | `cli-help/variants.txt` phase section, "GATK PairHMM threads (default: 1)", `VariantsCommand.swift:380-381` | |
| 62 | `--threads`, "It does not work in this release. A run passing `--threads 4` still prints and records `--native-pair-hmm-threads 1`" | true | Reproduced against `.build/debug/lungfish-cli` with `--threads 4`, `--threads 8`, `--threads=6`, and `--threads 6` in first position. All four print `--native-pair-hmm-threads 1`, and the written `phased-variant-command-plan.json` records `options.threads` and `resolvedDefaults.threads` as `1`. Root cause identified below, and it is not where the author looked | |
| 63 | `--threads`, "the plan file, the provenance record, and the executed command all show 1 whatever you pass" | true | Plan JSON `options.threads` is `1`, the phased run's provenance `parameters.threads` is `1`, and the printed GATK line carries `--native-pair-hmm-threads 1` | |
| 64 | `--extra-whatshap-args`, "The default is none, and the dialog offers no equivalent." | true | `parameters.yaml:3836-3838`, `VariantsCommand.swift:386-387`. `makePhasedVariantPlan` passes only `extraGATKArguments` (`BAMVariantCallingDialogState.swift:443`) | |
| 65 | "It always calls with `-ERC NONE` ... and it always writes its intermediate unphased calls to `gatk-unphased.vcf.gz` in the output directory." | true | `PhasedVariantCallingPlan.swift:89-98` hard-codes both. Confirmed on disk, `phased/gatk-unphased.vcf.gz` exists | |
| 66 | "writes 1,026 rows, of which 843 are SNVs ... and 184 are indels" | true, but the sum needs a sentence | Recounted. `bcftools view -H` gives 1,026, `-v snps` gives 843, `-v indels` gives 184. 843 + 184 = 1,027, one more than the total. See the Counts section for the reconciliation. The chapter never claims the two add to the total, so no sentence is false, but a reader will try the addition | Add one sentence after the counts. "Those two counts overlap by one row, because a single position carries both a substitution and an insertion as its two alternate alleles and so is counted under each heading." |
| 67 | "On this fixture 589 rows read `0/1` ... Another 418 read `1/1` ... A further 19 read `1/2`" | true | Recounted. `bcftools query -f '[%GT]\n'` gives exactly 589, 418, and 19, and 589 + 418 + 19 = 1,026 | |
| 68 | "Roughly three heterozygous sites for every two homozygous ones" | true | 589 to 418 is 1.41 to 1, which rounds to the stated three to two | |
| 69 | "The mean QUAL across this fixture is 903 ... with the first row of the file reading 2175.06." | true | Recounted. Mean QUAL 902.93, and the first record is `chr20_10.0-10.5Mb 2078 G A 2175.06` | |
| 70 | "The mean depth across these 1,026 calls is 38, against a mean of 44.7 across the whole aligned window." | true | Recounted. The per-sample `FORMAT/DP` mean is 38.34 and `samtools depth -a` gives 44.723 over all 500,001 positions. Note the chapter's 38 is the `FORMAT/DP` mean while chapter 02 quotes 39.4 for the same rows, which is the `INFO/DP` mean (recounted at 39.387). Both are right and they answer different questions. See Consistency | |
| 71 | "The same reads written as a GVCF give 48,057 rows, because 46,858 of them are reference blocks ... Only 1,199 rows carry a real alternate allele." | true | Recounted. 48,057 total, 46,858 rows whose only ALT is `<NON_REF>`, 1,199 with a real alternate, and 46,858 + 1,199 = 48,057 | |
| 72 | "The phased route's output has the same 1,026 rows" | true | Recounted. `phased/HG002.phased.vcf.gz` holds 1,026 records | |
| 73 | "373 of the 589 heterozygous calls came back phased, 188 as `0\|1` and 185 as `1\|0`, gathered into 125 phase sets. ... The 216 heterozygous calls that stayed `0/1`" | true | Recounted. Genotypes are 418 `1/1`, 216 `0/1`, 188 `0\|1`, 185 `1\|0`, 19 `1/2`. 188 + 185 = 373, 373 + 216 = 589, and 125 distinct `PS` values | |
| 74 | "The VCF's sample column should carry the name from the BAM's read group, which is `HG002` here" | true | The BAM's `@RG` carries `SM:HG002` and GATK writes that as the sample column | |
| 75 | "a HaplotypeCaller run returning 1,026 is the right order of magnitude" against 961 benchmark records | true | Both counts recounted, 1,026 and 961 | |
| 76 | "A successful `--execute` prints two lines, the GATK exit code and the path to the provenance record." | true | `GATKCommand.swift:50-51`. Author's run 9 printed both | |
| 77 | "A failed one prints neither, raises an error, exits nonzero, and still writes a provenance record with a failed status" | true | `GATKPipelineExecutor.swift:768-777` writes provenance with `status: .failed` before throwing, and `:50` is unreachable once `run` throws. Author's run 7 recorded `status: failed`, `exitCode: 2`. Reality-map rows 19, 20, 21 | |
| 78 | "LGE also deletes the outputs that run created, leaving anything that existed beforehand untouched" | true | `GATKPipelineExecutor.swift:758`, `:767`, `:811-831` | |
| 79 | "It holds the exact GATK command, the environment it ran in, the inputs and outputs with their checksums and sizes, the exit status, the wall time, and GATK's stderr." | true | Read back from the run's own `.lungfish-provenance.json`. Top-level keys are `appVersion`, `endTime`, `hostOS`, `id`, `name`, `parameters`, `runtime`, `startTime`, `status`, `steps`, and each step carries `command`, `exitCode`, `inputs`, `outputs`, `stderr`, `toolName`, `toolVersion`, `wallTime` | |
| 80 | "the record reports a wall time of about 23 seconds for the calling step" | true | Read back. The step's `wallTime` is 22.977 s | |
| 81 | "Every `lungfish-cli gatk` command builds and prints a GATK command without running anything." | true | `GATKCommand.swift:42-45`, `cli-help/gatk.txt:4-7` | |
| 82 | The quoted preview line, `gatk HaplotypeCaller -R ... -ERC GVCF` | true | Reproduced. The printed line matches the chapter's `text` block exactly in argument order and spelling | |
| 83 | "GVCF mode appears as GATK's short form `-ERC GVCF` ... and the thread count appears as `--native-pair-hmm-threads`" | true | `GATKCommandBuilder.swift:391`, `:393-394`. Reality-map rows 10 and 27 | |
| 84 | "LGE splits the quoted string into separate arguments and appends them to the end of the GATK command unchanged, and a string it cannot split is rejected before anything runs." | true | `GATKCommand.swift:54-59` routes through `AdvancedCommandLineOptions.parse`, which can throw a `ValidationError`, and `GATKCommandBuilder.swift:404` appends the parsed tokens last. This is the reality map's row 11 correction, adopted verbatim | |
| 85 | "That run prints both commands, then "Phased variant calling complete."" | true | Reproduced in preview, both commands print. The completion line is the author's run 12 output | |
| 86 | "It writes the phased VCF, the intermediate `gatk-unphased.vcf.gz` and its index, a `phased-variant-command-plan.json` recording the plan, and a provenance record covering both steps." | true | All five confirmed on disk in `phased/`. The provenance holds three steps, gatk, whatshap, and the wrapping `lungfish variants phase` | |
| 87 | "On this fixture the whole thing took 26 seconds, 23 in GATK and 3 in WhatsHap." | true | Read back from the phased provenance. gatk 23.17 s, whatshap 2.76 s, wrapper 25.95 s | |
| 88 | "the phased VCF is written without an index, so a tool that needs one wants `tabix -p vcf` run over it first" | true | Confirmed on disk. `phased/` holds `gatk-unphased.vcf.gz.tbi` but no `HG002.phased.vcf.gz.tbi` | |
| 89 | "Nine more GATK subcommands sit alongside `haplotype-caller` ... Each takes `--execute` and `--dry-run` the same way." | true | Ten sections total in `cli-help/gatk.txt`, and the nine named areas match joint-genotype, filter, select, variants-to-table, bqsr, markdup, validate-sam, leftalign, collect-metrics. All ten gate identically at `GATKCommand.swift:174`, `:271`, `:355`, `:442`, `:535`, `:637`, `:740`, `:842`, `:948`, `:1048` | |

Verdicts: 82 true, 5 false, 2 unverifiable.

## Front matter

`title`, `chapter_id`, `audience`, `task`, `tags`, and `tools` are all
consistent with the chapter body.

`parameters_refs` names both registry ids and both exist at
`parameters.yaml:3689` and `:3776`. Correct.

`entry_points` lists the Tools > Call Variants... route, `gatk haplotype-caller`,
and `variants phase`. All three are real, and the first adopts the reality map's
row 41 correction. The registry also lists the Inspector route, which the body
covers in Step 1 but the front matter omits. Minor, and not wrong.

`prereqs` names `01-foundations/05-variants-and-vcf` and
`01-foundations/07-plugin-packs`. Both files exist.

`glossary_refs` names 27 anchors. Every one resolves against a real `{#anchor}`
in `docs/user-manual/GLOSSARY.md`, checked mechanically. Every inline
`GLOSSARY.md#` link in the body is drawn from that set.

`shots` declares two ids with captions and the body carries the matching two
`<!-- SHOT: ... -->` markers. `illustrations` is empty, which is defensible.

`features_refs: [variants.gatk-germline]` follows reality-map row 43. That
entry is itself stale, since it names a nonexistent `lungfish gatk genotype`
and omits the GUI entry point, but `features.yaml` belongs to the Code
Cartographer and the citation is what the reality map directs.

`fixtures_refs: [hg002-chr20]` matches the fixture folder.

`brand_reviewed: false` and `lead_approved: false` are correct for this stage.

One front-matter gap sits outside the file. `build/mkdocs.yml:118` still labels
this page "HaplotypeCaller Dry Runs" in the site nav, contradicting the
chapter's own title and its whole argument that `--execute` is real. Reality-map
row 42 asked for this and it is still unfixed. It belongs to whoever owns
`mkdocs.yml`.

## Settings coverage against parameters.yaml

`variants.call-gatk-haplotypecaller` declares five `settings` and nine
`cli_only` flags. `variants.call-gatk-whatshap-phased` declares five `settings`
and six `cli_only` flags. The five shared controls are identical in label and
order across the two entries, so the chapter's decision to cover them once is
sound.

Shared controls, five of five covered. Alignment Track, Output Variant Track
Name, Minimum Allele Frequency, Minimum Depth, Extra arguments. Labels are
copied verbatim from the registry and appear in registry order. Each paragraph
carries the three required sentences and closes with its flag or with "This
setting has no command-line flag." Two of the five, Minimum Allele Frequency and
Minimum Depth, describe their effect wrongly, per claims 42 and 44.

HaplotypeCaller `cli_only`, nine of nine covered, in registry order, with every
default matching both the registry and `cli-help/gatk.txt`.

Phased `cli_only`, four of six covered. `--output-dir`, `--sample`, `--threads`,
and `--extra-whatshap-args` are documented. `--execute` and `--dry-run` are
missing. The chapter's fifth paragraph in that subsection documents
`--extra-gatk-args`, which the registry does not list as `cli_only` at all,
since it is the shared Extra arguments control's own flag at
`parameters.yaml:3825` and is already covered in the shared paragraph. So the
subsection's count is right by accident and wrong by content. Fixing it means
dropping the `--extra-gatk-args` paragraph, adding `--execute` and `--dry-run`,
and changing "Five settings" to "Six settings". The chapter then has twenty
Settings paragraphs rather than nineteen.

Nothing else in either registry entry is undocumented.

## Consistency

Against the committed Part V chapters, the dialog description holds. The
Overview section, the Alignment Track picker, and the Output Variant Track Name
field are described here exactly as the committed chapters describe them, and
all three are confirmed at `BAMVariantCallingToolPanes.swift:23`, `:31`, and
`:39`. The Presets disclosure for the filter chips matches CONSISTENCY.md:186.

Against the CONSISTENCY variant-track storage ruling, there is a real
divergence that the chapter gets right. The ruling describes a variant track as
`variants/<name>.vcf.gz` with a `.tbi` and a `.db` sidecar. The GATK dialog path
writes `variants/gatk/<track-id>.vcf.gz` instead, with the track id rather than
the track name as the filename, confirmed at
`BAMVariantCallingDialogState.swift:405-406`. The `.db` sidecar and the manifest
entry do follow the ruling. The chapter states the `variants/gatk` path and
separately explains that the name field names the track while the file keeps a
generated identifier, so it describes the divergence accurately. The
CONSISTENCY sheet should gain this as a second exception alongside the
`bundle create --variant` one already recorded there, so a later chapter does
not "correct" this to the general rule.

Against the just-written joint-genotyping chapter, one figure is quoted two
ways. This chapter says the mean depth across the 1,026 calls is 38. Chapter 02
says "Mean depth across the 1,026 rows was 39.4 reads." Both are correct and
they measure different fields, recounted here at `FORMAT/DP` 38.34 and
`INFO/DP` 39.387. A reader moving between the two chapters will read this as a
contradiction. The two chapters should say which depth they mean, or settle on
one field. This is the editor's call, not a defect in either chapter, and it
wants a CONSISTENCY entry either way.

Every other shared figure agrees between the two chapters. Both quote 1,026
rows, 843 substitutions, 184 indels, and 48,057 GVCF rows, and all four were
recounted here from the same files.

The 961-record benchmark count appears only in this chapter and is confirmed.

The `-ERC GVCF` versus `--emit-ref-confidence` distinction, the `--extra-args`
tokenizing correction, and the "Variant Calling Not Ready" finding are all
carried consistently from the reality map into both chapters.

## App defects

The author reported four. All four are confirmed, one is sharpened, and one new
one is added.

1. **The phased GUI entry has no consumer.** Confirmed independently by grep.
`pendingPhasedVariantPlan` is written at `BAMVariantCallingDialogState.swift:264`
and read nowhere outside that file, while the launcher at
`InspectorViewController+VariantWorkflow.swift:81-99` reads only
`pendingGATKRequest` and `pendingRequest`, both nil for this tool. Run therefore
always reaches the "Variant Calling Not Ready" alert. This reproduces
reality-map row 35. The chapter documents it as a limitation in Step 5 and gives
the working CLI route, which is the right handling.

2. **`variants phase --threads` is ignored, and the cause is an option
collision, not a lost value.** Reproduced with four spellings, all printing
`--native-pair-hmm-threads 1`. The author looked at the plan builder and found
the source path correct end to end, which it is. The actual cause is one level
up. `lungfish-cli` declares a global `--threads` option in `GlobalOptions`
(`name: [.customLong("threads"), .customShort("t")]`, help "Number of threads to
use (default: auto)"), and the phase subcommand declares its own
`--threads` (`VariantsCommand.swift:380`, help "GATK PairHMM threads"). The
global wins. The proof is the error text from `--threads abc`, which reports
the failure against the root usage line and quotes the global option's help
string, "Number of threads to use (default: auto)", not the subcommand's. So
the subcommand's `threads` property never leaves its default of 1 no matter what
the user passes. This also explains why `gatk haplotype-caller
--pair-hmm-threads 7` works correctly, since that flag has no global twin. The
fix is to rename the phase option or to have it read the global value. The
chapter's "does not work in this release" wording stays accurate either way.

3. **LGE never creates the GATK sequence dictionary.** Confirmed. No `.dict`
generating call exists under `Sources/`, and the author's run 7 failed with
GATK's user error against a FASTA carrying a `.fai` but no `.dict`. The chapter
warns about this in Before you start and gives `gatk CreateSequenceDictionary`
as the second command in the shell block, which is the right handling for a
hard first-run blocker.

4. **The micromamba `create_directory` failure on a first `conda install
gatk4 --env gatk-core`.** Not reproducible in this review, and the author saw it
once. Recorded as a flake. The chapter correctly does not mention it.

5. **New. The dialog's Minimum Allele Frequency and Minimum Depth are
discarded, not recorded, on both GATK entries.** This is the substance behind
claims 26, 42, and 44. `prepareForRun` nils `pendingRequest` on both GATK
paths, and `pendingRequest` is the only object carrying those two values, so
they reach neither GATK nor the provenance record. The run's own provenance
confirms it, holding `option.*` and `default.*` keys for six GATK parameters and
none for allele frequency or depth. Two consequences follow. The chapter needs
the wording changes in claims 26, 42, and 44. And `parameters.yaml:3721`,
`:3728`, `:3809`, and `:3816` all say "Recorded with the run", which is wrong
for these two entries and should be corrected by whoever owns the registry.
Beyond the docs, showing a user two fields that are silently thrown away is a UI
defect worth filing, since the honest options are to hide them on the GATK
entries or to record them.

## Notes for the editor

The chapter is in good shape. Five false claims, three of which are one
underlying source fact, and one of which is a miscount in the phased `cli_only`
subsection.

Highest priority. Fix the "recorded with the run" wording in three places, the
Step 2 paragraph and the two threshold Settings paragraphs. The current wording
tells a reader their numbers are preserved in provenance, and they are not, so a
reader who later goes looking for them in the provenance record will conclude
the record is broken.

Second. Fix the phased `cli_only` subsection. Change "Five" to "Six", drop the
`--extra-gatk-args` paragraph as a duplicate of the shared Extra arguments
entry, and add `--execute` and `--dry-run`. The `--execute` paragraph matters
more than most, because without it a reader of that subsection has no statement
that the phased command previews by default, and the code block in On the
command line passes `--execute` without ever explaining it for this command.

Third. Add one sentence reconciling 843 plus 184 against 1,026. A reader flagged
this on the joint-genotyping chapter, so it will be flagged again here. The
suggested wording is in claim 66.

Fourth. Settle the mean-depth field with chapter 02, either by naming the field
in both chapters or by picking one.

Two smaller things. The chapter mentions only the "Requires GATK Core Pack"
badge, while a second badge "Requires GATK4" appears when the pack is installed
but the tool is not ready. And `--emit-ref-confidence` falls back to GVCF on an
unrecognised value rather than erroring, which is worth a clause given the
chapter tells readers to type `NONE`.

Outside the chapter. The mkdocs nav label at `build/mkdocs.yml:118` still reads
"HaplotypeCaller Dry Runs". The registry's "Recorded with the run" effect text
needs correcting at four lines. The CONSISTENCY sheet wants the `variants/gatk`
storage exception and the depth-field ruling.

Both shot captions describe only things confirmed in source. The first caption
names the Overview section, the Alignment Track picker, the Output Variant Track
Name field, the Thresholds fields, and the readiness line, all verified. The
second names the Operations panel row with its GATK command and provenance, and
the Operations wiring is confirmed at
`InspectorViewController+VariantWorkflow.swift:212-254`. Neither caption should
need revision when the shots are taken. One caveat, the first caption calls the
Thresholds fields "the Thresholds fields the GATK tools ignore", which stays
true under the corrected wording, since ignoring is exactly what happens.

Lint is clean. `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports no issues, and
I re-ran it to confirm.

## Counts

Claims checked, 89. True 82, false 5, unverifiable 2.

False claims, one line each.

- Claim 26, "the two numbers are recorded with the run and then ignored". They
  are discarded, not recorded.
- Claim 42, Minimum Allele Frequency "Records a frequency floor with the run".
  Nothing is recorded.
- Claim 44, Minimum Depth "Records a depth floor with the run". Nothing is
  recorded.
- Claim 58, "Five settings exist on `lungfish-cli variants phase`". The registry
  lists six, and the chapter's fifth is a duplicate of a shared control.
- Claim 58 also carries the omission of `--execute` and `--dry-run` from that
  subsection, counted once above.

Figures recounted from the author's scratch outputs, all confirmed. 1,026 rows,
843 SNVs, 184 indels, 589 het, 418 hom, 19 `1/2`, mean QUAL 902.93, mean
`FORMAT/DP` 38.34, mean BAM depth 44.723, benchmark 961, GVCF 48,057 with 46,858
reference blocks and 1,199 alternate rows, phased 1,026 with 373 phased hets in
125 phase sets, wall times 22.98 s, 23.1 s, and 25.95 s.

The 1,026 reconciliation. 843 plus 184 is 1,027, one more than the total,
because `bcftools` counts one record under both headings. The record is
`chr20_10.0-10.5Mb 2078`-window position 29224, `REF A`, `ALT G,AGG`, whose
`TYPE` is `SNP,INDEL`. Its first alternate is a substitution and its second is
an insertion, so `view -v snps` and `view -v indels` both return it. The full
`TYPE` breakdown is 842 `SNP`, 178 `INDEL`, 5 `INDEL,OVERLAP`, and 1
`SNP,INDEL`, which sums to exactly 1,026. Under the Part V convention of
classifying on the first alternate allele the split would be 844 SNVs and 182
indels, which does sum to 1,026 but does not match the numbers either chapter
prints. The cleanest fix keeps the printed 843 and 184, which are what a reader
reproduces with the chapter's own `bcftools` commands, and adds one sentence
saying the two overlap by one record.

Defects. Four confirmed, one of them with a corrected root cause, and one new.
