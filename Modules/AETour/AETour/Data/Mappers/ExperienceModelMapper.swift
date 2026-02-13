//
//  ExperienceModelMapper.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

/// Mapper for converting SwiftData Models to Domain Entities
extension ExperienceModel {
    func toEntity() -> ExperienceEntity {
        ExperienceEntity(
            id: id,
            title: title,
            coverPhoto: coverPhoto,
            description: experienceDescription,
            viewsCount: viewsCount,
            likesCount: likesCount,
            isRecommended: isRecommended,
            hasVideo: hasVideo,
            city: city?.toEntity() ?? CityEntity(id: 0, name: "Unknown"),
            tourHTML: tourHTML,
            isLiked: isLiked
        )
    }
}

extension CityModel {
    func toEntity() -> CityEntity {
        CityEntity(id: id, name: name)
    }
}
