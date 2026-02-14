//
//  AsyncState.swift
//  AEShared
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

/// Generic state enum for handling different async operation states across the application
/// Provides type-safe state management for async operations in ViewModels, repositories, and use cases
public enum AsyncState<T> {
    case idle
    case loading
    case success(T)
    case failure(Error)
}

// MARK: - Computed Properties

public extension AsyncState {

    /// Returns true if the state is idle
    var isIdle: Bool {
        if case .idle = self {
            return true
        }
        return false
    }

    /// Returns true if the state is loading
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    /// Returns true if the state is success
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }

    /// Returns true if the state is failure
    var isFailure: Bool {
        if case .failure = self {
            return true
        }
        return false
    }

    /// Returns the success value if available
    var successValue: T? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }

    /// Returns the error if the state is failure
    var error: Error? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }

    /// Returns true if the state has a value (success state)
    var hasValue: Bool {
        successValue != nil
    }

    /// Returns true if the state has an error (failure state)
    var hasError: Bool {
        error != nil
    }

}

// MARK: - Mapping

public extension AsyncState {

    /// Maps the success value to another type
    /// - Parameter transform: Transform function to apply to success value
    /// - Returns: New AsyncState with transformed success value
    func map<U>(_ transform: (T) -> U) -> AsyncState<U> {
        switch self {
        case .idle:
            return .idle
        case .loading:
            return .loading
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }

    /// Maps the success value to another AsyncState
    /// - Parameter transform: Transform function that returns an AsyncState
    /// - Returns: Flattened AsyncState result
    func flatMap<U>(_ transform: (T) -> AsyncState<U>) -> AsyncState<U> {
        switch self {
        case .idle:
            return .idle
        case .loading:
            return .loading
        case .success(let value):
            return transform(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - Equatable

extension AsyncState: Equatable where T: Equatable {
    public static func == (lhs: AsyncState<T>, rhs: AsyncState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.success(let lhsValue), .success(let rhsValue)):
            return lhsValue == rhsValue
        case (.failure(let lhsError), .failure(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
