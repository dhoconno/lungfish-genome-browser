# Fidelity review, appendices/tool-versions

Chapter: `docs/user-manual/chapters/appendices/tool-versions.md`
Reviewer: Manual Fidelity Reviewer. Date: 2026-09-07.

Arbiters used. The lock at
`Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`,
read by my own Python script rather than the author's copy. A live
`/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli version --tools`,
exit 0, run from the primary checkout. The committed
`docs/user-manual/chapters/appendices/bibliography.md`. The DRIFT section
`### appendices.md/tool-versions.md`. `CONSISTENCY.md`. Live
`lungfish-cli tools update --help`, `taxtriage run --help`, and
`conda install --help`. The installed bundle at
`/Applications/Lungfish Preview.app`.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "Every number on this page is read out of one file, LGE's tool lock manifest." | true | I regenerated all four tables from the lock with my own script. Every cell of all 59 data rows matches a lock field. Nothing is invented, and no version was carried over from the old page | |
| "The file lives inside the app at `Contents/Resources/third-party-tools-lock.json`" | false | `find "/Applications/Lungfish Preview.app" -name third-party-tools-lock.json` returns exactly one path, `Contents/Resources/LungfishGenomeBrowser_LungfishWorkflow.bundle/Contents/Resources/ManagedTools/third-party-tools-lock.json`. `ls "/Applications/Lungfish Preview.app/Contents/Resources/"` has no such file at the top level. The author recorded this as inferred from the SwiftPM resource declaration and never opened the bundle | "The file lives inside the app at `Contents/Resources/LungfishGenomeBrowser_LungfishWorkflow.bundle/Contents/Resources/ManagedTools/third-party-tools-lock.json`, and in the source tree at `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`." |
| "and in the source tree at `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`" | true | The file is there and is the only file in that directory | |
| "This appendix reflects dependency set `2026.2`, cut on 2026-08-18, as shipped by release 2026.9.13." | true | Lock `dependencySet` `2026.2`, `dependencySetDate` `2026-08-18`, `version` `2026.9.13`. `version --tools` prints `Lungfish 2026.9.13` and `Dependency set: 2026.2 (2026-08-18)` | |
| "These folders live under `~/.lungfish/conda`." | true | Matches the project's conda root convention. Not contradicted by any arbiter | |
| "Installing the `assembly` pack brings in five assemblers at once." | true | Lock `packTools` under `packID` `assembly`: spades, megahit, skesa, flye, hifiasm. Five | |
| "IQ-TREE's executable is `iqtree3`, and Clair3's is `run_clair3.sh`." | true | Lock line 48 `"executables": ["iqtree3"]`. Lock line 39 `"executables": ["run_clair3.sh"]` | |
| Always-installed table, all 18 rows, every Tool, Version, Environment, License, and Executables cell | true | Regenerated from `bootstrap.micromamba` plus the 17 `tools[]` entries. All 18 agree, including bbtools 40.02 with all nine executables, trim_galore 2.3.0 GPL-3.0-only, and ucsc-bedgraphtobigwig 482 | |
| "ucsc-bedgraphtobigwig ... Varies, see https://genome.ucsc.edu/license" | false | The lock's `license` field is `Varies; see https://genome.ucsc.edu/license`, with a semicolon. The chapter substitutes a comma. This is the one cell in 59 rows that is not the lock's own string, and the chapter's own claim is that no cell is altered. The house prose rule bans semicolons in prose, but a quoted license string in a table cell is data, not prose, and the lint passes either way | "Varies; see https://genome.ucsc.edu/license" |
| "The eighteenth, micromamba ... ships inside the app itself ... and the lock records it under a separate `bootstrap` key that carries no license field." | true | `d["bootstrap"]["micromamba"]` has exactly two keys, `version` and `sha256`. No `license` | |
| "micromamba \| 2.9.0-0" and "The micromamba version carries a trailing `-0`" | true | Lock bootstrap `version` is `2.9.0-0`. `version --tools` prints `micromamba 2.9.0-0 bundled -` | |
| "bedGraphToBigWig counts by build number rather than by a dotted release, so a bare `482` is the whole version." | true | Lock `version` is the string `482`. The bibliography carries the same note at its line 137 | |
| "pysam is the Python library that reads the BAM files ... openpyxl writes the genotyping workbooks" | true | Both lock entries declare `python` as their only executable, consistent with a library rather than a command. The bibliography states the same two roles in the same words at its line 191 | |
| "The lock pins twenty-three tools across ten packs." | true | `len(d["packTools"])` is 23. Distinct `packID` values number 10 | |
| "The ten pack IDs are `read-mapping`, `full-length-mhc-genotyping`, `variant-calling`, `gatk-core`, `phasing`, `assembly`, `multiple-sequence-alignment`, `phylogenetics`, `metagenomics`, and `wastewater-surveillance`." | true | Distinct `packID` values in lock array order are exactly those ten, in exactly that order. Matches DRIFT changed-claim 22 | |
| Pack tools table, all 23 rows, every cell | true | Regenerated from `packTools[]`. All 23 agree on Pack, Tool, Version, Environment, License, and Executables | |
| "Install a pack from the Plugin Manager at **Tools > Plugin Manager...** (Cmd-Shift-B)" | true | `CONSISTENCY.md:34` fixes this surface and shortcut in exactly this form | |
| "or on the command line with `lungfish-cli conda install --pack read-mapping`" | true | `conda install --help` shows `--pack  Install a plugin pack instead of individual packages` with the pack name as a positional argument, so the form is right. Note the bibliography's caution below | |
| "GATK4 installs into an environment called `gatk-core` and WhatsHap into one called `phasing`" | true | Lock gatk4 `environment` `gatk-core`, whatshap `environment` `phasing`. The only two entries whose environment is the pack name | |
| Pipelines table, both rows | true | Lock `pipelines[]`: taxtriage, repository `jhuapl-bio/taxtriage`, `releaseVersion` `v3.3.8`, `revision` `e10bfebda32a62711f38a4e23ab03b61725a9675`. nf-core-viralrecon, `releaseVersion` and `revision` both `3.0.0`. All six cells agree | |
| "TaxTriage is pinned to a forty-character commit identifier" | true | The revision string is 40 hexadecimal characters | |
| "Override the TaxTriage revision by adding `--revision <ref>` to `lungfish-cli taxtriage run`" | true | Live `taxtriage run --help`: `--revision <revision>  TaxTriage pipeline revision/branch (defaults to Lungfish's pinned TaxTriage revision) (default: e10bfebda32a62711f38a4e23ab03b61725a9675)`. The default also independently confirms the pipeline row | |
| "the Viral Recon release with the version field of the Viral Recon wizard" | unverifiable | Not settled by the lock or the CLI. A GUI check of the Viral Recon wizard for a version or release field would settle it | |
| "The lock pins sixteen [databases]." | true | `len(d["databases"])` is 16 | |
| Databases table, all 16 rows, every Database, Tool, Name, Version, and Source policy cell | true | Regenerated from `databases[]`. All 16 agree, including the nine Kraken 2 builds, `ncbi-taxonomy` at `live` with policy `liveSnapshot`, and the two `bundledPayload` rows | |
| "`20260626` is 26 June 2026 and `20230407` is 7 April 2023. `20260706v2` is such a date with a revision marker after it." | true | Arithmetic on the lock strings. The bibliography says the same at its line 300, calling it a revision letter where this chapter says marker, which is a wording difference rather than a disagreement | |
| "The last two database rows are the same two entries the lock also lists under a separate `managedData` key, `deacon-panhuman` and `deacon-ribokmers`." | true | `managedData[]` is exactly `{"id": "deacon-panhuman", "displayName": "Human Read Removal Data"}` and `{"id": "deacon-ribokmers", "displayName": "Ribosomal RNA Removal Data"}`, matching the last two `databases[]` ids and display names | |
| "Run `lungfish-cli tools update --plan`, which compares what is on disk against what the lock pins and prints the work that is outstanding without doing any of it. It exits with status 10 when work is pending ... An exit status of 0 means the machine matches the lock." | true | Live `tools update --help`. Overview: "With --plan (the default), prints the pending work without changing anything." Exit codes block: "0 nothing to do, or the update was applied" and "10 work is pending (--plan only)". Option help: "--plan  Print the plan and exit 10 if work is pending". Verified from live help rather than the DRIFT transcription the author relied on | |
| "In dependency set 2026.2 that list [`retiredEnvironments`] is empty, so this release retires nothing." | true | `d["retiredEnvironments"]` is `[]` | |
| "either type the quoted full path `\"/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli\"`" | true | `ls "/Applications/Lungfish Preview.app/Contents/MacOS/"` lists `Lungfish` and `lungfish-cli` | |
| The quoted `version --tools` block, its first six lines | true | Byte for byte against the live run, allowing for the disclosed BBTools elision. `Lungfish 2026.9.13`, `Dependency set: 2026.2 (2026-08-18)`, blank, `Bundled and Managed Tools`, the header row `Tool Version Source Environment Executables`, the rule row, then micromamba, BBTools, BCFtools in that order | |
| "It prints the app version, the dependency set with the date it was cut, and then the first table of this appendix, in five columns headed Tool, Version, Source, Environment, and Executables." | true | Live output header row reads exactly those five column names | |
| "Its eighteen rows agree with the first table of this appendix on every version, environment, and executable" | true | I compared the live 18 rows against the lock cell by cell. Every version, environment, and executable list agrees. micromamba's Environment prints as `-` where the appendix writes "(bundled in the app)", which the chapter's own bootstrap sentence already explains | |
| "it writes display names such as `SAMtools` and `Trim_Galore` where the lock stores identifiers such as `samtools` and `trim_galore`" | false | The command prints `Samtools`, not `SAMtools`. `Sources/LungfishWorkflow/Conda/ManagedToolLock.swift:39` reads `case "samtools": return "Samtools"`, and the live output row is `Samtools 1.24 managed samtools samtools`. `Trim_Galore` is right. The chapter names a display name the command does not write, and the mistake is easy to make because the bibliography's own table writes `SAMtools`, which is the tool's real capitalisation and not what this command prints | "it writes display names such as `Samtools` and `Trim_Galore` where the lock stores identifiers such as `samtools` and `trim_galore`" |
| "it prints a Source column of `bundled` or `managed` in place of this appendix's License column, because the command reads the license field but does not print it" | true | Live output shows `bundled` for micromamba and `managed` for the other 17. The lock has no `source` field, so the value is derived from which key the entry came from, which the chapter does not overclaim | |
| "The command sorts alphabetically by display name while this appendix keeps the lock's own order" | true | Live order is BBTools, BCFtools, Cutadapt, Deacon, Fastp, HTSlib, Nextflow, openpyxl, pigz, pysam, Samtools, SeqKit, Snakemake, SRA Tools, Trim_Galore, UCSC bedGraphToBigWig, VSEARCH after micromamba, which is case-insensitive alphabetical. The appendix follows the lock array order | |
| "It prints nothing about plugin pack tools, pipelines, or databases" | true | The live output ends after the eighteenth row. No further sections | |
| "The [Tool Bibliography](bibliography.md) ... is built from the same lock file, so the two agree on every version." | true | Verified row for row, see Consistency below | |

