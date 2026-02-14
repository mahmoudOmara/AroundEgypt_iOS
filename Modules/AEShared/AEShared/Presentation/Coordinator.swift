//
//  Coordinator.swift
//  AEShared
//
//  Created by M. Omara on 14/02/2026.
//

import SwiftUI

// MARK: - Presentation Types

/// Defines the presentation style for modals
public enum PresentationStyle: Equatable {
    case sheet
    case fullScreenCover
    case sheetWithDetents([PresentationDetent])

    public static func == (lhs: PresentationStyle, rhs: PresentationStyle) -> Bool {
        switch (lhs, rhs) {
        case (.sheet, .sheet):
            return true
        case (.fullScreenCover, .fullScreenCover):
            return true
        case (.sheetWithDetents(let lhsDetents), .sheetWithDetents(let rhsDetents)):
            return lhsDetents.count == rhsDetents.count
        default:
            return false
        }
    }
}

/// Background interaction behavior for presented sheets
public enum PresentationBackgroundInteraction {
    case automatic
    case enabled
    case disabled
}

/// Configuration options for modal presentation
public struct PresentationOptions {
    public var showDragIndicator: Bool
    public var disableDismiss: Bool
    public var backgroundInteraction: PresentationBackgroundInteraction

    public init(
        showDragIndicator: Bool = true,
        disableDismiss: Bool = false,
        backgroundInteraction: PresentationBackgroundInteraction = .automatic
    ) {
        self.showDragIndicator = showDragIndicator
        self.disableDismiss = disableDismiss
        self.backgroundInteraction = backgroundInteraction
    }
}

/// Wrapper for modal presentation with configuration
public struct ModalPresentation<Destination: Hashable>: Identifiable {
    public let id = UUID()
    public let destination: Destination
    public let style: PresentationStyle
    public let options: PresentationOptions

    public init(destination: Destination, style: PresentationStyle, options: PresentationOptions) {
        self.destination = destination
        self.style = style
        self.options = options
    }
}

// MARK: - Base Coordinator Protocol

/// Base protocol for all coordinators providing navigation and modal presentation capabilities
@MainActor
public protocol Coordinator: ObservableObject {
    associatedtype ModalDestination: Hashable

    /// Currently presented modal item
    var presentedItem: ModalPresentation<ModalDestination>? { get set }

    /// Starts the coordinator and returns the initial view
    func start() -> AnyView

    /// Presents a modal with specified style and options
    func present(_ destination: ModalDestination, style: PresentationStyle, options: PresentationOptions)

    /// Dismisses the currently presented modal
    func dismissModal()
}

// MARK: - Default Implementation

public extension Coordinator {
    /// Default implementation for presenting modals
    func present(_ destination: ModalDestination, style: PresentationStyle = .sheet, options: PresentationOptions = PresentationOptions()) {
        presentedItem = ModalPresentation(destination: destination, style: style, options: options)
    }

    /// Default implementation for dismissing modals
    func dismissModal() {
        presentedItem = nil
    }
}

// MARK: - StateCoordinator Protocol

/// Coordinator that manages navigation through discrete states
@MainActor
public protocol StateCoordinator: Coordinator {
    associatedtype State

    /// Current state of the coordinator
    var currentState: State { get set }

    /// Transitions to a new state
    func transition(to state: State)
}

// MARK: - StateCoordinator Default Implementation

public extension StateCoordinator {
    /// Default implementation for state transitions
    func transition(to state: State) {
        currentState = state
    }
}

// MARK: - NavigationCoordinator Protocol

/// Coordinator that manages stack-based navigation
@MainActor
public protocol NavigationCoordinator: Coordinator {
    associatedtype Destination: Hashable

    /// Navigation path for stack-based navigation
    var path: NavigationPath { get set }

    /// Navigates to a destination by pushing it onto the stack
    func navigate(to destination: Destination)

    /// Pops the current view from the navigation stack
    func pop()

    /// Pops to the root view of the navigation stack
    func popToRoot()
}

// MARK: - NavigationCoordinator Default Implementation

public extension NavigationCoordinator {
    /// Default implementation for navigation
    func navigate(to destination: Destination) {
        path.append(destination)
    }

    /// Default implementation for popping
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    /// Default implementation for popping to root
    func popToRoot() {
        path = NavigationPath()
    }
}
