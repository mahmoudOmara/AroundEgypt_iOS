//
//  CustomNetworkLoggingPlugin.swift
//  AECore
//
//  Created by M. Omara on 03/09/2025.
//

import Foundation
import Moya

final class CustomNetworkLoggingPlugin: PluginType {
    private let logger: Logger
    private let isEnabled: Bool
    
    init(logger: Logger, isEnabled: Bool) {
        self.logger = logger
        self.isEnabled = isEnabled
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        guard isEnabled else { return }
        
        let httpMethod = request.request?.httpMethod ?? "Unknown"
        let url = request.request?.url?.absoluteString ?? target.baseURL.appendingPathComponent(target.path).absoluteString
        
        logger.info("→ \(httpMethod) \(url)")
        
        if let headers = request.request?.allHTTPHeaderFields, !headers.isEmpty {
            logger.debug("Headers: \(headers)")
        }
        
        if let body = request.request?.httpBody {
            if let bodyString = formatJSONData(body) {
                logger.debug("Body: \(bodyString)")
            }
        }
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard isEnabled else { return }
        
        switch result {
        case .success(let response):
            let url = response.request?.url?.absoluteString ?? target.baseURL.appendingPathComponent(target.path).absoluteString
            logger.info("← \(response.statusCode) \(url)")
            
            if let responseString = formatJSONData(response.data) {
                logger.debug("Response: \(responseString)")
            }
            
        case .failure(let error):
            logger.error("Network request failed: \(error.localizedDescription)")
        }
    }
    
    private func formatJSONData(_ data: Data) -> String? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let pretty = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return String(data: pretty, encoding: .utf8)
        } catch {
            return String(data: data, encoding: .utf8)
        }
    }
}
