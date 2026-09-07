# Editor pass, chapter 31: 05-variants/06-importing-existing-vcfs

Editor: brand-copy-editor. Date: 2026-09-07.
Chapter: `docs/user-manual/chapters/05-variants/06-importing-existing-vcfs.md`.
Inputs: `fidelity.md` (73 true, 3 false, 2 unverifiable), `readers.md` (80 rows,
25 hit by three or more readers), `author.md`, `CONSISTENCY.md`, `STYLE.md`,
and the project manager's six binding rulings.

## Changes from the fidelity review

**Claim 24, false. The write-permission check does not run on every path.**
Step 3 said "That check runs on every VCF import on every path." Replaced with
"That check runs before the import on both the Import Center path and the
drag-and-drop path", which is the review's own corrected wording and excludes
the orphaned `importVCFToBundle` route that runs the gate only with a bundle
already open.

**Claim 59, false. `import vcf` takes more than two options.** The On the
command line section said "Its only options are the positional input file and
`--output-dir`." Replaced with "Beyond the shared options every `lungfish-cli`
command carries, its only options are the positional input file,
`--output-dir`, and `--format`." This also removes the self-contradiction the
review noted, where the section's last paragraph already said `--format` is
accepted.

**Claim 59, ruling 1. `--format` documented where the options are listed.**
Added a Settings entry, **--format (command line only).**, in the fixed
three-sentence shape, saying it takes `text`, `json`, and `tsv`, that `text` is
the default, and that changing it does nothing on this subcommand so no script
should expect JSON back. This matches the `cli_only` entry another role added
to `parameters.yaml` mid-pass (see Note on parameters.yaml below).

**Claim 72, false. Only `variants query` caps its export.** The final paragraph
said "both cap the export at 5,000 records unless you raise `--limit`."
Rewritten to say `variants query` stops at 5,000 rows unless `--limit` is
raised, while `extract-sample` writes every matching row and has no such flag.

**Ruling 2, the manifest count qualification.** The chapter had never mentioned
`variant_count` or `bundle info` at all. Added a paragraph in the On the command
line section taking the fidelity review's narrowing rather than the author's
broader claim. It says the wrong `Variants: 0` reaches you only if you ask the
command line about a bundle the window has never opened, because opening the
bundle in LGE rewrites the count from the database, and it points the reader at
the Variants tab row count and at `bcftools view -H` instead.

**Ruling 3, the Source-column claim.** Added a paragraph after the storage
paragraph keeping the claim for the window's import path, which the worked
example uses, and warning that a bundle built by `bundle create --variant`
stores its rows in a database with no source column, so the same separation
should not be assumed there.

**Ruling 4, claim 19, unverifiable drag-onto-viewport import.** Step 2's "That
runs the same import" hedged to "which is reported to run the same import", with
a following sentence saying the Import Center route is the one this chapter
verified and the drag should be used only once the reader has seen it work.

**Ruling 4, claim 38, unverifiable Import profile scope.** The Settings entry
said the profile "applies to every VCF import the window performs." Narrowed to
"It governs an import into an already-open bundle", plus a sentence saying
whether the no-bundle path of step 5 reads the same preference is not confirmed,
so a very large file on that path should be treated as unprofiled. This is the
review's suggested corrected wording.

## Changes from the reader report, rows hit by three or more readers

All 25 consensus rows are addressed.

1. **Step 1 check needs a terminal.** Rewritten to say the window check goes as
   far as reading the sequence name in the viewport, that LGE offers no way to
   look inside a VCF before importing, and that the `Chrom` column shows the
   same name after the fact.
2. **NCBI fetch unexplained and "quietly" alarming.** Dropped "quietly", glossed
   NCBI as "the free public sequence database the United States government
   runs".
3. **Command-line route's optional status.** The What it is paragraph now opens
   "There is also a command line route, which is optional, is covered only in
   the last section of this chapter".
