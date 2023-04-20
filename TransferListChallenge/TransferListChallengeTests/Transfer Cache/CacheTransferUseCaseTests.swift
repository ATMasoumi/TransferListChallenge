//
//  CacheTransferUseCaseTests.swift
//  TransferListChallengeTests
//
//  Created by Amir Masoumi on 4/20/23.
//

import XCTest
import TransferListChallenge



final class CacheTransferUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() throws {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    // MARK: test Loading
    
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
    
    func test_load_deliversCachedFavoritesTransfers() {
        let favoriteTransfer = makeItem(name: "amin", cardNumber: "1", note: "note1")
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([favoriteTransfer.model]), when: {
            store.completeRetrieval(with: [favoriteTransfer.local])
        })
    }
    
    func test_load_deliversEmptyCachedFavoritesTransfers() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: [])
        })
    }
    
    // MARK: -test inserting
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil, when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeInsertion(with: insertionError)
        })
    }

    // MARK: - Deletion
    
    func test_delete_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expectDelete(sut, toCompleteWithError: insertionError, when: {
            store.completeDeletion(with: insertionError)
        })
    }
    
    func test_delete_succeedsOnSuccessfulCacheDeletion() {
        let (sut, store) = makeSUT()
        
        expectDelete(sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessfully()
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
    
    
    private func expect(_ sut: LocalFavoritesTransferLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(makeItem(name: "amin", cardNumber: "1", note: "note").model) { result in
            if case let Result.failure(error) = result { receivedError = error }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
    
    private func expectDelete(_ sut: LocalFavoritesTransferLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.delete(makeItem(name: "amin", cardNumber: "1", note: "note").model) { result in
            if case let Result.failure(error) = result { receivedError = error }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
    
    private func makeItem(name: String, cardNumber: String, note: String) -> (model: Transfer, local: LocalTransfer) {
        let person = Person(fullName: name, email: "Torabi.dsd@gmail.com", avatar: URL(string: "any-url.com")!)
        let card = Card(cardNumber: cardNumber, cardType: "Personal")
        let transferDate : String = "2022-07-14T02:47:58Z"
        let moreInfo = MoreInfo(numberOfTransfers: 5, totalTransfer: 100)
        let item = Transfer(person: person, card: card, lastTransfer: transferDate.toDate(), note: note, moreInfo: moreInfo)
        
        
        let localItem = LocalTransfer(person: LocalPerson(fullName: person.fullName, email: person.email, avatar: person.avatar), card: LocalCard(cardNumber: card.cardNumber, cardType: card.cardType), lastTransfer: transferDate.toDate(), note: note, moreInfo: LocalMoreInfo(numberOfTransfers: moreInfo.numberOfTransfers, totalTransfer: moreInfo.totalTransfer))
        return (item, localItem)
    }
    
    class FavoritesTransferStoreSpy: FavoritesTransferStore {

        enum ReceivedMessage: Equatable {
            case retrieve([LocalTransfer])
            case insert
            case delete
        }
        
        private var retrievalCompletions = [(RetrievalResult) -> Void]()
        private var insertionCompletions = [(InsertionResult) -> Void]()
        private var deletionCompletions = [(DeletionResult) -> Void]()

        var receivedMessages: [ReceivedMessage] = []
        
        func retrieve(completion: @escaping (RetrievalResult) -> Void) {
            retrievalCompletions.append(completion)
            receivedMessages.append(.retrieve([]))
        }
       
        func completeRetrieval(with error: Error, at index: Int = 0) {
            retrievalCompletions[index](.failure(error))
        }
        
        func completeRetrieval(with localTransfers: [LocalTransfer], at index: Int = 0) {
            retrievalCompletions[index](.success(localTransfers))
        }
       
        func insert(_ transfer: LocalTransfer, completion: @escaping (InsertionResult) -> Void) {
            insertionCompletions.append(completion)
            receivedMessages.append(.insert)
        }
        
        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](.success(()))
        }
        
        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](.failure(error))
        }
        
        func delete(_ transfer: LocalTransfer, completion: @escaping (DeletionResult) -> Void) {
            deletionCompletions.append(completion)
            receivedMessages.append(.delete)
        }
        
        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletions[index](.failure(error))
        }
        
        func completeDeletionSuccessfully(at index: Int = 0) {
            deletionCompletions[index](.success(()))
        }
        
        
        
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

}




