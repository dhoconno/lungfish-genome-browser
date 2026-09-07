# Author record: appendices/shared-projects

Chapter: `docs/user-manual/chapters/appendices/shared-projects.md`
Roster row 65. Rewritten in place against Preview 2026.9.13.
Author pass date: 2026-09-07.

## Lint result

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/shared-projects.md
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/shared-projects.md: no issues found
exit=0
```

One intermediate failure and its fix. The first lint run reported
`59:30-59:547 warning bare 'Lungfish' used for the app`, exit 0 with 1 warning.
The offending text was a verbatim quotation of the recovery-confirmation alert
from `ProjectLockResolutionDialog.swift:85`, which itself says "other Lungfish
versions" and "Lungfish will retain an archive". Rather than misquote the app,
the paragraph was restructured to paraphrase the two clauses containing the
bare word and to quote only the load-bearing warning sentence exactly
("Recovering a lock while another session is writing can damage the project.").

## Commands run

All CLI runs used `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`
against a copy of the demo project at
`<scratchpad>/shared-projects/Demo.lungfish`, copied from
`~/Desktop/lge-docs/LGE Manual Demo.lungfish`. The demo project itself was
never written to. Working directory was the worktree.

| # | Command | Exit | Result |
|---|---|---|---|
| 1 | `cp -R "$HOME/Desktop/lge-docs/LGE Manual Demo.lungfish" <scratch>/Demo.lungfish` | 0 | Copy made. The copy inherited a live GUI lock (see Defect note 1). |
| 2 | `cat <copy>/.lungfish/project.lock` | 0 | Inherited record, quoted below. |
| 3 | `rm -f <copy>/.lungfish/project.lock` | 0 | Cleared before testing. |
| 4 | `project lock <copy> --mode exclusive` | 0 | Three lines: `Locked project:`, `Lock file:`, `Mode: exclusive`. |
| 5 | `cat <copy>/.lungfish/project.lock` | 0 | Twelve-field record with `machineIdentifier`, `appVersion: "lungfish-cli 2026.9.13"`. |
| 6 | `project lock <copy> --mode maintenance` | 0 | **Succeeded and replaced record 4.** Key finding, see Defect note 2. |
| 7 | `python3 mklock.py` (writes a lock owned by a live `sleep` pid) | 0 | Live owner pid 97287. |
| 8 | `project lock <copy> --mode exclusive` (vs live owner) | 1 | `Error: Project is already locked at ... by dho@raven.local pid 97287 mode exclusive.` |
| 9 | `project unlock <copy>` (vs live owner, same user) | 1 | `Error: Refusing to remove lock at ... owned by dho@raven.local pid 97287; pass --force to override.` |
| 10 | `project unlock <copy> --force` | 0 | `Unlocked project:` / `Removed lock file:`. |
| 11 | `project unlock <copy>` (no lock present) | 0 | `No project lock found: <path>`. Not an error. |
| 12 | `project migrate <copy> --dry-run` | 0 | Four bundles, report quoted in the chapter. |
| 13 | `project migrate <copy> --dry-run --format json` | 0 | Per-bundle entries with `provenanceSidecar`, `formatVersion`, `message`. |
| 14 | `project migrate <copy>` (real run) | 0 | `chr20_10.0-10.5Mb.lungfishref: migrated (synthesized-browser-summary)`. |
| 15 | `ls <copy>/Reference Sequences/chr20_10.0-10.5Mb.lungfishref/.lungfish/migrations/` | 0 | `2026-09-07T141856753Z.manifest.json.backup` and `...project-migrate-provenance.json`. |
| 16 | `project migrate <copy> --dry-run` (rerun) | 0 | Migrated bundle now `current (none)`. Idempotent. |
| 17 | `project migrate <copy> --dry-run --format tsv` | 0 | Identical to text output. See Defect note 4. |
| 18 | `project lock <copy> --format json` | 0 | Record printed as JSON. `host` differed from run 5 (see Defect note 3). |
| 19 | `project unlock <copy>` (own stale lock, no force) | 0 | Removed. Confirms the stale-plus-same-user predicate. |
| 20 | `python3 mklock.py` then `project lock <copy> --mode exclusive --force` | 0 | Replaced a live owner's lock. |
| 21 | `ls <copy>/.lungfish/` after run 20 | 0 | Only `project.lock`. No `lock-recovery` archive. |
| 22 | `printf 'not json at all' > <copy>/.lungfish/project.lock` | 0 | Corrupt lock staged. |
| 23 | `project unlock <copy>` (corrupt) | 1 | `Error: Project lock file is corrupted at ...: The data couldn't be read because it isn't in the correct format.. Inspect the lock file or pass --force only after confirming no active writer is using the project.` |
| 24 | `project unlock <copy> --force` (corrupt) | 0 | Removed. |

No downloads or installs were run. Nothing was run against the demo project
itself or against any project outside the scratchpad.

The inherited lock from run 2, evidence that the GUI writes the same record shape:

```json
{
  "appVersion" : "2026.9.13",
  "createdAt" : "2026-09-07T03:34:38Z",
  "cwd" : "/",
  "host" : "raven.local",
  "machineIdentifier" : "38750482-9E30-587B-9B7D-5ADBCB1CF8B2",
  "mode" : "write",
  "pid" : 57785,
  "processStartTime" : "Sun Sep  6 17:22:58 2026",
  "projectPath" : "/Users/dho/Desktop/lge-docs/LGE Manual Demo.lungfish",
  "schemaVersion" : 1,
  "toolName" : "Lungfish ProjectStore",
  "user" : "dho"
}
```

Note the GUI uses `toolName: "Lungfish ProjectStore"` and `mode: "write"`,
where the CLI uses `"lungfish project lock"` and the `--mode` value.

## Source files consulted

| File | Lines | What it settled |
|---|---|---|
| `Sources/LungfishCore/Storage/ProjectLock.swift` | 8-13 | The four statuses `active`, `stale`, `unknown`, `corrupted`. |
| same | 35-48 | The twelve record fields, in order, including `machineIdentifier` as optional. |
| same | 108-112 | The lock path `.lungfish/project.lock`. |
| same | 164-188 | `acquireLock` uses `O_CREAT \| O_EXCL`, so two simultaneous creates cannot both win. |
| same | 200-224 | `status(of:)`. Non-local machine returns `.unknown`; a reused pid with a different start time returns `.stale`; `ESRCH` returns `.stale`. |
| same | 226-245 | `canRemoveWithoutForce`: own process, or same user on this machine with status `.stale`. Settles DRIFT #15. |
| same | 284-330 | `ProjectProcessInspector.processStartTime` via `proc_pidinfo`, `ps`-compatible format. |
| same | 332-374 | `machineIdentifier` from `gethostuuid`, and `isLocalMachine` preferring it over hostname. |
| `Sources/LungfishCore/Storage/ProjectLockRecovery.swift` | 38-41 | `ProjectLockRecoveryResult` carries `archiveURL` and `recoveryRecordURL`. |
| same | 57-105 | Recovery archives into `.lungfish/lock-recovery/<uuid>/project.lock` with `recovery.json`; the receipt is written before the move. |
| same | 94-98 | `RecoveryRecord` fields: schemaVersion, reason, timestamp, originalPath, archivePath, sha256, sizeBytes, operatorRecord. |
| same | 107-114 | An active local lock cannot be recovered at all. |
| `Sources/LungfishApp/App/ProjectLockResolutionDialog.swift` | 41-71 | Alert text per status, and the three buttons. |
| same | 84-88 | The recovery confirmation's exact wording. |
| same | 97-99 | `canRecover` excludes `.active`. |
| same | 101-119 | The accessory details block: session, owner and host and process, lock created, project path, details. |
| `Sources/LungfishApp/App/ProjectOpenWarningState.swift` | 14-16 | `isReadOnlyRecommended` covers active, unknown, corrupted, or any read error. |
| same | 44-87 | `evaluate`. A `.stale` lock returns `.unlocked`, so a plain stale lock never raises the dialog. |
| `Sources/LungfishApp/App/ProjectLockWarningPresentation.swift` | 16-49 | Banner title "Project opened read-only" and the four detail variants. |
| `Sources/LungfishApp/Views/MainWindow/ProjectLockWarningBannerView.swift` | 52-91 | Banner is a yellow-tinted strip with title and detail labels. |
| `Sources/LungfishApp/App/ProjectWriteGatePresenter.swift` | 22, 52-54 | Blocked-write sheet title and message. |
| `Sources/LungfishApp/App/AppDelegate.swift` | 609, 673 | The `" (Read Only)"` title suffix, from both causes. |
| `Sources/LungfishApp/App/ProjectLockOpenResolution.swift` | 14-81 | The dialog is wired into the real open path; recovery re-prepares and fails if another session took the lock meanwhile. |
| `Sources/LungfishCLI/Commands/ProjectCommand.swift` | 48-132 | `lock`: refuses on `.active` or `.unknown` without `--force`; replaces stale silently. |
| same | 150-185 | `unlock`: corrupted needs `--force`; foreign needs `--force`; missing prints and exits 0. |
| same | 337-342 | Summary counting. `unsupported` includes `unreadable`; `migration-available` is counted nowhere. |
| same | 370-376 | Bundle detection: any `lungfish*` extension (not bare `lungfish`) containing `manifest.json`. |
| same | 378-456 | The five statuses and their action strings, including `report-only` and `dry-run-report`. Settles DRIFT #23. |
| same | 458-525 | Migration writes backup and staged manifest under the **bundle's** `.lungfish/migrations/`, then `replaceItemAt`. |
| same | 560-617 | Migration provenance content: tool name and version, command, inputs, outputs, exit code, wall time, runtime, parameters. |
| same | 272-289 | Text output shape, and `case .text, .tsv:` sharing one branch. |
| `docs/user-manual/reviews/fidelity-2026-09/cli-help/project.txt` | whole | Flags for all three subcommands. Cross-checked against live `--help`. |
| `docs/user-manual/chapters/01-foundations/06-the-lungfish-project.md` | 68, 125-127, 191 | The `(Read Only)` suffix's two causes and the existing lock prose. |
| `docs/user-manual/chapters/08-workflows/01-the-workflow-builder.md` | 166 | The committed sentence on what read-only means and the two places it shows. |
| `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md` | whole | Naming, the `lungfish-cli` binary name, the demo-project sentence, glossary discipline. |
| `docs/user-manual/chapters/appendices/ai-assistant.md` | 53 | The fixed demo-project Before you start sentence, copied verbatim. |

## DRIFT rows applied

**False #4.** The old chapter claimed `lungfish` matched the help text's command
name. The help text prints `lungfish-cli`. Rather than carry the corrected
wording as a standalone note, the whole chapter now uses `lungfish-cli`
throughout, per CONSISTENCY's naming rule, so the paragraph explaining the
two names is gone as unnecessary.

**Changed #7.** The field list is now the full twelve in record order, adding
the schema version and the machine identifier. Verified against
`ProjectLock.swift:36-47` and against the live record from run 5.

**Changed #8.** The sample JSON is the actual record from run 5, so it carries
`machineIdentifier` and `appVersion: "lungfish-cli 2026.9.13"`.

**Changed #14.** Rewritten. A remote lock is recorded as unknown, not active,
and unknown blocks writes the same way active does. Source
`ProjectLock.swift:205-207` and `ProjectCommand.swift:77`.

**Changed #15.** Kept and made precise. The predicate is own process, or same
user on this machine with a stale status. Runs 9 and 19 demonstrate both
sides of it, and run 9 shows same-user is not sufficient.

**Changed #23.** Both literal action strings verified in source
(`ProjectCommand.swift:449`) and in run 12's output. Kept.

**Changed #24.** The provenance paragraph now marks the long requirement list
plainly as a requirement on future migrations, and describes separately what
the browser-summary migration actually writes today.

**Missing rows, all added.** The resolution dialog and its three buttons; the
second confirmation and its warning; recovery archiving rather than deleting,
with a recovery record beside it; the `corrupted` status and what the reader
sees; the exact banner text; `machineIdentifier` and why it exists;
`project lock --force`; and `--format tsv` (added with its defect noted).

**Screenshots.** `planned_shots` removed. One shot declared,
`shared-projects-read-only-banner`, with a `<!-- SHOT: ... -->` marker in the
read-only section. DRIFT suggested two, the dialog and the banner. The banner
is the one kept, because it is the state the reader lives with and the
committed chapters already describe it. The dialog was dropped because
reproducing it needs two concurrent LGE sessions on one project, which is
awkward to stage deterministically for the Screenshot Scout, and because the
dialog's text is quoted in full in the prose.

## Unverifiable claims settled or dropped

DRIFT listed four unverifiable claims. All four are resolved.

1. **The two migration action strings.** Settled as true.
   `ProjectCommand.swift:393` and `:449` give `report-only` and
   `dry-run-report`, and run 12 printed `report-only` on two bundles.
2. **The unlock ownership predicate.** Settled by reading
   `ProjectLockManager.canRemoveWithoutForce` (`ProjectLock.swift:236-245`)
   and by runs 9, 10, and 19.
3. **The claim that migration covers only `.lungfishref` in practice.**
   Settled false and rewritten. `isBundleDirectory`
   (`ProjectCommand.swift:370-376`) accepts any `lungfish*` extension holding
   a `manifest.json`, and run 12 scanned a `.lungfishmsa` and a
   `.lungfishtree`. The old sentence excluding FASTQ-derived bundles was
   dropped rather than repaired, since the real rule is simply the presence
   of a parseable `manifest.json`.
4. **Where migration backups and provenance are written.** The old chapter
   said `.lungfish/migrations/` without saying whose. Settled as the
   **bundle's** own `.lungfish/migrations/`, not the project's
   (`ProjectCommand.swift:471-481`), and confirmed by run 15.

One claim from the old chapter was dropped outright rather than corrected. The
old numbered rule 1 said `project lock` "refuses to replace" a lock whose
process is still live on this host. That is true of the code path but
misleading as guidance, because a CLI-created lock's process is never live by
the time the next command runs (run 6). The chapter now states the code
behaviour and then states the practical consequence explicitly.

## Defects found

1. **The demo project ships with a live GUI lock inside it.**
   `~/Desktop/lge-docs/LGE Manual Demo.lungfish/.lungfish/project.lock` held a
   valid record from a running app session (pid 57785, `toolName: "Lungfish
   ProjectStore"`, `mode: "write"`) at copy time. Any reader who copies the
   demo project and opens the copy gets a read-only window with a banner
   naming a process that has nothing to do with their copy, since the pid may
   still be live on the same Mac. Worth deciding whether the demo-project
   build script should clear the lock before the project is handed out.

