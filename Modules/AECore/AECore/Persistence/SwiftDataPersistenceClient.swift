//
//  SwiftDataPersistenceClient.swift
//  AECore
//
//  Created by M. Omara on 09/09/2025.
//

import Foundation
import SwiftData
import Combine

/// SwiftData client manager
/// Provides centralized model container and context management
@available(iOS 17, *)
public final class SwiftDataPersistenceClient: ObservableObject {
    
    // MARK: - Properties
    
    /// The main model container for the app
    public let modelContainer: ModelContainer
    
    /// The main context for UI operations
    @MainActor
    public var mainContext: ModelContext {
        return modelContainer.mainContext
    }
    
    /// Background context for data operations
    public func backgroundContext() -> ModelContext {
        return ModelContext(modelContainer)
    }
    
    // MARK: - Initialization
    
    /// Initializes the SwiftData stack with the app's model configuration
    /// - Parameters:
    ///   - modelTypes: Array of PersistentModel types to include in the schema
    ///   - isStoredInMemoryOnly: Whether to store data in memory only (useful for testing)
    public init(modelTypes: [any PersistentModel.Type] = [], isStoredInMemoryOnly: Bool = false) throws {
        let schema = Schema(modelTypes)
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isStoredInMemoryOnly,
            cloudKitDatabase: .none // Can be configured later for CloudKit sync
        )
        
        do {
            self.modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            throw SwiftDataError.containerInitializationFailed(error)
        }
    }
    
    // MARK: - Context Management
    
    /// Saves the main context
    /// - Throws: SwiftDataError if save fails
    @MainActor
    public func save() throws {
        do {
            try mainContext.save()
        } catch {
            throw SwiftDataError.saveFailed(error)
        }
    }
    
    /// Saves a specific context
    /// - Parameter context: The context to save
    /// - Throws: SwiftDataError if save fails
    public func save(context: ModelContext) throws {
        do {
            try context.save()
        } catch {
            throw SwiftDataError.saveFailed(error)
        }
    }
    
    /// Performs a background task with a new context
    /// - Parameter block: The task to perform
    /// - Returns: The result of the task
    /// - Throws: Any error thrown by the task
    public func performBackgroundTask<T>(_ block: @escaping (ModelContext) throws -> T) async throws -> T {
        let context = backgroundContext()
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let result = try block(context)
                    try save(context: context)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Utility Methods
    
    /// Deletes all data for a specific model type
    /// - Parameter modelType: The model type to delete
    /// - Throws: SwiftDataError if deletion fails
    @MainActor
    public func deleteAll<T: PersistentModel>(of modelType: T.Type) throws {
        do {
            try mainContext.delete(model: modelType)
            try save()
        } catch {
            throw SwiftDataError.deletionFailed(error)
        }
    }
    
    /// Fetches all entities of a specific type
    /// - Parameter modelType: The model type to fetch
    /// - Returns: Array of entities
    /// - Throws: SwiftDataError if fetch fails
    @MainActor
    public func fetchAll<T: PersistentModel>(of modelType: T.Type) throws -> [T] {
        let descriptor = FetchDescriptor<T>()
        do {
            return try mainContext.fetch(descriptor)
        } catch {
            throw SwiftDataError.fetchFailed(error)
        }
    }
    
    /// Counts entities of a specific type
    /// - Parameter modelType: The model type to count
    /// - Returns: Count of entities
    /// - Throws: SwiftDataError if count fails
    @MainActor
    public func count<T: PersistentModel>(of modelType: T.Type) throws -> Int {
        let descriptor = FetchDescriptor<T>()
        do {
            return try mainContext.fetchCount(descriptor)
        } catch {
            throw SwiftDataError.fetchFailed(error)
        }
    }
    
    /// Fetches entities with a predicate
    /// - Parameters:
    ///   - modelType: The model type to fetch
    ///   - predicate: The predicate to filter results
    /// - Returns: Array of entities matching the predicate
    /// - Throws: SwiftDataError if fetch fails
    @MainActor
    public func fetch<T: PersistentModel>(of modelType: T.Type, where predicate: Predicate<T>) throws -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        do {
            return try mainContext.fetch(descriptor)
        } catch {
            throw SwiftDataError.fetchFailed(error)
        }
    }
    
    /// Fetches entities with sorting and limiting
    /// - Parameters:
    ///   - modelType: The model type to fetch
    ///   - sortBy: Sort descriptors for ordering results
    ///   - limit: Maximum number of entities to return
    /// - Returns: Array of entities
    /// - Throws: SwiftDataError if fetch fails
    @MainActor
    public func fetch<T: PersistentModel>(
        of modelType: T.Type,
        sortBy: [SortDescriptor<T>] = [],
        limit: Int? = nil
    ) throws -> [T] {
        var descriptor = FetchDescriptor<T>(sortBy: sortBy)
        if let limit = limit {
            descriptor.fetchLimit = limit
        }
        do {
            return try mainContext.fetch(descriptor)
        } catch {
            throw SwiftDataError.fetchFailed(error)
        }
    }
}

// MARK: - Singleton Access

@available(iOS 17, *)
public extension SwiftDataPersistenceClient {
    
    /// Shared instance of SwiftDataPersistenceClient
    /// > Important: You must call `SwiftDataPersistenceClient.configureShared(with:)` early in the app lifecycle
    /// (e.g., in your `App` struct or the `SceneDelegate`) before accessing this property.
    /// - Note: If you attempt to access this property before calling `configureShared(with:)`,
    /// it will be `nil`, which may result in a crash or unexpected behavior.
    static var shared: SwiftDataPersistenceClient!
    
    /// Configures the shared SwiftDataPersistenceClient instance with model types
    /// - Parameter modelTypes: Array of PersistentModel types to include in the schema
    /// - Throws: SwiftDataError if initialization fails
    static func configureShared(with modelTypes: [any PersistentModel.Type]) throws {
        do {
            shared = try SwiftDataPersistenceClient(modelTypes: modelTypes)
        } catch {
            throw SwiftDataError.containerInitializationFailed(error)
        }
    }
    
    /// Creates a new instance for testing
    /// - Parameter modelTypes: Array of PersistentModel types to include in the schema
    /// - Returns: SwiftDataPersistenceClient configured for in-memory storage
    static func forTesting(with modelTypes: [any PersistentModel.Type] = []) throws -> SwiftDataPersistenceClient {
        return try SwiftDataPersistenceClient(modelTypes: modelTypes, isStoredInMemoryOnly: true)
    }
}
