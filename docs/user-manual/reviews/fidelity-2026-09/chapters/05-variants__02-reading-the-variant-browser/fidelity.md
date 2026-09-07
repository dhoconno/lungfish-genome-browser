# Fidelity review, chapter 28, Reading the Variants Table

File reviewed: `docs/user-manual/chapters/05-variants/02-reading-the-variant-browser.md`
Registry ids: `variants.filter-table`, `variants.query`
Fixture: `hg002-chr20`
Lint: `no issues found` under `LUNGFISH_MANUAL_STRICT=1`, reproduced.

Ground truth used, in campaign order: the Swift source under `Sources/`, the
CLI help tree from `.build/debug/lungfish-cli`, `parameters.yaml`, and reruns
of the chapter's own query commands against the author's scratch bundle at
`/private/tmp/claude-501/.../scratchpad/variants-table/`, recounted with
bcftools 1.24 from `~/.lungfish/conda/envs/bcftools/bin/bcftools`. The
installed Preview app was not driven, so every claim resting on what a
control looks like on screen rather than on what the code builds is marked
accordingly.

## Claims

| # | Claim (quoted) | Verdict | Evidence | Corrected wording |
|---|---|---|---|---|
| 1 | "It lives in the table drawer, the panel that slides up from the bottom edge of the reference bundle viewport, on a tab labelled **Variants**." | true | `ViewerViewController+AnnotationDrawer.swift:124-140` builds `AnnotationTableDrawerView` into the viewer; `+Columns.swift:344` switches to `variantColumnDefs` for the variants tab | |
| 2 | "The drawer opens by itself the moment you load a bundle that carries at least one variant track" | true | `ViewerViewController+AnnotationDrawer.swift:92-107`, `openAnnotationDrawerIfBundleHasData` toggles the drawer when the manifest has annotations or variants | |
| 3 | "no per-track node in the project sidebar to hunt for" | true | Ground-truth standing note, `SidebarItem.swift:230` maps variants onto the annotation kind; the only variant sidebar affordance is `Delete Variant Tracks…` | |
| 4 | "The drawer starts 250 points tall, you can drag its top edge to resize it, and LGE remembers the height you chose" | true | `ViewerViewController+AnnotationDrawer.swift:16` `annotationDrawerHeight = 250`; `:132-135` reads and writes `UserDefaults` key `annotationDrawerHeight` | |
| 5 | "Two sibling tabs share the same drawer. **Annotations** lists gene features, and **Samples** lists the sample columns" | true | `+Columns.swift:344-347` defines exactly three tabs; sample columns at `:327-332`; `AnnotationTableDrawerView.swift:972` accessibility label "Switch between annotations, variants, and samples" | |
| 6 | "A two-segment control switches between one row per variant and one row per sample." | true | `+Columns.swift:39-64` builds the Calls/Genotypes control, shortening to `GT` at narrow width | |
| 7 | "A second two-segment control decides whether the table lists only the stretch of genome the viewport is currently showing or queries the whole reference." | true | `AnnotationTableDrawerView.swift:776-789`, `scopeControl` with segments `Region` and `Genome`, tooltip "Choose whether variants follow the visible region or query the whole genome" | |
| 8 | "A **Presets** button opens a strip of one-click filter chips." | true | `AnnotationTableDrawerView.swift:849`, `presetFiltersToggleButton.title = "Presets ▸"` | |
| 9 | "A **Search Builder...** button opens a sheet" | true | `AnnotationTableDrawerView.swift:859`, `searchBuilderButton.title = "Search Builder..."` | |
| 10 | "A **Clear** button drops every filter at once." | true | `AnnotationTableDrawerView.swift:881-888`, title `Clear`, tooltip "Clear variant filter" | |
| 11 | "There is no free-text box to type a query into" | true | `+Columns.swift:92`, `variantFilterField.isHidden = true` with the comment "Always hidden; Query Builder writes to variantFilterText directly" | |
| 12 | "Sorting, filtering, hiding a column, and hiding a sample all change what you see and never touch the VCF on disk." | true | The drawer's only write path is `AnnotationTableDrawerView+Export.swift`, which writes a new file and never mutates the track | |
| 13 | "The table cannot write a VCF." | true | `+Export.swift:35-61` offers only `csv`, `tsv`, and `json`; there is no VCF case | |
| 14 | "Those two runs produced 1,056 rows and 862 rows respectively." | true | Recounted, `bcftools view -H` gives 1056 and 862 on the two fixture VCFs | |
| 15 | "the two call sets share 852 positions, bcftools reports 201 that LoFreq does not, and LoFreq reports 9 that bcftools does not" | true | Recounted with `bcftools query -f '%POS\n' \| sort -u` and `comm`, giving 852, 201, 9 | |
| 16 | "bcftools arrives in the Required Setup pack, so the optional command-line section at the end of this chapter needs nothing installed" | unverifiable | Not settled from the sources I read. `PluginPack.swift` would settle which pack carries bcftools. The chapter's own CLI section needs `lungfish-cli` rather than bcftools, except for the final `bcftools view -H` counting line | |
| 17 | "Twelve fixed columns run across the table, always in this order." followed by the twelve labels | true | `+Columns.swift:312-324`, `variantColumnDefs` lists exactly `ID`, `Type`, `Chrom`, `Position`, `Ref`, `Alt`, `Quality`, `Filter`, `Samples`, `Source`, `Consequence`, `AA Change`, in that order and with those exact titles | |
| 18 | "Seven of them are the VCF's own standard columns. `Type` and `Samples` are worked out from each record. `Source`, `Consequence`, and `AA Change` are added by LGE" | true | `+TableView.swift:804-811`, `Samples` returns `annotation.sampleCount`, `Source` returns `sourceFile`, `Consequence` and `AA Change` come from `variantConsequenceText`/`variantAAChangeText`; `Type` from `VariantDatabase.classifyVariant` | |
| 19 | "`Chrom` \| The reference sequence name, `chr20_10.0-10.5Mb` on this fixture" | true | `bcftools query -f '%CHROM'` on the fixture returns `chr20_10.0-10.5Mb` | |
| 20 | "`Samples`, which counts the sample columns holding a call at that position" | true | `+TableView.swift:805`, `return "\(annotation.sampleCount ?? 0)"` | |
| 21 | "The Inspector shows the consequence too, so the table and the Inspector agree rather than each holding half the story." | **false** | `Sources/LungfishApp/Views/Inspector/Sections/VariantSection.swift` renders only identity (ID, Type, Position, Alleles), quality and filter, a genotype summary, and INFO fields. It has no consequence and no AA-change row, and `grep` for `consequence` in that file returns nothing but `String(format:)` hits | Drop the sentence. The consequence appears in the table's own `Consequence` and `AA Change` columns; the Inspector does not repeat it |
| 22 | "LGE's own iVar output writes a bare `.` in that field for every row, so on an iVar track the column is blank" | true | `IVarTSVToVCFConverter.swift:144` writes a literal `.` in the QUAL position of every row | |
| 23 | "The bcftools track on this fixture declares sixteen `INFO` keys including `DP`, `DP4`, `MQ`, and `AC`, while the LoFreq track declares seven including `DP`, `AF`, and `SB`" | true | Recounted from the headers. bcftools declares 16 (`INDEL IDV IMF DP VDB RPBZ MQBZ BQBZ MQSBZ SCBZ SGB MQ0F AC AN DP4 MQ`), LoFreq declares 7 (`DP AF SB DP4 INDEL CONSVAR HRUN`) | |
| 24 | "A few are pulled to the front in a fixed order when the file carries them, and the rest follow in the order they were discovered." | true | `+Columns.swift:370-385`, promoted keys first, then remaining keys in discovery order | |
| 25 | "Every column sorts. Click a header once and the table sorts ascending, click again for descending." | true | `+Columns.swift:352` sets a `sortDescriptorPrototype` with `ascending: true` on every column | |
| 26 | "Drag a header sideways to reorder the columns, and right-click the header bar to hide the ones you are not using." | unverifiable | `+Columns.swift:333-341` sets `userResizingMask` and `:415-430` restores saved visibility and ordering, which implies both affordances, but neither the drag-to-reorder nor the right-click menu is built explicitly in the source I read. A GUI run would settle it | |
| 27 | "LGE stores your column widths, ordering, and visibility per tab" | true | `+Columns.swift:415-430`, `ColumnPrefsKey.load(tab:)` is keyed on the tab | |
| 28 | "It shows the identifier and type, the position, the alleles, the quality and the filter value, a genotype summary where the file carries genotypes, and every `INFO` key broken out on its own row." | true | `VariantSection.swift:279-292` renders exactly `variantIdentity` (ID, Type, Position, Alleles), `qualityAndFilter`, `genotypeSummary` gated on `hasGenotypes`, and `infoSection` gated on non-empty `infoFields` | |
| 29 | Shot caption: "The Inspector filled with one selected variant row, showing its INFO and FORMAT payload alongside the Consequence and AA Change values the table also carries." | **false** | Same evidence as row 21. The Inspector shows no FORMAT payload and no Consequence or AA Change. The genotype summary is per-variant counts (Hom Ref, Het, Hom Alt, No Call) plus a derived alt allele frequency, not the FORMAT string | Recaption: "The Inspector filled with one selected variant row, showing its identity, quality and filter, genotype summary, and every INFO key on its own line." |
| 30 | "the up and down arrow keys move the selection from row to row and the Inspector follows" | unverifiable | Standard `NSTableView` behaviour and a selection-driven Inspector are both plausible from `VariantSectionViewModel.select(variant:)`, but the key handling itself was not located. A GUI run would settle it | |
| 31 | "VoiceOver announces the focused cell and its column, and the column headers are reachable as buttons you can activate to sort without a mouse" | unverifiable | `AnnotationTableDrawerView.swift:1284` sets an accessibility label on the table and the header view is a real `NSTableHeaderView` (`:19`), which makes this likely, but the announcement text and header activation were not verified. A VoiceOver run would settle it | |
| 32 | "A strip of chips unfolds, grouped into four named sections." with the four section names | true | `SmartFilterTokens.swift:32-46`, `UISection` gives exactly `Biological Effect`, `Quality / QC`, `Population / Frequency`, `Sample / Genotype` | |
| 33 | The fourteen chip labels as listed per section | true | `SmartFilterTokens.swift:15-30` defines fourteen cases, `:49-66` gives the labels, `:81-93` gives the section for each. Every label and placement in the chapter matches, including the `≥` and `≤` glyphs rendered as `Qual ≥ 30`, `DP ≥ 10`, `Minor (≤20%)`, `Dominant (≥80%)` | |
| 34 | "A chip appears only when the loaded track carries the field it reads, and its tooltip says which field is missing" | true | `SmartFilterTokens.swift:110-166`, `isAvailable` plus `unavailabilityReason` returning strings such as "Requires DP field in INFO" | |
| 35 | "The impact chips need an `IMPACT` field written by an annotation program such as SnpEff or VEP, which neither caller on this fixture writes." | true | `SmartFilterTokens.swift:129-130` gates both impact chips on `impactKeys` = `IMPACT`, `impact`, `ANN_IMPACT`, `CSQ_IMPACT`; the reason string names SnpEff/VEP. Neither fixture VCF declares any of those keys | |
| 36 | "`ClinVar Path.` needs a `CLNSIG` field." | true | `SmartFilterTokens.swift:137-138`, gated on `clinvarKeys` which lead with `CLNSIG` | |
| 37 | "The three frequency chips appear only for a haploid organism with genotype data, so a human fixture never shows them." | true | `SmartFilterTokens.swift:143-145`, `return isHaploidOrganism && hasGenotypes` | |
| 38 | "`Het Only` is unavailable on every track today, and its tooltip says so." | true | `SmartFilterTokens.swift:140-141`, `case .heterozygous: return false` unconditionally, with reason "Genotype filtering not yet supported". Confirms the author's defect 1 | |
| 39 | "Chips from different sections combine, so `PASS` and `DP ≥ 10` together keep only the rows satisfying both." | true | Only three exclusivity groups are defined (`SmartFilterTokens.swift:96-106`), and `passOnly` and `depthGE10` are in neither, so they compose | |
| 40 | "`SNV` and `Indel` are mutually exclusive, `High Impact` and `Moderate+` are mutually exclusive, and the three frequency chips are mutually exclusive with each other." | true | `SmartFilterTokens.swift:97-105`, groups `variant-type`, `impact-tier`, `within-sample-af` | |
| 41 | "Click `PASS` while the bcftools rows are on screen and the table empties. Not one of the 1,056 bcftools rows says `PASS`" | true | Recounted, `bcftools query -f '%FILTER\n'` gives 1056 rows of `.` on the bcftools track and 862 rows of `PASS` on the LoFreq track | |
| 42 | "The 862 LoFreq rows all say `PASS`, so the same chip changes nothing on those." | true | Same recount | |
| 43 | "A **Profiles** pull-down beside the chips ... offers four built-in combinations, `Clinical`, `Research`, `QC`, and `High Confidence`" | true | `FilterProfileManager.swift:39-69` defines exactly those four names, collected at `:70` into `builtInProfiles` | |
| 44 | "each hidden when the track lacks a field its chips need" | true | `+TableView.swift:33-40` skips a profile unless every one of its tokens is available | |
| 45 | "and a `Save Current as Profile...` item that stores your own under the bundle. `No Profile` at the top clears the selection." | **false** in one part | The two menu items are exact (`+TableView.swift:23` `No Profile`, `:58` `Save Current as Profile…`), but a custom profile is stored in `UserDefaults` under the key `com.lungfish.filterProfiles.<bundle identifier>` (`FilterProfileManager.swift:75-97`), not inside the bundle. It does not travel with a bundle you copy or share | "...that stores your own on this Mac, keyed to the bundle you saved it from" |
| 46 | "The Variant Query Builder sheet opens with one blank rule." | true | `VariantQueryBuilderSheet.swift:74` titles the sheet "Variant Query Builder"; the rules array starts with a single default `QueryRule` | |
| 47 | "They combine with **Match All** ... and Match All is the only choice the sheet offers." | true | `QueryRule.swift:161-163`, `QueryLogic.allCases` is overridden to `[.matchAll]`, and the picker at `VariantQueryBuilderSheet.swift:78-80` iterates `allCases` | |
| 48 | "Seven categories organise the fields." with the seven names | true | `QueryRule.swift:90-107`, `allCases` gives exactly `Location`, `Variant Identity`, `Biological Effect`, `Population/Frequency`, `Call Quality`, `Sample/Genotype`, `INFO Field` | |
| 49 | "**Location** offers Region, Chromosome, and Gene List. **Variant Identity** offers ID/Name and Type. **Biological Effect** offers IMPACT, GENE, and CLNSIG. **Call Quality** offers Quality, Filter, DP, MQ, and Sample Count." | true | `QueryRule.swift:110-127`, the built-in field lists match exactly | |
| 50 | "**Population/Frequency** offers AF and the three population-database frequency keys." | true as far as it goes | `QueryRule.swift:118-119` gives `AF`, `gnomAD_AF`, `ExAC_AF`, `1000G_AF`. The chapter omits that `VariantQueryBuilderSheet.swift:494-501` also appends any loaded INFO key whose name contains AF, AN, AC, freq, MLEAF, gnomAD, ExAC, or 1000G, so on the bcftools track this category also lists `AC` and `AN` | Optional: add that the category also picks up matching INFO keys from the loaded track |
| 51 | "**Sample/Genotype** offers Sample.GT, Sample.AF, and Sample.DP." | **false** as the reader will see it | `VariantQueryBuilderSheet.swift:504-508` replaces those placeholder labels with one triple per loaded sample whenever any sample is present. On this fixture the reader sees `HG002.GT`, `HG002.AF`, and `HG002.DP`. The literal `Sample.GT` spelling appears only when no sample is loaded (`QueryRule.swift:124`) | "**Sample/Genotype** offers a genotype, allele-frequency, and depth field for each sample the tracks declare, so on this fixture it offers `HG002.GT`, `HG002.AF`, and `HG002.DP`." |
| 52 | "**INFO Field** offers every `INFO` key the loaded track actually declares." | true | `VariantQueryBuilderSheet.swift:502-503`, `fields = availableInfoKeys.sorted()` | |
| 53 | "A Location rule takes only `=` ... A Filter rule takes only `=`. Numeric fields take `<`, `<=`, `>`, `>=`, and `=`. A genotype rule takes `=` and `!=`, and the other per-sample fields add the numeric comparisons." | true | `QueryRule.swift:130-148`, `operators(for:)` returns `["="]` for location, `["="]` for `Filter`, the five comparisons for population and call quality, `["=", "!="]` for a `.GT` suffix, and the six for other per-sample fields | |
| 54 | "Set the first rule to Location, then Region, then `=`, then `1-250000`, which keeps the first half of the slice." | **false** | The Region field writes `region=1-250000` (`QueryRule.swift:39-40`). `parseRegion` (`+Filtering.swift:2053-2058`) splits on `:` and returns `nil` unless the value is `chrom:start-end`, and the `case "region"` arm at `:1456-1459` silently drops a `nil`. So this rule applies no restriction at all and the reader sees the unrestricted table. The clause that does take a bare range is `pos`, which the Location category does not expose | Use a Region value that names the sequence, `chr20_10.0-10.5Mb:1-250000`. A bare `1-250000` is silently ignored |
| 55 | "On the bcftools track that leaves 512 rows out of the 574 in that window" | true as arithmetic, unreachable by the stated route | Recounted, 574 bcftools rows sit at or below position 250,000 and 512 of those carry `INFO/DP >= 30`. But because of row 54 the reader following the chapter's steps will not see 512, they will see the DP filter applied across the whole slice | Keep the numbers, fix the Region value per row 54 |
| 56 | "The sheet ships built-in query presets ... including `High-Confidence Coding`, `Rare Pathogenic`, `Quality Review`, `PASS + High Quality`, `Rare Variants`, and `Indels Only`." | true | `QueryRule.swift:202-253` defines exactly those six names, in that order | |
| 57 | "A preset whose rules name a field the track does not carry is hidden rather than offered and failing." | true | `VariantQueryBuilderSheet.swift:214-221`, `allPresets` keeps a preset only when every rule is in a built-in category or names an available INFO key | |
| 58 | "`Save Preset...` stores a query of your own under the same list." | true | `VariantQueryBuilderSheet.swift:166` opens the save dialog; `:199-208` builds a `QueryPreset` appended to `savedPresets` | |
| 59 | "On a very large variant database the Search Builder button is disabled ... its tooltip names the database size and tells you to zoom the viewport in below 10 Mb" | true | `+Columns.swift:108-131`, the button stays visible and `isEnabled` goes false, with tooltip "Database is large (N MB). Zoom in to a region < 10 Mb to enable Query Builder." | |
| 60 | "The chips keep working in that case." | true | `+Columns.swift:105` hides the Presets button only on minimal density, an empty INFO key set, or materialized-only mode, none of which the large-database gate triggers on its own | |
| 61 | "LGE has no side-by-side caller comparison view, no intersection button, and no union export." | true | Settled by the DRIFT decision retiring `03-cross-caller-comparison.md` for exactly this reason, and no such surface appears in the drawer sources | |
| 62 | "The tick colors on the genome track above encode the genotype call and the variant type, never the source file" | true | `VariantTrackRenderer.swift:534` `colorForCall`, `:543` `colorForCallWithImpact`, `:562` `colorForVariantType`. No source-driven color path exists | |
| 63 | "Coordinate 250527 ... Both callers report a reference `C` read as a `T` at a depth of 63." | true | Recounted. bcftools row is `C T 222.235 . DP=63`, LoFreq row is `C T 1093 PASS DP=63` | |
| 64 | "The bcftools row carries the genotype `0/1` ... with allele depths of 20 reference reads and 33 alternate reads." | true | Recounted, `[%GT %AD]` gives `0/1` and `20,33` at that position | |
| 65 | "The LoFreq row carries no genotype at all and reports `AF=0.571429` instead." | true | Recounted, the LoFreq VCF has no sample column and the row's `AF` is `0.571429` | |
| 66 | "182 of the 1,056 bcftools rows are indels while LoFreq called none at all" | true | Recounted, `bcftools view -H -v indels` gives 182 on bcftools and 0 on LoFreq | |
| 67 | Settings entry, Calls / Genotypes, default Calls, no CLI flag | true | `parameters.yaml:3861-3867`; the control is built in `+Columns.swift:39-64`. Three-sentence shape and the closing no-flag sentence are present | |
| 68 | Settings entry, Region / Genome, default Region, no CLI flag | true | `parameters.yaml:3868-3874`; `AnnotationTableDrawerView.swift:781` sets `selectedSegment = 0`, which is `Region` | |
| 69 | Settings entry, Presets, "the button hides itself when the window is too narrow to hold it or the loaded track declares no `INFO` keys" | true | `+Columns.swift:105`, hidden on `toolbarDensity == .minimal` or `infoColumnKeys.isEmpty` (and on materialized-only mode, which the chapter does not mention and does not need to) | |
| 70 | Settings entry, Search Builder, "the free-text filter field is permanently hidden on this tab" and "the query engine has no OR" | true | `+Columns.swift:92` for the field; `VariantSmartFilter.swift:150` joins conditions with `" AND "` only, and `QueryLogic.allCases` hides `matchAny` | |
| 71 | Settings entry, Search Builder, "On the command line the query text it writes is what `--filter` takes." | **false** | Rerun against the author's bundle. `--filter 'filter=PASS'` returns `Error: Unsupported smart-filter clause: filter=PASS`, and so do `DP>=10` and `pos:1-250000`. The sheet writes exactly those shapes (`QueryRule.swift:36-73`), so its output is in general not accepted by `--filter`. This contradicts the chapter's own accurate paragraph in the command-line section, and it is the author's defect 2 | "The sheet's query text is not in general accepted by `--filter`, which takes per-sample clauses only. The command-line section covers what it does take." |
| 72 | Settings entry, Auto / Haploid / Diploid, default Auto | true | `parameters.yaml:3889-3895`; `AnnotationTableDrawerView.swift:794-800` builds the control with tooltip "Within-sample AF token mode: Auto from reference size, or force haploid/diploid" | |
| 73 | "The default is Auto, which guesses from the size of the reference and gets a human fixture and a viral genome right without being told." | unverifiable in its second half | The Auto default and the reference-size heuristic are in the tooltip and the registry, but no test or source line I read establishes that the guess is correct for both a human slice and a viral genome. The claim of correctness would be settled by reading the threshold in `isHaploidOrganism` | |
| 74 | Settings entry, Clear, "It is hidden until a filter is active" | true | `+Columns.swift:195`, `clearFilterButton.isHidden = !(activeTab == .variants && hasFilter)` | |
| 75 | "It holds 1,918 rows, which is the 1,056 bcftools rows plus the 862 LoFreq rows" | true | 1056 + 862 = 1918, and both counts are recounted above | |
| 76 | "Every bcftools row reads `.` and every LoFreq row reads `PASS`." | true | Recounted per row 41 | |
| 77 | "The bcftools rows run from 4.5 to 228.4 and only 24 of the 1,056 fall below 30." | true | Recounted, min 4.4503, max 228.417, 24 rows below 30 | |
| 78 | "The LoFreq rows run from 73 to 2,478 and none fall below 30." | true | Recounted, min 73, max 2478, 0 below 30 | |
| 79 | "This fixture has a mean depth of 44.7 across the slice" | unverifiable | Not derivable from the two VCFs. The mean `INFO/DP` at called sites is 42.17, a different quantity. A `samtools depth` run over the fixture BAM would settle it, which is outside this review's read-only allowance | |
| 80 | "1,049 of the 1,056 bcftools rows sit at a depth of 10 or more" | true | Recounted from `INFO/DP`, 1049 rows at 10 or more | |
| 81 | "reading it splits the 862 rows into 339 at or above 0.8, 517 between 0.2 and 0.8, and 6 below 0.2" | true | Recounted from LoFreq `INFO/AF`, giving 339, 517, 6 | |
| 82 | "The bcftools rows carry no `AF` key at all" | true | The 16 declared INFO keys contain no `AF` | |
| 83 | "623 rows reading `0/1` and 415 reading `1/1`. Both descriptions of this person's chromosome 20 agree." | **false** as stated | Recounted, the tally is 623 `0/1`, 415 `1/1`, and 18 `1/2`, which is 1,056. The chapter's two figures sum to 1,038 and leave 18 rows unexplained inside a sentence that claims the two descriptions agree. Chapter 27 states all three counts and explicitly reconciles them to 1,056 | Add the third group: "623 rows reading `0/1`, 415 reading `1/1`, and 18 reading `1/2`, where the two copies carry different alternates." |
| 84 | "Of the 1,056 bcftools rows, 874 are substitutions and 182 are insertions or deletions." | true, and it is the correct convention | Recounted three ways. `bcftools view -v snps` gives 874, `-v indels` gives 182, and `comm` on the two record sets shows **no overlap at all**, so the subsets partition the file exactly. Reclassifying with LGE's own rule (`VariantDatabase+Classification.swift:15-35`, first ALT allele only, one type per record) gives 874 SNP, 98 DEL, 84 INS, again 874 and 182. The file has 18 multiallelic records, and the only one whose alts are all substitutions is `31715 G > T,A`; none mixes a substitution with an indel | |
| 85 | "All 862 LoFreq rows are substitutions." | true | Recounted, `-v indels` gives 0 on the LoFreq track | |
| 86 | "The `Indel` chip therefore empties the LoFreq rows entirely and keeps 182 bcftools rows" | true | Follows from rows 84 and 85 and the chip's type filter (`SmartFilterTokens.swift:125-128`) | |
| 87 | "The bcftools track called 1,056 rows across 500 kb, which is roughly one difference every 470 bases." | true | 500,000 / 1,056 = 473.5 | |
| 88 | "Here 852 positions are shared, 201 are bcftools-only, and 9 are LoFreq-only" | true | Recounted per row 15 | |
| 89 | "clicking the track shows the provenance record with the caller version, the exact command line, and checksums of the inputs" | unverifiable | Provenance sidecars do exist beside every artefact (I observed `*.lungfish-provenance.json` written for each query output and each bundle variant file), but the sidebar interaction that surfaces them, and whether the record carries all three named items, was not verified. A GUI run plus a read of one sidecar would settle it | |
| 90 | "`lungfish-cli variants query` ... reads the same variant database the table reads, applies a smart-filter token, and writes the matching rows to a new VCF with a provenance record beside it." | true | `variants.txt` and the live `--help`; every successful rerun wrote `<output>.lungfish-provenance.json` beside the VCF | |
| 91 | "The command stages the output first, writes that record, and publishes the VCF only once the record is safely saved, restoring the previous record if anything fails" | true | Ground truth cites `VariantsCommand.swift:245-273` for exactly this staging order | |
| 92 | "The `--filter` flag accepts per-sample clauses only. Clauses of the form `Sample[<name>].<field>`, a `count(...)` over all samples, and a comparison between two named samples all work." | true | `VariantSmartFilter.swift:163-247`; the author's runs and my reruns confirm `Sample[HG002].GT=1/1` and `count(Sample[*].GT=1/1) >= 1` both succeed | |
| 93 | "The plain clause keys the Search Builder writes, such as `filter=PASS` or `pos:1-250000`, and comparisons against `INFO` keys such as `DP>=10`, are rejected with the message \"Unsupported smart-filter clause\"." | true | Reran all three. Each returns `Error: Unsupported smart-filter clause: <clause>` verbatim | |
| 94 | "Only `GT`, `AF`, and `DP` are valid per-sample fields, and `AF` is worked out from the allele depths rather than read from an `AF` tag" | true | `VariantSmartFilter.swift:44-46` for the three fields; `alleleFrequencyExpression` (`:360-372`) computes the ratio from `allele_depths` in SQL | |
| 95 | "so it works on a caller that writes `AD` and returns nothing on one that does not" | true | Reran `--filter 'Sample[HG002].DP>=1'`, which wrote a VCF with 0 records against a track whose 1,056 rows all carry `INFO/DP`. The bcftools VCF declares `GT:PL:AD` and no per-sample `DP`. Confirms the author's defect 3 | |
| 96 | "Homozygous-alternate calls for the HG002 sample, 415 rows on this fixture" | true | Reran `Sample[HG002].GT=1/1`, 415 records | |
| 97 | "Heterozygous calls, 623 rows" | true | Reran `Sample[HG002].GT=0/1`, 623 records | |
| 98 | "Calls where over half the reads carry the alternate, 770 rows" | true | Reran `Sample[HG002].AF>=0.5`, 770 records. My independent awk count summing every alt gives 773, and the 3-row gap is the multiallelic rows, where `alleleFrequencyExpression` takes everything after the first comma as one REAL. The chapter's figure is the one the command prints | |
| 99 | "Cap the export, which writes the first 20 matching rows only" with `--limit 20` | true | Reran with `--limit 20`, output held exactly 20 records | |
| 100 | "`--filter` holds the smart filter and is required. `-o` or `--output` names the VCF and is required too. `--limit` ... defaults to 5000 ... `--format` prints the run summary as `text`, `json`, or `tsv` and defaults to `text`. A `-t` or `--threads` flag sets the thread count and defaults to automatic." | true | Live `lungfish-cli variants query --help` matches every flag, both required markers in the USAGE line, and all three defaults | |
| 101 | "`lungfish-cli variants extract-sample` pulls one named sample's calls out of a multi-sample track" | true | `variants.txt:96-104`, "Extract one sample's variant calls from a bundle variant database" with a required `--sample` | |

