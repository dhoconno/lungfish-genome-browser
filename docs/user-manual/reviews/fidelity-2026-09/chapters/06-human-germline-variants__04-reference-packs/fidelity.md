# Fidelity review, 06-human-germline-variants/04-reference-packs

Chapter: `docs/user-manual/chapters/06-human-germline-variants/04-reference-packs.md`
Title "Reference Files for GATK". Roster row 45. `parameters_refs: []`.
Reviewed against Preview 2026.9.13, `Sources/`, the CLI help tree, the tool
lock manifest, the author's scratch outputs, and re-runs of the cheap
read-only GATK and bcftools commands.

Reviewer note on method. Where the author's provenance sidecar had been
overwritten by a later run in the same directory, I reproduced the failing
GATK command directly rather than trusting the report. The contig-mismatch
error, the missing-index error, the record counts, the SNV and indel split,
and the metrics figures were all regenerated from scratch in this review.
The two BQSR step timings could not be regenerated that way and are marked
unverifiable below.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "'Reference pack' is a convenience name this manual uses ... It is not an LGE object." | true | No `ReferencePack` or `referencePack` symbol anywhere in `Sources/`. `cli-help/_root.txt` lists no such command. Matches reality-map rows 87 and 88. | |
| "No `lungfish-cli` command installs, downloads, validates, or enforces a reference pack" | true | Same evidence. Reality-map row 88. | |
| "GATK will not read a bare FASTA. It wants two small companion files beside it" | true | Reproduced both failures. GATK stops on the missing `.fai` and on the missing `.dict` before reading any read. | |
| "Neither companion is produced by LGE, and a first GATK run against a bare FASTA fails on the missing file rather than building it." | **false** (first half overstated) | The `.dict` half is right, `CreateSequenceDictionary` returns zero hits across `Sources/`. The `.fai` half is not. LGE runs `samtools faidx` on several paths, `GenomeDownloadViewModel.swift:249-254`, `SequenceExtractionPipeline.swift:177`, `GenBankBundleDownloadViewModel.swift:91`, `:338`, `AssemblyBundleBuilder.swift:497-502`, `NativeToolRunner.swift:1794-1805`, `MetagenomicsImportService.swift:1045`. What is true is narrower. Those paths index `sequence.fa.gz` *inside* a `.lungfishref` bundle (`BundleManifest.swift:83`, `:106`), never a loose FASTA the reader hands to a `gatk` command. | "LGE never builds either companion for a loose FASTA like this one. It does index the FASTA inside a reference bundle when it builds one, but that index lives inside the bundle under a different name and is no use to a `gatk` command pointed at your own file. A first GATK run against a bare FASTA fails on the missing file rather than building it." |
| "LGE never creates this file for you, on either route." (the `.dict`) | true | `grep -rn "CreateSequenceDictionary" Sources/` returns nothing. `sequenceDictionaryURL` is only ever read from configuration and passed through (`GATKCommandBuilder.swift:358`, `:573-574`), never written. | |
| Quoted error, "Fasta index file ... does not exist." | true | Reproduced. `nofai/.lungfish-provenance.json` step stderr, exit 2, run status `failed`. Verbatim match. | |
| "The error names the file it wanted and links to the Broad Institute's page about reference inputs" | true | Full stderr continues "Please see https://gatk.broadinstitute.org/hc/articles/360035531652-FASTA-Reference-genome-format for help creating it." Note the quoted code block stops at "does not exist." and omits that sentence, so the prose describes a link the reader cannot see in the block. Cosmetic, not false. | Optional. Extend the quoted block by one line so the link the prose promises is visible. |
| Quoted error, "Fasta dict file ... does not exist." | true | Reproduced. `nodict/.lungfish-provenance.json`, exit 2, status `failed`. Verbatim. | |
| Quoted error, "Input files reference and features have incompatible contigs ... 500001 / 64444167" | true | Re-run live this review against the shipped benchmark VCF. Verbatim, including both contig lines. | |
| Quoted error, "An index is required but was not found ... Try running IndexFeatureFile on the input." | true | Re-run live this review on an unindexed copy. Verbatim. | |
| `.fai` is "34 bytes holding one line, `chr20_10.0-10.5Mb 500001 19 50 51`" | true | `wc -c` = 34. `cat -A` confirms the five tab-separated fields exactly as quoted. | |
| The five `.fai` fields, name / length / byte offset / bases per line / bytes per line including newline | true | Standard faidx layout, and the values match the file. | |
| "The slice is 500,001 bases long" | true | `.fai` field 2 and the `.dict` `LN:500001`. | |
| `.dict` is "a 251 byte file", `@HD` plus one `@SQ`, `SN:chr20_10.0-10.5Mb`, `LN:500001`, `M5:0bffe5f36c15cdb7069b96a1d4e4a0ef`, `UR` absolute path | true | Read the file. Every field matches character for character. | |
| "That last field is why the file size varies slightly between machines ... 249 or 252 bytes" | true | The `UR` holds the absolute FASTA path, so path length drives file length. The sibling authors' 249 and 252 are consistent with this. | |
| Name pattern, index appends to the whole file name, dictionary replaces the extension | true | Observed on disk. `GRCh38.chr20.10.0-10.5Mb.fasta.fai` beside `GRCh38.chr20.10.0-10.5Mb.dict`. | |
| "`CreateSequenceDictionary`, which ships inside GATK itself" | true | Ran through the `gatk` binary, no separate Picard install. Glossary `picard` entry agrees. | |
| Benchmark VCF "holding 961 records on the sliced contig" | true | `bcftools view -H` = 961. | |
| The benchmark header "still declares that chromosome's full length of 64,444,167 bases" | true | `##contig=<ID=chr20_10.0-10.5Mb,length=64444167,...>`. 195 contig lines in that header, and the reproduced GATK error lists all of them. | |
| Reheadered file "38,323 bytes with a single contig line of the right length, all 961 records intact, and a 392 byte `.tbi`" | true | 38,323 bytes and 392 bytes on disk. One `##contig` line at `length=500001`. 961 records. All four confirmed. | |
| "Of those records 809 are SNVs ... and 152 are indels" | true | Re-counted this review. `-v snps` = 809, `-v indels` = 152, sum 961. Note this is a different file from the cohort VCF the sibling chapters count, so the siblings' first-ALT ruling (844 and 182 of 1,026) does not bear on these numbers and the chapter does not quote the cohort counts anywhere. | |
| "`bcftools reheader --fai` ... and then rebuilds the index because the header changed" | true | The staged commands produced exactly the described outputs. | |
| "both go to GATK as separate `--known-sites` flags, since the option repeats" | true | `GATKCommandBuilder.swift:482-484` loops over `knownSitesVCFURLs`. `cli-help/gatk.txt:153-155` "Repeat for dbSNP, Mills, or cohort resources." | |
| "Running `gatk IndexFeatureFile -I known-sites.vcf.gz` writes the `.tbi`" | true | GATK's own error text names that remedy, and a 430 byte `.tbi` exists in `noidx/`. | |
| Interval BED, one line, "the file is 27 bytes" | true | `wc -c` = 27, content `chr20_10.0-10.5Mb\t0\t100000`. | |
| "the start counts from zero and the end is not included" | true | Standard BED half-open convention, consistent with the file. | |
| "LGE applies `--intervals` to both commands in a BQSR run, not just the first" | true | `GATKCommandBuilder.swift:485-487` appends `-L` to `recalibratorArguments` and `:498-500` to `applyArguments`. Reality-map row 94 corrected wording applied. | |
| "A successful BQSR run prints two lines and nothing else, an exit code line and a path to the provenance sidecar" | true | `GATKCommand.swift:50-51` emits exactly those two strings in that order. | |
| "a 1,191,386 byte recalibration table, a 16,929,652 byte recalibrated BAM, and its index" | true | Both byte counts match the files on disk exactly. `HG002.bqsr.bai` present at 1,576 bytes. | |
| "the provenance recording two steps of 3.78 and 2.58 seconds" | **unverifiable** | The BQSR provenance sidecar in the scratch directory was overwritten by the later `collect-metrics` run, which left a single-step file for `gatk-collect-metrics`. The two-step structure is right by construction (`GATKCommandBuilder.swift:503-506` returns two commands, `GATKPipelineExecutor.swift:833-855` writes one `StepExecution` each), but the two durations cannot now be checked. Rerunning `bqsr --execute` in a clean directory would settle it. | Either rerun to re-confirm, or soften to "two steps, each a few seconds on this fixture". |
| "its first block lists every argument the run used" | true | `head` of the table shows `#:GATKReport.v1.1:5` then an Arguments table headed "Recalibration argument collection values used in this run". | |
| "LGE still writes provenance with a failed status, the nonzero exit code, and the whole of GATK's error output in the step's `stderr` field" | true | `nofai` and `nodict` sidecars both carry `status: failed`, step `exitCode: 2`, and full GATK stderr. `GATKPipelineExecutor.swift:852` writes the step stderr. | |
| collect-metrics figures, "873 SNVs of which 805 were already catalogued, a 92.2 percent overlap ... 2.25 among the known ones and 1.34 among the 68 novel ones" | true | Read the summary metrics file this review. TOTAL_SNPS 873, NUM_IN_DB_SNP 805, NOVEL_SNPS 68, PCT_DBSNP 0.922108, DBSNP_TITV 2.245968, NOVEL_TITV 1.344828. Every rounding is right. | |
| "`collect-metrics` takes a called VCF, a dbSNP file, and the sequence dictionary" | true | `cli-help/gatk.txt:244-263`. `--sequence-dictionary` is optional there and `GATKCommandBuilder.swift:573-574` emits `--SEQUENCE_DICTIONARY` only when present, which the chapter does not claim otherwise. | |
| "Real human SNVs run near 2.0 to 2.1 genome-wide, and sequencing errors ... sit near 0.5" | true | Standard population-genetics figures, consistent with the observed 2.25 known versus 1.34 novel. Domain knowledge rather than app behaviour. | |
| Step 4 "prints two command lines rather than one, because `bqsr` is two GATK tools run in order" | true | `GATKCommandBuilder.swift:503-506` returns a two-element array, BaseRecalibrator then ApplyBQSR. | |
| "Both carry `-R` pointing at the reference" | true | `:478` and `:491`. | |
| "`--create-output-bam-index true` on the second is the default" | true | `cli-help/gatk.txt:160-162` "(default: true)". `:496` stringifies it onto `applyArguments` only. | |
| "`--extra-args` appends whatever you quote to the end of both" | true | `:489` and `:502` both append `config.extraArguments`. `cli-help/gatk.txt:163-165` "appended to both BQSR commands". | |
| "That differs from `gatk joint-genotype`, where `--extra-args` lands only on the final step" | true | Reality-map missing-row evidence, and the joint-genotype builder appends only to the last command array. | |
| "The GATK Core pack ... Its description reads 'GATK4 command construction and dry-run support for human germline workflows'" | true | `PluginPack.swift:620` verbatim. | |
| "which understates what the pack now does, since these commands execute rather than only print" | true | The description is stale. `--execute` runs GATK (`GATKCommand.swift:42-51`). Reality map flags the same staleness. | |
| "The card shows an estimate of about 600 MB" | true | `PluginPack.swift:641` `estimatedSizeMB: 600`, rendered by `formatPackSize` as "~600 MB" (`PluginManagerView.swift:719-721`, `:1256-1263`). | |
| "measured 887.6 MB once installed" | true | `lungfish-cli conda envs` this review reports `gatk-core 21 pkgs 887.6 MB`. | |
| "Variant Phasing, which provides WhatsHap for the `lungfish-cli variants phase` route, estimated at 180 MB and measured at 369.9 MB" | true | `PluginPack.swift:645-646`, `:666`. `conda envs` reports `phasing 67 pkgs 369.9 MB`. `variants phase --help` confirms the route exists. Correctly avoids reality-map row 100's trap of calling the GUI entry usable. | |
| "find the GATK Core card under the Variant Calling category" | true | `PluginPack.swift:623` and `:649` both `category: "Variant Calling"`. | |
| "Turn on **Show Experimental Features** in **Settings > Advanced**" | true | `AdvancedSettingsTab.swift:16` toggle label verbatim. `PluginManagerViewModel.swift:490-492` gates `visibleStatuses(includeExperimental:)` on it. Matches the CONSISTENCY fixed sentence word for word. | |
| The warning text, "experimental features may be incomplete, change without compatibility guarantees, and are not intended for production scientific work" | true | `AdvancedSettingsTab.swift:19` verbatim, lowercased into the sentence. | |
| "`lungfish-cli conda install --pack gatk-core` answers with an unknown-pack error and lists eight packs that exclude it" | true | Ran it. `✗ Unknown tool pack: gatk-core` then eight ids, gatk-core absent. | |
| "`--pack phasing` fails the same way. Both exit with status 3 and install nothing." | true | Ran both. Exit 3 each. | |
| "because the command line installer resolves ids only against the packs it treats as non-experimental" | true | `CondaCommand.swift:159-166` against `PluginPack.visibleForCLI`, which is `[requiredSetupPack] + activeOptionalPacks` (`PluginPack.swift:969-971`) with experimental excluded. | |
| "The Plugin Manager is the only route that works for either pack, which is a defect rather than a design choice." | true | Consistent with reality-map rows 96 and 101 and with sibling chapter 03's identical statement. | |
| "The pack installs GATK 4.6.2.0 at `~/.lungfish/conda/envs/gatk-core/bin/gatk`" | true | Version in `third-party-tools-lock.json:40`. Binary present at that path. | |
| "`samtools`, which ships in the Required Setup pack every project already has" | true | The lock's `packID` is `lungfish-tools` with `displayName` "Third-Party Tools" under `category: "Required Setup"`, and `samtools` is among its seventeen tools. "Required Setup pack" is the manual's settled name for it, established with a glossary anchor in the prereq chapter `01-foundations/07-plugin-packs.md:41`. | |
| "one with `samtools`" (of the files the chapter builds) | **false** (undercount) | The chapter builds three kinds of file and uses three binaries. `samtools` makes the `.fai`, `gatk` makes the `.dict`, and `bcftools` makes the known-sites VCF and its index. `bcftools` is used in five code blocks and is never introduced, so a reader is told where `gatk` and `samtools` come from but not `bcftools`. It is in the same Required Setup pack. | "Two of the files this chapter builds are made with that binary, and the rest with `samtools` and `bcftools`, which both ship in the Required Setup pack every project already has." |
| "The whole set of runs below takes under a minute on the fixture." | true | The two BQSR steps ran in a few seconds each and every other command is trivial on a 500 kb slice. Consistent with the artifacts. | |
| "The GRCh38 dbSNP VCF runs to roughly 1.5 GB compressed and the Mills indel file to around 20 MB" | **unverifiable** | Not downloaded, by the brief's own bandwidth cap, and nothing in the repo states either size. The author flags this as the chapter's least grounded pair of numbers. Both are in the right order of magnitude for the Broad resource bundle. | Keep, since the chapter already hedges with "roughly" and "around". A reviewer with bandwidth should confirm, or the sentence could drop the figures and say only that dbSNP is much the larger of the two. |
| "Both are published by the Broad Institute in its public GATK resource bundle on Google Cloud Storage" | true | Accurate as external fact, and the new `dbsnp` glossary entry says the same. | |
| "`--create-output-bam-index false` when you plan to index the result yourself" | true | `cli-help/gatk.txt:160-162` and `GATKCommandBuilder.swift:496`. Not executed by the author, but the flag plainly exists and is stringified from config. | |
| "the BAM you plan to recalibrate carries a read group ... since GATK groups reads by it" | true | BQSR's covariates include `ReadGroupCovariate`, visible in the recalibration table's Arguments block. The fixture BAM ran successfully, so it carries one. | |
| "the recalibration table ... is a report rather than a result" | true | It is a GATKReport consumed by ApplyBQSR, not a deliverable. | |
| Front matter `entry_points`, two GUI Plugin Manager routes plus `gatk bqsr` | true | Applies reality-map row 105 exactly. The `bqsr` invocation shown matches `cli-help/gatk.txt` usage. | |
| Front matter `features_refs: [variants.gatk-germline]` | true | `features.yaml:606-611` lists `lungfish gatk bqsr` as an entry point and `known-sites-vcf` as an input. Applies row 107. | |

