//
//  AroundEgyptAppApp.swift
//  AroundEgyptApp
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI

@main
struct AroundEgyptAppApp: App {
    @StateObject private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            appCoordinator.start()
        }
    }
}
