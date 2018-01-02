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
    
    //coredata
    var managedContext: NSManagedObjectContext!
    
    //classes
    let goFetch     = GoFetch()
    let convertDate = ConvertDate()
    
    //passed from StatsInformationViewController
    var selectedPlayer: [String: Any]?
    
    var numberOfGames = 0
    var gameData = [[String: AnyObject]]()
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
            
            
            let statsPerPlayer = goFetch.statsPerPlayer(player: player, managedContext: managedContext)
            print(statsPerPlayer)
            
        }  // if let player
        
    }  //fetchData
    
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
    
    
}  //UITableViewDataSource
