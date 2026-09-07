# Editor pass, 05-variants/05-consensus-and-lineage

Chapter: `docs/user-manual/chapters/05-variants/05-consensus-and-lineage.md`,
titled "Extracting a Consensus Sequence". Editor role, brand-copy-editor
persona, campaign rules 2026-09.

Inputs read in full: `fidelity.md` (66 true, 19 false, 2 unverifiable),
`readers.md` (68 rows, 22 hit by three or more readers), `author.md`,
`docs/user-manual/reviews/fidelity-2026-09/CONSISTENCY.md`,
`docs/user-manual/STYLE.md`, plus `GLOSSARY.md` anchor checks and the lint
rule set under `docs/user-manual/build/scripts/lint/rules/`.

## Changes by source

### Fidelity, false rows (19 of 19 fixed)

| Row | What changed |
|---|---|
| 4 | What it is. Deleted the sentence saying deletions appear as `*` and that runs of asterisks mark a missing stretch. Replaced with the true statement that positions the reads call deleted come back as `N`, so the output alphabet is `A`, `C`, `G`, `T`, and `N` only. |
| 16 | Procedure step 3 and the **Consensus scope** setting. Both said the run "refuses to start" or "stops with" the message. Both now say the button greys out with the line "Select a region in the viewer first" beside it, so the run never starts. |
| 22 | Front matter shot caption for `consensus-destination-dialog`. Rewritten from a Destination "menu open on Save to File..." to the four Destination choices all visible with `Save as Bundle` selected by default, in the source's own order. |
| 40 | Reading the results. 499,006 plain bases becomes 498,974, 724 `N` becomes 1,027, and the 271 asterisk count is deleted rather than corrected. |
| 41 | 0.145 percent becomes 0.205 percent, and "more than 99.8 percent" becomes "a little under 99.8 percent". |
| 42 | The whole "271 asterisks are positions the reads agree are deleted" sentence is gone. The review's suggested replacement is taken up, that a position the reads call deleted returns `N` like any other unresolved position, which is why an `N` count is not purely a coverage measure. |
| 43 | 608 differing positions becomes 337, and "counting the asterisks" is dropped. |
| 48 | Table baseline row, 724 / 0.145 percent becomes 1,027 / 0.205 percent. |
| 49 | Table depth-20 row, 5,339 / 1.068 percent becomes 5,646 / 1.129 percent. |
| 50 | Table Simple-mode row, 888 / 0.178 percent becomes 1,176 / 0.235 percent. |
| 51 | Table IUPAC row, 171 / 0.034 percent becomes 361 / 0.072 percent. |
| 52 | Table MAPQ-20 row, 800 / 0.160 percent becomes 1,107 / 0.221 percent. |
| 53 | 4,615 becomes 4,619, and "a sevenfold increase" becomes "a little over five times as much masking", with the ratio attached to the totals (5,646 against 1,027) rather than to the difference. That also settles reader row 27. |
| 54 | 164 more positions becomes 149. |
| 55 | 553 fewer becomes 666 fewer. |
| 56 | `R` 184 becomes `R` 182, the remaining four letters go from 178 to 176, and the run total of 549 is stated so the reader can check the sum. |
| 57 | "The three settings that move those numbers most" becomes "The settings that move those numbers most", since the table carries four changed settings plus a baseline. |
| 61 | The Operations-panel summary is no longer promised after the run the Procedure walks through. The paragraph now says a clipboard copy logs the summary block onto the Operations row, and that saving to a file or a bundle records the same settings in the provenance sidecar instead. The fifth check in What good looks like was rewritten to match. |
| 62 | The FASTA header no longer claims to carry the scope. It names the sample, the contig, and the word consensus, with a following sentence saying a selected-region consensus adds the coordinates and the word selected. |
| 66 | What good looks like, 0.145 percent becomes 0.205 percent. |
| 84 | Front matter `entry_points` rewritten to `"the Inspector's Consensus tab > Extract Consensus..."`, the form CONSISTENCY.md line 30 permits. |

Two further fidelity rows were taken up as optional improvements the review
offered.

- Row 37. **Consensus minimum MAPQ** now says the viewport's own
  alignment-confidence filter can raise this floor because the larger of the
  two settings wins.
- Row 64. The closing paragraph now says the bundle carries the same
  provenance record inside it, so saving to a file is not the only path that
  keeps one.

### Fidelity, unverifiable rows (2 of 2)

| Row | Disposition |
|---|---|
| 86 | Dropped. **Consensus minimum base quality** no longer asserts that `Bayesian` mode down-weights low-quality bases "rather than counting them equally", a claim about the samtools model the review could not settle. It now says only what the app does, that raising the floor sets a hard cutoff on top of whatever weighting the mode applies, so the two settings stack rather than cancel. That also answers reader row 57. |
| 87 | Hedged. **Hide high-gap sites** no longer names long-read insertion noise as the trigger, since the extraction request always omits insertions. It now says to turn it on when a noisy alignment is filling the consensus row with gap-heavy columns you do not believe, which keeps the setting's own vocabulary. That also answers reader row 28. |