2. **`project lock` twice in a row both succeed.** Because the CLI process
   exits immediately, its own lock is stale before the next command starts, so
   the second call replaces the first and exits 0 (run 6). This is correct per
   the code but defeats the naive reading of what "lock" means. The chapter
   documents it explicitly. A future `--wait` or a held-lease mode would make
   the command match the expectation.

3. **`host` is not stable within a single session.** Runs 5 and 18, seconds
   apart on the same Mac, recorded `raven.local` and
   `syn-2600-6c44-...spectrum.com`. Harmless because `machineIdentifier` is
   compared first, but it means the banner and the error messages can name a
   host the reader does not recognise as their own machine.

4. **`--format tsv` produces text, not TSV.** All three subcommands declare
   `text, json, tsv`, but `ProjectCommand.swift:277` and `:125` handle
   `.text, .tsv` in one branch, so `tsv` prints the human-readable report
   (run 17). The flag is advertised and does nothing. The chapter warns the
   reader to script against `json`.

5. **The migrate summary counts do not add up.** `unsupported` counts
   `unreadable` bundles too, and `migration-available` is counted in no line,
   so the demo project reports 4 inspected against 1 current, 2 unsupported,
   and 0 migrated (`ProjectCommand.swift:337-342`, run 12). The chapter tells
   the reader to read the per-bundle lines instead.

