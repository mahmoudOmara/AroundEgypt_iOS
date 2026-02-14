//
//  Constants.swift
//  MPCore
//
//  Created by M. Omara on 13/02/2026.
//

import Foundation

public struct Constants {
    
    // MARK: - Development & Testing
    
    public struct Development {
        public static let randomImage = "https://picsum.photos/600/600"
        public static let basicHTML = "<html><body>Sample 360 content</body></html>"
        public static let isDebugMode: Bool = {
#if DEBUG
            return true
#else
            return false
#endif
        }()
        public static let enableLogging = isDebugMode
    }
}
