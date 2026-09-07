# Reader 1 report, Aligning Sequences

Persona: sophomore fresh from a genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Conservation at a column is" | I do not know the word residue. The chapter uses it constantly from here on and never says what it is. | Gloss residue at first use as one base or one amino acid. |
| What it is, "the share of the non-gap" | Share of what, out of what. I could not tell whether a column of A A A - - is 3 of 3 or 3 of 5. | Give the arithmetic once with a tiny worked column. |
| What it is, "LGE aligns with MAFFT and" | I did not know how to say MAFFT or what it stands for, and there is no glossary link on it here. | Link MAFFT to the glossary on this first mention. |
| Why you would do this, "Their individual lengths run from" | I could not check this against my own file. The chapter never says which record is which length except the two extremes later. | A five-row table of name, accession, and length. |
| Before you start, "Download the file primate-mito.fasta" | The link points at a folder, not a file. I did not know which file inside to take or how to download one file from GitHub. | Say to click the file then Download raw file. |
| Before you start, "MAFFT arrives in the multiple-sequence-alignment" | I opened Plugin Manager and did not know what to click. The step says install it but not how. | One sentence naming the button in the Plugin Manager. |
| Before you start, "The pack ships MAFFT 7.526" | I did not know whether that number matters to me or whether a different number is a problem. | Say whether the version needs to match. |
| Procedure step 1, "Open the imported bundle so" | I did not know where the imported bundle appears. The import chapter is a separate read and I did not have it open. | Name the sidebar folder the imported bundle lands in. |
| Procedure step 1, "Select all five, or select" | I did not know how to select all five. Click and drag, Cmd-A, or click each one. | Say the gesture. |
| Procedure step 3, "Selected sequences (n), with the counts" | The letter n confused me. I looked for a literal n in the picker. | Write it as a number the way All sequences (5) is written. |
| Procedure step 3, "Where there is no choice" | I read this twice and still do not know when that happens or what it looks like. | Drop it or give the one case. |
| Procedure step 5, "the shipped defaults are right" | I could not tell which controls I was leaving alone, because the Advanced Options group was collapsed and I never opened it. | Say to leave Advanced Options collapsed. |
| Align the five genomes, "MAFFT scores a gap as" | I did not follow why scoring a gap like a residue makes realignment unreliable. | One clause saying the old gaps then get treated as real data. |
| Import an alignment, "the a2m and a3m profile" | I have never met a2m, a3m, Stockholm, or profile formats. | Say these are formats you meet only if a collaborator sends one. |
| Settings, "accepts a full FASTA header" | I do not know what a full FASTA header is versus a bare accession versus a label. Three things, no examples. | One example of each, since the CLI block later has them. |
| Settings, "Strategy. Picks how hard MAFFT" | I could not judge L-INS-i against the other five codes. Only two of the six are explained. | Say the other four are for cases this manual does not cover. |
| Settings, "leaves ragged gap columns" | I do not know what a ragged gap column looks like on screen. | Point at the illustration or describe the look. |
| Settings, "which shows up as a protein" | I could not picture a protein alignment scored as DNA or how I would notice it. | Say what the symptom looks like on screen. |
| Settings, "carry selenocysteine, stop codons" | Selenocysteine is not a word from my genetics course. | Gloss it or cut it, since the case is rare. |
| Settings, "Threads. Sets how many processor" | The default is blank and I did not know if blank means one core or all of them. | Say blank means the app picks a count. |
| Settings, "byte-identical result on a rerun" | Byte-identical stopped me. I was not sure whether a non-identical rerun is a wrong answer or just a different file. | Say the alignment can differ slightly without being wrong. |
| Settings, "a custom gap-opening penalty" | I do not know what a gap-opening penalty is. | Gloss gap penalty at first use. |
| Viewport display controls, "Numbering, the two consensus sliders" | I did not know what the Inspector is or how to open it. It is used as a place I should already know. | Name the menu item or shortcut that shows the Inspector. |
| Viewport display controls, "Low support (of non-gap residues)" | The heading is a phrase I could not parse. Low support of what, and low support means mask. | Rename in plain words, or put the meaning in the first clause. |
| Low support paragraph, "which defaults to 0.6 rather" | Two different defaults for one idea, and I did not know which one I was actually getting. | Say the dialog and the CLI genuinely differ, on purpose. |
| High gap, "This setting has no command-line flag, though" | The sentence carries two opposite facts and I had to read it twice. | Split it into two sentences. |
| Mask, "which writes X for protein" | I did not know why X and N differ or that N means any base. | Gloss N as any base. |
| Reading the results, "Annotations carried by the source" | I did not know what an annotation is here, and being told I cannot turn them off sounded like a warning. | Gloss annotation and say whether the primate file has any. |
| The numbers, "alignment added 672 gap columns" | I could not reproduce 672 or 835 from the numbers given. I tried subtracting and lost track of which row. | Show the subtraction once. |
| The numbers, "That is 29 percent of the" | I make 5,053 of 17,247 about 29.3 percent, so I doubted my own arithmetic. | Say the figure is rounded. |
| The numbers, "Under a few percent means your" | A few percent is not a number I can check my alignment against. | Give a figure. |
| Pairwise identity, "The clearest single check is" | I could not find where to open a pairwise identity matrix in the app. The section only reports numbers. | Say whether the matrix is in the Inspector or CLI only. |
| Pairwise identity, "come out at 0.926, the highest" | I do not know whether 0.926 is a fraction, so 92.6 percent, or some other score. | Say it is a fraction. |
| Pairwise identity, "The Inspector reports the alignment's own" | This told me not to trust the manual about the Inspector, which left me unsure what to check. | Name at least one row that is always there. |
| Acting on a selection, "It enables only when more than" | I could not turn "an annotation is part of the selection" into something I do. | Say to select columns that already carry an annotation. |
| Acting on a selection, "exceed 5 MB, rather than failing" | I do not know how many sequences 5 MB is, so I cannot predict when it happens. | Say roughly when this bites. |
| What good looks like, "the Operations panel holds the reason" | I did not know where the Operations panel is until the last paragraph of the section. | Move the Cmd-Shift-P shortcut to the first mention. |
| On the command line, "The block below reproduces the whole" | I have never opened a terminal and did not know whether this section was for me. | One line saying the app steps already did all of this. |
| On the command line, "lungfish msa is a different command" | The code block says lungfish-cli and this sentence says lungfish. I could not tell if they are the same program. | Use one name throughout. |
| Command line table, "msa export ... (default fasta)" | Settings said the sheet default is aligned-fasta. Two defaults for one thing confused me until the note after the table. | Put the note before the table. |
| Command line, "--parsimony-uninformative for columns that carry" | Parsimony is a word I have not met, and "carry no grouping signal" did not help. | Gloss it or cut it. |
| Command line, "--codon-position 1|2|3 for a CDS" | CDS is never spelled out. | Spell out coding sequence. |
| Command line, "with no correction for the changes" | I did not follow what reverting or happening twice means for a count. | One clause saying a site can change back and hide the change. |

The one thing I learned: an alignment is a rectangle, and once it is a rectangle a column becomes something you can count.

The one thing I still could not do: get the pairwise identity matrix on screen, because the chapter reports the three numbers without saying where in the app they live.

The sentence I liked most: "An alignment that says otherwise is telling you something went wrong with the run, not something new about primates."
