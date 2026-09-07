# Author record, appendices/06-running-in-ci.md

Author pass for the 2026-09 fidelity campaign, roster row 58. Rewritten in
place against Preview 2026.9.13. No registry ids, no fixture.

## Lint result

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
  docs/user-manual/chapters/appendices/06-running-in-ci.md
```

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/06-running-in-ci.md: no issues found
```

Clean on the first pass after the rewrite. The pre-rewrite file carried six
warnings (two bare "Lungfish", two semicolons, two in-sentence colons).

`GLOSSARY.md` lints at a 420-warning baseline that predates this chapter.
Every warning is the same in-sentence-colon rule firing on the "See also:"
clause that all 400-plus entries share. The four entries added here
(lines 147, 179, 205, 443) produce exactly one such warning each and no
other kind, so they match the established house shape rather than adding a
new defect.

## Commands run, with exit status

All run from the scratchpad
`/private/tmp/claude-501/.../scratchpad/running-in-ci/` unless noted. The
binary is `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.

| # | Command | Exit | What it settled |
|---|---|---|---|
| 1 | `conda packs` | 0 | Eight visible packs listed. `--format json` is ignored (defect 1). |
| 2 | `conda offline-export --help` | 0 | Flag set for the export command. |
| 3 | `conda offline-export --pack classification --output ./packs` | 3 | DRIFT row 6 confirmed. `classification` is not a pack. Error text and the eight-id list quoted verbatim in the chapter. |
| 4 | `conda offline-export --pack gatk-core --output ./packs-gatk` | 0 | DRIFT rows 7 and 19. `--output` is the *parent*; the pack lands at `./packs-gatk/gatk-core-conda-offline-pack`. It carries `offline-pack-manifest.json` and its own `.lungfish-provenance.json`. Also proves a hidden pack id is accepted (defect 2). |
| 5 | `run-headless <pkg>/main.nf --results-dir ./nf-results --expected-output ./nf-results/hello-world-nextflow.lungfishref --bundle-root ./bundles` | 0 | The worked run. Printed one line, the bundle path. |
| 6 | `run-headless <pkg>/main.nf --results-dir ./nf-fail` (no expected output) | 64 | Error text quoted verbatim. `--quiet` does not suppress it. |
| 7 | `workflow run <pkg>/main.nf --dry-run` | 0 | `--dry-run` needs no expected output. Plan output quoted verbatim. |
| 8 | `provenance verify ./nf-results/hello-world-nextflow.lungfishref` | 64 | Fails on an unsigned sidecar. Error quoted verbatim. This is the single most useful correction in the chapter, since the old text implied provenance was routinely verifiable in CI. |
| 9 | `ops stats ./nf-results` | 0 | Output quoted verbatim (1 sidecar, 1 completed run, `<1s`, Peak RAM `unknown`). |
| 10 | `ops stats ./nf-results --format json` | 0 | Printed the same text. `--format json` ignored (defect 1). |
| 11 | `tools update --plan` | 10 | Exit 10 confirmed against the documented contract. Plan output quoted verbatim. |
| 12 | `debug env --check-tools` | 0 | Runner report shape confirmed. Surfaced the Nextflow version-probe defect (defect 4). |
| 13 | `debug container` | 0 | Apple Containerization reported available and Ready. |
| 14 | `provision-tools --status` | 0 | Reports micromamba not installed, with an output directory under a temp folder. Not cited in the chapter (see Not verified). |

No downloads and no installs were run. Commands 4 and 5 write only into the
scratchpad.

## Sources consulted

Persona and rules.
- `.claude/agents/bioinformatics-educator.md`
- `docs/user-manual/STYLE.md` (prose rules, frontmatter schema, chapter template)
- `docs/user-manual/ARCHITECTURE.md` (audience tiers, retrieval rules, editorial rules)
- `docs/user-manual/build/scripts/lint/rules/ai-tells-words.txt`
- `docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`
- `docs/user-manual/reviews/fidelity-2026-09/DRIFT.md`, the `### appendices.md/06-running-in-ci.md` section

CLI help dumps under `docs/user-manual/reviews/fidelity-2026-09/cli-help/`.
`run-headless.txt`, `workflow.txt`, `conda.txt`, `provenance.txt`, `ops.txt`,
`tools.txt`, `debug.txt`, `provision-tools.txt`, `_root.txt`.

Source.
- `Sources/LungfishCLI/Commands/CondaCommand.swift` lines 481-620, for the
  `packs`, `export-pack`, `offline-export`, and `offline-install`
  subcommands and the shared `exportOfflinePack` they call.
- `Sources/LungfishWorkflow/Conda/PluginPack.swift`, for the built-in pack
  list and `builtInPack(id:)`, which is what accepts a hidden id.
