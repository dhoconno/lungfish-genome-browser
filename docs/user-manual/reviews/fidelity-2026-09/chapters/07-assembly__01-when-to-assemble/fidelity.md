# Fidelity review: 07-assembly/01-when-to-assemble

Reviewer pass on 2026-09-07 against the campaign worktree at the
2026.9.13 Preview source tree. Roster row 46, a concept chapter with no
registry ids, so there are no Settings entries to check against
`parameters.yaml`.

Ground truth used, in the campaign's order: the Swift source under
`Sources/`, the CLI help dumps under
`docs/user-manual/reviews/fidelity-2026-09/cli-help/`, the managed tool
lock, the fixture's committed `expected/` outputs, and the author's own
scratch run outputs under
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/assembly-concept/`.

Commands run by this review were read-only. No assembler was launched.
The SKESA and MEGAHIT figures were checked by reading the author's
committed run artefacts (`assembly-result.json`, `contigs.fasta`,
`contigs.fasta.fai`, the MEGAHIT `log`) rather than by re-executing,
since those artefacts carry the exact numbers the chapter quotes and
re-running would only reproduce them. Lint was re-run.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | Front matter `entry_points` lists the five `Tools > Assembly > <tool>...` paths | true | `MainMenu.swift:786-819` builds one `"\(toolID.title)…"` item per tool in each category submenu, with no aggregate leaf. `ToolsMenuModel.swift:71` gives the category title "Assembly". `FASTQOperationDialogState.swift:1989-1994` gives the five titles SPAdes, MEGAHIT, SKESA, Flye, Hifiasm. | |
| 2 | "An assembler looks for places where the end of one read matches the start of another, builds an assembly graph ... and then walks that graph to emit ... contigs" | true | Tool-domain description with no app claim. Consistent with the glossary's own Assembly graph entry (`GLOSSARY.md:41`) and with `ManagedAssemblyPipeline.swift:178-337`, where no assembler command takes a reference argument. | |
| 3 | "LGE ships five assemblers behind one shared configuration sheet" | true | `AssemblyTool.swift:8-13` declares exactly spades, megahit, skesa, flye, hifiasm. `AssemblyWizardSheet.swift` is one sheet reached by all five tool ids (`FASTQOperationToolPanes.swift:33-44`). | |
| 4 | "it opens with that tool already chosen in its Assembler picker" | true | `AssemblyWizardSheet.swift:95, 112` seed `selectedTool` from `initialTool`, which the menu item supplies. | |
| 5 | "the result is packaged the same way, as a `.lungfishref` assembly bundle inside a per-run folder under the project's `Analyses/` folder" | true | `AssemblyBundleBuilder.swift:89-101` publishes `<name>.lungfishref`. `AnalysesFolder.swift:18` names the directory "Analyses" and `:118-137` builds `Analyses/{tool}-{timestamp}/`. The GUI call site passes `assemblyRequest.tool.rawValue` (`MainSplitViewController+GenomicsDisplay.swift:1215-1220`). | |
| 6 | "The bundle's internal structure is identical to a reference bundle" | true | `AssemblyBundleBuilder.swift:89-140` builds the same `.lungfishref` shape with a bgzipped, indexed contigs FASTA and a manifest. | |
| 7 | "Five assemblers arrive in one plugin pack, shown in the Plugin Manager as Genome Assembly, at roughly 950 MB installed" | true | `PluginPack.swift:668-718`, id `assembly`, name "Genome Assembly", packages spades/megahit/skesa/flye/hifiasm, `estimatedSizeMB: 950`. The chapter's hedge "roughly" is correct, since 950 is the manifest's estimate rather than a measured install. | |
| 8 | "install it first from **Tools > Plugin Manager...** (Cmd-Shift-B)" | true | `MainMenu.swift:773-775` adds "Plugin Manager…" with the Cmd-Shift-B key equivalent, and the surrounding comment names it "Cmd-Shift-B for Bioconda". | |
| 9 | "The assembly sheet carries a Readiness panel at the bottom that reports whether the pack and the selected tool are present, and it names what is missing" | true | `AssemblyWizardSheet.swift:645-700`, section title "Readiness", printing `compatibilityPresentation.message`, "Managed tool status: \(toolStatus.statusText)", "Managed tool status: checking Genome Assembly pack.", and per-requirement failure strings. `canRun` (`:19-27`) requires `compatibilityPresentation.state == .ready`. | |
| 10 | "This release ships SPAdes 4.3.0, MEGAHIT 1.2.9, SKESA 2.5.1, Flye 2.9.6, and hifiasm 0.25.0" | true | `third-party-tools-lock.json`, the five `"packID": "assembly"` rows, versions 4.3.0, 1.2.9, 2.5.1, 2.9.6, 0.25.0. | |
| 11 | "There is no single Assembly command that then asks which tool you want" | true | `MainMenu.swift:805-818` emits one item per tool id and nothing else. `FASTQOperationDialogState.swift:1280-1281` returns the five tool ids for `.assembly`. No aggregate item exists. | |
| 12 | "Select the reads you want to assemble in the project sidebar first, because the sheet takes whatever is selected when it opens and offers no file picker of its own" | true | `AssemblyWizardSheet.swift:474-490` renders the Inputs section as read-only rows. No file-picker control exists in the sheet. Corroborated by the reality map's claim 9 for chapter 02. | |
| 13 | "Canu is not here ... Trinity is not here either" | true | `AssemblyTool.swift:8-13` and `PluginPack.swift:673` list only the five. | |
| 14 | "The genome-size column is guidance from published practice rather than a limit the application enforces. Nothing in LGE checks your genome size or refuses a run because of it" | true | No genome-size field in `AssemblyRunRequest.swift` and no genome-size control in the sheet. The column heading "Practical size ceiling, not enforced by the app" applies DRIFT row 13. Flye's genome size exists only as a catalog description string (`AssemblyOptionCatalog.swift:253-259`), not a control. | |
| 15 | Table: SPAdes, MEGAHIT, SKESA accept Illumina short reads | true | `AssemblyCompatibility.swift:16-18` returns `[.spades, .megahit, .skesa]` for `.illuminaShortReads`. | |
| 16 | Table: "Flye \| Oxford Nanopore reads" | true | `AssemblyCompatibility.swift:19-20` returns `[.flye, .hifiasm]` for `.ontReads`, and `:21-22` returns `[.hifiasm]` alone for `.pacBioHiFi`, so Flye is offered for ONT only. | |
| 17 | Table: "Hifiasm \| Oxford Nanopore or PacBio HiFi reads" | true | `AssemblyCompatibility.swift:19-22` lists hifiasm under both classes. `ManagedAssemblyPipeline.swift:314-316` adds `--ont` when the read type is ONT. | |
| 18 | "It reads the first header line of your FASTQ, works out which class of instrument produced the reads, and narrows the Assembler picker to the tools that accept that class" | true | `AssemblyReadType.swift:57-89, 134-146` sniffs the first header. `AssemblyWizardSheet.swift:242-249` returns `AssemblyCompatibility.supportedTools(for:)` once a read class resolves, and all five only when it does not. | |
| 19 | "Select Illumina reads and the picker offers SPAdes, MEGAHIT, and SKESA. Select Oxford Nanopore reads and it offers Flye and Hifiasm. Select PacBio HiFi reads and it offers Hifiasm alone." | true | `AssemblyCompatibility.swift:16-22`, all three branches. | |
| 20 | "Beneath the Assembler picker sits a Read Type row" | true | `AssemblyWizardSheet.swift:496-524`, the Assembler `labeledRow` precedes the Read Type `labeledRow` inside `primarySettingsSection`. | |
| 21 | "the row is a plain label reading the detected class with the note "Locked from FASTQ header detection." underneath, and you cannot change it" | true | `AssemblyWizardSheet.swift:507-514`. When `readTypeIsLockedToDetection`, the row renders `Text(effectiveReadType.displayName)` above `Text("Locked from FASTQ header detection.")` in caption style. The quoted string matches verbatim, period included. | |
| 22 | "When detection came back inconclusive ... the row becomes an editable picker offering all three classes" | true | `AssemblyWizardSheet.swift:515-522`, the else branch is a segmented `Picker` over `AssemblyReadType.allCases`, which has exactly three cases. | |
| 23 | "Hybrid assembly is not supported in v1. Select one read class per run." | true | `AssemblyCompatibility.swift:9-11`, `hybridAssemblyUnsupportedMessage`, verbatim. Returned by `evaluate` whenever more than one read class is detected (`:41-49`). | |
| 24 | "Selected FASTQ inputs mix detected and unclassified read classes. Select one read class per run." | true | `AssemblyWizardSheet.swift:56-57`, `mixedDetectedAndUnclassifiedInputsMessage`, verbatim. Surfaced at `:254-256`. | |
| 25 | "For SPAdes, MEGAHIT, and SKESA a run mode picker appears, and it is currently locked to running each bundle as its own separate assembly" | true | `AssemblyWizardSheet.swift:167-172`, `multiBundleRunPolicy` with `allowedModes: [.perBundle]`, `defaultMode: .perBundle`, and the lock reason "Combining multiple bundles into one assembly run is not yet supported; each bundle assembles separately." `:184-186` shows the picker only for `shortReadTools` with `bundleCount > 1`, and `:188` defines that set as spades, megahit, skesa. | |
| 26 | "Flye and Hifiasm reject a multi-file selection before you get that far, with a message that long-read assembly expects a single FASTQ input in this version" | true | `AssemblyWizardSheet.swift:261-270`, `readTopologyMessage` returns "\(effectiveReadType.displayName) assembly expects a single FASTQ input in v1." for `.ontReads` and `.pacBioHiFi` whenever `inputFiles.count != 1`, and it feeds the blocking message at `:274-280`. The chapter paraphrases rather than quotes, which is correct, since the literal string is prefixed by the read-class display name and so has no single fixed form. | |
| 27 | "the HG002 mitochondrial reads ... thinned to about 300-fold coverage, giving 9,958 paired-end read pairs" | true | `fixtures/human-mito/README.md:89-91`, 9,958 read pairs, about 300x of the 16,569 bp genome, downsampled with `samtools view -b -s 42.0077`. | |
| 28 | "The human mitochondrial genome is 16,569 bases and circular, and it is published as `NC_012920.1`" | true | `fixtures/human-mito/NC_012920.1.fasta.fai` gives length 16569. README:11 names `NC_012920.1`, Homo sapiens mitochondrion, complete genome, 16,569 bp. | |
| 29 | "SPAdes returned one contig of 16,697 bases, with an N50 of 16,697, an L50 of 1, and 44.4% GC content, in 13.7 seconds" | true | `fixtures/human-mito/expected/spades/assembly-result.json`: contigCount 1, totalLengthBP 16697, n50 16697, l50 1, gcFraction 0.4444510989998203, wallTimeSeconds 13.719936966896057, outcome completed, assemblerVersion 4.3.0. Header `>NODE_1_length_16697_cov_121.957333`. | |
| 30 | "SKESA returned one contig of 16,570 bases, the same N50 and L50, the same 44.4% GC, in 1.6 seconds" | true | Author's run artefact `scratchpad/assembly-concept/skesa/assembly-result.json`: contigCount 1, totalLengthBP 16570, n50 16570, l50 1, gcFraction 0.444055522027761, wallTimeSeconds 1.5956580638885498, outcome completed, assemblerVersion 2.5.1. The `contigs.fasta.fai` independently gives length 16570. | |
| 31 | "the 127-base difference between them" and "SKESA's contig is 16,570 bases against a 16,569-base reference, one base over" and "SPAdes overshot by 128 bases, about 0.8%" | true | Arithmetic on the two verified figures. 16697 minus 16570 is 127. 16570 minus 16569 is 1. 16697 minus 16569 is 128, and 128/16569 is 0.77%, which "about 0.8%" states correctly. README:97 records the same 128 bp / 0.8% figure independently. | |
| 32 | "SKESA labels its contig `[topology=circular]` in the FASTA header" | true | Author's `scratchpad/assembly-concept/skesa/contigs.fasta` first line is `>Contig_1_257.173_Circ [topology=circular]`. | |
| 33 | "A circular genome has no beginning, so an assembler walking a circular graph has to cut it somewhere ... and the sequence either side of that cut is easy to emit twice" | true | Tool-domain explanation, not an app claim. It is the standard account of a circular-overlap artefact and is consistent with the two observed lengths and with the SKESA header's own `Circ` marker. | |
| 34 | "MEGAHIT 1.2.9 currently fails partway through on Apple Silicon, aborting at one of its later graph-building steps even on this small dataset" | true | Author's `scratchpad/assembly-concept/megahit/log:694` records `megahit_core_no_hw_accel assemble ... -t 2 ...; Exit code -6` under "Assemble contigs from SdBG for k = 99", immediately after "Tips removal done". The run directory holds no `contigs.fasta` and no `assembly-result.json`, while the SKESA directory holds both. Exit -6 is SIGABRT. | |
| 35 | "LGE already applies the two published workarounds for this build, capping it to two threads and disabling its hardware acceleration, and the failure still occurs" | true | `AssemblyRunRequest.swift:99-104` caps MEGAHIT to `min(requestedThreads, 2)` on a host with `capsMegahitThreads`, with the comment "MEGAHIT 1.2.9 arm64 crashes reliably above two threads on Apple Silicon". `ManagedAssemblyPipeline.swift:234-237` appends `--no-hw-accel`. Both are visible in the failing log, which shows `-t 2` and the `megahit_core_no_hw_accel` binary. | |
| 36 | "If a MEGAHIT run stops with a nonzero exit code, that is the known fault and not something you have done wrong" | true | The app does surface it rather than swallowing it. `ManagedAssemblyPipeline.swift:134-143` throws `executionFailed(tool:exitCode:detail:)` on any nonzero exit, rendered at `:45-46` as "\(tool) failed (exit \(exitCode)): \(detail)". The author's CLI run reported "MEGAHIT failed (exit 250)". | |
| 37 | "N50 is the length of the contig you are standing on when the running total first reaches half the assembly's total length ... That is exactly how LGE computes it." | true | `AssemblyStatistics.swift:170-177` sorts descending (`lengths.sorted(by: >)`) and calls `computeNx(sorted:total:x:50)`, which at `:180-190` accumulates and returns `length` at the first index where `cumulative >= threshold`. `SequenceLengthStatistics.threshold` computes the 50 percent mark. The chapter's description matches the implementation step for step. | |
| 38 | "contigs of at least N50 bases together hold half of everything you assembled" | true | Follows from the descending walk in `computeNx`, and matches the field doc at `AssemblyStatistics.swift:24-25`, "length such that contigs of this length or longer cover >= 50% of total". | |
| 39 | "**L50** is a count ... the number of contigs you had to walk through to reach that halfway point" | true | `AssemblyStatistics.swift:186` returns `index + 1` at the same stopping point, and the field doc at `:26-27` reads "minimum number of contigs whose lengths sum to >= 50% of total". | |
| 40 | "On the mitochondrial fixture above, N50 is the full 16,697 bases because the single contig is the whole assembly" | true | The SPAdes result JSON gives n50 16697 with contigCount 1. | |
| 41 | "The folder is named for the tool and the moment the run started, for example `spades-2026-09-07T05-14-22`, and a run across several bundles at once uses `spades-batch-` followed by the same timestamp" | true | `AnalysesFolder.swift:121-122` documents `Analyses/{tool}-{yyyy-MM-dd'T'HH-mm-ss}/` and `Analyses/{tool}-batch-{yyyy-MM-dd'T'HH-mm-ss}/`, and `:139-141` builds `baseName` as `isBatch ? "\(tool)-batch-\(timestamp)" : "\(tool)-\(timestamp)"`. The tool segment is `AssemblyTool.rawValue` (`MainSplitViewController+GenomicsDisplay.swift:1217`), so `spades`. The example string matches the format exactly. | |
| 42 | "with the individual assemblies inside it" (batch) | true | `MainSplitViewController+GenomicsDisplay.swift:1201-1214` reuses one shared `precomputedAssemblyBatchSampleDirectory` under a single `Analyses/<tool>-batch-<timestamp>/` root for every child of a batch, with the comment saying that is what groups a batch's children together. | |
| 43 | "There is no `Assemblies/` folder in an LGE project." | true | A grep for `Assemblies` across `Sources/` returns exactly one hit, a doc comment at `AssemblyConfigurationViewController.swift:47`, and no path construction. Matches the CONSISTENCY ruling at line 80. | |
| 44 | "A summary strip along the top carries ... the assembler, the read type, the contig count, total bp, N50, L50, the longest contig, and the global GC percent, plus the tool version and the wall time when the run recorded them" | true | `AssemblySummaryStrip.swift:321-341`. The eight unconditional fields are Assembler, Read Type, Contigs, Total bp, N50, L50, Longest, Global GC, in that order. Version is appended only when non-empty and Wall Time only when `wallTimeSeconds > 0`, which the chapter's "when the run recorded them" states correctly. | |
| 45 | "A table below it lists the contigs one per row, ranked longest first, with columns for rank, contig name, length in bases, GC percent, share of the assembly as a percentage, and a preview of the sequence" | true | `AssemblyContigTableView.swift:18-47`, `columnSpecs` are `#`, `Contig`, `Length (bp)`, `GC %`, `Share of Assembly (%)`, `Sequence Preview`, in that order. | |
| 46 | "Selecting a row fills a detail pane beside the table with that contig's header, its length, its GC, its rank, its share, and its full sequence" | true | `AssemblyContigDetailPane.swift:11-18` per the reality map's recurring finding 3, and `AssemblyResultViewController.swift:144, 176-177` routes selection to the detail pane rather than the Inspector. | |
| 47 | "The bundle's FASTA holds the contigs in whatever order the assembler emitted them, and while SPAdes and MEGAHIT happen to write theirs longest first, Flye and hifiasm make no such promise. The table sorts by length regardless" | true | `AssemblyBundleBuilder.swift:114-120` bgzips and indexes the assembler's own FASTA without reordering. The table's rank column is the default sort (`AssemblyContigTableView.swift:20`). This applies DRIFT row 20 as written. | |
| 48 | "A scaffold file also lands in the run folder for the assemblers that produce one ... LGE builds the bundle from the contigs rather than the scaffolds" | true | `AssemblyOutputNormalizer.swift` records `scaffoldsPath` separately from `contigsPath`, and the SPAdes result JSON carries `"scaffoldsPath": "scaffolds.fasta"` alongside `"contigsPath": "contigs.fasta"`. The file exists in the fixture at `expected/spades/scaffolds.fasta` (17 KB). The bundle is built from `contigsPath`. Matches the glossary Scaffold entry (`GLOSSARY.md:549`). | |
| 49 | "Selecting contigs and using **Create Bundle** in the action bar beneath the table derives a reference bundle from them" | true | `AssemblyActionBar.swift:13` declares `bundleButton` titled "Create Bundle"; `AssemblyResultViewController.swift:214` places the bar at the bottom and `:411-433` derives the bundle. | |
| 50 | "The same action bar carries **BLAST Contigs** for identifying what assembled, along with **Copy FASTA** and **Export FASTA**" | true | `AssemblyActionBar.swift:10-13`, buttons titled "BLAST Contigs", "Copy FASTA", "Export FASTA", "Create Bundle". | |
| 51 | "a mapping target for a fresh run of minimap2, BWA-MEM2, Bowtie2, or BBMap under **Tools > Mapping**" | true | `FASTQOperationDialogState.swift:1278-1279` returns `[.minimap2, .bwaMem2, .bowtie2, .bbmap, .viralRecon]` for `.mapping`. The chapter names four of the five and omits Viral Recon, which is a pipeline rather than a bare aligner. Not an error, though see Notes. | |
| 52 | "Right-clicking an assembly bundle in the sidebar offers **Reassemble...**, ... and it appears only on bundles that carry a record of the assembly that produced them" | true | `SidebarViewController+MenuDelegate.swift:207-212`, the item titled "Reassemble…" is added only when `bundleHasAssemblyProvenance(url)`. | |
| 53 | "an assembler can finish cleanly while producing nothing at all, which LGE records as a distinct outcome rather than as either success or failure" | true | `AssemblyResult.swift:10` declares `completedWithNoContigs` as a case beside `completed`. `AssemblyOutputNormalizer.swift:64-71` sets it when `statistics.contigCount == 0` after a clean exit, synthesizing an empty FASTA so the outcome round-trips. Handled in the viewport (`AssemblyResultViewController.swift:457`) and the CLI (`AssembleCommand.swift:313`). | |
| 54 | "A run that finished with no contigs at all is reported as such" | true | Same evidence as claim 53. | |
| 55 | "The summary strip names the assembler and its version" | true | `AssemblySummaryStrip.swift:323, 339-341`. Version is conditional on the run having recorded one, which claim 44 already hedges. | |
| 56 | "The comparison below uses the HG002 mitochondrial reads, a fixture this manual ships ... Both runs below were made for this chapter on 2026-09-06 and 2026-09-07" | true | The SPAdes run is the fixture's committed run, README-dated 2026-09-06. The SKESA run artefacts are dated 2026-09-07 in the author's scratch directory. Both dates are accurate for their respective runs. | |
| 57 | "a per-base error rate of a few percent" for ONT and "well under one percent error" for PacBio HiFi | true | Domain background about the instruments, not an app claim. Consistent with the read classes LGE models (`AssemblyReadType.swift`). | |
| 58 | "somewhere above roughly 95% identity across most of the reference's length" as the point where a reference fits | unverifiable | No app behaviour corresponds to this. Nothing in `Sources/` computes or checks an identity threshold before offering assembly, and the chapter does not claim it does. It is domain guidance, and the chapter's hedges ("in practice", "roughly") are the right shape for it. What would settle it is a citation, which a concept chapter is not obliged to carry. | |
| 59 | "MEGAHIT ... uses less memory on such samples than SPAdes does" | unverifiable | Tool-domain comparison with no measurement in this campaign and no app claim behind it. The author's MEGAHIT run aborted before finishing, so no memory figure from this fixture supports or refutes it. It is standard published guidance about MEGAHIT and is stated as such. Settled by a benchmark on a metagenome, which is out of scope here. | |
| 60 | "SKESA is NCBI's isolate assembler" | true | `third-party-tools-lock.json` gives SKESA's `sourceUrl` as `https://github.com/ncbi/SKESA` and its license as Public Domain, consistent with NCBI authorship. | |

