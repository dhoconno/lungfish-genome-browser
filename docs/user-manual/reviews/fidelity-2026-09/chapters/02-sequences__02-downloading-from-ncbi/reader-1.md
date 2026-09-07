# Reader report: Downloading from NCBI

Reader 1. Sophomore, one genetics course, no lab time, has never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "What lands is a reference bundle..." | I do not know what an "index" is for a sequence. The bundle "holds the sequence, its indexes, and any annotations" and I cannot picture the middle one. | Gloss index once as a lookup file that lets the app jump to a position without reading the whole sequence. |
| What it is, "The same dialog reaches two other..." | "SRA holds raw sequencing reads" uses "reads" as a noun before anything defines it. | Gloss "read" at this first use. |
| Why you would do this, "The GenBank version of the record..." | The counts list "13 protein-coding sequences" and "22 transfer RNA genes" as separate kinds, and I do not know the difference between a coding sequence and a gene. | One clause saying a coding sequence is the translated stretch inside a gene. |
| Why you would do this, "That record is the revised Cambridge..." | "revised Cambridge Reference Sequence" arrives with no explanation and is never used again. I read it twice looking for what to do with it. | Say in the same sentence that it is simply the name people use for this record. |
| Why you would do this, "The record's accession begins with NC_..." | I could not tell whether RefSeq is a database, a label, or an organisation. "Curated subset" did not land. | Say that NCBI staff choose RefSeq records, unlike ordinary submissions. |
| Before you start, "You can read the fixture's notes..." | The word "fixture" is used three times and never explained. I did not know whether I was supposed to download that GitHub folder first. | One sentence saying a fixture is the manual's own frozen copy and I do not need it. |
| Before you start, "Nothing in this chapter needs a plugin..." | "Plugin pack" and "Docker Desktop" are both new to me. I stopped to check whether I had skipped an install step in an earlier chapter. | Say these are covered later and are not needed now. |
| Procedure step 2, "Type NC_012920.1 into the query..." | I did not know how long to wait or what an empty result would look like if I mistyped. | Say roughly how many results an accession query returns. |
| Procedure step 3, "Ticking more than fifty records asks..." | I could not tell whether this warns me, blocks me, or is only a note, and nothing says what the confirmation asks. | State what the prompt says and what happens if I decline. |
| Procedure step 5, "Find the finished bundle under Downloads/..." | I did not know whether `Downloads/` means my Mac's Downloads folder or something inside the project. I looked in the wrong place. | Say it is a folder inside the project, not the system Downloads folder. |
| Settings, "The controls below belong to two panes..." | Two settings entries are both titled **Organism** and I could not tell which one applied to the pane I had open. | Mark the second one as the Pathoplexus organism chip in its bold lead-in. |
| Settings, "Mode. Chooses which NCBI collection..." | "Genome returns whole assemblies" assumes I know what an assembly is as opposed to a single sequence. | Gloss assembly as all of an organism's chromosomes put together. |
| Settings, "On the command line this is --db." | Almost every entry ends with a command-line note and I could not tell whether I was allowed to ignore them. | One line at the top of Settings saying those notes belong to the optional section. |
| Settings, "Molecule Type. Restricts results to records..." | I did not understand "spliced transcripts" well enough to decide between mRNA and Genomic DNA. | Gloss transcript as the RNA copy made from a gene. |
| Settings, "Sequence Length. Keeps only records whose..." | "Set a minimum to drop short partial fragments" gives no number, and I do not know what counts as short. | Give one worked minimum for the mitochondrial example. |
| Settings, "Nucleotide Mutations. Keeps only records..." | I could not build one entry from "reference base, position, and new base". I do not know whether it is A123T, A-123-T, or 123A>T. | Show one literal example string. |
| Settings, "Amino Acid Mutations. Keeps only records..." | Same problem, and I also do not know what a gene name looks like in this database. | Show one literal example string. |
| Reading the results, "Right-click it in the Finder and choose..." | The chapter has kept me inside the app until now and I did not know how to get from the sidebar to the Finder. | Say how to reveal the bundle in the Finder from the sidebar. |
| Reading the results, "a genome/ folder holds the sequence..." | "compressed FASTA with its indexes" reuses FASTA, which I only half remember from the previous chapter. | Gloss FASTA again at this first use. |
| Reading the results, "Nothing warns you when that happens." | This alarmed me and then left me nothing to do. I do not know whether a GenBank-sourced track is wrong or merely different. | Say whether to download again or whether the fallback track is fine to use. |
| Reading the results, "Inside that file the endpoint reads..." | A whole paragraph of field names and values I could not act on and could not judge. I read it twice and still do not know if I should check any of them. | Say this paragraph is reference material and needs no action now. |
| Reading the results, "The checksum is a short fingerprint..." | I do not know how I would work out a checksum myself, having never used a terminal. | Say where the app shows it so no typing is needed. |
| What good looks like, "A number well below that usually means..." | "Well below" gives me no threshold. For 16,569 I cannot tell whether 16,000 is a problem. | Give a cutoff, or say any number other than 16,569 is wrong for this record. |
| When fetch genome returns a different accession, whole section | The section is entirely about a command I was told I could skip, but it sits before the optional heading and reads like a warning I must act on. | Say at the top that dialog users are unaffected. |
| Searching Pathoplexus, "they combine with AND logic across..." | "AND logic" is a phrase I only half know from a library catalogue search box. | Say plainly that a record must match every filter I fill in. |
| Searching Pathoplexus, "Some of them are segmented, meaning..." | I understood the definition but not what changes for me. Nothing says what a segmented download produces. | Say whether a segmented genome arrives as one bundle or several. |
| Searching SRA, "which needs prefetch and fasterq-dump installed" | Two tool names with no sign of how a person installs them or whether I ever would. | Say the default path needs nothing installed. |
| On the command line, "lungfish-cli fetch ncbi NC_012920.1 \\" | The backslashes at the ends of lines stopped me. I did not know whether I type them or whether the manual is wrapping a long line. | One line saying the backslash continues the command onto the next line. |
| On the command line, "--api-key sends your NCBI API key..." | I do not know what an API key is or whether I have one. | Gloss it as a free identifier from NCBI and say the chapter works without one. |
| On the command line, "--db accepts genome here as well as..." | I had to read this twice to work out that the command line reaches a collection the dialog cannot. | Split it into two sentences. |

The one thing I learned. An accession is a promise rather than a label, and the `.1` on the end is the part that keeps it, because a curator can revise a record and a bare accession will then hand me a different sequence than the paper meant.

The one thing I still could not do. Write a filter in the Pathoplexus Nucleotide Mutations or Amino Acid Mutations field, because the chapter describes the format in words and never shows me one.

The sentence I liked most. "Fetch the same accession later and a different checksum means the deposited record changed under you."
