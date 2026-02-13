//
//  Container+AETour.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation
import FactoryKit
import AECore

extension Container {

    // MARK: - Repository

    /// Experience repository - handles data operations for experiences
    /// TODO: Replace stub with actual implementation when Data layer is ready
    public var experienceRepository: Factory<ExperienceRepositoryProtocol> {
        self {
            fatalError("ExperienceRepository must be registered with Data layer implementation (not yet implemented)")
        }
        .singleton
    }
}
