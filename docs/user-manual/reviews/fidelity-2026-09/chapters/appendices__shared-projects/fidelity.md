# Fidelity review: appendices/shared-projects

Chapter: `docs/user-manual/chapters/appendices/shared-projects.md`
Roster row 65. Reviewed against Preview 2026.9.13, the Swift source, and live CLI runs.
Review date: 2026-09-07.

Independent rerun. All 24 author commands were rerun on a fresh copy of the demo
project at `/Users/dho/lge-fidelity-scratch/shared-projects/Demo.lungfish`, copied
from `~/Desktop/lge-docs/LGE Manual Demo.lungfish`. The demo project was read only
(its lock file was read, never written) and is unchanged. CLI binary
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`. Every
quoted output line and exit status in the chapter reproduced, with one exception
recorded as claim 31 below.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | A project is a `.lungfish` folder and nothing prevents two people opening it at once | true | Lock is advisory only. `ProjectLock.swift:164-188` uses `O_CREAT \| O_EXCL` on a file inside the bundle, with no kernel-level exclusion | |
| 2 | "The record lives at `.lungfish/project.lock` inside the project folder" | true | `ProjectLock.swift:108-112` `lockURL(for:)` appends `.lungfish` then `project.lock` | |
| 3 | "The lock is advisory, meaning it works only because every LGE process agrees to check it" | true | No `flock`/`fcntl` in the lock path. `acquireLock` writes a plain file; `status(of:)` reads it by choice | |
| 4 | Read-only means every viewport opens, every bundle is inspectable, no writing operation starts | true | `ProjectWriteGatePresenter.swift:52-54` blocks the workflow at run time only; no viewport gating | |
| 5 | "You see the state two ways", the `(Read Only)` title and a banner | true | `AppDelegate.swift:609` and `:673` both append `" (Read Only)"`; `ProjectLockWarningPresentation.swift:17` sets the banner title | |
| 6 | A bundle carries a manifest naming what it holds, with a schema version | true | `BundleManifest.swift:112-120` `formatVersion`; `ProjectLock.swift:36` `schemaVersion` | |
| 7 | Dialog is titled with the project's own name and the words "may already be open" | true | `ProjectLockResolutionDialog.swift:44` `"“\(name)” may already be open"` | |
| 8 | Active text reads "Another session is using this project. You can open it read-only to inspect it. Close the other session and try again to make changes." | true | `ProjectLockResolutionDialog.swift:50`, verbatim match | |
| 9 | Corrupted text says the lock information is damaged so LGE cannot tell whether another session is using it | true | `ProjectLockResolutionDialog.swift:52`, paraphrase is faithful | |
| 10 | The dialog offers up to three buttons, Open Read-Only (default), Cancel, Recover and Open | true | `ProjectLockResolutionDialog.swift:63-67`. Open Read-Only carries `keyEquivalent = "\r"` | |
| 11 | "**Recover and Open** appears only when recovery is possible, meaning when the lock is not from a live local process" | **false** | `canRecover` (`ProjectLockResolutionDialog.swift:99`) is `lockStatus != .active && (lockRecord != nil \|\| lockStatus == .corrupted)`. The read-error path (`ProjectOpenWarningState.swift:78-83`) yields `.unknown` with a nil record, which is not a live local process yet still shows no button. The stated rule also implies a stale lock shows the button, but `evaluate` returns `.unlocked` for stale (`:68-70`), so no dialog appears at all | "**Recover and Open** appears when the lock is not held by a live process on this Mac and LGE could still read a lock record, or when the record is corrupted. It does not appear when the lock file could not be read at all." |
| 12 | Below the buttons a details block names session, owner and host and process number, lock creation time, project path | true | `ProjectLockResolutionDialog.swift:104-110` builds exactly those lines | |
| 13 | Recovery raises a second confirmation | true | `ProjectLockResolutionDialog.swift:35-38` presents `makeRecoveryConfirmation` unless status is `.stale` | |
| 14 | It warns in these words that "Recovering a lock while another session is writing can damage the project." | true | `ProjectLockResolutionDialog.swift:85`, verbatim substring | |
| 15 | It asks you to ensure the project is closed in other LGE versions, in the CLI, and on other computers, and adds that an archive is kept | true | `ProjectLockResolutionDialog.swift:85`, faithful paraphrase (paraphrased to avoid the bare word "Lungfish", per the author's lint note) | |
| 16 | Recovery moves the record into a `lock-recovery` folder under the project's `.lungfish`, in a uniquely named subfolder, with `recovery.json` beside it | true | `ProjectLockRecovery.swift:79-84`, `lock-recovery/<UUID>/project.lock` plus `recovery.json` | |
| 17 | `recovery.json` holds the reason, time, original path, a checksum of archived bytes, and the recovering session's record | true | `ProjectLockRecovery.swift:94-99` `RecoveryRecord(schemaVersion:reason:timestamp:originalPath:archivePath:sha256:sizeBytes:operatorRecord:)` | |
| 18 | Banner is titled "Project opened read-only" with a detail naming tool, status, mode, owner and host, pid, creation time, ending "Project-writing workflows are blocked to protect shared storage." | true | `ProjectLockWarningPresentation.swift:17` and `:28-30`, verbatim | |
| 19 | Blocked-write sheet is titled **Project Is Open Read Only** and names the workflow | true | `ProjectWriteGatePresenter.swift:22` title, `:52-54` message interpolates `workflowName` | |
| 20 | A folder built only by `lungfish-cli` opens read-only for a missing project store, with no banner | true | `AppDelegate.swift:609` gates the suffix on `isNativeProject`; the banner is built only from `ProjectOpenWarningState` (`ProjectLockWarningPresentation.swift:15`), which needs a lock. Consistent with `01-foundations/06:68` | |
| 21 | Four states: active, stale, unknown (every lock on a different machine), corrupted | true | `ProjectLock.swift:8-13`; `status(of:)` `:200-224` returns `.unknown` when `isLocalMachine` fails, `.stale` on differing start time or `ESRCH` | |
| 22 | `project lock` on success prints three lines and exits 0 | true | Rerun: `Locked project:` / `Lock file:` / `Mode: exclusive`, exit 0. `ProjectCommand.swift:122-126` | |
| 23 | The record holds twelve fields in the order listed | true | `ProjectLock.swift:36-47`, twelve stored properties in that exact order; rerun record carried all twelve | |
| 24 | `--format json` prints the record instead of the three lines | true | `ProjectCommand.swift:118-121`; rerun confirmed | |
| 25 | Sample JSON block with `machineIdentifier` and `appVersion: "lungfish-cli 2026.9.13"`, `toolName: "lungfish project lock"` | true | My own run produced an identical record shape and identical `machineIdentifier` `38750482-9E30-587B-9B7D-5ADBCB1CF8B2`. `ProjectCommand.swift:103` sets the tool name; `:317` builds the version string | |
| 26 | `machineIdentifier` is opaque, host is not trustworthy, the same Mac reported `raven.local` and a long provider-assigned name seconds apart | true | Independently reproduced. My run at 14:26:11Z recorded `host: syn-2600-6c44-...spectrum.com`, my run at 14:26:18Z recorded `host: raven.local`, same `machineIdentifier` both times. `ProjectLock.swift:332-374` prefers the identifier | |
| 27 | LGE compares the identifier first and falls back to hostname only for records lacking it | true | `ProjectLock.swift:332-374` `isLocalMachine` | |
| 28 | `mode` defaults to `exclusive`, is a label not a permission level, nothing reads the string to grant or withhold | true | `ProjectCommand.swift:40` default; rerun without `--mode` printed `Mode: exclusive`. No comparison against the mode string anywhere in the lock path; `status(of:)` ignores it | |
| 29 | A lock whose owner is still running blocks a second lock, exiting 1 and printing the owner | true | Rerun against a live owner (pid 11499): `Error: Project is already locked at ... by dho@raven.local pid 11499 mode exclusive.`, exit 1. `ProjectCommand.swift:76-78` | |
| 30 | `project lock` replaces a stale lock without complaint, and run twice in a row the second call succeeds | true | Rerun: lock `--mode exclusive` exit 0, then lock `--mode maintenance` exit 0, record replaced (pid 10667 to 10953). `ProjectCommand.swift:76` refuses only `.active` or `.unknown` | |
| 31 | Corrupt-unlock error block quoted verbatim at chapter line 143 | **false** | The chapter's code block uses ASCII apostrophes (byte `0x27`) in `couldn't` and `isn't`. The app emits U+2019 (`e2 80 99`), from Foundation's `NSCocoaErrorDomain` description. Verified by hexdump of chapter line 143 against live stderr | Replace the two straight apostrophes with typographic ones so the block matches app output byte for byte: `The data couldn’t be read because it isn’t in the correct format.` |
| 32 | A lock from another machine is recorded as unknown, blocks a second lock as active does, and clearing takes `--force` | true (not directly demonstrated) | `ProjectLock.swift:205-207` returns `.unknown` when `isLocalMachine` fails; `ProjectCommand.swift:76` treats `.unknown` like `.active`. Single-Mac testing could not stage a genuine remote lock, as the author states | |
| 33 | `lock --force` replaces without stale-owner checks, keeps no archive, verified exit 0 leaving only the new record | true | Rerun against a live owner (pid 12328): exit 0, and `.lungfish/` afterwards held only `project.lock`, no `lock-recovery`. `ProjectCommand.swift:76` short-circuits on `force` | |
| 34 | Without `--force`, unlock removes a lock in two cases only, own process or same user on this machine with an exited process | true | `ProjectLock.swift:226-245` `canRemoveWithoutForce`. Both sides reproduced, runs 9 and 19 | |
| 35 | Refusal message quoted, exit 1 | true | Rerun: `Error: Refusing to remove lock at ... owned by dho@raven.local pid 11499; pass --force to override.`, exit 1 | |
| 36 | "it appeared in testing for a lock owned by the same user on the same Mac. Same user is not enough." | true | My staged lock used `user: dho`, this machine's `machineIdentifier`, and a live pid, and was still refused | |
| 37 | A corrupted lock is refused too and the error names the reason | true | Rerun exit 1 with the corruption message. `ProjectCommand.swift:157-159` | |
| 38 | `--force` removes the lock in every case including corrupted, exiting 0, and deletes the file | true | Rerun: exit 0, `Unlocked project:` / `Removed lock file:`. `ProjectCommand.swift:160-166` | |
| 39 | `--force` does not stop the process that wrote the lock | true | `removeLockIfPresent` only unlinks. No signal is sent anywhere in the unlock path | |
| 40 | Unlocking with no lock prints `No project lock found:` with the path and exits 0 | true | Rerun exact match, exit 0. `ProjectCommand.swift:167-170` | |
| 41 | The `--dry-run` report block quoted at chapter lines 161-171 | true | Byte-identical on my copy apart from the project path, including all four bundle lines and the 4/1/2/0 counts | |
| 42 | The scan counts any folder whose extension begins with `lungfish` containing a `manifest.json`, reaching MSAs and trees | true | `ProjectCommand.swift:370-376` `isBundleDirectory`, `ext.hasPrefix("lungfish"), ext != "lungfish"` plus a `manifest.json` existence check. Settles DRIFT unverifiable 3 | |
| 43 | Five statuses with the meanings listed | true | `current` `:414`, `migration-available` `:434`, `migrated` `:517`, `unsupported` `:448`, `unreadable` `:392` | |
| 44 | "Those bundle types store their metadata under a different filename, so the migrator finds a `manifest.json` it cannot parse as a bundle manifest" | **false** | Both halves are wrong. A `manifest.json` **is** present in each bundle (19659 bytes in the `.lungfishmsa`, 2006 in the `.lungfishtree`), so the metadata is not under a different filename. And the decode failure reported in JSON is `"The data couldn’t be read because it is missing."`, a missing-key error, not a missing file. The tree manifest's keys are `bundleKind`, `primaryTreeID`, `tipCount` and so on, while `BundleManifest` (`BundleManifest.swift:112-160`) requires `formatVersion`, `source`, and `createdDate`. The bundles use the same filename for a different schema | "Those bundle types write their own kind of `manifest.json`, built for a tree or an alignment rather than for a reference. The migrator can only decode the reference manifest layout, so it reports the file it cannot read and moves on." |
| 45 | The two `unreadable` lines are not damage, they are reported and left untouched | true | `ProjectCommand.swift:387-403` returns a report with `action: "report-only"` and writes nothing. The conclusion stands even though claim 44's reasoning does not | |
| 46 | `Unsupported` counts both `unsupported` and `unreadable`, and `migration-available` is counted in no line, so 1 + 2 + 0 does not reach 4 | true | `ProjectCommand.swift:337-342`. The summary has only `inspected`, `current`, `unsupported`, `migrated`. Reproduced exactly | |
| 47 | The one fillable gap is a missing browser summary, a cache holding the chromosome list | true | `ProjectCommand.swift:434` and the JSON message "Bundle manifest predates browser_summary; migration would synthesize the cache without changing payload files." | |
| 48 | A reference manifest at format version 1.0 lacking it gets `migration-available` on a dry run and is filled on a real one | true | JSON dry run showed `formatVersion: "1.0"` with `migration-available`; the real run reported `migrated` | |
| 49 | The real run exits 0 and the line changes to `migrated (synthesized-browser-summary)` | true | Rerun exact match, exit 0. `ProjectCommand.swift:517-518` | |
| 50 | Two timestamped files land under the bundle's own `.lungfish/migrations/`, a `.manifest.json.backup` and a `.project-migrate-provenance.json` | true | Rerun produced `2026-09-07T142740553Z.manifest.json.backup` and `2026-09-07T142740553Z.project-migrate-provenance.json` in the bundle's directory. The project-level `.lungfish/` was empty. `ProjectCommand.swift:471-481`. Settles DRIFT unverifiable 4 | |
| 51 | The original manifest is copied to the backup before the new one is written, and the new manifest is put into place last | true | `ProjectCommand.swift:477-478` `copyItem` to backup, `:483` staged write, `:499` provenance, `:509` `replaceItemAt` last | |
| 52 | Rerunning the dry run reported that bundle as `current (none)`, so the command is safe to run twice | true | Rerun: the migrated bundle read `current (none)` and Current rose to 2 | |
| 53 | Unsupported legacy bundles read `dry-run-report` on a dry run and `report-only` on a real one, and nothing on disk changes | true | `ProjectCommand.swift:449` `action: dryRun ? "dry-run-report" : "report-only"`. Settles DRIFT 23. Not observed in output, since no demo bundle is genuinely `unsupported` | |
| 54 | `--format` accepts `text`, `json`, `tsv` on migrate; json gives per-bundle relative path, manifest path, format version, status, action, message, provenance sidecar | true | Live `--help` and the rerun JSON carried `path`, `manifestPath`, `formatVersion`, `status`, `action`, `message`, `provenanceSidecar` | |
| 55 | "`tsv` is accepted but currently prints the same text report rather than tab-separated values" | true | Rerun `--format tsv` output was byte-identical to the text report with no tab characters. `ProjectCommand.swift:277` `case .text, .tsv:` | |
| 56 | Taking and releasing a lock writes no provenance sidecar | true | No `ProvenanceRecorder` call in `LockSubcommand.run` or `UnlockSubcommand.run` (`ProjectCommand.swift:47-185`) | |
| 57 | Migration writes its provenance before the new manifest is in place, so the record describes the final file | true | `ProjectCommand.swift:499` `writeMigrationProvenance` precedes `:509` `replaceItemAt`. The output record's manifest sha `0ce4c69d8c7b` is the post-migration file | |
| 58 | The record covers tool name and version, reproducible command, inputs with checksums and sizes, outputs including the backup, exit status, wall time, host and user, and parameters naming transformer and source and target schemas | true | Rerun record: step keys `toolName`, `toolVersion`, `command`, `inputs`, `outputs`, `exitCode` 0, `wallTime`; `runtime` holds `user` and `hostOS`; `parameters` holds `transformer`, `sourceSchema`, `targetSchema`, `backupManifest`. Inputs and outputs carry `sha256` and `sizeBytes` | |
| 59 | The bundle's original creation sidecar is left where it is | true | `.lungfish-provenance.json` survived the real run at 32080 bytes and appears as a migration *input*, never rewritten | |
| 60 | The wider provenance list is a requirement on migrations not yet written, not a description of today | true | Only one transformer exists (`migrateLegacyBrowserSummary`). Correctly framed per DRIFT 24 | |
| 61 | Dry-run and report-only results create no scientific output and report per bundle whether a sidecar was found | true | `provenanceSidecar` and `provenancePreserved` appear on every JSON entry, including both `unreadable` ones | |
| 62 | What good looks like, item 3, lock on a free project exits 0 with three lines and a second attempt against a live owner exits 1 naming that owner | true | Both halves reproduced. Correctly says "against a live owner", distinguishing it from the stale case in claim 30 | |
| 63 | See also, `cli-reference.md` exists | true | `docs/user-manual/chapters/appendices/cli-reference.md` present | |

## Front matter

Correct and complete.

- `chapter_id`, `title`, `audience`, `prereqs`, `task`, `tags` all well formed. Both prereq chapter files exist.
- `entry_points` lists the three subcommands with the `lungfish-cli` binary name, matching CONSISTENCY line 13.
- `shots` declares one shot, `shared-projects-read-only-banner`, and the body carries a matching `<!-- SHOT: ... -->` marker at line 65 in the read-only section. The caption names the `(Read Only)` title, the yellow banner, and the owner, host, process, and creation time, all of which the banner really renders (`ProjectLockWarningPresentation.swift:28-30`). The caption is accurate and the placement is right.
- `glossary_refs` lists eight terms. All eight anchors resolve in `GLOSSARY.md`, including the three the author flagged: `bundle-migration` (line 107), `schema-version` (line 699), `stale-lock` (line 743). Each of the three definitions is accurate against source. `stale-lock` correctly carries the CLI-lock-is-stale-immediately nuance.
- `features_refs: []` and no `parameters_refs`. Correct. These are CLI subcommands with no dialog, and `parameters.yaml` has no entry for the project command group.
- `fixtures_refs: [demo-project]` matches the fixture actually used.
- `tools: []` is right, since no managed tool is invoked.
- `brand_reviewed: false`, `lead_approved: false`, correct for this stage.

Note. `glossary_refs` omits `advisory lock`, which the `stale-lock` entry cross-references and which the body glosses inline at line 29 ("The lock is advisory, meaning..."). The inline gloss satisfies the reader rule, so this is optional rather than a defect.

## Consistency

Checked against `CONSISTENCY.md` and the two committed chapters.

- Naming. "Lungfish Genome Explorer (LGE)" at first mention (line 27), "LGE" after. No bare "Lungfish" in prose. The three appearances of bare "Lungfish" are inside quoted app strings and the `.lungfish` extension, which is correct.
- Binary name. `lungfish-cli` throughout, matching CONSISTENCY line 13 and live help. The author's decision to drop DRIFT false #4's suggested paragraph in favour of consistent naming is sound, since the suggested wording would have introduced a second name for the reader to track.
- Demo project. Named "the demo project" and located at `~/Desktop/lge-docs/`, matching CONSISTENCY lines 128-129. The Before you start paragraph at line 47 is byte-identical to the canonical version at `appendices/ai-assistant.md:53`.
- Prose rules. No em dashes or en dashes. No semicolons in prose (the single semicolon at line 135 is inside a verbatim error message). No colons inside a sentence. Lists are within the 5-bullet, 2-list caps, with one list per section at most.
- Lint. `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports no issues, exit 0. Reproduced.
- `08-workflows/01-the-workflow-builder.md:166` says a read-only project refuses the run and names the same two indicators, the `(Read Only)` title and the banner. Consistent. That chapter adds a second cause, a disk that has gone away, which this chapter does not contradict.
- `01-foundations/06-the-lungfish-project.md:68` gives the missing-project-store cause. Consistent with this chapter's line 69.
- `01-foundations/06-the-lungfish-project.md:125` says the **Project Is Open Read Only** message appears when the lock belongs to somebody else. This chapter is more precise, since that string is the blocked-write sheet title rather than the open-time dialog. Not a contradiction in this chapter, but worth chapter 6's attention.
- One real contradiction with chapter 6, at `06-the-lungfish-project.md:127`. Recorded under App defects as the author's finding 7.

