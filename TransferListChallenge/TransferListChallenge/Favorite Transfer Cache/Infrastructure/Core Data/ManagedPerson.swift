//
//  ManagedPerson+CoreDataProperties.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/20/23.
//
//

import Foundation
import CoreData


@objc(ManagedPerson)
public class ManagedPerson: NSManagedObject {

}


extension ManagedPerson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPerson> {
        return NSFetchRequest<ManagedPerson>(entityName: "ManagedPerson")
    }

    @NSManaged public var avatar: URL
    @NSManaged public var email: String?
    @NSManaged public var fullName: String
    @NSManaged public var favTransfer: ManagedFavTransfer

}

extension ManagedPerson : Identifiable {

    static func find(in context: NSManagedObjectContext) throws -> ManagedPerson? {
        let request = NSFetchRequest<ManagedPerson>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedPerson {
        return ManagedPerson(context: context)
    }
}
