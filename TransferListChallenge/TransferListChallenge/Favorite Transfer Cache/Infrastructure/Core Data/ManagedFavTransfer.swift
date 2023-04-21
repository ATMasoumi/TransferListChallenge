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
    @NSManaged public var identifier: String
    @NSManaged public var lastTransfer: Date
    @NSManaged public var addDate: Date
    @NSManaged public var person: ManagedPerson
    @NSManaged public var card: ManagedCard
    @NSManaged public var moreInfo: ManagedMoreInfo
    
}

extension ManagedFavTransfer : Identifiable {
   
    static func find(in context: NSManagedObjectContext) throws -> [ManagedFavTransfer]? {
        let request = fetchRequest()
        var addDateSort = NSSortDescriptor(key:"addDate", ascending:true)
        request.sortDescriptors = [addDateSort]
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    static func findObject(with id: String, in context: NSManagedObjectContext) throws -> ManagedFavTransfer? {
        let request = NSFetchRequest<ManagedFavTransfer>(entityName: entity().name!)
        request.predicate = NSPredicate(
            format: "identifier LIKE %@", id
        )
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedFavTransfer {
        return ManagedFavTransfer(context: context)
    }
    
}
