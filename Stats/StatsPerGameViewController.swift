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
    let timeFormat  = TimeFormat()
    let calculate   = Calculate()
    
    //passed from StatsInformationViewController
    var selectedPlayer: [String: Any]?
    
    var numberOfGames  = 0
    var gameData       = [[String: AnyObject]]()
    var statsPerPlayer = [[String: AnyObject]]()
    //    var player: Players?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate   = self
        
        // Register tableView cell classes
        let cellNib = UINib(nibName: "StatsAccumulatedTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "StatsAccumulatedCell")
        
        let cellChartNib = UINib(nibName: "StatsChartTableViewCell", bundle: nil)
        tableView.register(cellChartNib, forCellReuseIdentifier: "StatsChartCell")
        
        //StatsOneShiftTableViewCell
        let cellChartOneShiftNib = UINib(nibName: "StatsOneShiftTableViewCell", bundle: nil)
        tableView.register(cellChartOneShiftNib, forCellReuseIdentifier: "StatsOneShiftCell")

        
        
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
            
        }  // if let player
        
    }  //fetchData
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //        let statsDetailsPerGameViewController = segue.destination as! StatsDetailsPerGameViewController
    //
    //        //Get selected Game
    //        let indexPath = tableView.indexPathForSelectedRow
    //
    //        let game = gameData[(indexPath?.row)!]
    //        let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
    //        let selectedGame = managedContext.object(with: gameNSManagedObjectID) as! Games
    //
    //        //Get selected Player
    //        let selectedPlayerNSManagedObjectID = selectedPlayer!["playersRelationship"] as! NSManagedObjectID
    //        let player = managedContext.object(with: selectedPlayerNSManagedObjectID) as? Players
    //
    //        if segue.identifier == "StatsDetailsPerGameSegue" {
    //
    //            statsDetailsPerGameViewController.managedContext = managedContext
    //            statsDetailsPerGameViewController.player = player
    //            statsDetailsPerGameViewController.game = selectedGame
    //
    //        }  // if segue.identifier
    //
    //    }  //prepare(for segue
    
    
}

extension StatsPerGameViewController : UITableViewDelegate {
    
    
}  //UITableViewDelegate

