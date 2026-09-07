# Fidelity review, 06-human-germline-variants/02-joint-genotyping

Roster row 43. Registry id `variants.gatk-plans`. Reviewed 2026-09-07 against
Preview 2026.9.13, the Swift source in this worktree, the CLI help tree, and
the author's scratch outputs at
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/gatk-joint/`.

Every command I ran was a preview or a read. No file in the scratch tree was
written, and nothing was written to `~/Desktop/lge-docs/`. The author's
`.lungfish-provenance.json` in scratch is the record of their command 19
(the deliberate failure), which overwrote the successful run's record, so
the two-step timings are checked against the author record rather than
recomputed.

## Claim table

| # | Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "Joint genotyping has no dialog and no menu item in Lungfish Genome Explorer (LGE)" (line 24, repeated 42, 69) | true | A grep for `jointGenotype`, `joint-genotype`, `JointGenotyp`, `GenotypeGVCFs`, `CombineGVCFs` across `Sources/LungfishApp/` and `Sources/LungfishKit/` returns **0 hits**. `BAMVariantCallingCatalog.swift:9-16` lists seven tools, none of them a joint-genotype tool | |
| 2 | "LGE builds this as two GATK commands rather than one." (line 30) | true | `GATKCommandBuilder.swift:582-610` returns two `GATKCommand`s for the combine path, `:612-640` two for the GenomicsDB path | |
| 3 | GVCF records state at every position, VCF only where it differs (line 26) | true | Background genomics fact, consistent with `GLOSSARY.md` gvcf entry. Borne out by the fixture, 48,057 GVCF rows against 1,026 cohort rows | |
| 4 | "The Call Variants dialog reaches exactly one GATK tool, HaplotypeCaller, and joint genotyping is not among the tools it offers." (line 69) | **false** (first half) | `BAMVariantCallingCatalog.swift:15-16` declares **two** GATK cases, `gatkHaplotypeCaller` ("GATK HaplotypeCaller", `:31`) and `gatkWhatsHapPhased` ("GATK + WhatsHap Phased", `:33`). Chapter 01 line 98 documents the second entry explicitly. The second half of the sentence is true | "The Call Variants dialog reaches two GATK tools, GATK HaplotypeCaller and GATK + WhatsHap Phased, and joint genotyping is not among the tools it offers." |
| 5 | "Four of them are required and the run refuses to start without them." (line 118) | **false** | Only three are required. `--gvcf` is optional in the parser. Omitting it entirely (`lungfish-cli gatk joint-genotype --reference ... --intermediate c.g.vcf.gz --output c.vcf.gz`) exits **0** and prints a `CombineGVCFs` line carrying no `--variant` argument at all. The usage line brackets it, `cli-help/gatk.txt:64`. Recorded below as a new defect | "Three of them are required and the run refuses to start without them. A fourth, `--gvcf`, ought to be required and is not." |
| 6 | "The GATK toolchain shares three flags across all ten of its subcommands" (line 118) | true | `cli-help/gatk.txt` holds ten subcommand blocks besides the parent. I parsed each block, and all ten carry `--execute`, `--dry-run`, and `--extra-args` | |
| 7 | "the other seven subcommands are covered in [Filtering, Selecting, and Metrics] and [Reference Packs]" (line 118) | **false** (two errors) | Ten subcommands minus joint-genotype leaves **nine**, not seven. Of those nine, chapter 03 covers five (filter, select, variants-to-table, collect-metrics, leftalign) and chapter 04 covers one (bqsr), a total of six. `markdup` and `validate-sam` appear in **no chapter of the manual** (grep over `docs/user-manual/chapters/`), and haplotype-caller is chapter 01's, not either of these two | "and six of the other nine are covered in [Filtering, Selecting, and Metrics](03-filtering-selecting-and-metrics.md) and [Reference Packs](04-reference-packs.md)." |
| 8 | Preview prints the two composed command lines and stops (lines 73, 83-88) | true | Reran the exact command. Output matches the chapter's quoted block token for token, including the `--standard-min-confidence-threshold-for-calling 30.0 -G AS_StandardAnnotation` tail. `GATKCommand.swift:41-44` returns after emitting when `execute` is false | |
| 9 | "The command prints two lines when it finishes." `GATK execution completed with exit code 0.` and `Provenance: ...` (lines 103-108) | true | `GATKCommand.swift:49-51` emits exactly those two strings | |
| 10 | "The exit code on that first line is the exit code of the last GATK step rather than a figure for the run as a whole" (line 110) | true | `GATKPipelineExecutor.swift:804`, `exitCode: executedCommands.last?.result.exitCode ?? 0`. Matches drift row 59's correction | |
| 11 | "The recorded run took 3.3 seconds of wall time ... split as 1.61 seconds for the combine step and 1.62 for the genotyping step." (line 112) | unverifiable | The successful run's provenance was overwritten by the author's later failure run, so the split cannot be recomputed. The author record (command 5) states it, and the surviving structure carries a `wallTime` field per step, so the shape of the claim is right. Rerunning `--execute` would settle it, which I did not do because it writes files | |
| 12 | "Both runs recorded in this chapter finished in under five seconds" (line 65) | true | 3.30 s and 4.54 s per the author record, both under five | |
| 13 | "LGE allows a single GATK step 24 hours before it gives up on it." (line 65) | true | `GATKPipelineExecutor.swift:50`, `timeout: TimeInterval = 24 * 60 * 60` | |
| 14 | GATK Core pack is experimental, pins 4.6.2.0, around 600 MB (line 54) | true | `PluginPack.swift:617-642`, `isExperimental: true`, `estimatedSizeMB: 600`, `packages: ["gatk4"]`. Version 4.6.2.0 from `third-party-tools-lock.json:40` | |
| 15 | "Turn on **Show Experimental Features** in **Settings > Advanced** before you look for it." (line 54) | true | The campaign's fixed sentence, verbatim per CONSISTENCY.md "Recurring sentences" | |
| 16 | "**Tools > Plugin Manager...** (Cmd-Shift-B)" (line 54) | true | Matches CONSISTENCY.md "Menu paths and surfaces" exactly | |
| 17 | "Running `lungfish-cli conda install --pack gatk-core` answers `Unknown tool pack: gatk-core` and lists eight packs that do not include it" (line 56) | true | Reran it. Output is `✗ Unknown tool pack: gatk-core` then `Available packs: lungfish-tools, read-mapping, full-length-mhc-genotyping, variant-calling, assembly, multiple-sequence-alignment, phylogenetics, metagenomics`. Eight, and `gatk-core` is absent | |
| 18 | "because the installer only resolves the packs it considers non-experimental" (line 56) | true | `PluginPack.swift:970-972`, `visibleForCLI` is `[requiredSetupPack] + activeOptionalPacks`, with no experimental branch, against `:974-976` where the app form takes `includeExperimental` | |
| 19 | "The pack installs GATK at `~/.lungfish/conda/envs/gatk-core/bin/gatk`" (line 58) | true | `third-party-tools-lock.json:40` names environment `gatk-core`, and the conda root is `~/.lungfish/conda` per project convention | |
| 20 | GATK needs a `.fai` and a `.dict`, and LGE makes neither (line 58) | true | Neither is produced by any LGE code path for this subcommand. The author built the `.dict` with GATK's own `CreateSequenceDictionary`, and the file is present in scratch at 252 bytes | |
| 21 | **Reference.** required, no default, both steps run against it (line 120) | true | `cli-help/gatk.txt:67`, `GATKCommandBuilder.swift:585` and `:652` both pass `-R config.referenceFASTAURL.path` | |
| 22 | **GVCF.** "repeated once per sample rather than given a list" (line 122) | true | `cli-help/gatk.txt:71` "Repeat for each sample.", `GATKCommandBuilder.swift:588-590` loops one `--variant` per URL | |
| 23 | **GVCF.** "at least one is required" (line 122) | **false** | Same defect as claim 5. Zero GVCFs is accepted and previews cleanly at exit 0 | "There is no default and none is enforced, though a run without at least one is meaningless, because the GVCFs are the whole of the evidence the step works from." |
| 24 | **Output.** required, tabix `.tbi` appears beside it (line 124) | true | `cli-help/gatk.txt:72`. `cohort.vcf.gz.tbi` (399 B) sits beside `cohort.vcf.gz` in scratch | |
| 25 | **Intermediate.** required either way, a file under combine and a directory under GenomicsDB (line 126) | true | Omitting it gives `Error: Missing expected argument '--intermediate <intermediate>'`, reproduced. `GATKCommandBuilder.swift:586` uses `-O <intermediate>`, `:616` uses `--genomicsdb-workspace-path`, `:627` prefixes `gendb://`. Matches drift row 53's correction including the "Either way" clause | |
| 26 | **Combine strategy.** default `auto`, CombineGVCFs at 50 or fewer, GenomicsDB above, "50 itself falling on the CombineGVCFs side" (line 128) | true | `GATKCommandBuilder.swift:380` `jointGenotypingCombineGVCFsThreshold = 50`, `:411-413` `sampleCount <= jointGenotypingCombineGVCFsThreshold ? .combineGVCFs : .genomicsDB`. The `<=` puts 50 on the CombineGVCFs side. Values `combine-gvcfs` and `genomicsdb` from `:76-79` | |
| 27 | **Intervals.** "Restricts both GATK steps", default empty (line 130) | true | `GATKCommandBuilder.swift:592-594` and `:603-605` for the combine path, `:621-623` and `:632-634` for GenomicsDB. Confirmed empirically by the author's command 16, and I reconfirmed the outputs, 258 rows ending at position 99,174 against a 100 kb interval | |
| 28 | **Extra args.** lands only on the genotyping step, "a real difference from `lungfish-cli gatk bqsr` where the same flag reaches both commands" (line 132) | true | Reran the preview with `--extra-args "--max-alternate-alleles 3"`. It appears only at the end of the `GenotypeGVCFs` line. `GATKCommandBuilder.swift:605` and `:634` append to `genotypeArguments` alone. The bqsr contrast holds, `:488` and `:500` append `config.extraArguments` to both BaseRecalibrator and ApplyBQSR | |
| 29 | **Execute.** default false, without it nothing runs and no file is written (line 134) | true | `GATKCommand.swift:41-44`. My preview runs wrote no files, checked by `ls` afterwards | |
| 30 | **Dry run.** "overrides `--execute` when both are given" (line 136) | true | `GATKCommand.swift:270`, `execute: execute && !dryRun`. Also `:82-84` defines `isDryRun` as `!execute \|\| dryRun`, consistent | |
| 31 | Genotyping step always gets `--standard-min-confidence-threshold-for-calling 30.0`, no flag exposed (line 138) | true | `GATKCommandBuilder.swift:98` default `30.0`, `:654` always appended. `cli-help/gatk.txt:67-82` lists no `--stand-call-conf` | |
| 32 | Genotyping step always gets `-G AS_StandardAnnotation`, no flag exposed (line 138) | true | `GATKCommandBuilder.swift:99` `alleleSpecificAnnotations: Bool = true`, `:656-658` appends when true, and the CLI never sets it false. No flag in the help | |
| 33 | "each step runs with its working directory set to the folder holding that step's own output" (line 138) | true | `GATKCommandBuilder.swift:608` uses `config.intermediateURL.deletingLastPathComponent()` for the combine step, whose output is the intermediate, and `:609` uses `config.outputVCFURL.deletingLastPathComponent()` for genotyping. Same shape at `:637-638` | |
| 34 | "the only way to change the confidence threshold is to pass a second copy of it through `--extra-args`" (line 138) | true | Follows from claims 28 and 31. The extra arg lands after LGE's own copy on the same GenotypeGVCFs line, and GATK takes the last value | |
| 35 | Unrecognised strategy silently falls back to `auto`, `--combine-strategy genomics-db` "printed `CombineGVCFs` with no warning" (line 140) | true | `GATKCommand.swift:282`, `GATKJointGenotypingStrategy(rawValue: combineStrategy) ?? .auto`. Reran the exact typo. The first line is `gatk CombineGVCFs ...` with no warning on stdout or stderr | |
| 36 | Four files plus provenance, and the file table's contents (lines 144-151) | true | Scratch holds `cohort.vcf.gz` (61,798 B), `cohort.vcf.gz.tbi`, `cohort.combined.g.vcf.gz` (809,306 B), `cohort.combined.g.vcf.gz.tbi`, and `.lungfish-provenance.json` | |
| 37 | "The provenance file's name begins with a dot, which macOS treats as hidden" (line 153) | true | The file is `.lungfish-provenance.json` | |
| 38 | "The recorded run's input GVCF held 48,057 rows" (line 155) | true | Recounted, `bcftools view -H HG002.g.vcf.gz \| wc -l` gives **48057** | |
| 39 | "The cohort VCF that came out held 1,026 rows" (line 155) | true | Recounted, **1026** | |
| 40 | "843 of them substitutions of one base for another and 184 of them indels" (line 155) | **false** | These come from raw `bcftools view -v snps` and `-v indels`, which classify a row once per ALT allele and so double-count. Their sum is 1,027 against 1,026 rows. The overlap is exactly one row, position 29224, `A > G,AGG`, counted as both. Under the manual's own convention, stated at `05-variants/02-reading-the-variant-browser.md:98` and used at `05-variants/01-calling-variants-from-amplicons.md:140`, a row is classified by its **first ALT allele only** and gets one type. By that rule the file is **844 substitutions and 182 indels**, which sums to 1,026 exactly. The 19 multiallelic rows are otherwise internally consistent | "844 of them substitutions of one base for another and 182 of them [indels](../../GLOSSARY.md#indel)" |
| 41 | Quoted first row of the cohort VCF (lines 160-161) | true | `bcftools view -H cohort.vcf.gz \| head -1` matches, including `2078 . G A 2175.06 .`, `AC=2;AF=1;AN=2;AS_QD=25.36;DP=62`, `QD=28.73;SOR=0.76`, `GT:AD:DP:GQ:PL`, `1/1:0,60:60:99:2189,180,0`. The chapter elides the middle INFO keys with `...`, which is disclosed in the lead-in | |
| 42 | FORMAT field glosses, `GT` `1/1`, `AD` `0,60`, `DP` 60, `GQ` 99 max (line 164) | true | All four read directly off the quoted row. GQ 99 as GATK's ceiling matches `GLOSSARY.md` genotype-quality | |
| 43 | "The recorded cohort VCF declared eight `AS_` keys in its header." (line 166) | true | `bcftools view -h cohort.vcf.gz \| grep -c "ID=AS_"` gives **8** | |
| 44 | "The lowest quality score in the recorded cohort VCF was 31.6" (lines 168, 188) | true | `bcftools query -f '%QUAL\n' \| sort -g \| head -1` gives **31.6** | |
| 45 | "Mean depth across the 1,026 rows was 39.4 reads." (line 168) | true | Mean of `INFO/DP` over 1,026 rows is **39.39**, which rounds to 39.4 | |
| 46 | "Every row in the recorded cohort VCF carried a bare `.` in that column" (lines 170, 190) | true | `bcftools query -f '%FILTER\n' \| sort \| uniq -c` gives a single group, `1026 .` | |
| 47 | "Joint genotyping applies no quality filters at all" (line 170) | true | Neither command sequence emits a `VariantFiltration` step. `GATKCommandBuilder.swift:582-640` | |
| 48 | Provenance holds one entry per step with command, exit code, wall time, pinned version 4.6.2.0 (line 172) | true | The surviving record's step keys are `command`, `dependsOn`, `endTime`, `exitCode`, `id`, `inputs`, `outputs`, `startTime`, `stderr`, `toolName`, `toolVersion`, `wallTime`, with `toolVersion` `4.6.2.0`. `GATKPipelineExecutor.swift:830-875` writes one `StepExecution` per command | |
| 49 | Provenance records the conda environment path, every resolved option, a SHA-256 checksum and byte size per file (line 172) | true | The record carries `runtime` and `parameters` at top level, and the serialised JSON contains `sha256` and `sizeBytes` keys. The chapter says "byte size", which is what `sizeBytes` holds | |
| 50 | Failure prints `Error: GATK command failed with exit code 2.` then the provenance path, leaves no partial output, records status `failed` (line 174) | true | The surviving `.lungfish-provenance.json` has top-level `status` `failed`, one step, `exitCode` 2. `GATKPipelineExecutor.swift:764-785` removes new outputs and writes a `.failed` record before throwing | |
| 51 | GenomicsDB run wrote a workspace holding `callset.json`, `vidmap.json`, `vcfheader.vcf`, and one subdirectory per interval (line 176) | true | `ls gdb-workspace` gives `__tiledb_workspace.tdb`, `callset.json`, `chr20_10.0-10.5Mb$1$100000`, `vcfheader.vcf`, `vidmap.json`. The interval subdirectory is named for the 1-100000 range | |
| 52 | GenomicsDB cohort VCF "held 258 rows ending at position 99,174" (line 176) | true | Recounted, **258** rows, last POS **99174** | |
| 53 | "Both numbers confirm that `--intervals` restricted both steps rather than only the second one" (line 176) | true | Sound inference, and independently confirmed by the source at claim 27. The workspace directory name itself encodes the 100 kb bound | |
| 54 | "The recorded single-sample run listed exactly one, `HG002`." (line 182) | true | `bcftools query -l cohort.vcf.gz` gives one line, `HG002` | |
| 55 | "A cohort VCF nearly as long as its input GVCF suggests reference confidence was carried through" (line 184) | true | Sound reading of the 48,057 to 1,026 collapse | |
| 56 | "A row below 30 in a cohort VCF from this command would mean the threshold was overridden through `--extra-args`" (line 188) | true | Follows from claims 31 and 34, the only route to a different threshold | |
| 57 | Command block `CreateSequenceDictionary -R GRCh38...fasta` (lines 61-62, 197-199) | true | The author ran it and `GRCh38.chr20.10.0-10.5Mb.dict` (252 B) is in scratch | |
| 58 | The three On the command line blocks (lines 196-241) | true | Flags, order, and spellings match `cli-help/gatk.txt:62-82`. I reran the first two shapes as previews and both parse and compose correctly | |
| 59 | "Repeat the `--gvcf` option once per sample and nothing else changes." (lines 38, 217) | true | `GATKCommandBuilder.swift:588-590` emits one `--variant` per URL and no other argument depends on the count, except the `auto` strategy resolution above 50, which the chapter documents separately | |
| 60 | Next-chapter pointer, cohort VCF is unfiltered until the filtering step (line 245) | true | Follows from claim 47, and chapter 03 does cover `gatk filter` | |