6. **`lock --force` leaves no archive, unlike GUI recovery.** The window's
   Recover and Open path archives the displaced record and writes a recovery
   receipt. `project lock --force` deletes it (runs 20 and 21). The asymmetry
   is documented in the chapter, but it is arguably a gap in the CLI rather
   than an intended difference.

7. **Chapter 6 carries a claim this chapter contradicts.** Not my file, so not
   changed. `01-foundations/06-the-lungfish-project.md:127` says "The window
   has no button for this yet, so a stale lock is cleared from the command
   line." The window does have one, `Recover and Open`, wired through
   `AppDelegate.swift:527-542`. Chapter 6 is separately in the campaign roster
   and should pick this up. The nuance that makes it half-true is that
   `ProjectOpenWarningState.evaluate` returns `.unlocked` for a plain stale
   lock, so a stale lock opens normally and never offers the button, and the
   button appears for unknown and corrupted locks instead.

## Not verified

- **The read-only window itself was not observed.** Everything about the
  banner, the title suffix, the resolution dialog, and the blocked-write sheet
  comes from source reading, not from driving the app. Staging it means two
  concurrent LGE sessions on one project. The Screenshot Scout will confirm
  the banner when capturing `shared-projects-read-only-banner`, and any
  mismatch between my prose and that capture should be resolved in the
  capture's favour.
- **Cross-machine locks.** Every run was on one Mac. The `unknown` status for
  a remote lock is asserted from `isLocalMachine` and `status(of:)`, not
  demonstrated. Runs 7 and 20 impersonated a live owner by process id on this
  machine, which exercises the `active` path but not the remote one.
- **GUI-side recovery.** `ProjectLockRecovery.recover` was never executed. The
  archive layout, the `recovery.json` fields, and the claim that the record is
  written before the lock is moved all come from reading
  `ProjectLockRecovery.swift:80-104`.
- **A genuinely unsupported bundle.** No bundle in the demo project has a
  format version other than `1.0`, so the `unsupported` status and the
  `dry-run-report` action string were confirmed only in source, never in
  output. The two `unreadable` lines are a different status.
- **`parameters_refs`.** None declared. `project lock`, `unlock`, and
  `migrate` are CLI subcommands with no dialog and no entry in
  `parameters.yaml`, so no ids were cited and no Settings section was written.
- **`features_refs`.** Left empty, matching the stub. No `features.yaml`
  entry covers the project command group.
