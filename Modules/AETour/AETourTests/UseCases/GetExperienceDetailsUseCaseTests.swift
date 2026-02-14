//
//  GetExperienceDetailsUseCaseTests.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import XCTest
import FactoryKit
@testable import AETour
@testable import AECore

final class GetExperienceDetailsUseCaseTests: XCTestCase {

    // MARK: - Properties

    var sut: GetExperienceDetailsUseCase!
    var mockRepository: MockExperienceRepository!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        Container.setupTestContainer()

        mockRepository = Container.registerMockExperienceRepository()
        sut = GetExperienceDetailsUseCase()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        Container.tearDownTestContainer()
        super.tearDown()
    }

    // MARK: - Success Tests

    func testExecute_WithValidID_CallsRepositoryAndReturnsExperience() async throws {
        // Given
        let experienceID = "1"
        let expectedExperience = ExperienceEntityFixtures.pyramids
        mockRepository.getDetailsResult = .success(expectedExperience)

        // When
        let result = try await sut.execute(id: experienceID)

        // Then
        XCTAssertEqual(result.id, "1", "Should return correct experience")
        XCTAssertEqual(result.title, "Great Pyramids of Giza")
        XCTAssertEqual(mockRepository.getDetailsCallCount, 1, "Should call repository once")
        XCTAssertEqual(mockRepository.lastDetailsID, experienceID, "Should pass correct ID")
        XCTAssertEqual(mockRepository.lastDetailsForceRefresh, false, "Should default to false")
    }

    func testExecute_WithValidIDAndForceRefreshTrue_PassesForceRefreshToRepository() async throws {
        // Given
        let experienceID = "2"
        let expectedExperience = ExperienceEntityFixtures.sphinx
        mockRepository.getDetailsResult = .success(expectedExperience)

        // When
        let result = try await sut.execute(id: experienceID, forceRefresh: true)

        // Then
        XCTAssertEqual(result.id, "2")
        XCTAssertEqual(mockRepository.getDetailsCallCount, 1)
        XCTAssertEqual(mockRepository.lastDetailsID, experienceID)
        XCTAssertEqual(mockRepository.lastDetailsForceRefresh, true, "Should pass forceRefresh=true")
    }

    func testExecute_WithValidIDAndForceRefreshFalse_PassesForceRefreshFalse() async throws {
        // Given
        let experienceID = "3"
        let expectedExperience = ExperienceEntityFixtures.valleyOfKings
        mockRepository.getDetailsResult = .success(expectedExperience)

        // When
        let result = try await sut.execute(id: experienceID, forceRefresh: false)

        // Then
        XCTAssertEqual(result.id, "3")
        XCTAssertEqual(mockRepository.lastDetailsForceRefresh, false, "Should pass forceRefresh=false")
    }

    func testExecute_WithDefaultForceRefresh_UsesFalse() async throws {
        // Given
        let experienceID = "4"
        let expectedExperience = ExperienceEntityFixtures.karnakTemple
        mockRepository.getDetailsResult = .success(expectedExperience)

        // When - Not specifying forceRefresh, should default to false
        let result = try await sut.execute(id: experienceID)

        // Then
        XCTAssertEqual(result.id, "4")
        XCTAssertEqual(mockRepository.lastDetailsForceRefresh, false, "Should default to false")
    }

    func testExecute_WithIDContainingWhitespace_PassesOriginalID() async throws {
        // Given
        let experienceID = "  5  "
        let expectedExperience = ExperienceEntityFixtures.alexandriaLibrary
        mockRepository.getDetailsResult = .success(expectedExperience)

        // When
        let result = try await sut.execute(id: experienceID)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(mockRepository.lastDetailsID, experienceID, "Should pass original ID")
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
            XCTAssertEqual(mockRepository.getDetailsCallCount, 0, "Should not call repository")
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
            XCTAssertEqual(mockRepository.getDetailsCallCount, 0, "Should not call repository")
        } catch {
            XCTFail("Should throw ExperienceError.invalidExperienceID, got \(error)")
        }
    }

    func testExecute_WithTabAndNewlineID_ThrowsInvalidExperienceIDError() async {
        // Given
        let whitespaceID = "\t\n\r"

        // When/Then
        do {
            _ = try await sut.execute(id: whitespaceID)
            XCTFail("Should throw invalidExperienceID error")
        } catch ExperienceError.invalidExperienceID {
            // Expected error
            XCTAssertEqual(mockRepository.getDetailsCallCount, 0)
        } catch {
            XCTFail("Should throw ExperienceError.invalidExperienceID, got \(error)")
        }
    }

    func testExecute_WithEmptyIDAndForceRefreshTrue_StillThrowsError() async {
        // Given
        let emptyID = ""

        // When/Then
        do {
            _ = try await sut.execute(id: emptyID, forceRefresh: true)
            XCTFail("Should throw invalidExperienceID error regardless of forceRefresh")
        } catch ExperienceError.invalidExperienceID {
            // Expected error - validation happens before repository call
            XCTAssertEqual(mockRepository.getDetailsCallCount, 0)
        } catch {
            XCTFail("Should throw ExperienceError.invalidExperienceID, got \(error)")
        }
    }

    // MARK: - Error Propagation Tests

    func testExecute_WhenRepositoryThrowsNetworkError_PropagatesError() async {
        // Given
        let experienceID = "999"
        mockRepository.getDetailsResult = .failure(ExperienceError.networkError(.networkUnavailable))

        // When/Then
        do {
            _ = try await sut.execute(id: experienceID)
            XCTFail("Should propagate repository error")
        } catch {
            // Expected - error should propagate
            XCTAssertEqual(mockRepository.getDetailsCallCount, 1, "Should have called repository")
        }
    }

    func testExecute_WhenRepositoryThrowsExperienceNotFound_PropagatesError() async {
        // Given
        let experienceID = "888"
        mockRepository.getDetailsResult = .failure(ExperienceError.experienceNotFound)

        // When/Then
        do {
            _ = try await sut.execute(id: experienceID)
            XCTFail("Should propagate repository error")
        } catch ExperienceError.experienceNotFound {
            // Expected
            XCTAssertEqual(mockRepository.getDetailsCallCount, 1)
        } catch {
            XCTFail("Should propagate ExperienceError.experienceNotFound, got \(error)")
        }
    }

    func testExecute_WhenRepositoryThrowsPersistenceError_PropagatesError() async {
        // Given
        let experienceID = "777"
        let swiftDataError = SwiftDataError.fetchFailed(NSError(domain: "test", code: 1))
        mockRepository.getDetailsResult = .failure(ExperienceError.persistenceError(swiftDataError))

        // When/Then
        do {
            _ = try await sut.execute(id: experienceID)
            XCTFail("Should propagate repository error")
        } catch ExperienceError.persistenceError {
            // Expected
            XCTAssertEqual(mockRepository.getDetailsCallCount, 1)
        } catch {
            XCTFail("Should propagate ExperienceError.persistenceError, got \(error)")
        }
    }
}
