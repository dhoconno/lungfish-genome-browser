# Author report, 04-alignments/05-viral-recon-wizard

Chapter 26 of the campaign roster, registry id `workflow.viral-recon`, fixture
`sarscov2-srr36291587`. Rewritten in place against Preview 2026.9.13.

Lint result, verbatim.

    docs/user-manual/chapters/04-alignments/05-viral-recon-wizard.md: no issues found

## Sources behind every figure

No pipeline run was performed for this chapter, so every number below traces to a
file in the repository. Nothing was estimated.

| Figure or claim | Source |
|---|---|
| Pipeline pinned at release 3.0.0 | `ViralReconWizardSheet.swift:615` `fixedVersion`, and `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json` pipeline `nf-core-viralrecon` |
| Reference always `MN908947.3` | `ViralReconReferenceCatalog.swift:11` `canonicalAccession`, used at `ViralReconWizardSheet.swift:462` |
| Header line text | `ViralReconWizardSheet.swift:185`, quoted verbatim |
| Four sections in fixed order, Advanced between the third and fourth | `ViralReconWizardSheet.swift:57` `visibleControls`, `:132-134` inserts `advancedSection` before `.readiness` |
| Platform detection and the segmented control | `ViralReconWizardSheet.swift:56-57`, `:203-205`, `:210-224` |
| Mixed-platform refusal message | `ViralReconWizardSheet.swift:610`, `ViralReconInputResolver.ResolveError.mixedPlatforms` |
| Eight bundled schemes, all Built-in | `ls Sources/LungfishApp/Resources/PrimerSchemes/` returns exactly eight `.lungfishprimers` |
| Scheme detail line `MN908947.3 · 563 primers · 223 amplicons` | `PrimerOption.detail` at `ViralReconWizardSheet.swift:933-937`, plus `display_name`, `primer_count`, `amplicon_count` read out of `QIASeqDIRECT-SARS2.lungfishprimers/manifest.json` |
| Alphabetical default is ARTIC SARS-CoV-2 V3 | `loadPrimerOptions` sorts on `manifest.displayName` with `localizedStandardCompare`, and the eight `display_name` values put V3 first |
| Minimum mapped reads default 1000, step 100, range 1 to 1,000,000 | `ViralReconWizardSheet.swift:21`, `:255-260`, caption at `:262` |
| Advanced annotation note and Clear button | `ViralReconWizardSheet.swift:284`, `:289`, `:294` |
| Extra parameters placeholder and schema caption | `ViralReconWizardSheet.swift:302-311` |
| Readiness sentence "Ready to run Viral Recon." and the order of the blocked messages | `ViralReconWizardReadiness.evaluate` at `ViralReconWizardSheet.swift:835-867` |
| Structural (refused) vs overridable parameter sets | `ViralReconRunRequest.swift:247-264`, enforced by `ViralReconParameterSchema.validate` |
| Freyja always skipped, and why | `ViralReconRunRequest.swift:33-50`, `:172-174` |
| Assembly and Kraken2 skipped by default | `ViralReconRunRequest.swift:53-56` `defaultSelection` |
| Run bundle name `viralrecon.lungfishrun` under `Analyses/` | `ViralReconWorkflowExecutionService.swift:514-518`, and `AppDelegate+ToolsMenu.swift:218-220` sets `bundleRoot` to the project's `Analyses/` |
| Operations row titled `Viral Recon`, detail line contents | `ViralReconWorkflowExecutionService.swift:67`, `initialDetail` at `:566-568` |
| Results folder `Analyses/viralrecon-<timestamp>/` | `AnalysesFolder.createAnalysisDirectory(tool: "viralrecon")` called from `ViralReconResultIngest.ingestRun`, matching the CONSISTENCY.md rule |
| Trimmed BAM is the published alignment, not the untrimmed one | `ViralReconResultInventory.discover` prefers `<sample>.ivar_trim.sorted.bam`, with the reasoning in its comment |
| Inspector sections and their order | `ViralReconDocumentStateBuilder.sectionOrder` and the row labels in `rows(for:)` |
| Row labels and their plain-language details | `ViralReconDocumentStateBuilder.detail(for:)` |
| Consensus 29,900 bases against a 29,903 base reference, `AATT` to `A` at 20,297 | `docs/superpowers/specs/2026-09-02-viral-recon-results-integration-design.md:96-108`, a recorded real run of SRR11140748. The chapter labels it as a different sample, not the fixture |
| Coordinate mapping rather than positional overlay | `Sources/LungfishWorkflow/ViralRecon/ConsensusCoordinateMap.swift` |
| CLI flags, defaults, and the `--timeout` rejection | `cli-help/workflow.txt` plus `WorkflowCommand.swift:397-399` and `:626` |
| `provenance bibliography` subcommand name | `cli-help/provenance.txt:11`, `:18-25` |
| 86,281 paired-end read pairs, QIAseq Direct library | `docs/user-manual/fixtures/sarscov2-srr36291587/README.md` |
| Nextflow ships in the Required Setup pack | `docs/user-manual/chapters/01-foundations/07-plugin-packs.md:41` |
| Docker Desktop is not a Plugin Manager pack | `docs/user-manual/chapters/01-foundations/07-plugin-packs.md:65` |

