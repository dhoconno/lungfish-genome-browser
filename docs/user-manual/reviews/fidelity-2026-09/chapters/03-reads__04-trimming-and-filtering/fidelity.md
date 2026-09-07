# Fidelity review: 03-reads/04-trimming-and-filtering.md

Reviewed 2026-09-06 against the Swift source in this worktree, the CLI help
dump at `docs/user-manual/reviews/fidelity-2026-09/cli-help/fastq.txt`, the
registry at `docs/user-manual/parameters.yaml`, the reality map at
`docs/user-manual/reviews/fidelity-2026-09/ground-truth/03-reads.md`, and the
tool lock manifest at
`Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`.

Every quoted read and base count was rechecked by rerunning the chapter's own
`fastq` commands against
`docs/user-manual/fixtures/hg002-chr20/HG002.chr20.10.0-10.5Mb_R1.fastq.gz`
with `.build/debug/lungfish-cli`, writing only into the campaign scratchpad,
and counting records with `awk`. Those reruns are cited as "CLI rerun" below.

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
reports no issues on this chapter.

## Claims

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| Front matter `parameters_refs: [fastq.fastp-trim, fastq.quality-trim, fastq.adapter-removal, fastq.primer-trimming, fastq.trim-fixed-bases, fastq.filter-by-read-length]` | true | Identical to roster row 17, `DRIFT.md:3743`. All six ids exist in `parameters.yaml` at lines 184, 255, 312, 356, 431, 474. | no change |
| Front matter `entry_points: "Tools > Trimming & Filtering > (pick the operation)"` | true | `MainMenu.swift:702-706` adds one submenu per category directly under Tools via `ToolsMenuModel.build`; `MainMenu.swift:804-818` fills each with one item per operation titled `toolID.title` plus an ellipsis. Category title "Trimming & Filtering" at `ToolsMenuModel.swift:65`. | no change |
| Front matter `entry_points: "CLI: lungfish-cli fastq trim, quality-trim, adapter-trim, primer-remove, fixed-trim, length-filter"` | true | `fastq.txt` banners `==== fastq trim ====`, `quality-trim`, `adapter-trim`, `primer-remove`, `fixed-trim`, `length-filter`. | no change |
| Front matter `shots` lists four ids with captions | true | Body carries exactly four markers, `trimming-dialog` (line 73), `trim-operation-row` (85), `length-filter-readiness` (95), `primer-trimming-literal-pane` (111). Each has a caption in front matter and no caption lacks a marker. | no change |
| Front matter `glossary_refs` anchors all resolve | true | All nineteen anchors (`fastq`, `phred-score`, `read-length`, `adapter`, `fastp`, `bbduk`, `seqkit`, `sliding-window-trimming`, `k-mer`, `hamming-distance`, `umi`, `amplicon`, `primer`, `primer-trim`, `soft-clip`, `pileup`, `operations-panel`, `provenance`, `bundle`) match a `{#anchor}` heading in `GLOSSARY.md`, including the K and U sections the author added. | no change |
| "Six operations sit under **Tools > Trimming & Filtering**" | true | `FASTQOperationDialogState.swift:1269` returns `[.fastpTrim, .qualityTrim, .adapterRemoval, .primerTrimming, .trimFixedBases, .filterByReadLength]`. | no change |
| "every one of them reads a FASTQ bundle and writes a new one. … The input bundle is never modified" | true | Every operation routes through `.derivative(request:inputURLs:outputMode:)` (`FASTQOperationDialogState.swift:566-576` and neighbours), which writes a new bundle. No write path targets the input. | no change |
| "fastp handles quality trimming, adapter removal, and fixed-base trimming." | true | `fastq.txt` OVERVIEW lines: `quality-trim` "Trim low-quality bases using fastp", `adapter-trim` "Remove adapter sequences using fastp", `trim` "Trim adapters and low-quality bases in one fastp pass". `fixed-trim` names no tool in help but is grouped with the fastp operations; the fastp attribution for fixed-trim is the weakest link in this sentence (see the unverifiable row below). | see the fixed-trim engine row |
| "bbduk handles primer trimming when you type a primer sequence in." | true | `FASTQOperationDialogState.swift:549-556` builds `FASTQPrimerTrimConfiguration(source: .literal, tool: .bbduk, ...)`. | no change |
| "seqkit handles the length filter." | true | `FastqCommand.swift:424-430` builds `var args = ["seq"]`, appends `-m`/`-M`, and calls `runner.run(.seqkit, arguments: args)`. This settles the reality map's open question at `ground-truth/03-reads.md:252` and 259. | no change |
| "A fourth program, cutadapt, takes over primer trimming when you point at a FASTA file of primers instead of typing one" | true | `FASTQOperationDialogState.swift:558-564` builds `FASTQPrimerTrimConfiguration(source: .reference, mode: .linked, tool: .cutadapt)`. | no change |
| "All four ship inside the application." | true | `third-party-tools-lock.json` `tools` array carries `fastp` 1.3.6, `cutadapt` 5.2, `seqkit` 2.13.0, and `bbduk.sh` inside the BBTools 40.02 entry. | no change |
| "choose **File > New Project** (Cmd-N)" | true | `MainMenu.swift:170-173` adds "New Project" with `keyEquivalent: "n"`. | no change |
| "These operations use tools from the Required Setup pack, the one pack LGE installs by itself." | true | `PluginPack.swift:431` and 446 set `category: "Required Setup"`; `PluginManagerView.swift:451` renders that section. fastp, cutadapt, seqkit, and BBTools are all in the `lungfish-tools` pack the manual calls Required Setup. | no change |
| "Choose **Tools > Trimming & Filtering > fastp Adapter + Quality Trim...**" | true | Operation title is exactly "fastp Adapter + Quality Trim" (`FASTQOperationDialogState.swift:1958`) and the menu item appends an ellipsis (`MainMenu.swift:810-813`). | no change |
| "A window titled FASTQ/FASTA Operations opens on that operation." | true | `FASTQOperationDialogState.swift:1250-1252` `var dialogTitle: String { "FASTQ/FASTA Operations" }`. | no change |
| "Its left-hand list holds all six operations in the category, so you can switch to another one without closing the window" | true | The dialog is built per category from `toolIDs(for:)` (`FASTQOperationDialogState.swift:1269`), and `selectedToolID` is mutable state driving the pane switch (`FASTQOperationToolPanes.swift:321`). | no change |
| "Leave **Adapter Mode** on Auto-Detect, **Threshold** at 20, and **Window Size** at 4. Leave **Mode** on Cut Right." | true | Labels at `FASTQOperationToolPanes.swift:327-341`. Defaults at `FASTQOperationDialogState.swift:227-232`, `qualityTrimThreshold = 20`, `qualityTrimWindowSize = 4`, `qualityTrimMode = .cutRight`, `adapterRemovalMode = .autoDetect`. Segment titles "Auto-Detect" and "Cut Right" at `FASTQOperationToolPanes.swift:337`, 1070-1073. | no change |
| "Leave **Output Strategy** on Per Input." | true | Picker labelled "Output Strategy" at `FASTQOperationToolPanes.swift:109`; options `[.perInput, .groupedResult]` at `FASTQOperationDialogState.swift:1066-1067`; `supportsConfigurableOutput` is true for all six trimming operations (`FASTQOperationDialogState.swift:2135-2141`). | no change |
| "the readiness line at the bottom of the pane … reads 'Ready to configure output.' when nothing is missing" | true | `FASTQOperationDialogState.swift:1059-1061` returns "Ready to configure output." when `showsOutputStrategyPicker` and nothing blocks. Rendered in the `.readiness` section at `FASTQOperationToolPanes.swift:119-126`. | no change |
| "The result lands under `Analyses/`, in a folder named for the tool and the time the run started, in the shape `Analyses/<tool>-<timestamp>/`." | true | `FASTQOperationDialogState.swift:1607-1613` `defaultOutputDirectory` returns `projectURL/Analyses`. The `<tool>-<timestamp>` shape is the project convention, `AnalysesMigration.swift:103` renaming to `"\(tool)-\(timestamp)"`, and `CONSISTENCY.md:47` settles it for the campaign. | no change |
| "The Operations Panel, which opens with **Operations > Show Operations Panel** (Cmd-Shift-P)" | true | `MainMenu.swift:866-872`, title "Show Operations Panel", `keyEquivalent: "p"`, modifiers `[.command, .shift]`. | no change |
| "Choose **Tools > Trimming & Filtering > Filter by Read Length...**" | true | Title "Filter by Read Length" at `FASTQOperationDialogState.swift:1963`. | no change |
| "Set **Min Length** to 50 and leave **Max Length** empty. Both bounds start empty" | true | Labels at `FASTQOperationToolPanes.swift:397-398`; `filterByReadLengthMin`/`Max` both `nil` at `FASTQOperationDialogState.swift:241-242`. | no change |
| "while both are empty the readiness line reads 'Enter a minimum, a maximum, or both.'" | true | `FASTQOperationDialogState.swift:1348-1350`, exact string. | no change |
| "Use **Tools > Trimming & Filtering > Trim Fixed Bases...**" | true | Title "Trim Fixed Bases" at `FASTQOperationDialogState.swift:1962`. | no change |
| "Set **5' Trim**, **3' Trim**, or both … Both start at 0, and while both are 0 the readiness line reads 'Enter at least one fixed trim amount.'" | true | Labels at `FASTQOperationToolPanes.swift:391-392`; defaults 0 at `FASTQOperationDialogState.swift:239-240`; message at `FASTQOperationDialogState.swift:1343-1346`, exact string. | no change |
| "The operation is **Tools > Trimming & Filtering > Primer Trimming...**, and its pane changes shape depending on **Primer Source**." | true | Title "Primer Trimming" at `FASTQOperationDialogState.swift:1961`; picker "Primer Source" at `FASTQOperationToolPanes.swift:370`; the pane branches on `state.primerTrimmingSource` at line 376. | no change |
| "**Tools > Trimming & Filtering > Quality Trim...** trims quality and leaves adapters alone, and it carries an **Extra arguments** field the combined pane does not have." | true | `FASTQOperationToolPanes.swift:356` adds `labeledTextField("Extra arguments", ...)` in `case .qualityTrim` only; the `.fastpTrim` case (lines 326-343) has no such field. Title "Quality Trim" at `FASTQOperationDialogState.swift:1959`. | no change |
| "**Tools > Trimming & Filtering > Adapter Removal...** removes adapters and leaves quality alone." | true | Title "Adapter Removal" at `FASTQOperationDialogState.swift:1960`; `fastq.txt` `==== fastq adapter-trim ====` OVERVIEW "Remove adapter sequences using fastp", with no quality options. | no change |
| "Every operation in this category also accepts FASTA files" | **false** | `FASTQOperationDialogState.swift:2196-2208`, `supportsFASTA` is false for `.fastpTrim` and `.qualityTrim` and true for `.adapterRemoval`, `.primerTrimming`, `.trimFixedBases`, `.filterByReadLength`. Four of the six accept FASTA, not all six. | "Four of these six operations also accept FASTA files, which hold sequence without quality scores. The two fastp quality operations do not, because they have no quality scores to read." |
| "When every file you selected is FASTA, the window relabels itself and its subtitle reads FASTA rather than FASTQ." | true | `FASTQOperationDialogState.swift:1243-1247` `isFASTAInputMode` requires every selected URL to be FASTA; `dialogSubtitle` (1254-1256) interpolates `inputDatasetDisplayName.uppercased()`, which is "FASTA" or "FASTQ" (1258-1260). | no change |
| "The quality-based operations have nothing to work with on FASTA input, so this path is for the length filter and the fixed trim." | true | Consistent with `supportsFASTA` excluding `.fastpTrim` and `.qualityTrim`. Adapter Removal and Primer Trimming also accept FASTA, so the sentence understates the set, but it makes no false statement about the two it names. | Optionally widen to name Adapter Removal and Primer Trimming as well. |

