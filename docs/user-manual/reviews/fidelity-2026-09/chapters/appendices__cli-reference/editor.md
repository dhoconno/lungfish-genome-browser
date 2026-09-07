# Editor record, appendices/cli-reference

Chapter: `docs/user-manual/chapters/appendices/cli-reference.md`
Roster row 57. Editor pass date: 2026-09-07.
Inputs applied in order: `author.md`, `fidelity.md` (62 claims, 1 false, 7 notes),
`readers.md` (192 merged rows, 79 in Consensus), `CONSISTENCY.md`.

## The false claim

Fixed in both places the reviewer named.

The old chapter said `fastq ont-barcode-genotype` is deprecated "so prefer
`ont-genotype`" (line 283) and repeated it in Known defects as "new work should
use `ont-genotype`" (line 433). The live help text names neither. I confirmed
it myself by running `lungfish-cli fastq ont-barcode-genotype --help`, which
reads "Deprecated: demultiplexing now belongs in FASTQ import recipes. Use
those recipes to create per-sample .lungfishfastq bundles, then run
`lungfish-cli fastq genotype` or `lungfish-cli fastq genotype-cohort`."

Both sites now say the help text directs you to build per-sample
`.lungfishfastq` bundles with a FASTQ import recipe first, then run
`fastq genotype` or `fastq genotype-cohort` on those. The FASTQ subcommand
table also carries the command with a "Deprecated" row, closing the separate
reader row about the command appearing from nowhere.

Two reviewer notes applied alongside it. `--symbols` now carries its `strict`
default, which I confirmed by running `lungfish-cli align mafft --help`
("Symbol policy: strict or any (default: strict)"). The EcoRI example now
carries the palindrome note, saying the six matches are three positions each
reported once per strand.

No other claim was changed. Every fact in the chapter that the reviewer marked
true is still stated as it was verified, and I ran no operation.

## Project manager rulings

**(a) Before you type anything.** New H2 immediately after What it is and
before Finding the program. Fourteen sentences. It says commands are typed
into Terminal at **Applications > Utilities > Terminal** or via Cmd-Space,
that a command runs in whatever folder the window is sitting in, gives the
one-line `cd` with the drag-the-folder trick in the wording the committed
chapters use (`06-human-germline-variants/04-reference-packs.md:65`), and
gives the one line that makes the bare name work for the rest of the session,
`export PATH="/Applications/Lungfish Preview.app/Contents/MacOS:$PATH"`, with
a following sentence saying why the quotation marks are needed.

**(b) Notation key.** New H2, "How the syntax lines are written", one table of
six rows covering `<value>`, `[optional]`, `a|b`, `{a | b}`, `<arg>...`, and
the trailing backslash, plus one sentence on the menu-item trailing ellipsis.
Every syntax line in the chapter is now readable from it.

**(c) Window route per section.** Every domain section now opens with one
sentence naming the window route and its chapter, or saying there is none. The
seventeen such sentences cover Global flags (no equivalent), Downloading
records, Importing into a project, Reference bundles, Mapping, Calling
variants, Classification, Extracting, Assembly, FASTQ operations, Sequence
utilities (mostly none), Alignment and phylogenetics, Workflows, Tool packs,
Provenance (three commands have none), ONT genotyping, and Diagnostics (none).
The Plugin Manager mention is no longer the only place a dialog equivalent
appears. All nineteen cross-chapter link targets were checked on disk.

**(d) Unobtainable inputs.** The Reference bundles section names
`NC_012920.1.fasta` as the human-mito fixture with the GitHub fixtures link,
and Sequence utilities names `NG_000007.3.gb` as the HBB gene record with the
same. `mt-nd1.fasta` is identified as the output of the `extract sequence`
example above it. `--alignment-track <track-id>` in the variants example is
now a real-looking id with a sentence naming `bundle list --tracks` as where
ids come from. `--medaka-model` names its source and gives an example id.
`--taxon` says the id comes from the classifier's own report.
`--database-id` names `conda db install-managed --list`. `--project` shows a
real project path.

