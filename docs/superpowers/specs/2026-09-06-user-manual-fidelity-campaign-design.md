# User manual fidelity and accessibility campaign, design

Date: 2026-09-06
Branch: `worktree-user-manual-fidelity-campaign`
Status: approved in conversation, awaiting written-spec review

## Goal

Revise the whole Lungfish Genome Explorer user manual (`docs/user-manual/`, 67
chapter files, about 137,000 words) so that, in this order of priority:

1. Every statement is accurate and faithful to how the app behaves in the
   installed Preview build, version 2026.9.13.
2. The text is readable by an undergraduate biology student who has taken
   genetics but has never used a terminal. This means more explanatory text
   around each operation than command-line tool documentation normally
   carries.
3. Every operation or tool the manual explains also explains every setting
   and parameter the app exposes for it, and what each one does.
4. Explanations follow one consistent shape from chapter to chapter.
5. The prose carries none of the tells associated with machine-generated
   text: no em dashes, no semicolons, no colons used as joiners inside a
   sentence, and none of the words or sentence patterns in the reference
   list at https://www.contentbeta.com/blog/list-of-words-overused-by-ai/.

The campaign covers the whole manual in one pass (the user chose this over
part-by-part delivery). Screenshots are in scope and existing screenshots may
be recreated or replaced.

## Decisions taken in the design conversation

| Question | Decision |
|---|---|
| Sequencing | Whole manual in one campaign. |
| Colon rule | Ban colons inside sentences. A colon that ends a short lead-in line immediately before a list, table, or code block stays allowed. |
| Screenshots | In scope. Recapture as needed, from `/Applications/Lungfish Preview.app` (2026.9.13), driven through computer use. Existing shots may be replaced. |
| App name | "Lungfish Genome Explorer" at first mention in each chapter, "LGE" after. "Lungfish" alone means the research collaborative. |
| Example data | Non-viral examples from human or macaque genomics whenever possible. Viral data only where the feature is viral by design. |
| Readers | A team of undergraduate reader personas, each reading independently, with their reports synthesized into one. |
| Models | Fable 5.1 supervises, gates, and reviews every diff. Lesser agents do bounded authoring, editing, and extraction. Opus 4.8 is preferred over Opus 5 for prose work wherever the harness offers the choice. |
| Approach | Approach A (ground truth first, then rewrite, then scrub, with lint that enforces the rules). |

## Non-goals

- No changes to app behavior. Where the manual and the app disagree, the
  manual changes. Defects found in the app during the audit are recorded in
  the results report and, where clear, filed as issues, not fixed here.
- No new chapters for features that do not exist. A feature that exists
  and is undocumented gets a chapter.
- No redesign of the manual's navigation beyond what renamed or added
  chapters require.
- The InDesign and PDF export paths (`md-to-icml.sh`, `with-pdf`) are not
  exercised beyond confirming the mkdocs build still succeeds.

## Sources of truth

In priority order, the arbiter of any factual claim is:

1. The installed Preview app, `/Applications/Lungfish Preview.app`,
   version 2026.9.13 (bundle id `com.lungfish.browser.preview`, display
   name "Lungfish Genome Explorer Preview").
2. The Swift source at the same version. In particular
   `Sources/LungfishApp/App/MainMenu.swift`,
   `Sources/LungfishApp/App/AppDelegate+ToolsMenu.swift`,
   `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift`, the
   wizard sheets under `Sources/LungfishApp/Views/**`, and the pipelines
   under `Sources/LungfishWorkflow/**`.
3. The CLI help tree from the matching binary,
   `.build/debug/lungfish-cli` (2026.9.13), recursed one level below every
   subcommand.
4. `Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json`
   for tool names, versions, pack membership, experimental flags, and
   databases.
5. `docs/user-manual/features.yaml`, treated as a partial index, not as
   ground truth.

The three code audits run on 2026-09-06 for the README rewrite (GUI
inventory, CLI and tools, release history) are reused as a starting point.
Their conclusions are summarized in the project memory file
`project_github_pages_landing_site.md` and in the README's "What LGE can do
today" section.