### Rulings from the project manager

| Ruling | What changed |
|---|---|
| 1 | Every figure listed above comes from the review's recomputed four-stage chain. Where the review gave no replacement, the figure was dropped rather than guessed (the 271 asterisk count, the raw 608 difference count). |
| 2 | Procedure step 5 describes the Destination control as a column of four choices all visible at once with `Save as Bundle` already selected, names the button's first-sight label (Create Bundle), and no longer promises the Operations summary. The FASTA header sentence carries no scope word for the whole-contig case. |
| 3 | `entry_points` rewritten to CONSISTENCY.md line 30's permitted shape. |
| 4 | Both unverifiable rows handled as tabled above. |
| 5 | Section order untouched. All ten settings paragraphs remain with their bold labels verbatim and in the same order. No settings paragraph added or removed. `glossary_refs` edited to match the anchors the body links. No other chapter, `GLOSSARY.md`, `parameters.yaml`, or `mkdocs.yml` touched. |
| 6 | No em dashes, semicolons, or in-sentence colons introduced. "Lungfish Genome Explorer" survives at first mention with "LGE" after. No duration claim added anywhere. |

### Reader rows hit by three or more readers (22 of 22 addressed)

| Reader row subject | What changed |
|---|---|
| Title promises lineage | What it is now says in its opening paragraph that the chapter covers only the sequence, that naming a lineage is a separate job living in other chapters, and that the section's last paragraph says where. |
| Benchmark call set unglossed | Why you would do this glosses it inline as an answer key of variants established independently of your reads, links `#benchmark-vcf`, and says the reader already downloaded it with the fixture. |
| Three download files, singular pronoun | Before you start names all three files exactly, says "all three", makes the pronoun plural, and says what each is for. |
| Plugin pack and Docker unglossed | Rewritten to say nothing has to be installed first, then to gloss the two terms in passing (an optional tool pack, the container software Docker Desktop) while saying neither applies here. |
| Alignment track unnamed in step 1 | Step 1 now says the track sits nested beneath its reference bundle carrying the mapping run's name, which for the fixture is the BAM stem `HG002.sorted`. |
| Tab inside a tab | Step 2 now says Analysis holds a row of six tabs of its own and Consensus is the third, one word per level. |
| Command-line remark in Settings | The remark moved into the Settings lead paragraph in its consistency-sheet-required form, with a clause saying it costs an app-only reader nothing and pointing to On the command line. |
| Depth setting has no real-data anchor | The paragraph now names 20 as the common choice for a publication or public deposit and gives its cost on this fixture, 1.1 percent against the default's 0.2 percent. |
| Two further filters, no click path | The paragraph now gives the click path, Inspector from **Analysis** to **View Settings** then its **Alignment** tab, naming it as the same two-level move that reached Consensus. |
| 51 or 63, which does depth test | Stated that the depth floor is applied twice, once by the caller against the usable bases and once against the total depth, so a position survives only when both clear the floor. Taken from the fidelity review's headline finding rather than invented. |
| Alternate unglossed | Glossed inline at first use as "the base that differs from the reference", with the following clause now linking `#homozygous`. |
| IUPAC row reads as improvement | The table row is labelled "turned on, a relabeling and not new data", and the paragraph beneath says to read it as a change of notation rather than a gain, and that a lower `N` count is not by itself a better sequence. |
| Compare against a prior run | Replaced with the two fixture figures as a first yardstick, 0.205 percent at the defaults and 1.129 percent at a depth floor of 20, said to bracket what settings alone can do, with anything far above them pointing at the sequencing. |
| Command-line section skippable | The section now opens with a line saying an app-only reader can stop reading there. |
| Reading downward cannot be pictured | What it is now sets out the grid explicitly, each read a row, each reference position a column, the stack filling one column being the pileup. |
| Is an asterisk accepted downstream | Resolved by row 4. There is no asterisk, and the sentence now says the output alphabet is the one every downstream program expects. |
| Four tool names in one sentence | BLAST is glossed inline and linked, and the other three are collapsed into plain descriptions (tree-building programs, sequence-comparison programs, portals that accept public database deposits). |
| Bayesian unglossed | Glossed twice, once in Procedure step 4 as the mode that reads each base's own quality number instead of counting votes, and once in the setting itself as a name meaning only that. |
| All-N alert gives no second value | Now says to try 4 next and 1 after that, with the reason a floor of 1 accepts any position a single read reached. |
| Conflict as a second cause of N | Both causes are now named together where `N` is first defined in What it is, and all three (thin depth, conflict, called deletion) again in Reading the results. |
| Sevenfold cannot be checked | Fixed with fidelity row 53. |
| Gap versus insertion | Fixed with fidelity row 87. |

