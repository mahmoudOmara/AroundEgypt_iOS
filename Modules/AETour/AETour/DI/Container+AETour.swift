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
            let modelTypes: [any PersistentModel.Type] = [
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

    // MARK: - Use Cases

    /// Use case for fetching recommended experiences
    public var getRecommendedExperiencesUseCase: Factory<GetRecommendedExperiencesUseCase> {
        self { GetRecommendedExperiencesUseCase() }
    }

    /// Use case for fetching recent experiences
    public var getRecentExperiencesUseCase: Factory<GetRecentExperiencesUseCase> {
        self { GetRecentExperiencesUseCase() }
    }

    /// Use case for searching experiences
    public var searchExperiencesUseCase: Factory<SearchExperiencesUseCase> {
        self { SearchExperiencesUseCase() }
    }

    /// Use case for fetching experience details
    public var getExperienceDetailsUseCase: Factory<GetExperienceDetailsUseCase> {
        self { GetExperienceDetailsUseCase() }
    }

    /// Use case for liking an experience
    public var likeExperienceUseCase: Factory<LikeExperienceUseCase> {
        self { LikeExperienceUseCase() }
    }
}
