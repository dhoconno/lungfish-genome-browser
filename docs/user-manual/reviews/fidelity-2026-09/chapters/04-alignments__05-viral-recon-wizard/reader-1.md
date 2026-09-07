# Reader report, undergraduate reader 1

Persona: sophomore fresh from a genetics course, no lab time, has never opened a terminal.
Chapter: `docs/user-manual/chapters/04-alignments/05-viral-recon-wizard.md`

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "The pipeline behind this chapter is" | "openly published viral reconstruction workflow" told me nothing about what reconstruction means here. Reconstruct what, from what? | One clause saying it rebuilds a virus genome from short sequencing reads. |
| What it is, "viralrecon maps amplicon reads with" | Six tool names in one sentence and only iVar is glossed. I do not know what Bowtie2, BCFtools, Pangolin, or Nextclade are. | A gloss on first use for each, or a small table of the tools and what each contributes. |
| What it is, "LGE pins release 3.0.0 of" | "pins" and "tool lock manifest" are both new. I could not tell whether pinning is something I do or something already done for me. | Say the version is fixed for me and I cannot change it. |
| What it is, "It reads the sequencing platform off" | "sequencing platform" appears before any explanation. I did not learn that a platform is a kind of machine until the Settings section much later. | Gloss platform at this first mention rather than pages later. |
| What it is, "writes the samplesheet the pipeline expects" | I do not know what a samplesheet is or why the pipeline needs one. The glossary link helps but the sentence assumes I already know. | A half sentence saying it is a small table listing which files belong to which sample. |
| What it is, "registers the alignment, variants, and consensus" | Three nouns plus "tracks" plus "reference bundle" in one clause. I read it three times and am still guessing that a track is a layer drawn over the genome. | Gloss "track" in place. |
| What it is, "The reference is always the Wuhan-Hu-1" | I did not know what a reference genome is for. Nothing here says why the analysis needs one at all. | One sentence saying every read is compared against this fixed genome. |
| What it is, "The protocol is always amplicon." | I know PCR amplifies things, but I could not say what an amplicon protocol is versus a shotgun one. The prereq chapter is listed in the front matter, not linked here. | An inline link to the amplicon versus shotgun chapter at this sentence. |
| Why you would do this, "the interesting comparison is between" | I followed the argument but not the phrase "rather than within one". Within one what? | Say "rather than between two runs of the same sample". |
| Why you would do this, "the only way to tell amplicon" | I had to read this twice because the term dropout is used to explain something else before it is defined in the next sentence. | Put the definition sentence first. |
| Why you would do this, "This chapter works against the SRR36291587" | I do not know whether 86,281 read pairs is a lot or a little, and "clinical-scale" does not tell me what scale that is. | Say what count would be too few for this pipeline. |
| Why you would do this, "paired-end Illumina read pairs from" | "paired-end" is never explained anywhere in the chapter. | Gloss it as two reads from opposite ends of the same fragment. |
| Before you start, "This chapter uses the SRR36291587 SARS-CoV-2" | I could not perform this. The chapter sends me to another chapter but does not say how big the download is, so I could not tell a hang from normal progress. | A file size and a rough download time. |
| Before you start, "This pipeline runs inside Docker containers" | I could not do this step from the text alone. There is no link and no instruction, only that it comes from Docker's own site. | A link, and one line on how to tell it is actually running. |
| Before you start, "Docker is the only execution profile" | "execution profile" is unexplained. I only worked out later that profile means something like conda or local. | Drop the phrase or gloss it. |
| Before you start, "Nextflow itself comes with the Required" | I could not tell whether I must check this or whether it is guaranteed. The sentence seems to say both. | State the one check to run. |
| Opening the wizard, step 1, "Import the SRR36291587 reads into the" | I did not know a bundle is a row you click in a sidebar rather than a file you open. | Say it appears as one row in the left sidebar. |
| Opening the wizard, step 3, "Read the sheet from the top." | "disclosure" as a noun is not a word I know for a part of an interface. | Call it a collapsible section. |
| Filling in the four controls, step 1, "Check the Inputs summary. One selected" | "path relative to the project" stopped me. I do not know what a path is in this app or what it is relative to. | Show an example of what that line looks like. |
| Filling in the four controls, step 1, "Mixing platforms in one selection is" | I could not picture how I would ever mix platforms, since I have one dataset. It reads as a warning about a mistake I cannot imagine making. | An example of what a mixed selection would be. |
| Filling in the four controls, step 2, "Under the menu a caption names" | I do not know how to judge these numbers. Is 563 primers normal? Would 60 mean I chose wrong? | Say the caption is there to confirm the scheme matches the kit. |
| Filling in the four controls, step 2, "Read the scheme name off your" | I have never seen a kit box. Nothing tells me what to do if I do not know which kit was used. | Say who to ask, or that the run is not safe to start without it. |
| Filling in the four controls, step 3, "Leave Minimum mapped reads at 1000" | The text sends me forward to Settings for the meaning, so I had to jump ahead and come back. | Give the one-line meaning here. |
| Running and watching, "Right-clicking the row copies the exact" | I do not know what a command line is or why I would send one to a colleague. This assumes terminal familiarity inside a GUI procedure. | Say it copies a text summary of the run for troubleshooting. |
| Running and watching, "Leave the app running and the" | I cannot plan around this. Far longer means ten minutes or ten hours and I cannot tell which. | An approximate time for this exact sample. |
| Settings, "Minimum mapped reads:." | There is a stray colon inside the bold label, which made me reread the line thinking I had missed a word. | Remove the colon. |
| Settings, Scheme, "The default is the first scheme" | This clashes with the Procedure telling me to pick QIAseq Direct. I could not tell whether the default would silently be used if I forgot. | State plainly that the default is almost always wrong. |
| Settings, Minimum mapped reads, "The default is 1000, and the" | I do not know what a stepper is, and I could not judge why the range runs so wide. | Call it the small up and down arrows. |
| Settings, Annotation, "Choose a file when you have" | I know what an open reading frame is, but I cannot imagine when I would have a better annotation than the reference itself. | Say most readers will never use this. |
| Settings, Extra parameters, "each name you type is checked" | I do not know where that parameter list is, so I could not find out what is legal to type. | A link to the pipeline's parameter documentation. |
| Settings, "Those are input, outdir, platform, protocol, the" | "the five primer parameters" and "the two Freyja skips" are counted but never named, so I could not check whether something I want is on the list. | Name them, or drop the counts. |
| Reading the results, "Click it in the sidebar and" | "coordinate system" was the phrase I stumbled on. I think it means positions along the genome but I was not sure. | Say positions along the reference genome. |
| Reading the results, "On one recorded run of a" | The 29,900 against 29,903 example is concrete, but "an AATT becoming A at position 20,297" left me unable to see why that loses three bases. | Say a four base stretch collapsed to one, so three are gone. |
| Reading the results table, "Provenance, Sorted Alignment and Alignment Index" | I do not know what an alignment index is or why it counts as provenance rather than quality. | One clause saying the index is a lookup file that makes the alignment fast to browse. |
| Reading the results, "Coverage Depth by Amplicon is the" | "read depth" is used as if already known. I could guess it means how many reads stack on a position, but nothing confirms that. | Gloss read depth here. |
| Reading the results, "Pangolin assigns a SARS-CoV-2 lineage name" | I do not know how to judge that confidence. There is no number and no threshold anywhere. | Say what a low confidence value looks like. |
| What good looks like, "Second, read the per-amplicon coverage." | "at or near zero" is the only threshold given, and I do not know how near counts as near. | A number, even an approximate one. |
| What good looks like, "Third, look at the consensus for" | I could not judge "mostly N". Is thirty percent acceptable? | A percentage that is usually considered too high. |
| What good looks like, "The pipeline pins Freyja to a" | I did not follow this at all. I do not know what a bootstrap is here, nor what a worker is. | Say the step crashes on Apple computers and cannot be turned on. |
| On the command line, "The wizard builds a lungfish-cli command" | I have never opened a terminal, so I could not evaluate any of this section, and nothing tells me I may skip it. | A first line saying this section is optional for readers using the app. |
| On the command line, "--param primer_bed=Primer\ Schemes/QIASeqDIRECT-SARS2.lungfishprimers/primers.bed" | The backslash in the middle of the path looked like a typo to me. | A note that the backslash stands for the space in the folder name. |
| Next, "Continue to Calling Variants to call" | Earlier the chapter says running steps by hand teaches more, and here I am sent to do exactly that after the pipeline. I could not tell which order the manual wants. | Say the next chapter explains what the pipeline did silently. |

The one thing I learned: a pipeline's value is that it treats every sample identically, so a difference between two results is a difference in the samples rather than in how they were handled.

The one thing I still could not do: install and confirm Docker Desktop, which the chapter names as a hard requirement but never shows me how to satisfy.

The sentence I liked most: "Nothing looks exactly like no change, which is the most dangerous way for an analysis to be wrong."
