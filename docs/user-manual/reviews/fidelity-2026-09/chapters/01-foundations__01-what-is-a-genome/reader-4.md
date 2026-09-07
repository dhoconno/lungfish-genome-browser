# Reader report: What Is a Genome

Persona: a student who used Geneious in one class to look at a few sequences and align them. Never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is: "Sequencing does not hand you..." | "Run a sample on a sequencing instrument" assumes I know what a sample is here. Is it blood, a tube of DNA, a file? | Say what the physical thing is once. |
| What it is: "That already-known version is the" | "read from a well-characterised sample" - I do not know what makes a sample well characterised or who decides. | One clause saying who characterises it. |
| What it is: "Three ideas carry through every" | Had to read twice. The sentence about the second idea packs 1-based, inclusive, position 1 not 0, and pairing with a sequence name into one breath. | Break the second idea into its own sentence. |
| What it is: "Three ideas carry through every" | "treat the worked coordinate at the end as your checkpoint" - I could not tell which thing at the end is the checkpoint. There are several coordinates near the end. | Name the section that holds the checkpoint. |
| Why you would do this: "The HBB gene record is" | "RefSeqGene record" arrives before it is glossed, and I did not know RefSeq at all. In Geneious I just had accessions. | Gloss RefSeq before RefSeqGene. |
| Why you would do this: "This one is 81,706 bases" | "covers the whole beta-globin cluster, so it carries eight genes" - I do not know what a gene cluster is or why genes sit together. | One sentence on what a cluster is. |
| Why you would do this: "Its protein-coding stretch, the CDS," | `join(70595..70686,70817..71039,71890..72018)` was never explained. Two dots, commas, the word join. I could guess but not be sure. | Say the two dots mean a range and join means the pieces are stitched. |
| Why you would do this: "Sickle cell disease comes from" | "The sixth amino acid of the mature beta-globin protein" - mature is doing work I do not understand. Mature as opposed to what? | Drop or gloss "mature". |
| Why you would do this: "Change the middle base of that codon" | I could not connect codon position 70614 to "sixth amino acid". Why does amino acid six sit 70 thousand bases in? | One line linking the CDS start to the codon. |
| Before you start: "You need a project open in LGE" | I do not know how to make or open a project. The chapter never says. This is the first step and I am already stuck. | Point to where projects are created. |
| Before you start: "The fixture ships the record as" | "The fixture" - I do not know what a fixture is or where I get it. Is it downloaded with the app? | Say where the fixture file lives. |
| Before you start: "Fixture details and citation are recorded" | The line ends with template code printed literally instead of a citation. It looks broken. | Fix or remove the leftover. |
| Procedure step 2: "Drop `NG_000007.3.gb` onto the" | "LGE compresses and indexes the sequence and builds the bundle" - I do not know how long this takes or how I know it finished. | Say what tells me it is done. |
| Procedure step 3: "Find the new bundle under" | I do not know what the sidebar is or where on screen it sits. Geneious called it something else. | Name the sidebar's position once. |
| Procedure step 4: "Choose Sequence > Go to Location..." | The record is `NG_000007.3` but here I type `NG_000007` with no `.3`. I thought I had made a typo. The reason appears two sections later. | Flag the dropped version at the moment of typing. |
| Procedure step 5: "Type the same coordinate into the" | "the position field on the ruler" - I never learned there is a ruler or where. | Point at the ruler in a screenshot caption. |
| Reading the results: "Inside it, a `manifest.json` sits" | A wall of folder names, and I do not know if I am supposed to open any of them or just know they exist. | Say whether I ever touch these. |
| Reading the results: "a `genome/` folder holds the sequence" | "compressed FASTA with its two indexes beside it" - two indexes, and I do not know what either is for or their names. | Name the two indexes. |
| Reading the results: "Select the reference in the sidebar" | "a SHA-256 checksum" - the gloss tells me what a checksum does but not what I should do if two checksums differ. | Say what action a mismatch calls for. |
| Reading the results: "which the assembly literature calls the" | "the assembly literature" sent me off wondering what assembly is. It is not glossed here. | Cut the phrase or gloss assembly. |
| Reading the results: "Hand LGE a coordinate whose contig" | "even after its chromosome-name mapping runs, and it refuses" - I do not know what that mapping is, and "it refuses" does not tell me what I see. | Quote the message I would see. |
| Reading the results: "The record carries 8 genes, 5 mRNAs," | I cannot judge these numbers. 102 features in total, is that a lot? And I cannot see where in the app to count them. | Say where the feature count is displayed. |
| Reading a variant: "`A` is the reference base, called" | REF and ALT and VCF all arrive in one sentence. I had to read it three times to keep them apart. | Split REF and ALT into separate sentences. |
| Reading a variant: "An insertion makes REF one base" | "a deletion does the reverse" made me stop and work out the reverse for myself. | Spell the deletion case out. |
| Reading a variant: "and why the variants table always shows" | I have not seen a variants table anywhere yet. It is mentioned as if I know it. | Say which chapter shows the table. |
| Sample data and reference data: "It came off an instrument with" | "per-base quality scores" is dropped in with no gloss, though FASTQ and BAM around it are glossed. | Gloss quality score at first use. |
| Sample data and reference data: "and stretches where almost no reads landed" | I do not know if that is normal or a problem I should fix. | Say whether gaps are expected. |
| Sample data and reference data: "so when you publish a position you" | "you should pin the version" - I do not know what pinning means as an action I take. | Say what pinning looks like in practice. |
| Linear, circular, and segmented: "A read that physically crossed that origin" | I could not follow why one read becomes two pieces, and whether that breaks anything for me. | Say what the consequence is for my results. |
| Linear, circular, and segmented: "The problem belongs to plasmids and" | Plasmid is never glossed, and the next sentence repeats the unrolling point from two sentences earlier, so I reread to check I had not missed something new. | Gloss plasmid and cut the repeat. |
| What good looks like: "Confirm that the sequence viewport shows" | I do not know where in the viewport the length is shown. | Say where the length appears. |
| What good looks like: "Confirm that the bases at 70613 to 70615" | Step 4 already framed those bases and said they read `GAG`, so this check felt circular. I was not sure it was a new action. | Say what would make this check fail. |
| Why reference choice matters: "Human germline work uses the GRCh38" | Germline, GRCh38, GRCh37 all new. I do not know if this affects what I just did. | Gloss germline and say whether this applies to HBB. |
| Why reference choice matters: "Align against a reference that differs by" | "Align" is used as a known verb, but alignment has not been introduced in this chapter. | Point to the alignment chapter. |
| On the command line: "The same import runs from `lungfish-cli`," | I have never opened a terminal. Nothing says whether I can skip this section or where I would type this. | Say the section is optional for GUI users. |
| On the command line: "lungfish-cli import fasta docs/user-manual/fixtures/" | The path starting `docs/user-manual/fixtures/` is not a place on my computer. I would not know what to put instead. | Use a path a reader would actually have. |
| On the command line: "`--output-dir` names the project directory" | `~/Documents/hbb-example.lungfish` ends in `.lungfish` but the bundle is `.lungfishref`. Two similar extensions, and I could not tell which is which. | Say the project and the bundle have different extensions. |

The one thing I learned is that a position number is meaningless without the name and version of the reference it was measured on, which is why the same sickle cell change has a different number in three different files.

The one thing I still could not do is get to step 1, because the chapter tells me I need a project open and a fixture file but never says how to make a project or where the fixture file comes from.

The sentence I liked most is "A sample's sequence is what you gathered. A reference is what you hold it up against."
