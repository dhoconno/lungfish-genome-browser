# Fidelity review: 07-assembly/04-extracting-contigs

Reviewed against `Sources/`, the CLI help dump at
`docs/user-manual/reviews/fidelity-2026-09/cli-help/extract.txt`, the registry
entry `assemble.extract-contigs` in `docs/user-manual/parameters.yaml`, the
reality map at `ground-truth/07-assembly.md`, `CONSISTENCY.md`, and the
author's eight real runs under
`scratchpad/assembly-extract/`. Every numeric figure in the chapter was
recomputed from the run folder and the four bundles the author left behind.
Nothing was seen on screen, matching the author's own disclosure.

## Claim table

| Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|
| "MEGAHIT produced three contigs" of 16,711, 362, and 332 bases | true | `final.contigs.fa.fai` in `Analyses/megahit-20260907-050500/` gives k141_1=16711, k141_2=362, k141_0=332. | |
| "together under 4% of the assembly" (the two fragments) | true | 362+332=694 of 17,405 total, 3.99%. | |
| "LGE writes the selected contigs to a new FASTA ... builds a FASTA index beside it ... assembles a `.lungfishref` bundle around the pair, and writes a provenance record" | true | `ExtractContigsCommand.swift:300-340` writes the subset FASTA and calls `ReferenceBundleBuilder`; `recordProvenance` at `:75-122`. The bundle holds `genome/sequence.fa` and `genome/sequence.fa.fai`. | |
| "The FASTA inside a derived bundle is left uncompressed, unlike the one inside an assembly bundle" | true | `ExtractContigsCommand.swift:335` passes `compressFASTA: false`. The author's bundle holds a plain-text `genome/sequence.fa`, read directly here. | |
| "An assembly bundle is already a `.lungfishref`, so any reference picker in LGE will accept it whole" | true | `AssemblyBundleBuilder.swift:101`, and reality map claim 5. | |
| "A derived bundle carries a small metadata block naming the assembler, the source assembly, and the contigs you picked" | true | Every one of the four manifests carries a `Derived Subset` group with `Assembler`, `Source Assembly`, `Selected Contigs`, `Contigs`, `Total Length`, and `GC Content`. | |
| "nothing about extracting consumes or alters the original" | true | `buildBundle` reads the source catalog and writes only into `Reference Sequences/` and a temp directory it deletes. | |
| Procedure 1: "Open the assembly bundle from `Analyses/` in the sidebar" | true | `AnalysesFolder.createAnalysisDirectory`; the author's run folder is `Analyses/megahit-20260907-050500/`. Matches `CONSISTENCY.md`. | |
| Procedure 1: contig table lists "rank, name, length in bases, GC percent, share of the assembly, and a preview" | true | `AssemblyContigTableView.swift:18-46` declares exactly `#`, `Contig`, `Length (bp)`, `GC %`, `Share of Assembly (%)`, `Sequence Preview`. | |
| Procedure 1: "There is no coverage column." | true | Same six columns, no coverage among them. | |
| Procedure 2: bar reads "1 contig selected" or "3 contigs selected", and "Select contigs to materialize" while nothing is chosen | true | `AssemblyActionBar.swift:60-69` builds both strings verbatim, including the singular. | |
| Procedure 3: "All four of its buttons stay disabled until at least one row is selected." | true | `AssemblyActionBar.swift:61-64` sets `isEnabled = hasSelection` on all four. | |
| Procedure 3: the others are "BLAST Contigs", "Copy FASTA", "Export FASTA", and with one contig the first reads "BLAST Contig" | true | `AssemblyActionBar.swift:10-13` for the titles, `:65` for the singular retitle. | |
| Procedure 4: row titled `Create Reference Bundle`, detail names how many sequences, can be cancelled | true | `ViewerViewController.swift:2413-2422` sets that title, the detail "Creating a reference bundle from N selected FASTA sequence(s)...", and a cancel callback. | |
| Procedure 4: Operations Panel opens with "Operations > Show Operations Panel (Cmd-Shift-P)" | true | `MainMenu.swift:866-868`. Matches `CONSISTENCY.md`. | |
| Procedure 5: "Find the new bundle under `Reference Sequences/`" | true | `ExtractContigsCommand.swift:305` calls `ReferenceSequenceFolder.ensureFolder`. All four of the author's bundles landed there. See Consistency for the `Extractions/` question. | |
| "Right-clicking a selected row opens the same actions as a menu" | **false** | The context menu's create-bundle item is titled **Extract to New Bundle…**, not **Create Bundle**, and its export item is **Export FASTA…** with an ellipsis. `FASTASequenceActionMenuBuilder.swift:14, 17` set those defaults and `AssemblyResultViewController.swift:295-309` overrides only `blastMenuTitle` (to "BLAST Contig…"). So three of the five titles differ from the action bar's. | "Right-clicking a selected row opens the same actions under slightly different names. **Extract Sequence...**, **BLAST Contig...**, **Copy FASTA**, **Export FASTA...**, and **Extract to New Bundle...**, which is the context menu's name for Create Bundle." |
| Shot caption `contig-context-menu`: menu shows "Extract Sequence, BLAST Contig, Copy FASTA, Export FASTA, and Create Bundle above a separator, with Align with MAFFT and Run Operation below it" | **false** | Two errors. The fifth item is titled **Extract to New Bundle…** (`FASTASequenceActionMenuBuilder.swift:14`). And **Align with MAFFT…** is not in this menu at all. `addItem` returns early on a nil handler (`:138`), and `AssemblyResultViewController.refreshContextMenu` (`:294-309`) never passes `onAlignWithMAFFT`. A repo-wide grep finds it wired only in `FASTACollectionViewController.swift:497` and nulled in the MSA controller. | "The contig table's right-click menu on a selected row, showing Extract Sequence..., BLAST Contig..., Copy FASTA, Export FASTA..., and Extract to New Bundle... above a separator, with Run Operation... below it." |
| "**Align with MAFFT...** builds a multiple sequence alignment and needs at least two contigs selected, so it stays greyed out on a single row." | **false** | The item never appears in the assembly contig menu, so it is absent rather than greyed out. Evidence as above. The two-selection rule at `FASTASequenceActionMenuBuilder.swift:113-118` is real but governs the FASTA collection viewport, not this one. | Delete the sentence. The reality map's Missing row for MAFFT applies to the FASTA collection menu, not to the assembly contig menu. |
| "**Extract Sequence...** takes a sub-range of a contig rather than the whole thing." | true | Wired at `AssemblyResultViewController.swift:297` to `performExtractSelectedSequence`, which presents the sequence extraction dialog through `onExtractSequenceRequested` (`ViewerViewController+Assembly.swift:110-112`). | |
| "**Run Operation...** hands the selection to the FASTQ/FASTA Operations dialog." | true | `AssemblyResultViewController.swift:303-305` and the glue at `ViewerViewController+Assembly.swift:119`. | |
| "BLAST is capped at 50 selected sequences and explains that limit in a tooltip when you exceed it." | true | `FASTASequenceActionMenuBuilder.swift:83-90`, tooltip "Verify with BLAST is limited to 50 selected sequences." | |
| Settings: "Extraction has no dialog." | true | No sheet exists. `performCreateBundle` runs straight off the selection (`AssemblyResultViewController.swift:411-433`). Registry `notes` says the same. | |
| Settings: "there are only two settings in the window" | true | Registry lists exactly two `settings` entries and eight `cli_only` flags. | |
| **Contig selection** paragraph, default and CLI flag `--contig` | true | Matches the registry's first setting field for field. | |
| **Bundle name**: single selection suggests the contig's own full identifier, several suggest `<run folder name>-selected-contigs` | true | `AssemblyResultViewController.swift:312-319` returns `selectedContigs[0]` unchanged for one, else `result.outputDirectory.lastPathComponent + "-selected-contigs"`. | |
| **Bundle name**: "a SPAdes selection suggests something like `NODE_1_length_16697_cov_121.957333`" | unverifiable | The shape is right and matches the reality map's correction to claim 23, but this exact string was never produced. The author's SPAdes run is at `scratchpad/assembly-extract/out-spades/`, and its contig header would settle it. Not load-bearing, since the sentence says "something like". | Confirm the string against `out-spades/contigs.fasta`, or drop the version-specific coverage digits. |
| `--assembly` points at the run folder holding `assembly-result.json`, no default, one of two ways to name a source | true | CLI help: "Managed assembly output directory containing assembly-result.json". `validate()` at `:53-57` enforces exactly one of the two. | |
| `--contigs` reads from a plain FASTA, and the derived bundle records its assembler as `Unknown` | true | `ExtractContigsCommand.swift:315`, `source.result.map(...) ?? "Unknown"`. The author's run 8 bundle `k141_1.lungfishref` records `Assembler = Unknown` and `Source Assembly = final.contigs`. | |
| `--contig-file` reads one name per line, repeatable, combines with `--contig` | true | CLI help marks it repeatable; `:31-32` and `requestedContigs()` merge both sources. | |
| `--output` default is standard output | true | `run()` at `:110-121` writes to stdout when `output` is nil. Author's run 1 printed FASTA to stdout. | |
| `--bundle` is off by default and requires `--project-root` | true | `@Flag ... = false` at `:37-38`; `validate()` at `:67-70` throws "--project-root is required with --bundle". | |
| `--project-root`: "Point it at the `.lungfish` folder holding the assembly" | true | The author's runs passed `HG002-mito.lungfish` and the bundles landed in its `Reference Sequences/`. | |
| `--line-width` default 60, "pass 0 for one unbroken line per record" | **unverifiable in part** | The default of 60 is confirmed (CLI help and `:46-47`), and `validate()` at `:61-63` accepts 0. But no run used 0, so the claim that 0 yields one unbroken line per record is untested. Run 5 confirms 80 works, at 80 bases per line. | Either run `--line-width 0` once, or soften to "and 0 is accepted". |
| `--format` prints text, json, or tsv, default text | true | CLI help: "(values: text, json, tsv; default: text)". | |
| "Extracting the long MEGAHIT contig ... gives a bundle with one sequence of 16,711 bases at 44.3% GC" | true | Recomputed from `genome/sequence.fa` in run 2's bundle: length 16,711, GC 44.3421%, and the manifest records `44.3%`. | |
| "Extracting that contig together with the 362-base fragment gives two sequences totalling 17,073 bases." | true | Run 4's manifest records `Contigs = 2` and `Total Length = 17,073 bp`. | |
| "the bundle's source information records the source assembly's path and the note 'Derived from `<source name>`'" | true | Run 2's `source` block carries `notes: "Derived from megahit-20260907-050500"` and a `source_url` pointing at the run folder. | |
| A `Create Bundle` run that fails reports "Could not resolve the enclosing Lungfish project root" when the assembly sits outside a project | **false** | That string belongs to `AssemblyContigMaterializationAction.Error.projectRootNotFound` (`:19-21`), which is the fallback used only when no viewer callback is installed. In the app the callback is always installed (`ViewerViewController+Assembly.swift:116-117`), so `performCreateBundle` (`:411-421`) takes the `onCreateBundleRequested` branch and this error is unreachable. There the project check is `canWriteProjectOutputs` (`ViewerViewController.swift:2363-2364`), which returns silently without that message. | "A `Create Bundle` run on an assembly that sits outside a project stops before it starts, because there is no `Reference Sequences/` folder to write into. Any other failure raises an alert headed 'Reference Bundle Creation Failed' carrying the underlying message." |
| Any other failure raises an alert headed "Reference Bundle Creation Failed" | true | `ViewerViewController.swift:2388` and `:2449`. | |
| "The human mitochondrial genome is 16,569 bases in the reference record `NC_012920.1`" | true | Recounted from `docs/user-manual/fixtures/human-mito/NC_012920.1.fasta`, 16,569 bases. | |
| "The long HG002 mitochondrial contig is 96.01% of its assembly, with the two fragments at 2.08% and 1.91%." | true | 16711/17405 = 96.0126%, 362/17405 = 2.0799%, 332/17405 = 1.9075%. The column renders `%.2f` (`AssemblyContigTableView.swift:134`), so the app prints exactly 96.01, 2.08, 1.91. This resolves the author's open question about rounding. | |
| "a name already in use gets a counter rather than overwriting anything" | true | `makeUniqueBundleName` at `:353-364`. Author's run 3 reproduced it. | |
| "That run printed the path of the bundle it created on standard output and the line `✓ Created bundle megahit-20260907-050500-subset.lungfishref` on standard error." | true | `run()` at `:98-105` writes the path to stdout and the formatter's success line to stderr. Captured in `run2.err`. | |
| "Without `--bundle-name` the name defaults to `<source>-subset`" | true | `resolvedBundleName` at `:342-351`. | |
| "It creates a second one named `megahit-20260907-050500-subset 2`, stored in a file whose spaces become underscores, so the folder on disk is `megahit-20260907-050500-subset_2.lungfishref`." | true | `makeUniqueBundleName` joins with a space (`:359`); `bundleURL` replaces spaces with underscores (`:366-371`). Both forms are on disk in the author's project, and the manifest's `name` is the spaced form. | |
| "`genome/sequence.fa` holds the selected contigs with their original headers intact" | true | The file's first line is `>k141_1 flag=3 multi=256.0000 len=16711`, the MEGAHIT header unchanged. | |
| "`manifest.json` records the sequence names and lengths" | **unverifiable** | The manifest's top-level `sequences` array is empty in all four bundles. Names and lengths live in the `genome` block and in the Derived Subset metadata (`Total Length`, `Selected Contigs`) rather than in a sequence list. The claim is arguably true of the `genome` block but not of any list a reader would recognise as "sequence names and lengths". | Prefer "`manifest.json` records the bundle's genome files and carries the Derived Subset metadata described above." |
| "Sourcing with `--assembly` lets the command read `assembly-result.json` and record `Assembler` as `MEGAHIT 1.2.9`" | true | Runs 2, 3, and 4 all record `MEGAHIT 1.2.9`. `assemblerDisplayName` at `:419-424` joins `tool.displayName` and `assemblerVersion`, and `assembly-result.json` gives `assemblerVersion: "1.2.9"`. | |
| "The **Create Bundle** button takes the `--contigs` route internally, so a bundle made in the window records `Unknown`" | true | `FASTASelectionReferenceBundleCLI.arguments` builds `["extract", "contigs", "--contigs", sourceURL.path]` and never `--assembly`. Reached from `createReferenceBundleDirectlyFromDurableFASTA` (`ViewerViewController.swift:2400-2410`), which `createReferenceBundle` prefers whenever the selection comes from one durable FASTA. Run 8 reproduces the argument vector and yields `Assembler = Unknown`. See App defects. | |
| "This is the last chapter in Assembly" and the three Next links | true | Four chapter files in the part, this is the fourth. `../04-alignments/01-mapping-reads-to-a-reference.md`, `../05-variants/01-calling-variants-from-amplicons.md`, and `../08-workflows/` all exist. | |
| Before you start: "There is no `Assemblies/` folder." | true | Matches `CONSISTENCY.md` and chapter 02. | |
| Before you start: "the SPAdes run on the same reads produces a single contig" | true | Chapter 02's comparison table gives SPAdes 1 contig of 16,697 bases, and chapter 01 says the same. | |
| Shot caption `create-bundle-action-bar`: one contig selected, so "BLAST Contig, Copy FASTA, Export FASTA, and Create Bundle are all enabled" | true | `AssemblyActionBar.swift:60-69`. The singular retitle at one selection is what the caption names. | |
| Shot caption `derived-bundle-in-sidebar`: bundle "carrying the selected contig's own name because a single contig was selected" | true | `defaultSuggestedName` returns `selectedContigs[0]` for a single selection, and the button passes that as `--bundle-name`. Consistent with the reality map's instruction to recaption off the `-subset` CLI default. | |

