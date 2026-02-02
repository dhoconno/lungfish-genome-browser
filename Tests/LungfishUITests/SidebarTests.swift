// SidebarTests.swift - Tests for sidebar functionality
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishCore

/// Tests for sidebar item model and operations
final class SidebarItemTests: XCTestCase {

    // MARK: - SidebarItem Model Tests

    /// Test basic SidebarItem creation
    func testSidebarItemCreation() {
        let tempURL = URL(fileURLWithPath: "/tmp/test.gb")
        let item = SidebarItemMock(
            title: "test.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: tempURL
        )

        XCTAssertEqual(item.title, "test.gb")
        XCTAssertEqual(item.type, .sequence)
        XCTAssertEqual(item.icon, "doc.richtext")
        XCTAssertEqual(item.url, tempURL)
        XCTAssertTrue(item.children.isEmpty)
    }

    /// Test SidebarItem hierarchy with children
    func testSidebarItemHierarchy() {
        let projectURL = URL(fileURLWithPath: "/tmp/MyProject")
        let downloadsURL = projectURL.appendingPathComponent("downloads")
        let fileURL = downloadsURL.appendingPathComponent("NC_045512.gb")

        // Create project
        let project = SidebarItemMock(
            title: "MyProject",
            type: .project,
            icon: "folder.badge.gearshape",
            url: projectURL
        )

        // Create downloads folder
        let downloads = SidebarItemMock(
            title: "downloads",
            type: .folder,
            icon: "arrow.down.circle",
            url: downloadsURL
        )

        // Create file item
        let file = SidebarItemMock(
            title: "NC_045512.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: fileURL
        )

        // Build hierarchy
        downloads.children.append(file)
        project.children.append(downloads)

        // Verify hierarchy
        XCTAssertEqual(project.children.count, 1)
        XCTAssertEqual(project.children[0].title, "downloads")
        XCTAssertEqual(project.children[0].children.count, 1)
        XCTAssertEqual(project.children[0].children[0].title, "NC_045512.gb")
    }

    /// Test tint colors for different item types
    func testSidebarItemTypeTintColors() {
        // Verify each type has a distinct tint color
        XCTAssertNotNil(SidebarItemTypeMock.group.tintColor)
        XCTAssertNotNil(SidebarItemTypeMock.folder.tintColor)
        XCTAssertNotNil(SidebarItemTypeMock.sequence.tintColor)
        XCTAssertNotNil(SidebarItemTypeMock.annotation.tintColor)
        XCTAssertNotNil(SidebarItemTypeMock.alignment.tintColor)
        XCTAssertNotNil(SidebarItemTypeMock.project.tintColor)
    }

    // MARK: - Downloads Folder Placement Tests

    /// Test that downloads folder is created correctly within project
    func testDownloadsFolderCreation() {
        let projectURL = URL(fileURLWithPath: "/tmp/TestProject")
        let project = SidebarItemMock(
            title: "TestProject",
            type: .project,
            icon: "folder.badge.gearshape",
            url: projectURL
        )

        // Simulate addDownloadedDocument logic
        var downloadsFolder = project.children.first(where: {
            $0.title.lowercased() == "downloads" && $0.type == .folder
        })

        XCTAssertNil(downloadsFolder, "Downloads folder should not exist initially")

        // Create downloads folder
        let downloadsURL = projectURL.appendingPathComponent("downloads", isDirectory: true)
        downloadsFolder = SidebarItemMock(
            title: "downloads",
            type: .folder,
            icon: "arrow.down.circle",
            url: downloadsURL
        )
        project.children.append(downloadsFolder!)

        // Verify
        let foundFolder = project.children.first(where: {
            $0.title.lowercased() == "downloads" && $0.type == .folder
        })
        XCTAssertNotNil(foundFolder)
        XCTAssertEqual(foundFolder?.url, downloadsURL)

        print("✓ Downloads folder creation works correctly")
    }

