//
//  GoFetch.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-03.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation
import CoreData

class GoFetch {
    
    func teamNames(managedContext: NSManagedObjectContext) -> [String] {
        //print("\(self) -> \(#function)")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        var teamNameArray = [String]()
        
        fetchRequest.fetchBatchSize = 8
        fetchRequest.propertiesToGroupBy = [#keyPath(Players.team)]
        fetchRequest.propertiesToFetch   = [#keyPath(Players.team)]
        fetchRequest.resultType          = .dictionaryResultType
        
        do {
            
            let fetchTeamNamesArray = try managedContext.fetch(fetchRequest) as! [[String: String]]
            
            teamNameArray = fetchTeamNamesArray.map { $0["team"]! }
            
        } catch let error as NSError {
            
            print("GoFetch|teamNames: Could not fetch. \(error), \(error.userInfo)")
        }
        
        return teamNameArray
    }
    
    func city(managedContext: NSManagedObjectContext) -> [String] {
        //print("\(self) -> \(#function)")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        var cityArray = [String]()
        
        fetchRequest.fetchBatchSize = 8
        fetchRequest.propertiesToGroupBy = [#keyPath(Players.city)]
        fetchRequest.propertiesToFetch   = [#keyPath(Players.city)]
        fetchRequest.resultType          = .dictionaryResultType
        
        do {
            
            let fetchCityArray = try managedContext.fetch(fetchRequest) as! [[String: String]]
            
            cityArray = fetchCityArray.map { $0["city"]! }
            
        } catch let error as NSError {
            
            print("GoFetch|city: Could not fetch. \(error), \(error.userInfo)")
        }
        
        return cityArray
    }
    
    func league(managedContext: NSManagedObjectContext) -> [String] {
        //print("\(self) -> \(#function)")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        var leagueArray = [String]()
        
        fetchRequest.fetchBatchSize = 8
        fetchRequest.propertiesToGroupBy = [#keyPath(Players.league)]
        fetchRequest.propertiesToFetch   = [#keyPath(Players.league)]
        fetchRequest.resultType          = .dictionaryResultType
        
        do {
            
            let fetchLeagueArray = try managedContext.fetch(fetchRequest) as! [[String: String]]
            
            leagueArray = fetchLeagueArray.map { $0["league"]! }
            
        } catch let error as NSError {
            
            print("GoFetch|league: Could not fetch. \(error), \(error.userInfo)")
        }
        
        return leagueArray
    }
    
    func level(managedContext: NSManagedObjectContext) -> [String] {
        //print("\(self) -> \(#function)")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        var levelArray = [String]()
        
        fetchRequest.fetchBatchSize = 8
        fetchRequest.propertiesToGroupBy = [#keyPath(Players.level)]
        fetchRequest.propertiesToFetch   = [#keyPath(Players.level)]
        fetchRequest.resultType          = .dictionaryResultType
        
        do {
            
            let fetchLevelArray = try managedContext.fetch(fetchRequest) as! [[String: String]]
            
            levelArray = fetchLevelArray.map { $0["level"]! }
            
        } catch let error as NSError {
            
            print("GoFetch|level: Could not fetch. \(error), \(error.userInfo)")
        }
        
        return levelArray
    }
    
    func division(managedContext: NSManagedObjectContext) -> [String] {
        //print("\(self) -> \(#function)")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        var divisionArray = [String]()
        
        fetchRequest.fetchBatchSize = 8
        fetchRequest.propertiesToGroupBy = [#keyPath(Players.division)]
        fetchRequest.propertiesToFetch   = [#keyPath(Players.division)]
        fetchRequest.resultType          = .dictionaryResultType
        
        do {
            
            let fetchDivisionArray = try managedContext.fetch(fetchRequest) as! [[String: String]]
            
            divisionArray = fetchDivisionArray.map { $0["division"]! }
            
        } catch let error as NSError {
            
            print("GoFetch|level: Could not fetch. \(error), \(error.userInfo)")
        }
        
        return divisionArray
    }
    
    func player(managedContext: NSManagedObjectContext) -> [Players] {
        //print("\(self) -> \(#function)")
        
        var fetchPlayerArray = [Players]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        
        let sort = NSSortDescriptor(key: #keyPath(Players.lastName), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchBatchSize = 8
        
        do {
            
            fetchPlayerArray = try managedContext.fetch(fetchRequest) as! [Players]
            
        } catch let error as NSError {
            
            print("GoFetch|player: Could not fetch. \(error), \(error.userInfo)")
        }
        
       return fetchPlayerArray
    }
    
    
}



