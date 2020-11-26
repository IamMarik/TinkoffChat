//
//  ChannelDB+CoreDataProperties.swift
//  
//
//  Created by Марат Джаныбаев on 27.10.2020.
//
//

import Foundation
import CoreData

extension ChannelDB {
    
    class var className: String { "ChannelDB" }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChannelDB> {
        let request = NSFetchRequest<ChannelDB>(entityName: className)
        return request
    }
    
    @nonobjc public class func fetchRequest(withId identifier: String) -> NSFetchRequest<ChannelDB> {
        let request = NSFetchRequest<ChannelDB>(entityName: className)
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        return request
    }

    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var lastMessage: String?
    @NSManaged public var lastActivity: Date?

}
