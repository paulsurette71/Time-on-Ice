//
//  PlayerPopoverTableViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-07.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData

class PlayerPopoverTableViewController: UITableViewController {
    
    //CoreData
    var managedContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Players> = {
        
        let fetchRequest: NSFetchRequest<Players> = Players.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Players.number), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController( fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
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
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("\(self) -> \(#function) \(error), \(error.userInfo)")
        }
        
    }  //viewDidLoad
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let sections = fetchedResultsController.sections else {
            
            return 0
            
        }
        
        return sections.count
        
    }  //numberOfSections
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            
            return 0
            
        }
        
        return sectionInfo.numberOfObjects
        
    }  //numberOfRowsInSection
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerPopoverTableViewCell", for: indexPath) as! PlayerPopoverTableViewCell
        
        let player = fetchedResultsController.object(at: indexPath)
        
        cell.playerNumberLabel.text      = String(player.number)
        cell.playerInformationLabel.text = player.firstName! + " " + player.lastName!
        cell.playerTeamLabel.text        = player.city! + " " + player.team!
        
        if player.onBench {
            
            cell.checkMarkImageView.isHidden = false
            
        } else {
            
            cell.checkMarkImageView.isHidden = true
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
        
        guard let numberOfPlayers = fetchedResultsController.sections?[section] else {
            return ""
            
        }
        
        //return sectionInfo.numberOfObjects
        let playersCount = numberOfPlayers.numberOfObjects
        
        return String(playersCount) + " Players"
        
    }  //titleForHeaderInSection
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! PlayerPopoverTableViewCell
        
        let player = fetchedResultsController.object(at: indexPath)
        
        if cell.checkMarkImageView.isHidden {
            
            cell.checkMarkImageView.isHidden = false
            
            saveOnBenchStatus(player: player, managedContext: managedContext, onBench: true)
            
        } else {
            
            cell.checkMarkImageView.isHidden = true
            
            //Remove player from bench
            saveOnBenchStatus(player: player, managedContext: managedContext, onBench: false)
            
            //Remove player from Ice.
            saveOnIceStatus(player: player, managedContext: managedContext, onIce: false)
            
        }
                
        //NotificationCenter
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name:Notification.Name(rawValue:"PlayersOnBench"),
                                object: nil,
                                userInfo: nil)
        
    }  //didSelectRowAt
    
    
    //Move to own class
    func saveOnBenchStatus(player:Players, managedContext: NSManagedObjectContext, onBench: Bool) {
        
        do {
            
            player.onBench = onBench
            
            //Save
            try player.managedObjectContext?.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
            
        }  //do
        
    }  //saveOnBenchStatus
    
    //Move to own class
    func saveOnIceStatus(player:Players, managedContext: NSManagedObjectContext, onIce: Bool) {
        
        do {
            
            player.onIce = onIce
            
            //Save
            try player.managedObjectContext?.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
            
        }  //do
        
    }  //saveOnIceStatus
    
}

extension PlayerPopoverTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
    }
    
}
