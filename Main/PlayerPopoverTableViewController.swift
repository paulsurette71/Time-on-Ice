//
//  PlayerPopoverTableViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-07.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit

class PlayerPopoverTableViewController: UITableViewController {
    
    var players         = [Players]()
    var selectedPlayers = [Players]()
    var checkmarkIndexPathArray = [IndexPath]()
    
    //Delegates
    var myDelegates: myDelegates?
    
    //App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register tableView cell classes
        let cellNib = UINib(nibName: "PlayerPopoverTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "playerPopoverTableViewCell")
        tableView.rowHeight = 75
        
        if appDelegate.checkmarkIndexPath != nil {
            if let checkArray = appDelegate.checkmarkIndexPath {
                checkmarkIndexPathArray = checkArray
            }
        }
        
        if appDelegate.selectedPlayers != nil {
            if let selectedPalyersInDelegate = appDelegate.selectedPlayers {
                selectedPlayers = selectedPalyersInDelegate
            }
        }
    }  //viewDidLoad
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count
        
    }  //numberOfRowsInSection
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerPopoverTableViewCell", for: indexPath) as! PlayerPopoverTableViewCell
        
        cell.playerNumberLabel.text      = players[indexPath.row].number
        cell.playerInformationLabel.text = players[indexPath.row].firstName! + " " + players[indexPath.row].lastName!
        cell.playerTeamLabel.text        = players[indexPath.row].city! + " " + players[indexPath.row].team!
        
        
        
        if checkmarkIndexPathArray.count > 0 {
            
            if checkmarkIndexPathArray.contains(indexPath) {
                
                cell.checkMarkImageView.isHidden = false
                
            } else {
                
                cell.checkMarkImageView.isHidden = true
                
            }
            
        }
        
        return cell
        
    }  //cellForRowAt
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        //http://stackoverflow.com/questions/19802336/changing-font-size-for-uitableview-section-headers
        
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
        
        let playersCount = String(players.count)
        
        return playersCount + " Players"
        
    }  //titleForHeaderInSection
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PlayerPopoverTableViewCell
        
        let selectedPlayer = players[indexPath.row]
        
        if cell.checkMarkImageView.isHidden {
            
            cell.checkMarkImageView.isHidden = false
            
            checkmarkIndexPathArray.append(indexPath)
            
            //Store Array in Delegate
            myDelegates?.storeCheckmarkIndexPathArray(indexPath: checkmarkIndexPathArray)
            
            selectedPlayers.append(selectedPlayer)
            
            //Store Array in Delegate
            myDelegates?.storeSelectedPlayers(selectedPlayers: selectedPlayers)
            
        } else {
            
            cell.checkMarkImageView.isHidden = true
            
            checkmarkIndexPathArray = checkmarkIndexPathArray.filter { $0 != indexPath }
            
            //Store Array in Delegate
            myDelegates?.storeCheckmarkIndexPathArray(indexPath: checkmarkIndexPathArray)
            
            selectedPlayers = selectedPlayers.filter {$0 != selectedPlayer}
            
            //Store Array in Delegate
            myDelegates?.storeSelectedPlayers(selectedPlayers: selectedPlayers)
            
        }
        
        //NotificationCenter
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name:Notification.Name(rawValue:"PlayersOnBench"),
                                object: selectedPlayers,
                                userInfo: nil)
        
    }  //didSelectRowAt
    
}