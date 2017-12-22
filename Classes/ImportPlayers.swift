//
//  ImportPlayers.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-05.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ImportPlayers {
    
    //App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func importPlayers() {
        
        let managedContext = appDelegate.coreDataStack.managedContext
        
        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "Sidney"
            player.lastName  = "Crosby"
            player.number    = "87"
            player.position  = "Centre"
            player.shoots    = "Left"
            player.city      = "Pittsburgh"
            player.team      = "Penguins"
            player.league    = "NHL"
            player.level     = "Professional"
            player.division  = "Metropolitan"
            player.height    = "5'11\""
            player.weight    = "200 lb"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "crosby.jpg")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "1987-08-07"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "Alex"
            player.lastName  = "Ovechkin"
            player.number    = "8"
            player.position  = "Left Wing"
            player.shoots    = "Right"
            player.city      = "Washington"
            player.team      = "Capitals"
            player.league    = "NHL"
            player.level     = "Professional"
            player.division  = "Metropolitan"
            player.height    = "6'3\""
            player.weight    = "235 lb"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "ovechkin.jpg")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "1985-09-17"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "Patrick"
            player.lastName  = "Kane"
            player.number    = "88"
            player.position  = "Right Wing"
            player.shoots    = "Left"
            player.city      = "Chicago"
            player.team      = "Blackhawks"
            player.league    = "NHL"
            player.level     = "Professional"
            player.division  = "Central"
            player.height    = "5'11\""
            player.weight    = "177 lb"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "kane.jpg")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "1988-11-19"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "Steven"
            player.lastName  = "Stamkos"
            player.number    = "91"
            player.position  = "Centre"
            player.shoots    = "Right"
            player.city      = "Tampa Bay"
            player.team      = "Lightning"
            player.league    = "NHL"
            player.level     = "Professional"
            player.division  = "Atlantic"
            player.height    = "5'11\""
            player.weight    = "177 lb"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "stamkos.jpg")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "1990-02-07"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "Jamie"
            player.lastName  = "Benn"
            player.number    = "14"
            player.position  = "Left Wing"
            player.shoots    = "Left"
            player.city      = "Dallas"
            player.team      = "Stars"
            player.league    = "NHL"
            player.level     = "Professional"
            player.division  = "Central"
            player.height    = "6'2\""
            player.weight    = "209 lb"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "benn.jpg")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "1989-07-18"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "John"
            player.lastName  = "Tavares"
            player.number    = "91"
            player.position  = "Centre"
            player.shoots    = "Left"
            player.city      = "New York"
            player.team      = "Islanders"
            player.league    = "NHL"
            player.level     = "Professional"
            player.division  = "Metropolitan"
            player.height    = "6'1\""
            player.weight    = "208 lb"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "tavares.jpg")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "1990-09-20"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "P.K."
            player.lastName  = "Subban"
            player.number    = "76"
            player.position  = "Defense"
            player.shoots    = "Right"
            player.city      = "Nashville"
            player.team      = "Predators"
            player.league    = "NHL"
            player.level     = "Professional"
            player.division  = "Central"
            player.height    = "6'0\""
            player.weight    = "210 lb"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "subban.jpg")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "1989-05-13"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "Jaromir"
            player.lastName  = "Jagr"
            player.number    = "68"
            player.position  = "Right Wing"
            player.shoots    = "Left"
            player.city      = "Calgary"
            player.team      = "Flames"
            player.league    = "NHL"
            player.level     = "Professional"
            player.division  = "Pacific"
            player.height    = "6'3\""
            player.weight    = "230 lb"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "jagr.jpg")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "1972-02-15"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "Evgeni"
            player.lastName  = "Malkin"
            player.number    = "71"
            player.position  = "Centre"
            player.shoots    = "Left"
            player.city      = "Pittsburgh"
            player.team      = "Penguins"
            player.league    = "NHL"
            player.level     = "Professional"
            player.division  = "Metropolitan"
            player.height    = "6'3\""
            player.weight    = "195 lb"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "malkin.jpg")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "1986-07-31"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "Connor"
            player.lastName  = "McDavid"
            player.number    = "97"
            player.position  = "Centre"
            player.shoots    = "Left"
            player.city      = "Edmonton"
            player.team      = "Oilers"
            player.league    = "NHL"
            player.level     = "Professional"
            player.division  = "Pacific"
            player.height    = "6'1\""
            player.weight    = "192 lb"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "mcdavid.jpg")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "1997-01-13"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "Vladimir"
            player.lastName  = "Tarasenko"
            player.number    = "91"
            player.position  = "Centre"
            player.shoots    = "Left"
            player.city      = "St. Louis"
            player.team      = "Blues"
            player.league    = "NHL"
            player.level     = "Professional"
            player.division  = "Central"
            player.height    = "6'0\""
            player.weight    = "225 lb"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "tarasenko.jpg")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "1991-12-13"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = "Lucas"
            player.lastName  = "Surette"
            player.number    = "47"
            player.position  = "Left Wing"
            player.shoots    = "Left"
            player.city      = "Guelph"
            player.team      = "Jr. Gryphons"
            player.league    = "Tri-County"
            player.level     = "AA"
            player.division  = "Novice"
            player.height    = "4'3\""
            player.weight    = "55 lbs"
            
            //HeadShot
            let playerHeadshot = UIImageJPEGRepresentation(UIImage(named: "headshot")!, 1.0) as NSData?
            player.headshot = playerHeadshot
            
            //Store Birthdate
            let dateString           = "2009-04-07"
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            player.birthdate = date as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        
    }  //importPlayers
    
}  //ImportPlayers 
