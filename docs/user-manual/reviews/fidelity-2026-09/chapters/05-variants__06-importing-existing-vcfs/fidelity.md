# Fidelity review, chapter 31: 05-variants/06-importing-existing-vcfs

Reviewer: manual-fidelity-reviewer. Date: 2026-09-07.
Chapter: `docs/user-manual/chapters/05-variants/06-importing-existing-vcfs.md`.
Author report: `author.md` in this directory.

Ground truth used, in campaign order: the Swift source under `Sources/`, the
CLI at `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`,
the help dumps under `reviews/fidelity-2026-09/cli-help/`, and
`docs/user-manual/parameters.yaml`. Every number the chapter quotes was
recounted independently with `bcftools 1.24` and `sqlite3` against copies of
the fixture under the author's scratch. The installed Preview app was not
driven, so claims that need a live window are marked unverifiable and say what
would settle them.

## Claims

| # | Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "If a reference bundle is open in the viewport when you import, the VCF attaches to that bundle as a new variant track." | true | `AppDelegate+ImportCenter.swift:47-59`, `importVCFFromURL` takes `viewerController?.currentBundleURL` and calls `performVCFImport` when it is non-nil | |
| 2 | "If no bundle is open, LGE asks you to name a new bundle it will build around the VCF alone, then quietly tries to fetch a matching reference sequence from NCBI in the background." | true | `AppDelegate+ImportCenter.swift:59` falls through to `loadVCFFilesInBackground`; `MainSplitViewController+GenomicsDisplay.swift:177-181` prompts, `:217-227` starts `downloadReferenceForNakedBundle` | |
| 3 | "If no project is open at all, it refuses and tells you to open or create one." | true | `MainSplitViewController+GenomicsDisplay.swift:155-165`, alert `No Active Project` | |
| 4 | "There is no inference readout, no dropdown of candidate references, and nothing on screen that names a matched bundle." | true | `importVCFFromURL` (`AppDelegate+ImportCenter.swift:39-61`) makes no inference; no such string exists in `Sources/`. Confirms reality-map rows 12, 13, 14 | |
| 5 | "`lungfish-cli import vcf` validates the file, prints a summary of what is inside it, copies it into a directory, and stops. It builds no bundle, attaches no track, and matches no reference." | true | `ImportCommand.swift:955-1055`; confirmed by a live run whose output directory held only the VCF, its `.tbi`, and provenance sidecars | |
| 6 | "A second command, `lungfish-cli bundle create --variant`, does build a bundle carrying the VCF" | true | `bundle.txt:96` `--variant <variant>  Variant file(s) to include`; the author's run produced `HG002_chr20_slice.lungfishref` with a populated `variants/` folder, which I re-read | |
| 7 | "The two earlier chapters in this part called variants on the fixture's own reads twice, once with bcftools and once with LoFreq, and produced 1,056 and 862 rows." | true | `docs/user-manual/fixtures/hg002-chr20/README.md` Variant calls section; corroborated by chapter 01 line 138 and chapter 02 line 45 | |
| 8 | "Download the file `HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz` and its index `HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz.tbi`" | true | Both committed at `docs/user-manual/fixtures/hg002-chr20/`, 39,454 and 393 bytes | |
| 9 | "The `.tbi` is a tabix index ... and LGE picks it up automatically when it sits beside the data file." | true | `ImportCommand.swift:1040-1055` copies a companion `.tbi` or `.csi`; `VCFImportHelper.swift` `ensureIndexedVCFGzip` builds one when absent | |
| 10 | "No plugin pack is needed for the import. LGE reads and writes VCF with code built into the app." | true | The import path is `VCFImportHelper` / `VCFAutoIngestor`, both in-app Swift with no managed-tool dependency. `import.vcf` carries `gating: []` in `parameters.yaml:1566` | |
| 11 | "Choose **File > Import Center...** (Cmd-Shift-I)." | true | `MainMenu.swift:207-212`, title `Import Center…`, `keyEquivalent: "i"` with `[.command, .shift]` | |
| 12 | "Click the **Variants** tab." | true | `ImportCenterViewModel.swift:177` `case .variants: return "Variants"` | |
| 13 | "One card sits there, titled **VCF Variants**" | true | `ImportCenterViewModel.swift:393-410` is the only card with `tab: .variants` | |
| 14 | "described as importing variant calls from VCF files" | true | `ImportCenterViewModel.swift:395`, description `Import variant calls from VCF files. Supports plain text and gzipped VCF with tabix indices.` The chapter paraphrases rather than quotes, which is fair | |
| 15 | "hinting `.vcf, .vcf.gz` underneath" | true | `ImportCenterViewModel.swift:397` `fileHint: ".vcf, .vcf.gz"` | |
| 16 | "Click its **Import...** button." | true | `ImportCenterView.swift:230` `Button("Import…")`. The chapter writes three dots where the source has a single ellipsis character, which is the manual's normal convention | |
| 17 | "The panel accepts more than one file at a time" | true | `ImportCenterViewModel.swift:404` `allowsMultipleSelection: true` | |
| 18 | "it offers only the `.vcf` and `.gz` extensions, so a `.bcf` cannot be chosen here even though the command line accepts one" | true | `ImportCenterViewModel.swift:399-402` allows only the `vcf` and `gz` extensions; `ImportCommand.swift:939` accepts `["vcf", "bcf"]` | |
| 19 | "You can skip the Import Center entirely by dragging the VCF from Finder straight onto the open bundle in the viewport. That runs the same import." | unverifiable | `AppDelegate+MenuActions.swift:268-280` posts `sidebarFileDropped` into the same pipeline, which supports "the same import". But the source I read routes a drop through the sidebar import pipeline, and I could not confirm from source that the viewport itself is a drop target for a VCF. A live drop onto the viewport in the Preview app would settle it | |
| 20 | "a row titled `Importing HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz` with a detail line reading `Importing VCF variants (Auto)...`" | true | `AppDelegate+ImportCenter.swift:1075-1076`, title `"Importing \(vcfURL.lastPathComponent)"`, detail `"Importing VCF variants (\(profileLabel))..."`; `:1508-1519` maps `.auto` to `Auto` | |
| 21 | "where `Auto` names the import profile from Settings" | true | `AppDelegate+ImportCenter.swift:1051-1052` reads `selectedVCFImportProfile()` from `AppSettings.shared.vcfImportProfile` and labels the row with it | |
| 22 | "LGE compresses the VCF with bgzip and builds an index if it needs one, writes the rows into a SQLite database inside the bundle's `variants/` folder ... and records a provenance entry" | true | `VCFImportHelper.swift` `ensureIndexedVCFGzip`; `AppDelegate+ImportCenter.swift:1061-1064` writes the `.db` under `variants/`; provenance at `VCFAutoIngestor.swift:428-500` | |
| 23 | "Only one operation can hold a bundle at a time, so if a variant-calling run is still going you will be told to wait" | true | `AppDelegate+ImportCenter.swift:1042-1048` guards on `OperationCenter.shared.canStartOperation(on:)` and shows `Operation in Progress`; `OperationCenter.swift:305-313` | |
| 24 | "If the import fails on a permissions check before it starts, the project folder is not writable by you. That check runs on every VCF import on every path." | false | The gate runs on the attach path (`AppDelegate+ImportCenter.swift:48-53`) and on the naked path (`MainSplitViewController+GenomicsDisplay.swift:145`), but `importVCFToBundle` runs it only when a bundle is already open (`AppDelegate+MenuActions.swift:296-304`, the `if let bundleURL` block). "every path" also overstates coverage given that orphaned action | Say the check runs before the import on both the Import Center and the drag-drop paths, and drop "on every path" |
| 25 | "The table drawer along the bottom of the viewport opens by itself, because the bundle now carries variant tracks." | true | Matches chapter 01 line 94, which states the same behaviour for the same bundle, and CONSISTENCY.md's table-drawer paragraph. Consistent across the reviewed set | |
| 26 | "Every track in the bundle loads into the one table at once. You do not open the benchmark track separately, and there is no per-track node in the sidebar to click." | true | Reality-map standing note (rows 16, 33, 34); `+Columns.swift:146` aggregates tracks; corroborated by chapter 02 line 188 | |
| 27 | "The `Source` column names the file each row came from" | true | `AnnotationTableDrawerView+Columns.swift:322` `(sourceColumn, "Source", 100, 60, "source")`; `+TableView.swift:521` renders `annotation.sourceFile` | See note 2 below, which qualifies this for a CLI-built bundle |
| 28 | "An alert appears titled **Name Imported Variant Bundle**, with a message naming the project folder the bundle will be saved into and a text field pre-filled with the VCF's base name. Buttons read Create and Cancel." | true | `MainSplitViewController+GenomicsDisplay.swift:256-270`, `messageText = "Name Imported Variant Bundle"`, informative text carries `projectDirectory.path`, `NSTextField(string: defaultName)`, buttons `Create` and `Cancel`; default name at `:168-173` strips two extensions | |
| 29 | "Click Create and LGE builds a variant-only bundle, a `.lungfishref` bundle holding variant rows and no reference sequence, then opens it in the viewport." | true | `VCFAutoIngestor.swift:259` writes `genome: nil` and the note `Variant-only bundle created by auto-ingestion`; `MainSplitViewController+GenomicsDisplay.swift:212-214` calls `displayReferenceBundleViewportFromSidebar` | |
| 30 | "If the name you typed matches a bundle the project already has, the existing one is replaced, so type carefully." | true | `MainSplitViewController+GenomicsDisplay.swift:274-277` sets `replaceExisting` from `FileManager.default.fileExists`, passed to `VCFAutoIngestor.ingest` as `replaceExistingBundle` | |
| 31 | "The bundle records a `Default Ploidy` value under an Import Settings group in its manifest, set to `auto` for a single-file import and to `haploid` when several VCFs were imported together and merged into one track." | true | `VCFAutoIngestor.swift:253` `vcfURLs.count > 1 ? "haploid" : "auto"`; `:270-276` writes it as a `MetadataItem` labelled `Default Ploidy` inside a `MetadataGroup` named `Import Settings` | |
| 32 | "LGE reads the VCF's contig lines and record names looking for an assembly it recognises or an NCBI accession it can fetch, and when it finds one it downloads that reference in the background" | true | `MainSplitViewController+GenomicsDisplay.swift:217-227` fires on `result.ncbiAccessions` or `inferredReference.accession`; `VCFReferenceInference.swift:133-201` | |
| 33 | "The benchmark VCF's header still carries the full GRCh38 contig list, so this path tries to fetch a human reference for it, which is a large download for a 500 kb example." | true | The header carries 195 `##contig` lines (`bcftools view -h ... \| grep -c '^##contig'`), which is the whole GRCh38 primary set. The "tries to fetch" half follows from claim 32 | |
| 34 | "An alert titled **No Active Project** tells you to open or create a project first, and explains that VCF imports are saved as `.lungfishref` bundles inside the active project." | true | `MainSplitViewController+GenomicsDisplay.swift:158-160`, both the title and the informative text quoted verbatim | |
| 35 | "The VCF Variants card carries no controls of its own. It opens a file panel and imports what you give it." | true | `ImportCenterViewModel.swift:402-408`, `importKind: .openPanel`; `parameters.yaml:1573` `settings: []` | |
| 36 | "**Import profile.** ... The default is Auto, and the alternatives are Fast and Low Memory" | true | `GeneralSettingsTab.swift:62-66`, a three-value segmented picker tagged `auto`, `fast`, `lowMemory`; `selectedVCFImportProfile()` returns `.auto` for an empty setting (`AppDelegate+ImportCenter.swift:1492`) | |
| 37 | "It lives in **Settings > General** under a **VCF Import** heading" | true | `GeneralSettingsTab.swift:61` `Section("VCF Import")` | |
| 38 | "it applies to every VCF import the window performs" | unverifiable | The attach path reads it (`AppDelegate+ImportCenter.swift:1051`). I did not find the naked path reading `vcfImportProfile` at all, so `VCFAutoIngestor` may ignore it. Reading `VCFAutoIngestor.ingest` for a profile parameter, or running both paths with Low Memory set and comparing, would settle it | If the naked path ignores the setting, say the profile governs an import into an already-open bundle |
| 39 | "the profile in force is named in the Operations panel row so you can tell which one ran" | true | `AppDelegate+ImportCenter.swift:1076`, the detail string interpolates `profileLabel` | |
| 40 | "This setting has no command-line flag." | true | `import.txt:77-92` for `import vcf` lists only `--output-dir`, `--format`, and the global option group. No profile flag reaches the user, though the app passes `--import-profile` to its own internal `--vcf-import-helper` subcommand (`AppDelegate+ImportCenter.swift:1071`) | |
| 41 | "**--output-dir.** ... The default is the current directory ... The short form is `-o`." | true | `import.txt:78-79` `-o, --output-dir <output-dir>  Output project directory (default: current directory)` | |
| 42 | "The benchmark track holds 961 rows across the 500 kb slice" | true | `bcftools view -H \| wc -l` returns 961 on the fixture VCF and 961 on the bundle's `.bcf`; `select count(*) from variants` returns 961 | |
| 43 | "961 differences in 500,001 bases is about one every 520 bases" | true | The `.fai` gives 500,001 bases; 500001 / 961 = 520.29 | |
| 44 | "All 961 benchmark rows read `PASS`." | true | `bcftools query -f '%FILTER\n' \| sort \| uniq -c` returns `961 PASS`; the database agrees, `PASS\|961` | |
| 45 | "All 862 LoFreq rows read `PASS` as well. Every one of the 1,056 bcftools rows reads a bare `.`" | true | Fixture README Variant calls section states both explicitly; corroborated by chapter 02 line 122 | |
| 46 | "Clicking the `PASS` preset chip therefore keeps the benchmark and LoFreq rows and empties the bcftools rows entirely." | true | Follows from claim 45 and the chip's behaviour documented at chapter 02 line 122. Chips are generated from values present in the data (`+Columns.swift:1029-1039`), so a `PASS` chip appears | |
| 47 | "Every benchmark row carries a quality of exactly 50." | true | `bcftools query -f '%QUAL\n' \| sort \| uniq -c` returns `961 50`; the database gives `min(quality)` and `max(quality)` both 50.0 | |
| 48 | "reading a benchmark row's 50 against a bcftools row's 225 compares two numbers on unrelated scales" | true | The fixture README's representative bcftools row carries `225.417`. Chapter 02 line 192 makes the same non-comparability point | |
| 49 | "The `Type` column splits the benchmark into 809 substitutions, 77 deletions, and 75 insertions." | true | `select variant_type, count(*) from variants group by variant_type` returns `SNP 809`, `DEL 77`, `INS 75`, summing to 961 | |
| 50 | "LoFreq called no insertions or deletions at all on this fixture ... so 152 of the benchmark's rows were never in reach of that caller. bcftools called 182 of them." | true | 77 + 75 = 152; chapter 02 line 198 and chapter 01 line 140 both give 182 bcftools indels and zero for LoFreq | |
| 51 | "The benchmark's one sample column, named `HG002`" | true | `bcftools query -l` returns the single line `HG002`; `select name from samples` agrees | |
| 52 | "carries 571 rows called `0/1` and 374 called `1/1`, with sixteen more rows carrying multi-allelic calls such as `2/1`" | true | Genotype counts from the VCF are `0/1` 571, `1/1` 374, `2/1` 11, `1/2` 4, `1/0` 1, and 11 + 4 + 1 = 16. The database agrees row for row. `2/1` is a real value in the file, so the example is well chosen | |
| 53 | "Position 250,527 ... the benchmark reads `0/1` there against a reference `C` and an alternate `T`" | true | The record reads `chr20_10.0-10.5Mb 250527 C T 50 PASS 0/1:...` | |
| 54 | "which agrees with bcftools's `0/1` and with LoFreq's allele frequency of 0.571 at the same position" | true | Chapter 02 line 164 gives the bcftools `0/1` and `AF=0.571429` at coordinate 250527 | |
| 55 | "On this fixture every row of every track reads `chr20_10.0-10.5Mb`." | true | The benchmark VCF's only `CHROM` value is `chr20_10.0-10.5Mb`; the fixture README states the FASTA header was rewritten to the same name and both caller VCFs use it | |
| 56 | "The fixture slice is 500,001 bases long, so a benchmark position of 250,527 is comfortably inside it." | true | `GRCh38.chr20.10.0-10.5Mb.fasta.fai` gives 500001 | |
| 57 | "`lungfish-cli import vcf` reads the header and the records, prints a summary, and copies the file plus any companion `.tbi` or `.csi` into a directory." | true | `ImportCommand.swift:1015-1055`; my run printed `Copied index: HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz.tbi` and left both files in the output directory | |
| 58 | "It ... does not compress or index a plain VCF." | true | The author's `imported-plain/` holds `benchmark-plain.vcf` at 717,032 bytes with no `.gz` and no index, which I re-read on disk | |
| 59 | "Its only options are the positional input file and `--output-dir`." | false | `import.txt:72` shows the command also accepts `--format`, plus the global group (`--verbose`, `--quiet`, `--progress`, `--no-progress`, `--debug`, `--log-file`, `--no-color`, `--threads`). The chapter itself contradicts this at the end of the section, where it says every one of these commands takes `--format` | "Its only options beyond the shared ones every command carries are the positional input file and `--output-dir`." |
| 60 | The quoted Summary block (`Format : VCFv4.2`, `Variants: 961`, `Types : SNP: 809, DEL: 74, INS: 64, OTHER: 14`, `Samples : 1`, `Contigs : 1`, `Samples: HG002`) | true | Reproduced verbatim by my own run of the command against the fixture VCF | |
| 61 | "The type breakdown here counts 14 records as `OTHER` where the bundle's own database sorts the same 961 records into 809 substitutions, 77 deletions, and 75 insertions." | true | 809 + 74 + 64 + 14 = 961 from the CLI, and 809 + 77 + 75 = 961 from the database. Both totals confirmed independently | |
| 62 | "Both totals agree at 961 ... and it matches what `bcftools view -H` counts in the same file." | true | `bcftools view -H \| wc -l` returns 961 | |
| 63 | "`lungfish-cli analyze validate <vcf> --strict` prints a one-line verdict. On the fixture it reports the file valid." | true | My run printed exactly `✓ HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz: Valid VCF file` | |
| 64 | "Passing `--variant` attaches the VCF to a new bundle built around a reference FASTA." | true | `bundle.txt:84-96`, `--fasta` and `--name` and `--output-dir` required, `--variant` optional. The author's run produced exactly that, which I inspected | |
| 65 | The `bundle create` code block's flags (`--fasta`, `--name`, `--variant`, `--organism`, `--assembly`, `--output-dir`) | true | All six appear in `bundle.txt:84-96`. `--organism` and `--assembly` both default to `Unknown` | |
| 66 | "A track attached by `bundle create --variant` is written as a `.bcf` with a `.csi` index beside it and a `.db` SQLite sidecar" | true | The bundle's `variants/` folder holds `hg002.chr20.10.0-10.5mb.benchmark.vcf.bcf`, `.bcf.csi`, and `.db`, which I listed directly. Matches the exception recorded in CONSISTENCY.md's Variant track storage section | |
| 67 | "where the window's own variant calling writes a bgzip-compressed `.vcf.gz` with a `.tbi` index and the same kind of `.db`" | true | CONSISTENCY.md Variant track storage, citing `BundleVariantTrackAttachmentService.swift:71-74` | |
| 68 | "Both are read by the Variants tab and both hold the same rows." | true | Both totals are 961 (`bcftools view -H` on the `.bcf`, `count(*)` on the `.db`). The "read by the Variants tab" half follows from the manifest declaring both paths on the same `VariantTrackInfo` | |
| 69 | "`lungfish-cli variants extract-sample` pulls one sample's calls out to a VCF of their own, and on the fixture's benchmark bundle it writes all 961 rows for the sample `HG002`." | true | My rerun wrote a VCF with 961 non-header lines | |
| 70 | "Asking for the homozygous alternate calls returns 374 rows, which is exactly the count the genotype breakdown above gives." | true | My rerun of `variants query --filter "Sample[HG002].GT=1/1"` wrote 374 non-header lines, matching the 374 `1/1` genotypes counted from the VCF and the database | |
| 71 | "Both commands write a provenance sidecar beside the output" | true | Both my runs left a `.lungfish-provenance.json` beside the output VCF; `VariantsCommand.swift:215-216` | |
| 72 | "both cap the export at 5,000 records unless you raise `--limit`" | false | Only `variants query` has a limit. `VariantsCommand.swift:721-722` declares `--limit` with a default of 5000 and `:752` applies it, while `extract-sample` calls `queryForTable(sampleNames:limit: Int.max)` at `:659` and has no `--limit` in its help (`variants.txt:104-119`) | "`variants query` caps the export at 5,000 records unless you raise `--limit`, and `extract-sample` writes every matching row." |
| 73 | "The cap is silent" | true | `VariantSmartFilter.swift:143-153` compiles a bare `LIMIT` with no count-back and no warning, per reality-map row 31 | |
| 74 | "Every one of these commands also takes `--format` with the values `text`, `json`, and `tsv`, although `import vcf` prints its human-readable summary regardless of what you pass." | true | `--format` with those three values appears in the help for `import vcf` (`import.txt:80-81`), `bundle create` (`bundle.txt:98-99`), `extract-sample` (`variants.txt:107-108`), and `query` (`variants.txt:134-135`). My run of `import vcf --format json` returned the same text block with exit 0 | |
| 75 | Front matter `entry_points` lists the Import Center path, the drag-drop, `import vcf`, and `bundle create --variant` | true | The first three are established above. `bundle create --variant` is real (claim 64). The reality map's suggestion to add `File > Open` was correctly declined, since no menu item carries that selector (see defect 2) | |
| 76 | Front matter `parameters_refs: [import.vcf]` | true | Matches roster row 31 at `DRIFT.md:3757`, which reads `[import.vcf]` with fixture `hg002-chr20` | |
| 77 | Front matter `prereqs` name `05-variants/02-reading-the-variant-browser` | true | That chapter exists and is in review; the chapter leans on its coordinate-250527 example, so the prerequisite is real rather than decorative | |
| 78 | "This is the last chapter in Variants." | true | The roster's Variants rows run 27 to 31, and row 31 is this chapter. Row 32 opens Classification | |