### Settings coverage

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| The Settings section documents all 26 registry settings across the six operations | true | Counted 6 + 5 + 3 + 6 + 3 + 3 = 26 in `parameters.yaml:184-506`. The chapter's `## Settings` section carries 26 bold-label paragraphs under six H3 headings matching the six operations. | no change |
| fastp Adapter + Quality Trim, **Threshold**, default 20, integers above 0, `--threshold` | true | `parameters.yaml:194-200`; `FASTQOperationDialogState.swift:227`; `fastq.txt` `==== fastq trim ====` "--threshold … (default: 20)". | no change |
| **Window Size**, default 4, `--window` | true | `parameters.yaml:201-207`; `FASTQOperationDialogState.swift:228`; `fastq.txt` "--window … (default: 4)". | no change |
| **Mode**, default Cut Right, allowed Cut Right, Cut Front, Cut Tail, Cut Both, `--mode` | true | `parameters.yaml:208-214`; display names at `FASTQOperationToolPanes.swift:1070-1082`; `fastq.txt` "cut-right, cut-front, cut-tail, cut-both (default: cut-right)". | no change |
| **Adapter Mode**, default Auto-Detect, allowed Auto-Detect, Manual Sequence, `--adapter` where a sequence means Manual Sequence and omitting the flag means Auto-Detect | true | `parameters.yaml:215-221`; segments at `FASTQOperationToolPanes.swift:336-338`; `fastq.txt` "--adapter <adapter> Adapter sequence (omit for auto-detect)". | no change |
| **Adapter Sequence**, starts empty, appears only while Adapter Mode is Manual Sequence, `--adapter` | true | `parameters.yaml:222-228`; `adapterRemovalSequence = ""` at `FASTQOperationDialogState.swift:232`; the field is inside `if state.adapterRemovalMode == .specified` at `FASTQOperationToolPanes.swift:342-344`. | no change |
| **Output Strategy**, default Per Input, allowed Per Input and Grouped Result, no command-line flag | true | `parameters.yaml:229-235` with `cli_flag: null`; `outputStrategyOptions` at `FASTQOperationDialogState.swift:1066-1067`; `fastq trim` help lists no output-strategy flag. | no change |
| Quality Trim, **Threshold** / **Window Size** / **Mode**, same three defaults | true | `parameters.yaml:262-286`; same state properties (`FASTQOperationToolPanes.swift:346-355`); `fastq.txt` `==== fastq quality-trim ====` gives 20, 4, cut-right. | no change |
| Quality Trim, **Extra arguments**, starts empty, not checked before fastp sees them, `--extra-args` | true | `parameters.yaml:287-293`; `qualityTrimExtraArguments = ""` at `FASTQOperationDialogState.swift:230`; `fastq.txt` "--extra-args … Additional fastp arguments passed verbatim". | no change |
| Quality Trim, **Output Strategy** | true | `parameters.yaml:294-300`. | no change |
| Adapter Removal, **Adapter Mode** and **Adapter Sequence** | true | `parameters.yaml:321-334`; pane at `FASTQOperationToolPanes.swift:358-367`. | no change |
| Adapter Removal, "while Manual Sequence is chosen and this field is empty the readiness line reads 'Enter an adapter sequence for manual adapter removal.'" | true | `FASTQOperationDialogState.swift:1329`, exact string. Note the combined operation uses a different message at line 1317, "Enter an adapter sequence or switch to auto-detect.", which the chapter does not quote and does not need to. | no change |
| Adapter Removal, **Output Strategy** | true | `parameters.yaml:335-341`. | no change |
| Primer Trimming, **Primer Source**, default Literal Sequence, allowed Literal Sequence and Reference FASTA, maps to `--literal` or `--ref` | true | `parameters.yaml:365-371`; `primerTrimmingSource = .literal` at `FASTQOperationDialogState.swift:234`; segments at `FASTQOperationToolPanes.swift:371-372`; `fastq.txt` lists both `--literal` and `--ref`. | no change |
| "pick the file itself under **Primer Reference** in the Inputs section" | true | Input-kind display name "Primer Reference" at `FASTQOperationDialogState.swift:2232`. | no change |
| "LGE accepts only FASTA-like extensions such as `.fa`, `.fasta`, and `.fna`, along with `.lungfishref`" | true | `FASTQOperationDialogState.swift:2258-2270`, `.primerSource` returns `fastaLike.contains(ext)` where `fastaLike` is `["fa", "fasta", "fna", "fas", "ffn", "frn", "faa", "gb", "gbk", "gbff", "embl", "lungfishref"]`. The list is wider than the three named, but "such as" carries that. | no change |
| Primer Trimming, **Primer Sequence**, starts empty, appears only in Literal Sequence, `--literal` | true | `parameters.yaml:372-378`; `primerTrimmingLiteralSequence = ""` at `FASTQOperationDialogState.swift:235`; field inside `if state.primerTrimmingSource == .literal` at `FASTQOperationToolPanes.swift:376-377`. | no change |
| "while it is empty the readiness line reads 'Enter a literal primer sequence or switch to reference mode.'" | true | `FASTQOperationDialogState.swift:1333-1338`, exact string. | no change |
| **k**, default 15, `--kmer`, "whose own default is 23 rather than 15" | true | `parameters.yaml:379-385`; `primerTrimmingKmerSize = 15` at `FASTQOperationDialogState.swift:236`; label "k" at `FASTQOperationToolPanes.swift:379`; `fastq.txt` "--kmer … (default: 23)". | no change |
| **mink**, default 11, `--mink` | true | `parameters.yaml:386-392`; `primerTrimmingMinKmer = 11` at `FASTQOperationDialogState.swift:237`; label "mink" at `FASTQOperationToolPanes.swift:380`; `fastq.txt` "--mink … (default: 11)". | no change |
| **hdist**, default 1, `--hdist` | true | `parameters.yaml:393-399`; `primerTrimmingHammingDistance = 1` at `FASTQOperationDialogState.swift:238`; label "hdist" at `FASTQOperationToolPanes.swift:381`; `fastq.txt` "--hdist … (default: 1)". | no change |
| Primer Trimming, **Output Strategy** | true | `parameters.yaml:400-406`. | no change |
| "Primer Sequence, k, mink, and hdist all disappear from the pane when Primer Source is Reference FASTA … In their place the pane reads 'Select the primer reference FASTA in the Inputs section.'" | true | `FASTQOperationToolPanes.swift:376-387`, the `else` branch renders exactly that string and none of the four fields. | no change |
| "because that path runs cutadapt in linked mode rather than bbduk and none of those four values reaches it" | true | `FASTQOperationDialogState.swift:558-564` passes `mode: .linked, tool: .cutadapt` with no kmer, mink, or hdist arguments. | no change |
| Trim Fixed Bases, **5' Trim** default 0 `--front`, **3' Trim** default 0 `--tail` | true | `parameters.yaml:440-453`; defaults at `FASTQOperationDialogState.swift:239-240`; `fastq.txt` `==== fastq fixed-trim ====` "--front … (default: 0)", "--tail … (default: 0)". | no change |
| Trim Fixed Bases, **Output Strategy** | true | `parameters.yaml:454-460`. | no change |
| "There is no quality check and no minimum-length guard on this operation." | true | `parameters.yaml:469-471` notes the Advanced Settings pane says trim values are applied exactly as entered, with no quality check and no minimum-length guard. Confirmed by the CLI rerun of `fixed-trim --front 10`, which kept all 45,574 reads and produced a 40 bp shortest read from the 50 bp shortest input read. | no change |
| Filter by Read Length, **Min Length** default empty `--min`, **Max Length** default empty `--max` | true | `parameters.yaml:483-496`; both `nil` at `FASTQOperationDialogState.swift:241-242`; `fastq.txt` `==== fastq length-filter ====` lists `--min` and `--max` with no defaults. | no change |
| Filter by Read Length, **Output Strategy** | true | `parameters.yaml:497-503`. | no change |
| "This filter works one read at a time. It has no option to drop a whole pair when only one mate falls below the bound." | true | `FastqCommand.swift:424-430` runs `seqkit seq -m/-M` on a single input file with no pair-aware flag; the CLI takes one `<input>` argument. | no change |
| "Setting a minimum larger than the maximum makes the readiness line read 'Minimum read length cannot exceed maximum read length.'" | true | `FASTQOperationDialogState.swift:1351-1353`, exact string. | no change |

