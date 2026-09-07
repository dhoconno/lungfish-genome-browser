# Author record, appendices/tool-versions

Chapter: `docs/user-manual/chapters/appendices/tool-versions.md`
Roster row 66. Fixture: the tool lock. Roster note "existing (generated)".
Author: Bioinformatics Educator. Date: 2026-09-07.

## Was there a generator?

No. I searched `docs/`, `scripts/`, and `Tools/` for `tool-versions` and for
`appendix-tool-versions`. Every hit on `tool-versions` in `scripts/` names a
different file, `Sources/LungfishWorkflow/Resources/Tools/tool-versions.json`,
which is the native-bundling manifest used by `scripts/bundle-native-tools.sh`,
`scripts/smoke-test-release-tools.sh`, and `scripts/deps/bump.py`. It is not the
managed-tool lock and it does not produce this chapter. The only hit on
`appendix-tool-versions` is the anchor in the chapter itself and the links to it
from other chapters. `docs/user-manual/build/scripts/` holds lint, shot, render,
and fixture scripts and nothing that writes a chapter. The roster's
"(generated)" note describes the page's character, not an existing tool.

So I wrote the tables with a short Python script instead.

## The script

Kept at
`/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/tool-versions/generate_tables.py`.
It was authored and run inside the worktree at `.scratch-tool-versions/`, which
I removed afterwards so the worktree carries no new untracked file.

```python
#!/usr/bin/env python3
"""Read the LGE managed-tool lock and emit the Tool Versions appendix tables."""
import json
import sys

LOCK = sys.argv[1]
d = json.load(open(LOCK))

out = []
out.append("dependencySet=%s dependencySetDate=%s version=%s" % (
    d["dependencySet"], d["dependencySetDate"], d["version"]))

# Always-installed tools: bootstrap micromamba + tools[]
out.append("\n## ALWAYS-INSTALLED (%d)" % (1 + len(d["tools"])))
out.append("| Tool | Version | Environment | License | Executables |")
out.append("|---|---|---|---|---|")
mm = d["bootstrap"]["micromamba"]
out.append("| micromamba | %s | (bootstrap) | (none in lock) | `micromamba` |" % mm["version"])
for t in d["tools"]:
    out.append("| %s | %s | `%s` | %s | %s |" % (
        t["id"], t["version"], t["environment"], t.get("license", "(none)"),
        ", ".join("`%s`" % e for e in t["executables"])))

# Pack tools
out.append("\n## PACK TOOLS (%d)" % len(d["packTools"]))
out.append("| Pack | Tool | Version | Environment | License | Executables |")
out.append("|---|---|---|---|---|---|")
for t in d["packTools"]:
    out.append("| `%s` | %s | %s | `%s` | %s | %s |" % (
        t["packID"], t["id"], t["version"], t["environment"],
        t.get("license", "(none)"),
        ", ".join("`%s`" % e for e in t["executables"])))

# Pipelines
out.append("\n## PIPELINES (%d)" % len(d["pipelines"]))
out.append("| Repository | Release | Revision |")
out.append("|---|---|---|")
for p in d["pipelines"]:
    out.append("| `%s` | %s | `%s` |" % (
        p["repository"], p["releaseVersion"], p["revision"]))

# Databases
out.append("\n## DATABASES (%d)" % len(d["databases"]))
out.append("| Id | Tool | Name | Version | Source policy |")
out.append("|---|---|---|---|---|")
for b in d["databases"]:
    out.append("| `%s` | %s | %s | %s | %s |" % (
        b["id"], b.get("tool", ""), b["displayName"], b["version"],
        b["sourcePolicy"]))

# Managed data
out.append("\n## MANAGED DATA (%d)" % len(d["managedData"]))
for m in d["managedData"]:
    out.append("- `%s` %s" % (m["id"], m["displayName"]))

out.append("\n## retiredEnvironments: %r" % d["retiredEnvironments"])
print("\n".join(out))
```

Every cell of every table in the chapter is a field of the lock as printed by
that script. Nothing in the tables was typed by hand. The only hand edits to the
generated output were three presentational ones, all disclosed in the chapter.
The micromamba Environment cell reads "(bundled in the app)" and its License
cell reads "(not recorded in the lock)" rather than the script's placeholders,
and the BBTools executable list is elided in the quoted CLI output block only,
not in the table.

## Commands run, with exit status