## Front matter

Correct, with one defect.

- `title`, `chapter_id`, `audience`, `estimated_reading_min`, `task`,
  `tags`, `tools`, `parameters_refs`, `entry_points`, `shots`,
  `illustrations`, `glossary_refs`, `features_refs`, `fixtures_refs`,
  `brand_reviewed`, `lead_approved` are all present.
- `parameters_refs: []` and `features_refs: []` are correct. The roster
  row carries no registry ids, and the chapter documents no operation, so
  there is nothing to cite and no Settings entries are owed.
- `tools: []` is correct for a chapter that opens no dialog.
- `fixtures_refs: [human-mito]` matches the fixture the chapter uses.
- `entry_points` matches `MainMenu.swift:786-819` exactly, five paths,
  one per assembler. This applies DRIFT row 1.
- `brand_reviewed: false` and `lead_approved: false` are correct at this
  stage.
- `estimated_reading_min: 14` is plausible for roughly 2,900 words and is
  not a factual claim about the app.

**Defect.** `glossary_refs` lists `read-length`, but the body never links
`(../../GLOSSARY.md#read-length)`. Every other one of the sixteen listed
anchors is linked exactly once. Either drop `read-length` from
`glossary_refs` or link it, most naturally at "Illumina reads are short,
tens to a few hundred bases" in "Working out which assembler you want".
All sixteen anchors do resolve against `GLOSSARY.md`, so this is a
manifest-versus-body mismatch rather than a broken link.

