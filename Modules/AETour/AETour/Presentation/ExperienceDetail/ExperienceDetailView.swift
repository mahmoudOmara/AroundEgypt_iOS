//
//  ExperienceDetailView.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI
import AEShared
import FactoryKit

/// Experience detail screen showing full information and 360° tour
struct ExperienceDetailView: View {
    @State private var viewModel: ExperienceDetailViewModel

    init(viewModel: ExperienceDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            switch viewModel.detailState {
            case .idle, .loading:
                LoadingView()
                    .frame(minHeight: 400)

            case .failure(let error):
                ErrorView(error: error) {
                    await viewModel.loadDetails(forceRefresh: true)
                }
                .frame(minHeight: 400)

            case .success(let experience):
                experienceContent(experience)
            }
        }
        .background(AppColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadDetails()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    private func experienceContent(_ experience: ExperienceEntity) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero section
                ExperienceHeroView(
                    coverPhoto: experience.coverPhoto,
                    viewsCount: experience.viewsCount,
                    has360: !experience.tourHTML.isEmpty,
                    hasVideo: experience.hasVideo,
                    onExploreTap: {
                    }
                )

                // Info section
                ExperienceInfoView(
                    title: experience.title,
                    cityName: experience.city.name,
                    description: experience.description,
                    likesCount: experience.likesCount,
                    isLiked: experience.isLiked,
                    onLikeTap: {
                        await viewModel.likeExperience()
                    },
                    onShareTap: {
                        // TODO: Share action
                    }
                )
            }
        }
    }
}

#Preview {
    Container.setupPreviewContainer()
    return NavigationStack {
        ExperienceDetailView(viewModel: ExperienceDetailViewModel(experienceId: "1"))
    }
}
