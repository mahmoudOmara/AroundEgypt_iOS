//
//  Container+Testing.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import Foundation
import FactoryKit
@testable import AETour
@testable import AECore

/// Testing utilities for Factory DI Container
extension Container {

    // MARK: - Setup & Teardown

    /// Resets and configures container for testing
    /// Call this in test setUp() to start with a clean slate
    static func setupTestContainer() {
        shared.reset(options: .all)
    }

    /// Cleans up the container after tests
    /// Call this in test tearDown() to prevent test pollution
    static func tearDownTestContainer() {
        shared.reset(options: .all)
    }

    // MARK: - Common Mock Registration

    /// Registers a MockLogger and returns it
    @discardableResult
    static func registerMockLogger(_ mock: MockLogger = MockLogger()) -> MockLogger {
        shared.logger.register { mock }
        
        return mock
    }

    /// Registers a MockExperienceRepository and returns it
    /// Use this for testing Use Cases that depend on the repository
    @discardableResult
    static func registerMockExperienceRepository(
        _ mock: MockExperienceRepository = MockExperienceRepository()
    ) -> MockExperienceRepository {
        shared.experienceRepository.register { mock }
        return mock
    }

    /// Registers a MockNetworkClient and returns it
    /// Use this for testing components that make API calls
    @discardableResult
    static func registerMockNetworkClient(
        _ mock: MockNetworkClient = MockNetworkClient()
    ) -> MockNetworkClient {
        shared.networkClient.register { mock }
        return mock
    }

    /// Registers an in-memory SwiftDataPersistenceClient for testing
    /// Use this for testing components that interact with local storage
    @discardableResult
    static func registerTestPersistenceClient() throws -> SwiftDataPersistenceClient {
        let testClient = try SwiftDataPersistenceClient.forTesting(
            with: [ExperienceModel.self, CityModel.self]
        )
        shared.persistenceClient.register { testClient }
        return testClient
    }
}