## Front matter

Well formed and consistent with the rewrite. `title` "Reference Files for
GATK" matches the H1 intent. `parameters_refs: []` is correct, since the
chapter documents no registry operation and therefore owes no Settings
section. `features_refs` applies drift row 107. `fixtures_refs:
[hg002-chr20]` matches the fixture actually used. `shots` holds two entries
with captions and the body holds exactly two matching `<!-- SHOT: -->`
markers, ids agreeing in both places. `glossary_refs` lists eighteen
anchors and all eighteen resolve against a real `{#anchor}` in
`GLOSSARY.md`, as do all eighteen inline `GLOSSARY.md#` links.
`brand_reviewed: false` and `lead_approved: false` are correct at this
stage. `prereqs` gained `06-human-germline-variants/01-haplotype-caller`,
which is justified, since the chapter's BAM input and its Next section both
assume the caller.

One item outside the chapter's control. Drift row 106 asked for the mkdocs
nav label to change, and `docs/user-manual/build/mkdocs.yml:121` still reads
"Reference Packs" against a chapter titled "Reference Files for GATK". That
file belongs to the documentation lead, not the author. Flagging it so it is
not lost.

## Consistency

Checked against `CONSISTENCY.md` and the three sibling chapters, all of
which are present.

Correct. "Lungfish Genome Explorer (LGE)" at first mention then "LGE"
throughout. `lungfish-cli` spelled that way everywhere, including in the
`entry_points` and in prose, which is an improvement on the reality map's
older `lungfish` spellings. The Plugin Manager path is
**Tools > Plugin Manager...** (Cmd-Shift-B), matching the sheet exactly.
The experimental-features sentence is the fixed one, verbatim, and matches
its use in all three siblings. The Before-you-start project sentence is the
fixed one. The fixture is named "the HG002 chromosome 20 slice" per the
sheet. Bundle extension `.lungfishref` is not used here, so nothing to
check. No em dashes, no semicolons, no in-sentence colons, and the lint
passes clean under `LUNGFISH_MANUAL_STRICT=1`.