### Numbers

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| Input R1 holds 45,574 reads and 11,331,492 bases, mean 248.6 bp, shortest 50 bp | true | CLI rerun, counted from the gzipped fixture: `reads=45574 bases=11331492 mean=248.6394 min=50 max=250`. | no change |
| The combined trim at defaults gives 45,534 reads and 10,540,866 bases, mean 231.5 bp, shortest 1 bp | true | CLI rerun of `fastq trim --threshold 20 --window 4 --mode cut-right --adapter-trimming`: `reads=45534 bases=10540866 min=1`, mean 231.4944 rounding to 231.5. Matches the author's `R1.trim.fastq` byte for byte in these counts. | no change |
| "45,534 of the original 45,574 survived, which is 99.91 percent" | true | 45534/45574 = 99.9122 percent. | no change |
| "Only 40 reads were removed outright" | true | 45574 - 45534 = 40. | no change |
| "93.0 percent of it survived, so the trim cost seven percent of the sequence" | true | 10540866/11331492 = 93.0228 percent. | no change |
| "the average read lost about seventeen bases off its end" | true | 248.6394 - 231.4944 = 17.14. | no change |
| "Six hundred and seventy-seven reads came out shorter than 50 bases." | true | CLI rerun, counting records under 50 bases in the trimmed file: 677. | no change |
| "Filtering the trimmed file at a 50-base minimum kept 44,857 reads, which is 98.51 percent of what went into the filter and 98.43 percent of the original file." | true | CLI rerun of `length-filter --min 50` on the trimmed file: `reads=44857`. 44857/45534 = 98.5132 percent; 44857/45574 = 98.4267 percent. | no change |
| "Running Adapter Removal on its own changed nothing at all, giving back all 45,574 reads and all 11,331,492 bases" | true | CLI rerun of `fastq adapter-trim` with auto-detect: `reads=45574 bases=11331492 min=50`, identical to the input. | no change |
| "Running Quality Trim on its own gave exactly the same 45,534 reads and 10,540,866 bases as the combined operation" | true | The author's `R1.qtrim.fastq` measures `reads=45534 bases=10540866 min=1`, identical to `R1.trim.fastq` in every statistic measured. | no change |
| "Running Quality Trim at a Threshold of 30 instead of 20 kept 44,916 reads but only 8,947,205 bases" | true | CLI rerun of `quality-trim --threshold 30 --window 4 --mode cut-right`: `reads=44916 bases=8947205`. | no change |
| "raising the threshold by ten points cost a further 1.59 million bases" | true | 10540866 - 8947205 = 1,593,661, which rounds to 1.59 million. | no change |
| "Trim Fixed Bases with **5' Trim** set to 10 removed exactly 455,740 bases, which is ten bases times 45,574 reads, and kept every read." | true | CLI rerun of `fixed-trim --front 10`: `reads=45574 bases=10875752`. 11331492 - 10875752 = 455,740 = 10 x 45,574. | no change |
| "For typical Illumina data expect 90 to 99 percent of reads to survive a quality trim, and this fixture's 99.91 percent sits at the healthy end of that." | true | The 99.91 percent figure is confirmed above. The 90 to 99 percent expectation is a field convention rather than an app behaviour, and the chapter presents it as guidance, not as something the app reports. | no change |
| "A survival rate below about 70 percent means the Threshold is too harsh" and "Re-run at a Threshold of 15, a one-in-32 error rate" | true | Q15 is an error probability of 10^-1.5 = 0.0316, which is one in about 32. The 70 percent figure is stated as a rule of thumb, not as an app readout. | no change |
| "the primer-remove run kept 45,410 reads with 15,046 shortened" (from the review brief) | **unverifiable as written, and absent from the chapter** | The chapter never states either figure, so there is no claim in the text to judge. For the record, the author's `R1.primer.fastq` does measure `reads=45410`, matching the brief. The "15,046 shortened" half does not reproduce: joining input and output read lengths by read name gives 2,616 reads shortened and 42,794 unchanged. Whoever produced 15,046 counted something else. | Leave the chapter as it stands. If a primer figure is ever added, use 45,410 kept and recount the shortened reads before quoting one. |

