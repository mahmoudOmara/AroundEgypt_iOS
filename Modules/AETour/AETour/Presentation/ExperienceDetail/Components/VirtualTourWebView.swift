//
//  VirtualTourWebView.swift
//  AETour
//
//  Created by M. Omara on 13/02/2026.
//

import SwiftUI
import WebKit

/// WebKit wrapper for displaying 360° virtual tour HTML
struct VirtualTourWebView: UIViewRepresentable {
    let htmlURL: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = true
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: htmlURL) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview {
    VirtualTourWebView(htmlURL: "https://fls-9ff553c9-95cd-4102-b359-74ad35cdc461.laravel.cloud/1598534877vtour/vtour/tour.html")
}
