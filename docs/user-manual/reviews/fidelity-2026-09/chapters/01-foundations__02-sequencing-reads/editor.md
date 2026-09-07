# Editor pass: 01-foundations/02-sequencing-reads.md

Date: 2026-09-06
Editor: brand-copy-editor

Inputs applied in order. `fidelity.md` (rows 37, 42, 43), `readers.md`
(every row hit by two or more readers, plus single-reader rows whose fix is
one sentence), `CONSISTENCY.md`, the chapter template in
`docs/user-manual/STYLE.md`, and the campaign prose rules.

`brand_reviewed` and `lead_approved` both remain `false`.

## Changes

| Location | Change | Reason | Source |
|---|---|---|---|
| Frontmatter, `glossary_refs` | Added `sra`, `variant-caller`, `simplex-read`, `duplex-read` | Four new inline glossary links were added in the body, and every body link must resolve to a declared ref | readers |
| What it is, para 1 | Rewrote the opening to say the read is the data the instrument wrote down and that the molecule itself is gone | Readers could not tell whether a read is the molecule or the record of it | readers |
| What it is, para 1 | Glossed "noisy" as containing errors, and replaced "stacking those guesses until they agree" with the literal comparison of many reads over one position | Both phrasings were read literally or needed a second pass | readers |
| What it is, para 2 | Added that plain text means ordinary readable characters openable in any text editor, and that you will not normally open one by hand | Readers did not know whether they could open a FASTQ in a word processor | readers |
| What it is, para 3 | Glossed "fixture" as the example dataset shipped with the manual, and "slice" as a region of data rather than tissue | Both words were used throughout without definition | readers |
| What it is, para 4 | Moved the "So what should you do with this" advice to the end of the chapter and rephrased as a plain closing sentence | The advice arrived before the practices it referenced were explained | readers |
| Why you would do this, para 1 | Gave variant call, assembly, and classification a half-sentence gloss each at first use | Three outputs named in succession with none defined | readers |
| Why you would do this, para 2 | Added a clause explaining Genome in a Bottle as a reference-materials project supplying human samples with known answers | The project name was used as if already known | readers |
| Why you would do this, para 2 | Attributed the 250 and 10,000 base figures to the short-read and long-read fixtures | Readers could not tell if the numbers were fixture-specific or general | readers |
| Why you would do this, final line | Replaced the unrendered `{{ fixtures_refs \| cite }}` placeholder with the actual provenance and licence sentence, pointing at each fixture's `README.md` for the full citation | The placeholder rendered on the page as raw template braces | readers |
| Before you start, project sentence | Kept the two fixed CONSISTENCY sentences verbatim and added that a project is an ordinary folder on disk LGE manages, and that the menu route and the Welcome window route do the same thing | Readers did not know what a project was, or whether Cmd-N was required | readers, consistency |
| Before you start, download sentence | Kept the fixed fixture-download sentence and added two sentences on saving a single file from a GitHub file page | Readers did not know how to download one file from GitHub | readers |
| Before you start, long-read sentence | Gave the HG002 long reads their own paragraph with a full GitHub URL and said explicitly that they need not be downloaded | The template requires the fixture link, and readers were unsure whether both fixtures were needed | readers, template |
| Before you start, final para | Said the downloaded files simply wait on disk until the import chapter, and glossed plugin pack and Docker Desktop as optional extra installs some later chapters need | Readers had no instruction for the downloaded files, and the reassurance read as a warning of a future requirement | readers |
| The four-line FASTQ record, lead-in | Said the second record is an arbitrary choice, and that the block is four lines even though the long lines wrap on screen | Readers wondered whether the first record was special, and the wrapping obscured the line boundaries being taught | readers |
| The four-line FASTQ record, line 1 | Replaced the six-name prose list with a table mapping each of the seven colon-separated header values to what it names | Prose named six fields while the example showed seven values | readers |
| The four-line FASTQ record, line 1 | Changed "no two reads in a file" to "no two reads within one file" | Readers hit an apparent contradiction when two mates later shared a header | readers |
| The four-line FASTQ record, line 2 | Added that an N means no call was made, which differs from a wrong call, and that a wrong call still reads as a normal base | Readers could not tell whether an N is an error they must fix | readers |
| The four-line FASTQ record, line 3 | Added a forward pointer to the Phred quality scores section | The remark about quality characters resembling bases only makes sense after that section | readers |
| The four-line FASTQ record, closing para | Added that 45,574 is a deliberately small teaching slice and that a real run holds tens or hundreds of millions of reads per file | The count had no comparison point | readers |
| Compressed FASTQ files, para 1 | Compared the 22,662,846 bases to the 500,001 bp region, giving the roughly 45-fold ratio | The number had nothing to compare against | readers |
| Compressed FASTQ files, para 3 | Said unzipping is optional and no step in the manual requires it, and named double-clicking in the Finder as the way to do it | Readers were unsure whether unzipping was required and how to do it | readers |
| Paired-end reads, para 1 | Introduced "mate" at first use, and said the two reads may overlap, meet, or leave a gap | "Mate" was used before introduction, and readers could not tell whether mates always touch | readers |
| Paired-end reads, para 1 | Glossed reverse complement where the illustration caption first uses it | The caption used the phrase and the body never explained it | readers |
| Paired-end reads, SRA para | Expanded SRA at first use to Sequence Read Archive with a one-clause gloss, linked to the glossary | SRA was never expanded anywhere in the chapter | readers |
| Paired-end reads, new para after the header block | Added that mates need not be the same length and that unequal lengths are ordinary | Readers could not tell whether 250 against 249 signalled trouble | readers |
| Paired-end reads, pairing para | Replaced "Pairing earns its keep twice" with "Pairing is worth the extra file for two reasons" | Idiom softened toward a calm, precise register | style |
| Paired-end reads, pairing para | Glossed variant caller at first use and explained that the two mates are one piece of evidence from one fragment rather than two independent ones | The term was used as if known, and the double-counting logic did not follow | readers |
| Paired-end reads, closing para | Pointed at the Reads card of the FASTQ viewport as the check that both files arrived whole | Readers were warned about split pairs with no way to check their own files | readers |
| When the mates overlap | Glossed amplicon library, deferred the design to the amplicon chapter, and said insert size is reported after mapping | Amplicon library was used before definition, and readers had no way to find their own insert size | readers |
| When the mates overlap | Described `bbmerge` as an external tool LGE installs and runs on the reader's behalf | The tool name was given with no indication of what it does or whether it must be installed | readers |
| When the mates overlap | Dropped "independent" from "two independent reads of the same base" | The two mates were described as independent evidence three paragraphs after saying they are not | style |
| Interleaved FASTQ | Replaced the vague "several read processors accept it" with the concrete condition, a downstream assembler or mapper wanting one input file | Readers could not tell which tools were meant | readers |
| Interleaved FASTQ | Added where Merge Overlapping Pairs, Interleave, and Deinterleave are reached, the Operations tab of the FASTQ viewport | Readers could not tell where in the app the named operations live | readers |
| Phred quality scores, para 1 | Put the plain-language rule first, stated the table alone is enough, and moved the `Q = -10 * log10(P)` formula to its own later paragraph marked optional, with P stated as a number between 0 and 1 | The formula preceded the plain-language version, and P's range was unstated | readers |
| Phred quality scores, new para after the table | Stated plainly that Q30 is the threshold and Q40 the practical ceiling | Readers could not tell which of the two was the value to judge against | readers |
| Phred quality scores, Phred+33 para | Glossed ASCII as the standard numbering that gives every keyboard character a number, with two worked examples | ASCII was never explained, so readers could not decode a character | readers |
| Phred quality scores, worked example para | Placed Q35 explicitly between the Q30 and Q40 table rows before giving the 1-in-3,000 figure | The table listed only round tens, so the figure could not be derived | readers |
| Phred quality scores, tools para | Said what `fastp`, BWA-MEM2, and `minimap2` each do and that LGE installs and runs them | The tools were named with no explanation and no statement about installation | readers |
| Read length and platform differences, para 1 | Replaced "fences in" with "limits" and "tuned for" with "written for" | The idiom was unfamiliar to a reader | readers, style |
| Read length and platform differences, new para under the table | Glossed simplex and duplex in one sentence each, linked to the glossary, and said Ion Torrent appears for completeness and does not return, since every worked example uses one of the other three | Both terms were undefined, and readers could not tell whether Ion Torrent is used again | readers |
| Read length and platform differences, comparison para | Signalled the switch from the chromosome 20 slice to the mitochondrial genome and gave the reason | The chapter changed genomes with no signal | readers |
| A nanopore read, para 1 | Glossed UUID as a randomly generated name unlikely ever to collide | UUID was never expanded | readers |
| A nanopore read, para 1 | Showed the 40 minus 33 arithmetic and placed Q7 just below the Q10 row before giving the 1-in-5 figure | The table's round tens gave readers no way to derive the figure | readers |
| A nanopore read, N50 | Split N50 into its own paragraph with a definition sentence and a two-read worked example | The definition arrived in a trailing clause readers had to reread | readers |
| A nanopore read, closing para | Explained at first mention why the fixture's Q7.9 sits below the Q12 to Q20 range, and expanded "errors are largely independent" into the voting argument | Readers could not tell whether the fixture was broken, nor why independence lets stacked reads correct each other | readers |
| A nanopore read | Replaced "the trick that makes HiFi work" with "the method that makes HiFi work" | Calmer, more precise register | style |
| A HiFi read, new para after Q93 | Said plainly that the Phred scale runs past Q40, that Q40 is the ceiling of a single Illumina measurement, and that Q93 is a consensus confidence | Q93 fell past every table and readers could not judge whether it was real | readers |
| A HiFi read, numbers para | Said the `~` characters are the high end of one strong read while Q29 averages every base including weaker read ends | A Q93 read beside a Q29 average looked contradictory | readers |
| A HiFi read, numbers para | Replaced "HiFi buys most of nanopore's length" with "HiFi reaches most of nanopore's length while holding Illumina's per-base accuracy" | Commercial register softened toward the brand voice | style |
| How LGE shows a read set, new opening para | Said the section describes what appears once reads are imported, that importing has its own later chapter, and to come back and click through after | A reader who had not reached the import chapter could not perform any step here | readers |
| How LGE shows a read set, viewport para | Glossed bundle as LGE's container holding one sample's R1 and R2 files with a record of where they came from | Bundle was used repeatedly without definition | readers |
| How LGE shows a read set, cards para | Replaced the one-paragraph run of nine card names with a five-row table of card and meaning | Readers lost track of the cards partway through the list | readers |
| How LGE shows a read set, cards para | Gave a typical human GC figure near 41% and said a far-off figure often means contamination | GC content was defined with no value to compare against | readers |
| How LGE shows a read set, cards para | Stated that all nine cards scan the whole bundle and only the Reads table is windowed | Readers could not tell whether the cards were also limited to 1,000 records | readers |
| How LGE shows a read set, sparkline para | Glossed sparkline as a small chart drawn without axes or labels | The term was never glossed | readers |
| How LGE shows a read set, sparkline para | Replaced "Click any of the three to open it full size in a popover" with the corrected wording, the length chart opens a popover while the two quality charts read Click to Compute and start the report instead | Fidelity row 37, marked false | fidelity |
| How LGE shows a read set, final para | Replaced "The Operations tab offers Compute Quality Report" with the corrected wording naming the Operations tab's category list, QC & Reporting, and Refresh QC Summary, plus the quality-chart shortcut | Fidelity row 42, marked false. No control is labelled "Compute Quality Report" | fidelity |
| How LGE shows a read set, final para | Named `lungfish-cli fastq qc-summary` as the command that computes the same JSON quality summary, and added that the buttons above do everything this chapter describes without a terminal | Fidelity row 43, settled by the project manager. Also answers the reader who found "available from the command line" a dead end | fidelity, readers |
| How LGE shows a read set, final para | Said which figures appear immediately on import and which wait for the report | Readers could not tell which numbers needed a report | readers |
| What good looks like, para 1 | Said up front that the first three numbers come from the FASTQ and that coverage can only be measured after mapping | Coverage was promised as one of four numbers judged from the read set but requires a step the chapter has not covered | readers |
| What good looks like, read count para | Gave the rule connecting read count and read length to genome size before the two example targets | The two targets were given with no rule connecting either to genome size | readers |
| What good looks like, read length para | Said the short reads in the tail are the ones trimming cut hardest and a small tail is expected | Readers could not tell whether the 50-base minimum was a problem | readers |
| What good looks like, coverage para | Stated once that this manual uses depth as a synonym for coverage | The two terms were used interchangeably with no note | readers |
| What good looks like, coverage para | Explained the x notation as each base being covered about that many times on average | The notation was never explained | readers |
| What good looks like, coverage para | Glossed small variants as single-base changes and short indels, and gave 20x to 30x as the working minimum with below 10x as untrustworthy | The term was never glossed and no depth threshold was given | readers |
| What good looks like, final para | Named the three numbers to ask a sequencing provider for | The advice named no specific numbers to request | readers |
| What good looks like, new closing sentence | Placed the three practices from the old "So what should you do with this" paragraph here | Same row as the What it is move above | readers |

