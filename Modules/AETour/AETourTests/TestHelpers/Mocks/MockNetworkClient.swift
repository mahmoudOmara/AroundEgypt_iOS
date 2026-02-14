//
//  MockNetworkClient.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import Foundation
@testable import AECore

/// Mock implementation of NetworkClient for testing
/// Allows tests to configure responses and verify method calls
final class MockNetworkClient: NetworkClient {

    // MARK: - Properties

    /// Mock network configuration
    var configuration: NetworkConfiguration = NetworkConfiguration(baseURL: URL(string: "https://test.example.com")!)

    /// Configurable result for network requests
    /// Set this before calling perform() to return specific data or throw errors
    var performResult: Any?

    /// Configurable error to throw
    var performError: NetworkError?

    /// Tracks the last API request made
    var lastRequest: (any APIRequestRepresentable)?

    /// Tracks the last type requested for decoding
    var lastRequestedType: Any.Type?

    /// Number of times perform() was called
    var performCallCount = 0

    // MARK: - NetworkClient Protocol

    func perform<T: Decodable>(_ apiRequest: any APIRequestRepresentable, type: T.Type) async throws(NetworkError) -> T {
        performCallCount += 1
        lastRequest = apiRequest
        lastRequestedType = type

        // Throw error if configured
        if let error = performError {
            throw error
        }

        // Return configured result
        guard let result = performResult else {
            fatalError("performResult not configured in test. Set mockNetworkClient.performResult before calling perform()")
        }

        guard let typedResult = result as? T else {
            fatalError("performResult type mismatch. Expected \(T.self), got \(Swift.type(of: result))")
        }

        return typedResult
    }

    // MARK: - Test Helpers

    /// Resets all tracking variables
    func reset() {
        performResult = nil
        performError = nil
        lastRequest = nil
        lastRequestedType = nil
        performCallCount = 0
    }

    /// Helper to check if a specific API request was made (by comparing paths)
    func wasRequestMade(matching path: String) -> Bool {
        guard let request = lastRequest else { return false }
        return request.path.contains(path)
    }
}