## Front matter

Correct, with one loose thread.

`chapter_id`, `title`, `prereqs`, `parameters_refs`, and `fixtures_refs` all
resolve. `parameters_refs: [assemble.extract-contigs]` is the right and only
id. `fixtures_refs: [human-mito]` matches
`docs/user-manual/fixtures/human-mito/`, which holds the paired FASTQ and
`NC_012920.1.fasta` the chapter names. `tools: []` is right, since extraction
runs no managed tool. `features_refs: []` and `illustrations: []` are empty by
choice. `brand_reviewed: false` and `lead_approved: false` are correct for this
stage.

The three `entry_points` all check out. The action bar button
(`AssemblyActionBar.swift:13`), the context menu item (`AssemblyResultViewController.swift:294-309`,
though see the claim table on its title), and the CLI form, which matches the
registry's third entry_point string exactly.

`glossary_refs` lists sixteen terms and every anchor resolves in
`GLOSSARY.md`. One entry is unearned. `n50` appears in `glossary_refs` but the
word N50 never appears in the chapter body, so nothing links it. Drop it, or
the list overstates the chapter's coverage.

The `shots` block declares three ids and the body carries three
`<!-- SHOT: ... -->` markers, one to one, in the same order.

## Settings coverage against parameters.yaml

Complete. Ten settings in the registry, ten paragraphs in the chapter, in the
registry's own order.

