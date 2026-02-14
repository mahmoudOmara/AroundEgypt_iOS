//
//  TourCoordinator.swift
//  AETour
//
//  Created by M. Omara on 14/02/2026.
//

import SwiftUI
import AEShared
import Combine

// MARK: - Tour Destination

/// Defines navigation destinations in the tour flow
public enum TourDestination: Hashable {
    case home
}

// MARK: - Tour Modal Destination

/// Defines modal destinations in the tour flow
public enum TourModalDestination: Hashable {
    case experienceDetail(experience: ExperienceEntity)
}

// MARK: - Tour Coordinator

/// Coordinator managing the tour feature navigation flow
@MainActor
public final class TourCoordinator: @MainActor NavigationCoordinator {
    public typealias Destination = TourDestination
    public typealias ModalDestination = TourModalDestination

    // MARK: - Published Properties

    @Published public var path = NavigationPath()
    @Published public var presentedItem: ModalPresentation<TourModalDestination>?

    // MARK: - Initializer

    public init() {}

    // MARK: - Lifecycle

    public func start() -> AnyView {
        return AnyView(TourCoordinatorView(coordinator: self))
    }

    // MARK: - Destination Builder

    @ViewBuilder
    public func destination(for destination: TourDestination) -> some View {
        switch destination {
        case .home:
            createHomeView()
        }
    }
    
    @ViewBuilder
    public func modal(for destination: TourModalDestination) -> some View {
        switch destination {
        case .experienceDetail(let experience):
            createExperienceDetailView(experience: experience)
        }
    }

    // MARK: - Private View Factories

    private func createHomeView() -> some View {
        let viewModel = HomeViewModel(coordinator: self)
        return HomeView(viewModel: viewModel)
    }

    private func createExperienceDetailView(experience: ExperienceEntity) -> some View {
        let viewModel = ExperienceDetailViewModel(coordinator: self, experience: experience)
        return ExperienceDetailView(viewModel: viewModel)
    }
}
