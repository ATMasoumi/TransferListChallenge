//
//  FavoritesTransferLoader.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/20/23.
//

import Foundation

public protocol FavoritesTransferLoader {
    typealias LoadResult = Swift.Result<[Transfer], Error>
    func load(completion: @escaping (LoadResult) -> Void)
    
    typealias SaveResult = Swift.Result<Void, Error>
    func save(_ transfer: Transfer, completion: @escaping (SaveResult) -> Void)
    
    typealias DeleteResult = Swift.Result<Void, Error>
    func delete(_ transfer: Transfer, completion: @escaping (DeleteResult) -> Void)
}