**(e) Two paragraphs became tables.** The `fastq` subcommand paragraph is now
a 38-row table, one row per subcommand with a short phrase, replacing the
"five lanes" prose. The `extract reads` mode paragraph is now a four-row
table, one row per mode with its own flags in a third column. Three further
paragraphs became tables under the same reasoning, since the readers made the
same complaint about them: the nine `import application-export` kinds, the
`import fastq` flag set, and the `tools update` exit statuses. The bullet cap
does not apply to tables.

**(f) Coordinate conventions.** Stated once in the notation key, naming all
three (1-based inclusive, 0-based half-open, 1-based alignment columns) and
saying they differ because each command matches the tool it wraps. Repeated in
one clause at `extract sequence`, at `extract reads --by-region`, at
`sequence annotate-orfs`, and at `tree infer --columns`.

**(g) Numbers with scale.** Mapping quality gets its 0 to 60 range and 20 as
a common cutoff. ALT_QUAL gets the same scale with 20 meaning one in a
hundred. Phred gets 20 and 30 explained. GC content 39.5% is set against the
human genome average of about 41%. N50 gets a worked explanation and the note
that the single-record example makes every statistic equal. Bracken read
length is named as bases and told to match your own reads. BLAST confirmation
counts are read out of 20. Where no committed chapter gives a scale I said the
value is the tool's default and left it alone, which covers the vsearch word
length of 12 and dust masking ("both defaults are fine to leave alone"), the
`--min-length` of 100, and the Bracken threshold of 10. I invented no
threshold. The one number I supplied from outside is `--memory-gb`, where I
said 32 is a reasonable start for a bacterial or viral genome rather than
naming it as a tool default.

**(h) Binary path.** The fixed opener is not used, correctly, since this is not
a procedure chapter. The path
`/Applications/Lungfish Preview.app/Contents/MacOS/lungfish-cli` is written
word for word as the CONSISTENCY ruling and the two committed chapters
(`06-running-in-ci.md:29` and the old text here) give it, now with the quoting
the readers asked for.

**(i) Reference shape kept.** No Settings entries, no operation template, no
Before you start. The flat index, the domain sections, and the two closing
sections are all where they were.

## Reader rows applied

All 79 Consensus rows applied. The remaining 113 merged rows: 108 applied,
5 skipped. Grouped by the chapter-wide fixes that closed many at once.

**Closed by the Before you type anything section (18 rows).** Never learned
where to type a command. Terminal never named. No first worked command. Shell
used to explain PATH. PATH offered with no command shown. PATH resurfacing at
Diagnostics unexplained (repeated there too). "Substitute whichever path"
unclear. The space in "Lungfish Preview.app" unquoted. Working directory never
established. "Run from an ordinary folder" with nowhere saying commands have a
current folder. SwiftPM, product, and checkout stacked (now one clause marked
for readers who compile LGE themselves). "Binary" in the heading (section
retitled "Finding the program"). Which of two code blocks is output (now
labelled "Output:", applied to all four such pairs in the chapter).

**Closed by the notation key (7 rows).** Angle brackets, square brackets,
pipes, braces, trailing dots, the trailing backslash, and the `args...`
placeholder style used nowhere else, which is now `<arg>...` throughout.

**Closed by the What it is rewrite (9 rows).** Switch buried inside the flag
definition, now its own sentence and its own glossary entry. Exit status used
from the first extract command with its gloss arriving in Tool packs, now
glossed in What it is. "Three words appear on every page" (now "four terms are
used throughout"). "This appendix is the map of that program" (now says it
lists every command). "No window at all" reading as a limitation (now leads
with anything clickable can be typed). "Interchangeable as evidence" (now a
scripted run is documented as fully as a clicked one). The four terms never
shown together on one line, now an annotated example block. Two hyphens as two
key presses. JSON glossed.

**Closed by the command index rewrite (8 rows).** The 44/44 coincidence now
stated as one. `.lungfish*` extensions glossed in a lead-in with a File
Formats pointer. The reference-bundle definition moved above the index. conda
glossed. "Exposes" replaced. Subcommand counts replaced by named subcommands
on the three rows that only counted. CI, SQLite, de novo, BAM, track, and
micromamba glossed in their rows. What share of the window's operations the
index covers, answered with a pointer to the four-gap section.

