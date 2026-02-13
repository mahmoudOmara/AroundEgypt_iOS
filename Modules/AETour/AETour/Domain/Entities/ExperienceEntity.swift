//
//  ExperienceEntity.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

/// Core domain entity representing a tour experience
public struct ExperienceEntity {

    // MARK: - Properties

    /// Unique identifier for the experience
    public let id: String

    /// Title of the experience
    public let title: String

    /// Cover image URL
    public let coverPhoto: String

    /// Description of the experience
    public let description: String

    /// Number of views
    public let viewsCount: Int

    /// Number of likes
    public let likesCount: Int

    /// Whether this experience is recommended
    public let isRecommended: Bool

    /// Whether this experience has a video
    public let hasVideo: Bool

    /// City where the experience is located
    public let city: CityEntity

    /// Virtual tour HTML URL
    public let tourHTML: String

    /// Whether the current user has liked this experience (local state)
    public let isLiked: Bool

    // MARK: - Initialization

    public init(
        id: String,
        title: String,
        coverPhoto: String,
        description: String,
        viewsCount: Int,
        likesCount: Int,
        isRecommended: Bool,
        hasVideo: Bool,
        city: CityEntity,
        tourHTML: String,
        isLiked: Bool = false
    ) {
        self.id = id
        self.title = title
        self.coverPhoto = coverPhoto
        self.description = description
        self.viewsCount = viewsCount
        self.likesCount = likesCount
        self.isRecommended = isRecommended
        self.hasVideo = hasVideo
        self.city = city
        self.tourHTML = tourHTML
        self.isLiked = isLiked
    }
}
