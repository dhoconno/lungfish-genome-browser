// AppIcon.swift - App icon resource accessor
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit

/// Provides access to the app icon from LungfishApp's bundled resources
public enum AppIcon {
    /// Returns the app icon image loaded from the bundled resources
    /// Falls back to NSApp.applicationIconImage if the resource cannot be loaded
    public static var image: NSImage {
        if let url = Bundle.module.url(forResource: "about-logo", withExtension: "png", subdirectory: "Images"),
           let image = NSImage(contentsOf: url) {
            return image
        }
        return NSApp.applicationIconImage
    }
}
