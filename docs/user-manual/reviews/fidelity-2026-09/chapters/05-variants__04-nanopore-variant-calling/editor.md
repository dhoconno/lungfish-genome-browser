# Editor pass, 05-variants/04-nanopore-variant-calling

Date: 2026-09-07. Role: brand-copy-editor. Inputs were `fidelity.md`
(74 true, 2 false, 4 unverifiable), `readers.md` (77 rows, 25 hit by three
or more readers), `author.md`, `CONSISTENCY.md`, and `STYLE.md`, plus the
project manager's six binding rulings.

Section order is unchanged. All seven Settings paragraphs remain, in the
same order, with their bold labels verbatim. No other chapter, `GLOSSARY.md`,
or `parameters.yaml` was touched.

## Changes from the fidelity review

- **Fidelity row 71 (false), ruling 1. Step 3.** Removed "and arriving that
  way preselects the track you clicked." Replaced with the review's own
  correction, that neither route preselects a track and both open on the
  first eligible one, so the reader should check the Alignment Track menu
  whichever way they arrived. This now agrees with the Alignment Track
  Settings paragraph, which was the accurate one.
- **Fidelity row 48 (false), ruling 1. Reading the results.** Deleted
  "against the 20 to 27 the confident rows carry". The 9028 sentence now
  ends on the quality itself. A following paragraph gives the real
  distribution, that the 27 PASS rows run from 2.58 to 27.69, that only the
  strongest ten reach 21 or above, and that position 14229, one of the
  listed PASS substitutions, carries 6.04. Verified directly against
  `clair3-nospace/merge_output.vcf.gz` in the author's scratch, which also
  let me state the PASS/LowQual boundary as measured, between 1.78 and
  2.58, rather than the "about 2" I first wrote.
- **Fidelity note on row 50, ruling 2. Reading the results.** The Phred 7.9
  figure is now named as the error-probability average, the same average the
  FASTQ viewport's Mean Q card shows, against an arithmetic mean of 20.3 on
  the same reads, with the note that the two are not comparable. This is
  CONSISTENCY.md's "Mean quality has two definitions" rule.
- **Fidelity note on the Clair3 error text, ruling 2. What good looks like.**
  The `pypy not found` quotation is now attributed to what this manual's own
  test machine produced, with the note that the wording can differ elsewhere
  because what the run finds depends on which Python is installed there.
- **Fidelity U1 and U2 (unverifiable), ruling 3.** Dropped the instruction to
  run `medaka tools list_models`, which could not be exercised because no
  Medaka run completes. Replaced with Oxford Nanopore's published model list
  in Medaka's own documentation. `r941_prom_sup_variant_g507` is kept but
  reframed from a tested recommendation to the model whose name matches the
  fixture's own instrument and chemistry, with the name decoded (`r941`,
  `prom`) so the reader can see why.
- **Fidelity U3 (unverifiable), ruling 3.** The "about half the reads" claim
  about untrimmed primer bases is kept but is now stated as a consequence of
  overlapping amplicon design rather than as a measured figure, which also
  answers a reader row asking why the effect is half rather than all.
- **Fidelity U4 (unverifiable), ruling 3.** The diagnosis, forensics, and
  population-history sentence is kept as domain background, which the review
  said nothing in the app can or need settle.

## Changes from the reader report

Every row hit by three or more readers is addressed. Rows hit by one or two
readers are addressed where the fix was a sentence or two.

### Consensus rows (three or more readers)

- LoFreq and iVar now carry glossary links and are named as the short-read
  callers `01-calling-variants-from-amplicons.md` covers.
- "Fixture" glossed at first use as the practice dataset that ships with the
  manual.
- Both imports now give the menu path, tab, and card, verified against
  `03-reads/01-importing-fastq.md` and `02-sequences/01-importing-and-viewing.md`
  and linked to both.
- Docker glossed in a clause and stated plainly not to matter here.
- Reads and alignment records are now distinguished before the counts, with
  a record glossed as one placement of one read.
- The shared model field gets a concrete two-step walkthrough and states the
  consequence, that Run stays enabled and Clair3 fails on a Medaka name.
- PromethION named as an instrument model and R9.4.1 as a pore chemistry
  version, both tied to the model string.
- The terminal-only route to a model name is gone (see U1/U2 above).
- `samtools fastq -F 2304` is now explained in plain words first, with the
  number given afterwards as how samtools is told which records to drop.
- The Clair3 Model paragraph gives the reason before the flag name, so
  `--medaka-model` no longer reads as a typo. The flag sentence keeps
  CONSISTENCY.md's final-short-sentence shape.
- A table now separates the counts that cover all 44 rows from those that
  cover only the 27 PASS rows.
- The Phred scale is explained inline, logarithmic with ten points per
  tenfold change, before any Phred number is used, and 4.38 is translated as
  roughly one chance in three.
- That same explanation moves the plain-English translation to the first use
  of a Phred number, which is where the readers asked for it.
- The `<track-id>` placeholder is gone. The block now lists the `variants/`
  folder and reads the filename off it, because the stored basename comes
  from the track identifier (`VariantAttachmentPathComponent.sanitizedTrackBasename`)
  and I could not verify what a given display name becomes.
- The coverage arithmetic is shown once, using the fixture README's own
  950 reads and 4,348,051 bases over 16,569 positions.
- The reference sentence is turned around to say the one person the
  reference came from carried the uncommon base.
- "Sliced" replaced with the file being filtered to keep only reads that map
  to the mitochondrion.
- A closing paragraph in "What it is" states up front that the procedure
  cannot be completed on this version and what the reader still gets.
