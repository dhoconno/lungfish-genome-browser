# Author report, chapter 37, 06-classification/06-blast-verification

Registry id `classify.blast-verify`. Fixture `sarscov2-srr36291587`.
Author pass by bioinformatics-educator against Preview 2026.9.13 sources.

## Runs made

Two live NCBI BLAST runs, both from `.build/debug/lungfish-cli` in the primary
checkout, both writing only under the session scratchpad's `blast/` folder.
Inputs were copies of the Kraken 2 viral run already in `scratchpad/kraken2/`
(`run-viral/classification.kreport`, `run-viral/classification.kraken`) with the
plain-text `scratchpad/kraken2/sars-reads.fastq` as the source. Nothing in
`scratchpad/kraken2/` was modified.

Run 1, `--reads 5`, taxid 2697049. Submitted successfully, RID `9WZADAY9016`,
polled 24 times, then failed with `BLAST job timed out after 10 minutes`. This is
the client-side ceiling, not an NCBI error.

Run 2, `--reads 2 -v`, same taxid, an hour later. Completed on the first poll.
Result quoted verbatim in the chapter's command-line section. Confidence
Supported, 2 of 2 supporting, both reads matching *Severe acute respiratory
syndrome coronavirus 2* at 100.0 percent identity, RID `9WZYE9M0014`, program
`blastn`, database `nt`. The command also reported `Clade reads: 83591`,
`Rank: Subspecies`, and `Subsampled 2 reads (167182 available)`.

The chapter quotes only numbers from run 2 and the timeout string from run 1.

## What was removed from the old chapter, and why

**The invented timing sentence.** "Typical wait is 30 seconds to a few minutes;
during NCBI peak hours the queue can stretch to ten minutes or more" was the
chapter's one unverifiable claim (ground-truth row 22). Removed and replaced with
the one timing fact that is in the source, which is `BlastService.defaultTimeout
= 600.0`, plus the adaptive poll schedule at `BlastService.adaptivePollInterval`
(10 s, 15 s after three attempts, 30 s after ten). The chapter now says LGE gives
up after ten minutes and says nothing about how long NCBI takes.

**The wrong drawer column list.** The old chapter listed eleven columns as though
all were visible. Corrected per DRIFT row 13, with one further correction the
DRIFT row itself got wrong, noted below.

**"BLAST Verify…" as a menu title, and "BLAST Matching Reads…" as an alternative
for the same menu.** Replaced with the four distinct titles the source sets, in a
new `## Where else verification starts` section.

**"stratified across the taxon's coverage".** False for the Kraken 2, EsViritu and
TaxTriage paths. `SubsampleStrategy` is `.mixed(longest:random:)` and every caller
in `ViewerViewController+{EsViritu,TaxTriage,NaoMgs}.swift`, `BlastService.swift:363`
and `BlastCommand.swift:216-222` uses it. Only NAO-MGS is coverage-stratified, in
`NaoMgsDataConverter.selectBlastReads`, which quarters the reference genome. The
chapter now says longest-plus-random and names NAO-MGS as the exception.

**"Lungfish enforces a minimum spacing between submissions".** Kept, but sourced
rather than asserted. `BlastRateLimitConfiguration.ncbiDefault` is
`minSubmitInterval: 10`, `maxSequencesPerHour: 50`. The chapter now gives those
two numbers instead of a vague claim.

**The "When BLAST verification earns its keep" five-row table.** Replaced with
prose. The table carried a "Typical outcome" column that predicted results the
manual has not measured, which is invented data in table clothing. The four
situations survive as prose in `## Why you would do this`.

**"the classifier will pick the closest thing it has seen and confidently report
it".** Kept in substance, reworded, because the underlying claim is true of any
closed-database classifier and the chapter now says so without the anthropomorphism.

**The old `## What you will learn` and `## A note on rate limits` sections.**
Folded into the template's sections. `## What you will learn` is not in the
template. The rate-limit material moved into `## On the command line`, where the
flags that control it live.

## How the DRIFT rows were settled

**Row 5 (changed), the right-click titles.** DRIFT gave two titles. The source has
four. `TaxonomyViewController.swift:1405-1408` is "BLAST Matching Reads…",
`ViralDetectionTableView.swift:815` is "BLAST Verify…",
`BatchTaxTriageTableView.swift:64` and `FASTASequenceActionMenuBuilder.swift:7`
are both "Verify with BLAST…", and NAO-MGS has no single title at all because
`NaoMgsResultViewController.populateContextMenu` builds the count into the item
("BLAST 20 Reads", "BLAST 50 Reads", "BLAST All \<n\> Reads"). All four are in the
chapter's `## Where else verification starts` section.