- `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`,
  for the ten distinct `packTools[].packID` values and `version` 2026.9.13.
- `Sources/LungfishCore/Storage/ManagedStorageConfigStore.swift:125-155`,
  for `LUNGFISH_STORAGE_ROOT` and `LUNGFISH_CONDA_ROOT` being read together.
- `Sources/LungfishCore/Services/NCBI/NCBIService.swift:85-90`, for `NCBI_API_KEY`.

Repository CI.
- `.github/workflows/ci.yml`. This is the only evidence for what the project
  itself runs, and it changed the chapter materially. Confirmed: `runs-on:
  macos-26` on every job, the push gate is a fast non-Swift job with Swift
  work behind `workflow_dispatch` (matching the memory note), concurrency is
  keyed by event, the cache key is the lock-manifest SHA-256 over
  `~/.lungfish/conda`, provisioning is `tools update --apply --yes
  --required-only` followed by `conda install --pack <id>` per pack and
  `conda db download Viral`, and evidence upload uses `if: always()`.
  Notably the project does **not** use offline packs in its own CI, which is
  why the rewritten chapter presents install-and-cache first and offline
  packs second, reversing the old chapter's emphasis.

Artifacts read.
- `packs-gatk/gatk-core-conda-offline-pack/offline-pack-manifest.json` and
  its `.lungfish-provenance.json`, for the pack's own provenance fields
  (`packID`, `sourceCondaRoot`, per-file SHA-256 and byte size).
- `nf-results/hello-world-nextflow.lungfishref/.lungfish-provenance.json`,
  for the sidecar field list, the `argv` rewrite, and the location finding.

## Facts taken from the sibling chapter

`docs/user-manual/chapters/08-workflows/03-running-external-workflows.md` is
binding where it and this appendix overlap, and it won on every point below.

1. `--executor` accepts `docker`, `conda`, `local`, defaults to `docker`,
   and reaches only the nf-core route. A local `.nf` or `Snakefile` ignores it.
2. `--expected-output` is required for an executed run, is repeatable, and
   names where to look rather than causing the file to be written.
3. `--bundle-root` defaults to the current directory, and a repeat run
   produces `main-2.lungfishrun` rather than overwriting.
4. `--timeout` is accepted but unenforced locally and rejected outright by
   an nf-core run, which is why the chapter tells a CI job to use the
   runner's own timeout instead.
5. `--prepare-only` is the one flag that formally waives the expected-output
   requirement, while `--dry-run` works in practice because the command
   returns before the check runs. The chapter states both without
   contradicting the sibling.
6. `ops stats` reports an unknown option and still exits 0, so a script must
   read its output rather than its exit status.
7. Peak RAM reads `unknown` for local adapters, expected rather than a fault.
8. `workflow run` detects Nextflow by a lower-case `.nf` only, while
   `workflow validate` lowercases first.
9. `run-headless` prints the bundle path and nothing else.
10. nf-core/viralrecon is the only supported published pipeline and takes
    exactly one `--input` samplesheet (DRIFT row 13).

## DRIFT rows applied

False 6. `classification` replaced by `metagenomics` throughout, and the
`--output` argument corrected to the parent directory in both templates.

False 13. Every example now uses a real workflow argument. The worked run
uses the shipped `main.nf`; the templates use `pipeline.nf`. The three
accepted shapes and the viralrecon single-samplesheet rule are stated.

Changed 3. Opening claim rewritten to "runs without the app's window, so a
CI runner needs no display", with the container-or-conda requirement and
`--executor` named immediately after.

Changed 4. First clause kept. Field list taken from the actual sidecar and
checked against `power-user-notes.md`, which agrees on checksums, byte
sizes, exit status, wall time, tool version, and command.

Changed 7. `--output` semantics corrected and demonstrated with the observed
`gatk-core-conda-offline-pack` path.

Changed 8. `--overwrite` added to every `offline-install` example, with the
cached-re-run reason given.

Changed 14. `macos-26` kept, with the macOS 26 container requirement given
as the reason and a sentence telling the reader to check the label against
the vendor's current image list.

Changed 19. Portability kept. The pack's own provenance is now asserted from
the observed `.lungfish-provenance.json` rather than left vague.

All twelve Missing rows are covered. `--executor`, `--dry-run`,
`--prepare-only`, `--timeout`, `--resume`, `tools update --plan` and its
exit 10, `debug env --check-tools`, `debug container`,
`LUNGFISH_STORAGE_ROOT`, `NCBI_API_KEY`, `--format json`, the real pack ids,
`conda export-pack`, and `conda db download` / `db install-managed`.

