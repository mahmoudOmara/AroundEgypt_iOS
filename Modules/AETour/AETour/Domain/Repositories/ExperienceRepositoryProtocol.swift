//
//  ExperienceRepositoryProtocol.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

/// Protocol defining the contract for experience data operations
/// Implementation in Data layer handles remote-first with local fallback strategy
public protocol ExperienceRepositoryProtocol {

    /// Fetches recommended experiences
    /// - Parameter forceRefresh: If true, bypass cache and fetch from API
    /// - Returns: Array of recommended experiences
    /// - Throws: ExperienceError if the operation fails
    func getRecommendedExperiences(forceRefresh: Bool) async throws -> [ExperienceEntity]

    /// Fetches recent experiences
    /// - Parameter forceRefresh: If true, bypass cache and fetch from API
    /// - Returns: Array of recent experiences
    /// - Throws: ExperienceError if the operation fails
    func getRecentExperiences(forceRefresh: Bool) async throws -> [ExperienceEntity]

    /// Searches for experiences by title
    /// - Parameter query: Search query string
    /// - Returns: Array of matching experiences
    /// - Throws: ExperienceError if the operation fails
    func searchExperiences(query: String) async throws -> [ExperienceEntity]

    /// Fetches details for a specific experience
    /// - Parameters:
    ///   - id: Unique identifier of the experience
    ///   - forceRefresh: If true, bypass cache and fetch from API
    /// - Returns: The requested experience
    /// - Throws: ExperienceError if the operation fails
    func getExperienceDetails(id: String, forceRefresh: Bool) async throws -> ExperienceEntity

    /// Likes an experience
    /// - Parameter id: Unique identifier of the experience to like
    /// - Returns: Updated experience with new like status
    /// - Throws: ExperienceError if the operation fails
    func likeExperience(id: String) async throws -> ExperienceEntity
}

// MARK: - Default Parameters

public extension ExperienceRepositoryProtocol {

    /// Fetches recommended experiences with default refresh behavior
    func getRecommendedExperiences() async throws -> [ExperienceEntity] {
        return try await getRecommendedExperiences(forceRefresh: false)
    }

    /// Fetches recent experiences with default refresh behavior
    func getRecentExperiences() async throws -> [ExperienceEntity] {
        return try await getRecentExperiences(forceRefresh: false)
    }

    /// Fetches experience details with default refresh behavior
    func getExperienceDetails(id: String) async throws -> ExperienceEntity {
        return try await getExperienceDetails(id: id, forceRefresh: false)
    }
}
