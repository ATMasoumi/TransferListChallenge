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
    
   
    func test_Insert_DeliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        let insertionError = insert(favTransfer: makeItem(name: "amin", cardNumber: "1", note: "note").local, to: sut)
        XCTAssertNil(insertionError, "Expected to insert cache successfully")
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
    
    func insert(favTransfer: LocalTransfer, to sut: FavoritesTransferStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(favTransfer) { result in
            if case let Result.failure(error) = result { insertionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
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
}

