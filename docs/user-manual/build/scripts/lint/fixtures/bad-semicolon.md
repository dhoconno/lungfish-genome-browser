---
title: Semicolon fixture
chapter_id: 99-test/bad-semicolon
audience: bench-scientist
prereqs: []
estimated_reading_min: 3
shots: []
glossary_refs: []
features_refs: []
fixtures_refs: []
brand_reviewed: false
lead_approved: false
---

## What it is

Reads are short; they need mapping.

Here is code that is fine: `a; b` and a block:

```bash
samtools sort in.bam; samtools index out.bam
```

## Procedure

1. Open the file; then wait.