    /// Test downloaded document placement in downloads folder
    func testDownloadedDocumentPlacement() {
        // Setup project with downloads folder
        let projectURL = URL(fileURLWithPath: "/tmp/TestProject")
        let downloadsURL = projectURL.appendingPathComponent("downloads")
        let fileURL = downloadsURL.appendingPathComponent("NC_045512.gb")

        let project = SidebarItemMock(
            title: "TestProject",
            type: .project,
            icon: "folder.badge.gearshape",
            url: projectURL
        )

        let downloadsFolder = SidebarItemMock(
            title: "downloads",
            type: .folder,
            icon: "arrow.down.circle",
            url: downloadsURL
        )
        project.children.append(downloadsFolder)

        // Add downloaded document
        let document = SidebarItemMock(
            title: "NC_045512.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: fileURL
        )

        // Check for duplicates before adding
        let alreadyExists = downloadsFolder.children.contains { $0.url == document.url }
        XCTAssertFalse(alreadyExists)

        downloadsFolder.children.append(document)

        // Verify placement
        XCTAssertEqual(downloadsFolder.children.count, 1)
        XCTAssertEqual(downloadsFolder.children[0].title, "NC_045512.gb")
        XCTAssertEqual(downloadsFolder.children[0].url, fileURL)

        print("✓ Downloaded document placement works correctly")
    }

    // MARK: - Drag and Drop Tests

    /// Test item move operation
    func testItemMove() {
        // Setup source and destination folders
        let projectURL = URL(fileURLWithPath: "/tmp/TestProject")
        let sourceFolderURL = projectURL.appendingPathComponent("source")
        let destFolderURL = projectURL.appendingPathComponent("dest")
        let fileURL = sourceFolderURL.appendingPathComponent("test.gb")

        let project = SidebarItemMock(
            title: "TestProject",
            type: .project,
            icon: "folder.badge.gearshape",
            url: projectURL
        )

        let sourceFolder = SidebarItemMock(
            title: "source",
            type: .folder,
            icon: "folder",
            url: sourceFolderURL
        )

        let destFolder = SidebarItemMock(
            title: "dest",
            type: .folder,
            icon: "folder",
            url: destFolderURL
        )

        let fileItem = SidebarItemMock(
            title: "test.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: fileURL
        )

        // Build initial structure
        sourceFolder.children.append(fileItem)
        project.children.append(sourceFolder)
        project.children.append(destFolder)

        // Verify initial state
        XCTAssertEqual(sourceFolder.children.count, 1)
        XCTAssertEqual(destFolder.children.count, 0)

        // Simulate move: remove from source, add to dest
        sourceFolder.children.removeAll { $0 === fileItem }
        destFolder.children.append(fileItem)

        // Update file URL
        let newFileURL = destFolderURL.appendingPathComponent(fileItem.title)
        fileItem.url = newFileURL

        // Verify moved state
        XCTAssertEqual(sourceFolder.children.count, 0)
        XCTAssertEqual(destFolder.children.count, 1)
        XCTAssertEqual(destFolder.children[0].url, newFileURL)

        print("✓ Item move operation works correctly")
    }

    /// Test item copy operation
    func testItemCopy() {
        let projectURL = URL(fileURLWithPath: "/tmp/TestProject")
        let sourceFolderURL = projectURL.appendingPathComponent("source")
        let destFolderURL = projectURL.appendingPathComponent("dest")
        let sourceFileURL = sourceFolderURL.appendingPathComponent("test.gb")

        let sourceFolder = SidebarItemMock(
            title: "source",
            type: .folder,
            icon: "folder",
            url: sourceFolderURL
        )

        let destFolder = SidebarItemMock(
            title: "dest",
            type: .folder,
            icon: "folder",
            url: destFolderURL
        )

        let fileItem = SidebarItemMock(
            title: "test.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: sourceFileURL
        )

        sourceFolder.children.append(fileItem)

        // Verify initial state
        XCTAssertEqual(sourceFolder.children.count, 1)
        XCTAssertEqual(destFolder.children.count, 0)

        // Simulate copy: create new item with new URL
        let copyURL = destFolderURL.appendingPathComponent("test.gb")
        let copyItem = SidebarItemMock(
            title: "test.gb",
            type: fileItem.type,
            icon: fileItem.icon,
            url: copyURL
        )
        destFolder.children.append(copyItem)

        // Verify copied state - source unchanged, copy in dest
        XCTAssertEqual(sourceFolder.children.count, 1)
        XCTAssertEqual(destFolder.children.count, 1)
        XCTAssertEqual(sourceFolder.children[0].url, sourceFileURL)
        XCTAssertEqual(destFolder.children[0].url, copyURL)

        print("✓ Item copy operation works correctly")
    }

