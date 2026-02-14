//
//  ExperienceLocalDataSourceTests.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import XCTest
import FactoryKit
@testable import AETour
@testable import AECore

final class ExperienceLocalDataSourceTests: XCTestCase {

    // MARK: - Properties

    var sut: ExperienceLocalDataSource!
    var persistenceClient: SwiftDataPersistenceClient!
    var mockLogger: MockLogger!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        Container.setupTestContainer()

        do {
            persistenceClient = try Container.registerTestPersistenceClient()
        } catch {
            XCTFail("Failed to create test persistence client: \(error)")
            return
        }

        mockLogger = Container.registerMockLogger()
        sut = ExperienceLocalDataSource()
    }

    override func tearDown() {
        sut = nil
        persistenceClient = nil
        mockLogger = nil
        Container.tearDownTestContainer()
        super.tearDown()
    }

    // MARK: - Read Tests

    func testGetRecommendedExperiences_ReturnsOnlyRecommendedModels() async throws {
        // Given
        let recommended = ExperienceModelFixtures.createRecommendedModels().experiences
        let nonRecommended = ExperienceModelFixtures.createAlexandriaLibraryModel()
        try await sut.saveExperiences(recommended + [nonRecommended])

        // When
        let result = try await sut.getRecommendedExperiences()

        // Then
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result.allSatisfy { $0.isRecommended })
        XCTAssertTrue(mockLogger.containsInfo("Fetching recommended experiences from cache"))
    }

    func testGetRecentExperiences_ReturnsAllCachedModels() async throws {
        // Given
        let all = ExperienceModelFixtures.createAllModels().experiences
        try await sut.saveExperiences(all)

        // When
        let result = try await sut.getRecentExperiences()

        // Then
        XCTAssertEqual(result.count, all.count)
        XCTAssertTrue(mockLogger.containsInfo("Fetching recent experiences from cache"))
    }

    func testGetExperienceById_WithExistingID_ReturnsModel() async throws {
        // Given
        let model = ExperienceModelFixtures.createPyramidsModel()
        try await sut.saveExperiences([model])

        // When
        let result = try await sut.getExperienceById("1")

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, "1")
        XCTAssertEqual(result?.title, "Great Pyramids of Giza")
    }

    func testGetExperienceById_WithMissingID_ReturnsNil() async throws {
        // Given
        let model = ExperienceModelFixtures.createPyramidsModel()
        try await sut.saveExperiences([model])

        // When
        let result = try await sut.getExperienceById("missing")

        // Then
        XCTAssertNil(result)
    }

    // MARK: - Write Tests

    func testSaveExperiences_WithSharedCity_DeduplicatesCityInPersistence() async throws {
        // Given
        let cairo = ExperienceModelFixtures.createCairoCity()
        let pyramids = ExperienceModelFixtures.createPyramidsModel(city: cairo)
        let sphinx = ExperienceModelFixtures.createSphinxModel(city: cairo)

        // When
        try await sut.saveExperiences([pyramids, sphinx])

        // Then
        let cityCount = try await MainActor.run {
            try persistenceClient.count(of: CityModel.self)
        }
        let experienceCount = try await MainActor.run {
            try persistenceClient.count(of: ExperienceModel.self)
        }

        XCTAssertEqual(cityCount, 1, "Experiences with same city ID should reuse one city model")
        XCTAssertEqual(experienceCount, 2)
        XCTAssertTrue(mockLogger.containsInfo("Saving 2 experiences to cache"))
    }

    func testUpdateLikeStatus_WithExistingExperience_UpdatesLikeFields() async throws {
        // Given
        let model = ExperienceModelFixtures.createPyramidsModel()
        try await sut.saveExperiences([model])

        // When
        try await sut.updateLikeStatus(id: "1", isLiked: true, likesCount: 3000)
        let updated = try await sut.getExperienceById("1")

        // Then
        XCTAssertNotNil(updated)
        XCTAssertEqual(updated?.isLiked, true)
        XCTAssertEqual(updated?.likesCount, 3000)
    }

    func testUpdateLikeStatus_WithMissingExperience_LogsWarningAndDoesNotThrow() async throws {
        // Given/When
        try await sut.updateLikeStatus(id: "404", isLiked: true, likesCount: 10)

        // Then
        XCTAssertTrue(mockLogger.contains("Experience not found for ID: 404", level: .warning))
    }

    func testClearCache_RemovesExperiencesAndCities() async throws {
        // Given
        let all = ExperienceModelFixtures.createAllModels().experiences
        try await sut.saveExperiences(all)

        // Precondition
        let preExperienceCount = try await MainActor.run {
            try persistenceClient.count(of: ExperienceModel.self)
        }
        let preCityCount = try await MainActor.run {
            try persistenceClient.count(of: CityModel.self)
        }
        XCTAssertGreaterThan(preExperienceCount, 0)
        XCTAssertGreaterThan(preCityCount, 0)

        // When
        try await sut.clearCache()

        // Then
        let postExperienceCount = try await MainActor.run {
            try persistenceClient.count(of: ExperienceModel.self)
        }
        let postCityCount = try await MainActor.run {
            try persistenceClient.count(of: CityModel.self)
        }

        XCTAssertEqual(postExperienceCount, 0)
        XCTAssertEqual(postCityCount, 0)
        XCTAssertTrue(mockLogger.containsInfo("Clearing experience cache"))
    }
}
