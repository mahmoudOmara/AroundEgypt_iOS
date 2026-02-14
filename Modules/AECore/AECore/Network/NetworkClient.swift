//
//  NetworkClient.swift
//  AECore
//
//  Created by M. Omara on 03/09/2025.
//

import Foundation
import Combine

public protocol NetworkClient {
    var configuration: NetworkConfiguration { get }
    func perform<T: Decodable>(_ apiRequest: APIRequestRepresentable, type: T.Type) async throws(NetworkError) -> T
}