Sibling agreement. The chapter does not quote the cohort VCF's SNV and indel
counts at all, so the gates' first-ALT ruling (844 and 182 of 1,026) has
nothing to bind here. Its own 809 and 152 of 961 describe the reheadered
benchmark VCF, a different file, and I verified them directly. Worth
noting that siblings 01 and 02 say 843 and 184 while sibling 03 says 842 and
182, so those two will need reconciling with each other and with the ruling.
This chapter is unaffected.

Two consistency gaps to settle.

First, the shipped `.fai`. The fixture directory ships
`GRCh38.chr20.10.0-10.5Mb.fasta.fai`, byte-identical to the one this
chapter's `samtools faidx` command produces, which I confirmed. Sibling
chapter 03 tells the reader "the `.fai` index the fixture ships". This
chapter's Before-you-start names only two files to download and then walks
the reader through creating the `.fai` without mentioning that one already
exists beside the FASTA on GitHub. Nothing here is false, and running
`faidx` is harmless and pedagogically useful, but a reader who read chapter
03 first will be confused. One clause fixes it, for example "The fixture
ships this index already, and the command below rebuilds an identical one,
which is worth doing once so you have seen where it comes from."

Second, the build-string pin. The author's report says drift row 97's pin,
`bioconda::gatk4=4.6.2.0=py310hdfd78af_1`, was left out because "the pin is
documented next door" in sibling 02. It is not. Grepping all four chapters
for `py310hdfd78af_1` and `bioconda::gatk4` returns nothing, so row 97 is
unaddressed across the whole part. The chapter states the version 4.6.2.0
and the install path, which serves its own reader well, so the cleanest fix
is for the editor to route the pin into whichever chapter owns pack
provenance rather than forcing it in here.