Verdict count: **55 true, 4 false, 1 unverifiable**.

## Front matter

Checked against the sibling chapter 01 and CONSISTENCY.md.

`title`, `chapter_id`, `audience`, `prereqs`, `estimated_reading_min`, and
`task` are all well formed, and `task` names the command-line route, which
matches the chapter. `tools: [gatk]` is right, since WhatsHap never enters
this chapter. `parameters_refs: [variants.gatk-plans]` matches the roster.
`shots: []` and `illustrations: []` match the drift report's screenshot
ruling, and the body carries no `<!-- SHOT: -->` marker, which I confirmed by
grep. `features_refs: [variants.gatk-germline]` applies drift row 62.
`entry_points` gives the CLI form with `lungfish-cli`, which is the name
CONSISTENCY.md fixes, and the June-era `lungfish` spelling is gone.

One problem. `glossary_refs` lists 17 terms and all 17 anchors resolve in
`GLOSSARY.md`, but three of them are never linked from the body, **`bam`**,
**`variant-caller`**, and **`genotypegvcfs`**. The third is the notable one,
because `genotypegvcfs` is one of the four entries the author added for this
chapter, and the body writes GenotypeGVCFs only in code font, never as a
link. Either link them on first use or drop them from the list.

## Settings coverage against parameters.yaml