## Stage 1: ground truth and the parameter registry

### Reality maps

For each part of the manual (Foundations, Sequences, Reads, Alignments,
Variants, Classification, Human Germline Variants, Assembly, Workflows,
Genotyping, Appendices) an agent writes a reality map to
`docs/user-manual/reviews/fidelity-2026-09/ground-truth/<part>.md`. The
June 2026 maps under `reviews/part-ii-fidelity-2026-06-02/ground-truth/`
are the starting point. Foundations, which the June pass skipped, is
included.

Each map lists, chapter by chapter, every claim the chapter makes about the
app (menu path, dialog, setting, output, file written, behavior) and
records for each whether it is true, false, or changed, with the source
file and line, CLI output, or Preview-app observation that decides it. The
map also lists features in the app that the part should cover and does
not.

### The parameter registry

A new file, `docs/user-manual/parameters.yaml`, owned by the Code
Cartographer role in the same way as `features.yaml`. One entry per
operation. Schema:

```yaml
version: 0
operations:
  <operation_id>:            # e.g. fastq.trim.fastp, map.minimap2, classify.kraken2
    title: <human name as shown in the app>
    entry_points: [<menu path>, "CLI: lungfish-cli ..."]
    gating: [<pack id>, docker, experimental]   # empty when none
    sources: [<Sources/ path>, ...]
    settings:
      - label: <control label exactly as the app shows it>
        control: <checkbox | number | slider | popup | text | file | radio>
        default: <value>
        allowed: <range, list, or "any">
        effect: <one or two plain sentences on what it changes>
        when_to_change: <one sentence, or "rarely">
        cli_flag: <flag or null>
    cli_only:
      - flag: <flag>
        default: <value>
        effect: <one sentence>
    notes: <free text, including anything that differs between GUI and CLI>
```

Extraction is by agent from the dialog state, wizard sheets, and
`--help` output. A second agent spot-checks the twenty most used
operations against the live Preview app by opening each dialog and reading
its controls, and records the check in the registry `notes`. Chapters cite
registry ids in a new frontmatter key `parameters_refs`.

### Fixtures

Fixture tiers in `docs/user-manual/fixtures/README.md` flip to:

1. **Human.** Public-domain Genome in a Bottle HG002 reads sliced to a
   small region of GRCh38 for mapping and variant chapters. The human
   mitochondrial genome and its reads for a compact assembly example. A
   human gene GenBank record with annotations for the sequence chapters.
2. **Rhesus macaque.** Mmul_10 slices where a macaque reference is needed.
   For genotyping, the lab's own MiSeq amplicon project
   `32566_MS267_Williams1.lungfish` (30 samples, IPD-MHC Mamu 2021-07-09
   reference bundle, seven genotype result bundles, 475 MB). It exceeds the
   fixture caps, so it is a documented external demo asset, not a
   committed fixture. User decision 2026-09-06: the genotyping chapters use
   it as a genotyping-only example. Haplotype analysis (the MCM, Mauritian
   cynomolgus macaque, haplotyping features) is not worked in this campaign.
   Each genotyping chapter that would otherwise cover haplotyping carries
   one short, clearly labeled placeholder section stating that the feature
   exists, that a worked example with an MCM dataset will be added later,
   and nothing more. This placeholder is the one sanctioned exception to
   the "promise only what exists" rule, because the feature does exist.
3. **Primate comparative.** Mitochondrial genomes of human, chimpanzee,
   gorilla, rhesus, and cynomolgus macaque from NCBI, for multiple
   sequence alignment and tree chapters.
4. **Viral, only where the feature is viral by design.** Viral Recon,
   Freyja, EsViritu, NVD, and the classification chapters keep SARS-CoV-2
   or metagenomic data. The existing SARS-CoV-2 fixtures stay for these.

Every new fixture keeps the existing caps (10 MB per file, 50 MB per set,
a `fetch.sh` for anything larger), a README with accession, license,
citation block, sizes, and internal-consistency notes, and a regeneration
script. Fixtures are never invented data.

## Stage 2: style rules, linter, and the agent team

### Rules added to `STYLE.md`

