---
title: Primer Scheme Bundles
chapter_id: appendices/primer-schemes
audience: power-user
prereqs: [01-foundations/03-amplicon-vs-shotgun, 04-alignments/03-primer-trimming]
estimated_reading_min: 28
task: Read what a `.lungfishprimers` bundle holds, list the schemes Lungfish Genome Explorer ships, and build one of your own from a BED file.
tags: [reference, primer-scheme, amplicon, bed, provenance, sars-cov-2]
tools: []
entry_points:
  - "File > Import Center..."
  - "CLI: lungfish-cli primers import"
shots:
  - id: primer-scheme-import-card
    caption: "The Import Center on its Reference Sequences tab, with the Primer Scheme card and its file hint reading .bed (+ optional .fasta/.fa/.fna)."
  - id: primer-scheme-import-sheet
    caption: "The Import Primer Scheme sheet, showing the Files section with its BED and FASTA rows and the Identity section with its four text fields."
  - id: primer-scheme-inspector
    caption: "A primer scheme selected in the sidebar, with the Inspector showing the display name, the primer and amplicon counts, and the reference and equivalent accessions."
illustrations: []
glossary_refs: [amplicon, argv, bed, boolean, canonical-accession, checksum, contig, coverage, equivalent-accession, exit-status, ivar, json, kilobase, manifest, ncbi, pcr, primer, primer-pool, primer-scheme, primer-trim, provenance, provenance-sidecar, shearing, snake-case, tiling]
features_refs: []
fixtures_refs: []
brand_reviewed: true
lead_approved: true
---

<a id="appendix-primer-schemes"></a>

## What it is

