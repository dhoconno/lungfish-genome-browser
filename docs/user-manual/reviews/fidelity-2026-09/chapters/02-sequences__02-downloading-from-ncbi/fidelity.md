# Fidelity review: 02-sequences/02-downloading-from-ncbi

Chapter reviewed: `docs/user-manual/chapters/02-sequences/02-downloading-from-ncbi.md`

Ground truth, in campaign order, was the Swift source under `Sources/`, the
`cli-help/fetch.txt` dump, `docs/user-manual/parameters.yaml` (`fetch.ncbi`,
`fetch.pathoplexus`, and `fetch.sra` for the SRA section), the reality map at
`ground-truth/02-sequences.md`, `CONSISTENCY.md`, the human-mito fixture
README, and `GLOSSARY.md`. Every number the chapter quotes from the live fetch
was recomputed from the author's scratch output at
`scratchpad/ncbi-fetch/manual-check.lungfish/Downloads/`, which holds the
fetched `NC_012920.1.gb` and its sidecar. The `.gb` was re-checksummed, its
byte count re-measured, and its FEATURES table re-counted by feature key.

The chapter has absorbed the DRIFT Part A corrections. Both false claims DRIFT
recorded are fixed (the feature-type filter, and the `imported_annotations.gff3`
track name). All four changed claims are corrected, including the mirror clause
DRIFT told the author to drop. The four DRIFT unverifiables are now settled from
source: the ABS consent gate, the OPEN-only filter, the SRA ENA-mirror ordering,
and the `fetch genome` accession substitution.

Eight new findings are recorded that DRIFT never checked. The two that matter
are row 44, the Pathoplexus Settings coverage gap (two registry settings and two
on-screen filters are undocumented, and the chapter's own "nine filters" count
contradicts the ten it would have to describe), and row 22, the label mismatch
between the pane's on-screen title "GenBank & Genomes" and the chapter's
"GenBank and Genomes".

## Claims

