//
//  Container+AETour.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit
import AECore
import SwiftData

extension Container {

    // MARK: - Persistence

    /// SwiftData persistence client for local database operations
    /// Configured with all required model types for the Tour module
    public var persistenceClient: Factory<SwiftDataPersistenceClient> {
        self {
            // Define all SwiftData models used in this module
            let modelTypes = [
                ExperienceModel.self,
                CityModel.self
            ]

            // Create the persistence client with the model schema
            do {
                return try SwiftDataPersistenceClient(modelTypes: modelTypes)
            } catch {
                fatalError("Failed to initialize SwiftDataPersistenceClient: \(error)")
            }
        }
        .singleton
    }

    // MARK: - Data Sources

    /// Local data source for caching experiences
    var experienceLocalDataSource: Factory<ExperienceLocalDataSource> {
        self { ExperienceLocalDataSource() }
            .singleton
    }

    /// Remote data source for fetching experiences from API
    var experienceRemoteDataSource: Factory<ExperienceRemoteDataSource> {
        self { ExperienceRemoteDataSource() }
            .singleton
    }

    // MARK: - Repository

    /// Experience repository - handles data operations for experiences
    public var experienceRepository: Factory<ExperienceRepositoryProtocol> {
        self {
            ExperienceRepository()
        }
        .singleton
    }
}