## Left unchanged, deliberately

Reader row 65 (LGE named before its definition is easy to notice) needed no
fix by the reader's own account, and the first mention now sits in the
Before you start section where the chapter first asks the reader to open the
app.

Reader row 73's alternative wording for the summary bar and the summary
cards was resolved by the new card table rather than by renaming either.
The bar is the container and the cards are its contents, and the text now
says so.

Reader row 24 asked for the Phred table to be moved above the formula. The
table already sat above the formula's original paragraph. The formula moved
below the table instead of the table moving, which keeps the section order
intact and is not a structural edit.

Reader row 44 asked the chapter to say whether LGE handles Ion Torrent
reads. `fidelity.md` does not settle that, and no source available to this
pass does either, so the chapter now says only that Ion Torrent appears in
the table for completeness and does not return, which answers the reader's
actual confusion without asserting a support claim. If the Documentation
Lead wants the support statement, it needs a source check first.

Two reader-suggested sentences were rewritten to avoid asserting facts no
review verified. Row 67 asked what in LGE flags a mismatched pair, and row
23 asked whether `bbmerge` must be installed. The chapter now points at the
Reads card as a check the reader can perform, and describes `bbmerge` as a
tool LGE installs and runs rather than claiming it ships preinstalled.
Neither claim is in `fidelity.md`, so the wording was kept to what is
demonstrably safe.