Searched `docs/reports/` and `docs/superpowers/` for viralrecon run records. The
only recorded run with real output figures is the SRR11140748 consensus length in
the phase-3 design spec, cited above. No recorded run exists for the manual's own
fixture, SRR36291587, so the chapter states no coverage, depth, lineage, or
runtime numbers.

## What was removed from the old chapter, and why

1. The entry point `Tools > FASTQ/FASTA Operations > Mapping...` followed by
   clicking a Viral Recon tool row. DRIFT false rows 8 and 28. The route is
   `Tools > Mapping > Viral Recon...`, built at `MainMenu.swift:703-706` and
   `:804-817`, with the ellipsis appended by the menu builder. "FASTQ/FASTA
   Operations" is a dialog window title, never a menu, per CONSISTENCY.md.
2. The claim that `NC_045512.2` "is never substituted" because "its FASTA header
   would not match the primer BED". DRIFT changed row 18. Every bundled manifest
   lists `NC_045512.2` as an equivalent accession, so the stated reason is wrong.
   The chapter now simply says the reference is fixed and offers no control,
   without inventing a mechanism.
3. The "cuts primers.fasta out of the reference" paragraph. The fact is true
   (`ViralReconWorkflowExecutionService.swift:319-323`, and no `.fasta` or `.fa`
   exists in any of the eight scheme folders, checked with `find`), but it is
   staging detail an undergraduate reader never sees, so it was cut rather than
   corrected.
4. The advanced-field examples `--consensus_caller ivar` and `--max_memory 16.GB`,
   which the old chapter offered as things that might be refused. DRIFT changed
   row 35 asked for these to be tested. Reading
   `ViralReconRunRequest.overridableAdvancedKeys` settles it. Both are
   *overridable*, not structural, so both are accepted. The chapter now names
   both sets explicitly instead of guessing.
5. The whole "Inputs", "Reference and Primers", "The four controls", "CLI
   Procedure", and "Outputs and Provenance" heading structure, replaced by the
   campaign template order.
6. The two defaults tables and the nine-row stage table. The stage table was
   accurate but was nine rows of parameter names with no biological meaning for
   this reader. What survives is the two facts that matter, which are that
   Assembly and Kraken2 are off by default and can be switched on, and that
   Freyja is off permanently and cannot.
7. The backwards Next link to Alignment Quality. DRIFT changed row 47. Chapter 04
   already names this chapter as the last in the part, so this chapter now closes
   the part and points forward to `05-variants/01-calling-variants-from-amplicons.md`.

## How each DRIFT row was settled

False rows.

- Row 8 and row 28, menu path. Fixed as above, verified against `MainMenu.swift`.

Changed rows.

- Row 18, `NC_045512.2`. Settled by removing the false mechanism. See item 2.
- Row 19, `primers.fasta`. Settled by checking all eight scheme directories.
  None ships one, so the source comment is correct. The claim was cut as
  irrelevant to the reader rather than published.
- Row 21, sheet structure. Settled. The chapter now names the Viral Recon header
  and its Docker line, then the four sections, then says where Advanced sits and
  when a fifth Platform section appears.
- Row 22, `PrimerOption.detail`. Settled by reading
  `ViralReconWizardSheet.swift:933-937`. The old chapter's three fields were
  right. The chapter now also quotes the real rendered string for the fixture's
  scheme.
- Row 35, advanced examples. Settled by reading the reserved-key sets. See item 4.
- Row 46, `provenance bibliography`. Settled. The subcommand exists exactly as
  named, in `cli-help/provenance.txt`.
- Row 47, Next link. Settled. See item 7.
- Row 48, `--param primer_bed=...` on the CLI. Settled by reading
  `WorkflowCommand.runNFCoreWorkflow`, which builds an `NFCoreRunRequest`
  directly and applies no `structuralAdvancedKeys` guard. Confirmed a second way
  by `ViralReconRunRequest.cliArguments`, which is what the GUI itself shells
  out, and which emits `--param primer_bed=...` on every run. The flag is not
  merely allowed on the CLI, it is required there, and the chapter says so.

Unverifiable row. The Part A summary counts one unverifiable claim for this
chapter but the ground-truth table lists none under that verdict for
`05-viral-recon-wizard.md`. The nearest is row 44's note that `--timeout` parses
and is then rejected, which was resolvable from `WorkflowCommand.swift:397-399`
and is now stated in the chapter. Nothing was left unsettled on that basis.

Missing features from the DRIFT list, all now covered.

- Eight bundled schemes shared with the primer-trim dialog. Covered in Procedure.
- Nanopore `fastq_dir` and `sequencing_summary`. Covered indirectly by the
  structural-parameter list and by the platform discussion. Not expanded, because
  the chapter's fixture is Illumina and a full Nanopore walkthrough would need a
  Nanopore SARS-CoV-2 fixture the manual does not have.