## Front matter

| Item | Verdict | Evidence |
|---|---|---|
| `parameters_refs: [variants.filter-table, variants.query]` matches roster row 28 | true | `DRIFT.md:3754` lists exactly those two ids for this chapter |
| Title `Reading the Variants Table` matches the roster and the nav | true | `DRIFT.md:3754`; `mkdocs.yml:100` reads `Reading the Variants Table:` |
| Retired chapter removed from nav | true | `mkdocs.yml` has no `Cross-Caller Comparison` entry and no `03-cross-caller-comparison.md` path |
| Every `<!-- SHOT -->` marker is listed in `shots` with a caption | true | Five markers in the body (`variants-tab-twelve-columns`, `variants-inspector-row`, `variants-preset-chips`, `variants-search-builder`, `variants-source-column`), five `shots` entries, ids identical, each with a caption. One caption is factually wrong, see claim 29 |
| Every `glossary_refs` anchor resolves in `GLOSSARY.md` | true | All 22 anchors checked, none missing. The four new entries (`allele-depth`, `consequence`, `table-drawer`, `variant-track`) exist in alphabetical position and follow the one-sentence-plus-See-also shape |
| All three `help-ids.yaml` anchors exist as heading slugs | true | `step-2-read-the-columns`, `step-4-filter-with-the-preset-chips`, and `step-3-select-a-row-and-read-the-inspector` each match an H3 in the body. Note that `inspector.VariantSection`'s own description still says "per-variant INFO and FORMAT detail", which is wrong for the same reason as claim 21, but that file belongs to another role |
| `tools: [bcftools]` | true | The chapter's only third-party command is `bcftools view -H` |