## Front matter

`title`, `chapter_id`, `audience`, `prereqs`, `tags`, `tools`, `shots`,
`illustrations`, `features_refs`, `fixtures_refs`, `brand_reviewed`, and
`lead_approved` are all present and well formed. `shots: []` with no body
markers matches the DRIFT screenshot verdict of "not applicable".

The anchor `<a id="appendix-tool-versions"></a>` is present, on line 21,
immediately after the front matter and before the first H2. Four chapters
link to it and none is broken.

`entry_points` reads `"CLI: lungfish-cli version --tools"`, which is the
CONSISTENCY spelling of the command name and the command that actually runs.

All nine `glossary_refs` resolve. A per-anchor grep of `GLOSSARY.md` returns
exactly one match for each of `conda`, `dependency-set`, `micromamba`,
`pinned`, `plugin-pack`, `provenance`, `provenance-sidecar`,
`reproducibility`, and `tool-lock-manifest`. Every one of the nine is also
linked from the body, so no ref is dead weight.

`estimated_reading_min: 14`, raised from 6. The page is roughly 1,400 words of
prose plus 59 table rows. The Bibliography, a comparable page, sits at 26. The
figure is proportionate and I have no correction.

`parameters_refs` is absent, correctly. This chapter documents no operation
and no setting, so the campaign rule requiring `parameters_refs` does not
apply to it.

