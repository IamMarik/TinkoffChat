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
    
    class var className: String { "MessageDB" }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDB> {
        return NSFetchRequest<MessageDB>(entityName: className)
    }
    
    @nonobjc public class func fetchRequest(withId identifier: String) -> NSFetchRequest<MessageDB> {
        let request = NSFetchRequest<MessageDB>(entityName: className)
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        return request
    }
    
    @NSManaged public var identifier: String
    @NSManaged public var channelId: String
    @NSManaged public var content: String
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var created: Date

}
