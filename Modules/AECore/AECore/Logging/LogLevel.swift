//
//  LogLevel.swift
//  AECore
//
//  Created by M. Omara on 03/09/2025.
//

import Foundation

public enum LogLevel: Int {
    case debug = 0
    case info
    case warning
    case error
    case none
    
    var prefix: String {
        switch self {
        case .debug: return "🔷 DEBUG"
        case .info: return "ℹ️ INFO"
        case .warning: return "⚠️ WARNING"
        case .error: return "❌ ERROR"
        case .none: return ""
        }
    }
}
