# Fidelity review, 06-classification/10-twelve-s-metabarcoding

Chapter: `docs/user-manual/chapters/06-classification/10-twelve-s-metabarcoding.md`
Roster row 41, registry id `classify.twelve-s-match`. Build: Preview 2026.9.13.
Reviewer date: 2026-09-07.

Method. Every window claim was checked against the Swift source under `Sources/`.
Every command-line claim was checked against `.build/debug/lungfish-cli <cmd> --help`
run fresh, not against the captured dumps. Every quoted number was recomputed from
the author's result bundle in the scratchpad, and the two cheap runs that produce
disputed numbers were rerun. All four of the author's defects were reproduced
independently rather than taken on report.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "12S Amplicon Matching is a specialized workflow rather than a core one, so it does not appear in the menus until you enable it" | true | `WorkflowLibrary.swift:146` `maturity: .specialized`; `MainMenu.swift:821-845` `workflowMenuItem` draws the disabled form | |
| 2 | "Open **Tools > Workflow Library...**" | true | `MainMenu.swift:765-771` adds "Workflow Library…" to the Tools menu | |
| 3 | "under the **Specialized Workflows** heading in the **Genotyping** group" | true | `WorkflowLibrary.swift:207-210` section title "Specialized Workflows"; `:145` `categoryID: .genotyping`; `:257` `displayTitle` returns "Genotyping" | |
| 4 | "turn its **Enabled** switch on" | true | `WorkflowLibraryPanelView.swift:355-365` a `.switch`-styled `Toggle("Enabled", ...)` in `actionView` | |
| 5 | "The card shows a **Specialized** badge beside its title" | true | `WorkflowLibraryPanelView.swift:278-285` renders `item.maturity.displayName` as a badge next to `item.title` | |
| 6 | "a dependency row underneath reading either Ready or Needs install" | true | `WorkflowLibraryPanelView.swift:333-335` `Text(ready ? "Ready" : "Needs install")` | |
| 7 | "which the card names as `Lungfish Tools`" | **false** | The row prints `pluginPackName(for:)` = `PluginPack.builtInPack(id:)?.name` (`WorkflowLibraryViewModel.swift:112-114`). For `lungfish-tools` that name comes from the lock manifest's `displayName` (`PluginPack.swift:424-427`), which is `Third-Party Tools` (`third-party-tools-lock.json`, `displayName`). `Lungfish Tools` is the pack **id**, never shown. | "which the card names as **Third-Party Tools**" |
| 8 | "the switch is replaced by an **Install Dependencies** button" | true | `WorkflowLibraryPanelView.swift:346-351` `if !missingPluginPackIDs.isEmpty { Button("Install Dependencies") }` before the Toggle branch | |
| 9 | "the workflow appears as **Tools > Genotyping > 12S Amplicon Matching...**" | true | `WorkflowLibrary.swift:145` category Genotyping; `MainMenu.swift:823-828` enabled item titled `"<title>…"` | |
| 10 | "the Tools menu still lists the workflow, but greyed out and with the words \"(not enabled)\" after its name" | true | `MainMenu.swift:833-845` title `"\(workflow.title) (not enabled)"` in `NSColor.disabledControlTextColor` | |
| 11 | "Choosing it in that state does not run anything. It raises an alert headed Enable \"12S Amplicon Matching\"?" | true | `MainMenu.swift:837` action is `promptEnableWorkflowFromMenu`; the item stays enabled by design (`:842` comment) so the action can fire | |
| 12 | "whose **Open Workflow Library** button takes you to the card" | true | `AppDelegate+ToolsMenu.swift` `promptEnableWorkflowFromMenu` alert buttons | |
| 13 | "It expects reads that are already merged ... It does not merge pairs for you." | true | `WorkflowOperationsDialog.swift:522-524` helper text "The 12S workflow expects merged FASTQ inputs; paired-read merging should be handled before import." Corrects DRIFT row 8. | |
| 14 | "click **Create 12S Reference...** beside the Reference picker" | true | `WorkflowOperationsDialog.swift:175-178` `Button("Create 12S Reference…")` inside `referencePicker`, gated on the 12S tool kind | |
| 15 | "name lines should read as a common name followed by the scientific name in parentheses" | true | `TwelveSReferenceMetadata.swift:294-305` `parseSpeciesLabel`; reproduced below as defect 2 | |
| 16 | "LGE joins the two on the scientific name" | true | `TwelveSReferenceMetadata.swift:376-390` `bestMatch` tries latin name, then common name, then display name | |
| 17 | "The Workflow Operations dialog opens" | true | `WorkflowOperationsDialog.swift:17` `title: "Workflow Operations"` | |
| 18 | "using its **Choose...** button, or pick one from the Project Reference menu above it" | true | `WorkflowOperationsDialog.swift:160-161` `Picker("Project Reference", ...)`; `:181` `Button(... "Choose…" : "Replace…")` | |
| 19 | "Selecting more than one bundle is allowed and they run together as one batch ... they will run as one batch" | true | `WorkflowOperationsDialog.swift:69-71` `multiBundleRunPolicy` `allowedModes: [.combined]`, `lockReason: "They will run as one batch."` | |
| 20 | "The **Analysis Metadata** picker is optional" | true | `WorkflowOperationsDialog.swift:268-286` `twelveSSampleMetadataPicker`, group label "Analysis Metadata" | |
| 21 | "Leave the **Read Platform** picker on the Illumina setting" | true | `WorkflowOperationsDialog.swift:348-359` `groupLabel("Read Platform")`, `.pickerStyle(.segmented)`; `TwelveSAmpliconReadClassifier.swift:16` displayName "Illumina exact" | |
| 22 | "writes a result bundle into the folder shown under **Directory**" | true | `WorkflowOperationsDialog.swift:530-545` `outputPicker` with `groupLabel("Directory")` | |
| 23 | "It opens on the **Targets** view" | true | `TwelveSAmpliconResultViewController.swift:234` `labels: ["Targets", "Unresolved"]`, `:492` `showTargets()` on load | |
| 24 | "columns for Sample, Scientific Name, Common Names, Group ..., Tax ID, Exact Reads, % of Sample, Refs, and Alternates" | true | `TwelveSTargetTableView.swift:156-164`, all nine titles verbatim and in that order | |
| 25 | "A summary line ... reports four figures separated by vertical bars ... samples, total exact-matching reads, percent unresolved, chimera candidates" | true | `TwelveSAmpliconResultViewController.swift:1554-1564` `summaryText` joins exactly those four with `" \| "`. Settles ground-truth claim 11, previously unverifiable, as **true**. | |
| 26 | "use the **Filter species or matches** field" | true | `TwelveSTargetTableView.swift:169` `searchPlaceholder` is "Filter species or matches" | |
| 27 | "**Learn More About** opens that species' NCBI Taxonomy page ... using its taxid when the reference supplied one and a name search otherwise" | true | `TwelveSCopyMenuProvider.swift:128-130`; `TwelveSSpeciesLinks.swift:16-26` taxid path then `?term=` search | |
| 28 | "**View Photo of** opens its Wikipedia article" | true | `TwelveSSpeciesLinks.swift:29-37` underscored scientific name against `en.wikipedia.org/wiki/` | |
| 29 | "Both open the browser immediately and do not ask for confirmation first" | true | `TwelveSAmpliconResultViewController.swift:1097-1101` calls the handler or `NSWorkspace.shared.open(url)` directly, no alert. Matches the campaign's binding external-link fact. | |
| 30 | "Right-clicking a single species row adds two lookups to the bottom of the context menu" | true | `TwelveSCopyMenuProvider.swift:124-135` guarded by `rows.count == 1`, after `NSMenuItem.separator()` | |
| 31 | "The table lists them with Sequence ..., Reads, Samples, Chimera, and Bases" | true | `TwelveSUnresolvedTableView.swift:17-24`, five titles verbatim | |
| 32 | "click **BLAST Verify** in the action bar at the bottom of the viewport" | true | `ClassifierActionBar.swift:22-80` defines the BLAST Verify button; `TwelveSAmpliconResultViewController.swift:313` `onUnresolvedBlastRequested` | |
| 33 | "The hits appear in a drawer below the table with Organism, Identity, and Accession columns" | true | `BlastResultsDrawerTab.swift:215-225` | |
| 34 | "The menu offers **Export as CSV...**, **Export as TSV...**, and **Export as Excel...**" | true | `TwelveSAmpliconResultViewController.swift:1576-1589` builds `"Export as \(format.displayName)..."` over `allCases`; `TwelveSAmpliconResultExportService.swift:8-20` gives CSV, TSV, Excel and no FASTA | |
| 35 | "The viewport has no FASTA export." | true | Same two sites. `12s-export-unresolved` is the only FASTA route (`--help`, "Output FASTA path") | |
| 36 | "take the `unresolved-sequences.fasta` the workflow already wrote into the result bundle" | true | The rerun bundle contains `unresolved-sequences.fasta`, and `12s-result.json` carries `"unresolvedFastaPath": "unresolved-sequences.fasta"`. Settles ground-truth claim 23, previously unverifiable, as **true**. | |
| 37 | "The dialog carries eight controls and the Inspector's **12S Results** section carries six more" | true | Dialog: Reference, Analysis Metadata, Read Platform, Result Name, Min Soft Clip, Max Indels, chimera toggle, Directory = 8. Inspector: `TwelveSResultDisplaySection.swift:266-378` = 6. | |
| 38 | "The first three sit under the **Target Rows** disclosure and the last two under **Unmatched Reads**." | **false** | `TwelveSResultDisplaySection.swift:238-245`. `Target Rows` holds `filterControls` **and** `taxonomyControls`, which is four of the six: Minimum Exact Reads (`:266-294`), Exclude Human and Only With Alternates (`:308-321`), and Taxon Groups (`:324-336`). `Unmatched Reads` holds the remaining two (`:343-380`). Three plus two also fails to account for all six. | "The first four sit under the **Target Rows** disclosure and the last two under **Unmatched Reads**." |
| 39 | "the field accepts 0 to 1,000,000" (Minimum Exact Reads) | true | `TwelveSResultDisplaySection.swift:289` `in: 0...1_000_000` | |
| 40 | "Taxon Groups ... such as Mammal, Fish, or Bird ... each pill cycles through neutral, included, and excluded" | true | `TwelveSResultDisplaySection.swift:27` `taxonGroupOptions = ["Mammal", "Fish", "Bird", "Reptile", "Amphibian"]`; `:330-334` `TaxonGroupPill` with `cycleTaxonGroup` | |
| 41 | "Chimera ... offering All, Not Reviewed, Not Detected, Candidate, and Confirmed. The default is All." | true | `TwelveSResultDisplayState.swift:5-26`, five cases with those display names, `all` first | |
| 42 | "Minimum Unresolved Reads ... default is 0 and the field accepts 0 to 1,000,000" | true | `TwelveSResultDisplaySection.swift:365` `in: 0...1_000_000`; export help `--min-unresolved-reads (default: 0)` | |
| 43 | "173 merged reads went in, 110 matched exactly, and 63 were left unresolved, giving a 63.6 percent exact-match rate" | true | `read-fate.json` in the author's bundle reads `totalReads 173`, `exactMatchReads 110`, `unresolvedReads 63`. 110/173 = 63.58 percent, which rounds to 63.6. | |
| 44 | "Homo sapiens with 110 exact reads and 100 percent of the sample, and the four other primates ... each at zero" | true | `sample-target-counts.tsv`: Human 110, Chimpanzee 0, Western gorilla 0, Rhesus macaque 0, Cynomolgus macaque 0 | |
| 45 | "56 unresolved clusters, all of them marked not detected, of which 51 held a single read, four held two reads, and one held four" | true | Recomputed from `unresolved-sequences.tsv`: 56 rows, `chimera_status` all `not_detected`, read-count histogram exactly `{1: 51, 2: 4, 4: 1}` | |
| 46 | "Matching the same reads before orienting them found only 35 of the same 110, because the other 75 carried the target on the opposite strand" | true | Author's run 7 gave 35 exact on the unoriented set; the classifier has no reverse-complement pass (defect 3), so 110 minus 35 = 75 is the strand deficit | |
| 47 | "The matcher compares each read as it is given and does not also try the reverse complement" | true | `TwelveSAmpliconReadClassifier.swift:146-175` `classify(readSequence:)` scans `read` only. A grep for reverse-complement across all of `Sources/LungfishWorkflow/TwelveS/` returns nothing. | |
| 48 | Provenance popover "reports the analysis name, the sample count, the exact-read count, the unmatched percent, the creation time, and the path" | true | `TwelveSAmpliconResultViewController.swift:1638-1662` `TwelveSProvenanceSummaryView`, six fields in that order | |
| 49 | "The metadata TSV must carry the columns `seq_id`, `common_name`, `latin_name`, `group`, `taxid`, `name_source`, and `taxonomy`." | true | `TwelveSReferenceMetadata.swift:354`, exactly those seven strings | |
| 50 | "The command's own help text lists only five of those seven and omits `common_name` and `name_source`" | true | Fresh `12s-reference-metadata --help`: "MIDORI-derived metadata TSV with seq_id, latin_name, group, taxid, and taxonomy". Same wording in `12s-reference-bundle --help`. | |
| 51 | "`--ambiguity-resolution` ... defaults to `strict` ... `conservative` ... at least twice the runner-up and at least ten reads" | true | `12s-match --help` verbatim; `FastqTwelveSMatchSubcommand.swift:62` maps conservative to `minFoldRatio: 2.0, absoluteFloor: 10` | |
| 52 | "`--min-soft-clip`" default 1, "`--max-indels`" default 3, "`--matching-mode`" default illumina-exact, "`--chimera-review`" default on | true | `12s-match --help`, all four defaults verbatim | |
| 53 | "The run writes a `.lungfish12s` bundle holding `targets.tsv`, `samples.tsv`, `sample-target-counts.tsv`, `unresolved-sequences.tsv`, `read-fate.json`, a copy of the reference, and `unresolved-sequences.fasta`" | true | Bundle listing confirms all seven. The reference copy is named `reference.fa`, which the chapter describes rather than names, so the sentence is accurate. | |
| 54 | "`read-fate.json` ... holds the total, exact-match, unresolved, ambiguous, and chimera-candidate read counts as five plain numbers" | true | The file has exactly those five keys | |
| 55 | "`--export-format` takes `csv`, `tsv`, or `xlsx`" | true | `12s-export --help` `(values: csv, tsv, xlsx)` | |
| 56 | "`--min-reads` defaults to 5 ... Lower it to 1 to see every cluster." | true | `12s-export-unresolved --help` `(default: 5)`; author's runs 15 and 16 gave 0 records then 56, consistent with the recomputed histogram where every cluster is under 5 reads | |
| 57 | "its `--compress` option currently writes plain text rather than gzip even when the output name ends in `.gz`" | true | Reproduced independently. `fastq orient ... --output /tmp/orient-test.fastq.gz --compress --force` exits 0; `file` reports "ASCII text" and the first bytes are a literal `@D00360:` FASTQ header, not a gzip magic number. | |
| 58 | "the ONT setting recovers indel-only matches the Illumina setting rejects" | true | Rerun `--matching-mode ont-indel --max-indels 3` on the same oriented reads gives `exactMatchReads 113` against 110, unresolved 60 against 63 | |
| 59 | "defaults to the project's 12S amplicon results folder" (Directory) | true | `WorkflowOperationDialogState.swift:1586-1604`. See the folder note below for the exact path. | |
| 60 | "A read that contains a reference sequence exactly is assigned to that reference's species" | true | `TwelveSAmpliconReadClassifier.swift:183-200` `exactMatchedReferences` requires verbatim containment with `minimumSoftClipBases` flank at both ends | |
| 61 | "LGE counts how many reads unambiguously support each candidate species elsewhere in the sample, then assigns the shared read to whichever candidate leads" | true | `TwelveSAbundanceReassigner.swift:58-141` computes per-sample then global unambiguous totals and picks by policy | |
| 62 | "Every such reassignment is recorded in its own channel" | true | `TwelveSAbundanceReassigner.swift:62` accumulates a `moves` array | |
| 63 | "The default is 1, so a read needs at least one base of its own beyond each end of the match" (Min Soft Clip) | true | `12s-match --help` "(default: 1)"; `TwelveSAmpliconReadClassifier.swift:184-186` sets both the lower and the upper scan bound from `minimumSoftClipBases`, so the flank applies at both ends | |
| 64 | "it is greyed out in the Illumina setting" (Max Indels) | true | `WorkflowOperationsDialog.swift:519-520` `.disabled(state.twelveSMatchingMode != .ontIndel)` | |

