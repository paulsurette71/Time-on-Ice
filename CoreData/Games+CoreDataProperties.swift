//
//  Games+CoreDataProperties.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-01.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//
//

import Foundation
import CoreData


extension Games {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Games> {
        return NSFetchRequest<Games>(entityName: "Games")
    }

    @NSManaged public var arenaCity: String?
    @NSManaged public var arenaName: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var oppositionCity: String?
    @NSManaged public var oppositionTeamName: String?
    @NSManaged public var gameShiftRelationship: NSSet?

}

// MARK: Generated accessors for gameShiftRelationship
extension Games {

    @objc(addGameShiftRelationshipObject:)
    @NSManaged public func addToGameShiftRelationship(_ value: Shifts)

    @objc(removeGameShiftRelationshipObject:)
    @NSManaged public func removeFromGameShiftRelationship(_ value: Shifts)

    @objc(addGameShiftRelationship:)
    @NSManaged public func addToGameShiftRelationship(_ values: NSSet)

    @objc(removeGameShiftRelationship:)
    @NSManaged public func removeFromGameShiftRelationship(_ values: NSSet)

}
