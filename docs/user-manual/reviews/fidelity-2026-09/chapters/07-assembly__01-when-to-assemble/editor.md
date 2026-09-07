# Editor pass: 07-assembly/01-when-to-assemble

Brand copy editor, 2026-09-07. The chapter on disk was the author's text.
No previous editor pass existed.

Lint: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
exits 0, "no issues found". No em dashes, no semicolons, no in-sentence
colons. No front-matter flag was touched. `brand_reviewed` and
`lead_approved` remain `false` for the gate to flip.

## 1. The two unverifiable rows, hedged

**Fidelity row 58, the roughly 95% identity threshold.** Rewritten as
guidance rather than a measured fact. The chapter now reads "Published
practice puts that somewhere above roughly 95% identity across most of the
reference's length, which is a working rule of thumb rather than a
threshold LGE checks or enforces." The prior wording implied a testable
line. The paragraph also now says where a reader gets the number, which
reader row 17 asked for and which the rulings require: a mapping run's
summary, by link to `04-alignments/01-mapping-reads-to-a-reference.md`, and
a BLAST hit. No percent-identity procedure was invented.

**Fidelity row 59, MEGAHIT's memory use.** Rewritten as attributed
guidance. "Published guidance is that MEGAHIT uses less memory than SPAdes
on samples of that kind, which is the usual reason people reach for it,
though no measurement in this manual tests that." Reader rows 56 and 72
asked for a memory figure. I did not give one, because none exists in this
campaign. The sentence now says so instead of implying a measurement.

## 2. Front-matter mismatch, fixed by linking

`read-length` is now linked in the body, at "Illumina reads are short, with
a read length of tens to a few hundred bases", which is where the fidelity
review suggested it. I chose linking over dropping because the chapter's
whole second decision question is about read length.

`glossary_refs` was also extended for the anchors the new prose links:
`accession`, `blast`, `gc-content`, `mapper`, `operations-panel`,
`percent-identity`, `shotgun`. Every one of the 23 declared anchors is now
linked exactly once in the body, and all 23 resolve against `GLOSSARY.md`.
I added no `GLOSSARY.md` entries, per role scope. `indel` was considered
for the insertion gloss and rejected, since the plain-words gloss reads
better for this audience than a link.

## 3. Consensus reader rows (38 of 38 applied)

Numbers are `readers.md` table rows.

