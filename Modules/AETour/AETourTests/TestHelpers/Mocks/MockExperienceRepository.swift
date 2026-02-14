//
//  MockExperienceRepository.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import Foundation
@testable import AETour

/// Mock implementation of ExperienceRepositoryProtocol for testing
/// Allows tests to configure responses and verify method calls
final class MockExperienceRepository: ExperienceRepositoryProtocol {

    // MARK: - Configurable Results

    /// Result to return for getRecommendedExperiences(forceRefresh:)
    var getRecommendedResult: Result<[ExperienceEntity], Error>?

    /// Result to return for getRecentExperiences(forceRefresh:)
    var getRecentResult: Result<[ExperienceEntity], Error>?

    /// Result to return for searchExperiences(query:)
    var searchResult: Result<[ExperienceEntity], Error>?

    /// Result to return for getExperienceDetails(id:forceRefresh:)
    var getDetailsResult: Result<ExperienceEntity, Error>?

    /// Result to return for likeExperience(id:)
    var likeResult: Result<Int, Error>?

    // MARK: - Call Tracking

    /// Number of times getRecommendedExperiences() was called
    var getRecommendedCallCount = 0

    /// Number of times getRecentExperiences() was called
    var getRecentCallCount = 0

    /// Number of times searchExperiences() was called
    var searchCallCount = 0

    /// Number of times getExperienceDetails() was called
    var getDetailsCallCount = 0

    /// Number of times likeExperience() was called
    var likeCallCount = 0

    /// Last forceRefresh value passed to getRecommendedExperiences()
    var lastRecommendedForceRefresh: Bool?

    /// Last forceRefresh value passed to getRecentExperiences()
    var lastRecentForceRefresh: Bool?

    /// Last query passed to searchExperiences()
    var lastSearchQuery: String?

    /// Last ID passed to getExperienceDetails()
    var lastDetailsID: String?

    /// Last forceRefresh value passed to getExperienceDetails()
    var lastDetailsForceRefresh: Bool?

    /// Last ID passed to likeExperience()
    var lastLikeID: String?

    // MARK: - ExperienceRepositoryProtocol

    func getRecommendedExperiences(forceRefresh: Bool) async throws -> [ExperienceEntity] {
        getRecommendedCallCount += 1
        lastRecommendedForceRefresh = forceRefresh
        guard let result = getRecommendedResult else {
            fatalError("getRecommendedResult not configured in test")
        }
        return try result.get()
    }

    func getRecentExperiences(forceRefresh: Bool) async throws -> [ExperienceEntity] {
        getRecentCallCount += 1
        lastRecentForceRefresh = forceRefresh
        guard let result = getRecentResult else {
            fatalError("getRecentResult not configured in test")
        }
        return try result.get()
    }

    func searchExperiences(query: String) async throws -> [ExperienceEntity] {
        searchCallCount += 1
        lastSearchQuery = query
        guard let result = searchResult else {
            fatalError("searchResult not configured in test")
        }
        return try result.get()
    }

    func getExperienceDetails(id: String, forceRefresh: Bool) async throws -> ExperienceEntity {
        getDetailsCallCount += 1
        lastDetailsID = id
        lastDetailsForceRefresh = forceRefresh
        guard let result = getDetailsResult else {
            fatalError("getDetailsResult not configured in test")
        }
        return try result.get()
    }

    func likeExperience(id: String) async throws -> Int {
        likeCallCount += 1
        lastLikeID = id
        guard let result = likeResult else {
            fatalError("likeResult not configured in test")
        }
        return try result.get()
    }

    // MARK: - Test Helpers

    /// Resets all tracking variables
    func reset() {
        getRecommendedCallCount = 0
        getRecentCallCount = 0
        searchCallCount = 0
        getDetailsCallCount = 0
        likeCallCount = 0
        lastRecommendedForceRefresh = nil
        lastRecentForceRefresh = nil
        lastSearchQuery = nil
        lastDetailsID = nil
        lastDetailsForceRefresh = nil
        lastLikeID = nil
        getRecommendedResult = nil
        getRecentResult = nil
        searchResult = nil
        getDetailsResult = nil
        likeResult = nil
    }
}