The registry entry `variants.gatk-plans` (`parameters.yaml:4008-4017`) has
`settings: []`, because this operation has no dialog. Its `cli_only` list is
built subcommand by subcommand rather than flag by flag. Three shared flags
are listed as flags (`--execute`, `--dry-run`, `--extra-args`), then one
entry per subcommand, and the `joint-genotype` entry at `:4031-4033` names
`--gvcf`, `--intermediate`, and `--combine-strategy` inside its prose.

Measured against the CLI help, which lists exactly nine options for this
subcommand besides `--version` and `--help`, the chapter covers all nine.

| Flag | `cli-help/gatk.txt` | Registry | Chapter paragraph |
|---|---|---|---|
| `--reference` | :67 | not named | **Reference.** line 120 |
| `--gvcf` | :71 | named at :4033 | **GVCF.** line 122 |
| `--output` | :72 | not named | **Output.** line 124 |
| `--intermediate` | :73-74 | named at :4033 | **Intermediate.** line 126 |
| `--combine-strategy` | :75-76 | named at :4033 | **Combine strategy.** line 128 |
| `--intervals` | :77 | not named | **Intervals.** line 130 |
| `--extra-args` | :78-80 | :4025-4027 | **Extra args.** line 132 |
| `--execute` | :65 | :4019-4021 | **Execute.** line 134 |
| `--dry-run` | :66 | :4022-4024 | **Dry run.** line 136 |

