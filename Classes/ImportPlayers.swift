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
            print("ImportPlayers|importPlayers: Fetch error: \(error) description: \(error.userInfo)")
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
            print("ImportPlayers|importPlayers: Fetch error: \(error) description: \(error.userInfo)")
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
            print("ImportPlayers|importPlayers: Fetch error: \(error) description: \(error.userInfo)")
        }

    }  //importPlayers
    
}  //ImportPlayers 
