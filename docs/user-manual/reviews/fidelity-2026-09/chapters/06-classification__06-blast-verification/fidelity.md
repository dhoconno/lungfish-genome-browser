# Fidelity review, chapter 37, 06-classification/06-blast-verification

Reviewer pass by manual-fidelity-reviewer against Preview 2026.9.13 sources,
`.build/debug/lungfish-cli`, `parameters.yaml`, and the author's two recorded
NCBI runs. No live BLAST submission was made by this review. Line numbers are
from the worktree `user-manual-fidelity-campaign`.

## Claim table

| # | Claim | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "the word, which is **Supported** at 80 percent or above, **Mixed** from 40 up to 80, **Unsupported** below 40, and **Inconclusive** when no read produced a good match at all" | true | `BlastResult.swift:365-376`, `rate >= 0.8` supported, `rate >= 0.4` mixed, else unsupported, `significantHits == 0` inconclusive | |
| 2 | "The share of supporting reads among those two groups decides the word" | true | `BlastResult.swift:330-333`, `supportRate = supporting / (supporting + contradicting)`, so no-hit reads are outside the denominator | |
| 3 | "A read with no good match counts as neither" | true | same, `significantHits = supportingCount + contradictingCount` | |
| 4 | "It polls for the result and gives up after ten minutes" | true | `BlastService.swift:63` `defaultTimeout: TimeInterval = 600.0 // 10 minutes`, passed at `:429`; the author's run-5reads.log ends `BLAST job timed out after 10 minutes (RID: 9WZADAY9016)` | |
| 5 | "reporting a timeout that carries the job's request ID" | true | `BlastVerificationRequest.swift:338` formats `"BLAST job timed out after \(minutes) minutes (RID: \(rid)). "`; run-5reads.log confirms | |
| 6 | The 10s/15s/30s adaptive poll (in the author's report, not stated in the chapter) | true, and correctly omitted from the chapter | `BlastService.swift:805-811`, attempts 1-3 at 10 s, 4-10 at 15 s, thereafter 30 s | The chapter says nothing about poll cadence, which is the right call for the reader. No change. |
| 7 | "Click **BLAST Verify** in the action bar under the table" | true | `ClassifierActionBar.swift:24` `btn.title = "BLAST Verify"`, shared by all classifier viewports | |
| 8 | "Right-clicking the row and choosing **BLAST Matching Reads...** does the same thing" | true | `TaxonomyViewController.swift:1405-1408` `title: "BLAST Matching Reads\u{2026}"` | |
| 9 | "The button stays disabled until exactly one row is selected, and its tooltip says why" | true | `ClassifierActionBar.swift:22` `btn.isEnabled = false` at construction; `:125-137` sets the tooltip from the reason. Taxonomy `TaxonomyViewController.swift:950`, `:1223`, `:1227`; EsViritu `:808`, `:1275`, `:1285`; TaxTriage `:2690`, `:2719`, `:3284`; NVD `:2107`, `:2124`, `:2128`; NAO-MGS `:770`, `:2587`, `:2613`. Reasons are "Select a single row to use BLAST Verify" and "Select a row to use BLAST Verify" | |
| 10 | "Its title is `Verify \"<taxon>\" via NCBI BLAST`" | true | `BlastConfigPopoverView.swift:66` `Text("Verify \"\(taxonName)\" via NCBI BLAST")` | |
| 11 | "under the slider it warns that the reads leave the app for NCBI" | true | `BlastConfigPopoverView.swift:88`, verbatim "Submits selected reads to NCBI BLASTN nt for review. Reads leave the app for NCBI.", rendered after the slider block and before the Run BLAST row | |
| 12 | "If the taxon has only one read, the slider is replaced by a line stating the fixed count" | true | `BlastConfigPopoverView.swift:54-56` `showsSlider = maxReads >= 2`, `:49-51` `maxReads = min(50, max(1, readsClade))`, `:85-86` renders `Text("Reads to submit: \(maxReads)")` in the else branch | The chapter is more accurate here than `parameters.yaml`, which says "fewer than two reads". See App defects. |
| 13 | "the drawer at the bottom of the viewport, which opens on its **BLAST Results** tab" | true | `TaxonomyViewController.swift:1155-1167` opens the drawer then `switchToTab(.blastResults)` | |
| 14 | "shows the three phases of the job in turn. Those are submitting the reads, waiting for NCBI, and parsing what came back" | true | `BlastResultsDrawerTab.swift:130-136` labels "Submitting reads to NCBI BLAST...", "Waiting for NCBI BLAST results...", "Parsing BLAST results..."; `:158` `totalPhases = 3` | |
| 15 | "The run also appears in the Operations panel, titled `BLAST <taxon>`" | true | `ViewerViewController+Taxonomy.swift:172` `title: "BLAST \(node.name)"` | |
| 16 | "The drawer is one of two tabs in the taxonomy viewport, sharing the space with Collections" | true | `TaxonomyViewController.swift:1155-1177` switches between `.blastResults` and the Collections tab of the same drawer; ground-truth row 46 confirms both action-bar buttons | |
| 17 | "clicking the button for the tab already showing closes the drawer" | true | `TaxonomyViewController.swift:1168-1171`, when `selectedTab == .blastResults` the handler calls `toggleTaxaCollectionsDrawer()` and sets the button state off | |
| 18 | "The default is 20 ... and the slider runs from 1 to 50, capped at the number of reads the taxon actually has" | true | `BlastConfigPopoverView.swift:40` `@State private var readCount: Double = 20`, `:75` `in: 1...Double(maxReads)`, `:49-51` the cap. Matches `parameters.yaml` | |
| 19 | "On the command line this is `--reads`, which accepts 1 to 100 there rather than stopping at 50" | true | `BlastCommand.swift:115-117` `guard readCount >= 1, readCount <= 100`; `cli-help/blast.txt` shows `--reads` default 20 | |
| 20 | "LGE takes some of the longest reads assigned to the taxon and fills the rest of the sample at random" | true | `BlastService.swift:363` `SubsampleStrategy.mixed(longest: min(5, readCount / 4), random: readCount - min(5, readCount / 4))`; `BlastCommand.swift:216-222` builds the same; `BlastVerificationRequest.swift:200-227` defines `.mixed(longest:random:)` with `.default = .mixed(longest: 5, random: 15)` | |
| 21 | "The NAO-MGS viewport is the exception. It spreads its picks across quarters of the reference genome" | true | `NaoMgsDataConverter.selectBlastReads` quarters the reference; author's citation confirmed by the absence of `.mixed` in that path | |
| 22 | "The program is `blastn` ... The database is `nt`" | true | `BlastVerificationRequest.swift:86-88` defaults; both author runs printed `Program: blastn` and `Database: nt` | |
| 23 | "Each read gets at most five hits back, which is why an expanded read row never shows more than five" | true | `BlastVerificationRequest.swift:88` `maxTargetSeqs: Int = 5`, sent as `HITLIST_SIZE` and `MAX_NUM_SEQ` at `BlastService.swift:661-662`; `BlastResultsDrawerTab.swift:175-176` "Child hit items (hits 2+, since hit 1 is shown on the parent row)" | |
| 24 | "It reads `BLAST for <taxon>: <n> supporting, <n> contradicting (<n> reads)`" | true | `BlastResultsDrawerTab.swift:451`, verbatim | |
| 25 | "followed by a ten-dot bar and the confidence word" | true | `:456-462` sets `confidenceDots` from `buildConfidenceDots`, `:454` sets `confidenceLabel` from `confidence.displayLabel` | |
| 26 | "a filled circle is a supporting read, a diamond is a contradicting one, and a hollow circle is a read that settled nothing, all scaled to ten dots" | true | `:1281-1290`, U+25CF filled, U+25C6 diamond, U+25CB hollow, each count `round(n / total * 10)` | |
| 27 | "The bar is tinted to match the word" | true | `:466` `summaryBar.layer?.backgroundColor = confidence.tintColor.cgColor` | |
| 28 | "One extra phrase can appear beside the word, reading `<n> with conflicting organisms`" | true | `:468-471`, shown only when `result.lcaDisagreementCount > 0` | |
| 29 | "It counts reads whose own list of hits disagrees about the genus" | true | `BlastVerificationResult.lcaDisagreementCount`, genus-level disagreement among a read's own hits | |
| 30 | "Six columns are shown by default. Status ... Read / Accession ... Organism ... Identity, E-value, and Bit Score" | true | `BlastResultsDrawerTab.swift:852` (Status, empty title), `:861` "Read / Accession", `:870` "Organism", `:879` "Identity", `:888` "E-value", `:897` "Bit Score". None of the six sets `isHidden` | The chapter is right and DRIFT row 13 is wrong. See App defects. |
| 31 | "Read / Accession holds the read's identifier on a parent row and the matched record's accession on a child row" | true | `:861` and `:1299` set that title; parent rows are `ReadResultItem`, child rows `HitSummaryItem` | |
| 32 | "Four more columns are hidden until you ask for them, which are Accession, Coverage, Align Length, and Verdict, along with Tax ID" | true, imprecise | `:913`, `:923`, `:933`, `:943`, `:953` each set `isHidden = true` on Accession, Coverage, Align Length, Tax ID, Verdict, five in total. The sentence names all five but counts four | "Five more columns are hidden until you ask for them, which are Accession, Coverage, Align Length, Tax ID, and Verdict." |
| 33 | "Right-click the column header and choose one to show it, and LGE remembers your choice ... including after you quit" | true | `:229` `hiddenColumnsDefaultsKey = "blastResultsHiddenColumns"`, `:257` documents the UserDefaults persistence, with `restoreColumnVisibility`/`saveColumnVisibility` | |
| 34 | "Verdict shows LGE's own per-read call, which is Verified ... Ambiguous ... Unverified ... and Error" | true | `BlastResult.swift:14-32` defines exactly those four cases with those meanings; `BlastService.swift:873-875` gives the thresholds, 90 percent identity and 80 percent query coverage and the e-value threshold | |
| 35 | "Right-clicking a row offers Copy Sequence as FASTA, Copy Read ID, and Copy Accession, plus Expand All and Collapse All" | true | `BlastResultsDrawerTab.swift:1104-1121`, those five titles in that order with a separator before Expand All | |
| 36 | "**Open in NCBI BLAST** opens the full result on NCBI's own site in your browser" | true | `:1059` `openInBlastButton.title = "Open in NCBI BLAST"` | |
| 37 | "**Re-run BLAST** submits the taxon again with a fresh sample of reads" | true | `:1069` `rerunBlastButton.title = "Re-run BLAST"`; the rerun path re-enters the subsample step, so the sample is redrawn | |
| 38 | "**Export** in the summary bar writes the table as CSV or TSV through a save panel" | true | `:795` `exportButton.title = "Export"`; `:1443` "Export as CSV..." and `:1445` "Export as TSV..."; `:1463` comment "Exports results to a delimited file using NSSavePanel" | |
| 39 | "with both submitted reads matching *Severe acute respiratory syndrome coronavirus 2* at 100 percent identity" | true | author's `run-2reads.log`, `PASS SRR36291587.1 ... 100.0%` and `PASS SRR36291587.2 ... 100.0%` | |
| 40 | "two supporting reads out of three is a 67 percent share and lands in the Mixed band" | true | 2/3 = 0.667, inside `[0.4, 0.8)` per `BlastResult.swift:371-373` | |
| 41 | "The source FASTQ must be uncompressed, though the Kraken 2 output may be gzipped" | true | `BlastCommand.swift:482-503` `blastOpenKrakenOutputStream` branches on `.gz` through `/usr/bin/gzip -dc`; `:515-532` `blastExtractSequences` opens a bare `FileHandle` and decodes UTF-8 with no gzip branch | The chapter's warning is correct and is the right mitigation for a real CLI defect. See App defects. |
| 42 | The quoted `Verification Results` block | true | matches `run-2reads.log` line for line, including `BLAST RID : 9WZYE9M0014`, `Program : blastn`, `Database : nt`, and both PASS lines | |
| 43 | "`--taxid` picks the taxon, and its number comes from the kreport's sixth column" | **false** | The taxid is the **seventh** tab-separated field of a kreport. On the author's `classification.kreport` line 15 the fields are `98.11`, `83591`, `83591`, `9512702`, `9121`, `S1`, `2697049`, name. Field 6 is the rank code `S1`, field 7 is the taxid | "its number comes from the kreport's seventh column" |
| 44 | "or from Copy Taxon ID in the viewport" | **false** | The taxonomy viewport's context menu has no Copy Taxon ID. `TaxonomyViewController.buildTaxonContextMenu` (lines 1305-1410) offers Extract Reads..., Copy Taxon Name, Copy Taxonomy Path, Zoom to..., Zoom Out to Root, the Look Up on NCBI submenu, and BLAST Matching Reads... "Copy Taxon ID" exists only in NAO-MGS, `NaoMgsResultViewController.swift:2098`. Chapter 02 line 218 lists the same menu and likewise has no Copy Taxon ID | "its number comes from the kreport's seventh column, or from the Tax ID column of the taxonomy table." Alternatively drop the second clause. |
| 45 | "`--include-children` also pulls in reads assigned to taxa below the one you named" | true | `cli-help/blast.txt` "Include reads classified to descendant taxa" | |
| 46 | "`--max-concurrent` caps how many submissions this process keeps in flight, defaulting to 1" | true | `cli-help/blast.txt` "Maximum in-flight BLAST submissions for this process (default: 1)"; `BlastCommand.swift:118-120` validates `>= 1` | |
| 47 | "`--extra-args` forwards further NCBI parameters as `KEY=VALUE` tokens, for example `WORD_SIZE=11`" | true | `cli-help/blast.txt`, that exact example | |
| 48 | "Adding `--format json` prints the summary as JSON" | true | `cli-help/blast.txt` `--format` values text, json, tsv, default text | |
| 49 | "`-v` adds the per-read table shown below" | true | `run-2reads.log` was produced with `-v` and carries the `Per-Read Results` block | |
| 50 | "the command prints a link built from it" | true | `run-2reads.log` "View full results: https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Get&RID=9WZYE9M0014&FORMAT_TYPE=HTML" | |
| 51 | "An earlier run of the same command with `--reads 5` was still queued when LGE gave up at ten minutes, and it printed `BLAST job timed out after 10 minutes (RID: 9WZADAY9016)`" | true | `run-5reads.log`, verbatim, after 24 polls | |
| 52 | "waiting at least ten seconds between them and treating fifty sequences an hour as its ceiling" | true | `BlastVerificationRequest.swift:280-281` `minSubmitInterval: TimeInterval = 10`, `maxSequencesPerHour: Int = 50`, `:289` `ncbiDefault`; enforced at `BlastService.swift:1429-1441` | |
| 53 | "In the EsViritu viewport it is **BLAST Verify...**" | true | `ViralDetectionTableView.swift:815` `title: "BLAST Verify\u{2026}"` | This settles ground-truth row 29 of `03-running-esviritu.md`, previously unverifiable. |
| 54 | "In the TaxTriage viewport it is **Verify with BLAST...**" | true | `BatchTaxTriageTableView.swift:63` `title: "Verify with BLAST\u{2026}"` | |
| 55 | "the Novel Virus Diagnostics viewport uses that same wording" | true | NVD builds its row menu through `FASTASequenceActionMenuBuilder`, whose `blastMenuTitle` default is "Verify with BLAST…" (`FASTASequenceActionMenuBuilder.swift:7`), and `NvdResultViewController.swift:1930-1938` passes no override | |
| 56 | "its right-click menu offers the read count directly, as **BLAST 20 Reads** and **BLAST 50 Reads** on an abundant taxon, or as **BLAST All \<n\> Reads** when the taxon has fifty reads or fewer" | true, imprecise | `NaoMgsResultViewController.swift:2074-2086`. At or under 20 reads the only item is "BLAST All \<n\> Reads". From 21 to 50 there are two, "BLAST 20 Reads" and "BLAST All \<n\> Reads". Above 50 there are two, "BLAST 20 Reads" and "BLAST 50 Reads" | The sentence reads as a two-way split but the code has three bands. Suggest "as **BLAST 20 Reads** and **BLAST 50 Reads** on a taxon with more than fifty reads, and as **BLAST All \<n\> Reads** on one with twenty or fewer, with both forms offered in between." |
| 57 | "That pipeline has already assembled the reads into contigs, so verification submits the selected contig's own sequence rather than a sample of reads" | true | `NvdResultViewController.swift:2028-2031` `performBlastVerification` passes `contigSequence(for: hit)` to `onBlastVerification` | |
| 58 | "The drawer looks the same but its summary is a plain heading with no confidence word, because a single sequence has no supporting share to compute" (of Novel Virus Diagnostics) | **false** | NVD never assigns `presentationStyle`, so its drawer keeps the declared default `.verification` (`BlastResultsDrawerTab.swift:290`). A grep for `presentationStyle =` across `Sources/` returns only `TwelveSAmpliconResultViewController.swift:1497` and `:1532` (`.sequenceBlast`) and `AssemblyResultViewController.swift:569` and `:612` (`.contigBlast`). The plain-heading branch at `:488-489` is therefore reached by the assembly and 12S viewports, not by NVD | "The drawer looks the same and still carries a confidence word, since it runs the same verification summary. The 12S metabarcoding viewport is the one that drops the word, showing a plain `BLAST results for <name>` heading instead, because a single unmatched sequence has no supporting share to compute." |
| 59 | "The same is true of the 12S metabarcoding viewport, which BLASTs the sequences it could not match locally" | true for 12S | `TwelveSAmpliconResultViewController.swift:1497`, `:1532` set `.sequenceBlast`, which takes the `:488` plain-heading branch. The empty state at `:627-629` reads "Select unmatched 12S sequences and run BLAST..." | The clause is right about 12S. It fails only because it inherits the false NVD claim above. Fold into the correction for row 58. |
| 60 | "LGE offers no local BLAST to fall back on" | true | The only submission path is the NCBI URL API (`BlastService.swift:640-662`); no local `blastn` executable appears in the tool lock or the plugin packs | |
| 61 | "Every classifier viewport carries the same **BLAST Verify** button in its action bar and opens the same drawer" | true | `ClassifierActionBar.swift:22-33` is the single shared button, and every classifier viewport routes into `BlastResultsDrawerTab` | The 12S viewport is a partial exception, since its action bar gates on the Unresolved tab (`TwelveSAmpliconResultViewController.swift:1147`, `:1468-1472`) and allows a multi-row selection. The chapter's sentence is about classifier viewports and 12S is treated separately two paragraphs later, so no change is needed. |

## Front matter

`parameters_refs: [classify.blast-verify]` matches the roster and the registry
id exists in `parameters.yaml`. Correct.

`shots` declares `blast-verify-popover` and `blast-results-drawer`. Both have
matching `<!-- SHOT: ... -->` markers in the body, at lines 71 and 93, and there
are no markers without a declaration. Both captions are accurate. The
`blast-results-drawer` caption's "in their six default columns" matches the
source (claim 30) and satisfies the DRIFT screenshot note that the caption must
not imply the optional columns are visible.

`glossary_refs` lists sixteen terms. Every one resolves to an anchor in
`GLOSSARY.md`: accession, bit-score, blast, coverage, e-value, kraken2, kreport,
nt-database, percent-identity, query-coverage, read, read-classification, rid,
taxon, taxonomic-rank. Each appears exactly once as `{#anchor}`. Every in-body
`../../GLOSSARY.md#...` link targets a term that is also in `glossary_refs`.
No dangling links either way.

`prereqs: [06-classification/02-running-kraken2]` is right, since the procedure
starts from a finished Kraken 2 result. `tools: [blast]`, `features_refs: []`
and `illustrations: []` are consistent with a chapter that documents no plugin
pack. `fixtures_refs: [sarscov2-srr36291587]` matches the fixture the runs used.
`entry_points` reproduces the registry's three entries verbatim.

`brand_reviewed: false` and `lead_approved: false` are correct at this stage.
`estimated_reading_min: 14` is plausible for roughly 2,600 words.

One note. The `representative-read` glossary entry was corrected by the author
and now reads "drawn as some of the longest reads plus a random fill ... except
in the NAO-MGS viewport, which instead spreads its picks across quarters of the
reference genome" (`GLOSSARY.md:457`). That matches `BlastService.swift:363` and
`NaoMgsDataConverter.selectBlastReads`. The correction is sound. The term is not
in this chapter's `glossary_refs` and is not linked from the body, which is fine
since the chapter explains the sampling in prose instead.

## Settings coverage against parameters.yaml

The registry lists one setting and three `cli_only` flags.

**Reads to submit:** is documented, in the fixed three-sentence shape, with the
label verbatim from the registry, the default 20, the range 1 to 50 capped at
the taxon's reads, when to change it, and the `--reads` flag in a closing
sentence. Complete and correct. Coverage is 1 of 1.

The three `cli_only` flags are all documented, in `## On the command line`
rather than as Settings paragraphs. `--include-children`, `--max-concurrent`
with its default of 1, and `--extra-args` with the registry's own `WORD_SIZE=11`
example all appear. Placing them outside Settings is right, since they are not
controls in the popover, and CONSISTENCY does not require a Settings paragraph
for a flag with no control.

The registry's `notes` block names three fixed values, program `blastn`,
database `nt`, and five hits per read. All three are in the closing paragraph of
`## Settings`, framed so a reader can copy them into a methods section.

Two registry statements the chapter does not repeat, correctly. The `notes`
sentence "When a taxon has fewer than two reads the slider disappears" is wrong
(claim 12), and the chapter states the true threshold instead. The `notes`
mention of "a verification rate" is not what the verification-style summary bar
shows (`BlastResultsDrawerTab.swift:451` shows counts, not a rate), and the
chapter describes the counts and the dot bar instead. Both departures from the
registry are improvements, and both should be pushed back into the registry.

## Consistency

Naming. "Lungfish Genome Explorer (LGE)" at first mention in the body, line 32,
then LGE throughout. No stray bare "Lungfish" for the app. Correct.

Fixture name. "the SRR36291587 SARS-CoV-2 reads" at lines 46, 52, and 66,
exactly the CONSISTENCY spelling.

Before you start. The two fixed sentences are present verbatim, adapted to the
fixture, at lines 50 and 52, with the GitHub fixtures URL. Correct.

Menu paths. **File > New Project** (Cmd-N) matches. Bold action-bar and menu
item names are written as bold without a path where they are buttons, which is
the CONSISTENCY form.

Cross-chapter agreement. Chapter 02 line 218 lists the taxonomy right-click menu
and names **BLAST Matching Reads...** as "the per-row route into verification",
matching this chapter's step 2 exactly. Chapter 02 line 220 describes the two
drawer toggles, Collections and BLAST Results, and defers to this chapter, which
matches the paragraph after step 5. Chapter 03 line 205 writes the EsViritu row
menu item as **BLAST Verify...**, matching claim 53, and line 207 quotes the
tooltip "Select a row to use BLAST Verify", matching claim 9. Chapter 02 line
261 sets the low-abundance threshold habit that this chapter's second reason
refers back to at line 44. No contradiction found in either direction.

Settings shape. The one Settings paragraph follows the label-then-three-sentences
order and closes with the command-line sentence. The label keeps its trailing
colon inside the bold, as `parameters.yaml` spells it.

Glossary discipline. Every term is glossed on first use in the body even where
an earlier chapter glossed it, and each links to `GLOSSARY.md`.

Prose rules. Lint is green under `LUNGFISH_MANUAL_STRICT=1`. Spot checks confirm
no em dash, no semicolon, and no mid-sentence colon outside code blocks and the
verbatim CLI output. Bullet and list caps are respected, since the only list is
the five-step Procedure.

One consistency risk worth flagging. The chapter is a viral example, and line 46
justifies it explicitly ("because the classifier databases are pathogen
databases"). That is the right handling of the human-or-macaque-first rule, and
it matches chapter 02 line 56, which carries the same justification. No change.

## App defects

Confirming the author's four.

**One, `parameters.yaml` and DRIFT row 13 both understate the hidden columns.
Confirmed.** `BlastResultsDrawerTab.swift:913` sets `accessionColumn.isHidden =
true` in the same block as Coverage, Align Length, Tax ID and Verdict, under the
comment "Optional columns (hidden by default, right-click header to show)". The
default set is six and the hidden set is five. DRIFT row 13's corrected wording,
"Right-click the column header to add Coverage, Align Length, Tax ID, and
Verdict", omits Accession and is wrong. The author diagnosed the cause
correctly, which is that the visible outline column is titled "Read / Accession"
(`:861`) and is a different thing from the separate hidden Accession column
(`:907-914`). This is a documentation-source defect. DRIFT row 13 and the
registry's `notes` should both be corrected, and neither is the chapter's to fix.

**Two, `blast verify --source` cannot read a gzipped FASTQ. Confirmed, and it is
a real CLI defect.** `blastOpenKrakenOutputStream` (`BlastCommand.swift:482-503`)
branches on a `.gz` extension and pipes through `/usr/bin/gzip -dc`, so
`--kraken-output` accepts compressed input. `blastExtractSequences`
(`:515-532`) has no such branch. It calls `FileHandle(forReadingAtPath:)`
directly and decodes each 4 MB chunk with `String(data:encoding: .utf8)`. On a
gzip stream that decode fails, the `guard let text = ... else { continue }` at
`:532` silently discards every chunk, and the function returns an empty array.
The caller then prints the warning at `:211`, "No matching reads found in source
FASTQ", which names the wrong cause. The GUI is unaffected, since
`BlastService.extractMatchingSequences` (`BlastService.swift:480-517`) takes an
`isGzip` flag, launches a decompression subprocess, and even retries once. The
severity is real because LGE's own imports store `.fastq.gz`, so the natural
path a reader takes is the one that fails silently. Two acceptable fixes, either
give `blastExtractSequences` the same `.gz` branch its sibling already has, or
detect the gzip magic bytes and fail with a message naming compression. The
chapter's warning at line 121 is the correct interim mitigation.

**Three, `parameters.yaml` states the slider threshold as "fewer than two
reads". Confirmed, cosmetic.** `showsSlider` is `maxReads >= 2` where `maxReads
= min(50, max(1, readsClade))` (`BlastConfigPopoverView.swift:49-56`), so a
zero-read taxon also takes the no-slider branch and shows "Reads to submit: 1",
while `canRun` is `readsClade >= 1` (`:59-61`) so Run BLAST is disabled there.
The chapter's "only one read" is the accurate phrasing for anything a reader can
reach. The registry sentence should be corrected.

**Four, ground-truth row 29 of `03-running-esviritu.md` is now settled.
Confirmed.** `ViralDetectionTableView.swift:815` sets the title verbatim to
"BLAST Verify\u{2026}". That row can move from unverifiable to true. Chapter 03
line 205 already writes it correctly.

New defects and errors found by this review.

**Five, the chapter says the kreport taxid is in the sixth column. It is the
seventh.** Claim 43. Checked against the author's own fixture, where field 6 is
the rank code `S1` and field 7 is `2697049`. This is a chapter error rather than
an app defect, and the correction is a one-word change.

**Six, the chapter points the reader at a Copy Taxon ID menu item that the
taxonomy viewport does not have.** Claim 44. The taxonomy context menu offers
Copy Taxon Name and Copy Taxonomy Path but no Copy Taxon ID
(`TaxonomyViewController.buildTaxonContextMenu`, lines 1305-1410). Copy Taxon ID
exists only in the NAO-MGS viewport
(`NaoMgsResultViewController.swift:2098`). Chapter 02 line 218, which lists the
same menu, corroborates the absence. There is a genuine usability gap here,
since a reader who wants a taxid for the CLI has to read it out of the table
column by eye, but the chapter must not describe a control that is missing. Two
things to do, correct the chapter now, and consider filing the missing menu item
as a separate app request.

**Seven, the chapter says the Novel Virus Diagnostics drawer shows no confidence
word. It does show one.** Claim 58. NVD never assigns `presentationStyle`, so
the drawer keeps its declared default `.verification`
(`BlastResultsDrawerTab.swift:290`) and takes the confidence branch at
`:447-486`. Only `.contigBlast` and `.sequenceBlast` reach the plain-heading
branch at `:488-489`, and a grep for `presentationStyle =` across `Sources/`
finds exactly four assignments, two to `.sequenceBlast` in
`TwelveSAmpliconResultViewController.swift` and two to `.contigBlast` in
`AssemblyResultViewController.swift`. So the chapter has attached the 12S
behaviour to NVD. The 12S half of the claim is right. Whether NVD should show a
confidence word over a single contig is a fair design question, since a
one-sequence support rate is either 0 or 1 and the word will always read
Supported or Unsupported with a full or empty dot bar, but the chapter must
describe what ships. Worth raising with the app side separately as a possible
missing `presentationStyle = .contigBlast` in `NvdResultViewController`.

## Notes for the editor

Three body changes are needed, all small.

Line 132, change "the kreport's sixth column" to "the kreport's seventh column",
and either delete "or from Copy Taxon ID in the viewport" or replace it with a
pointer to the table's Tax ID column. The second half of that sentence is the
one that would send a reader hunting through a menu for an item that is not
there, so it matters more than the column number.

Line 167, rewrite the Novel Virus Diagnostics paragraph so the missing
confidence word belongs to the 12S viewport alone. The suggested wording is in
the claim table. The paragraph's first sentence, about NVD submitting the
contig's own sequence, is correct and should stay.

Line 103 reads "Four more columns are hidden ... which are Accession, Coverage,
Align Length, and Verdict, along with Tax ID." The list is complete and correct,
but the count says four while five are named. Suggest "Five more columns are
hidden until you ask for them, which are Accession, Coverage, Align Length, Tax
ID, and Verdict."

Line 165, consider widening the NAO-MGS sentence to cover the third band, since
a taxon between 21 and 50 reads gets both "BLAST 20 Reads" and "BLAST All \<n\>
Reads". The current sentence is not false for the two bands it names, so this is
a precision improvement rather than a correction.

Nothing else in the chapter needs a change. The rewrite is a marked improvement
on what it replaced. The removal of the invented timing sentence, the correction
of the sampling strategy from "coverage-stratified" to longest-plus-random, and
the four distinct right-click titles are all verified against source, and the
two CLI runs are quoted accurately. The Settings section is the cleanest example
of the three-sentence shape I have reviewed in this part.

Two items to route elsewhere rather than into the chapter. DRIFT row 13 and the
`classify.blast-verify` `notes` block in `parameters.yaml` both need the
Accession correction and the slider-threshold correction, and neither file is
the chapter's to edit. Ground-truth row 29 of `03-running-esviritu.md` can be
marked true.

## Counts

61 claims checked. 58 true, 3 false, 0 unverifiable.

False claims are 43 (kreport column six, should be seven), 44 (Copy Taxon ID is
not in the taxonomy viewport), and 58 (the NVD drawer does show a confidence
word).

Claims 32 and 56 are true but imprecise and carry suggested rewordings.

App and documentation defects: 4 of the author's 4 confirmed, 3 new found
(2 chapter errors, 1 possible app defect in `NvdResultViewController`).

Front matter: clean. Settings coverage: 1 of 1, plus 3 of 3 cli_only flags.
Consistency: no violation found. Lint: green.
