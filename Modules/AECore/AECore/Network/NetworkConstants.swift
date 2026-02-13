//
//  NetworkConstants.swift
//  AECore
//
//  Created by M. Omara on 03/09/2025.
//

import Foundation

/// Network-related constants and default configurations
/// These are fallback values that can be overridden via NetworkConfiguration
public struct NetworkConstants {
    
    // MARK: - Headers
    
    public struct Headers {
        public static let accept = "accept"
        public static let authorization = "Authorization"
        public static let contentType = "Content-Type"
    }
    
    // MARK: - Content Types
    
    public struct ContentTypes {
        public static let json = "application/json"
        public static let formURLEncoded = "application/x-www-form-urlencoded"
        public static let multipartFormData = "multipart/form-data"
    }
    
    // MARK: - Default Values
    
    public struct Defaults {
        public static let requestTimeout: TimeInterval = 30.0
        public static let resourceTimeout: TimeInterval = 60.0
        public static let maxRetryAttempts = 3
        public static let cacheSize = 50 * 1024 * 1024 // 50MB
    }
}