### Engines and the absence of an adapter metric

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| Trim Fixed Bases runs fastp | unverifiable | The chapter's opening groups fixed-base trimming under fastp. `fastq.txt` `==== fastq fixed-trim ====` names no tool, unlike its neighbours whose OVERVIEW lines name fastp explicitly. The GUI route goes through `.derivative(request: .fixedTrim(...))`, and I did not trace the derivative pipeline to the process it spawns. | Settle it by reading the `fixedTrim` case in the FASTQ derivative pipeline and naming whichever binary it launches. Until then the safe wording drops the tool from that clause, "fastp handles quality trimming and adapter removal", and says separately what fixed trimming runs. |
| "There is no separate QC tab." | true | `FASTQDatasetViewController.swift:494-496` sets `middleTabControl.segmentCount = 2` with labels "Operations" and "Reads". No QC segment exists. | no change |
| "Its top pane holds the nine summary cards and the three sparkline charts" | true | `FASTQChartViews.swift:30-41` returns nine cards, Reads, Bases, Mean Length, Median Length, N50, Mean Q, Q20, Q30, GC. `FASTQSparklineStrip.swift:22-29` defines three kinds titled "Length Dist.", "Q / Position", "Q Score Dist.". | no change |
| "The Q / Position sparkline, which plots mean quality against position along the read" | true | `FASTQSparklineStrip.swift:24` title "Q / Position"; the popover chart is `FASTQQualityBoxplotView` (line 48). | no change |
| "The Length Dist. sparkline tightens around the expected fragment size" | true | `FASTQSparklineStrip.swift:23` title "Length Dist.". | no change |
| "The adapter fastp settled on is not reported anywhere in the app's summary, so you cannot check it there." | true | The nine cards at `FASTQChartViews.swift:30-41` carry no adapter field, and the three sparklines at `FASTQSparklineStrip.swift:22-29` are length and quality only. No adapter-contamination metric exists in the FASTQ viewport. This is the correct handling of DRIFT rows 20, 30, and 33. | no change |
| "Re-run **Tools > QC & Reporting > Refresh QC Summary...** on the new bundle" | true | Category title "QC & Reporting" at `ToolsMenuModel.swift:63`; operation title "Refresh QC Summary" at `FASTQOperationDialogState.swift:1955`; the category holds that one operation (`FASTQOperationDialogState.swift:1265-1266`). | no change |
| "Right-click a finished row to reach its context menu" | true | `OperationsPanelController.swift:384-386` attaches an `NSMenu` to the table view; actions include `contextRunAgain` (442) and `contextCopyCLICommand` (448). | no change |
| Shot caption "the finished trim row expanded, showing its state, elapsed time, and command line" | true | The expansion renders the CLI command section (`OperationsPanelController.swift:953-955`) and log entries (983-985); state and elapsed are row columns, the Elapsed column at line 354-359. All three are on screen for an expanded row. | no change |
| "read the durable record in the bundle's `provenance/` folder, which stores the resolved settings, the command, the checksums, and the runtime" | true | `FASTQBundle.swift:391` and `BundleManifest+Validation.swift:229` both recognise the reserved path `"provenance"`. Every trimming operation sets `requiresProvenance` true (`FASTQOperationDialogState.swift:2143-2149`). | no change |

