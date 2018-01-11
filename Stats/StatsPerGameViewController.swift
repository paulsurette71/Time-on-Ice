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
    var fetchedResultsController: NSFetchedResultsController<Shifts>!
    
    lazy var fetchedResultsControllerShiftPerPlayer: NSFetchedResultsController<Shifts> = {
        
        let fetchRequest: NSFetchRequest<Shifts> = Shifts.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Shifts.date), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let predicate               = NSPredicate(format: "playersRelationship = %@", selectedPlayer!)
        fetchRequest.predicate      = predicate
        
        let fetchedResultsControllerShiftPerPlayer = NSFetchedResultsController( fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsControllerShiftPerPlayer.delegate = self
        
        return fetchedResultsControllerShiftPerPlayer
    }()
    
    
    //classes
    let goFetch     = GoFetch()
    let convertDate = ConvertDate()
    let timeFormat  = TimeFormat()
    let calculate   = Calculate()
    
    //passed from StatsInformationViewController
    var selectedPlayer: Players?
    
    var numberOfGames  = 0
    var gameData       = [[String: AnyObject]]()
    var statsPerPlayer = [[String: AnyObject]]()
    var listOfShifts = [Int]()
    
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
        
        //StatsOneShiftTableViewCell
        let cellChartPerGame = UINib(nibName: "StatsAccumaltedPerGameTableViewCell", bundle: nil)
        tableView.register(cellChartPerGame, forCellReuseIdentifier: "StatsAccumaltedPerGameCell")
        
        //StatsOneShiftTableViewCell
        let cellShifts = UINib(nibName: "ShiftDetailsTableViewCell", bundle: nil)
        tableView.register(cellShifts, forCellReuseIdentifier: "ShiftDetailsCell")
        
    }  //viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            try fetchedResultsControllerShiftPerPlayer.performFetch()
        } catch let error as NSError {
            print("\(self) -> \(#function) \(error), \(error.userInfo)")
        }
        
        for shifts in fetchedResultsControllerShiftPerPlayer.fetchedObjects! {
            
            listOfShifts += [Int(shifts.timeOnIce)]
        }
        
        guard listOfShifts.count > 1 else {
            
            navigationController?.popToRootViewController(animated: true)
            return
        }
        
        fetchData(player: selectedPlayer!)
        
        //Period
        let period = goFetch.statsShiftsPerPlayerPerPeriod(player: selectedPlayer!, managedContext: managedContext, period: 1)
        print("number of shifts 1t period \(period)")
        
        
    }  //viewWillAppear
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData(player: Players) {
        
        //        guard player.firstName != nil, player.lastName != nil else {
        //
        //            navigationController?.popToRootViewController(animated: true)
        //            return
        //        }
        
        self.title = (player.firstName)! + " " + (player.lastName)!
        
        numberOfGames = goFetch.statsGamesPerPlayer(player: player, managedContext: managedContext)
        
        gameData = goFetch.getGamesForPlayer(player: player, managedContext: managedContext)
        
        
    }  //fetchData
    
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
        
        if section == 0 {
            
            return 2
            
        } else {
            
            let game = gameData[section - 1]
            let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
            let gameDetails = managedContext.object(with: gameNSManagedObjectID) as! Games
            
            let results = goFetch.shiftsPerPlayerPerGame(player: selectedPlayer!, game: gameDetails, managedContext: managedContext)
            
            return results.count + 2
        }
        
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
            
            //Game Information
            let game = gameData[indexPath.section - 1]
            let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
            let gameDetails = managedContext.object(with: gameNSManagedObjectID) as! Games
            
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatsAccumaltedPerGameCell", for: indexPath) as! StatsAccumaltedPerGameTableViewCell   //Try this one
                
                configureStatsCell(cell, indexPath: indexPath)
                
                return cell
                
            } else if indexPath.row == 1 {
                
                //                //Game Information
                //                let game = gameData[indexPath.section - 1]
                //                let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
                //                let gameDetails = managedContext.object(with: gameNSManagedObjectID) as! Games
                
                let results = goFetch.shiftsPerPlayerPerGame(player: selectedPlayer!, game: gameDetails, managedContext: managedContext)
                
                


                
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
                
            } else {  //Shift details
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftDetailsCell", for: indexPath) as! ShiftDetailsTableViewCell
                
                
                
                configueShiftCell(cell: cell, indexPath: indexPath, player: selectedPlayer!, game: gameDetails)
                
                return cell
                
            }  //if indexPath.row == 0
            
        }  //if indexPath.section == 0
        
        
        
        
        //                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        //
        //                //Game Information
        //                let game = gameData[indexPath.section - 1]
        //                let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
        //                let gameDetails = managedContext.object(with: gameNSManagedObjectID) as! Games
        //
        //                //Player Information
        ////                let playerNSManagedObjectID = selectedPlayer!["playersRelationship"] as! NSManagedObjectID
        ////                let player = managedContext.object(with: playerNSManagedObjectID) as? Players
        //
        //                let results = goFetch.shiftsPerPlayerPerGame(player: selectedPlayer!, game: gameDetails, managedContext: managedContext)
        //
        //                print(convertDate.convertDate(date: (gameDetails.date)!))
        //                print(results)
        //
        //                return cell
        
        
    }  //cellForRowAt
    
    func configueShiftCell (cell: ShiftDetailsTableViewCell, indexPath: IndexPath, player: Players, game: Games) {
        
        let results = goFetch.shiftsPerPlayerPerGame(player: player, game: game, managedContext: managedContext)
        let timeOnIce = results[indexPath.row - 2]["timeOnIce"]
        let shiftDate = results[indexPath.row - 2]["date"] as! Date
        
        if indexPath.row > 2 {
            let previousDate = results[indexPath.row - 3]["date"] as! Date
            let timeDifference   = shiftDate.timeIntervalSince(previousDate)
            cell.dateDifferenceLabel.text = timeDifference.stringTime
            
        } else {
            
            cell.dateDifferenceLabel.text = "0s"
        }
        
        cell.timeOnIceLabel.text = timeFormat.mmSS(totalSeconds: timeOnIce as! Int)
        cell.dateLabel.text = convertDateToString(dateToConvert: shiftDate)
        cell.numberOfShiftsLabel.text = String(indexPath.row - 1)
        

    }  //configueShiftCell
    
    func convertDateToString(dateToConvert:Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .medium  //10:00:00 PM
        
        let dateAsAString = dateFormatter.string(from: dateToConvert)
        let dateAsADate   = dateFormatter.date(from: dateAsAString)
        let convertedDateAsAString = dateFormatter.string(from: dateAsADate!)
        
        return convertedDateAsAString
        
    }
    
    
    func configureStatsCell(_ cell: StatsAccumaltedPerGameTableViewCell, indexPath: IndexPath) {
        
        //Game Information
        let game = gameData[indexPath.section - 1]
        let gameNSManagedObjectID = game["gameRelationship"] as! NSManagedObjectID
        let gameDetails = managedContext.object(with: gameNSManagedObjectID) as! Games
        
        let results = goFetch.shiftsPerPlayerPerGame(player: selectedPlayer!, game: gameDetails, managedContext: managedContext)
        
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
        
    }  //configureStatsCell
    
    
    func configureAccumulatedCell(_ cell: StatsAccumulatedTableViewCell, indexPath: IndexPath) {
        
        
        
        //Total TimeOnIce
        let timeOnIce = listOfShifts.reduce(0, +)
        
        let totalTimeOnIce = timeFormat.mmSS(totalSeconds: timeOnIce)
        cell.statsTotalTimeOnIceLabel.text = totalTimeOnIce
        
        //Total Shifts
        let totalShifts = listOfShifts.count
        cell.statsTotalShiftsLabel.text =  String(totalShifts)
        
        //Average Shift Length
        let averageShift = timeOnIce / totalShifts
        let avergeShiftLength = timeFormat.mmSS(totalSeconds: averageShift)
        cell.statsAverageShiftLengthLabel.text = avergeShiftLength
        
        //Shortest Shift Length
        let shortestShift = timeFormat.mmSS(totalSeconds: listOfShifts.min()!)
        cell.statsShortestShiftLengthLabel.text = shortestShift
        
        //Longest Shift
        let longestShift = timeFormat.mmSS(totalSeconds: listOfShifts.max()!)
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
        
    }  //configureAccumulatedCell
    
    func configureChartCell(_ cell: StatsChartTableViewCell, indexPath: IndexPath) {
        
        //barChart
        var barChartData: [PointEntry] = []
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            let timeOnIcePerPlayer = goFetch.statsTimeOnIcePerPlayer(player: selectedPlayer!, managedContext: managedContext)
            
            for index in timeOnIcePerPlayer.indices {
                
                let timeOnIce = timeOnIcePerPlayer[index].timeOnIce
                
                let shiftNumber = String(index + 1)
                
                barChartData.append(PointEntry(value: Int(timeOnIce), label: shiftNumber))
                
                //draw barChart
                cell.chartView.isCurved = true
                cell.chartView.dataEntries = barChartData
                
            }  //if let player =
            
        }  // if indexPath.section
        
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
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        
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
            
            let currentDate = convertDate.convertDateOnly(date: (gameDetails.date)!) + " - " + gameDetails.visitorTeamCity! + " vs. " + gameDetails.homeTeamCity!
            
            let sectionHeader = currentDate
            
            return sectionHeader
        }
        
    }  //titleForHeaderInSection
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }  //heightForHeaderInSection
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var returnValue:CGFloat = 0
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                
                returnValue = 240
                
            } else if indexPath.row == 1 {
                
                returnValue = 200
                
            }
            
        default:
            
            if indexPath.row == 0 {
                
                returnValue = 250  //163
                
            } else if indexPath.row == 1 {
                
                returnValue = 200
                
            } else {
                
                //Individual shifts
                returnValue = 50
            }
            
        }  //switch
        
        return  returnValue
        
    }  //heightForRowAt
    
}  //UITableViewDataSource

extension StatsPerGameViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            tableView?.reloadData()
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
    }
    
} //extension

extension TimeInterval {
    
    //https://stackoverflow.com/review/suggested-edits/16940597
    
    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    
    private var seconds: Int {
        return Int(self) % 60
    }
    
    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    
    private var hours: Int {
        return Int(self) / 3600
    }
    
    var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }
}  //TimeInterval

