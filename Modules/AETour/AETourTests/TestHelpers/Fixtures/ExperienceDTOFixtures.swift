//
//  ExperienceDTOFixtures.swift
//  AETourTests
//
//  Created by M. Omara on 14/02/2026.
//

import Foundation
@testable import AETour

/// Provides predefined ExperienceDTO instances for testing
enum ExperienceDTOFixtures {

    // MARK: - City Fixtures

    static let cairoDTO = CityDTO(id: 1, name: "Cairo")
    static let luxorDTO = CityDTO(id: 2, name: "Luxor")
    static let alexandriaDTO = CityDTO(id: 3, name: "Alexandria")

    // MARK: - Experience Fixtures

    /// Great Pyramids of Giza - recommended experience
    static let pyramidsDTO = ExperienceDTO(
        id: "1",
        title: "Great Pyramids of Giza",
        coverPhoto: "https://example.com/pyramids.jpg",
        description: "Explore the ancient wonders of the Great Pyramids, one of the Seven Wonders of the Ancient World",
        viewsNo: 15420,
        likesNo: 2340,
        recommended: 1,
        hasVideo: 1,
        city: cairoDTO,
        tourHtml: "https://example.com/tours/pyramids.html"
    )

    /// The Great Sphinx - recommended experience
    static let sphinxDTO = ExperienceDTO(
        id: "2",
        title: "The Great Sphinx",
        coverPhoto: "https://example.com/sphinx.jpg",
        description: "Witness the majestic Great Sphinx, guardian of the Giza Plateau",
        viewsNo: 12800,
        likesNo: 1890,
        recommended: 1,
        hasVideo: 0,
        city: cairoDTO,
        tourHtml: "https://example.com/tours/sphinx.html"
    )

    /// Valley of the Kings - not recommended
    static let valleyOfKingsDTO = ExperienceDTO(
        id: "3",
        title: "Valley of the Kings",
        coverPhoto: "https://example.com/valley.jpg",
        description: "Discover the ancient burial ground of Egyptian pharaohs in Luxor",
        viewsNo: 9500,
        likesNo: 1450,
        recommended: 0,
        hasVideo: 1,
        city: luxorDTO,
        tourHtml: "https://example.com/tours/valley.html"
    )

    /// Karnak Temple - recommended experience
    static let karnakTempleDTO = ExperienceDTO(
        id: "4",
        title: "Karnak Temple",
        coverPhoto: "https://example.com/karnak.jpg",
        description: "Visit the vast temple complex dedicated to the Theban gods",
        viewsNo: 11200,
        likesNo: 1670,
        recommended: 1,
        hasVideo: 1,
        city: luxorDTO,
        tourHtml: "https://example.com/tours/karnak.html"
    )

    /// Alexandria Library - not recommended
    static let alexandriaLibraryDTO = ExperienceDTO(
        id: "5",
        title: "Bibliotheca Alexandrina",
        coverPhoto: "https://example.com/library.jpg",
        description: "Modern recreation of the ancient Library of Alexandria",
        viewsNo: 6800,
        likesNo: 890,
        recommended: 0,
        hasVideo: 0,
        city: alexandriaDTO,
        tourHtml: "https://example.com/tours/library.html"
    )

    // MARK: - Convenience Collections

    /// All experience DTOs
    static let all: [ExperienceDTO] = [
        pyramidsDTO,
        sphinxDTO,
        valleyOfKingsDTO,
        karnakTempleDTO,
        alexandriaLibraryDTO
    ]

    /// Only recommended experiences
    static let recommended: [ExperienceDTO] = [
        pyramidsDTO,
        sphinxDTO,
        karnakTempleDTO
    ]

    /// Only non-recommended experiences
    static let notRecommended: [ExperienceDTO] = [
        valleyOfKingsDTO,
        alexandriaLibraryDTO
    ]

    /// Experiences with video
    static let withVideo: [ExperienceDTO] = [
        pyramidsDTO,
        valleyOfKingsDTO,
        karnakTempleDTO
    ]

    /// Experiences in Cairo
    static let inCairo: [ExperienceDTO] = [
        pyramidsDTO,
        sphinxDTO
    ]

    /// Experiences in Luxor
    static let inLuxor: [ExperienceDTO] = [
        valleyOfKingsDTO,
        karnakTempleDTO
    ]

    // MARK: - Helper Functions

    /// Creates a custom experience DTO with specified parameters
    static func makeDTO(
        id: String = "test-id",
        title: String = "Test Experience",
        coverPhoto: String = "https://example.com/test.jpg",
        description: String = "Test description",
        viewsNo: Int = 100,
        likesNo: Int = 10,
        recommended: Int = 0,
        hasVideo: Int = 0,
        city: CityDTO? = cairoDTO,
        tourHtml: String = "https://example.com/tours/test.html"
    ) -> ExperienceDTO {
        return ExperienceDTO(
            id: id,
            title: title,
            coverPhoto: coverPhoto,
            description: description,
            viewsNo: viewsNo,
            likesNo: likesNo,
            recommended: recommended,
            hasVideo: hasVideo,
            city: city,
            tourHtml: tourHtml
        )
    }
}