### Command line

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "Each subcommand takes one input file and requires `--output`." | true | `fastq.txt` USAGE lines for all six show a single `<input>` and `--output <output>` marked "(required)". | no change |
| "Add `--force` to overwrite an output that already exists, and `--compress` to write the result gzip-compressed. Both are available on every subcommand below." | true | `fastq.txt` OPTIONS blocks for `trim`, `quality-trim`, `adapter-trim`, `fixed-trim`, `primer-remove`, and `length-filter` each list `--force` and `--compress`. Both exercised in the CLI reruns. | no change |
| The `fastq trim` example with `--threshold 20 --window 4 --mode cut-right --adapter-trimming --output ... --force` | true | Every flag appears in `fastq.txt` `==== fastq trim ====`. The command ran successfully in the rerun and reproduced 45,534 reads and 10,540,866 bases. | no change |
| The `fastq quality-trim`, `fastq adapter-trim`, `fastq fixed-trim`, and `fastq length-filter` examples | true | All flags present in the respective help blocks; all four commands ran successfully in the rerun with the counts the chapter quotes. | no change |
| The `fastq primer-remove` example with `--literal ... --kmer 15 --mink 11 --hdist 1` | true | All flags present in `fastq.txt` `==== fastq primer-remove ====`. Not rerun, since the chapter quotes no count from it. | no change |
| "`fastq trim` carries an `--adapter-trimming` and `--no-adapter-trimming` pair, defaulting to `--adapter-trimming`" | true | `fastq.txt`: "--adapter-trimming/--no-adapter-trimming Run fastp adapter trimming in the same pass (default: enabled) (default: --adapter-trimming)". | no change |
| "the negative form has no counterpart in the dialog because the combined operation always trims adapters" | true | The `.fastpTrim` pane (`FASTQOperationToolPanes.swift:326-343`) has no adapter on/off toggle, only Adapter Mode choosing between auto-detect and a manual sequence. `parameters.yaml:243-246` records the same. | no change |
| "`fastq trim` and `fastq quality-trim` both take `--extra-args` … while only the Quality Trim pane offers that field in the window" | true | Both help blocks list `--extra-args`; only `case .qualityTrim` builds the field (`FASTQOperationToolPanes.swift:356`). | no change |
| "`fastq primer-remove` defaults `--kmer` to 23 where the dialog defaults **k** to 15" | true | `fastq.txt` "--kmer … (default: 23)"; `FASTQOperationDialogState.swift:236` sets 15. | no change |
| "Pass `--engine cutadapt-linked` to select it, and tune it with `--minimum-overlap`, which defaults to 12, and `--error-rate`, which defaults to 0.12." | true | `fastq.txt` `==== fastq primer-remove ====`: `--engine` "bbduk or cutadapt-linked (default: bbduk)", `--minimum-overlap` "(default: 12)", `--error-rate` "(default: 0.12)". | no change |
| "Both of those apply to the cutadapt engine alone and are ignored by the bbduk default." | true | Help text for both flags says "for cutadapt-linked primer matching"; `parameters.yaml:414-420` records the same. | no change |

## Notes for the editor

One correction is needed. The FASTA paragraph in the Procedure overstates the
set, since `supportsFASTA` excludes the two fastp quality operations. The rest
of that paragraph is accurate.

One item stays open. The chapter attributes fixed-base trimming to fastp in its
opening paragraph. Nothing I read confirms or refutes it, because
`fastq fixed-trim` is the one subcommand in this group whose help names no tool.
Reading the `fixedTrim` case in the FASTQ derivative pipeline would settle it.

Two glossary anchors, `read-length` and `primer-trim`, are declared in
`glossary_refs` but never linked from the body. Both resolve, so this is a
tidiness point for the editor rather than a fidelity failure.

The review brief mentioned a primer-remove result of 45,410 reads with 15,046
shortened. The chapter quotes neither. The 45,410 half reproduces exactly; the
15,046 half does not, and my own count of shortened reads is 2,616. Since the
chapter makes no claim here, nothing needs correcting, but the figure should not
be added later without a recount.

Verdicts: 98 true, 1 false, 2 unverifiable.
