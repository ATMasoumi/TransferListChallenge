//
//  LocalFavoritesTransferLoader.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/20/23.
//

import Foundation

public class LocalFavoritesTransferLoader: FavoritesTransferLoader {
    
    let store: FavoritesTransferStore
    
    public init(store: FavoritesTransferStore) {
        self.store = store
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(transfers):
                    completion(.success(transfers.toModels()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func save(_ transfer: TransferListChallenge.Transfer, completion: @escaping (FavoritesTransferLoader.SaveResult) -> Void) {
        
        let localTransfer = LocalTransfer(person: LocalPerson(fullName: transfer.person.fullName, email: transfer.person.email, avatar: transfer.person.avatar), card: LocalCard(cardNumber: transfer.card.cardNumber, cardType: transfer.card.cardType), lastTransfer: transfer.lastTransfer, note: transfer.note, moreInfo: LocalMoreInfo(numberOfTransfers: transfer.moreInfo.numberOfTransfers, totalTransfer: transfer.moreInfo.totalTransfer))
        
        store.insert(localTransfer) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func delete(_ transfer: TransferListChallenge.Transfer, completion: @escaping (DeleteResult) -> Void) {
       
        let localTransfer = LocalTransfer(person: LocalPerson(fullName: transfer.person.fullName, email: transfer.person.email, avatar: transfer.person.avatar), card: LocalCard(cardNumber: transfer.card.cardNumber, cardType: transfer.card.cardType), lastTransfer: transfer.lastTransfer, note: transfer.note, moreInfo: LocalMoreInfo(numberOfTransfers: transfer.moreInfo.numberOfTransfers, totalTransfer: transfer.moreInfo.totalTransfer))
        
        store.delete(localTransfer) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
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
            let item = Transfer(person: person, card: card, lastTransfer: $0.lastTransfer, note: $0.note, moreInfo: moreInfo, markedFavorite: true)
           return item
        }
    }
}
