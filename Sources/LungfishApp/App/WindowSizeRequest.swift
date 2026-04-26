// WindowSizeRequest.swift - Point-based app window sizing helpers
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit

@MainActor
struct WindowSizeRequest {
    let widthText: String
    let heightText: String

    var contentSize: NSSize? {
        guard let width = Self.parsePointValue(widthText),
              let height = Self.parsePointValue(heightText) else {
            return nil
        }
        return NSSize(width: width, height: height)
    }

    static func apply(_ requestedContentSize: NSSize, to window: NSWindow) {
        let contentSize = NSSize(
            width: max(requestedContentSize.width, window.minSize.width),
            height: max(requestedContentSize.height, window.minSize.height)
        )

        var contentRect = window.contentRect(forFrameRect: window.frame)
        let currentMaxY = contentRect.maxY
        contentRect.size = contentSize
        contentRect.origin.y = currentMaxY - contentSize.height

        let frame = window.frameRect(forContentRect: contentRect)
        window.setFrame(frame, display: true, animate: true)
    }

    private static func parsePointValue(_ text: String) -> CGFloat? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Double(trimmed), value > 0, value.isFinite else {
            return nil
        }
        return CGFloat(value.rounded())
    }
}