### Glossary entries

The five new entries exist, are in the right alphabetical slots, and
agree with the chapter.

- **Assembly graph** (`GLOSSARY.md:41`), after Assembly bundle.
- **De novo assembly** (`:153`), in section D.
- **L50** (`:303`), in section L.
- **Scaffold** (`:549`), in section S. Its second sentence independently
  states the chapter's claim that LGE builds the bundle from the contigs
  rather than the scaffolds.
- **Structural variation** (`:599`), in section S.

All five carry the "See also:" tail the house shape requires. N50
(`:379`) already existed and is consistent with the chapter's longer
treatment.

### Shot captions

All three describe things that exist in source. None is capturable from
this review, and all three need the Screenshot Scout.

- `assembly-submenu`. Accurate. `MainMenu.swift:786-819` builds exactly
  five items in the Assembly submenu, titled with a trailing ellipsis,
  which the caption reproduces.
- `assembly-sheet-assembler-picker`. Accurate and correctly scoped. The
  caption says the Read Type row "reads Illumina short reads with the
  note Locked from FASTQ header detection. beneath it", which matches
  `AssemblyWizardSheet.swift:507-514` and the display name
  `AssemblyReadType.illuminaShortReads`. Note for the Scout: the picker
  will show three segments, not five, for a detected Illumina bundle
  (`:242-249`), which is what the reality map asked the recaption to
  make unambiguous. The caption does not claim five, so it is correct,
  but the capture must not be taken from an unclassified selection.