extension StatsPerGameViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard numberOfGames > 0 else {
            return 0
        }
        
        return numberOfGames + 1
        
    }  //numberOfSections
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2 //numberOfGames + 2
        
    }  //numberOfRowsInSection
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatsAccumulatedCell", for: indexPath) as! StatsAccumulatedTableViewCell
                
                configureAccumulatedCell(cell, indexPath: indexPath)
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatsChartCell", for: indexPath) as! StatsChartTableViewCell
                
                configureChartCell(cell, indexPath: indexPath)
                
                return cell
                
            }  //if indexPath.row == 0
            
        } else {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatsAccumulatedCell", for: indexPath) as! StatsAccumulatedTableViewCell
                
                configureStatsCell(cell, indexPath: indexPath)
                
                return cell
                
            } else {
                
                
                //Game Information
                let game = gameData[indexPath.section - 1]
                let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
                let gameDetails = managedContext.object(with: gameNSManagedObjectID) as! Games
                
                //Player Information
                let playerNSManagedObjectID = selectedPlayer!["playersRelationship"] as! NSManagedObjectID
                let player = managedContext.object(with: playerNSManagedObjectID) as? Players
                
                
                let results = goFetch.shiftsPerPlayerPerGame(player: player!, game: gameDetails, managedContext: managedContext)
                
                var timeOnIceValues = [Int]()
                
                for shifts in results {
                    
                    timeOnIceValues += [shifts["timeOnIce"] as! Int]
                    
                }

                guard timeOnIceValues.count > 1 else {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StatsOneShiftCell") as! StatsOneShiftTableViewCell
                    
                    return cell
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatsChartCell", for: indexPath) as! StatsChartTableViewCell
                
                
                configureChartPerGame(cell, data: timeOnIceValues)
                
                return cell
                
            }  //if indexPath.row == 0
            
        }  //if indexPath.section == 0
        
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        //
        //        //Game Information
        //        let game = gameData[indexPath.section - 1]
        //        let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
        //        let gameDetails = managedContext.object(with: gameNSManagedObjectID) as! Games
        //
        //        //Player Information
        //        let playerNSManagedObjectID = selectedPlayer!["playersRelationship"] as! NSManagedObjectID
        //        let player = managedContext.object(with: playerNSManagedObjectID) as? Players
        //
        //        let results = goFetch.shiftsPerPlayerPerGame(player: player!, game: gameDetails, managedContext: managedContext)
        //
        //        print(convertDate.convertDate(date: (gameDetails.date)!))
        //        print(results)
        //
        //        return cell
        
        
    }  //cellForRowAt
    
    func configureStatsCell(_ cell: StatsAccumulatedTableViewCell, indexPath: IndexPath) {
        
        //Game Information
        let game = gameData[indexPath.section - 1]
        let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
        let gameDetails = managedContext.object(with: gameNSManagedObjectID) as! Games
        
        //Player Information
        let playerNSManagedObjectID = selectedPlayer!["playersRelationship"] as! NSManagedObjectID
        let player = managedContext.object(with: playerNSManagedObjectID) as? Players
        
        let results = goFetch.shiftsPerPlayerPerGame(player: player!, game: gameDetails, managedContext: managedContext)
        
        var totalTimeOnIce = 0
        var minMaxArray = [Int]()
        
        for shifts in results {
            
            totalTimeOnIce += shifts["timeOnIce"] as! Int
            minMaxArray += [shifts["timeOnIce"] as! Int]
            
        }
        
        //Total TimeOnIce
        cell.statsTotalTimeOnIceLabel.text = timeFormat.mmSS(totalSeconds: totalTimeOnIce)
        
        //Total Shifts
        cell.statsTotalShiftsLabel.text = String(results.count)
        
        //Average Shift Length
        let averageShift = totalTimeOnIce / results.count
        let avergeShiftLength = timeFormat.mmSS(totalSeconds: averageShift)
        cell.statsAverageShiftLengthLabel.text = avergeShiftLength
        
        //Shortest Shift Length
        let min = minMaxArray.min()
        let shortestShift = timeFormat.mmSS(totalSeconds: min!)
        cell.statsShortestShiftLengthLabel.text = shortestShift
        
        //Longest Shift
        let max = minMaxArray.max()
        let longestShift = timeFormat.mmSS(totalSeconds: max!)
        cell.statsLongestShiftLengthLabel.text = longestShift
        
        
        
    }
    
    
    func configureAccumulatedCell(_ cell: StatsAccumulatedTableViewCell, indexPath: IndexPath) {
        
        //Total TimeOnIce
        let timeOnIce = statsPerPlayer.first!["sumShift"]! as! Int
        let totalTimeOnIce = timeFormat.mmSS(totalSeconds: timeOnIce)
        cell.statsTotalTimeOnIceLabel.text = totalTimeOnIce
        
        //Total Shifts
        let totalShifts = statsPerPlayer.first!["countShift"]! as! Int
        cell.statsTotalShiftsLabel.text =  String(totalShifts)
        
        //Average Shift Length
        let avergeShiftLength = timeFormat.mmSS(totalSeconds: statsPerPlayer.first!["avgShift"]! as! Int)
        cell.statsAverageShiftLengthLabel.text = avergeShiftLength
        
        //Shortest Shift Length
        let shortestShift = timeFormat.mmSS(totalSeconds: statsPerPlayer.first!["minShift"]! as! Int)
        cell.statsShortestShiftLengthLabel.text = shortestShift
        
        //Longest Shift
        let longestShift = timeFormat.mmSS(totalSeconds: statsPerPlayer.first!["maxShift"]! as! Int)
        cell.statsLongestShiftLengthLabel.text = longestShift
        
        //Number of Games
        let numberOfGamesForPlayer = String(numberOfGames)
        cell.statsTotalGamesLabel.text = numberOfGamesForPlayer
        
        //Average Shifts Per Game
        let averageShiftsPerGame = calculate.averageShiftsPerGame(games: numberOfGames, shifts: totalShifts)
        cell.statsAvgShiftsPerGameLabel.text = averageShiftsPerGame
        
        //Average Time on Ice Per Game
        let averageTimeOnIcePerGame = calculate.averageTimeOnIcePerGame(timeOnInce: timeOnIce, games: numberOfGames)
        cell.statsAvgTimeOnIcePerGameLabel.text = timeFormat.mmSS(totalSeconds: averageTimeOnIcePerGame)
        
    }  //configureCell
    
    func configureChartCell(_ cell: StatsChartTableViewCell, indexPath: IndexPath) {
        
        //barChart
        var barChartData: [PointEntry] = []
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            let playerNSManagedObjectID = selectedPlayer!["playersRelationship"] as! NSManagedObjectID
            
            if let player = managedContext.object(with: playerNSManagedObjectID) as? Players {
                
                let timeOnIcePerPlayer = goFetch.statsTimeOnIcePerPlayer(player: player, managedContext: managedContext)
                
                for index in timeOnIcePerPlayer.indices {
                    
                    let timeOnIce = timeOnIcePerPlayer[index].timeOnIce
                    
                    let shiftNumber = String(index + 1)
                    
                    barChartData.append(PointEntry(value: Int(timeOnIce), label: shiftNumber))
                }
                
                //draw barChart
                cell.chartView.isCurved = true
                cell.chartView.dataEntries = barChartData
                
            }  //if let player =
            
        }// if indexPath.section
        
    }  //configureChartCell
    
    func configureChartPerGame(_ cell: StatsChartTableViewCell, data: [Int]) {
        
        //barChart
        var barChartData: [PointEntry] = []
        
        for index in data.indices {
            
            let timeOnIce = data[index]
            
            let shiftNumber = String(index + 1)
            
            barChartData.append(PointEntry(value: Int(timeOnIce), label: shiftNumber))
        }
        

        //draw barChart
        cell.chartView.isCurved = true
        cell.chartView.dataEntries = barChartData
        
    }  //configureChartPerGame
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor            = UIColor.white
        header.textLabel?.font                 = UIFont.systemFont(ofSize: 20, weight: .light)
        header.textLabel?.frame                = header.frame
        header.textLabel?.textAlignment        = .left
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.6352941176, green: 0.5764705882, blue: 0.5254901961, alpha: 1)
        
    }  //willDisplayHeaderView
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard numberOfGames != 0 else {
            return "No Games"
        }
        
        if section == 0 {
            
            return "Overall Stats"
            
        } else {
            
            let game = gameData[section - 1]
            let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
            let gameDetails = managedContext.object(with: gameNSManagedObjectID) as! Games
            
            let currentDate = convertDate.convertDate(date: (gameDetails.date)!)
            
            let sectionHeader = currentDate
            
            return sectionHeader
        }
        
    }  //titleForHeaderInSection
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 240
            
        } else if indexPath.row == 1 {
            
            return 200
            
        } else {
            
            return 44
        }
    }  //heightForRowAt
    
}  //UITableViewDataSource