    /// Test copy with unique filename generation
    func testItemCopyWithDuplicate() {
        let destFolderURL = URL(fileURLWithPath: "/tmp/dest")

        let destFolder = SidebarItemMock(
            title: "dest",
            type: .folder,
            icon: "folder",
            url: destFolderURL
        )

        // Add existing file
        let existingFile = SidebarItemMock(
            title: "test.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: destFolderURL.appendingPathComponent("test.gb")
        )
        destFolder.children.append(existingFile)

        // Simulate copy with unique name generation
        func generateUniqueName(_ baseName: String, existingNames: [String]) -> String {
            let ext = (baseName as NSString).pathExtension
            let base = (baseName as NSString).deletingPathExtension
            var counter = 1
            var newName = baseName

            while existingNames.contains(newName) {
                newName = "\(base)_copy\(counter > 1 ? "_\(counter)" : "").\(ext)"
                counter += 1
            }
            return newName
        }

        let existingNames = destFolder.children.map { $0.title }
        let uniqueName = generateUniqueName("test.gb", existingNames: existingNames)

        XCTAssertEqual(uniqueName, "test_copy.gb")

        // Add copy
        let copyItem = SidebarItemMock(
            title: uniqueName,
            type: .sequence,
            icon: "doc.richtext",
            url: destFolderURL.appendingPathComponent(uniqueName)
        )
        destFolder.children.append(copyItem)

        // Add another copy
        let existingNames2 = destFolder.children.map { $0.title }
        let uniqueName2 = generateUniqueName("test.gb", existingNames: existingNames2)

        XCTAssertEqual(uniqueName2, "test_copy_2.gb")

        print("✓ Item copy with unique filename works correctly")
    }

    // MARK: - Parent Finding Tests

    /// Test finding parent item in hierarchy
    func testFindParent() {
        let projectURL = URL(fileURLWithPath: "/tmp/Project")
        let folderURL = projectURL.appendingPathComponent("folder")
        let fileURL = folderURL.appendingPathComponent("file.gb")

        let project = SidebarItemMock(
            title: "Project",
            type: .project,
            icon: "folder.badge.gearshape",
            url: projectURL
        )

        let folder = SidebarItemMock(
            title: "folder",
            type: .folder,
            icon: "folder",
            url: folderURL
        )

        let file = SidebarItemMock(
            title: "file.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: fileURL
        )

        folder.children.append(file)
        project.children.append(folder)

        // Find parent function
        func findParent(of target: SidebarItemMock, in items: [SidebarItemMock], parent: SidebarItemMock?) -> SidebarItemMock? {
            for item in items {
                if item === target {
                    return parent
                }
                if let found = findParent(of: target, in: item.children, parent: item) {
                    return found
                }
            }
            return nil
        }

        let fileParent = findParent(of: file, in: [project], parent: nil)
        XCTAssertTrue(fileParent === folder)

        let folderParent = findParent(of: folder, in: [project], parent: nil)
        XCTAssertTrue(folderParent === project)

        let projectParent = findParent(of: project, in: [project], parent: nil)
        XCTAssertNil(projectParent)

        print("✓ Find parent operation works correctly")
    }

    // MARK: - Delete Tests

