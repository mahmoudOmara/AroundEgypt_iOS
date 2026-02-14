//
//  SearchExperiencesUseCaseTests.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import XCTest
import FactoryKit
@testable import AETour
@testable import AECore

final class SearchExperiencesUseCaseTests: XCTestCase {

    // MARK: - Properties

    var sut: SearchExperiencesUseCase!
    var mockRepository: MockExperienceRepository!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        Container.setupTestContainer()

        mockRepository = Container.registerMockExperienceRepository()
        sut = SearchExperiencesUseCase() // Default minQueryLength = 2
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        Container.tearDownTestContainer()
        super.tearDown()
    }

    // MARK: - Success Tests

    func testExecute_WithValidQuery_TrimsAndCallsRepository() async throws {
        // Given
        let query = "pyramid"
        let expectedResults = ExperienceEntityFixtures.inCairo
        mockRepository.searchResult = .success(expectedResults)

        // When
        let result = try await sut.execute(query: query)

        // Then
        XCTAssertEqual(result.count, 2, "Should return search results")
        XCTAssertEqual(mockRepository.searchCallCount, 1, "Should call repository once")
        XCTAssertEqual(mockRepository.lastSearchQuery, "pyramid", "Should pass trimmed query to repository")
    }

    func testExecute_WithQueryContainingLeadingWhitespace_TrimsBeforeSearch() async throws {
        // Given
        let query = "  temple"
        mockRepository.searchResult = .success([])

        // When
        _ = try await sut.execute(query: query)

        // Then
        XCTAssertEqual(mockRepository.lastSearchQuery, "temple", "Should trim leading whitespace")
        XCTAssertEqual(mockRepository.searchCallCount, 1)
    }

    func testExecute_WithQueryContainingTrailingWhitespace_TrimsBeforeSearch() async throws {
        // Given
        let query = "sphinx  "
        mockRepository.searchResult = .success([])

        // When
        _ = try await sut.execute(query: query)

        // Then
        XCTAssertEqual(mockRepository.lastSearchQuery, "sphinx", "Should trim trailing whitespace")
        XCTAssertEqual(mockRepository.searchCallCount, 1)
    }

    func testExecute_WithQueryContainingBothLeadingAndTrailing_TrimsBeforeSearch() async throws {
        // Given
        let query = "  luxor  "
        mockRepository.searchResult = .success([])

        // When
        _ = try await sut.execute(query: query)

        // Then
        XCTAssertEqual(mockRepository.lastSearchQuery, "luxor", "Should trim both sides")
        XCTAssertEqual(mockRepository.searchCallCount, 1)
    }

    func testExecute_WithExactlyMinimumLength_Succeeds() async throws {
        // Given - Default minQueryLength is 2
        let query = "ab"
        mockRepository.searchResult = .success([])

        // When
        let result = try await sut.execute(query: query)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(mockRepository.searchCallCount, 1)
        XCTAssertEqual(mockRepository.lastSearchQuery, "ab")
    }

    func testExecute_WithLongerQuery_Succeeds() async throws {
        // Given
        let query = "Great Pyramids of Giza"
        mockRepository.searchResult = .success(ExperienceEntityFixtures.recommended)

        // When
        let result = try await sut.execute(query: query)

        // Then
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(mockRepository.searchCallCount, 1)
    }

    // MARK: - Validation Tests

    func testExecute_WithQueryLessThanMinimumLength_ThrowsInvalidSearchQueryError() async {
        // Given - Default minQueryLength is 2
        let shortQuery = "a"

        // When/Then
        do {
            _ = try await sut.execute(query: shortQuery)
            XCTFail("Should throw invalidSearchQuery error")
        } catch ExperienceError.invalidSearchQuery {
            // Expected error
            XCTAssertEqual(mockRepository.searchCallCount, 0, "Should not call repository")
        } catch {
            XCTFail("Should throw ExperienceError.invalidSearchQuery, got \(error)")
        }
    }

    func testExecute_WithEmptyQuery_ThrowsInvalidSearchQueryError() async {
        // Given
        let emptyQuery = ""

        // When/Then
        do {
            _ = try await sut.execute(query: emptyQuery)
            XCTFail("Should throw invalidSearchQuery error")
        } catch ExperienceError.invalidSearchQuery {
            // Expected error
            XCTAssertEqual(mockRepository.searchCallCount, 0)
        } catch {
            XCTFail("Should throw ExperienceError.invalidSearchQuery, got \(error)")
        }
    }

    func testExecute_WithWhitespaceOnlyQuery_ThrowsInvalidSearchQueryError() async {
        // Given
        let whitespaceQuery = "   "

        // When/Then
        do {
            _ = try await sut.execute(query: whitespaceQuery)
            XCTFail("Should throw invalidSearchQuery error")
        } catch ExperienceError.invalidSearchQuery {
            // Expected error (trimmed length = 0, which is < 2)
            XCTAssertEqual(mockRepository.searchCallCount, 0)
        } catch {
            XCTFail("Should throw ExperienceError.invalidSearchQuery, got \(error)")
        }
    }

    func testExecute_WithQueryThatBecomesTooShortAfterTrimming_ThrowsError() async {
        // Given - Query is "a  " which becomes "a" after trimming (length 1 < 2)
        let query = "a  "

        // When/Then
        do {
            _ = try await sut.execute(query: query)
            XCTFail("Should throw invalidSearchQuery error")
        } catch ExperienceError.invalidSearchQuery {
            // Expected error
            XCTAssertEqual(mockRepository.searchCallCount, 0)
        } catch {
            XCTFail("Should throw ExperienceError.invalidSearchQuery, got \(error)")
        }
    }

    // MARK: - Custom Min Query Length Tests

    func testExecute_WithCustomMinQueryLength_EnforcesCustomLength() async throws {
        // Given - Register new mock BEFORE creating SUT (so SUT gets injected with the new mock)
        mockRepository = Container.registerMockExperienceRepository()
        mockRepository.searchResult = .success([])
        sut = SearchExperiencesUseCase(minQueryLength: 5)

        let validQuery = "hello"
        let invalidQuery = "hi"

        // When - Valid query should succeed
        let result = try await sut.execute(query: validQuery)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(mockRepository.searchCallCount, 1)

        // When - Invalid query should fail
        do {
            _ = try await sut.execute(query: invalidQuery)
            XCTFail("Should throw error for query shorter than custom min length")
        } catch ExperienceError.invalidSearchQuery {
            // Expected
            XCTAssertEqual(mockRepository.searchCallCount, 1, "Should still be 1 from previous call")
        }
    }

    // MARK: - Error Propagation Tests

    func testExecute_WhenRepositoryThrowsError_PropagatesError() async {
        // Given
        let query = "test"
        mockRepository.searchResult = .failure(ExperienceError.networkError(.networkUnavailable))

        // When/Then
        do {
            _ = try await sut.execute(query: query)
            XCTFail("Should propagate repository error")
        } catch {
            // Expected - error should propagate
            XCTAssertEqual(mockRepository.searchCallCount, 1)
        }
    }
}
