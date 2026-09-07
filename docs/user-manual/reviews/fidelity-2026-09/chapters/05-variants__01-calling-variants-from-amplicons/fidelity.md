# Fidelity review: 05-variants/01-calling-variants-from-amplicons.md

Chapter: `docs/user-manual/chapters/05-variants/01-calling-variants-from-amplicons.md`
Title: Calling Variants. Roster row 27. Fixture hg002-chr20.
Reviewed 2026-09-07 against the Swift source, `.build/debug/lungfish-cli`,
`docs/user-manual/parameters.yaml`, the committed fixture, and reruns of the
author's own scratch project under the session scratchpad.

## How the numbers were rechecked

I did not take the author's counts on trust. The two VCFs the author produced
are still on disk under
`.../scratchpad/variants/scratch.lungfish/Reference Sequences/chr20_10.0-10.5Mb.lungfishref/variants/`,
and I recounted every figure from them directly with Python's `gzip` and
`sqlite3` modules, then compared each against the committed
`docs/user-manual/fixtures/hg002-chr20/expected/variants/` files and against
`docs/user-manual/fixtures/hg002-chr20/README.md`. Managed
`~/.lungfish/conda/envs/lofreq/bin/lofreq` and `.../ivar/bin/ivar` were queried
for their versions. Nothing was written outside the scratchpad.

Recount, bcftools track `vc-44ffbd29-...`: 1,056 records, FILTER `.` on all
1,056 and `PASS` on none, 873 substitutions and 183 indels, 10 columns per row,
1,053 distinct positions, FORMAT `GT:PL:AD`, sample column `HG002`, genotypes
623 `0/1`, 415 `1/1`, 18 `1/2`.

Recount, LoFreq track `vc-c0a7ae3e-...`: 862 records, all `PASS`, 862
substitutions and 0 indels, 8 columns, 861 distinct positions, no FORMAT and no
sample column.

Benchmark: 961 records, 961 distinct positions. Position-only intersections are
954 of bcftools' 1,053 and 808 of LoFreq's 861. The two callers share 852
positions.

Record bodies of both tracks are identical line for line to the committed
expected VCFs, and the compressed files are the same size (46,134 and 14,112
bytes). The raw gzip bytes are **not** identical, because the BGZF headers
differ, so "byte-identical" in the author's report overstates it. The chapter
itself says only "matches ... row for row", which is exactly right.

## Claims

