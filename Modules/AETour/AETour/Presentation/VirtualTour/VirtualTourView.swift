//
//  VirtualTourView.swift
//  AETour
//
//  Created by M. Omara on 14/02/2026.
//

import SwiftUI
import AEShared

/// Full-screen modal view for displaying 360° virtual tours
/// Includes HTMLWebView with close button overlay
struct VirtualTourView: View {
    let htmlURL: String
    let coordinator: TourCoordinator

    var body: some View {
        ZStack {
            // Background: HTMLWebView fills entire screen
            HTMLWebView(url: htmlURL)
                .ignoresSafeArea()
                .overlay(alignment: .topTrailing) {
                    closeButton
                        .padding(.top, AppSpacing.md)
                        .padding(.trailing, AppSpacing.md)
                }
        }
    }

    private var closeButton: some View {
        Button {
            coordinator.dismissModal()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(.white)
                .background(
                    Circle()
                        .fill(.black.opacity(0.6))
                        .frame(width: 36, height: 36)
                )
        }
        .accessibilityLabel("Close virtual tour")
    }
}

#Preview {
    VirtualTourView(
        htmlURL: "https://fls-9ff553c9-95cd-4102-b359-74ad35cdc461.laravel.cloud/1598534877vtour/vtour/tour.html",
        coordinator: TourCoordinator()
    )
}
