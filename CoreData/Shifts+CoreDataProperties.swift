//
//  Shifts+CoreDataProperties.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-11.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//
//

import Foundation
import CoreData


extension Shifts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shifts> {
        return NSFetchRequest<Shifts>(entityName: "Shifts")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var timeOnIce: Int16
    @NSManaged public var period: Int16
    @NSManaged public var gameRelationship: Games?
    @NSManaged public var playersRelationship: Players?

}