## Where the result lands

A 12S run's result **does** land under `Analyses/`, in a named subfolder rather
than loose. `WorkflowOperationDialogState.defaultOutputDirectory` builds
`projectURL/Analyses/` (`:1587-1588`, literal `"Analyses"`, matching
`AnalysesFolder.directoryName`) and for `.twelveSAmpliconMatching` appends
`twelveSResultsDirectoryName`, which is the literal string
`"12S amplicon results"` (`:1545`). So the default Directory is

    <project>.lungfish/Analyses/12S amplicon results/

and the bundle inside it is `<Result Name>.lungfish12s`, where Result Name
defaults to the first read file's stem plus `-12s`, or the literal
`12s-amplicons` when no stem can be read (`:1956-1962`).

This is a third shape for `Analyses/`, alongside the two the consistency sheet
already records. It is neither `Analyses/<tool>-<timestamp>/` nor a bundle
written directly under `Analyses/`. It is a fixed, human-readable category
folder, the same shape as `Analyses/Multiple Sequence Alignments/`. The
chapter's phrase "the project's 12S amplicon results folder" is accurate but
does not give the reader the path. Worth naming it, and worth a CONSISTENCY
line, since ONT genotyping and full-length ONT MHC genotyping use the same
category-folder shape from the same switch.

