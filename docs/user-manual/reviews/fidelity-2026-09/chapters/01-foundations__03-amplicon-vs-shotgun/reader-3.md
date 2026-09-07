# Reader report: Amplicons and Shotgun Sequencing

Reader 3. Pre-med student, English is my second language, no terminal experience.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is / "Somebody first turned a tube..." | "Library prep" is used before I know what a library is. In English a library is a building with books. I could not guess the meaning from the sentence. | Say in one clause that the library is the prepared mixture of DNA fragments the machine reads. |
| What it is / "In shotgun sequencing the sample is..." | The word "shotgun" is a gun. I read the sentence twice before I understood it is a metaphor about scattering. | Add three words saying the name comes from the scattered pattern. |
| What it is / "Each holds the same four lines" | This assumes I remember the FASTQ format from the previous chapter. I did not. | Name the four lines once here. |
| What it is / "Nothing inside the file announces which" | "Announces" for a file is unusual English for me. I stopped to check I understood. | Use "records" or "states". |
| What it is / "So what should you do with this?" | This question is spoken to me suddenly and the paragraph changes voice. I read it twice to see if I had missed a heading. | Remove the question and keep the instruction sentence. |
| Why you would do this / "It holds 45,574 Illumina read pairs" | I do not know if 45,574 read pairs is a lot or a little. The text never says. | Say whether this is a small, typical, or large file. |
| Why you would do this / "reach a mean depth of 44.7" | I do not know how to judge 44.7. Is 10 bad? Is 100 needed? The definition of depth arrives after the number. | Define depth before the number and say what range is usually enough. |
| Why you would do this / "cover 99.99% of the slice" | I cannot tell if 99.99% is expected or excellent. Every percentage near 100 looks the same to me. | Say what a poor value would look like. |
| Why you would do this / "and it climbs and falls gently" | "Local base composition" is not explained. I know bases are A, T, G, C but not what composition does to coverage. | Gloss it as the local proportion of G and C. |
| Why you would do this / "It holds 30 macaque samples prepared" | "PCR against the MHC" uses a preposition I could not parse. I know PCR but not "against" here. | Use "PCR targeting the MHC". |
| Why you would do this / "and the reference it is genotyped" | "Allele" is used with no gloss and it is not linked like the other terms. I learned it in genetics but was not sure it means the same here. | Gloss allele at first use. |
| Why you would do this / "577 of them 156 bases long" | I could not tell why two different lengths matter or what I should do with this fact. | Say in one sentence why the two lengths exist. |
| Shotgun sequencing / "In a shotgun prep the nucleic" | "Physical shearing" is a word I only know for sheep and scissors. I had to guess. | Say "physically broken by force". |
| Shotgun sequencing / "Where any given read lands is" | "Close enough to random for the purpose" is idiomatic. I understood the words but not the intent on first reading. | Say the positions are effectively random. |
| Shotgun sequencing / "If your target is one part" | The jump from a ratio to "one read in ten thousand" was fast. I re-read to check the arithmetic was the same idea. | Keep one form of the ratio only. |
| Amplicon sequencing / "Two primers, each usually 18 to" | "Polymerase" is not glossed. I know it from class, but the chapter glosses easier words like primer and not this one. | Gloss polymerase at first use. |
| Amplicon sequencing / "One primer pair covers one stretch." | "Tiling" is in the glossary list at the top of the file but the word is not linked in the text, unlike primer and shotgun. | Link the word like the other glossary terms. |
| Amplicon sequencing / "The Williams project works differently, because" | "Loci" is a Latin plural and not glossed. I guessed "places". | Use "chosen gene positions". |
| Amplicon sequencing / "The polymerase makes occasional errors that" | "Chimeric product" is used with no gloss. I did not know the word chimeric in a molecular sense. | Gloss chimeric as an artificial hybrid of two molecules. |
| Amplicon sequencing / "Most of these show up as" | I do not know if 0.05 is strict or permissive, or what unit it is. Percent? Fraction? | State it is a fraction, so 5% of reads. |
| What an amplicon looks like / "A 22-base forward primer binds at" | Positions 1000 to 1021 is 22 numbers only if both ends count. I had to count on my fingers to check. | Say the range is inclusive. |
| What an amplicon looks like / "The amplicon is everything between and" | I counted 1399 minus 1000 as 399 and then had to re-read to see the end is included. | State the inclusive count in the same clause. |
| What an amplicon looks like / "Read 2 covers positions 1250 to" | I could not see where 1250 came from. The text gives 150-base reads but does not show the subtraction. | Show that 1399 minus 149 gives 1250. |
| What an amplicon looks like / "Read 2 covers positions 1250 to" | "From the other strand" assumes I hold the double helix orientation in my head. I could not picture which direction read 2 goes. | One clause saying read 2 is sequenced backwards from the right end. |
| What an amplicon looks like / "The primer overwrote it." | This is a metaphor and I first thought the software overwrote a file. | Say the primer sequence replaced the sample sequence during PCR. |
| Primer trimming / "Its engine is bbduk by default" | Two tool names in code font with no explanation of what they are or where I would see them. | Say these are the two choices in a menu. |
| Primer trimming / "Its engine is bbduk by default" | I cannot tell which engine I should pick or when the alternative is better. | One sentence on when to switch. |
| Primer trimming / "In LGE this runs after alignment" | I could not perform this. It says the Inspector's Primer Trim tab but never says how I reach the Inspector. | Say where the Inspector is in the window. |
| Primer trimming / "In LGE this runs after alignment" | "Provenance sidecar" is two unfamiliar words together. I do not know if it is a file, a panel, or a setting. | Say it is a small file saved beside the result. |
| Primer trimming / "Some ivar trim options can drop" | Which options? I could not act on this warning. | Name the option or say the linked chapter names it. |
| What a primer scheme is / "For each primer it records which" | The score column is listed but never explained. I do not know what a good score is or if I should care. | Say the score is unused here. |
| What a primer scheme is / "BED counts positions from 0 and" | I read this three times. Two ideas, counting from 0 and excluding the end, are compressed into one hyphenated term. | Split into two short sentences. |
| What a primer scheme is / "Inside sit the BED file, the" | "Where the scheme supplies them" makes the FASTA conditional and I could not tell what happens when it does not. | Say what is missing when the FASTA is absent. |
| The schemes LGE ships / "Four are from the ARTIC network." | "More rows than twice the amplicon count" is a double comparison and I had to work out 218 against 98 by hand. | Give the arithmetic plainly. |
| The schemes LGE ships / "ARTIC SARS-CoV-2 V4 and ARTIC SARS-CoV-2" | Two primer numbers for two schemes in one clause. I could not tell which number belongs to which version. | Split the sentence. |
| The schemes LGE ships / "ARTIC SARS-CoV-2 V4 and ARTIC SARS-CoV-2" | "Spike-in" is jargon and "Omicron mutations" assumes I follow SARS-CoV-2 lineages. | Gloss spike-in as extra primers added later. |
| The schemes LGE ships / "Any scheme LGE does not bundle" | I have never opened a terminal. This gives only the command-line way, so I do not know how to import a scheme in the app. | Give the menu path for importing in the app. |
| The schemes LGE ships / "Every bundled scheme declares both MN908947.3" | I do not know what an accession is. The word appears earlier only buried inside a longer sentence. | Gloss accession as a public database identifier. |
| The schemes LGE ships / "Trim a V4.1 sample against the" | "Tidy-looking" is ironic and I first read it as a good outcome. | Say the list looks convincing but is false. |
| How to tell which prep / "The sequencing submission record names the" | SRA and ENA are not expanded. I do not know these databases. | Expand both names once. |
| How to tell which prep / "Guessing at a scheme is worse" | The reason given is that trimming clips real bases "along with nothing useful", a double negative I had to untangle. | Say it removes real data and removes no primer. |
| Target enrichment / "Target enrichment, also called capture or" | Three names for one thing in one clause, and "hybridisation" is not glossed. | Keep one name and gloss hybridisation. |
| Target enrichment / "Twist and IDT sell panels of" | Two company names with no context. I did not know if these are products I need. | Say they are commercial suppliers, as examples only. |
| Target enrichment / "When you inspect coverage, expect the" | I do not know what a dip in coverage looks like or how deep a dip is a problem. | Say what depth would worry you. |
| What good looks like / "Confirm the primer trim actually ran," | I could not perform this check. It does not say what I would see that proves the trim ran. | Say what marking appears on the track. |
| What good looks like / "And look at the variant list" | I do not know how many calls make a cluster or what frequency counts as high. | Give an approximate number. |

Learned: amplicon reads always begin and end at the same designed primer positions, and that is why a primer can look like a real mutation to a variant caller.

Could not do: run the alignment-based primer trim, because I never found where the Inspector is or how to open its Primer Trim tab.

Liked most: "A variant caller has no way to tell that apart from a real fixed mutation, so it reports one. What it found was the primer."
