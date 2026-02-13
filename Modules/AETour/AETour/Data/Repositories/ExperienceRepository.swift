//
//  ExperienceRepository.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit
import AECore

/// Repository implementation for experiences - handles remote-first with local fallback
final class ExperienceRepository: ExperienceRepositoryProtocol {

    // MARK: - Properties

    @Injected(\.experienceRemoteDataSource) private var remoteDataSource: ExperienceRemoteDataSource
    @Injected(\.experienceLocalDataSource) private var localDataSource: ExperienceLocalDataSource
    @Injected(\.logger) private var logger: Logger

    // MARK: - Initialization

    init() {}

    // MARK: - ExperienceRepositoryProtocol

    func getRecommendedExperiences(forceRefresh: Bool) async throws -> [ExperienceEntity] {
        do {
            let dtos = try await remoteDataSource.getRecommendedExperiences()
            let models = dtos.map { $0.toModel() }

            do {
                try await localDataSource.saveExperiences(models)
            } catch let swiftDataError as SwiftDataError {
                logger.error("Failed to cache experiences: \(swiftDataError)")
            }

            return models.map { $0.toEntity() }
        } catch let networkError as NetworkError {
            logger.error("Remote fetch failed, falling back to cache: \(networkError)")

            do {
                let cached = try await localDataSource.getRecommendedExperiences()
                return cached.map { $0.toEntity() }
            } catch let swiftDataError as SwiftDataError {
                throw ExperienceError.persistenceError(swiftDataError)
            } catch {
                throw ExperienceError.networkError(networkError)
            }
        }
    }

    func getRecentExperiences(forceRefresh: Bool) async throws -> [ExperienceEntity] {
        do {
            let dtos = try await remoteDataSource.getRecentExperiences()
            let models = dtos.map { $0.toModel() }

            do {
                try await localDataSource.saveExperiences(models)
            } catch let swiftDataError as SwiftDataError {
                logger.error("Failed to cache experiences: \(swiftDataError)")
            }

            return models.map { $0.toEntity() }
        } catch let networkError as NetworkError {
            logger.error("Remote fetch failed, falling back to cache: \(networkError)")

            do {
                let cached = try await localDataSource.getRecentExperiences()
                return cached.map { $0.toEntity() }
            } catch let swiftDataError as SwiftDataError {
                throw ExperienceError.persistenceError(swiftDataError)
            } catch {
                throw ExperienceError.networkError(networkError)
            }
        }
    }

    func searchExperiences(query: String) async throws -> [ExperienceEntity] {
        do {
            let dtos = try await remoteDataSource.searchExperiences(query: query)
            return dtos.map { $0.toModel().toEntity() }
        } catch let error as NetworkError {
            throw ExperienceError.networkError(error)
        }
    }

    func getExperienceDetails(id: String, forceRefresh: Bool) async throws -> ExperienceEntity {
        do {
            let dto = try await remoteDataSource.getExperienceDetails(id: id)
            let model = dto.toModel()

            do {
                try await localDataSource.saveExperiences([model])
            } catch let swiftDataError as SwiftDataError {
                logger.error("Failed to cache experience: \(swiftDataError)")
            }

            return model.toEntity()
        } catch let networkError as NetworkError {
            logger.error("Remote fetch failed, falling back to cache: \(networkError)")

            do {
                if let cached = try await localDataSource.getExperienceById(id) {
                    return cached.toEntity()
                }
                throw ExperienceError.experienceNotFound
            } catch let swiftDataError as SwiftDataError {
                throw ExperienceError.persistenceError(swiftDataError)
            } catch let experienceError as ExperienceError {
                throw experienceError
            } catch {
                throw ExperienceError.networkError(networkError)
            }
        }
    }

    func likeExperience(id: String) async throws -> ExperienceEntity {
        do {
            let dto = try await remoteDataSource.likeExperience(id: id)
            let model = dto.toModel()

            do {
                try await localDataSource.updateLikeStatus(
                    id: id,
                    isLiked: true,
                    likesCount: model.likesCount
                )
            } catch let swiftDataError as SwiftDataError {
                logger.error("Failed to update like status in cache: \(swiftDataError)")
            }

            return model.toEntity()
        } catch let error as NetworkError {
            throw ExperienceError.networkError(error)
        }
    }
}
