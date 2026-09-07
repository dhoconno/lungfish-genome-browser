# Editor pass: 03-reads/02-downloading-from-sra

Date: 2026-09-06
Chapter: `docs/user-manual/chapters/03-reads/02-downloading-from-sra.md`

Sources are `fidelity.md`, `readers.md`, `CONSISTENCY.md`, the chapter
template in `docs/user-manual/STYLE.md`, and the brand style pass.

## Changes applied

| Location | Change | Reason | Source |
|---|---|---|---|
| Front matter, `shots[0].caption` | "Import Accessions button under the query field" became "above the query field" | Fidelity row 15. The accessory card renders before the search controls | fidelity |
| Front matter, `shots[1].caption` | "the primary button" became "the dialog's primary button at the bottom of the window" | Fidelity row 21. Two controls in the window read Search | fidelity |
| Front matter, `glossary_refs` | `download-center` replaced by `operations-panel` | Fidelity row 27, settled from source by the project manager. `DownloadCenter` is a typealias of `OperationCenter` and no live UI string reads "Download Center" | fidelity |
| Front matter, `glossary_refs` | added `sparkline` and `mitochondrial-genome` | New glossary links introduced by the reader fixes below | readers |
| Front matter, `estimated_reading_min` | 13 became 15 | The chapter grew to about 4,100 words with the reader fixes | template |
| Procedure step 1 | Import Accessions described as sitting above the query field in its own card, query field below it | Fidelity row 15 | fidelity |
| Procedure step 1 | added that the scope popup reads All Fields until changed | Readers, 4 hits. Readers could not find an unlabelled control with no stated default | readers |
| Procedure step 4 | replaced the single-button sentence with three sentences naming both Search controls and saying which one transforms | Fidelity row 21 | fidelity |
| Procedure, after step 5 | "Watch the progress in the Download Center, which is where a download reports rather than the Operations Panel" became the Operations Panel opened with **Operations > Show Operations Panel** (Cmd-Shift-P) | Fidelity row 27, and readers, 4 hits, who were never told how to open the surface | fidelity, readers |
| What it is, accession paragraph | stated the containment order (project holds samples, samples hold experiments, experiments hold runs) before listing the four, and reordered the four from outermost to innermost | Readers, 4 hits | readers |
| What it is, accession paragraph | added that the run and project prefixes record only which partner archive took the deposit | Readers, 3 hits | readers |
| What it is, accession paragraph | glossed "library" as one prepared pool of DNA fragments, not a cloned collection | Readers, 2 hits, one sentence | readers |
| What it is, Database Browser paragraph | "its three panes hold" became "three tabs across the top of it switch between", with the pane named as what sits below | Readers, 3 hits, who could not tell a pane from a tab | readers |
| What it is, arrival paragraph | added "You never open the Import Center yourself in this procedure." | Readers, 3 hits, pointing at an unseen surface | readers |
| What it is, arrival paragraph | "What arrives is not a loose pair of files" became "What arrives is a finished bundle rather than loose files" | Style. The original is close to the banned negation-then-correction shape | style |
| Why you would do this | named the run's mitochondrial target where the run is introduced | Readers, 4 hits, who thought the step 3 search text was wrong | readers |
| Why you would do this | added that 115,776 pairs is an ordinary depth for a single amplicon target | Readers, 4 hits, no frame of reference | readers |
| Why you would do this | split the figures sentence and said the base count already counts both mates | Readers, 3 hits, who arithmetically doubted the chapter | readers |
| Before you start | "Nothing here needs a plugin pack or Docker Desktop, which are optional installs covered in a later chapter" became "No extra software has to be installed for this chapter." | Readers, 4 hits. Naming tools only to dismiss them read as a missed setup step | readers |
| Procedure step 2 | "Click Show" became "Click the Show button" | Readers, 3 hits, who could not tell button from disclosure triangle | readers |
| Procedure step 3 | added that the query text matches the run's mitochondrial target | Readers, 4 hits | readers |
| Procedure step 4 | added the narrowing route, scope popup to Accession then search the accession | Readers, 3 hits, finding one row among 238 | readers |
| Procedure step 5 | "Confirm those two settings" became "Read those two values, check that they match what you expect" | Readers, 4 hits, who did not know what confirming required | readers |
| Downloading a list of accessions | added an example file layout, one accession per line, no header row, with two sample lines | Readers, 4 hits | readers |
| Settings lead-in | added that the command line is optional throughout the chapter | Readers, 2 hits, one sentence | readers |
| Settings, **Platform.** | named OXFORD_NANOPORE and PACBIO_SMRT as the long-read families | Readers, 4 hits | readers |
| Settings, **Strategy.** | expanded WXS as whole-exome shotgun beside WGS | Readers, 4 hits | readers |
| Settings, **Min Size (Mbases).** | anchored the example floor to this chapter's run, about 35 million bases | Readers, 4 hits | readers |
| Settings, **Max Results.** | added that the dialog and command-line defaults differ deliberately | Readers, 2 hits, one sentence | readers |
| Reading the results, Reads column | glossed spot as the archive's word for one fragment read end to end, and walked spots to pairs to reads | Readers, 4 hits. Spot has no `GLOSSARY.md` anchor, so it is glossed in the body only | readers |
| Reading the results, Size column | gave 12.8 MB and 15.3 MB beside the byte counts, and named about 28 MB as the figure to trust | Readers, 3 hits and 2 hits | readers |
| Reading the results, `fetch sra info` | "it printed exactly thirteen fields" became a statement that the same labelled fields print for every run | Readers, 3 hits, who counted the fields and could not tell why | readers |
| Reading the results, viewport | linked and glossed sparkline as a small chart drawn inline with no axes of its own | Readers, 4 hits | readers |
| Reading the results, viewport | said plainly that the single Length Dist. spike is expected and not a warning sign | Readers, 3 hits | readers |
| Reading the results, sidecars | split the two sidecars into separate sentences saying what each records, and named the Inspector's Provenance section as where to read the history | Readers, 4 hits | readers |
| What good looks like, read count | said the Reads card counts individual reads and should read 231,552, twice the archive spot figure | Readers, 4 hits | readers |
| What good looks like, pairing | "A bundle half the expected size" became a Reads card reading 115,776 rather than 231,552 | Readers, 3 hits. The FASTQ Inspector shows no file size, so the check was recast onto a number the reader can actually see | readers |
| Which path served your download | added that LGE installs `prefetch` and `fasterq-dump` in its managed SRA Toolkit environment | Readers, 3 hits. Confirmed against `third-party-tools-lock.json`, which pins `sra-tools` 3.4.1 with both executables | readers |
| Which path served your download, sidecar paragraph | named the Inspector's Provenance section as where `selectedStrategy` is read, and glossed `curl` as the standard file-transfer program | Readers, 3 hits | readers |
| Troubleshooting, rate limits | said HTTP 429 means too many requests, and named View Log on the download's row in the Operations Panel | Readers, 4 hits | readers |
| Troubleshooting, rate limits | said to start the download again from the SRA Runs pane where the retry control is absent | Readers, 3 hits | readers |
| Troubleshooting, rate limits | said the NCBI key is free, optional, and for heavy use | Readers, 3 hits | readers |
| Troubleshooting, metadata | said interleaved means the two mates alternate down one file | Readers, 3 hits | readers |
| Troubleshooting, metadata | "The run page on NCBI's web archive viewer" became searching the accession on the NCBI website to reach the run page | Readers, 2 hits, one sentence | readers |
| Reaching ENA directly | "its File Size of 28.1 MB is the honest figure" became the delivered size that the two files add up to, and the one to trust | Readers, 2 hits, three size figures for one run | readers, style |

## Deliberately left unchanged

The "spot" term is glossed in the body but not added to `glossary_refs`,
because `GLOSSARY.md` has no `spot` anchor and this role does not edit
`GLOSSARY.md`. Adding the ref would fail `frontmatter.js`.

No factual claim outside fidelity rows 15, 21, and 27 was altered. Every
other row in `fidelity.md` verified true and its wording stands.

## Status

brand_reviewed: false
lead_approved: false
