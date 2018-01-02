//
//  StatsInformationViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-25.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData

class StatsInformationViewController: UIViewController {
    
    //coredata
    var managedContext: NSManagedObjectContext!
    
    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    //classes
    let goFetch    = GoFetch()
    let timeFormat = TimeFormat()
    let createAttributedString = CreateAttributedString()
    
    var playerStatsArray = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Stats"
        
        // Register tableView cell classes
        let cellNib = UINib(nibName: "StatsInformationTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "statsInformationTableViewCell")
        tableView.rowHeight = 220
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        playerStatsArray = goFetch.statsPerAllPlayers(managedContext: managedContext)
        
        guard playerStatsArray.count > 0 else {
            return
        }
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let statsPerGameViewController = segue.destination as! StatsPerGameViewController
        
        let indexPath = sender as! IndexPath
        
        let selectedPlayer = playerStatsArray[indexPath.row]
        
        if segue.identifier == "StatsPerGameSegue" {
            
            statsPerGameViewController.managedContext = managedContext
            statsPerGameViewController.selectedPlayer = selectedPlayer
            
        }  // if segue.identifier
        
    }  //prepare(for segue
    
}

extension StatsInformationViewController : UITableViewDelegate {
    
    
}

extension StatsInformationViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }  //numberOfSections
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard playerStatsArray.count > 0 else {
            return 0
        }
        
        return playerStatsArray.count
        
    }  //numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "statsInformationTableViewCell", for: indexPath) as! StatsInformationTableViewCell
        
        cell.selectionStyle = .none
        
        let player = playerStatsArray[indexPath.row]
        
        configureCell(cell, withPlayer: player, indexPath: indexPath)
        
        return cell
        
    }  //cellForRowAt
    
    func configureCell(_ cell: StatsInformationTableViewCell, withPlayer player: [String: Any], indexPath: IndexPath) {
        
        guard player["playersRelationship"] as? NSManagedObjectID != nil else {
            return
        }
        
        let totalTimeOnIce = timeFormat.mmSS(totalSeconds: player["sumShift"]! as! Int)
        cell.totalTimeOnIceLabel.text = totalTimeOnIce
        
        let shifts = player["countShift"]!
        cell.totalShiftsLabel.text = String(describing: shifts)
        
        let playerObjID   = player["playersRelationship"] as! NSManagedObjectID
        let playerDetails = managedContext.object(with: playerObjID) as! Players
        
        let playerInformation = createAttributedString.poundNumberFirstNameLastName(number: String(playerDetails.number), firstName: playerDetails.firstName!, lastName: playerDetails.lastName!)
        
        //Player Details.
        cell.statsPlayerInformationLabel.attributedText = playerInformation
        cell.statsTeamInformationLabel.text = playerDetails.city! + " " + playerDetails.team!
        
        //Games
        let numberOfGames = goFetch.statsGamesPerPlayer(player: playerDetails, managedContext: managedContext)
        cell.totalGamesLabel.text = String(numberOfGames)
        
        //Average Shift Length
        let averageTimeOnice = timeFormat.mmSS(totalSeconds: player["avgShift"]! as! Int)
        cell.averageTimeOnIceLabel.text = averageTimeOnice
        
        //Shortest Shift
        let shortestShift = timeFormat.mmSS(totalSeconds: player["minShift"]! as! Int)
        cell.shortestShiftLabel.text = shortestShift
        
        //Longest Shift
        let longestShift = timeFormat.mmSS(totalSeconds: player["maxShift"]! as! Int)
        cell.longestShiftLabel.text = longestShift
        
        
        //Average Shifts per Game
        let averageShifts = averageShiftsPerGame(games: numberOfGames, shifts: shifts as! Int)
        cell.averageShiftsPerGameLabel.text = averageShifts
        
    }  //configureCell
    
    func averageTimeOnIce(player: Players, timeOnIce: Int, shifts: Int) -> String {
        var returnValue = ""
        
        if shifts > 0 {
            
            let average = timeOnIce / shifts
            
            returnValue = timeFormat.mmSS(totalSeconds: average)
            
        } else {
            
            returnValue = ""
        }
        
        return returnValue
        
    }  //averageTimeOnIce
    
    func averageShiftsPerGame(games: Int, shifts:Int) -> String {
        var returnValue = ""
        
        if shifts > 0 {
            
            let average = Double(shifts) / Double(games)
            
            returnValue = String(average)
            
        } else {
            returnValue = ""
        }
        
        return returnValue
        
    }  //averageShiftsPerGame
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor     = UIColor.black
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .light)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        header.backgroundView?.backgroundColor = UIColor(named: "gryphonGold")
        
    }  //willDisplayHeaderView
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard playerStatsArray.count > 0 else {
            
            return "No Players with Stats"
        }
        
        return String(playerStatsArray.count) + " Players"
        
    }  //titleForHeaderInSection
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "StatsPerGameSegue", sender: indexPath)
        
    } //didSelectRowAt
    
}
