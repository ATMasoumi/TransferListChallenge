//
//  CoreDataFavoritesTransferStore+FavoritesTransferStore.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/20/23.
//

import Foundation

extension CoreDataFavoritesTransferStore: FavoritesTransferStore {
    
    public func retrieve(completion: @escaping (RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                let managedFavTransfer: [ManagedFavTransfer]? = try ManagedFavTransfer.find(in: context)
                guard let managedFavTransfer = managedFavTransfer else { return []}
                
                return managedFavTransfer.map({LocalTransfer(person: LocalPerson(fullName: $0.person.fullName, email: $0.person.email, avatar: $0.person.avatar), card: LocalCard(cardNumber: $0.card.cardNumber, cardType: $0.card.cardType), lastTransfer: $0.lastTransfer, note: $0.note, moreInfo: LocalMoreInfo(numberOfTransfers: Int($0.moreInfo.numberOfTransfers), totalTransfer: Int($0.moreInfo.totalTransfer)))})
            })
        }
    }
    
    public func insert(_ transfer: TransferListChallenge.LocalTransfer, completion: @escaping (InsertionResult) -> Void) {
        perform { context in
            completion(Result {
                
                let managedFavTransfer = try ManagedFavTransfer.newUniqueInstance(in: context)
                
                let managedMoreInfo = try ManagedMoreInfo.newUniqueInstance(in: context)
                managedMoreInfo.numberOfTransfers = Int32(transfer.moreInfo.numberOfTransfers)
                managedMoreInfo.totalTransfer = Int32(transfer.moreInfo.totalTransfer)
                
                let managedCard = try ManagedCard.newUniqueInstance(in: context)
                managedCard.cardNumber = transfer.card.cardNumber
                managedCard.cardType = transfer.card.cardType
                
                let managedPerson = try ManagedPerson.newUniqueInstance(in: context)
                managedPerson.avatar = transfer.person.avatar
                managedPerson.email = transfer.person.email
                managedPerson.fullName = transfer.person.fullName
                
                managedFavTransfer.lastTransfer = transfer.lastTransfer
                managedFavTransfer.note = transfer.note
                managedFavTransfer.person = managedPerson
                managedFavTransfer.card = managedCard
                managedFavTransfer.moreInfo = managedMoreInfo
                
                try context.save()
            })
        }
    }
    
    public func delete(_ transfer: TransferListChallenge.LocalTransfer, completion: @escaping (DeletionResult) -> Void) {
        
    }
    
    
}