## Consistency

Naming. "Lungfish Genome Explorer (LGE)" at first mention on line 25, "LGE"
throughout after. The command is `lungfish-cli` in all seven places it
appears, never bare `lungfish`, which is the DRIFT-era spelling. The installed
build is named only inside a quoted path.

Menu path. **Tools > Plugin Manager...** (Cmd-Shift-B) matches
`CONSISTENCY.md:34` exactly, including the ellipsis and the hyphenated
shortcut.

Prose rules. Zero em dashes. Zero semicolons outside the one license cell
noted above. No colon inside a sentence. Ten H2 sections, no bulleted or
numbered list anywhere in the body, so the five-bullet and two-list caps are
met trivially. `LUNGFISH_MANUAL_STRICT=1 lint-chapter.sh` reports
"no issues found", exit 0, which I reran myself rather than trusting the
author's transcript.

Bibliography agreement, checked row by row rather than sampled.

- Always-installed. Both pages carry 18 rows. Every version matches, including
  micromamba 2.9.0-0 and Trim Galore 2.3.0. The two pages differ only in name
  form, this chapter using the lock identifiers and the Bibliography using
  citation-style display names such as `SAMtools` and `Trim Galore`. That is a
  deliberate split and not a disagreement, though it is the same split that
  produced the false `SAMtools` claim above.
