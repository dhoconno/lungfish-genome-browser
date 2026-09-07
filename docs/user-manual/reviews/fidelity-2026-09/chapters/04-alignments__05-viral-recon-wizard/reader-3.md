# Reader report: The Viral Recon Wizard

Reader 3. Pre-med student, English is my second language. I have taken genetics. I have never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "You supply reads and a primer scheme..." | "at one end and collect ... at the other" is a picture I had to build in my head twice before it worked. | Say the pipeline takes reads in and gives four files out. |
| What it is, "The pipeline behind this chapter is..." | "viral reconstruction workflow" is not glossed. I do not know what is being reconstructed. | Say in one sentence what reconstructing a virus genome means. |
| What it is, "viralrecon maps amplicon reads with Bowtie2..." | Six tool names in one sentence. Bowtie2, iVar, BCFtools, Pangolin, Nextclade. I cannot hold six new names at once and I do not know which ones I must care about. | Split into two sentences, or say which of these I will see again later. |
| What it is, "Lungfish Genome Explorer (LGE) pins release..." | "pins" as a verb is new to me. I guessed it means locks but I was not sure. | Say LGE always uses release 3.0.0 and never updates it. |
| What it is, "the revision recorded in its tool..." | "revision" and "tool lock manifest" together. I do not know if the manifest is a file I can open. | Say whether the manifest is something I ever need to look at. |
| What it is, "It reads the sequencing platform off..." | "reads ... off the reads" uses the same word two ways in five words. I read it three times. | Use "detects the sequencing platform from the read files". |
| What it is, "records a run bundle describing exactly..." | I could not tell if the run bundle is made before or after the analysis. "about to do" says before, but later text says LGE writes it when I click Run. | Say when in the sequence the bundle appears. |
| What it is, "The wizard is SARS-CoV-2 only, and..." | "being blunt about how narrow that is" is an idiom I had to guess at. | Say plainly the wizard works for one virus only. |
| What it is, "So what should you do with..." | A question addressed to me in the middle of an explanation made me stop and think it was a test. | Remove the question and give the rule directly. |
| Why you would do this, "Every sample needs the same treatment, and..." | I do not understand what comparing "within one" sample would mean. | Give one short example of a within-sample comparison. |
| Why you would do this, "A pipeline removes that doubt by..." | "by construction" is a phrase from mathematics I think. I do not know what it means here. | Say the doubt is removed because every sample gets the same settings. |
| Why you would do this, "The per-amplicon coverage table says how..." | The sentence uses "amplicon dropout" and only explains it in the next sentence. When I met the word I did not yet know it. | Define dropout first, then say why the table matters. |
| Why you would do this, "Nothing looks exactly like no change..." | I read this five times. Two negatives in six words in a language that is not mine. | Say no reads and no variants look the same on screen. |
| Why you would do this, "This chapter works against the SRR36291587..." | I do not know if 86,281 read pairs is a lot or a little. "clinical-scale" gives me no number to compare against. | Say what read count is typical for this kind of sample. |
| Before you start, "Docker is the only execution profile..." | "execution profile" is not glossed and I do not know where I would see one. | Say Docker is the only way this runs and there is no setting to change. |
| Before you start, "which is why the wizard offers..." | "launch path" sounds like part of the program's insides. I do not know what refuses me. | Say the app will not start the run any other way. |
| Before you start, "Nextflow itself comes with the Required..." | I do not know how to check whether I have this pack. The sentence only tells me what to do if it is missing. | Say where in the app I confirm it is installed. |
| Procedure, "The worked example runs the SRR36291587..." | I do not know how I would find out what scheme MY own library was prepared with. The kit-box advice comes much later. | Move the kit-box advice up to first mention. |
| Opening the wizard 1, "Import the SRR36291587 reads into the..." | I could not picture "a sheet that will not run". Is there an error message, or does Run stay grey? | Say what I would actually see on screen. |
| Opening the wizard 2, "Choose Tools > Mapping > Viral..." | The clause about why it sits fifth explains the menu designer's reasoning, not what I should do. I stopped to check it was not an instruction. | Move that reasoning into a note. |
| Opening the wizard 3, "Read the sheet from the top." | "disclosure" as a name for a UI part is new to me. I thought it meant revealing information. | Call it a collapsed Advanced section. |
| Filling in the four controls 1, "Check the Inputs summary. One selected..." | "path relative to the project" is not explained. I do not know what a relative path looks like. | Show one example of the text that appears in the box. |
| Filling in the four controls 1, "Mixing platforms in one selection is..." | I do not know how I would ever select two platforms by accident, so I could not tell if this applies to me. | Say when this happens, for example selecting many bundles at once. |
| Filling in the four controls 2, "Under the menu a caption names..." | I do not know how to judge 563 primers or 223 amplicons. Are these numbers I should verify? | Say whether I need to check these against my kit. |
| Filling in the four controls 2, "Read the scheme name off your..." | "nothing in the interface will tell you" frightened me but gave me no way to check my own choice. | Name where on a kit or protocol the scheme name appears. |
| Filling in the four controls 3, "Leave Minimum mapped reads at 1000..." | I am sent to a later section for the meaning, so I must jump ahead and come back. | Give the one-line meaning right here. |
| Running and watching, "Right-clicking the row copies the exact..." | I have never opened a terminal. I do not know what a command line is or what I would do with the copied text. | Say it copies text I can paste into an email to a colleague. |
| Running and watching, "Leave the app running and the..." | No time estimate at all. I do not know whether to wait, go to lunch, or leave it overnight. | Give an approximate run time for this example. |
| Running and watching, "When the run succeeds, LGE copies..." | I expected clicking a folder to open a folder. I could not predict this and had to reread. | Say the app shows the genome view instead of a file list. |
| Settings, "The wizard's five settings are documented..." | I do not use the command line, so I did not know whether I could ignore the last sentence of every entry. | Say app-only readers can skip those sentences. |
| Settings Platform, "On the command line this is..." | The angle brackets and the vertical bar are notation I have never seen. | Say it means choose one of the two words. |
| Settings Scheme, "The default is the first scheme..." | "a default only in the sense of being first in a list" is long and abstract. I understood it only on a second reading. | Say the default is not chosen for your sample. |
| Settings Scheme, "Always match the scheme to the..." | The most important warning in the chapter sits at the end of a very long sentence. I nearly missed it. | Give the primer-bases warning its own sentence. |
| Settings, "Minimum mapped reads:." | There is a stray colon before the period in the bold label. I thought I had missed a word. | Remove the colon. |
| Settings Minimum mapped reads, "The default is 1000, and the..." | "stepper" is a UI word I do not know. Also if it moves in hundreds, how do I ever reach 1? | Name the control plainly and explain the smallest value. |
| Settings Minimum mapped reads, "Lower it when you deliberately sequenced..." | "low-titre" is a word I half remember from an immunology lecture and it is not glossed. | Gloss titre as the amount of virus present. |
| Settings Annotation, "Points the run at a gene..." | "variant effects" is not glossed. I do not know what an effect is here. | Say it tells you which gene a change falls in. |
| Settings Annotation, "Choose a file when you have..." | "open reading frame" is a genetics term I only half remember and it is not glossed here. | Gloss it in one clause. |
| Settings Extra parameters, "Passes further pipeline parameters straight to..." | In the example I cannot tell where one parameter ends and the next begins, and I do not know what fastqc is. | Show them on separate lines or explain the shape. |
| Settings Extra parameters, "The default is empty, and each..." | I do not know where I could read the pipeline's parameter list to find a legal name. | Point me to where that list lives. |
| Settings, "Those are input, outdir, platform, protocol, the..." | "the five primer parameters" and "the two Freyja skips" are counted but not named, so I cannot check whether the thing I want is refused. | Name them or say where they are named. |
| Reading the results, "The alignment track is the primer-trimmed..." | I did not know two BAM files existed until this sentence, and I do not know where the untrimmed one is. | Say both are produced and where each one lives. |
| Reading the results, "On one recorded run of a..." | I could not work out from "an AATT becoming A" whether three or four bases were deleted. | Say how many bases were lost. |
| Reading the results, "LGE maps consensus coordinates back onto..." | "coordinates" and "by index" together defeated me. I understood only that the app does something clever. | Say the app corrects for missing bases so positions still match. |
| Reading the results table, "Provenance, Sorted Alignment and Alignment..." | I do not know what an Alignment Index is or whether I ever open it. | Say the index is a helper file I never open. |
| Reading the results, "Full Run Report is the MultiQC..." | The chapter did not warn me a result would leave the app and open elsewhere. I was surprised. | Note that this opens outside LGE. |
| What good looks like, "Four checks, in the order they..." | "invalidate the ones after them" is abstract. I understood the idea only after reading all four checks. | Say a failure at one check makes the next ones meaningless. |
| What good looks like, "A sample with fewer mapped reads..." | "the threshold speaking" is a figure of speech I did not follow. | Say the sample was dropped on purpose, not that the run broke. |
| What good looks like, "Third, look at the consensus for..." | The letter N is used before it is explained. The next sentence explains masking but not the symbol. | Say N means an unknown base. |
| What good looks like, "When they disagree, or when Pangolin..." | A very long sentence carrying three ideas. I lost the subject halfway through. | Break it into two sentences. |
| What good looks like, "The pipeline pins Freyja to a..." | "bootstrap workers are killed" is not explained. It sounds alarming and I do not know if it affects me. | Say the step fails on Apple computers so it is turned off. |
| On the command line, "The wizard builds a lungfish-cli command..." | I have never opened a terminal and this whole section assumes I have. I did not know whether to read it. | Say at the top that this section is optional for app-only users. |
| On the command line, code block "--param primer_bed=Primer\ Schemes/..." | The backslash before the space looks like a typing mistake to me. | Explain that the backslash protects the space in the name. |
| On the command line, "--executor accepts docker, conda, and local..." | This reads as though the program is broken. I could not tell if it is a bug I should report. | Say the extra choices are accepted for compatibility but do not work. |
| On the command line, "--timeout parses and is then rejected..." | "parses" is a programming word I do not know. | Say the option is accepted but has no effect. |
| Next, "Continue to Calling Variants to call..." | "what each decision costs" is metaphorical and I was not sure what is being spent. | Say what you give up by letting the pipeline decide for you. |

The one thing I learned. A pipeline is not faster or smarter than doing the steps myself, it is valuable because every sample gets exactly the same treatment, so a difference between two samples must come from the samples.

The one thing I still could not do. Judge whether my own run was good. The chapter tells me to read the per-amplicon coverage table and look for dropout, but it never gives me a number for what a healthy amplicon depth is, so I would stare at the table without knowing where the line falls.

The sentence I liked most. "Nothing looks exactly like no change, which is the most dangerous way for an analysis to be wrong." It took me five readings, but now I will never forget it.
