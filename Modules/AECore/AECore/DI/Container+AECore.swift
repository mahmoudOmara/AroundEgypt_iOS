//
//  Container+GMCore.swift
//  AECore
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit

extension Container {

    // MARK: - Infrastructure Services (Singleton Scope)

    /// Network client for API communication
    /// This is a stub registration that MUST be overridden by the app module
    /// using autoRegister() to provide the actual implementation with baseURL
    /// Scope: Singleton - shared URLSession and configuration across app
    public var networkClient: Factory<NetworkClient> {
        self {
            fatalError("NetworkClient must be registered from app module using autoRegister() with proper baseURL")
        }
        .singleton
    }

    /// Logger service for debugging and monitoring
    /// Scope: Singleton - centralized logging configuration
    public var logger: Factory<Logger> {
        self {
            #if DEBUG
            return ConsoleLogger(minLevel: .debug)
            #else
            return ConsoleLogger(minLevel: .error)
            #endif
        }
        .singleton
    }
}
