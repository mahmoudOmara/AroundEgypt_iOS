//
//  AppColors.swift
//  AEShared
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI

/// Application-wide color tokens for consistent theming with dark mode support
public struct AppColors {

    // MARK: - Primary Colors

    /// Primary brand color - iOS blue
    public static let primary = Color(hex: "007AFF")

    /// Darker shade of primary color
    public static let primaryDark = Color(hex: "0051D5")

    /// Lighter shade of primary color
    public static let primaryLight = Color(hex: "4DA3FF")

    // MARK: - Secondary Colors

    /// Secondary accent color - Orange
    public static let secondary = Color(hex: "FF9500")

    // MARK: - Background Colors

    /// Main background color (adapts to dark mode)
    public static let background = Color(
        light: Color(hex: "FFFFFF"),
        dark: Color(hex: "000000")
    )

    /// Secondary background color (adapts to dark mode)
    public static let backgroundSecondary = Color(
        light: Color(hex: "F2F2F7"),
        dark: Color(hex: "1C1C1E")
    )

    /// Tertiary background color (adapts to dark mode)
    public static let backgroundTertiary = Color(
        light: Color(hex: "E5E5EA"),
        dark: Color(hex: "2C2C2E")
    )

    // MARK: - Card Colors

    /// Card background color (adapts to dark mode)
    public static let cardBackground = Color(
        light: .white,
        dark: Color(hex: "1C1C1E")
    )

    /// Card shadow color (adapts to dark mode)
    public static let cardShadow = Color.black.opacity(0.1)

    // MARK: - Text Colors

    /// Primary text color (adapts to dark mode)
    public static let textPrimary = Color(
        light: Color(hex: "000000"),
        dark: Color(hex: "FFFFFF")
    )

    /// Secondary text color (adapts to dark mode)
    public static let textSecondary = Color(
        light: Color(hex: "3C3C43").opacity(0.6),
        dark: Color(hex: "EBEBF5").opacity(0.6)
    )

    /// Tertiary text color (adapts to dark mode)
    public static let textTertiary = Color(
        light: Color(hex: "3C3C43").opacity(0.3),
        dark: Color(hex: "EBEBF5").opacity(0.3)
    )

    /// Text color on primary background
    public static let textOnPrimary = Color.white

    // MARK: - Badge Colors

    /// Recommended badge background color
    public static let recommendedBadge = Color(hex: "007AFF")

    /// 360° badge background color (adapts to dark mode)
    public static let badge360Background = Color(
        light: Color.white.opacity(0.9),
        dark: Color.black.opacity(0.7)
    )

    /// 360° badge text color (adapts to dark mode)
    public static let badge360Text = Color(
        light: Color(hex: "000000"),
        dark: Color(hex: "FFFFFF")
    )

    // MARK: - Overlay Colors

    /// Dark overlay color
    public static let overlayDark = Color.black.opacity(0.6)

    /// Light overlay color (adapts to dark mode)
    public static let overlayLight = Color(
        light: Color.white.opacity(0.9),
        dark: Color.black.opacity(0.7)
    )

    // MARK: - Status Colors

    /// Active like color (filled heart)
    public static let likeActive = Color(hex: "FF3B30")

    /// Inactive like color (outline heart) (adapts to dark mode)
    public static let likeInactive = Color(
        light: Color(hex: "3C3C43").opacity(0.3),
        dark: Color(hex: "EBEBF5").opacity(0.3)
    )

    /// Icon tint color (adapts to dark mode)
    public static let iconTint = Color(
        light: Color(hex: "3C3C43").opacity(0.6),
        dark: Color(hex: "EBEBF5").opacity(0.6)
    )
}

// MARK: - Color Extension for Hex Initialization

public extension Color {
    /// Initialize a Color from a hex string
    /// - Parameters:
    ///   - hex: Hex string (e.g., "007AFF")
    ///   - opacity: Optional opacity value (0.0 to 1.0)
    init(hex: String, opacity: Double = 1.0) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b, opacity: opacity)
    }

    /// Initialize a Color with different values for light and dark mode
    /// - Parameters:
    ///   - light: Color for light mode
    ///   - dark: Color for dark mode
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
}

// MARK: - UIColor Extension for Dark Mode Support

private extension UIColor {
    /// Initialize a UIColor with different values for light and dark mode
    /// - Parameters:
    ///   - light: UIColor for light mode
    ///   - dark: UIColor for dark mode
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }
    }
}
