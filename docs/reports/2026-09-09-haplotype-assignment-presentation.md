# Haplotype assignment presentation and custom overrides

The assigned M2B blocks in AMC1362 and AMC1363 were drawn at half opacity because diagnostic reads made up 293/6348 (4.62%) and 289/6031 (4.79%) of their respective MHC-B totals. Both persisted calls have status `called`. The extra display-only rule used fewer than five reads or less than five percent support, independent of the completed calling workflow.

Assigned calls will use solid haplotype colors irrespective of this display heuristic. Unassigned/error details and diagnostic evidence remain available; pipeline calls and read totals are not rewritten. Explicit analyst overrides retain their audit and provenance markers.

The Inspector will allow a custom haplotype name for either slot, even when definitions contain no choices. Custom entry requires a rationale and acknowledgement before staging, followed by the existing Apply pending action. The detail-sheet arbitrary-name editor uses equivalent safeguards. Names need not occur in the active reference. Original pipeline values remain recoverable through override removal and the audit history.

Validation covers low-read and low-fraction assigned blocks, custom names absent from definitions, intentional staging, and audit persistence. A local Debug build is installed to /Applications after checks.
