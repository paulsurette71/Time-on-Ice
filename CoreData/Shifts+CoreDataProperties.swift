//
//  Shifts+CoreDataProperties.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-01.
//  Copyright © 2017 Surette, Paul. All rights reserved.
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
    @NSManaged public var gameRelationship: Games?
    @NSManaged public var playersRelationship: Players?

}