| # | Claim (quoted) | Verdict | Evidence | Correction if false |
|---|---|---|---|---|
| 1 | "you pick a caller from a list of seven" | true | `BAMVariantCallingCatalog.swift:9-16` defines seven `BAMVariantCallingToolID` cases | |
| 2 | "Medaka and Clair3 are for Oxford Nanopore reads" | true | Subtitles at `BAMVariantCallingCatalog.swift:161-166` both read "ONT-focused" | |
| 3 | "GATK HaplotypeCaller and the GATK plus WhatsHap phased plan are human germline tools that sit behind experimental plugin packs" | true | `BAMVariantCallingCatalog.swift:167-170` subtitles say germline; `PluginPack.swift:625` and `:651` set `isExperimental: true` on `gatk-core` and `phasing` | |
| 4 | "bcftools builds a genotype model ... LoFreq builds an error model from the base qualities ... iVar reports the observed fraction of reads carrying each alternate above a fixed threshold" | true | Tool behaviour consistent with the built commands at `ViralVariantCallingPipeline.swift:1329-1346` (`mpileup`/`call -mv`), `:1217-1225` (`lofreq call`), `:1241-1256` (`-t <af>`) | |
| 5 | "It ships with a benchmark VCF, a set of 961 variant calls" | true | Recount of `HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz` gives 961 records; fixture README line 95 agrees | |
| 6 | "choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window" | true | `MainMenu.swift:170-173` adds "New Project" with `keyEquivalent: "n"`; `WelcomeWindowController.swift:626` defines `case createProject = "Create Project"` | |
| 7 | Fixture filenames `GRCh38.chr20.10.0-10.5Mb.fasta`, `HG002.chr20.10.0-10.5Mb_R1.fastq.gz`, `..._R2.fastq.gz` | true | Fixture README "Committed files" table, lines 70-73 | |
| 8 | "That leaves a reference bundle carrying an alignment track named 'minimap2 Mapping'" | unverifiable | The chapter defers to the committed mapping chapter for the name rather than asserting it from source. Ground-truth row 23 left the naming convention untraced. A GUI mapping run would settle it | |
| 9 | "A loose BAM sitting in a folder cannot be called from. The caller only ever works on a track the bundle owns." | true | `variants call` requires `--bundle` and `--alignment-track` (`cli-help/variants.txt`, confirmed live); `BAMVariantCallingEligibility.eligibleAlignmentTracks(in: bundle)` is the only source of options | |
| 10 | "bcftools needs no extra installation. It arrives in the Required Setup pack" | true (with a naming caveat) | `BAMVariantCallingCatalog.swift:42-45` gates bcftools on pack `lungfish-tools`, whose `category` is "Required Setup" (`PluginPack.swift:431`, `:446`). Its `name` is "Third-Party Tools" (lock manifest `displayName`), so the on-screen disabled badge would read "Requires Third-Party Tools Pack", not "Required Setup". parameters.yaml uses the chapter's phrasing, and the GLOSSARY bcftools entry does too, so the manual is self-consistent | Optional tightening. "It arrives in the Required Setup pack, named Third-Party Tools in the Plugin Manager" |
| 11 | "Both live in the `variant-calling` pack" (LoFreq and iVar) | true | `BAMVariantCallingCatalog.swift:37-41` gates lofreq, ivar, medaka, clair3 on `variant-calling`; `PluginPack.swift:565-569` packages `lofreq, ivar, medaka, clair3` | |
| 12 | "Open **Tools > Plugin Manager...** (Cmd-Shift-B)" | true (ellipsis differs) | `MainMenu.swift:774-779` titles it `Plugin Manager\u{2026}` with `keyEquivalent: "b"` and `[.command, .shift]`. The app uses a real ellipsis where the chapter writes three periods | Cosmetic only. The campaign has been rendering `...` for `…` elsewhere; flagging for the consistency sheet, not as a chapter error |
| 13 | "A caller whose pack is missing still appears in the dialog's tool list, greyed out and labelled with the pack it wants" | true | `BAMVariantCallingCatalog.swift:94-99` returns "Requires \(pack.name) Pack" as the disabled reason; `DatasetOperationsDialog.swift:91-95` renders it as a badge beside the still-listed title | |
| 14 | "Select the reference bundle in the sidebar, then choose **Tools > Call Variants...**" | true | `MainMenu.swift:719-724` adds the item titled `Call Variants…`, action `showBAMVariantCalling` | |
| 15 | "choosing it with nothing selected raises an alert reading 'No Bundle Loaded'" | true | `InspectorViewController+VariantWorkflow.swift:21-23` presents `title: "No Bundle Loaded"` when the bundle is nil | |
| 16 | "inside its **Variant Calling** tab click **Call Variants...**" | true | `ReadStyleSection.swift:1030`/`:1046` define the `variantCalling` subsection titled "Variant Calling"; `:2592` is the `Button("Call Variants…")` | |
| 17 | "The dialog that opens is identical, except that arriving from a track preselects that track." | **false** | Both Inspector buttons call `runCallVariantsWorkflow()` (`InspectorViewController+MetadataImport.swift:825` and `:901`), which calls `presentVariantCallingDialog()` with no arguments, so `preferredAlignmentTrackID` is nil. The Tools-menu route passes `preferredAlignmentTrackID: nil` explicitly (`AppDelegate+ToolsMenu.swift:159`). No shipping call site supplies a preferred track, so `BAMVariantCallingEligibility.defaultTrackID` always falls through to `eligibleAlignmentTracks.first`. The two routes are identical in every respect | "The dialog that opens is identical either way." (And drop the "rather than the one you clicked" contrast in the Alignment Track setting only if this sentence goes, since that sentence is the one that is right.) |
| 18 | "The dialog is two columns. A tool sidebar runs down the left listing the seven callers, each with a one-line subtitle" | true | `DatasetOperationsDialog.swift:50-62` lays out a 260pt sidebar plus one detail pane; `BAMVariantCallingCatalog.swift:155-171` gives every tool a subtitle | |
| 19 | "**LoFreq** is selected when the dialog opens" | true | `BAMVariantCallingDialogState.swift:73-74` sets `selectedToolID = .lofreq` and `selectedCaller = .lofreq` | |
| 20 | "a footer bar underneath it carries a readiness message, a Cancel button, and a Run button" | true | `DatasetOperationsDialog.swift:123-140` | |
| 21 | "**Overview** holds an Alignment Track menu and an Output Variant Track Name field." | true | `BAMVariantCallingToolPanes.swift:22-42` | |
| 22 | "**Thresholds** holds Minimum Allele Frequency and Minimum Depth." | true | `BAMVariantCallingToolPanes.swift:44-68`, both labels verbatim | |
| 23 | "choosing bcftools titles it 'bcftools Settings'" | true | `BAMVariantCallingToolPanes.swift:72-73` renders `Text("\(state.selectedToolDisplayName) Settings")`; the bcftools display name is "bcftools" | |
| 24 | "**Extra arguments** is a single text field, and **Readiness** repeats the footer's message." | true | `BAMVariantCallingToolPanes.swift:133-147` (one `TextField`), `:186-195` (Readiness renders the same `state.readinessText` the footer shows) | |
| 25 | "Selecting iVar inserts one more section, **iVar Options**, between the caller's own section and Extra arguments. No other caller shows it." | true | Body order at `BAMVariantCallingToolPanes.swift:11-16` is overview, thresholds, callerSpecific, ivarOptions, advancedOptions, readiness; `:149-150` gates the section on `selectedToolID == .ivar` | |
| 26 | "Those two fields reach iVar and no other caller. For bcftools, LoFreq, Medaka, and Clair3 they are recorded in the run's provenance and then ignored." | true | The only reads of `request.minimumAlleleFrequency` and `request.minimumDepth` in the whole pipeline are `ViralVariantCallingPipeline.swift:1248-1249` inside `ivarVariantArguments`, plus `:1353-1354` which writes them into the provenance payload. Confirmed live: with both flags omitted, my bcftools sidecar records `"minimumAlleleFrequency": "caller-default"` and `"minimumDepth": "caller-default"` | |
| 27 | "The section titled 'bcftools Settings' carries no controls, only the line 'bcftools will run mpileup and call as an orthogonal cross-check on the selected BAM.'" | true | `BAMVariantCallingToolPanes.swift:88-90`, string verbatim | |
| 28 | "The Output Variant Track Name field has filled itself in ... giving 'minimap2 Mapping • bcftools'" | true | `BAMVariantCallingDialogState.swift:305-313` builds `"\(alignmentName) • \(toolName)"` with a U+2022 bullet | |
| 29 | Step 3 pipeline narration (stage reference and BAM, `samtools faidx`, `bcftools mpileup` into `bcftools call`, reheader against the reference index, sort, bgzip, tabix, SQLite import) | true | The eleven provenance steps of my own bcftools run are, in order, alignment-staging, reference-staging, `samtools faidx`, `bcftools mpileup -Ou -f`, `bcftools call -mv -Ov -o`, `bcftools reheader -f <ref>.fai`, `bcftools sort -O v`, `bgzip -f -k`, `tabix -f -p vcf`, `lungfish-internal variant-sqlite-import`, `lungfish-cli variants call` | |
| 30 | "The run finishes with the line 'Variant calling complete'." | true | `InspectorViewController+VariantWorkflow.swift:148` and `VariantsCommand.swift:1079` | |
| 31 | "Its section reads 'LoFreq is ready to run directly on the selected bundle alignment track.'" | true | `BAMVariantCallingToolPanes.swift:84-86`, string verbatim | |
| 32 | "The table drawer at the bottom of the viewport opens by itself, because the bundle now carries variant tracks." | true | `ViewerViewController+AnnotationDrawer.swift:92-107` opens the drawer when the manifest carries any annotation or variant track | |
| 33 | "Both tracks load into the one table at once, and the **Source** column names the file each row came from." | true, with a wording nit | `AnnotationTableDrawerView.swift:4798-4810` sets `sourceFile: trackNames[trackId]`, the manifest track display name. So the column names the *track*, which is what the next sentence and the Settings entry both say. "the file" is loose but not wrong, since the track is one file | Optional. "the Source column names the track each row came from" |
| 34 | "There is no separate variant browser window and no per-track node in the sidebar." | true | Ground-truth standing note; `SidebarItem.swift:230` folds variants onto the annotation kind | |
| 35 | "Filtering happens through the **Presets** button above the table" | true | `AnnotationTableDrawerView.swift:849` sets the title `Presets ▸` | |
| 36 | "and through the Search Builder sheet" | true | `AnnotationTableDrawerView.swift:859` sets the title `Search Builder...` | |
| 37 | "Selecting iVar with an untrimmed BAM leaves the readiness line reading 'Confirm the BAM was primer-trimmed before running iVar.' and the Run button disabled" | true | `BAMVariantCallingDialogState.swift:196-198` returns that exact string; `isRunEnabled` at `:203-212` plus the iVar attestation guard blocks Run | |
| 38 | "On a track that LGE primer-trimmed, the checkbox is already ticked and greyed out, with a caption naming the date and the primer scheme used." | true | `BAMVariantCallingToolPanes.swift:96-105` renders `.constant(true)` `.disabled(true)` with the caption "Primer-trimmed by Lungfish on <date> using <scheme>."; `:81-82` and `:105-112` of the state read the sidecar | |
| 39 | "When the bundle carries gene annotations, LGE exports them to a GFF3 file and hands it to iVar" | true | `ViralVariantCallingPipeline.swift:1270-1304` returns nil when `manifest.annotations.first` is absent and otherwise writes `ivar-annotations.gff3`; `:1252-1254` passes it as `-g` | |
| 40 | "Whether they merge depends on their allele frequencies agreeing, by the two rules the Consensus allele frequency and Merge AF distance settings describe below." | **false** | `IVarCodonMerger.swift:105-114` applies **three** rules, not two. Rule 1 merges when every AF exceeds `consensusAF`. Rule 2, which no dialog setting controls and the chapter never mentions, merges when every AF sits within 0.4 to 0.6 inclusive. Rule 3 merges when the maximum pairwise distance is below `mergeAFThreshold` | "Whether they merge depends on their allele frequencies agreeing. Two settings below, Consensus allele frequency and Merge AF distance, set two of the three tests, and a third fixed test merges any pair whose frequencies both sit between 0.40 and 0.60." |
| 41 | Settings **Alignment Track**: default "the first analysis-ready BAM track in the bundle, which is simply the first one in the manifest rather than the one you clicked" | true | `BAMVariantCallingEligibility.swift:22-26` falls through to `eligibleAlignmentTracks.first?.id` because no call site passes a preferred id. This sentence is right and claim 17 is the one that contradicts it | |
| 42 | Settings **Alignment Track**: "selecting a track also re-reads the primer-trim record filed beside that track's BAM" | true | `BAMVariantCallingDialogState.swift:118-126` `updatePrimerTrimAutoConfirm()` | |
| 43 | Settings **Alignment Track**: "On the command line this is `--alignment-track`." | true | Live `lungfish-cli variants call --help` | |
| 44 | Settings **Output Variant Track Name**: "a name already in use gets a number appended rather than overwriting anything" | true | `BAMVariantCallingDialogState.swift:310-319` appends " (2)", " (3)" until unused | |
| 45 | Settings **Output Variant Track Name**: "On the command line this is `--name`." | true | Live help shows `--name, --output-track-name <name>` | |
| 46 | Settings **Minimum Allele Frequency**: default 0.05, becomes iVar's `-t`, recorded as "caller-default" for bcftools, flag `--min-af` | true | `BAMVariantCallingDialogState.swift:75`; `ViralVariantCallingPipeline.swift:1248`; my sidecar records `caller-default`; live help lists `--min-af` | |
| 47 | Settings **Minimum Depth**: default 10, reaches iVar as `-m`, flag `--min-depth` | true | `BAMVariantCallingDialogState.swift:76`; `ViralVariantCallingPipeline.swift:1249`; live help | |
| 48 | Settings **This BAM has already been primer-trimmed for iVar..** (label ending in a period) with default off, or on and locked when a record is found, flag `--ivar-primer-trimmed` | true | `BAMVariantCallingToolPanes.swift:94` and `:107` both use the label "This BAM has already been primer-trimmed for iVar." including its trailing period; `BAMVariantCallingDialogState.swift:81-82` sets `ivarPrimerTrimConfirmed = provenance != nil`; live help lists the flag. The chapter's doubled period is the registry label plus sentence punctuation, matching parameters.yaml | |
| 49 | Settings **Consensus allele frequency**: default 0.75, flag `--ivar-consensus-af` | true | `BAMVariantCallingDialogState.swift:83`; live help shows `(default: 0.75)` | |
| 50 | Settings **Merge AF distance**: default 0.25, flag `--ivar-merge-af-threshold` | true | `BAMVariantCallingDialogState.swift:84`; live help shows `(default: 0.25)` | |
| 51 | Settings **Merge AF distance**: "so two changes at 0.40 and 0.55 merge while one at 0.40 and another at 0.90 do not" | true (outcomes), wrong mechanism for the first | I evaluated `IVarCodonMerger.mergeRuleCheck` on both pairs. 0.40 and 0.55 do merge and 0.40 and 0.90 do not, so both stated outcomes hold. But 0.40 and 0.55 merge by the undocumented 0.4-to-0.6 rule, which fires before the distance test. The distance test would also have merged them (0.15 < 0.25), so the example survives; only the "by this setting" framing is imprecise | Covered by the claim 40 correction. Consider picking a pair outside the 0.4 to 0.6 band, for example 0.30 and 0.50, which merges by distance alone |
| 52 | Settings **Minimum ALT quality**: "Marks a call with the `bq` filter flag ... default is 20", flag `--ivar-bad-quality-threshold` | true | `BAMVariantCallingDialogState.swift:85`; `IVarTSVToVCFConverter.swift:123` declares the `bq` FILTER; live help says "iVar ALT_QUAL below this fails the bq filter (default 20)" | |
| 53 | Settings **Ignore strand bias (recommended for amplicons)**: defaults on, "On the command line the flag is inverted ... `--ivar-no-ignore-strand-bias`" | true | `BAMVariantCallingDialogState.swift:86` sets `true`; live help describes `--ivar-no-ignore-strand-bias` as "Apply iVar strand-bias filter (off by default for amplicon data)" | |
| 54 | Settings **Extra arguments**: "right after the subcommand and ahead of the arguments LGE builds, so it reaches `bcftools call`, `lofreq call`, or `ivar variants` as typed" | true | `ViralVariantCallingPipeline.swift:1338-1345` (`["call"] + advancedArguments + [...]`), `:1217-1224` (same shape for lofreq), `:1243-1244` (`["variants"]` then advancedArguments) | |
| 55 | Settings **Extra arguments**: "`--call-indels`, which makes LGE run an extra `lofreq indelqual` pass over a copy of the BAM first" | true | `ViralVariantCallingPipeline.swift:580-624` runs `lofreq indelqual` then `lofreq index` on a copied BAM when `lofreqRequiresIndelQualityPreprocessing` | |
| 56 | Settings **Extra arguments**: flag `--extra-args` | true | Live help shows `--extra-args, --advanced-options <extra-args>` | |
| 57 | "produces 1,056 rows from bcftools and 862 rows from LoFreq" | true | My recount of both tracks. Fixture README lines 113 and 124 agree | |
| 58 | "their output matches the VCFs committed under the fixture's `expected/variants/` folder row for row" | true | Record bodies compared line by line, identical for both callers, 1,056 and 862 lines each | |
| 59 | "Of the 1,056 bcftools rows, 873 are single-base substitutions and 183 are insertions or deletions." | true | Recount: 873 rows with single-base REF and ALT, 183 otherwise | |
| 60 | "All 862 LoFreq rows are substitutions, because LoFreq calls no indels unless you ask it to" | true | Recount: 862 substitutions, 0 indels; the indel path is gated on `--call-indels` through Extra arguments (`ViralVariantCallingPipeline.swift:580`) | |
| 61 | "Every one of the 1,056 bcftools rows has `FILTER` set to a bare `.`, and not one says `PASS`" | true | Recount: `{'.': 1056}` | |
| 62 | "Every one of the 862 LoFreq rows says `PASS`" | true | Recount: `{'PASS': 862}` | |
| 63 | "The **PASS** chip hides every row whose FILTER is anything but `PASS`, so on the bcftools track it empties the table completely" | true | `VariantDatabase+Cache.swift:174-180` materialises the chip as `SELECT id FROM variants WHERE filter = 'PASS'`. In the bcftools `.db` the FILTER column is NULL on all 1,056 rows, and that query returns 0. I ran it read-only against the track database and got `(0,)` | |
| 64 | "The bcftools VCF carries ten columns, the eight standard ones plus a `FORMAT` column reading `GT:PL:AD` and one sample column named HG002." | true | Recount: every row has 10 fields, FORMAT is `GT:PL:AD`, and the `#CHROM` header line ends with `HG002` | |
| 65 | "Of its rows, 623 carry the genotype `0/1` ... and 415 carry `1/1`" | true | Recount: 623 and 415. There are also 18 rows carrying `1/2`, which the sentence does not claim to cover | Optional. A reader summing 623 and 415 against 1,056 will come up 18 short. Consider "and 18 more are multi-allelic" |
| 66 | "The LoFreq VCF has eight columns and no sample column at all" | true | Recount: 8 fields on every row; the `#CHROM` line ends at `INFO` | |
| 67 | "At fixture coordinate 2078 both callers report the same `REF` and `ALT`, a reference `G` read as `A`, and both read a depth of 62." | true | Both rows carry `G A` and `DP=62` | |
| 68 | The two quoted VCF lines at position 2078 | true | Both match the files exactly. The bcftools INFO is abridged with `...`, which the surrounding prose makes clear, and the elided text is `VDB=0.240996;SGB=-0.693147;MQSBZ=0;MQ0F=0;AC=2;AN=2` | |
| 69 | "The benchmark VCF agrees with both, calling this position `1/1` from a depth of 1,231 reads" | true | Benchmark row 2078 sample field parses to `GT=1/1`, `DP=1231` | |
| 70 | "A variant track lives inside the reference bundle, under its `variants/` folder, as three files sharing one name. A `.vcf.gz` ... a `.vcf.gz.tbi` ... and a `.db`" | true | Directory listing of my scratch bundle shows exactly `vc-<uuid>.vcf.gz`, `.vcf.gz.tbi`, `.db` per track. Matches the CONSISTENCY.md variant-track storage rule, including no BCF and no CSI. A fourth file, `vc-<uuid>.lungfish-provenance.json`, is also written; the chapter does not claim the list is exhaustive but says "three files sharing one name", which the provenance sidecar also does | Optional. "as three files sharing one name, beside a provenance sidecar" |
| 71 | "The bcftools track from this fixture writes 46 KB, 368 bytes, and 2.2 MB respectively." | true | Measured 46,134 / 368 / 2,228,224 bytes. The committed fixture `.vcf.gz` and `.tbi` are the same 46,134 and 368. (The fixture README line 140 rounds the index to "4 KB", which is wrong; the chapter's 368 bytes is the measured value) | |
| 72 | "The fixture covers 500 kb and bcftools called 1,056 rows, which is roughly one difference every 470 bases." | true | 500,000 / 1,056 = 473.5. Fixture README line 10 gives the slice as 500,001 bp | |
| 73 | "954 of the 1,053 distinct positions bcftools called match a position in the fixture's 961-call benchmark, and 808 of LoFreq's 861 do." | true | My own intersection on (CHROM, POS): 954 and 808, from 1,053 and 861 distinct positions. Fixture README lines 136-137 agree | |
| 74 | "a real accuracy assessment needs a benchmarking program such as `hap.py`, which LGE does not ship" | true | No `hap.py` or `happy` entry in `third-party-tools-lock.json` or any `PluginPack` requirement | |
| 75 | "Click the variant track and the Inspector shows every step the run took with its exact command line, the tool versions, and checksums of the inputs." | true | The provenance sidecar carries eleven steps each with `command`, `toolVersion`, and per-input file records. Inspector rendering of the sidecar was not exercised live, but the data backing every listed element is present | |
| 76 | "The fixture runs recorded bcftools 1.24 and LoFreq 2.1.5 from the managed environments" | **false** for the LoFreq half | bcftools 1.24 is right, recorded as "1.24 (managed conda environment bcftools ... bioconda::bcftools=1.24=h6bd33b9_2)". The LoFreq step's `toolVersion` records the tool's own error text instead: "FATAL(lofreq_main.c\|main:336): Unrecognized command '--version' (managed conda environment lofreq; executable lofreq; package lofreq)". No version number appears. The binary is 2.1.5 (`lofreq version` reports it), but the run did not record that, and the sentence says "recorded". The author's own report notes this and the chapter did not carry the correction through | "The fixture runs recorded bcftools 1.24 from the managed environments, and the managed LoFreq is 2.1.5, though a quirk of that binary leaves the version field of a LoFreq run unfilled." |
| 77 | "they record the two threshold fields as 'caller-default' whenever the flags were left off" | true | Both sidecars carry `"minimumAlleleFrequency": {"type": "string", "value": "caller-default"}` and the same for `minimumDepth` | |
| 78 | CLI script: `lungfish-cli import fasta <fasta> --name "..." -o MyProject.lungfish` | true | Live `import fasta --help`: positional input, `--name`, `-o, --output-dir` | |
| 79 | CLI script: `lungfish-cli bam adopt-mapping --bundle ... --mapping-result ... --name ... --track-id ...` | true | Live `bam adopt-mapping --help` lists all four, with `--bundle`, `--mapping-result`, `--name` required and `--track-id` optional | |
| 80 | CLI script: `lungfish-cli variants call --bundle ... --alignment-track ... --caller bcftools --name ...` and the lofreq twin | true | Live `variants call --help`; and these are the commands my recounted runs were produced by | |
| 81 | "`bcftools view -H "$BUNDLE"/variants/<track-id>.vcf.gz` piped to `wc -l`" counts the rows in a finished track | true | The track files are named `vc-<uuid>.vcf.gz` under `variants/`, and this is how I obtained 1,056 and 862 | |
| 82 | iVar CLI example with `--ivar-primer-trimmed --min-af 0.05 --min-depth 10` | true | All three flags in live help; `--min-af` and `--min-depth` genuinely reach iVar per claim 26 | |
| 83 | "`--format` prints the run summary as text, JSON, or a tab-separated table, where the window always shows text." | true | Live help: `--format <format>` values text, json, tsv, default text. No `--format` control exists in `BAMVariantCallingToolPanes.swift` | |
| 84 | "`--threads` sets how many threads the run may use, where the window always takes the machine's processor count." | true | Live help `-t, --threads`; `BAMVariantCallingDialogState.swift:442` builds the GUI request with `threads: max(1, ProcessInfo.processInfo.activeProcessorCount)` | |

## Front matter

| Item | Verdict | Evidence |
|---|---|---|
| `parameters_refs: [variants.call-bcftools, variants.call-lofreq, variants.call-ivar]` matches roster row 27 | true | DRIFT.md line 3753 lists `[variants.call-lofreq, variants.call-ivar, variants.call-bcftools]`. Same set, different order; the roster does not impose an order |
| Every setting in all three registry entries has a Settings paragraph | true | The union of the three entries is Alignment Track, Output Variant Track Name, Minimum Allele Frequency, Minimum Depth, Extra arguments, plus iVar's This BAM has already been primer-trimmed for iVar., Consensus allele frequency, Merge AF distance, Minimum ALT quality, Ignore strand bias (recommended for amplicons). All ten appear as bold-label paragraphs in "## Settings", each with the exact label including the one ending in a period, its default, and its allowed values |
| Registry defaults and allowed values match the source | true | Checked each against `BAMVariantCallingDialogState.swift:73-87` and `ivarThresholdValidationMessage` at `:374-386`, which enforces the 0 to 1 ranges and the non-negative quality the registry states |
| `title: Calling Variants` matches the nav | true | `docs/user-manual/build/mkdocs.yml:99` reads `- Calling Variants: chapters/05-variants/01-calling-variants-from-amplicons.md` |
| Every `<!-- SHOT -->` marker is listed in `shots` with a caption | true | Body markers at lines 76, 96, 106 are `call-variants-dialog-bcftools`, `variants-tab-two-callers`, `call-variants-dialog-ivar`. All three are declared in `shots` with captions, and no declared shot lacks a marker |
| Every `glossary_refs` anchor resolves in GLOSSARY.md | true | All 29 resolve against the `{#anchor}` ids in `docs/user-manual/GLOSSARY.md`. Every inline `GLOSSARY.md#...` link in the body is also declared. Three declared terms, `bcftools`, `lofreq`, `snv`, are not linked from the body; harmless, since the chapter names all three tools in prose |
| Seven new glossary entries exist | true | `bcftools`, `bgzip`, `indel`, `lofreq`, `mpileup`, `ploidy`, `snv` are all present in the house `**Term**{#anchor}. ...  See also: ...` shape |
| `prereqs` resolve | true | `01-foundations/05-variants-and-vcf.md` exists and is titled "Variants and VCF Files", matching the in-body link text |
| Lint | passes | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh <file>` returns "no issues found" |

## The author's three defect claims

**Defect 1, thresholds that silently do nothing. Confirmed.** This is a real
defect and the strongest finding in the chapter. The Thresholds section is
built unconditionally at `BAMVariantCallingToolPanes.swift:44-68` with no
per-caller gating, and the two values are consumed at exactly one place in the
pipeline, `ViralVariantCallingPipeline.swift:1248-1249`, inside
`ivarVariantArguments`. For the other six callers they travel only into the
provenance payload at `:1353-1354`. Nothing disables the fields, dims them, or
warns. I reproduced the end state: a bcftools run with both flags omitted
records `caller-default` for both. A reader who types 0.20 gets silence.

**Defect 2, the PASS chip empties a bcftools table with no explanation.
Confirmed.** The chip is materialised as `WHERE filter = 'PASS'`
(`VariantDatabase+Cache.swift:177`), and the bcftools track's SQLite database
stores NULL for all 1,056 rows, so the query returns zero. I ran it directly
against the track database. There is no empty-state message keyed to this
cause.

**Defect 3, ellipsis inconsistency. Confirmed and slightly wider than
stated.** `MainMenu.swift:720` titles the top-level item `Call Variants…` with
U+2026 while the nearby `Search NCBI...`, `Search SRA...`, and
`Search Pathoplexus...` at `:742`, `:750`, `:757` use three ASCII periods.
`Plugin Manager…` (`:775`), `Haplotype Definitions…` (`:710`), and the
Inspector's `Call Variants…` button (`ReadStyleSection.swift:2592`) also use
U+2026, so the Search Online Databases submenu is the outlier rather than
Call Variants. Cosmetic.

## Notes for the editor

Three things to fix, in descending order of consequence.

1. Claim 17, the preselection sentence in step 1. It is the only outright
   false statement about behaviour a reader can act on, and it contradicts the
   Alignment Track setting paragraph four screens later, which is correct.
2. Claim 40, the "two rules" framing of codon merging. There are three, and
   the third is invisible in the dialog. Worth one clause because a reader
   tuning Merge AF distance on a pair inside the 0.4 to 0.6 band will find the
   setting has no effect.
3. Claim 76, LoFreq 2.1.5. The version is right about the binary and wrong
   about what the run recorded, in a sentence whose whole point is what the
   provenance records.

Everything quantitative in the chapter survived an independent recount from the
author's own run artifacts, cross-checked against the committed fixture and its
README. The storage layout, the PASS-chip behaviour, the caller-default
provenance, and every CLI flag are confirmed at source.

Verdicts: 89 true, 3 false, 1 unverifiable.
