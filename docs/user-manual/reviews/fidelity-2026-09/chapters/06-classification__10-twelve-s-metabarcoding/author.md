# Author record, 06-classification/10-twelve-s-metabarcoding

Chapter: `docs/user-manual/chapters/06-classification/10-twelve-s-metabarcoding.md`
Roster row 41, registry id `classify.twelve-s-match`, title "12S Amplicon Metabarcoding".
Build documented: Preview 2026.9.13. Date: 2026-09-07.

## Outcome

Lint, verbatim final line:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/06-classification/10-twelve-s-metabarcoding.md: no issues found
```

Settings paragraphs: 14, one per registry `settings` entry, labels copied verbatim.
All 7 `cli_only` entries covered in the command-line section.
Shot markers: 7, matching 7 front-matter `shots` entries with captions.
Glossary terms added: `chimera`, `deduplicated-reference`, `read-orientation`, `vsearch`.
Real run: yes, from a fixture I built out of the demo project (details below).

## Fixture, built rather than found

There is no 12S fixture in `Tests/Fixtures/` and none in the demo project. There is
also no 12S run in `~/Desktop/lge-docs/LGE Manual Demo.lungfish`. Rather than write
the chapter with no figures, I built a real human 12S fixture from two things the
demo project already ships, so every number in the chapter comes from real primate
mitochondrial sequence and real HG002 reads.

Scratchpad: `/private/tmp/claude-501/-Users-dho-Documents-lungfish-genome-explorer/8e8f6de6-4b18-4243-8bb4-601f75d7c63a/scratchpad/twelve-s/`

Sources copied in (read-only from the demo project, never written to):

- `~/Desktop/lge-docs/LGE Manual Demo.lungfish/Analyses/Multiple Sequence Alignments/Primate-mitochondria.lungfishmsa/alignment/input.unaligned.fasta`
  Five complete primate mitochondrial genomes: human `NC_012920.1` (16,569 bp),
  chimp `NC_001643.1`, gorilla `NC_011120.1`, rhesus macaque `NC_005943.1`,
  cynomolgus macaque `NC_012670.1`.
- `~/Desktop/lge-docs/LGE Manual Demo.lungfish/Imports/HG002-chrM.lungfishfastq/HG002-chrM.fastq.gz`
  9,958 Illumina reads of 250 bp from the human mitochondrion.

Fixture construction, scripts kept in the scratchpad:

- `build_ref.py` cuts a 60-base slice out of the human 12S rRNA gene (MT-RNR1 is
  `NC_012920.1:648-1601`) and finds the homologous slice in each of the other four
  genomes by anchoring on a conserved 18-base 5' flank. Anchor identity was 18/18
  for human and gorilla, 17/18 for chimp, 16/18 for both macaques. All five slices
  were distinct, so nothing collapsed during deduplication. Writes
  `primate-12s-dedup.fasta` with headers in the `Common name (Scientific name)`
  form the metadata joiner requires.
- `make_amplicon.py` selects the HG002 reads that overlap the 12S locus by exact
  24-base seed sharing in either orientation, so the read set behaves like a 12S
  amplicon library instead of whole-mitochondrion shotgun. 631 of 9,958 reads kept.
- The MIDORI-style metadata TSV was hand-written with real NCBI taxids
  (9606, 9598, 9593, 9544, 9541).

This is a constructed fixture, not a published 12S dataset. The chapter quotes only
figures that came out of the runs below, and it names the demo project as the source
of the reads and the reference genomes.

## Commands run, in order

Binary: `/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli`.
All run from the scratchpad directory. Exit status is the shell's `$?`.

1. `fastq 12s-match --help` — exit 0. Output matches
   `reviews/fidelity-2026-09/cli-help/fastq.txt` banner `==== fastq 12s-match ====`
   exactly, so the captures are current for this build.
2. `fastq 12s-reference-metadata --dedup-fasta primate-12s-dedup.fasta
   --midori-metadata primate-12s-midori.tsv --output primate-12s-targets.tsv --force`
   — first attempt FAILED with `Error: 12S MIDORI metadata table is missing required
   column 'common_name'`. See defect 1.
3. Same command after adding `common_name` and `name_source` — exit 0, but every
   `scientific_name`, `common_name`, `taxid`, and `taxon_group` column came back
   empty, because the join is on the species name parsed out of the FASTA header
   and my headers were underscored. See defect 2.
4. Same command after rewriting the FASTA headers to `Common name (Scientific name)`
   — exit 0, all columns populated. Verified: `Homo sapiens / Human / 9606 / Mammal`,
   `Macaca mulatta / Rhesus macaque / 9544 / Mammal`, and the other three.
5. `fastq 12s-reference-bundle --dedup-fasta primate-12s-dedup.fasta
   --midori-metadata primate-12s-midori.tsv --output primate-12s.lungfish12sref
   --name "Primate 12S" --force` — exit 0. Bundle contains `12s-reference.json`,
   `reference.fasta`, `target-metadata.tsv`, `sources/`, `provenance/`.
6. `fastq 12s-match HG002-chrM.fastq.gz --reference primate-12s.lungfish12sref
   --output-dir results --output-name HG002-12S --force` (whole mitochondrion,
   120-base targets) — exit 0. 9,958 reads, 24 exact, 99.76 percent unresolved.
   Correct biology (human only, apes and macaques zero) but not a representative
   12S run, so not quoted in the chapter.
7. Rebuilt the reference at 60 bases, rebuilt the bundle, then
   `fastq 12s-match HG002-12S-amplicon.fastq.gz --reference primate-12s.lungfish12sref
   --output-dir results --output-name HG002-12S-amplicon --force` — exit 0.
   631 reads, 35 exact, 596 unresolved, 5.55 percent exact.
8. Diagnosed the gap by hand. 111 of the 631 reads contain the human 60-base target
   exactly, and 110 of those have at least one flanking base on both sides, so the
   Min Soft Clip rule accounted for 1 read and something else accounted for 75.
   Splitting by strand gave 35 forward and 75 reverse-complement. See defect 3.
9. `fastq orient HG002-12S-amplicon.fastq.gz --reference primate-12s-dedup.fasta
   --output HG002-12S-oriented.fastq.gz --compress --force` — exit 0, but the
   output was plain text despite `--compress` and the `.gz` name. See defect 4.
   Renamed to `.fastq` and continued.
10. `fastq 12s-match HG002-12S-oriented.fastq --reference primate-12s.lungfish12sref
    --output-dir results --output-name HG002-12S-oriented --force` — exit 0.
    **This is the run the chapter quotes.** 173 reads in, 110 exact, 63 unresolved,
    63.58 percent exact match. `sample-target-counts.tsv` gives Homo sapiens 110 and
    chimp, gorilla, rhesus macaque, and cynomolgus macaque 0 each.
    56 unresolved clusters, all `not_detected` for chimera, of which 51 hold one
    read, 4 hold two, and 1 holds four.
11. `fastq 12s-match ... --matching-mode ont-indel --max-indels 3 --output-name
    HG002-12S-ont --force` — exit 0. 113 exact instead of 110, confirming that the
    ONT setting recovers indel-only matches the Illumina setting rejects.
12. `fastq 12s-export --bundle results/HG002-12S-oriented.lungfish12s
    --export-format csv --output species.csv --force` — exit 0. Columns are
    Scientific Name, Common Names, Taxon Groups, Taxids, Exact Reads, Reference
    Targets, Other Potential Matches, Max Sample %, then one column per sample.
    Homo sapiens row reads 110 reads and 100.000000 percent.
13. `fastq 12s-export ... --export-format tsv --output mammals.tsv
    --min-exact-reads 20 --taxon-group Mammal --force` — exit 0, one row (human).
14. `fastq 12s-export ... --exclude-human --min-exact-reads 1 --force` — exit 0,
    header only, zero rows. Both filters behave as the registry describes.
15. `fastq 12s-export-unresolved --bundle results/HG002-12S-oriented.lungfish12s
    --min-reads 5 --output unresolved.fasta --metadata-output unresolved-meta.tsv
    --force` — exit 0, zero records, because every cluster is under 5 reads.
16. Same with `--min-reads 1` — exit 0, 56 records. This is what backs the chapter's
    note that the default threshold of 5 is a deliberate floor.
17. `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh
    docs/user-manual/chapters/06-classification/10-twelve-s-metabarcoding.md`
    — first run 3 warnings (bare "Lungfish" for the pack name, a colon inside a
    sentence, the word "navigation"). After fixes: `no issues found`.

## Figures used in the chapter, and where each came from

| Figure | Source |
|---|---|
| 173 reads in, 110 exact, 63 unresolved, 63.6 percent | run 10, `read-fate.json` and `samples.tsv` |
| Homo sapiens 110 reads, 100 percent of sample | run 10, `sample-target-counts.tsv`; run 12, `species.csv` |
| Chimp, gorilla, and both macaques at zero | run 10, `sample-target-counts.tsv` |
| 56 unresolved clusters, all not detected | run 10, `unresolved-sequences.tsv` |
| 51 singletons, 4 doubletons, 1 four-read cluster | run 10, `unresolved-sequences.tsv` read-count column |
| 35 exact before orienting versus 110 after | runs 7 and 10 compared |
| Empty FASTA at `--min-reads 5`, 56 records at 1 | runs 15 and 16 |

## Source files consulted for window claims

Enabling route and menu behaviour:
- `Sources/LungfishApp/Services/WorkflowLibrary.swift:137-149` — `twelveSAmpliconMatchingItem`,
  `categoryID: .genotyping`, `maturity: .specialized`, `requiredPluginPackIDs: ["lungfish-tools"]`.
  Confirms Genotyping, not Classification, and specialized rather than experimental.
- `Sources/LungfishApp/Views/WorkflowLibrary/WorkflowLibraryPanelView.swift:260-366` —
  the card: title, maturity badge, subtitle, dependency rows reading `Ready` or
  `Needs install`, the `Install Dependencies` button when a pack is missing, and the
  `Enabled` switch otherwise. `builtInSections` puts specialized items under the
  `Specialized Workflows` heading, grouped by category.
- `Sources/LungfishApp/App/MainMenu.swift:765-771` — `Tools > Workflow Library…`.
- `Sources/LungfishApp/App/MainMenu.swift:820-843` — `workflowMenuItem`. A disabled
  workflow is drawn as `"<title> (not enabled)"` in `disabledControlTextColor`, and
  it stays clickable so it can raise the prompt.
- `Sources/LungfishApp/App/AppDelegate+ToolsMenu.swift:1739-1756` —
  `promptEnableWorkflowFromMenu`. The alert reads `Enable "<title>"?` with
  "This workflow is available but not yet enabled. Enable it in the Workflow
  Library?" and buttons `Open Workflow Library` and `Cancel`.

Dialog:
- `Sources/LungfishApp/Views/WorkflowOperations/WorkflowOperationsDialog.swift:17-18` —
  window title "Workflow Operations", subtitle "Run enabled specialized and user workflows."
- `:99-116` — section order: Inputs, then primary settings, then advanced, then output.
- `:150-190` — the Reference picker, the Project Reference menu, the
  `Create 12S Reference…` button, and the Choose/Replace/Clear buttons.
- `:266-284` — the `Analysis Metadata` group with `Choose Metadata…` / `Replace Metadata…`.
- `:209-215` — the `FASTQ Bundles` group.
- `:60-71` — `multiBundleRunPolicy`, lock reason "They will run as one batch."
- `:324-330` — the 12S primary settings: `twelveSMatchingModePicker`, `Result Name`,
  `Min Soft Clip`.
- `:345-357` — `Read Platform` as a `.segmented` picker.
- `:516-527` — Advanced Options for 12S: `Max Indels` disabled unless
  `twelveSMatchingMode == .ontIndel`, `Run vsearch chimera review` toggle, and the
  helper text "The 12S workflow expects merged FASTQ inputs; paired-read merging
  should be handled before import."
- `:530-545` — the `Directory` output picker.

Viewport:
- `Sources/LungfishTwelveSUI/TwelveSAmpliconResultViewController.swift:231-236` —
  title "12S Amplicon Matches" and the `["Targets", "Unresolved"]` segmented control.
- `:240`, `:298-299` — `All Samples` filter button, `autoReadsColumnSampleLimit = 8`,
  `Sample Columns` button.
- `:1554-1568` — `summaryText`, which settles ground-truth claim 11 as **true**. It
  joins exactly four fields with `" | "`: sample count, exact reads, unresolved
  percent to one decimal, and the chimera-candidate count singular/plural.
- `:1576-1589` — the export menu, "Export as CSV...", "Export as TSV...",
  "Export as Excel...". No FASTA item.
- `:1596-1605`, `:1638-1662` — the Provenance popover: Analysis, Samples, Exact Reads,
  Unmatched, Created, and the provenance file path.
- `Sources/LungfishTwelveSUI/TwelveSTargetTableView.swift:155-165` — the nine Targets
  columns, verbatim titles.
- `Sources/LungfishTwelveSUI/TwelveSUnresolvedTableView.swift:17-24` — the five
  Unresolved columns: Sequence, Reads, Samples, Chimera, Bases.
- `Sources/LungfishTwelveSUI/TwelveSTargetTableView.swift:169` — the search
  placeholder "Filter species or matches".
- `Sources/LungfishKit/ClassifierActionBar.swift:22-80` — the action bar buttons,
  `BLAST Verify`, `Export`, `Extract FASTQ`, and the info-circle provenance button.
- `Sources/LungfishKit/BlastResultsDrawerTab.swift:215-225` — Organism, Identity,
  Accession columns in the drawer.
- `Sources/LungfishTwelveSUI/TwelveSCopyMenuProvider.swift:101-135` — the right-click
  menu. `Learn More About <species>` and `View Photo of <species>` appear only on a
  single-row selection, after a separator.
- `Sources/LungfishTwelveSUI/TwelveSSpeciesLinks.swift` — the URLs. NCBI Taxonomy by
  taxid when present and by name search otherwise, Wikipedia by underscored
  scientific name, Google as the never-taken fallback. Opened immediately with no
  per-click prompt, matching the campaign's binding fact.

Inspector display controls:
- `Sources/LungfishApp/Views/Inspector/Sections/TwelveSResultDisplaySection.swift:232-250` —
  the `12S Results` disclosure with `Target Rows` and `Unmatched Reads` inside it.
- `:266-296` — `Minimum Exact Reads`, stepper range `0...1_000_000`.
- `:300-340` — `Attributes` pills `Exclude Human` and `Only With Alternates`, then
  the `Taxon Groups` pills.
- `:225` — `taxonGroupOptions = ["Mammal", "Fish", "Bird", "Reptile", "Amphibian"]`.
- `:343-378` — `Minimum Unresolved Reads` and the `Chimera` picker.
- `:381-394` — the Export menu built from `TwelveSAmpliconResultExportFormat.allCases`.

Matching behaviour:
- `Sources/LungfishWorkflow/TwelveS/TwelveSAmpliconReadClassifier.swift:146-175` —
  `classify(readSequence:)`. Exact containment first, indel fallback only when
  `matchingMode.allowsIndelFallback`. No reverse-complement pass anywhere, which is
  the basis for defect 3.
- `:183-200` — `exactMatchedReferences`, where `minimumSoftClipBases` sets the lower
  and upper scan bounds, so the flank requirement applies at both ends.
- `Sources/LungfishWorkflow/TwelveS/TwelveSAbundanceReassigner.swift:58-141` —
  per-sample and global unambiguous totals, then the policy pick. `moves` records
  every reassignment.
- `Sources/LungfishWorkflow/TwelveS/TwelveSReferenceMetadata.swift:352-357` — the
  seven required MIDORI columns, basis for defect 1.
- `:376-390` — `bestMatch`, joining on latin name then common name then display
  name, basis for defect 2.
- `:294-305` — `parseSpeciesLabel`, which is why the header must be
  `Common name (Scientific name)`.
- `Sources/LungfishWorkflow/TwelveS/TwelveSAmpliconMatchingWorkflow.swift:593`, `:620` —
  the target and unresolved table headers.

Registry and captures:
- `docs/user-manual/parameters.yaml`, entry `classify.twelve-s-match`, all 14
  settings and all 7 `cli_only` entries.
- `docs/user-manual/reviews/fidelity-2026-09/cli-help/fastq.txt`, banners
  `==== fastq 12s-match ====`, `12s-export`, `12s-export-unresolved`,
  `12s-reference-metadata`, `12s-reference-bundle`, `fastq orient`.

## DRIFT items applied

- Row 8 (false). Replaced with the corrected wording. The chapter now says the
  workflow does not merge pairs and that merging happens first, in Before you start
  and again in step 3.
- Row 7 (changed). Now "Leave the **Read Platform** picker on the Illumina setting,
  or switch it to the Nanopore setting".
- Row 10 (changed). The Targets table is described by its nine real columns.
- Marker placement. `twelve-s-workflow-library` moved out of "What it is" and into
  Before you start, where the reader is told to enable the workflow.
- `twelve-s-export` recaptioned to the three formats the menu actually offers.
- `twelve-s-workflow-library` caption widened, and the dialog split into two shots
  (`twelve-s-dialog-inputs`, `twelve-s-dialog-options`) so the Read Platform picker,
  Min Soft Clip, the metadata picker, and the Advanced Options disclosure are all
  covered, as the drift report asked.
- Every Missing row covered: Min Soft Clip, Max Indels, Run vsearch chimera review,
  the sample-metadata picker, the in-dialog reference builder, `12s-reference-metadata`,
  `12s-reference-bundle`, `--force`, the Provenance popover, and the specialized
  or Genotyping enabling route.

## Ground-truth rows I could settle that the review could not

- Claim 11 ("the summary line reports the sample count, the total exact reads, the
  percent unresolved, and the number of chimera candidates") was marked
  **unverifiable**. It is **true**. `TwelveSAmpliconResultViewController.swift:1554-1564`
  builds exactly those four fields joined with `" | "`.
- Claim 23 ("the workflow also writes an `unresolved-sequences.fasta` into the result
  bundle automatically") was marked **unverifiable**. It is **true**. My run 10
  bundle contains `unresolved-sequences.fasta`, and `12s-result.json` declares
  `"unresolvedFastaPath": "unresolved-sequences.fasta"`.

## Defects found

1. **`12s-reference-metadata` help understates its required columns.** The help text
   says the MIDORI TSV needs "seq_id, latin_name, group, taxid, and taxonomy", but
   `TwelveSReferenceMetadata.swift:354` requires seven columns including
   `common_name` and `name_source`. Following the help produces
   `Error: 12S MIDORI metadata table is missing required column 'common_name'`.
   Same wording in `12s-reference-bundle`. Documented in the chapter as a warning
   with the full seven-column list.

2. **The FASTA header format the metadata joiner needs is documented nowhere.** The
   join is on the species name parsed out of the reference header by
   `parseSpeciesLabel`, which expects `Common name (Scientific name)`. A header
   without parentheses is treated as a scientific name, so a plain `>Homo_sapiens`
   silently produces a target metadata file with every taxonomy column empty and
   exit status 0. A silent empty join is worse than an error here. Worked around in
   the chapter by stating the header form in step 1.

3. **The matcher never tries the reverse complement, and does not say so.**
   `TwelveSAmpliconReadClassifier.classify(readSequence:)` scans the read as given
   only. On my fixture that cost 75 of 110 matchable reads, taking the exact-match
   rate from 63.6 percent down to 5.5 percent, with nothing in the output to
   indicate why. Neither the dialog nor the CLI help mentions orientation. This is
   the most likely cause of a mystifying near-zero 12S result in the field.
   Documented in What good looks like with the `fastq orient` fix. Worth a real fix,
   either a reverse-complement pass or a warning when a large share of unresolved
   reads match in the opposite orientation.

4. **`fastq orient --compress` writes uncompressed output.** The command exits 0 and
   writes a file named `HG002-12S-oriented.fastq.gz` that `file` reports as ASCII
   text and `gzcat` rejects with "not in gzip format". Any downstream step that
   trusts the `.gz` extension will fail. Noted in the chapter's command-line section
   so a reader is not stopped by it.

Defects 1, 2, and 4 are small and self-contained. Defect 3 is the one worth
escalating, because it silently produces a wrong-looking result rather than an error.

## What I could not verify

- **No screenshots were taken.** All seven shots are declared with captions written
  from source, and every claim in a caption is backed by a source line listed above,
  but the shots themselves still need capturing. My fixture is reproducible from the
  scripts in the scratchpad, so a Screenshot Scout can rebuild the same result
  bundle and open it in the app.
- **The GUI was never launched.** Every window claim in this chapter comes from
  reading source, not from driving the app. The dialog's exact layout, the Workflow
  Library card's rendering, and the viewport's appearance are all inferred from the
  view code.
- **The in-dialog `Create 12S Reference…` builder sheet.** I confirmed the button
  exists (`WorkflowOperationsDialog.swift:175-178`) and that it presents
  `TwelveSReferenceBundleBuilderSheet` with a `TwelveSReferenceBundleDraft`, and I
  exercised the equivalent CLI path end to end, but I did not read the sheet's own
  field labels. Step 1 therefore describes what the builder needs rather than naming
  its controls.
- **Cross-species reassignment was never exercised.** All five of my reference
  sequences were distinct, so `ambiguousExactReads` was 0 in every run and no read
  was ever reassigned. The chapter's account of `strict` and `conservative` comes
  from `TwelveSAbundanceReassigner.swift:58-141`, the CLI help, and
  `FastqTwelveSMatchSubcommand.swift:62`, not from an observed reassignment.
  A fixture with two species sharing one 12S sequence would settle it.
- **Chimera detection was never exercised.** All 56 unresolved clusters came back
  `not_detected`, so I saw the review run and label clusters but never saw a
  candidate or confirmed verdict.
- **Multi-sample behaviour.** Every run was single-sample, so the sample filter
  button, the eight-sample column rule, and `Import Metadata…` were verified from
  source only.
- **BLAST Verify was never run.** It needs the network and NCBI. The button, the
  callback wiring, and the drawer's three columns were read from source.

## Phase 5 note

A 12S run made in the GUI is needed for the screenshots. The fixture is not blocking:
the scratchpad holds `build_ref.py`, `make_amplicon.py`, the reference bundle
`primate-12s.lungfish12sref`, the oriented reads `HG002-12S-oriented.fastq`, and the
result bundle `results/HG002-12S-oriented.lungfish12s`, all reproducible from the
demo project alone. Copy the reference bundle and the oriented FASTQ into a project,
enable the workflow in the Workflow Library, and run it from
**Tools > Genotyping > 12S Amplicon Matching...** to reach every one of the seven
declared shots.

Two of the seven shots need something my fixture cannot supply. `twelve-s-blast-review`
needs a network round trip to NCBI. `twelve-s-unresolved-clusters` will show 56
single-read clusters, which is honest but a thin illustration, so a fixture with a
genuinely novel species in the reads would make a better picture.
