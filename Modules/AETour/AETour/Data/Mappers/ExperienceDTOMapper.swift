//
//  ExperienceDTOMapper.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

/// Mapper for converting DTOs to SwiftData Models
extension ExperienceDTO {
    func toModel() -> ExperienceModel {
        ExperienceModel(
            id: id,
            title: title,
            coverPhoto: coverPhoto,
            experienceDescription: description,
            viewsCount: viewsNo,
            likesCount: likesNo,
            isRecommended: recommended == 1,
            hasVideo: hasVideo == 1,
            city: city.toModel(),
            tourHTML: tourHtml,
            isLiked: false
        )
    }
}

extension CityDTO {
    func toModel() -> CityModel {
        CityModel(id: id, name: name)
    }
}