## Cross-chapter consistency

**The SNV and indel split contradicts chapter 27, and this chapter has the
right numbers.** Chapter 27 line 140 says "873 are single-base substitutions
and 183 are insertions or deletions". This chapter says 874 and 182. I
recounted the same file three ways and every convention gives 874 and 182.
Crucially, the premise offered for the 873/183 convention, that one
multiallelic record carries both a substitution and an indel and should be
counted once under its first type, does not hold on this file. `bcftools view
-v snps` and `-v indels` produce **disjoint** record sets here, their sizes
sum to exactly 1,056, and `comm` on the two sets returns nothing in common.
The file's 18 multiallelic records are each internally uniform, the only
all-substitution one being `31715 G > T,A`. LGE's own `Type` column, which is
what the chapter's table describes, classifies on the first ALT allele alone
(`VariantDatabase+Classification.swift:15-35`) and yields 874 SNP plus 98 DEL
plus 84 INS.

So the count convention the project manager ruled on is sound in the abstract
(one record, one type, first type wins) but the figures attached to it are
not what this file produces. Under that very convention the answer is 874 and
182. My recommendation for the campaign is to keep this chapter's numbers and
correct chapter 27, which is still in review, rather than the reverse. Either
way the two chapters must not ship as they stand.

Two smaller consistency notes. The chapter never states the convention it is
using, which the review brief asked for, so even once the figures agree a
reader meeting 874/182 here and a different pair elsewhere has nothing to go
on. And the genotype sentence at claim 83 drops the 18 `1/2` rows that
chapter 27 carefully reconciles, which makes the same fixture look like it
has two different row totals across two adjacent chapters.