## App defects

Four claimed by the author. All four confirmed, none new beyond them, and
one correction to the framing of the third.

1. `conda install --pack` rejects both experimental packs. Confirmed by
   running both. Exit 3, `✗ Unknown tool pack: gatk-core`, eight packs
   listed with neither experimental id among them. Mechanism at
   `CondaCommand.swift:159-166` against `PluginPack.visibleForCLI`
   (`PluginPack.swift:969-971`). Real defect, correctly described as one,
   and the Plugin Manager route the chapter gives is the only working one.

2. A known-sites VCF whose header contig length disagrees with the
   reference is rejected, and the fixture's own benchmark VCF is such a
   file. Confirmed by re-running BaseRecalibrator against the shipped
   benchmark this review. The header carries 195 contigs with the slice
   declared at 64,444,167. I agree with the author that this is a fixture
   defect rather than an app defect, since GATK is behaving correctly and
   `regenerate.sh` could reheader at build time. Worth the Cartographer's
   attention as a fixture issue. The chapter's decision to teach it as the
   worked failure is the right call, because the fix generalises.

3. Plugin Manager size estimates understate installed environments. Both
   numbers confirmed, 887.6 MB against a declared 600 MB and 369.9 MB
   against a declared 180 MB, from `conda envs` this review. The author's
   own caveat is the important one and the chapter honours it. On-disk
   environment size and download size are different quantities, so this is
   better described as a stale or optimistic estimate than as a measured
   error. The chapter's wording, "budget more disk and more download time
   than the card suggests", stays on the right side of that line.

