# BLAST Verification — Implementation Phases

## Phase 2: Data Model + BlastService Actor
**Files**: LungfishCore/Services/BlastService.swift, LungfishCore/Models/BlastResult.swift
- BlastResult model (per-read verdict, summary stats)
- BlastService actor (NCBI BLAST REST API: PUT submit, GET poll, parse results)
- BlastVerificationRequest (taxon, reads, parameters)
- Read subsampling logic (5 longest + 15 random)
- Tests for models + request building

## Phase 3: BLAST Submission + Polling
**Files**: BlastService.swift (implementation)
- Submit via BLAST URL API (CMD=Put, PROGRAM=blastn, DATABASE=nt)
- Organism filter: ENTREZ_QUERY=txid{taxid}[Organism:exp]
- Poll every 15s via CMD=Get with RID
- Parse JSON2 results into BlastResult
- 10-minute timeout
- OperationCenter integration
- Tests for parsing mock BLAST JSON responses

## Phase 4: BLAST Results Drawer Tab
**Files**: LungfishApp/Views/Metagenomics/BlastResultsView.swift
- New tab in bottom drawer (alongside Taxa Collections)
- NSSegmentedControl: Collections | BLAST Results
- Summary bar: "18/20 verified (90%)" with color
- Per-read table: read ID, top hit, % identity, e-value, verdict icon
- Expandable detail rows
- "Open in NCBI BLAST" link

## Phase 5: Integration + Polish
- Right-click "BLAST Matching Reads..." with config popover
- Wire to BlastService from TaxonomyViewController
- CLI: `lungfish blast verify --kreport X --source Y --taxid Z`
- Tests with simulated BLAST responses

## Collision Prevention
- Phase 2: LungfishCore only (no App files)
- Phase 3: LungfishCore only (BlastService implementation)
- Phase 4: LungfishApp only (UI)
- Phase 5: Both (wiring), sequential after 2-4
