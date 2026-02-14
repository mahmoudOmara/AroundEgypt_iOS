//
//  HomeViewModel.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit
import AEShared

/// ViewModel for the Home screen
/// Handles fetching recommended and recent experiences SIMULTANEOUSLY
@MainActor
@Observable
final class HomeViewModel {

    // MARK: - State

    var recommendedState: AsyncState<[ExperienceEntity]> = .idle
    var recentState: AsyncState<[ExperienceEntity]> = .idle
    var searchQuery: String = ""
    var searchState: AsyncState<[ExperienceEntity]> = .idle

    // MARK: - Dependencies

    @ObservationIgnored
    private let coordinator: TourCoordinator

    @ObservationIgnored
    @Injected(\.getRecommendedExperiencesUseCase)
    private var getRecommendedUseCase: GetRecommendedExperiencesUseCase

    @ObservationIgnored
    @Injected(\.getRecentExperiencesUseCase)
    private var getRecentUseCase: GetRecentExperiencesUseCase

    @ObservationIgnored
    @Injected(\.searchExperiencesUseCase)
    private var searchUseCase: SearchExperiencesUseCase
    
    @ObservationIgnored
    @Injected(\.likeExperienceUseCase)
    private var likeUseCase: LikeExperienceUseCase

    // MARK: - Initializer

    init(coordinator: TourCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Computed Properties

    var recommendedExperiences: [ExperienceEntity] {
        recommendedState.successValue ?? []
    }

    var recentExperiences: [ExperienceEntity] {
        recentState.successValue ?? []
    }

    // MARK: - Methods

    /// Loads initial data for both sections SIMULTANEOUSLY
    func loadInitialData() async {
        // Set both to loading state
        recommendedState = .loading
        recentState = .loading

        // Fetch BOTH simultaneously using async let
        async let recommendedResult = fetchRecommended()
        async let recentResult = fetchRecent()

        // Wait for both to complete
        let (recommended, recent) = await (recommendedResult, recentResult)

        // Update states independently (partial success support)
        recommendedState = recommended
        recentState = recent
    }

    /// Refreshes both sections
    func refresh() async {
        await loadInitialData()
    }

    /// Selects an experience for detail view
    func selectExperience(_ experience: ExperienceEntity) {
        coordinator.present(
            .experienceDetail(experience: experience),
            style: .sheet,
            options: .init(showDragIndicator: false)
        )
    }
    
    /// Selects an experience for 360 view
    func select360Experience(_ experience: ExperienceEntity) {
        coordinator.present(
            .virtualTour(htmlURL: experience.tourHTML),
            style: .fullScreenCover,
            options: .init(showDragIndicator: false)
        )
    }
    
    /// Like an experience with optimistic update
    func likeExperience(_ experience: ExperienceEntity) async {
        guard !experience.isLiked else { return } // Already liked

        // Create optimistic experience
        let optimisticExperience = ExperienceEntity(
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

        // Optimistically update in both lists
        updateExperienceInLists(optimisticExperience)

        do {
            let updatedLikesCount = try await likeUseCase.execute(id: experience.id)

            // Create updated experience with the returned likes count
            let confirmedExperience = ExperienceEntity(
                id: experience.id,
                title: experience.title,
                coverPhoto: experience.coverPhoto,
                description: experience.description,
                viewsCount: experience.viewsCount,
                likesCount: updatedLikesCount,
                isRecommended: experience.isRecommended,
                hasVideo: experience.hasVideo,
                city: experience.city,
                tourHTML: experience.tourHTML,
                isLiked: true
            )
            updateExperienceInLists(confirmedExperience)
        } catch {
            // Revert on failure
            updateExperienceInLists(experience)
        }
    }

    /// Performs search with the current query
    func performSearch() async {
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchState = .idle
            return
        }

        searchState = .loading

        do {
            let results = try await searchUseCase.execute(query: searchQuery)
            searchState = .success(results)
        } catch {
            searchState = .failure(error)
        }
    }

    /// Clears search results
    func clearSearch() {
        searchQuery = ""
        searchState = .idle
    }

    // MARK: - Private Methods

    private func fetchRecommended() async -> AsyncState<[ExperienceEntity]> {
        do {
            let experiences = try await getRecommendedUseCase.execute()
            return .success(experiences)
        } catch {
            return .failure(error)
        }
    }

    private func fetchRecent() async -> AsyncState<[ExperienceEntity]> {
        do {
            let experiences = try await getRecentUseCase.execute()
            return .success(experiences)
        } catch {
            return .failure(error)
        }
    }

    private func updateExperienceInLists(_ experience: ExperienceEntity) {
        // Update in recommended list if present
        if case .success(let experiences) = recommendedState {
            if let index = experiences.firstIndex(where: { $0.id == experience.id }) {
                var updated = experiences
                updated[index] = experience
                recommendedState = .success(updated)
            }
        }

        // Update in recent list if present
        if case .success(let experiences) = recentState {
            if let index = experiences.firstIndex(where: { $0.id == experience.id }) {
                var updated = experiences
                updated[index] = experience
                recentState = .success(updated)
            }
        }
    }
}
