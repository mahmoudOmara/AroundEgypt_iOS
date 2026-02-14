//
//  HomeView.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI
import AEShared
import FactoryKit

/// Main home screen showing recommended and recent experiences
struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom header with menu, search, and filter
                customHeaderView

                ScrollView {
                    ZStack {
                        switch viewModel.searchState {
                        case .idle:
                            // Regular content when not searching
                            normalStateView
                            
                        case .loading:
                            LoadingView()
                                .frame(height: 200)
                                .padding(.top, AppSpacing.xl)
                            
                        case .failure(let error):
                            ErrorView(error: error) {
                                await viewModel.performSearch()
                            }
                            .frame(height: 200)
                            .padding(.top, AppSpacing.xl)
                            
                        case .success(let results):
                            searchResultsView(results: results)
                        }
                    }
                    .padding(.bottom, AppSpacing.xl)
                }
                .background(AppColors.background)
                .refreshable {
                    await viewModel.refresh()
                }
            }
            .task {
                await viewModel.loadInitialData()
            }
        }
    }
    
    private var customHeaderView: some View {
        HStack(spacing: AppSpacing.md) {
            // Menu button
            Button {
                // TODO: Menu action
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(AppColors.iconTint)
            }

            // Search bar
            SearchBar(
                text: $viewModel.searchQuery,
                placeholder: "Try \"Luxor\"",
                onSubmit: {
                    Task {
                        await viewModel.performSearch()
                    }
                },
                onClear: {
                    viewModel.clearSearch()
                }
            )
            
            // Filter button
            Button {
                // TODO: Filter action
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .foregroundColor(AppColors.iconTint)
            }
        }
        .padding(.horizontal, AppSpacing.screenPadding)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.background)
    }

    private var welcomeHeaderView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Welcome!")
                .font(AppTypography.titleLarge)
                .foregroundColor(AppColors.textPrimary)

            Text("Now you can explore any experience in 360 degrees and get all the details about it all in one place.")
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppSpacing.screenPadding)
    }
    
    private var normalStateView: some View {
        VStack(spacing: AppSpacing.sectionSpacing) {
            welcomeHeaderView

            recommendedSectionView

            mostRecentSectionView
        }
    }
    
    private var recommendedSectionView: some View {
        ExperienceHorizontalSectionView(
            title: "Recommended Experiences",
            emptyStateMessage: "No experiences available",
            state: viewModel.recommendedState,
            onExperienceTap: { experience in
                viewModel.selectExperience(experience)
            },
            on360Tap: { experience in
                viewModel.select360Experience(experience)
            },
            onLikeTap: { experience in
                Task {
                    await viewModel.likeExperience(experience)
                }
            },
            onRetry: {
                await viewModel.loadInitialData()
            }
        )
    }

    private var mostRecentSectionView: some View {
        ExperienceVerticalSectionView(
            title: "Most Recent",
            emptyStateMessage: "No experiences available",
            state: viewModel.recentState,
            onExperienceTap: { experience in
                viewModel.selectExperience(experience)
            },
            on360Tap: { experience in
                viewModel.select360Experience(experience)
            },
            onLikeTap: { experience in
                Task {
                    await viewModel.likeExperience(experience)
                }
            },
            onRetry: {
                await viewModel.loadInitialData()
            }
        )
    }

    private func searchResultsView(results: [ExperienceEntity]) -> some View {
        ExperienceVerticalSectionView(
            title: "Search Results",
            emptyStateMessage: "No results found for \"\(viewModel.searchQuery)\"",
            state: viewModel.searchState,
            onExperienceTap: { experience in
                viewModel.selectExperience(experience)
            },
            on360Tap: { experience in
                viewModel.select360Experience(experience)
            },
            onLikeTap: { experience in
                Task {
                    await viewModel.likeExperience(experience)
                }
            },
            onRetry: {
                Task {
                    await viewModel.performSearch()
                }
            }
        )
    }
}

#Preview {
    Container.setupPreviewContainer()
    let coordinator = TourCoordinator()
    return HomeView(viewModel: HomeViewModel(coordinator: coordinator))
}
