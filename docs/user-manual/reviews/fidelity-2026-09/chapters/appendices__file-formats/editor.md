# Editor record, appendices/file-formats.md

Campaign: 2026-09 fidelity pass. Roster row 61. Target build: Preview 2026.9.13.
Editor: brand-copy-editor. Date: 2026-09-07.

Inputs read in order: `author.md`, `fidelity.md` (78 claims, 4 false, 2
unverifiable, plus Notes for the editor), `readers.md` (138 merged rows, 47 in
Consensus), `CONSISTENCY.md`, and the committed `cli-reference.md` sections
"Before you type anything" and "How the syntax lines are written".

Fixture reads run to confirm quoted lines: `head -3` on
`HBB.lungfishref/annotations/imported_annotations.gff3` (the stitched GFF3
sample), `head -2` on `QIASeqDIRECT-SARS2.lungfishprimers/primers.bed` (the BED
row used in the coordinate example), and `ls` on the shipped primer schemes
folder (the eight scheme names).

## The four false claims

1. **Identifier-only formats undercounted.** "Three more formats" is now "Four
   more formats", naming EMBL, 2bit, and "the two index formats CSI (`.csi`)
   and tabix (`.tbi`), both described under the variant section below", in the
   reviewer's own wording. The paragraph also now states the practical effect
   (LGE can name the file type but cannot open it as a track), closing reader
   row 39.
2. **VCF version range.** "LGE reads VCF versions 4.0 through 4.4" is replaced
   with the reviewer's wording: LGE rejects a version 3 file, which has to be
   converted with an outside tool before import, and any 4.x version is
   accepted. The named tool is `bcftools convert` (reader row 110), and the
   next sentence points back at the `##fileformat` line as the place to check
   your own file (reader row 46).
3. **Three abridged layout blocks now say they are abridged.** The chr20
   `.lungfishref` lead-in says the provenance sidecars and the whole
   `provenance/` subtree are left out for room, and the block gains its second
   variant track (`vc-7ed9726c-de61-4735-80cf-0735eee621ec` with its `.tbi` and
   `.db`). The paragraph that follows was rewritten to make the naming point off
   two visible tracks, exactly as the reviewer predicted it would land better.
   The `.lungfishmsa` and `.lungfishtree` lead-ins say the bundle's own
   provenance sidecar and view-state file are left out.
4. **Checksum sentence.** Rewritten to the reviewer's wording. Every entry
   naming a file on disk carries `path`, `role`, `format`, `sha256`, and
   `sizeBytes`, with the exception stated plainly: a step that pipes its output
   straight into the next records that stream as an entry with a `path` such as
   `pipe:stdout:bcftools-mpileup` and no checksum or byte size, because no file
   was written. The unreadable "holds for both directions" phrasing is gone
   (Consensus row).

**GFF3 ellipsis.** The stitched sample is replaced with the real two feature
lines from `head -3`, cut in the middle with an explicit `...` where the
attribute column is elided, and the lead-in says so. `%3B` now genuinely appears
in the shown lines (reader row 96), and the `_lf_raw_genbank_location` value
shown is the plain unspliced `52070..53062`, with a sentence saying so rather
than pretending it demonstrates splicing (reader row 95).

**Write-flag paragraph kept**, as the reviewer directed, and strengthened rather
than trimmed. It now leads with "The read and write columns are easy to
misread" (reader row 87) and uses the table's own word "No" instead of "flag of
false" (reader row 59).

Also applied from the reviewer's optional notes: the category sentence now names
`index` among the categories (fixing the count against the chapter's own table,
closing reader row 88), the `pairingMode` gloss names the `ingestion` block that
holds it, the `steps` key list adds `toolName`, `toolVersion`, and `wallTime`,
the bcftools `MQ` header warning is named so a reader does not read it as a
failure, and the shortened `vc-6edd1356.vcf.gz` in the closing block is restored
to the full identifier (Consensus row). The GLOSSARY `csi` entry was widened to
"a BAM, a BCF, or a compressed VCF", the narrowness the reviewer flagged.

## Project manager rulings, each and where applied

**(a) BAM contradiction, reconciled where the table is introduced.** The
write-flag paragraph, which sits immediately above the table, now carries the
reconciliation in one place: "BAM is the clearest case. Its row says No because
no part of LGE writes a BAM by itself, and yet every alignment that reaches a
viewport is a sorted BAM produced by the mapping pipeline, because the pipeline
hands the writing to samtools. Read the write column as a statement about which
program holds the pen rather than about what you end up with." The alignment
section was rewritten from the reader's side ("What you always end up with,
whichever tool did the mapping, is a sorted, indexed BAM"), closing reader row
102 as well.