## Front matter checks

**parameters_refs.** `[import.vcf]`, which matches roster row 31 at
`DRIFT.md:3757` exactly. The registry entry at `parameters.yaml:1561-1587`
carries `settings: []` and one `cli_only` flag, `--output-dir`. The chapter's
Settings section documents `--output-dir` in the registry's terms and adds the
Import profile preference, which the registry does not list. That is a gap in
the registry rather than an error in the chapter, since the setting demonstrably
shapes this operation (`AppDelegate+ImportCenter.swift:1051`). Flagging for the
Lead. The registry's `entry_points` list two paths where the chapter lists four,
so it also lags the chapter on drag-drop and `bundle create --variant`.

**Shots.** Three `<!-- SHOT -->` markers in the body, at lines 81, 101, and 107,
and three matching `shots:` entries with captions. Every id resolves both ways
and no marker is orphaned. Both retired ids from the reality map
(`import-center-variants`, `imported-vcf-track-sidebar`) are gone, as the author
intended. One ordering note for the Scout rather than a fidelity fault. The
`shots:` block lists `name-imported-variant-bundle` second while the body places
its marker third, after `imported-benchmark-in-variants-tab`.

**glossary_refs.** All fourteen anchors resolve in `GLOSSARY.md`: `benchmark-vcf`,
`bgzip`, `csi`, `filter`, `genotype`, `import-center`, `provenance`,
`provenance-sidecar`, `reference-bundle`, `table-drawer`, `tabix`,
`variant-only-bundle`, `variant-track`, `vcf`. Each is linked from the body at
first use. The new `Variant-only bundle` entry sits at `GLOSSARY.md:539`,
alphabetised between `Variant-caller` and `Variant track`, in the house shape
with a `See also:` line, and its content agrees with `VCFAutoIngestor.swift:259`
and `:270-276`.

