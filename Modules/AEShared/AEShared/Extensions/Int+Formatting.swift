//
//  Int+Formatting.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

public extension Int {
    /// Formats the integer for display (e.g., 156 → "156", 1500 → "1.5K", 2300000 → "2.3M")
    var easyDisplay: String {
        switch self {
        case 0..<1000:
            return "\(self)"
        case 1000..<1_000_000:
            let value = Double(self) / 1000.0
            return String(format: "%.1fK", value)
        default:
            let value = Double(self) / 1_000_000.0
            return String(format: "%.1fM", value)
        }
    }
}