4. The GATK Core pack description is stale. Confirmed at
   `PluginPack.swift:620`. It still advertises "dry-run support" for a pack
   that executes. Reader-visible on the card, and the chapter quotes it and
   immediately corrects it, which is the honest handling.

No new defect found in this review.

## Notes for the editor

The one substantive rewrite is the `.fai` sentence in What it is. As
written, "Neither companion is produced by LGE" is too absolute, because LGE
does run `samtools faidx` on seven code paths. The claim the chapter needs
is narrower and still supports its whole argument, that no LGE path builds
these files for a loose FASTA you hand to a `gatk` command. Corrected
wording is in the table. The parallel sentence about the `.dict` in The
sequence dictionary section needs no change, since that one is absolutely
true.

Second, introduce `bcftools`. The chapter carefully tells the reader where
`gatk` and `samtools` come from and then uses `bcftools` in five code blocks
without a word. It is in the same Required Setup pack, so this is one clause
in the sentence at line 73.

Third, the two BQSR timings. They are the only figures in the chapter I
could not re-derive, because the sidecar that held them was overwritten. If
a rerun is cheap, rerun. If not, the sentence works just as well without the
two decimals.

Fourth, consider extending the first quoted error block by its final line so
the Broad Institute link the prose promises is actually visible to the
reader.

