# Build Troubleshooting Guide

## Issue: GUI doesn't reflect code changes

### Root Cause
Xcode's SPM integration caches resolved packages and derived data. When new
.swift files are added, Xcode may not discover them until the package graph
is re-resolved.

### Fix Steps (in order)
1. Close Xcode completely
2. Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData/Lungfish-*`
3. Resolve packages: `cd /path/to/project && swift package resolve`
4. Reopen Xcode
5. File → Packages → Resolve Package Versions (wait for completion)
6. Product → Clean Build Folder (Cmd+Shift+K)
7. Product → Build (Cmd+B)

### If "Missing package product" errors appear
The SPM package resolution failed. Fix:
1. File → Packages → Reset Package Caches
2. File → Packages → Resolve Package Versions
3. Wait for all packages to download
4. Build again

### Verifying the build includes new files
Run `swift build` from Terminal first. If it succeeds, the source files
are correct. Xcode just needs to re-discover them.

## CLI Verification Commands

### Kraken2
```bash
micromamba run -n kraken2 kraken2 --version
```

### EsViritu
```bash
micromamba run -n esviritu EsViritu --version
```

### Nextflow (for TaxTriage)
```bash
micromamba run -n nextflow nextflow -version
```

## Conda Environment Path
CRITICAL: The conda root MUST be at `~/.lungfish/conda` as a REAL directory
(not a symlink). If it's a symlink to ~/Library/Application Support/...,
all bioinformatics tools will break due to spaces in the path.

Check: `file ~/.lungfish/conda` should show "directory", not "symbolic link".