4. **Two downloads not marked as two.** Before you start now says "Download two
   separate files", notes the names differ only in their last suffix, and lists
   both on their own lines in a code block (also reader row 3's request).
5. **Required Setup pack has no pointer.** Now glossed as "the one pack LGE
   installs by itself on first launch" with a link to
   [Plugin Packs](../01-foundations/07-plugin-packs.md).
6. **SQLite unglossed.** Step 3 now says it is an internal file format LGE uses
   to hold the rows for fast searching, and that the reader never opens it.
7. **Default Ploidy unglossed and no action stated.** Step 5 now glosses ploidy,
   links the glossary entry, and says it needs no action and that no control in
   the app edits it afterwards.
8. **Scope control never located.** Reading the results now names it as the
   two-segment **Region** / **Genome** control in the row above the table, and
   says what Region does, matching chapter 02's wording.
9. **961-in-500,001 arithmetic not connected.** Now states the one-in-a-thousand
   expectation first, shows the division of 500,001 by 961 explicitly, and says
   520 is close enough to one in a thousand for the fixture to be fair.
10. **Bare dot unglossed.** Now says it is "a single dot that is neither missing
    data nor an error" and that in a VCF it means no filter judgement was made.
11. **Preset chip never located.** Now says the chips are small labelled buttons
    that appear when you click **Presets** in the toolbar above the table.
12. **`2/1` never glossed.** Added a sentence saying the numbers name which
    alternate allele each copy carries, and that `2/1` is a position where the
    two copies carry two different changes rather than one change and the
    reference.
13. **0.571 not connected to `0/1`.** Now states before the number that a
    heterozygous position should show roughly half the reads carrying the
    change, and glosses 0.571 as 57 percent of reads carrying the `T`.
14. **Clonal isolates unglossed.** Replaced with "two bacterial cultures grown
    from a single parent cell, which are nearly identical by descent and differ
    at only a handful of positions", and reordered so the mixed-population case
    comes before it.
15. **Three explanations promised, never listed.** All three are now written out
    in prose (filter correct and nothing matches; filter reading a column one
    track leaves empty, as `PASS` does on bcftools; the track not loaded at all).
    Kept as prose rather than a list to stay inside the two-lists-per-H2 cap.
16. **HG002 identity never pinned.** Added "HG002 is DNA from one anonymous,
    well-studied person, distributed as a cell line so that laboratories
    everywhere can sequence the same material and compare answers."
17. **200-row caller gap never judged.** Now says the gap is "ordinary rather
    than alarming" and explains that the two programs draw the signal-noise line
    in different places.
18. **bcftools over-reporting given without reason.** Added the mechanism for
    both callers, bcftools listing every position that looks different enough
    and leaving the judgement to you, LoFreq requiring the alternate reads to
    beat its own error model.
19. **BCF never glossed, no conversion path.** Step 2 now glosses BCF as the
    compact binary form of a VCF, links the glossary anchor, and names
    `bcftools view -O v` as the conversion.
20. **`Auto` used before Settings defines it.** Step 3 now glosses the import
    profile inline as a preference deciding how much memory the import may use,
    and says the default needs no action.
21. **Memory guidance has no number.** The Settings entry now names 32 GB or
    more for Fast, 8 GB or 16 GB for Low Memory, and points at
    **Apple menu > About This Mac** to check.
22. **Command-line-only settings unmarked.** Both CLI entries now carry
    "(command line only)" in the bold label, and `--output-dir` closes with
    "This flag reaches the command line only and changes nothing in the app."
23. **SNP, DEL, INS never expanded.** Added a sentence mapping `SNP` to the
    Variants tab's "substitution", `DEL` to deletion, `INS` to insertion.
24. **Filter grammar and Search Builder unexplained.** Glossed filter grammar
    as "the fixed way a filter must be written down", described the Search
    Builder as the sheet that composes a filter rule by rule, and
    cross-referenced [Reading the Variants Table](02-reading-the-variant-browser.md).
25. **5,000-row cap, fate of the rest not stated.** Now says nothing warns you,
    rows past the five thousandth are simply absent, the command reports
    success, and the file looks complete. Also drops "cap" as a verb and the
    phrase "the cap is silent", per reader row 3's separate request.

## Changes from the reader report, single-sentence fixes below the threshold

Taken because each is one or two sentences.

- **"turns on one question"** replaced with "Everything depends on one question"
  (row: reader 3 did not know the idiom).
- **"That is the entire decision tree"** replaced with "Those are all the
  possible outcomes".
- **"So what should you do with this?"** rhetorical question dropped, the advice
  given directly.
- **"coordinates" unglossed** now reads "coordinates, meaning the position
  number each row carries".
- **Position 250,527 with no source** now says it comes up again later in the
  chapter as a worked example.
- **"truth set" and "benchmarking consortium"** glossed at first use in What it
  is as a call set a group of laboratories agreed on and published as the
  correct answer for one sample.
- **"answer key" unglossed** now reads "an answer key, meaning the set of
  correct answers you check your own work against".
- **bcftools and LoFreq unglossed at first mention** now introduced as variant
  callers with a linked glossary anchor and a one-clause gloss.
- **"a far better description" unexplained** now says each technology makes its
  own kinds of mistake, so agreement across several makes a change likelier to
  be real.
- **Reader never told they will not open the VCF** stated in What it is, matching
  chapter 02's existing sentence.
- **"inference readout" unpicturable** replaced with "The app never shows a guess
  about which reference the file matches."
- **"viewport" unnamed** now glossed inline as "the panel that fills the window
  when you open a bundle".
- **"fixture" defined mid-sentence** now its own sentence.
- **`.gz` decompression doubt** answered with "Leave the `.gz` file compressed".
- **"Download raw file" button unlocatable** now says it sits at the top right of
  the file's grey header bar, and glosses "raw".
- **`.tbi` opened or renamed?** now "you never open, rename, or move it
  yourself".
- **"together in one folder" ambiguous** now "Any folder works as long as both
  files sit in it, and it does not have to be the project folder."
- **Prerequisite chapter length unknown** now "a 24-minute read plus the time its
  own two calling runs take on your machine". Sourced from chapter 01's
  `estimated_reading_min: 24`, not invented.
- **Cmd-Shift-I ambiguity** now spelled out as holding Command and Shift down
  together while pressing I.
- **"hinting" as a verb** replaced with "with the accepted extensions
  `.vcf, .vcf.gz` shown as small text underneath".
- **Whether to also select the `.tbi`** answered with "Select only that file and
  leave the `.tbi` index alone".
- **"keyed against"** replaced with "whose positions were measured along".
- **Bundle-loaded appearance** now described as the sequence name and its ruler
  appearing and the sidebar spinner stopping.
- **"Only one operation can hold a bundle"** rewritten as "can work on a
  bundle", the alert named as **Operation in Progress**, and the reader told the
  import does not queue itself and must be started again.
- **Non-writable folder, no remedy** now gives the Finder Get Info route and
  names external drives and network shares as the commonest cause.
- **Provenance unglossed** now glossed inline as the record of where a result
  came from and how it was made.
- **Table drawer may not open** now says to drag the divider at the bottom edge
  of the viewport upward.
- **Expected number of tracks unstated** now "this bundle now carries three
  tracks".
- **Step 5 read as sequential** the Procedure lead-in now says step 5 is not the
  next thing to do after step 4, that it is a valid alternative path and not an
  error, and the step heading is retitled "The alternative path, with no bundle
  open" with a first sentence repeating the point.
- **Variant-only bundle's usefulness unclear** now says what you can do (read,
  sort, filter, export) and what you cannot (see rows against a sequence, since
  the sequence viewport stays empty).
