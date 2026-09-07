# Editor pass, appendices/primer-schemes

Chapter: `docs/user-manual/chapters/appendices/primer-schemes.md`
Roster row 64. Edited 2026-09-07.
Editor: brand-copy-editor.

## The false claim

One false claim, in BED expectations. The old sentence said
`nCoV-2019_72_LEFT-1` folds onto `nCoV-2019_72_LEFT`. It does not. The two
suffix rules run in a fixed order, `_LEFT` or `_RIGHT` first and the dash-digit
tag second, so the tag has to sit before the suffix.

Replaced with the reviewer's wording, taking the example from the QIAseq
scheme, which is a real shipped pair rather than an invented one.

> It also drops a trailing dash followed by up to three digits once that
> suffix has been removed, so a spare-primer name such as `QIAseq_221-2_LEFT`
> folds onto the same amplicon as `QIAseq_221_LEFT` rather than counting
> twice. The variant tag has to sit before the `_LEFT` or `_RIGHT`, which is
> where the shipped schemes put it. A name spelled the other way round, as
> `QIAseq_221_LEFT-1`, counts as its own amplicon and inflates the amplicon
> count with nothing said.

The following sentence, about non-conforming names giving an amplicon count
equal to the primer count, was kept as the reviewer directed and extended with
the FWD/REV case and the rename fix.

Also corrected, per the reviewer's note on the author's defect 5, the
created-and-imported reasoning. The chapter now says the importer takes one
clock reading when the run starts and another when it writes the manifest, and
both land in the same second on a fresh import. It no longer says one instant.

## Project manager rulings

**(a) The window route performable without a terminal.** The Procedure now
says where the contig name comes from. Select the reference bundle in the
sidebar and read the sequence name it shows, which the Inspector repeats for
the selected sequence, with the alignment's own header named as the second
route and chapter 04-03 cited for it. A filled-in example set of all four
Identity values is given. The Terminal-and-install pointer moved into the
command-line section and links `cli-reference.md`, which covers opening
Terminal and putting `lungfish-cli` on the machine.

**(b) The reference-mismatch trap.** Checked
`docs/user-manual/chapters/04-alignments/03-primer-trimming.md` line 179,
which names `--target-reference` among two flags that "have no counterpart in
the dialog". The Primer Trim dialog therefore has no target-reference control.
Said plainly inside the Procedure, in the window section rather than the
optional one.

> The window has no control for the reference-mismatch trap described above.
> When your alignment's contig name matches neither the canonical accession
> nor any equivalent one, the only override is `lungfish-cli bam primer-trim
> --target-reference` on the command line.

The paragraph closes with the window's own remedy, typing the alignment's
contig name into the canonical accession field at import, which avoids the
mismatch rather than overriding it. The BED expectations trap paragraph no
longer names the flag, so the fix is stated once, where the reader is standing.

**(c) Terminal work moved under the command line.** New subheading
**Verifying a bundle from the terminal** inside On the command line. It holds
the checksum comparison and the BED comparison, both of which needed the
terminal and neither of which had a method. The checksum comparison got its
method rather than being dropped. Read the `sha256` for `primers.bed` out of
`provenance/primers.bed.lungfish-provenance.json` in each copy and compare, or
run `shasum -a 256`. The BED comparison is `diff`. The reproducibility section
now points at that subheading instead of telling the reader to compare by
hand. The Procedure keeps only what the window can do.

**(d) One panel name.** MinimalPanel in the duplicate-import error was the
mismatch. The rerun error now names DemoPanel, matching the eight-flag example
that precedes it. MinimalPanel survives only as the second, defaults-only
example, which is introduced as a second import rather than a third.

**(e) The worked subtraction.** The zero-based half-open definition is now
split into its two halves, each glossed separately, and the four-row BED
sample follows. Directly beside it, the subtraction is worked. "The first row
runs from 30 to 54, so the primer covers 54 minus 30, which is 24 bases.
Counting the two endpoints inclusively would give 25, and that off-by-one is
what the half-open convention removes."

**(f) Hidden paths.** The bundle-is-a-folder sentence now carries the clause.
Right-click the bundle in Finder and choose **Show Package Contents**. That
clause is reused where the chapter says how to reach `manifest.json` for hand
editing. No dot-prefixed path is named in this chapter, so the Cmd-Shift-period
half of the ruling had nothing to attach to, and the Finder route that does
apply here is the package-contents one.

**(g) Glossing.** Glossed at first use, one clause each: PCR, shearing,
canonical, equivalent, trimming, coverage, boolean, argv, checksum, snake_case,
kilobase, NCBI, exit status, tiling, spike-in, picker, comment row, stem,
durable replay command, runtime identity, version control, committing, UTC
timestamp, the JSON punctuation, and the three interchangeable FASTA
extensions. iVar is named at the first mention of a trimming program rather
than eight sections later.

**(h) Viral by design.** The sentence stays, once, in What it is. Extended by
half a clause saying LGE ships no non-viral scheme, so a reader who wants one
builds it, which answers the reader who was reassured and then found no
non-viral example.

**(i) Shot markers.** Three `<!-- SHOT: ... -->` markers, matched to the three
`shots` entries, in the same order. Unchanged.

## Reader rows

**Consensus rows: 32 of 32 applied.**

