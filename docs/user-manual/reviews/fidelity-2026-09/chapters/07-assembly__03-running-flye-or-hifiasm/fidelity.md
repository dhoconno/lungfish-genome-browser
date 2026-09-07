# Fidelity review: 07-assembly/03-running-flye-or-hifiasm

Reviewer pass on 2026-09-07 against the campaign worktree, the Swift
source, `docs/user-manual/parameters.yaml`, the CLI help dumps, the
fixture README and its committed expected outputs, and three fresh runs
of my own (two Flye, one hifiasm) through
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.

Scratch outputs for this pass are under
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/assembly-long/review/`
(`flyeA`, `flyeB`, `hifiC`, `multitest`). The two fixture read files were
copied there first and the ONT file's md5 checked against the committed
original (`751d2bb30e1040b787d95a9ac588da9d`, matching the author's
record), so every run below is against byte-identical input.

## Reruns performed

| Run | Command | Result |
|---|---|---|
| flyeA | `assemble --assembler flye --read-type ont-reads` on the ONT fixture | 1 contig, **16,359 bp**, N50 16,359, L50 1, 43.9% GC, 35.66 s, `contig_1 16359 256 Y N 3 * 1` |
| flyeB | identical command, different output dir and project name | 1 contig, **16,359 bp**, N50 16,359, L50 1, 43.9% GC, 35.6 s, `contig_1 16359 256 Y N 3 * 1` |
| hifiC | `assemble --assembler hifiasm --read-type pacbio-hifi` on the HiFi fixture | 1 contig, **33,140 bp**, N50 33,140, L50 1, 44.4% GC, 6.0 s, header `ptg000001c` |

Both of my Flye runs returned the unit-length 16,359 bp answer, with
identical coverage (256), circularity (`Y`), and multiplicity (3). I did
not reproduce the 32,652 bp doubled outcome the author recorded. Two
runs are not enough to disprove nondeterminism, and the author's run 1
is a recorded observation from the same binary on the same bytes, so the
phenomenon stands as reported. What my reruns establish is that the
16,359 bp outcome is the common one, that it matches both the fixture
README and the committed `expected/flye/assembly.fasta` (measured at
16,359 bases, `assembly_info.txt` identical to mine), and that the
doubled outcome is the rarer branch rather than a coin flip. The
chapter's wording, which documents both outcomes and teaches the
size check rather than promising a length, survives this unchanged.

Hifiasm reproduced exactly, including the committed
`expected/hifiasm/contigs.fasta` at 33,140 bases under the same
`>ptg000001c` header.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "Flye and hifiasm are the two long-read assemblers that Lungfish Genome Explorer (LGE) ships." | true | `AssemblyCompatibility.swift:14-23` returns `[.flye, .hifiasm]` for `ontReads` and `[.hifiasm]` for `pacBioHiFi`. | |
| "Hifiasm also accepts Nanopore reads, and LGE adds the flag that tells it so." | true | `ManagedAssemblyPipeline.swift:314-316` inserts `--ont` at index 0 when `request.readType == .ontReads`. | |
| "Each run produces a `.lungfishref` assembly bundle inside a per-run folder under the project's `Analyses` folder, holding a contigs FASTA and its index" | true | `AnalysesFolder.swift:118-140`; `AssemblyOutputNormalizer.swift:62-68` writes the FASTA index only when contigs survive. Matches DRIFT row 3 and chapter 01 line 144. | |
| "There is no `Assemblies` folder." | true | No `Assemblies` path anywhere in `Sources/`. Chapter 01 line 144 and chapter 02 line 101 say the same. | |
| "Nanopore reads give you a choice between Flye and hifiasm, HiFi reads give you hifiasm alone, and Illumina reads give you neither." | true | `AssemblyCompatibility.swift:14-23`. | |
| Fixture: reference `NC_012920.1`, 16,569 bp, circular | true | Fixture README, Genome section. | |
| Fixture: "roughly 300-fold coverage" | true | README Downsampling table gives 262x ONT and 301x HiFi, and `fetch.sh` targets approximately 300x for both. | |
| Fixture: "`HG002.chrM.ont.fastq.gz`, holding 950 Nanopore reads, and `HG002.chrM.hifi.fastq.gz`, holding 363 HiFi reads" | true | README Downsampling table, `seqkit stats -a` row per file. | |
| "HG002, also catalogued as NA24385, is the son in the Ashkenazim trio" | true | README Sources section. | |
| "Both assemblers finish in under a minute" | true | My runs: 35.6 s and 6.0 s. | |
| "Open **Tools > Plugin Manager...** (Cmd-Shift-B)" | true | Matches chapter 01 line 70 and chapter 02 line 61, both lint-green siblings. | |
| "The pack holds all five assemblers together" | true | `PluginPack.swift:669-676`, `packages: ["spades", "megahit", "skesa", "flye", "hifiasm"]`, display name "Genome Assembly". | |
| "Flye 2.9.6 and hifiasm 0.25.0" | true | `third-party-tools-lock.json:45-46`. My runs reported `assemblerVersion` 2.9.6 and 0.25.0 respectively. | |
| "Assembly is a submenu holding one item per assembler, so SPAdes, MEGAHIT, SKESA, Flye, and Hifiasm are five separate menu items that all open the same sheet." | true | `ToolsMenuModel.swift:71`; `AssemblyWizardSheet.swift` is one sheet for all five. Matches chapter 01's `assembly-submenu` shot caption and chapter 02 line 73. | |
| "The sheet has no input picker of its own, so whatever is selected when you open the menu is what gets assembled." | true | `AssemblyWizardSheet.swift:474-490` renders Dataset, Read Layout, and Detected as read-only `Text`, with no file picker anywhere in the sheet. | |
| Inputs section rows named Dataset, Read Layout, Detected | true | `AssemblyWizardSheet.swift:474-490`, `labeledRow("Dataset")`, `labeledRow("Read Layout")`, `labeledRow("Detected")`. | |
| "which should read ONT reads" | true | `AssemblyReadType.swift:16-21`, `displayName` for `.ontReads` is exactly "ONT reads". | |
| "Detection works by reading the first FASTQ header in the file and recognising the shape the instrument writes, falling back to whatever the bundle recorded at import when the header gives nothing away." | true | `AssemblyReadType.swift:54-60` (`detect(fromFASTQ:)` reads one header) and `:35-52` (the platform fallbacks). | |
| "It offers Flye and Hifiasm and nothing else, because those are the two assemblers that accept Nanopore reads." | true | `AssemblyCompatibility.swift:18-19`; the picker iterates `availableTools`. | |
| Read Type "is a plain label reading ONT reads with the note \"Locked from FASTQ header detection.\" underneath" | true | `AssemblyWizardSheet.swift:507-524`, verbatim string including the trailing period. | |
| "Leave the **Profile** picker on **Nano HQ**, its default" | true | `AssemblyWizardSheet.swift:892-897` titles, `:944` `defaultProfileID` returns `nano-hq` for `.flye`. | |
| "the Assembler picker" (Flye run) shows Hifiasm alone for a HiFi bundle | true | `AssemblyCompatibility.swift:21-22`. | |
| "Leave the **Profile** picker on **Diploid**, its default." | true | `AssemblyWizardSheet.swift:898-902`, `:946-947`. | |
| "**Project Name** ... defaults to the input file's name with `_assembly` appended" | true | `AssemblyWizardSheet.swift:326-337`, stem with `_R1`/`_R2`/`_1`/`_2`/`.lungfishfastq` stripped, then `+ "_assembly"`. | |
| "and at the **Output Folder** line beneath it" | true | `AssemblyWizardSheet.swift:635-641`. | |
| "**Operations > Show Operations Panel** (Cmd-Shift-P)" | true | Matches the campaign's settled wording in the sibling chapters. | |
| "The panel streams Flye's own output as it works, so what you read there is Flye's wording rather than anything LGE composed." | true | DRIFT row 20's correction, applied. Nothing in `ManagedAssemblyPipeline.swift` parses or renames Flye's stages. | |
| "The whole text is also saved as `assembly.log` in the run folder." | true | `AssemblyOutputNormalizer.swift:71` sets `logPath` to `assembly.log`. My `flyeA/assembly.log` exists. | |
| "The reference run finished in 35.2 seconds." | true | Author run 3. My reruns gave 35.66 s and 35.6 s, consistent, and the chapter attributes the figure to the reference run rather than promising it. | |
| "The reference run finished in 5.9 seconds." | true | Author run 2 (5.857 s). My rerun gave 6.0 s. | |
| "Hifiasm does not write a FASTA. It writes its assembly as a GFA file ... LGE reads the primary contig graph out of that file and converts it into `contigs.fasta`" | true | `AssemblyOutputNormalizer.swift:44-52`, converting `<projectName>.bp.p_ctg.gfa` via `GFASegmentFASTAWriter.writePrimaryContigs` only when no FASTA exists. My `hifiC/` listing has no hifiasm-written FASTA and does hold `contigs.fasta`. | |
| "each in its own folder named for the tool and the moment it started, such as `flye-2026-09-07T05-12-23`" | true | `AnalysesFolder.swift:118-140`, `Analyses/{tool}-{yyyy-MM-dd'T'HH-mm-ss}/`. Not observed in a GUI run, but the format string is exact and chapter 01 line 144 and chapter 02 line 101 use the same shape. | |
| "A second run of the same reads therefore never overwrites the first." | true | `AnalysesFolder.swift:140-145` appends `-2`, `-3` on a timestamp collision. | |
| "right-click the bundle in the sidebar and choose **Reassemble...** ... That item appears only on a bundle that carries assembly provenance" | true | `SidebarViewController+MenuDelegate.swift:207-209`, guarded on provenance, title `"Reassemble\u{2026}"`. | |
| "The sheet carries seven controls for each assembler." | true | The registry lists exactly seven settings for each of `assemble.flye` and `assemble.hifiasm`. Note the task brief's "sixteen registry settings" is fourteen (seven per tool, six labels shared). | |
| "Five sit in plain view under Primary Settings and Output, and two sit inside the Advanced Settings section." | true | Primary Settings holds Assembler, Read Type, Profile, Threads (`:494-549`); Output holds Project Name (`:628`). That is five. Advanced holds the tool toggle and Extra arguments (`:582-620`). That is two. | |
| "Memory Limit does not appear, because neither Flye nor hifiasm takes a memory budget, and Min Contig does not appear" | true | `AssemblyOptionCatalog.swift:110-131`, both `capabilityScopedControls` map only to `.spades`, `.megahit`, `.skesa`. The sheet gates on `supportsMemoryLimit`. | |
| **Assembler.** "lists only the assemblers that accept the read class LGE detected" and "defaults to whichever assembler you chose from the Tools menu" | true | `AssemblyCompatibility.swift:14-23`; registry default "Flye when the sheet is opened from the Flye menu item". CLI flag `--assembler` present in `cli-help/assemble.txt`. | |
| **Read Type.** "It unlocks into a three-way picker offering Illumina short reads, ONT reads, and PacBio HiFi/CCS only when detection came back inconclusive, which is what happens with a PacBio CLR library" | true | `AssemblyWizardSheet.swift:507-524` branches on `readTypeIsLockedToDetection`; `AssemblyReadType.swift:38-43, 48-53` return nil for `.pacbio`. Matches DRIFT row 7's correction. CLI flag `--read-type`. | |
| **Profile.** Flye's three profiles reach Flye as `--nano-hq`, `--nano-raw`, `--nano-corr` | true | `ManagedAssemblyPipeline.swift:285-287` emits `"--\(readMode)"` from `selectedProfileID ?? "nano-hq"`, and the ids are `nano-hq`, `nano-raw`, `nano-corr` (`AssemblyWizardSheet.swift:892-897`). My `flyeA` command line reads `flye --nano-hq ...`. | |
| **Profile.** Haploid/Viral "quietly also passes `--n-hap 1`, `-l0`, and `-f0`" | true | `ManagedAssemblyPipeline.swift:400-414`, each added only when absent from `extraArguments`. Matches DRIFT row 17 and the registry. | |
| **Threads.** "defaults to the smaller of your Mac's core count and 8, and the slider will not let you exceed the number of cores your Mac reports" | true | `AssemblyWizardSheet.swift:324` (`min(Double(availableCores), 8)`) and `:546` (`in: 1...Double(max(1, availableCores))`). | |
| **Metagenome mode.** "Turns on Flye's `--meta` flag ... It is off by default and belongs to Flye alone, and it lives inside the **Curated extra arguments** disclosure" | true | `AssemblyWizardSheet.swift:58` (`advancedDisclosureTitle = "Curated extra arguments"`), `:589-591` (the toggle under `case .flye`), `:918-921` (`curatedAdvancedArguments` appends `--meta`). Registry `cli_flag: null`. Matches DRIFT row 10. | |
| **Primary contigs only.** "Adds hifiasm's `--primary` flag ... belongs to hifiasm alone, and sits in the same Curated extra arguments disclosure ... the viewport lists the primary contigs either way" | true | `AssemblyWizardSheet.swift:592-594`, `:922-925`; `AssemblyOutputNormalizer.swift:44-52` reads the primary graph regardless. Matches DRIFT row 15. | |
| **Extra arguments.** "Passes text straight through to the assembler exactly as you typed it, without LGE checking it" and "anything you pass here which the Haploid/Viral profile would also have added wins" | true | `ManagedAssemblyPipeline.swift:292` and `:317` append `request.extraArguments`; `:400-414` skips a profile argument the user already supplied. CLI flag `--extra-args`. | |
| **Project Name.** "An empty name blocks Run" | true | `AssemblyWizardSheet.swift:294-300` feeds `projectName` into `AssemblyWizardRunPresentation`, which gates `canRun`. Registry says the same. | |
| **Project Name.** "for hifiasm alone this name also becomes the output prefix hifiasm writes every one of its files under" | true | `ManagedAssemblyPipeline.swift:311` builds `-o <outputDirectory>/<projectName>`. My `hifiC/` listing shows every hifiasm file prefixed `revC.`, matching the project name I passed. | |
| "The Advanced Settings section also prints four read-only descriptions ... For Flye these name ONT Read Mode, Genome Size, Overlap / Assembly Coverage, and Haplotype Controls, and for hifiasm they name Small-Genome Memory Tuning, Purge Duplication, Primary / Alternate Output, and Haplotype Assumption." | true | `AssemblyOptionCatalog.swift:245-304`, all eight titles verbatim and in that order. Rendered as `Text(option.title)` plus `Text(option.summary)` with no control (`AssemblyWizardSheet.swift:599-607`). | |
| "`--output` writes the run somewhere other than the project's `Analyses` folder, and accepts `-o` and `--output-dir` as aliases." | true | `cli-help/assemble.txt`, `-o, --output, --output-dir <output>`. | |
| "`--memory-gb` is accepted by the command and then ignored for both of these tools" | true | Help text says "when the selected assembler supports it"; `AssemblyOptionCatalog.swift:110-121` maps memory only to spades, megahit, skesa. Neither `buildFlyeCommand` (`:280-298`) nor `buildHifiasmCommand` (`:300-325`) reads a memory field. Not exercised by a run, but the source is unambiguous. | |
| "`--min-contig-length` is likewise accepted and ignored for both" | true | Same, `AssemblyOptionCatalog.swift:122-131`, and neither command builder filters by length. | |
| "`--extra-arg` adds one argument at a time and may be repeated" | true | `cli-help/assemble.txt` marks it repeatable. | |
| "`--format` prints the run summary as `text`, `json`, or `tsv` instead of the default text." | true | `cli-help/assemble.txt`, `(values: text, json, tsv; default: text)`. | |
| Summary strip "reports the assembler, the read type, the contig count, the total assembled length in base pairs, N50, L50, the longest contig, and the whole-assembly GC content as a percentage. It adds the resolved tool version and the wall time when the run recorded them" | true | `AssemblySummaryStrip.swift:321-341`, exactly those eight fields in that order, then Version when non-empty and Wall Time when greater than zero. | |
| "The contig table below carries six columns, holding each contig's rank, its name, its length in base pairs, its GC percent, its share of the whole assembly as a percentage, and a preview of its opening sequence." | true | `AssemblyContigTableView.swift:19-47`, `#`, `Contig`, `Length (bp)`, `GC %`, `Share of Assembly (%)`, `Sequence Preview`. | |
| "There is no per-contig coverage column anywhere in this viewport, so if you want Flye's own per-contig coverage figure you read it out of `assembly_info.txt` in the run folder." | true | No coverage column in `AssemblyContigTableView.swift`. My `flyeA/assembly_info.txt` carries a `cov.` column reading 256. | |
| "Both reference runs returned one contig." | true | Author runs, and all three of my reruns. | |
| "A one-contig assembly makes both numbers trivial, since N50 equals the contig's length and L50 is 1, which is exactly what both reference runs report." | true | `flyeA`, `flyeB`, and `hifiC` JSON all give `n50 == totalLengthBP` and `l50 == 1`. | |
| "The Flye reference run returned one contig of 16,359 bp at 43.9% GC, with N50 16,359 bp, L50 1, and a wall time of 35.2 seconds." | true | Author run 3, and both of my reruns (43.9% GC, N50 16,359, L50 1, 35.6 s). Matches the fixture README's Assembly results section. | |
| "Against the 16,569 bp reference that contig is 210 bp, or 1.3%, short." | true | 16,569 minus 16,359 is 210; 210 / 16,569 is 1.27%. The README states the same figures. | |
| "Flye's own `assembly_info.txt` marks this contig `circ. Y`, meaning Flye recognised the contig as circular." | true | My `flyeA` and `flyeB` both give `contig_1 16359 256 Y N 3 * 1` under the header `#seq_name length cov. circ. repeat mult. alt_group graph_path`. | |
| "The hifiasm reference run returned one contig of 33,140 bp at 44.4% GC, with N50 33,140 bp, L50 1, and a wall time of 5.9 seconds." | true | Author run 2 and my `hifiC` (33,140 bp, 44.4% GC, 6.0 s). Matches the README and the committed `expected/hifiasm/contigs.fasta`, which measures 33,140 bases. | |
| "33,140 divided by 16,569 is 2.0002" | true | Arithmetic checks. The README states the same ratio. | |
| Hifiasm's doubling explanation (walks the circle twice with no boundary in a graph that is a loop) | unverifiable | This is a mechanism claim about hifiasm's internals, not about LGE. The observation it explains is solid and reproduced. The fixture README offers the same explanation in the same hedged form, so the chapter is not inventing it. Nothing in this campaign's evidence base can confirm or refute the mechanism. Settling it would take reading hifiasm's graph-traversal source or its authors' documentation. | |
| "Running the identical command on the identical reads twice produced two different answers. One run returned the 16,359 bp contig described above, and another returned a 32,652 bp contig ... at 43.0% GC and marked circular with a multiplicity of 4." | true | The author's runs 1 and 3, recorded with full JSON and `assembly_info.txt` evidence. **Not reproduced by me.** Both of my reruns gave 16,359 bp with multiplicity 3. See the Reruns section above and App defects below. The claim is a report of a real observation and remains true as written, since the chapter says "produced" rather than "always produces". | |
| "Flye 2.9.6 is not deterministic here" | true | Follows from the author's two runs on byte-identical input with an identical recorded command line. My two runs agreeing does not contradict a single divergent observation. | |
| "The run folder holds the primary contig graph LGE converted, `<project name>.bp.p_ctg.gfa`, and beside it the two haplotype-resolved graphs `bp.hap1.p_ctg.gfa` and `bp.hap2.p_ctg.gfa`" | **false** (partly) | The primary graph is correctly given with its `<project name>.` prefix, but the two haplotype graphs are written with the same prefix. My `hifiC/` listing holds `revC.bp.hap1.p_ctg.gfa` and `revC.bp.hap2.p_ctg.gfa`, never bare `bp.hap1.p_ctg.gfa`. A reader looking for the literal file name will not find it. | "The run folder holds the primary contig graph LGE converted, `<project name>.bp.p_ctg.gfa`, and beside it the two haplotype-resolved graphs `<project name>.bp.hap1.p_ctg.gfa` and `<project name>.bp.hap2.p_ctg.gfa`, plus the unitig graphs" |
| "plus the unitig graphs, which hold the unambiguous stretches before hifiasm joined any of them into contigs" | true | My `hifiC/` holds `revC.bp.p_utg.gfa` and `revC.bp.r_utg.gfa`. | |
| "Only the primary contigs reach the viewport, so the alternate haplotype stays on disk unlisted." | true | `AssemblyOutputNormalizer.swift:44-52` sets `contigsPath` to the converted primary FASTA only. Matches DRIFT row 5. | |
| "Flye similarly keeps its assembly graph as `assembly_graph.gfa` in its run folder, alongside the per-stage working directories it built along the way." | true | `AssemblyOutputNormalizer.swift:40`; my `flyeA/` holds `assembly_graph.gfa` and the `00-assembly` through `40-polishing` directories. | |
| "An assembler that exits cleanly but emits nothing is reported as completed with no contigs rather than as a failure, and the viewport opens on an empty table." | true | `AssemblyOutputNormalizer.swift:56-70`, synthesizes an empty FASTA and sets `outcome = .completedWithNoContigs`. Not triggered by a run this pass. | |
| Both CLI commands in the code block "are the ones the reference runs in this chapter actually used" | true | The flag set matches the author's recorded commands and my own reruns, which used the same flags with different `--output` and `--project-name` values. All flags verified in `cli-help/assemble.txt`. | |
| "They also write `assembly-result.json` into the output directory, which holds the same statistics as machine-readable fields together with the exact command line that ran, the resolved assembler version, and the wall time" | true | My `flyeA/assembly-result.json` holds `commandLine`, `assemblerVersion`, `wallTimeSeconds`, and a `statistics` object with `contigCount`, `totalLengthBP`, `n50`, `l50`, `largestContigBP`, `gcFraction`. | |
| "`--output` on the command line writes exactly where you point it and creates no timestamped folder, so a second run against the same output directory overwrites the first." | true | My three runs each wrote a flat directory at the path given, with no timestamp component. | |
| "Both assemblers take exactly one input file. Passing two or more is refused before the run starts" | true | `ManagedAssemblyPipeline.swift:280-283` and `:301-304` both guard on `inputURLs.count == 1`. I confirmed by running two inputs, which printed a refusal and ran nothing. | |
| "the sheet refuses the same selection with a message naming the read class, reading \"ONT reads assembly expects a single FASTQ input in v1.\" for Nanopore and \"PacBio HiFi/CCS assembly expects a single FASTQ input in v1.\" for HiFi" | true | `AssemblyWizardSheet.swift:261-270` interpolates `effectiveReadType.displayName` into exactly that string, and `AssemblyReadType.swift:16-21` gives those two display names verbatim. The sentence correctly attributes these to the sheet. **See Notes for the editor**, since the CLI's own message is different and this sentence sits in the command-line section. | |
| "The Run Mode picker that appears for the short-read assemblers when several bundles are selected therefore never appears for these two." | true | The long-read path rejects before the picker is reachable; chapter 01 line 104 says the same. | |
| "The two toggles in the Curated extra arguments disclosure reach the command line only through `--extra-args`, since neither has a flag of its own." | true | Both registry entries carry `cli_flag: null` for their toggle, and `cli-help/assemble.txt` lists no `--meta` or `--primary`. | |
| "every flag defaults to the same value the sheet does" | true | Spot-checked against the registry defaults for Profile (`nano-hq` / `diploid`) and Threads. `--assembler` defaults to `spades` on the CLI while the sheet defaults to the menu item clicked, but the chapter's sentence is about the flags the sheet offers, and the sheet always sends `--assembler` explicitly. | |

