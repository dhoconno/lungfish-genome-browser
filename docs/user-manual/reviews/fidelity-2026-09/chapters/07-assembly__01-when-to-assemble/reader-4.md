# Reader 4 report, 07-assembly/01-when-to-assemble

Persona: undergraduate who used Geneious for one semester in a course. Comfortable
with a graphical sequence viewer, expects a dialog for every operation, has never
opened a terminal.

| Location | Issue | Suggested fix |
|---|---|---|
| What it is, "builds an assembly graph recording every such overlap" | Assembly graph is linked to the glossary but never said in the chapter's own words. I do not know if it is a picture I can look at in LGE or an internal thing I never see. In Geneious the assembly shows me a graph of coverage, so I assumed I would get a picture. | Gloss it in one clause and say whether LGE shows it. |
| What it is, "a repeated stretch longer than the reads can span" | I had to read this twice. I did not know what a repeat is in a genome or why length matters until the long-read section, four pages later, explained it. | Gloss "repeat" here as a stretch of sequence that occurs more than once. |
| What it is, "the result is packaged the same way, as a `.lungfishref` assembly bundle" | The file extension says "ref" but this is an assembly, not a reference. I read the sentence three times thinking it was a typo. | Say in one clause that the extension is shared deliberately because the formats are identical. |
| What it is, "inside a per-run folder under the project's `Analyses/` folder" | Backticked paths look like terminal commands to me. I do not know if `Analyses/` is something I click in the sidebar or a folder I have to find in Finder. | Say it is a folder visible in the LGE sidebar. |
| Why you would do this, "mapping discards most of the reads as unalignable" | I do not know what counts as most. Later the chapter says more than half, but here I could not judge it. | Move the "more than half" figure to first use or drop the vaguer wording. |
| Why you would do this, "gives you per-position coverage meaning how many reads sit over each base" | This is the one good gloss, but coverage was already used in "sequenced deeply" and "300-fold coverage" earlier without it. I did not know what 300-fold meant when I met it. | Gloss coverage at its first appearance, not its third. |
| Why you would do this, "pays for it in compute, in memory" | No number anywhere. I have a laptop. I cannot tell whether assembling is a thing I can do on it or a thing that needs a server. Geneious warned me when a job was too big. | State a rough RAM figure for the mitochondrial fixture and for a bacterial genome, and say whether LGE warns. |
| What LGE ships, "at roughly 950 MB installed" | I do not know whether this downloads once or per project, or where it goes. 950 MB is a lot on a student laptop. | Say it installs once per machine. |
| What LGE ships, "install it first from **Tools > Plugin Manager...** (Cmd-Shift-B)" | I cannot perform this from the text. It tells me to open the manager but not what to click inside it, whether I search for "Genome Assembly", or how long the install takes. | Add the one step inside the manager and a rough install time. |
| What LGE ships, "The versions are pinned rather than tracking whatever is newest" | "Pinned" was not explained. I guessed from context on the second reading. | Gloss pinned as fixed to one version. |
| What LGE ships, "Select the reads you want to assemble in the project sidebar first" | This is the step that would trip me. Geneious lets me open a dialog and then pick the file inside it. Here the order is reversed and the consequence of getting it wrong is not stated. | Say what the sheet shows if nothing is selected. |
| What LGE ships, "Shotgun metagenomes, where one sample holds many organisms" | Shotgun is glossed only by implication. I know metagenome from lecture but not shotgun as a modifier. | Drop "shotgun" or gloss it. |
| Table, "around 10 Mb" and "around 100 Mb" | I do not know my genome's size and the chapter never says how to find out. The column is guidance I cannot use. | Add one sentence saying where to look up a genome size, or drop the column to a note. |
| Table, "Hybrid assembly ... a conservative assembly matters more than a contiguous one" | "Contiguous" appears in the table before contigs are connected to the word contiguity anywhere. I read the SKESA row twice. | Reword to "fewer, longer contigs". |
| How the sheet decides, "It reads the first header line of your FASTQ" | I have never looked inside a FASTQ. I do not know what a header line is or that instruments write their name into it. This is the mechanism the whole section rests on. | Add one clause saying instruments stamp their name into each read's first line. |
| How the sheet decides, "reads whose headers were rewritten by an earlier processing step" | I could not tell whether steps I do in LGE, like trimming or subsetting, count as an earlier processing step. If they do, this will happen to me constantly. | Name whether LGE's own trim and subset operations rewrite headers. |
| How the sheet decides, "Selecting bundles from more than one kind of instrument at once" | "Bundles" is used here for FASTQ inputs, but the chapter has been using "bundle" for the `.lungfishref` output. I read the paragraph twice and still am unsure which is meant. | Use one word for inputs and another for outputs. |
| How the sheet decides, "a run mode picker appears, and it is currently locked" | A picker with only one usable option is confusing. I could not tell from the text whether it looks greyed out or whether I can click it and get an error. | Say the control is disabled. |
| Working out which, "somewhere above roughly 95% identity across most of the reference's length" | I do not know how to measure identity to a reference before I have done anything. The number is unusable to me without a step. | Point at the operation in LGE that produces this number. |
| Working out which, "a per-base error rate of a few percent" | I could not judge this. A few percent sounds tiny to me, but the chapter treats it as a big deal against HiFi. | State what a few percent error costs, e.g. errors per read. |
| Worked example, "The third question reads as isolate territory and points at SKESA. The second question overrules it" | The example walks the questions out of order (first, third, second) to make its point, and I lost the thread. I had to read it three times. | Walk them in order and note the SKESA temptation at step three. |
| Two assemblers, "the GIAB reference individual HG002" | GIAB is never expanded. I do not know what it is or why it makes HG002 special. | Expand Genome in a Bottle in one clause. |
| Two assemblers, "thinned to about 300-fold coverage" | Thinned was not explained and 300-fold is a number I cannot judge. Is 300 a lot? For what? | Gloss thinned as subsampled, and say 300-fold is far more than needed. |
| Two assemblers, "a fixture this manual ships" | I do not know what a fixture is or how to get it. The chapter compares two runs on it but never tells me where to find it so I could repeat them. | Say where the fixture lives and whether I can open it. |
| Two assemblers, "SPAdes overshot by 128 bases, about 0.8%" | The paragraph opens by calling it "the 127-base difference between them" and then says 128. I checked the arithmetic twice. 16,697 minus 16,569 is 128, and 16,697 minus 16,570 is 127. The two numbers measure different things but the text does not say so. | Say which comparison each number is. |
| Two assemblers, "SKESA labels its contig `[topology=circular]` in the FASTA header" | I cannot act on this. The chapter said earlier that the bundle appears as one item and the viewport shows the header, but I do not know if this tag is visible there or only in a file I would need a terminal to read. | Say where in the viewport the header text appears. |
| Two assemblers, "MEGAHIT 1.2.9 currently fails partway through on Apple Silicon" | This is a broken tool listed in the table two sections earlier as the metagenome answer with no ceiling, and nothing there warns me. I would have picked it and lost an afternoon. | Add the warning to the MEGAHIT table row. |
| Two assemblers, "aborting at one of its later graph-building steps" and "a nonzero exit code" | Exit code is terminal vocabulary. I have never seen one and would not know where to look. | Say what the failure looks like in the Operations panel instead. |
| What the numbers mean, "44.4% GC content" | GC content is used three times and never explained. It is in the summary strip too, so I will see it again. | Gloss it once as the percentage of G and C bases. |
| What the numbers mean, "An N50 of 50 kb on a bacterial chromosome of 5 Mb" | kb and Mb are used throughout without being defined. I can guess, but the chapter defines gentler things than this. | Gloss kb and Mb once at first use. |
| Where the result lands, "for example `spades-2026-09-07T05-14-22`" | The timestamp format with the T in it looks like something machine-generated I am not supposed to read. I could not tell it apart from a command. | Say it is date then time. |
| Where the result lands, "There is no `Assemblies/` folder in an LGE project" | I never expected one, so being told it does not exist made me wonder what I had misread earlier. | Cut or move to a note for upgraders. |
| Where the result lands, "the tool version and the wall time when the run recorded them" | Wall time was not explained. And "when the run recorded them" left me unsure whether these fields are sometimes blank and why. | Gloss wall time as elapsed real time, and say which tools omit it. |
| Where the result lands, "Scaffolds are contigs that the assembler has ordered and oriented" | Then the chapter says LGE ignores them. I could not work out why the file is mentioned at all, or whether I am supposed to do anything with it. | Say plainly that no action is needed. |
| Where the result lands, "it appears only on bundles that carry a record of the assembly that produced them" | I cannot tell which of my bundles those are. It reads like Reassemble will be missing sometimes for a reason I cannot see. | Name the case where the record is absent. |
| Where the result lands, "**Create Bundle** in the action bar beneath the table" | Coming from Geneious I would expect to drag a contig into a viewer or double-click it. The chapter never says that double-clicking a contig row does nothing. | Say the action bar is the only route. |
| What good looks like, "A run that finished with no contigs at all is reported as such" | "Reported as such" is vague. The earlier section called it "a distinct outcome". I still do not know what word appears on screen. | Quote the label LGE shows. |
| What good looks like, "landing in the tens to low hundreds of contigs is ordinary" | This is the only judgeable number in the section, and it is for bacteria. I have no equivalent for the human mitochondrial case I was just shown, or for anything else. | Add the expected count for the worked fixture. |

Three lines.

The one thing I learned: two assemblers can both be right and still disagree, and a
circular genome coming back slightly long is an artefact of cutting the circle, not
an insertion.

The one thing I still could not do: install the plugin pack and get to a run,
because the text stops at opening the Plugin Manager and never says what to click
inside it or how to tell my genome size against the table's ceilings.

The sentence I liked most: "Assembly starts from nothing and asks what sequence the
sample must carry for these reads to make sense at all."
