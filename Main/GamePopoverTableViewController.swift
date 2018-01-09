//
//  GamePopoverTableViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-11.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit

class GamePopoverTableViewController: UITableViewController {
    
    var games = [Games]()
    var selectedGame: Games?
    var checkmarkIndexPath: IndexPath! = nil
    
    //classes
    let convertDate = ConvertDate()
    
    //Delegates
    var myDelegates: myDelegates?
    
    //App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register tableView cell classes
        let cellNib = UINib(nibName: "GamePopoverTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "gamePopoverTableViewCell")
        tableView.rowHeight = 75
        
    }  //viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = appDelegate.gameIndexPath {
            
            let cell = tableView?.cellForRow(at: indexPath) as! GamePopoverTableViewCell
            cell.gameCheckmarkImageView.isHidden = false
            checkmarkIndexPath = appDelegate.gameIndexPath!
            
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return games.count
        
    }  //numberOfRowsInSection
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gamePopoverTableViewCell", for: indexPath) as! GamePopoverTableViewCell
        
        let currentDate = convertDate.convertDate(date: games[indexPath.row].date!)
        
        cell.gameDateLabel.text         = currentDate
        cell.gameVisitingTeamLabel.text = games[indexPath.row].visitorTeamCity! + " vs."
        cell.gameHomeTeamLabel.text     = games[indexPath.row].homeTeamCity!
        
        
        
        //This is to check to see if the checkmark needs to be removed or stick to the same cell.
        if checkmarkIndexPath != nil {
            
            if checkmarkIndexPath == indexPath {
                
                cell.gameCheckmarkImageView.isHidden = false
                
            } else {
                
                cell.gameCheckmarkImageView.isHidden = true
            }
        }
        
        return cell
        
    }  //cellForRowAt
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        //http://stackoverflow.com/questions/19802336/changing-font-size-for-uitableview-section-headers
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor     = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .light)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        
    }  //willDisplayHeaderView
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let gameCount = String(games.count)
        
        return gameCount + " Games"
        
    }  //titleForHeaderInSection
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GamePopoverTableViewCell
        
        selectedGame = games[indexPath.row]
        
        if cell.gameCheckmarkImageView.isHidden {
            
            cell.gameCheckmarkImageView.isHidden = false
            
            checkmarkIndexPath = indexPath
            
            //Store IndexPath in Delegate
            myDelegates?.storeGameCheckmarkIndexPathArray(indexPath: checkmarkIndexPath)
            
            //Store Game in Delegate
            myDelegates?.storeGame(game: selectedGame)
            
        } else {
            
//            guard appDelegate.toPlay?.count == 0 || appDelegate.toPlay == nil else {
//                //This is to make sure you can't unselect the game if there are players on the bench.
//                return
//            }
            
            cell.gameCheckmarkImageView.isHidden = true
            
            checkmarkIndexPath = nil
            selectedGame       = nil
            
            myDelegates?.storeGameCheckmarkIndexPathArray(indexPath: checkmarkIndexPath)
            myDelegates?.storeGame(game: selectedGame)
        }
        
        //reloading the table will get rid of the checkmark if already selected.
        tableView.reloadData()
        
        //NotificationCenter
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name:Notification.Name(rawValue:"GameNotification"),
                                object: nil,
                                userInfo: nil)
        
        
    }  //didSelectRowAt
    
}