Nine flags, nine paragraphs, no flag undocumented and no paragraph
inventing a flag that does not exist. Each paragraph follows the fixed
three-sentence shape from CONSISTENCY.md and closes with "On the command
line this is `--flag`." The two closing paragraphs cover the three
unchangeable GATK options and the lenient strategy parse, which are
behaviours rather than settings, so they correctly sit outside the labelled
set. All four "Missing from this chapter" rows in the drift report are now
covered, and I verified each against source.

The registry itself is thinner than the chapter. It never names
`--reference`, `--output`, or `--intervals` for this subcommand. That is a
registry gap rather than a chapter defect, and the chapter is the more
complete document of the two. Worth a registry ticket so a later reviewer
does not read the chapter as over-documenting.

## Consistency

Against CONSISTENCY.md the chapter is clean. "Lungfish Genome Explorer (LGE)"
appears once at line 24 and every later mention is "LGE". The tool is
`lungfish-cli` throughout, never bare `lungfish`. The experimental sentence
at line 54 is the fixed wording verbatim. **Tools > Plugin Manager...**
carries its Cmd-Shift-B and its ellipsis. **File > New Project** carries
Cmd-N. The fixture is called "the HG002 chromosome 20 slice", the fixed
name. Settings paragraphs use the bold label with the period inside the
bold, then three sentences, then the flag sentence.