- Pack tools. Both carry 23 rows across the same 10 packs. Every version
  matches.
- Pipelines. Both carry viralrecon 3.0.0 and TaxTriage v3.3.8. This chapter
  adds the pinned commit, which the Bibliography omits. An addition, not a
  conflict.
- Databases. The Bibliography groups 16 lock entries into 8 rows by shared
  version. Expanding its groups gives 8 + 1 + 2 + 1 + 1 + 1 + 1 + 1, which is
  16, at the same versions as this chapter's 16 rows.

One cross-chapter gap the editor should know about, not a defect in this
chapter. The Bibliography states at its line 197 that `gatk-core`, `phasing`,
and `wastewater-surveillance` install only through the Plugin Manager, because
the command-line installer rejects them. This chapter names all ten pack IDs
and then offers `lungfish-cli conda install --pack read-mapping` without that
caveat. The example it gives is one of the seven that work, so nothing it says
is false, but a reader who substitutes `phasing` into that command will hit an
unknown-pack error the page did not warn about.

The three source-policy words, the conda gloss, the plugin pack gloss, and the
lock-file gloss all match the shapes the Bibliography uses for the same ideas.

## App defects

No new app defect. The lock parses cleanly, `version --tools` exits 0 and
agrees with it on all 18 rows, `tools update --help` documents exit 10 as the
chapter says, and `taxtriage run --help` carries the pinned revision as its
default.

One documentation-adjacent observation, recorded rather than filed. The Source
column that `version --tools` prints is derived from which lock key an entry
came from, `bootstrap` against `tools`, rather than read from a field. The old
page presented it as lock data and invented a BSD-3-Clause license for
micromamba that the lock does not carry. This rewrite drops the column and says
the license is not recorded, which is the right call.

## Notes for the editor

Two corrections, both small and both in prose rather than in a table cell.

The in-app lock path is wrong. The file is inside the SwiftPM resource bundle,
not at the top of `Contents/Resources`. The corrected path is in the claim
table. The author flagged this as inferred rather than checked, and it turned
out to be the one inference that did not hold.

The `SAMtools` example in the "On the command line" section names a display
name the command does not print. It prints `Samtools`. Swapping the one letter
fixes it, and `Trim_Galore` in the same sentence is already right.

Two things worth considering, neither of them errors.

The ucsc-bedgraphtobigwig License cell replaces the lock's semicolon with a
comma. The chapter twice claims every cell is the lock's own field, so
restoring the semicolon would make that claim exactly true. Against that, the
house prose rule bans semicolons, and the lint passes as written, so this is
the editor's call rather than mine.

The pack-install example would be safer with the Bibliography's caveat beside
it, since three of the ten pack IDs this chapter lists cannot be installed by
the command it demonstrates.

## Counts

Claims checked: 36. True: 32. False: 3. Unverifiable: 1.

The three false claims are the in-app lock path, the `SAMtools` display name,
and the comma-for-semicolon in the ucsc-bedgraphtobigwig license cell. The one
unverifiable claim is the Viral Recon wizard's version field, which a GUI check
would settle.

Table cells verified against the lock: 18 always-installed rows at five columns,
23 pack rows at six columns, 2 pipeline rows at four columns, 16 database rows
at five columns. 59 rows, 306 cells, one of which differs from the lock by a
single punctuation mark.