- `assembly-bundle-in-analyses`. Accurate against source. It is the one
  shot that cannot be confirmed without a GUI run, since no
  `Analyses/<tool>-<timestamp>/` assembly folder exists on disk in the
  demo project. The author flags this and it should stay flagged.

## Consistency

Consistent with `CONSISTENCY.md` on every point that document rules on.

- **Analyses folder ruling** (`CONSISTENCY.md:52-58`). The chapter puts
  assembly output at `Analyses/<tool>-<timestamp>/`, which is the named
  tool shape the ruling prescribes, and names the batch variant.
- **The `Assemblies/` correction** (`CONSISTENCY.md:80`). The chapter
  states outright that there is no `Assemblies/` folder, in the same
  section where a reader would look for it. This is the strongest
  possible application of that ruling and it closes the recurring drift.
- **Fixture naming** (`CONSISTENCY.md:124-125`). The chapter says "the
  HG002 mitochondrial reads", the prescribed name, at first mention.
- **Bundle extensions in code font** (`CONSISTENCY.md:80-82`).
  `.lungfishref` is code-formatted at every occurrence.
- **Product naming.** "Lungfish Genome Explorer (LGE)" at first mention
  in "What it is", "LGE" thereafter. No bare "Lungfish" is used for the
  application.
- **Prose rules.** No em dashes, no semicolons, no in-sentence colons. No
  list exceeds five bullets and no H2 section carries more than two
  lists. Verified by
  `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`,
  which exits 0 with "no issues found".
