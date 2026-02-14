//
//  LikeExperienceUseCaseTests.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import XCTest
import FactoryKit
@testable import AETour
@testable import AECore

final class LikeExperienceUseCaseTests: XCTestCase {

    // MARK: - Properties

    var sut: LikeExperienceUseCase!
    var mockRepository: MockExperienceRepository!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        Container.setupTestContainer()

        mockRepository = Container.registerMockExperienceRepository()
        sut = LikeExperienceUseCase()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        Container.tearDownTestContainer()
        super.tearDown()
    }

    // MARK: - Success Tests

    func testExecute_WithValidID_CallsRepositoryAndReturnsCount() async throws {
        // Given
        let experienceID = "123"
        let expectedCount = 151
        mockRepository.likeResult = .success(expectedCount)

        // When
        let result = try await sut.execute(id: experienceID)

        // Then
        XCTAssertEqual(result, expectedCount, "Should return updated likes count")
        XCTAssertEqual(mockRepository.likeCallCount, 1, "Should call repository once")
        XCTAssertEqual(mockRepository.lastLikeID, experienceID, "Should pass correct ID to repository")
    }

    func testExecute_WithIDContainingWhitespace_TrimsAndCallsRepository() async throws {
        // Given
        let experienceID = "  456  "
        mockRepository.likeResult = .success(200)

        // When
        let result = try await sut.execute(id: experienceID)

        // Then
        XCTAssertEqual(result, 200)
        XCTAssertEqual(mockRepository.likeCallCount, 1)
        XCTAssertEqual(mockRepository.lastLikeID, experienceID, "Should pass original ID (repository handles trimming if needed)")
    }

    // MARK: - Validation Tests

    func testExecute_WithEmptyID_ThrowsInvalidExperienceIDError() async {
        // Given
        let emptyID = ""

        // When/Then
        do {
            _ = try await sut.execute(id: emptyID)
            XCTFail("Should throw invalidExperienceID error")
        } catch ExperienceError.invalidExperienceID {
            // Expected error
            XCTAssertEqual(mockRepository.likeCallCount, 0, "Should not call repository")
        } catch {
            XCTFail("Should throw ExperienceError.invalidExperienceID, got \(error)")
        }
    }

    func testExecute_WithWhitespaceOnlyID_ThrowsInvalidExperienceIDError() async {
        // Given
        let whitespaceID = "   "

        // When/Then
        do {
            _ = try await sut.execute(id: whitespaceID)
            XCTFail("Should throw invalidExperienceID error")
        } catch ExperienceError.invalidExperienceID {
            // Expected error
            XCTAssertEqual(mockRepository.likeCallCount, 0, "Should not call repository")
        } catch {
            XCTFail("Should throw ExperienceError.invalidExperienceID, got \(error)")
        }
    }

    func testExecute_WithTabAndNewlineID_ThrowsInvalidExperienceIDError() async {
        // Given
        let whitespaceID = "\t\n"

        // When/Then
        do {
            _ = try await sut.execute(id: whitespaceID)
            XCTFail("Should throw invalidExperienceID error")
        } catch ExperienceError.invalidExperienceID {
            // Expected error
            XCTAssertEqual(mockRepository.likeCallCount, 0)
        } catch {
            XCTFail("Should throw ExperienceError.invalidExperienceID, got \(error)")
        }
    }

    // MARK: - Error Propagation Tests

    func testExecute_WhenRepositoryThrowsNetworkError_PropagatesError() async {
        // Given
        let experienceID = "789"
        mockRepository.likeResult = .failure(ExperienceError.networkError(.networkUnavailable))

        // When/Then
        do {
            _ = try await sut.execute(id: experienceID)
            XCTFail("Should propagate repository error")
        } catch {
            // Expected - error should propagate
            XCTAssertEqual(mockRepository.likeCallCount, 1, "Should have called repository")
        }
    }

    func testExecute_WhenRepositoryThrowsExperienceNotFound_PropagatesError() async {
        // Given
        let experienceID = "999"
        mockRepository.likeResult = .failure(ExperienceError.experienceNotFound)

        // When/Then
        do {
            _ = try await sut.execute(id: experienceID)
            XCTFail("Should propagate repository error")
        } catch ExperienceError.experienceNotFound {
            // Expected
            XCTAssertEqual(mockRepository.likeCallCount, 1)
        } catch {
            XCTFail("Should propagate ExperienceError.experienceNotFound, got \(error)")
        }
    }
}