| Rows | What changed |
|---|---|
| 7, 26 | "What good looks like" item 2 now gives a 10% tolerance and names where to look up a published length. Item 3 gained non-bacterial anchors, one for the mitochondrial fixture and one for a large eukaryotic genome. |
| 8 | Reassemble now says plainly it appears only on bundles LGE assembled itself, and that an imported or downloaded reference bundle has no record and no menu item. Confirmed against `SidebarViewController+MenuDelegate.swift:875-877`. |
| 9 | The scaffold file now says it needs no action from the reader. |
| 10 | The run-folder timestamp is spelled out in year, month, day, then time order, with the ruling's `<tool>-2026-09-07T14-23-10` shape and chapter 32's framing, plus "Nothing there is typed by you." |
| 11, 55 | Kilobases and megabases are spelled out at first use, in the new paragraph before the catalogue table, and explicitly separated from the 950 MB of megabytes above them. |
| 12 | Nonzero exit code is now glossed where a reader meets it, with the Operations panel named, its shortcut given, and the exit code explained as a number where zero means success. |
| 13 | The FASTA topology header now says where it is visible, which is the assembly viewport's detail pane beside the contig table. |
| 14 | Applied the arithmetic ruling. One paragraph now states each figure once with what it compares. 127 is SPAdes against SKESA. 128 is SPAdes against the 16,569-base reference. Both named explicitly so they cannot read as a contradiction. |
| 15 | Thinned is glossed as reads discarded at random to reach a depth, and 300-fold is called far more than assembly needs. |
| 16 | Error rates now carry a comparison. Illumina and PacBio HiFi under one per hundred, Nanopore a few per hundred, plus what that costs, which is base-by-base trust in a contig rather than its overall shape. No error-rate consequence was invented beyond that. |
| 17 | See section 1 above. |
| 18 | The Run Mode picker is now called disabled, with what it shows and why. |
| 19 | Named two concrete header-rewriting steps, trimming or filtering, plus a colleague renaming reads. |
| 20 | Applied the genome-size ruling. Points at NCBI's assembly record, and at **Total Length** in the Inspector for a reference bundle already held. That Inspector label is confirmed at `DocumentSection.swift:841`. No lookup procedure was invented. |
| 21 | The sidebar step is now described to the end. What a FASTQ bundle looks like as a row, that it sits under `Imports`, that a paired sample is one row not two, and that you click once to highlight. Kept as prose, not a numbered step, since a concept chapter carries no Procedure section. |
| 22 | Applied the Plugin Manager ruling in chapter 33's wording: **Packs** tab, the Genome Assembly card, **Install All**, and a link to `01-foundations/07-plugin-packs.md`. |
| 23 | Applied the ruling. The 950 MB stays with its "roughly" hedge, per fidelity note 5, and no download time was added. |
| 24 | "Discards most of the reads" replaced with the same "more than half your reads unaligned" threshold used later, so both places match. |
| 25 | Repeat glossed at first use, with why a read must span it to bridge it, and what branching looks like in the data (two reads matching the same end). |
| 27 | The four mappers each get one clause. minimap2 for long reads, BWA-MEM2 and Bowtie2 as established short-read mappers, BBMap as tolerant of divergence. Linked to the mapping chapter for the choice. Viral Recon stays omitted, per fidelity note 2. |
| 28 | `N` glossed as a base whose identity is unknown. |
| 29 | bp spelled out as base pairs at its first use in the summary strip. |
| 30 | "Drift" and "junk" replaced. The chapter now says every assembly picks up a scatter of short, low-value contigs and that this is ordinary. |
| 31 | Applied the worked-N50 ruling. The three contigs of 16,711, 362, and 332 bases from the sibling chapter's MEGAHIT run are used, attributed to that run by link. The rule is also stated once without the metaphor, ahead of the procedure. |
| 32 | New paragraph. Run time is not a check on a result, with the 110.7-second figure quoted once per the ruling, and one sentence on how run time scales. |
| 33 | GC content glossed once, with its one use, which is spotting a contig that came from a different organism. |
| 34 | 9,958 given as read pairs per the ruling, with 19,916 individual reads stated alongside. |
| 35 | Applied the ruling. The worked example now answers the three questions in the order they were asked. |
| 36 | Added the clause that instruments stamp identifying marks into each read's first line. |
| 37 | Contiguous and conservative both glossed in a new paragraph before the table, where they are first used. |
| 38 | Pinned glossed as fixed to one version. |
| 39 | Shotgun glossed in the table row and linked. |
| 40, 65 | hifiasm is lower case throughout the body per the ruling, including the catalogue table row. One sentence records that the menu item and picker read Hifiasm and are the same tool, since `AssemblyTool.swift:22` gives that literal label and the entry points and shot captions must keep it. |
| 41 | The paired-end gloss moved forward to its true first use, in "Why you would do this". |
| 42 | Reference bundle glossed at first use, and downstream replaced by naming the three things it meant. |
| 43 | A bundle is now stated plainly as a folder of files LGE treats as one item, per the ruling's wording. |
| 44 | The assembly graph is now said to be a network of pieces joined by their overlaps rather than a plot or chart, and "walks that graph" is replaced by tracing paths. |

## 4. Other reader rows applied

Rows 45 (a coverage figure and where to read Read Count, confirmed at
`DocumentSection.swift:1002`), 46 ("the picker narrowed its choices"), 47
(the `Assemblies/` sentence recast as reassurance rather than a bare
negation, keeping the CONSISTENCY ruling at line 80), 48 (wall time
glossed, and which runs carry it stated plainly), 49 (threads glossed in a
few words), 50 (the genome length is now in the same sentence as the 0.8%),
51 (fixture glossed and located), 52 (FASTQ bundle versus assembly bundle
separated by an explicit note), 53 (hit glossed), 54 (the "v1" in the two
quoted strings explained once as the app's own wording, with the quotes
left verbatim per fidelity note 4), 57 (coverage glossed at its true first
use), 58 (insertion glossed and the sentence recast), 59 (coordinate system
glossed), 60 (points forward to the counts), 61 ("small" dropped), 62 (the
shared `.lungfishref` extension explained as deliberate), 63 (`Analyses/`
called a sidebar folder), 64 (BLAST named at the contaminant case), 66 (the
two sentences merged so the Readiness panel reads as the check), 67 ("Two
assemblers are missing that people often expect"), 68 (Nanopore's reads
described where Canu is mentioned), 69 (unavailable tools stated as absent,
not greyed out), 70 (picker glossed as a row of buttons), 71 (where to find
the instrument), 73 (stool or swab named), 74 (isolate glossed in the table
row), 75 (NCBI accession named and linked), 76 ("write out" for "emit"),
77 (double negative removed), 78 (Genome in a Bottle expanded), 79 (the
caution added to the catalogue table row and the paragraph under it), 80
(the half clause on why a contig cannot exceed its genome), 81 (share said
to be of total assembled bases), 82 (preview said to be 80 bases, confirmed
at `AssemblyContigCatalog.swift:359`), 83 (the action bar named as the only
route), 84 (the exact string quoted, from `AssemblyResultViewController.swift:26`),
85 (an opening line saying this chapter decides and the next runs), 86 (the
check named as needing a trial mapping), 87 (the sentence split in three),
88, 89, 90, 91, 92, 93, 94 (all idiom and parsing fixes as suggested).

