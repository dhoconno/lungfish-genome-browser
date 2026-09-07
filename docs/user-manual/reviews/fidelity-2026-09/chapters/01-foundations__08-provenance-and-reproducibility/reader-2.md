# Reader report: Provenance and Reproducibility

Persona: senior, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "LGE stores that record as" | "Sidecar" is glossed as a small JSON file, but I still do not know whether I will ever see this file in Finder or whether it hides inside the bundle. | Say in one sentence whether the sidecar is visible in Finder. |
| What it is, "Open the chr20 reference bundle's" | The chapter tells me to open the sidecar but never tells me how. Do I double-click it? Does something in LGE open it? | Say that the Inspector shows this, so I do not go hunting in Finder. |
| What it is, "reproducibleCommand: lungfish-cli import fasta" | The first thing I am shown is a terminal command with flags, quotes, and `...` in the middle. I have never typed a command and could not tell whether I was meant to run this. | Say that this block is only a record of what happened and not something to type. |
| What it is, "LGE uses SHA-256, a standard" | I understand it is a fingerprint, but I do not know how I would ever compare two of them. Do I read 64 characters by eye? | Say how a person actually compares two checksums. |
| Why you would do this, "bcftools at 1.24 (managed conda" | I do not know what bcftools is, what conda is, or what `bioconda::bcftools=1.24=h6bd33b9_2` means. Four unknown words in one string. | Gloss bcftools at first use as the tool that calls variants. |
| Why you would do this, "LGE writes the record for every supported" | "Every supported workflow" left me unsure whether my own work would count as supported. | Say what makes a workflow supported, or drop the qualifier. |
| Why you would do this, "the HG002 minimap2 mapping built" | HG002 and minimap2 both arrive with no gloss. I could not tell whether HG002 is a person, a sample, or a file name. | Gloss HG002 as a standard human reference sample at first use. |
| Before you start, "Build it by following the instructions" | The build instructions live on a GitHub page outside the manual. I have never used GitHub and do not know what I would download or run there. | Say what the reader will do at that link, in one sentence. |
| Before you start, "Nothing in this chapter needs a plugin" | "Plugin pack" and "Docker Desktop" appear once, unexplained, only to say I do not need them. It made me wonder whether I needed them earlier. | Drop the sentence or gloss the two terms. |
| Procedure step 1, "Open the demo project and select" | I do not know whether `Reference Sequences/` is a real folder I would see or an internal grouping. | Say that it is a group in the sidebar. |
| Procedure step 4, "Select the HG002 bcftools variant track" | "Table drawer" appears here for the first time with no word on where it is or how to open it. I could not perform this step. | Say where the table drawer is and how to open it. |
| Procedure step 4, "eleven steps from staging the alignment" | samtools, bgzip, and tabix all arrive unglossed in one sentence. I could not tell whether I need to know them. | Say these are the underlying tools and the reader need not know each one. |
| Procedure step 5, "Choose Methods Section... to draft a" | Six formats exist but the Procedure names only two. I could not tell which to pick on a first try. | Name one recommended default for a first export. |
| Procedure, "Name the export folder in the save" | This paragraph sits outside the numbered list, so I read it twice before realising it continues step 5. | Number it as step 6. |
| Settings, "Provenance. Chooses what the export renders" | "Nextflow Pipeline" and "Snakemake Workflow" are offered as choices with no hint of what they are. I cannot judge whether they are for me. | Gloss both as pipeline languages a bioinformatician would run. |
| Settings, "Pick the target that matches what" | Every Settings entry ends with a command-line flag. I have never opened a terminal, so those lines told me nothing and made the chapter feel not for me. | Add a lead-in saying these lines serve terminal users only. |
| Settings, "Save As. Names the folder that receives" | Save As and Where both end with "On the command line this is `--output`". Two settings mapping to one flag confused me. | Explain that the one flag carries both the folder name and its location. |
| Reading the results, "Signatures appears only when the sidecar" | Signing is not explained until three sections later, so this row meant nothing when I met it. | Point forward to the Signing a record section here. |
| Reading the results, "bcftools mpileup -Ou -f" | A second raw command block. I do not know what `-Ou`, `-f`, or `-mv` do, and could not tell whether the chapter expects me to. | Say the reader need not decode the flags. |
| Reading the results, "The demo project's minimap2 mapping recorded" | I know 14 is a thread count, but I have no idea whether 14 is a lot, a little, or a number I should match. | Say what number a reader would normally see on their own Mac. |
| Reading the results, "Runtime names the machine. The chr20" | "Dependency set" is never defined in the chapter. I could not judge whether mine would differ. | Gloss dependency set as the versioned bundle of tools LGE installed. |
| What the export folder holds, "Inside it sits the primary artifact" | Six file names in one sentence, four of which I do not recognise as file types. I had to read it twice. | Put the format-to-file mapping in a small table. |
| What the export folder holds, "A script pulled out on its own" | This warns me about running a script, but I have no way to run one and no idea who does. | Say this warning is for the collaborator, not for me. |
| What the export folder holds, "On shared storage use lungfish-cli project lock" | The one piece of advice about sharing on lab storage is a terminal command, which I cannot run. | Say whether a menu equivalent exists. |
| What good looks like, "Confirm the input checksums in Files" | This is one of four trust checks, but I do not know what I compare the checksum against or where the other copy comes from. | Say where the second checksum comes from. |
| What good looks like, "And confirm that the step count" | I have never run this workflow, so I have no expected step count to compare against. | Give the expected count for the demo chain. |
| What good looks like, "A re-run on a different Mac" | This says results can shift on a different machine, which seemed to undercut the whole chapter. I read it three times working out how much to worry. | Say how large these shifts typically are. |
| Signing a record, "Its Provider control offers Off, Local" | "Cosign Plan" is named with no gloss at all and I cannot guess what it is. | Gloss Cosign as an external signing service. |
| Signing a record, "Signing only matters if you go" | The section teaches a setting, then tells me the payoff is reachable only from the terminal. I could not act on any of it. | Say plainly that signing is not for readers who stay in the interface. |
| On the command line, "lungfish-cli provenance holds three subcommands" | The whole section assumes a terminal. Two of the three subcommands have no menu equivalent, so features exist that I cannot reach at all. | Say whether these will ever appear in the interface. |
| On the command line, "~/Desktop/lge-docs/LGE Manual Demo.lungfish" | The `~` character appears in every path and is never explained. | Gloss `~` as the home folder. |

I learned that LGE writes down the exact tool version and options behind every result it makes, so I do not have to remember them six months later.

I still could not open the table drawer in step 4, because the chapter never says where it is or how to open it.

The sentence I liked most is "LGE writes down what ran, not what you meant to run."
