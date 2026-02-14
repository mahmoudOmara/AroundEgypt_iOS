//
//  ExperienceModel.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import SwiftData

/// SwiftData model for caching experience information
@Model
final class ExperienceModel {
    @Attribute(.unique) var id: String
    var title: String
    var coverPhoto: String
    var experienceDescription: String
    var viewsCount: Int
    var likesCount: Int
    var isRecommended: Bool
    var hasVideo: Bool
    var city: CityModel?
    var tourHTML: String
    var isLiked: Bool
    var cachedAt: Date

    init(
        id: String,
        title: String,
        coverPhoto: String,
        experienceDescription: String,
        viewsCount: Int,
        likesCount: Int,
        isRecommended: Bool,
        hasVideo: Bool,
        city: CityModel?,
        tourHTML: String,
        isLiked: Bool,
        cachedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.coverPhoto = coverPhoto
        self.experienceDescription = experienceDescription
        self.viewsCount = viewsCount
        self.likesCount = likesCount
        self.isRecommended = isRecommended
        self.hasVideo = hasVideo
        self.city = city
        self.tourHTML = tourHTML
        self.isLiked = isLiked
        self.cachedAt = cachedAt
    }
}