- **Examples.** Human throughout. The worked comparison is HG002
  mitochondrial data and the decision example is a clinical bacterial
  isolate. No viral example is used where a human one would serve, which
  matches the campaign preference.

### Section order

Correct for a concept chapter. The order is What it is, Why you would do
this, What LGE ships and what it does not, How the sheet decides what you
may run, Working out which assembler you want, Two assemblers on the same
human reads, What the numbers mean, Where the result lands, What good
looks like, Next.

This tracks the committed concept-chapter precedent
`06-classification/01-what-is-classification.md`, whose H2 sequence is
What it is, Why you would do this, What LGE runs and what it only
imports, Picking a classifier for your sample, Where the classifiers
live, What you will see in the results, Databases and why you install one
first, What good looks like, Next. Both open with the two fixed template
sections, carry a middle of chapter-specific sections, and close with
What good looks like then Next.

The four dropped template sections are dropped correctly. Before you
start and Procedure presuppose a dialog this chapter never opens.
Settings presupposes registry ids the roster row does not give it. The
CLI appendix attaches to chapters that walk a GUI procedure, per the
editorial rule, and this chapter walks none. `ARCHITECTURE.md:349-352`
describes row 46 as "the assembly question; reference-based vs de novo;
the Lungfish assembly wizard; tool comparison table", which is a concept
brief and not a procedure brief, so the shape is what the architecture
asked for.

