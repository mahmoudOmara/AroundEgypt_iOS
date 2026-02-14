//
//  ExperienceCard.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI
import AEShared

struct ExperienceCard: View {
    let title: String
    let coverPhoto: String
    let isRecommended: Bool
    let tourHTML: String
    let viewsCount: Int
    let hasVideo: Bool
    let likesCount: Int
    let isLiked: Bool
    let on360Tap: () -> Void
    let onLikeTap: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            coverImagesection
            titleSection
                .padding(.horizontal, AppSpacing.xxs)
        }
    }
     
    private var coverImagesection: some View {
        AsyncImageView(url: coverPhoto)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
            .overlay {
                coverOverlay
            }
    }
    
    private var titleSection: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .font(AppTypography.headline)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(2)
            Spacer()
            
            LikeButton(
                count: likesCount,
                isLiked: isLiked,
                onTap: onLikeTap
            )
        }
    }
    
    private var coverOverlay: some View {
        VStack {
            // Top overlays
            HStack {
                if isRecommended {
                    recommendedView
                }

                Spacer()

                infoButton
            }
            .padding(AppSpacing.xs)

            Spacer()

            if !tourHTML.isEmpty {
                button360
            }

            Spacer()

            HStack {
                viewsCountView

                Spacer()

                if hasVideo {
                    videoGalleryView
                }
            }
            .padding(AppSpacing.xs)
        }
    }
    
    private var recommendedView: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "star.fill")
                .foregroundColor(AppColors.likeActive)
            Text("RECOMMENDED")
                .foregroundColor(AppColors.textOnPrimary)
        }
        .font(AppTypography.badge)
        .padding(.horizontal, AppSpacing.xs)
        .padding(.vertical, AppSpacing.xxs)
        .background(AppColors.recommendedBadge)
        .cornerRadius(AppRadius.circle)
    }
    
    private var infoButton: some View {
        Image(systemName: "info.circle")
            .font(.system(size: 20))
            .foregroundColor(.white)
            .padding(AppSpacing.xxs)
            .background(AppColors.overlayDark)
            .clipShape(Circle())
    }
    
    private var button360: some View {
        Button(action: on360Tap) {
            HStack {
                Spacer()
                VStack(spacing: 2) {
                    Image(systemName: "globe")
                        .font(.system(size: 18))
                    Text("360°")
                        .font(AppTypography.badge)
                }
                .foregroundColor(AppColors.badge360Text)
                .padding(AppSpacing.sm)
                .background(AppColors.badge360Background)
                .clipShape(Circle())
                Spacer()
            }
        }
    }
    
    private var viewsCountView: some View {
        HStack(spacing: 4) {
            Image(systemName: "eye.fill")
                .font(.system(size: 12))
            Text(viewsCount.easyDisplay)
                .font(AppTypography.captionBold)
        }
        .foregroundColor(.white)
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

#Preview("ExperienceCardd Stub") {
    VStack {
        ExperienceCard(
            title: "Desert Adventure at Sunrise",
            coverPhoto: Constants.Development.randomImage,
            isRecommended: true,
            tourHTML: Constants.Development.basicHTML,
            viewsCount: 12840,
            hasVideo: true,
            likesCount: 342,
            isLiked: false,
            on360Tap: {},
            onLikeTap: {}
        )
        .background(Color.red)
    }
    .padding()
    .background(Color.black.opacity(0.1))
}
