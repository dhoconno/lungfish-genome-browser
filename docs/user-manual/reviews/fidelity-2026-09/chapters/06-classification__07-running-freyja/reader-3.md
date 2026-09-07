# Reader 3 report, Running Freyja

Reader: pre-med student, English is my second language. I know biology words
from my textbooks. I have never opened a terminal.

| Location | Issue | Suggested fix |
|---|---|---|
| What it is, "Kraken 2, EsViritu, TaxTriage, and the importers" | Four names arrive in one sentence with no gloss. I do not know what EsViritu or TaxTriage are, and "the importers" sounds like people, not software. | Say "the read classifiers in the earlier chapters" and drop the four names, or gloss each one in three words. |
| What it is, "Which named varieties of SARS-CoV-2" | The paragraph asks a question of the reader before the word lineage is defined in the next paragraph. I had to read forward and come back. | Move the definition of lineage in front of the question. |
| What it is, "BQ.1 and BA.5.3.2 are both SARS-CoV-2" | These names are used as if familiar. I have heard of Omicron and Delta, not BQ.1. I could not tell whether BQ.1 is a big famous lineage or a small one. | Add one clause saying these are Omicron descendants circulating in late 2022. |
| What it is, "a few dozen positions out of nearly thirty thousand" | I could not judge this number. Is a few dozen a lot or a little for telling two lineages apart? The sentence gives the ratio but not the meaning. | Add the consequence, that this is few enough that a whole-genome consensus can hide the difference. |
| What it is, "mapping tells you what fraction of the reads carried the change" | "Mapping" is used as a bare noun for a process I have not done. The word links only later, in Before you start. | Say "the alignment step, covered in Mapping Reads to a Reference". |
| What it is, "solves for the mixture of lineages whose combined mutation profile comes closest" | Long sentence, four clauses, I read it three times. "Solves for" is a mathematics idiom I do not use in English. | Split into two sentences and replace "solves for" with "searches for". |
| What it is, "the rule for reaching for this chapter is short" | "Reaching for" is an idiom. I first read it as physically reaching. | "The rule for when to use this chapter is short." |
| Why you would do this, "stands in for tens of thousands of people" | "Stands in for" is an idiom. Also I could not judge whether tens of thousands is the normal size of a treatment plant. | "Represents tens of thousands of people". |
| Why you would do this, "It is worth being honest about a second limitation" | I never found the first limitation stated as a limitation, so I went back to look for it and could not find one labelled. | Number both, or say "one more limitation". |
| Why you would do this, "The SRR36291587 reads" | The accession number appears with no explanation of what an accession is or why it looks like that. It is only explained by a link two sections later. | Gloss at first use, "the public dataset SRR36291587". |
| Before you start, "choose File > New Project (Cmd-N)" | I do not know whether Cmd-N is typed instead of the menu or as well. Small point but I stopped. | Say "or press Cmd-N". |
| Before you start, "Download the reference file MN908947.3.fasta" | I could not perform this. The link goes to a folder listing on GitHub. Nothing tells me that on GitHub I must open the file and use a Download button, not right-click the link. | Add one sentence naming the button to click on the GitHub page. |
| Before you start, "fetch them from the Sequence Read Archive" | I could not judge the cost of this step. No size, no time. I do not know if this is a two-minute download or an overnight one. | State the approximate file size or download time. |
| Before you start, "Build a reference bundle from MN908947.3.fasta and map the reads to it with minimap2" | This is three separate multi-step jobs packed in one sentence with two links, and I could not tell how long the detour is or in what order to return. It is the point where I would give up. | Break into a short numbered list of three prerequisites with the link on each. |
| Before you start, "Leaving them in fakes allele frequencies at the amplicon edges" | "Fakes" used as a verb stopped me. I know "fake" as adjective or noun. | "Produces false allele frequencies". |
| Before you start, "Freyja reads nothing but allele frequencies" | Double negative construction, read twice. | "Allele frequencies are all Freyja reads." |
| Before you start, "The pack carries five programs rather than one" | The sentence after it lists Freyja, iVar, minimap2, Pangolin, Nextclade. Not one of these five is glossed, and Pangolin and Nextclade appear nowhere else until the last section. | Gloss each in three or four words, or say the other four are used by other chapters. |
| Before you start, "the pack is large enough that the download is not instant" | I could not judge this. Not instant could mean thirty seconds or an hour, and I would plan my afternoon differently. | Give an approximate size in gigabytes or a time range. |
| Before you start, "worth taking at face value" | Idiom. I understood it after a pause but it slowed me. | "worth believing". |
| Before you start, "LGE pins version 2.0.3 of it" | "Pins" as a verb for software versions is jargon I do not know. It is used again later in the Reading the results section. | "uses exactly version 2.0.3". |
| Before you start, "a barcode file dated 22 March 2026" | I cannot judge this against today. Is a barcode file from six months ago fine or badly stale? The What good looks like section says it should be recent but never says how recent. | Say roughly how often lineages change enough to matter, for example every few months. |
| Before you start, "Freyja has its own freyja update command" | The chapter tells me a command exists but not how to run it, and I have never opened a terminal. Half a step. | Either show the full command in a code block or say plainly this is out of scope. |
| Procedure, "Freyja is not a FASTQ or FASTA operation, so it never appears in the Tools category submenus" | Three format names and a menu structure in one sentence. I read it twice and I am still not sure what a "category submenu" looks like. | Cut to "Freyja does not read FASTQ or FASTA files, so it is not in the Tools menus". |
| Procedure, "The app does carry an internal handler for Freyja" | "Internal handler" is programmer vocabulary. Nothing in the sentence tells me anything I can act on. | Delete, or say "a leftover menu action". |
| Procedure, "The command line tool is lungfish-cli" | This is where I truly stop. I have never opened a terminal, and the whole procedure is command line. The one link is called The Command Line but the chapter does not warn me at the top that no part of this is clickable. | Put a one-line warning in the front matter or first paragraph that this chapter requires a terminal. |
| Procedure Step 1, the `freyja variants` code block | I cannot perform this. The text says it runs "from the pack's environment rather than through lungfish-cli", but never says how to get into that environment. There is no command shown for entering it. | Show the exact command that activates the pack environment. |
| Procedure Step 1, "srr36291587.trimmed.bam" | The file name appears with no statement of where it came from or which directory I should be in. My trimmed BAM from the earlier chapter surely has a different name and path. | Say the name is a placeholder for the primer-trimmed BAM path from the trimming chapter. |
| Procedure Step 1, the backslashes at line ends | I do not know what the `\` at the end of each line means, and there are five code blocks using it. I would not know whether to type it. | One sentence saying the backslash continues one command across lines. |
| Procedure Step 1, "16,779 rows and a depths table with 29,903 rows" | I can check the 29,903 against genome length, which is helpful. But I cannot judge 16,779 at all. Is that many? Should mine be close? | Say whether the variants row count is expected to vary a lot between samples. |
| Procedure Step 2, "Write the command plan without running anything" | "Command plan" appears here before it is defined. It is only explained in Reading the results. | Gloss at first use, "a file recording exactly what would be run". |
| Procedure Step 2, "with the three leading dots standing in for the full directory path" | I read this twice. The dots are in the middle of three separate paths in the example, not leading, so the description did not match what I saw. | "the dots stand in for the directory part of each path". |
| Procedure Step 3, "16.7 seconds of wall time" | "Wall time" is jargon. I guessed it means real elapsed time but I was not sure. | Gloss it once as clock time. |
| Procedure Step 3, "which the provenance sidecar records to the millisecond" | Provenance sidecar is linked to a glossary but never explained in the chapter body until much later. Three unfamiliar words in a row. | Gloss in half a sentence at first use. |
| Settings, "Every setting is a command-line flag" | "Flag" is not glossed. I know the word only as an object. | "a word beginning with two dashes that you add to the command". |
| Settings, Extra args, "such as --eps to change the minimum abundance" | "eps" is never expanded and I could not guess it. Also 0.001 is given as the default with no statement of what that means in percent. | Expand once and say 0.001 is one tenth of one percent. |
| Settings, Dry run, "the flag is redundant on its own because not executing is already the default" | Two negatives plus "redundant". I read this three times before understanding. | "On its own the flag changes nothing, because not executing is already the default." |
| Reading the results, the code block starting with a blank label line | The first line of the output starts with a tab and a path with no label. I could not tell whether that is a heading, a filename, or an error. | Say in the prose that the first line names the input file. |
| Reading the results, "[('Omicron', 0.9885371959826457)]" | The brackets, parentheses and quotes are a programming data format I do not recognise, and it is not explained. | One sentence saying this is a name and its proportion in the tool's own notation. |
| Reading the results, "the long lineage and abundance lines wrapped to fit" | I could not tell from the block which numbers pair with which names once they wrap, because the second wrapped line of names sits above the first line of numbers. | Show a small two-column table of the top few pairs instead. |
| Reading the results, "no other group reached the threshold to be listed" | Which threshold? A number is not given here, and the 0.001 default appears only in Settings, far above. | Name the threshold and its value at this point. |
| Reading the results, "absorbing part of the signal" | Metaphor. I understood it only after reading the next sentence about the solver splitting evidence. | Lead with the mechanical explanation, then the image. |
| Reading the results, "The lesson generalises." | Very short abstract sentence between two long ones. I stopped to ask what "generalises" refers to. | "The same caution applies to other samples." |
| Reading the results, "`coverage` is the percentage of genome positions covered by at least ten reads" | The word coverage was already used in the earlier prose in a looser sense, so its exact meaning arrives late. Also I could not judge "drops into the tens" as a phrase. | Give a concrete unusable example, for example 40 percent. |
| Reading the results, "`resid` is the residual" | The chapter says smaller is better, zero is perfect, this run is 12.29, and then that no threshold is quoted. So I still cannot tell whether 12.29 is good. That is the number I most wanted to judge. | Say what a typical range looks like for this pipeline, even approximately. |
| Reading the results, "a SHA-256 checksum" | Not glossed. I do not know what a checksum is or why it proves anything. | "a short fingerprint of the file contents that changes if the file changes". |
| Reading the results, "the question a reviewer asks about a published figure" | This assumes I have published a figure and been reviewed. I have not. | "the question a reviewer will ask, which is what was run against what". |
| What good looks like, "the twelve of them summed to 0.9885" | I counted the lineages in the output block to check twelve and it took me a minute. Also I did not see why the sum equals the Omicron figure until the clause at the end. | Put the reason first, then the coincidence. |
| What good looks like, "A total well under 1" | "Well under" is not a number. Is 0.95 well under? 0.7? | Give a rough figure to worry at. |
| On the command line, "cat demix-run/freyja-demix.tsv" | `cat` is never explained. I would not know this shows the file rather than doing something to it. | Add a trailing comment saying cat prints the file. |
| Next, "pins a Freyja container built for Intel processors only" | "Container" is a new term in the last paragraph, and the Intel versus Apple Silicon point assumes I know which chip my Mac has. | Gloss container in four words, and say how the app decides. |

Three closing lines.

The one thing I learned. Freyja answers a different question from the
classifiers, which is not what is here but in what proportions, and a
consensus sequence throws that away.

The one thing I still could not do. Run any of it. I have never opened a
terminal, the chapter never warns me at the top that everything is
command line, and Step 1 asks me to work inside "the pack's environment"
without showing the command that puts me there.

The sentence I liked most. "A pure sample of one lineage shows its own
defining mutations at close to 100 percent and nothing else."
