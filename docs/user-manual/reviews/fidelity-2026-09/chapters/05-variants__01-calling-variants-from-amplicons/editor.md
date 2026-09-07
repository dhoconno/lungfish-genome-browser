# Editor pass: 05-variants/01-calling-variants-from-amplicons.md

Date: 2026-09-07. Role: brand-copy-editor.
Chapter: `docs/user-manual/chapters/05-variants/01-calling-variants-from-amplicons.md`
Inputs: `fidelity.md` (89 true, 3 false, 1 unverifiable), `readers.md` (30 rows,
15 hit by three or more readers), `author.md`, `CONSISTENCY.md`, `STYLE.md`,
and the project manager's five binding rulings.

Section order unchanged. All ten Settings paragraphs kept, in place, with their
bold labels verbatim including `**This BAM has already been primer-trimmed for
iVar..**`. No other chapter, `GLOSSARY.md`, `parameters.yaml`, or `mkdocs.yml`
was touched. `glossary_refs` was extended, as ruling 4 permits, and
`brand_reviewed` flipped to `true`.

## Changes from the fidelity review and the rulings

**Fidelity row 17, false (ruling 1a). Step 1.** "The dialog that opens is
identical, except that arriving from a track preselects that track." became
"The dialog that opens is identical either way. Neither route preselects the
track you arrived from, because the dialog always opens on the first eligible
alignment track in the bundle, so check the Alignment Track menu before you
run." This now agrees with the Alignment Track settings paragraph, which the
review confirmed was the correct half of the contradiction.

**Fidelity row 40, false (ruling 1b). Step 6.** The "two rules" sentence became
two sentences naming all three tests in the order `IVarCodonMerger.mergeRuleCheck`
applies them: every frequency above Consensus allele frequency, or every
frequency between 0.40 and 0.60 inclusive, or the widest neighbouring gap below
Merge AF distance. The paragraph says plainly that the middle test is fixed in
the code, answers to no setting, and fires before the distance test.

**Fidelity row 51 (ruling 1b, second half). Settings, Merge AF distance.** The
worked example changed from 0.40 and 0.55, which merges by the fixed band rather
than by this setting, to 0.30 and 0.50, which merges by distance alone, with
0.30 and 0.90 as the non-merging pair. A following clause names 0.40 and 0.55
explicitly as the case that merges before this test is reached. The paragraph's
"first of the two rules" and "second merging rule" framings became "first of the
three tests" and "third and last test".

**Fidelity row 76, false (ruling 1c). What good looks like.** The provenance
sentence now says the runs recorded bcftools 1.24, that the LoFreq run recorded
no version because the binary rejects `--version` and its version field holds
the tool's own error message, and that the 2.1.5 quoted here is measured
separately rather than recorded.

**Fidelity row 8, unverifiable (ruling 2). Before you start.** "an alignment
track named 'minimap2 Mapping'" became "an alignment track whose default name
that chapter gives as 'minimap2 Mapping'", with a following sentence telling the
reader to use whatever name their own sidebar shows. The chapter no longer
asserts the name on its own authority.

**Fidelity row 65 (ruling 3). Reading the results.** The genotype sentence now
accounts for the 18 `1/2` rows and states that the three counts reach 1,056.

**Fidelity row 58 (ruling 3).** Already "row for row" in the draft. Verified and
left as written. No "byte for byte" claim exists anywhere in the chapter.

**Fidelity row 10 (ruling 3). Before you start.** "Required Setup pack" kept as
the manual's name, now linked to its glossary entry, with a sentence saying the
Plugin Manager lists it under the display name Third-Party Tools. The disabled
badge is quoted as the app draws it, "Requires Third-Party Tools Pack", and the
LoFreq badge as "Requires Variant Calling Pack". Both strings verified against
`BAMVariantCallingCatalog.swift:99` and `PluginPack.swift:442`/`:566`.

**Fidelity row 70 note. Reading the results.** "three files sharing one name"
became "three data files sharing one name, beside a provenance sidecar carrying
the same stem".

**Fidelity row 33 note. Step 5.** The Source column "names the file each row
came from" became "names the track each row came from", matching the manifest
display name it actually renders and the settings paragraph.

## Changes from the reader synthesis

Every one of the fifteen consensus rows was addressed, plus eight of the
remaining rows whose fix was a sentence or two.

Consensus rows (three or more readers):

**Genotype model.** Glossed at first use as the list of allele combinations a
sample could carry, which the tool scores against the pileup.

**Diploid.** "a fixed small number of genome copies" became "[diploid], meaning
it carries two copies of every chromosome, as a human does", linked to the
ploidy entry.

**SQLite.** Glossed inline in step 3 as a small local database held in a single
file.

**Shotgun.** Glossed in step 6 against amplicon, reads from randomly broken DNA
rather than targeted PCR products, so no primer sits on them to clip. Linked to
the existing `shotgun` entry.

**PL and AD.** All three FORMAT codes are now named where the column first
appears, with `AD` linked to the existing allele-depth entry.

**Quality score.** The bare "cannot be compared" sentence was replaced with what
`QUAL` measures, that larger means more confident, that both example values read
as confident, and that a `QUAL` is comparable only against other rows in the
same file.

**Determinism.** Reading the results now states that the counts are exact rather
than approximate, that neither caller samples reads at random, and that a
disagreeing run means an input differs.

**hap.py.** Now stated to live outside LGE, to be neither shipped nor installed
by it, and that full accuracy assessment is out of scope for this manual with
nothing later depending on it.

