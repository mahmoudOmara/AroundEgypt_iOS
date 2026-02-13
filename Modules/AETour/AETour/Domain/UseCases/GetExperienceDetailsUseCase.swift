//
//  GetExperienceDetailsUseCase.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit

/// Use case for fetching detailed information about a specific experience
public final class GetExperienceDetailsUseCase {

    // MARK: - Properties

    @Injected(\.experienceRepository) private var repository: ExperienceRepositoryProtocol

    // MARK: - Initialization

    public init() {}

    // MARK: - Execution

    /// Executes the use case to fetch experience details
    /// - Parameters:
    ///   - id: Unique identifier of the experience
    ///   - forceRefresh: If true, bypass cache and fetch from API
    /// - Returns: The requested experience with full details
    /// - Throws: ExperienceError if the operation fails
    public func execute(id: String, forceRefresh: Bool = false) async throws -> ExperienceEntity {
        // Validate ID
        guard !id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ExperienceError.invalidExperienceID
        }

        return try await repository.getExperienceDetails(id: id, forceRefresh: forceRefresh)
    }
}