| Registry entry | Chapter paragraph | Default agrees? | Flag agrees? |
|---|---|---|---|
| Contig selection (setting) | **Contig selection** | yes, "nothing selected" and the materialize string | yes, `--contig` |
| Bundle name (setting) | **Bundle name** | yes, contig identifier or `<run folder name>-selected-contigs` | yes, `--bundle-name` |
| `--assembly` (cli_only) | **`--assembly`** | yes, none | yes |
| `--contigs` (cli_only) | **`--contigs`** | yes, none | yes |
| `--contig-file` (cli_only) | **`--contig-file`** | yes, none | yes |
| `--output` (cli_only) | **`--output`** | yes, standard output | yes |
| `--bundle` (cli_only) | **`--bundle`** | yes, false | yes |
| `--project-root` (cli_only) | **`--project-root`** | yes, none | yes |
| `--line-width` (cli_only) | **`--line-width`** | yes, 60 | yes |
| `--format` (cli_only) | **`--format`** | yes, text | yes |

Every paragraph follows the three-sentence shape, states the default, and
closes on its flag. Cross-checked against the CLI help dump, which lists
exactly these ten plus the global options the manual does not document
per-chapter. No registry setting is missing and no chapter paragraph is
invented.

## Consistency

**Destination folder. This operation is a legitimate exception to the
`Extractions/` rule, and the chapter is right.** `CONSISTENCY.md:44-50` rules
that "extractions" go under `Extractions/`, and already carries one exception
for Extract Reads in Selected Region. This is a second, and the source is
unambiguous. `ExtractContigsCommand.buildBundle` calls
`ReferenceSequenceFolder.ensureFolder(in: projectRootURL)` at
`ExtractContigsCommand.swift:305` and builds into that directory with no
`Extractions/` path anywhere in the file. The author's four bundles are all in
`HG002-mito.lungfish/Reference Sequences/`, verified on disk. The app path
agrees, because it shells out to the same command. The reason is coherent
rather than accidental. What this operation produces is a reference bundle
meant to be used as a mapping or variant-calling target, not a read
extraction, so it belongs with the other references. **Recommend
`CONSISTENCY.md` be amended to record this as a named second exception**, so a
later chapter does not "fix" the chapter back to `Extractions/`.

