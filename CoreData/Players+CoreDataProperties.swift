//
//  Players+CoreDataProperties.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-01.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//
//

import Foundation
import CoreData


extension Players {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Players> {
        return NSFetchRequest<Players>(entityName: "Players")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var number: String?
    @NSManaged public var position: String?
    @NSManaged public var shoots: String?
    @NSManaged public var city: String?
    @NSManaged public var team: String?
    @NSManaged public var league: String?
    @NSManaged public var level: String?
    @NSManaged public var division: String?
    @NSManaged public var height: String?
    @NSManaged public var weight: String?
    @NSManaged public var headshot: NSData?
    @NSManaged public var birthdate: NSDate?
    @NSManaged public var playersShiftRelationship: NSSet?

}

// MARK: Generated accessors for playersShiftRelationship
extension Players {

    @objc(addPlayersShiftRelationshipObject:)
    @NSManaged public func addToPlayersShiftRelationship(_ value: Shifts)

    @objc(removePlayersShiftRelationshipObject:)
    @NSManaged public func removeFromPlayersShiftRelationship(_ value: Shifts)

    @objc(addPlayersShiftRelationship:)
    @NSManaged public func addToPlayersShiftRelationship(_ values: NSSet)

    @objc(removePlayersShiftRelationship:)
    @NSManaged public func removeFromPlayersShiftRelationship(_ values: NSSet)

}
