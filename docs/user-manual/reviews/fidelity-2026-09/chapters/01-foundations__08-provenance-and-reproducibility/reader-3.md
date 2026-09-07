# Reader report: Provenance and Reproducibility

Reader 3. Pre-med student, English is my second language, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "LGE stores that record as a..." | "Sidecar" is a motorcycle word to me. I could not picture a file that "sits beside" another file. Does it share the name? | One sentence saying the sidecar shares the result's name with a different ending. |
| What it is, "Open the chr20 reference bundle's sidecar" | I do not know how to open a JSON file, and the Procedure has not happened yet. I stopped and looked for a button. | Say that the Procedure below shows this inside the Inspector. |
| What it is, "reproducibleCommand: lungfish-cli import fasta..." | The command block has `...` in the middle of a path and I could not tell if the dots are real text or something cut out. | A note that `...` marks a shortened path. |
| What it is, "and a single changed base changes the whole string." | "Base" means a DNA letter, but the sentence before was about any file's bytes. I read it twice to see which one changed. | Say "a single changed letter in the sequence". |
| Why you would do this, "1.24 (managed conda environment bcftools..." | "Managed conda environment" and "bioconda::bcftools=1.24=h6bd33b9_2" are never explained. I do not know what conda is. | A short gloss for conda at first use. |
| Why you would do this, "The demo project holds an answer." | I read this twice. I thought the project literally contains a written answer about versions. | Plainer wording. |
| Why you would do this, "LGE writes the record for every supported workflow" | "Supported workflow" is not defined. I cannot tell which of my future work counts. | Point to where the supported workflows are listed. |
| Before you start, "Build it by following the instructions..." | The long web address sits inside the sentence. I could not tell whether I download something or run something. As a person who never used a terminal this worried me. | One sentence saying whether the fixture needs the terminal. |
| Before you start, "Nothing in this chapter needs a plugin" | "Plugin pack" appears here for the first time with no explanation. | Gloss it, or drop the mention. |
| Procedure step 1, "select the chr20_10.0-10.5Mb reference bundle" | The name here and the name in the caption are punctuated differently, so I was unsure I clicked the right item. | Use one exact name everywhere. |
| Procedure step 4, "in the table drawer instead of the reference" | I do not know what the table drawer is or where it opens. Nothing earlier mentions a drawer. | Gloss "table drawer" and say how to open it. |
| Procedure step 4, "eleven steps from staging the alignment through" | "Staging" is a word I only know from theatre. | Replace with "copying the alignment into place". |
| Procedure, "Name the export folder in the save panel" | This paragraph has no number, so I could not tell if it is step 6 or a remark about step 5. | Number it. |
| Settings, "Provenance. Chooses what the export renders" | "Renders" made me think of drawing. Also six choices are offered and I could not judge which one I need. | Say "produces", and give one clue per choice. |
| Settings, "Nextflow Pipeline..., Snakemake Workflow..." | Nextflow and Snakemake are never explained. I cannot tell whether I have them. | A gloss saying they are workflow programs a collaborator may run. |
| Settings, "for example sample-provenance-nextflow" | The example uses "sample" but the chapter's artifact is chr20. I thought "sample" was a setting word, not a name. | Use the chapter's own artifact name. |
| Settings, "On the command line this is --output" | Save As and Where both say `--output`. I read it three times thinking one was a typo. | Explain that one option covers both the name and the place. |
| Reading the results, "whatever the tool wrote to standard error" | "Standard error" means nothing to me. It sounds like a normal expected mistake. | Gloss it as the tool's message channel, not a failure. |
| Reading the results, "In the demo project's bcftools chain, step" | "Pileup" and "call" are used as nouns with no gloss. I know variants only vaguely from genetics class. | Gloss pileup at first use. |
| Reading the results, the two-line bcftools code block | I cannot tell whether these are two commands or one command split across lines. There is no prompt symbol. | Say they are two steps shown as Lineage shows them. |
| Reading the results, "sha256 3ee1418353a681cbd415a278ecc0bd9579121" | I do not know how to compare a 64-character string by eye. The chapter says checksums prove sameness but never says how I check one. | Say how a reader compares one, or that LGE compares it. |
| Reading the results, "The demo project's minimap2 mapping recorded -t 14." | I do not know what a thread count is or whether 14 is high, and the chapter later says it can change results. | Say what the number means before saying it matters. |
| Reading the results, "a dependency set of 2026.2" | "Dependency set" is not defined. I could not tell if it is a date or a version. | Gloss it. |
| What the export folder holds, "run.sh for Shell Script, reproduce.py" | Six filenames in one sentence. I lost track of which file goes with which format halfway through. | A small table of format and filename. |
| What the export folder holds, "use lungfish-cli project lock so two" | This tells me to use the terminal after the chapter said nothing before required it. | Say whether a menu can lock a project too. |
| What good looks like, "An empty Provenance section is worth a" | The next sentences say an empty section is a bug, then say a copied file is not. I read the paragraph three times to sort the two cases. | Put the not-a-bug case first. |
| What good looks like, "A re-run on a different Mac, a" | This frightened me. I could not tell how big "a little" is or whether my result is still valid. | Give an example of the size of the difference. |
| Signing a record, "Its Provider control offers Off, Local, and" | I do not know what Cosign is or what "Plan" adds to the name. | Gloss it, or say it is for organisations only. |
| Signing a record, "Signing only matters if you go on" | The sentence ends abruptly. I could not tell whether the command line checks it for me or whether I must run something. | Say plainly that only the CLI can verify a signature. |
| On the command line, "lungfish-cli provenance verify \"~/Desktop/lge-docs/LGE" | The path is in quotes and begins with `~`. I do not know what the tilde means. | Gloss the tilde as the home folder. |
| On the command line, "and --signature or --public-key point it elsewhere" | I do not know what a public key is or where I would obtain one. | Gloss public key, or say beginners can skip this. |
| Next, "Foundations is complete. Continue to one of" | After a chapter ending in terminal commands I was unsure whether I had finished the required part or skipped work. | A closing line saying the command-line section was optional. |

The one thing I learned is that LGE writes a record of every run by itself, so I do not need my own notebook of software versions.

The one thing I still could not do is compare a checksum to confirm my collaborator holds the same file, because the chapter shows me the strings but never shows me how to check one.

The sentence I liked most is "LGE writes down what ran, not what you meant to run."
