//
//  TODOListItem+CoreDataProperties.swift
//  CoreData TODOList Demo
//
//  Created by Adwait Barkale on 15/12/23.
//
//

import Foundation
import CoreData


extension TODOListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TODOListItem> {
        return NSFetchRequest<TODOListItem>(entityName: "TODOListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension TODOListItem : Identifiable {

}