**(b) Commands are typed, and from where.** A new H2, "Before you type
anything", sits between "What it is" and "The format registry". It points at the
CLI Reference section of the same name for Terminal and the binary path ruling
rather than repeating either, names samtools and bcftools as separate programs
LGE installs for its own use, and states that every command block below is
preceded by a sentence naming its folder and that a window-only reader can skip
every code block. Every one of the eight command blocks in the chapter now
carries that folder sentence: `samtools faidx` (folder holding the FASTA), the
two samtools inspection commands (folder holding the project), `bcftools view`
(folder holding the project), `bundle info` (folder holding the project),
`fastq materialize` (folder holding the bundle), `zip -r` (folder holding the
bundle), and the four-line inspection block (folder holding the bundles).

**(c) Coordinates, one worked example at first mention.** The conversion is now
worked at the BED sample, its first mention, using the real fixture row
`MN908947.3 27 51`: add 1 to the BED start so 27 becomes 28, leave the end at
51, giving bases 28 through 51, and 51 minus 27 gives the length of 24 bases
directly. The paragraph after it says what to type when copying a coordinate
into LGE and points at the CLI Reference's "How the syntax lines are written"
for the per-command conventions rather than repeating them. The later mention in
the sharing section's `samtools faidx` region points back to this example.

**(d) Numbers with no scale.** Each got one clause of orientation from a
committed chapter where one exists, and a plain statement of "this fixture's
own" where none does.

- Mean quality 26.52 against the Phred 30 anchor: one sentence saying the figure
  averages error probabilities rather than scores, an average a handful of poor
  bases pulls down hard, with the reason it sits below the anchor and the
  statement that it is this fixture's own property and not a threshold. Points
  at `03-reads/03-quality-control.md`, which settles the two averages.
- QUAL 50 against 225.417: named as two different programs writing the same
  position, with "there is no pass mark on that column, so judge a QUAL against
  the other calls in the same file", pointing at
  `05-variants/02-reading-the-variant-browser.md`. Closes reader row 104 too.
- Mapped percentage: the 90,990 of 91,203 reading now gives 99.8% and the
  anchors from `04-alignments/01-mapping-reads-to-a-reference.md`, above 99% for
  human reads against the matching reference, under 50% meaning the wrong
  reference.
- GC content 0.444: named as the human mitochondrial fingerprint, matching what
  the assembly chapters report for the same molecule.
- Variable sites and parsimony-informative sites: stated plainly as properties
  of this particular set of five primate genomes, carrying no threshold, since
  the count depends entirely on how distant the aligned sequences are.
- The 512-megabase `.bai` limit: named as a property of the index format rather
  than something to judge data by, and noted as reaching no human chromosome.

No threshold was invented anywhere.

**(e) Newick unrootedness, beside the example.** The sentence sits directly under
the Newick block, before the reading of the nesting: "This tree is unrooted,
meaning it records which sequences group together but not which lineage came
first. Its own manifest records `isRooted` as false. So the order the names
appear in, on the page or in the description below, asserts nothing about
ancestry, and neither does sitting outside a bracket." The `isRooted` false
paragraph 130 lines later now expands rooted against unrooted and explains the
three internal nodes an unrooted five-tip tree gives (reader rows 74 and 126).
The tree itself is broken across five indented lines with a note that the file
holds it as one line (Consensus row), and the long 0.898 branch is explained
(Consensus row).

**(f) Materializing a virtual bundle.** The window route is named from the
committed reads chapters: any operation that needs the real reads materializes
them itself, rerunning the stored operation and clearing the file away
afterwards, with no menu item for it, pointing at
`03-reads/06-subsetting-and-extraction.md`. Doing it deliberately for a program
outside LGE is named as a command-line step.

**(g) Inspection commands, window equivalent and chapter.** The two samtools
commands name the Inspector's alignment summary and
`04-alignments/01-mapping-reads-to-a-reference.md`. The bcftools command names
the Variants tab of the table drawer and
`05-variants/02-reading-the-variant-browser.md`, glossing the table drawer as a
panel sliding up from the bottom of a reference bundle viewport (reader row 65).
`bundle info` names the Inspector. `fastq materialize` and `metadata
export-biosample` say plainly that the window has no equivalent. `samtools
faidx` says LGE writes the `.fai` on import so a reader never needs to make one.

**(h) Glosses at first use.** Every term the Consensus lists is glossed in one
clause at its first appearance: samtools, contig, sidecar (via the provenance
naming sentence), checksum, JSON and key, classifier, 12S, phase, N50, ONT, SRA,
ENA, CZ ID, OCI layout, stderr (given as "error logs", the readers' own
preferred fix), tarball, haplotype, plus byte offset, snake_case, camelCase,
fixture, tilde, pool, spliced feature, repeat masking, half-open, zero-based,
paired-end, PHA4GE, NCBI, assembler, trimming, materialize, Nextflow and engine,
graph as a connected sequence of steps, XLSX, projections, deduplicated, sorted,
the flagstat `+ 0` notation and its categories, the `*` idxstats row, DP,
bgzip's block-wise reading, MN908947.3 as the SARS-CoV-2 reference, HG002 as a
reference human sample, and Primary and Mitochondrial in the chromosome table.

