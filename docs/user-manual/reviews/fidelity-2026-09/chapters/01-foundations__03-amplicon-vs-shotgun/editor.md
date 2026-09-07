# Editor pass: 01-foundations/03-amplicon-vs-shotgun

Date: 2026-09-06
Role: Brand Copy Editor
Chapter: `docs/user-manual/chapters/01-foundations/03-amplicon-vs-shotgun.md`

Inputs applied in order: `fidelity.md` (with the project manager's rulings on
the five unverifiable rows), `readers.md` (merged four-reader report),
`CONSISTENCY.md`, `docs/user-manual/STYLE.md`, and the brand style guide.

`brand_reviewed` and `lead_approved` both remain `false`.

## Changes

| Location | Change | Reason | Source |
|---|---|---|---|
| Primer trimming, first method | "LGE's Primer Remove operation" became "LGE's Primer Trimming operation", and the corrected wording's second sentence "On the command line this is `lungfish-cli fastq primer-remove`." was added | No LGE surface is called "Primer Remove". The GUI operation title is "Primer Trimming" and `primer-remove` is only the CLI subcommand | fidelity |
| Primer trimming, first method | "Its engine is `bbduk` by default, with `cutadapt-linked` as the alternative." became the corrected two-sentence wording separating the CLI flag from the app's source-driven choice | The engine is a command-line flag. The GUI exposes no engine control and picks the tool from the primer source, so the old sentence misled a GUI reader | fidelity |
| Why you would do this, HG002 paragraph | "That coverage is smooth, because no one chose ... at fixed points" became "Shotgun coverage in general is smooth, because no one chose ... at fixed points" | Rewritten as a general statement about shotgun libraries rather than an observation on this fixture. The repo holds no per-base depth track for the slice, so no sentence now claims a measurement the repo does not hold | fidelity |
| Why you would do this, Williams paragraph | "Its coverage does not spread across a chromosome at all. It piles onto a set of designed targets" became "Amplicon coverage in general does not spread across a chromosome at all. It piles onto the set of targets the primers were designed to reach." | Same ruling. No coverage artifact from the Williams genotype bundles was inspected, so the shape claim is now general rather than an observation on that dataset | fidelity |
| Why you would do this, depth sentence | Added a band for depth ("Around 30 or more is comfortable ... under 10 is too thin to trust, so 44.7 is a healthy working depth") | Hit by 4 readers. A number given with no scale to judge it against. Follows the CONSISTENCY recurring-sentence shape, measure then typical then bad | readers |
| Why you would do this, coverage sentence | Added "Coverage breadth is the share of positions that got any reads at all. Above 99% is routine ... a figure in the 80s or 90s would point at reads lost to repeats or to a mismatched reference." | Hit by 4 readers. 99.99% had no baseline to read it against | readers |
| Why you would do this, HG002 paragraph | Added "HG002 is a reference human sample sequenced many times over by many groups, which is why it is used to benchmark methods." | Hit by 2 readers, one-sentence fix. HG002 was used as though already met | readers |
| Why you would do this, HG002 paragraph | Added "A read pair is the two reads that came from opposite ends of one fragment, so 45,574 pairs means 91,148 reads split across the two files." | Hit by 3 readers, read pairs and paired files unexplained. The 91,148 figure is the fidelity review's own committed-file count, matching the minimap2 log | readers |
| Why you would do this, Williams paragraph | Added "It is a laboratory dataset named for the group that produced it" | Hit by 2 readers, one-clause fix. "Williams" had no referent | readers |
| Why you would do this, new paragraph on the MHC reference | Split the allele-database claim into its own paragraph and added that it is a catalogue of known MHC variants rather than a chromosome, that reads are matched against the catalogue, and that some references are lists of alleles in this way | Hit by 4 readers. A reference that is hundreds of allele sequences broke the mental model of what a reference is. The fidelity review confirmed the fact, so explanation was added rather than the fact changed | readers |
| Why you would do this, allele lengths | Reworded to say why several lengths exist and to account for the balance ("The remaining 195 records sit at other lengths") | Hit by 2 readers. The two figures did not visibly add to 970. 577 + 198 + 195 = 970 | readers |
| What it is, FASTQ paragraph | Replaced "Each holds the same four lines per read, the same quality strings, and the same pair of files" with a naming of the four lines and of the two paired files | Hit by 3 readers for the four lines and 3 for the paired files | readers |
| What it is, variant caller | Added "A variant caller is the program that compares your reads to a reference and decides where the sample genuinely differs from it." | Hit by 1 reader, one-sentence fix, and the term is central to the chapter's argument | readers |
| Shotgun sequencing, randomness hedge | "which is close enough to random for the purpose" became "and for every purpose in this manual that placement is random" | Hit by 3 readers. The hedge claimed then withdrew randomness | readers |
| Shotgun sequencing, adapters | Added "LGE never removes adapters on its own. Adapter Removal is a separate operation you run deliberately, so if you did not run it, it did not happen." | Hit by 2 readers, who could not tell what LGE does or how to confirm. The existing sentence about instrument software was left verbatim per the project manager's ruling. The separate Adapter Removal operation is confirmed in the fidelity evidence | readers |
| Amplicon sequencing, loci | Added "A locus is one specific place on the genome, and loci is its plural." | Hit by 3 readers. Term unglossed in running text | readers |
| Amplicon sequencing, chimeric product | Added a gloss of both template and chimeric product | Hit by 4 readers, including one who flagged "template" in the same sentence | readers |
| Amplicon sequencing, 0.05 | Added "That 0.05 is a fraction rather than a percentage, so it means the difference has to appear in at least 5 percent of the reads stacked at that position before the caller will report it." | Hit by 4 readers, who could not tell the unit | readers |
| What an amplicon looks like, ranges | Added "Every position range in this manual counts both of its ends, so positions 1000 to 1021 is 22 bases and not 21." | Hit by 4 readers, who had to count on their fingers and were then undercut by the BED row | readers |
| What an amplicon looks like, read 2 | Added "The two reads of a pair start at opposite ends of the molecule and are read inward toward each other, so read 1 begins at the amplicon's left edge and read 2 begins at its right edge." | Hit by 4 readers, who could not see why read 2 starts at 1250 | readers |
| What an amplicon looks like, middle gap | "are filled in by its neighbours" became "That gap is expected rather than a fault, because in a tiling scheme the neighbouring amplicons overlap this one and cover it." | Hit by 3 readers, who could not tell whether the gap was a problem | readers |
| Primer trimming, BAM | Added "A BAM is the file that holds your reads after they have been mapped, each read recorded with the reference position it landed on." | Hit by 2 readers. BAM appeared in a sentence they had to act on | readers |
| Primer trimming, pileup | Added "The pileup is the stack of reads sitting over one reference position, which is the evidence a variant caller weighs there." | Hit by 2 readers. Term unglossed anywhere in the chapter | readers |
| Primer trimming, Inspector | Split the long sentence and added "The Inspector is the panel down the right-hand side of the project window, showing details and actions for whatever you have selected." Wording of the tab follows CONSISTENCY ("the Primer Trim tab of the Inspector") | Hit by 4 readers. The Inspector was used for real steps but never located | readers, consistency |
| Primer trimming, provenance sidecar | Added "A provenance sidecar is a small file LGE saves beside every result, holding the tool version, the full command, and the checksums of what went in and came out." | Hit by 4 readers, who could not tell whether it was a file, panel, or setting | readers |
| Primer trimming, new paragraph | Added "Prefer the alignment-based trim whenever you have a primer scheme and a mapped BAM ... Reach for the read-based trim only when you have no reference to map against, or when you want trimmed FASTQ files to hand on to something outside LGE." | Hit by 4 readers, who could not tell what choosing between the two changes. The chapter's own opening promises "this chapter says which to prefer" and never delivered it | readers |
| Primer trimming, dropped reads | Added "Losing a few reads this way is normal rather than a fault, and `ivar trim` writes its own tally of what it kept and dropped into the run's log, which the Operations panel row for the trim links to." | Hit by 3 readers, who were warned about dropped reads but not told where to look. Scoped to the run log rather than a structured count, since the source surfaces no kept/dropped field | readers |
| What a primer scheme is, score column | Added "The score column carries no meaning for primer schemes. It is present because BED requires it, it is filled with a placeholder, and nothing in LGE reads it." | Hit by 4 readers. Column listed but never explained | readers |
| What a primer scheme is, BED counting | Split the zero-based half-open sentence into two paragraphs that separate the two rules and then combine them on the worked example | Hit by 2 readers, whose shortest fix was exactly this split | readers |
| What a primer scheme is, bundle | Added "To look inside safely, right-click the bundle in the Finder and choose Show Package Contents, which opens it as the folder it is." | Hit by 2 readers, who did not know a folder can display as one item or whether opening it was safe | readers |
| The schemes LGE ships, spike-in | Added "A spike-in primer is an extra primer added to an existing design to bring back an amplicon that stopped working, and the term has nothing to do with the coronavirus spike gene." | Hit by 4 readers, who read it as spike-protein related | readers |
| The schemes LGE ships, importing | Added the in-app route first ("click \"Choose Scheme…\" beside the Primer Scheme menu and point the file chooser at a `.lungfishprimers` bundle") and kept `lungfish-cli primers import` for the two jobs only it does | Hit by 4 readers, none of whom had opened a terminal, and the only route given was a CLI command. The in-app route is the verified `onBrowse` button already described one paragraph earlier | readers |
| How to tell which prep, SRA and ENA | Added "The SRA is NCBI's Sequence Read Archive and the ENA is the European Nucleotide Archive, the two public archives where raw sequencing reads are deposited, and each run in them carries a metadata page with those fields on it." | Hit by 4 readers, both acronyms unexpanded. The existing claim about the metadata fields was left as written per the project manager's ruling | readers |
| Target enrichment, three names | Split the dense sentence, settled on one name for the technique, and glossed hybridisation on its own | Hit by 2 readers | readers |
| Target enrichment, Twist and IDT | Added "named here only as examples of commercial vendors rather than as products you need" | Hit by 3 readers. The vendor sentence itself was left as written per the project manager's ruling | readers |
| Target enrichment, later paragraphs | "Capture borrows from both sides" became "Target enrichment borrows from both sides", and "treat capture data as shotgun data" became "treat target-enrichment data as shotgun data" | Consistency with the new sentence naming target enrichment as the manual's one name for the technique | style |
| What it is, closing paragraph | "So what should you do with this?" became "What this asks of you is one habit." | Rhetorical filler question, off-voice for the trustworthy and calm quality | style |
| Why you would do this, closing | "Read on to see which question yours is asking." became "The sections that follow set out what each one is good for, so you can place your own sample against them." | Exhortation replaced with a purposeful statement of what the reader gets | style |
| Primer trimming, first method | Merged the two consecutive "On the command line" sentences into one and changed "the default suits an ordinary run" to "the choice it makes suits an ordinary run" | Repetition introduced by the fidelity correction. "Default" was inaccurate once the app picks by source rather than defaulting | style |
| The schemes LGE ships, spike-in gloss | Dropped "simply", and changed a second "restore" to "bring back" | Filler adverb and a word repeated twice in one paragraph | style |
| Target enrichment, hybridisation gloss | Dropped "just" | Filler adverb | style |
| Frontmatter `glossary_refs` | Added `depth` | The body link was retargeted from `#coverage` to `#depth`, which the fidelity review's note to the controller recommended as more direct. Both anchors exist in `GLOSSARY.md` | fidelity |
| What it is, library prep | Linked first mention to `GLOSSARY.md#library-prep` | `library-prep` was declared in `glossary_refs` but never linked from the body | template |
| Amplicon sequencing, tiling | Linked first mention to `GLOSSARY.md#tiling` | `tiling` was declared in `glossary_refs` but never linked from the body | template |
| Target enrichment, first mention | Linked to `GLOSSARY.md#target-enrichment` | `target-enrichment` was declared in `glossary_refs` but never linked from the body | template |

