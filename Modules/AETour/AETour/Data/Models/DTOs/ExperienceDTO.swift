//
//  ExperienceDTO.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

/// Data transfer object for experience from API
struct ExperienceDTO: Codable {
    let id: String
    let title: String
    let coverPhoto: String
    let description: String
    let viewsNo: Int
    let likesNo: Int
    let recommended: Int
    let hasVideo: Int
    let city: CityDTO?
    let tourHtml: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case city
        case coverPhoto = "cover_photo"
        case viewsNo = "views_no"
        case likesNo = "likes_no"
        case recommended
        case hasVideo = "has_video"
        case tourHtml = "tour_html"
    }
}
