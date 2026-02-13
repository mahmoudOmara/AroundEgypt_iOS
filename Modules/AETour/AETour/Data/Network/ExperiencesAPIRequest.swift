//
//  ExperiencesAPIRequest.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import AECore

/// API request definitions for experience endpoints
enum ExperiencesAPIRequest {
    case getRecommended
    case getRecent
    case search(query: String)
    case getDetails(id: String)
    case like(id: String)
}

extension ExperiencesAPIRequest: APIRequestRepresentable {
    var path: String {
        switch self {
        case .getRecommended, .getRecent, .search:
            return "/api/v2/experiences"
        case .getDetails(let id):
            return "/api/v2/experiences/\(id)"
        case .like(let id):
            return "/api/v2/experiences/\(id)/like"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .like:
            return .POST
        default:
            return .GET
        }
    }

    var queryParams: [String: String]? {
        switch self {
        case .getRecommended:
            return ["filter[recommended]": "true"]
        case .search(let query):
            return ["filter[title]": query]
        default:
            return nil
        }
    }

    var headers: HTTPHeaders? { nil }
    var jsonBody: Parameters? { nil }
    var multipartBody: [UploadMediaFile]? { nil }
}
