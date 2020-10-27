//
//  MessageDB+CoreDataProperties.swift
//  
//
//  Created by Марат Джаныбаев on 27.10.2020.
//
//

import Foundation
import CoreData

extension MessageDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDB> {
        return NSFetchRequest<MessageDB>(entityName: "MessageDB")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var content: String?
    @NSManaged public var senderId: String?
    @NSManaged public var created: Date?

}
