// DbCommand.swift - CLI commands for managing metagenomics databases
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import ArgumentParser
import Foundation
import LungfishWorkflow
import LungfishCore

/// Manage metagenomics reference databases.
///
/// List, download, remove, and get recommendations for Kraken2 databases
/// used in taxonomic classification.
///
/// ## Examples
///
/// ```
/// lungfish conda db list
/// lungfish conda db download Viral
/// lungfish conda db remove Standard-8
/// lungfish conda db recommend
/// ```
struct DbCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "db",
        abstract: "Manage metagenomics reference databases",
        discussion: """
        Manage Kraken2 databases for taxonomic classification. Databases are
        downloaded from Ben Langmead's pre-built index collection and stored
        in ~/.lungfish/databases/kraken2/.
        """,
        subcommands: [
            DbListSubcommand.self,
            DbDownloadSubcommand.self,
            DbRemoveSubcommand.self,
            DbRecommendSubcommand.self,
        ]
    )
}

// MARK: - db list

extension DbCommand {

    /// Lists available and installed metagenomics databases.
    struct DbListSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "list",
            abstract: "List available and installed databases"
        )

        @OptionGroup var globalOptions: GlobalOptions

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let registry = MetagenomicsDatabaseRegistry.shared

            let databases = try await registry.availableDatabases()

            if databases.isEmpty {
                print(formatter.info("No databases registered."))
                return
            }

            print(formatter.header("Metagenomics Databases (\(databases.count))"))
            print("")

            let rows = databases.map { db -> [String] in
                let sizeGB = String(format: "%.1f GB", Double(db.sizeBytes) / 1_073_741_824)
                let ramGB = String(format: "%.0f GB", Double(db.recommendedRAM) / 1_073_741_824)
                return [db.name, db.status.rawValue, sizeGB, ramGB, db.description]
            }

            print(formatter.table(
                headers: ["Name", "Status", "Size", "RAM", "Description"],
                rows: rows
            ))
        }
    }
}

// MARK: - db download

extension DbCommand {

    /// Downloads a database from the built-in catalog.
    struct DbDownloadSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "download",
            abstract: "Download a database from the catalog"
        )

        @Argument(help: "Database name (e.g., 'Viral', 'Standard-8', 'PlusPF')")
        var name: String

        @OptionGroup var globalOptions: GlobalOptions

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let registry = MetagenomicsDatabaseRegistry.shared

            guard let db = try await registry.database(named: name) else {
                print(formatter.error("Database '\(name)' not found in catalog"))
                print(formatter.info("Use 'lungfish conda db list' to see available databases"))
                throw ExitCode.failure
            }

            if db.status == .ready {
                print(formatter.success("Database '\(name)' is already installed"))
                if let path = db.path {
                    print(formatter.info("Location: \(path.path)"))
                }
                return
            }

            let sizeGB = String(format: "%.1f GB", Double(db.sizeBytes) / 1_073_741_824)
            print(formatter.header("Downloading Database: \(name)"))
            print(formatter.info("Size: \(sizeGB)"))
            print("")

            let _ = try await registry.downloadDatabase(name: name) { fraction, message in
                if !globalOptions.quiet {
                    print("\r\(formatter.info(message))", terminator: "")
                }
            }

            print("")
            print(formatter.success("Database '\(name)' downloaded and verified"))
        }
    }
}

// MARK: - db remove

extension DbCommand {

    /// Removes a database from the registry.
    struct DbRemoveSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "remove",
            abstract: "Remove a database from the registry"
        )

        @Argument(help: "Database name to remove")
        var name: String

        @Flag(name: .customLong("delete-files"), help: "Also delete database files from disk")
        var deleteFiles: Bool = false

        @OptionGroup var globalOptions: GlobalOptions

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let registry = MetagenomicsDatabaseRegistry.shared

            guard let db = try await registry.database(named: name) else {
                print(formatter.error("Database '\(name)' not found"))
                throw ExitCode.failure
            }

            if deleteFiles, let path = db.path {
                print(formatter.info("Removing database files at \(path.path)..."))
                try? FileManager.default.removeItem(at: path)
            }

            try await registry.removeDatabase(name: name)
            print(formatter.success("Database '\(name)' removed from registry"))
        }
    }
}

// MARK: - db recommend

extension DbCommand {

    /// Shows the recommended database for this system's RAM.
    struct DbRecommendSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "recommend",
            abstract: "Show recommended database for this system"
        )

        @OptionGroup var globalOptions: GlobalOptions

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let registry = MetagenomicsDatabaseRegistry.shared

            let ram = ProcessInfo.processInfo.physicalMemory
            let ramGB = String(format: "%.0f", Double(ram) / 1_073_741_824)

            let recommended = try await registry.recommendedDatabase()

            print(formatter.header("Database Recommendation"))
            print("")
            print(formatter.keyValueTable([
                ("System RAM", "\(ramGB) GB"),
                ("Recommended DB", recommended.name),
                ("DB Size", String(format: "%.1f GB", Double(recommended.sizeBytes) / 1_073_741_824)),
                ("Required RAM", String(format: "%.0f GB", Double(recommended.recommendedRAM) / 1_073_741_824)),
                ("Description", recommended.description),
                ("Status", recommended.status.rawValue),
            ]))

            if !recommended.isDownloaded {
                print("")
                print(formatter.info("Download with: lungfish conda db download \(recommended.name)"))
            }
        }
    }
}
