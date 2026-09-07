# Editor pass, appendices/06-running-in-ci.md

Brand copy editor, 2026-09-07. Roster row 58. Chapter rewritten in place.
Sibling chapters untouched. `brand_reviewed` and `lead_approved` left false.

## False claims fixed

All eight, with the reviewer's wording.

1. **`--executor` reaches only the nf-core route.** The opening paragraph's
   "single most important choice" claim is gone. The What it is section now
   says the toolset depends on the route, that a local `.nf` or `Snakefile`
   runs the engine directly from conda-installed tools and needs no container
   runtime, and that only an nf-core run reads `--executor`, whose `docker`
   default is what makes a runtime a requirement on that route. The flag
   bullet now agrees, telling a job with no runtime to set `conda` and saying
   a local `.nf` ignores the flag.
2. **Ten accepted pack ids, three useful ones named.** "Three further ids" is
   now "Ten further ids are accepted by `offline-export` even though the error
   message omits them, because the id lookup searches the whole built-in pack
   list while the message prints only the eight the CLI shows", with
   `gatk-core`, `phasing`, and `wastewater-surveillance` named as the real
   packs, called safe to use (reader row 40), and the rest explained as
   naming environments the build does not install. The rough-edges item and
   the What fails entry were both updated to ten.
3. **Manifest and provenance record separated.** The offline-pack sentence now
   assigns the pack id, source conda root, exporting command line, and the
   per-file SHA-256 and byte size to `offline-pack-manifest.json`, and gives
   `.lungfish-provenance.json` only the export-as-operation role. This brings
   the body into line with the chapter's own `offline-pack` glossary entry.
4. **`--format json` is a general caution.** The two-command exception is now
   "declared on almost every command ... many commands accept the flag and
   print their ordinary text anyway", naming `conda packs`, `ops stats`,
   `workflow list`, `conda offline-export`, and `version`, telling the reader
   to check any command's output before parsing, and naming `tools update`
   and its own `--json` as the exception worth knowing. The rough-edges item
   carries the same five commands.
5. **Dry-run block regains its missing line.** The `ℹ Preparing workflow:`
   opener is restored, and the `Workflow:` value is now the literal argument
   `hello-world-nextflow.lungfishflowpkg/main.nf` rather than the elided path.
6. **`ops stats` block regains its `Project` line**, printed after the blank
   line following "Operation Stats".
7. **CircleCI `when: always` removed from `store_artifacts`.** The prose is
   replaced with the reviewer's wording about `store_artifacts` taking only
   `path` and `destination`, and about guarding an earlier `run` step with
   `when: always` instead. The template's `store_artifacts` now carries only
   `path` and `destination`.
8. **Rough-edges count matches the findings.** The "Four rough edges" number
   is dropped. The section opens with a reassurance instead (see ruling and
   reader row 47), and now lists five items, having gained the empty-file-list
   and missing-`reproducibleCommand` finding the reviewer added as defect 7.

## Project manager rulings

**(a) Binary path in both templates.** Applied. Following the CONSISTENCY
naming line and the fixed form already established in `cli-reference.md`,
both templates set `LUNGFISH:
"/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli"` once at the
top of the job, quoted because of the space, and every command writes
`"$LUNGFISH"`. A new **Finding the program** section states in one sentence
that a bare `lungfish-cli` will not resolve, because installed releases put
nothing on `PATH`, and explains the shell variable and the `$` syntax. The
What fails entry now points at the templates rather than at an unwritten
PATH step. This closes reader row 23.

**(b) GitHub Actions cache step.** Removed, per the ruling. The author's
record shows no working cache pattern from ci.yml to adopt, only
install-and-cache provisioning, so the fallback did not apply. The
`actions/cache@v4` step and the `hashFiles` key are gone, replaced by a
"Provision the required tools" step running `tools update --apply --yes
--required-only` and `conda install --pack metagenomics`, which is what the
project's own CI does. One sentence after the template says there is no cache
step deliberately, that the project provisions the same way, and that caching
is an optimisation to add once the job runs green. Reader rows 41 and 42 are
closed for the GitHub template by removal, and row 42 is answered for
CircleCI by a new paragraph describing the empty first run.

**(c) Opening paragraph.** Applied as a new `## Before you read this` section
placed before any command. It says everything is typed rather than clicked
and defines a command as a line of text typed into Terminal, defines a CI job
as a script a hosted machine runs on every push, says the workflow file lives
at the path each service documents and names `.github/workflows/` for GitHub
Actions, and says both templates are starting points to adapt rather than
runs the manual performed. It also names the two prerequisite chapters
(reader row 91) and, with the What it is section, closes rows 69 and 92.

**(d) Exit status.** The gloss now sits at the first appearance of a number,
in the Running the workflow section immediately after the exit-64 refusal,
and is followed by a four-row table collecting 0, 3, 10, and 64 with what
each means for a job. The earlier exit-10 mention in What a job needs
installed was reworded so no bare number precedes the gloss. Closes reader
row 10.

