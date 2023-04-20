//
//  CacheTransferUseCaseTests.swift
//  TransferListChallengeTests
//
//  Created by Amir Masoumi on 4/20/23.
//

import XCTest
import TransferListChallenge

struct LocalTransfer: Equatable {
    
}

protocol FavoritesTransferLoader {
    typealias LoadResult = Swift.Result<[Transfer], Error>
    func load(completion: @escaping (LoadResult) -> Void)
}

protocol FavoritesTransferStore {
    typealias RetrievalResult = Result<[LocalTransfer]?, Error>
    func retrieve(completion: @escaping (RetrievalResult) -> Void)
}

class LocalFavoritesTransferLoader: FavoritesTransferLoader {
    
    let store: FavoritesTransferStore
    init(store: FavoritesTransferStore) {
        self.store = store
    }
    
    func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { result in
            
        }
    }
}

final class CacheTransferUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() throws {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve([])])
    }
    
    // MARK: - Helpers
    
    func makeSUT() -> (LocalFavoritesTransferLoader,FavoritesTransferStoreSpy) {
        let store = FavoritesTransferStoreSpy()
        let sut = LocalFavoritesTransferLoader(store: store)
        return (sut, store)
    }
    
    class FavoritesTransferStoreSpy: FavoritesTransferStore {
       
        enum ReceivedMessage: Equatable {
            case retrieve([LocalTransfer])
        }
        
        var receivedMessages: [ReceivedMessage] = []
        
        func retrieve(completion: @escaping (RetrievalResult) -> Void) {
            receivedMessages.append(.retrieve([]))
        }
    }
}
