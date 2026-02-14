//
//  ExperienceRemoteDataSourceTests.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import XCTest
import FactoryKit
@testable import AETour
@testable import AECore

final class ExperienceRemoteDataSourceTests: XCTestCase {

    // MARK: - Properties

    var sut: ExperienceRemoteDataSource!
    var mockNetworkClient: MockNetworkClient!
    var mockLogger: MockLogger!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        Container.setupTestContainer()

        mockNetworkClient = Container.registerMockNetworkClient()
        mockLogger = Container.registerMockLogger()
        sut = ExperienceRemoteDataSource()
    }

    override func tearDown() {
        sut = nil
        mockNetworkClient = nil
        mockLogger = nil
        Container.tearDownTestContainer()
        super.tearDown()
    }

    // MARK: - Success Tests

    func testGetRecommendedExperiences_WithSuccessResponse_ReturnsDataAndUsesRecommendedRequest() async throws {
        // Given
        let expectedDTOs = ExperienceDTOFixtures.recommended
        mockNetworkClient.performResult = APIResponse(
            meta: MetaDTO(code: 200, errors: [], exception: nil),
            data: expectedDTOs
        )

        // When
        let result = try await sut.getRecommendedExperiences()

        // Then
        XCTAssertEqual(result.count, expectedDTOs.count, "Should return API response data")
        XCTAssertEqual(mockNetworkClient.performCallCount, 1, "Should perform one API call")
        XCTAssertEqual(mockNetworkClient.lastRequest?.path, "/api/v2/experiences")
        XCTAssertEqual(mockNetworkClient.lastRequest?.method, .GET)
        XCTAssertEqual(mockNetworkClient.lastRequest?.queryParams?["filter[recommended]"], "true")
        XCTAssertTrue(mockLogger.containsInfo("Fetching recommended experiences from API"))
    }

    func testGetRecentExperiences_WithSuccessResponse_ReturnsDataAndUsesRecentRequest() async throws {
        // Given
        let expectedDTOs = ExperienceDTOFixtures.all
        mockNetworkClient.performResult = APIResponse(
            meta: MetaDTO(code: 200, errors: [], exception: nil),
            data: expectedDTOs
        )

        // When
        let result = try await sut.getRecentExperiences()

        // Then
        XCTAssertEqual(result.count, expectedDTOs.count)
        XCTAssertEqual(mockNetworkClient.performCallCount, 1)
        XCTAssertEqual(mockNetworkClient.lastRequest?.path, "/api/v2/experiences")
        XCTAssertEqual(mockNetworkClient.lastRequest?.method, .GET)
        XCTAssertNil(mockNetworkClient.lastRequest?.queryParams, "Recent endpoint should not include query params")
        XCTAssertTrue(mockLogger.containsInfo("Fetching recent experiences from API"))
    }

    func testSearchExperiences_WithSuccessResponse_ReturnsDataAndPassesQueryFilter() async throws {
        // Given
        let query = "pyramids"
        let expectedDTOs = ExperienceDTOFixtures.inCairo
        mockNetworkClient.performResult = APIResponse(
            meta: MetaDTO(code: 200, errors: [], exception: nil),
            data: expectedDTOs
        )

        // When
        let result = try await sut.searchExperiences(query: query)

        // Then
        XCTAssertEqual(result.count, expectedDTOs.count)
        XCTAssertEqual(mockNetworkClient.performCallCount, 1)
        XCTAssertEqual(mockNetworkClient.lastRequest?.path, "/api/v2/experiences")
        XCTAssertEqual(mockNetworkClient.lastRequest?.method, .GET)
        XCTAssertEqual(mockNetworkClient.lastRequest?.queryParams?["filter[title]"], query)
        XCTAssertTrue(mockLogger.containsInfo("Searching experiences with query: \(query)"))
    }

    func testGetExperienceDetails_WithSuccessResponse_ReturnsDataAndUsesDetailsPath() async throws {
        // Given
        let id = "42"
        let expectedDTO = ExperienceDTOFixtures.pyramidsDTO
        mockNetworkClient.performResult = APIResponse(
            meta: MetaDTO(code: 200, errors: [], exception: nil),
            data: expectedDTO
        )

        // When
        let result = try await sut.getExperienceDetails(id: id)

        // Then
        XCTAssertEqual(result.id, expectedDTO.id)
        XCTAssertEqual(result.title, expectedDTO.title)
        XCTAssertEqual(mockNetworkClient.performCallCount, 1)
        XCTAssertEqual(mockNetworkClient.lastRequest?.path, "/api/v2/experiences/\(id)")
        XCTAssertEqual(mockNetworkClient.lastRequest?.method, .GET)
        XCTAssertTrue(mockLogger.containsInfo("Fetching experience details for ID: \(id)"))
    }

    func testLikeExperience_WithSuccessResponse_ReturnsLikesCountAndUsesPostMethod() async throws {
        // Given
        let id = "77"
        let expectedLikes = 1234
        mockNetworkClient.performResult = APIResponse(
            meta: MetaDTO(code: 200, errors: [], exception: nil),
            data: expectedLikes
        )

        // When
        let result = try await sut.likeExperience(id: id)

        // Then
        XCTAssertEqual(result, expectedLikes)
        XCTAssertEqual(mockNetworkClient.performCallCount, 1)
        XCTAssertEqual(mockNetworkClient.lastRequest?.path, "/api/v2/experiences/\(id)/like")
        XCTAssertEqual(mockNetworkClient.lastRequest?.method, .POST)
        XCTAssertTrue(mockLogger.containsInfo("Liking experience with ID: \(id)"))
    }

    // MARK: - Error Handling Tests

    func testGetRecommendedExperiences_WhenApiReturns404WithErrors_ThrowsNotFoundAndLogsError() async {
        // Given
        mockNetworkClient.performResult = APIResponse(
            meta: MetaDTO(
                code: 404,
                errors: [APIErrorDTO(type: "not_found", message: "Experience not found")],
                exception: nil
            ),
            data: [ExperienceDTO]([])
        )

        // When/Then
        do {
            _ = try await sut.getRecommendedExperiences()
            XCTFail("Should throw notFound for API meta code 404")
        } catch NetworkError.notFound {
            XCTAssertTrue(mockLogger.containsError("API error: not_found - Experience not found"))
            XCTAssertEqual(mockNetworkClient.performCallCount, 1)
        } catch {
            XCTFail("Should throw NetworkError.notFound, got \(error)")
        }
    }

    func testGetRecentExperiences_WhenApiReturnsNon404ErrorWithErrors_ThrowsServerError() async {
        // Given
        mockNetworkClient.performResult = APIResponse(
            meta: MetaDTO(
                code: 500,
                errors: [APIErrorDTO(type: "server", message: "Unexpected error")],
                exception: nil
            ),
            data: [ExperienceDTO]([])
        )

        // When/Then
        do {
            _ = try await sut.getRecentExperiences()
            XCTFail("Should throw serverError when API contains errors and code is not 404")
        } catch NetworkError.serverError {
            XCTAssertTrue(mockLogger.containsError("API error: server - Unexpected error"))
            XCTAssertEqual(mockNetworkClient.performCallCount, 1)
        } catch {
            XCTFail("Should throw NetworkError.serverError, got \(error)")
        }
    }

    func testSearchExperiences_WhenApiReturnsFailureWithoutErrors_ThrowsHttpErrorCode() async {
        // Given
        let code = 418
        mockNetworkClient.performResult = APIResponse(
            meta: MetaDTO(code: code, errors: [], exception: nil),
            data: [ExperienceDTO]([])
        )

        // When/Then
        do {
            _ = try await sut.searchExperiences(query: "tea")
            XCTFail("Should throw httpError with meta code when API fails without detailed errors")
        } catch NetworkError.httpError(let statusCode) {
            XCTAssertEqual(statusCode, code)
            XCTAssertEqual(mockNetworkClient.performCallCount, 1)
        } catch {
            XCTFail("Should throw NetworkError.httpError(\(code)), got \(error)")
        }
    }

    func testGetExperienceDetails_WhenNetworkClientThrows_PropagatesNetworkError() async {
        // Given
        mockNetworkClient.performError = .networkUnavailable

        // When/Then
        do {
            _ = try await sut.getExperienceDetails(id: "11")
            XCTFail("Should propagate network client error")
        } catch NetworkError.networkUnavailable {
            XCTAssertEqual(mockNetworkClient.performCallCount, 1)
        } catch {
            XCTFail("Should propagate NetworkError.networkUnavailable, got \(error)")
        }
    }
}
