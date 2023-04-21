//
//  ManagedCard+CoreDataProperties.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/20/23.
//
//

import Foundation
import CoreData

@objc(ManagedCard)
public class ManagedCard: NSManagedObject {

}

extension ManagedCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCard> {
        return NSFetchRequest<ManagedCard>(entityName: "ManagedCard")
    }

    @NSManaged public var cardType: String
    @NSManaged public var cardNumber: String
    @NSManaged public var favTransfer: ManagedFavTransfer
    
}

extension ManagedCard : Identifiable {

}
