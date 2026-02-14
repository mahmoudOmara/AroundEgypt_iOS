//
//  ExperienceModelFixtures.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import Foundation
import SwiftData
@testable import AETour
@testable import AECore

/// Provides helper methods to create ExperienceModel instances for testing
/// Note: ExperienceModel uses @Model macro and must be inserted into a ModelContext
enum ExperienceModelFixtures {

    // MARK: - City Creation Helpers

    /// Creates a Cairo city model
    static func createCairoCity() -> CityModel {
        return CityModel(id: 1, name: "Cairo")
    }

    /// Creates a Luxor city model
    static func createLuxorCity() -> CityModel {
        return CityModel(id: 2, name: "Luxor")
    }

    /// Creates an Alexandria city model
    static func createAlexandriaCity() -> CityModel {
        return CityModel(id: 3, name: "Alexandria")
    }

    // MARK: - Experience Creation Helpers

    /// Creates Great Pyramids experience model
    /// - Parameter city: Optional city model. If nil, creates Cairo city.
    static func createPyramidsModel(city: CityModel? = nil) -> ExperienceModel {
        let cityModel = city ?? createCairoCity()
        return ExperienceModel(
            id: "1",
            title: "Great Pyramids of Giza",
            coverPhoto: "https://example.com/pyramids.jpg",
            experienceDescription: "Explore the ancient wonders of the Great Pyramids, one of the Seven Wonders of the Ancient World",
            viewsCount: 15420,
            likesCount: 2340,
            isRecommended: true,
            hasVideo: true,
            city: cityModel,
            tourHTML: "https://example.com/tours/pyramids.html",
            isLiked: false
        )
    }

    /// Creates Great Sphinx experience model
    static func createSphinxModel(city: CityModel? = nil) -> ExperienceModel {
        let cityModel = city ?? createCairoCity()
        return ExperienceModel(
            id: "2",
            title: "The Great Sphinx",
            coverPhoto: "https://example.com/sphinx.jpg",
            experienceDescription: "Witness the majestic Great Sphinx, guardian of the Giza Plateau",
            viewsCount: 12800,
            likesCount: 1890,
            isRecommended: true,
            hasVideo: false,
            city: cityModel,
            tourHTML: "https://example.com/tours/sphinx.html",
            isLiked: false
        )
    }

    /// Creates Valley of the Kings experience model
    static func createValleyOfKingsModel(city: CityModel? = nil) -> ExperienceModel {
        let cityModel = city ?? createLuxorCity()
        return ExperienceModel(
            id: "3",
            title: "Valley of the Kings",
            coverPhoto: "https://example.com/valley.jpg",
            experienceDescription: "Discover the ancient burial ground of Egyptian pharaohs in Luxor",
            viewsCount: 9500,
            likesCount: 1450,
            isRecommended: false,
            hasVideo: true,
            city: cityModel,
            tourHTML: "https://example.com/tours/valley.html",
            isLiked: false
        )
    }

    /// Creates Karnak Temple experience model
    static func createKarnakTempleModel(city: CityModel? = nil) -> ExperienceModel {
        let cityModel = city ?? createLuxorCity()
        return ExperienceModel(
            id: "4",
            title: "Karnak Temple",
            coverPhoto: "https://example.com/karnak.jpg",
            experienceDescription: "Visit the vast temple complex dedicated to the Theban gods",
            viewsCount: 11200,
            likesCount: 1670,
            isRecommended: true,
            hasVideo: true,
            city: cityModel,
            tourHTML: "https://example.com/tours/karnak.html",
            isLiked: false
        )
    }

    /// Creates Alexandria Library experience model
    static func createAlexandriaLibraryModel(city: CityModel? = nil) -> ExperienceModel {
        let cityModel = city ?? createAlexandriaCity()
        return ExperienceModel(
            id: "5",
            title: "Bibliotheca Alexandrina",
            coverPhoto: "https://example.com/library.jpg",
            experienceDescription: "Modern recreation of the ancient Library of Alexandria",
            viewsCount: 6800,
            likesCount: 890,
            isRecommended: false,
            hasVideo: false,
            city: cityModel,
            tourHTML: "https://example.com/tours/library.html",
            isLiked: false
        )
    }

    // MARK: - Generic Creation Helper

    /// Creates a custom experience model with specified parameters
    static func createCustomModel(
        id: String = "test-id",
        title: String = "Test Experience",
        coverPhoto: String = "https://example.com/test.jpg",
        experienceDescription: String = "Test description",
        viewsCount: Int = 100,
        likesCount: Int = 10,
        isRecommended: Bool = false,
        hasVideo: Bool = false,
        city: CityModel? = nil,
        tourHTML: String = "https://example.com/tours/test.html",
        isLiked: Bool = false
    ) -> ExperienceModel {
        let cityModel = city ?? createCairoCity()
        return ExperienceModel(
            id: id,
            title: title,
            coverPhoto: coverPhoto,
            experienceDescription: experienceDescription,
            viewsCount: viewsCount,
            likesCount: likesCount,
            isRecommended: isRecommended,
            hasVideo: hasVideo,
            city: cityModel,
            tourHTML: tourHTML,
            isLiked: isLiked
        )
    }

    // MARK: - Collection Helpers

    /// Creates all standard experience models with proper city relationships
    /// Returns tuple of (experiences, cities) for insertion into context
    static func createAllModels() -> (experiences: [ExperienceModel], cities: [CityModel]) {
        let cairo = createCairoCity()
        let luxor = createLuxorCity()
        let alexandria = createAlexandriaCity()

        let experiences = [
            createPyramidsModel(city: cairo),
            createSphinxModel(city: cairo),
            createValleyOfKingsModel(city: luxor),
            createKarnakTempleModel(city: luxor),
            createAlexandriaLibraryModel(city: alexandria)
        ]

        return (experiences, [cairo, luxor, alexandria])
    }

    /// Creates only recommended experience models
    static func createRecommendedModels() -> (experiences: [ExperienceModel], cities: [CityModel]) {
        let cairo = createCairoCity()
        let luxor = createLuxorCity()

        let experiences = [
            createPyramidsModel(city: cairo),
            createSphinxModel(city: cairo),
            createKarnakTempleModel(city: luxor)
        ]

        return (experiences, [cairo, luxor])
    }
}