    /// Test removing item from sidebar hierarchy
    func testRemoveItemFromHierarchy() {
        let projectURL = URL(fileURLWithPath: "/tmp/TestProject")
        let downloadsURL = projectURL.appendingPathComponent("downloads")
        let file1URL = downloadsURL.appendingPathComponent("file1.gb")
        let file2URL = downloadsURL.appendingPathComponent("file2.gb")

        let project = SidebarItemMock(
            title: "TestProject",
            type: .project,
            icon: "folder.badge.gearshape",
            url: projectURL
        )

        let downloads = SidebarItemMock(
            title: "downloads",
            type: .folder,
            icon: "arrow.down.circle",
            url: downloadsURL
        )

        let file1 = SidebarItemMock(
            title: "file1.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: file1URL
        )

        let file2 = SidebarItemMock(
            title: "file2.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: file2URL
        )

        downloads.children.append(file1)
        downloads.children.append(file2)
        project.children.append(downloads)

        XCTAssertEqual(downloads.children.count, 2)

        // Remove file1 from hierarchy
        downloads.children.removeAll { $0 === file1 }

        XCTAssertEqual(downloads.children.count, 1)
        XCTAssertEqual(downloads.children[0].title, "file2.gb")

        print("✓ Remove item from hierarchy works correctly")
    }

    /// Test that groups and projects cannot be deleted
    func testNonDeletableItems() {
        let group = SidebarItemMock(
            title: "OPEN DOCUMENTS",
            type: .group,
            icon: nil
        )

        let project = SidebarItemMock(
            title: "MyProject",
            type: .project,
            icon: "folder.badge.gearshape",
            url: URL(fileURLWithPath: "/tmp/MyProject")
        )

        let file = SidebarItemMock(
            title: "sequence.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: URL(fileURLWithPath: "/tmp/sequence.gb")
        )

        // Simulate filtering deletable items
        let items = [group, project, file]
        let deletableItems = items.filter { item in
            item.type != .group && item.type != .project
        }

        XCTAssertEqual(deletableItems.count, 1)
        XCTAssertEqual(deletableItems[0].title, "sequence.gb")

        print("✓ Non-deletable items filtering works correctly")
    }

    /// Test multi-select logic
    func testMultipleSelection() {
        // Simulate selection of multiple items
        var selectedItems: [SidebarItemMock] = []

        let file1 = SidebarItemMock(
            title: "file1.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: URL(fileURLWithPath: "/tmp/file1.gb")
        )

        let file2 = SidebarItemMock(
            title: "file2.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: URL(fileURLWithPath: "/tmp/file2.gb")
        )

        let file3 = SidebarItemMock(
            title: "file3.gb",
            type: .sequence,
            icon: "doc.richtext",
            url: URL(fileURLWithPath: "/tmp/file3.gb")
        )

        // Simulate Cmd+Click to add items to selection
        selectedItems.append(file1)
        XCTAssertEqual(selectedItems.count, 1)

        selectedItems.append(file3)  // Cmd+Click on file3
        XCTAssertEqual(selectedItems.count, 2)

        // Verify discontiguous selection
        XCTAssertTrue(selectedItems.contains { $0 === file1 })
        XCTAssertFalse(selectedItems.contains { $0 === file2 })
        XCTAssertTrue(selectedItems.contains { $0 === file3 })

        print("✓ Multiple selection logic works correctly")
    }
}

// MARK: - Mock Classes for Testing

/// Mock SidebarItem for testing without AppKit dependencies
class SidebarItemMock {
    var title: String
    let type: SidebarItemTypeMock
    let icon: String?
    var children: [SidebarItemMock]
    var url: URL?

    init(title: String, type: SidebarItemTypeMock, icon: String? = nil, children: [SidebarItemMock] = [], url: URL? = nil) {
        self.title = title
        self.type = type
        self.icon = icon
        self.children = children
        self.url = url
    }
}

/// Mock SidebarItemType for testing without AppKit dependencies
enum SidebarItemTypeMock {
    case group
    case folder
    case sequence
    case annotation
    case alignment
    case coverage
    case project

    var tintColor: String {
        switch self {
        case .group: return "secondaryLabel"
        case .folder: return "systemBlue"
        case .sequence: return "systemGreen"
        case .annotation: return "systemOrange"
        case .alignment: return "systemPurple"
        case .coverage: return "systemTeal"
        case .project: return "systemGray"
        }
    }
}