## Front matter

Correct. `chapter_id` matches the path. `parameters_refs` is
`[classify.twelve-s-match]`, the right id. `entry_points` lists the three real
routes and matches the registry's own list, modulo the registry writing the
library route as "Tools > Workflow Library... > 12S Amplicon Matching" against
the chapter's bare "Tools > Workflow Library..."; both are true and the chapter's
form is the one the consistency sheet's menu-path rule prefers.

`tools: [blast, vsearch]` is right. vsearch runs the chimera review
(`--chimera-review` help text names it) and BLAST is the unresolved-cluster
verification path.

Seven `shots` entries, seven `<!-- SHOT: -->` markers, ids matching one for one.
All seven captions are accurate against source: the Specialized badge and Enabled
switch (claims 4, 5), the Create 12S Reference button and the FASTQ Bundles list
(14, 19), the segmented Read Platform picker with Min Soft Clip and the Advanced
Options pair (21, 37, 64), the nine Targets columns in order (24), the five
Unresolved columns (31), the BLAST drawer's three columns (33), and the three
export items (34). The one caption fault is inherited from claim 7: the Workflow
Library caption says "its dependency row for the Lungfish Tools pack", and the
row will read Third-Party Tools when the shot is taken. Fix the caption with the
body sentence or the screenshot will contradict it.