| # | Command | Exit |
|---|---|---|
| 1 | `grep -rIl --exclude-dir=.build --exclude-dir=.git -e 'tool-versions' -e 'appendix-tool-versions' docs/ scripts/ Tools/` | 0 |
| 2 | `grep -rIn --exclude-dir=.build --exclude-dir=.git 'tool-versions' scripts/ Tools/ docs/user-manual/build/` | 0 |
| 3 | `ls docs/user-manual/build/scripts/` | 0 |
| 4 | `python3 -c` inspection of the lock's top-level keys and list lengths | 0 |
| 5 | `python3 -c` inspection of one `tools[]`, `packTools[]`, `databases[]` entry plus `pipelines` and `managedData` in full | 0 |
| 6 | `python3 .scratch-tool-versions/generate_tables.py Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json` | 0 |
| 7 | `./.build/debug/lungfish-cli version --tools` (run from the primary checkout, which is where the built binary lives) | 0 |
| 8 | `grep -n '^### ' docs/user-manual/GLOSSARY.md` and per-term `grep -c` for each candidate term | 0 |
| 9 | Per-anchor `grep -c "{#<anchor>}" docs/user-manual/GLOSSARY.md` for all nine `glossary_refs` entries | 0 |
| 10 | `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/tool-versions.md` | 0 |