The FASTQ record blocks, the header identifiers, all quoted counts, sizes,
lengths, N50s, quality averages, and the mapping figures are untouched.
`fidelity.md` marks every one of them true.

## Lint

`LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh`
was NOT executed on this pass. This role runs with Read, Write, and Edit
tools only and has no shell, so the command could not be invoked. The
chapter was instead checked by hand against every rule the linter loads
from `build/scripts/lint/.remarkrc.mjs`, reading each rule's source.

- `em-dash`, `semicolon`, `sentence-colon`. No em dash, no semicolon, and
  no colon anywhere in prose. The three tables and the five fenced blocks
  each follow a lead-in that ends in a period.
- `ai-tells`. Every added sentence was checked word by word against
  `rules/ai-tells-words.txt`, allowing for the rule's suffix expansion.
  No entry matches. The pre-existing "bear" in "The numbers bear it out"
  is explicitly excluded by a comment in the word list.
- `app-name`. "Lungfish Genome Explorer" appears once, in Before you
  start, ahead of every "LGE". No bare "Lungfish" in prose. The
  `lungfish-cli` command and the GitHub URLs sit in inline code or are
  followed by a hyphen, both of which the rule exempts.
- `bullet-cap`. The chapter has no bulleted or numbered lists at all.
  Two of the three tables were added by this pass in place of prose runs
  the readers lost track of, and a table is not a list under the rule.