| # | Claim | Verdict | Evidence | Correction |
|---|---|---|---|---|
| 1 | "LGE reaches NCBI through **Tools > Search Online Databases > Search NCBI...**" | true | `MainMenu.swift:740-747`, submenu titled "Search Online Databases", item titled "Search NCBI..." | |
| 2 | "which opens a database search dialog on its GenBank and Genomes pane" | true | `DatabaseSearchDialogState.swift:29` returns the pane title; the NCBI item routes to `GenBankGenomesSearchPane` | See row 22 on the ampersand |
| 3 | "What lands is a [reference bundle](...), a folder carrying the `.lungfishref` extension" | true | `GenBankBundleDownloadViewModel.swift:67-73`, `BundleBuildHelpers.makeUniqueBundleURL` with `genome/` and `annotations/` subfolders | |
| 4 | "Leave the Include GFF3 Annotations checkbox on and LGE downloads that table too, converting it into a track attached to the bundle." | true | `GenBankGenomesSearchPane.swift:7`, `:35-38`; `GenBankBundleDownloadViewModel.swift:118-130` fetches GFF3 when the flag is set | |
| 5 | "The same dialog reaches two other collections from its sidebar. SRA holds raw sequencing reads ... and Pathoplexus holds pathogen submissions" | true | `DatabaseSearchDialogState.swift:29-33`, three destinations GenBank & Genomes, SRA Runs, Pathoplexus | |
| 6 | "This chapter downloads the human mitochondrial genome, `NC_012920.1`." | true | Fixture README, "Genome" section, `NC_012920.1`, Homo sapiens mitochondrion | |
| 7 | "The human one is 16,569 bases long" | true | Scratch fetch `NC_012920.1.gb` LOCUS line reads `16569 bp`; fixture README agrees | |
| 8 | "The GenBank version of the record carries 77 features" | true | Recounted from the scratch `.gb` FEATURES block, 77 feature keys total | |
| 9 | "among them 13 protein-coding sequences, 22 transfer RNA genes, and 2 ribosomal RNA genes" | true | Recount by key: 13 `CDS`, 22 `tRNA`, 2 `rRNA` (also 37 `gene`, 1 `source`, 1 `misc_feature`, 1 `D-loop`) | |
| 10 | "That record is the revised Cambridge Reference Sequence" | true | Fixture README, "Genome" and "Sources" sections both name the rCRS | |
| 11 | "The record's accession begins with `NC_`, which marks it as [RefSeq](...)" | true | `GLOSSARY.md:279`, RefSeq entry names the `NC_` prefix | |
| 12 | "choose **File > New Project** (Cmd-N), or click Create Project on the Welcome window" | unverifiable | Not checked in this pass. The chapter owns the NCBI dialog, and the project-creation route is the Foundations chapter's claim | Confirm against `MainMenu.swift` File menu and the Welcome window controller |
| 13 | "You can read the fixture's notes in the manual's fixtures on GitHub at https://github.com/dhoconno/lungfish-genome-explorer/tree/main/docs/user-manual/fixtures/human-mito" | true | `docs/user-manual/fixtures/human-mito/README.md` exists at that repo path | |
| 14 | Step 1, "Leave **Mode** on Nucleotide and leave **Include GFF3 Annotations** checked, which are both the defaults." | true | `DatabaseBrowserViewController.swift:731` `ncbiSearchType = .nucleotide`, `:773` `includeGFF3Annotations = true`; registry `fetch.ncbi` Mode default Nucleotide, Include GFF3 Annotations default on | |
| 15 | Step 2, "The Advanced Search Filters panel below the field stays collapsed until you click Show" | true | `DatabaseBrowserPane.swift:193` panel heading, `:221` `Button(viewModel.isAdvancedExpanded ? "Hide" : "Show")`, `:731` `isAdvancedExpanded = false` default at `DatabaseBrowserViewController.swift:746` | |
| 16 | Step 3, "The primary button changes from Search to Download Selected." | true | `DatabaseSearchDialogState.swift:112-114`, `selectedRecords.isEmpty ? "Search" : "Download Selected"` | |
| 17 | Step 3, "Ticking more than fifty records asks you to confirm before it starts." | true | `DatabaseBrowserViewController.swift:2393-2394`, `if recordsToDownload.count > 50` presents an alert with Download All and Cancel | |
| 18 | Step 4, "LGE fetches the record, fetches its annotations, and assembles the `.lungfishref` bundle in one action, reporting each stage in the Operations Panel." | changed | The stage sequence is right (`GenBankBundleDownloadViewModel.swift:44-224`, progress handler reports each). But progress goes to `DownloadCenter`, not `OperationCenter` (`DatabaseBrowserViewController.swift:2615-2621`, `:2874-2877`), and `CONSISTENCY.md` reserves "Operations Panel" for the `Operations > Show Operations Panel` surface | Name the surface the download actually reports to, or drop the clause |
| 19 | Step 5, "Find the finished bundle under `Downloads/` in the sidebar" | true | `AppDelegate+Classification.swift:2484-2487`, the destination is `projectURL.appendingPathComponent("Downloads")`. This corrects the reality map's row 44, which said `Reference Sequences/` | |
| 20 | "Turn **Include GFF3 Annotations** off before you search and the bundle holds the bases alone" | changed | Turning it off skips the GFF3 fetch (`:118`), but `:132` then falls through to the GenBank FEATURES path whenever the parsed record carries annotations, so an unticked box still produces a `NCBI GenBank Annotations` track on this record | Say the box only skips the GFF3 fetch, and that a record with a FEATURES table still yields a GenBank-derived track |
| 21 | Settings lead-in, "The first group is the GenBank and Genomes pane ... The second group, from **Organism** onwards, is the Pathoplexus pane" | changed | The split is wrong at the seam. The first Pathoplexus setting in registry order is Organism, but the chapter's first **Organism.** paragraph documents the NCBI nucleotide filter (`DatabaseBrowserPane.swift:405`, `cli_flag: --organism`), and a second **Organism.** paragraph at line 129 documents the Pathoplexus chips. Fifteen paragraphs sit between them, all NCBI | Say the second group starts at the second **Organism.** paragraph, or retitle one of the two |
| 22 | "the GenBank and Genomes pane" (throughout) | changed | The pane title on screen is `"GenBank & Genomes"` with an ampersand (`GenBankGenomesSearchPane.swift:19`, `DatabaseSearchDialogState.swift:29`) | Use "GenBank & Genomes" so the reader can match the label |
| 23 | **Mode.** "The default is Nucleotide" and the three collections | true | Registry `fetch.ncbi` Mode, default Nucleotide, allowed Nucleotide, Genome, Virus; `GenBankGenomesSearchPane.swift:6` `modeTitles = ["Nucleotide", "Genome", "Virus"]` | |
| 24 | **Mode.** "On the command line this is `--db`." | true | Registry `cli_flag: --db`; `fetch.txt:37` and `:75` | |
| 25 | **RefSeq Only.** "Filters a nucleotide search down to RefSeq records" | changed | The toggle is shown in both Nucleotide and Virus modes (`GenBankGenomesSearchPane.swift:30`) and is passed to both searches (`DatabaseBrowserViewController.swift:1655` nucleotide, `:1735` virus). The registry says "Restricts results to RefSeq records" with no mode qualifier, and `DatabaseBrowserPane.swift:301` tells virus users to use it | Drop "nucleotide", matching the registry wording |
| 26 | **RefSeq Only.** "The default is off ... This setting has no command-line flag." | true | `DatabaseBrowserViewController.swift:770` `refseqOnly: Bool = false`; registry `cli_flag: null` | |
| 27 | **Include GFF3 Annotations.** "The default is on ... the nearest equivalent is `--fasta-only` on `fetch genome`" | true | `DatabaseBrowserViewController.swift:773`; registry `cli_flag: --fasta-only`; `fetch.txt:335-336` "Download only the FASTA sequence (no annotations, no bundle)" | |
| 28 | **(search scope).** "The default is All Fields ... Narrow it to Accession" | true | `DatabaseBrowserViewController.swift:427-433`, `case all = "All Fields"` first, `:745` `searchScope = .all`; registry default All Fields | |
| 29 | **Organism.** (NCBI) "The default is empty ... On the command line this is `--organism` on `fetch search`." | true | `DatabaseBrowserPane.swift:405` `filterField("Organism")`; `DatabaseBrowserViewController.swift:752` `organismFilter = ""`; `fetch.txt:78` `--organism` | |
| 30 | **Location.** "The default is empty ... no command-line flag." | true | `DatabaseBrowserPane.swift:411`; `DatabaseBrowserViewController.swift:755`; registry `cli_flag: null` | |
| 31 | **Gene.**, **Author.**, **Journal.** paragraphs, labels and empty defaults | true | `DatabaseBrowserPane.swift:419`, `:425`, `:431`; `DatabaseBrowserViewController.swift:758`, `:761`, `:764`; registry all default empty, `cli_flag: null` | |
| 32 | **Molecule Type.** "The default is Any ... Set it to mRNA ... or to Genomic DNA" | true | `DatabaseBrowserPane.swift:439`; `DatabaseBrowserViewController.swift:776` `moleculeType = .any`; registry allowed includes Genomic DNA and mRNA | |
| 33 | **Sequence Length.** "Both sides start empty ... measured in bases" | true | `DatabaseBrowserPane.swift:449` with a `bp` suffix label; `DatabaseBrowserViewController.swift:767-768` both `""` | |
| 34 | **Publication Date.** "Both sides start empty" | true | `DatabaseBrowserPane.swift:466`; `DatabaseBrowserViewController.swift:779-782` both `""` | |
| 35 | **Sequence Properties.** "among Has CDS, Has Gene, Has Source, Has tRNA, and Has rRNA, and the checked properties combine so a record must have all of them" | true | `DatabaseBrowserPane.swift:480-500` iterates `SequencePropertyFilter.allCases`; `DatabaseBrowserViewController.swift:785` `propertyFilters: Set = []`; registry allowed lists exactly those five and states they combine | |
| 36 | **Host.**, **Geographic Location.**, **Completeness.**, **Released Since.**, **Annotated Only.** "In Virus mode ..." with their defaults | true | `DatabaseBrowserPane.swift:264-299` is `virusFiltersGrid`, reached only when `ncbiSearchType == .virus` (`:257`); labels are verbatim; registry defaults empty, empty, Any, empty, off | |
| 37 | **Organism.** (Pathoplexus) "the chip row above the query field ... The default is Mpox virus" | true | `PathoplexusSearchPane.swift:30-41` chip flow under a headline "Organism"; `DatabaseBrowserViewController.swift:1229` selects the `"mpox"` organism on load; registry default Mpox virus | |
| 38 | **Organism.** (Pathoplexus) "changing the chip clears the results you were looking at" | true | `PathoplexusSearchPane.swift:49-57`, `selectOrganism` empties `results`, `selectedRecords`, `totalResultCount` | |
| 39 | **Country.**, **Clade.**, **Lineage.** "The default is empty" | true | `DatabaseBrowserPane.swift:314`, `:328`, `:334`, all `TextField` bound to filters that start `""`; registry all default empty | |
| 40 | **Nucleotide Mutations.** "written as reference base, position, and new base and separated by commas" | true | `DatabaseBrowserPane.swift:342-344`, placeholder `"e.g., C180T, A200G"`; registry allowed matches | |
| 41 | **Amino Acid Mutations.** "written as a gene name and a change separated by a colon and again comma-separated" | true | `DatabaseBrowserPane.swift:348-350`, placeholder `"e.g., GP:440G"`; registry allowed matches | |
| 42 | **Collection Date.** "which is the sampling date and not the date the record was published" | true | `DatabaseBrowserPane.swift:356-367`, a From/To pair distinct from the NCBI Publication Date field; registry effect states the same distinction | |
| 43 | **INSDC Source.** "The default is Any ... Set it to Non-INSDC Only" | true | `DatabaseBrowserPane.swift:386-392` picker over `PathoplexusINSDCFilter.allCases`; registry default Any, allowed Any, INSDC Only, Non-INSDC Only | |
| 44 | Settings coverage of `fetch.pathoplexus` | false | The registry lists 11 settings. The chapter documents Organism, Country, Clade, Lineage, Nucleotide Mutations, Amino Acid Mutations, Collection Date, INSDC Source, and the shared (search scope). **Host** and **Sequence Length** are documented for NCBI but never for Pathoplexus, though both are on the Pathoplexus panel (`DatabaseBrowserPane.swift:320`, `:369`). The campaign rule is that a chapter documents every setting of every operation it cites | Add a Pathoplexus **Host.** and a Pathoplexus **Sequence Length.** paragraph, and see row 51 on the count |
| 45 | "The bundle in the sidebar carries the accession as its name, so it appears as `NC_012920.1`." | true | `GenBankBundleDownloadViewModel.swift:68-70`, base name is the sanitized `resolvedAccession`; `:200` sets `BundleManifest(name: resolvedAccession, ...)` | |
| 46 | "A `manifest.json` sits at the root, a `genome/` folder holds the sequence as a compressed FASTA with its indexes, and an `annotations/` folder holds the feature track." | true | `GenBankBundleDownloadViewModel.swift:71-74` creates `genome/` and `annotations/`; `:176-183` records `genome/sequence.fa.gz`, `.fai`, `.gzi`; `manifest.save(to: bundleURL)` at `:219` writes `manifest.json` (`SequenceExtractionPipeline.swift:405` names the same file) | |
| 47 | "That track is a file named `ncbi_gff3_annotations.db`, and the app displays it as NCBI GFF3 Annotations." | true | `GenBankBundleDownloadViewModel.swift:255` writes `annotations/ncbi_gff3_annotations.db`; `:266-269` sets `id: "ncbi_gff3_annotations"`, `name: "NCBI GFF3 Annotations"` | Fixes DRIFT false claim 16 |
| 48 | "It is a SQLite database ... built from the GFF3 the server returned." | true | `GenBankBundleDownloadViewModel.swift:257-261`, `AnnotationDatabase.createFromGFF3`; `fetch.txt:315` names the bundle's "SQLite annotation database (converted from GFF3)" | |
| 49 | "LGE keeps every feature row it is given, with no filter by feature type ... On the mitochondrial record that means all 77 features, not only the 13 coding sequences." | changed | The no-filter half is right (`:284-289`, `gff3FeatureRowCount` counts any nine-column non-comment line, and `createFromGFF3` applies no type filter), which fixes DRIFT false claim 5. But 77 is the count of the **GenBank** FEATURES table, measured from the scratch `.gb`. The GFF3 the server returns is a different serialisation with its own row count, and no GFF3 was fetched in this campaign's scratch run | Drop the "all 77" bridge, or fetch the GFF3 and quote its own row count |
| 50 | "When the GFF3 fetch fails, LGE falls back to the feature table carried inside the GenBank record itself and writes `ncbi_genbank_annotations.db`, displayed as NCBI GenBank Annotations. Nothing warns you when that happens." | true | `GenBankBundleDownloadViewModel.swift:126-129` catches the GFF3 error and only logs a warning to the unified log, no user-facing alert; `:154` writes `ncbi_genbank_annotations.db`; `:160-163` sets id `ncbi_genbank_annotations`, name `"NCBI GenBank Annotations"` | Settles DRIFT's missing-feature note |
| 51 | "The nine filters described in the Settings section sit in the shared Advanced Search Filters panel" | false | The Pathoplexus panel holds ten filters, not nine (`DatabaseBrowserPane.swift:305-395`: Country, Host, Clade, Lineage, Nucleotide Mutations, Amino Acid Mutations, Collection Date, Sequence Length, INSDC Source, plus the shared scope popup outside the panel). The chapter's Settings section describes eight of them | "The ten filters described in the Settings section", once row 44 is fixed |
| 52 | "they combine with AND logic across organism, provenance, and sequence attributes" | true | `DatabaseBrowserPane.swift:396`, caption verbatim: "Pathoplexus filters combine with AND logic across organism, provenance, and sequence attributes." | |
| 53 | "LGE retrieves only records marked OPEN, so restricted sequences never appear in the results." | true | `DatabaseBrowserViewController.swift:2065` sets `ppFilters.dataUseTerms = .open`; `PathoplexusService.swift:426-427` sends it as a query item; `PathoplexusModels.swift:360` `case open = "OPEN"`. The pane also states it at `DatabaseBrowserPane.swift:307` | Settles DRIFT unverifiable 40 |
| 54 | "The `source` block names the database as NCBI, carries the accession, holds a source URL under `https://www.ncbi.nlm.nih.gov/nuccore/`, stamps the download date, and copies the record's own definition line." | true | `GenBankBundleDownloadViewModel.swift:186-196`, `SourceInfo(database: "NCBI", assemblyAccession: resolvedAccession, sourceURL: .../nuccore/\(resolvedAccession), downloadDate: Date(), organism: record.sequence.description ?? record.definition ...)` | |
| 55 | Implied contrast, the GUI download records origin in the manifest rather than a `.lungfish-provenance.json` sidecar | true | `downloadAndBuild` (`:37-224`) writes only the bundle tree and `manifest.json`, with no provenance-sidecar writer anywhere in the file. The CLI path writes one (row 56) | Corrects DRIFT changed claim 17, which had assumed a GUI sidecar |
| 56 | "The command-line fetch keeps a fuller record ... in a [provenance sidecar](...) written beside the file it saved." | true | Scratch run produced `NC_012920.1.gb.lungfish-provenance.json` beside `NC_012920.1.gb` in the same `Downloads/` folder | |
| 57 | "produced `NC_012920.1.gb` at 64,640 bytes" | true | `wc -c` on the scratch file returns 64640 | |
| 58 | "the endpoint reads `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi`" | true | Sidecar `parameters.endpoint.value` is exactly that string, with no mirror alternative | Fixes DRIFT changed claim 32 |
| 59 | "the database reads `nucleotide`" | true | Sidecar `parameters.database.value` is `"nucleotide"` | |
| 60 | "`apiKeyProvided` reads false" | true | Sidecar `parameters.apiKeyProvided.value` is `false` | |
| 61 | "`retryCount` reads 0 with an empty list of retry events" | true | Sidecar `parameters.retryCount.value` is `0` and `parameters.retryEvents.value` is `[]` | |
| 62 | "`exitStatus` reads 0" | true | Sidecar top-level `"exitStatus": 0`, and the step's `exitStatus` and `exitCode` are both 0 | |
| 63 | "`wallTimeSeconds` read 0.61 for that run" | true | Sidecar `wallTimeSeconds` is `0.6148250102996826`, which rounds to 0.61 | |
| 64 | "The tool is named as `ncbi-efetch`." | true | Sidecar `tool.name`, `toolName`, and the step's `toolName` all read `"ncbi-efetch"` | |
| 65 | "The [checksum](...) ... for that run it read `7530d659e7174272372814edfecb2ece1f87a444395a861fcdf1b977c4aa5c1f`." | true | Recomputed with `shasum -a 256` on the scratch `.gb`, identical; the sidecar's `output.checksumSHA256` and `sha256` match | |
| 66 | "The `reproducibleCommand` field holds the full command line" | true | Sidecar `reproducibleCommand` holds the whole invocation including `--db`, `--fetch-format`, `--save-to`, and `--format text` | |
| 67 | "The sidecar records only whether an API key was supplied, never the key itself." | true | The only key-related field anywhere in the sidecar is the boolean `apiKeyProvided`; no key value appears in `argv`, `parameters`, or `reproducibleCommand` | |
| 68 | "The viewport reports the sequence length, and for this record it is 16,569 bases." | true | LOCUS line reads `16569 bp`; `GenomeInfo.totalLength` is summed from the FAI at `:106-108`, so the manifest carries the same number | |
| 69 | "A downloaded bundle lands under `Downloads/`, which is how a project distinguishes what came off the internet from what came off your own disk under `Imports/`." | true | `AppDelegate+Classification.swift:2484-2487`; `CONSISTENCY.md` "Folders and files" assigns `Imports/` to imported reads and `Downloads/` to downloaded data | |
| 70 | "If a reference you expected to find there is missing, check the Operations Panel row for the download" | changed | Same surface error as row 18. Failures are reported through `DownloadCenter.fail` (`DatabaseBrowserViewController.swift:2851-2857`), not the Operations Panel | Name the download surface, or drop the sentence |
| 71 | "An assembly accession, which begins `GCF_` or `GCA_` ... `fetch genome` resolves it through NCBI's assembly database. Any other accession is fetched from the nucleotide database instead, which returns the exact record you asked for." | true | `fetch.txt:307-309`, "Assembly accessions (GCF_/GCA_) are resolved through the assembly database. Any other accession is fetched from nucleotide, which returns the exact record requested" | |
| 72 | "Asking the assembly database for a nucleotide accession returns the linked assembly rather than the record you named, under a different sequence name. The command's own help states this." | true | `fetch.txt:309-311`, "asking the assembly database for a nucleotide accession returns the linked assembly instead, under a different sequence name" | |
| 73 | "LGE reaches it through **Tools > Search Online Databases > Search Pathoplexus...**" | true | `MainMenu.swift:755-758`, title "Search Pathoplexus..." | |
| 74 | "holding ten outbreak-relevant pathogens ... mpox virus, Marburg virus, measles virus, the Sudan and Zaire ebolaviruses, RSV-A and RSV-B, human metapneumovirus, West Nile virus, and Crimean-Congo haemorrhagic fever virus" | changed | `PathoplexusService.swift:192-204` lists exactly ten, and the set matches. But two display names differ from the chapter's: the app shows "Crimean-Congo hemorrhagic fever" (American spelling, no trailing "virus") and "Human metapneumovirus" | Use the app's display names so the reader can match the chips |
| 75 | "Crimean-Congo haemorrhagic fever virus splits into segments named `S`, `M`, and `L`" | true | `PathoplexusService.swift:194`, `segmented: true, segments: ["S", "M", "L"]` | Spelling as row 74 |
| 76 | "On first use the pane shows an access and benefit sharing notice titled Pathoplexus Access and Benefit Sharing, and nothing else on the pane works until you click I Understand and Agree." | true | `PathoplexusSearchPane.swift:8-15` swaps the whole pane for the consent panel; `:67` is the title verbatim; `:98` is the button title verbatim; `DatabaseSearchDialogState.swift:117-118` disables the primary action while consent is showing | Settles DRIFT unverifiable 34 |
| 77 | "A download attempted with no organism selected stops with the message \"Select a Pathoplexus organism\"." | true | `DatabaseBrowserViewController.swift:2445-2448`, `errorMessage = "Select a Pathoplexus organism"`; the same string is the search-time guard at `:1479` and `:2051` | |
| 78 | "When a record carries an INSDC accession, LGE tries the GenBank path first and appends the Pathoplexus metadata to it. When that retrieval fails, or when the record has no INSDC accession at all, LGE builds the bundle from the Pathoplexus sequence directly." | true | `DatabaseBrowserViewController.swift:2756` and `:2791` both route to `genBankVM.buildBundleFromSequence` as the fallback; `:2809-2811` appends the Pathoplexus metadata; `GenBankBundleDownloadViewModel.swift:291+` is the sequence-backed builder | |
| 79 | "There is no command-line equivalent for Pathoplexus." | true | Registry `fetch.pathoplexus` `cli_only: []` and no CLI entry point; `fetch.txt:10-16` lists only ncbi, search, sra, ena, genome | |
| 80 | "The third item in the same submenu is **Tools > Search Online Databases > Search SRA...**, and it opens the same dialog on its SRA Runs pane." | changed | `MainMenu.swift:749-752` shows "Search SRA..." as the **second** item, between Search NCBI... and Search Pathoplexus..., not the third. The pane title "SRA Runs" is right (`SRARunsSearchPane.swift:10`) | "The second item in the same submenu" |
| 81 | "An SRA run accession looks like `SRR11140748`." | true | `fetch.txt:152`, "SRA run accession (e.g., SRR11140748)" | |
| 82 | "On the command line the entry point is `lungfish-cli fetch sra`, with `search`, `download`, and `info` subcommands underneath it." | true | `fetch.txt:113-116`, exactly those three subcommands | |
| 83 | "Its help states that downloads use [ENA](...) mirrors for direct access without the SRA Toolkit" | true | `fetch.txt:99-100`, "Downloads use ENA mirrors for direct HTTP access (no SRA Toolkit required)" | Settles DRIFT changed claim 45 |
| 84 | "`fetch sra download --use-toolkit` switches to the toolkit instead, which needs `prefetch` and `fasterq-dump` installed." | true | `fetch.txt:158-159`, "Use SRA Toolkit instead of ENA (requires prefetch/fasterq-dump)" | |
| 85 | The `fetch ncbi` code block with `--fetch-format genbank --save-to ./Downloads/NC_012920.1.gb` | true | `fetch.txt:31-42` usage and options; the scratch run used exactly this shape and its sidecar's `reproducibleCommand` confirms the accepted form | |
| 86 | "`--fetch-format` picks what the server returns, among `genbank`, `fasta`, `gff3`, and `xml`, and it defaults to `genbank`." | true | `fetch.txt:39-41` | |
| 87 | "`--save-to` names the output file, and without it the record prints to the terminal." | true | `fetch.txt:42` "Output file path"; registry `cli_only` `--save-to` default "standard output" | |
| 88 | "`--db` picks `nucleotide` or `protein`, defaulting to `nucleotide`." | true | `fetch.txt:37-38` | |
| 89 | "Several accessions can follow the subcommand in one call, and they all land in the one output file." | true | `fetch.txt:31` `<accessions> ...`, and the example at `:29` writes two accessions to one `sequences.gb` | |
| 90 | "`--api-key` sends your NCBI API key ... and `NCBI_API_KEY` in the environment does the same thing" | changed | `--api-key` is confirmed (`fetch.txt:43`). The `NCBI_API_KEY` environment fallback is not in the help text, and `FetchCommand.swift` was not read in this pass | Verify the environment variable name against `FetchCommand.swift`, or drop the clause |
| 91 | "`--no-retry` stops the command retrying after NCBI answers with a rate-limit response" | true | `fetch.txt:44`, "Do not retry HTTP 429 rate-limit responses" | |
| 92 | The `fetch genome NC_012920.1 --output-dir ./Downloads` code block | true | `fetch.txt:324` usage and `:320` example `lungfish fetch genome MN908947.3 --output-dir ./genomes`, the same nucleotide-accession shape | |
| 93 | "`--output-dir` sets the destination and defaults to the current directory." | true | `fetch.txt:331-333`, "(default: .)" | |
| 94 | "`--name` sets the bundle name, which is otherwise derived from the assembly." | true | `fetch.txt:334`, "Bundle name (default: derived from assembly)" | |
| 95 | "`--fasta-only` saves just the decompressed FASTA, skipping the annotations and the bundle both, while `--no-bundle` keeps the annotations and stops short of assembling them." | true | `fetch.txt:335-337` | |
| 96 | "`--api-key` works here too." | true | `fetch.txt:338`, on `fetch genome` | |
| 97 | The `fetch search "mitochondrion complete genome" --organism human --limit 5` code block | true | `fetch.txt:69` usage; `:67` shows the same `--organism human` shape | |
| 98 | "`--limit` caps the number of results and defaults to 20." | true | `fetch.txt:77`, "Maximum results (default: 20)" | |
| 99 | "`--db` accepts `genome` here as well as `nucleotide` and `protein`, which is a third collection the dialog's Mode picker does not offer." | changed | The flag half is right (`fetch.txt:75-76`, "nucleotide, protein, genome"). The contrast is wrong: the dialog's Mode picker *does* offer Genome (`GenBankGenomesSearchPane.swift:6`), and the chapter itself documents it in **Mode.** The collection the picker lacks is `protein` | Say `fetch search --db` reaches a protein collection the Mode picker does not offer |
| 100 | "The European Nucleotide Archive is reachable directly too, through `fetch ena search`, `fetch ena fasta`, and `fetch ena reads`" | true | `fetch.txt:217-220`, subcommands search, reads, fasta | |
| 101 | Front matter `parameters_refs: [fetch.ncbi, fetch.pathoplexus]` | true | Both ids exist in `parameters.yaml` (lines 1926 and 2192). The SRA section is a pointer to its own chapter rather than a documented operation, so `fetch.sra` is correctly absent | |
| 102 | Front matter `shots` against the body's `<!-- SHOT -->` markers | true | Five markers (lines 71, 75, 79, 85, 187) and five `shots` entries with matching ids and captions; `ncbi-accession-anatomy` is under `illustrations` and is referenced as an image at line 179 | |
| 103 | Front matter `glossary_refs` anchors | true | All thirteen resolve as `{#anchor}` entries in `GLOSSARY.md`: accession, reference-bundle, reference-genome, gff, provenance, provenance-sidecar, checksum, insdc (`:155`), pathoplexus, sra, ena, mitochondrial-genome (`:201`), refseq (`:279`) | |
| 104 | "the human mitochondrial genome fixture, which is where the record's committed copy and its facts live" | true | `docs/user-manual/fixtures/human-mito/README.md` commits `NC_012920.1.fasta` and states the 16,569 bp length | |
| 105 | "Nothing in this chapter needs a plugin pack or Docker Desktop, because the download and the bundle build both run inside the app." | changed | The download needs no pack, but the bundle build shells out to bgzip and samtools faidx through `NativeToolRunner` and pre-flights them with `validateTools()` (`GenBankBundleDownloadViewModel.swift:33-34`, `:46-47`, `:84`, `:93`). `BundleBuildError.missingTools` is the failure mode | Say the bundle build uses the app's bundled samtools tooling, or drop "inside the app" |

Verdict counts: 83 true, 3 false, 18 changed, 1 unverifiable.

## Notes for the editor

Row 44 and row 51 are one repair. The Pathoplexus Settings group needs a
**Host.** paragraph and a **Sequence Length.** paragraph, and the "nine
filters" sentence then becomes "ten filters". Without both, the chapter fails
the campaign's every-setting rule and contradicts its own count.

Rows 18 and 70 are the other paired repair. The chapter twice sends the reader
to the Operations Panel for a download that never reports there. A reader whose
download fails will find an empty panel and conclude nothing ran.

Rows 22, 74, and 80 are label and position mismatches a reader hits while
looking at the screen. The ampersand in "GenBank & Genomes", the American
spelling on the Crimean-Congo chip, and SRA being the second submenu item
rather than the third.

Row 49 is the subtlest. The chapter proves the no-feature-filter claim, which is
correct, by bridging to the 77 features counted in the GenBank record. Those 77
were recounted and are right, but they are not the GFF3 row count, and the
chapter presents them as what the GFF3 track holds.