Every row in the Consensus section is in the chapter. Show Package Contents,
the source path marked internal, canonical glossed at its own first use, the
platform-read-length reasoning, the layout comments described in words instead
of by flag name, all three required-file messages quoted with the counting
language dropped, snake_case glossed, the silent fallback's cost stated with
the low trim rate named as the only sign, how to confirm tabs, the three-digit
rule with a failing example and the four-digit case, the window's lack of an
override stated plainly, the safe character set for Name, where to find the
contig name, the checksum gloss moved to its first use with NCBI glossed,
argv and durable replay command glossed, the runtime identity's two fields
named, the checksum comparison given a method, the reproducibility section
given an opt-out line, who the appendix is for and what to skip, the
roughly-twice rule moved above the table, the table reordered to picker order,
coverage and drifted glossed, the BED section moved above Manifest fields,
boolean glossed, the subtraction worked beside the sample, the Inspector named
as where the counts are read with the rename fix given, iVar and the
Operations panel glossed with the high-nineties figure, the project chapter
linked, the CLI chapter linked, exit 0 glossed, and the panel names reconciled.

**Other merged rows: 55 applied, 6 skipped.**

Applied among the non-consensus rows: PCR named at the copying reaction, the
Viral Recon gloss, the long drift-apart sentence split in two and reworded to
"cannot disagree", the question turned into a statement, the Primer Trim
dialog named as the menu's home, picker glossed, spike-in glossed, kilobase
glossed, the kit-box rule moved ahead of the platform comparison, ARTIC V3's
ratio explained with a stated ten-percent boundary, the shipped-bundle
sentence moved after Bundle layout, where the load error appears, hand
assembly stated and discouraged, schema_version reworded without the word
schema, why the two timestamps match, one consistent name for the part that
reads a bundle, the JSON punctuation labelled, tiling defined before use,
column 5 tied to the vendor's numbering, amplicon competition explained,
"removing the ending" for stripping, other vendor naming conventions, "the
sign" for "the tell", the window route stated complete, the missing fields
called labels only, the two limits moved above the fill-in steps, "inspecting
is read-only", the version-control terms glossed, the comparison tool named,
"Go to" for "Return to", the three FASTA extensions called one format, the
empty equivalent field called normal, the route to `manifest.json` inside the
bundle, the backslash continuations explained, the prereq chapters named in
prose, the two CLI-only things named, where a primer FASTA comes from, the
BED named rather than called "the same", the key order called meaningless, the
window-import provenance case shown, stem glossed, "the folder the terminal is
currently using", the shortened command noted, the reassurance led with in the
regenerating paragraph, "one catch" for "wrinkle", "review" for "trust", the
UTC gloss, and the prefilled example set.

Skipped, with reasons:

| Row | Reason |
|---|---|
| Show one non-viral example, or say plainly none is shipped | Half applied. The "none is shipped" half is in. Adding a worked non-viral example would be new run-verified content the reviewer never checked, which is author work rather than editing. |
| Name a rough healthy trim-rate range | Applied as "the high nineties" with the reader sent to 04-03. The numeric threshold itself belongs to 04-03, which measured it, and CONSISTENCY keeps the trim-rate figure in one chapter. |
| Move the BED section before Manifest fields, or gloss here | Took the move, since the reader team offered it first. Manifest fields now follows BED expectations, so no gloss duplication was needed. |
| Quote all four load-error messages | Three of four quoted. The fourth, the parse failure, has no fixed string to quote, since it carries the decoder's own message. Described instead. |
| "Say how to reach the file inside the bundle, or say to re-import" | Both given, with re-import named as the route to prefer. Not a skip so much as a both. |
| Show the window-import provenance file in full | Described its two differences from the command-line block rather than quoting a second nine-line block. No one has run a window import, so a quoted block would be invented. |

Two further rows needed no change and are recorded as such by their own
readers, the "Both routes run the same code" line read positively and the
headless opt-out sentence read positively.

## Glossary changes

Eight terms added to `docs/user-manual/GLOSSARY.md`, each alphabetically
placed and in the existing one-sentence-plus-See-also shape.

- **argv** `{#argv}`, before Assembly bundle.
- **Boolean** `{#boolean}`, before Bracken.
- **Canonical accession** `{#canonical-accession}`, before Capped database.
- **Equivalent accession** `{#equivalent-accession}`, before Error correction.
- **Kilobase** `{#kilobase}`, before Kraken 2.
- **NCBI** `{#ncbi}`, before Negative control.
- **Shearing** `{#shearing}`, before Shell.
- **snake_case** `{#snake-case}`, before Snakemake.

`glossary_refs` now reads twenty-five terms and matches the body links exactly,
with no ref unlinked and no link unreffed. `accession` was dropped from the
list, since the body now links `canonical-accession` and
`equivalent-accession` at that spot instead. `coverage` and `exit-status` were
added, both newly linked. `GLOSSARY.md` lints clean, exit 0.

## Brand and style

No em dashes and no semicolons, confirmed by grep. No colon inside a sentence.
Every colon in the chapter ends a lead-in before a table, list, or code block.
No word from `ai-tells-words.txt` in any inflection, confirmed by grep against
the list. Long sentences split toward the twenty-word target, most visibly the
drift-apart sentence, the trap paragraph, and the shipped-scheme ratio
paragraph, each now two or three sentences. "Lungfish Genome Explorer" is
spelled out at first mention with "LGE" after, which needed one fix after the
iVar gloss moved the first mention earlier.

`brand_reviewed: false` and `lead_approved: false` are unchanged.

`estimated_reading_min` raised from 14 to 16, since the chapter grew by about
a third with the glosses and the new subsection.

## Lint

Final run, verbatim.

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/primer-schemes.md: no issues found
```

exit=0.

One intermediate failure, worth recording. The first run after the edits
reported `34:279-34:396 warning 'LGE' before the first 'Lungfish Genome
Explorer' in this chapter.` The iVar gloss had introduced LGE one paragraph
above the spelled-out first mention. Fixed by spelling the name out at the
gloss and shortening the later one. Not a linter defect.
