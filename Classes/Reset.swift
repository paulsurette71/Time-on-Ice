//
//  Reset.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-01.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import Foundation
import CoreData

class Reset {
    
    func playersStoredData(managedContext: NSManagedObjectContext){
        
        var fetchAllPlayers = [Players]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        
        do {
            
            fetchAllPlayers = try managedContext.fetch(fetchRequest) as! [Players]
            print(fetchAllPlayers.count)
            
            
            
        } catch let error as NSError {
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        do {
            for player in fetchAllPlayers {
                
                player.onIce = false
                player.onBench = false
                player.runningTimeOnIce = 0
                
                //Save
                try player.managedObjectContext?.save()
            }
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
            
        }  //do
        
    }  //playersStoredData
    
}  //Reset

