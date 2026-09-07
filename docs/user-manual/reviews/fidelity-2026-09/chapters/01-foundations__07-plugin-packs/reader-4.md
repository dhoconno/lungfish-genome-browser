# Reader report: Plugin Packs

Persona: a student who used Geneious in one class. I have never opened a terminal.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is, "A plugin pack is a themed" | "Command-line tools" is never explained. In Geneious the plugins were just plugins and I never saw a command line. I do not know if installing these means I have to use one. | One sentence saying these are programs LGE runs for you in the background. |
| What it is, "The variant-calling pack hands you" | Four variant callers are named and I cannot tell why there are four or which I should pick. | Say that later chapters tell you which caller to choose. |
| What it is, "One pack is not optional" | The pack is called Required Setup in the text but Third-Party Tools in the app. I read this twice and I still expect to hunt for the wrong name on screen. | Name the on-screen label first and the id second. |
| What it is, "So are fastp and Deacon" | I do not know what "trim reads" means. Trim off what, and why would I want reads shortened. | A short gloss of trimming at first use. |
| What it is, "So is BBMap, which arrives inside" | BBMap and bbtools appear with no explanation of what either does, unlike every other tool in the paragraph. | Say in three words what BBMap is for. |
| What it is, "The whole collection sits in a hidden folder" | I do not know how to find a hidden folder, and the tilde in `~/.lungfish/conda` means nothing to me. | Say that you never need to open this folder yourself. |
| Why you would do this, "Learning it once here means" | The manual says workflow chapters will say "install the assembly pack", but nothing here tells me that pack ids are the backtick words rather than the display names. | One line linking the backtick id to the card title. |
| Before you start, "The About window states the full" | I do not know where the About window is or how to open it. | Name the menu it sits under. |
| Before you start, "It asks for 16 GB of memory" | I do not know how to find out how much memory my Mac has, so I cannot judge whether I pass. | Say where on the Mac to read the memory figure. |
| Before you start, "recommends 100 GB of free disk" | I read this as a hard requirement and then the next sentence softened it to "where you can". I could not tell whether I am blocked at less than 100 GB. | State plainly whether a smaller disk stops you. |
| Before you start, "Use a real SSD over Thunderbolt" | I do not know which ports on my Mac are which, or how to tell an SSD from a spinning drive. | Say the drive's own listing will state SSD. |
| Before you start, "Nothing in this chapter needs Docker Desktop" | Docker Desktop is mentioned only to be dismissed and I have no idea what it is, so the reassurance did nothing for me. | Drop it, or gloss it in four words. |
| Procedure step 3, "Needs reinstall means installed but failing" | "Integrity check" is not explained. I do not know what is being checked or why a working install would start failing it. | A half-sentence saying LGE re-verifies the files are intact. |
| Procedure step 3, "Storage unavailable means the volume" | I do not know what "the volume" refers to here, and nothing earlier used that word. | Use "external drive" since that is the case being described. |
| Procedure step 4, "Progress streams into the card" | I do not know how long to expect. Minutes, an hour? I would assume it had frozen. | Give a rough time for one pack on a normal connection. |
| Procedure step 5, "because LGE sets up micromamba along the way" | Micromamba was defined earlier as a program that speaks the conda protocol, and "protocol" is the part I did not follow. | Cut the word protocol and say it installs conda packages. |
| Procedure, "which is the way to confirm an install survived a closed lid" | I could not tell whether closing my laptop lid mid-install is something I must avoid or something that is fine. | Say directly whether to keep the lid open during an install. |
| The packs, "The three marked experimental are hidden" | Then the table lists them anyway, marked experimental. I was confused about whether I would see ten cards or seven. | Say you see seven cards until you turn the setting on. |
| The packs, "Turn on Show Experimental Features in Settings > Advanced" | The sentence before it says "This feature is experimental", which reads as if the setting itself is the experimental feature. I read the block three times. | Delete the stray sentence. |
| The packs table, "Savont, NCBI BLAST+" | Savont is a name I have never seen and there is no gloss anywhere in the chapter. BLAST I know from Geneious. | One clause saying what Savont does. |
| The packs, "A handful of further pack ids appear in the source code" | I do not read source code and I do not know why I am being told about things I cannot see. | Remove, or say it exists so the ids you may hear about are not missing. |
| The packs, "Sizes vary more than the table suggests" | The table has no size column at all, so "more than the table suggests" pointed me back at nothing. | Put an approximate size column in the table. |
| Post-install hooks, "such as fetching the lineage data" | "Lineage data" is unexplained and I do not know which surveillance tool is meant. | Name the tool and gloss lineage. |
| Install without internet, "An air-gapped or firewalled Mac" | I do not know what air-gapped means. | Gloss it as a machine with no network at all. |
| Install without internet, "Run the first command on a networked Mac" | I have never opened a terminal. The chapter says elsewhere I only click buttons, so I do not know where these commands are typed. | Say the commands are typed in the Terminal app, with a pointer. |
| Manage installed environments, "It compares this machine against the pinned dependency list" | "Pinned dependency list" and "manifest" are used interchangeably and neither is glossed. | Gloss it once as the version list shipped with your copy of LGE. |
| Manage installed environments, "with a bare hexadecimal name rather than" | I do not know what hexadecimal means in this context. | Say "a long string of letters and numbers". |
| Settings, Download, "showing the download size, the memory the database wants" | I do not understand why a stored file wants memory. I thought memory was for running programs. | One clause saying the whole database is loaded into RAM to run. |
| Settings, Download, "the collection runs from half a gigabyte to seventy-two" | Seventy-two what. I assumed gigabytes but the unit is dropped. | Write the unit out. |
| Settings, Update, "databases built on your own machine cannot be replaced" | At this point in the chapter I did not know any database is built on my machine. That is only explained two sections later. | Move or forward-reference the locally built databases. |
| Settings, Storage Settings, "It points at the app's own managed storage folder by default" | "Managed storage" appears here and in the Download entry, but the glossary list at the top only has "managed environment". I could not tell if they are the same thing. | Use one term for both, or gloss the second. |
| Reading the results, "Nine of them are Kraken2 collections" | Kraken2 was named once in the pack table and once in Before you start, but never explained as a classifier. | Gloss Kraken2 at first use. |
| Reading the results, "Standard-8 and Standard-16 are the same collection compressed" | I could not tell what compressing to fit 8 GB costs me. Does it give worse answers? | One clause on the accuracy tradeoff. |
| Reading the results, "MinusB is Standard with the bacteria taken out" | No size is given for MinusB, unlike its neighbors, and I could not judge whether it fits my Mac. | Give its size like the others. |
| Reading the results, "EuPathDB46 covers eukaryotic pathogens" | I know what a eukaryote is from genetics but I cannot guess what the 46 means or what organisms are actually inside. | An example organism or two. |
| Reading the results, "the gene regions used to identify bacteria" | The sentence explains ribosomal RNA collections, but I still do not know when I would pick SILVA over Greengenes. | One line on when either is the right choice. |
| Reading the results, "The EsViritu Viral DB holds 19,925 curated" | The precise count is impressive but I do not know how to judge it against the Kraken2 Viral database, which was also viral. | Say which of the two to reach for. |
| Reading the results, "Three entries handle human sequence removal" | I count the Scrubber Database, Human Read Removal Data, and Ribosomal RNA Removal Data, but the last one is rRNA not human, so the count of three did not add up for me. | Separate the rRNA entry from the human count. |
| What good looks like, "expanding one shows real package versions rather than an empty list" | I do not know what a package version should look like, so I cannot tell a real one from a wrong one. | An example of one line from an expanded row. |
| On the command line, "which matters on a machine you reach only over SSH" | SSH is not explained and this is the first time the manual assumes I would want a machine I cannot see. | Gloss SSH, or say this section is optional. |
| On the command line, "lungfish-cli conda list --env minimap2" | Nothing tells me where `lungfish-cli` comes from or whether installing LGE gave it to me. | Say the CLI ships with the app and where it lives. |
| On the command line, "With --plan, the default, it prints the work" | Flags starting with two dashes are never introduced anywhere in the chapter. | Say a word beginning with dashes is an option you add. |
| Shared workstations, "LGE reads the LUNGFISH_CONDA_ROOT environment variable" | I do not know what an environment variable is or how to set one, and "a shell startup file the other accounts inherit" made it worse. | The opening line says to skip this, so say that more firmly. |
| Shared workstations, "conda root is read-only; reinstall as the admin user" | This is an error message I might see, but it is buried in the section I was told to skip. | Repeat it in the missing-tool section. |

One thing I learned: tools and reference databases are stored once per Mac, outside my project folder, so a project stays small and I only install a pack once.

One thing I still could not do: work out whether my own Mac has enough memory and disk to download a Kraken2 database, because the chapter gives the requirements but never says where to read my machine's own numbers.

The sentence I liked most: "Run an operation that needs a tool you have not installed and it stops before doing any work, naming the tool and the pack."
