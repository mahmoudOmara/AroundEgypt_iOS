//
//  ExperienceLocalDataSource.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit
import AECore
import SwiftData

/// Local data source for caching experiences using SwiftData
/// All operations performed on background context to prevent UI blocking
final class ExperienceLocalDataSource {

    // MARK: - Properties

    @Injected(\.persistenceClient) private var persistenceClient: SwiftDataPersistenceClient
    @Injected(\.logger) private var logger: Logger

    // MARK: - Initialization

    init() {}

    // MARK: - Read Methods (Background context for non-blocking operations)

    func getRecommendedExperiences() async throws -> [ExperienceModel] {
        logger.info("Fetching recommended experiences from cache")

        return try await persistenceClient.performBackgroundTask { context in
            let predicate = #Predicate<ExperienceModel> { $0.isRecommended == true }
            let descriptor = FetchDescriptor(predicate: predicate)
            return try context.fetch(descriptor)
        }
    }

    func getRecentExperiences() async throws -> [ExperienceModel] {
        logger.info("Fetching recent experiences from cache")

        return try await persistenceClient.performBackgroundTask { context in
            let descriptor = FetchDescriptor<ExperienceModel>()
            return try context.fetch(descriptor)
        }
    }

    func getExperienceById(_ id: String) async throws -> ExperienceModel? {
        logger.info("Fetching experience by ID from cache: \(id)")

        return try await persistenceClient.performBackgroundTask { context in
            let predicate = #Predicate<ExperienceModel> { $0.id == id }
            let descriptor = FetchDescriptor(predicate: predicate)
            return try context.fetch(descriptor).first
        }
    }

    // MARK: - Write Methods (Background context to avoid UI blocking)

    func saveExperiences(_ experiences: [ExperienceModel]) async throws {
        logger.info("Saving \(experiences.count) experiences to cache")

        try await persistenceClient.performBackgroundTask { context in
            var cityCache: [Int: CityModel] = [:]

            for experience in experiences {
                guard let cityId = experience.city?.id,
                      let cityName = experience.city?.name else {
                    context.insert(experience)
                    continue
                }

                // Check cache first
                if let cachedCity = cityCache[cityId] {
                    experience.city = cachedCity
                } else {
                    // Check database
                    let predicate = #Predicate<CityModel> { $0.id == cityId }
                    let descriptor = FetchDescriptor(predicate: predicate)

                    if let existingCity = try context.fetch(descriptor).first {
                        experience.city = existingCity
                        cityCache[cityId] = existingCity
                    } else {
                        // Create new city and cache it for subsequent experiences
                        let newCity = CityModel(id: cityId, name: cityName)
                        context.insert(newCity)
                        experience.city = newCity
                        cityCache[cityId] = newCity
                    }
                }

                context.insert(experience)
            }
            try context.save()
        }
    }

    func updateLikeStatus(id: String, isLiked: Bool, likesCount: Int) async throws {
        logger.info("Updating like status for experience ID: \(id)")

        try await persistenceClient.performBackgroundTask { context in
            let predicate = #Predicate<ExperienceModel> { $0.id == id }
            let descriptor = FetchDescriptor(predicate: predicate)

            if let experience = try context.fetch(descriptor).first {
                experience.isLiked = isLiked
                experience.likesCount = likesCount
                try context.save()
            } else {
                self.logger.warning("Experience not found for ID: \(id)")
            }
        }
    }

    func clearCache() async throws {
        logger.info("Clearing experience cache")

        try await persistenceClient.performBackgroundTask { context in
            try context.delete(model: ExperienceModel.self)
            try context.delete(model: CityModel.self)
            try context.save()
        }
    }
}
