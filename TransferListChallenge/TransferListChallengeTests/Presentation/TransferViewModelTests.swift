//
//  TransferViewModelTests.swift
//  TransferListChallengeTests
//
//  Created by Amir Masoumi on 4/21/23.
//

import XCTest
import TransferListChallenge

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
    
    func test_increasePage_onLoadCall() throws {
        let (sut,_, _) = makeSUT()
        
        sut.load()
        XCTAssertEqual(sut.page,1)
        
        sut.load()
        XCTAssertEqual(sut.page,2)
    }
    
    func test_refreshPaginationData() {
        let (sut,_, _) = makeSUT()
        
        sut.load()
        XCTAssertEqual(sut.page,1)
        
        sut.load()
        XCTAssertEqual(sut.page,2)
        
        sut.refreshPaginationData()
        
        XCTAssertEqual(sut.page, 0)
        XCTAssertEqual(sut.transfers, [])
        
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
        
        XCTAssertNotNil(sut.remoteLoadError)
    }
    
    func test_loadingTransfers_getsInvalidDataError() {
        let (sut,transferLoader, _) = makeSUT()
        sut.load()
        transferLoader.complete(with: RemoteTransferLoader.Error.invalidData)
        
        XCTAssertNotNil(sut.remoteLoadError)
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
        
        XCTAssertNotNil(sut.addError)
    }
    
    func test_addToFavTransferSuccessfully_canLoadThatItem() {
        let (sut, _, favTransferLoader) = makeSUT()
        
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        sut.addToFavorites(item: transfer)
        favTransferLoader.completeSaving()
        
        let transfer2 = makeItem(name: "torabi", cardNumber: "2", note: "note2").model
        sut.addToFavorites(item: transfer2)
        favTransferLoader.completeSaving()
        
        sut.loadFavTransfers()
        favTransferLoader.completeLoading()
        
        XCTAssertEqual(sut.favTransfers, [transfer, transfer2])
    }
    
    func test_addToFavTransferSuccessfully_marksThatTransferAsFavorite() {
        
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        let (sut, transferLoader, favTransferLoader) = makeSUT()
       
        sut.load()
        transferLoader.complete(with: [transfer])
        
        sut.addToFavorites(item: transfer)
        favTransferLoader.completeSaving()
        
        
        XCTAssertEqual(sut.transfers.first!.markedFavorite, true)
    }
    
        func test_removeFromFavTransferSuccessfully_marksThatTransferAsNotFavorite() {
    
            var transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
            transfer.markedFavorite = true
            let (sut, transferLoader, favTransferLoader) = makeSUT()
    
            sut.load()
            transferLoader.complete(with: [transfer])
    
            sut.deleteFavorite(item: transfer)
            favTransferLoader.completeDeletion()
    
    
            XCTAssertEqual(sut.transfers.first!.markedFavorite, false)
        }
    
    func test_deleteFavTransferSuccessfully() {
        let (sut, _, favTransferLoader) = makeSUT()
        
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        sut.addToFavorites(item: transfer)
        favTransferLoader.completeSaving()
        
        let transfer2 = makeItem(name: "torabi", cardNumber: "2", note: "note2").model
        sut.addToFavorites(item: transfer2)
        favTransferLoader.completeSaving()
        
        
        sut.deleteFavorite(item: transfer2)
        favTransferLoader.completeDeletion()
        
        sut.loadFavTransfers()
        favTransferLoader.completeLoading()
        
        XCTAssertEqual(sut.favTransfers, [transfer])
    }
    
    func test_deleteFavTransfer_givesError() {
        let (sut, _, favTransferLoader) = makeSUT()
        
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        sut.addToFavorites(item: transfer)
        favTransferLoader.completeSaving()
        
        let transfer2 = makeItem(name: "torabi", cardNumber: "2", note: "note2").model
        sut.addToFavorites(item: transfer2)
        favTransferLoader.completeSaving()
        
        
        sut.deleteFavorite(item: transfer2)
        favTransferLoader.completeDeletion(with: anyError())
        
        XCTAssertNotNil(sut.deleteError)
    }
    
    func test_marksTransfersFromRemoteToFavorite_onLoadFavorites() {
        let (sut, transferLoader, favTransferLoader) = makeSUT()
        
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        let transfer2 = makeItem(name: "amin", cardNumber: "1", note: "note").model
        let transfer3 = makeItem(name: "amin", cardNumber: "1", note: "note").model
       
        sut.addToFavorites(item: transfer)
        favTransferLoader.completeSaving()
        
        sut.load()
        transferLoader.complete(with: [transfer,transfer2, transfer3])
        
        sut.loadFavTransfers()
        favTransferLoader.completeLoading()
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(sut.favTransfers, [transfer])
            XCTAssertEqual(sut.transfers[0].markedFavorite, true)
            XCTAssertEqual(sut.transfers[1].markedFavorite, false)
            XCTAssertEqual(sut.transfers[2].markedFavorite, false)
        }
        executeRunLoop()
    }
    
    func test_selectItem() {
        let (sut, transferLoader, _) = makeSUT()
        let transfer = makeItem(name: "amin", cardNumber: "1", note: "note").model
        let transfer2 = makeItem(name: "amin", cardNumber: "1", note: "note").model
        let transfer3 = makeItem(name: "amin", cardNumber: "1", note: "note").model
        
        sut.load()
        transferLoader.complete(with: [transfer,transfer2, transfer3])
        
        sut.select(item: transfer)
        XCTAssertEqual(sut.selectedItem, transfer)
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
        
        func load(page: Int, completion: @escaping (TransferLoader.Result) -> Void) {
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
        var deleteCompletions: [(DeleteResult) -> Void] = []
        
        var saveTransfers: [Transfer] =  []
        var deleteTransfers: [Transfer] =  []
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
            saveTransfers = []
        }
        
        func completeSaving(with error: Error) {
            guard let completion = saveCompletions.first else { return }
            completion(.failure(error))
        }
        
        
        func delete(_ transfer: TransferListChallenge.Transfer, completion: @escaping (DeleteResult) -> Void) {
            deleteCompletions.append(completion)
            deleteTransfers.append(transfer)
        }
        
        func completeDeletion() {
            guard let completion = deleteCompletions.first else { return }
            guard let transfer = deleteTransfers.first else {
                completion(.success(()))
                return
            }
            favTransfers.removeAll(where: { $0.person.fullName == transfer.person.fullName })
            completion(.success(()))
            deleteTransfers = []
        }
        
        func completeDeletion(with error: Error) {
            guard let completion = deleteCompletions.first else { return }
            completion(.failure(error))
        }
        
        
        
    }
    
    private func makeItem(name: String, cardNumber: String, note: String) -> (model: Transfer, local: LocalTransfer) {
        let person = Person(fullName: name, email: "Torabi.dsd@gmail.com", avatar: URL(string: "any-url.com")!)
        let card = Card(cardNumber: cardNumber, cardType: "Personal")
        let transferDate : String = "2022-07-14T02:47:58Z"
        let moreInfo = MoreInfo(numberOfTransfers: 5, totalTransfer: 100)
        let item = Transfer(person: person, card: card, lastTransfer: transferDate.toDate(), note: note, moreInfo: moreInfo, markedFavorite: false)
        
        
        let localItem = LocalTransfer(person: LocalPerson(fullName: person.fullName, email: person.email, avatar: person.avatar), card: LocalCard(cardNumber: card.cardNumber, cardType: card.cardType), lastTransfer: transferDate.toDate(), note: note, moreInfo: LocalMoreInfo(numberOfTransfers: moreInfo.numberOfTransfers, totalTransfer: moreInfo.totalTransfer))
        return (item, localItem)
    }
    
    func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    /// this method is there to hold the test for longer time  to give DispatchGroup to be notified
    func executeRunLoop() {
        RunLoop.current.run(until: Date() + 1)
    }
}

