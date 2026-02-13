//
//  PreviewData.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

#if DEBUG

/// Sample data for SwiftUI previews
enum PreviewData {

    static let sampleCity1 = CityEntity(id: 1, name: "Aswan")
    static let sampleCity2 = CityEntity(id: 2, name: "Cairo")
    static let sampleCity3 = CityEntity(id: 3, name: "Luxor")

    static let sampleExperiences: [ExperienceEntity] = [
        ExperienceEntity(
            id: "1",
            title: "Nubian House",
            coverPhoto: "https://picsum.photos/seed/nubian/800/600",
            description: "Experience the vibrant colors and unique architecture of traditional Nubian houses in Aswan. These beautiful homes showcase the rich cultural heritage of the Nubian people.",
            viewsCount: 372,
            likesCount: 156,
            isRecommended: true,
            hasVideo: true,
            city: sampleCity1,
            tourHTML: "https://www.example.com/tour/nubian",
            isLiked: false
        ),
        ExperienceEntity(
            id: "2",
            title: "Egyptian Desert",
            coverPhoto: "https://picsum.photos/seed/desert/800/600",
            description: "Explore the vast and beautiful Egyptian desert with its golden dunes and stunning sunsets. A truly unforgettable experience.",
            viewsCount: 1523,
            likesCount: 45,
            isRecommended: false,
            hasVideo: false,
            city: sampleCity2,
            tourHTML: "",
            isLiked: true
        ),
        ExperienceEntity(
            id: "3",
            title: "Pyramids of Giza",
            coverPhoto: "https://picsum.photos/seed/pyramids/800/600",
            description: "Marvel at the ancient Pyramids of Giza, one of the Seven Wonders of the Ancient World. These magnificent structures have stood for over 4,500 years.",
            viewsCount: 15420,
            likesCount: 2340,
            isRecommended: true,
            hasVideo: true,
            city: sampleCity2,
            tourHTML: "https://www.example.com/tour/pyramids",
            isLiked: false
        ),
        ExperienceEntity(
            id: "4",
            title: "Temple of Karnak",
            coverPhoto: "https://picsum.photos/seed/karnak/800/600",
            description: "Visit the largest religious building ever constructed. The Temple of Karnak is a vast complex of sanctuaries, kiosks, pylons and obelisks.",
            viewsCount: 8765,
            likesCount: 892,
            isRecommended: true,
            hasVideo: true,
            city: sampleCity3,
            tourHTML: "https://www.example.com/tour/karnak",
            isLiked: false
        ),
        ExperienceEntity(
            id: "5",
            title: "Abu Simbel Temples",
            coverPhoto: "https://picsum.photos/seed/abusimbel/800/600",
            description: "The Abu Simbel temples are two massive rock temples at Abu Simbel, a village in Nubia, southern Egypt, near the border with Sudan. They serve as a lasting monument to the king and his queen Nefertari.",
            viewsCount: 12840,
            likesCount: 1567,
            isRecommended: false,
            hasVideo: true,
            city: sampleCity1,
            tourHTML: "https://www.example.com/tour/abusimbel",
            isLiked: false
        ),
        ExperienceEntity(
            id: "6",
            title: "Valley of the Kings",
            coverPhoto: "https://picsum.photos/seed/valley/800/600",
            description: "Explore the Valley of the Kings, the burial site of many pharaohs including Tutankhamun. This valley contains 63 tombs and chambers.",
            viewsCount: 9234,
            likesCount: 756,
            isRecommended: true,
            hasVideo: false,
            city: sampleCity3,
            tourHTML: "",
            isLiked: true
        )
    ]

    static var sampleExperience: ExperienceEntity {
        sampleExperiences[0]
    }
}

#endif
