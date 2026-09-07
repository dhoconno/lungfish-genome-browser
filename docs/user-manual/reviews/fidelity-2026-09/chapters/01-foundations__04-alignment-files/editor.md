# Editor pass: 01-foundations/04-alignment-files

Date: 2026-09-06
Editor: brand-copy-editor

Chapter edited: `docs/user-manual/chapters/01-foundations/04-alignment-files.md`
Also edited by project-manager ruling: the `CSI` entry in
`docs/user-manual/GLOSSARY.md` (text corrected in place, anchor and
position unchanged).

## Changes applied

| Location | Change | Reason | Source |
|---|---|---|---|
| What it is, index paragraph | Replaced "LGE writes whichever of the two the data requires" with the reviewer's corrected wording, that BAI cannot address a sequence over 512 megabases, CSI covers those, and LGE writes BAI and reads either format | LGE calls bare `samtools index` at every call site and has no BAI/CSI selection logic | fidelity |
| The index section | Replaced "an index beside it, a `.bam.bai` for ordinary references and a `.csi` where..." with "Every BAM LGE writes gets a `.bam.bai` index beside it", and deleted "LGE picks the right one without asking" | Same defect. Every LGE-written index is BAI | fidelity |
| The index section | Added that no human chromosome approaches the 512 megabase limit, chromosome 1 being about 249 megabases, and named wheat and the axolotl as genomes where it bites | Readers could not judge whether the limit ever applies to them (3 hits) | readers |
| The index section | Added that LGE reads a `.csi` arriving beside an imported BAM, so such a file opens without an extra step | Preserves the true half of the deleted claim | fidelity |
| What good looks like, opening line | Replaced "all four are visible in the alignment viewport and the Inspector" with the reviewer's wording naming the mapping results table, the coverage track label, and the Inspector | Mean depth and coverage breadth are not in the Inspector. Its mapping rows carry Mapped, Unmapped, Total Reads, and Mapped Rate | fidelity |
| What good looks like, fourth check | "LGE writes one for every BAM" became "LGE writes a BAI for every BAM it produces and rebuilds a missing index on load" | Same BAI/CSI defect | fidelity |
| `GLOSSARY.md`, CSI entry | Removed the claim that Lungfish writes CSI. Now describes CSI as the format for sequences over the BAI limit and states LGE writes BAI and reads a CSI arriving beside an imported BAM | Project manager ruling. Same error as the chapter | fidelity |
| What it is, second paragraph | Expanded SAM as Sequence Alignment/Map and added that BAM and SAM hold identical information and the reader will never handle a SAM directly | SAM named but never expanded or defined (4 hits) | readers |
| What it is, second paragraph | Said `samtools` is a toolkit of command-line programs that LGE installs and runs behind the scenes, never launched by the reader | Readers could not tell whether to install, click, or ignore it (3 hits) | readers |
| Why you would do this | Glossed 2x250 as two reads of 250 bases read inward from opposite ends of one fragment, not one read of 500 | Notation unglossed (4 hits) | readers |
| Why you would do this | Explained the 500,001 count as an inclusive span from 10,000,000 to 10,500,000 | The count ending in 1 read as a typo and stopped readers (4 hits) | readers |
| Why you would do this | Added two sentences explaining Genome in a Bottle as a NIST reference project and where its answers live | Named repeatedly but never explained (3 hits) | readers |
| Before you start | Deleted "Docker Desktop is not needed anywhere in this chapter" | Docker named only to be dismissed, leaving readers unsure why it appeared (4 hits). Reviewer's shortest fix | readers |
| Before you start | Glossed reference bundle and alignment track, and linked the projects chapter for building and opening the demo project with its two-minute estimate | Both terms and the demo project used as if familiar, with no way to find them (3 hits) | readers |
| Before you start | Located the Plugin Manager at **Tools > Plugin Manager...** (Cmd-Shift-B) and said the Required Setup pack is the one LGE installs itself on first launch and lists at the top there | Required Setup pack capitalised like a proper name but never located (2 hits) | readers, consistency |
| What one row records | Added that optional tags vary by mapper and can be ignored while learning | Named and never explained (4 hits) | readers |
| What one row records | Added a sentence covering RNEXT, PNEXT, and TLEN as the mate and fragment-length fields | Three fields in the example block never covered by the walkthrough (4 hits) | readers |
| What one row records, MAPQ | Added that every 10 points divides the error chance by ten, with 20, 30, and 60 spelled out as one in a hundred, thousand, and million | Readers could not turn MAPQ 60 into a concrete confidence (4 hits) | readers |
| What one row records, FLAG | Said the FLAG is the sum of the numbers whose facts are true and showed 99 as 1 plus 2 plus 32 plus 64 | Readers could not see how one number becomes four facts and had no way to check (3 hits) | readers |
| The CIGAR string | Added that 240 plus 9 is 249, the read's length | The CIGAR numbers did not visibly reconcile with the read length (3 hits) | readers |
| The CIGAR string, table | `I` and `D` rows reworded to share one viewpoint, "Present in the read, missing from the reference" and "Missing from the read, present in the reference" | The `D` row read backwards next to `I` (4 hits) | readers |
| One row is not one read | Replaced "spans a junction" with a plain description of a read aligning in pieces because the halves belong to distant parts of the reference, and gave a large deletion as the concrete case | Junction undefined, and readers who knew "splice junction" could not tell if it was the same thing (4 hits) | readers |
| One row is not one read | Showed the subtraction 91,203 minus 91,148 and said 55 rows is about one in 1,700 and normal | Readers did the arithmetic themselves and could not tell if the gap was a warning (4 hits) | readers |
| Coverage | Said a zoomed-out bar reports the deepest position in its span rather than the average | Readers could not picture whether the bar was a mean or a maximum (3 hits) | readers |
| Coverage | Split the multi-figure sentence into one figure per sentence, each naming what it measures before giving the fixture value | Figures arrived together and readers lost track of which was which (4 hits) | readers, consistency |
| Coverage | Said the 99.99 percent breadth is a rounding of 99.994 | Readers who did the arithmetic got 99.994 and thought they had misunderstood (3 hits) | readers |
| Coverage | Added that the 505 low-depth positions include the 31 with no coverage | Readers could not reconcile the two counts (3 hits) | readers |
| Pileup | Added that sampling noise keeps a real heterozygous site off 0.50 and that most callers accept about 0.25 to 0.75, placing 0.62 inside that band | 0.62 did not look close to 0.5 and no tolerance was given (4 hits) | readers |
| Pileup | Converted "10 percent" and "0.5 percent" to 0.10 and 0.005 to match the dialog's 0.05 | One sentence mixed decimals and percentages (4 hits) | readers |
| Strand | Rewrote the forward and reverse definition to say the mapper flips the read, reading it backwards and swapping each base for its partner, to make it fit | Reverse complement assumed but never connected to what a mapper does (4 hits) | readers |
| Strand | Said the per-strand counts appear in the Inspector when a row in the Variants tab of the table drawer is selected, and gave a rough one-third to two-thirds band | Readers could not find the counts in LGE or judge how far from even is a concern (3 hits) | readers, consistency |
| Steps that reshape a BAM | Added that callers and coverage summaries skip a marked row, so a duplicate stays in the file and stops counting as evidence | Readers could not tell whether marked duplicates still count (3 hits) | readers |
| Steps that reshape a BAM | Named `--ivar-min-length` and its 30-base default in place of "some `ivar trim` options" | The option and whether defaults drop rows were never stated (2 hits) | readers |
| Choosing a mapper | Said the 500 and 6,000 figures are read-length ceilings that LGE checks before a run so an unsuitable pairing is refused rather than failing partway | Readers could not tell what the numbers were or whether the app enforced them (4 hits) | readers |
| Choosing a mapper | Glossed contig at its first use as a stretch built by joining overlapping reads | Contig used more than once with no gloss (3 hits) | readers |
| Choosing a mapper | Glossed checksum inline as a short fingerprint from a file's exact contents | Computing term used with no gloss (2 hits) | readers |
| Long reads and short reads | Added that the choice among callers is taken up in the variant-calling chapters | Five caller names arrived with no way to choose (4 hits). Reviewer's second option, which adds no unverified fact | readers |
| What good looks like, mapped fraction | Added the band above 95 percent as healthy and 80 to 95 as a close-but-inexact reference or foreign DNA in the library | The chapter gave 99.77 as good and 80 as bad with nothing in between (4 hits) | readers |
| On the command line | Replaced "the repository root" with the top folder of the project's source code, the one holding the `docs` folder | "Repository root" means nothing to a reader who has never opened a terminal (4 hits) | readers |
| On the command line | Explained the trailing backslash as a line-continuation character and said to type it or paste the block whole | Backslashes unexplained (2 hits) | readers |
| On the command line | Broke the `lungfish-cli bam` sentence into a four-item list, one subcommand per line | Several capabilities packed into one sentence (4 hits). Four items and one list, inside the five-per-list and two-per-section caps | readers, style |
| Why you would do this | Reordered the 2x250 gloss to sit with the reads sentence and folded the 500,001 explanation into the reference sentence | The inserted glosses split two related facts apart | style |
| Why you would do this | Split the Genome in a Bottle definition into two sentences and cut it to the calmer cadence | One long definitional sentence opened the paragraph | style |
| What one row records, FLAG | Reworded "Each fact owns one number" to "Each fact is assigned its own number... the sum of the numbers whose facts are true" | Whimsical phrasing against the precise-and-scientific voice quality | style |
| What one row records | "Take the four fields that carry the most meaning one at a time" became "The four fields that carry the most meaning are worth taking one at a time" | Awkward imperative following the new mate-field sentence | style |
| Coverage | Recast the figure sentences into the consistency sheet's shape, naming what each figure measures before giving the fixture value | Five stacked figures read as a list in prose | style, consistency |
| What good looks like, mapped fraction | Tightened the 80 to 95 band into one sentence carrying both causes and the verdict | Four consecutive threshold sentences read as a list in prose | style |
| On the command line | Compressed the backslash explanation from three sentences to two | Four sentences of preamble stood between the section opening and the code block | style |
| Before you start | Reworded the link to the projects chapter so its title's bare "Lungfish" does not appear in prose | `app-name.js` flagged the bare word, which names the collaborative and not the app | style |

## Deliberately unchanged

The pileup numbers at position 250,527 are kept exactly as written. The
fidelity review confirmed they match `samtools mpileup` at its default
filtering, which is the column a caller actually reads.

The fixture `README.md` discrepancy the reviewer noted, 90,935 primary-mapped
against 90,990 including supplementary rows, is outside this chapter and
outside this role. The chapter's "99.77 percent" is true on either count.

Single-reader items were left where the fix needed more than one sentence or
a fact this role cannot verify. No such item remained after the two-hit pass.

## Status

brand_reviewed: false
lead_approved: false
