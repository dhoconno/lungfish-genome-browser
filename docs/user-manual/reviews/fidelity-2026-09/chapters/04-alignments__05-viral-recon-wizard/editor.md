# Editor pass, 04-alignments/05-viral-recon-wizard

Date: 2026-09-07. Role: brand-copy-editor. Chapter edited in place. No other
file touched except this report and the chapter's own front matter.

## Changes from the fidelity review (false rows)

1. **Settings, Scheme, command-line sentence.** Fidelity false row. Replaced
   `--param primer_set_version`, which exists nowhere in the source, with
   "On the command line this is `--param primer_bed=<path>`, together with
   `--param primer_left_suffix` and `--param primer_right_suffix` read off the
   scheme." Wording follows ruling 1 exactly. The bold label is unchanged.
2. **Settings, refused-parameter sentence.** Fidelity false row. "the five
   primer parameters" corrected to four, and per reader row (4 readers) the
   four are now named inline as `primer_bed`, `primer_fasta`,
   `primer_left_suffix`, `primer_right_suffix`, with the two Freyja skips
   named as `skip_freyja` and `skip_freyja_boot`.
3. **Link text, plugin packs.** Fidelity false row. "Plugin Packs and
   Databases" corrected to "Plugin Packs", the target's real title.
4. **Link text, importing reads.** Fidelity false row. "Importing FASTQ Files"
   corrected to "Importing Sequencing Reads", the target's real title.

## Changes from the fidelity review's extra notes (ruling 3)

5. **On the command line, lead paragraphs.** Added a paragraph saying the block
   is a hand-written command that reproduces the procedure rather than a
   transcript of what the wizard runs, and naming the two differences. The
   wizard stages a local reference and passes `--param fasta=` and
   `--param gff=` where the block passes `--param genome=MN908947.3`, and it
   writes its run bundle with `--bundle-path` where the block uses
   `--bundle-root`.
6. **Procedure, step 4 and the viral-recon-advanced-open caption.** Added a
   sentence to the step telling the reader the picture is posed with the
   section clicked open although the procedure leaves it collapsed. The
   frontmatter caption itself is unchanged, since the surrounding step now
   carries the explanation.

## Changes from reader rows hit by three or more readers

7. **What it is, five tool names in one sentence** (4 readers). Split into a
   five-row table naming Bowtie2, iVar, BCFtools, Pangolin, and Nextclade with
   what each contributes. No new section, no reordering.
8. **What it is, platform detection** (4 readers). Now states plainly that the
   platform is read out of the metadata the read bundle recorded at import, and
   glosses "platform" as the kind of machine that produced the reads.
9. **Before you start, execution profile** (4 readers). Glossed in place as the
   pipeline's setting for where its programs come from and run.
10. **Why you would do this, read count judgement** (4 readers). Reworded
    "clinical-scale" to "large enough to behave like a real patient sample
    rather than a teaching toy". No coverage figure invented, since none is
    recorded for this fixture (ruling 6, no unsourced numbers).
11. **Running and watching, no time estimate** (4 readers). Ruling 6 forbids an
    unsourced duration, so instead of a number the chapter now says plainly
    that no measured time is quoted because no timed run of this fixture is
    recorded, and to plan for an unattended stretch. Phase 5 supplies the
    figure.
12. **Filling in the controls, step 1, Inputs example** (4 readers). Added the
    concrete string `Imports/SRR36291587.lungfishfastq` as the example path.
13. **Step 2, scheme caption numbers** (4 readers). Now says the 563 primers
    and 223 amplicons are that one scheme's fixed values rather than anything
    measured from the reads, and to match them against the kit documentation.
14. **Step 2, no kit box in hand** (4 readers). Added the kit insert, the
    sample metadata, and the person who prepared the library as fallbacks.
15. **Settings, Scheme default** (4 readers). The default is now flagged in its
    own sentence as not chosen for the reader's sample and almost always wrong.
16. **Settings, Minimum mapped reads, stepper** (4 readers). Named as the small
    up and down arrows beside the field, and states that typing a value works
    too.
17. **Settings, refused parameters never named** (4 readers). Covered by change
    2 above.
18. **Reading the results, AATT to A** (4 readers). Now states the loss is
    three bases and that a shortfall of a few bases is expected on a sample
    carrying deletions.
19. **What good looks like, Freyja on Apple Silicon** (4 readers). Rewritten to
    say plainly that every Mac sold since 2020 is Apple Silicon, how to check
    under **Apple menu > About This Mac**, and that the helper processes the
    bootstrap step starts are killed there.
20. **On the command line, skippable** (4 readers). The section now opens with
    "This section is optional." before anything else.
