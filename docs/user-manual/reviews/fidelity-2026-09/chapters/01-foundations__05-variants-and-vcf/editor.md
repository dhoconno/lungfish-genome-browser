# Editor pass: 01-foundations/05-variants-and-vcf

Date: 2026-09-06
Role: brand-copy-editor
Inputs: fidelity.md, readers.md, CONSISTENCY.md, STYLE.md chapter template.

brand_reviewed: false
lead_approved: false

## Changes applied

| Location | Change | Reason | Source |
|---|---|---|---|
| Frontmatter `glossary_refs` | Added `strand-bias` and `amplicon` | Both are linked from the body and neither was listed | fidelity |
| Frontmatter, `variants-pass-chip-and-tokens` caption | "The filter chips above the Variants tab" became "The filter chips revealed by the Presets button" | The chips sit behind a Presets disclosure button | fidelity |
| What it is, variant-caller sentence | "walks the reference position by position" became "moves along the reference one position at a time"; added a gloss of pileup as the stack of reads covering that position, and a gloss of thresholds as plain counts and fractions | Pileup was linked but not glossed in place, thresholds were named before anything was measured, and "walks" read ambiguously | readers |
| What it is, caveat paragraph | Kept the caveat's own logic intact and appended a plain-words gloss of `AF` and `GT` | Both fields were used as examples before either was introduced | readers |
| Why you would do this, downstream steps | Glossed consensus building and lineage assignment in half a sentence each | Both terms were new, unglossed, and unlinked | readers |
| Why you would do this, fixture sentence | Explained the 2x250 notation, and replaced "characterised in detail" with a statement that HG002 is a human reference sample whose true variants are already established | Readers could not tell what HG002 is or what the phrase meant | readers |
| Before you start, opening | Replaced the opening with the two fixed sentences, adjusted for this chapter's fixture, and said where the demo project comes from | Required opening for every procedure chapter, and readers did not know the demo project's origin | consistency, readers |
| Before you start, plugin pack | Moved "reading a track needs no pack" ahead of the calling requirement | Readers could not tell whether the chapter needed a pack until a later sentence resolved it | readers |
| Before you start, bundle | Glossed reference bundle at first use, with its `.lungfishref` extension | Bundle was used before it was defined | readers, consistency |
| Before you start, fixture files | "rebuilt by `regenerate.sh` rather than committed, because they are larger than the per-file cap" became "committed alongside the rest of the fixture, and `regenerate.sh` reproduces them" | False. Both caller VCFs and both `.tbi` indexes are committed, and the files are 46 KB and 16 KB | fidelity |
| What a VCF file looks like, header paragraph | Moved the contig gloss out of the middle of the enumeration into its own sentence | Contig was unglossed, and the inline gloss broke the list | readers, style |
| What a VCF file looks like, header counts | 29 became 30 for bcftools, 18 became 19 for LoFreq | False counts | fidelity |
| What a VCF file looks like, bgzip | Split into two sentences and said why random access matters, with a worked example | The hardest sentence in the chapter for all four readers | readers |
| What a VCF file looks like, CSI | Gave the roughly 512-megabase threshold and said no human chromosome reaches it | No length was given, so readers could not judge their own files | readers |
| What a VCF file looks like, LGE storage | Rewrote the whole claim. The track is stored under `variants/` as a bgzip-compressed VCF with a tabix index and a `.db` sidecar, with imported BCF plus CSI named as a read-only case that cannot yet be queried by region | False. `BundleVariantTrackAttachmentService.swift:71-74` writes `.vcf.gz`, `.vcf.gz.tbi`, and `.db`. The BCF layout exists only in an aspirational doc comment | fidelity |
| What a VCF file looks like, SQLite sidecar | Described it as a small database LGE writes on its own that the reader never creates or maintains | SQLite and sidecar were both unexplained, and readers could not tell whether they had to make it | readers |
| What a VCF file looks like, export path | "LGE writes one from the stored BCF" became "LGE copies or filters the stored one" | Follows from the storage correction. The stored payload is already a VCF | fidelity |
| What a VCF file looks like | Split the storage paragraph in two | The paragraph ran past a readable length after the correction | style |
| The eight standard columns, indel example | Marked the leading `C` as the anchor base and gave the T counts as five against six | Readers counted the T's repeatedly and still could not see the change | readers |
| The eight standard columns, caller table | Added a sentence saying the table only shows that callers differ and that iVar's keys are covered elsewhere | The nine iVar keys sat as unexplained noise | readers |
| The eight standard columns, codon merge | Added a clause saying a codon decides one amino acid, so changes inside one are reported together | Readers knew what a codon is but not why a caller would merge | readers |
| The eight standard columns, genotype | "iVar lane" became "iVar pipeline", and the one-genome-copy case now names a virus such as SARS-CoV-2 or a bacterium | Lane was unexplained, and the ploidy note gave no concrete case in an all-human chapter | readers |
| Walking through one row, INFO | Said plainly that the unexplained keys are caller internals a reader may ignore | Nine keys were never explained and readers did not know whether to try | readers |
| Walking through one row, PL | Said explicitly that PL is a penalty, that the smallest number wins, and gave the genotype order | Readers could not reconcile "lower is better" against QUAL's "higher is better" | readers |
| Walking through one row, AD | Added a clause linking `DP4` and `AD` and explaining why caller totals differ, placed after `AD` is introduced | Readers could not tell whether the two count the same evidence, and the cross-caller difference undercut trust | readers |
| Walking through one row, QUAL | Said the two callers scale the Phred number differently, so QUAL is comparable only within one file | The claim that the scales differ read as a contradiction of the Phred explanation | readers |
| Walking through one row, SB | Gave the direction and a rough concerning value of about 60 | Readers had no scale for SB, so no non-zero value was judgeable | readers |
| Walking through one row, AF | Said read counts scatter around 0.5, so 0.57 is inside the ordinary spread | Readers expected exactly 0.5 for a heterozygous call | readers |
| Walking through one row, benchmark depth | Said up front that the benchmark pools many runs, so 1,247 is not comparable to 63 | One reader read it as a fixture error | readers |
| Walking through one row | Split the LoFreq walkthrough into three paragraphs | The paragraph ran too long after the additions | style |
| FILTER table, `min_indelqual_20` | "at a fixed threshold of 20" became "The header of this file declares the threshold as 20" | Unverifiable. Nothing in the source settles whether 20 is fixed by LoFreq or particular to this run | fidelity |
| FILTER table, `sb_fdr` | Explained that testing many positions produces false alarms by chance, so the bar is raised | The phrase taught nothing to readers who had not met multiple testing | readers |
| FILTER, `ft` | Named the hypothesis on trial so the above-0.05 direction makes sense | Readers read the direction as backwards against the usual significance cutoff | readers |
| FILTER, amplicon | Glossed amplicon as sequencing targeted stretches of PCR product, and linked the glossary entry | Amplicon was unglossed and readers could not tell whether their own data qualified | readers |
| Where a VCF comes from, primer trim | Glossed primer trimming and pointed at the chapter that covers it | First mention of primers in the chapter, unexplained | readers |
| Where a VCF comes from, row counts | Explained that a few positions carry more than one row | Readers stalled on 1,056 rows against 1,053 positions thinking they had erred | readers |
| Where a VCF comes from, hap.py | Said it is a separate program LGE does not ship | Readers could not tell whether it was part of LGE | readers |
| Where a VCF comes from, Nanopore | Added a clause saying Nanopore is a long-read platform with a different error pattern | Readers could not tell why a read type needs its own caller | readers |
| Reading a variant track, first paragraph | Glossed viewport and table drawer before the first click | Bundle, viewport, and drawer arrived together and readers could not perform the first click | readers |
| Reading a variant track, genome track | "draws each variant as a tick at its `POS`" became "summarises where in the reference the calls fall" | Unverifiable. The renderer draws a summary bar and genotype rows, and the tick claim is a visual property source cannot settle | fidelity |
| Reading a variant track, columns | Replaced "one column per VCF field, plus derived columns ... the gene name from any attached GFF3 annotation" with the fixed twelve-column set plus promoted INFO keys, and stated that Gene comes from INFO | False. The column set is fixed and Gene is a promoted INFO key, not an annotation-track lookup | fidelity |
| Reading a variant track, Consequence | Gave `missense_variant` and `synonymous_variant` as example values | Readers did not know what values the derived column can take | readers |
| Reading a variant track, chips | "Filter chips sit above the table" became a **Presets** button that reveals them, with its hiding conditions | False. The chips sit behind a disclosure button that hides at minimal toolbar density and when no INFO keys are present | fidelity |
| Reading a variant track, chip list | Added **Bookmarked** and the three within-sample frequency chips as a second paragraph, noting they appear only for a haploid organism with genotype data | False as a complete enumeration. Fourteen tokens exist and four appearing ones were undocumented | fidelity |
| Reading a variant track, impact chips | Named the HIGH, MODERATE, LOW, MODIFIER levels and said SnpEff or VEP writes them | Readers did not know what makes a change high or moderate impact | readers |
| Reading a variant track, Rare chip | Said it reads whichever allele-frequency key the file declares, and what that means on a population database against a single-sample file | Rare gave no population denominator | readers |
| Reading a variant track, ClinVar | Glossed ClinVar as a public database of variants curated for clinical significance | ClinVar was never glossed | readers |
| Reading a variant track, Match All | Said Match All is the only option and there is no Match Any | Readers could not tell whether it was fixed behaviour or a setting | readers |
| Reading a variant track, categories | Added a worked two-rule example query | The seven categories arrived in one dense sentence and readers retained none | readers |
| Reading a variant track, filtering | "stay in the underlying BCF" became "stay in the underlying track" | False, following from the storage correction | fidelity |
| Reading a variant track | Split the column paragraph and the Query Builder paragraph | Both ran past a readable length after the additions | style |
| What good looks like, depth | Said human whole-genome work aims at a mean of about 30, and that viral and bacterial work aims far higher, pointing at the viral chapters | Readers could not judge 44.7, and the "in a human sample" qualifier implied other thresholds without giving any | readers |
| What good looks like, provenance | "carries all of it", meaning thresholds, became the caller, the command line, and the alignment | Unverifiable. The sidecar carries those three. Whether the Inspector surfaces the thresholds was not settled | fidelity |
| What good looks like, QUAL | Described a healthy distribution and two unhealthy ones | Readers did not know what to look for once sorted | readers |
| On the command line, opening | Dropped "nothing in the chapter depends on it", said instead that the files are committed and the dialog does the same work | Readers found it contradictory that a skippable section produced the chapter's own quoted files | readers |
| On the command line, alignment track | "a bundle-owned alignment track" became "an alignment track stored inside a bundle" | The compound term was new and unglossed | readers |
| On the command line, track name | Said where a name like `hg002-minimap2` appears on screen | Readers could not tell where the name comes from | readers |
| On the command line, subcommands | Added `variants phase` and split the three subcommands into their own sentences | False as a complete list. The group holds four subcommands | fidelity |
| On the command line, versions | Rewrote to say bcftools 1.24 is recorded in the sidecar and LoFreq 2.1.5 had to be read from the tool by hand, because the binary rejects `--version` | False. The LoFreq sidecar records an error string, not 2.1.5 | fidelity |
| `GLOSSARY.md` **BCF** | Rewrote to say LGE reads an imported BCF with CSI but stores what it writes as bgzip VCF plus tabix plus SQLite sidecar under `variants/` | The entry repeated the chapter's storage error | fidelity |
| `GLOSSARY.md` **Smart-filter token** | "chips above the Variants tab" became "chips revealed by the Presets button above the Variants tab" | The entry repeated the chip-placement error | fidelity |
| `GLOSSARY.md` **Genotype** | "Lungfish's iVar lane" became "The Lungfish Genome Explorer iVar pipeline" | "Lungfish" alone names the collaborative, not the app, and "lane" was flagged as unexplained jargon | consistency, readers |

Entries stayed in their existing alphabetical positions. No entry was added or removed.

## Deliberately left unchanged

Every fidelity row marked true was left alone, including the two the fidelity review flagged as
acceptable paraphrase, which are the shortened "Ignore strand bias" label and iVar's `bq`
threshold of 20 stated as a flat fact where it is a user-settable default that ships at 20.

The Inspector's twenty-key `INFO` display cap, which the fidelity review noted the chapter does
not mention, was left out. No reader raised it and the review did not call the omission false.

The three `<!-- SHOT -->` markers, the three illustration briefs, the section order, and the
`parameters_refs: []` declaration were all left as they stand. The fidelity review confirmed each,
and structure is not this role's to change.

## Observations for the Documentation Lead

The `GLOSSARY.md` **CSI** entry defines the format only for BAM, against a BAI limit. This
chapter links `#csi` for the VCF-plus-tabix case, so the anchor resolves to an entry that does
not cover the use the reader arrived from. That is a glossary scope question rather than an
error, the fidelity review did not raise it, and it is left for the Lead.