## Defect claims, adjudicated

**Defect 1, `bundle create --variant` writes `variant_count: 0`.** Confirmed and
worth filing. The manifest at the author's bundle carries `"variant_count" : 0`
while `bcftools view -H` on the `.bcf` returns 961 and `select count(*)` on the
`.db` returns 961. One qualification the author did not have. The window heals
this on open. `ViewerViewController+AnnotationDrawer.swift:700-732`
(`syncVariantCountsToManifest`) rewrites each track's `variantCount` from the
live database and saves the manifest. So the wrong number is visible to
`bundle info` on a bundle the window has never opened, and disappears afterwards.
That makes the defect real but narrower than "the count is simply never written",
and it explains why nothing in the GUI chapters ever showed it.

**Defect 2, `importVCFToBundle` is orphaned.** Confirmed. The action is
implemented at `AppDelegate+MenuActions.swift:285-330` with its own file panel,
and validated at `AppDelegate.swift:1951`, but a repository-wide search for the
symbol returns only those two sites and the function's own debug lines. No
`NSMenuItem` in `MainMenu.swift` carries the selector, and the File menu's only
Open item is `Open Project Folder...` (`MainMenu.swift:175-177`). The
`features.yaml:18` entry point is therefore unreachable, and the author was right
to decline the reality map's instruction to document it.

