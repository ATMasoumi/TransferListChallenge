//
//  NullStore.swift
//  TransferListApp
//
//  Created by Amir Masoumi on 4/22/23.
//

import Foundation
import TransferListChallenge

class NullStore {}

extension NullStore: FavoritesTransferStore {
    func retrieve(completion: @escaping (RetrievalResult) -> Void) {
        
    }
    
    func insert(_ transfer: TransferListChallenge.LocalTransfer, completion: @escaping (InsertionResult) -> Void) {
        
    }
    
    func delete(_ transfer: TransferListChallenge.LocalTransfer, completion: @escaping (DeletionResult) -> Void) {
        
    }
}
