//
//  ExperienceHorizontalSectionView.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI
import AEShared
import AECore

/// A reusable horizontal scrolling section for experiences with AsyncState support
struct ExperienceHorizontalSectionView: View {
    let title: String
    let emptyStateMessage: String
    let state: AsyncState<[ExperienceEntity]>
    let onExperienceTap: (ExperienceEntity) -> Void
    let on360Tap: (ExperienceEntity) -> Void
    let onLikeTap: (ExperienceEntity) -> Void
    let onRetry: () async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .font(AppTypography.titleSmall)
                .foregroundColor(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, AppSpacing.screenPadding)

            switch state {
            case .idle, .loading:
                LoadingView()
                    .frame(height: 200)

            case .failure(let error):
                ErrorView(error: error, onRetry: onRetry)
                    .frame(height: 200)

            case .success(let experiences):
                experiencesView(experiences: experiences)
            }
        }
    }
    
    @ViewBuilder
    private func experiencesView(experiences: [ExperienceEntity]) -> some View {
        if experiences.isEmpty {
            EmptyStateView(message: emptyStateMessage)
                .frame(height: 200)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: AppSpacing.xs) {
                    ForEach(experiences, id: \.id) { experience in
                        ExperienceCardBuilder(
                            experience: experience,
                            onTap: {
                                onExperienceTap(experience)
                            },
                            on360Tap: {
                                on360Tap(experience)
                            },
                            onLikeTap: {
                                onLikeTap(experience)
                            }
                        )
                        .containerRelativeFrame(.horizontal) { length, _ in
                            length - AppSpacing.screenPadding * 2
                        }
                        .frame(height: 220)
                    }
                }
                .padding(.horizontal, AppSpacing.screenPadding)
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    ExperienceHorizontalSectionView(
        title: "Recommended Experiences",
        emptyStateMessage: "No experiences available",
        state: .success(PreviewData.sampleExperiences),
        onExperienceTap: { _ in },
        on360Tap: { _ in },
        onLikeTap: { _ in },
        onRetry: {}
    )
}
