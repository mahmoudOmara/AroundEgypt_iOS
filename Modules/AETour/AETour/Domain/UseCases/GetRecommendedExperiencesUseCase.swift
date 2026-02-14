//
//  GetRecommendedExperiencesUseCase.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit

/// Use case for fetching recommended experiences
public final class GetRecommendedExperiencesUseCase {

    // MARK: - Properties

    @Injected(\.experienceRepository) private var repository: ExperienceRepositoryProtocol

    // MARK: - Initialization

    public init() {}

    // MARK: - Execution

    /// Executes the use case to fetch recommended experiences
    /// - Parameter forceRefresh: If true, bypass cache and fetch from API
    /// - Returns: Array of recommended experiences
    /// - Throws: ExperienceError if the operation fails
    public func execute(forceRefresh: Bool = false) async throws -> [ExperienceEntity] {
        return try await repository.getRecommendedExperiences(forceRefresh: forceRefresh)
    }
}
