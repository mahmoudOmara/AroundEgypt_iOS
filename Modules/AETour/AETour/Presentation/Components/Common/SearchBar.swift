//
//  SearchBar.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI
import AEShared

/// A reusable search bar component styled for iOS
struct SearchBar: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.iconTint)

            TextField(placeholder, text: $text)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textPrimary)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.iconTint)
                }
            }
        }
        .padding(AppSpacing.sm)
        .background(AppColors.backgroundSecondary)
        .cornerRadius(AppRadius.medium)
    }
}

#Preview {
    SearchBar(text: .constant("Luxor"), placeholder: "Search experiences...")
        .padding()
}