## App defects

Two, one of them serious. Both were confirmed independently of the
author's report.

1. **MEGAHIT 1.2.9 cannot complete a run on Apple Silicon.**
   `megahit_core_no_hw_accel assemble` exits `-6` (SIGABRT) at k=99,
   immediately after tip removal, on a 19,915-read, 16.5 kb-target
   dataset. Confirmed at `scratchpad/assembly-concept/megahit/log:694`,
   with the failing command line recorded in full. Both shipped
   workarounds were active in that run, the two-thread cap
   (`AssemblyRunRequest.swift:99-104`) visible as `-t 2` in the failing
   command, and `--no-hw-accel`
   (`ManagedAssemblyPipeline.swift:234-237`) visible in the binary name.
   The run directory holds `log`, `options.json`, `checkpoints.txt`,
   `tmp/`, and `intermediate_contigs/`, but no `contigs.fasta` and no
   `assembly-result.json`, while the SKESA run in the same session
   produced both. The input is small and the machine reported 30 GB free
   to SKESA in the same session, so this is not a resource ceiling. As
   shipped, the MEGAHIT item in the Assembly submenu is non-functional on
   this hardware. The failure is surfaced honestly rather than hidden
   (`ManagedAssemblyPipeline.swift:134-143` throws with the exit code),
   so this is a tool defect and not a reporting defect, but it needs an
   engineering decision, because chapter 02 documents MEGAHIT as a
   runnable option and the Readiness panel will report the tool as
   present.