Against the Freyja chapter, which is the manual's other command-line-only
operation, the pattern matches closely and deliberately. Both open with the
same "has no dialog and no menu item in Lungfish Genome Explorer (LGE), so
everything in this chapter runs from the command line in a terminal"
sentence, both repeat it in Before you start with the CLI Reference pointer,
both restate it at the head of the Procedure, and both open Settings with
"has no dialog, so it has no dialog settings. Every setting is a
command-line flag". One divergence is substantive rather than stylistic.
Freyja tells the reader the app carries a leftover menu action that opens
the Plugin Manager, whereas joint genotyping has no such action, and the
grep at claim 1 confirms that. The chapter is right not to claim one.

Against the committed Part V variants chapters, the divergence is the
counting rule at claim 40. `05-variants/02-reading-the-variant-browser.md:98`
states the convention once for the manual and says "Every substitution and
indel count in this chapter follows that rule", and
`05-variants/01-calling-variants-from-amplicons.md:140` applies it. This
chapter's 843 and 184 do not. Fixing it to 844 and 182 also removes the
arithmetic oddity a careful reader would catch, that 843 plus 184 exceeds
the 1,026 rows the same sentence gives.

One cross-chapter contradiction, at claim 4. This chapter says the Call
Variants dialog reaches exactly one GATK tool. Chapter 01 line 98 documents
a second, GATK + WhatsHap Phased, and devotes settings paragraphs to it.

