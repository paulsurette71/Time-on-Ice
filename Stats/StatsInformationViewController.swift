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
    
    var playersWithShifts = [Any]()
    
    let createAttributedString = CreateAttributedString()
    
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
        
        playersWithShifts = goFetch.statsShifts(managedContext: managedContext)
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension StatsInformationViewController : UITableViewDelegate {
    
    
}

extension StatsInformationViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersWithShifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "statsInformationTableViewCell", for: indexPath) as! StatsInformationTableViewCell
        
        let player = playersWithShifts[indexPath.row] as! Players
        
        configureCell(cell, withPlayer: player, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: StatsInformationTableViewCell, withPlayer player: Players, indexPath: IndexPath) {
        
        let results = goFetch.statsPerPlayer(player: player, managedContext: managedContext)
        print(results)
        
        if results.count != 0 {
            
            let totalTimeOnIce = timeFormat.mmSS(totalSeconds: results[indexPath.row]["sumShift"]!)
            cell.totalTimeOnIceLabel.text = totalTimeOnIce
            
            if let shifts = results[indexPath.row]["countShift"] {
                cell.totalShiftsLabel.text = String(shifts)
                                
                let averageTimeOnice = timeFormat.mmSS(totalSeconds: results[indexPath.row]["avgShift"]!)
                cell.averageTimeOnIceLabel.text = averageTimeOnice
                
                let numberOfGames = goFetch.statsGamesPerPlayer(player: player, managedContext: managedContext)
                cell.totalGamesLabel.text = String(numberOfGames)
                
                let averageShifts = averageShiftsPerGame(games: numberOfGames, shifts: shifts)
                cell.averageShiftsPerGameLabel.text = averageShifts
                
                let shortestShift = timeFormat.mmSS(totalSeconds: results[indexPath.row]["minShift"]!)
                cell.shortestShiftLabel.text = shortestShift

                let longestShift = timeFormat.mmSS(totalSeconds: results[indexPath.row]["maxShift"]!)
                cell.longestShiftLabel.text = longestShift

                
                
            }
        }
        
        
        let playerInformation = createAttributedString.poundNumberFirstNameLastName(number: String(player.number), firstName: player.firstName!, lastName: player.lastName!)
        
        cell.statsPlayerInformationLabel.attributedText = playerInformation
        
        if let city = player.city, let team = player.team {
            cell.statsTeamInformationLabel.text = city + " " + team
        }
        
        cell.selectionStyle = .none
        
    }
    
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
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return String(playersWithShifts.count) + " Players"
        
    }  //titleForHeaderInSection
    
    
    
    
}