**CONSISTENCY sheet, variant track storage.** The sheet's "Variant track
storage" section says a track is `<name>.vcf.gz` with `.vcf.gz.tbi` and a
`.db` sidecar, with no BCF and no CSI. The author's scratch bundle, built
with `bundle create --variant`, holds `hg002.bcftools.vcf.bcf`,
`hg002.bcftools.vcf.bcf.csi`, and `hg002.bcftools.vcf.db`. I confirmed those
files on disk. The sheet's claim is therefore true of the `variants call`
attachment path and false of `bundle create --variant`. The chapter itself
stays clear of this by never describing what `bundle create` leaves on disk,
so no chapter claim is affected, but the sheet needs a qualifier from whoever
owns it. This confirms the author's defect 4 and matches the review brief's
framing.

## Defect claims, adjudicated

1. **`Het Only` chip never appears.** Confirmed. `SmartFilterTokens.swift`
   returns a hard `false` from `isAvailable` for `.heterozygous`, with the
   reason "Genotype filtering not yet supported". `parameters.yaml:3879`
   lists the chip among the fourteen without saying it is inert. The chapter
   handles it correctly. The registry entry needs a note.
2. **Search Builder queries are rejected by `--filter`.** Confirmed by rerun.
   `filter=PASS`, `DP>=10`, and `pos:1-250000` each fail with "Unsupported
   smart-filter clause". The `variants.query` note at `parameters.yaml:3952`
   saying a sheet query "can be pasted straight into --filter" is false and
   needs correcting. The chapter's command-line section states the
   restriction correctly, but its own Settings entry for Search Builder
   repeats the registry's error, see claim 71.
