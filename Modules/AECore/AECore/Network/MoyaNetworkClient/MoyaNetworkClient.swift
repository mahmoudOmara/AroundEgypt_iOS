//
//  MoyaNetworkClient.swift
//  AECore
//
//  Created by M. Omara on 03/09/2025.
//

import Foundation
import Combine
import Moya
import CombineMoya
import Alamofire

/// Moya network client for API integration
/// Provides Combine-based networking with error handling and caching
public final class MoyaNetworkClient: NetworkClient {
    
    // MARK: - Properties
    
    /// Moya provider for API requests
    private let provider: MoyaProvider<MultiTarget>
        
    /// Network configuration
    public let configuration: NetworkConfiguration
    
    // MARK: - Initialization
    
    public init(
        configuration: NetworkConfiguration,
        logger: Logger? = nil,
        additionalPlugins: [PluginType] = []
    ) {
        precondition(configuration.requestTimeout > 0, "Request timeout must be positive")
        precondition(configuration.resourceTimeout > 0, "Resource timeout must be positive")
        precondition(configuration.maxRetryAttempts >= 0, "Max retry attempts cannot be negative")
        precondition(configuration.cacheSize > 0, "Cache size must be positive")
        
        self.configuration = configuration
        
        // Configure URL session
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = configuration.requestTimeout
        sessionConfiguration.timeoutIntervalForResource = configuration.resourceTimeout
        sessionConfiguration.urlCache = URLCache(
            memoryCapacity: configuration.cacheSize / 4,
            diskCapacity: configuration.cacheSize,
            diskPath: "network_cache"
        )
        let session = Session(configuration: sessionConfiguration)

        // Configure Moya provider with custom logging plugin
        var allPlugins = additionalPlugins
        if let logger = logger {
            let customLoggingPlugin = CustomNetworkLoggingPlugin(logger: logger, isEnabled: configuration.enableLogging)
            allPlugins.insert(customLoggingPlugin, at: 0)
        }
        
        self.provider = MoyaProvider<MultiTarget>(session: session, plugins: allPlugins)
    }
    
    // MARK: - Public Methods
    
    /// Performs a network request using APIRequestRepresentable
    /// - Parameters:
    ///   - apiRequest: The API request representation
    ///   - type: The expected response type
    /// - Returns: Publisher that emits the decoded response or an error
    public func perform<T: Decodable>(_ apiRequest: APIRequestRepresentable, type: T.Type) async throws(NetworkError) -> T {
    let target = APIRequestTarget(apiRequest: apiRequest, configuration: configuration)
    
    do {
        let response = try await withCheckedThrowingContinuation { continuation in
            provider.request(MultiTarget(target)) { result in
                continuation.resume(with: result)
            }
        }
        let decodedData = try configuration.jsonDecoder.decode(type, from: response.data)
        return decodedData
    } catch let moyaError as MoyaError {
        throw mapMoyaError(moyaError)
    } catch let decodingError as DecodingError {
        throw NetworkError.decodingError(decodingError)
    } catch {
        throw NetworkError.unknown(error)
    }
}
    
    
    // MARK: - Private Methods
    
    private func mapMoyaError(_ error: MoyaError) -> NetworkError {
        switch error {
        case .imageMapping, .jsonMapping, .stringMapping, .encodableMapping:
            return .decodingError(error)
        case .statusCode(let response):
            return NetworkError.fromStatusCode(response.statusCode)
        case .underlying(let nsError, _):
            if let urlError = nsError as? URLError {
                return NetworkError.fromURLError(urlError)
            }
            return .unknown(nsError)
        case .objectMapping(let error, _):
            return .decodingError(error)
        case .requestMapping:
            return .invalidURL
        case .parameterEncoding(let error):
            return .unknown(error)
        @unknown default:
            return .unknown(error)
        }
    }
}