**Track id.** The storage paragraph names the `vc-` stem as the track id, says
it is not shown in the window, and points at the `variants/` folder. The command
block gained an `ls "$BUNDLE"/variants/` step with a comment before the counting
command that consumes the id.

**HG002 as a person.** Why you would do this now opens by saying HG002 is a real
person, a consenting research participant whose DNA is distributed as a cell
line, before the identifier is used for anything.

**Analysis-ready.** The Alignment Track paragraph now defines eligibility from
`BAMVariantCallingEligibility.eligibleAlignmentTracks`, BAM format with both the
BAM and its index present, and names what that disqualifies.

**Where to check depth.** The Minimum Depth paragraph points at the coverage
track's right-hand max-and-mean label in the viewport and at the Mean Depth
column of the mapping run's contig table. Both surfaces verified in source
(`ReadTrackRenderer.swift:490`, `MappingContigTableView.swift:36`).

**Mapping chapter route.** Before you start now names **File > Import Center...**
and **Tools > Mapping > minimap2...** while still deferring the detail. No time
estimate was added, per ruling 5 on unsourced durations.

**Plugin pack install.** Now states that installing downloads the tools from the
internet into a managed environment, so the machine must be online, and that the
pack's row reports progress and then shows the pack as installed. No duration
claim.

**Table drawer and viewport.** Both glossed at first use in step 5, with the
table drawer linked to its glossary entry.

Non-consensus rows also fixed:

**"So what should you do with this?"** (rows 2, 3, 4). The rhetorical question
became "The rule to carry away is short."

**"piped into"** (rows 2, 3, 4). Glossed as the output of the first tool fed
straight into the second without ever being written to disk.

**Error model** (rows 2, 3, 4). Glossed as an estimate of how often the
instrument misreads a base.

**A sample whose allele fractions can be anything** (rows 1, 2, 3). Given two
concrete examples, a mixed infection and a tumour biopsy.

**No way to sort the seven callers** (rows 1, 2, 4). A closing sentence in the
first paragraph says the next two paragraphs explain how to choose.

**1,053 versus 1,056** (rows 1, 3, 4). What good looks like now explains that a
few positions carry more than one row, once per alternate allele.

**Unlabeled code block** (rows 1, 3, 4). A `#CHROM` header line was added above
the two data lines, and the prose now says LoFreq's line stops at `INFO` because
it writes no FORMAT or sample column.

**Provenance** (rows 1, 2, 4). Glossed inline in step 2 as the saved record of
how the run was done, with where to read it.

**Filter chips** (rows 2, 3, 4). Glossed as a small labelled button you click to
switch one filter on or off.

**Kilobases** (rows 1, 2, 4). Spelled out at first use, and the later
"half-megabase" was changed to "500 kilobases" so the unit is consistent.

**Genome in a Bottle** (rows 1, 2). Given one clause naming it a public
standards project run out of the United States National Institute of Standards
and Technology.

**Orthogonal** (rows 1, 3). The quoted app string is untouched. A following
sentence glosses orthogonal as independent, a second opinion arrived at by a
different route.

**Why codon merging matters** (rows 1, 4). Step 6 now says the merged row names
the one amino acid the pair actually produces, where two rows would each name a
change that never happened alone.

**indelqual** (rows 1, 3). Now says it writes per-base quality scores for
insertions and deletions into the copied BAM, and that it adds a second pass
over the whole alignment. No wall-clock claim.

**Lopsided amplicon libraries** (rows 1, 4). Now says every read in an amplicon
starts at the same primer and so lands on whichever strand that primer sits on.

## Front matter

`glossary_refs` gained `allele-depth`, `codon`, `required-setup-pack`,
`shotgun`, and `table-drawer` to match the five new body links. All 34 anchors
resolve in `GLOSSARY.md`. `brand_reviewed` flipped from `false` to `true`.
`lead_approved` untouched.

## Left unchanged, deliberately

**Fidelity row 12, the ellipsis.** The chapter writes `Plugin Manager...` and
`Call Variants...` with three ASCII periods where the app draws U+2026. The
review classes this as cosmetic and routes it to the consistency sheet rather
than to the chapter, and CONSISTENCY.md's menu-path rule spells menu paths with
three periods throughout the manual. Changing it here alone would break house
consistency. For the project manager to rule on manual-wide, not here.

**Reader row: a use-when table of all seven callers.** The chapter now signposts
that the next two paragraphs explain the choice, which was the row's alternative
suggestion. A seven-row table would exceed the five-item cap in spirit and would
duplicate the Nanopore chapter's own scope. Left as prose.

**Reader rows asking for durations** (mapping chapter length, plugin install
time). Ruling 5 forbids unsourced durations and no source exists for either. The
adjacent facts each row wanted, the menu command and what a finished install
looks like, were supplied instead. Flagging in case the project manager wants
measured figures gathered.

**`glossary_refs` entries `bcftools`, `lofreq`, `snv`.** Declared but not linked
from the body. The fidelity review calls this harmless since the chapter names
all three tools in prose, and removing them would narrow the chapter's index
entry. Kept.

**The three shot markers and their captions.** Unchanged. The author's report
records both dialog shots as un-captured, which is a screenshot-scout matter,
not an editing one.

**Both app defects (silent thresholds, the PASS chip emptying the table).**
Documented plainly in the chapter as behaviour, as the author intended and the
fidelity review confirmed. Not softened.

## Lint

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/05-variants/01-calling-variants-from-amplicons.md
```

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/05-variants/01-calling-variants-from-amplicons.md: no issues found
```

Green on the first run after the edits. No rerun was needed.

## Status

brand_reviewed: true
