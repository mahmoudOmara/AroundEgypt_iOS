//
//  APIRequestTarget.swift
//  AECore
//
//  Created by M. Omara on 03/09/2025.
//

import Foundation
import Moya
import Alamofire

/// Adapter to convert APIRequestRepresentable to Moya TargetType
public struct APIRequestTarget: TargetType {
    private let apiRequest: APIRequestRepresentable
    private let configuration: NetworkConfiguration
    
    public init(apiRequest: APIRequestRepresentable, configuration: NetworkConfiguration) {
        self.apiRequest = apiRequest
        self.configuration = configuration
    }
    
    public var baseURL: URL {
        // Use apiRequest.baseURL if provided (for special endpoints),
        // otherwise fall back to NetworkConfiguration's baseURL
        return apiRequest.baseURL ?? configuration.baseURL
    }
    
    public var path: String {
        return apiRequest.path
    }
    
    public var method: Moya.Method {
        switch apiRequest.method {
        case .GET:
            return .get
        case .POST:
            return .post
        case .PUT:
            return .put
        case .DELETE:
            return .delete
        case .PATCH:
            return .patch
        }
    }
    
    public var task: Task {
        var urlParameters: [String: Any] = [:]
        
        // Add query parameters to URL parameters
        if let queryParams = apiRequest.queryParams {
            urlParameters.merge(queryParams) { (_, new) in new }
        }
        
        // Handle different body types
        if let multipartBody = apiRequest.multipartBody, !multipartBody.isEmpty {
            let multipartData = multipartBody.map { uploadFile in
                MultipartFormData(
                    provider: .data(uploadFile.data),
                    name: uploadFile.key,
                    fileName: uploadFile.filename,
                    mimeType: uploadFile.mimeType
                )
            }
            return .uploadMultipart(multipartData)
        } else if let jsonBody = apiRequest.jsonBody {
            if urlParameters.isEmpty {
                return .requestParameters(parameters: jsonBody, encoding: JSONEncoding.default)
            } else {
                return .requestCompositeParameters(
                    bodyParameters: jsonBody,
                    bodyEncoding: JSONEncoding.default,
                    urlParameters: urlParameters
                )
            }
        } else if !urlParameters.isEmpty {
            return .requestParameters(parameters: urlParameters, encoding: URLEncoding.queryString)
        } else {
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        var allHeaders: [String: String] = [:]
        
        // Start with NetworkConfiguration's default headers
        allHeaders.merge(configuration.defaultHeaders) { (_, new) in new }
        
        // Override with request-specific headers
        if let requestHeaders = apiRequest.headers {
            allHeaders.merge(requestHeaders) { (_, new) in new }
        }
        
        return allHeaders.isEmpty ? nil : allHeaders
    }
}
