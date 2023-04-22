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
    @Published var favTransfers: [Transfer] = []
    
    @Published var isTransfersLoading: Bool = false
    @Published var isFavTransfersLoading: Bool = false
    
    @Published var connectivityError : String? = nil
    @Published var invalidDataError : String? = nil
    @Published var dataStoreError : String? = nil
    @Published var deleteError : String? = nil
    
    let transferLoader: TransferLoader
    let favTransferLoader: FavoritesTransferLoader
    
    init(transferLoader: TransferLoader, favTransferLoader: FavoritesTransferLoader) {
        self.transferLoader = transferLoader
        self.favTransferLoader = favTransferLoader
    }
    
    func load() {
        isTransfersLoading = true
        transferLoader.load { [weak self] result in
            guard let self = self else { return }
            self.isTransfersLoading = false
            switch result {
            case let .success(transfers):
                self.transfers = transfers
            case let .failure(error):
                guard let error = error as? RemoteTransferLoader.Error else { return }
                switch error {
                case .connectivity:
                    self.connectivityError = "Please check your network!"
                case .invalidData:
                    self.invalidDataError = "Could not reach to server!"
                }
            }
        }
    }
    
    func loadFavTransfers() {
        isFavTransfersLoading = true
        favTransferLoader.load { [weak self] result in
            guard let self = self else { return }
            self.isFavTransfersLoading = false
            switch result {
            case let .success(favTransfers):
                self.favTransfers = favTransfers
            case .failure:
                self.dataStoreError = "Could not load favorite transfers!"

            }
        }
    }
    
    func addToFavorites(item: Transfer) {
        favTransferLoader.save(item) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: break
            case .failure:
                self.deleteError = "Could not delete item"
            }
        }
    }
}

final class TransferViewModelTests: XCTestCase {

    // MARK: - transfer Loading

    func test_doesNotLoad_onInit() throws {
        let (sut,_, _) = makeSUT()
        XCTAssertEqual(sut.transfers, [])
    }
    
    func test_deliversTransfers_onLoadCall() throws {
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        let (sut,transferLoader, _) = makeSUT()
        sut.load()
        transferLoader.complete(with: [transfer])
        XCTAssertEqual(sut.transfers, [transfer])
    }
    
    func test_transfersLoadingIsActivated_onLoadCall() throws {
       
        let (sut,transferLoader, _) = makeSUT()
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model

        XCTAssertEqual(sut.isTransfersLoading, false)
        sut.load()
        XCTAssertEqual(sut.isTransfersLoading, true)
        transferLoader.complete(with: [transfer])
        XCTAssertEqual(sut.isTransfersLoading, false)
    }
    
    func test_loadingTransfers_getsConnectivityError() {
        let (sut,transferLoader, _) = makeSUT()
        sut.load()
        transferLoader.complete(with: RemoteTransferLoader.Error.connectivity)
        
        XCTAssertNotNil(sut.connectivityError)
    }
    
    func test_loadingTransfers_getsInvalidDataError() {
        let (sut,transferLoader, _) = makeSUT()
        sut.load()
        transferLoader.complete(with: RemoteTransferLoader.Error.invalidData)
        
        XCTAssertNotNil(sut.invalidDataError)
    }

    func test_transfersLoadingIsDeActivated_afterGettingError() {
        let (sut,transferLoader,_) = makeSUT()

        XCTAssertEqual(sut.isTransfersLoading, false)
        sut.load()
        XCTAssertEqual(sut.isTransfersLoading, true)
        transferLoader.complete(with: RemoteTransferLoader.Error.connectivity)
        XCTAssertEqual(sut.isTransfersLoading, false)
    }
    
    // MARK: - favTransfer Loading
    func test_doesNotLoadFavTransfers_onInit() throws {
        let (sut,_, _) = makeSUT()
        XCTAssertEqual(sut.favTransfers, [])
    }
    