**Sibling figures. One real conflict.** Chapter 02's comparison table gives
MEGAHIT a Global GC of **44.6%**, while this chapter says the long contig is at
**44.3%**. Both are defensible and they measure different things. 44.6% is the
whole three-contig assembly, 44.3% is the 16,711-base contig alone, recomputed
here as 44.3421% and recorded as `44.3%` in the manifest. But a reader moving
from chapter 02 to chapter 04 sees two GC numbers for what looks like the same
MEGAHIT result and has no way to tell them apart. **Recommend chapter 04 say
"44.3% GC, which is the contig alone rather than the 44.6% chapter 02 reports
for all three contigs together."** Contig counts, lengths (16,711, 362, 332),
and the total 17,405 agree exactly across the two chapters.

**The MEGAHIT-on-Apple-Silicon ruling is the serious one.** Chapter 01 line 122
tells the reader that "MEGAHIT 1.2.9 currently fails partway through on Apple
Silicon", that LGE's two workarounds do not help, and to "use SPAdes for a
single-organism sample until it is fixed". This chapter's entire worked example
is a MEGAHIT assembly, and Before you start actively steers the reader onto it,
saying the SPAdes run "leaves nothing to choose between". A reader who follows
chapter 01's advice cannot run chapter 04's example at all, and a reader who
follows chapter 04 has been told two pages earlier that it will fail.

