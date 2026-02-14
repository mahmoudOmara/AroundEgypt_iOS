//
//  ExperienceError.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import AECore

/// Domain-specific errors for the Tour/Experience feature
public enum ExperienceError: LocalizedError {

    // MARK: - Business Logic Errors

    case invalidExperienceID
    case experienceNotFound
    case invalidSearchQuery
    case alreadyLiked

    // MARK: - Network Errors

    case networkError(NetworkError)

    // MARK: - Persistence Errors

    case persistenceError(SwiftDataError)

    // MARK: - LocalizedError Conformance

    public var errorDescription: String? {
        switch self {
        case .invalidExperienceID:
            return "Invalid experience identifier"
        case .experienceNotFound:
            return "Experience not found"
        case .invalidSearchQuery:
            return "Invalid search query"
        case .alreadyLiked:
            return "Experience already liked"
        case .networkError(let error):
            return "Network error: \(error.errorDescription ?? "Unknown")"
        case .persistenceError(let error):
            return "Persistence error: \(error.errorDescription ?? "Unknown")"
        }
    }

    public var failureReason: String? {
        switch self {
        case .invalidExperienceID:
            return "The provided experience ID is empty or invalid"
        case .experienceNotFound:
            return "The requested experience does not exist or has been removed"
        case .invalidSearchQuery:
            return "The search query is too short or contains invalid characters"
        case .alreadyLiked:
            return "You have already liked this experience"
        case .networkError(let error):
            return error.failureReason
        case .persistenceError(let error):
            return error.failureReason
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .invalidExperienceID:
            return "Please try again or contact support if the issue persists"
        case .experienceNotFound:
            return "Please refresh the list or try searching for other experiences"
        case .invalidSearchQuery:
            return "Please enter at least 2 characters to search"
        case .alreadyLiked:
            return "This experience is already in your liked list"
        case .networkError(let error):
            if case .networkUnavailable = error {
                return "Please check your internet connection"
            }
            return "Please check your internet connection and try again"
        case .persistenceError:
            return "Try restarting the app or clearing local data"
        }
    }
}
