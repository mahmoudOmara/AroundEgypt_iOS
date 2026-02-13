//
//  Container+AroundEgyptApp.swift
//  GoodsMart
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit
import AECore
import AEShared

// MARK: - Auto Registration

extension Container: @retroactive AutoRegistering {

    /// Automatically called by Factory before first dependency resolution
    /// Use this to register app-specific implementations that override module stubs
    public func autoRegister() {
        // Register NetworkClient with environment-based configuration
        // This overrides the stub registered in Container+GMCore
        networkClient.register {
            let configuration = NetworkConfiguration(
                baseURL: URL(string: "aroundegypt.34ml.com")!,
                requestTimeout: 30,
                resourceTimeout: 60,
                maxRetryAttempts: 3,
                cacheSize: 50 * 1024 * 1024, // 50MB
                enableLogging: Constants.Development.enableLogging,
                jsonDecoder: JSONDecoder()
            )
            return MoyaNetworkClient(
                configuration: configuration,
                logger: self.logger(),
                additionalPlugins: []
            )
        }
    }
}