**(e) Glossing.** All fourteen named terms are glossed in one clause at first
use: shell, flag (as "command-line flag" via the existing PATH gloss and the
placeholder explanation), PATH, export, runner, checkout, repository, push,
YAML, glob (reworded to "files named `*.lungfish-provenance.json`" per reader
row 45, with the term itself in the Glossary), cache, Docker, nf-core, and
Kraken2. "Standard error" is now "the captured error stream, which the
terminal calls standard error", with a following sentence saying it has
nothing to do with the statistical term (reader row 84). Further terms
glossed for the same reader rows: container runtime, conda environment,
alias, argv, run bundle, workflow engine, Nextflow, Snakemake, pull request,
plugin pack, the angle-bracket placeholder convention, the line-continuation
backslash, manifest, checksum, dot-file hiding in the Finder, host depletion,
managed database, wall time, signing, scratch folder, checkpoint, work
directory, version drift, JSON, and the archive extensions.

**(f) Numbers with no scale.** 157.3 MB now carries a clause saying it is
that machine's pending download, not a fixed figure, that it grows with the
number of out-of-date tools and falls to nothing once the runner matches, and
that a restored cache skips it. 60 minutes is named as GitHub's own default
rather than a measured figure, with the reader told to time their own
pipeline, since the example finishes in under a second. Core count and peak
RAM from `debug env --check-tools` are stated as the runner's own figures
with no threshold offered. `Total wall time: <1s` and `Peak RAM: unknown` are
both given context. No thresholds were invented anywhere.

**(g) Sidecar inside the bundle.** Stands as the chapter had it, per the
ruling that the appendix is right and the sibling is wrong. Presentation only
was changed, into a small folder tree (reader row 83) that labels which of
the two records to check (row 63).

**(h) Appendix shape.** Kept. No section was reordered or removed. Three
sections were added ahead of the existing flow (Before you read this, Finding
the program) and the rough-edges subsection kept its position under What
fails.

## Reader rows

**Consensus section, 42 rows: all 42 applied.**

**Other merged rows, 58 total: 52 applied, 6 skipped.**

Applied rows include 72 (non-interactively reworded), 73 (a not-ready
container result now names the next step), 75 (the `--format json` defect is
stated once in the body and once in the rough-edges list, now differently
scoped rather than word for word), 78, 79, 80 (Power-user notes named
authoritative), 81, 82, 83, 84, 85, 86, 87 (`--timeout` split out of the flag
list into its own do-not-set paragraph), 88, 89 (structural sentence cut), 90,
91, 92, 93, 94, 95 (rhetorical question removed), 96, 97, 98 ("two ways that
work"), 99, 100, 101 ("two commands worth running first"), 102, 103 ("three
kinds"), 104 ("upper or lower case both work"), 105, and 106.

Skipped, with reasons.

- **Row 74** (give a minimum core count and memory figure). Skipped under
  ruling (f), which forbids inventing thresholds. The chapter instead says
  the figures are the runner's own and offers none.
- **Row 59** (a table matching each of the eight pack ids to an analysis).
  Partly applied rather than skipped. A five-row table covers the five packs
  a CI author is likely to choose, and one sentence says the remaining three
  name their work in their ids. A full eight-row table would breach the
  five-row spirit of the bullet cap and pad the section.
- **Row 55** (reconcile the dry run's `Results: ./results` with the worked
  run's path). The reviewer confirms the dry run genuinely printed
  `./results`, that being its own command's value, so the paths are not
  reconcilable without misquoting verified output. A sentence now explains
  the difference instead.
- **Row 58** (show a CI step reading a JSON field). Skipped where the reader
  asked for it, in the `--format json` paragraph, because the reviewer
  widened that paragraph into a caution that the flag is unreliable, and an
  example of parsing would work against it. The concrete `jq` example is
  given later instead, where it is sound, closing row 46.
- **Row 30's second half** (how large the Viral database is). Skipped as an
  invented number under ruling (f). The chapter says `conda db list` prints
  the other catalogue names, and gives the storage-root paragraph a
  several-gigabytes clause for the database class as a whole, which is the
  author's own observation rather than a measurement of Viral.
- **Row 51** (drop the "trap" teaser from the heading). Half applied. The
  heading is now "Offline packs, and the flag that does not mean what it
  says", which names the problem rather than teasing it, and the forward
  reference in the earlier section names it too. The word "trap" is gone. The
  section was not moved, since the shape stays under ruling (h).

## Glossary changes

Nine terms added to `GLOSSARY.md`, each alphabetically placed among its
neighbours in the existing entry shape with a `See also:` clause, and each
added to the chapter's `glossary_refs`.

`cache` (line 117), `checkout` (113), `glob` (273), `path` (517), `push`
(567), `repository` (629), `runner` (649), `shell` (655), `yaml` (807).

`docker`, `kraken2`, and `nf-core` already existed and were added to
`glossary_refs` only. `glossary_refs` grew from eleven slugs to twenty-three,
and all twenty-three resolve. Each new entry produces exactly one
in-sentence-colon warning from its `See also:` clause and no other kind,
matching the file's established 420-warning house baseline.

## Front matter

`estimated_reading_min` raised from 14 to 18 for the added glosses, the two
new sections, and the two tables. `glossary_refs` extended as above.
`brand_reviewed: false` and `lead_approved: false` unchanged. No other key
touched.

## Lint result

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/06-running-in-ci.md
```

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/06-running-in-ci.md: no issues found
```
