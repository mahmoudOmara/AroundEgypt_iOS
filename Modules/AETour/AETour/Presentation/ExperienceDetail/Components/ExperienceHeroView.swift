//
//  ExperienceHeroView.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI
import AEShared

/// Hero image section for experience detail screen
struct ExperienceHeroView: View {
    let coverPhoto: String
    let viewsCount: Int
    let has360: Bool
    let hasVideo: Bool
    let onExploreTap: () -> Void

    var body: some View {
        ZStack {
            coverImageSection
            gradientOverlay
            exploreButton
            bottomOverlay
        }
        .frame(height: 300)
    }

    private var coverImageSection: some View {
        AsyncImageView(url: coverPhoto)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
    }

    private var gradientOverlay: some View {
        LinearGradient(
            colors: [
                Color.black.opacity(0.4),
                Color.clear,
                Color.black.opacity(0.6)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var exploreButton: some View {
        Button(action: onExploreTap) {
            Text("EXPLORE NOW")
                .font(AppTypography.button)
                .foregroundColor(AppColors.textOnPrimary)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .background(AppColors.primary)
                .cornerRadius(AppRadius.button)
        }
    }

    private var bottomOverlay: some View {
        VStack {
            Spacer()

            HStack(alignment: .bottom) {
                viewsCountView
                Spacer()

                if hasVideo {
                    videoGalleryView
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.md)
        }
    }

    private var viewsCountView: some View {
        HStack(spacing: AppSpacing.xxs) {
            Image(systemName: "eye")
                .font(.system(size: 20))
            Text("\(viewsCount) views")
                .font(AppTypography.body)
        }
        .foregroundColor(AppColors.textOnPrimary)
    }

    private var videoGalleryView: some View {
        Image(systemName: "photo.stack")
            .font(.system(size: 16))
            .foregroundColor(.white)
            .padding(AppSpacing.xxs)
            .background(AppColors.overlayDark)
            .clipShape(Circle())
    }
}

#Preview {
    let experience = PreviewData.sampleExperience
    ExperienceHeroView(
        coverPhoto: experience.coverPhoto,
        viewsCount: experience.viewsCount,
        has360: !experience.tourHTML.isEmpty,
        hasVideo: true,
        onExploreTap: {
        }
    )
}
