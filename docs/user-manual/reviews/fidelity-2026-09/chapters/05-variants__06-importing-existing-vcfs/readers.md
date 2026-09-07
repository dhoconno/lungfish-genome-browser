# Merged reader report - Importing Existing VCFs

Four readers reviewed this chapter. Personas were a genetics sophomore with no lab time, a wet-lab senior with two years of pipetting and no data analysis, a pre-med student reading in a second language, and an undergraduate who has used Geneious. None had opened a terminal before.

| Location | Issue | Readers who hit it | Suggested fix |
|---|---|---|---|
| Step 1, "comparing it against the first column of the VCF" | All four readers could not perform this check because they cannot open a compressed VCF without a terminal, and the chapter never says how to see the sequence name from inside the app. | 1, 2, 3, 4 | Say how to see the VCF's sequence name from inside the app without a terminal, or say plainly that window users should skip the check. |
| What it is, "then quietly tries to fetch a matching reference sequence from NCBI" | All four readers stopped on "quietly" and NCBI, unsure whether the download is normal, costs anything, can be cancelled, or is something to avoid. | 1, 2, 3, 4 | Gloss NCBI as a free public sequence database in one clause, and say plainly whether the download can be cancelled. |
| What it is, "There is also a command line route" | All four readers could not tell whether the command-line paragraph was optional, since none of them had ever opened a terminal. | 1, 2, 3, 4 | Say up front, in the first few words, that the command line route is optional and covered at the end. |
| Before you start, "Download the file HG002.chr20.10.0-10.5Mb..." and its `.tbi` pair | All four readers could not tell whether the `.vcf.gz` and the `.tbi` were one download or two, since the names differ only by a suffix. | 1, 2, 3, 4 | State plainly that these are two separate downloads that must both be fetched. |
| Before you start, "the Required Setup pack" | All four readers met "the Required Setup pack" named as if already familiar, with no pointer to where it comes from or whether they already had it. | 1, 2, 3, 4 | Point to the chapter or step where the Required Setup pack is installed or checked. |
| Step 3, "writes the rows into a SQLite database" | All four readers did not know what SQLite is and could not tell whether it is a file they now own or ever need to touch. | 1, 2, 3, 4 | Gloss SQLite in a few words as an internal file format, or say plainly the reader never opens it. |
| Step 5, "records a Default Ploidy value" | All four readers knew ploidy from class but could not tell what it means for this file setting or whether they needed to act on it. | 1, 2, 3, 4 | Gloss ploidy as used here and say plainly whether the default needs any action. |
| Reading the results, "with the scope control set to Genome" | All four readers could not find the scope control or tell what its other values were. | 1, 2, 3, 4 | Say where the scope control sits in the drawer. |
| Reading the results, "so 961 differences in 500,001 bases is about one every 520 bases" | All four readers could not quickly reproduce or connect this arithmetic to the one-in-a-thousand expectation for human variation. | 1, 2, 3, 4 | Show the division, and connect the result to the one-in-a-thousand benchmark directly. |
| Reading the results, "Every one of the 1,056 bcftools rows reads a bare `.`" | All four readers read the bare dot as missing data, an error, or the end of the sentence, rather than a specific meaning. | 1, 2, 3, 4 | State plainly that a bare dot means no filter judgement was made. |
| Reading the results, "Clicking the `PASS` preset chip" | All four readers did not know what a preset chip was or where it sat on screen. | 1, 2, 3, 4 | Say where the preset chips appear in the Variants tab. |
| Reading the results, "sixteen more rows carrying multi-allelic calls such as `2/1`" | All four readers could not read `2/1`, since the chapter explains `0/1` and `1/1` but never a second alternate allele. | 1, 2, 3, 4 | Gloss what the second number in a multi-allelic call refers to. |
| Reading the results, "with LoFreq's allele frequency of 0.571" | All four readers could not connect the 0.571 frequency to the `0/1` genotype it was meant to support. | 1, 2, 3, 4 | State plainly that a heterozygous site should show roughly half the reads carrying the change, before giving the number. |
| What good looks like, "far fewer for two clonal isolates of the same bacterium" | All four readers did not know "clonal isolates" and could not use the comparison to judge their own file. | 1, 2, 3, 4 | Gloss clonal isolates, or replace the example with one readers can judge directly. |
| What good looks like, "a filter that empties the view has three possible explanations" | All four readers found the three explanations promised but never listed, so none of them could perform this check. | 1, 2, 3, 4 | List the three explanations. |
| Why you would do this, "The HG002 chromosome 20 slice" / "cell line" | Three readers could not tell what HG002 is, whether a person, a cell line, a file, or a folder, since it is used as several of these later with no single defining sentence. | 1, 2, 4 | Add one sentence saying HG002 is DNA from one well-studied person used as a shared standard. |
| Why you would do this, "produced 1,056 and 862 rows" | Three readers met the two counts with no sense of whether the roughly 200-row gap between callers was alarming or ordinary. | 1, 2, 3 | Say whether that spread between callers is expected before using it as evidence. |
| Why you would do this, "since bcftools reports more than is really there" | Three readers were given this as a bare fact about the tool with no reason, and could not judge or reuse the claim. | 2, 3, 4 | Add one clause on why bcftools over-reports relative to LoFreq. |
| Before you start, "which is a fixture, the sample data set" | Two readers lost the main sentence because fixture is defined mid-sentence inside a relative clause. | 2, 3 | Define fixture in its own short sentence. |
| Step 2, "so a `.bcf` cannot be chosen here" | Three readers did not know what a BCF is or how they would convert one, though the sentence assumes they might have one. | 1, 2, 3 | Gloss BCF as a compact binary VCF, and say where the conversion is described. |
| Step 3, "where `Auto` names the import profile" | Three readers reached this before the Settings section defined "import profile" and could not tell whether they needed to change anything first. | 1, 2, 4 | Say plainly that the default is fine and needs no action, with a short gloss inline. |
| Settings, memory guidance for Fast versus Low Memory / Auto | Three readers could not judge "plenty of memory" or a "multi-gigabyte" file against their own laptop, with no number given. | 1, 2, 3 | Give a rough memory threshold in gigabytes, or say how to check available memory. |
| Settings, "--output-dir" / command-line-only settings mixed into app settings | Three readers found a command-line-only flag sitting among app settings with nothing marking it as such. | 1, 2, 4 | Mark each command-line-only entry as such in its first words. |
| Step 5, "which is a large download for a 500 kb example" | Two readers could not judge "large" without a number, so could not decide whether to risk it on their own laptop. | 1, 2 | Give an approximate download size. |
| Reading the results, "reading a benchmark row's 50 against a bcftools row's 225" | Two readers met the 225 quality value with no scale or context, so could not tell whether it was high, typical, or one example. | 1, 2 | Say what the quality scale runs over, or say plainly the value is one example. |
| On the command line, "Types : SNP: 809, DEL: 74, INS: 64" | Three readers were never given the expansions for SNP, DEL, and INS, though the table earlier in the chapter uses the long words for the same things. | 1, 2, 3 | Expand the abbreviations once, and map them to the earlier table's words. |
| On the command line, "the same per-sample filter grammar the Search Builder" | Three readers met "filter grammar" and "Search Builder" both unexplained at this point. | 1, 2, 3 | Cross-reference the chapter that teaches the Search Builder. |
| On the command line, "both cap the export at 5,000 records" | Three readers could not tell how they would notice missing rows, since the cap is called silent with no statement of what happens to the rest. | 1, 2, 3 | State plainly that rows past the cap are simply absent from the output file, with no warning. |
| Step 1, "wait for the viewport to fill with it" | Two readers did not know what "filled" looks like or how long to wait before deciding something had gone wrong. | 1, 2 | Say what appears on screen when the bundle has finished loading. |
| Step 2, "hinting `.vcf, .vcf.gz` underneath" | Two readers stopped on "hinting" as a verb describing screen text and read the sentence twice. | 1, 2 | Use a plainer verb and say the extensions appear as small text on the card. |
| What good looks like, "Sort by `Chrom` and read the value" | Two readers could not tell whether `Chrom` was the same column called "the first column of the VCF" earlier in the chapter. | 1, 2 | Use one name for this column throughout the chapter. |
| What it is, "It might be a published study's supplementary... a truth set downloaded from a benchmarking consortium" | Two readers met "truth set" and "benchmarking consortium" as unfamiliar terms defined only much later in the chapter. | 1, 2 | Gloss "truth set" at its first use here. |
| What it is, "tab-separated text file" | Two readers could not tell from this phrase whether they would ever open the VCF themselves or only ever hand it to the app. | 1, 2 | Say once, plainly, that the reader never opens or edits the VCF by hand. |
| What it is, "There is no inference readout, no dropdown" | Two readers could not picture what an "inference readout" would be, so could not tell what was actually missing from the app. | 2, 3 | Say plainly that the app never shows a guess about which reference the file matches. |
| Procedure, "The procedure has five steps" / step 5 as alternative | Two readers followed step 5 as a sequential next step after step 4, rather than recognizing it as an alternative path, and became confused. | 2, 3 | Label step 5 explicitly as an alternative path, not the next sequential step. |
| Step 3, "Only one operation can hold a bundle at a time" | Two readers could not tell how they would know a second import is waiting, or what message tells them so. | 2, 3 | Name the message that appears when an import is queued behind another operation. |
| Step 5, "the existing one is replaced, so type carefully" | Two readers were alarmed that this destroys something, with no statement of whether the replaced bundle can be recovered. | 2, 3 | State plainly whether the replaced bundle can be recovered. |
| Before you start, "Follow Calling Variants first" | Two readers could not choose between the prerequisite chapter and the step 5 path without knowing how long the prerequisite takes. | 1, 4 | Give a time estimate for the prerequisite chapter. |
| Reading the results, "since bcftools reports more than" (as first raised) / general caller-strictness difference | Two readers were told the callers differ in strictness with no explanation of why, undermining their ability to read the results table. | 3, 4 | Add one clause explaining why the two programs differ in strictness. |
| On the command line, whole section assumes a terminal is already open | Two readers found the command-line section assumes the reader already has a terminal open with the command available, with nothing saying how to get there. | 2, 4 | Add one line saying where these commands are typed. |
| What it is, "Most people arrive at Lungfish" three-clause opening | One reader could not tell whether they would ever open the VCF by hand from this sentence alone. | 1 | Say once that the reader never edits the VCF by hand. |
| What it is, "A VCF's coordinates are meaningless" | One reader met position 250,527 with no source, and read the sentence twice looking for the table it came from. | 1 | Say the position is one reused later in the chapter. |
| Why you would do this, "A position only one caller reports" | One reader followed the logic but could not tell what to actually do on screen to see agreement between callers. | 1 | Point forward to the Source column here. |
| Before you start, "choose File > New Project (Cmd-N)" | One reader was given three ways to do one thing in one sentence and could not tell which to use. | 1 | Give one route only. |
| Before you start, "The `.tbi` is a tabix index" | One reader could not tell whether the `.tbi` file is ever opened, renamed, or moved. | 1 | State plainly that the reader never opens or renames this file. |
| Procedure lead-in, "The first three do the import... which is the path you want" | One reader could not tell whether step 5 was a mistake or a real alternative. | 1 | Say plainly that step 5 is a valid alternative, not an error. |
| Step 3, "records a provenance entry" | One reader did not know what provenance means, with only a glossary link as a clue. | 1 | Gloss provenance inline at its first use. |
| Step 3, "you will be told to wait" | One reader could not tell whether a failed import must be restarted or whether it queues itself. | 1 | Say plainly whether the reader must start the import again after a failure. |
| Step 4, "Every track in the bundle loads into the one table at once" | One reader had no way to check they had gotten the result right, since the expected number of tracks is never stated. | 1 | State the expected number of tracks. |
| Settings, "**--output-dir.** Names the directory" | One reader skipped this thinking it was app-only, then worried it also changed the app, since nothing marked it command-line only. | 1 | Mark it command line only in the first clause. |
| Reading the results, "reading a benchmark row's 50" one-in-a-thousand source | One reader followed the arithmetic but not why one-in-a-thousand is the expected human rate. | 1 | Add one clause on where the one-in-a-thousand figure comes from. |
| Before you start, "Keep the two files together in one folder" | One reader could not tell whether "together" meant inside the project folder specifically or any shared folder. | 2 | Say plainly that any folder works as long as both files share it. |
| Step 3, "If the import fails on a permissions check" | One reader would not know how to make a folder writable, with no instruction given. | 2 | Add one sentence on what to do when the folder is not writable. |
| Step 4, "The table drawer along the bottom... opens by itself" | One reader worried the drawer might not open automatically if an earlier chapter was skipped, with no manual-open instruction. | 2 | Say how to open the table drawer manually if it does not appear. |
| Step 5, "a `.lungfishref` bundle holding variant rows and no reference sequence" | One reader could not picture what a variant-only bundle is good for, given the chapter's earlier claim that coordinates are meaningless without a reference. | 2 | Say plainly what the reader can and cannot do with a variant-only bundle. |
| Reading the results, "so 152 of the benchmark's rows were never in reach" | One reader could not tell where 152 came from until adding two other numbers themselves. | 2 | Show the sum that produces 152. |
| On the command line, "`bcftools view -H` counts in the same file" | One reader met a second tool with a flag and no explanation of what it counts. | 2 | Say what that command counts. |
| On the command line, "--fasta GRCh38.chr20.10.0-10.5Mb.fasta" | One reader could not run the example because this file was never in the earlier download list. | 2 | Say where the FASTA file comes from. |
| On the command line, "`Types : SNP: 809...` contradicts earlier counts" | One reader thought they had made an error when the command-line counts differed from the 809/77/75 figures given earlier, before the next paragraph explained the difference. | 2 | Warn before the output block that the counts will differ from the earlier figures. |
| What it is / "The whole thing turns on one question" | One reader did not know the idiom "turns on" and thought something was being switched on. | 3 | Say "depends on one question" instead. |
| What it is / "A VCF's coordinates are meaningless without one" | One reader did not know that "coordinates" here meant the position numbers in each row. | 3 | Gloss coordinates as the position numbers in each row. |
| What it is / "That is the entire decision tree" | One reader did not know "decision tree" as an English phrase. | 3 | Say "those are all the possible outcomes" instead. |
| What it is / "So what should you do with this?" | One reader read the rhetorical question as being about the VCF file rather than about the reader's own next action. | 3 | Drop the question and give the advice directly. |
| Why you would do this / "treated as an answer key" | One reader had to guess "answer key" from context. | 3 | Gloss it once as the correct answers to compare against. |
| Why you would do this / "bcftools reports more than is really there" (callers unglossed) | One reader did not know what bcftools and LoFreq are, since both appear before any explanation. | 3 | Gloss both tools as variant callers at first mention. |
| Before you start / "Download the file HG002.chr20.10.0-10.5Mb" dots in filename | One reader could not tell where the file name ended, since it contains many dots. | 3 | Show the two file names on separate lines. |
| Before you start / "the Download raw file button" | One reader could not find this button from the text alone and did not know what "raw" meant for a file. | 3 | Say where on the GitHub page the button sits. |
| Step 2 / "Cmd-Shift-I" | One reader could not tell whether Shift is pressed together with the other keys or after them. | 3 | Spell out that all keys are held down at once. |
| Step 1 / "keyed against the same 500 kb slice" | One reader did not know the phrase "keyed against". | 3 | Say the positions were measured along that same slice. |
| Step 3 / "Only one operation can hold a bundle at a time" (physical reading) | One reader read "hold a bundle" as physical and could not tell what to do if it happened to them. | 3 | Say plainly that the second import waits until the first finishes. |
| Reading the results / "about one every 520 bases" division | One reader could not reproduce the number, not seeing that 500,001 divided by 961 gives it. | 3 | Show the division. |
| Reading the results / "reading a benchmark row's 50 against a bcftools row's 225" scale | One reader did not understand what a Quality of 225 measures on its own scale. | 3 | Say briefly what bcftools quality measures. |
| On the command line / "Cap" as a verb and "The cap is silent" | One reader found "cap" as a verb unclear and read "the cap is silent" twice. | 3 | Say the export stops at 5,000 rows with no warning, avoiding both terms. |
| What it is / "LGE answers that question by" / what the viewport is | One reader could not tell what "the viewport" referred to, since their prior tool used a document list and a separate viewer. | 4 | Name the viewport once as the panel that fills the window when a bundle is opened. |
| Why you would do this / "so it is a far better description" | One reader could not judge why combining several technologies produces a better call set. | 4 | Add one sentence saying different technologies make different kinds of mistakes. |
| Before you start / "Download the file HG002.chr20.10.0-10.5Mb" .gz decompression | One reader was unsure whether the `.gz` needed to be decompressed before use. | 4 | State plainly not to decompress the `.gz` file. |
| Step 2 / "The panel accepts more than one file" | One reader did not know whether to also select the `.tbi` index file in the import panel. | 4 | Say to select only the `.vcf.gz` and leave the `.tbi` alone. |
| Step 5 / "reads the VCF's contig lines and record" | One reader met "contig lines" and "NCBI accession" both unglossed in an already long sentence. | 4 | Gloss contig as one named sequence in the file's header. |
| On the command line / "Both commands write a provenance sidecar" | One reader could not tell what the sidecar file was for, since it is glossed only by a link. | 4 | Say plainly that it is a small record of how the file was made. |
| Next / "revisit Reading the Variants Table to work" | One reader could not tell whether the link text and the chapter name used in the prerequisites list were the same chapter. | 4 | Use one consistent name for that chapter everywhere it is mentioned. |

