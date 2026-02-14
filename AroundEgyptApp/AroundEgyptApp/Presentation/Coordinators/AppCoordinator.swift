//
//  AppCoordinator.swift
//  AroundEgyptApp
//
//  Created by M. Omara on 14/02/2026.
//

import SwiftUI
import AEShared
import AETour
import Combine

// MARK: - App State

/// Defines the main states of the application
enum AppState: Equatable {
    case onboarding
    case main
}

// MARK: - App Modal Destination

/// Defines modal destinations at the app level
enum AppModalDestination: Hashable {
    // Add app-level modals here if needed
}

// MARK: - App Coordinator

/// Root coordinator managing the main application flow
@MainActor
final class AppCoordinator: @MainActor StateCoordinator {
    typealias ModalDestination = AppModalDestination

    // MARK: - Published Properties

    @Published var currentState: AppState = .onboarding
    @Published var presentedItem: ModalPresentation<AppModalDestination>?

    // MARK: - Child Coordinators

    var tourCoordinator: TourCoordinator?

    // MARK: - Lifecycle

    func start() -> AnyView {
        return AnyView(AppCoordinatorView(coordinator: self))
    }

    // MARK: - Destination Builder

    @ViewBuilder
    func destination(for state: AppState) -> some View {
        switch state {
        case .onboarding:
            OnboardingView(onComplete: { [weak self] in
                self?.transition(to: .main)
            })
            .transition(.opacity)

        case .main:
            createTourCoordinator()
                .transition(.opacity)
        }
    }

    @ViewBuilder
    func modal(for destination: AppModalDestination) -> some View {
        // Add modal views here if needed
        EmptyView()
    }

    // MARK: - Private Methods

    private func createTourCoordinator() -> AnyView {
        let coordinator = TourCoordinator()
        tourCoordinator = coordinator
        return coordinator.start()
    }
}
