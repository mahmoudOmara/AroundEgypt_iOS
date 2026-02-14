//
//  EmptyStateView.swift
//  AEShared
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI

/// A reusable empty state view for when no data is available
public struct EmptyStateView: View {
    let message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(AppColors.textSecondary)

            Text(message)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    EmptyStateView(message: "No experiences available")
}
