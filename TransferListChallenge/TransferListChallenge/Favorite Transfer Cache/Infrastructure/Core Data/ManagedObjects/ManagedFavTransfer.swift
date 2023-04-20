//
//  ManagedFavTransfer+CoreDataProperties.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/20/23.
//
//

import Foundation
import CoreData

@objc(ManagedFavTransfer)
public class ManagedFavTransfer: NSManagedObject {

}

extension ManagedFavTransfer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedFavTransfer> {
        return NSFetchRequest<ManagedFavTransfer>(entityName: "ManagedFavTransfer")
    }

    @NSManaged public var note: String?
    @NSManaged public var lastTransfer: Date?
    @NSManaged public var person: ManagedPerson?
    @NSManaged public var card: ManagedCard?
    @NSManaged public var moreInfo: ManagedMoreInfo?

}

extension ManagedFavTransfer : Identifiable {

}
