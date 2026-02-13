//
//  APIRequestRepresentable.swift
//  AECore
//
//  Created by M. Omara on 03/09/2025.
//

import Foundation

public typealias HTTPHeaders = [String:String]
public typealias Parameters = [String: Any]

/// Protocol for API request representation
/// Implementation should be provided by consuming apps with their specific configuration
/// Protocol for API request representation
/// 
/// This protocol defines the structure for making API requests in a type-safe manner.
/// It works in conjunction with NetworkConfiguration to provide flexible endpoint configuration.
///
/// ## Base URL Handling
/// - If `baseURL` returns `nil`, the NetworkConfiguration's baseURL will be used
/// - If `baseURL` returns a URL, it overrides the NetworkConfiguration's baseURL for this specific request
/// - Use override for special cases like CDN endpoints, third-party APIs, or different API versions
///
/// ## Example Implementation
/// ```swift
/// enum MyAPIRequest: APIRequestRepresentable {
///     case getUser(id: String)
///     case uploadAvatar(Data)
///     
///     var baseURL: URL? {
///         switch self {
///         case .uploadAvatar:
///             return URL(string: "https://cdn.myapp.com/") // Override for CDN
///         default:
///             return nil // Use NetworkConfiguration's baseURL
///         }
///     }
///     
///     var path: String {
///         switch self {
///         case .getUser(let id):
///             return "users/\(id)"
///         case .uploadAvatar:
///             return "upload/avatar"
///         }
///     }
/// }
/// ```
public protocol APIRequestRepresentable {
    
    /// Base URL for the request (optional override)
    /// - Returns: URL to override NetworkConfiguration's baseURL, or nil to use the configured baseURL
    var baseURL: URL? { get }
    
    /// API endpoint path (relative to base URL)
    /// - Returns: The path component of the API endpoint (e.g., "auth/login", "users/123")
    var path: String { get }
    
    /// HTTP method for the request
    /// - Returns: The HTTP method (GET, POST, PUT, DELETE, PATCH)
    var method: HTTPMethod { get }
    
    /// HTTP headers for the request
    /// - Returns: Dictionary of HTTP headers, or nil if no custom headers needed
    var headers: HTTPHeaders? { get }
    
    /// Query parameters to append to the URL
    /// - Returns: Dictionary of query parameters, or nil if no parameters needed
    var queryParams: [String: String]? { get }
    
    /// JSON body for the request
    /// - Returns: Dictionary representing the JSON body, or nil for requests without body
    var jsonBody: Parameters? { get }
    
    /// Multipart form data for file uploads
    /// - Returns: Array of files to upload, or nil for non-multipart requests
    var multipartBody: [UploadMediaFile]? { get }
}

// MARK: - Default Implementations

public extension APIRequestRepresentable {
    /// Default implementation returns nil to use NetworkConfiguration's baseURL
    /// Override this property only when you need to use a different endpoint
    var baseURL: URL? {
        return nil
    }
}