**Row 5 also settles ground-truth row 29 of `03-running-esviritu.md`,** which was
marked unverifiable because the EsViritu row-menu title could not be located.
It is at `ViralDetectionTableView.swift:815`, verbatim "BLAST Verify\u{2026}".
Chapter 03 already says "BLAST Verify..." and is therefore correct as written.
This is a finding for the chapter 03 reviewer, not an edit I made.

**Row 13 (changed), the columns. DRIFT's correction is itself wrong about
Accession.** DRIFT says the default set is "Status, Read ID or Accession,
Organism, Identity, E-value, and Bit score" with "Coverage, Align Length, Tax ID,
and Verdict" hidden. In `BlastResultsDrawerTab.setupResultsView` the hidden set is
five, not four. `accessionColumn.isHidden = true` sits at the same place as the
other four (the code comments the whole block "Optional columns (hidden by
default, right-click header to show)"). The DRIFT row was misled by the visible
outline column being titled "Read / Accession", which is one column showing the
read id on a parent row and the hit's accession on a child row, and is not the
same thing as the separate hidden Accession column. The chapter names six default
columns and five hidden ones, and uses the column's real title "Read / Accession"
rather than DRIFT's paraphrase "Read ID or Accession". Column titles taken
verbatim from `:861` through `:948`. Persistence claim kept, key
`blastResultsHiddenColumns` at `:229`, `restoreColumnVisibility`/`saveColumnVisibility`.

**Row 22 (unverifiable), the wait time.** Settled by deletion plus substitution,
as described above. The claim was about NCBI, not LGE, so no amount of source
reading could have verified it. Both of my runs are consistent with the removal,
since one returned inside a single poll and one exceeded ten minutes.

**Missing row, the popover's NCBI warning.** Added. Verbatim string at
`BlastConfigPopoverView.swift:90` is "Submits selected reads to NCBI BLASTN nt for
review. Reads leave the app for NCBI." The chapter paraphrases it in Before you
start and in procedure step 3, and draws the consequence, which is that a sample
you cannot share is a sample you cannot verify this way.

**Missing row, the slider disappearing.** Added to procedure step 4. The threshold
is not "fewer than two reads" as `parameters.yaml` notes says. `showsSlider` is
`maxReads >= 2` and `maxReads` is `min(50, max(1, readsClade))`, so the slider
disappears only when the taxon has one read or none. The chapter says "only one
read".

**Missing row, the conflicting-organisms warning.** Added to `## Reading the
results`. String at `:468` is "\<n\> with conflicting organisms", driven by
`BlastVerificationResult.lcaDisagreementCount`, which counts reads whose own hit
list disagrees at genus level.

**Missing row, column persistence.** Added, as above.

**Missing row, the drawer is one of two tabs.** Added at the end of `## Procedure`,
with the Collections pairing and the toggle-to-close behaviour from
`TaxonomyViewController.toggleBlastResultsTab` at `:1155-1182`.

## Facts added beyond the DRIFT rows

The verdict thresholds, which the old chapter described qualitatively only. From
`BlastResult.swift:340-373`, Supported is a support rate at or above 0.8, Mixed
0.4 up to 0.8, Unsupported below 0.4, Inconclusive when no read produced a
significant hit. Support rate is supporting over (supporting plus contradicting),
so reads with no significant hit are excluded from the denominator, which is why a
two-of-three result lands in Mixed. The chapter states all of this.

The summary bar's real text, `BLAST for <taxon>: <n> supporting, <n>
contradicting (<n> reads)` at `:451`, replaces the old chapter's "verification
rate" framing. The verification rate exists as a property but is not what the
verification-style summary bar shows, so the chapter describes the counts and the
dot bar instead. The ten-dot bar is from `buildConfidenceDots` at `:1281-1288`,
filled circle for supporting, diamond for contradicting, hollow for neither.

The per-read Verdict values, from `BlastVerdict` at `BlastResult.swift:14-32`.

The Operations panel entry, titled `BLAST <taxon>`, from
`ViewerViewController+Taxonomy.swift:167-176`.

The drawer's row context menu and Export button, from `buildContextMenu` at
`:1101-1124` and `exportButton.title = "Export"` at `:795`.

The CLI's `--reads` range being 1 to 100 rather than the popover's 1 to 50, from
`BlastCommand.VerifySubcommand.validate()`.

## Settings

One paragraph, for the registry's one setting, label **Reads to submit:** copied
verbatim from `parameters.yaml`. Default 20, range 1 to 50 capped at the taxon's
read count, `--reads` named in the closing sentence. The three `cli_only` flags
(`--include-children`, `--max-concurrent`, `--extra-args`) are documented in
`## On the command line` rather than as Settings paragraphs, since they are not
controls. The fixed values the registry's `notes` block lists (program `blastn`,
database `nt`, five hits per read) are stated in a closing paragraph of the
Settings section so a reader can copy them into a methods section.