## Front matter

Checked every key against the roster row, the registry, the glossary, and
the lint's `frontmatter` rule.

| Key | Verdict |
|---|---|
| `title: Running Flye or hifiasm` | true, matches roster row 48 and the tool's lowercase name |
| `chapter_id` | true, matches the path |
| `prereqs: [07-assembly/01-when-to-assemble, 03-reads/07-ont-runs]` | true, both files exist |
| `parameters_refs: [assemble.flye, assemble.hifiasm]` | true, both ids exist in `parameters.yaml` at lines 5120 and 5210 |
| `entry_points` | true, DRIFT row 1's correction applied. The two menu paths match `ToolsMenuModel.swift:71` and the registry `entry_points`. Note the chapter writes `CLI: lungfish-cli assemble` while DRIFT row 1 proposed `lungfish assemble`. The registry uses `lungfish-cli`, and the binary is `lungfish-cli`, so the chapter is right and the DRIFT row was loose. |
| `tools: [flye, hifiasm]` | true, both ids in `third-party-tools-lock.json` |
| `fixtures_refs: [hg002-long-reads]` | true, the fixture directory exists with README, fetch, regenerate, and expected outputs |
| `glossary_refs`, 22 terms | true, every one of the 22 anchors resolves exactly once in `GLOSSARY.md`, and each is linked at least once in the body |
| `shots`, 4 entries | true, all four have matching `<!-- SHOT: -->` markers in the body and no orphans either way |
| `estimated_reading_min: 24` | unverifiable, an editorial judgment. The body is roughly 4,200 words, so 24 minutes is a defensible rate. |
| `brand_reviewed: false`, `lead_approved: false` | true, correct for a chapter at this stage |
| `features_refs: []`, `illustrations: []` | true, nothing claimed |

