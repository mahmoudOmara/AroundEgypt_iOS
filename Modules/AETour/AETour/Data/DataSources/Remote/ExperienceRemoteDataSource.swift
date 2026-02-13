//
//  ExperienceRemoteDataSource.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit
import AECore

/// Remote data source for fetching experiences from API
final class ExperienceRemoteDataSource {

    // MARK: - Properties

    @Injected(\.networkClient) private var networkClient: NetworkClient
    @Injected(\.logger) private var logger: Logger

    // MARK: - Initialization

    init() {}

    // MARK: - Methods

    private func handleResponse<T>(_ response: APIResponse<T>) throws -> T {
        guard response.isSuccess else {
            if let firstError = response.meta.errors.first {
                logger.error("API error: \(firstError.type) - \(firstError.message)")
                if response.meta.code == 404 {
                    throw NetworkError.notFound
                }
                throw NetworkError.serverError
            }
            throw NetworkError.httpError(response.meta.code)
        }

        return response.data
    }

    func getRecommendedExperiences() async throws -> [ExperienceDTO] {
        logger.info("Fetching recommended experiences from API")
        let response = try await networkClient.perform(
            ExperiencesAPIRequest.getRecommended,
            type: APIResponse<[ExperienceDTO]>.self
        )
        return try handleResponse(response)
    }

    func getRecentExperiences() async throws -> [ExperienceDTO] {
        logger.info("Fetching recent experiences from API")
        let response = try await networkClient.perform(
            ExperiencesAPIRequest.getRecent,
            type: APIResponse<[ExperienceDTO]>.self
        )
        return try handleResponse(response)
    }

    func searchExperiences(query: String) async throws -> [ExperienceDTO] {
        logger.info("Searching experiences with query: \(query)")
        let response = try await networkClient.perform(
            ExperiencesAPIRequest.search(query: query),
            type: APIResponse<[ExperienceDTO]>.self
        )
        return try handleResponse(response)
    }

    func getExperienceDetails(id: String) async throws -> ExperienceDTO {
        logger.info("Fetching experience details for ID: \(id)")
        let response = try await networkClient.perform(
            ExperiencesAPIRequest.getDetails(id: id),
            type: APIResponse<ExperienceDTO>.self
        )
        return try handleResponse(response)
    }

    func likeExperience(id: String) async throws -> ExperienceDTO {
        logger.info("Liking experience with ID: \(id)")
        let response = try await networkClient.perform(
            ExperiencesAPIRequest.like(id: id),
            type: APIResponse<ExperienceDTO>.self
        )
        return try handleResponse(response)
    }
}
