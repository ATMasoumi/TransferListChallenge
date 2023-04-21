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

    @NSManaged public var totalTransfer: Int
    @NSManaged public var numberOfTransfers: Int
    @NSManaged public var favTransfer: ManagedFavTransfer

}

extension ManagedMoreInfo : Identifiable {

}