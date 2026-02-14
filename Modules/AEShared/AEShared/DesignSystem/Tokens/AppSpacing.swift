//
//  AppSpacing.swift
//  AEShared
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

/// Application-wide spacing tokens for consistent layout spacing
public struct AppSpacing {

    // MARK: - Base Spacing Scale (multiples of 4)

    /// Extra extra extra small spacing (2pt)
    public static let xxxs: CGFloat = 2

    /// Extra extra small spacing (4pt)
    public static let xxs: CGFloat = 4

    /// Extra small spacing (8pt)
    public static let xs: CGFloat = 8

    /// Small spacing (12pt)
    public static let sm: CGFloat = 12

    /// Medium spacing (16pt)
    public static let md: CGFloat = 16

    /// Large spacing (20pt)
    public static let lg: CGFloat = 20

    /// Extra large spacing (24pt)
    public static let xl: CGFloat = 24

    /// Extra extra large spacing (32pt)
    public static let xxl: CGFloat = 32

    /// Extra extra extra large spacing (40pt)
    public static let xxxl: CGFloat = 40

    // MARK: - Component-Specific Spacing

    /// Padding for card components (16pt)
    public static let cardPadding: CGFloat = md

    /// Padding for screen edges (16pt)
    public static let screenPadding: CGFloat = md

    /// Spacing between sections (24pt)
    public static let sectionSpacing: CGFloat = xl

    /// Spacing between items in a list/grid (12pt)
    public static let itemSpacing: CGFloat = sm
}