The evidence does not support the blanket failure claim. The author's
`assembly-result.json` records `"outcome": "completed"` for a MEGAHIT 1.2.9 run
on Apple Silicon with the workarounds applied (`--num-cpu-threads 2
--no-hw-accel`), producing three usable contigs, and chapter 02's own table
records that same run at 2.7 seconds. So MEGAHIT succeeded here. Chapter 01's
caution and chapter 02's successful run already contradict each other,
independently of this chapter. This is a campaign-level conflict rather than
one this chapter created. **Recommend the editor route it to whoever owns
chapter 01, since either the caution needs narrowing to the conditions under
which it actually fails, or chapters 02 and 04 need a different worked
example.** This chapter should not be the one to change until that is settled,
but it should at minimum acknowledge the caution rather than silently
contradicting it.

**Other cross-chapter checks pass.** The Operations Panel path, the "no
`Assemblies/` folder" statement, the `Analyses/<tool>-<timestamp>/` shape, and
the bold-menu convention all match `CONSISTENCY.md`. Chapter 02 line 150
independently describes the same action bar and the same singular retitle,
agreeing with this chapter. Note that chapter 02 makes the same MAFFT error,
saying right-clicking "adds Extract Sequence..., Align with MAFFT..., and Run
Operation..." to the set. Both chapters need the same correction.

