//
//  CityEntity.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

/// Represents a city associated with an experience
public struct CityEntity {

    // MARK: - Properties

    /// Unique identifier for the city
    public let id: Int

    /// Name of the city
    public let name: String

    // MARK: - Initialization

    public init(
        id: Int,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}
