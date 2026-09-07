---
title: Settings-coverage fixture
chapter_id: 99-test/bad-settings-coverage
audience: bench-scientist
prereqs: []
estimated_reading_min: 3
shots: []
glossary_refs: []
features_refs: []
fixtures_refs: []
brand_reviewed: false
lead_approved: false
parameters_refs: [test.trim, test.missing]
---

## What it is

Lungfish Genome Explorer trims reads.

## Settings

**Minimum length.** Drops reads shorter than this. Default 50. Change it for very short amplicons.

**Quality cutoff**. Trims bases below this score. Default 20. Rarely changed.
