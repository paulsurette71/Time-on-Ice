//
//  StatsPerGameViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-02.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData

class StatsPerGameViewController: UIViewController {
    
    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    //UILabel
    @IBOutlet weak var totalTimeOnIceLabel: UILabel!
    @IBOutlet weak var totalShiftsLabel: UILabel!
    @IBOutlet weak var avergeShiftLengthLabel: UILabel!
    @IBOutlet weak var shortestShiftLabel: UILabel!
    @IBOutlet weak var longestShiftLabel: UILabel!
    @IBOutlet weak var gamesLabel: UILabel!
    @IBOutlet weak var averageShiftsPerGameLabel: UILabel!
    @IBOutlet weak var averageTimeOnIcePerGameLabel: UILabel!
    
    //coredata
    var managedContext: NSManagedObjectContext!
    
    //classes
    let goFetch     = GoFetch()
    let convertDate = ConvertDate()
    let timeFormat  = TimeFormat()
    let calculate   = Calculate()
    
    //passed from StatsInformationViewController
    var selectedPlayer: [String: Any]?
    
    var numberOfGames  = 0
    var gameData       = [[String: AnyObject]]()
    var statsPerPlayer = [[String: AnyObject]]()
    var player: Players?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate   = self
        
    }  //viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard (selectedPlayer != nil) else {
            return
        }
        
        fetchData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        
        let playerNSManagedObjectID = selectedPlayer!["playersRelationship"] as! NSManagedObjectID
        
        if let player = managedContext.object(with: playerNSManagedObjectID) as? Players {
            
            self.title = (player.firstName)! + " " + (player.lastName)!
            
            numberOfGames = goFetch.statsGamesPerPlayer(player: player, managedContext: managedContext)
            
            gameData = goFetch.getGamesForPlayer(player: player, managedContext: managedContext)
            
            statsPerPlayer = goFetch.statsPerPlayer(player: player, managedContext: managedContext)
            
            displayStats()
            
        }  // if let player
        
    }  //fetchData
    
    func displayStats() {
        
        let timeOnIce = statsPerPlayer.first!["sumShift"]! as! Int
        let totalTimeOnIce = timeFormat.mmSS(totalSeconds: timeOnIce)
        totalTimeOnIceLabel.text = totalTimeOnIce
        
        let totalShifts = statsPerPlayer.first!["countShift"]! as! Int
        totalShiftsLabel.text = String(totalShifts)
        
        let avergeShiftLength = timeFormat.mmSS(totalSeconds: statsPerPlayer.first!["avgShift"]! as! Int)
        avergeShiftLengthLabel.text = avergeShiftLength
        
        let shortestShift = timeFormat.mmSS(totalSeconds: statsPerPlayer.first!["minShift"]! as! Int)
        shortestShiftLabel.text = shortestShift
        
        let longestShift = timeFormat.mmSS(totalSeconds: statsPerPlayer.first!["maxShift"]! as! Int)
        longestShiftLabel.text = longestShift
        
        let numberOfGamesForPlayer = String(numberOfGames)
        gamesLabel.text = numberOfGamesForPlayer
        
        let averageShiftsPerGame = calculate.averageShiftsPerGame(games: numberOfGames, shifts: totalShifts)
        averageShiftsPerGameLabel.text = averageShiftsPerGame
        
        let averageTimeOnIcePerGame = calculate.averageTimeOnIcePerGame(timeOnInce: timeOnIce, games: numberOfGames)
        averageTimeOnIcePerGameLabel.text = timeFormat.mmSS(totalSeconds: averageTimeOnIcePerGame)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        let statsDetailsPerGameTableViewController = segue.destination as! StatsDetailsPerGameTableViewController
        let statsDetailsPerGameViewController = segue.destination as! StatsDetailsPerGameViewController
        
        
        //Get selected Game
        //let indexPath = sender as! IndexPath
        let indexPath = tableView.indexPathForSelectedRow
        
        let game = gameData[(indexPath?.row)!]
        let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
        let selectedGame = managedContext.object(with: gameNSManagedObjectID) as! Games
        
        
        //Get selected Player
        let selectedPlayerNSManagedObjectID = selectedPlayer!["playersRelationship"] as! NSManagedObjectID
        let player = managedContext.object(with: selectedPlayerNSManagedObjectID) as? Players
        
        if segue.identifier == "StatsDetailsPerGameSegue" {
            
            statsDetailsPerGameViewController.managedContext = managedContext
            statsDetailsPerGameViewController.player = player
            statsDetailsPerGameViewController.game = selectedGame
            
        }  // if segue.identifier
        
    }  //prepare(for segue
    
    
}

extension StatsPerGameViewController : UITableViewDelegate {
    
    
}  //UITableViewDelegate

extension StatsPerGameViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }  //numberOfSections
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfGames
        
    }  //numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let game = gameData[indexPath.row]
        
        configureCell(cell, withGame: game, indexPath: indexPath)
        
        return cell
        
    }  //cellForRowAt
    
    func configureCell(_ cell: UITableViewCell, withGame game: [String: AnyObject], indexPath: IndexPath) {
        
        let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
        let gameDetails = managedContext.object(with: gameNSManagedObjectID) as! Games
        
        let currentDate = convertDate.convertDate(date: (gameDetails.date)!)
        
        cell.textLabel?.text = currentDate
        
        
    }  //configureCell
    
    
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
        
        guard numberOfGames != 0 else {
            return "No Games"
        }
        
        let numberOfGamesForPlayer = String(numberOfGames) + " Games"
        
        return numberOfGamesForPlayer
        
    }  //titleForHeaderInSection
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "StatsDetailsPerGameSegue", sender: nil)
        
    } //didSelectRowAt
    
}  //UITableViewDataSource
