//
//  MockLogger.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import Foundation
@testable import AECore

/// Mock implementation of Logger for testing
/// Captures all log messages for verification in tests
final class MockLogger: Logger {

    // MARK: - Properties

    /// All captured log entries
    var logs: [(message: String, level: LogLevel)] = []

    /// Captured debug messages
    var debugMessages: [String] {
        logs.filter { $0.level == .debug }.map { $0.message }
    }

    /// Captured info messages
    var infoMessages: [String] {
        logs.filter { $0.level == .info }.map { $0.message }
    }

    /// Captured warning messages
    var warningMessages: [String] {
        logs.filter { $0.level == .warning }.map { $0.message }
    }

    /// Captured error messages
    var errorMessages: [String] {
        logs.filter { $0.level == .error }.map { $0.message }
    }

    /// Minimum log level (always .debug for testing)
    var minLevel: LogLevel = .debug

    // MARK: - Logger Protocol

    func log(_ message: String, level: LogLevel, file: String, function: String, line: Int) {
        logs.append((message, level))
    }

    // MARK: - Test Helpers

    /// Clears all captured logs
    func clear() {
        logs.removeAll()
    }

    /// Checks if a message was logged at a specific level
    func contains(_ message: String, level: LogLevel) -> Bool {
        logs.contains { $0.message.contains(message) && $0.level == level }
    }

    /// Checks if any error message contains the given string
    func containsError(_ message: String) -> Bool {
        errorMessages.contains { $0.contains(message) }
    }

    /// Checks if any info message contains the given string
    func containsInfo(_ message: String) -> Bool {
        infoMessages.contains { $0.contains(message) }
    }
}
