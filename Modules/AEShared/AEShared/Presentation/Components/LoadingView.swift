//
//  LoadingView.swift
//  AEShared
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI

/// A reusable loading state view showing a progress indicator
public struct LoadingView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())

            Text("Loading...")
                .font(AppTypography.bodySmall)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    LoadingView()
}
