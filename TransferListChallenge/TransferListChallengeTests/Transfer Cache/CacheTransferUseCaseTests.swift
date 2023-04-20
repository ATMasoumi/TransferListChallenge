//
//  CacheTransferUseCaseTests.swift
//  TransferListChallengeTests
//
//  Created by Amir Masoumi on 4/20/23.
//

import XCTest
import TransferListChallenge


protocol FavoritesTransferLoader {
    typealias LoadResult = Swift.Result<[Transfer], Error>
    func load(completion: @escaping (LoadResult) -> Void)
}

protocol FavoritesTransferStore {
    typealias RetrievalResult = Result<[LocalTransfer], Error>
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
            case let .success(transfers):
                completion(.success(transfers.toModels()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private extension Array where Element == LocalTransfer {
    func toModels() -> [Transfer] {
        return map {
            let person = Person(fullName: $0.person.fullName, email: $0.person.email, avatar: $0.person.avatar)
            let card = Card(cardNumber: $0.card.cardNumber, cardType: $0.card.cardType)
            let moreInfo = MoreInfo(numberOfTransfers: $0.moreInfo.numberOfTransfers, totalTransfer: $0.moreInfo.totalTransfer)
            let item = Transfer(person: person, card: card, lastTransfer: $0.lastTransfer, note: $0.note, moreInfo: moreInfo)
           return item
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
    
    func test_load_deliversCachedFavoritesTransfers() {
        let favoriteTransfer = makeItem(name: "amin", cardNumber: "1", note: "note1")
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([favoriteTransfer.model]), when: {
            store.completeRetrieval(with: [favoriteTransfer.local])
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
        
        func completeRetrieval(with localTransfers: [LocalTransfer], at index: Int = 0) {
            retrievalCompletions[index](.success(localTransfers))
        }
        
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

}




// MARK: - Transfer
public struct LocalTransfer: Equatable {
    public let person: LocalPerson
    public let card: LocalCard
    public let lastTransfer: Date
    public let note: String?
    public let moreInfo: LocalMoreInfo
    public init(person: LocalPerson, card: LocalCard, lastTransfer: Date, note: String?, moreInfo: LocalMoreInfo) {
        self.person = person
        self.card = card
        self.lastTransfer = lastTransfer
        self.note = note
        self.moreInfo = moreInfo
    }
}

// MARK: - Card
public struct LocalCard: Equatable {
    public let cardNumber, cardType: String
    public init(cardNumber: String, cardType: String) {
        self.cardNumber = cardNumber
        self.cardType = cardType
    }
}

// MARK: - MoreInfo
public struct LocalMoreInfo: Equatable {
    public let numberOfTransfers, totalTransfer: Int
    public init(numberOfTransfers: Int, totalTransfer: Int) {
        self.numberOfTransfers = numberOfTransfers
        self.totalTransfer = totalTransfer
    }
}

// MARK: - Person
public struct LocalPerson: Equatable {
    public let fullName: String
    public let email: String?
    public let avatar: URL
    public init(fullName: String, email: String?, avatar: URL) {
        self.fullName = fullName
        self.email = email
        self.avatar = avatar
    }
}
