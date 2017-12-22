//
//  Players+CoreDataProperties.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-21.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//
//

import Foundation
import CoreData


extension Players {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Players> {
        return NSFetchRequest<Players>(entityName: "Players")
    }

    @NSManaged public var birthdate: NSDate?
    @NSManaged public var city: String?
    @NSManaged public var division: String?
    @NSManaged public var firstName: String?
    @NSManaged public var headshot: NSData?
    @NSManaged public var height: String?
    @NSManaged public var lastName: String?
    @NSManaged public var league: String?
    @NSManaged public var level: String?
    @NSManaged public var number: String?
    @NSManaged public var position: String?
    @NSManaged public var shoots: String?
    @NSManaged public var team: String?
    @NSManaged public var weight: String?
    @NSManaged public var onIce: Bool
    @NSManaged public var onBench: Bool
    @NSManaged public var onIceStatusRelationship: NSOrderedSet?
    @NSManaged public var playersShiftRelationship: NSSet?

}

// MARK: Generated accessors for onIceStatusRelationship
extension Players {

    @objc(insertObject:inOnIceStatusRelationshipAtIndex:)
    @NSManaged public func insertIntoOnIceStatusRelationship(_ value: NSManagedObject, at idx: Int)

    @objc(removeObjectFromOnIceStatusRelationshipAtIndex:)
    @NSManaged public func removeFromOnIceStatusRelationship(at idx: Int)

    @objc(insertOnIceStatusRelationship:atIndexes:)
    @NSManaged public func insertIntoOnIceStatusRelationship(_ values: [NSManagedObject], at indexes: NSIndexSet)

    @objc(removeOnIceStatusRelationshipAtIndexes:)
    @NSManaged public func removeFromOnIceStatusRelationship(at indexes: NSIndexSet)

    @objc(replaceObjectInOnIceStatusRelationshipAtIndex:withObject:)
    @NSManaged public func replaceOnIceStatusRelationship(at idx: Int, with value: NSManagedObject)

    @objc(replaceOnIceStatusRelationshipAtIndexes:withOnIceStatusRelationship:)
    @NSManaged public func replaceOnIceStatusRelationship(at indexes: NSIndexSet, with values: [NSManagedObject])

    @objc(addOnIceStatusRelationshipObject:)
    @NSManaged public func addToOnIceStatusRelationship(_ value: NSManagedObject)

    @objc(removeOnIceStatusRelationshipObject:)
    @NSManaged public func removeFromOnIceStatusRelationship(_ value: NSManagedObject)

    @objc(addOnIceStatusRelationship:)
    @NSManaged public func addToOnIceStatusRelationship(_ values: NSOrderedSet)

    @objc(removeOnIceStatusRelationship:)
    @NSManaged public func removeFromOnIceStatusRelationship(_ values: NSOrderedSet)

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