- minimap2 named as the aligner at the menu item, with the `-x map-ont`
  option described as applied for the reader with nothing to type.
- The circular wrap is explained as the circle being written down as a
  straight line, splitting a read that crosses position 16,569.
- The four nanopore primer schemes are now one flat list in their own
  sentence.
- "Provenance" glossed as LGE's written record of how a file was made, with
  "dropped" replaced by a statement that nothing is lost and the run does
  not fail.
- "Analysis-ready" glossed as sorted with an index, with what disqualifies a
  track, and the reader told to check the menu's own label.
- PhyloTree named as where the near-universal and haplogroup positions are
  published.
- Running Clair3 outside LGE is now stated to need the command line, with
  the invocation given in the CLI section and a note that a reader who has
  never opened a terminal will want a colleague who has.

### Rows hit by one or two readers, fixed

Protein pore described as a channel a few nanometres wide in a membrane. A
read glossed as the letter string for one DNA molecule. Oxford Nanopore
introduced as a company making sequencing machines. Neural network explained
as a trained program that repeats the same mistake in the same situation.
"The pore can tell which base but not how many" split out explicitly. Pore
chemistry glossed with R9.4.1 and R10.4.1 named. Per-base quality score
glossed at its first use. "Ships in" replaced with "included in". The plugin
pack named as something the reader installs. Model glossed as a file of
learned error patterns. Path glossed as the text address of a folder. rCRS
introduced at first mention of the full name. Genome in a Bottle explained as
a benchmarking reference sample set. "The smallest human genome there is"
replaced by naming the mitochondrial genome directly. Library glossed. The
control region explained. Bundle glossed at first use. Preset explained at
its earlier mention rather than only in Step 1. The read-class error message
followed immediately by the fix in plain words. Shotgun glossed against
amplicon. "Files a record beside" replaced with writing a small note file.
The five non-ONT callers pointed back to their own chapter. The two columns
named as the tool list and the settings pane. "Normalised" glossed alongside
the other three verbs. The supplementary-record difference between the two
callers given a verdict, that it matters only at the wrap point. Manifest
glossed as the bundle's own list of its files. The inert thresholds explained
once in the Settings lead paragraph. `1/1` and `0/1` notation glossed. What
to do with a LowQual row stated. An assembled example command added for
Extra arguments. "Pins" replaced with "installs those exact versions". The
BAM header described as a block of text at the top of the file. The header
check explained as comparing header information with what the reader typed.
The pypy clause shortened to "Clair3 cannot find the Python it needs" plus a
statement that there is nothing the reader can do. "Builds `medaka variant`"
rewritten as asking for a subcommand the tool no longer has. "The bundle
already owns" replaced with "already inside the bundle". The acceptable row
count given an upper edge, roughly ten to sixty PASS rows. The "optional"
framing of the CLI section corrected, since the workaround lives there. A
way to list installed Clair3 models added. The statement that no route inside
LGE satisfies the header requirement made explicit. ONT expanded at first
use.

## Style and consistency changes

- Front matter `glossary_refs` regenerated from the anchors the body
  actually links, per ruling 5. Nine stale entries dropped
  (`alignment-track`, `bam`, `duplex-read`, `read-group`, `ref-alt`,
  `reference-bundle`, `simplex-read`, `snv`, `vcf`) and ten added for the
  new inline glosses (`amplicon`, `bundle`, `coverage`, `docker`, `ivar`,
  `library-prep`, `lofreq`, `mapping-preset`, `read`, `shotgun`). All
  resolve in `GLOSSARY.md`.
- Import Center surfaces written to CONSISTENCY.md's naming, with the tab
  and card names taken from the committed chapters rather than invented.
- "Lungfish Genome Explorer" appears once, at first mention in the body, and
  "LGE" thereafter. No em dashes, no semicolons, no colons inside a
  sentence. No unsourced durations were added.
- Every number added to the chapter is sourced. The coverage arithmetic and
  the read total come from the fixture README. The quality distribution, the
  PASS/LowQual boundary, and the 14229 figure were recomputed from
  `merge_output.vcf.gz`. The error probabilities for Phred 4.38 and 7.9 were
  computed rather than estimated.

## Deliberately left unchanged

- **Section order, the seven Settings paragraphs, and their bold labels.**
  Ruling 5.
- **The three `<!-- SHOT -->` markers and their front matter captions.**
  Still accurate after the edits, and shots are not this role's to change.
- **`estimated_reading_min: 22`.** The chapter grew by roughly a fifth in
  glosses, so 22 may now be low, but changing it is a Documentation Lead
  call and the figure is not something I can source.
- **The plain statement that neither caller completes through LGE.** Ruling
  4. It is stated three times, in "What it is", "Before you start", and
  "What good looks like", and the provenance of the Clair3 numbers is given
  in "Reading the results" as well as in the CLI section.

## For the project manager to rule on

1. **Reader row asking for the haplogroup to be named.** I named PhyloTree
   as the published source rather than naming a haplogroup for HG002.
   Fidelity row 45 explicitly praised the chapter for making no haplogroup
   claim, calling that "the safe form", so naming one would undo a verified
   strength. Flagging in case the reader row was meant to override that.
2. **The stored filename of a variant track.** The CLI block now tells the
   reader to list `variants/` rather than naming a file, because the
   basename comes from the internal track identifier and I could not
   establish what a display name becomes without running a call, which no
   version completes. A future pass with a working caller could give the
   exact filename.
3. **`estimated_reading_min`.** See above.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/05-variants/04-nanopore-variant-calling.md
```

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/05-variants/04-nanopore-variant-calling.md: no issues found
```

## Status

brand_reviewed: true