**Closed by the section-opener ruling (3 rows).** The dialog-equivalence
question asked once at Plugin Manager. Whether the window has the same MEGAHIT
problem (it does, now said). Whether the Kraken 2 dialog and command differ on
Bracken (now its own sentence).

**Closed by the two mandated tables (8 rows).** Thirty to forty FASTQ
subcommands run together. The four extract modes in one dense paragraph. Nine
import kinds in one sentence. Fifteen lines of `import fastq` prose. Four exit
statuses in one unordered sentence. Six known defects in one paragraph (also a
table). The TaxTriage paragraph. The `--pack` trap, now two labelled example
lines.

**Individual rows applied (55).** Verbosity levels. Threads glossed with a
starting point. "Whatever older copies said" cut. Wrapped tools and
bit-identical rewritten as results differing slightly and that being no error.
The `variants phase --threads` notice moved to Known defects and
cross-referenced, saying plainly the run itself is fine. "Consumed before any
subcommand sees it" split and made explicit that it is silently ignored.
"Sit on the program itself" replaced with typed before the subcommand.
Progress bar "is a terminal" rewritten. British "colour" made American. Fetch
four-versus-five subcommands fixed to five. Nested `sra` subcommands signalled.
HTTP 429 glossed. SRA and ENA glossed. "Falls back" and "refuses" rewritten.
Two-accession example shown. Limit of 20 given context. `--api-key` explained
once. The `GCF_` accession substitution stated outright. Bare import failure
given its error and exit status. CHROM glossed. Quality binning explained,
value case left as the program spells it since the chapter must match the
program. VSP2, WGS, and HiFi expanded. Clumping glossed. Compression tradeoff
named. Samplesheet example shown with a header row. A classifier import example
shown. "The last" pronoun replaced. kreport glossed. Index glossed. bgzip
rewritten. OCI tarball rewritten leading with what the file is for. `bundle
validate` output shown as a code block. Long syntax lines broken where they
were tables. Mapping quality, presets, read groups, secondary and
supplementary, and coordinate-sorted and indexed all glossed. In-place BAM
rewrite given its own sentences and a keep-a-copy instruction. `@SQ` glossed.
`--min-af` self-contradiction resolved. ALT_QUAL and the bq filter glossed.
Direction of each iVar threshold given. Amplicon glossed. `--execute` leading
the sentence on both `variants phase` and `gatk`. Presets explained. Bracken
glossed. Rank codes spelled out once. `--memory-mapping` given a when.
Confidence values distinguished between Kraken 2 and TaxTriage. Nextflow size
string and its dot shown. Database listing pointed at in the same sentence.
BLAST URL API parameters given a source. Skip-assembly double negative
resolved. Byte-identical rewritten. `--bundle` switch gloss repeated inline.
The two exit statuses 3 and 64 explained as not diagnostic. Source and output
counts said to be files. A parallel human example given beside the viral one.
The two line-width defaults said to differ on purpose. MEGAHIT given a
frequency, an Apple Silicon check, and what a failed run looks like.
`--memory-gb` given a value. `--profile` pointed at its own help for the full
list. Both extra-arg spellings shown side by side. Deterministic two-pass
selection reduced to the plain clause. Word length and dust glossed. Virtual
bundle explained. Deacon glossed with its identifier source. The Phred
two-averages sentence split into three and told which to quote where. 12S and
MHC glossed. ONT expanded. Nx rewritten with the single-record caveat. Reading
frame explained before its first use. The search command shown. Skew glossed.
Symlink and hard link replaced with plain words. Table 2 named at the flag.
Translate output shown with what a wrong table looks like. IUPAC and regex
glossed. BED glossed in the body. All five comparison operators listed. The
query annotated token by token. MAFFT strategies given a when-to-change.
`--symbols` given its default and what each value does. `--keep-identical`
given a reason. MFP expanded. Seed glossed. Bootstrap and aLRT glossed with
usual counts. `--safe` given a when. Column range syntax stated. Workflow,
Nextflow, Snakefile, and nf-core glossed. `--expected-output` said plainly.
`--repeat-from` rewritten to one plain sentence. Bound and unbound replaced.
`workflow list` told what does list project workflows. `conda setup` moved to
the front of its section. Pack pointed at `conda packs` at first mention. The
conda-lock explanation led with what the file is good for. "Byte for byte"
said once plainly. The receipt-failure sentence rewritten. The Plugin Manager
aside given its fix. PHA4GE expanded. Provenance "both halves" named plainly.
Export runnability made checkable. `provenance verify` merged to one sentence.
The eleven `haplotypes` subcommands all named. `.lungfishmhcref` glossed.
`ai-haplotyping` said what it writes and where its flags are documented. The
pivot-workbook conditional split. `--percent-basis` denominators stated.
`debug env` default-subcommand sentence moved to the front. Containerization
glossed. arm64 explained. macOS version check located. Campaign language cut.
"Flat index is the map of that overlap" rewritten. Four gaps stated as the
complete list. Empty Kraken2 report said the run may have completed and found
nothing. The Next pointer's jargon replaced with plain words.

