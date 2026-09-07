# Reader report: Oxford Nanopore Runs

Persona: senior undergraduate, two years of pipetting at the bench, no data analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is / "The instrument's control software is called" | I do not know what a pore is here. The text says signal "from each pore" as if I already know a nanopore flow cell has thousands of them. | One clause saying a flow cell holds thousands of tiny protein holes and DNA is read as it threads through one. |
| What it is / "MinKNOW writes those reads into" | "cleared its own quality threshold" left me wondering what the threshold is and whether there is a `fastq_fail` folder I am throwing away. | Say the discarded reads go to `fastq_fail` and that LGE ignores it. |
| What it is / "A 24-sample run can therefore land" | I had to read the sentence twice to work out that twenty-five folders means 24 barcodes plus unclassified. | Write "twenty-four barcode folders plus `unclassified`". |
| Why you would do this / "The HG002 long reads average Phred" | Phred 7.9 meaning one wrong base in six is the single number I could not judge. I do not know how to get from 7.9 to one in six, and one in six sounds catastrophic to me. | State the conversion in the sentence, and say plainly that this is normal for nanopore rather than a broken run. |
| Why you would do this / "That high copy number is why" | "covering the genome about 262 times over" is coverage, but the word coverage is never used, so I could not connect it to anything later in the chapter. | Name it as coverage at first use and link the glossary. |
| Before you start / "Download the folder `ont-run` from" | I could not perform this step. GitHub does not let me download a folder, and "rebuild the same three levels of folders on your disk" left me guessing at the exact names. | Give the three folder names to create, in order, as a short block. |
| Before you start / "Importing a run folder needs no" | Docker Desktop appears with no explanation of what it is or why it might have been needed. | Drop the mention or gloss it in three words. |
| Procedure step 2 / "Click the Sequencing Reads tab, then" | The step tells me to select `fastq_pass`, but Before you start had me build `ont-run/fastq_pass/barcode01`. I hesitated over which level to click. | Say the folder to select is the one that contains the `barcode01` folder. |
| Procedure step 4 / "Leave Apply processing recipe after import" | Two figures are called for in steps 3 and 4, but step 4 tells me to leave the checkbox off, so I would never see the controls the second figure shows. I thought I had done something wrong. | One sentence saying the second figure shows what appears only if you turn the checkbox on. |
| Procedure / "Reads whose barcode MinKNOW could not" | "on the command line that is the `--include-unclassified` option" implies there is no way to include them from the window. I could not tell if that is a limitation or if I missed a checkbox. | Say directly that the window always skips them. |
| When the run needs demultiplexing / "Or the library may carry" | I could not picture an inner barcode sitting behind an outer one. | A one-line example of two samples sharing barcode01 and separated by an inner tag. |
| When the run needs demultiplexing / "Twenty barcode kits ship with LGE" | Nothing tells me how to find out which kit my library used if someone else prepared it. | Point me at the library prep kit box or the core facility's run sheet. |
| Checking barcodes before you commit / "Before running a full demultiplex, scan" | This whole subsection is a command-line step, and I have never opened a terminal, so I could not do any of it. | Flag at the start of the subsection that this one is command line only. |
| Settings / "**Barcode Sheet:.** Supplies the table mapping" | The trailing colon and period in the bold name read as a typo and made me check whether the control is literally named that. | Match the on-screen label without the stray punctuation. |
| Settings / "**Built-In Kit.** Names the commercial" | "It defaults to the first kit in the list, which is almost never the one you want" alarmed me, but the list order is never given, so I do not know what the wrong default actually is. | Name the default kit. |
| Settings / "**Engine.** Chooses the program that" | I do not know what Exact Bare Barcode means, and "barcodes sit at unpredictable positions inside the read" is a situation I cannot recognise from my own data. | Gloss "bare barcode" once. |
| Settings / "**5' Distance.** Sets how many" | I know 5' and 3' from genetics, but a default of 0 confused me. Zero sounded like no limit rather than a strict requirement. | Say a value of 0 means the barcode must sit flush with the read end. |
| Settings / "**Error Rate.** Sets the fraction" | The example says 0.15 on a 20-base barcode tolerates three bases, but 0.15 times 20 is exactly 3.0, and I could not tell whether that rounds to three or two. | Pick an example where the arithmetic is unambiguous. |
| Settings / "**Output Strategy.** Chooses whether each" | This setting never appears in the Procedure and is not in the figure caption listing the pane's controls, so I did not know where to find it on screen. | Add it to the figure caption. |
| Reading the results / "Click the new bundle in the" | I have not seen the nine summary cards or the three sparkline charts, and the chapter never says which nine. | Cross-reference the chapter that describes the FASTQ viewport cards. |
| Reading the results / "Demultiplexing reports its own summary" | The demultiplex summary says 927 input reads but the import found 950, and nothing explains where the other 23 went. I read this three times. | One clause explaining the difference. |
| Reading the results / "Reads matching no barcode go" | "unassigned" here and "unclassified" earlier are two different things with near-identical names, and I mixed them up. | State the distinction once, side by side. |
| Reading the results / "Do not read a base count" | I do not know where `demux-manifest.json` lives or how I would open it without a terminal, so I could not act on the warning. | Say the file sits in the output folder and that a window user can ignore it. |
| What good looks like / "Confirm the base count yourself rather" | I could not reproduce the 72 percent from 7,495,398 against 4,348,051, and being told a number the software wrote is that wrong made me distrust the other numbers too. | Say whether this affects anything I actually use. |
| On the command line / "The commands below were run against" | Beyond me entirely, and the file `Imports/HG002.chrM.ont.fastq.gz` in the commands does not match the bundle name `barcode01` the procedure told me to expect. | Use the same name in both places. |
| What this chapter does not cover / "POD5 and FAST5 files hold" | Two file formats and re-basecalling arrive at once with no gloss, and I could not tell whether any of it matters to me. | Say in one clause that a bench scientist who receives FASTQ can ignore this paragraph. |

The one thing I learned: a nanopore run arrives as a folder tree of many small files per barcode, and the importer collapses each barcode folder into a single sample.

The one thing I still could not do: download the fixture and rebuild its folder structure from GitHub, which means I could not start the procedure at all.

The sentence I liked most: "You do not read individual nanopore bases as truth."