21. **What it is, pins and tool lock manifest** (3 readers). Pinning glossed as
    fixing the version so it never moves, already done for the reader, and the
    lock manifest glossed as the file naming the exact version of every outside
    program.
22. **What it is, viral reconstruction** (3 readers). Glossed as rebuilding the
    sample's own genome from reads compared against a known reference.
23. **Before you start, Docker Desktop** (3 readers). Added the download URL
    and named the whale icon in the menu bar as the running check.
24. **Before you start, Required Setup pack** (3 readers). Now states there is
    no check for the reader to run, since having opened a project means the
    pack is present.
25. **Step 1, mixed platforms** (3 readers). Added the concrete scenario of
    shift-clicking a folder of bundles where some came from a MiSeq and others
    from a MinION.
26. **Running and watching, right-click** (3 readers). Reworded as copying a
    text record of what the app asked the pipeline to do, useful in an email or
    a lab notebook, with no assumption of terminal familiarity.
27. **Settings, the "Minimum mapped reads:." label** (3 readers). Ruling 5
    keeps the label verbatim, so instead of removing the colon the Settings
    lead-in now tells the reader the stray colon is copied from the label the
    sheet draws and no word is missing.
28. **Reading the results, untrimmed BAM** (3 readers). Now states the
    untrimmed alignment is also kept, in the raw pipeline output tree beside
    the bundle.
29. **Reading the results, "by index"** (3 readers). Replaced with a plain
    statement that LGE corrects for missing bases so reference position 500
    still points at the matching consensus base rather than the five hundredth
    base in the file.
30. **Reading the results, Alignment Index** (3 readers). Added a sentence
    saying it is a helper file that lets the app jump to any position, and that
    the reader never opens it.
31. **What good looks like, dropout threshold** (3 readers). No measured
    cut-off exists, so the chapter now says so and tells the reader to read the
    column against the other amplicons of the same run.
32. **What good looks like, "mostly N"** (3 readers). Same treatment. States
    plainly that no pass-mark percentage is given because the threshold belongs
    to the surveillance programme, not the pipeline.
33. **On the command line, the backslash** (3 readers). Added a sentence saying
    the backslash marks the space as part of the `Primer Schemes` folder name
    rather than being a typing mistake.

## Changes from one and two reader rows whose fix was a sentence or two

34. What it is, samplesheet glossed as a small table listing which read files
    belong to which sample.
35. What it is, "track" glossed as one layer of data drawn over a genome.
36. What it is, reference genome purpose stated (every read compared against
    that one fixed genome).
37. What it is, the `.3` in `MN908947.3` explained as the record's version, and
    named as the record every SARS-CoV-2 result is reported against.
38. What it is, inline link added from "amplicon" to
    `01-foundations/03-amplicon-vs-shotgun.md`, with an inline gloss.
39. What it is, "being blunt about how narrow that is" replaced with a plain
    statement that the wizard works for one virus only.
40. What it is, the direct question "So what should you do with this?" removed
    and replaced with the rule stated directly.
41. What it is, run-bundle timing stated as just before Nextflow starts and
    never after.
42. Why you would do this, "rather than within one" replaced with "rather than
    between two runs of the same sample".
43. Why you would do this, "by construction" replaced with "because every
    sample gets the same settings".
44. Why you would do this, the dropout definition moved ahead of the sentence
    that uses it, and the double negative replaced with "no reads and no
    variants look exactly the same as a stretch that matched the reference
    perfectly".
45. Why you would do this, paired-end glossed as each fragment read from both
    ends.
46. Before you start, "the launch path refuses any other" replaced with "the
    app will not start the run any other way".
47. Opening the wizard step 1, the bundle described as one row in the left
    sidebar, clicked once to highlight, and "a sheet that will not run"
    replaced with the Readiness message plus a greyed-out Run button.
48. Opening the wizard step 2, the reasoning about why the item sits fifth
    moved into an indented Note, so it no longer reads as an instruction.
49. Opening the wizard step 3, "disclosure" glossed as a collapsible section
    closed until you click its triangle.
50. Filling in the controls step 2, added the clause that the primer count
    should be roughly twice the amplicon count.
51. Filling in the controls step 3, the one-line meaning of Minimum mapped
    reads given in place so the reader need not jump to Settings.
52. Filling in the controls step 5, Readiness now says it names only the first
    missing piece.
53. Settings lead-in, states that an app-only reader can skip every closing
    command-line sentence.
54. Settings, Platform, angle brackets and the upright bar explained as
    choosing one of the two words shown.
55. Settings, Platform, "lost in an earlier copy" explained as reads copied out
    of a bundle and back in as bare files.