## Rows skipped

Five, each with its reason.

1. **"Show the fetch command that produces each fixture" (all four readers,
   partly applied).** The fixture files are not fetchable, they are manual
   fixtures on GitHub. I gave the GitHub fixtures route instead, which is what
   the CONSISTENCY fixture rule requires, so the row is closed by a different
   fix than the one suggested. Recorded here rather than counted as a skip in
   spirit, but the literal suggestion was not followed.

2. **"Make the `--quality-binning` value names consistent in case" (two
   readers).** `illumina4` and `eightLevel` are the values the program
   accepts. Changing their spelling in the manual would print something that
   fails when typed. Reviewer authority is the help text.

3. **"Show the three classification preset value sets in a small table" (two
   readers).** The numeric values behind `sensitive`, `balanced`, and
   `precise` are not in the help dump, no committed chapter states them, and
   the brief forbids running an operation to find out. Printing invented
   numbers would breach the no-invented-thresholds rule. I pointed at
   `conda classify --help` instead.

4. **"Say roughly how much memory a Kraken 2 database needs" (two readers).**
   Same reason. No committed chapter gives a figure. I said instead when the
   flag is worth reaching for, which is when the database is larger than free
   memory.

5. **"Cut every sentence that says what does not exist" (one reader).** Cut
   two of them, "There is no `--in` or `--out`" and "There is no `--msa` or
   `--out`", since both only restate the syntax line above them. Three stay:
   the absent seed flag on `fastq subsample`, the absent `provenance show`,
   and the absent general `lungfish-cli blast <sequence>`. Each names a
   command or flag a reader would reasonably guess exists and try, which is
   the one case where naming an absence saves a failed run.

Also not applied, for reference-shape reasons rather than as reader rows: I
did not move the `fastq` "common shape" sentence into the opening section as
one reader asked, because the opening now carries the notation key and the
annotated example line, and a third syntax preamble there would push the
command index below three screens of front matter. The sentence was reworded
in place instead, dropping "the common shape is" for "most of them take".

## Brand and style

No em dashes, no semicolons, no colons inside a sentence. Colons appear only
as YAML keys, as lead-ins before a table or code block, and in the "Output:"
labels. No word from `ai-tells-words.txt`. "Lungfish Genome Explorer" at first
mention and "LGE" after. No hex values or font names appear in this chapter,
so the palette and typography checks had nothing to correct. `brand_reviewed`
and `lead_approved` both left false.

## Glossary

One term added. **Switch**, alphabetised into the S block after
`Substitution model`, in the existing one-sentence shape with a `See also:`
line. `JSON` and `provenance sidecar` already existed and were only linked.
`glossary_refs` updated from four entries to seven: command-line flag, exit
status, JSON, positional argument, provenance sidecar, subcommand, switch.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/appendices/cli-reference.md`

```
/Users/dho/Documents/lungfish-genome-explorer/.claude/worktrees/user-manual-fidelity-campaign/docs/user-manual/chapters/appendices/cli-reference.md: no issues found
```

## Status

brand_reviewed: false
lead_approved: false
