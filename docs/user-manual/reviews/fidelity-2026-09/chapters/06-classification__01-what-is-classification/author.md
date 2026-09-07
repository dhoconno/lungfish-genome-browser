# Author report, 06-classification/01-what-is-classification

Chapter 32 of the campaign roster. Concept chapter opening Part VI. No
`parameters_refs` (no registry ids on the roster row). Fixture named but not
run, since the chapter runs no operation.

Lint result: `no issues found` under `LUNGFISH_MANUAL_STRICT=1`.

## Sources behind every tool and database claim

Everything asserted about a tool, a menu, a folder, or a database was read in
the source or run on this machine. The reality map
(`ground-truth/06-classification.md`) was used as an index, and each claim it
covers was confirmed at the cited line before being written.

| Claim in the chapter | Source verified |
|---|---|
| Three runnable classifiers, exactly Kraken2, EsViritu, TaxTriage | `FASTQOperationDialogState.swift:2070` (`case .kraken2, .esViritu, .taxTriage: return .classification`) |
| Menu path is `Tools > Classification > <tool>...`, a submenu of three items | `MainMenu.swift:786-819` builds one submenu per category with one item per tool id; `ToolsMenuModel.swift` `menuTitle` returns "Classification" |
| Tool titles "Kraken2", "EsViritu", "TaxTriage" | `FASTQOperationDialogState.swift:1994-1996` |
| The app's one-line tool descriptions quoted in the chapter | `FASTQOperationDialogState.swift` `subtitle`, which returns "Classify reads taxonomically.", "Detect viruses and report coverage.", "Run the TaxTriage pathogen workflow." |
| Window is titled FASTQ/FASTA Operations, with a tool sidebar | `FASTQOperationDialogState.swift:1250-1252` (title), `FASTQOperationDialog.swift:30-43` + `FASTQOperationDialogState.swift:1144-1148` (sidebar built from the selected category) |
| Dataset line rather than a file picker | `FASTQOperationDialogState.swift:1119-1128`, `FASTQOperationDialog.swift:34` |
| Run button says "Run" | `FASTQOperationDialog.swift:20` |
| Operations rows "Classifying \<file\>" and "Classification Batch (N samples)" | `AppDelegate+Classification.swift:851-858` (`"\(goalLabel) \(inputName)"`, goalLabel "Classifying"), `:1385-1386` (batch title) |
| Results land in `Analyses/<tool>-<timestamp>/` | `AppDelegate+Classification.swift:842-845`; `AnalysesFolder.swift:132-141` (`baseName = isBatch ? "\(tool)-batch-\(timestamp)" : "\(tool)-\(timestamp)"`) |
| CZ-ID is the exception, writing `.lungfishtax` under `Classifications/` | `AppDelegate+ToolsMenu.swift:860-867` |
| Import Center Classification Results tab holds six cards | `ImportCenterViewModel.swift`, card titles at `:416` NAO-MGS, `:426` Kraken2, `:448` EsViritu, `:469` TaxTriage, `:490` NVD, `:500` CZ-ID, all `tab: .classificationResults` |
| Taxonomy table columns Sample, Taxon Name, Rank, Reads, Direct, Bracken, % | `TaxonomyTableView.swift:245,254,263,273,282,291,302` (column `title` assignments read directly) |
| "Filter taxa..." search field | `TaxonomyTableView.swift:226` (`placeholderString = "Filter taxa\u{2026}"`) |
| Sunburst is ring-per-rank from the root, wedge angle proportional to clade count, phylum-based colouring | `TaxonomySunburstView.swift:15-25` |
| Kraken2 Standard covers archaea, bacteria, viral, plasmid, human, UniVec; fungi and protozoa only in PlusPF | `MetagenomicsModels.swift` `contentsDescription`, Standard case and PlusPF case |
| Kraken2 collections run 0.5 GB (Viral) to 72 GB (PlusPF) | `MetagenomicsModels.swift` `approximateSizeBytes`, viral `536_870_912`, plusPF `72 * 1_073_741_824` |
| Thirteen databases, nine of them Kraken2 collections | `lungfish-cli conda db list` on this machine printed "Metagenomics Databases (13)" and nine Kraken2 collection rows; the nine-case enum is `MetagenomicsModels.swift:75-84` |
| `metagenomics` pack ships Kraken 2, Bracken, EsViritu, RiboDetector | `PluginPack.swift:771-821` (`packages: ["kraken2", "bracken", "esviritu", "ribodetector"]`, display names Kraken 2, Bracken, EsViritu, RiboDetector) |
| TaxTriage is not a plugin pack, needs Nextflow plus a container runtime, classifies against an installed Kraken2 database | No TaxTriage entry anywhere in `PluginPack.swift`; `TaxTriageWizardSheet.swift:300-347` gates the run on `nextflowAvailable` and `containerAvailable` and shows a Prerequisites section with both |
| Plugin Manager at Cmd-Shift-B | `MainMenu.swift:773-780`, and the committed `01-foundations/07-plugin-packs.md` |
| NAO-MGS is SecureBio's wastewater pipeline | `NaoMgsResultParser.swift:319` names `https://github.com/securebio/nao-mgs-workflow` |
| Fixture is 86,281 read pairs of SARS-CoV-2 | `docs/user-manual/fixtures/sarscov2-srr36291587/README.md` |

