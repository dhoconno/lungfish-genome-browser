# Reader report: Provenance and Reproducibility

Reader 4. Undergraduate. I used Geneious in one class. I have never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "LGE stores that record as a" | "Sidecar" is not a word I have met for a file. I pictured a motorcycle. The link tells me the definition is elsewhere and I did not want to leave the page. | Say in the sentence that it rides alongside the file the way an index file rides alongside a FASTA. |
| What it is, "Open the chr20 reference bundle's sidecar" | It tells me to open the sidecar but never says how. Double-click it? Does it open in LGE or in a text editor? In Geneious I never opened a file next to a file. | One clause saying the Provenance section in step 2 is how you open it. |
| What it is, "```json "reproducibleCommand"" | A block of terminal text arrives before the chapter has told me I will never need to type it. My eyes stopped because I assumed I was supposed to run it. | A lead-in saying this is only shown, not typed. |
| What it is, "LGE uses SHA-256, a standard" | I understand it is a fingerprint but not what I do with it. Do I compute one? Does LGE compare them for me? | Say who checks the checksum and when. |
| Why you would do this, "1.24 (managed conda environment" | I do not know what conda is, or what h6bd33b9_2 is. The chapter says this is the detail a reviewer needs but I cannot tell which part is the version. | Point at which piece is the version number and which is the build. |
| Why you would do this, "LGE writes the record for every supported" | "Every supported workflow" made me wonder which workflows are not supported, and whether the thing I do is one of them. | Either a pointer to the list, or say all of them. |
| Before you start, "Build it by following the instructions" | The instructions live on a GitHub page. I have looked at GitHub twice and both times could not tell which file to click. Nothing here tells me what I will be doing there. | One sentence on what the fixture build actually asks of me. |
| Before you start, "Nothing in this chapter needs a plugin" | "Plugin pack" and "Docker Desktop" are both new. I could not tell whether I was being reassured or warned. | Drop the terms, or gloss plugin pack once. |
| Procedure step 1, "select the chr20_10.0-10.5Mb reference" | The caption in the front matter and the code font here spell the bundle two different ways, with a space and with an underscore. I did not know which to look for in the sidebar. | Spell it the same way both times. |
| Procedure step 2, "Scroll the Inspector to its Provenance" | I did not know how far down. With other sections above it I was not sure I had scrolled far enough or was in the wrong selection. | Name the section directly above Provenance. |
| Procedure step 4, "in the table drawer instead of the" | "Table drawer" is a piece of the window I have never been told about. I do not know where it is or how to open it. | Say where the table drawer is, or name the sidebar path to the variant track instead. |
| Procedure step 5, "Select the result you want to hand over" | Step 4 just told me to select the variant track, so I could not tell whether step 5 wants a new selection or is describing what I already did. | Say "keep the variant track selected". |
| Procedure, "Name the export folder in the save panel" | This paragraph has no number but reads like step 6. I lost my place and re-read step 5 to check I had not skipped something. | Number it. |
| Settings, Provenance, "Nextflow Pipeline..., Snakemake Workflow..." | Nextflow and Snakemake mean nothing to me. Two of the six choices are invisible. | Half a sentence saying both are workflow systems a bioinformatician might already run. |
| Settings, Provenance, "On the command line this is --format" | Every Settings entry ends with a command-line flag. I have never opened a terminal so I could not tell whether these lines were instructions for me. | Say once that these lines are for command-line readers only. |
| Settings, Save As, "for example sample-provenance-nextflow" | The example uses "sample" but everything else in the chapter uses chr20 or HG002. I could not tell if "sample" was a literal word LGE writes. | Use the chr20 name here. |
| Settings, "Where. Chooses where the export folder" | Save As and Where both say the flag is --output. Two different settings mapping to one flag confused me about whether they are really two things. | Explain that on the command line one path covers both. |
| Reading the results, "whatever the tool wrote to standard error" | "Standard error" sounds like the statistics term I learned in genetics, and it is clearly not that here. I stopped hard. | Call it the tool's error messages. |
| Reading the results, "step 3 is the pileup and step 4" | "Pileup" is not glossed. From the command I guessed it stacks reads at each position but I was guessing. | Gloss pileup at first use. |
| Reading the results, "The demo project's minimap2 mapping recorded -t 14" | I do not know whether 14 is a good number, or what I should set. The chapter says threads can change the answer, which worried me without telling me what to do. | Say 14 is just this machine's core count, not a number to copy. |
| Reading the results, "a dependency set of 2026.2" | I have no idea what a dependency set is or why its number looks like a date. | Gloss it, or say it is a version label for the bundled tools. |
| What the export folder holds, "main.nf with a nextflow.config for" | Six formats and nine filenames arrive in one sentence. I read it three times and still could not match them up. | Make it a small table. |
| What good looks like, "An empty Provenance section is worth" | The paragraph tells me an empty section is a bug and then tells me it is not a bug for a copied file. The order flipped on me mid-paragraph. | Lead with the copied-file case. |
| What good looks like, "A re-run on a different Mac, a different" | This says results can shift on another machine, right after the chapter told me reproducibility means landing on the same answer. I could not reconcile the two. | Say how much shift is normal. |
| Signing a record, "Its Provider control offers Off, Local" | "Cosign Plan" is a product name I have never seen and the chapter never says what it is. | One clause saying what Cosign is. |
| On the command line, "lungfish-cli provenance holds three" | This whole section is terminal work I cannot do, but it holds the only way to verify a signature, which the Signing section pointed me to. I ended up bouncing between the two. | Say plainly that verifying is command-line only and a menu-driven reader can stop at Signing. |
| On the command line, "--output ~/Desktop/chr20-provenance-shell" | The tilde appears with no explanation. I have seen it before and never learned it. | Gloss the tilde once as the home folder. |

Learned: every result LGE makes carries a written record of the exact tool, version, options, and file fingerprints that produced it, and that record is what I would send a collaborator rather than my memory.

Could not do: verify a signed record, because the only route given is the command line and I have never opened a terminal.

Liked most: "LGE writes down what ran, not what you meant to run."