- **Replaced bundle recoverable?** now "not recoverable from inside LGE and does
  not go to the Trash".
- **"large download" with no number** now given as scale rather than bytes, "the
  full GRCh38 contig list, all 195 sequences of the human primary assembly", so
  a whole human reference for a 500 kb example. The 195 figure is the fidelity
  review's own count at claim 33. No byte size was invented.
- **Quality 225 with no scale** now says a bcftools quality is a score rising
  with the caller's confidence that a variant is present at all, and that 225 is
  one example value rather than a maximum.
- **One-in-a-thousand source** now attributed to surveys of thousands of
  sequenced human genomes.
- **152 arithmetic hidden** now shows "77 deletions plus 75 insertions come to
  152".
- **`bcftools view -H` unexplained** now says it prints records without header
  lines so piping to `wc -l` counts one line per variant.
- **FASTA in `bundle create` never sourced** now says it sits in the same
  fixtures folder as the two downloads.
- **CLI type counts contradict earlier figures** the lead-in before the output
  block now warns the counts will differ and points at the paragraph that
  explains why.
- **Terminal assumed open** the section lead now names Terminal and where it
  lives, reusing chapter 02's exact framing.
- **Provenance sidecar unexplained** now "a small companion file recording how
  the output was made".
- **Forward pointer to the Source column** added at the end of the third Why you
  would do this paragraph.

## Style, consistency, and front matter

