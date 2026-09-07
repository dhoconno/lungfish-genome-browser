# Reader 1 report — 12S Amplicon Metabarcoding

Persona: sophomore, one genetics course, no lab time, never opened a terminal, never used sequencing software.

| Location | What stopped me | What would have helped |
|---|---|---|
| What it is — "reading the amplicon tells you which" | The opening paragraph carries mitochondrial genome, PCR, primers, conserved, and amplicon in five sentences. I understood each gloss but lost the thread of the argument by the end. | Split the primer sentence out into its own short paragraph. |
| What it is — "compared base for base against" | I could not picture what "base for base" comparison means when the read is longer than the reference record. Step 5 later says a read must contain the reference, which is what I needed here. | Say the read must contain the whole reference stretch. |
| What it is — "This differs from a classifier such as Kraken 2" | Kraken 2 is named as if I would know it. I have never heard of it and the sentence assumes I need the contrast. | Add three words saying Kraken 2 is a classifier covered earlier in this part. |
| What it is — "So what should you do with this?" | The question is addressed to me but I had not yet done anything, so I did not know it was a preview of the procedure rather than a task. | Drop the question and state the three steps plainly. |
| Why you would do this — "none of the mapping or variant-calling workflows" | Mapping and variant calling are named but not glossed here. I only half know them from the genetics course. | Gloss both or point to the chapters that cover them. |
| Why you would do this — "it will happily report a genus" | Genus and family are used to show a precision difference. I know the ranks in order but could not tell which is the worse error here without stopping to count. | Say a genus call is broader than a species call. |
| Why you would do this — "the HG002 mitochondrial reads, both of" | HG002 appears with no explanation. I could not tell whether it is a person, a cell line, or a file name. | One clause saying HG002 is a standard human reference sample. |
| Before you start — "Build the demo project first if" | This tells me to build the demo project but not how, and no link is given. I could not perform this step. | Link to the chapter that builds the demo project. |
| Before you start — "This is not the experimental-features switch" | I did not know there was an experimental-features switch, so being told this is not it left me wondering what I had missed. | Delete the sentence. |
| Before you start — "the plugin pack the workflow depends on, which the card names as Lungfish Tools" | Plugin pack is not glossed, and I did not know whether installing it costs anything, needs a network, or takes minutes or hours. | Gloss plugin pack and say installing needs a network connection. |
| Before you start — "It expects reads that are already merged" | I understood what merged means from the gloss, but I could not tell how to know whether my own files are already merged. | Say how a merged bundle is labelled in the project. |
| Before you start — "Merge them with a read-processing operation first" | "a read-processing operation" is not named and not linked, so I could not go do it. | Name the exact menu command and link the chapter. |
| Procedure 1 — "open the dialog as described in step 2" | Step 1 sends me forward to step 2 and step 2 assumes the reference already exists. I read both twice to work out the order. | Reorder so the dialog opens first. |
| Procedure 1 — "a metadata table in the MIDORI style" | MIDORI is never explained. I do not know if it is a database, a file format, or a lab convention, and I would not know where to get one. | Say MIDORI is a public 12S reference database and link it. |
| Procedure 1 — "naming its common name, its scientific name, its taxon group" | The four columns named here do not match the seven columns listed in the command-line section. I could not tell which list to build my file from. | Use the same column list in both places. |
| Procedure 2 — "pick one from the Project Reference menu above it if the workflow found candidates" | I could not tell what makes a file a candidate, so I would not know whether an empty menu means a problem. | Say which folder LGE searches for candidates. |
| Procedure 2 — "they run together as one batch" | I did not understand what running as one batch changes. Do the samples get pooled into one row, or stay separate? | Say each bundle stays a separate sample row. |
| Procedure 3 — "their defaults are reasonable for a first run" | Reasonable for a first run does not tell me whether the result would be publishable or only a practice run. | Say the defaults are the ones used for the worked example. |
| Procedure 4 — "reports four figures separated by vertical bars" | The four figures are named in order but no example line is shown, so I could not check I was reading the right number. | Show the worked example's actual summary line. |
| Procedure 4 — "Refs is how many reference records that species matched" | I could not judge whether a high Refs count is good or bad, and the section never says. | State whether a high Refs count matters. |
| Procedure 5 — "with Sequence (the cluster's identifier)" | The column is called Sequence but holds an identifier, while Bases holds the sequence. I read that twice. | Say the Sequence column holds a short label, not DNA. |
| Procedure 5 — "Clusters marked as chimera candidates are usually artifacts" | Artifact is used here and again in later sections but never glossed, and chimera is glossed only in Settings, two sections later. | Gloss chimera and artifact at this first use. |
| Procedure 6 — "takes noticeably longer than the local match" | Noticeably longer gives me no idea whether to wait or come back tomorrow. | Give a rough time for one cluster. |
| Procedure 6 — "A high-identity hit to a plausible animal" | High identity is the deciding number of this whole step and no figure is given. I could not judge 91 percent against 99 percent. | Give a percent identity to look for. |
| Procedure 7 — "take the unresolved-sequences.fasta the workflow already wrote into the result bundle" | I do not know how to look inside a result bundle from the Finder, and nothing here says. | Say how to reveal the bundle contents. |
| Settings — "The dialog carries eight controls and the Inspector's 12S Results section carries six more" | Inspector is used as if I know where it is. It never appears in the Procedure, so I could not find it. | Say the Inspector is the right-hand panel and how to show it. |
| Settings — "The first three sit under the Target Rows disclosure and the last two under Unmatched Reads" | Six controls follow but only three plus two are placed, so one is unaccounted for. I counted twice. | Fix the count. |
| Settings — "Sets how many of the read's own bases must sit on each side" | Min Soft Clip defaults to 1 and I could not judge what raising it to 5 or 20 would cost me. Soft clip is glossed nowhere in the body. | Gloss soft clip and give a raised value worth trying. |
| Settings — "the field only takes effect when Read Platform is set to ONT indel-tolerant" | ONT appears here for the first time as an abbreviation. Earlier text says Oxford Nanopore. | Expand ONT at this first use. |
| Settings — "the field accepts 0 to 1,000,000" | The accepted range tells me nothing about a useful value. Two settings give the same range. | Give a typical value instead of the range. |
| Settings — "Turn it on for diet or environmental studies" | Exclude Human says human reads are almost always contamination, but the worked example is human reads and reports 100 percent Homo sapiens. I could not reconcile the two. | Note that the worked example is the exception. |
| Reading the results — "110 matched exactly, and 63 were left unresolved, giving a 63.6 percent exact-match rate" | 110 of 173 is 63.6 percent, but the sentence puts 63 next to 63.6 and I spent a while thinking those were the same number. | Reorder so the percent follows 110 directly. |
| Reading the results — "the four other primates in the reference, the chimpanzee, the gorilla, and the two macaques, each at zero" | It says four then lists three names plus "the two macaques", which is four items but reads as three. | Name all four species. |
| Reading the results — "The default policy lets any nonzero lead win" | A single read of lead deciding a species call sounded alarming and the text does not say whether that is safe. | Say how often a one-read lead occurs in practice. |
| Reading the results — "Every such reassignment is recorded in its own channel" | Channel is not a word I know in this context and nothing says where to look at it. | Say which file or column holds the reassignments. |
| What good looks like — "usually lands high" | The first check in the section has no number, and then the worked example scores 63.6 percent, which the text calls a trap. I could not tell whether 63.6 is good. | Give an approximate percent for a healthy run. |
| What good looks like — "The reads were oriented to match the reference before matching" | This says orientation was already fixed, then says matching without orienting found only 35. I read the paragraph three times to work out which run produced the 110. | Say plainly that the chapter's example used oriented reads. |
| What good looks like — "meaning the reverse complement" | Reverse complement is glossed as "read from the other strand", which does not tell me the bases are also flipped. That is what actually made it fail to match. | Gloss reverse complement fully. |
| What good looks like — "Click the information button at the right of the action bar" | The action bar is mentioned in steps 6 and 7 but never located on screen. | Say the action bar sits along the bottom of the viewport. |
| On the command line — "by typing into the Terminal application" | I have never opened Terminal and this section is the only route to a FASTA of unresolved clusters, which step 7 sends me here for. | Say where a beginner can learn to open Terminal. |
| On the command line — "The command's own help text lists only five of those seven" | Being told the app's own help is wrong made me doubt the rest of the chapter. | Move this to a note rather than the main flow. |
| On the command line — "its --compress option currently writes plain text rather than gzip" | A second admitted bug, and I could not tell whether either one had been fixed in the version I would install. | Say which version these apply to. |

Three lines.

The one thing I learned: an exact-match workflow refuses to guess, so the unresolved pile is the interesting part rather than the leftovers.

The one thing I still could not do: get the unresolved cluster sequences as a FASTA, because both routes go through a terminal I have never opened or a bundle I do not know how to open.

The sentence I liked most: "A chimera looks exactly like a novel species until something checks it."
