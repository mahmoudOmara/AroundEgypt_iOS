//
//  SearchExperiencesUseCase.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit

/// Use case for searching experiences by title
public final class SearchExperiencesUseCase {

    // MARK: - Properties

    @Injected(\.experienceRepository) private var repository: ExperienceRepositoryProtocol
    private let minQueryLength: Int

    // MARK: - Initialization

    public init(minQueryLength: Int = 2) {
        self.minQueryLength = minQueryLength
    }

    // MARK: - Execution

    /// Executes the use case to search experiences
    /// - Parameter query: Search query string
    /// - Returns: Array of matching experiences
    /// - Throws: ExperienceError if the operation fails
    public func execute(query: String) async throws -> [ExperienceEntity] {
        // Validate query length
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedQuery.count >= minQueryLength else {
            throw ExperienceError.invalidSearchQuery
        }

        return try await repository.searchExperiences(query: trimmedQuery)
    }
}
