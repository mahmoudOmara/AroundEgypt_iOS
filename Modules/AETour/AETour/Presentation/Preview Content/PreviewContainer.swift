//
//  PreviewContainer.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit

#if DEBUG

/// Preview-specific DI container setup with stub implementations
extension Container {

    /// Configures the container with stub implementations for SwiftUI previews
    static func setupPreviewContainer() {
        // Stub Repository
        shared.experienceRepository.register {
            StubExperienceRepository()
        }
    }

    /// Resets the container to default implementations
    static func resetContainer() {
        shared.reset()
    }
}

// MARK: - Stub Repository

final class StubExperienceRepository: ExperienceRepositoryProtocol {
    func getRecommendedExperiences(forceRefresh: Bool) async throws -> [ExperienceEntity] {
        try? await Task.sleep(for: .milliseconds(500))
        return PreviewData.sampleExperiences.filter { $0.isRecommended }
    }

    func getRecentExperiences(forceRefresh: Bool) async throws -> [ExperienceEntity] {
        try? await Task.sleep(for: .milliseconds(500))
        return PreviewData.sampleExperiences
    }

    func searchExperiences(query: String) async throws -> [ExperienceEntity] {
        try? await Task.sleep(for: .milliseconds(300))
        return PreviewData.sampleExperiences.filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }
    }

    func getExperienceDetails(id: String, forceRefresh: Bool) async throws -> ExperienceEntity {
        try? await Task.sleep(for: .milliseconds(500))
        guard let experience = PreviewData.sampleExperiences.first(where: { $0.id == id }) else {
            throw ExperienceError.experienceNotFound
        }
        return experience
    }

    func likeExperience(id: String) async throws -> ExperienceEntity {
        try? await Task.sleep(for: .milliseconds(300))
        guard let experience = PreviewData.sampleExperiences.first(where: { $0.id == id }) else {
            throw ExperienceError.experienceNotFound
        }

        return ExperienceEntity(
            id: experience.id,
            title: experience.title,
            coverPhoto: experience.coverPhoto,
            description: experience.description,
            viewsCount: experience.viewsCount,
            likesCount: experience.likesCount + 1,
            isRecommended: experience.isRecommended,
            hasVideo: experience.hasVideo,
            city: experience.city,
            tourHTML: experience.tourHTML,
            isLiked: true
        )
    }
}

#endif
