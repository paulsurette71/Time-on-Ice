//
//  StatsDetailsPerGameTableViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-03.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData

class StatsDetailsPerGameTableViewController: UITableViewController {
    
    //coredata
    var managedContext: NSManagedObjectContext!
    
    //Passed from StatsPerGameViewController
    var player: Players?
    var game: Games?
    
    //classes
    let goFetch     = GoFetch()
    let convertDate = ConvertDate()
    let timeFormat  = TimeFormat()
    
    //data
    var results = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard player != nil else {
            
            return
        }
        
        self.title = (player?.firstName)! + " " + (player?.lastName)!
        
        results = goFetch.shiftsPerPlayerPerGame(player: player!, game: game!, managedContext: managedContext)
        
    }  //viewWillAppear
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }  //numberOfSections
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return results.count
        
    }  //numberOfRowsInSection
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsDetailsPerGameCell", for: indexPath)
        
        // Configure the cell...
        
        let currentCell = results[indexPath.row]
        
        let currentDate = convertDate.convertDate(date: currentCell["date"] as! NSDate)
        let currentTimeOnIce = timeFormat.mmSS(totalSeconds: currentCell["timeOnIce"]! as! Int)
        
        cell.detailTextLabel?.text = currentDate
        cell.textLabel?.text = String(currentTimeOnIce)
        
        return cell
        
    }  //cellForRowAt
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor     = UIColor.black
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .light)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        header.backgroundView?.backgroundColor = UIColor(named: "gryphonGold")
        
    }  //willDisplayHeaderView
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard results.count != 0 else {
            
            return "No Shifts recorded"
        }
        
        let numberOfShiftsForPlayer = String(results.count) + " Shifts"
        
        return numberOfShiftsForPlayer
        
    }  //titleForHeaderInSection

}