## 5. Rulings applied

- **MEGAHIT.** The same one-paragraph caution now appears in both places
  the ruling names, the catalogue table's MEGAHIT row (as a pointer) with
  the full paragraph immediately under the table where MEGAHIT is first
  recommended, and again in "Two assemblers on the same human reads" in a
  one-sentence recap. It says the tool fails most runs on Apple Silicon in
  this release, that the failure is a nonzero exit in the Operations panel
  with no contigs written, that a completing run is correct, and that
  rerunning is the only workaround. The sibling reviewer's drafted wording
  was used where it fits. The author's narrower "aborts at k=99 with
  SIGABRT" claim is gone, as the sibling review asked. The chapter does not
  say the two-thread cap fixes it. It says the workarounds are applied and
  the failure still occurs.
- **SPAdes wall time.** The fixture's 13.7 seconds stands, attributed to
  the fixture's committed run. The 110.7-second figure appears exactly once,
  in the new run-time paragraph, attributed to another author's run on a
  busy machine, with the point that runtime is not a check on a result.
- **127 against 128.** Each figure stated once with what it compares, in
  one paragraph, with both comparisons named explicitly.
- **Numbers.** No genome-size lookup, percent-identity procedure, mapping
  discard percentage, or error-rate consequence was invented. Genome size
  points at NCBI's assembly record and the Inspector's Total Length.
  Percent identity points at a mapping run's summary and at BLAST. 9,958 is
  given as read pairs. 950 MB carries no download time. The worked N50
  example uses the sibling's three contigs, attributed.
- **Sidebar and Plugin Manager.** Both described to the end, the latter in
  chapter 33's wording.
- **Glosses at first use.** All the listed terms are glossed where the
  reader first meets them. hifiasm is lower case in the body throughout.
  The worked example answers its three questions in order.
- **App defects.** Each is disclosed in one sentence where the reader meets
  it. The MEGAHIT defect at the catalogue and again at the comparison. The
  locked Run Mode picker where multi-bundle selection is described. The
  clean-run-no-contigs outcome where results are described and again in
  "What good looks like".

## 6. Left for the gate or for another role

- **`brand_reviewed` and `lead_approved` stay `false`.** The gate flips
  them, per the task.
- **Three shots remain uncaptured.** `assembly-submenu`,
  `assembly-sheet-assembler-picker`, and `assembly-bundle-in-analyses` all
  need the Screenshot Scout. The fidelity review's note for the Scout, that
  the picker must be captured from a detected Illumina bundle so it shows
  three segments rather than five, still stands. I did not change the
  captions, which the fidelity review found accurate against source. The
  captions keep "Hifiasm..." because that is the literal menu title
  (`AssemblyTool.swift:22`), and the body now explains the two spellings.
- **The illustration** `assembly-vs-mapping` is referenced and its brief is
  unchanged. Not in this role's scope.
- **App defect 2 from the fidelity review**, the dead
  `AssemblyTool.analysisDirectoryPrefix` with a misleading doc comment,
  is an engineering item with no reader-facing surface. Nothing in the
  chapter documents it, and nothing was added. It needs a code change, not
  a prose one.
- **The MEGAHIT defect needs an engineering decision.** The chapter now
  discloses it honestly in both places, but a menu item that fails four
  runs in five is a product question beyond this pass.

## 7. Facts I could not source

- **A memory figure for any assembler on any sample.** Reader rows 56 and
  72 both asked. Nothing in the campaign's scratch runs, the fixture's
  committed outputs, or the source records peak memory, so the chapter
  names memory as a cost and says no measurement here tests it rather than
  inventing a number.
- **A download time for the 950 MB pack.** Reader row 23 asked. The
  manifest value is `estimatedSizeMB: 950`, an estimate rather than a
  measured install per fidelity note 5, and download time depends entirely
  on the connection. Per the ruling, no time was given.
- **The coverage figures in the closing paragraph**, about 30-fold workable
  and below 10 a struggle, are conventional short-read assembly practice
  rather than anything measured in this campaign. They are stated as
  guidance in the same register as the 95% identity rule of thumb. If the
  gate wants them sourced or dropped, that is a one-sentence change.
- **The "about 3,100 Mb" human nuclear genome figure** used for scale is
  standard published practice, not an LGE measurement. The Inspector
  preview at `InspectorView.swift:1419` carries 3,088,286,401 for GRCh38,
  which is consistent, but that is a preview fixture rather than a claim
  the app makes to a reader.