## Settings coverage against parameters.yaml

The registry holds **seven** settings for `assemble.flye` and **seven**
for `assemble.hifiasm`, fourteen in total, of which six labels are shared
between the two. The task brief's "sixteen registry settings" overcounts.
The chapter's own count, "seven controls for each assembler", is right.

| Registry label | Tool | Documented | Notes |
|---|---|---|---|
| Assembler | both | yes, **Assembler.** | Default, narrowing, and `--assembler` all correct |
| Read Type | both | yes, **Read Type.** | Three allowed values verbatim, lock note verbatim, CLR unlock correct, `--read-type` |
| Profile | both | yes, **Profile.** | Carries both tools' full option lists and both defaults, which is the right call for the one label whose meaning differs |
| Threads | both | yes, **Threads.** | Default and bound both correct, `--threads` |
| Metagenome mode | flye | yes, **Metagenome mode.** | Off by default, Flye only, inside the disclosure, `cli_flag: null` handled by naming the `--extra-args "--meta"` form |
| Primary contigs only | hifiasm | yes, **Primary contigs only.** | Same shape, `--extra-args "--primary"` |
| Extra arguments | both | yes, **Extra arguments.** | Empty default, pass-through, profile-precedence note, `--extra-args` |
| Project Name | both | yes, **Project Name.** | Default, empty-blocks-Run, hifiasm prefix, `--project-name` |

