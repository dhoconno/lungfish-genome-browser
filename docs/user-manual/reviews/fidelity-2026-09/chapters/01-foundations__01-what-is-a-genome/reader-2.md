# Reader report: What Is a Genome

Reader 2. Senior, two years of pipetting, PCRs and gels, no sequencing analysis, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Run a sample on a sequencing" | I have never run one. I do not know how long a read is, or how many "millions" means for one sample. | Give one concrete number, such as a typical read length and read count. |
| What it is, "which are fragments of the sequence" | I could not tell whether the fragments come from random places or from ordered pieces along the genome. | Say in one clause that the fragments come from random positions. |
| What it is, "read from a well-characterised sample" | I do not know what makes a sample well characterised, or who decides. | Name one property that qualifies a sample. |
| What it is, "It is a coordinate on a" | I had to read this paragraph twice. The accession, the position number, and the map arrive in four sentences. | Split the accession sentence away from the coordinate sentence. |
| What it is, "The second is how Lungfish" | I know what 1-based means from the following clause, but not what inclusive means. Nothing says what it excludes. | Say that both the start base and the end base are counted. |
| Why you would do this, "The HBB gene record is" | RefSeqGene is not glossed until the next sentence, so I stalled on it once. | Move the definition ahead of the accession. |
| Why you would do this, "This one is 81,706 bases" | I could not tell whether the other seven genes matter for anything I do in this chapter. | Say in half a sentence that the other seven are not used here. |
| Why you would do this, "Its protein-coding stretch, the CDS" | I have never seen the join notation. I guessed the two dots mean a range and the commas separate pieces. | Gloss the join notation, since it is the only place two dots appear. |
| Why you would do this, "The sixth amino acid of" | I do not know what mature means for a protein, and I could not connect the sixth amino acid to any number on the page. | Say why the count starts after processing, or drop the word. |
| Why you would do this, "Change the middle base of" | I could not work out from the text alone which coordinate the middle base has until a later section told me. | Give the position here, since the codon range appears later anyway. |
| Before you start, "You need a project open" | I have never made a project. Nothing on this page tells me how, and this is the first thing asked of me. | Point to the chapter or menu item that creates a project. |
| Before you start, "The fixture ships the record" | I do not know what a fixture is or where it lives on my computer. The word appears three times and is never glossed. | Gloss fixture at first use and give the folder path. |
| Before you start, "Fixture details and citation are" | The line with the double braces is printed on the page. I do not know if that is an error or something I should click. | Fix or remove the unrendered placeholder. |
| Procedure step 1, "Choose File > Import Center..." | I could not tell whether the Reference Sequences tab is already open or whether I must click something to open it. | Say where the tab sits in the window. |
| Procedure step 2, "Drop NG_000007.3.gb onto the Reference" | I could not tell how long the import takes or how I know it finished. No end state is described before step 3. | Say what appears when the import is done. |
| Procedure step 4, "Choose Sequence > Go to" | The record is called NG_000007.3 everywhere else and here the .3 is gone. I retyped it twice thinking I had erred. | Flag the dropped version at the moment of typing, not two sections later. |
| Procedure step 5, "Type the same coordinate into" | I do not know what the ruler is or where on screen to find it. | Name where the ruler sits relative to the bases. |
| Reading the results, "The bundle in the sidebar" | I could not work out how to look inside the bundle if I wanted to check the manifest. | Say the Finder gesture that opens it, or say you never need to. |
| Reading the results, "Inside it, a manifest.json sits" | Two indexes, but only one index is explained. I do not know what the second one is for. | Name both indexes, or say only that there are companion files. |
| Reading the results, "Hand LGE a coordinate whose" | I do not know what the chromosome-name mapping is, whether I configure it, or what it maps between. | Gloss the mapping in one sentence or cut the clause. |
| Reading the results, "The record carries 8 genes" | Eight genes but only five mRNAs and five CDS features. I could not tell whether that gap is normal or a sign of a bad import. | Say in one clause why the counts differ. |
| Reading the results, "and 102 annotation features in" | I do not know how to judge 102. Nothing says whether that is a lot for a record this size. | Say that the count is what this record should show. |
| Reading a variant, "70614 is the 1-based position" | I had to count on my fingers to confirm 70614 is the middle. The text asserts it without showing it. | Lay the three positions under the three bases. |
| Reading a variant, "A is the reference base" | I do not know what a VCF looks like or when I would see one. It is named here and again later before any chapter covers it. | Say which chapter covers VCF. |
| Sample data and reference data, "It came off an instrument" | I know quality from gels, not from bases. I do not know what scale a per-base quality score is on. | Say the scale, or defer the term to the reads chapter. |
| Sample data and reference data, "a share of sequencing errors" | I could not tell whether stretches with almost no reads are expected on every run or a sign of a failed sample. | Say that some low-coverage stretches are normal. |
| Sample data and reference data, "so when you publish a" | I do not know what pinning a version means as an action, or whether I do it in LGE or in a paper. | Say where the version gets written down. |
| Linear, circular, and segmented, "Bacterial chromosomes and many viral" | I could not tell whether a curator-chosen origin affects anything I would do, since this chapter's record is linear. | Say whether a circular reference changes any step above. |
| Linear, circular, and segmented, "The problem belongs to plasmids" | The problem was never named as a problem. The prior sentences describe a split read but not what goes wrong. | Name the consequence before calling it a problem. |
| Linear, circular, and segmented, "On disk, a DNA genome" | I read this twice because the paragraph says the two are indistinguishable and then describes a difference. | Put the T for U substitution before the claim about indistinguishability. |
| What good looks like, "Confirm that the sequence viewport" | I do not know where in the viewport a length is displayed. | Name the place the length appears. |
| What good looks like, "If any of those disagree" | I could not act on this. I do not know how to check which record a .gb file holds without opening a terminal. | Say how to check the file from inside LGE. |
| Why reference choice matters, "Human germline work uses the" | Neither GRCh38 nor GRCh37 is glossed. I do not know if these are files I download or names I only read about. | Gloss assembly at first use here. |
| Why reference choice matters, "And every variant call keeps" | I do not know how to look at a file header. That is the second check offered that I cannot perform. | Say where LGE shows the header. |
| On the command line, "The same import runs from" | I have never opened a terminal. I cannot tell whether this section is optional or something I will eventually need. | Say the section is optional. |
| On the command line, "lungfish-cli import fasta docs/user-manual/fixtures" | The path is relative and I do not know what folder I would be starting from. | Show the path from the home folder, as the output option does. |
| On the command line, "Despite the subcommand name, the" | The command says import fasta but the file ends in .gb, and I read the whole block twice before the explanation arrived. | Put the caveat before the code block. |

The one thing I learned is that a position number means nothing without the name of the sequence it sits on, and that the same base carries a different number on a different reference.

The one thing I still could not do is get to step 1, because I have never made a project in LGE and this chapter begins by assuming one is already open.

The sentence I liked most is "It does not move while you analyse sample after sample against it, and that stillness is the point."
