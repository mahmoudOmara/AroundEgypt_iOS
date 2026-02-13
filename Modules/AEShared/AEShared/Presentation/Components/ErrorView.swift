//
//  ErrorView.swift
//  AEShared
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI

/// A reusable error state view showing error details and retry button
public struct ErrorView: View {
    let error: Error
    let onRetry: () async -> Void

    public init(error: Error, onRetry: @escaping () async -> Void) {
        self.error = error
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(AppColors.textSecondary)

            Text(error.localizedDescription)
                .font(AppTypography.headline)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)

            if let recoverySuggestion = (error as? LocalizedError)?.recoverySuggestion {
                Text(recoverySuggestion)
                    .font(AppTypography.bodySmall)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task { await onRetry() }
            } label: {
                Text("Retry")
                    .font(AppTypography.button)
                    .foregroundColor(AppColors.textOnPrimary)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.vertical, AppSpacing.sm)
                    .background(AppColors.primary)
                    .cornerRadius(AppRadius.button)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ErrorView(error: NSError(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])) {
        // Preview retry action
    }
}