An [amplicon](../../GLOSSARY.md#amplicon) protocol copies a genome in numbered pieces rather than [shearing](../../GLOSSARY.md#shearing) it at random, which means breaking the DNA into fragments of no fixed position. The copying reaction is [PCR](../../GLOSSARY.md#pcr), the standard laboratory method for making many copies of one chosen stretch of DNA. Each piece is made by one pair of [primers](../../GLOSSARY.md#primer), short pieces of laboratory-made DNA that bind a chosen spot on the genome and start the copying reaction.

A [primer scheme](../../GLOSSARY.md#primer-scheme) is the list saying where every one of those primers lands on the reference genome. A trimming program needs that list before it can tell primer bases apart from your sample's own bases. [Trimming](../../GLOSSARY.md#primer-trim) here means cutting those primer-derived bases off the ends of aligned reads, and the program Lungfish Genome Explorer (LGE) runs for it is [iVar](../../GLOSSARY.md#ivar).

This appendix is a reference rather than a lesson. Its two prerequisite chapters are [Amplicons and Shotgun Sequencing](../01-foundations/03-amplicon-vs-shotgun.md) and [Primer Trimming an Alignment](../04-alignments/03-primer-trimming.md), and a first-time reader who only wants to pick a shipped scheme can read [Shipped schemes](#shipped-schemes) and stop there. Everything after it matters when you build a scheme of your own.

LGE packages a scheme as a `.lungfishprimers` bundle. A bundle is a folder that macOS shows as a single item. To look inside one, right-click it in Finder and choose **Show Package Contents**, which opens the folder in the ordinary way. The bundle holds the primer coordinates, a [manifest](../../GLOSSARY.md#manifest) naming the protocol and the reference the coordinates were written against, and a [provenance](../../GLOSSARY.md#provenance) record saying where the scheme came from.

Packaging those three things together is the point. The Primer Trim dialog and the Viral Recon wizard, which is LGE's front end for the nf-core SARS-CoV-2 pipeline, both read the bundle rather than a loose coordinate file. So the scheme name shown in the Primer Trim dialog's scheme picker cannot disagree with the counts shown beside it. Neither can disagree with the coordinates the trim actually uses.

Every scheme LGE ships is a SARS-CoV-2 scheme, and this appendix uses SARS-CoV-2 examples for that reason rather than by preference. The format itself carries no assumption about the organism. A human or macaque amplicon panel imports through the same route and produces the same bundle, though LGE ships no non-viral scheme, so you would build that one yourself.

Read the [Shipped schemes](#shipped-schemes) table to find out whether your kit is already covered. If it is not, follow [Building a scheme](#building-a-scheme-from-a-bed-file) to make one from the BED file your kit vendor supplies.

## Shipped schemes

Eight built-in schemes ship inside the application, in a location you never need to browse, since every scheme there already appears in the pickers. A picker is the dropdown menu of schemes, and there are two of them, one in the Primer Trim dialog and one in the Viral Recon wizard.

All eight target SARS-CoV-2 with [canonical accession](../../GLOSSARY.md#canonical-accession) `MN908947.3` and [equivalent accession](../../GLOSSARY.md#equivalent-accession) `NC_045512.2`. An accession is the permanent identifier a public sequence database gives one record. The canonical one is the accession the coordinates were written against, and an equivalent one names the same sequence deposited under a second identifier. Those two are the same genome deposited twice, once by the group that submitted it and once by a curated reference collection.

Read the two number columns against this rule. The primer count should run to roughly twice the amplicon count, because each amplicon needs a primer at each end. Treat anything more than about ten percent above twice as worth a second look, which is where three of these eight sit.

| Display name | Manifest `name` | Primers | Amplicons |
|---|---|---|---|
| ARTIC SARS-CoV-2 V4 | `ARTIC-SARS-CoV-2-V4` | 198 | 99 |
| ARTIC SARS-CoV-2 V4.1 | `ARTIC-SARS-CoV-2-V4.1` | 209 | 99 |
| ARTIC SARS-CoV-2 V5.3.2 | `ARTIC-SARS-CoV-2-V5.3.2` | 192 | 96 |
| ARTIC SARS-CoV-2 V3 | `ARTIC-nCoV-2019-V3` | 218 | 98 |
| Midnight 1200 bp V1 | `Midnight-1200-V1` | 58 | 29 |
| NEB VarSkip Long v1 | `NEB-VarSkip-Long-vsl1` | 50 | 29 |
| NEB VarSkip Short v1 | `NEB-VarSkip-vss1` | 148 | 74 |
| QIAseq Direct SARS-CoV-2 with Booster A | `QIASeqDIRECT-SARS2` | 563 | 223 |

The display name is what a picker shows you. The manifest `name` is the file-safe identifier, which is also the folder name and the key both pickers sort on. This table is ordered the way a picker orders it, by that second column, which is why ARTIC V3 sits fourth rather than first.

Three schemes exceed the roughly-twice rule on purpose. QIAseq Direct's 563 primers over 223 amplicons reflect its Booster A spike-in primers, meaning extra primers added on top of the base design. ARTIC V4.1 carries 209 over 99 and ARTIC V3 carries 218 over 98 for the same reason, which is a handful of extra primers restoring [coverage](../../GLOSSARY.md#coverage), meaning the parts of the genome the amplicons reach, that the original design lost as the virus mutated at the sites where those primers bind.

Whichever scheme your wet-lab protocol actually used is the right one, read off the kit box rather than picked from the menu. Amplicon length is the practical difference between the eight, and it explains why kits differ. Each sequencing platform reads only up to a certain fragment length. The four ARTIC versions and NEB VarSkip Short make short amplicons of a few hundred bases, which suits short-read Illumina sequencing. Midnight 1200 bp V1 and NEB VarSkip Long make amplicons over a [kilobase](../../GLOSSARY.md#kilobase), meaning a thousand bases, which suits the longer reads Oxford Nanopore produces.

## Bundle layout

A bundle the importer wrote has this shape.

```text
DemoPanel.lungfishprimers/
  manifest.json
  primers.bed
  primers.fasta        # only when you supplied a primer FASTA
  attachments/         # only when you supplied documentation files
  PROVENANCE.md
  provenance/
```

The two optional items are written only by the command-line route. The window route supplies neither, so a bundle built in the LGE window carries the four remaining items and nothing more.

Three of those are required, and a bundle missing any one of them refuses to load rather than loading partially. The refusal appears as an error message where you tried to open the scheme, in the dialog or the sidebar rather than in a log you have to go and find. The three messages read "Bundle is missing manifest.json.", "Bundle is missing primers.bed.", and "Bundle is missing PROVENANCE.md.", each naming the missing file exactly. A manifest that is present but unreadable gives a different message naming the parse failure instead.

The reader most likely to hit those messages is someone who assembled a bundle by hand. Hand assembly works, since the format is plain files, but the importer is the supported route and the one this appendix describes. Use it unless you have a reason not to.

`primers.fasta` holds the primer sequences themselves and is optional, because a scheme's coordinates plus the reference genome already say what each primer's sequence is. Attachments are the place for vendor documentation, source spreadsheets, or lab notes that need to travel with the scheme, and they sit under `attachments/` inside the bundle.

`PROVENANCE.md` is the human-readable record and `provenance/` is the machine-readable one. The `provenance/` folder holds one [provenance sidecar](../../GLOSSARY.md#provenance-sidecar) per file the import wrote, named after that file, plus a `bundle.lungfish-provenance.json` covering the run as a whole. The [Provenance](#what-the-provenance-records) section below says what those hold.

Only the shipped schemes are different. Each of the eight holds exactly `manifest.json`, `primers.bed`, and `PROVENANCE.md`. None ships a primer FASTA, and none carries the `provenance/` folder that an imported bundle gets.

## BED expectations

`primers.bed` is a [BED](../../GLOSSARY.md#bed) file, a plain-text table with one region per line and tab characters between the columns. Tabs and spaces look identical on screen, so if your own file was edited by hand, turn on the show-invisibles or show-whitespace view your text editor offers and confirm each gap is one tab character rather than several spaces.

Its coordinates are zero-based and half-open. Zero-based means the first base of a [contig](../../GLOSSARY.md#contig) is position 0 rather than position 1. Half-open means the end coordinate names the first base past the region rather than the last base in it.

```text
MN908947.3	30	54	nCoV-2019_1_LEFT	1	+
MN908947.3	385	410	nCoV-2019_1_RIGHT	1	-
MN908947.3	320	342	nCoV-2019_2_LEFT	2	+
MN908947.3	704	726	nCoV-2019_2_RIGHT	2	-
```

The first row runs from 30 to 54, so the primer covers 54 minus 30, which is 24 bases. Counting the two endpoints inclusively would give 25, and that off-by-one is what the half-open convention removes.

Column 1 is the contig name and has to match the accession or sequence name in the alignment you plan to trim, or resolve through one of the manifest's equivalent accessions. Columns 2 and 3 are the start and end. Column 4 names the primer. Column 5 is the [primer pool](../../GLOSSARY.md#primer-pool), the number of the PCR reaction that primer belongs to, and it must follow your vendor's own pool numbering rather than a scheme of your invention. In a [tiling](../../GLOSSARY.md#tiling) scheme, meaning one whose amplicons overlap end to end to cover a whole region, the pool alternates between 1 and 2 so that neighbouring amplicons are amplified in separate tubes. Two overlapping amplicons in one tube amplify poorly, and both come out at lower yield. Column 6 is the strand, `+` for the forward primer of a pair and `-` for the reverse.

Column 4 is the column the counting depends on. LGE counts every non-empty, non-comment row as one primer. A comment row is one beginning with a `#`, which BED files use for headers and notes. LGE counts amplicons by removing the ending `_LEFT` or `_RIGHT` from each name and then counting the distinct names left over.

It also drops a trailing dash followed by up to three digits once that suffix has been removed, so a spare-primer name such as `QIAseq_221-2_LEFT` folds onto the same amplicon as `QIAseq_221_LEFT` rather than counting twice. The variant tag has to sit before the `_LEFT` or `_RIGHT`, which is where the shipped schemes put it. A name spelled the other way round, as `QIAseq_221_LEFT-1`, counts as its own amplicon and inflates the amplicon count with nothing said. Four digits or more fall outside the rule too, so `QIAseq_221-1000_LEFT` also counts separately.

A scheme whose names follow neither convention still imports. Names such as `panel_fwd_01` and `panel_rev_01`, or a vendor's FWD and REV in place of LEFT and RIGHT, make its amplicon count come out equal to its primer count, which is the sign that the naming did not parse. Renaming the fourth column in a text editor to the `NAME_LEFT` and `NAME_RIGHT` form and importing again is the fix. The Inspector is where you read the two counts back, side by side, and a count you did not expect means the names rather than the coordinates.

The trap worth knowing about is that a scheme built against one reference and applied to reads mapped against another can trim zero primers and raise no visible error at all. Two things guard against it. The manifest's equivalent accessions cover the ordinary case of one genome deposited twice, and the version suffix is ignored during matching, so `NC_045512` matches `NC_045512.2`. Beyond that, the trim rate iVar prints in the Operations panel, which opens with **Operations > Show Operations Panel**, is the only check. A well-matched scheme reaches the high nineties, and [Primer Trimming an Alignment](../04-alignments/03-primer-trimming.md) covers how to read it and what to do when it falls short.

## Building a scheme from a BED file

Both routes below write the same bundle through the same code, but the window route offers fewer options than the command line does, and the paragraph on its limits below says which. The window route alone is complete for work inside a project. The command-line route is the one to use in a script.

### In the LGE window

<!-- SHOT: primer-scheme-import-card -->

Open the project that will own the scheme, following [The Lungfish Genome Explorer Project](../01-foundations/06-the-lungfish-project.md) if you do not have one yet. Choose **File > Import Center...** and click the **Reference Sequences** tab, which is where primer schemes live alongside reference genomes. The card titled **Primer Scheme** sits there, with a file hint reading `.bed (+ optional .fasta/.fa/.fna)`. Those three FASTA extensions name one and the same format, so use whichever your vendor sent. Click the card and a sheet titled **Import Primer Scheme** opens.

<!-- SHOT: primer-scheme-import-sheet -->

Two limits are worth knowing before you fill anything in. The sheet offers no attachments picker, so a bundle built this way never carries an `attachments/` folder even though the format supports one, and only the command line can add attachments. The sheet also writes no description, organism, source URL, or version into the manifest, so an imported bundle's Inspector shows fewer fields than a shipped scheme's does. Those four fields are labels you read and nothing else. Their absence changes no trimming result.

The sheet holds two sections. **Files** has a **BED** row, which is required, and a **FASTA (optional)** row, each with a **Choose…** button. **Identity** has four text fields, reading Name, Display name, Canonical reference accession, and Equivalent accessions. The **Import** button stays disabled until a BED file, a name, and a canonical accession are all set, which are the three the sheet treats as required. Display name and Equivalent accessions are not among them, so both may stay empty.

Fill the Name field with a file-safe identifier, since it becomes the folder name. Any slash in it is replaced with an underscore, and letters, digits, hyphens, and underscores are the safe set, so prefer a name like `MacaqueMHC-v1` and avoid spaces and accented letters. Fill Display name with the label you want to read in the picker, and leave it empty to let the name serve as both. Type the canonical accession exactly as the alignment you will trim spells its contig, and type any equivalent accessions into the last field separated by commas, or leave that field empty, which is the normal case when your reference carries only one accession.

To find how your own alignment spells its contig, select the reference bundle in the sidebar and read the sequence name it shows, which the Inspector repeats for the selected sequence. That name is what the trim matches against, and [Primer Trimming an Alignment](../04-alignments/03-primer-trimming.md) describes reading it from the alignment's own header instead. A filled-in set for the Midnight scheme reads `Midnight-1200-V1`, `Midnight 1200 bp V1`, `MN908947.3`, and `NC_045512.2`. Click **Import** and LGE writes `Primer Schemes/<name>.lungfishprimers` into the project.

The window has no control for the reference-mismatch trap described above. When your alignment's contig name matches neither the canonical accession nor any equivalent one, the only override is `lungfish-cli bam primer-trim --target-reference` on the command line, documented in [Primer Trimming an Alignment](../04-alignments/03-primer-trimming.md). The window route's remedy is to type the alignment's own contig name into the canonical accession field when you import, which avoids the mismatch rather than overriding it.

<!-- SHOT: primer-scheme-inspector -->

The new scheme appears in the sidebar under **Primer Schemes**, listed without its `.lungfishprimers` extension. Click it and the Inspector shows the display name, the description when the manifest carries one, the primer and amplicon counts side by side, the reference accession and any equivalents, then the organism, source, and version when those are present, and a list of attachments at the foot when there are any. Inspecting is read-only. There is no editor and no command-line inspector, so changing a field means importing the scheme again under a new name, which is the route to prefer, or opening the bundle with **Show Package Contents** and editing `manifest.json` in a text editor.

## Manifest fields

`manifest.json` is a [JSON](../../GLOSSARY.md#json) file, meaning plain text holding named fields in a shape a program reads directly. Its keys are [snake_case](../../GLOSSARY.md#snake-case), meaning lowercase words joined by underscores.

| Field | Meaning |
|---|---|
| `schema_version` | Which version of the bundle file format this bundle follows, currently `1`. |
| `name` | File-safe bundle name, matching the folder name without its extension. |
| `display_name` | Label shown in pickers and at the top of the Inspector. |
| `description` | Free-text description of the scheme. |
| `organism` | Target organism name. |
| `reference_accessions` | Array of accession objects, described below. |
| `primer_count` | Number of non-empty, non-comment BED rows. |
| `amplicon_count` | Number of distinct amplicon names inferred from BED column 4. |
| `source` | Where the scheme came from. All eight shipped schemes use `built-in`, and the importer writes `imported`. |
| `version` | Scheme version string. |
| `created` | Timestamp written when the bundle was authored. |
| `imported` | Timestamp written when an existing scheme was imported into a project, which is a different event from `created`. |
| `attachments` | Array of `{path, description}` objects naming the files copied under `attachments/`. |
| `source_url` | Link to the scheme's upstream source. |

Only `schema_version`, `name`, `display_name`, `reference_accessions`, `primer_count`, and `amplicon_count` are always present. The rest may be absent, and the part of LGE that reads a bundle accepts a manifest without them, which is why the importer writes a shorter manifest than a shipped scheme carries. The Inspector draws only the fields a given bundle has. The order the keys appear in the file carries no meaning, so a manifest whose keys read alphabetically and this table's order are equally correct.

`reference_accessions` is an array of objects rather than a flat list of strings. Each object carries an `accession` and up to two [boolean](../../GLOSSARY.md#boolean) role flags, meaning values that are either true or false.

```json
"reference_accessions": [
  { "accession": "MN908947.3", "canonical": true },
  { "accession": "NC_045512.2", "equivalent": true }
]
```

In that example the square brackets hold the list, each pair of curly braces holds one accession record, and the quoted words on the left of each colon are field names while the values on the right are the content. The canonical accession is the one the BED coordinates are defined against. The equivalent accessions let LGE match an alignment whose reference names the same sequence differently.

Both flags default to false when a hand-written manifest leaves them out, so a list where nothing is marked canonical is still accepted, and LGE then treats the first entry as canonical. Nothing warns you when that happens. A manifest listing two genomes with the flags omitted can therefore have your reads trimmed against whichever one happens to be first, which may be the wrong genome, and the only sign is a low trim rate in the Operations panel. Mark the flags rather than relying on the fallback.

## On the command line

This section is optional. If you do your work in the LGE window, everything above is complete without it, apart from attachments and the trim-time contig override, which only the command line offers. It is here for readers who want to script a run or repeat one on a server. The whole procedure runs headless, meaning with no window at all, by typing commands into the Terminal application.

Two things only the command line can do. It can add attachments to a bundle, and it can override the contig name the scheme is matched against at trim time. [CLI Reference](cli-reference.md) covers opening Terminal and putting `lungfish-cli` on your machine.

```bash
lungfish-cli primers import \
  --bed midnight.bed \
  --fasta primers.fasta \
  --output DemoPanel \
  --project "Demo.lungfish" \
  --reference-accession MN908947.3 \
  --equivalent-accession NC_045512.2 \
  --display-name "Demo Amplicon Panel" \
  --attachment kit-notes.txt
```

The backslash at the end of each line joins that line to the next, so the block above is one command rather than nine. Type it as shown, or leave the backslashes out and put the whole thing on one line.

That run printed one line and exited 0, meaning it succeeded. An [exit status](../../GLOSSARY.md#exit-status) of 0 is the number a command hands back when nothing went wrong, and any other number means it stopped.

```text
Primer scheme bundle written to /.../Demo.lungfish/Primer Schemes/DemoPanel.lungfishprimers
```

Only `--bed` and `--output` are required. `--fasta` copies a FASTA of the primer sequences themselves into the bundle rather than a reference genome, and your kit vendor supplies that file when it exists, so leave the flag off when you do not have one. `--reference-accession` names the canonical accession, and leaving it off makes the importer take the value from the BED file's first column instead, which is right whenever the BED already names the reference you mapped to. `--display-name` sets the label shown in pickers and defaults to the output filename's stem, meaning the filename without its extension. `--equivalent-accession` and `--attachment` may each be repeated as often as you need them.

`--project` decides where a relative `--output` lands. With a project given, the bundle is written under that project's `Primer Schemes/` folder, which is the folder LGE's own pickers read. Without one, a relative path resolves from the folder the terminal is currently using. An absolute `--output` path is honoured as given either way. The `.lungfishprimers` extension is appended for you when you leave it off, which is why `--output DemoPanel` above produced `DemoPanel.lungfishprimers`.

Running the same import a second time into the same project does not overwrite the first. It exits 1 with the following.

```text
Error: A primer scheme bundle already exists at /.../Demo.lungfish/Primer Schemes/DemoPanel.lungfishprimers.
```

Delete the old bundle or pick a different `--output` name. That refusal is what makes the command safe to leave in a setup script, because a rerun cannot quietly replace a scheme other results were trimmed against.

A second import shows the defaults at work. Running the command with only `--bed midnight.bed` and `--output MinimalPanel` wrote this manifest, with the accession taken from `midnight.bed`'s first column and the display name taken from the output stem.

```json
{
  "amplicon_count" : 29,
  "created" : "2026-09-07T14:10:05Z",
  "display_name" : "MinimalPanel",
  "imported" : "2026-09-07T14:10:05Z",
  "name" : "MinimalPanel",
  "primer_count" : 58,
  "reference_accessions" : [
    { "accession" : "MN908947.3", "canonical" : true, "equivalent" : false }
  ],
  "schema_version" : 1,
  "source" : "imported"
}
```

That BED is the Midnight 1200 bp V1 scheme's own, which is why the counts read 58 and 29. The two timestamps are written in UTC, which the `T` between date and time and the closing `Z` both signal. They read identically here because the importer takes one clock reading when the run starts and another when it writes the manifest, and both land in the same second on a fresh import.

`lungfish-cli primers` offers `import` and nothing else, so there is no subcommand that lists or prints a scheme. Reading a bundle from the command line means reading its `manifest.json` directly, which is why that file is plain JSON rather than anything packed.

### Verifying a bundle from the terminal

Two checks in this appendix need a terminal, and both are here rather than in the procedure because the window offers no equivalent.

To confirm the bundle in front of you is the one a published result was trimmed against, read the `sha256` value for `primers.bed` out of `provenance/primers.bed.lungfish-provenance.json` in each copy and compare the two strings. Run `shasum -a 256 <path>/primers.bed` on a bundle whose sidecar you doubt and check the output against the recorded value. Identical strings prove the two copies are identical, and differing strings prove one was edited. Nothing in LGE compares them for you.

To confirm two BED files match after regenerating a bundle, run `diff <old>/primers.bed <new>/primers.bed`. Silence means the files are identical, and any printed lines are the differences.

## What the provenance records

`PROVENANCE.md` is the file you read yourself. The importer writes nine lines below the `# PROVENANCE` heading, naming the workflow, the tool version, the exact command as typed, the start timestamp, the BED source path, the FASTA source path or the words "not provided", the output bundle path, the reference accession, and the exit status. The demo import above produced this, with the long paths and the command line shortened here.

```text
# PROVENANCE

Workflow: lungfish primers import
Version: lungfish-cli 2026.9.13
Command: /.../lungfish-cli primers import --bed /.../midnight.bed ...
Started: 2026-09-07T14:09:52Z
BED source: /.../midnight.bed
FASTA source: /.../panel-primers.fasta
Output bundle: /.../Demo.lungfish/Primer Schemes/DemoPanel.lungfishprimers
Reference accession: MN908947.3
Exit status: 0
```

A window import produces the same nine lines with two differences. The FASTA source line reads "not provided" when you left that row empty, and the command line records the import as the app ran it rather than as you typed it.

A shipped scheme's `PROVENANCE.md` is longer and differently shaped, because a different program wrote it. It is a set of Markdown tables recording the build script and its version, the wall time, the resolved value of every option, a Reference Verification table giving a SHA-256 [checksum](../../GLOSSARY.md#checksum) of each declared accession's sequence as fetched from [NCBI](../../GLOSSARY.md#ncbi), the American public sequence database, and the computed primer and amplicon counts. It closes with checksums and byte sizes for the input BED and every output file, then a section naming the upstream source and its licence. A checksum is a short string computed from a file's exact bytes. Identical checksums on the canonical and equivalent rows of the Reference Verification table are the evidence that the two accessions really are the same sequence rather than two similar ones.

The `provenance/` folder is the machine-readable half and exists only on bundles the importer wrote. `bundle.lungfish-provenance.json` describes the whole run, and it records more than the Markdown file does. It holds the [argv](../../GLOSSARY.md#argv) as an array, meaning the command split into its separate words, and a durable replay command, which is that same command rewritten so it runs again later without depending on where you were standing. It holds the resolved options alongside their defaults so you can see which values you actually set, a file list giving a SHA-256 checksum and a byte size for every input and every output, the runtime identity of the machine, its exit status, and the wall time in seconds. The runtime identity records the host name and the operating system version, which is worth knowing before you share a bundle outside your group. Beside it sit one small sidecar per written file, named for that file, so `primers.bed.lungfish-provenance.json` covers the BED alone.

## Keeping a scheme reproducible

This section is for readers whose projects use version control, meaning a system such as Git that records every change to a set of files. If you do not use one, the sections above are complete without this one.

A scripted project has two ways to keep a scheme available, and the choice is between storage and review. Committing the finished `.lungfishprimers` folder, meaning recording it in the repository as it stands, keeps the exact bytes that produced your results, checksums included, and costs a few kilobytes. Regenerating it from the original BED with `lungfish-cli primers import` during project setup keeps the repository smaller and makes the source BED the single thing under review.

Regenerating has one catch worth planning around, and it is harmless once you know it. `created` and `imported` are written from the clock at import time, so a regenerated bundle differs from the committed one in those two fields even when every coordinate matches. A byte-for-byte comparison of `manifest.json` will therefore show a difference that means nothing. Compare `primers.bed` instead, which the importer copies unchanged, and whose checksum in the provenance sidecar is therefore stable across reruns. [Verifying a bundle from the terminal](#verifying-a-bundle-from-the-terminal) above gives the command.

## Next

Go to [Primer Trimming an Alignment](../04-alignments/03-primer-trimming.md) to apply a scheme to a mapped alignment, or to [The Viral Recon Wizard](../04-alignments/05-viral-recon-wizard.md) to run one through the whole SARS-CoV-2 pipeline.
