//
//  ManagedMoreInfo+CoreDataProperties.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/20/23.
//
//

import Foundation
import CoreData

@objc(ManagedMoreInfo)
public class ManagedMoreInfo: NSManagedObject {

}

extension ManagedMoreInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedMoreInfo> {
        return NSFetchRequest<ManagedMoreInfo>(entityName: "ManagedMoreInfo")
    }

    @NSManaged public var totalTransfer: Int32
    @NSManaged public var numberOfTransfers: Int32
    @NSManaged public var favTransfer: ManagedFavTransfer

}

extension ManagedMoreInfo : Identifiable {

    static func find(in context: NSManagedObjectContext) throws -> ManagedMoreInfo? {
        let request = NSFetchRequest<ManagedMoreInfo>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedMoreInfo {
        try find(in: context).map(context.delete)
        return ManagedMoreInfo(context: context)
    }
    
}
