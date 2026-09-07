# Reader report, Calling Variants

Reader 3. Pre-med student, English is my second language, no terminal experience.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Variant calling is the step that turns" | The file name and the task line say amplicons, but the whole worked example is human shotgun and the chapter tells me not to run the amplicon caller. I did not know what this chapter was for. | Say in the first paragraph that the amplicon caller is only one of three. |
| What it is, "walks the reference one position" | I did not know what "walks" means for a program. In my English a person walks. | Say "reads the reference position by position". |
| What it is, "the pileup of read bases stacked" | Pileup is linked but I still could not picture it. I read this sentence twice. | One sentence saying a pileup is the column of letters from all reads covering one position. |
| What it is, "normalises and sorts the output" | "Normalises" is not glossed and not linked. I do not know what is being made normal. | Gloss normalise at first use. |
| What it is, "which suits a sample with a fixed small number" | I did not connect "fixed small number of genome copies" with the word ploidy until much later in Settings. | Use the word ploidy here with its gloss. |
| What it is, "LoFreq builds an error model from the base qualities" | I do not know what an error model is or how a program builds one. | One clause saying it estimates how often the machine misreads a base. |
| What it is, "whose true allele fractions can be anything" | I could not think of a real example of such a sample. Everything before this was human. | Name one example, such as a mixed infection or a tumour sample. |
| What it is, "So what should you do with this?" | This question sounded like it was addressed to somebody else. I had to read the paragraph again to see it was advice. | Delete the question and keep the advice sentence. |
| Why you would do this, "a well-characterised human cell line" | I did not know that HG002 is both a person and a cell line, and later the text says "this person". | Say once that HG002 is a person whose DNA is available as a cell line. |
| Why you would do this, "961 variant calls that the Genome" | I could not judge whether 961 is many or few for this region until the very last section. | Give the density here, one call per so many bases. |
| Why you would do this, "an outside answer key, so a caller" | "Answer key" is an idiom I did not know. I guessed from context. | Say "an independent list to compare against". |
| Before you start, "which is a fixture, the sample data set" | The sentence defines fixture inside itself with commas and I lost the thread. I read it three times. | Define fixture in its own short sentence. |
| Before you start, "Import the FASTA as a reference and" | It sends me to do a whole other chapter, but I do not know how long that takes or whether I can come back. | Say mapping is a prerequisite chapter to finish first, and how long it takes. |
| Before you start, "It arrives in the Required Setup pack" | I do not know what a pack is at this point. The gloss link sits on the next line, not on the first mention. | Put the gloss link on the first mention. |
| Before you start, "Open Tools > Plugin Manager... (Cmd-Shift-B)" | I did not know whether installing a pack needs internet, how long it takes, or whether I must wait for it. | One sentence about the download and the wait. |
| Step 1, "raises an alert reading "No Bundle Loaded"" | I did not know what "raises an alert" looks like. A beep, a window, a red mark? | Say "opens a small window titled No Bundle Loaded". |
| Step 2, "and LoFreq is selected when the dialog opens" | Step 3 then tells me to click bcftools. I could not tell whether the default choice is a recommendation. | Say the default selection is not a recommendation. |
| Step 2, "Extra arguments is a single text field" | I had no idea what I would ever type there, and this section does not say. | Point forward to the Settings entry. |
| Step 2, "they are recorded in the run's provenance and then ignored" | This is very strange to me. Why does the program show a field it will not use? I read the paragraph three times and still thought the app was broken. | Say why the fields stay visible, for example that they are shared across all callers. |
| Step 3, "as an orthogonal cross-check on the selected BAM" | I know "orthogonal" only from geometry. In this sentence it made no sense. | Replace with "independent". |
| Step 3, "runs bcftools mpileup piped into bcftools call" | "Piped into" is terminal language and I have never opened a terminal. | Say the output of the first is fed into the second. |
| Step 3, "loads the rows into a SQLite database" | I do not know what SQLite is and it is not glossed. | Say "a small local database file". |
| Step 4, "Open the dialog again and click LoFreq, which is where it opens anyway" | The sentence tells me to click and then says clicking is unnecessary. I did not know what to do. | Say plainly that LoFreq is already selected so no click is needed. |
| Step 5, "The table drawer at the bottom of the viewport" | "Table drawer" and "viewport" are both new here and neither is glossed. | Gloss both at first use. |
| Step 5, "Filtering happens through the Presets button" | I could not tell what a "filter chip" is. To me a chip is food or silicon. | Say the chips are small toggle buttons. |
| Step 6, "the HG002 reads are shotgun" | "Shotgun" is never explained in this chapter and is not in the glossary list. | Gloss shotgun sequencing at first use. |
| Step 6, "where every primer position would then read as a variant in about half the reads" | I did not understand why half and not all. | One clause explaining that primer bases come from the primer, not from the sample. |
| Settings, "The default is the first analysis-ready BAM track" | "Analysis-ready" is a new term with no gloss. I could not tell which of my tracks would qualify. | Gloss analysis-ready. |
| Settings, "a name already in use gets a number appended" | I could not tell what the number looks like, whether 2 or (2) or -2. | Show one example name. |
| Settings, "which is why a bcftools run started from this dialog records" | A very long sentence with three clauses. I lost the subject by the end and read it twice. | Split it into two sentences. |
| Settings, "The default is 10, which is about the thinnest evidence" | I do not know why 10 and not 20. The text says thinnest worth calling but gives no reason. | Say briefly why calls below 10 reads are unreliable. |
| Settings, "using each tool's own flag" | It tells me to use each tool's own flag but never names those flags here. | Name the two flags in this entry. |
| Settings, "This BAM has already been primer-trimmed for iVar.." | There are two full stops at the end. I thought a word was missing. | Remove the extra full stop. |
| Settings, "Sets the frequency above which a change counts as the consensus base" | I did not know what "the consensus base" is and it is not glossed. | Gloss consensus base. |
| Settings, "The default is 0.25, so two changes at 0.40 and 0.55 merge" | Even with the example I could not tell whether the rule compares a difference or a ratio. | State the rule as a subtraction. |
| Settings, "Marks a call with the bq filter flag" | "bq" is not explained. I did not know where I would see those letters. | Say it appears in the FILTER column. |
| Settings, "Ignore strand bias (recommended for amplicons)" | I do not know what a strand bias artifact is, so I could not judge the recommendation. | One sentence on why both strands should agree. |
| Settings, "On the command line the flag is inverted" | I read this three times. A setting on by default, with a flag that turns it off, and the flag has "no" in its name. Too many negatives. | Give the plain meaning of the flag first. |
| Settings, "makes LGE run an extra lofreq indelqual pass" | I do not know what indelqual does or whether it costs time. | Say it adds indel quality scores and takes extra time. |
| Reading the results, "Those two runs were made for this chapter with the command-line tool" | I only used the window. I could not tell whether my own counts would be exactly 1,056 and 862 or merely close. | Say whether window runs give identical counts. |
| Reading the results, "873 are single-base substitutions and 183" | I used a calculator to check that these add to 1,056, because the text does not say so. | Say the two numbers add to the total. |
| Reading the results, "Every one of the 1,056 bcftools rows has FILTER set to a bare `.`" | I could not tell whether an unfiltered file is a problem I must fix before using the data. | Say explicitly that no action is needed. |
| Reading the results, "the eight standard ones plus a FORMAT column reading GT:PL:AD" | PL and AD are never expanded. Only GT is explained, by the genotype sentence. | Expand PL and AD once. |
| Reading the results, the two-line code block | The block has no header row, so I could not match the fields to column names, and the `...` in the middle made me think text was missing. | Add a comment line naming the columns. |
| Reading the results, "The quality scores are on different scales and cannot be compared" | This surprised me, since both are called quality. I wanted to know which number is better. | Say each score is only comparable inside its own file. |
| Reading the results, "writes 46 KB, 368 bytes, and 2.2 MB respectively" | Three sizes in a row with no file named beside each. I had to count back to the earlier list to match them. | Name each file with its size. |
| What good looks like, "which is roughly one difference every 470 bases" | Earlier the chapter said about one in a thousand. 470 is twice as dense, and "gene-rich" did not convince me. I read the paragraph twice. | Say how much denser than average is still acceptable. |
| What good looks like, "954 of the 1,053 distinct positions bcftools called" | Earlier the count was 1,056 rows and now it is 1,053 positions. I thought I had misread a number. | Say why rows and positions differ. |
| What good looks like, "a real accuracy assessment needs a benchmarking program such as hap.py" | The chapter says the proper tool is not included but does not say what I should do instead. | Say whether the position match is enough for classwork. |
| What good looks like, "they record the two threshold fields as "caller-default"" | I could not tell where in the Inspector this word appears. | Name the field or row in the Inspector. |
| On the command line, "lungfish-cli bam adopt-mapping --bundle" | I have never opened a terminal, and this step uses a `mapping/` folder that the window procedure never produced or named. | Say that folder comes from a command-line mapping run only. |
| On the command line, "bcftools view -H "$BUNDLE"/variants/<track-id>.vcf.gz" | I did not know where to find the track id that replaces the angle brackets. | Say where the track id is shown. |

One thing I learned. Two callers run on exactly the same alignment give different files on purpose, and an empty FILTER column is not a failure but a caller that has judged nothing.

One thing I still could not do. I could not tell whether leaving Minimum Allele Frequency and Minimum Depth alone is safe for a bcftools run, or whether I was supposed to set a real threshold some other way before trusting my rows.

The sentence I liked most. "Read `.` as unjudged rather than as failed, and check what the column actually holds before filtering on it."