`glossary_refs` lists twelve terms and all twelve resolve in `GLOSSARY.md`. The
four new ones are correct and well written: `chimera` (`:93`),
`deduplicated-reference` (`:147`), `read-orientation` (`:447`), `vsearch`
(`:597`). `read-orientation` is the one that earns its place, since it is the
term the chapter's central trap depends on, and it names `fastq orient` in the
definition.

`illustrations: []` and `fixtures_refs: []` are both empty. The empty
`fixtures_refs` is defensible but unfortunate, and is discussed under Notes.

Lint is clean under `LUNGFISH_MANUAL_STRICT=1`, verbatim final line:

    docs/user-manual/chapters/06-classification/10-twelve-s-metabarcoding.md: no issues found

## Settings coverage against parameters.yaml

The registry declares fourteen `settings` and seven `cli_only` entries. The
chapter carries fourteen settings paragraphs and covers all seven `cli_only`
entries. Coverage is complete, with one grouping error.

| Registry label | Paragraph | Default matches | Allowed matches | Flag matches |
|---|---|---|---|---|
| Reference | yes | yes, "no default and the Run button stays disabled" | yes, FASTA or `.lungfish12sref` | `--reference` |
| Analysis Metadata | yes | yes, "No analysis metadata selected" verbatim | yes, CSV or TSV | `--sample-metadata` |
| Read Platform | yes | yes, Illumina exact | yes, both display names verbatim | `--matching-mode` |
| Result Name | yes | yes, built from the read files | yes | `--output-name` |
| Min Soft Clip | yes | yes, 1 | yes | `--min-soft-clip` |
| Max Indels | yes | yes, 3 | yes | `--max-indels` |
| Run vsearch chimera review | yes | yes, ticked | yes | `--chimera-review` plus `--no-chimera-review` |
| Directory | yes | yes | yes | `--output-dir` |
| Minimum Exact Reads | yes | yes, 0 | yes, 0 to 1,000,000 | `--min-exact-reads` |
| Exclude Human | yes | yes, off | yes | `--exclude-human` |
| Only With Alternates | yes | yes, off | yes | `--require-alternate-matches` |
| Taxon Groups | yes | yes, every group shown | yes | `--taxon-group` plus `--exclude-taxon-group` |
| Minimum Unresolved Reads | yes | yes, 0 | yes, 0 to 1,000,000 | `--min-unresolved-reads` |
| Chimera | yes | yes, All | yes, all five verbatim | `--chimera-status` |

