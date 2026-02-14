//
//  OnboardingView.swift
//  AroundEgyptApp
//
//  Created by M. Omara on 14/02/2026.
//

import SwiftUI
import AEShared

/// Onboarding/Splash screen shown on app launch
struct OnboardingView: View {
    let onComplete: () -> Void

    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.primary,
                    AppColors.primaryDark
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Splash/Onboarding content
            VStack(spacing: AppSpacing.xl) {
                Spacer()

                // App icon/logo
                Image(systemName: "globe.europe.africa.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                // App name
                VStack(spacing: AppSpacing.xs) {
                    Text("Around Egypt")
                        .font(AppTypography.titleLarge)
                        .foregroundColor(.white)
                        .opacity(logoOpacity)

                    Text("Explore Egypt in 360°")
                        .font(AppTypography.body)
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(logoOpacity)
                }

                Spacer()

                // Loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                    .padding(.bottom, AppSpacing.xxl)
                    .opacity(logoOpacity)
            }
        }
        .onAppear {
            // Animate the logo entrance
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }

            // Transition to main content after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onComplete()
            }
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
