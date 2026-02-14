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
    var selectedExperience: ExperienceEntity?
    var searchQuery: String = ""
    var searchState: AsyncState<[ExperienceEntity]> = .idle

    // MARK: - Dependencies

    @ObservationIgnored
    @Injected(\.getRecommendedExperiencesUseCase)
    private var getRecommendedUseCase: GetRecommendedExperiencesUseCase

    @ObservationIgnored
    @Injected(\.getRecentExperiencesUseCase)
    private var getRecentUseCase: GetRecentExperiencesUseCase

    @ObservationIgnored
    @Injected(\.searchExperiencesUseCase)
    private var searchUseCase: SearchExperiencesUseCase

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
        selectedExperience = experience
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
}
