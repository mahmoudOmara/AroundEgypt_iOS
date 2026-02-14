//
//  HTMLWebView.swift
//  AEShared
//
//  Created by M. Omara on 14/02/2026.
//

import SwiftUI
import WebKit

/// A reusable WebKit wrapper for displaying HTML content
/// Supports loading from URL with scrolling and navigation gestures
public struct HTMLWebView: UIViewRepresentable {
    let url: String

    public init(url: String) {
        self.url = url
    }

    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        guard let htmlURL = URL(string: url) else { return }
        let request = URLRequest(url: htmlURL)
        webView.load(request)
    }
}

#Preview {
    HTMLWebView(url: "https://www.apple.com")
        .ignoresSafeArea()
}