Eighty rows total.

## Consensus

Twenty-five rows were hit by three or more readers.

- The step 1 check against the VCF's first column cannot be performed without a terminal.
- The reference-fetch from NCBI is unexplained and its "quietly" framing reads as alarming.
- The command-line route's optional status is never stated up front.
- The `.vcf.gz` and `.tbi` downloads are not clearly marked as two separate files.
- The Required Setup pack is named with no pointer to where it comes from.
- SQLite is named with no gloss and no statement of whether the reader ever touches it.
- Default Ploidy is named with no gloss and no statement of whether it needs action.
- The scope control is never located on screen.
- The 961-in-500,001 arithmetic is not connected to the one-in-a-thousand benchmark.
- A bare dot as a filter value is not glossed as "no judgement made."
- The preset chip is never located on screen.
- A `2/1` multi-allelic call is never glossed, though `0/1` and `1/1` are.
- The 0.571 allele frequency is never connected to the `0/1` genotype it supports.
- Clonal isolates is unglossed and does not help the reader judge their own file.
- The three explanations for an empty filtered view are promised but never listed.
- HG002's identity as a person, cell line, file, or folder is never pinned to one meaning.
- The roughly 200-row gap between the two callers' counts is never judged as expected or alarming.
- bcftools reporting more than is really there is stated with no reason given.
- The `.bcf` format is never glossed, and the conversion path is never given.
- The `Auto` import profile is used before Settings defines the term.
- The memory guidance for Fast, Low Memory, and Auto gives no number to check against.
- Command-line-only settings sit among app settings with no marker distinguishing them.
- The SNP, DEL, and INS abbreviations in the command-line output are never expanded or mapped to the earlier table's words.
- "Filter grammar" and "Search Builder" are both used with no cross-reference or gloss.
- The 5,000-record export cap gives no statement of what happens to the rows past the cap.
