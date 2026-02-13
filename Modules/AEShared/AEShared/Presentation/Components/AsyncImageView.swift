//
//  AsyncImageView.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI

/// A reusable async image view with placeholder support
public struct AsyncImageView: View {
    let url: String
    let placeholder: Image

    public init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.url = url
        self.placeholder = placeholder
    }

    public var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.gray.opacity(0.3))
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.gray.opacity(0.3))
            @unknown default:
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.gray.opacity(0.3))
            }
        }
    }
}

#Preview {
    AsyncImageView(url: Constants.Development.randomImage)
        .frame(width: 200, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 12))
}