    func test_deliversFavTransfers_onLoadCall() throws {
        let (sut,_, favTransferLoader) = makeSUT()

        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        sut.addToFavorites(item: transfer)
        favTransferLoader.completeSaving()
        
        sut.loadFavTransfers()
        favTransferLoader.completeLoading()
        XCTAssertEqual(sut.favTransfers, [transfer])
    }
    
    
    func test_favTransfersLoadingIsActivated_onLoadCall() throws {
       
        let (sut,_, favTransferLoader) = makeSUT()
      
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        sut.addToFavorites(item: transfer)
        favTransferLoader.completeSaving()

        XCTAssertEqual(sut.isFavTransfersLoading, false)
        sut.loadFavTransfers()
        XCTAssertEqual(sut.isFavTransfersLoading, true)
        favTransferLoader.completeLoading()
        XCTAssertEqual(sut.isFavTransfersLoading, false)
    }
    
    func test_favTransfersLoadingIsDeActivated_afterGettingError() {
        let (sut,_,favTransferLoader) = makeSUT()

        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        sut.addToFavorites(item: transfer)
        favTransferLoader.completeSaving()
        
        XCTAssertEqual(sut.isFavTransfersLoading, false)
        sut.loadFavTransfers()
        XCTAssertEqual(sut.isFavTransfersLoading, true)
        favTransferLoader.complete(with: anyError())
        XCTAssertEqual(sut.isFavTransfersLoading, false)
    }
    
    func test_loadingFavTransfers_getsDataStoreError() {
        let (sut,_,favTransferLoader) = makeSUT()
       
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        sut.addToFavorites(item: transfer)
        favTransferLoader.completeSaving()
        
        sut.loadFavTransfers()
        favTransferLoader.complete(with: anyError())
        
        XCTAssertNotNil(sut.dataStoreError)
    }
    
    func test_addToFavTransfer_givesError() {
        let (sut, _, favTransferLoader) = makeSUT()
        
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        sut.addToFavorites(item: transfer)
        favTransferLoader.completeSaving(with: anyError())
        
        XCTAssertNotNil(sut.deleteError)
    }
   
    func test_addToFavTransferSuccessfully_canLoadThatItem() {
        let (sut, _, favTransferLoader) = makeSUT()
        
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        sut.addToFavorites(item: transfer)
        favTransferLoader.completeSaving()
        
        sut.loadFavTransfers()
        favTransferLoader.completeLoading()
        
        XCTAssertEqual(sut.favTransfers, [transfer])
    }
    
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: TransferViewModel, transferLoader: TransferLoaderSpy, favTransferLoader: FavTransferLoaderSpy) {
       
        let transferLoader = TransferLoaderSpy()
        let favTransferLoader = FavTransferLoaderSpy()
        let sut = TransferViewModel(transferLoader: transferLoader, favTransferLoader: favTransferLoader)
        
        trackForMemoryLeaks(transferLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(favTransferLoader, file: file, line: line)
       
        return (sut, transferLoader, favTransferLoader)
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
        
        func complete(with error: RemoteTransferLoader.Error) {
            guard let completion = transferCompletions.first else { return }
            completion(.failure(error))
        }
    }
    
    class FavTransferLoaderSpy: FavoritesTransferLoader {
       
        var favTransferCompletions: [(LoadResult) -> Void] = []
        var saveCompletions: [(SaveResult) -> Void] = []
        
        var saveTransfers: [Transfer] =  []
        var favTransfers: [Transfer] = []
        
        func load(completion: @escaping (LoadResult) -> Void) {
            favTransferCompletions.append(completion)
        }
        
        func completeLoading() {
            guard let completion = favTransferCompletions.first else { return }
            completion(.success(favTransfers))
        }
        
        func complete(with error: Error) {
            guard let completion = favTransferCompletions.first else { return }
            completion(.failure(error))
        }
        
        func save(_ transfer: TransferListChallenge.Transfer, completion: @escaping (SaveResult) -> Void) {
            saveCompletions.append(completion)
            saveTransfers.append(transfer)
        }
        
        func completeSaving() {
            guard let completion = saveCompletions.first else { return }
            favTransfers.append(contentsOf: saveTransfers)
            completion(.success(()))
        }
        
        func completeSaving(with error: Error) {
            guard let completion = saveCompletions.first else { return }
            completion(.failure(error))
        }
        
        
        func delete(_ transfer: TransferListChallenge.Transfer, completion: @escaping (DeleteResult) -> Void) {
            
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
    
    func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
}
