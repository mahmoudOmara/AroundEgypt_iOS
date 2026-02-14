//
//  AppTypography.swift
//  AEShared
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI

/// Application-wide typography tokens for consistent text styling
public struct AppTypography {

    // MARK: - Title Styles

    /// Large title style (34pt bold)
    public static let titleLarge = Font.system(size: 34, weight: .bold)

    /// Medium title style (28pt bold)
    public static let titleMedium = Font.system(size: 28, weight: .bold)

    /// Small title style (22pt semibold)
    public static let titleSmall = Font.system(size: 22, weight: .semibold)

    // MARK: - Headline Styles

    /// Standard headline style (17pt semibold)
    public static let headline = Font.system(size: 17, weight: .semibold)

    /// Small headline style (15pt semibold)
    public static let headlineSmall = Font.system(size: 15, weight: .semibold)

    // MARK: - Body Styles

    /// Standard body style (17pt regular)
    public static let body = Font.system(size: 17, weight: .regular)

    /// Medium body style (15pt regular)
    public static let bodyMedium = Font.system(size: 15, weight: .regular)

    /// Small body style (13pt regular)
    public static let bodySmall = Font.system(size: 13, weight: .regular)

    // MARK: - Caption Styles

    /// Standard caption style (12pt regular)
    public static let caption = Font.system(size: 12, weight: .regular)

    /// Bold caption style (12pt semibold)
    public static let captionBold = Font.system(size: 12, weight: .semibold)

    /// Small caption style (11pt regular)
    public static let captionSmall = Font.system(size: 11, weight: .regular)

    // MARK: - Badge Styles

    /// Badge text style (10pt bold)
    public static let badge = Font.system(size: 10, weight: .bold)

    /// Medium badge text style (11pt semibold)
    public static let badgeMedium = Font.system(size: 11, weight: .semibold)

    // MARK: - Button Styles

    /// Standard button style (17pt semibold)
    public static let button = Font.system(size: 17, weight: .semibold)

    /// Small button style (15pt medium)
    public static let buttonSmall = Font.system(size: 15, weight: .medium)
}