Note on the default. `parameters.yaml` says 20 flatly. The popover's `.onAppear`
sets `readCount = min(Double(min(20, maxReads)), Double(maxReads))`, so on a taxon
with fewer than 20 reads the slider opens at that lower number. The chapter says
the default is 20 and separately says the range is capped at the available reads,
which covers the case without contradicting the registry.

## Shot markers

Two, both matching `shots[]` entries. Both were `planned_shots` in the old
front matter and are now real markers, which the DRIFT screenshot table approved.

`blast-verify-popover`, in procedure step 3. Caption rewritten to name the
warning line as well as the slider and the button, since the warning is one of the
DRIFT missing rows and the shot is the only place a reader will see it.

`blast-results-drawer`, opening `## Reading the results`. Caption rewritten per the
DRIFT screenshot note so it does not imply the optional columns are visible. It now
says "in their six default columns".

## Glossary

Three terms added, alphabetised, in the existing `**Term**{#anchor}. Sentence. See
also:` shape.

- **Bit score**{#bit-score}, needed because Bit Score is a default drawer column
  and the old chapter listed it without ever defining it.
- **nt database**{#nt-database}, needed because the chapter says the database is
  fixed at `nt` and an undergraduate reader has no reason to know what that is.
- **RID (Request ID)**{#rid}, needed because the CLI prints `BLAST RID` and
  because the RID is what makes a timeout recoverable.

One existing entry corrected. **Representative reads**{#representative-read}
claimed the sample is coverage-stratified, which is true only of NAO-MGS. Rewritten
to say longest-plus-random with NAO-MGS named as the exception.

BLAST, e-value, percent identity, query coverage, coverage, kreport, accession,
taxon, taxonomic rank, read, read classification and Kraken 2 all already existed
and are linked rather than redefined.

## Possible app defects found

**One, `parameters.yaml` understates the hidden columns.** Its notes and DRIFT row
13 both treat Accession as visible by default. `BlastResultsDrawerTab.swift`
hides it alongside Coverage, Align Length, Tax ID and Verdict. This is a
documentation-source defect rather than an app defect, but it will mislead the
next author who reads the registry, so it is worth correcting there. The registry
is not mine to edit.

**Two, the `blast verify` source FASTQ cannot be gzipped.** `blastScanKrakenOutput`
opens the Kraken 2 output through `gzip -dc` when the extension is `.gz`, but
`blastExtractSequences` opens the source with a bare `FileHandle` and parses it as
UTF-8 text with no such branch. A user pointing `--source` at the `.fastq.gz` that
every LGE import actually stores will get zero matching reads and the message "No
matching reads found in source FASTQ", which names the wrong cause. The GUI is
unaffected, because `BlastService.extractMatchingSequences` has its own gzip path
with a retry. The chapter warns the reader that the source must be uncompressed,
but the CLI should either decompress it or say so in the error.

**Three, `parameters.yaml` states the slider threshold as "fewer than two reads".**
`showsSlider` is `maxReads >= 2` where `maxReads = min(50, max(1, readsClade))`,
so a taxon with zero reads also reaches the no-slider branch, and `canRun` is
`readsClade >= 1`, meaning a zero-read taxon shows the fixed-count line reading
"Reads to submit: 1" with the Run button disabled. Cosmetic, and unreachable from
the taxonomy table in practice, but the popover would read oddly if it were.

**Four, an unverifiable row in a neighbouring chapter is now settled.** See row 5
above. Ground-truth `03-running-esviritu.md` row 29 can be marked true.

## Lint

    LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh \
      docs/user-manual/chapters/06-classification/06-blast-verification.md

Result: `docs/user-manual/chapters/06-classification/06-blast-verification.md: no issues found`

One warning was raised and fixed on the first pass. Procedure step 4 originally
wrote the control as **Reads to submit:** inline, and `sentence-colon.js` flagged
the label's own trailing colon as a mid-sentence colon. Reworded to "the slider
labelled **Reads to submit**". The Settings paragraph keeps the verbatim label in
the `**Reads to submit:.**` form, which lint accepts at the start of a line.

`GLOSSARY.md` carries 342 pre-existing warnings, all of them the "See also:"
idiom every entry ends with. The four entries I touched follow that same shape and
add no new class of warning.
