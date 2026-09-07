# Reader report: What Is a Genome

Reader 1, undergraduate persona. Sophomore, one genetics course, no lab time, never opened a terminal.

| Location | What stopped me | What would have helped |
| --- | --- | --- |
| What it is, "Run a sample on a sequencing" | I do not know what "a sample" is here. Blood? Spit? A tube of purified DNA? | Say what the sample physically is in one clause. |
| What it is, "what comes back is millions of" | "Short" compared to what? I have no sense of scale for a read. | Give a typical read length in bases. |
| What it is, "read from a well-characterised sample, filed" | "Well-characterised" told me nothing. Characterised how, and by whom? | Say what makes a sample good enough to become a reference. |
| What it is, "filed in a public database under" | I do not know which database this is, or how I would find a record in it. | Name the database once. |
| What it is, "such as `NG_000007.3`. When a paper" | I could not tell whether the `NG` prefix means something or is arbitrary. | Say whether the prefix encodes a record type. |
| What it is, "which is 1-based and inclusive, so" | I had to read this twice. The example explains 1-based but never inclusive. | Define inclusive right there, not six sections later. |
| Why you would do this, "The HBB gene record is `NG_000007.3`" | RefSeqGene is defined in the next sentence, but I hit the term first and stalled. | Put the definition before the term. |
| Why you would do this, "so it carries eight genes and" | I could not tell why a record about HBB would carry seven other genes. | One clause on why the cluster is filed together. |
| Why you would do this, "is split into three pieces by" | I know intron from class, but the chapter avoids the word, so I was not sure it was the same thing. | Use the word intron once and link it. |
| Why you would do this, "`join(70595..70686,70817..71039,71890..72018)`" | Nothing explains the `join` syntax or the double dots. I guessed. | Say that `join` lists the pieces and `..` marks a range. |
| Why you would do this, "The sixth amino acid of the" | "Mature" protein confused me. Mature as opposed to what? | Drop "mature" or say the first amino acid is removed. |
| Why you would do this, "a person who inherits the change" | I wanted to know what happens with only one copy, and it is not said. | One sentence on the single-copy case. |
| Before you start, "You need a project open in" | I do not know how to make a project. Nothing here tells me. | Point to where projects are created. |
| Before you start, "The fixture ships the record as" | I do not know what a fixture is or where it sits on my computer. | Say what a fixture is and give its folder. |
| Before you start, "Fixture details and citation are recorded" | Raw template text `{{ fixtures_refs[] \| cite }}` sits in the page. It looks broken. | Render the citation. |
| Procedure step 1, "Choose **File > Import Center...** (Cmd-Shift-I)" | I could not tell whether Cmd-Shift-I is an alternative to the menu or an extra step. | Say the shortcut does the same thing. |
| Procedure step 2, "LGE compresses and indexes the sequence" | I could not tell whether I have to wait, or how I know it finished. | Say what appears when the import is done. |
| Procedure step 3, "Find the new bundle under `Reference Sequences/`" | I do not know what name the bundle will have, so I would not know what to look for. | Say what the bundle is called after import. |
| Procedure step 4, "type `NG_000007:70613-70615`. The viewport frames" | The `.3` version is dropped only here. I thought it was a typo and would have typed it back in. | Flag the dropped version at the moment of typing. |
| Procedure step 5, "the position field on the ruler" | I do not know what the ruler is or where in the window to find it. | Say where the ruler sits. |
| Reading the results, "a folder that macOS shows as" | I did not understand how a folder can look like one item, or how I would look inside. | One clause saying it behaves like a file until you ask otherwise. |
| Reading the results, "holds the sequence as a compressed" | Two indexes, but I never learn what the second one is for. | Name the two indexes or say why there are two. |
| Reading the results, "A checksum is a short fingerprint" | The definition helped, but I do not know what to do when two checksums differ. | Say what a mismatch means in practice. |
| Reading the results, "even after its chromosome-name mapping runs" | I do not know what chromosome-name mapping is. It appears once, undefined. | Gloss it, or cut it. |
| Reading the results, "and 102 annotation features in total" | I cannot judge 102. Is that a rich record or a sparse one? | Say what number would signal a problem. |
| Reading a variant, "`A` is the reference base, called" | I could not tell whether REF and ALT are things inside a file or just words people say. | Say they are column names in the file. |
| Reading a variant, "An insertion makes REF one base" | I could not work out how one letter and several letters describe inserted bases. | A two-base worked example. |
| Sample data and reference data, "It came off an instrument with" | Quality score is named but never explained, and I do not know what a good one is. | Say what a quality score measures. |
| Sample data and reference data, "and stretches where almost no reads" | I did not know whether empty stretches are normal or a failure. | Say whether gaps are expected. |
| Sample data and reference data, "Read or region extractions land under" | I do not know what a read extraction or a region extraction is. Both terms are new. | Gloss both, or defer them to their own chapter. |
| Linear, circular, and segmented genomes, "The problem belongs to plasmids and" | "The problem" is not clearly the origin-crossing read, and plasmid is undefined. | Name the problem again and gloss plasmid. |
| Linear, circular, and segmented genomes, "An RNA reference is spelled with" | This contradicted my class, where RNA has U. The reason follows, but I had already stopped. | Put the reason before the claim. |
| What good looks like, "since a bundle built from a" | I do not know whether my own file counts as "bare" FASTA, and the check depends on it. | Say how to tell the two apart. |
| Why reference choice matters, "Human germline work uses the GRCh38" | Assembly is a new word here, and I cannot tell how it differs from a reference genome. | Gloss assembly at this use. |
| Why reference choice matters, "and a large amount of clinical" | I could not tell whether LGE does the translating for me or not. | Say plainly whether LGE converts coordinates. |
| On the command line, "The same import runs from `lungfish-cli`" | I have never opened a terminal and cannot tell where I would type this. | Say the section is optional and needs a terminal. |
| On the command line, "lungfish-cli import fasta docs/user-manual/fixtures" | The path is relative to something I cannot identify, so I could not run the command. | Say what directory the command runs from. |
| On the command line, "`--output-dir` names the project directory" | The procedure needed a project already open, but this command seems to make one. I could not reconcile them. | Say whether the command creates the project. |

One thing I learned. A position number means nothing without the name of the reference it sits on, so `NG_000007.3:70614 A>T` carries its own map with it.

One thing I still could not do. Create a project and locate the fixture file, so I never reached step 1.

The sentence I liked most. "Take the map away and two labs sequencing the same patient sample would name the same change with different numbers."