- `voice`. No banned marketing term and no sentence-terminal `!` in prose.
  The `!` in the Phred anchors is inline code, which the rule skips.
- `palette`, `typography`, `data-viz`. No hex value, no font name, and no
  vega block anywhere in the file.
- `frontmatter`. Both declared shot ids still have their markers and no
  marker is undeclared. The four `glossary_refs` added by this pass
  (`sra`, `variant-caller`, `simplex-read`, `duplex-read`) each resolve to
  an existing anchor in `GLOSSARY.md`, at lines 277, 299, 271, and 87.
- `primer-before-procedure`, `settings-coverage`. Not applicable. The
  chapter opens on `## What it is`, has no `## Procedure`, and carries an
  empty `parameters_refs`.

The Documentation Lead should run the command before accepting this
chapter, since a hand check cannot substitute for the linter.

## Screenshots

Neither `fastq-viewport-summary-cards` nor `fastq-viewport-reads-tab` has
been captured yet, so the two captions could not be checked against
images. Both captions were left as written and agree with the
source-verified facts in `fidelity.md` rows 32, 35, and 39, nine cards
above three charts and the five Reads columns. Recheck them once the
screenshots exist.

## Structural note for the Documentation Lead

The chapter has no `## Procedure` section and none of the template's
Settings, Reading the results, or On the command line sections. That is
correct for a concept chapter, and `parameters_refs` is empty to match.
The CONSISTENCY "Before you start" fixed sentences are present verbatim and
adjusted to this chapter's two fixtures, even though this is not a
procedure chapter, because the section already carried them.

`docs/user-manual/fixtures/hg002-chr20/README.md:78` still says "91,203
total reads (45,614 read pairs)", which `fidelity.md` shows is stale
against the committed files. That correction belongs to the fixture owner,
not to this chapter, and the chapter's 45,574 figure is left as is.

## Status

brand_reviewed: false
lead_approved: false
