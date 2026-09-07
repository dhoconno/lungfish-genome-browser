# Reader report: Provenance and Reproducibility

Persona: sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "A sidecar answers one question." | The next sentence is written as a question but ends with a period, so I read it twice looking for the answer sentence. | Punctuate it as a question. |
| What it is / "Open the chr20 reference bundle's" | The code block is my first sight of a command line and it is long, with `.../` in the middle. I could not tell if `.../` is something I type. | Say in one clause that `.../` stands for a path the manual shortened. |
| What it is / "Open the chr20 reference bundle's" | "bundle" appears here for the first time and is never glossed. I do not know if it is a folder, a file, or a row in the app. | Gloss bundle at first use. |
| What it is / "LGE uses SHA-256, a standard" | I understand it is a fingerprint but not where it comes from or whether I ever have to compute one myself. | Say the app computes it and you only ever compare two. |
| What it is / "and a single changed base changes" | "base" reads as a DNA base, but the checksum is over file bytes, so I could not tell whether editing a header line also changes it. | Say any change to the file at all changes the string. |
| Why you would do this / "the sidecar names bcftools at" | I have never met bcftools and the chapter never says what it does. | Gloss bcftools at first use. |
| Why you would do this / "package bioconda::bcftools=1.24=h6bd33b9_2" | I could not read `bioconda::` or `h6bd33b9_2`, and I could not tell which part is the version. | Name which piece is the version and which is the build. |
| Why you would do this / "the HG002 minimap2 mapping built" | HG002 and minimap2 both arrive unexplained. I guessed HG002 is a sample but was not sure. | Gloss HG002 and minimap2 at first use. |
| Before you start / "You need a project open. If you" | I could not tell whether I should make a new project or use the demo project, since the next sentence says the chapter uses the demo one. | Lead with the demo project and make the new-project route the alternative. |
| Before you start / "Build it by following the instructions" | The fixture instructions live on a web page outside the manual, and I could not tell whether building the demo project needs a terminal. | Say up front whether the demo build is clicks or terminal. |
| Before you start / "Nothing in this chapter needs a" | "plugin pack" and "Docker Desktop" are both new, so I could not judge whether I still have something to install. | Gloss plugin pack, or shorten to "nothing to install". |
| Procedure step 1 / "Open the demo project and select" | The sidebar name has an underscore, but the command-line section writes the same item with a `.lungfishref` ending. I could not tell if they are the same thing. | Say the sidebar hides the file extension. |
| Procedure step 2 / "Scroll the Inspector to its Provenance" | I could not tell how far down the section sits, or what to do if I do not see it. | Say roughly where it falls among the other sections. |
| Procedure step 3 / "Read Run Summary at the top." | Exit status 0 and wall time are both new here. My first guess was that zero meant failure. | Gloss exit status and wall time at this step, not later. |
| Procedure step 4 / "Open the Lineage block and expand" | "the table drawer" is a place in the app I have not been shown, and step 1 used the sidebar instead. | Say what the table drawer is and how to open it. |
| Procedure step 4 / "eleven steps from staging the alignment" | "staging", "bgzip", and "tabix" all pass by unexplained and I could not tell whether I need them. | Say these are internal steps a reader does not need to follow. |
| Procedure step 5 / "Select the result you want to" | Only two of the six formats are named in the procedure, so I could not tell if the other four work at this step. | Say any of the six works and point to Settings. |
| Procedure / "Name the export folder in the" | This paragraph is not numbered like the five steps above it, so I thought I had finished at step 5 and skipped it. | Number it as step 6. |
| Settings / "Provenance. Chooses what the export renders" | The heading says Settings but these read as menu choices, not preferences I set once. I went looking for a preferences window. | Say these are choices made per export. |
| Settings / "offering Shell Script..., Python Script..., Nextflow" | Nextflow and Snakemake are named as if I know them, and I could not choose between them. | One clause saying both are pipeline systems a collaborator may already use. |
| Settings / "Save As. Names the folder that" | Both Save As and Where map to `--output`, which confused me because they are two separate fields in the app. | Say the two combine into one path on the command line. |
| Reading the results / "Signatures appears only when the sidecar" | Signatures is mentioned here but signing is not explained until much later in the chapter. | Point forward to the signing section. |
| Reading the results / "and whatever the tool wrote to" | "standard error" means nothing to me and I have never opened a terminal. | Gloss it as the tool's own progress and error messages. |
| Reading the results / "In the demo project's bcftools chain," | Pileup and call are used as names for steps I have not learned. | One clause on what a pileup is. |
| Reading the results / "The chr20 import's own record shows" | I could not tell how to compare two of these strings in practice, by eye or by some app feature. | Say whether to compare the whole string or only the first characters. |
| Reading the results / "The demo project's minimap2 mapping recorded" | I only learned `-t` means threads one sentence earlier, and I do not know what number is good. | Say the number reflects the machine and is not something to tune. |
| Reading the results / "Runtime names the machine. The chr20" | "dependency set" is not defined, and `2026.2` could be a date or a version. | Gloss dependency set. |
| Export folder / "Inside it sits the primary artifact" | Six filenames arrive in one sentence and I lost track of which belongs to which format. | Break it into a small table. |
| Export folder / "On shared storage use lungfish-cli project" | A terminal command appears in the middle of a clicking chapter with no menu alternative offered. | Say whether there is a menu way to lock a project. |
| What good looks like / "An empty Provenance section is worth" | The paragraph says an empty section is a bug and then says it is not. I read it three times to sort out which case is which. | Lead with the harmless case, then the bug case. |
| What good looks like / "And confirm that the step count" | I have no idea how many steps a normal run has, so I cannot judge whether a chain is short. | Give one number as an anchor, such as the eleven already cited. |
| Signing / "Its Provider control offers Off, Local," | "Cosign Plan" is never explained and I could not tell whether it costs money. | One clause on what Cosign Plan is. |
| Signing / "Signing only matters if you go" | The section says the default is right for me and then explains everything anyway, so I could not tell whether to act. | Say plainly that most readers leave it Off and skip ahead. |
| On the command line / "lungfish-cli provenance holds three subcommands." | The whole section assumes I can run commands. Nothing says where to type them or that the menu route already did the job. | One line saying this section is optional if you used the menu. |
| On the command line / "lungfish-cli provenance export \\" | The `~`, the quotes, and the backslashes at line ends are all unexplained typography to me. | Gloss `~` and say the backslash continues one command. |
| On the command line / "Check a signed sidecar against its" | The verify example runs against a whole project, but the paragraph below talks about a sidecar and its neighbouring files. I could not tell what I am pointing it at. | Say a project bundle target checks the sidecars inside it. |

Learned: every result LGE makes carries a written record of the tool, the version, the options, and the file fingerprints that produced it.

Could not do: run any of the command-line examples, or judge whether a checksum or a thread count I saw was the right one.

Liked most: "LGE writes down what ran, not what you meant to run."