## App defects

The author reported seven. I confirmed all seven independently and add one new one.

1. **The demo project ships holding a live GUI lock.** Confirmed. `~/Desktop/lge-docs/LGE Manual Demo.lungfish/.lungfish/project.lock` holds `pid 57785`, `toolName "Lungfish ProjectStore"`, `mode "write"`, `processStartTime "Sun Sep  6 17:22:58 2026"`. I verified that pid is live: `ps -p 57785` returns `/Applications/Lungfish Preview.app/Contents/MacOS/Lungfish` started at exactly that time, so `status(of:)` returns `.active`. My `cp -R` inherited the record verbatim. A reader copying the demo project gets an active-status read-only window naming a process unrelated to their copy. Real, and worth fixing in the fixture build script.
2. **`project lock` twice in a row both succeed.** Confirmed. My two consecutive locks both exited 0 (pid 10667 then 10953), the second replacing the first. Correct per `ProjectCommand.swift:76`, which refuses only `.active` and `.unknown`, and a just-exited CLI process is `.stale`.
3. **`host` is not stable within one session.** Confirmed and independently reproduced inside my own run. Seven seconds apart on one Mac: `syn-2600-6c44-007f-9884-a1db-cec4-61d4-8c8f.biz6.spectrum.com` then `raven.local`. `machineIdentifier` identical both times, so correctness is unaffected, but the banner and both error messages interpolate `record.host` (`ProjectLockWarningPresentation.swift:29`, `ProjectCommand.swift` error strings) and can name a host the reader does not recognise.
4. **`--format tsv` prints the text report.** Confirmed on migrate: output byte-identical to text, no tab characters. `ProjectCommand.swift:277` and `:125` both branch `case .text, .tsv:`. The flag is advertised in help for all three subcommands and does nothing on any of them.
5. **Migrate summary counts do not reconcile.** Confirmed. `ProjectCommand.swift:340` folds `unreadable` into `unsupported`, and no summary field counts `migration-available`, so the demo project reports 4 inspected against 1 + 2 + 0.
6. **`lock --force` leaves no archive.** Confirmed. After forcing past a live owner, `.lungfish/` held only `project.lock`. The GUI path archives to `lock-recovery/<UUID>/` with a `recovery.json` receipt (`ProjectLockRecovery.swift:79-104`). A real asymmetry between the two paths.
7. **Chapter 6 contradicts this chapter.** Confirmed. `01-foundations/06-the-lungfish-project.md:127` reads "The window has no button for this yet, so a stale lock is cleared from the command line." The button exists as **Recover and Open** (`ProjectLockResolutionDialog.swift:66`), wired into the live open path through `ProjectLockOpenResolution.resolve` at `AppDelegate.swift:541`. The author's nuance is right and worth carrying to chapter 6: because `ProjectOpenWarningState.evaluate` returns `.unlocked` for a plain stale lock (`:68-70`), a stale lock never raises the dialog, so chapter 6's sentence is accidentally true for the stale case it names while being wrong about the window in general.