56. Settings, Scheme, the primer-bases warning given its own sentence.
57. Settings, Minimum mapped reads, low-titre glossed as carrying very little
    virus, and "mostly ambiguous genome" replaced with "full of unresolved
    positions".
58. Settings, Annotation, GFF expanded at first use as General Feature Format,
    "variant effects" replaced with a variant reported as falling inside a
    named gene, open reading frame glossed, and a sentence added saying most
    readers will never change this.
59. Settings, Extra parameters, the shape spelled out as two dashes then name
    then space then value, with a note to type the dashes exactly as shown, and
    a pointer to the published parameter list at
    https://nf-co.re/viralrecon/3.0.0/parameters.
60. Reading the results, "coordinate system" glossed as positions counted along
    the reference genome.
61. Reading the results, read depth defined in place.
62. Reading the results, the MultiQC row now says clicking it leaves LGE and
    opens the page in a web browser.
63. Reading the results table, the Provenance row reworded as evidence files
    the rest was derived from rather than an interpretation.
64. Reading the results, a sentence added saying no Pangolin confidence figure
    is quoted because no run of this fixture is recorded.
65. What good looks like, "in the order they can each invalidate the ones after
    them" replaced with a plain statement that a failure at one check makes the
    later checks meaningless.
66. What good looks like, "the threshold speaking" replaced with the pipeline
    setting the sample aside on purpose.
67. What good looks like, `N` explained as an unknown base and masking named.
68. What good looks like, the long Pangolin and Nextclade disagreement sentence
    split in two.
69. On the command line, `--executor` and `--timeout` reworded to say plainly
    that the extra choices are accepted for compatibility and do not work here,
    and that neither is a bug worth reporting.
70. On the command line, `--cpus 8` and `--memory 8.GB` explained, with advice
    to set `--cpus` to the core count on a smaller Mac.
71. Next, the closing paragraph now says the next chapter walks through by hand
    what the pipeline did silently, to run it after rather than instead, and
    says plainly what the reader gives up by letting the pipeline choose.

## Front matter

72. `glossary_refs` trimmed from twenty-one anchors to eighteen. `amplicon`,
    `variant-caller`, and `vcf` are no longer linked from the body, because the
    amplicon mention now links the amplicon-versus-shotgun chapter and the
    other two were never linked in the revised text. Every remaining anchor is
    linked in the body and resolves in `GLOSSARY.md`. Permitted by ruling 5.
73. `brand_reviewed` flipped to `true`.

## Deliberately left unchanged

- **The unverifiable `loadKnownParameters` behaviour.** Ruling 2. The chapter
  still says the typed name is checked against the pipeline's own parameter
  list, with no caveat about a fresh install.
- **The SRR11140748 consensus figures.** Ruling 4. The sample is now named
  explicitly in the sentence and labelled as a different sample and not this
  chapter's fixture, so it cannot be misread as the fixture's own result.
  Phase 5 supplies SRR36291587's figures.
- **The five settings paragraphs, their order, their bold labels.** Ruling 5.
  All five kept, including the colon-terminated **Minimum mapped reads:.**
  label. The stray colon is explained in the Settings lead-in instead of being
  removed, which is the only fix available that keeps the label verbatim.
- **Section order and the eight-section template.** Ruling 5. Nothing moved.
- **Every duration, coverage number, depth cut-off, `N` percentage, and
  download size the readers asked for.** Ruling 6 forbids unsourced figures and
  no recorded run of this fixture exists. Where readers asked for a number the
  chapter now says explicitly that none is quoted and why, rather than
  inventing one or leaving the reader wondering. Seven such figures are on the
  author's Phase 5 list.
- **`parameters.yaml`, `GLOSSARY.md`, `features.yaml`, and every other
  chapter.** Ruling 5. The registry's own `cli_flag: --param
  primer_set_version` error for Scheme is corrected in the chapter only, and
  the project manager states the registry has already been corrected to match.
- **The `Lineage` glossary entry** the fidelity review flags as contradicted by
  this chapter, and its semicolon. Shared definition, not this role's file, and
  the author already routed it for revision after the classification chapters.

## For the project manager to rule on

- The fidelity review notes that `01-foundations/07-plugin-packs.md` does not
  itself name Nextflow among the tools it lists, so a reader following this
  chapter's cross-reference will not find the word in the target. That is a fix
  in another chapter, outside this pass.
- The reader team asked twice for a download size and time for the SRA fetch in
  Before you start. No sourced figure exists and ruling 6 forbids an unsourced
  one, so nothing was added there at all. If a figure is wanted, Phase 5 can
  measure it.

## Lint output, verbatim

    /Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/04-alignments/05-viral-recon-wizard.md: no issues found

## Status

brand_reviewed: true
