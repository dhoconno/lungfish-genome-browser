# Reader report: Reading an Alignment

Reader 2. Senior, two years of pipetting, never analyzed data, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "A BAM file is a long" | I do not know what BAM stands for or whether it is something I make or something the sequencing core hands me. The link goes to a page I have not read. | Say what a BAM is inside this sentence. |
| What it is / "which of the two DNA" | I know strands from the bench but not how a sequencing machine knows which strand a read came from. | A half-sentence saying the strand is inferred by the mapper, not measured. |
| What it is / "and how confident the mapper" | "Mapper" appears here for the first time with no gloss. I guessed it is the program that did the alignment. | Name the mapper as the program that placed the reads, at first use. |
| What it is / "A table with ninety thousand rows" | I could not tell whether ninety thousand is the size of my file or only this example's. | Say this is the example dataset's size. |
| What it is / "and the single-position column through that" | I read this twice and still could not picture a column drawn through a pile of horizontal bars. | A figure right here, or "imagine a vertical line down through the stack". |
| What it is / "Depth and coverage both name the" | Helpful, but later the chapter says "99.99% of the slice carries at least one read" and "Est. Coverage", which sound like a different meaning of coverage. | Say plainly that percent-covered is a different number from depth. |
| What it is / "LGE picks the picture from" | I had to read the bases-per-pixel idea three times. I have no intuition for pixels and could not tell whether a bigger number means more zoomed in or less. | State which direction is which, e.g. smaller means more zoomed in. |
| What it is / "Above roughly 2 bases per" | Following from the above, I could not tell if "above 2" means zoomed in or zoomed out. I had to reason backwards from the word "Zoom in" in the quoted message. | Say "zoomed out past 2 bp/px". |
| What it is / "pale blue for a read" | I know reverse complement from class but I do not understand why a read would align that way, or whether it is a problem. | One sentence saying both strands get sequenced and this is normal. |
| What it is / "Read ends the mapper set" | I did not know reads had ends that get set aside. The explanation arrives in the next sentence, after I was already lost. | Define soft clipping before saying how it is drawn. |
| Why you would do this / "an artefact of the sequencing" | I do not know what a chemistry artefact is, or why it would show on only one strand. | Name one concrete example of such an artefact. |
| Why you would do this / "human Illumina reads from a genome" | I do not know what HG002 is, or why an independently established sequence matters for learning. | Say it is a benchmark person's genome so you can check your answers. |
| Why you would do this / "mapped onto a 500 kb" | I did not know an alignment could be to a window rather than a whole chromosome, and I cannot tell if my own data will look like this. | Say this is a trimmed-down slice used for speed. |
| Before you start / "Then work through Mapping Reads to" | This means I cannot do this chapter today without doing another one first, and I only learned that in the third paragraph. | Put the prerequisite chapter in the first line of the section. |
| Before you start / "named minimap2 Mapping by default and" | I do not know what minimap2 is. It appears here and in the procedure with no gloss anywhere. | One clause saying minimap2 is the aligner program LGE used. |
| Before you start / "The mapping run's own folder sits" | I could not tell why I am told this or whether I need to do anything there. | Say what I would go to that folder for, or drop the sentence. |
| Before you start / "and pick a BAM, CRAM, or" | I do not know the difference between these three or which one I would have. | One line naming which one a sequencing core usually gives you. |
| Before you start / "because random access into the middle" | I do not know what an index is in this sense, so the explanation uses a term I do not have. | Gloss index as a lookup table that lets a program jump without reading the whole file. |
| Before you start / "LGE reads alignments by running the" | I have never run a program and could not tell whether this means I must do something myself. | Say explicitly that LGE does this for me and I never type it. |
| Before you start / "check the Plugin Manager under Tools" | I would not know what to look for once I got there, or what a healthy Required Setup pack looks like. | Name the row I should see and the state it should be in. |
| Procedure step 1 / "under the GRCh38.chr20.10.0-10.5Mb reference bundle" | I do not know what GRCh38 means and it is never spelled out. | Say GRCh38 is the standard human reference genome build. |
| Procedure step 2 / "Hover any point for a tooltip" | I could not tell whether hover means hold still, and whether I need to click first. | Say to rest the pointer without clicking. |
| Procedure step 2 / "LGE prints the deepest column in" | I do not know what the "x" in `79x` means. I guessed "times" but nothing says so. | Gloss the x notation once, as reads deep. |
| Procedure step 2 / "that label gains the average as" | I could not tell whether the mean is across the whole file or only across what is on screen. | Say which window the mean is computed over. |
| Procedure step 3 / "Go to position 2,078 and zoom" | Position 2,078 of what? The slice starts at 10 Mb on chromosome 20, so I could not tell if 2,078 is a coordinate inside the slice or on the real chromosome. | Say the coordinates are counted from the start of the slice. |
| Procedure step 3 / "or pan there with the Left" | Three different routes to a position are joined by "or" and "then" in one sentence. After three readings I still was not sure whether the right-click is part of the panning route or its own route. | Split into separate sentences, one route each. |
| Procedure step 3 / "Then press `Cmd-=` to zoom in" | On my keyboard equals needs shift to make a plus, and I did not know whether to press shift. | State the literal keys to press. |
| Procedure step 3 / "The Up and Down arrow keys" | The same paragraph gives Left and Right for panning and Up and Down for zooming, and I lost track of which did what. | Put the keys in a short table. |
| Procedure step 3 / "and Zoom Reset (10kb) (Cmd-1) for" | I did not know whether this ten-kilobase window is centred where I am or jumps to the start of the contig. | Say the window is centred on the current position. |
| Procedure step 3 / "Keep zooming until each read is" | I do not know how many presses that is, or what the bases-per-pixel figure should read when I arrive. | Give the approximate bp/px value where letters appear. |
| Procedure step 4 / "A reference-base row sits under the" | I could not tell whether this row is always there or appears only at base-letter zoom. | Say the reference row appears only when zoomed to letters. |
| Procedure step 4 / "The four bases have fixed colours" | "In both rows" is ambiguous. I think it means the reference row and the reads, but there are many read rows. | Say "in the reference row and in the reads". |
| Procedure / step numbering jumps from 4 to 6 | There is no step 5. I scrolled back looking for a step I had skipped. | Renumber the list. |
| Procedure step 6 / "Drag across a stretch of the" | I did not know whether to drag on the ruler, the coverage curve, or the reads, or whether the drag is horizontal only. | Say where to start the drag. |
| Procedure step 6 / "writes every read overlapping that stretch" | I do not know what a `.lungfishfastq` bundle is as opposed to a file, or whether anything outside LGE can open it. | One line saying a bundle is a folder LGE treats as a single item. |
| Procedure step 6 / "choose Copy as FASTA (aligned orientation)" | I do not know what aligned orientation means or how it differs from the read as sequenced. The clause mentions soft clips but not orientation. | Say aligned orientation means reverse-strand reads are flipped to match the reference. |
| Procedure / "If you select many reads at" | I do not know how a read could have an empty stored sequence, or whether that means something is wrong with my data. | A clause saying this is normal for certain record types. |
| Settings / "None of them changes the BAM" | I had to read the scripting clause twice, and since I do not script anything I could not tell whether it mattered to me. | Say plainly that these settings are not saved into the file. |
| Settings / Visible Alignment / "which is the usual case when" | Primer trimming has not been introduced yet in this chapter. | Point forward to the primer trimming chapter here. |
| Settings / Minimum alignment confidence / "On this fixture almost nothing disappears" | I do not know what scale mapping quality is on, why 60 is the maximum, or what 30 means. | Say the scale runs 0 to 60 and describe 30 in words. |
| Settings / Minimum alignment confidence / "since 87,755 of the 90,935 placed" | The chapter says "placed", "mapped", and "primary" in different places and I could not tell whether they name the same set of reads. | Use one word, or say the three are the same. |
| Settings / Coverage scale / "Switch to Log10 or Square root" | I have seen log axes in class but I could not tell which of the two to pick, or whether it changes the numbers or only the drawing. | Say it changes only the drawing, and give a rule for choosing. |
| Settings / Coverage scale / "which is exactly what happens on" | Amplicon is used here before it is explained. The explanation arrives much later. | Gloss amplicon at this first use. |
| Settings / Include secondary alignments / "It is off by default, and" | If the mapping run excluded them, I do not understand what turning the toggle on would ever show me. | Say the toggle only reveals records that are already in the file. |
| Settings / Include supplementary alignments / "This fixture carries 55 supplementary records" | 91,148 primary here, 90,935 placed earlier, 90,990 Total Mapped later. Three totals and I cannot reconcile them. | A short note saying which total counts what. |
| Settings / Limit visible rows / "keeps all mapped reads in the" | This is quoted help text I did not understand. I do not know what unstable scrolling would look like. | Explain it in the manual's own words rather than quoting. |
| Settings / Read display budget / "high enough that an ordinary window" | I could not judge whether my own data would sit near 50,000 or near 500,000. | Give a rough rule, e.g. reads per window at typical depth. |
| Settings / Forward strand color / "which is the reason the two" | I do not know what a "well" is in an interface. At the bench a well is on a plate. | Say colour swatch or colour picker. |
| Settings / "(the selected region)." and "(the save destination)." | The parentheses and lowercase made me think something was missing from the page. | Give these two settings plain names. |
| Settings / "On the command line this is" | I have never opened a terminal, and this is the first mention of one in the Settings section. | Mark these lines as for readers who script, or move them. |
| Reading the results / "Every number in this section was" | I could not tell whether I should expect to reproduce these exact numbers when I follow along. | Say whether my own run gives the same numbers. |
| Reading the results / "Mean depth across the 500 kb" | The 99.99% figure is a percent-of-positions number but the section defines coverage as depth, so I lost track of which was meant. | Distinguish percent of positions covered from depth. |
| Reading the results / "Depth is the number of reads" | I understood the idea but not why ten specifically, or whether ten holds for all data or only this kind. | Say where ten comes from and when it changes. |
| Reading the results / "A shotgun library like this one" | I know GC content but not what counts as "unusually" rich or poor here, or how I would spot the dip in the picture. | Say how deep the dips go and roughly where they appear. |
| Reading the results / "usually because the site it binds" | I could not tell whether this is something I diagnose in LGE or something I take back to the bench. | Say what the next step would be. |
| Reading the results / "that the independent benchmark for this" | I do not know what this benchmark is or where I would look at it. | Name it once, e.g. a published truth set. |
| Reading the results / "Twenty-four of those reads run forward" | 24 plus 27 is 51, which matches, but the sentence before says all fifty-one carry an A, so I could not see why the strand split is a separate finding. | Say the split matters because a real difference should appear in both directions. |
| Reading the results / "meaning the alternate base is on" | I nearly followed this, but I do not know the word for the other case where only one inherited copy carries the change, or what that column would look like. | Name the one-copy case and say it would read near half. |
| Reading the results / "LGE draws an even sample of" | The banner says 620,000 reads but the fixture holds 91,148, so I could not tell whether this banner is from a different dataset. | Say this banner example is not the fixture. |
| Reading the results / "Pressing it lifts the budget for" | The Settings section said the ceiling is 500,000. Here it says two million. | Reconcile the two ceilings. |
| Reading the results / "and the sample is a fixed" | I do not know what a stride is here. | Say it takes every nth read. |
| Reading the results / "While a heavy window is loading" | I do not know what "packing" means, or whether N is a number I will actually see. | Say packing means laying the reads out into rows. |
| Reading the results / "It reports the read's base qualities" | Q scores have not been introduced in this chapter. The Q20 gloss arrives one sentence after I hit "Mean Q". | Gloss the Q scale before naming the three figures. |
| Reading the results / "and the percentage of the read's" | I could not tell what percentage would count as good. | Give a typical value for clean Illumina data. |
| Reading the results / "showing the first five with their" | I do not know why insertions get their own list when deletions do not. | Say why only insertions are listed. |
| Reading the results / "and, for a single-contig reference like" | I still do not know why a single-contig reference is special for the coverage estimate. | Say the estimate needs one sequence length to divide by. |
| Reading the results / "For this fixture those read 90,990," | Five numbers matched to five labels across two sentences. I counted on my fingers to line them up. | Use a small table. |
| Reading the results / "and it is a grid of" | Six tab names and six operation names, and on a second reading I could not remember which button lives in which tab. | Use a two-column list. |
| Reading the results / "which is the first eligible track" | This sounds like a trap and I could not tell how I would notice it had happened. | Say what to look at to confirm the right track is chosen. |
| Reading the results / "The provenance travels with the operation" | Provenance is linked but never explained in words anywhere in this chapter. | One clause saying provenance is the record of what produced a file. |
| What good looks like / "Zoom to fit and look at" | Earlier I was told that at full-slice zoom I see only the coverage curve, so I could not tell whether that is enough for this check. | Say the curve alone is what this check needs. |
| What good looks like / "or a region no read could" | I do not know why a read could fail to be placed somewhere. | Name the reason, e.g. repeated sequence. |
| What good looks like / "On this fixture 6,308 of the" | Useful, but I do not know at what percentage a soft-clip rate stops being ordinary. | Give the number where it becomes worth worrying about. |
| On the command line / whole section | I have never opened a terminal. I could not tell whether to skip this section or whether anything in it is needed for the app workflow. | A first line saying this section is optional. |
| On the command line / "--region chr20_10.0-10.5Mb" | The bundle is `GRCh38.chr20.10.0-10.5Mb` with dots and the contig is `chr20_10.0-10.5Mb` with an underscore. I could not tell whether that was a typo. | Say the contig name differs from the bundle name. |
| On the command line / "That run reports Extracted 91148 reads" | The Inspector was said to report 90,990 Total Mapped, not 91,148, so I do not see the match being claimed. | Say which Inspector figure this matches. |
| On the command line / "so the command extracts a whole" | This reads like a bug I should know about, but I could not tell whether it affects the app buttons too. | Say the app path is unaffected. |
| Next / "Continue to Primer Trimming if your" | Which chapter I read next hinges on whether my reads came from an amplicon panel, and I am not certain whether mine did. | One line on how to tell. |

One thing I learned: a difference from the reference is only believable if it shows up on reads running in both directions, and the strand tints in the viewport let me check that by eye instead of by arithmetic.

One thing I still could not do: get to position 2,078 at base-letter zoom with any confidence, because I could not tell whether 2,078 is a coordinate inside the 500 kb slice or on the real chromosome, and I could not tell from the bases-per-pixel figure whether I had zoomed in far enough yet.

The sentence I liked most: "Silence from a caller looks the same whether the region matched the reference perfectly or was never sequenced at all."
