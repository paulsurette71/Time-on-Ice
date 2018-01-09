////
////  StatsInformationViewController.swift
////  Time on Ice
////
////  Created by Surette, Paul on 2017-12-25.
////  Copyright © 2017 Surette, Paul. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//class StatsInformationViewController: UIViewController {
//    
//    //coredata
//    var managedContext: NSManagedObjectContext!
//    var fetchedResultsController: NSFetchedResultsController<Shifts>!
//    
//    lazy var fetchedResultsControllerAllPlayers: NSFetchedResultsController<Players> = {
//        
//        let fetchRequest: NSFetchRequest<Players> = Players.fetchRequest()
//        let sort = NSSortDescriptor(key: #keyPath(Players.lastName), ascending: true)
//        fetchRequest.sortDescriptors = [sort]
//        
////        let predicate               = NSPredicate(format: "%K > 0", #keyPath(Shifts.timeOnIce))
////        fetchRequest.predicate      = predicate
//        
////        fetchRequest.propertiesToFetch = [#keyPath(Shifts.playersRelationship)]
//        
//        let fetchedResultsControllerAllPlayers = NSFetchedResultsController( fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
//        
//        fetchedResultsControllerAllPlayers.delegate = self
//        
//        return fetchedResultsControllerAllPlayers
//    }()
//    
//    //UITableView
//    @IBOutlet weak var tableView: UITableView!
//    
//    //classes
//    let goFetch    = GoFetch()
//    let timeFormat = TimeFormat()
//    let createAttributedString = CreateAttributedString()
//    
//    var playerStatsArray = [[String: Any]]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        self.title = "Stats"
//        
//        // Register tableView cell classes
//        let cellNib = UINib(nibName: "StatsInformationTableViewCell", bundle: nil)
//        tableView.register(cellNib, forCellReuseIdentifier: "statsInformationTableViewCell")
//        tableView.rowHeight = 220
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        playerStatsArray = goFetch.statsPerAllPlayers(managedContext: managedContext)
//        
//        //Go get the players on the bench
//        //        goFetch.fetchPlayersOnIceOrBench(managedContext: managedContext, fetchedResultsController: fetchedResultsControllerAllPlayers)
//        
//        //Go get the players on the ice
//        
//        do {
//            try fetchedResultsControllerAllPlayers.performFetch()
//        } catch let error as NSError {
//            print("\(self) -> \(#function) \(error), \(error.userInfo)")
//        }
//        
//        
// 
//        
////        print("fetched objects: \(fetchedResultsControllerAllPlayersWithShifts.fetchedObjects!.count)")
////        
////        for players in fetchedResultsControllerAllPlayersWithShifts.fetchedObjects! {
////
////            print(players.lastName!)
////            
//////            for time in players.playersRelationship {
//////                
//////                print((time as! Shifts).timeOnIce)
//////            }
////
////        }
////
////        guard playerStatsArray.count > 0 else {
////            return
////        }
////
////        tableView.reloadData()
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        let statsPerGameViewController = segue.destination as! StatsPerGameViewController
//        
//        let indexPath = sender as! IndexPath
//        
////        let selectedPlayer = playerStatsArray[indexPath.row]
//        
//        let selectedPlayer = fetchedResultsControllerAllPlayers.object(at: indexPath)
//        
//        if segue.identifier == "StatsPerGameSegue" {
//            
//            statsPerGameViewController.managedContext = managedContext
//          statsPerGameViewController.selectedPlayer = selectedPlayer
//            
//        }  // if segue.identifier
//        
//    }  //prepare(for segue
//    
//}
//
//extension StatsInformationViewController : UITableViewDelegate {
//    
//    
//}
//
//extension StatsInformationViewController : UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        
//        //        if let sections = fetchedResultsController.sections {
//        //            return sections.count
//        //        }
//        //        return 0
//        
//        
////        return 1
//        
//        guard let sections = fetchedResultsControllerAllPlayers.sections else {
//            
//            return 0
//            
//        }
//        
//        return sections.count
//        
//        
//    }  //numberOfSections
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        //        guard let sectionInfo = fetchedResultsController.sections?[section] else {
//        //            return 0
//        //
//        //        }
//        //
//        //        return sectionInfo.numberOfObjects
//        
//        
////        guard playerStatsArray.count > 0 else {
////            return 0
////        }
////
////        return playerStatsArray.count
//        
//        guard let sectionInfo = fetchedResultsControllerAllPlayers.sections?[section] else {
//            
//            return 0
//            
//        }
//        
//        return sectionInfo.numberOfObjects
//
//        
//    }  //numberOfRowsInSection
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "statsInformationTableViewCell", for: indexPath) as! StatsInformationTableViewCell
//        
//        cell.selectionStyle = .none
//        
////        let player = playerStatsArray[indexPath.row]
//        
//        let player = fetchedResultsControllerAllPlayers.object(at: indexPath)
//        
////        configureCell(cell, withPlayer: player, indexPath: indexPath)
//        
//        configureCell(cell: cell, player: player, indexPath: indexPath)
//        
//        
//        return cell
//        
//    }  //cellForRowAt
//    
//    
//    func configureCell(cell: StatsInformationTableViewCell, player: Players, indexPath: IndexPath) {
//        
//        
////        if let playerInformation = player.playersShiftRelationship {
//        
//            //Player Information
//            let playerNumber = player.number
//            let playerInformationAttributedString = createAttributedString.poundNumberFirstNameLastName(number: String(describing: playerNumber), firstName: player.firstName!, lastName: player.lastName!)
//            
//            cell.statsPlayerInformationLabel.attributedText = playerInformationAttributedString
//            
//            //Team Information
//            cell.statsTeamInformationLabel.text = player.city! + " " + player.team!
//            
////            #keyPath(Players.playersShiftRelationship.gameRelationship)
////            var gamesArray = [Games]()
////            if let games = player.playersShiftRelationship.reg {
////
////               gamesArray += [games]
////            }
////
////            print("number of Games: \(gamesArray.count)")
//            
////        }
//        
//        
//    }
//    
////    func configureCell(_ cell: StatsInformationTableViewCell, withPlayer player: [String: Any], indexPath: IndexPath) {
////
////        guard player["playersRelationship"] as? NSManagedObjectID != nil else {
////            return
////        }
////
////        let totalTimeOnIce = timeFormat.mmSS(totalSeconds: player["sumShift"]! as! Int)
////        cell.totalTimeOnIceLabel.text = totalTimeOnIce
////
////        let shifts = player["countShift"]!
////        cell.totalShiftsLabel.text = String(describing: shifts)
////
////        let playerObjID   = player["playersRelationship"] as! NSManagedObjectID
////        let playerDetails = managedContext.object(with: playerObjID) as! Players
////
////        let playerInformation = createAttributedString.poundNumberFirstNameLastName(number: String(playerDetails.number), firstName: playerDetails.firstName!, lastName: playerDetails.lastName!)
////
////        //Player Details.
////        cell.statsPlayerInformationLabel.attributedText = playerInformation
////        cell.statsTeamInformationLabel.text = playerDetails.city! + " " + playerDetails.team!
////
////        //Games
////        let numberOfGames = goFetch.statsGamesPerPlayer(player: playerDetails, managedContext: managedContext)
////        cell.totalGamesLabel.text = String(numberOfGames)
////
////        //Average Shift Length
////        let averageTimeOnice = timeFormat.mmSS(totalSeconds: player["avgShift"]! as! Int)
////        cell.averageTimeOnIceLabel.text = averageTimeOnice
////
////        //Shortest Shift
////        let shortestShift = timeFormat.mmSS(totalSeconds: player["minShift"]! as! Int)
////        cell.shortestShiftLabel.text = shortestShift
////
////        //Longest Shift
////        let longestShift = timeFormat.mmSS(totalSeconds: player["maxShift"]! as! Int)
////        cell.longestShiftLabel.text = longestShift
////
////
////        //Average Shifts per Game
////        let averageShifts = averageShiftsPerGame(games: numberOfGames, shifts: shifts as! Int)
////        cell.averageShiftsPerGameLabel.text = averageShifts
////
////    }  //configureCell
//    
//    func averageTimeOnIce(player: Players, timeOnIce: Int, shifts: Int) -> String {
//        var returnValue = ""
//        
//        if shifts > 0 {
//            
//            let average = timeOnIce / shifts
//            
//            returnValue = timeFormat.mmSS(totalSeconds: average)
//            
//        } else {
//            
//            returnValue = ""
//        }
//        
//        return returnValue
//        
//    }  //averageTimeOnIce
//    
//    func averageShiftsPerGame(games: Int, shifts:Int) -> String {
//        var returnValue = ""
//        
//        if shifts > 0 {
//            
//            let average =  Double(shifts) / Double(games)
//            
//            //check for remainder for proper formatting.
//            if shifts % games == 0 {
//                returnValue = String(format: "%.0f", average)  //no decimal places
//            } else {
//                returnValue = String(format: "%.2f", average)  //two decimal places
//            }
//            
//        } else {
//            
//            returnValue = ""
//        }
//        
//        return returnValue
//        
//    }  //averageShiftsPerGame
//    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        
//        guard let header = view as? UITableViewHeaderFooterView else {
//            return
//        }
//        
//        header.textLabel?.textColor     = UIColor.black
//        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .light)
//        header.textLabel?.frame         = header.frame
//        header.textLabel?.textAlignment = .left
//        //        header.backgroundView?.backgroundColor = UIColor(named: "gryphonGold")
//        
//    }  //willDisplayHeaderView
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        guard playerStatsArray.count > 0 else {
//            
//            return "No Players with Stats"
//        }
//        
//        return String(playerStatsArray.count) + " Players"
//        
//    }  //titleForHeaderInSection
//    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        performSegue(withIdentifier: "StatsPerGameSegue", sender: indexPath)
//        
//    } //didSelectRowAt
//    
//}
//
//extension StatsInformationViewController: NSFetchedResultsControllerDelegate {
//    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        
//        switch type {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .automatic)
//        case .update:
//            print("StatsInformationViewController Update")
//            tableView?.reloadData()
//        case .move:
//            tableView.deleteRows(at: [indexPath!], with: .automatic)
//            tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        }
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        
//        let indexSet = IndexSet(integer: sectionIndex)
//        switch type {
//        case .insert:
//            tableView.insertSections(indexSet, with: .automatic)
//        case .delete:
//            tableView.deleteSections(indexSet, with: .automatic)
//        default: break
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//
//    }
//    
//} //extension
//