Databases installed on this machine, read from `~/.lungfish/databases/` and
cross-checked with `lungfish-cli conda db list`, were Standard-16, Viral,
SILVA, the EsViritu Viral DB, and NCBI Taxonomy. The chapter states no
per-machine install state, so this only served to confirm the catalogue and
the ready/missing vocabulary.

The CLI was run read-only twice, `conda db install-managed --list` (returned
`human-scrubber`, `deacon-panhuman`, `deacon-ribokmers`) and `conda db list`.
Neither result needed to appear in this chapter, since the plugin-packs
chapter already teaches both, but they confirmed the thirteen-database count
this chapter cites.

## What was removed from the old chapter, and why

1. **`Tools > FASTQ/FASTA Operations > Classification…` as a menu path**, in
   both places it appeared. That submenu does not exist. The Tools menu is
   built one submenu per operation category, and FASTQ/FASTA Operations is
   only the dialog's window title. DRIFT rows 1 and 15.

2. **"This is a single menu item, not a submenu"**, and the explicit denial
   that a `Classification > Kraken2` path exists. That is exactly the path
   that does exist. DRIFT row 15.

3. **"the wizard ... let it pick the right database"**. The wizard does not
   pick a database. It renders a picker filtered to installed databases
   (`ClassificationWizardSheet.swift:434-472`, `:179-181`), and it is the
   Kraken2 chapter's job to walk that. Removed rather than reworded, since a
   concept chapter should not teach a control it does not show.

4. **"the result appears as a new track on the source FASTQ bundle"** and
   **"Lungfish keeps each classification result as its own track on the FASTQ
   bundle"**. There is no track. Results are timestamped folders under
   `Analyses/`. Both replaced with the folder wording, and the side-by-side
   point kept, since it is still true and still the reason the reader cares.
   DRIFT rows 20 and 21.

5. **The tool colours** (Kraken2 blue, EsViritu green, TaxTriage purple,
   NAO-MGS amber). Grepped the whole `Sources/` tree for any classifier colour
   constant and found none, in the wizard, in `LungfishColors.swift`, or
   anywhere else. The reality map reached the same conclusion at DRIFT row 16.
   These colours live in project memory as a UI convention, not in the code
   this build ships, so the chapter asserts no colour. See the defect note
   below.

6. **"The wizard opens with a tool picker showing the three runnable
   classifiers"**. It opens on the tool you already chose in the menu.
   Replaced with the sidebar description. DRIFT row 16.

7. **"A standard Kraken2 database covers bacteria, archaea, viruses, fungi,
   and the human genome"**. Fungi are not in Standard. Corrected to the
   `contentsDescription` list, with the PlusPF sentence added. DRIFT row 22.

