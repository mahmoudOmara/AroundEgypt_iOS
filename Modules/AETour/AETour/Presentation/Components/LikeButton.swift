//
//  LikeButton.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI
import AEShared

/// A reusable like button component with heart icon and count
struct LikeButton: View {
    let count: Int
    let isLiked: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.xxs) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? AppColors.likeActive : AppColors.likeInactive)

                Text(count.easyDisplay)
                    .font(AppTypography.captionBold)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 20) {
        LikeButton(count: 45, isLiked: false) {}
        LikeButton(count: 1523, isLiked: true) {}
    }
    .padding()
}
