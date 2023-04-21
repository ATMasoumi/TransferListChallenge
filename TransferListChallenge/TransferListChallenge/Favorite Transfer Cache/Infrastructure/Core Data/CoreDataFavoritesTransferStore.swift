//
//  CoreDataFavoritesTransferStore.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/20/23.
//

import Foundation
import CoreData

public class CoreDataFavoritesTransferStore {
    private static let modelName = "FavoritesTransferStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataFavoritesTransferStore.self))
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    public init(storeURL: URL) throws {
        guard let model = CoreDataFavoritesTransferStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: CoreDataFavoritesTransferStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
    
}
