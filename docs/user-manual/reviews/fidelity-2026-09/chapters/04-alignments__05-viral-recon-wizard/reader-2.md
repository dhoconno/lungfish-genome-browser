# Reader report: The Viral Recon Wizard

Reader 2. Senior, two years of pipetting, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "The pipeline behind this chapter is nf-core/viralrecon" | The sentence names Bowtie2, iVar, BCFtools, Pangolin, and Nextclade at once. Only iVar and consensus genome are linked. I do not know what Bowtie2 or BCFtools are. | One clause saying Bowtie2 is a read mapper and BCFtools builds sequences from variant calls. |
| What it is, "LGE pins release 3.0.0 of the pipeline" | I do not know what "pins" means here or what a "tool lock manifest" is. | Gloss "pins" as fixes the version so it never changes. |
| What it is, "It reads the sequencing platform off the reads" | I do not know how a FASTQ file would say what machine made it. It sounds like magic. | One sentence saying the platform is recorded in the bundle when the reads are imported. |
| What it is, "The reference is always the Wuhan-Hu-1 genome" | I have seen accession numbers but I do not know what the `.3` on the end means or whether a different number would be wrong. | Say the trailing number is the version of that record. |
| Why you would do this, "This chapter works against the SRR36291587" | I do not know whether 86,281 read pairs is a lot or a little for one SARS-CoV-2 sample. The text calls it clinical-scale but gives me nothing to compare it against. | Say roughly what depth that gives across the 30 kb genome. |
| Before you start, "This pipeline runs inside Docker containers" | I am told Docker Desktop must be installed and running, but never how to check whether it is, and I have never installed it. I do not know where "Docker's own site" is. | A link, and one line saying the whale icon in the menu bar means it is running. |
| Before you start, "Docker is the only execution profile" | "Execution profile" is a new term used before it is explained, and it is not in the glossary list. | Drop the phrase or gloss it. |
| Before you start, "Nextflow itself comes with the Required" | I do not know if I have the Required Setup pack or how to look. The next clause says it is installed if the app opens a project at all, which I read twice before I believed it. | Say plainly that opening a project means it is there. |
| Before you start, "The first run also downloads two" | No size and no time given. On lab wifi I would want to know whether this is a coffee break or an afternoon. | An approximate download size. |
| Opening the wizard, step 1, "Import the SRR36291587 reads into" | For paired reads I imported two files. I do not know whether that makes one bundle or two, so I do not know what to click. | Say a paired import produces one bundle. |
| Opening the wizard, step 2, "There is no Workflows menu in" | This tells me what is not there, which sent me hunting the menu bar to check. It reads like a note to someone else. | Cut it or move it to a footnote. |
| Filling in the four controls, step 1, "Check the Inputs summary. One selected" | I do not know what "its path relative to the project" looks like on screen and could not tell a right value from a wrong one. | An example of the text shown. |
| Filling in the four controls, step 1, "Mixing platforms in one selection is" | I do not know how I would end up with a mixed selection, or how to split a run by platform once I have. | Point to where selection is explained. |
| Filling in the four controls, step 2, "Under the menu a caption names" | I cannot tell whether 563 primers and 223 amplicons are the numbers I should see or just an example. If mine read differently I would not know whether to stop. | Say these are the values for this specific scheme. |
| Filling in the four controls, step 2, "Read the scheme name off your" | I have used kits where the box gives a product name and not a scheme name. I would not know which of the eight entries matched. | Name where in the kit insert the scheme version appears. |
| Running and watching, "Leave the app running and the" | The chapter refuses to say how long. "Far longer than any single dialog" could be twenty minutes or eight hours and I have to plan my day. | An order-of-magnitude figure for this sample. |
| Running and watching, "Right-clicking the row copies the exact" | I have never opened a terminal, so I do not know what a command line is or why a colleague would want one. | Say it is the text record of what was run. |
| Settings, Platform, "this control appears at all only" | I still do not know where a bundle keeps platform information or how metadata gets "lost in an earlier copy". | One clause on what copying loses. |
| Settings, Scheme, "The default is the first scheme" | Reading that the default is not meant to be correct made me stop and reread. I could not tell if this was a warning or a complaint about the app. | State it once as a plain warning. |
| Settings, Minimum mapped reads, "The default is 1000, and the" | If the stepper moves in hundreds I cannot see how I would ever set it to 1, and the stated range confused me. | Say the field can also be typed into. |
| Settings, Minimum mapped reads, "Lower it when you deliberately sequenced" | "Low-titre" is not glossed. I know titre from virus stocks but not what a low-titre swab means for read counts. | Gloss it as low viral load. |
| Settings, Annotation, "Points the run at a gene" | I do not know what this file is, what a GFF is, or where I would get one. The Advanced section says Choose GFF but GFF is never expanded. | Expand GFF at first use. |
| Settings, Extra parameters, "Passes further pipeline parameters straight to" | The instruction is to write them the way you would on a command line, which assumes the one skill I do not have. The example helps but I could not extend it. | Show the shape as name then value with two dashes in front. |
| Settings, Extra parameters, "Those are input, outdir, platform, protocol," | A list of thirteen or so bare parameter names with no explanation. I skipped it entirely and could not have used it. | Say only that anything the sheet controls is refused. |
| Reading the results, "The alignment track is the primer-trimmed" | I had to read this twice to work out that both a trimmed and an untrimmed file exist and only one is shown. | Say the untrimmed file is kept but not displayed. |
| Reading the results, "On one recorded run of a" | I understood the deletion, but I could not tell whether a three base difference in my own run would be normal or alarming. | Say a small difference is expected. |
| Reading the results, "LGE maps consensus coordinates back onto" | I do not know what laying one over the other "by index" means, so the contrast did nothing for me. | Cut the alternative. |
| Reading the results, "Coverage Depth by Amplicon is the" | "Read depth" is used here and in What good looks like without ever being defined, and it is the number the whole quality check turns on. | Define read depth as how many reads cover one position. |
| What good looks like, "Second, read the per-amplicon coverage. Every" | I am told an amplicon at or near zero is dropout, but not what a healthy number looks like. "Near zero" is the only landmark I am given. | Give a rough depth to expect. |
| What good looks like, "Third, look at the consensus for" | "Mostly N" is the only threshold given. I would want a percentage before I threw a sample away. | Give a percentage of N above which the sample is unusable. |
| What good looks like, "The pipeline pins Freyja to a" | I do not know whether my Mac is Apple Silicon or Intel, and the chapter assumes I do. | One line on checking under About This Mac. |
| On the command line, "The wizard builds a lungfish-cli command" | I have never opened a terminal, so the code block and the six options meant nothing. The heading calls it optional but every Settings entry ends by pointing here, which made me feel I had to read it. | Say in Settings that those closing sentences are for terminal users only. |

The one thing I learned: amplicon dropout produces no variant calls, and no calls looks exactly like no change, so the per-amplicon coverage table is the only thing that tells the two apart.

The one thing I still could not do: install and confirm Docker Desktop, which the chapter requires before anything else and never shows me how to do.

The sentence I liked most: "Nothing looks exactly like no change, which is the most dangerous way for an analysis to be wrong."
