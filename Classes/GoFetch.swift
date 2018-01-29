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
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return teamNameArray
    }  //teamNames
    
    func city(managedContext: NSManagedObjectContext) -> [String] {
        
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
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return cityArray
    }  //city
    
    func league(managedContext: NSManagedObjectContext) -> [String] {
        
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
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return leagueArray
    }  //league
    
    func level(managedContext: NSManagedObjectContext) -> [String] {
        
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
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return levelArray
    }  //level
    
    func division(managedContext: NSManagedObjectContext) -> [String] {
        
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
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return divisionArray
    }  //division
    
    func player(managedContext: NSManagedObjectContext) -> [Players] {
        
        var fetchPlayerArray = [Players]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        
        let sort = NSSortDescriptor(key: #keyPath(Players.lastName), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchBatchSize = 8
        
        do {
            
            fetchPlayerArray = try managedContext.fetch(fetchRequest) as! [Players]
            
        } catch let error as NSError {
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return fetchPlayerArray
    }  //player
    
    func timeOnIceWithShifts(player: Players, game: Games, managedContext: NSManagedObjectContext) -> [String:Int] {
        
        var resultsDictionary = [String: Int]()
        
        let fetchRequest       = NSFetchRequest<NSFetchRequestResult>(entityName: "Shifts")
        let predicatePlayer    = NSPredicate(format: "playersRelationship = %@", player)
        let predicateGame      = NSPredicate(format: "gameRelationship = %@", game)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicatePlayer,predicateGame])
        
        let nsExpressionForKeyPath  = NSExpression(forKeyPath: "timeOnIce")
        
        let nsExpressionForFunction = NSExpression(forFunction: "count:", arguments: [nsExpressionForKeyPath])
        let nsExpressionDescriptionCount = NSExpressionDescription()
        nsExpressionDescriptionCount.expression = nsExpressionForFunction
        nsExpressionDescriptionCount.name = "shifts"
        nsExpressionDescriptionCount.expressionResultType = .integer16AttributeType
        
        let nsExpressionForFunctionSum = NSExpression(forFunction: "sum:", arguments: [nsExpressionForKeyPath])
        let nsExpressionDescriptionSum = NSExpressionDescription()
        nsExpressionDescriptionSum.expression = nsExpressionForFunctionSum
        nsExpressionDescriptionSum.name = "timeOnIce"
        nsExpressionDescriptionSum.expressionResultType = .integer16AttributeType
        
        fetchRequest.propertiesToFetch   = [nsExpressionDescriptionCount, nsExpressionDescriptionSum]
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            
            let fetchArray    = try managedContext.fetch(fetchRequest) as! [[String:Int]]
            
            guard fetchArray.count != 0 else {
                return resultsDictionary
            }
            
            resultsDictionary = fetchArray.first!  //crash
            
        } catch let error as NSError {
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return resultsDictionary
    }  //timeOnIceWithShifts
    
    func games(managedContext: NSManagedObjectContext) -> [Games] {
        
        var fetchGamesArray = [Games]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Games")
        
        let sort = NSSortDescriptor(key: #keyPath(Games.date), ascending: false)  //Jan 29
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchBatchSize = 8
        
        do {
            
            fetchGamesArray = try managedContext.fetch(fetchRequest) as! [Games]
            
        } catch let error as NSError {
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return fetchGamesArray
        
    }  //games
    
    func fetchPlayersOnIceOrBench(managedContext: NSManagedObjectContext, fetchedResultsController: NSFetchedResultsController<Players>) {
        
        //Go get the players on the ice
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("\(self) -> \(#function) \(error), \(error.userInfo)")
        }
        
    }  //fetchPlayersOnIce
    
    func playersOnIce(managedContext: NSManagedObjectContext) -> [Players] {
        
        var playerOnIce = [Players]()
        
        let fetchRequest: NSFetchRequest<Players> = Players.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Players.number), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let predicate               = NSPredicate(format: "%K = true", #keyPath(Players.onIce))
        fetchRequest.predicate      = predicate
        
        do {
            
            playerOnIce = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return playerOnIce
        
    }  //playersOnIce
    

    func statsGamesPerPlayer(player: Players, managedContext: NSManagedObjectContext) -> Int {
        
        var numberOfGames = 0
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shifts")
        let predicate               = NSPredicate(format: "playersRelationship = %@", player)
        fetchRequest.predicate      = predicate
        
        fetchRequest.fetchBatchSize = 8
        fetchRequest.propertiesToGroupBy = [#keyPath(Shifts.gameRelationship)]
        fetchRequest.propertiesToFetch   = [#keyPath(Shifts.gameRelationship)]
        fetchRequest.resultType          = .dictionaryResultType
        
        do {
            
            let fetchGamesPerPlayer = try managedContext.fetch(fetchRequest)
            
            guard fetchGamesPerPlayer.count > 0 else {
                
                return 0
            }
            numberOfGames = fetchGamesPerPlayer.count
            
        } catch let error as NSError {
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return numberOfGames
    }  //statsGamesPerPlayer
    
    func getGamesForPlayer(player: Players, managedContext: NSManagedObjectContext) ->  [[String : AnyObject]] {
        
        //select ZGAMERELATIONSHIP from ZSHIFTS where ZPLAYERSRELATIONSHIP = 5 group by ZGAMERELATIONSHIP;
        
        var fetchGamesPerPlayer = [[String: AnyObject]]()
        
        let fetchRequest       = NSFetchRequest<NSFetchRequestResult>(entityName: "Shifts")
        let predicate          = NSPredicate(format: "playersRelationship = %@", player)
        
        let sortByDate = NSSortDescriptor(key: #keyPath(Shifts.date), ascending: false)  //Jan 29
        fetchRequest.sortDescriptors = [sortByDate]  //Jan 29
        
        fetchRequest.predicate = predicate
        
        fetchRequest.propertiesToGroupBy = [#keyPath(Shifts.gameRelationship)]
        fetchRequest.propertiesToFetch   = [#keyPath(Shifts.gameRelationship)]
        fetchRequest.resultType          = .dictionaryResultType
        
        do {
            
            fetchGamesPerPlayer = try managedContext.fetch(fetchRequest) as! [[String : AnyObject]]
            
        } catch let error as NSError {
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return fetchGamesPerPlayer
        
    }  //getGamesForPlayer
    
     func shiftsPerPlayerPerGame(player: Players, game: Games, managedContext: NSManagedObjectContext) -> [[String: Any]] {
        
        var resultsDictionary = [[String: Any]]()
        
        let fetchRequest       = NSFetchRequest<NSFetchRequestResult>(entityName: "Shifts")
        let predicatePlayer    = NSPredicate(format: "playersRelationship = %@", player)
        let predicateGame      = NSPredicate(format: "gameRelationship = %@", game)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicatePlayer,predicateGame])
        
        let sortByPeriod = NSSortDescriptor(key: #keyPath(Shifts.period), ascending: true)
        let sortByDate = NSSortDescriptor(key: #keyPath(Shifts.date), ascending: true)
        fetchRequest.sortDescriptors = [sortByPeriod, sortByDate]
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            resultsDictionary    = try managedContext.fetch(fetchRequest) as! [[String : Any]]
            
        } catch let error as NSError {
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return resultsDictionary
    }  //timeOnIceWithShifts
    
    func statsTimeOnIcePerPlayer(player: Players, managedContext: NSManagedObjectContext) -> [Shifts] {
        
        var timeOnIcePerPlayer = [Shifts]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shifts")
        let predicate               = NSPredicate(format: "playersRelationship = %@", player)
        fetchRequest.predicate      = predicate
        
        fetchRequest.propertiesToFetch   = [#keyPath(Shifts.timeOnIce)]
        
        do {
            
            timeOnIcePerPlayer = try managedContext.fetch(fetchRequest) as! [Shifts]
            
            
        } catch let error as NSError {
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return timeOnIcePerPlayer
        
    }  //statsTimeOnIcePerPlayer
    
    func statsShiftsPerPlayerPerPeriod(player: Players, managedContext: NSManagedObjectContext, period: Period) -> Int {
        
        var numberOfPeriods = 0
        
        let fetchRequest       = NSFetchRequest<NSFetchRequestResult>(entityName: "Shifts")
        let predicatePlayer    = NSPredicate(format: "playersRelationship = %@", player)
        let predicatePeriod    = NSPredicate(format: "%K = %@", #keyPath(Shifts.period), period.rawValue)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicatePlayer, predicatePeriod])
        
        let nsExpressionForKeyPath  = NSExpression(forKeyPath: #keyPath(Shifts.period))
        
        let nsExpressionForFunction = NSExpression(forFunction: "count:", arguments: [nsExpressionForKeyPath])
        
        let nsExpressionDescriptionCount = NSExpressionDescription()
        nsExpressionDescriptionCount.expression = nsExpressionForFunction
        
        fetchRequest.propertiesToFetch   = [nsExpressionDescriptionCount]
        fetchRequest.resultType = .countResultType
        
        do {
            
            let shiftsPerPeriod = try managedContext.fetch(fetchRequest)
            
            guard shiftsPerPeriod.count > 0 else {
                return 0
            }
            
            numberOfPeriods = shiftsPerPeriod.first as! Int
            
        } catch let error as NSError {
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return numberOfPeriods
        
    }  //statsShiftsPerPlayerPerPeriod
    
    func statsShiftsPerPlayerPerPeriodPerGame(player: Players, game: Games, managedContext: NSManagedObjectContext, period: Period) -> Int {
        
        var numberOfPeriods = 0
        
        let fetchRequest       = NSFetchRequest<NSFetchRequestResult>(entityName: "Shifts")
        let predicatePlayer    = NSPredicate(format: "playersRelationship = %@", player)
        let predicatePeriod    = NSPredicate(format: "%K = %@", #keyPath(Shifts.period), period.rawValue)
        let predicateGame      = NSPredicate(format: "gameRelationship = %@", game)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicatePlayer, predicatePeriod, predicateGame])
        
        let nsExpressionForKeyPath  = NSExpression(forKeyPath: #keyPath(Shifts.period))
        
        let nsExpressionForFunction = NSExpression(forFunction: "count:", arguments: [nsExpressionForKeyPath])
        
        let nsExpressionDescriptionCount = NSExpressionDescription()
        nsExpressionDescriptionCount.expression = nsExpressionForFunction
        
        fetchRequest.propertiesToFetch   = [nsExpressionDescriptionCount]
        fetchRequest.resultType = .countResultType
        
        do {
            
            let shiftsPerPeriod = try managedContext.fetch(fetchRequest)
 
            guard shiftsPerPeriod.count > 0 else {
                return 0
            }
            
            numberOfPeriods = shiftsPerPeriod.first as! Int
            
        } catch let error as NSError {
            
            print("\(self) -> \(#function): Could not fetch. \(error), \(error.userInfo)")
        }
        
        return numberOfPeriods
        
    }  //statsShiftsPerPlayerPerPeriodPerGame
    
    
}