## App defects

**1. Create Bundle loses the assembler in the derived bundle's provenance.
Confirmed, and it is real.** The author reported it and I verified it
independently by reading the argument vector rather than trusting the run.
`FASTASelectionReferenceBundleCLI.arguments` (the whole file, 11-22) builds

```
["extract", "contigs", "--contigs", sourceURL.path] + ["--contig", id]... +
["--bundle", "--project-root", projectURL.path, "--bundle-name", bundleName]
```

There is no `--assembly` anywhere in the file. `ExtractContigsCommand` reads
`assembly-result.json` only on the `--assembly` path, so `source.result` is nil
and line 315 falls through to the literal `"Unknown"`. The author's run 8
reproduces the exact vector and yields a bundle recording
`Assembler = Unknown` and `Source Assembly = final.contigs`, against
`MEGAHIT 1.2.9` and `megahit-20260907-050500` for the same selection made with
`--assembly`. Both manifests are on disk and I read them. The button holds
`currentResult`, so it has the run folder available and this looks fixable by
preferring `--assembly` when the source is a managed run. Route to engineering.

**2. New, found in this review. The assembly contig context menu is missing
Align with MAFFT.** `AssemblyResultViewController.refreshContextMenu`
(`:294-309`) constructs `FASTASequenceActionHandlers` without passing
`onAlignWithMAFFT`, which defaults to nil (`FASTASequenceActionMenuBuilder.swift:18`),
and `addItem` returns early on a nil handler (`:138`). So the item is never
built for this viewport. The same builder does produce it for the FASTA
collection viewport (`FASTACollectionViewController.swift:497`). Aligning two
selected contigs is a reasonable thing to want from an assembly, and the
separator logic at `:112` still fires because `onRunOperation` is non-nil, so
the menu renders a separator above a single item. Either an oversight in the
wiring or a deliberate omission that is not recorded anywhere. Worth a decision
from engineering. Both this chapter and chapter 02 currently document the item
as present.

