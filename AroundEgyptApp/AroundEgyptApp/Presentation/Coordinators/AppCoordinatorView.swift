//
//  AppCoordinatorView.swift
//  AroundEgyptApp
//
//  Created by M. Omara on 14/02/2026.
//

import SwiftUI
import AEShared

/// View that manages the app coordinator's state-based navigation
struct AppCoordinatorView: View {
    @ObservedObject private var coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    var body: some View {
        coordinator.destination(for: coordinator.currentState)
            .applyModalPresentation(item: $coordinator.presentedItem) { presentation in
                coordinator.modal(for: presentation.destination)
                    .applyPresentationConfiguration(presentation)
            }
    }
}
