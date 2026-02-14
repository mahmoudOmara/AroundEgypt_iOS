//
//  ExperienceDetailViewModel.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit
import AEShared

/// ViewModel for the Experience Detail screen
/// Handles loading experience details and like action with optimistic update
@MainActor
@Observable
final class ExperienceDetailViewModel {

    // MARK: - State

    var detailState: AsyncState<ExperienceEntity> = .idle

    // MARK: - Dependencies

    @ObservationIgnored
    private let coordinator: TourCoordinator

    @ObservationIgnored
    @Injected(\.getExperienceDetailsUseCase)
    private var getDetailsUseCase: GetExperienceDetailsUseCase

    @ObservationIgnored
    @Injected(\.likeExperienceUseCase)
    private var likeUseCase: LikeExperienceUseCase

    // MARK: - Private Properties

    private let experienceId: String

    // MARK: - Computed Properties

    var experience: ExperienceEntity? {
        detailState.successValue
    }

    // MARK: - Initialization

    init(coordinator: TourCoordinator, experience: ExperienceEntity) {
        self.coordinator = coordinator
        self.experienceId = experience.id
    }

    // MARK: - Methods

    /// Loads experience details
    func loadDetails(forceRefresh: Bool = false) async {
        detailState = .loading

        do {
            let experience = try await getDetailsUseCase.execute(id: experienceId, forceRefresh: forceRefresh)
            detailState = .success(experience)
        } catch {
            detailState = .failure(error)
        }
    }

    /// Likes the experience with optimistic update
    func likeExperience() async {
        guard let currentExperience = experience else { return }
        guard !currentExperience.isLiked else { return } // Already liked

        // Optimistic update
        let optimisticExperience = ExperienceEntity(
            id: currentExperience.id,
            title: currentExperience.title,
            coverPhoto: currentExperience.coverPhoto,
            description: currentExperience.description,
            viewsCount: currentExperience.viewsCount,
            likesCount: currentExperience.likesCount + 1,
            isRecommended: currentExperience.isRecommended,
            hasVideo: currentExperience.hasVideo,
            city: currentExperience.city,
            tourHTML: currentExperience.tourHTML,
            isLiked: true
        )
        detailState = .success(optimisticExperience)

        do {
            let updatedExperience = try await likeUseCase.execute(id: currentExperience.id)
            detailState = .success(updatedExperience)
        } catch {
            // Revert on failure
            detailState = .success(currentExperience)
        }

    }

    /// Refreshes the experience details
    func refresh() async {
        await loadDetails(forceRefresh: true)
    }
}