3. **`Sample[HG002].DP>=1` returns zero.** Confirmed by rerun, 0 records
   against 1,056 rows that all carry `INFO/DP`. The bcftools VCF declares
   `GT:PL:AD` with no per-sample `DP`, so the ingest stores none. Silent
   empty result rather than a warning. The chapter teaches the trap, which is
   the right call for a manual.
4. **`bundle create --variant` writes `.bcf` and `.csi`.** Confirmed on disk,
   and it does contradict the CONSISTENCY sheet as written. See above.
5. **`QueryLogic.matchAny` is rewritten to `matchAll` on preset load.**
   Confirmed. `QueryRule.swift:161-163` hides `matchAny` from `allCases`, and
   `VariantQueryBuilderSheet.swift:224-228` rewrites a loaded `matchAny`
   preset to `matchAll` without telling the user. `applyQuery` at `:244-246`
   logs a warning to the console only. Low severity today since nothing in
   the UI can produce such a preset. The chapter's "Match All is the only
   choice" is accurate.

## What must change before this chapter ships

Four claims are wrong in ways a reader will hit.

1. Claim 54, the Search Builder worked example. A Region value of `1-250000`
   is silently ignored, so the reader gets an unfiltered table and a row
   count that does not match the chapter. This is the only defect in the
   chapter that breaks a procedure the reader is told to follow.
2. Claims 21 and 29, the Inspector showing the consequence. It does not, and
   the shot caption instructs a screenshot that cannot be taken.
3. Claim 71, the Settings entry telling the reader the sheet's text is what
   `--filter` takes. The chapter contradicts itself here, correctly in the
   command-line section and incorrectly in Settings.
4. Claim 83, the genotype counts that leave 18 rows unaccounted for inside a
   sentence claiming agreement.

Claim 51 and claim 45 are smaller but still misdescribe what a reader sees
and where their saved work lives.

## Verdict counts

True 84, false 7, unverifiable 10.