### Other reader rows fixed in a sentence or two

Rows for the consensus disagreeing with the reference, HG002 unintroduced,
whether the reader's own numbers should match, what the sidebar looks like
with a bundle open, how to make a viewport selection, defaults given inline
in step 4, "leave Hide high-gap sites off" versus the later Settings advice,
a numeric example for weighted versus majority calling, spanning versus
covering reads, whether the base-quality floor double counts with Bayesian
mode, where to see read quality, MAPQ versus Phred as different scales, why
0 is the MAPQ default and that it means no filtering, what a MAPQ floor of
20 costs on this fixture (80 `N` positions, derived from the review's table),
whether asterisks count as called (moot after row 4), the 500,001 arithmetic
stated in the text, whether the numbers are reproducible, "caller mode"
renamed to the control's own name, the glossary pointer widened to all six
ambiguity letters, contig glossed at first use in step 4, sidecar described
as a small separate file to keep with the FASTA, the spot-check said to work
on the fixture and on any position with independent evidence, that the reader
never types the recorded command, a row defined at the `--threshold`
sentence, the three ambiguity counts shown to sum to 549, the fixed policies
said to be unchangeable, the danger they protect against moved ahead of the
quoted policy lines, and the app control said not to be a second consensus
button but a different feature.

### Consistency and style

- `entry_points` brought to CONSISTENCY.md line 30's form (also fidelity 84).
- "the Inspector's Consensus tab" replaces "the Inspector's Analysis tab, in
  a section named Consensus" in What it is and in the `analysis-consensus-tab`
  caption, matching the same line.
- The no-command-line-flag statement is kept in the Settings lead paragraph,
  which is the form CONSISTENCY.md lines 94 to 99 permit for a group of
  settings that all lack a flag.
- `glossary_refs` rewritten to exactly the anchors the body links. Added
  `benchmark-vcf`, `blast`, `flag`, `homozygous`, `provenance-sidecar`.
  Removed `bam`, `consensus-fasta`, `coverage`, which the body no longer
  links. Kept `contig-reference`, now linked at the contig gloss.
- No new glossary-worthy term was left unglossed. Benchmark call set, BLAST,
  contig, alternate, flagged record, and provenance sidecar all get an inline
  gloss at first use, each pointing at an existing `GLOSSARY.md` entry.

## Left unchanged, deliberately

- **Section order and the ten settings paragraphs.** Untouched per ruling 5.
  Reader row 48 asked that the variant-caller argument in Why you would do
  this move earlier within its section, and row 71 asked that the
  "Create Consensus Sequence" sentence move out of On the command line. Both
  are structural moves this role does not make. Row 71 is answered in place
  instead, by saying in that section that the two are different features.
- **`parameters.yaml:2913`.** Fidelity row 84 says the registry carries the
  same non-conforming `entry_points` string and needs the same correction.
  Ruling 5 forbids touching it, so the chapter front matter is now correct
  and the registry is not. **This needs a project manager ruling** on who
  fixes the registry.
- **The screenshots themselves.** Reader row 73 asked for the actual image
  behind the step 2 marker rather than only a caption. The three `<!-- SHOT
  -->` markers and their captions are correct and the images are the
  screenshot scout's to capture.
- **`estimated_reading_min: 24`.** The chapter grew by roughly a fifth. The
  figure is a front matter estimate rather than a duration claim in prose, so
  rule 6 does not reach it, but a lead may want it revised.
- **The claim that 337 and 961 differ because of length-changing variants.**
  Reader row 43 asked why the two numbers differ. The fidelity review did not
  verify a cause, so the text now explains only what is provable from the
  chapter's own facts, that a consensus carries one letter per reference
  position and therefore cannot show a length change or an `N`-masked
  position, and tells the reader to treat 337 as a count of visible
  single-letter differences rather than a variant count. If the lead wants a
  causal breakdown, it needs a run against the benchmark VCF.
- **Reader rows asking for figures.** Row 15 asked for a diagram of a read
  stack with one column highlighted. The text now describes the grid in
  words, and `illustrations: []` stays empty for the illustration owner.
- **`brand_reviewed` and `lead_approved`.** Both left `false`. This pass
  applied the reader report and the fidelity corrections rather than the
  brand-only pass the persona flips that flag for, and the chapter has not
  been through gate 2.

## Lint

Command run from the worktree root:

```
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/05-variants/05-consensus-and-lineage.md
```

Output, verbatim:

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/05-variants/05-consensus-and-lineage.md: no issues found
```

The chapter was lint-green before this pass and is lint-green after it. No
rule fired at any point during editing, so no fix-and-rerun cycle was needed.
