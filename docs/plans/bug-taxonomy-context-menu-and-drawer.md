# Bug: Taxonomy View Context Menu + Drawer Issues

## Status: Investigation

## Issues
1. Right-click in taxonomy TABLE doesn't show BLAST or NCBI links (only in sunburst)
2. Bottom drawer shows Annotations/Variants/Samples tabs from the annotation drawer
   instead of Collections/BLAST Results from the taxonomy drawer
3. The taxonomy-specific bottom content is obscured by the annotation drawer

## Root Cause Hypothesis
- Issue 1: The NCBI links and BLAST items were added to `showContextMenu(for:at:)`
  in TaxonomyViewController (sunburst right-click) but NOT to the table's
  `buildContextMenu()` in TaxonomyTableView
- Issues 2-3: The annotation drawer (`AnnotationTableDrawerView`) is not being
  hidden when the taxonomy view is displayed, or it's being re-shown
