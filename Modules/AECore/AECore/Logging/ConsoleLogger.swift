//
//  ConsoleLogger.swift
//  AECore
//
//  Created by M. Omara on 03/09/2025.
//


import Foundation

public class ConsoleLogger: Logger {
    public var minLevel: LogLevel
    private let dateFormatter: DateFormatter
    
    public init(minLevel: LogLevel = .debug) {
        self.minLevel = minLevel
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    public func log(_ message: String, level: LogLevel, file: String, function: String, line: Int) {
        if level.rawValue < minLevel.rawValue {
            return
        }
        
        let timestamp = dateFormatter.string(from: Date())
        let fileURL = URL(fileURLWithPath: file)
        let fileName = fileURL.lastPathComponent
        
        // Format: [TIMESTAMP] [LEVEL] [FILE:LINE] [FUNCTION] MESSAGE
        let logMessage = "[\(timestamp)] [\(level.prefix)] [\(fileName):\(line)] [\(function)] \(message)"
        
        print(logMessage)
    }
}
