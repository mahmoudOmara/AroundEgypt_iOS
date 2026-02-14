//
//  TourCoordinatorView.swift
//  AETour
//
//  Created by M. Omara on 14/02/2026.
//

import SwiftUI
import AEShared

/// View that manages the tour coordinator's navigation stack
public struct TourCoordinatorView: View {
    @ObservedObject private var coordinator: TourCoordinator
    private let initialView: AnyView

    public init(coordinator: TourCoordinator) {
        self.coordinator = coordinator
        self.initialView = AnyView(coordinator.destination(for: .home))
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            initialView
                .navigationDestination(for: TourDestination.self) { destination in
                    coordinator.destination(for: destination)
                }
        }
        .applyModalPresentation(item: $coordinator.presentedItem) { presentation in
            coordinator.modal(for: presentation.destination)
                .applyPresentationConfiguration(presentation)
        }
    }
}