Every label is copied verbatim from the registry. Every paragraph follows the
three-sentence shape with the flag in a closing sentence, as the consistency
sheet requires, and the group of six Inspector settings uses the permitted
group lead-in to explain once why they map to export flags rather than run flags.

One registry drift worth noting rather than a chapter fault. The registry's
`Run vsearch chimera review` entry says clusters come back marked "not detected,
candidate, or confirmed", three states. The real enum has four
(`TwelveSChimeraStatusFilter`, and the `--chimera-status` help lists
`notReviewed` alongside the other three). The chapter states four and is right.
The registry entry is the one that should be corrected.

The seven `cli_only` entries all appear: `--ambiguity-resolution` with both
policies and their thresholds, `--reference-metadata` with its override
semantics, `--force`, and the four sibling subcommands
(`12s-reference-metadata`, `12s-reference-bundle`, `12s-export`,
`12s-export-unresolved`), each with a worked invocation.

## Consistency

Checked against `CONSISTENCY.md` and the committed chapters 02 and 03.

Correct. "Lungfish Genome Explorer (LGE)" at first mention then LGE throughout.
Menu paths bold, greater-than separated, ellipsis on dialog-opening items.
`lungfish-cli` in code font. Bundle extensions in code font. Settings paragraphs
in the fixed shape with the flag sentence last. Fixture names use the sanctioned
forms "the HG002 mitochondrial reads", "the primate mitochondrial genomes", and
"the demo project". The Before-you-start section opens with the two fixed
sentences verbatim. No em dashes, no semicolons, no in-sentence colons.

