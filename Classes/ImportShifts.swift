//
//  ImportShifts.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-10.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ImportShifts {
    
    //class
    let goFetch     = GoFetch()
    let convertDate = ConvertDate()
    
    //App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func importShifts () {
        
        let managedContext = appDelegate.coreDataStack.managedContext
        
        //Games
        let games = goFetch.games(managedContext: managedContext)
        
        //Players
        let players = goFetch.player(managedContext: managedContext)
        
        for game in games {
            
            print(convertDate.convertDateOnly(date: game.date!))
            print("")
            
            for player in players {
                
                print("")
                print(String(describing: player.lastName!))
                
                let numberOfShifts = arc4random_uniform(50) + 1  ////Just so you can't get 0
                
                
                print("Number of Shifts: \(numberOfShifts)")
                print("")
                
                for i in 1...numberOfShifts {
                    
                    let randomTimeOnIce = arc4random_uniform(150) + 1 //Just so you can't get 0
                    let randomPeriod =  arc4random_uniform(4) + 1  ////Just so you can't get 0
                    
                    var period: Period?
                    
                    switch randomPeriod {
                    case 1:
                        period = Period.first
                    case 2:
                        period = Period.second
                    case 3:
                        period = Period.third
                    case 4:
                        period = Period.overtime
                    default:
                         period = Period.first
                    }
                    
                    print("Shift \(i) - \(Int(randomTimeOnIce)) Period \(String(describing: period!))")
                    
                    saveShifts(player: player, game: game, timeOnIce: Int(randomTimeOnIce), period: period!, managedContext: managedContext)
                    
                }
            }
        }
        
    }  //importShifts
    
    
    func saveShifts (player: Players, game: Games, timeOnIce: Int, period: Period, managedContext: NSManagedObjectContext) {
        
        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Shifts", in: managedContext)
            let shifts = Shifts(entity: entity!, insertInto: managedContext)
            
            shifts.gameRelationship = game
            shifts.playersRelationship = player
            shifts.timeOnIce = Int16(timeOnIce)
            shifts.period = period.rawValue
            shifts.date = Date() as NSDate
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }
    }  //saveShifts
    
}  //ImportShifts
