//
//  AppRadius.swift
//  AEShared
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

/// Application-wide border radius tokens for consistent rounded corners
public struct AppRadius {

    // MARK: - Base Radius Scale

    /// Small radius (4pt)
    public static let small: CGFloat = 4

    /// Medium radius (8pt)
    public static let medium: CGFloat = 8

    /// Large radius (12pt)
    public static let large: CGFloat = 12

    /// Extra large radius (16pt)
    public static let extraLarge: CGFloat = 16

    /// Circle radius (9999pt) - for fully circular shapes
    public static let circle: CGFloat = 9999

    // MARK: - Component-Specific Radius

    /// Border radius for card components (12pt)
    public static let card: CGFloat = large

    /// Border radius for badge components (9999pt - circular)
    public static let badge: CGFloat = circle

    /// Border radius for button components (8pt)
    public static let button: CGFloat = medium
}
