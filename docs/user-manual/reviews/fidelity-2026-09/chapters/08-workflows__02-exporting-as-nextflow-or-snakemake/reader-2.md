# Reader 2 report

Persona. A senior who has spent two years pipetting in a wet lab. I know
library prep and PCR. I have never analyzed sequencing data and I have never
opened a terminal.

| Location | Issue | Suggested fix |
|---|---|---|
| Front matter, "audience: analyst" | The chapter labels itself for an analyst. I am not one, and nothing tells me whether I am supposed to be reading this. | Say in the first paragraph who this chapter is for. |
| What it is, "Nextflow or Snakemake" (title) | The title uses two words I have never seen, and neither is explained until much later. Nextflow is never actually defined anywhere in the chapter. | Gloss both in the first sentence of What it is as systems for running an analysis as a series of steps. |
| What it is, "it writes down what it did" | I did not know LGE was recording anything at all. This is presented as a fact I should already know. | Add one clause saying this happens automatically with no setting to turn on. |
| What it is, "a small JSON file" | JSON is used with no gloss on first use. I have never opened one. | Gloss as a plain text format that both people and programs can read. |
| What it is, "the exact command line" | "Command line" is used before the chapter tells me what a command line is. The terminal is only explained in the optional last section. | Gloss as the typed instruction the app sent to the tool. |
| What it is, "the tool and its version" | I do not know what counts as a tool here or why versions matter. | Name an example, such as minimap2 version 2.31. |
| What it is table, "Shell Script... run.sh" | I do not know what a shell script is, what `run.sh` does, or how I would run it. Same for `reproduce.py`. | Add a one-line gloss for shell script before the table. |
| What it is table, "A subprocess driver" | I have no idea what a subprocess driver is. This is the least readable cell in the table. | Rewrite as a Python file that runs the same commands. |
| What it is table, "already uses Nextflow" | Both runnable rows describe the recipient rather than the file, so I still cannot tell how `main.nf` differs from a `Snakefile`. | Say the two do the same job in two different systems. |
| What it is, "Each one writes a folder" | I expected Export to give me a file I could email. A folder is a surprise and I do not know how to send one. | Add that you compress the folder before sending it. |
| What it is, "a separator after the fourth item" | I had to read this twice. I do not know what a separator is in a menu, and the sentence explains a visual detail before I have seen the menu. | Move this after the screenshot, or say "a dividing line". |
| What it is, "LGE walks the provenance chain backwards" | I could not picture this. What is a chain, and how far back does it go? | Give one concrete sentence, such as the BAM leads back to the FASTQ files. |
| What it is, "the most recent completed run" | I cannot tell what counts as a run or how to see which one was most recent. | Say where in the window to check which run finished last. |
| Why you would do this, "which minimap2 build produced a BAM file" | minimap2 and BAM both appear with no gloss. I know sequencing but not these file types. | Gloss BAM as the file of aligned reads and minimap2 as the aligner. |
| Why you would do this, "the build tested for this chapter" | I do not know what a build is or how to tell which build I have, so I cannot judge whether this warning applies to me. | Name the version, such as Preview 2026.9.13. |
| Why, "documentary targets as finished" | Runnable versus documentary is introduced as a category here but the table above never used those words. | Label the two groups in the table. |
| Before you start, "the HG002 chromosome 20 slice" | I do not know what HG002 is or what a slice means. I know it is human from context only. | Gloss HG002 as a widely used human reference sample. |
| Before you start, "against a piece of the human reference genome with minimap2" | Mapping is not explained. I have prepped libraries but never seen what happens after sequencing. | Add half a sentence saying mapping places each read on the genome. |
| Before you start, "then processed the alignment with samtools" | "Processed" tells me nothing, and samtools is not glossed. Later I learn four samtools steps ran, but never what they did. | Name what the samtools steps did, such as sorting and indexing. |
| Before you start, "the demo project" | I do not know whether I have a demo project or how to open it. The paragraph above only tells me how to make a new empty one. | Say where the demo project comes from. |
| Before you start, "a classification, or a download all qualify" | I do not know what a classification is in this app. | Drop it or link to the classification chapter. |
| Before you start, "Reading one back needs only a text editor" | I do not know which text editor to use on a Mac or how to open a `.nf` file in one. | Name one, such as TextEdit. |
| Procedure step 1, "open it so its viewport is showing" | Viewport is not explained. I do not know what part of the window that is. | Gloss viewport as the large panel on the right. |
| Procedure step 1, "select `Analyses/mapping-HG002`" | I do not know if `Analyses` is a folder I will see in the sidebar or a path I have to type. | Say it appears in the sidebar under the project. |
| Procedure step 3, "in the form `<artifact>-provenance-<format>`" | The angle brackets confused me. I first thought I had to type them. | Show only the worked example. |
| Procedure step 3, "choose a location outside the project" | I do not know where that should be. Desktop? Documents? And I do not know why it matters. | Suggest one location and say why in half a sentence. |
| Settings, "Provenance." | The setting is named Provenance but the text immediately says it is not a control I set. I read this three times and still find it confusing. | Rename the entry to Target, or say up front it is the menu item you picked. |
| Settings, "such as one taken before a reanalysis and one after" | I do not know what a reanalysis is in this app or why I would do one. | Cut the example or make it concrete. |
| Settings, "--signature." and "--public-key." | Signature, public key, and signer are all new to me and none is glossed. I cannot tell whether this is something I need. | Add one sentence saying most readers never configure a signer. |
| Settings, "`<sidecar>.signature.json`" | I do not know what "beside the sidecar" means on disk, because I have not been shown the folder yet. | Move these two flags after Reading the results. |
| Reading the results, "the copied records" | I do not know what a record is here, or how it differs from a sidecar. The two words seem to swap. | Use one word throughout. |
| Reading the results, "any enclosing `.lungfishref` reference bundle" | A file extension I have never seen, used with no gloss. | Gloss as the folder that holds a reference genome. |
| Reading the results, "with their original path preserved as a folder tree" | I read this twice and still cannot picture what I would see when I open that folder. | Show the folder layout as a short listing. |
| Reading the results, "a reproducibility reviewer wants" | I do not know who this is. A journal editor? A colleague? | Name the role plainly. |
| Nextflow export, "turning each dot into an underscore and sanitizing what is left" | "Sanitizing" is not explained, so I cannot predict a name for my own file. | Say what characters get replaced. |
| Nextflow export, the ```groovy block | Groovy is a language I have never heard of, and nothing tells me whether I need to understand this block or just look at it. | Say the block is for recognition, not for typing. |
| Nextflow export, "`MINIMAP2_1` followed by `SAMTOOLS_2` through `SAMTOOLS_5`" | I cannot tell whether five steps is a normal number or specific to this run, so I cannot judge my own export. | Say the count matches the number of steps LGE ran. |
| Nextflow export, "a `publishDir` directive pointing at `params.outdir`" | Directive is jargon and this sentence packs four unexplained things into one clause. I gave up on it. | Split into two sentences and drop `publishDir`. |
| Nextflow export, "managed conda environment minimap2; executable minimap2; root /Users/dho/..." | conda is never glossed anywhere in the chapter although it appears five times. Also this quoted string contains a real user's home directory. | Gloss conda as the system LGE uses to install tools. |
| Nextflow export, "byte-copy replays of a retained selection" | I could not parse this sentence at all. Every noun in it is new. | Rewrite the qualifier for a reader who has never heard of a retained selection. |
| Nextflow export, "`docker.enabled = true`" | Docker is never glossed, and the config says containers are on while the text says this run used none. That contradiction stopped me. | Say the line is harmless when no step uses a container. |
| Nextflow export, "do not pass `-profile`" | I do not know what passing a flag means, and I have not been told how anyone runs this file yet. | Move this to the command line section. |
| Nextflow export, "needs `nextflow run main.nf -resume`" | This is the first command in the chapter and it appears before the section that explains the terminal. | Cross-reference the optional last section. |
| Nextflow export, "image digest" | Digest is used once and never explained. I think it is like a checksum but I am guessing. | Say it is a checksum for the container image. |
| Snakemake export, "`snakemake --cores 8 --use-singularity`" | Singularity and cores are both new. I cannot tell whether 8 is a number I should change. | Say what cores means and that 8 is just a starting number. |
| Snakemake export, "a `rule all` naming the run's final outputs" | I do not know what a rule is in Snakemake. The word carries the whole section. | Gloss rule as one step of the workflow. |
| Snakemake export, "A collaborator overrides one with `--config`" | I cannot perform this from the text. There is no example of what a full override looks like. | Show one complete example. |
| Other four exports, "`set -euo pipefail`" | Shown with no explanation. I have no idea what it does or whether it matters. | Say it makes the script stop on the first error. |
| Other four exports, "that file's SHA-256" | SHA-256 appears here but the chapter used "checksum" earlier. I did not know they were the same thing. | Say SHA-256 is the kind of checksum used. |
| Other four exports, "written with the executable bit set" | Executable bit and `chmod` are both terminal concepts introduced outside the terminal section. | Move to the command line section. |
| What good looks like, "confirm none of them reads `unknown`" | I do not know where in the file to look for tool versions, and each target puts them somewhere different. | Say which line or section holds the versions in each target. |
| What good looks like, "validate the file before you send it" | The two commands are given but nothing says how to get Nextflow or Snakemake installed, and I have never opened a terminal. | Say installing them is out of scope and link somewhere. |
| What good looks like, "one error and eleven warnings" | I cannot judge these numbers. Is eleven warnings bad, or normal? | Say warnings are expected and only the error blocks the run. |
| What good looks like, "`Incorrect number of call arguments, expected 3 but received 1`" | The explanation about input paths and workflow blocks assumes I know Nextflow's structure. I only learned it is a defect. | Say plainly that this is a bug and I cannot fix it myself. |
| What good looks like, "`CyclicGraphException in rule samtools_5`" | Same problem. "A rule depending on itself" is the one part I followed. | Keep the plain clause and drop the exception name. |
| What good looks like, "including a conda environment path under the original user's home directory" | This is the most practically important limitation in the chapter and it is buried in a long paragraph as a subordinate clause. | Give absolute paths their own short paragraph. |
| What good looks like, "These are defects in LGE's exporter" | This tells me the export is broken but not what I should tell the collaborator I already sent it to. | Add one sentence on what to say when you hand it over. |
| On the command line, "typing commands into the Terminal application" | This is where the terminal is finally explained, four sections after the first command appeared. | Move this definition to the first mention of a command. |
| On the command line, "`lungfish-cli`" with a `\` line continuation | I do not know where `lungfish-cli` comes from, whether it is installed, or what the backslash at the end of the line does. | Say where the CLI comes from and that the backslash continues one command. |
| On the command line, "`./Analyses/mapping-HG002`" | The leading `./` is never explained, and I do not know what directory I should be in when I type this. | Say to run it from the project folder. |
| On the command line, "It only has something to check when a signer is configured" | Signer is still never explained, and the chapter never says how to configure one or whether I should. | Say signing is optional and covered elsewhere. |
| On the command line, "`Signature artifact is missing`" | An error message that means nothing is wrong is confusing on its own, though the last sentence rescues it. | Put the reassurance before the error text. |
| On the command line, "LGE pins Nextflow 26.04.6 and Snakemake 9.25.2" | "Pins" is jargon, and I cannot judge what counts as "a much older Nextflow". | Give the oldest version that works. |
| On the command line, "the requested package specification for a plugin pack" | Plugin pack is new here at the very end. I do not know what `read-mapping` is or how to find the name of my pack. | Say where the list of pack names lives. |
| On the command line, "`--from-lockfile` reconstruction is unsupported" | A flag named only to say it does not work. I could not tell what I am supposed to do with this. | Say plainly you cannot rebuild the exact environment. |
| Next, "through a separate code path from the provenance export" | Code path is developer language, and I could not tell whether the Builder's export has the same defects described above. | Say whether the Builder export has the same limits. |

One thing I learned. LGE quietly records the exact command, tool, version, and
file fingerprints for every step it runs, and one menu choice turns that into a
folder I can hand to somebody.

One thing I still could not do. Send a working pipeline to a collaborator. The
chapter tells me the Nextflow and Snakemake files do not run as written, but not
what to do about it, and I would not know how to edit them.

The sentence I liked most. "A checksum is a short fingerprint computed from a
file's exact bytes, so two people can confirm they are holding the identical
file."
