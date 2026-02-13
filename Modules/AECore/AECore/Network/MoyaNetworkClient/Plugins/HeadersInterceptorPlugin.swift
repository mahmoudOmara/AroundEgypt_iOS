//
//  HeadersInterceptorPlugin.swift
//  AECore
//
//  Created by M. Omara on 04/09/2025.
//

import Foundation
import Moya

/// Generic headers interceptor that can be configured by consuming apps
/// Keeps AECore business-agnostic while providing flexibility
public final class HeadersInterceptorPlugin: PluginType {
        
    private let headersProvider: HeadersProvider
    
    /// Initialize with a provider that provides headers
    /// This allows the consuming app to inject their specific business logic
    public init(headersProvider: HeadersProvider) {
        self.headersProvider = headersProvider
    }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var modifiedRequest = request
        
        // Get headers from the consuming app
        let additionalHeaders = headersProvider.provideHeaders()
        
        // Add all provided headers to the request
        for (key, value) in additionalHeaders {
            modifiedRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return modifiedRequest
    }
}

// MARK: - Protocol for Headers Provider

/// Protocol that can be implemented by consuming apps to provide headers
public protocol HeadersProvider {
    func provideHeaders() -> [String: String]
}
