# Reader report: Calling Variants

Reader 4. Undergraduate who used Geneious in one class. Never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "Variant calling is the step that" | The text says LGE "normalises and sorts the output" and I do not know what normalising a variant is. Geneious never showed me such a step. | One clause saying what normalising does to a row. |
| What it is / "Lungfish Genome Explorer (LGE) runs the" | Seven callers are introduced at once and I had no way to sort them until three paragraphs later. | A short table of the seven with a "use when" column. |
| What it is / "bcftools builds a genotype model" | "Genotype model" is not glossed. I know a genotype is AA or Aa from class but not what a model of one is. | Gloss it as a list of possible genotypes it scores. |
| What it is / "which suits a sample with" | "A fixed small number of genome copies" made me stop. I think this means diploid but the word does not appear. | Say "two copies, as in a human". |
| What it is / "LoFreq builds an error model" | Error model is used before it is explained, and the explanation that follows talks about counting reads, which sounded like a different idea. | Gloss error model at first use. |
| What it is / "which suits a sample whose" | I cannot think of a sample whose allele fractions "can be anything at all" and none is named. | One concrete example of such a sample. |
| What it is / "So what should you do" | The question surprised me. Nothing before it was a question, so I reread the paragraph looking for what I had missed. | Drop the question and keep the instruction. |
| Why you would do this / "The HG002 chromosome 20 slice" | I did not know HG002 was a person until two sentences later. The name reads like a gene symbol. | Say "a cell line from one anonymous person" at first mention. |
| Why you would do this / "It ships with a benchmark" | I could not tell whether 961 calls is a lot for 500 kb, especially since a caller later finds 1,056. | Say why the benchmark holds fewer calls than a caller reports. |
| Before you start / "Download the files GRCh38.chr20.10.0-10.5Mb.fasta" | Three long filenames and I could not tell which is the reference and which are the reads. | Label each file on the line where it is named. |
| Before you start / "Import the FASTA as a" | This sends me to another chapter for the real work and I did not know whether to go there now or finish here. | One line saying to do the mapping chapter first, then return. |
| Before you start / "It arrives in the Required" | I still do not know what a pack is after following the glossary link. Is it downloaded or already inside the app? | Say whether packs come from the internet. |
| Before you start / "Open Tools > Plugin Manager..." | The chapter does not say how long a pack install takes or how I know it finished. | One sentence on what a finished install looks like. |
| Step 1 / "Select the reference bundle in the" | I was not sure a bundle and an alignment track look different in the sidebar, so I did not know what to click. | Say how the two rows differ. |
| Step 2 / "The dialog is two columns." | I could not build a picture from the text. A sidebar plus four stacked sections plus a footer was too much to hold at once. | Put the screenshot before the description, not after. |
| Step 2 / "Four sections stack down that pane" | Two fields that appear for every caller but work for only one is the opposite of every dialog I have used. I read this four times. | Say why they are shown at all when they do nothing. |
| Step 2 / "they are recorded in the run's" | Provenance is linked but I do not know where in the window I would look at it. | Name the Inspector here, not only later. |
| Step 3 / "runs bcftools mpileup piped into" | "Piped into" is terminal language and I have never used a terminal. I could not tell if that is one step or two. | Say the first tool's output feeds the second. |
| Step 3 / "and loads the rows into" | SQLite is not glossed and I do not know what it is. | Gloss it as a small database kept in one file. |
| Step 4 / "Open the dialog again and click" | Running the same data twice felt like a mistake until the next paragraph. I paused to check I had not misread step 3. | Say up front that both tracks are wanted. |
| Step 5 / "The table drawer at the bottom" | I did not know the viewport had a drawer and I have not been shown one. | Say the drawer is the panel that slides up from the bottom edge. |
| Step 5 / "which reveals the filter chips" | Chip is used without explanation and I could not picture one. | Gloss chip as a small removable filter button. |
| Step 6 / "and the HG002 reads are shotgun" | Shotgun is not glossed and it is the whole reason iVar is wrong here. | Gloss shotgun against amplicon in one clause. |
| Step 6 / "which lets two neighbouring changes inside" | I know what a codon is but not why merging two changes into one row matters. | Say the merged row gives the right amino acid. |
| Settings / "The default is the first analysis-ready" | "Analysis-ready" is not defined and I do not know what would make a track not ready. | Define it or drop the qualifier. |
| Settings / "which is simply the first one" | Manifest appears once and is not glossed. | Say "the bundle's internal file list". |
| Settings / "records the value caller-default instead" | I could not tell whether that recorded value is a problem I am supposed to fix. | Say plainly it is correct and expected. |
| Settings / "The default is 10, which is" | I do not know how to find the depth of my own data, so I cannot judge whether 10 is right for me. | Point to where depth is shown. |
| Settings / "Tick it yourself only when you" | The warning is strong but I do not know how to tell whether a BAM was trimmed if I did not trim it. | Say how to check the trimming status. |
| Settings / "Sets the frequency above which a" | I could not follow how the consensus rule and the distance rule combine. Two rules, either or both, was unclear. | Say whether merging needs one rule or both. |
| Settings / "It defaults to on, because amplicon" | I do not understand why amplicon libraries are "lopsided by design". | One clause on why primers make the strands uneven. |
| Settings / "Use it to set ploidy on" | Every example flag is something I would already have to know. I could not invent one of my own. | Say where a tool's own flag list lives. |
| Reading the results / "produces 1,056 rows from bcftools" | I do not know whether I will get exactly these numbers on my machine or whether close is fine. | Say whether the run is deterministic. |
| Reading the results / "Of the 1,056 bcftools rows, 873" | The split is stated but I was never told which column of the table shows the type. | Name the column that shows substitution versus indel. |
| Reading the results / "Every one of the 1,056 bcftools" | The hardest paragraph. A dot meaning unjudged rather than failed is not something I would ever have guessed. | State what the dot means before giving the counts. |
| Reading the results / "Of its rows, 623 carry the" | 623 plus 415 is 1,038, not 1,056, and the missing 18 are never accounted for. | Account for the remaining rows. |
| Reading the results / "One position shows all of this" | "Fixture coordinate 2078" confused me. I expected a chromosome 20 position in the millions. | Say the fixture is numbered from its own start. |
| Reading the results / The two-line code block | I could not read the lines. The columns are unlabelled and DP4 and SB appear nowhere else. | Label the columns above the block. |
| Reading the results / "The quality scores are on different" | If the two quality scores cannot be compared, I do not know what the column is for at all. | Say what a quality score is good for within one caller. |
| Reading the results / "The bcftools track from this fixture" | I do not know why the three file sizes matter to me. | Say why the sizes are worth knowing. |
| What good looks like / "The fixture covers 500 kb and" | I could not do the arithmetic quickly and did not know whether 470 is meant to be near 1,000 or different from it. | Show the comparison as a ratio. |
| What good looks like / "954 of the 1,053 distinct" | 1,053 here but 1,056 above. I could not tell whether that is an error or three shared positions. | Explain the three-row difference. |
| What good looks like / "a real accuracy assessment needs a" | hap.py is named but not explained and I do not know where to get it. | Say it lives outside LGE and leave it there. |
| What good looks like / "The fixture runs recorded bcftools 1.24" | I do not know whether my tool version has to match for the counts to match. | Say whether a different version changes the numbers. |
| On the command line / "This section is optional." | Good, but the chapter said the numbers came from the command-line tool, so I wondered whether the window gives different ones. | Say the window produces the same numbers. |
| On the command line / "BUNDLE=MyProject.lungfish/Reference Sequences/chr20_10.0-10.5Mb.lungfishref" | I have never opened a terminal and could not tell what this line does. | Say it just names a folder for the lines below. |
| On the command line / "--mapping-result mapping/" | I do not know where a mapping folder comes from or what it is called on my machine. | Say where the mapping chapter leaves that folder. |
| On the command line / "bcftools view -H \"$BUNDLE\"/variants/<track-id>" | The angle brackets are unexplained and I would have typed them. | Say to replace the brackets and their contents. |

One thing I learned. A dot in the FILTER column means nobody judged the row rather than that the row failed, and clicking the PASS chip on such a track empties the table without saying why.

One thing I still could not do. Choose which of the seven callers fits my own data, because only three are explained and my sample would be none of human shotgun, amplicon, or nanopore.

The sentence I liked most. "Read `.` as unjudged rather than as failed, and check what the column actually holds before filtering on it."
