# Reader 3 report, Subsetting and Extraction

Persona: pre-med student, English is my second language, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Subsetting means making a smaller" | The word "subsetting" is in the title but the meaning arrives only in the first body sentence. I read the title and did not know what the chapter was about. | Put the plain meaning in the title line. |
| What it is, "A bundle is the folder" | I do not know what "the folder LGE treats as one object" means. Is it a folder I can open in Finder, or something invisible? | Say whether a bundle is a normal folder. |
| What it is, "and a read bundle carries the extension" | "Extension" means the ending of a file name, but a bundle was just called a folder. A folder with a file ending confused me. | Say a bundle is a folder whose name ends in `.lungfishfastq`. |
| What it is, "Extract Reads by Motif matches a sequence motif" | I know "motif" from a lecture as a protein pattern. Here it seems to be plain DNA letters. The gloss helped but came after the hard word. | Give the plain words before the term. |
| What it is, "Select Reads by Sequence matches an adapter" | I do not know what a barcode is in sequencing. Adapter is glossed, barcode is not. | Gloss barcode at first use, like adapter. |
| Why you would do this, "Any measure that grows with depth" | "Depth" is used with no explanation. I guessed it means how many reads, but I was not sure. | Gloss depth the first time it appears. |
| Why you would do this, "removes that particular objection before" | I read this twice. It is an English idiom about arguing, not about data, and I could not tell what the objection was. | Say plainly that the comparison is then fair. |
| Why you would do this, "45,574 read pairs from a well-characterized" | The results table says "the 45,574 in" as reads, not pairs. I could not tell if the file holds 45,574 reads or 91,148. | Use the same unit in both places. |
| Why you would do this, "They came off five separate sequencing runs" | Later the text says 10,622 reads from HISEQ1 and 34,952 from "the other one". Five runs but two instruments, and I could not work out which number belongs to what. | State the two instrument names once. |
| Why you would do this, "a small number of them run" | "Run through into the sequencing adapter" is a phrase I did not understand at all until the Search End paragraph much later. | Move that one-line explanation here. |
| Before you start, "These operations use tools from" | I do not know what a "pack" is or whether I already have it. The sentence says LGE installs it by itself, so I do not know if I must do anything. | Say plainly that no action is needed. |
| Before you start, "and no Docker Desktop is needed" | I have never heard of Docker Desktop. Being told I do not need it did not help me, it only worried me. | Drop it or gloss it. |
| Procedure, "There is no wizard with multiple" | I do not know what a wizard is in this program, so a sentence telling me there is not one was empty for me. | Say the window has one page. |
| Procedure step 3, "Type `10000` into the Count" | I was not sure if "Enter a positive read count." is an error I caused or a normal hint. | Say it is a hint next to the Run button. |
| Procedure step 4, "Leave Output Strategy on Per" | I did not know that selecting one bundle mattered until the Settings section. Here it is asserted with no reason. | Add a clause saying why one bundle means Per Input. |
| Procedure, "Extract Reads by ID takes a" | Three new control names in one sentence with no example. I could not picture the window. | Split into short sentences or point to the shot. |
| Paired reads stay paired, "A paired-end sample is stored inside" | "Interleaved" and "consecutive records" are both new. I understand only because of the gloss link, and I cannot check it since I cannot see the file. | Give a two-line example of the layout. |
| Paired reads stay paired, "Subsample by Count on a paired" | I read this three times. The sentence says 10,000 then 5,000 then 10,000 again and I lost track of which number I type. | Say clearly that you type the read count you want. |
| Settings, Proportion, "The share of reads to keep" | The entry gives two different reasons to set it, in "Set it when" and in "which is the right choice", and I could not tell which one applies to me. | Give one reason per setting. |
| Settings, Proportion, "Asking for 0.1 of the fixture's" | 4,473 out of 45,574 is 9.81 percent only if 45,574 counts reads. Earlier the fixture was described in pairs, so I could not verify it. | Fix the unit so the number checks out. |
| Settings, Query, "Read the next paragraph before using" | Being told to read on made me anxious that I would break something. I did not know if a wrong query is harmful. | Say a wrong query only returns zero reads. |
| Settings, Query, "A plain query must match the" | This is the most surprising thing in the chapter and I still do not know why an exact whole match is the default. | Add a clause on why exact is the default. |
| Settings, Field, "Chooses which part of the name" | I have never looked at a FASTQ name line. I cannot tell if my own file has a space in it. | Show one real name line. |
| Settings, Use Regular Expression, "A regular expression is a small" | I have never seen a regular expression. The gloss is a whole other page and I did not want to leave the chapter. | Give the one rule I need here in plain words. |
| Settings, Pattern, "Set it to a primer footprint" | Three examples, none of which I can supply myself. I do not know any of my own sequences. | Point back to the Alu example as the one to copy. |
| Settings, Pattern, "Searching the fixture for the 26-base" | 260 plus 261 is 521, but I do not know how a read cannot be counted in both halves at once. | Say each read is counted once. |
| Settings, Use Regular Expression, "Turn it on when the motif" | "Degenerate" is glossed inside the sentence, which helped, but I could not tell how I would know my motif has such a position. | Say where degenerate positions come from. |
| Settings, Use Regular Expression, "Writing `GCCTCCCAAAGTGCTGGGATTACAG[GA]` means either G" | 565 minus 521 is 44, so this checks, but the earlier example split its total into two halves and this one does not. | Keep the two examples parallel. |
| Settings, Sequence or FASTA Path, "LGE decides which you meant by" | I do not know what a path looks like, since I have never used a terminal. I am afraid my sequence will be read as a path. | Say a path contains a slash. |
| Settings, Search End, "Chooses which end of the read" | I do not know what 5' and 3' mean for a read as opposed to a strand of DNA. My genetics course taught the chemistry, not the file. | Say 5' end means the first bases in the file. |
| Settings, Search End, "The command line has a third" | This paragraph is about the command line, which the chapter later calls optional. Meeting it inside the window settings confused me about which surface I was reading. | Move CLI differences to the CLI section. |
| Settings, Min Overlap, "It defaults to 16 in the" | "Reads this long" assumes I know the fixture's read length. It appears only much later, as 250 bases. | State the read length here. |
| Settings, Min Overlap, "Searching its reads for the Illumina" | I understand the warning, but I do not know how to choose a value for my own data, only that 8 is bad here. | Give a rule for picking a value. |
| Settings, Error Rate, "It defaults to 0.15 in the" | 0.15 times 16 is 2.4, and I did not know whether that rounds down to 2 or up to 3. | Say the number is rounded down. |
| Settings, Keep Matched Reads, "On the command line this is" | I read this twice. Three negatives in one clause in a language that is not my first. | Split into two short sentences. |
| Settings, Search Reverse Complement, "Turn it on for unstranded libraries" | "Unstranded library" is not glossed. I do not know whether my own library is stranded. | Gloss stranded and unstranded. |
| Reading the results, "The new bundle appears in the" | "Summary cards" and "parent" are both used before being explained. I guessed parent means the original bundle. | Name the original bundle the parent once, earlier. |
| Reading the results, "Subsample by Count, 10000" | 10,000 out of 45,574 is 21.9 percent, so the arithmetic works, but the column heading "Share of the 45,574 in" I could not parse. | Reword the column heading. |
| Reading the results, "The fourth says about one read" | 521 out of 45,574 is one in 87, close enough, but "Alu right-arm end" is a new term at the last moment. | Drop or gloss right-arm. |
| Reading the results, "which is roughly what a human" | I do not know what a shotgun library is, and this is its first use. | Gloss shotgun library. |
| Subset bundles hold no reads, "Reveal the bundle in the Finder" | I do not know the menu command that reveals a bundle in the Finder. | Name the menu item. |
| Subset bundles hold no reads, "If you need the reads as" | The chapter later says the command line is optional, but here it is the only way to do something. That is a contradiction for a reader like me. | Say whether the window can do it too. |
| What good looks like, "A proportion subsample should land within" | "Within a percent or so" is vague, and the one example was 9.81 against 10. I do not know if 9.0 would be fine. | Give the acceptable range as two numbers. |
| What good looks like, "Its reads are 76.7 percent from" | The instruments are still never named, so I cannot check this against my own sidebar. | Name the instruments. |
| On the command line, "This section is optional. Everything above" | I have never opened a terminal, so I do not know what running a command means in practice. I was glad this is optional. | Nothing needed, the optional label is enough. |
| On the command line, "--search-end right --min-overlap 16 --error-rate" | Everywhere above the ends are called 5' End and 3' End, but here the value is "right". I could not match the two names. | Say right means the 3' end. |
| On the command line, "It converts your error rate and" | "Edit distance" is a new term in the last section and it is never explained. | Gloss edit distance or drop the detail. |
| On the command line, "so `--min-overlap 18 --error-rate 0.15` fails" | I do not know what a Java error looks like or whether it means I broke something. | Say the run simply stops. |
| Extracting reads from a list, "Note that the output is gzip-compressed" | I did not know that gzip-compressed means the file is squeezed smaller and still usable. | Gloss gzip. |
| Extracting reads from a list, "Reading names from a file is" | Three more commands are listed with terms I do not know, in a section I was told is optional. | Cut to the classifier route only. |

The one thing I learned: a random subsample and a targeted extraction are two different jobs, and choosing between them is only asking whether I care which reads I get.

The one thing I still could not do: pick a Min Overlap and an Error Rate for my own data, because every number is explained for this one human fixture and no rule is given for anything else.

The sentence I liked most: "Treat a result that keeps most of your reads as evidence the overlap is too low, not as evidence of contamination."
