# Fidelity review, appendices/troubleshooting.md

Reviewed against Preview 2026.9.13, `Sources/`, the campaign gate files, the
committed chapters, CONSISTENCY.md, DRIFT `### appendices.md/troubleshooting.md`,
and four live runs of `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
made with the working directory at the worktree root, never under `/private/tmp`.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| First instruction is to take the failure report from the failed row, not reconstruct the command | true | Chapter lines 30 to 34. The section is the first after What it is, and it names the anti-pattern explicitly | |
| Right-click menu offers **Copy Failure Report**, **Copy CLI Command**, **Reveal Failure Report in Finder** | true | `Sources/LungfishApp/Views/Operations/OperationsPanelController.swift:1543`, `:1517`, `:1557` | |
| **Open GitHub Issue** on the failed row's menu | true | `OperationsPanelController.swift:1548` | |
| **Help > Report an Issue...** | true | `Sources/LungfishApp/App/MainMenu.swift:1026` | |
| **Operations > Show Operations Panel** (Cmd-Shift-P) | true | `MainMenu.swift:866-873`, `keyEquivalent: "p"` with `[.command, .shift]` | |
| **Tools > Plugin Manager...** (Cmd-Shift-B) | true | `MainMenu.swift:773-775` | |
| Failure reports written under `~/Library/Logs/`, a build-named folder, then `Operations/Failures` | true | `Sources/LungfishKit/OperationFailureReportStore.swift:56-77` | |
| "The store keeps the most recent reports and prunes older ones each time it writes a new one" | true but under-specified | `OperationFailureReportStore.swift:22` declares `public static let defaultRetentionLimit = 50`, and `writeReport` calls `pruneOldReports()` on every write (`:100`). DRIFT row 33 also names 50 | The count is verifiable. Say "the most recent 50 reports", as DRIFT row 33 specifies. The author recorded this as unverifiable, which the source contradicts |
| Genotyping menu items grey with `(not enabled)` | true | `MainMenu.swift:832` builds `"\(workflow.title) (not enabled)"`. Gate `09-genotyping__01` records the same | |
| "turn its **Enabled** switch on. If the card says Needs install, click **Install Dependencies** first" | **false** | `Sources/LungfishApp/Views/WorkflowLibrary/WorkflowLibraryPanelView.swift:346-360`. `actionView` renders the Install Dependencies button **instead of** the Enabled toggle when packs are missing, and the button calls `installDependenciesAndEnable`, which enables the workflow itself. Committed chapter 51 (`09-genotyping/01-what-is-mhc-genotyping.md:104`) states this correctly | "find the workflow's card under **Specialized Workflows** in the **Genotyping** group and turn its **Enabled** switch on. If the card reads Needs install, an **Install Dependencies** button stands in place of the switch, and it fetches the packs and enables the workflow when it finishes." |
| Card grouping **Specialized Workflows**, dependency row Ready or Needs install | true | `Sources/LungfishApp/Services/WorkflowLibrary.swift:207`, `WorkflowLibraryPanelView.swift:334`, `PluginPackStatusService.swift:82` | |
| Workflow Builder item absent from Tools menu until Show Experimental Features | true | `Sources/LungfishApp/Views/Settings/AdvancedSettingsTab.swift:16` holds the toggle title. `PluginPack.swift:975` gates the optional pack list on `experimentalFeaturesEnabled`. Committed chapter 50 documents the same route. Note the `08-workflows__01` gate Findings do not record menu visibility, so the entry rests on source plus the committed chapter rather than on a gate | |
| Experimental sentence used verbatim | true | CONSISTENCY.md lines 110 to 112. Chapter line 49 matches word for word | |
| Assistant tab appears only when a genomics bundle is loaded, five other viewport kinds lack it | true | Gate `appendices__ai-assistant` Findings: the tab exists only in the genomics content mode, so read, assembly, mapping, classifier and genotype viewports get an Inspector without it | |
| Workaround "Select a reference bundle under `Reference Sequences/`" | unverifiable | The gate names the **genomics content mode**, not a reference bundle specifically. A reference bundle is one way into that mode but the gate does not say it is the only one. What would settle it: the content-mode switch in `InspectorViewController` and which bundle kinds map to `.genomics` | Say "Load a bundle that opens the Sequence viewport, which is what puts the Inspector in its genomics mode" unless source shows reference bundles are the sole route |
| Alert headed "AI Assistant Disabled" when the assistant is off | true | `Sources/LungfishApp/App/AppDelegate+MenuActions.swift:503`. Its body names **Settings > AI Services**, which the chapter does not print and does not need to | |
| A greyed item's keyboard shortcut does nothing | true | Standard `NSMenuItem` behaviour for a disabled item, and `MainMenu.swift:832` disables the item alongside the title suffix | |
| Window title ends in ` (Read Only)` | true | `Sources/LungfishApp/App/AppDelegate.swift:673`, also `:609` | |
| Banner "Project opened read-only" names user, host, process id | true | `Sources/LungfishApp/App/ProjectLockWarningPresentation.swift:18`, `:28-30` interpolating `record.user`@`record.host`, `pid \(record.pid)` | |
| Alert "Project Is Open Read Only" on Run, naming the workflow, telling you to close the other writer or reopen | true | `Sources/LungfishApp/App/ProjectWriteGatePresenter.swift:22`, `:53` | |
| Lock metadata corrupted or unreadable blocks writing until inspected or force-removed | true | `ProjectLockWarningPresentation.swift:35-44` | |
| Lock failures surface against `.lungfish/project.lock` or a `.install.lock` in the conda root, never `manifest.json` | true | DRIFT row 28 states exactly this. `CondaRootMutationLock.swift` holds the conda-root lock | |
| Stray `._` files confuse the check on network storage | true | `Sources/LungfishWorkflow/Engines/NextflowRunner.swift:167-177` names AppleDouble `._` xattr sidecars as one of the two probed properties | |
| `Empty Kraken2 report`, exit status 64 | true | `Sources/LungfishIO/Formats/Kraken/KreportParser.swift:39` for the text. Gate `06-classification__02` Findings: "An all-unclassified Kraken 2 run exits 64 with Empty Kraken2 report before Bracken runs" | |
| MEGAHIT 1.2.9 "fails most runs on Apple Silicon", rerun is the only workaround, a completing run is correct | true | CONSISTENCY.md lines 201 to 207 fix this wording for every chapter, including the four required points. The gate's own figure is "about four runs in five", which the sheet deliberately generalises | |
| `/private/tmp` provenance publication artifact failure writes nothing, and `/tmp/...` works | true | Gate `appendices__cli-reference` Findings, quoted verbatim: a resolved path is compared with an unresolved one across the `/tmp` symlink | |
| Genotyping run stops at about 84 percent saying an output is outside the result bundle, same cause | true | Gate `09-genotyping__02` Findings: fails at 84 percent after all the work with a misleading outside-the-bundle message | |
| Nextflow relocates scratch off a volume lacking file locks or carrying `._` sidecars, results still land where asked | true | `NextflowRunner.swift:160-180`. The comment and the `NextflowScratchVolumeProbe` policy switch both say so, and `outputDirectory` is unchanged | |
| "Zero means the command succeeded. Three means a pack name was not recognised... Ten means `tools update --plan` found pending work" | true | `Sources/LungfishCLI/LungfishCLI.swift:143` `success = 0`, `:146` `inputError = 3`, `:153` `updatesPending = 10`. Exit 10 reproduced live | |
| "Sixty-four means a usage refusal, so the command stopped before doing any work" | **false** | `LungfishCLI.swift:154` names 64 `workflowError`. `:145` names **2** `usage`. And the chapter's own Kraken 2 row attaches 64 to a classification that finished, which readers 2 and 4 both flagged as a contradiction they could not resolve | "Sixty-four means the command refused the work or the work failed inside a workflow step, so read the message rather than assuming a typing mistake. It covers a run started without a required flag and a classification that finished and matched nothing." Note the committed CI chapter (`06-running-in-ci.md:135`) carries the same wrong gloss, so this is a sweep item across two chapters |
| `genotype-cohort` requires at least two input FASTQ bundles, minimum not in the help text | true | `Sources/LungfishCLI/Commands/FastqGenotypingSubcommand.swift:470` throws that exact string. Gate `09-genotyping__02` calls the minimum undocumented | |
| `bundle export` cannot be run because its `--format` collides with the global one, zip the folder by hand | true | Gate `appendices__cli-reference` Findings and its Known defects row | |
| `conda install --pack gatk-core` exits 3 with an unknown-pack error, same for `--pack phasing`, install from the Plugin Manager | true | Gates `06-human-germline-variants__01`, `__02`, `__04`, the last naming exit 3 | |
| `convert` refuses an in-place conversion and rejects a symlink or hard link back at the input | true | `Sources/LungfishCLI/Commands/ConvertCommand.swift:19` | |
| VCFv3 rejected on import, convert with `bcftools convert` or vcftools `vcf-convert` | true | `Sources/LungfishIO/Formats/VCF/VCFReader.swift:826` | |
| "a version of the Variant Call Format that predates what LGE reads" | true but misleading | `appendices__file-formats/fidelity.md:54`: `validateFileFormat` throws only on the `VCFv3.` prefix, and nothing restricts the upper bound, so 4.5 and later are accepted. The phrase implies a bounded supported range | "The file is in version 3 of the Variant Call Format, which LGE refuses. Any 4.x version is accepted." |
| `fastq ont-barcode-genotype` deprecation, redirect to FASTQ import recipes plus `fastq genotype` or `genotype-cohort` | true | `appendices__cli-reference/fidelity.md:79` marks the older `ont-genotype` redirect false and gives this replacement. The chapter carries the corrected version | |
| Min Reads and `--min-support` recorded in run statistics but never applied as a filter on a Genotype only run | true | Gate `09-genotyping__02` Findings, same wording | |
| Genotype-only result hides the cohort summary panel and Smart Cohorts by design | true | Gate `09-genotyping__03` Findings, with two tests asserting the panel guard | |
| `genotype list-samples` prints one row per sample with retained read count and status | true | `Sources/LungfishCLI/Commands/GenotypeListSamplesSubcommand.swift:18`. `09-genotyping__03/fidelity.md:91` verifies the header carries `qc_status` and `total_reads` | |
| BigWig and BigBed are recognised but have no in-process reader, so nothing renders | true | `Sources/LungfishIO/Registry/FormatRegistry+BuiltInDescriptors.swift:193` and `:210` both read "detection only; in-process reader unavailable" with `canRead: false` | |
| `fetch genome` returns a record under a different sequence name, and "the command's own help text says so" | true | `cli-help/fetch.txt:307-311` says verbatim that asking the assembly database for a nucleotide accession returns the linked assembly instead, under a different sequence name | |
| "Several commands accept `--format json` and ignore it" | true but under-specified | Gate `appendices__06-running-in-ci` Findings names all five: `conda packs`, `ops stats`, `workflow list`, `conda offline-export`, `version`. The chapter names none, so a reader cannot tell whether the command they are about to script is affected | "Five commands accept the flag and ignore it, `conda packs`, `ops stats`, `workflow list`, `conda offline-export`, and `version`, so their output cannot be parsed reliably yet." |
| `debug env --check-tools` reports each tool found with its version or not found, `--tool <name>` checks one | true | `cli-help/debug.txt:32-33` | |
| `version --tools` exited 0 and printed `Lungfish 2026.9.13` with `Dependency set: 2026.2 (2026-08-18)` above eighteen tool rows | true | Reproduced live. Exit 0. Header and dependency-set lines exact. Eighteen rows, micromamba bundled plus seventeen managed | |
| `tools update --plan` exits 10 when work is pending and 0 when there is none | true | `LungfishCLI.swift:149-153` and the live run | |
| It exited 10 and printed two lines of pending work with an estimated download of 157.3 MB | true | Reproduced live. Exit 10. `preserve bracken` and `reinstall gatk-core`, then `Estimated download: 157.3 MB` | |
| `conda db list`, `conda db recommend`, `conda db download <name>` | true | `cli-help/conda.txt`, and `conda db recommend --help` run live | |
| `esviritu download-db` and `esviritu db-status` | true | `cli-help/esviritu.txt:19-20` | |
| `waiting for conda lock held by pid <n>` then continues on its own | true | `Sources/LungfishWorkflow/Conda/CondaRootMutationLock.swift:95` | |
| `conda root is read-only; reinstall as the admin user` | true | `CondaRootMutationLock.swift:12` | |
| `HTTPS_PROXY` read by micromamba and the network stack rather than by LGE | true | DRIFT row 8 fixes this wording. No LGE source reads the variable | |
| `debug container` reports the Apple Containerization framework, exited 0, printed `Apple Containerization framework available` and `Status      : Ready` | true | Reproduced live. Exit 0. Both strings exact, spacing included | |
| `debug container --pull-test` checks image fetch separately | true | `cli-help/debug.txt:55` | |
| `taxtriage check-prerequisites` verifies Nextflow and the container runtime | true | `cli-help/taxtriage.txt:20` | |
| `debug env` exited 0 and reported macOS 26.6.2, 14 CPU cores, 48 GB, arm64, Apple Containerization available | true | Reproduced live. Exit 0. Every figure exact | |
| `analyze validate <files>...` with `--strict`, `bundle validate <bundle>` | true | `cli-help/analyze.txt:110-116`, `cli-help/bundle.txt` | |
| `provenance verify` handles only signed records, signing off by default, exits 64 on an unsigned sidecar | true | Gate `appendices__06-running-in-ci` Findings, and `ProvenanceCommand.swift:78` abstract reads "Verify a signed Lungfish provenance sidecar" | |
| LGE rebuilds a `.fai`, `.bai`, or `.tbi` the first time an operation needs one | unverifiable | No single source states the regenerate-on-demand policy for all three. What would settle it: the index-materialisation path each reader takes when the sidecar index is absent | |
| `lungfish-cli version` prints the app version, About window shows it | true | Live run prints `Lungfish 2026.9.13` | |
| Deacon example dropped because both indexes ship with Required Setup | true, see App defects | `third-party-tools-lock.json:27-28` declares both under `managedData`. `ManagedToolLock.swift:256-259` folds every `managedData` entry into the Required Setup pack's requirements as a `managedDatabase` requirement. `PluginPack.swift:424-436` builds the pack from that lock | |
| SRA Toolkit fallback message dropped as unsourceable | true as to the quoted string, over-broad as a drop | The DRIFT-quoted line `Falling back to SRA Toolkit (prefetch + fasterq-dump)` is genuinely absent. The behaviour exists and prints `ENA FASTQ unavailable for <accession>; using SRA Toolkit...` at `Sources/LungfishApp/Views/DatabaseBrowser/DatabaseBrowserViewController.swift:3064` | Dropping the verbatim quote is right. The fallback itself is real and quotable from `:3064` if the editor wants the row back |
| `project migrate` dropped as unverifiable, "appears in neither the CLI Reference's index nor `cli-help/`" | **false** as a justification | `Sources/LungfishCLI/Commands/ProjectCommand.swift:249` defines it with `--dry-run` at `:262`. `cli-help/project.txt:83` shows the full usage. `cli-reference.md:138` indexes `project`. The committed Shared Projects chapter documents it at length (`shared-projects.md:35`, `:152`, `:155`) | The command exists and is documented. Dropping the migration section from this appendix is still defensible, because Shared Projects covers it, but the stated reason is wrong. If a row is wanted, point at Shared Projects rather than restating |
| iCloud corruption claim dropped | true | No `iCloud` string anywhere in `Sources/` | |
| NFS `noac,actimeo=0` remedy dropped | true | No `noac` or `actimeo` in `Sources/`. DRIFT row 28 supplies the better-sourced replacement the chapter uses | |
| mpileup depth cap of 600,000 dropped | true | The figure exists only as a read-viewport budget (`Sources/LungfishApp/Views/Viewer/ReadViewportPolicy.swift:26`, `ReadBudgetState.swift:11`), not as an mpileup cap. No `--max-depth` is passed to mpileup anywhere. DRIFT row 26's framing was itself wrong | |
| 5 GB free-space figure dropped | true | No such threshold in source. `tools update --plan` reports the real figure | |
| All 18 relative chapter links resolve | true | Every target checked on disk | |
| Lint clean under `LUNGFISH_MANUAL_STRICT=1` | true | Reproduced. `no issues found`, exit 0 | |

## Front matter

Well formed and consistent with the roster. `chapter_id` matches the path.
`prereqs`, `tools`, `entry_points`, `illustrations`, `features_refs`, and
`fixtures_refs` are all empty, which is right for an appendix with no fixture and
no single operation. `brand_reviewed` and `lead_approved` are both `false`, correct
before the brand pass. `estimated_reading_min: 18` sits inside the appendix range
(14 to 45) and is plausible for six sections and 23 table rows.

One `shots` entry, `operations-panel-failed-row`, and exactly one matching
`<!-- SHOT: operations-panel-failed-row -->` at line 36. The caption describes a
capturable state and names the menu item the shot must show. Declaring only this
shot rather than DRIFT's suggested two is sound, because the lock dialog needs a
live second session to stage.

`glossary_refs` holds thirteen ids and every one resolves to a real anchor in
`GLOSSARY.md`. Three are declared but never linked from the body: `container`,
`failure-report`, and `workflow-library`. The body explains containers in prose
(line 122) and failure reports in prose (line 34), and names Workflow Library as a
bold menu path rather than a glossary link. Either link them at first use or drop
them from the list.

The four new glossary entries are all present and in the one-sentence house shape,
`failure-report` at line 267, `symlink` at 781, `working-directory` at 863,
`workflow-library` at 865. Two defects there, both in `GLOSSARY.md` rather than in
the chapter. First, **Workflow Library** is filed after **Working directory**, but
"Workflow" sorts before "Working", so it belongs immediately after **Workflow
package** and before **Working directory**. Second, the author's report says both
new W terms go "after Workflow package", which is right for one of them only.

## Consistency

Compliant with CONSISTENCY.md on every rule I checked.

- App named "Lungfish Genome Explorer (LGE)" at line 24, LGE thereafter, and bare
  "Lungfish" is never used for the app.
- `lungfish-cli` throughout, never bare `lungfish`.
- **Operations > Show Operations Panel** (Cmd-Shift-P) and **Tools > Plugin
  Manager...** (Cmd-Shift-B) match lines 34 to 35 of the sheet exactly, ellipsis
  and all.
- The experimental sentence at line 49 is the sheet's fixed sentence verbatim.
- The MEGAHIT paragraph carries all four required points and makes no claim that
  the thread cap fixes it.
- The read-only ruling is followed. Multi-user projects are treated as supported
  and coordinated by locks, pointing at Shared Projects, which reverses the old
  "not yet supported" claim as DRIFT row 29 requires.
- No em dash, no semicolon, no in-sentence colon. No bullet list at all, so the
  five-per-list and two-per-section caps are trivially met.
- No fixture referenced, correct for an appendix with `fixtures_refs: []`.

One cross-chapter inconsistency, carried in rather than introduced. The gloss
"Sixty-four means a usage refusal" matches the committed CI chapter
(`06-running-in-ci.md:135`) and contradicts both `LungfishCLI.swift:154` and this
chapter's own Kraken 2 row. Fixing it in one chapter alone would create a new
disagreement, so it needs a sweep item covering both.

A second, smaller one. The chapter presents 0, 3, 10, and 64 as the exit statuses
worth knowing, but the gates record exit 5 (`workflow validate` on a builder
graph, gate `08-workflows__01`) and a second meaning for exit 3 (`collect-metrics`
hiding a Picard dictionary error, gate `06-human-germline-variants__03`). A reader
who hits exit 5 and consults this list is told nothing.

## App defects

**The Deacon ruling. Chapter 50 is wrong and this chapter is right.**

Chapter 50 (`08-workflows/01-the-workflow-builder.md:75`) says of the Deacon human
index that "that one you install yourself", that "The Plugin Manager's Databases
tab does not list it, because that tab carries only the classifier databases, so
the command line is the only route", and then gives
`lungfish-cli conda db install-managed deacon-panhuman` as the required step.

Half of that is right and the load-bearing half is wrong.

Right. The Databases tab genuinely excludes Deacon indexes. That tab is fed by
`MetagenomicsDatabaseRegistry.availableDatabases()`
(`Sources/LungfishApp/Views/PluginManager/PluginManagerViewModel.swift:727`,
resolving to `Sources/LungfishWorkflow/Metagenomics/MetagenomicsDatabaseRegistry.swift:487`),
which returns only the Kraken 2 style catalog. The Deacon indexes live in a
different registry entirely, `DatabaseRegistry`, reached through
`installManagedDatabase`. So chapter 50's editor was correct that the tab does not
list them.

Wrong. "The command line is the only route" and "that one you install yourself" do
not follow, and are false. Both indexes are declared as `managedData` in the tool
lock (`Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json:27-28`,
`deacon-panhuman` as Human Read Removal Data and `deacon-ribokmers` as Ribosomal
RNA Removal Data). `PackToolRequirement.from(lock:)`
(`Sources/LungfishWorkflow/Conda/ManagedToolLock.swift:256-259`) folds every
`managedData` entry into the requirement list as a `managedDatabase` requirement,
and `PluginPack.requiredSetupPack` builds the Required Setup pack from exactly that
list (`Sources/LungfishWorkflow/Conda/PluginPack.swift:424-436`). So both Deacon
indexes are Required Setup requirements and install with the pack LGE installs by
itself before a project can open.

`lungfish-cli conda db install-managed --list` run live prints `human-scrubber`,
`deacon-panhuman`, `deacon-ribokmers`, exit 0, which confirms the CLI route exists.
It is a route, not the only one, and `DbCommand.swift:49-58` says why it was added,
to let the `toolset-conformance` CI job provision the index headlessly. It was
never the user-facing install path.

The committed chapter 30 (`03-reads/05-decontamination.md:81`) already states the
correct position, that both databases arrive with Required Setup, that they show in
the Plugin Manager as Human Read Removal Data and Ribosomal RNA Removal Data, and
that neither appears on the Databases tab. Chapter 30 and chapter 50 contradict each
other in the committed manual today.

The troubleshooting author was therefore right to drop the Deacon example, and right
about the reason. Chapter 50 needs a sweep item: keep the Databases-tab sentence,
delete "that one you install yourself" and "the command line is the only route", and
delete the required install step, replacing it with chapter 30's wording. The
`install-managed` command may stay as an optional scripted route if the editor wants
it, but not as a prerequisite.

No new app defect was found by this review. Every defect the chapter reports was
already recorded by a gate or is visible in source.

## Notes for the editor

Ordered by how much a reader loses.

1. Fix the exit-64 gloss (claim table row 30). Two of the four readers stopped on
   this contradiction, and it is the only place in the chapter where two statements
   cannot both be true. It needs a paired fix in `06-running-in-ci.md:135`, so raise
   it as a sweep item rather than editing this chapter alone.

2. Fix the Install Dependencies instruction (claim table row 10). As written it
   sends a reader to look for a switch that the button has replaced and that will
   already be on when the install finishes. Chapter 51 has the correct sentence to
   copy.

3. Name the five `--format json` commands. The entry currently tells a reader that
   a problem exists without telling them whether it applies to them, which is the
   one thing a troubleshooting row has to do. The gate lists all five.

4. Restore the retention count. Source and DRIFT both say 50, so "the most recent
   reports" gives away a number the reader can use to judge whether last month's
   report is still there. The chapter already tells them to collect it, and 50
   makes that advice concrete.

5. Consider one missing symptom of the same severity as MEGAHIT. Gate
   `05-variants__04-nanopore-variant-calling` records that **every** Medaka run
   fails in this release (the pipeline calls a `variant` subcommand Medaka 2.2.2
   removed) and that Clair3 aborts on any BAM path containing a space, which every
   path under `Reference Sequences/` has. That is a total failure of two named
   callers with a path-shaped workaround for one of them, and it is the closest
   analogue in the corpus to the MEGAHIT row the chapter does carry. Its absence is
   the one gap I would call reader-facing rather than editorial.

6. Smaller gaps, listed for the record rather than urged. A wrong primer scheme
   trims with exit 0 and no warning (`04-alignments__03`), `fastq sequence-filter`
   crashes with a raw Java assertion at the dialog's own default
   (`03-reads__06`), `tree reroot` duplicates every tip (`02-sequences__05`),
   `extract reads --by-region` blames the reference name for a coordinate refusal
   (`04-alignments__02`), and `genotype export` under `/private/tmp` leaves a
   zero-byte lock behind (`09-genotyping__04`). The author's stated reason for
   excluding this class, that carrying every gate defect would turn the appendix
   into a defect list, is sound, and I would not overturn it for these five.

7. Fix the two glossary bookkeeping items. Move **Workflow Library** above
   **Working directory** in `GLOSSARY.md`, and either link `container`,
   `failure-report`, and `workflow-library` at first use in the body or drop them
   from `glossary_refs`.

8. Two author-report bookkeeping errors worth correcting so the gate's counts are
   right. The report says "28 symptom entries across six tables"; there are five
   tables holding 23 rows, plus five symptoms in prose, which is how the 28 is
   reached. And it says 60 gate files were read with six roster directories lacking
   gates; there are 62 gate files and four such directories, since
   `appendices__keyboard-shortcuts` and `appendices__primer-schemes` now have gates.
   Neither affects the chapter text.

9. The VCFv3 meaning column implies a bounded supported range that does not exist
   (claim table row 36). A one-word fix, and nearby chapters already carry the
   corrected phrasing.

## Counts

77 claims checked. **72 true**, **3 false**, **2 unverifiable**.

The three false claims are the Install Dependencies instruction, the "sixty-four
means a usage refusal" gloss, and the author's stated justification for dropping
`project migrate`. The two unverifiable ones are the reference-bundle workaround
for the Assistant tab and the index regenerate-on-demand policy.

Two further claims are true but under-specified enough to be worth an edit, the
failure-report retention count and the unnamed `--format json` commands, and one
is true but misleading, the VCFv3 range.

Every quoted message in the chapter was found in `Sources/` or the committed CLI
help at the line the author cited. All four diagnostics reproduced with the exit
statuses the chapter states, 0, 0, 0, and 10. Every one of the 18 chapter links
resolves. The chapter's first instruction is to read the failed Operations row and
it names the reconstruct-by-hand anti-pattern explicitly, as the campaign requires.
