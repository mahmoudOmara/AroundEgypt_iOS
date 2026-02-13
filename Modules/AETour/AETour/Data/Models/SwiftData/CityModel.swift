//
//  CityModel.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import SwiftData

/// SwiftData model for caching city information
@Model
final class CityModel {
    @Attribute(.unique) var id: Int
    var name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