## App defects

The author's three defects all reproduce.

1. **`lungfish-cli conda install --pack gatk-core` fails.** Confirmed. The
   output is `✗ Unknown tool pack: gatk-core` followed by eight packs that
   exclude it. The cause is `PluginPack.swift:970-972`, where `visibleForCLI`
   omits the experimental branch that `visibleForApp` takes at `:974-976`.
   The chapter states the defect plainly at line 56 and routes the reader to
   the Plugin Manager. Chapter 04 documents the same failing command and
   needs the same treatment, as the reality map's campaign note 2 says.
2. **An unrecognised `--combine-strategy` value falls back to `auto`
   silently.** Confirmed. `--combine-strategy genomics-db` printed a
   `CombineGVCFs` first line with no warning on stdout or stderr and exit 0.
   Cause is `GATKCommand.swift:282`, `GATKJointGenotypingStrategy(rawValue:)
   ?? .auto`. Worth an upstream fix so an unrecognised value is rejected the
   way `ArgumentParser` rejects a missing `--intermediate`.
3. **The lock's pinned conda build string no longer resolves.** Accepted on
   the author's evidence, not independently retested, because retesting means
   a network install. The lock names
   `bioconda::gatk4=4.6.2.0=py310hdfd78af_1` at
   `third-party-tools-lock.json:40` and the author could resolve only `_0`.
   The upstream version is the same, so this is packaging drift. The chapter
   does not mention the build string, which is right for a reader, so this
   one needs a repository ticket rather than a chapter change.

