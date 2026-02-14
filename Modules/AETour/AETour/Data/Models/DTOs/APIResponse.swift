//
//  APIResponse.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

/// Generic wrapper for all API responses
struct APIResponse<T: Codable>: Codable {
    let meta: MetaDTO
    let data: T

    var isSuccess: Bool {
        meta.code == 200
    }

    var hasErrors: Bool {
        !meta.errors.isEmpty
    }
}

/// Metadata included in all API responses
struct MetaDTO: Codable {
    let code: Int
    let errors: [APIErrorDTO]
    let exception: String?
}

/// Error detail from API
struct APIErrorDTO: Codable {
    let type: String
    let message: String
}