2. **`AssemblyTool.analysisDirectoryPrefix` is dead code with a
   misleading doc comment.** `AssemblyTool.swift:37-40` returns
   `"assembly-\(rawValue)"` under the comment "Stable analysis-directory
   prefix for normalized output bundles". A grep across both `Sources/`
   and `Tests/` finds the definition and no caller of any kind. The real
   directory name uses the bare `rawValue`
   (`MainSplitViewController+GenomicsDisplay.swift:1217`), giving
   `spades-<timestamp>`, not `assembly-spades-<timestamp>`. Anyone
   trusting the comment would document a folder name the app never
   writes. Given that the campaign has repeatedly had to correct an
   invented `Assemblies/` folder, a property whose value literally begins
   `assembly-` is a plausible origin for that confusion. Either delete it
   or wire it up, but do not leave it asserting a convention nothing
   follows.

A third item, the inert Min Contig stepper for SPAdes, belongs to
chapter 02 and is recorded in that chapter's DRIFT row 11
(`AssemblyOptionCatalog.swift:128` advertises a "Lungfish post-filter"
that `ManagedAssemblyPipeline.swift:176-206` never implements). This
chapter documents no settings and correctly says nothing about it. Noted
here only so the two records agree.

## Notes for the editor

1. **Fix `glossary_refs`.** `read-length` is declared and never linked.
   This is the only front-matter error in the chapter. See Front matter.

