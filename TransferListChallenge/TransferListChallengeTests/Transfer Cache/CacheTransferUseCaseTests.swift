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
            switch result {
            case .success:
                break
            case let .failure(error):
                completion(.failure(error))
            }
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
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    // MARK: - Helpers
    
    func makeSUT() -> (LocalFavoritesTransferLoader,FavoritesTransferStoreSpy) {
        let store = FavoritesTransferStoreSpy()
        let sut = LocalFavoritesTransferLoader(store: store)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFavoritesTransferLoader, toCompleteWith expectedResult: LocalFavoritesTransferLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedTransfers), .success(expectedTransfers)):
                XCTAssertEqual(receivedTransfers, expectedTransfers, file: file, line: line)
            
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    class FavoritesTransferStoreSpy: FavoritesTransferStore {
       
        enum ReceivedMessage: Equatable {
            case retrieve([LocalTransfer])
        }
        
        private var retrievalCompletions = [(RetrievalResult) -> Void]()

        var receivedMessages: [ReceivedMessage] = []
        
        func retrieve(completion: @escaping (RetrievalResult) -> Void) {
            retrievalCompletions.append(completion)
            receivedMessages.append(.retrieve([]))
        }
       
        func completeRetrieval(with error: Error, at index: Int = 0) {
            retrievalCompletions[index](.failure(error))
        }
        
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

}
