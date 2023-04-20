//
//  FavoritesTransferStore.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/20/23.
//

import Foundation

public protocol FavoritesTransferStore {
    typealias RetrievalResult = Result<[LocalTransfer], Error>
    func retrieve(completion: @escaping (RetrievalResult) -> Void)
    
    typealias InsertionResult = Result<Void, Error>
    func insert(_ transfer: LocalTransfer, completion: @escaping (InsertionResult) -> Void)
    
    typealias DeletionResult = Result<Void, Error>
    func delete(_ transfer: LocalTransfer, completion: @escaping (DeletionResult) -> Void)
}