2. **The Mapping list omits Viral Recon.** The chapter names minimap2,
   BWA-MEM2, Bowtie2, and BBMap as the mapping tools an assembly can feed
   into. `FASTQOperationDialogState.swift:1278-1279` also lists Viral
   Recon in that submenu. The omission is defensible, since Viral Recon
   is a SARS-CoV-2 pipeline rather than a general aligner and would not
   accept an arbitrary assembly as a target, and DRIFT row 23's corrected
   wording names the same four. No change needed. Flagged only so a later
   reviewer does not read it as a miss.

3. **The long-read rejection message is paraphrased, not quoted, and
   should stay that way.** Unlike the two hybrid messages, which are
   fixed strings the chapter quotes verbatim and correctly, the
   single-input message is built as
   `"\(effectiveReadType.displayName) assembly expects a single FASTQ
   input in v1."`, so its literal text varies with the read class. If a
   later pass is tempted to quote it, it must quote a specific class's
   form.

4. **"v1" appears in two quoted strings the chapter reproduces
   verbatim.** The chapter's own prose says "this version" rather than
   "v1", which is right, and the quoted messages keep the app's wording,
   which is also right. Do not harmonise the quotes to the prose.

5. **The 950 MB figure is an estimate, and the chapter's "roughly" is
   load-bearing.** `PluginPack.swift:718` is `estimatedSizeMB: 950`, a
   manifest value rather than a measured install. If a later pass tightens
   the sentence, keep the hedge.

6. **Three shots and the batch-folder claim need a GUI run.** Claim 41's
   batch-folder shape and claim 42 are traced through source and are
   sound, but no `Analyses/<tool>-batch-<timestamp>/` directory was
   observed on disk. The `assembly-bundle-in-analyses` capture will
   settle the single-run half of it. A batch capture is not required by
   the chapter, which states the shape without showing it.

7. **Nothing in the chapter needs a factual correction.** Every claim
   that touches the app is true against source, CLI help, or the
   fixture's committed outputs. The two unverifiable claims are both
   domain guidance that the chapter already hedges, and neither asserts
   app behaviour.

## Counts

60 claims assessed. 58 true, 0 false, 2 unverifiable.

Front matter: 1 defect (`read-length` declared in `glossary_refs` and
never linked). Glossary: 5 new entries, all present and consistent, 16 of
16 anchors resolve. Shots: 3 declared, 3 accurate against source, 3
awaiting capture. Consistency: no violations. Lint: exit 0.
App defects: 2 (1 new to this chapter's review, 1 confirming the
author's).