**Defect 3, the Settings picker's `lowMemory` tag.** Confirmed on both halves.
`GeneralSettingsTab.swift:65` tags the option `"lowMemory"` while
`VariantDatabaseModels.swift:237` declares `case lowMemory = "low-memory"`, so
`VCFImportProfile(rawValue:)` fails and only the lowercased fallback at
`AppDelegate+ImportCenter.swift:1499` (`case "lowmemory", "low-memory",
"low_memory"`) rescues it. The picker omits `ultraLowMemory`
(`VariantDatabaseModels.swift:239`), which `importProfileLabel` can still render
as `Ultra Low Memory` (`:1516-1517`). The chapter documents only the three values
a user can pick, which is the right call for the reader.

**Defect 4, `import vcf --format json` is accepted and ignored.** Confirmed by my
own run. `--format json` returned the same human-readable block and exit 0. The
flag is declared in the help (`import.txt:80-81`), so a script has no signal that
it did not get JSON. The chapter warns the reader about this in the last sentence
of the section, which is the right treatment while the defect stands.

**Note 1, the two type classifiers disagree.** Confirmed. `import vcf` reports
`SNP: 809, DEL: 74, INS: 64, OTHER: 14` and the database reports `SNP 809,
DEL 77, INS 75` on the same 961 records. The chapter states the disagreement
rather than picking a side, which is the honest treatment.

