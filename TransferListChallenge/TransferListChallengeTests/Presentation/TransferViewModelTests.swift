//
//  TransferViewModelTests.swift
//  TransferListChallengeTests
//
//  Created by Amir Masoumi on 4/21/23.
//

import XCTest
import TransferListChallenge

class TransferViewModel: ObservableObject {
    
    @Published var transfers: [Transfer] = []
    @Published var isTransfersLoading: Bool = false
    
    let transferLoader: TransferLoader
    init(transferLoader: TransferLoader) {
        self.transferLoader = transferLoader
    }
    
    func load() {
        isTransfersLoading = true
        transferLoader.load { result in
            switch result {
            case let .success(transfers):
                self.transfers = transfers
                self.isTransfersLoading = false
            case .failure:
                break
            }
        }
    }
}

final class TransferViewModelTests: XCTestCase {

    func test_doesNotLoad_onInit() throws {
        let transferLoader = TransferLoaderSpy()
        let sut = TransferViewModel(transferLoader: transferLoader)
        XCTAssertEqual(sut.transfers, [])
    }
    
    func test_deliversTransfers_onLoadCall() throws {
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        let transferLoader = TransferLoaderSpy()
        let sut = TransferViewModel(transferLoader: transferLoader)
        sut.load()
        transferLoader.complete(with: [transfer])
        XCTAssertEqual(sut.transfers, [transfer])
    }
    
    func test_transfersLoadingIsActivated_onLoadCall() throws {
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        let transferLoader = TransferLoaderSpy()
        let sut = TransferViewModel(transferLoader: transferLoader)
        XCTAssertEqual(sut.isTransfersLoading, false)
        sut.load()
        XCTAssertEqual(sut.isTransfersLoading, true)
        transferLoader.complete(with: [transfer])
        XCTAssertEqual(sut.isTransfersLoading, false)
    }
    
    class TransferLoaderSpy: TransferLoader {
        var transferCompletions: [(TransferLoader.Result) -> Void] = []
        
        func load(completion: @escaping (TransferLoader.Result) -> Void) {
            transferCompletions.append(completion)
        }
        
        func complete(with transfers: [Transfer]) {
            guard let completion = transferCompletions.first else { return }
            completion(.success(transfers))
        }
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