## Deliberately left unchanged

The five unverifiable rows the project manager ruled on were handled exactly
as ruled. The Twist and IDT sentence, the SRA and ENA metadata sentence, and
the adapter-trimming sentence all keep their original wording as general
domain facts, and the reader fixes for each were added around them rather
than inside them. The two coverage-shape sentences were rewritten as general
statements about shotgun and amplicon libraries.

No structural change was made. The chapter has no Procedure section, so the
fixed Before you start sentences from `CONSISTENCY.md` do not apply, and no
Before you start section was added. Section order, the illustration briefs,
the shot marker, the BED code block, and the fixture references are all
untouched.

No `GLOSSARY.md` entry was added or edited. Every term glossed in this pass
(variant caller, template, chimeric product, locus, BAM, pileup, Inspector,
provenance sidecar, hybridisation, spike-in primer, read pair, coverage
breadth) is glossed inline in the chapter as the campaign rules require. Of
these, BAM, pileup, Inspector, provenance sidecar, and paired-end already
have `GLOSSARY.md` entries, and the glossary is the Bioinformatics
Educator's file.

Three reader rows were left for the Documentation Lead rather than fixed
here, all of them single-reader or already covered. None required more than
the inline gloss now present.

## Screenshot check

The chapter declares one shot, `primer-scheme-picker-built-in`. The image
has not been captured yet, so the caption could not be checked against a
rendered screen. The caption itself is brand-correct as written, one
descriptive sentence with no marketing, and its factual content (a Built-in
section, eight bundled schemes) matches the verified source. Re-check the
caption against the image once the screenshot lands.

## Brand notes

No palette hex, font name, or tagline appears in the chapter body, so
nothing needed correction on those axes. The illustration briefs in
frontmatter name Lungfish Creamsicle, Peach, and Deep Ink, all
palette-correct, and are the illustrator's to own.

## Status

brand_reviewed: false
lead_approved: false
