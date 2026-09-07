# Reader report: 01-foundations/07-plugin-packs

Reader 1. Sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "Lungfish Genome Explorer (LGE) does not carry..." | "Bioinformatics tools" is used before anything says what one is. I pictured websites, not programs I install. | One clause saying these are small programs that read sequencing files. |
| What it is, "A plugin pack is a themed..." | "Command-line tools" is not glossed. I have never opened a terminal, so I do not know what makes a tool a command-line one. | A short gloss the first time the phrase appears. |
| What it is, "The read-mapping pack hands you..." | minimap2, BWA-MEM2, and Bowtie2 are three names with no way to tell them apart. If a later chapter says pick one, I would have no basis. | One sentence saying they do the same job and later chapters say which to pick. |
| What it is, "The variant-calling pack hands you..." | Four more names with no distinction. Also the word variant is never tied to the phrase "differs from the reference" in the next sentence. | Say plainly that those differences are called variants. |
| What it is, "holds the seventeen everyday utilities LGE..." | Seventeen utilities but only five are named. I could not tell whether the missing twelve matter to me. | Say the rest are internal helpers, or point to the full list. |
| What it is, "So are fastp and Deacon, which..." | "Trim reads" was new. In genetics class reads were just sequences and nothing was ever trimmed off them. | Say what gets trimmed and why, in half a sentence. |
| What it is, "So is BBMap, which arrives..." | I could not tell what BBMap does. Every other tool in this paragraph got a job description and this one did not. | Give BBMap the same short job description as its neighbours. |
| What it is, "installs compiled scientific software along with..." | "Libraries" in a software sense. I know sequencing libraries from class, so I read the sentence twice and got the wrong meaning first. | A different word, or a note that this is not a sequencing library. |
| What it is, "so two tools that want different..." | I understood the words but not why this would ever happen, so I could not judge whether it was a big deal. | One clause naming the symptom this prevents. |
| What it is, "The whole collection sits in a..." | I do not know how to see a hidden folder on a Mac, and the tilde in the path is not explained. | Say the tilde means your home folder and that you never need to open it. |
| Why you would do this, "Every workflow chapter in this manual..." | I did not know what counts as a workflow chapter versus a foundations chapter. | A pointer to where the workflow chapters start. |
| Why you would do this, "Knowing which database your work actually..." | Eight gigabytes appears nowhere else. The databases later are half a gigabyte, 34, 67, and 72, so I could not match the eight to anything. | Use a figure that appears in the database section. |
| Before you start, "The About window states the full..." | I did not know where the About window is, or that "hardware floor" meant minimum requirements. | Name the menu, and say minimum rather than floor. |
| Before you start, "It asks for 16 GB of..." | I do not know how to find out how much memory my Mac has. | One clause saying where to check it. |
| Before you start, "recommends 32 GB for metagenomics and..." | If I have only 16 GB, can I still do metagenomics? Minimum and recommended together did not tell me whether it fails or just runs slowly. | Say what actually happens at the minimum. |
| Before you start, "Use a real SSD over Thunderbolt..." | I cannot tell whether a drive I own is an SSD or spinning, or which of my ports is USB 3. | A way to check, or a note that most drives sold now qualify. |
| Before you start, "Nothing in this chapter needs Docker..." | Docker Desktop is named once and never explained. I could not tell whether that was a relief or a warning. | Drop it, or say what it is in four words. |
| Procedure step 3, "Needs reinstall means installed but failing..." | I do not know what an integrity check is or what would make one fail. | Say it is a check that the files are complete and undamaged. |
| Procedure step 3, "Storage unavailable means the volume the..." | "Volume" and "mounted" are both new. I guessed it meant an unplugged drive but was not sure. | Say plugged in and available rather than mounted. |
| Procedure step 4, "The Required Setup card says Install..." | The chapter says this pack is not optional, so I could not tell whether it is already installed when I arrive or whether I have to click it. | Say whether it is present on a first launch. |
| Procedure step 5, "Packs are independent, so several can..." | I did not know whether to wait for step 4 to finish before starting step 5. The sentence hints no but does not say. | Say directly that you do not need to wait. |
| Procedure, "which is the way to confirm..." | I did not know that closing the lid could break an install, and nothing earlier warned me. | Warn about the lid in step 4, before I close it. |
| The packs, "The three marked experimental are hidden..." | I read this three times. "This feature is experimental" follows, and I could not tell whether "it" meant one pack, three packs, or the setting. | Say in one sentence which thing is hidden and which switch reveals it. |
| The packs table, "full-length-mhc-genotyping ... Savont, NCBI BLAST+" | Savont meant nothing to me and the table gives no job description for any pack. | A column saying what each pack does, or a pointer to the chapter that uses it. |
| The packs, "A handful of further pack ids..." | Source code is not something I can look at, so this told me about something I can neither see nor use. | Cut it, or say plainly that you can ignore it. |
| The packs, "and the Required Setup pack is..." | The chapter says Required Setup is not optional, so I could not tell whether the 2.7 GB is already spent before I install anything. | Say when the 2.7 GB is downloaded. |
| The packs, "because GATK4 ships as a Java..." | "Java toolkit" and "runtime" are both new, and this is an experimental pack I cannot even see yet. | Cut it for this reader, or explain runtime. |
| The packs, "such as fetching the lineage data..." | Lineage data is not explained and the surveillance tool is not named. | Name the tool, or drop the example. |
| Install without internet, "An air-gapped or firewalled Mac cannot..." | Air-gapped was new. I worked it out from context but had to stop. | Say a Mac with no internet connection. |
| Install without internet, "lungfish-cli conda export-pack --pack read-mapping..." | This is the one place I am told to type a command. I do not have a terminal open, do not know how to open one, and do not know where lungfish-cli lives. | A pointer to wherever the manual explains opening a terminal. |
| Manage installed environments, "It compares this machine against the..." | Pinned list, build, and manifest look like three names for one thing and I could not tell whether they are. | Use one word for it throughout. |
| Manage installed environments, "An interrupted install sometimes leaves an..." | "Bare hexadecimal name" stopped me. I only know hexadecimal from a different context. | Say a long string of letters and numbers. |
| Settings, "Download. Fetches one database and unpacks..." | A stored database needing memory did not make sense at first. I thought memory was for running programs, not for files. | Point back to the Kraken2 sentence in Before you start. |
| Settings, "because the collection runs from half..." | Seventy-two what. The unit is dropped and I read it twice. | Repeat the unit. |
| Settings, "and databases built on your own..." | At this point I did not yet know that any database is built on my machine. That is explained two sections later. | Move the explanation earlier or forward-reference it. |
| Settings, "On the command line this is..." | Four of the five settings end this way and the angle brackets are never explained. I did not know whether to type them. | One note saying angle brackets mark something you replace. |
| Reading the results, "Each row reports the database's size..." | I could not tell what the database install states are. The four states earlier in the chapter were for tools. | List the database states, or say they are the same four. |
| Reading the results, "Sixteen databases are listed. Nine of..." | Kraken2 appears three times in this chapter but nothing says what it does beyond loading a database. | One sentence saying what Kraken2 classifies. |
| Reading the results, "Standard covers archaea, bacteria, viruses, plasmids..." | Vector sequence was new. In class a vector was a plasmid, and plasmids are listed separately here, so I was confused. | Gloss vector sequence. |
| Reading the results, "Standard-8 and Standard-16 are the same..." | I could not tell what I lose by using the compressed version. Compression sounds free and I doubt it is. | Say what the tradeoff costs. |
| Reading the results, "MinusB is Standard with the bacteria..." | No size is given for MinusB, and no reason anyone would want bacteria removed. | Give the size and one reason. |
| Reading the results, "EuPathDB46 covers eukaryotic pathogens and wants..." | I know eukaryote from class but not which pathogens are meant, and the 46 is unexplained. | Name an example organism. |
| Reading the results, "SILVA and Greengenes are both assembled..." | The paragraph says they are built on my machine but never says what I click to build them. | Say which control builds them. |
| Reading the results, "Rebuild them by downloading them again." | This contradicts the sentence three lines above saying they are built rather than downloaded. I read the paragraph twice and am still unsure. | Reconcile the two sentences. |
| Reading the results, "The EsViritu Viral DB holds 19,925..." | I do not know what an assembly is here, and I could not judge whether 19,925 is a lot. | Say whether that is broad coverage or narrow. |
| Reading the results, "Three entries handle human sequence removal..." | I could not tell whether I need one, two, or all three of these, or how to choose. | Say which one a beginner should take. |
| What a missing tool looks like, "Anything reading Needs install or Needs..." | The paragraph starts by telling me to check the pack's tools and I lost track of which tab Install All is on. | Name the tab again. |
| Disk usage, "and a full set of the..." | "A few gigabytes" for ten packs does not square with "a few hundred megabytes" each from the earlier section. | Give one number for all ten. |
| What good looks like, "and expanding one shows real package..." | An empty list is offered as the failure sign but nothing says what causes it or what to do about it. | Say what to do when the list is empty. |
| On the command line, "Everything the Plugin Manager does has..." | I cannot run any of this, and the only clue about who it is for is SSH, which I do not know. | A one-line note saying this section is optional if you use the app. |
| On the command line, "lungfish-cli conda db recommend" | This is the one command I would actually want, since the chapter keeps telling me to take the recommendation, but the button version is only a banner. | Say the banner and this command give the same answer. |
| Notes for shared workstations, "This section is for whoever sets..." | Our lab machine is shared and I could not tell whether I am the person who sets it up. | Say to skip it unless you are the machine's administrator. |
| Notes for shared workstations, "LGE reads the LUNGFISH_CONDA_ROOT environment variable..." | Environment variable and shell startup file are both new, and this is presented as the pattern that works with no way for me to follow it. | Nothing, if the skip note above is made clearer. |

One thing I learned. The tools are not inside the app. They install in groups called packs, once per machine, and every project on that machine shares them.

One thing I still could not do. Run either of the offline install commands, because I do not know how to open a terminal or where `lungfish-cli` lives.

The sentence I liked most. "Reading this chapter turns that dead end into a one-click fix."
