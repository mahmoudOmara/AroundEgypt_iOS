//
//  ExperienceCardBuilder.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI
import AEShared

struct ExperienceCardBuilder: View {
    
    let experience: ExperienceEntity
    let onTap: () -> Void
    let on360Tap: () -> Void
    let onLikeTap: () -> Void

    var body: some View {
        ExperienceCard(
            title: experience.title,
            coverPhoto: experience.coverPhoto,
            isRecommended: experience.isRecommended,
            tourHTML: experience.tourHTML,
            viewsCount: experience.viewsCount,
            hasVideo: experience.hasVideo,
            likesCount: experience.likesCount,
            isLiked: experience.isLiked,
            on360Tap: on360Tap,
            onLikeTap: onLikeTap
        )
        .onTapGesture(perform: onTap)
    }
}

#Preview {
    VStack {
        ExperienceCardBuilder(
            experience: ExperienceEntity(
                id: "1",
                title: "Siwwa",
                coverPhoto: Constants.Development.randomImage,
                description: "Amazing desert views",
                viewsCount: 30200,
                likesCount: 4500,
                isRecommended: false,
                hasVideo: false,
                city: CityEntity(id: 2, name: "Cairo"),
                tourHTML: Constants.Development.basicHTML,
                isLiked: true
            ),
            onTap: {},
            on360Tap: {},
            onLikeTap: {}
        )
        
        ExperienceCardBuilder(
            experience: ExperienceEntity(
                id: "2",
                title: "Egyptian Desert",
                coverPhoto: Constants.Development.randomImage,
                description: "Amazing desert views",
                viewsCount: 1523,
                likesCount: 45,
                isRecommended: false,
                hasVideo: false,
                city: CityEntity(id: 2, name: "Cairo"),
                tourHTML: Constants.Development.basicHTML,
                isLiked: true
            ),
            onTap: {},
            on360Tap: {},
            onLikeTap: {}
        )
    }
    .padding(.horizontal)
}