Everything else in the chapter is unusually well grounded. Every byte count,
every record count, every metrics figure, and all three GATK error messages
reproduced exactly against the artifacts or against fresh runs. The section
order the author chose suits a reference chapter and the omission of a
Settings section is correct for an empty `parameters_refs`.

Two items are for other roles rather than the editor. The mkdocs nav label
(drift row 106) belongs to the documentation lead. The benchmark VCF's
unreheadered header belongs to the Cartographer as a fixture question. The
two shots are unbuilt and belong to the Screenshot Scout at gate 2, and both
captions match the surfaces as read from source, with the small caveat that
the optional-pack button reads "Install All" rather than "Install"
(`PluginManagerView.swift:576`) and the size estimate sits in a status bar
beside the ready count rather than on the button.

## Counts

True 45, false 3, unverifiable 2.

False, in one line each. "Neither companion is produced by LGE" overstates
the `.fai` half, since LGE runs `samtools faidx` on seven paths, though
never for a loose FASTA. "one with `samtools`" undercounts the binaries the
chapter uses, omitting `bcftools`, which appears in five code blocks and is
never introduced. And the author's report claims the GATK build-string pin
is documented in sibling 02, which no chapter carries, leaving drift row 97
unaddressed manual-wide.

Unverifiable, in one line each. The two BQSR step timings of 3.78 and 2.58
seconds, because the provenance sidecar holding them was overwritten by a
later run. The dbSNP and Mills download sizes of roughly 1.5 GB and around
20 MB, because neither file was downloaded and nothing in the repo states
them.
