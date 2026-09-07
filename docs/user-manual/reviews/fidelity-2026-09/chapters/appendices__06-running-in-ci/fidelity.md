# Fidelity review, appendices/06-running-in-ci.md

Reviewer pass for the 2026-09 fidelity campaign, roster row 58. Every
command in the author's table was rerun into an independent scratch folder
at `/Users/dho/lge-scratch/running-in-ci-review/` against
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
(reports version 2026.9.13). The chapter file was not edited.

The chapter is unusually well grounded. The worked runs reproduce exactly,
the exit statuses are right, the quoted CLI output matches, and the ci.yml
reading is correct. The false claims below are concentrated in two places,
the size of the hidden pack set and the attribution of the offline pack's
own provenance fields, plus one internal contradiction about `--executor`.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "Installed releases do not put it on your `PATH` ... Inside the Preview application bundle the program sits at `/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli`" | true | `ls "/Applications/Lungfish Preview.app/Contents/MacOS/"` returns `Lungfish` and `lungfish-cli`. Nothing installs a `PATH` shim | |
| "If you build from source instead, the SwiftPM product lands at `.build/debug/lungfish-cli`" | true | The binary under review is exactly that path | |
| "The runner has to be macOS 26 or later ... `lungfish-cli workflow run` says so in its own help text" | true | `workflow run --help` prints "Workflows are executed using Apple Containerization (macOS 26+)", and the `workflow` parent prints "Requires macOS 26 or later for container support" | |
| "On GitHub Actions that is the `macos-26` runner label, which is the label this project's own CI file uses" | true | `.github/workflows/ci.yml` lines 37, 103, 114, 141 all read `runs-on: macos-26`. `pages.yml` uses `ubuntu-latest`, but no job there runs LGE | |
| "Which of the two a job needs is decided by the `--executor` flag ... it is the single most important choice in this appendix" | **false** | `--executor` reaches only the nf-core route. `WorkflowCommand.swift:426-447` sends a local `.nf` or `Snakefile` to `runLocalWorkflow`, which never reads `executor`. My verified run's `manifest.json` `commandPreview` is a bare `nextflow run ...` with no container and no executor. The chapter itself says so at its own `--executor` bullet, so the opening contradicts line 90 | "Which of the two a job needs depends on the route the workflow takes. A local `.nf` file or `Snakefile` runs the engine directly from the conda-installed tools and needs no container runtime at all. Only an nf-core run reads `--executor`, described below, and its default of `docker` is what makes a container runtime a requirement on that route." |
| "`lungfish-cli tools update --plan` ... exits 10 when work is pending and 0 when there is nothing to do" | true | `cli-help/tools.txt` `==== tools update ====` "Exit codes: 0 nothing to do ... 10 work is pending (--plan only)". My run exited 10 | |
| The four-line `tools update --plan` output block | true | Reproduced byte for byte, including "Target dependency set: 2026.2", the `preserve bracken` pair, the `reinstall gatk-core` line, and "Estimated download: 157.3 MB" | |
| "`tools update --apply --yes --required-only` installs what cannot be deferred, and `--yes` is required" | true | `cli-help/tools.txt` "2 usage error, such as --apply without --yes" and the `--required-only` description | |
| "This project's own CI file uses exactly that line, followed by `lungfish-cli conda install --pack <id>` ... and `lungfish-cli conda db download Viral`" | true | `ci.yml` "Provision required tools" runs `tools update --apply --yes --required-only`, "Provision conformance packs" runs seven `conda install --pack <id>` lines, "Provision Kraken2 viral DB" runs `conda db download Viral` | |
| "`lungfish-cli debug env --check-tools` prints the runner's macOS version, core count, memory, and architecture, then reports each bioinformatics tool as found with its version or as not found" | true | My run printed macOS Version, CPU Cores, Physical Memory, Architecture, then a tool list with versions or `not found`. Exit 0 | |
| "`lungfish-cli debug container` reports whether the Apple Containerization framework is available and ready" | true | My run printed "Apple Containerization framework available" and "Status : Ready". Exit 0 | |
| "Its own help text describes it as a thin alias for `lungfish-cli workflow run --quiet <workflow> ...`" | true | `run-headless --help` line 3 is that sentence verbatim | |
| "the `argv` field it stores reads `workflow run ... --quiet` rather than `run-headless`" | true | My sidecar's `argv` is `['lungfish-cli','workflow','run', ..., '--quiet']` | |
| "only three shapes are accepted. A Nextflow file with a lower-case `.nf` extension, a file whose name contains `snakefile` in any case, or the one built-in nf-core pipeline" | true | `WorkflowCommand.swift:425-426` and `:456-458`. A fourth branch fires on `workflow.contains("nf-core")` but `validateViralReconWorkflowName` (`:775-789`) rejects everything but `viralrecon` and `nf-core/viralrecon`, so the reachable set is the three named | |
| "Nothing else is recognised." | true | `runLocalWorkflow` guards `isNextflow \|\| isSnakemake` and otherwise throws `unsupportedFormat` (`:456-458`) | |
| The worked `run-headless` command and its exit 0 | true | Rerun verbatim in my scratch. Exit 0 | |
| "It exited 0 and printed one line, the path of the run bundle it created." | true | Sole stdout line was `/Users/dho/lge-scratch/running-in-ci-review/bundles/main.lungfishrun` | |
| The `--expected-output` refusal message and "That refusal exited 64" | true | Reproduced. Exit 64, text identical (the chapter's line break is cosmetic; the CLI emits one line) | |
| "`--quiet` did not suppress it" | true | `run-headless` passes `--quiet` and the error still printed | |
| "`--executor` picks the execution profile for an nf-core run from `docker`, `conda`, or `local`, defaulting to `docker`" | true | `cli-help/workflow.txt` `==== workflow run ====`. Agrees with the sibling chapter line 126 | |
| "`--dry-run` validates the workflow and prints the plan without running anything, and it exits 0 without an expected output" | true | My `workflow run ... --dry-run` exited 0 with no `--expected-output` | |
| "`--prepare-only` ... is the one flag that formally waives the expected-output requirement" | true | Sibling chapter line 148 and line 186, both run-verified and binding | |
| "`--timeout` sets a ceiling in minutes, but a local run accepts it without enforcing it and an nf-core run rejects it outright" | true | Sibling chapter line 150, run-verified and binding | |
| "`--resume` continues a repeated run from the last checkpoint" | true | Sibling chapter line 138 | |
| The four-line dry-run output block | **false** | The real output has five lines. It opens with `ℹ Preparing workflow: hello-world-nextflow.lungfishflowpkg/main.nf`, which the chapter omits, and the `Workflow:` line prints the path as given, not the elided `.../hello-world-nextflow.lungfishflowpkg/main.nf` the chapter shows | Reproduce all five lines, or say the first line is omitted. The `Workflow:` value is the literal argument, so with the chapter's own command it reads `hello-world-nextflow.lungfishflowpkg/main.nf` |
| "`LUNGFISH_CONDA_ROOT` sets the folder holding conda environments, and `LUNGFISH_STORAGE_ROOT` sets the managed storage root" | true | `ManagedStorageConfigStore.swift:154-160` and `:184-195` | |
| "LGE reads the two together, so a job that overrides one usually wants to override both." | true | `currentCondaRootURL(environment:)` falls back to `currentLocation(environment:).condaRootURL`, so `LUNGFISH_STORAGE_ROOT` alone moves the conda root too, and both are checked as a pair at `:136-140`. The advice follows | |
| "`NCBI_API_KEY`, is worth setting on any job that fetches records from NCBI" | true | `NCBIService.swift:82-90` `resolve(explicitAPIKey:environment:)` reads `environment["NCBI_API_KEY"]` | |
| "Every command accepts `--format json`, which is how a CI step reads a result ... two commands used in this appendix, `conda packs` and `ops stats`, print their ordinary text and exit 0 whatever `--format` says." | **false** | The exception is far wider than two commands. `workflow list --nf-core --format json`, `conda offline-export --format json`, and `version --format json` all printed ordinary text and exited 0 in my runs. Naming only two commands tells a CI author the rest are safe, and they are not | "`--format json` is declared on almost every command, but many commands accept it and print their ordinary text anyway. `conda packs`, `ops stats`, `workflow list`, `conda offline-export`, and `version` all did so on the 2026.9.13 build. Check the output of any command before a CI step parses it. `tools update` is the exception worth knowing, since it carries its own `--json` flag." |
| "It names the directory the pack directory is written *into*, not the pack directory itself." | true | `cli-help/conda.txt` `-o, --output` "Directory where the offline pack directory will be written". My `--output ./packs-gatk` produced `./packs-gatk/gatk-core-conda-offline-pack` | |
| "Exporting the `gatk-core` pack with `--output ./packs-gatk` ... exited 0 and reported the pack at `./packs-gatk/gatk-core-conda-offline-pack`, alongside its `offline-pack-manifest.json` and its own `.lungfish-provenance.json`" | true | Reproduced exactly, all three paths | |
| "it does carry its own provenance, recording the pack id, the source conda root, the exporting command, and a SHA-256 checksum and byte size for every file in the exported environments" | **false** | Those fields are split across two files, and the sentence attributes all of them to the provenance record. `.lungfish-provenance.json` holds `packID`, `packName`, output paths and kind, but its `files` list is empty (0 entries) and it has no `sourceCondaRoot` and no `reproducibleCommand`. `offline-pack-manifest.json` is what holds `sourceCondaRoot`, `commandLine`, and a `files` list of 5,755 entries each with `relativePath`, `sha256`, and `sizeBytes` | "it carries two records. `offline-pack-manifest.json` holds the pack id, the source conda root, the exporting command line, and a SHA-256 checksum and byte size for every file in the exported environments. The `.lungfish-provenance.json` beside it records the export as an operation, naming the pack and the output paths." |
| The `offline-install` example and "`--overwrite` replaces environments whose names already exist" | true | `cli-help/conda.txt` "Replace existing environments with matching names". `CondaOfflinePackService.swift:292-297` throws "Environment '<name>' already exists. Re-run with --overwrite to replace it." otherwise | |
| "Asking for a pack named `classification`, which does not exist, exited 3 and listed the ones that do." | true | Reproduced. Exit 3, and the eight ids listed exactly (the chapter's three-line wrap is cosmetic, the CLI emits two lines) | |
| "For a Kraken2 read-classification job the pack is `metagenomics`." | true | `conda packs` lists Metagenomics (metagenomics) with kraken2, bracken, esviritu, ribodetector | |
| "Three further ids that the tool lock manifest defines, `gatk-core`, `phasing`, and `wastewater-surveillance`, are accepted by `offline-export` even though that error message does not list them, so the listed eight are not the complete set" | **false** | The count is wrong and so is the source. `builtInPack(id:)` (`PluginPack.swift:406-408`) searches the whole `builtIn` array, which holds 18 ids, so ten are accepted but unlisted, not three. I exported `phasing` (exit 0) and `illumina-qc` (exit 0), and `illumina-qc` is not in the lock's `packTools` at all. `rna-seq` was also accepted as an id and failed later on a missing environment rather than on the id | "Ten further ids are accepted by `offline-export` even though the error message omits them, because the id lookup searches the whole built-in pack list while the message prints only the eight the CLI shows. Three of them, `gatk-core`, `phasing`, and `wastewater-surveillance`, are real packs the tool lock manifest defines and are the ones worth knowing. The rest name environments the build does not install, so an export of one fails on a missing environment rather than on the id." |
| "An offline pack carries tools and not databases ... `conda db download <name>` ... or `conda db install-managed <identifier>`" | true | `cli-help/conda.txt` `==== conda db ====` lists both subcommands. `ci.yml` uses `conda db download Viral` and `conda db install-managed deacon-panhuman` | |
| "`conda export-pack` ... calls the identical code, differing only in that its `--output` also accepts a `.tar`, `.tgz`, or `.tar.gz` archive path" | true | `cli-help/conda.txt` shows identical OVERVIEW and option sets, with `export-pack`'s `--output` reading "Offline pack output directory, .tar, .tgz, or .tar.gz archive" against `offline-export`'s "Directory where the offline pack directory will be written" | |
| "The file below is a template to adapt, not a run performed for this appendix." (GitHub Actions) | true | The chapter states this plainly, and again for CircleCI at "This is likewise a template rather than a run" | |
| "Every flag in it was verified individually against the 2026.9.13 build" | true | Each CLI line in the template uses flags I verified above | |
| The GitHub Actions cache step as written | **false** | `actions/cache@v4` with only `path` and `key` and no `restore-keys` never gets populated, because the template has no step that writes into `.ci/lungfish-conda-packs`. Worse, `hashFiles('.ci/lungfish-conda-packs/**')` returns an empty string when the folder is absent, so the key is the constant `lungfish-conda-packs-`, and the "Install the cached pack" step then runs against a directory that does not exist and fails the job on the first run. The CircleCI template does not have this problem, because its `save_cache` step saves the folder | Either commit the pack to the repository and drop the cache step, or restore from a cache the workflow itself populates. If the pack is committed, the step is just `actions/checkout` and the key line goes away. If it is built in the job, add the `offline-export` step before the cache save and give the cache step a `restore-keys` fallback |
| "The `tools update --plan` step fails the job on exit 10, which is what makes it an assertion instead of a report." | true | A GitHub Actions `run` step fails on any nonzero exit, and `--plan` exits 10 when work is pending | |
| "The upload step carries `if: always()` so a failed run still yields its logs" | true | `if: always()` is the documented GitHub Actions condition for running a step regardless of prior failure, and `ci.yml` uses it on all three of its upload steps | |
| "CircleCI splits caching into separate restore and save steps and has no equivalent of the `always()` condition, so failure artifacts need `when: always` on the storing step." | **false** | The second half inverts CircleCI's schema. `when` is a key of the `run` step, not of `store_artifacts`, which takes `path` and `destination` only. CircleCI does have a job-level `when` and a step-level `when` on `run`, so the sentence's premise about `always()` is also loose. No CircleCI config exists in this repository to compare against, and the service cannot be reached here, so this is settled from the documented step schema rather than a run | "CircleCI splits caching into separate restore and save steps. `store_artifacts` runs as part of the step list and takes only `path` and `destination`, so to keep artifacts from a failed job put the storing step inside the job and let CircleCI's own step ordering reach it, or guard an earlier `run` step with `when: always` rather than the storing step." Then drop `when: always` from `store_artifacts` in the template |
| "Do not cache a live conda root across jobs and let several jobs write to it." | true | Sound advice, and consistent with `ci.yml`, which caches `~/.lungfish/conda` in exactly one job keyed on the manifest hash | |
| "the sidecar was written *inside* the bundle at `hello-world-nextflow.lungfishref/.lungfish-provenance.json`, with a second copy of the bundle's own record under `hello-world-nextflow.lungfishref/provenance/`" | true | `ls -a` of my run's bundle shows `.lungfish-provenance.json`, `genome`, `manifest.json`, `provenance/`, and `provenance/` holds `bundle.lungfish-provenance.json` | |
| "A CI artifact step that globs for `*.lungfish-provenance.json` beside the output will therefore find nothing." | true | Follows from the above. Nothing sits beside the bundle | |
| The sidecar field list (workflow name, tool name and version, full `argv`, resolved options, runtime identity with application version, architecture, OS version, dependency set, and user, a `files` list with role, SHA-256, and byte size, exit status, start and end times, wall time, captured stderr) | true | Every field present in my sidecar. `runtimeIdentity` carries `appVersion`, `architecture`, `dependencySet` (`2026.2`), `operatingSystemVersion`, `user`, plus `executablePath` and `processIdentifier` the chapter does not claim. `files` entries carry `role`, `sha256`, `sizeBytes` | |
| "That list is the same one the Power-user notes and File formats appendices give" | true | `power-user-notes.md:237-239` and `:259` give the same fields. Both linked files exist | |
| The `ops stats` output block | **false** | The real output carries a `Project` line the chapter's block omits, printing `Project : <path>` immediately after the blank line following "Operation Stats". Everything else matches, including `<1s` and `unknown` | Add the `Project` line to the quoted block, or say the path line is omitted |
| "Peak RAM reading `unknown` is expected rather than a fault, because the local workflow adapters do not record it." | true | Sibling chapter line 254, run-verified and binding | |
| "`ops stats` exits 0 even when it is given an option it does not understand" | true | `ops stats ./nf-results --nonsense-flag` printed "Error: Unknown option '--nonsense-flag'" and a usage line. Confirms the sibling's finding at line 254 | |
| The `provenance verify` error block and "it exited 64" | true | Reproduced. Exit 64, message identical (chapter's line break cosmetic) | |
| "It verifies a *signed* sidecar, and signing is off by default." | true | The error names a missing `.signature.json` artifact. Sibling chapter line 168 says LGE "signs that record when a signer is configured and leaves it unsigned otherwise, and signing is off by default" | |
| "check the sidecar's `exitStatus` field and the presence of the declared outputs instead" | true | `exitStatus` is present in my sidecar with value 0 | |
| "`workflow run` detects Nextflow by a lower-case `.nf` extension only, so `pipeline.NF` is not seen as Nextflow even though `workflow validate` lowercases the extension first and does see it" | true | `WorkflowCommand.swift:425` `workflowURL.pathExtension == "nf"` against `:1233` `url.pathExtension.lowercased()`. Agrees with the sibling | |
| Defect 3, "The `wallTimeSeconds` field ... held a very small negative number" | true | My run's value was `-5.9604644775390625e-06`. The author saw `-6.9141387939453125e-06`, so the exact digits vary per run and the chapter is right not to quote them | |
| Defect 3, "The `startTime` and `endTime` fields are sound." | true | Both present as ISO 8601 UTC strings | |
| Defect 4, "`debug env --check-tools` reports Nextflow's version by printing Nextflow's own complaint about the version flag" | true | My run printed `✓ nextflow: Unknown option: --version=true -- Check the available commands and options and syntax with 'help' - Workflow engine` | |
| Defect 4, "Every other tool row reports a real version." (implied by "without telling you which release it is") | true | `snakemake: 8.26.0`, `samtools 1.24`, `bcftools 1.23.1`. Absent tools read `not found` | |
| "Six failures account for most red CI jobs" and the six signatures that follow | true | Each restates a claim verified above. The count matches the six paragraphs | |
| "Four rough edges in the 2026.9.13 build" | **false** | The section then lists four items, but the chapter's body raises six findings, and two of the four listed are themselves understated (see the `--format json` and pack-id rows). The count also disagrees with the author's own report, which records six | Either raise the count to match what the section lists after the corrections above, or drop the number and open with "The rough edges in the 2026.9.13 build worth knowing are these, and none of them prevents a working CI job." |

## Front matter

`chapter_id` matches the path. `audience: power-user` matches the roster
row. Both `prereqs` resolve to real files,
`01-foundations/08-provenance-and-reproducibility.md` and
`08-workflows/03-running-external-workflows.md`, and the second is the right
one to name given how heavily the chapter leans on it.

All eleven `glossary_refs` slugs resolve in `GLOSSARY.md`: `conda` (133),
`container` (147), `continuous-integration` (153), `dependency-set` (185),
`environment-variable` (211), `exit-status` (217), `offline-pack` (451),
`plugin-pack` (501), `provenance-sidecar` (523), `run-bundle` (597),
`workflow-engine` (739).

`entry_points` names three CLI commands that all exist. `tools: [nextflow,
snakemake]` matches the two engines the lock manifest pins (nextflow
26.04.6, snakemake 9.25.2). `shots`, `illustrations`, `features_refs`, and
`fixtures_refs` are empty, which the DRIFT screenshot row endorses for a
YAML-and-shell chapter. `brand_reviewed` and `lead_approved` are false,
correct at this stage. `estimated_reading_min: 14` is plausible for the
length.

No `parameters_refs` key. The roster row says no registry ids, and the
chapter documents CLI flags rather than a dialog's settings, so the campaign
rule requiring a `parameters_refs` citation does not bite here.

The four glossary entries the author added are accurate and correctly
placed. `continuous-integration` sits between `contig-reference` and
`coordinate`, `dependency-set` between `demixing` and `depth`,
`environment-variable` between `ena` and `error-correction`, and
`offline-pack` between `nvd` and `open-reading-frame`. Each matches the
house `See also:` shape. `dependency-set` naming `2026.2` is right, since
that is the lock's `dependencySet`. `environment-variable` naming all three
variables is right. `offline-pack` describing the pack as holding a manifest
and its own provenance record is right, and is the more careful phrasing
than the chapter body's own sentence on the same point.

## Consistency

`CONSISTENCY.md` holds no CI-specific ruling. The general rules are met.
"Lungfish Genome Explorer (LGE)" appears at first mention and "LGE" after.
The tool is `lungfish-cli` throughout, and where the chapter quotes help
text that says `lungfish` it is quoting, which is correct. Bundle
extensions are in code font. No menu paths appear, so those rules do not
apply. Lint is green under `LUNGFISH_MANUAL_STRICT=1`.

Against the sibling chapter, which wins on `workflow run`, `run-headless`,
`--expected-output`, `--bundle-root`, and `ops stats`, the appendix agrees
everywhere it overlaps. `--executor`'s values and default, the
expected-output requirement and its "names where to look" caveat,
`--timeout`'s two behaviours, `--prepare-only` as the formal waiver,
`ops stats` exiting 0 on an unknown option, Peak RAM reading `unknown`, the
lower-case `.nf` detection, and `run-headless` printing only the bundle
path all match.

One divergence is worth flagging to the editor rather than charging to this
chapter. The sibling says at line 168 and again at line 176 that each
`--expected-output` path "receives its own `.lungfish-provenance.json`
sidecar written beside it". For a bundle output that is not what happens,
as this appendix correctly documents and as my run confirms, since the
sidecar lands inside the bundle. The appendix is right and the sibling's
"beside it" is the loose one. Because the sibling is binding, the appendix
should not be changed, but the sibling needs the qualification added in its
own pass.

The appendix's own `--executor` bullet agrees with the sibling. Its opening
paragraph does not, which is the internal contradiction recorded in the
claim table.

## App defects

Confirmed, and worth filing.

1. `--format json` is accepted and ignored far more widely than the chapter
   says. Verified on `conda packs`, `ops stats`, `workflow list`,
   `conda offline-export`, and `version`, all printing ordinary text and
   exiting 0. Every one of these declares `--format <format>` with `json`
   among its values. This is the same defect the sibling chapter found on
   `ops stats`, and it is not command-specific.

2. `conda offline-export --pack <id>` accepts any of the 18 ids in
   `PluginPack.builtIn`, while the unknown-pack error lists the 8 in
   `visibleForCLI`. `builtInPack(id:)` at `PluginPack.swift:406-408` does
   `builtIn.first { $0.id == packID }` with no visibility filter, while the
   error is built from the visible subset. Verified by exporting `phasing`
   and `illumina-qc` (both exit 0) and `rna-seq` (accepted as an id, then
   failed with "Conda environment 'salmon' not found", which is a
   post-lookup failure). Either filter the lookup to `visibleForCLI` plus
   the experimental packs, or list what the lookup actually accepts.

3. `wallTimeSeconds` in a local workflow run's sidecar is a small negative
   float. Mine was `-5.9604644775390625e-06`, the author's
   `-6.9141387939453125e-06`. The magnitude is at float epsilon, so this
   reads as a subtraction of two nearly equal timestamps in the wrong
   order or across a precision boundary. `startTime` and `endTime` are
   sound, and `exitStatus` is sound.

4. `debug env --check-tools` probes Nextflow with `--version=true`, which
   Nextflow rejects, so the row reads
   `✓ nextflow: Unknown option: --version=true -- Check the available
   commands and options and syntax with 'help' - Workflow engine`. Presence
   is confirmed, version is never reported. Every other tool row reports a
   real version.

5. For a bundle output, the `--expected-output` sidecar is written inside
   the bundle rather than beside it, so a CI glob of
   `*.lungfish-provenance.json` next to the output finds nothing. This is
   arguably correct behaviour rather than a defect, since a bundle is a
   folder, but it is a documentation trap and the chapter is right to name
   it.

6. `provenance verify` handles only signed sidecars and exits 64 on an
   unsigned one, while signing is off by default. The command name invites
   exactly the wrong CI use.

New, not in the author's list.

7. The `.lungfish-provenance.json` an offline export writes has an empty
   `files` list and no `reproducibleCommand`, while the run-workflow
   sidecar for the same build populates both. The checksums, sizes, and
   command line are only in `offline-pack-manifest.json`. If the export's
   provenance record is meant to be a peer of the workflow sidecar, it is
   missing its two most useful fields. This is what makes the chapter's
   sentence on pack provenance false, so the fix is either in the app or in
   the prose, and the prose fix is given in the claim table.

Recorded and not charged to this chapter. The author's `provision-tools
--status` observation, that a debug build invoked outside its package
directory reports its output directory as
`/var/folders/.../T/Sources/LungfishWorkflow/Resources/Tools`, is a real
oddity. The command is not cited in the chapter, which is the right call.

## Notes for the editor

The chapter is close to publishable and the corrections are surgical. Six
edits, in the order they appear.

The opening paragraph's `--executor` sentence contradicts the chapter's own
bullet 90 pages later. Take the corrected wording from the claim table. This
is the one change that alters an argument rather than a fact, so it wants a
second read.

The `--format json` paragraph needs its exception widened from two commands
to a general caution, or a CI author will trust the wrong output.

The offline-pack provenance sentence needs the manifest and the provenance
record separated. The chapter's own glossary entry for `offline-pack` already
gets this right, so the two should be brought into line.

The "three further ids" sentence needs to become ten, with the three real
packs still called out by name, because three is the count of useful ones and
ten is the count of accepted ones and the chapter currently conflates them.

Two quoted output blocks are missing a line each. The dry run is missing its
`ℹ Preparing workflow:` opener, and `ops stats` is missing its `Project`
line. Both are easy to restore from the runs.

The GitHub Actions template's cache step cannot work as written. That needs
a decision from the author about whether the pack is committed or built in
the job, and the CircleCI template's `when: always` on `store_artifacts`
should come off.

The "Four rough edges" count no longer matches after these corrections.

Nothing else in the chapter needs touching. The worked runs, the exit
statuses, the error text, the sidecar field list, the ci.yml reading, and
the reversal of emphasis from offline packs to install-and-cache are all
correct and well evidenced.

## Counts

True 47. False 8. Unverifiable 0.

Front matter, all sixteen keys correct, all eleven glossary slugs resolve,
all four new glossary entries accurate and correctly placed.

Defects confirmed 6 of 6, plus 1 new (empty `files` list and missing
`reproducibleCommand` in the offline-export provenance record).
