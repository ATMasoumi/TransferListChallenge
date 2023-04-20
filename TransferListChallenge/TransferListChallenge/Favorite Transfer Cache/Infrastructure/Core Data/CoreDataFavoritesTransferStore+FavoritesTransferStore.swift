//
//  CoreDataFavoritesTransferStore+FavoritesTransferStore.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/20/23.
//

import Foundation

extension CoreDataFavoritesTransferStore: FavoritesTransferStore {
    
    public func retrieve(completion: @escaping (RetrievalResult) -> Void) {
        completion(.success([]))
    }
    
    public func insert(_ transfer: TransferListChallenge.LocalTransfer, completion: @escaping (InsertionResult) -> Void) {
        
    }
    
    public func delete(_ transfer: TransferListChallenge.LocalTransfer, completion: @escaping (DeletionResult) -> Void) {
        
    }
    
    
}