Lint result line, verbatim, first and only run:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/tool-versions.md: no issues found
```

I ran no git commands.

## The lock's own fields

Path in the source tree:
`Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`.
It is the only file in that directory.

| Key | Value |
|---|---|
| `packID` | `lungfish-tools` |
| `displayName` | `Third-Party Tools` |
| `version` | `2026.9.13` |
| `dependencySet` | `2026.2` |
| `dependencySetDate` | `2026-08-18` |
| `tools` | 17 entries |
| `managedData` | 2 entries |
| `packTools` | 23 entries |
| `pipelines` | 2 entries |
| `databases` | 16 entries |
| `bootstrap` | `micromamba` 2.9.0-0, with an osx-arm64 sha256 |
| `retiredEnvironments` | empty list |

The lock's `version` field equals the app release, 2026.9.13, so the lock is
current for Preview 2026.9.13 and needed no cross-check against a separate
release file.

Each `tools[]` and `packTools[]` entry carries `id`, `environment`,
`packageSpec`, `executables`, `version`, `license`, and `sourceUrl`. A
`packTools[]` entry adds `packID`. Because `license` is present on all forty
of those entries, I kept the License column the old page carried rather than
dropping it. The bootstrap micromamba entry is the one exception, carrying only
`version` and `sha256`, so its License cell says so in words rather than
guessing BSD-3-Clause the way the old page did.

The lock carries no license field on `pipelines[]` or `databases[]`, so those
two tables have no License column and instead carry the fields those entries do
have, `repository`, `releaseVersion`, `revision` for pipelines and `id`, `tool`,
`displayName`, `version`, `sourcePolicy` for databases.

## The manifest beside the lock

The brief names "the manifest beside it". There is no second file in
`Sources/LungfishWorkflow/Resources/ManagedTools/`. The lock is the whole
manifest, and `scripts/deps/manifest_io.py` confirms it, opening with the
docstring "Load and write `third-party-tools-lock.json` in the repo's own
style." The separate `Sources/LungfishWorkflow/Resources/Tools/tool-versions.json`
is the native-bundling manifest for micromamba and is a different artifact. The
Bibliography chapter's phrase "tool lock manifest" and this chapter's "lock
file" therefore name the same file, which is what the glossary entry
`tool-lock-manifest` already says.

## Agreement with the Bibliography chapter

I compared every version cell of `docs/user-manual/chapters/appendices/bibliography.md`
against the script's output, row by row.

Always-installed, 18 rows. Agrees on all 18, micromamba 2.9.0-0 included, and
Trim Galore 2.3.0 is present in both.

Pack tools, 23 rows. Agrees on all 23.

Pipelines, 2 rows. Agrees on both, viralrecon 3.0.0 and TaxTriage v3.3.8. The
Bibliography does not print the TaxTriage commit; this chapter does, since the
lock pins it and the DRIFT entry asked for it. That is an addition rather than a
disagreement.

Databases, 16 entries. The Bibliography groups them into 8 rows by shared
version, which expands to the same 16 lock entries at the same versions.

No disagreement of any kind was found between the two chapters or between either
chapter and the lock. Nothing needed to be reported as wrong, and nothing was
propagated from the Bibliography without checking it against the lock first.

## Agreement between `version --tools` and the lock

`./.build/debug/lungfish-cli version --tools` exits 0 and prints
`Lungfish 2026.9.13` then `Dependency set: 2026.2 (2026-08-18)`, both matching
the lock's `version`, `dependencySet`, and `dependencySetDate` exactly.

It then prints 18 rows, the same 18 the lock yields, agreeing on every version,
environment, and executable list. Three presentation differences, all stated in
the chapter, are not disagreements.

1. The command sorts alphabetically by display name. The lock and this chapter
   keep the lock's own array order.
2. The command shows display names such as `SAMtools`, `Fastp`, `Trim_Galore`,
   and `SRA Tools` where the lock stores identifiers `samtools`, `fastp`,
   `trim_galore`, `sra-tools`. The chapter's tables print the lock's
   identifiers, since the brief requires every cell to come from the lock. The
   identifier is also the string that appears in a provenance record.
3. The command has a Source column of `bundled` or `managed`. The lock has no
   such field. This chapter carries License in that column position instead and
   explains that the command reads the license field without printing it.

The command prints nothing about pack tools, pipelines, or databases, so three
of the chapter's four tables have no command-line check. Their only source is
the lock, which the chapter states.

## App defects found

None. The lock parses cleanly, `version --tools` exits 0 and agrees with it, and
no claim I checked in the app or the CLI was wrong.

One near-defect worth recording rather than filing. `version --tools` prints the
Source column as `bundled` for micromamba and `managed` for the other 17, but
the lock has no `source` field. The value is derived from which key the entry
came from, `bootstrap` against `tools`, so it is a display convention rather
than lock data. The old page presented Source as though it were a lock column
and put a License value beside micromamba that the lock does not carry. This
rewrite drops the Source column and says the micromamba license is not recorded.

## Glossary

No terms added. All nine terms the chapter needs already existed with the shapes
the chapter uses, and I verified each anchor resolves with a per-anchor grep.
They are `conda`, `dependency-set`, `micromamba`, `pinned`, `plugin-pack`,
`provenance`, `provenance-sidecar`, `reproducibility`, and `tool-lock-manifest`.
All nine are listed in `glossary_refs`.

Four terms the brief asked me to explain at first use are explained inline in
the chapter body without a glossary link, because they are not glossary entries
and did not warrant becoming ones. "Lock file" is glossed in the second
paragraph of What it is and then pointed at the existing `tool-lock-manifest`
entry. "Conda environment" is glossed in Reading the tables above the existing
`conda` link. "Executable" and the three source-policy words `unpinnedArchive`,
`localBuild`, and `bundledPayload` are glossed where they first appear, since
the last three are lock-internal strings that belong to this page alone.

## DRIFT items and how each was handled

All 13 false claims are corrected. Items 3 through 11 and 14 are the nine stale
versions, now read from the lock. Item 20 adds Trim Galore 2.3.0. Item 21 is
rewritten as the chapter's Reading the tables and pack-table lead. Item 24 adds
the TaxTriage pipeline row with its commit.

Both changed claims are handled. Item 22's ten pack IDs are named in the pack
section lead. Item 25's dependency set line is in What it is.

All six missing items are added. Trim Galore, the whole pack table, the whole
database table, the two `managedData` entries as a closing paragraph of the
database section, `tools update --plan` with its exit code 10 in What good looks
like, `retiredEnvironments` in the same section, and `dependencySetDate` in What
it is.

The screenshot verdict was "not applicable" and I kept `shots: []` with no
markers, as the DRIFT entry advises.

## Front matter changes

`estimated_reading_min` raised from 6 to 14. The page grew from one 16-row table
to four tables of 18, 23, 2, and 16 rows plus roughly 1,400 words of prose. The
Bibliography, which is longer and carries comparable tables, is set at 26, so 14
is proportionate.

`task` rewritten to name pipelines and databases, which the page now covers.
`glossary_refs` expanded from `[provenance]` to the nine terms above.
`brand_reviewed` and `lead_approved` left at `false`.
The `<a id="appendix-tool-versions"></a>` anchor is preserved immediately after
the front matter, unchanged, since `index.md`, `cli-reference.md`,
`power-user-notes.md`, and `bibliography.md` link to it.

## What I could not verify

Three things.

The in-app path I give for the lock, `Contents/Resources/third-party-tools-lock.json`,
is inferred from the SwiftPM resource declaration rather than read out of an
installed bundle. I did not open `/Applications/Lungfish Preview.app` to confirm
the file's exact location inside it. The source-tree path beside it is verified.

The CLI output I quote comes from `.build/debug/lungfish-cli` in the primary
checkout, not from the binary inside the installed Preview app. Both are built
from the 2026.9.13 lock and both report `Lungfish 2026.9.13`, so they should be
identical, but I did not run the installed one.

The claim that `tools update --plan` exits 10 when work is pending comes from
`cli-help/tools.txt` as recorded in DRIFT, not from an observed run. Running it
would have provisioned tools on this machine, which is out of scope for a doc
pass.