**New (8). A stale lock cannot be recovered from the window at all, and the CLI is the only route.** Not a chapter error, and adjacent to finding 7 rather than the same thing. `evaluate` returns `.unlocked` for `.stale` (`ProjectOpenWarningState.swift:68-70`), so the project opens read-write and the dialog never appears. Meanwhile `ProjectLockResolutionDialog.swift:35` explicitly skips the recovery confirmation when `lockStatus == .stale`, and `ProjectLockRecovery.recover` accepts a stale snapshot. So there is dead code for a stale-lock recovery flow that the open path can never reach. Harmless today, since a stale lock does not block the reader, but the two components disagree about whether stale is a state the dialog handles, and a future change to `evaluate` would silently activate an untested path.

## Notes for the editor

Two corrections are needed before this chapter is handed on, plus one optional tightening.

1. **Line 182, the `unreadable` explanation, is wrong on the facts** (claim 44). The chapter says those bundle types "store their metadata under a different filename". They do not. Both bundles contain a `manifest.json` at the standard name, 19659 bytes for the `.lungfishmsa` and 2006 for the `.lungfishtree`, holding a tree-shaped or alignment-shaped schema (`bundleKind`, `primaryTreeID`, `tipCount`) rather than the reference schema `BundleManifest` decodes. The JSON message is `"Manifest could not be decoded: The data couldn’t be read because it is missing."`, which is a missing-required-key error and not a missing file. The conclusion the paragraph draws is still right, so only the explanation needs replacing. Suggested wording is in the claim table.

