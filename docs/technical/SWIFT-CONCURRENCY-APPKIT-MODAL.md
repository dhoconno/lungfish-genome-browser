# Swift Concurrency and AppKit Modal Sessions

## Problem Description

When using Swift's async/await concurrency with AppKit modal sessions (sheets, modal dialogs), async work can become blocked and never execute. This manifests as:

- `Task { }` bodies never executing
- `DispatchQueue.main.async` blocks never firing
- UI stuck on loading indicators indefinitely

## Root Cause

During AppKit modal transitions (e.g., sheet dismissal via `window.endSheet()`), the main thread's run loop enters a special modal state. In this state:

1. **Swift concurrency's MainActor executor** may not process scheduled tasks because its scheduling queue isn't being drained during modal transitions.

2. **GCD's main queue** (`DispatchQueue.main.async`) can also be blocked because GCD's main queue serialization may be stalled during modal run loop states.

3. **Even `Task.detached`** doesn't fully solve the problem because any `await` on `@MainActor`-isolated code (like `DocumentManager.shared.loadDocument()`) requires hopping to MainActor, which is blocked.

## The Solution

### 1. Use Pure GCD Background Threads for File I/O

Avoid Swift async/await entirely for the critical code path. Use `DispatchQueue.global(qos:).async` for background work:

```swift
private func loadFileInBackground(at url: URL, completion: @escaping @Sendable (FileLoadResult) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
        // Synchronous file parsing here - no async/await, no MainActor
        let result = parseFileSynchronously(url)
        completion(result)
    }
}
```

### 2. Use CFRunLoopPerformBlock for MainActor Work

`CFRunLoopPerformBlock` with `kCFRunLoopCommonModes` bypasses GCD completely and schedules directly to the run loop:

```swift
private func scheduleOnMainRunLoop(_ block: @escaping @MainActor @Sendable () -> Void) {
    CFRunLoopPerformBlock(CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue) {
        MainActor.assumeIsolated {
            block()
        }
    }
    // Wake up the run loop to process the block immediately
    CFRunLoopWakeUp(CFRunLoopGetMain())
}
```

### 3. Avoid @MainActor-Isolated Code in Critical Paths

If your `DocumentManager` or similar classes are `@MainActor`-isolated, create synchronous parsing functions that don't require actor isolation:

```swift
// BAD: Requires MainActor hop
let document = try await DocumentManager.shared.loadDocument(at: url)

// GOOD: Synchronous parsing, no MainActor required
let records = try loadGenBankSync(from: url)  // Pure function, no actor
scheduleOnMainRunLoop {
    // Create UI objects on MainActor
    let document = LoadedDocument(url: url, type: .genbank)
    document.sequences = records.map { $0.sequence }
    viewerController?.displayDocument(document)
}
```

## What Doesn't Work

### Task { } from Sheet Completion Handler
```swift
// BROKEN: Task body may never execute
window.beginSheet(sheet) { _ in
    Task {
        // This may never run!
        let doc = try await loadDocument()
    }
}
```

### Task.detached with @MainActor Await
```swift
// BROKEN: await blocks on MainActor
window.beginSheet(sheet) { _ in
    Task.detached {
        // This starts...
        let doc = try await mainActorIsolatedFunction()  // Blocks here!
    }
}
```

### DispatchQueue.main.async
```swift
// BROKEN: GCD main queue may be stalled
DispatchQueue.global().async {
    let data = parseFile()
    DispatchQueue.main.async {
        // This may never execute during modal transitions!
        updateUI(data)
    }
}
```

## Complete Working Pattern

```swift
// Sheet completion handler
window.beginSheet(browserWindow) { [weak self] _ in
    if let tempURL = self?.pendingDownloadURL {
        self?.handleDownload(at: tempURL)
    }
}

private func handleDownload(at url: URL) {
    // 1. Copy file synchronously (we're already on main thread)
    let destURL = copyFile(from: url)

    // 2. Parse on background thread using GCD (no Swift concurrency)
    loadFileInBackground(at: destURL) { result in

        // 3. Update UI via CFRunLoopPerformBlock
        scheduleOnMainRunLoop { [weak self] in
            let document = LoadedDocument(url: result.url, type: result.type)
            document.sequences = result.sequences
            self?.viewerController?.displayDocument(document)
        }
    }
}
```

## Key Takeaways

1. **Swift async/await and GCD can both block during AppKit modal transitions**
2. **CFRunLoopPerformBlock with commonModes is the reliable escape hatch**
3. **Keep synchronous parsing functions that don't require MainActor**
4. **Use the run loop directly instead of going through GCD for modal-safe scheduling**

## References

- [Swift Forums: MainActor and modal windows](https://forums.swift.org/t/mainactor-and-modal-windows/61744)
- [Apple Documentation: CFRunLoopPerformBlock](https://developer.apple.com/documentation/corefoundation/1542011-cfrunloopperformblock)
- [AppKit Run Loop Modes](https://developer.apple.com/documentation/foundation/runloop/mode)
