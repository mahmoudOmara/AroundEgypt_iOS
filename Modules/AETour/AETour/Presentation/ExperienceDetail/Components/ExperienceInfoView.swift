//
//  ExperienceInfoView.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI
import AEShared

/// Info section for experience detail screen showing title, location, description, and actions
struct ExperienceInfoView: View {
    let title: String
    let cityName: String
    let description: String
    let likesCount: Int
    let isLiked: Bool
    let onLikeTap: () async -> Void
    let onShareTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Title and actions
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(title)
                        .font(AppTypography.titleMedium)
                        .foregroundColor(AppColors.textPrimary)

                    Text("\(cityName), Egypt.")
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(AppColors.textSecondary)
                }

                Spacer()

                // Action buttons
                HStack(spacing: AppSpacing.sm) {
                    // Share button
                    Button(action: onShareTap) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.iconTint)
                    }

                    // Like button
                    Button {
                        Task { await onLikeTap() }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? AppColors.likeActive : AppColors.iconTint)
                            Text(likesCount.easyDisplay)
                                .font(AppTypography.bodyMedium)
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
                }
            }

            // Description section
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("Description")
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textPrimary)

                Text(description)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textSecondary)
                    .lineSpacing(4)
            }
        }
        .padding(AppSpacing.md)
    }
}

#Preview {
    let experience = PreviewData.sampleExperience
    return ExperienceInfoView(
        title: experience.title,
        cityName: experience.city.name,
        description: experience.description,
        likesCount: experience.likesCount,
        isLiked: experience.isLiked,
        onLikeTap: {},
        onShareTap: {}
    )
}
