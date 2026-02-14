//
//  ExperienceEntityFixtures.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import Foundation
@testable import AETour

/// Provides predefined ExperienceEntity instances for testing
enum ExperienceEntityFixtures {

    // MARK: - City Fixtures

    static let cairoEntity = CityEntity(id: 1, name: "Cairo")
    static let luxorEntity = CityEntity(id: 2, name: "Luxor")
    static let alexandriaEntity = CityEntity(id: 3, name: "Alexandria")

    // MARK: - Experience Fixtures

    /// Great Pyramids of Giza - recommended, not liked
    static let pyramids = ExperienceEntity(
        id: "1",
        title: "Great Pyramids of Giza",
        coverPhoto: "https://example.com/pyramids.jpg",
        description: "Explore the ancient wonders of the Great Pyramids, one of the Seven Wonders of the Ancient World",
        viewsCount: 15420,
        likesCount: 2340,
        isRecommended: true,
        hasVideo: true,
        city: cairoEntity,
        tourHTML: "https://example.com/tours/pyramids.html",
        isLiked: false
    )

    /// Great Pyramids - liked version
    static let pyramidsLiked = ExperienceEntity(
        id: "1",
        title: "Great Pyramids of Giza",
        coverPhoto: "https://example.com/pyramids.jpg",
        description: "Explore the ancient wonders of the Great Pyramids, one of the Seven Wonders of the Ancient World",
        viewsCount: 15420,
        likesCount: 2341,
        isRecommended: true,
        hasVideo: true,
        city: cairoEntity,
        tourHTML: "https://example.com/tours/pyramids.html",
        isLiked: true
    )

    /// The Great Sphinx - recommended, not liked
    static let sphinx = ExperienceEntity(
        id: "2",
        title: "The Great Sphinx",
        coverPhoto: "https://example.com/sphinx.jpg",
        description: "Witness the majestic Great Sphinx, guardian of the Giza Plateau",
        viewsCount: 12800,
        likesCount: 1890,
        isRecommended: true,
        hasVideo: false,
        city: cairoEntity,
        tourHTML: "https://example.com/tours/sphinx.html",
        isLiked: false
    )

    /// Valley of the Kings - not recommended
    static let valleyOfKings = ExperienceEntity(
        id: "3",
        title: "Valley of the Kings",
        coverPhoto: "https://example.com/valley.jpg",
        description: "Discover the ancient burial ground of Egyptian pharaohs in Luxor",
        viewsCount: 9500,
        likesCount: 1450,
        isRecommended: false,
        hasVideo: true,
        city: luxorEntity,
        tourHTML: "https://example.com/tours/valley.html",
        isLiked: false
    )

    /// Karnak Temple - recommended
    static let karnakTemple = ExperienceEntity(
        id: "4",
        title: "Karnak Temple",
        coverPhoto: "https://example.com/karnak.jpg",
        description: "Visit the vast temple complex dedicated to the Theban gods",
        viewsCount: 11200,
        likesCount: 1670,
        isRecommended: true,
        hasVideo: true,
        city: luxorEntity,
        tourHTML: "https://example.com/tours/karnak.html",
        isLiked: false
    )

    /// Alexandria Library - not recommended
    static let alexandriaLibrary = ExperienceEntity(
        id: "5",
        title: "Bibliotheca Alexandrina",
        coverPhoto: "https://example.com/library.jpg",
        description: "Modern recreation of the ancient Library of Alexandria",
        viewsCount: 6800,
        likesCount: 890,
        isRecommended: false,
        hasVideo: false,
        city: alexandriaEntity,
        tourHTML: "https://example.com/tours/library.html",
        isLiked: false
    )

    // MARK: - Convenience Collections

    /// All experience entities
    static let all: [ExperienceEntity] = [
        pyramids,
        sphinx,
        valleyOfKings,
        karnakTemple,
        alexandriaLibrary
    ]

    /// Only recommended experiences
    static let recommended: [ExperienceEntity] = [
        pyramids,
        sphinx,
        karnakTemple
    ]

    /// Only non-recommended experiences
    static let notRecommended: [ExperienceEntity] = [
        valleyOfKings,
        alexandriaLibrary
    ]

    /// Experiences with video
    static let withVideo: [ExperienceEntity] = [
        pyramids,
        valleyOfKings,
        karnakTemple
    ]

    /// Experiences in Cairo
    static let inCairo: [ExperienceEntity] = [
        pyramids,
        sphinx
    ]

    /// Experiences in Luxor
    static let inLuxor: [ExperienceEntity] = [
        valleyOfKings,
        karnakTemple
    ]

    // MARK: - Helper Functions

    /// Creates a custom experience entity with specified parameters
    static func makeEntity(
        id: String = "test-id",
        title: String = "Test Experience",
        coverPhoto: String = "https://example.com/test.jpg",
        description: String = "Test description",
        viewsCount: Int = 100,
        likesCount: Int = 10,
        isRecommended: Bool = false,
        hasVideo: Bool = false,
        city: CityEntity = cairoEntity,
        tourHTML: String = "https://example.com/tours/test.html",
        isLiked: Bool = false
    ) -> ExperienceEntity {
        return ExperienceEntity(
            id: id,
            title: title,
            coverPhoto: coverPhoto,
            description: description,
            viewsCount: viewsCount,
            likesCount: likesCount,
            isRecommended: isRecommended,
            hasVideo: hasVideo,
            city: city,
            tourHTML: tourHTML,
            isLiked: isLiked
        )
    }

    /// Creates a liked version of an experience with incremented like count
    static func makeLiked(_ experience: ExperienceEntity) -> ExperienceEntity {
        return ExperienceEntity(
            id: experience.id,
            title: experience.title,
            coverPhoto: experience.coverPhoto,
            description: experience.description,
            viewsCount: experience.viewsCount,
            likesCount: experience.likesCount + 1,
            isRecommended: experience.isRecommended,
            hasVideo: experience.hasVideo,
            city: experience.city,
            tourHTML: experience.tourHTML,
            isLiked: true
        )
    }
}