8. **The invented sample distribution** "63% human, 22% bacterial (mostly
   *Streptococcus*), 4% SARS-CoV-2, 11% unclassified" and the two invented
   unclassified thresholds ("treat a 10% unclassified fraction as normal, a
   60% unclassified fraction is a signal"). No fixture or run produces these
   numbers, and the campaign forbids invented figures. The paragraph now makes
   the same interpretive point without any number, and says plainly that the
   normal unclassified fraction depends on the sample type and the database.

9. **"EsViritu ... can tell you not just *Influenzavirus A* but H3N2, clade
   3C.2a1b"**. Fabricated output. Nothing in the source promises clade-level
   naming, and the EsViritu table's real columns are Sample, Virus Name,
   Family, Reads, Unique Reads, RPKMF, Coverage, Identity, Segment
   (`ViralDetectionTableView.swift`). Replaced with the coverage argument,
   which is what the tool actually reports and what actually distinguishes it.

10. **"plan for an afternoon of one-time downloads"**. An unsourced duration.
    Replaced with a statement that large collections are large downloads and
    should be started ahead of need.

11. **The old chapter's "What you will learn" section**, which restated the
    chapter in one sentence. Not in the template, and it duplicated the
    "so what should I do with this" line the primer already carries.

12. **"Each row is one taxon, with columns for rank, name, read count, and
    percent of classified reads."** Replaced with the seven real columns, and
    the Reads/Direct distinction explained, since that difference is the one
    thing about the table an undergraduate will misread. DRIFT row 10.

13. **"the smallest useful Kraken2 database is several hundred megabytes and
    the largest is over a hundred gigabytes"**. The largest is 72 GB, not over
    a hundred. Corrected to the real range.

## DRIFT unverifiable rows

The Part A section for this chapter records **0 unverifiable rows** (verdicts
line reads "16 true, 4 false, 3 changed, 0 unverifiable"). Nothing needed
settling on that axis. The one adjacent unverifiable row in the reality map,
02's row 5 about Kraken 2's default k of 35, belongs to the Kraken2 chapter and
is not touched here. This chapter asserts no k value.

## Missing rows from DRIFT, and how each was handled

| Missing row | Handling |
|---|---|
| Classification submenu carries workflow-library entries below a divider | Not written. `MainMenu.swift:794-798` draws that divider only when `category.workflows` is non-empty, and no `WorkflowLibraryItem` currently has `categoryID: .classification` (the only two built-ins, 12S Amplicon Matching and Full-length ONT MHC genotyping, are both `.genotyping`). So the Classification submenu today holds three items and no divider. Writing the divider would have been a false claim. |
| Six Import Center cards, not three | Written, with its own SHOT marker |
| 12S is under Genotyping and is specialized | Not written into this chapter. It is chapter 41's subject, it is not a classifier in the app's own categorisation, and pulling it in here would contradict the "three runnable classifiers" frame the reader needs. Flagged instead for the Lead in case Part VI's ordering wants revisiting, since 12S currently sits as chapter 10 of a classification part while the app files it under Genotyping. |
| Nine Kraken2 collections plus SILVA and Greengenes | Written at the level a concept chapter needs (thirteen databases, nine Kraken2 collections, range 0.5 GB to 72 GB) with the detail delegated to the plugin-packs chapter, which already carries the full table |
| Every run registers an OperationCenter entry | Written, with both title shapes quoted |

## Template sections kept and dropped

Kept, in template order. `## What it is`, `## Why you would do this`, then the
concept sections, then `## What good looks like` and `## Next`.

Dropped, with reasons.

- `## Before you start`. The chapter runs nothing. There is no project state
  to require, no pack to install for the reading, and no fixture to download.
  The fixed Before-you-start sentences from CONSISTENCY are written for
  procedure chapters, and inserting them here would tell the reader to fetch a
  file the chapter never opens. The prerequisites that do matter (a pack, a
  database) are taught in their own section, "Databases, and why you install
  one first", which routes to the plugin-packs chapter.
- `## Procedure`. No operation is run.
- `## Settings`. No `parameters_refs` on the roster row, and no settings are
  shown. `settings-coverage.js` is satisfied by the empty `parameters_refs`.
- `## On the command line`. Every CLI invocation this part needs belongs to a
  specific tool chapter. A shell block here would have to reproduce a
  procedure the chapter does not contain.

`## What good looks like` was kept even though nothing is run, because a
concept chapter that ends without telling the reader how to judge a result
leaves them with the idea and none of the judgement. Its three checks are all
about a run made in a later chapter, and it says so.

## Shot markers

Four, each with a caption in `shots[]`.

| id | Placement | Note |
|---|---|---|
| `classification-submenu` | "Where the classifiers live", after the menu-path sentence | New. Replaces the old `classification-wizard-tool-picker` as the shot that proves the corrected menu path. DRIFT judged the old planned shot invalid as captioned. |
| `classification-dialog-tool-sidebar` | Same section, after the dialog paragraph | The recaptioned successor to `classification-wizard-tool-picker`, framed on the FASTQ/FASTA Operations dialog opened from the Kraken2 menu item with the sidebar visible, as DRIFT directed |
| `taxonomy-viewport-overview` | "What you will see in the results", before the three-view description | Carried over. Caption now names the "Filter taxa..." field, per the DRIFT screenshot row |
| `import-center-classification-tab` | "What LGE runs and what it only imports", after the six-cards sentence | New, to carry the six-card correction |

The `classification-question` illustration is carried over unchanged in
concept, with the brief tightened to name the database inside the classifier
box and to include an unclassified share in the sunburst, since both are
points the prose now makes. DRIFT judged the illustration still valid.

The old file used `planned_shots` and `<!-- planned: id -->` markers. Those are
not what `frontmatter.js` validates. Converted to real `shots[]` entries and
`<!-- SHOT: id -->` markers, per the campaign rule that every marker has a
captioned entry.

## Glossary additions

Nine terms added to `GLOSSARY.md`, alphabetised, in the existing one-sentence
shape with a "See also:" tail. All nine are listed in `glossary_refs`.

`cz-id`, `esviritu`, `kraken2`, `lowest-common-ancestor`, `metagenomics`,
`read-classification`, `taxon`, `taxonomic-rank`, `taxtriage`.

None of the nine existed. `metabarcoding` and `minimizer` referenced Kraken2
and metagenomics without either being defined, which those two entries now
resolve. The chapter also links sixteen existing entries, and every anchor in
`glossary_refs` was checked to resolve against a `{#anchor}` in the file.

The glossary as a whole reports 322 pre-existing lint warnings, almost all from
the established "See also:" entry shape and legacy semicolons in older
entries. My nine entries contain no semicolon, no em dash, and no
sentence-internal colon other than the "See also:" tail that every entry in the
file uses.

## Possible defects found

1. **The classifier tool colours documented in project memory do not exist in
   the shipping source.** Project memory records "Classification tool colors:
   Kraken2=blue, EsViritu=green, TaxTriage=purple, NAO-MGS=amber" as a binding
   UI convention. A grep of `Sources/` for any per-classifier colour constant
   returns nothing, in `LungfishColors.swift` or elsewhere, and the reality map
   reached the same finding independently at DRIFT row 16. Either the
   convention was never implemented, or it was removed. Worth a decision,
   because two more chapters in this part inherited the claim from the same
   memory line.

2. **12S Amplicon Matching is filed under Genotyping in the app but sits as
   chapter 10 of the Classification part of the manual.**
   `WorkflowLibrary.swift:141-149` gives it `categoryID: .genotyping` and
   `maturity: .specialized`, so a reader following this chapter's routing into
   Part VI will not find it under **Tools > Classification** at all, and will
   not see it anywhere until Show Experimental Features is on. This is a
   manual-structure question for the Lead rather than an app bug, but it makes
   this chapter unable to route honestly to chapter 41 without contradicting
   its own menu section, so it routes to the other eight and leaves 12S alone.

3. **Minor, not acted on.** `AnalysesFolder.createAnalysisDirectory` appends
   `-2`, `-3` and so on for up to 1,000 collisions when two runs land in the
   same timestamped second. Harmless, and the chapter does not mention it,
   but the folder name a reader sees is not guaranteed to be exactly
   `<tool>-<timestamp>`. The chapter says "for example" before the sample name
   rather than stating the form as a rule.
