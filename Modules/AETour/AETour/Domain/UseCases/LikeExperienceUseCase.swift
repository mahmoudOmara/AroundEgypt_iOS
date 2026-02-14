//
//  LikeExperienceUseCase.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit

/// Use case for liking an experience
/// Note: Per requirements, experiences can be liked but NOT unliked
public final class LikeExperienceUseCase {

    // MARK: - Properties

    @Injected(\.experienceRepository) private var repository: ExperienceRepositoryProtocol

    // MARK: - Initialization

    public init() {}

    // MARK: - Execution

    /// Executes the use case to like an experience
    /// - Parameter id: Unique identifier of the experience to like
    /// - Returns: Updated likes count
    /// - Throws: ExperienceError if the operation fails
    public func execute(id: String) async throws -> Int {
        // Validate ID
        guard !id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ExperienceError.invalidExperienceID
        }

        return try await repository.likeExperience(id: id)
    }
}