**New defect, found in this review. `--gvcf` is not required.** The parser
declares it optional, so
`lungfish-cli gatk joint-genotype --reference <fasta> --intermediate <path>
--output <vcf>` with no `--gvcf` at all exits 0 and composes
`gatk CombineGVCFs -R <fasta> -O <path>` carrying no `--variant` argument,
followed by a normal `GenotypeGVCFs` line. Under `--execute` this would hand
GATK a `CombineGVCFs` invocation with no inputs. Every other required
argument on this subcommand is enforced, `--intermediate` included, so the
omission looks like an oversight rather than a decision. The chapter
currently claims four flags are required, which is what led me to test it.

## Notes for the editor

Four sentences need changing and one needs a decision.

Line 69, the GATK tool count. Change "reaches exactly one GATK tool,
HaplotypeCaller" to name both entries. The correction is in the claim table
at row 4. Keep the second half of the sentence, which is true and is the
point of the paragraph.

Line 118, the two counts in one sentence. "Four of them are required"
becomes three, and "the other seven subcommands" becomes six of the other
nine. Rows 5 and 7 carry the wording. While you are in that sentence, note
that `markdup` and `validate-sam` are documented nowhere in the manual, so
do not promise the reader they are covered elsewhere.

Line 122, the GVCF paragraph's "at least one is required". Row 23 has the
replacement. This is the chapter's only claim that a reader could act on and
be misled by, since a pipeline author might rely on the CLI to catch an empty
input list.

Line 155, the substitution and indel counts. Row 40 has the numbers, 844 and
182. This is a convention alignment, not a recount dispute. Both readings are
defensible in isolation, but Part V fixed the rule and said so, and 844 plus
182 lands exactly on the 1,026 the same sentence quotes.

The decision. Three `glossary_refs` entries are unlinked in the body,
`bam`, `variant-caller`, and `genotypegvcfs`. `genotypegvcfs` is a new
entry written for this chapter, so linking it on its first appearance at line
87 or line 110 is probably what the author intended. `bam` and
`variant-caller` may simply be inherited from chapter 01's list and can be
dropped.

Everything else stands. The chapter is unusually well evidenced, the nine
Settings paragraphs match the CLI help exactly, the four drift Missing rows
are all covered against source, and the lint passes strict.

## Counts

- Claims checked: 60. **True 55, false 4, unverifiable 1.**
- Settings paragraphs: 9, against 9 flags in `cli-help/gatk.txt:62-82`. Full coverage, no invented flag.
- Registry flags named for this subcommand: 6 of 9. The registry is the thinner document.
- Numbers recounted from the scratch outputs: 12. Ten reproduced exactly (48,057 GVCF rows, 1,026 cohort rows, 8 `AS_` keys, min QUAL 31.6, mean DP 39.39, 1,026 bare `.` FILTER values, one sample `HG002`, 258 GenomicsDB rows, last POS 99,174, the quoted first row). One pair, the 843 and 184, is wrong by convention and should be 844 and 182. One, the 1.61 and 1.62 second split, is unverifiable from surviving artefacts.
- CLI commands rerun read-only: 6. All previews, no `--execute`, no files written.
- Defects: 3 reproduced from the author record, **1 new** (`--gvcf` not required).
- Glossary: 17 refs, 17 anchors resolve, 3 unlinked in the body.
- Lint: `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports no issues found.
