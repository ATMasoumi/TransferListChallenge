//
//  CacheTransferUseCaseTests.swift
//  TransferListChallengeTests
//
//  Created by Amir Masoumi on 4/20/23.
//

import XCTest

protocol FavoritesTransferStore {
    
}

class LocalFavoritesTransferLoader {
    let store: FavoritesTransferStore
    init(store: FavoritesTransferStore) {
        self.store = store
    }
}

final class CacheTransferUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() throws {
        let store = FavoritesTransferStoreSpy()
        let _ = LocalFavoritesTransferLoader(store: store)
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    class FavoritesTransferStoreSpy: FavoritesTransferStore {
        var receivedMessages: [String] = []
    }
}
