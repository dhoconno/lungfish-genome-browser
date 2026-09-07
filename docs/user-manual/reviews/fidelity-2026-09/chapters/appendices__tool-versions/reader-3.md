# Reader 3 report, Tool Versions

Persona: pre-med student, English as a second language, strong biology vocabulary from textbooks, slowed by idioms and long sentences, has never opened a terminal. Task: write the version of one tool into a methods section.

| Location | Issue | Suggested fix |
|---|---|---|
| What it is, "a variant call is GATK or LoFreq" | The sentence says a call *is* a program. In my English this reads as a definition, not as "is done by". I read it three times before I saw the pattern. | Write "mapping is done by minimap2, variant calling by GATK or LoFreq". |
| What it is, "hands them their files" | "Hands" as a verb is an idiom for me. My first reading was the body part. | Use "gives them their files". |
| What it is, "A lock file is a list that names" | 48 words with two subordinate clauses. I had to read it twice to find the main verb. | Split the sentence after "depends on". |
| What it is, "every outside program" | "Outside program" is not defined. Outside of what. I guessed it means not written by the LGE team. | Say "every program written by someone else". |
| What it is, "Contents/Resources/third-party-tools-lock.json" | I do not know how to look inside an app. I see one Lungfish icon in Applications and no way in. The text gives a path but not an action. | Add "right-click the app and choose Show Package Contents". |
| What it is, "left to float upward" | Metaphor. A version number does not float. Understood only on the second reading. | Say "rather than allowed to change to a newer number". |
| What it is, "dependency set 2026.2, cut on 2026-08-18" | "Cut" in this meaning is an idiom I do not know. I thought something had been removed. | Say "created on 2026-08-18". |
| What it is, "Name the dependency set beside the app version" | This is the sentence I most needed and it has no example. I do not know what the finished methods sentence should look like. | Add one example line such as "Lungfish Genome Explorer 2026.9.13, dependency set 2026.2". |
| What it is, "read the provenance sidecar of that analysis instead" | I am told to read a sidecar but never told where one is or how to open it. This is the step I could not perform, and my task is a methods section for a finished run. | Add the file location or link to the provenance chapter. |
| Reading the tables, "Four ideas separate the four tables" | I expected the four ideas to map one to one onto the four tables. They do not. Conda, plugin pack, License and Executables are not tables. | Say "Four terms appear in the tables below". |
| Reading the tables, "kept apart from every other program" | 42 words, a purpose clause inside a relative clause. Read twice. | Split at "so that". |
| Reading the tables, "These folders live under `~/.lungfish/conda`" | The tilde means nothing to me. I have never opened a terminal, I do not know it is my home folder, and Finder does not show a folder starting with a dot. | Gloss the tilde as "your home folder" and note the folder is hidden. |
| Reading the tables, "a few of these are more restrictive than others" | I cannot tell which ones. The column holds strings like "GPL-3.0-or-later OR BSD-2-Clause" and I have no way to judge them. | Name the restrictive ones, or say plainly that licenses do not affect academic use. |
| Reading the tables, "in a provenance record and in a command line" | "Command line" is used here but only explained ten sections later. | Gloss it at first use. |
| Tools installed with every copy, "conda environments LGE provisions on first use" | "Provisions" as a verb is unfamiliar. "First use" is ambiguous, first use of LGE or of that tool. | Say "installs the first time you use that tool". |
| Tools installed with every copy, "a separate `bootstrap` key that carries no license field" | "Key" and "field" are both file terms and neither is glossed. | Gloss "field" once as "a labelled entry in the file". |
| First table, "bbtools 40.02" against "BBTools" later | The table writes lowercase names, the command output writes BBTools. For my methods section I do not know which spelling to write. | Say once, near the table, which spelling belongs in a paper. |
| First table, "Varies, see https://genome.ucsc.edu/license" | A license cell that is not a license. The chapter already said licenses are not interpreted here, so this row is a dead end. | Say in one sentence what to do with this row. |
| Version notes, "look wrong at a glance and are not" | "At a glance" is an idiom. Neither number looked wrong to me, so the sentence corrected a reaction I had not had. | Say "Two version numbers are written in an unusual form". |
| Version notes, "the packaging revision of that build" | Three technical words together, none glossed. I copied the number whole only because I was told to. | Keep the instruction and drop the explanation, or gloss it. |
| Plugin pack section, "cannot map a read until `read-mapping` is installed" | I follow the words but not the consequence. If a pack was not installed, is the version in the table still correct for what I ran. | Say whether an uninstalled pack's row still describes a past run. |
| Plugin pack section, "(Cmd-Shift-B)" | No context. I do not know that this opens the Plugin Manager, and B matches no word in the menu name. | Write "press Cmd-Shift-B to open it". |
| Plugin pack section, "lungfish-cli conda install --pack read-mapping" | A command appears here, but only much later does the chapter say the bare name will not work. I would have typed this and failed. | Move the PATH warning before the first command, or point to it here. |
| Pinned external pipelines, "runs it through Nextflow" | Nextflow is a row in the first table but never explained as a concept, and here it is used as if I know it. | Gloss it once as "a program that runs pipelines". |
| Pinned external pipelines, "a forty-character commit identifier" | "Commit" is not glossed. I know it only as an ordinary English verb. | Gloss as "a code naming one exact saved state of the project". |
| Pinned external pipelines, "a name a maintainer could in principle move" | "In principle" plus a hypothetical. Read twice, and I still do not know whether this actually happens. | Say "a maintainer is able to move a tag, though this is rare". |
| Pinned external pipelines, "adding `--revision <ref>`" | I do not know what to put in place of `<ref>`. The angle brackets are a convention nobody explained. | Show one real example value. |
| Reference databases, "The lock pins sixteen" | Sixteen what. The sentence has no noun and I had to count the rows. | Say "sixteen databases". |
| Reference databases, "unpinnedArchive", "liveSnapshot", "localBuild", "bundledPayload" | Four invented words appear in a table column and are explained only in the paragraph after the table. | Add a lead-in line saying the policies are explained below the table. |
| Reference databases, "the archive is trusted to keep its contents" | Passive with no agent. Trusted by whom, and what if the trust is wrong. This matters for a methods section. | Say "LGE cannot verify that the contents did not change". |
| Reference databases, "Its version is the word `live`, which means it is not pinned at all" | The one thing on this page that could make my methods section wrong, and it sits in the middle of a long section. | Move this warning up, or set it as a warning callout. |
| Reference databases, "recognise and discard host reads" | "Host reads" is not glossed. I know host from immunology and had to guess it means reads from the person, not the pathogen. | Gloss as "reads from the sample donor rather than the organism you are studying". |
| What good looks like, heading and "Two checks are worth running" | The heading promises a judgement standard and delivers two commands. I nearly skipped the section. | Rename the heading to say what the section contains. |
| What good looks like, "It exits with status 10 when work is pending" | I have never opened a terminal and will not write a script. I do not know what an exit status is. | Move this to a note for advanced readers. |
| What good looks like, "a `retiredEnvironments` list" | Another file key, and it turns out to be irrelevant to me. I studied it before learning that. | Say first that this matters only when upgrading. |
| On the command line, "do not put it on your `PATH`, the list of places your shell searches" | "Shell" is used to explain PATH but "shell" is itself never explained. One unknown word defined by another. The sentence is also the longest in the chapter and I read it four times. | Gloss "shell" and split the sentence into three. |
| On the command line, "type the quoted full path" | I could not perform this step. I do not know where to type it, what "quoted" means in practice, or what "bare name" refers to. | Add a first step saying to open Terminal, then show the full line to paste. |
| On the command line, "The example below writes the bare name." | A paragraph tells me the bare name will not work, then the example uses it. This felt like a trap. | Show the working full-path form in the code block. |
| On the command line, "checked row by row against the lock on 2026-09-07" | I cannot tell whether this date is a promise about my copy or a fact about the writer's copy. | Say who checked it and that it can go stale. |
| On the command line, "Three differences are presentation only" | The three items are one 62-word sentence joined by commas and "and". I lost the boundaries between them. | Make it a three-item list. |
| Which one governs, "A machine can hold an older installed version than the lock names" | This answers the question I started the chapter with, and it arrives on the last screen. | State it in the opening section. |
| Which one governs, "the sidecar is right about your analysis" | The fourth time the sidecar is named as what I actually need, still with no way to find one. | Link to the chapter that opens a sidecar. |
| Next, "so the two agree on every version" | Good sentence, but it left me unsure whether a methods section should cite this appendix or the bibliography. | Say which page a methods section should cite. |

Three lines.

The one thing I learned. A methods section should name the dependency set, 2026.2, beside the app version, because all the version numbers move together under that one name.

The one thing I still could not do. Find and open the provenance sidecar for my own finished run, which the chapter names four times as the correct source for a methods section and never explains how to reach.

The sentence I liked most. "Almost none of the analysis in Lungfish Genome Explorer (LGE) is done by LGE itself."