All eight paragraphs use the `**Label.**` form with the period inside the
bold, which is what the `settings-coverage` lint rule matches. Lint
passes clean.

The five `cli_only` flags are identical between the two registry entries
(`--output`, `--memory-gb`, `--min-contig-length`, `--extra-arg`,
`--format`) and are documented once in the paragraph closing the Settings
section. All five appear in `cli-help/assemble.txt` with the aliases and
default the chapter states. Documenting a shared group once is what the
CONSISTENCY sheet allows.

Each entry follows the three-sentence Settings shape and closes with
either the flag or the no-flag substitute sentence.

## Consistency

| Point | Verdict |
|---|---|
| Where assemblies land | Consistent. Chapter 03 says a per-run folder under `Analyses` and states outright that there is no `Assemblies` folder, matching chapter 01 line 144, chapter 02 line 101, and the CONSISTENCY sheet's `Analyses/<tool>-<timestamp>/` ruling. |
| The Genome Assembly pack | Consistent in name. Chapter 03 calls it the Genome Assembly plugin pack, as do chapters 01 and 02, and `PluginPack.swift:670` gives that display name. |
| The 950 MB size | Chapter 03 states **no** size. Chapter 01 line 70 gives "roughly 950 MB installed", which matches `PluginPack.swift:718` (`estimatedSizeMB: 950`). No contradiction, since 03 makes no claim, and 03 correctly defers to chapter 01 by saying the pack was already installed for SPAdes. |
| Pinned versions | Consistent. Chapters 01, 02, and 03 all give Flye 2.9.6 and hifiasm 0.25.0, matching the lock. |
| The MEGAHIT caution | Correctly absent. Chapter 01 line 130 carries the arm64 abort caution; chapter 03 documents no short-read assembler and says nothing about MEGAHIT, which is the right division. |
| The five-assembler comparison table | Correctly absent from 03. Editorial rule 3's tool-comparison requirement is met by chapter 01 line 89's table, and 03's removal of its own stale table avoids two competing comparisons. |
| Menu shape | Consistent. All three chapters describe `Tools > Assembly` as a submenu of five items into one sheet. |
| Sheet naming | Consistent. Chapters 02 and 03 both call it "the assembly sheet" rather than "the Assembly wizard", which is the campaign's settled wording. Chapter 01 does not name it. |
| Fixture naming | Consistent. "the HG002 long reads", the CONSISTENCY sheet's fixed name. |
| App naming | Consistent. "Lungfish Genome Explorer (LGE)" at first mention in the body, "LGE" after. |

