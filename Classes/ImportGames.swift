//
//  ImportGames.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-10.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ImportGames {
    
    //App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func importGames() {
        
        let managedContext = appDelegate.coreDataStack.managedContext
        
        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Games", in: managedContext)
            let game = Games(entity: entity!, insertInto: managedContext)

            game.homeTeamCity = "Chicago"
            game.homeTeamName = "Blackhawks"
            game.visitorTeamCity = "Arizona"
            game.visitorTeamName = "Coyotes"
            game.arenaCity = "Chicago"
            game.arenaName = "United Center"
            
            game.date = Date() as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }
        
        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Games", in: managedContext)
            let game = Games(entity: entity!, insertInto: managedContext)
            
            game.homeTeamCity = "St. Louis"
            game.homeTeamName = "Blues"
            game.visitorTeamCity = "Buffalo"
            game.visitorTeamName = "Sabres"
            game.arenaCity = "Buffalo"
            game.arenaName = "Scottrade Center"
            
            game.date = Date() as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }
        
        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Games", in: managedContext)
            let game = Games(entity: entity!, insertInto: managedContext)
            
            game.homeTeamCity = "Toronto"
            game.homeTeamName = "Maple Leafs"
            game.visitorTeamCity = "Edmonton"
            game.visitorTeamName = "Oilers"
            game.arenaCity = "Toronto"
            game.arenaName = "Air Canada Centre"
            
            game.date = Date() as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Games", in: managedContext)
            let game = Games(entity: entity!, insertInto: managedContext)
            
            game.homeTeamCity = "San Jose"
            game.homeTeamName = "Sharks"
            game.visitorTeamCity = "Minnesota"
            game.visitorTeamName = "Wild"
            game.arenaCity = "San Jose"
            game.arenaName = "SAP Center"
            
            game.date = Date() as NSDate?
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }

    }  //importGames
    
}  //ImportPlayers

