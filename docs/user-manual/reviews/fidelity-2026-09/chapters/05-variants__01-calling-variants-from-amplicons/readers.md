# Merged reader report - Calling Variants from Amplicons

Four readers reviewed this chapter. Personas were a genetics sophomore who has never opened a terminal, a wet-lab senior with two years of pipetting and no data analysis, a pre-med student reading in a second language, and an undergraduate who has used Geneious. None had opened a terminal before.

| Location | Issue | Readers who hit it | Suggested fix |
|---|---|---|---|
| What it is, "bcftools builds a genotype model" | All four readers knew genotype from class but not what a model of one is, and one reader found the surrounding explanation circular. | 1, 2, 3, 4 | Gloss genotype model as the list of possible allele combinations the tool scores against the pileup. |
| What it is, "a fixed small number of genome copies" | All four readers worked out this means diploid but the word itself never appears at this point in the chapter. | 1, 2, 3, 4 | Name the word diploid here and gloss it as two genome copies, as in a human. |
| Step 3, "loads the rows into a SQLite database" | All four readers had never heard of SQLite and found it unglossed. | 1, 2, 3, 4 | Gloss SQLite as a small local database file the app uses to search fast. |
| Step 6, "the HG002 reads are shotgun" | All four readers found shotgun unglossed, even though it carries the whole reason not to run iVar here. | 1, 2, 3, 4 | Gloss shotgun against amplicon in one clause, reads from randomly broken DNA rather than targeted PCR products. |
| Reading the results, "a FORMAT column reading GT:PL:AD" | All four readers could not find PL and AD explained anywhere in the chapter, though GT is covered by the genotype sentence. | 1, 2, 3, 4 | Gloss PL and AD in one clause where the column is first shown. |
| Reading the results, "The quality scores are on different scales and cannot be compared" | All four readers were told the two quality scores cannot be compared but not what either scale measures on its own, leaving the column meaningless to them. | 1, 2, 3, 4 | Say what a quality score in a VCF measures, and that it is only comparable inside its own file. |
| Reading the results, "produces 1,056 rows from bcftools" | All four readers could not tell whether their own run would match these exact figures or only come close. | 1, 2, 3, 4 | State plainly whether the counts are deterministic or the reader should expect close, not exact, numbers. |
| What good looks like, "a real accuracy assessment needs a benchmarking program such as hap.py" | All four readers did not know what to do with hap.py, whether to install it, and whether accuracy assessment was in reach without a terminal. | 1, 2, 3, 4 | State plainly that hap.py lives outside LGE and that accuracy assessment is out of scope for this manual. |
| On the command line, "bcftools view -H $BUNDLE/variants/<track-id>" | All four readers did not know where to find the track id that replaces the angle brackets. | 1, 2, 3, 4 | Say where the track id is displayed in the window. |
| Why you would do this, HG002 introduced as "a well-characterised human cell line" or "chromosome 20 slice" | All four readers did not know HG002 was a person before the identifier was used, and one reader only learned it was a cell line from a later sentence. | 1, 2, 3, 4 | Say at first mention that HG002 is a person whose DNA is available as a cell line. |
| Settings, "The default is the first analysis-ready" | All four readers found analysis-ready undefined and could not tell what would disqualify a track. | 1, 2, 3, 4 | Define analysis-ready, or say plainly what disqualifies a track. |
| Settings, "The default is 10, which is" | All four readers had no way to check their own alignment's depth, so they could not judge whether the default of 10 was safe for their own data. | 1, 2, 3, 4 | Point to where coverage depth is shown in the window. |
| Before you start, "Import the FASTA as a reference" | All four readers could not perform this step from the chapter text, since it points to the mapping chapter with no menu command or estimate of how long that takes. | 1, 2, 3, 4 | Name the menu command even if detail lives elsewhere, and say roughly how long the mapping chapter takes. |
| Before you start, "It arrives in the Required Setup pack" and the Plugin Manager install | All four readers could not tell whether the plugin pack needed the internet, how long install took, or how to know it had finished. | 1, 2, 3, 4 | State what the install needs, roughly how long it takes, and what a finished install looks like. |
| Step 5, "The table drawer at the bottom of the viewport" | All four readers met drawer and viewport together with neither glossed. | 1, 2, 3, 4 | Gloss both at first use, for example the panel that slides up from the bottom edge of the main window. |
| What it is, "So what should you do with this?" | Three readers found this question read as rhetorical or addressed to somebody else, and had to reread the paragraph to find the actual advice. | 2, 3, 4 | Drop the question and state the rule directly. |
| Step 3, "runs bcftools mpileup piped into bcftools call" | Three readers had never opened a terminal and did not know what piped into means. | 2, 3, 4 | Say the output of the first tool is fed straight into the second. |
| What it is, "LoFreq builds an error model from the base qualities" | Three readers found error model used before or without being explained, with one reader finding the explanation that follows sound like a different idea. | 2, 3, 4 | Gloss error model at first use as an estimate of how often the machine misreads a base. |
| What it is, "whose true allele fractions can be anything at all" | Three readers could not think of an example of such a sample, since every example before this point was human. | 1, 2, 3 | Name one concrete example, such as a mixed infection or a tumour sample. |
| What it is, "you pick a caller from" a list of seven | Three readers had no way to sort or judge the seven callers until later in the chapter. | 1, 2, 4 | Say up front that the next paragraph explains how to choose, or give a short table of the seven with a use-when column. |
| What good looks like, "954 of the 1,053 distinct positions" | Three readers were confused that the chapter said 1,056 rows earlier and now says 1,053 positions with no explanation of the gap. | 1, 3, 4 | Say that a few positions carry more than one row, accounting for the difference. |
| Reading the results, the two-line code block | Three readers could not match the unlabeled fields to column names, with the lines running wider than the screen. | 1, 3, 4 | Label the columns above the block, or add a comment line naming them. |
| Step 2, "recorded in the run's provenance" | Three readers found provenance used as if familiar, with no gloss and no clear location for where the recorded value can be seen. | 1, 2, 4 | Gloss provenance inline as the saved record of how the run was done, and name where it is displayed. |
| Step 5, "which reveals the filter chips" | Three readers could not picture what a filter chip is. | 2, 3, 4 | Gloss chip as a small toggle or removable filter button. |
| Why you would do this, "mapped to a 500 kb stretch" | Three readers met kb without it being spelled out, with one reader also noting the chapter later switches to a different unit for the same figure. | 1, 2, 4 | Spell out kilobases at first use, and keep the same unit throughout. |
| Why you would do this, "the Genome in a Bottle consortium" | Two readers had never heard of this body and could not judge how much to trust it. | 1, 2 | Add one clause saying it is a public standards project. |
| Reading the results, "Of its rows, 623 carry" | Two readers added 623 and 415 to get 1,038, not 1,056, and found the remaining 18 rows never accounted for. | 1, 4 | Say what the remaining rows carry. |
| Step 3, "as an orthogonal cross-check on the selected BAM" | Two readers knew orthogonal only from math or geometry and it made no sense in this sentence. | 1, 3 | Replace with independent. |
| Step 6, "two neighbouring changes inside one codon" | Two readers knew codons from class but not why merging two changes into one row matters. | 1, 4 | Say the merged row gives the correct single amino acid result. |
| Settings, "makes LGE run an extra lofreq indelqual pass" | Two readers did not know what indelqual does or whether it costs extra time. | 1, 3 | Say it adds quality scores for insertions and deletions, and whether it takes extra time. |
| Settings, "because amplicon libraries are lopsided by design" | Two readers did not follow why amplicon libraries are lopsided by strand. | 1, 4 | Add one clause on why primers make the strands land unevenly. |

Thirty rows total.

## Consensus

Fifteen rows were hit by three or more readers.

- Genotype model is never glossed as the list of allele combinations the tool scores.
- A fixed small number of genome copies is never named as diploid at first use.
- SQLite is never glossed.
- Shotgun is never glossed against amplicon, though it is the reason not to run iVar.
- PL and AD in the FORMAT column are never glossed.
- The quality score column is never explained as measuring anything on its own, or as comparable only within one file.
- Whether the reported row counts are deterministic on the reader's own machine is never stated.
- What to do with hap.py, and whether accuracy assessment is in scope at all, is never stated.
- Where the track id is displayed in the window is never said.
- HG002 is used as an identifier before being introduced as a person whose DNA is a cell line.
- Analysis-ready is never defined.
- Where to check the depth of the reader's own alignment is never shown, leaving the default of 10 unjudgeable.
- The mapping chapter this chapter depends on is pointed to with no menu command or time estimate.
- The plugin pack install gives no indication of internet need, duration, or completion.
- Table drawer and viewport are both introduced together with neither glossed.