**(i) `bundle export` defect paragraph and zip workaround kept**, since the CLI
Reference points at them. The defect notice was moved to the head of the
treatment per the Consensus row, with a skip signal for the reader who is not
moving bundles through container infrastructure, and the OCI explanation now
follows the notice rather than preceding it. The zip route now gives the Finder
step first (right-click, Compress) and explains what `-r` does.

## Rows applied and skipped

**All 47 Consensus rows applied.** Each is closed either by a chapter-wide fix
below or by an individual edit named above.

Of the 91 non-Consensus merged rows, **85 applied and 6 skipped**. Grouped by
the chapter-wide fixes that close many at once:

- The new "Before you type anything" section plus the per-block folder sentences
  and window-equivalent clauses close rows 7, 12, 23, 68, 73, 79, 86, 101, 107,
  109, 111, 132, and 141.
- The gloss-at-first-use sweep closes rows 11, 14, 15, 17, 18, 19, 20, 22, 24,
  25, 27, 35, 36, 37, 38, 40, 44, 45, 52, 53, 60, 62, 63, 64, 65, 67, 71, 74,
  81, 85, 92, 93, 94, 105, 112, 114, 116, 117, 119, 123, 124, 125, 127, 133,
  134, 135, and 139.
- The numeric-orientation sweep closes rows 8, 13, 48, and 104.
- The abridgement and honest-truncation sweep closes rows 41, 61, 103, 122, and
  140.
- The plain-statement rewrites, replacing jargon and negative framing with the
  practical rule, close rows 9, 10, 26, 28, 29, 30, 31, 32, 33, 34, 39, 42, 43,
  49, 50, 51, 54, 56, 57, 58, 59, 66, 69, 70, 72, 75, 76, 77, 78, 80, 82, 83,
  87, 88, 89, 90, 91, 95, 96, 97, 98, 100, 102, 106, 108, 110, 113, 118, 120,
  121, 128, 129, 131, 136, 137, 138, 142, 143, and 144.
- Row 84 is closed by a new "Finding a format by its extension" section before
  Next, mapping every extension in the chapter to its section.
- Row 55 is closed by dropping the `FormatRegistry+BuiltInDescriptors.swift`
  citation from the chapter body.

The six skips, each with its reason:

1. **Row 16, "say what to type when copying a coordinate into LGE."** Partly
   applied, not fully. The worked example and the "add 1 to the start" rule are
   in. The request for a second block showing the same bases in both conventions
   side by side was skipped, because ruling (c) asks for one worked example and
   a second block would restate it at the cost of the section's shape.
2. **Row 21's "say the bundle can give the two files back."** Skipped as
   written. CONSISTENCY.md's paired-end ruling forbids describing a bundle in
   terms of "the R1 and R2 files", so the chapter says the Pairing setting
   controls how files are read in rather than promising a two-file handback in
   those terms.
3. **Row 47's "annotate which name a given branch length sits after."** Partly
   applied. The tree is broken across indented lines, which is the first half of
   the fix and settles the legibility complaint. Per-branch annotation inside a
   `text` block was skipped, because it would require altering a quoted file's
   contents, which the chapter's own honesty convention forbids.
4. **Row 99, semicolons in code examples.** No fix needed, as the reader who
   filed it said. The distinction is confirmed rather than changed: prose
   carries no semicolons and the quoted GFF3 lines are file contents. The
   lead-in now says semicolons separate the attributes, which serves the same
   reader without treating it as an error.
5. **Row 115, "the identifier can be copied from the Finder rather than typed."**
   Applied once at the variant section's first mention of a long identifier
   rather than at every one of the six repetitions, because repeating it would
   crowd the reference-appendix shape the roster preserves for this chapter.
6. **Row 120, "cut the manifest key list down to the keys a reader would
   actually use."** Partly applied. The paragraph now leads with `genome` as the
   one worth reading and lists the other thirteen after it. Cutting the list
   entirely was skipped, because the fidelity reviewer verified all fourteen as
   the complete key set and dropping any would make the chapter less accurate as
   a reference.

## Glossary changes

Fourteen new entries added to `GLOSSARY.md` in alphabetical order in the existing
one-sentence-plus-"See also" shape: **Assembler**, **Byte offset**,
**camelCase**, **Fixture**, **Half-open**, **ONT**, **PHA4GE**, **Phase (in
GFF3)**, **Repeat masking**, **Spliced feature**, **Standard error**,
**Tarball**, **Variable site**, and **Zero-based**. Zero-based required a new
`## Z` section, which the file did not have. `snake_case` was found already
present and not duplicated. One existing entry was corrected as the fidelity
reviewer asked: **CSI** now reads "The alternative index format for a BAM, a
BCF, or a compressed VCF" rather than "The alternative BAM index format".

`glossary_refs` grew from 34 to 69 anchors. Every anchor was checked
mechanically against the `{#anchor}` set in `GLOSSARY.md` and all 69 resolve.

## Frontmatter

`brand_reviewed: false` and `lead_approved: false`, both left untouched as the
brief requires.

## Lint

Verbatim:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/file-formats.md: no issues found
```
