//
//  UploadMediaFile.swift
//  AECore
//
//  Created by M. Omara on 03/09/2025.
//

import Foundation

public struct UploadMediaFile {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init(data: Data, forKey key: String, filename: String = "imagefile.jpg", mimeType: String = "image/jpeg") {
        self.key = key
        self.filename = filename
        self.data = data
        self.mimeType = mimeType
    }
}