- **Front matter `glossary_refs`** extended with `bcf`, `heterozygous`,
  `ploidy`, and `variant-caller`, the four anchors the new glosses link. Every
  declared anchor is now linked from the body and every linked anchor is
  declared. Authorised by ruling 5.
- **Consistency sheet, scope control.** The Region / Genome description is
  worded to match chapter 02's Settings entry for the same control.
- **Consistency sheet, Presets.** The chips are described as sitting behind the
  **Presets** disclosure button, matching the CONSISTENCY.md Variant track
  storage paragraph's closing line and chapter 01 line 98.
- **Consistency sheet, Terminal.** The On the command line lead reuses chapter
  02's sentence naming Terminal and the Utilities folder.
- **Prose rules.** No em dashes, no semicolons, no in-sentence colons were
  introduced. The one colon added ends a lead-in immediately before the file-name
  code block. "Lungfish Genome Explorer" stays at first mention with "LGE"
  after. No banned word from `ai-tells-words.txt` appears in any added line
  (checked by grep over the diff's added lines).
- **Bullet cap.** The three explanations for an empty filtered view were written
  as prose rather than a list, keeping every H2 section inside the five-bullet
  and two-list caps.
- **Settings label.** `**Import profile.**` became `**Import profile:.**` to
  match the registry label `Import profile:`, following the house convention
  already used in `04-alignments/01`, `04-alignments/05`, and `03-reads/07`. The
  paragraph now carries the same explanatory sentence chapter `03-reads/07`
  uses, saying the label carries a trailing colon on screen.

## Note on parameters.yaml, for the project manager

`docs/user-manual/parameters.yaml` was modified in the working tree by another
role during this pass, between my baseline lint run and my first post-edit run.
The change adds the `Import profile:` setting and the `--format` `cli_only`
flag to `import.vcf`, which is exactly what the fidelity review recommended.
The baseline lint was green before that edit and the chapter's Settings section
went from covering the registry to being one setting short of it, which is what
produced the single warning I then fixed. I did not edit `parameters.yaml`, per
ruling 5. Flagging only so the sequencing is on the record.

## Left unchanged, deliberately

- **Section order, and both Settings paragraphs.** Untouched as structure, per
  ruling 5. Both settings keep their bold labels and the fixed three-sentence
  shape. The `--format` entry is an addition required by ruling 1 rather than a
  removal or a reordering.
- **The fixed Before you start opening sentences.** Reader row "Give one route
  only" asks to cut the three ways of making a project down to one. Declined.
  CONSISTENCY.md fixes both opening sentences verbatim for every procedure
  chapter, and changing them here would desynchronise this chapter from the rest
  of the manual. **For the project manager to rule on** if the reader complaint
  is to be honoured manual-wide.
- **`prereqs` naming of chapter 02.** One reader could not tell whether
  "Reading the Variants Table" in the body and
  `05-variants/02-reading-the-variant-browser` in the front matter were the same
  chapter. The body already uses the chapter's real title consistently, and the
  front-matter value is a `chapter_id` that must match the file location, so no
  change was made. The mismatch is between a file name and a title, which is
  metadata rather than prose.
- **The reference-download byte size.** Two readers asked for an approximate
  size for the background NCBI fetch in step 5. I gave the scale in sequences
  (195 contigs, a whole human reference) rather than a number of gigabytes,
  because no source in the campaign's ground-truth order states the download
  size and the prose rules forbid an unsourced figure. **For the project manager
  to rule on** whether Phase 5 should measure it in the app.
- **The `.bcf` conversion command.** `bcftools view -O v` is named without a
  worked invocation, since a full conversion example belongs to a bcftools
  chapter rather than this one.
- **Defect 2, the orphaned `importVCFToBundle` action.** Still not documented as
  an entry point, matching the author's decision and the fidelity review's
  agreement that it is unreachable.
- **Defect 3, the `lowMemory` tag mismatch.** Not surfaced to the reader. The
  chapter documents the three values the picker offers, which the fidelity
  review calls the right call for the reader.
- **Other chapters, `GLOSSARY.md`, `parameters.yaml`.** Untouched, per ruling 5.

## Lint

    LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
      docs/user-manual/chapters/05-variants/06-importing-existing-vcfs.md

Verbatim output:

    /Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/05-variants/06-importing-existing-vcfs.md: no issues found

## Status

brand_reviewed: true
