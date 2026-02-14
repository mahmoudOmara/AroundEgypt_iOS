//
//  NetworkConfiguration.swift
//  AECore
//
//  Created by M. Omara on 03/09/2025.
//

import Foundation

/// Configuration object for network client
/// Allows each app to customize network behavior without modifying AECore
public struct NetworkConfiguration {
    
    // MARK: - Properties
    
    /// Base URL for API requests
    public let baseURL: URL
    
    /// Request timeout interval
    public let requestTimeout: TimeInterval
    
    /// Resource timeout interval
    public let resourceTimeout: TimeInterval
    
    /// Maximum number of retry attempts
    public let maxRetryAttempts: Int
    
    /// Cache size in bytes
    public let cacheSize: Int
    
    /// Whether to enable verbose logging
    public let enableLogging: Bool
    
    /// Custom JSON decoder for API responses
    public let jsonDecoder: JSONDecoder
    
    /// Default headers to include in all requests
    public let defaultHeaders: [String: String]
    
    // MARK: - Initialization
    
    public init(
        baseURL: URL,
        requestTimeout: TimeInterval = NetworkConstants.Defaults.requestTimeout,
        resourceTimeout: TimeInterval = NetworkConstants.Defaults.resourceTimeout,
        maxRetryAttempts: Int = NetworkConstants.Defaults.maxRetryAttempts,
        cacheSize: Int = NetworkConstants.Defaults.cacheSize,
        enableLogging: Bool = false,
        jsonDecoder: JSONDecoder = JSONDecoder(),
        defaultHeaders: [String: String] = [:]
    ) {
        self.baseURL = baseURL
        self.requestTimeout = requestTimeout
        self.resourceTimeout = resourceTimeout
        self.maxRetryAttempts = maxRetryAttempts
        self.cacheSize = cacheSize
        self.enableLogging = enableLogging
        self.jsonDecoder = jsonDecoder
        self.defaultHeaders = defaultHeaders
    }
}