## App defects

Four items, of which one is new from this review.

1. **Flye 2.9.6 nondeterminism on this fixture (author's defect 1),
   partially reproduced.** The author observed 32,652 bp on one run and
   16,359 bp on another from byte-identical input and an identical
   recorded command line. My two reruns this pass both returned
   16,359 bp with identical coverage, circularity, and multiplicity, so I
   did not reproduce the doubled branch. That narrows rather than
   contradicts the finding. Three of the four Flye runs now on record,
   plus the fixture README's own 2026-09-06 run and the committed
   `expected/flye/assembly.fasta`, all give 16,359 bp. The doubled result
   is the rare branch. The consequence for the fixture stands, since a
   `regenerate.sh` run that lands on the rare branch would write an
   `expected/flye/assembly.fasta` at twice the committed length and any
   exact-length assertion would flake. Somebody still needs to decide
   between pinning a seed, recording a tolerance, and dropping the length
   assertion. Worth logging how often the rare branch appears before
   choosing.

2. **The doubled-circle outcome is invisible in the viewport (author's
   defect 2). Confirmed.** `AssemblyContigTableView.swift:19-47` declares
   exactly six columns and nothing in `Sources/LungfishAssemblyUI/`
   mentions circularity, multiplicity, or `assembly_info.txt` at all. My
   16,359 bp Flye result and the 33,140 bp hifiasm result differ in no
   field the summary strip or the contig table shows, beyond the length
   itself. Flye records `circ. Y` and `mult. 3` in `assembly_info.txt`
   and hifiasm encodes the `c` suffix in `ptg000001c`, and neither
   reaches the UI. A suggestion rather than a bug, as the author framed
   it, but a well-aimed one, since the length check is currently the
   reader's only defence.

3. **`--memory-gb` and `--min-contig-length` are accepted and silently
   ignored for both tools (author's defect 3). Confirmed by source, not
   by a run.** `AssemblyOptionCatalog.swift:110-131` maps both controls
   only to spades, megahit, and skesa, and neither `buildFlyeCommand`
   (`ManagedAssemblyPipeline.swift:280-298`) nor `buildHifiasmCommand`
   (`:300-325`) reads either field. The CLI help hedges with "when the
   selected assembler supports it" but the command emits no warning when
   it does not. I did not run a Flye assembly with `--memory-gb` to
   confirm the silence, since the two command builders have no code path
   that could consume it.

4. **New: the CLI's multi-input refusal message differs from the sheet's,
   and neither the chapter nor the registry records the CLI wording.**
   I ran two input files through the CLI and got

   ```
   ✗ Flye expects a single ONT sequence input in v1.
   ```

   That string comes from `ManagedAssemblyPipeline.swift:281-282`, and
   the hifiasm arm at `:302-303` reads "Hifiasm expects a single ONT or
   PacBio HiFi/CCS sequence input in v1." The two messages the chapter
   quotes ("ONT reads assembly expects a single FASTQ input in v1." and
   "PacBio HiFi/CCS assembly expects a single FASTQ input in v1.") are
   the sheet's, from `AssemblyWizardSheet.swift:261-270`. Both pairs are
   real and the chapter attributes its pair correctly to the sheet, so
   this is not a false claim. It is a product wrinkle worth recording:
   the same refusal reads differently depending on the route, one message
   naming the read class and the other naming the tool. Also note the CLI
   printed this refusal and **exited 0**, which means a script cannot
   detect the rejection from the exit status. That exit code looks like a
   genuine bug.

## Notes for the editor

1. **One correction to make.** The haplotype-graph file names in the
   "Hifiasm keeps more than it shows" paragraph are missing their project
   name prefix. Written as `bp.hap1.p_ctg.gfa` and `bp.hap2.p_ctg.gfa`,
   they do not exist on disk. My run wrote `revC.bp.hap1.p_ctg.gfa` and
   `revC.bp.hap2.p_ctg.gfa`. The sentence already gets the primary graph
   right as `<project name>.bp.p_ctg.gfa`, so the fix is to carry that
   same prefix into the other two names. Corrected wording is in the
   claim table.

2. **The multi-file refusal sentence sits in the command-line section but
   quotes the sheet's messages.** The sentence is accurate and does say
   "the sheet refuses", so it is not wrong. But a reader in the
   command-line section who triggers the same refusal from the CLI will
   see different words. Consider either moving that sentence up into the
   Settings or Procedure material, or adding the CLI's own wording beside
   it. Editor's call, and no correction is required for fidelity.

3. **The task brief's setting count is off.** The brief says sixteen
   registry settings. The registry holds fourteen, seven per tool, six
   labels shared. The chapter's own "seven controls for each assembler"
   is correct and needs no change.

4. **The Flye nondeterminism paragraph is well hedged and should stay as
   written.** It says "produced two different answers", not that Flye
   always varies, and it teaches the size check rather than promising a
   number. My failure to reproduce the doubled branch in two attempts
   does not weaken that paragraph. If anything the editor might consider
   whether "is not deterministic here" wants softening to name how rare
   the doubled outcome appears to be, but the sentence as written is
   defensible and I am not asking for a change.

5. **The four shot captions all describe elements that exist.** The
   `assembly-sheet-flye` caption names the Inputs Detected row, the
   Assembler picker offering exactly Flye and Hifiasm, the locked Read
   Type row, and the Nano HQ profile, all confirmed in
   `AssemblyWizardSheet.swift:474-540` and `:892-897`. The
   `assembly-sheet-hifiasm` caption's claim that the picker shows Hifiasm
   alone follows from `AssemblyCompatibility.swift:21-22`, and the
   caption explains why, which the reality map asked for. The
   `assembly-sheet-curated-arguments` caption names the Metagenome mode
   toggle above four read-only descriptions and the Extra arguments
   field, matching the render order at `:585-620`. The
   `flye-contig-table` caption quotes one contig at 16,359 bp, which is
   the outcome three of four recorded runs and the committed fixture all
   produced, so the capture should be reproducible. Whoever captures it
   should check the length before accepting the shot, given defect 1.

6. **The three new glossary entries are accurate.** GFA, Nanopore
   sequencing, and Unitig all resolve, all sit in alphabetical position,
   and all three describe LGE behaviour correctly (the GFA entry's claim
   that LGE converts the primary contig graph before the viewport lists
   it matches `AssemblyOutputNormalizer.swift:44-52`). Each of the three
   uses a semicolon, which the chapter prose rules ban. The rule is
   scoped to `docs/user-manual/**` chapters and `.claude/agents/*` in the
   campaign brief, and the existing GLOSSARY entries around them use
   semicolons throughout, so the new entries match house style for that
   file. Flagging it only so the brand editor can rule if the ban is
   meant to reach the glossary.

7. **Lint is green.** `LUNGFISH_MANUAL_STRICT=1 bash
   docs/user-manual/build/scripts/lint-chapter.sh` on this chapter prints
   "no issues found".

## Counts

**80 claims checked: 78 true, 1 false, 1 unverifiable.**

The one false claim is the pair of haplotype-graph file names written
without their project-name prefix.

The one unverifiable claim is the mechanism offered for hifiasm's
doubling, which is a statement about hifiasm's internals rather than
about LGE. Settling it would take reading hifiasm's graph-traversal
source or its authors' documentation, and the chapter hedges it
appropriately.