One Missing row is corrected rather than adopted. It asks for "the ten real
pack IDs a CI author must choose from", citing the lock's `packTools[].packID`
values. The lock does hold ten distinct ids, but `conda packs` prints eight
(including `lungfish-tools`, which is not in the lock's `packTools`), and the
unknown-pack error lists those same eight. Command 4 proves the three
lock-only ids still work. The chapter therefore quotes the eight the error
prints and then says plainly that three more are accepted but unlisted,
which is the accurate statement rather than either count on its own.

## Defects found

1. `--format json` is accepted and ignored by both `conda packs` and
   `ops stats`. Both print their ordinary text and exit 0, so neither is
   script-parseable despite advertising the flag. The `ops stats` half
   corroborates the sibling chapter's independent finding.
2. The unknown-pack error lists eight ids, but `offline-export` also accepts
   `gatk-core`, `phasing`, and `wastewater-surveillance`. A CI author reading
   only the error would conclude three working packs do not exist.
   `builtInPack(id:)` looks up the full built-in list while the error prints
   the visible subset.
3. `wallTimeSeconds` in the verified run's sidecar was
   `-6.9141387939453125e-06`, a small negative number rather than a duration.
   `startTime` and `endTime` are sound, so the chapter tells a CI check to use
   those and not to compute from `wallTimeSeconds`.
4. `debug env --check-tools` reports the Nextflow row as
   `✓ nextflow: Unknown option: --version=true -- Check the available commands
   and options and syntax with 'help' - Workflow engine`. The probe passes
   `--version=true`, which Nextflow rejects, so the row confirms presence but
   never reports a version. Every other tool row reports a real version.
5. Not a defect but a documentation trap worth recording. For a bundle
   output, the `--expected-output` sidecar is written *inside* the bundle at
   `<bundle>/.lungfish-provenance.json`, not beside it. A CI artifact glob of
   `*.lungfish-provenance.json` next to the output finds nothing. The old
   chapter's GitHub Actions example globbed exactly that way and would have
   silently uploaded no provenance. Both rewritten templates upload the whole
   results directory instead.
6. `provenance verify` verifies only *signed* sidecars and exits 64 on an
   unsigned one, while signing is off by default. The command reads like the
   obvious CI check and is not one.

## Not verified

The two YAML templates were not executed. No CI service is reachable from
this environment, so every flag in them was verified individually by the runs
above and the files themselves are labelled in the chapter as templates to
adapt rather than runs performed. The GitHub Actions runner label `macos-26`
and the CircleCI `xcode: "26.0.0"` image tag were not checked against the
vendors' current image lists, and the chapter tells the reader to do that.

`conda offline-install` was never run. Doing so would mutate a conda root,
which is outside the no-installs limit for this pass. Its flags come from
`conda.txt` and from `OfflineInstallSubcommand` in `CondaCommand.swift`, and
the `--overwrite` behaviour is quoted from the declared help text rather than
observed.

`conda db download` and `conda db install-managed` were not run, being
downloads. Their existence, arguments, and purpose come from `conda.txt`.

`conda export-pack` was not run. Its identity with `offline-export` is read
from the source, where both subcommands call the same `exportOfflinePack`
function, differing only in the declared help for `--output`.

`--resume`, `--timeout`, and `--executor` were not exercised. All three are
taken from the sibling chapter, which is run-verified and binding.

`provision-tools --status` was run (exit 0) but is not cited in the chapter.
It reported its output directory as
`/var/folders/.../T/Sources/LungfishWorkflow/Resources/Tools`, a path under a
temporary folder, which looks wrong for a debug build invoked outside its
package directory. I could not tell from one run whether that reflects a real
defect or only the debug-build resource lookup, so rather than describe
behaviour I do not understand, the command is left out of the chapter and
recorded here for whoever owns that command.

## Front matter

`glossary_refs` was `[provenance sidecar, conda]`, where the first was not a
slug. It is now eleven real slugs, all resolving in `GLOSSARY.md`.
`prereqs` gained `08-workflows/03-running-external-workflows`, since the
appendix now leans on that chapter for the workflow-run flag set.
`estimated_reading_min` raised from 8 to 14, the chapter having roughly
doubled. `tools` gained `nextflow` and `snakemake`. `entry_points` gained
`workflow run` and `tools update` and corrected `lungfish` to `lungfish-cli`.
`brand_reviewed` and `lead_approved` left false.

## Glossary terms added

Four, alphabetically placed, in the existing entry shape.

- **Continuous integration** `{#continuous-integration}` at line 147
- **Dependency set** `{#dependency-set}` at line 179
- **Environment variable** `{#environment-variable}` at line 205
- **Offline pack** `{#offline-pack}` at line 443