**Note 2, the CLI-built database has no `source_file` column.** Confirmed and
more consequential than the author suggests. `.schema variants` on the bundle's
database returns twelve columns (`id`, `chromosome`, `position`, `end_pos`,
`variant_id`, `ref`, `alt`, `variant_type`, `quality`, `filter`, `info`,
`sample_count`) with no source among them. `source_file` lives on the `samples`
table instead (`VariantDatabase+Info.swift:423-432`,
`VariantDatabase+RegionExtraction.swift:377`), and the Variants tab's Source
column renders `annotation.sourceFile` (`+TableView.swift:521`). Claim 27 is
still true for the chapter's own worked example, because that bundle is built by
the window's `VCFAutoIngestor`, which sets `sourceFile` per file
(`VCFAutoIngestor.swift:160`, `:187`, `:205`). It may not hold for a bundle built
by `bundle create --variant`. The chapter never asserts that it does, so no
correction is needed, but the author's request to confirm a CLI-built multi-track
bundle in the window is worth honouring before anyone writes that case up.

## Notes for the Lead

The three false verdicts are all small and local. Claim 24 overreaches on one
word ("every path"), claim 59 contradicts a sentence the chapter itself writes
twenty lines later, and claim 72 attributes a cap to a command that has none.
None of them touches the chapter's argument, and none needs a rewrite.

Two claims are unverifiable without driving the Preview app. Claim 19, that
dropping a VCF onto the viewport runs the same import, and claim 38, that the
Import profile applies to every VCF import the window performs. Claim 38 is the
one worth settling before publication, because a reader who sets Low Memory for a
large import on the naked-bundle path may get no benefit from it.

The registry entry `import.vcf` should gain the Import profile setting and the
two missing entry points, so that a later reader of `parameters.yaml` finds the
same four routes the chapter documents.

Counts: 73 true, 3 false, 2 unverifiable.