1. **No semicolons in prose.** Split the sentence.
2. **No colons inside a sentence.** A colon may end a short lead-in line
   that is immediately followed by a list, table, or fenced code block. The
   current advice to use a colon as the em-dash replacement is removed.
3. **No overused words or patterns.** The word list and sentence patterns
   from the reference article are banned in prose, in every inflection.
   Terms of art that appear on the list keep their technical meaning only
   inside code, tables, or quoted app labels (for example a control
   literally labeled "Navigate").
4. **App naming.** "Lungfish Genome Explorer" at first mention in a
   chapter body, "LGE" after. "Lungfish" alone refers to the research
   collaborative. The current written-identity rule is replaced.
5. **Settings section.** Any chapter that documents an operation contains
   a `## Settings` section. Each setting is one entry in a fixed shape
   (what it does, the default and why, when to change it) and the section
   covers every setting the parameter registry lists for that operation.

### Linter

One rule file per new rule under `build/scripts/lint/rules/`:
`semicolon.js`, `sentence-colon.js`, `ai-tells.js` (words and patterns,
merged with the existing `voice.js` banned list), `app-name.js`
(replacing `written-identity.js`), and `settings-coverage.js` (reads
`parameters.yaml` and each chapter's `parameters_refs`). Each rule ships
with cases in `test-rules.mjs` and a fixture under `lint/fixtures/`. The
rules are landed and green on the current manual's structure before any
chapter is rewritten, with the prose rules set to report (not fail) until
the rewrite reaches each chapter.

### Agent definitions

The four definitions under `.claude/agents/` (`documentation-lead`,
`bioinformatics-educator`, `brand-copy-editor`, `code-cartographer`) and
`screenshot-scout` are updated to the new rules, the new template, the
registry, the fixture tiers, and the app-name rule. Two personas are
added:

- `manual-fidelity-reviewer`: reads a chapter against its reality map,
  registry entries, the Swift source, and the CLI binary, and reports
  every claim it cannot verify.
- `undergraduate-reader`: parameterized persona used for the reader team
  (see Stage 3).

The docs prose rules memory file is corrected to match.

## Stage 3: chapter template and rewrite pipeline

### Template

Every chapter follows this order. Concept-only chapters (Foundations,
appendices) use the first two sections and whatever else applies, and the
lint rule for the Settings section applies only to chapters with
`parameters_refs`.

1. `## What it is`. The concept in two to four short paragraphs. Every
   term glossed at first use in the chapter. Pitched at the undergraduate
   reader.
2. `## Why you would do this`. Biological motivation tied to the chapter's
   fixture.
3. `## Before you start`. What must already be in the project, which tool
   pack, whether Docker is needed, how long the example takes.
4. `## Procedure`. Numbered steps, exact menu path, one action per step,
   a `<!-- SHOT: id -->` marker wherever the reader needs to see the screen.
5. `## Settings`. One entry per setting from the registry, in the fixed
   three-part shape.
6. `## Reading the results`. What appears in the viewport and inspector,
   what each number means, worked against the fixture's real output.
7. `## What good looks like`. The checks to apply before trusting the
   result.
8. `## On the command line`. One shell block reproducing the procedure.

### Pipeline per chapter

Agents run one chapter at a time per role. No two agents edit the same
file at once.

1. **Author** (educator role, Opus). Rewrites the chapter against its
   reality map, registry entries, fixture, and the template.
2. **Fidelity review** (Fable, with the fidelity-reviewer persona as a
   first pass). Every claim checked against the sources of truth.
3. **Reader team** (four `undergraduate-reader` instances, Opus or
   Sonnet). Personas: a sophomore fresh from genetics with no lab time; a
   senior who has pipetted but never analyzed; a pre-med for whom English
   is a second language; a student who used Geneious in a class. Each
   reads the chapter cold and lists every sentence or step they could not
   follow. A synthesizer agent merges the four reports into one, ranking
   each confusion point by how many readers hit it.
4. **Editor** (Opus). Applies the synthesis, scrubs voice and tells,
   enforces the template and naming.
5. **Lint** green with the new rules.
6. **Fable diff review.** Every chapter's diff is read in full before it is
   committed. Frontmatter `brand_reviewed` and `lead_approved` flip only
   here.
7. **Commit**, one per chapter, naming the roles that signed off.

The glossary, mkdocs navigation, and `help-ids.yaml` are updated as
chapters change. Nothing is removed from the manual without a note in the
review record saying what was removed and why.

### Model policy

Fable 5.1 gates, reviews every diff, and does the fidelity review. Opus
authors and edits. Sonnet or Haiku only for mechanical passes (help-tree
extraction, lint runs, link checks). Opus 4.8 is preferred over Opus 5 for
prose wherever the harness offers the choice. Note for this session: the
agent launcher exposes a single `opus` option (Opus 5) and cannot pin 4.8.

## Stage 4: screenshots and the demo project

### Demo project

One project, built by a script from the fixtures, with every result the
manual needs already computed: the HG002 slice mapped and called, the
mitochondrial assembly, the primate mitochondrial alignment and tree, a
macaque MHC genotyping run, a classification run on the viral database, an
imported NVD result, and a Viral Recon run for its chapter. The script
lives under `docs/user-manual/fixtures/demo-project/` and produces the
project outside the repository (results exceed the size caps), under
`~/Desktop/lge-docs/` at the user's request (2026-09-06), so any project a
screenshot was taken from can be reopened later to redo the shot. The
Williams genotyping project is copied there too and the copy is the one
opened for capture. Recipes point at those paths.

### Capture

Shots are captured from `/Applications/Lungfish Preview.app` through
computer use, one shot at a time, by an agent under Fable supervision.
The user grants access to "Lungfish Genome Explorer Preview" when asked,
and capture sessions run while the user is around. Every shot gets a
recipe file under `assets/recipes/<chapter>/<id>.yaml` even though the
runner cannot replay click actions today, so the intent is recorded. Light
appearance, fixed window size 1600 by 1000 for full-app shots, never the
menu bar or Dock, never user-specific state. The 22 existing markers and
12 images are audited against the rewritten procedures and recaptured
where stale.

## Stage 5: verification and delivery

- Every chapter passes lint with the new rules.
- `mkdocs build` completes without warnings.
- A link checker passes over every internal link and glossary reference.
- A script confirms each chapter's Settings section covers its registry
  entries (this is the lint rule, run over the whole manual).
- A script confirms every shot marker has both an image and a recipe.
- Frontmatter flags reflect reality: `lead_approved: true` only after the
  full pipeline.
- Work lands on the campaign branch in a worktree, one commit per chapter.
- The campaign closes with `reviews/fidelity-2026-09/RESULTS.md` listing
  every factual correction, every feature the old manual described that
  does not exist, every feature it omitted, and every claim that could not
  be verified, in the shape of the June results file.
- Read the Docs rebuilds from `main` after merge.

## Risks

- **Scale.** 67 chapters through a six-step pipeline is weeks of agent
  work. The plan sequences parts so partial progress is always shippable.
- **Fixture sourcing.** The macaque MHC run needs the user to name an
  accession. Human data must be public domain or openly licensed (GIAB
  qualifies).
- **Computed results for the demo project.** Kraken 2 and Viral Recon runs
  need databases and Docker on the capture machine.
- **Computer use availability.** Capture needs the user present to grant
  access. Capture is scheduled as its own phase.
- **Lint false positives.** The overused-word list contains ordinary
  words ("capture", "critical", "navigate"). The rule must whitelist
  quoted app labels, code, and tables, and the list is reviewed before it
  is enforced as an error.

## Open items for the user

1. Resolved 2026-09-06: the genotyping demo data is
   `/Users/dho/Downloads/32566_MS267_Williams1.lungfish`.
2. Resolved 2026-09-06: Docker Desktop and Kraken 2 with databases are on
   the capture machine.
3. The Williams project's sample names and barcode sheet may carry animal
   identifiers. Confirm they may appear in published screenshots, or name
   the samples to use.
4. Resolved 2026-09-06: haplotyping is out of scope for this campaign.
   The genotyping chapters carry a labeled placeholder section for it.
