//
//  View+ModalPresentation.swift
//  AEShared
//
//  Created by M. Omara on 14/02/2026.
//

import SwiftUI

// MARK: - Modal Presentation View Modifiers

public extension View {
    /// Applies modal presentation configuration based on ModalPresentation
    @ViewBuilder
    func applyModalPresentation<Destination: Hashable, Content: View>(
        item: Binding<ModalPresentation<Destination>?>,
        @ViewBuilder content: @escaping (ModalPresentation<Destination>) -> Content
    ) -> some View {
        self.modifier(ModalPresentationModifier(item: item, modalContent: content))
    }

    /// Applies presentation configuration to a presented view
    @ViewBuilder
    func applyPresentationConfiguration<Destination: Hashable>(
        _ presentation: ModalPresentation<Destination>
    ) -> some View {
        self
            .presentationDragIndicator(presentation.options.showDragIndicator ? .visible : .hidden)
            .interactiveDismissDisabled(presentation.options.disableDismiss)
            .applyBackgroundInteraction(presentation.options.backgroundInteraction)
    }

    /// Applies background interaction behavior
    @ViewBuilder
    private func applyBackgroundInteraction(_ interaction: PresentationBackgroundInteraction) -> some View {
        switch interaction {
        case .automatic:
            self
        case .enabled:
            if #available(iOS 16.4, *) {
                self.presentationBackgroundInteraction(.enabled)
            } else {
                self
            }
        case .disabled:
            if #available(iOS 16.4, *) {
                self.presentationBackgroundInteraction(.disabled)
            } else {
                self
            }
        }
    }
}

// MARK: - Modal Presentation Modifier

private struct ModalPresentationModifier<Destination: Hashable, ModalContent: View>: ViewModifier {
    @Binding var item: ModalPresentation<Destination>?
    let modalContent: (ModalPresentation<Destination>) -> ModalContent

    func body(content: Content) -> some View {
        content
            .sheet(item: sheetBinding) { presentation in
                modalContent(presentation)
            }
            .fullScreenCover(item: fullScreenBinding) { presentation in
                modalContent(presentation)
            }
    }

    private var sheetBinding: Binding<ModalPresentation<Destination>?> {
        Binding(
            get: {
                guard let item = item else { return nil }
                switch item.style {
                case .sheet, .sheetWithDetents:
                    return item
                case .fullScreenCover:
                    return nil
                }
            },
            set: { newValue in
                if newValue == nil {
                    item = nil
                }
            }
        )
    }

    private var fullScreenBinding: Binding<ModalPresentation<Destination>?> {
        Binding(
            get: {
                guard let item = item else { return nil }
                switch item.style {
                case .fullScreenCover:
                    return item
                case .sheet, .sheetWithDetents:
                    return nil
                }
            },
            set: { newValue in
                if newValue == nil {
                    item = nil
                }
            }
        )
    }
}

// MARK: - Sheet with Detents Support

public extension View {
    /// Applies custom detents if available in the presentation style
    @ViewBuilder
    func applyDetents<Destination: Hashable>(_ presentation: ModalPresentation<Destination>) -> some View {
        switch presentation.style {
        case .sheetWithDetents(let detents):
            self.presentationDetents(Set(detents))
        default:
            self
        }
    }
}