**3. Bundle name collision shows two different strings.** Confirmed, not a
fault. `makeUniqueBundleName` joins the counter with a space (`:359`) while
`bundleURL` replaces spaces with underscores (`:366-371`), so the sidebar shows
`megahit-20260907-050500-subset 2` and Finder shows
`megahit-20260907-050500-subset_2.lungfishref`. Both are on disk. The chapter
is right to state both forms.

**4. The reality map's claim 14 verdict needs correcting, and the author is
right.** DRIFT claim 14 says the in-app button "is routed to the viewer, not to
the CLI helper" and that the claim it shells out to `extract contigs` "is not
accurate for the in-app path". The first half holds. The second does not.
`createReferenceBundle` (`ViewerViewController.swift:2361-2378`) prefers
`createReferenceBundleDirectlyFromDurableFASTA` whenever the selection comes
from exactly one durable FASTA source in FASTA format with all identifiers
matched, which is the ordinary assembly case, and that method builds a
`lungfish-cli extract contigs ... --bundle` invocation and runs it through
`LungfishCLIRunner` (`:2400-2420`). It is a real OperationCenter operation and
a CLI call at the same time. The map's own claim-4 correction is unaffected and
remains right. **Recommend the DRIFT entry for claim 14 be amended.** The
chapter itself sidesteps this by describing the operation the reader sees and
never asserting either routing, which is the right call.

## Notes for the editor

The chapter is in strong shape. Every number in it is real, measured from
runs whose outputs I recomputed rather than trusted, and the ten Settings
paragraphs are a clean match to the registry. The drift report's seven false
and eight changed claims are all applied correctly. The failures below are
narrow.

Three corrections are needed before this ships.

1. The context menu item titles. Three of the five differ from what the
   chapter says, and the shot caption would send the Screenshot Scout looking
   for a **Create Bundle** item that is not there. Fix the prose paragraph and
   the `contig-context-menu` caption together.
2. The **Align with MAFFT...** sentence must go. The item is absent from this
   menu, not disabled. This is the one place the chapter tells the reader
   something they can look for and fail to find.
3. The "Could not resolve the enclosing Lungfish project root" quotation is
   from a code path the app never reaches. The failure mode is real, the
   quoted string is not what a reader would see.

Two softenings are worth making. `--line-width 0` is documented as producing
one unbroken line per record but was never run, and `manifest.json` does not
carry a sequence name and length list in the form the chapter implies.

Two items belong outside this chapter. The MEGAHIT Apple Silicon conflict with
chapter 01 is the more urgent, because as things stand the part contradicts
itself about whether the reader can run this chapter's example at all. And
`CONSISTENCY.md` should record the `Reference Sequences/` destination as a
named exception to the `Extractions/` rule, so this does not get "corrected"
later.

The author's Not verified section is honest and mostly holds. Two of its open
questions are now closed. The Share of Assembly rounding is `%.2f`
(`AssemblyContigTableView.swift:134`), so the chapter's 96.01, 2.08, and 1.91
are exactly what the app prints. And the Create Bundle argument vector is
confirmed by reading, which is what the task asked for in place of clicking the
button. What remains genuinely unseen is the window itself, so the three shot
captions still need a capture pass to confirm, and the two corrected captions
above should be fixed before that capture happens rather than after.

Lint is green. `LUNGFISH_MANUAL_STRICT=1` reports no issues. Prose rules pass
on inspection too. No em dashes, no semicolons, no in-sentence colons, "Lungfish
Genome Explorer (LGE)" at first mention and "LGE" after, and the human
mitochondrial example satisfies the human-data-first rule.

## Counts

44 true, 4 false, 3 unverifiable.

Front matter correct with one unearned `glossary_refs` entry (`n50`). Settings
coverage complete, ten of ten against the registry. Destination folder ruled a
legitimate exception to `Extractions/`. Two app defects confirmed (Create
Bundle records Assembler Unknown, collision name shows two forms), one new app
defect found (Align with MAFFT missing from the assembly contig menu), one
DRIFT verdict to amend (claim 14), and one cross-chapter conflict to route
(MEGAHIT on Apple Silicon, chapter 01 versus chapters 02 and 04).