- `primer_left_suffix` and `primer_right_suffix`. Named in the structural set.
- `max_cpus` defaulted to core count capped at 8. Covered by the CLI section's
  `--cpus 8`, matching `defaultResourceParams()`.
- Advanced Clear button and annotation note. Covered in Settings.
- `primer_fasta` emitted only when the file exists. Cut as staging detail.
- Full reserved-parameter list. Covered verbatim in Settings.
- `ViralReconResultIngest` and `ViralReconResultInventory`. This is the largest
  addition. The whole Reading the results section is new and did not exist before.
- `--repeat-from` and `--params-file`. Both named in On the command line.
- `ConsensusCoordinateMap`. Covered in Reading the results.

## Shot markers

Four markers, each with a frontmatter caption. The two planned shots from the old
chapter were both marked invalid by the DRIFT screenshot table, so both were
recaptioned and one was renamed.

| id | Change | Caption intent |
|---|---|---|
| `viral-recon-menu-item` | Replaces `viral-recon-tool-row` | The open `Tools > Mapping` submenu with Viral Recon... as its fifth item, per the DRIFT instruction |
| `viral-recon-wizard-overview` | Kept, recaptioned | Now names the header, the Docker note, all four sections, and the collapsed Advanced |
| `viral-recon-advanced-open` | New | The Advanced disclosure expanded, which no shot covered before |
| `viral-recon-inspector-outputs` | New | The Inspector's five output sections, the surface the old chapter never described |

## Glossary additions

Eight terms added to `docs/user-manual/GLOSSARY.md` in the existing entry shape,
each alphabetised into its section, all listed in `glossary_refs`.

`amplicon-dropout`, `container`, `docker`, `mosdepth`, `multiqc`, `nextflow`,
`nf-core`, `run-bundle`.

`sample-sheet` already existed and is reused rather than duplicated as
"samplesheet". The glossary's warning count went from 299 to 297 after the pass,
because two semicolons I first introduced were removed. Every remaining warning
on my lines is the mandated `See also:` colon shape shared by all 200-odd
existing entries.

## Things that look like app defects

1. The `Lineage` glossary entry, which predates this chapter, states that
   "Lungfish does not assign lineages itself; it produces consensus FASTAs that
   downstream tools call lineages from." That is no longer true of this path.
   viralrecon runs Pangolin and Nextclade inside the pipeline and
   `ViralReconResultIngest` copies their outputs into the analysis bundle, where
   the Inspector labels them Pangolin Lineage and Nextclade Clade. The entry is
   owned by this role but is referenced by several other chapters, so I left it
   alone rather than change a shared definition mid-campaign. It should be
   revised once the classification chapters are through review. Not an app
   defect, a documentation one.
2. The wizard's advanced-parameter check falls back to
   `ViralReconRunRequest.overridableAdvancedKeys` when the pipeline schema has
   not been pulled yet (`loadKnownParameters`, `ViralReconWizardSheet.swift:551-566`).
   Before a first run, therefore, the field accepts a much narrower set of names
   than after one, and a legitimate pipeline parameter typed on a fresh install is
   rejected with "is not a Viral Recon parameter. Check the spelling.", which is
   the wrong reason. The chapter does not document this, because documenting it
   would be documenting a bug. Worth a look.
3. `docs/user-manual/features.yaml` entry `align.viral-recon` carries a stale
   entry point (`Tools > FASTQ/FASTA Operations > Alignment`) and a stale source
   path (`Sources/LungfishApp/Views/Metagenomics/ViralReconWizardSheet.swift`,
   which is now under `Views/Mapping/`). I do not own that file and did not touch
   it. The Code Cartographer should correct both.

## Figures the Phase 5 capture run must fill in

The chapter deliberately describes the shape of every result without naming a
number, in every place where no recorded figure exists. Phase 5 should run the
fixture through the wizard and supply these.

1. How many read records of the 86,281 SRR36291587 pairs the pipeline mapped,
   and the mapping rate, for the Run Quality Summary paragraph.
2. Mean genome coverage depth for the sample, and the depth range across the 223
   QIAseq amplicons, so the What good looks like section can say what a healthy
   amplicon profile looks like rather than only what a failed one does.
3. Whether any amplicon dropped out on this fixture, and if so which, so the
   dropout check has a concrete example.
4. The consensus length and the number of masked `N` positions for SRR36291587.
   The chapter currently cites the SRR11140748 figures from the design spec and
   labels them as a different sample. Replace or supplement with the fixture's own.
5. The Pangolin lineage call, its reported confidence, and the Nextclade clade,
   so the two-tool agreement check has a worked example.
6. Wall-clock runtime of the run on the reference machine, including whether the
   first-run container pull is counted. The chapter says only that it takes far
   longer than a single dialog, because no recorded duration exists and the prose
   rules forbid an unsourced one.
7. The exact filenames the Inspector lists in each of its five sections for this
   fixture, to confirm the table in Reading the results names every row a real run
   produces and no row it does not.
