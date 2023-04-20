//
//  CoreDataTransferStoreUseCase.swift
//  TransferListChallengeTests
//
//  Created by Amir Masoumi on 4/20/23.
//

import XCTest
import TransferListChallenge

final class CoreDataTransferStoreUseCase: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieve: .success([]))
    }
    
    private func makeSUT() -> FavoritesTransferStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFavoritesTransferStore(storeURL: storeURL)
        return sut

    }
    
    func expect(_ sut: FavoritesTransferStore, toRetrieve expectedResult: FavoritesTransferStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.success([]), .success([])),
                 (.failure, .failure):
                break
                
            case let (.success(expected), .success(retrieved)):
                XCTAssertEqual(retrieved, expected, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