Two gaps, neither a false claim.

**The fixture sentence is incomplete.** The consistency sheet fixes what follows
the fixture name: a GitHub link, and for a folder fixture the Download ZIP
paragraph. Chapters 02 and 03 both carry a full fixture location. This chapter
says only "Build the demo project first if you have not already, and remember
where you saved it", which never tells the reader where the demo project comes
from or how to build it. A reader who has not met the demo project cannot start.
Either cross-reference the chapter that builds it or state the build step.

**The results folder is not in the sheet.** `Analyses/12S amplicon results/` is a
third `Analyses/` shape and the sheet records only two plus the MSA exception.
Add a line, since three workflows share this shape.

Against chapters 02 and 03 specifically, the enabling route is handled well. Both
siblings gate on the Plugin Manager and the Metagenomics pack; this chapter gates
on the Workflow Library instead, which is the correct difference, and it says so
plainly ("This is not the experimental-features switch and there is nothing to
turn on in Settings"), which pre-empts the obvious wrong turn. The dependency-row
naming is the only place where that paragraph misleads, per claim 7.

## App defects

All four of the author's defects reproduce. I did not take any on report.

**1. `12s-reference-metadata` and `12s-reference-bundle` help understate the
required columns. Confirmed.** Both help texts say the TSV carries "seq_id,
latin_name, group, taxid, and taxonomy". `TwelveSReferenceMetadata.swift:354`
requires seven, adding `common_name` and `name_source`, and throws
`missingColumn` on any absence. A user who builds the file from the help text
gets `Error: 12S MIDORI metadata table is missing required column 'common_name'`.
Low severity, since it fails loudly. The fix is one string in each subcommand.

**2. A reference header without parentheses silently produces empty metadata at
exit 0. Confirmed, and this is worse than the author's writeup implies.** I built
a one-record FASTA headed `>Homo_sapiens` with a correct seven-column MIDORI TSV
whose `latin_name` is `Homo sapiens`, and ran `12s-reference-metadata`. Exit 0,
no warning on stderr, and the output row is

    Homo_sapiens|seq_sha256=b6bf4a383c4079eb  b6bf...  Homo_sapiens  Homo_sapiens  (then nine empty fields)

`scientific_name`, `common_name`, `taxid`, `taxon_group`, `taxonomy`, and
`name_source` are all empty. `parseSpeciesLabel` treats a parenthesis-free header
as a display name, and `bestMatch` finds nothing because the underscore breaks
the normalized key. The user gets a reference that matches reads correctly and
labels every hit with nothing, and nothing anywhere says why. The join is
best-effort by construction (`bestMatch` returns an optional and the caller
tolerates nil), so the fix is a warning when a non-trivial share of records fail
to join, not a hard error. Highest-value small fix in this chapter.

**3. The matcher never attempts the reverse complement. Confirmed, and it is the
one worth escalating.** `classify(readSequence:)` uppercases the read and scans
it as given, both in the exact path (`:150`) and the indel fallback (`:155-166`).
A grep for reverse-complement across every file in
`Sources/LungfishWorkflow/TwelveS/` returns nothing, so no upstream stage
orients either. The consequence is measured on this fixture: 35 exact matches
before orienting against 110 after, so 75 of 110 matchable reads, 68 percent,
were lost to strand alone. The result is not an error. It is a plausible-looking
low-yield run with no diagnostic. Neither the dialog, the CLI help, nor the
result bundle mentions orientation anywhere. A user whose library is not already
oriented will read a 5 percent exact-match rate as a bad reference or a bad
sample and has nothing to lead them to the real cause. Either add a
reverse-complement pass or, cheaper and nearly as good, count unresolved reads
that would match reverse-complemented and warn when that share is large.

**4. `fastq orient --compress` writes uncompressed output. Confirmed
independently.** Fresh run to a clean path, exit 0, output named `.fastq.gz`,
`file` reports "ASCII text", and the leading bytes are the literal FASTQ header
`@D00360:94:H2YT5BCXX:1:1102:14525:68959` rather than a gzip magic number. Any
consumer trusting the extension breaks. The chapter's workaround, naming the
output plainly, is correct advice.

**5. New, not in the author's report. The Workflow Library card names the pack
Third-Party Tools, not Lungfish Tools.** `lungfish-tools` is the pack id;
`PluginPack.builtInPack(id:)?.name` resolves through the lock manifest's
`displayName`, which is `Third-Party Tools`. This is a documentation defect
rather than an app defect. It matters because the chapter tells a reader to look
for a row that does not exist under that name, and because the same card is the
subject of a declared screenshot. See claim 7.

No new app defect beyond the four the author found. The fifth item is a chapter
error, corrected in the claim table.

## Notes for the editor

**Two corrections, both one-line.** Claim 7, the pack name, appears twice, once
in the Before-you-start paragraph and once in the `twelve-s-workflow-library`
caption. Claim 38, the three-plus-two split, is one clause in the Settings
lead-in. Neither touches the chapter's structure.

**The fixture is the chapter's real exposure.** Every number in the chapter is
correct, verified against the bundle and reproduced by rerunning the match. But
the fixture is constructed, not published. The reference is five 60-base slices
cut from primate mitochondrial genomes by a script that lives only in a
scratchpad, and the reads are HG002 mitochondrial reads seed-filtered to the
locus. The chapter is honest that it uses demo-project material and never claims
the fixture is a real 12S library, which is the right call. Two consequences the
editor should weigh. `fixtures_refs` is empty, so nothing in the manual points at
the material a reader would need to follow along, and the scratchpad is not
durable. If this fixture is meant to survive, it needs a home under
`docs/user-manual/fixtures/` with the two scripts, or the chapter needs to stop
implying the reader can reproduce the numbers.

**The 63.6 percent figure needs its framing kept.** It is a true number from a
real run, but it is low for a healthy 12S run and the chapter says so, then uses
it to teach the orientation trap. That is good pedagogy and the paragraph should
not be trimmed. If a future run on a better fixture raises the number, the
orientation lesson has to move somewhere else rather than be lost.

**The Overview section of the dialog is undocumented.** `WorkflowOperationsDialog`
opens with an Overview section carrying the workflow summary and an **Open
Previous Run…** button (`:79-83`). The chapter goes straight to Inputs. This is
not a registry setting so it is not a coverage failure, and the button is
arguably out of scope for a first run. Worth one sentence if the editor wants the
dialog described completely, and worth nothing if not.

**Two claims the author settled that the ground-truth pass could not.** Claim 11,
the summary line's four fields, and claim 23, the automatic
`unresolved-sequences.fasta`. I verified both independently and both are true.
The ground-truth file should be updated so the next reviewer does not redo the
work.

**Registry correction.** The `Run vsearch chimera review` entry in
`parameters.yaml` lists three chimera states. There are four. The chapter is
right and the registry is wrong.

## Counts

64 claims checked: **62 true, 2 false, 0 unverifiable.**

Front matter: correct, one caption to fix with claim 7. Lint: clean.
Settings coverage: 14 of 14 settings and 7 of 7 `cli_only` entries, complete,
one grouping error (claim 38).
Consistency: two gaps, the incomplete fixture sentence and the unrecorded
`Analyses/12S amplicon results/` folder.
App defects: 4 confirmed by independent reproduction, 0 new. One new chapter
error (the pack name) that is not an app defect.
Ground-truth rows upgraded from unverifiable to true: 2 (claims 11 and 23).