2. **Line 143 misquotes app output by one character class** (claim 31). The code block uses ASCII `'` where the app emits `’`. Since the block is presented as verbatim stderr and a reader may grep for it, the two apostrophes should be typographic. Worth a scan of the chapter's other quoted blocks, though line 143 is the only one affected here.

3. **Line 57's Recover and Open rule is incomplete** (claim 11). "not from a live local process" is necessary but not sufficient, since `canRecover` also needs a readable record or a corrupted status. The read-error case is not-live and shows no button. Suggested wording is in the claim table. This is the least urgent of the three, since the omitted case is rare, but the current sentence would leave a reader hunting for a button that will not appear.

Everything else in the chapter survived rerun and source checking without amendment. The author's handling of the four DRIFT unverifiables is correct in all four cases, and the two that mattered most, migration scope and backup location, I confirmed independently by running the scan and listing the bundle's own `.lungfish/migrations/`. The decision to document defects 2, 4, and 5 in the reader's prose rather than hide them is the right call, since each one would otherwise mislead someone scripting against these commands.

The author's "Not verified" list is honest and I reproduced its boundaries. The read-only window was not observed by me either. The banner, title suffix, dialog, and write-gate sheet claims are all confirmed against source strings, which is strong evidence for wording but does not prove the surfaces render. The Screenshot Scout's capture of `shared-projects-read-only-banner` remains the outstanding check, and any mismatch should be resolved in the capture's favour.

## Counts

63 claims checked. **60 true, 3 false, 0 unverifiable.**

False: claim 11 (Recover and Open availability rule incomplete), claim 31 (apostrophe misquote in the corrupt-lock error block), claim 44 (the `unreadable` bundles' cause misstated).

Author defects confirmed: 7 of 7. New defects found: 1 (unreachable stale-lock recovery path).
Commands rerun: 24 of 24, all exit statuses and quoted output reproduced except the apostrophes in claim 31.
Lint: clean, exit 0.
