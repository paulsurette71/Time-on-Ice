//
//  PlayerInformationTableViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-16.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData

class PlayerInformationTableViewController: UITableViewController {
    
    //UIBarButtonItem
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
    //coredata
    var managedContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Players>!
    var selectedPlayer: Players?
    
    //classes
    let createAttributedString = CreateAttributedString()
    let goFetch                = GoFetch()
    let timeFormat             = TimeFormat()
    let showPopover            = ShowPopover()
    
    //Delegates
    var myDelegates: myDelegates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register tableView cell classes
        let cellNib = UINib(nibName: "PlayerInformationTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "playerInformationTableViewCell")
        tableView.rowHeight = 70
        
        goFetchPlayers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        goFetchPlayers()
        
        if let fetchedObjects = fetchedResultsController.fetchedObjects?.count {
            
            if fetchedObjects == 0 {
                
                //Show popover if there are no players listed.
                showPopover.forNoPlayersAdded(view: self, sender: addBarButtonItem)
            }
        }
        
        //Update the tableview.
        //        tableView.reloadData()
        
    }
    
    func goFetchPlayers() {
        
        let fetchRequest: NSFetchRequest<Players> = Players.fetchRequest()
        //        let sortTeam   = NSSortDescriptor(key: #keyPath(Players.team), ascending: true)
        //        let sortNumber = NSSortDescriptor(key: #keyPath(Players.number), ascending: true)
        //        fetchRequest.sortDescriptors = [sortTeam, sortNumber]
        
        let sortByPlayerLastName = NSSortDescriptor(key: #keyPath(Players.lastName), ascending: true)
        fetchRequest.sortDescriptors = [sortByPlayerLastName]
        //        fetchRequest.fetchBatchSize = 10
        
        //        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: #keyPath(Players.team), cacheName: nil)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetching error: \(error), \(error.userInfo)")
        }
    }  //goFetchPlayers
    
    func updatePlayer(indexPath: IndexPath)  {
        
        let player = self.fetchedResultsController.object(at: indexPath as IndexPath)
        
        let playerDetailsTableViewController = storyboard?.instantiateViewController(withIdentifier: "PlayerDetailsTableViewController") as! PlayerDetailsTableViewController
        
        playerDetailsTableViewController.selectedPlayer = player
        playerDetailsTableViewController.newPlayer      = false
        playerDetailsTableViewController.myDelegates    = myDelegates
        
        //This is for lookup popovers
        playerDetailsTableViewController.managedContext = managedContext
        
        self.navigationController?.pushViewController(playerDetailsTableViewController, animated: true)
        
    }  //updatePlayer
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
            
        }
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerInformationTableViewCell", for: indexPath) as! PlayerInformationTableViewCell
        
        let player = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withPlayer: player, indexPath: indexPath)
        
        cell.chevronButton.tag = indexPath.row
        cell.statsButton.tag   = indexPath.row
        
        cell.chevronButton.addTarget(self, action: #selector(chevron), for: .touchUpInside)
        cell.statsButton.addTarget(self, action: #selector(stats), for: .touchUpInside)
        
        //Check to see if there are at least 3 shifts to display stats
        if let shift = player.playersShiftRelationship as! Set<Shifts>? {
                        
            if shift.count > 2 {
                
                cell.statsButton.isHidden = false
                
            } else {
                
                cell.statsButton.isHidden = true
                
            }  //if shift.count

        }  //if let shift
        
        
        //Check to see if the on ice image should be shown.
        if player.onIce {
            cell.onIceImageView.isHidden = false
        } else {
            cell.onIceImageView.isHidden = true
        }
        
        return cell
    }
    
    func configureCell(_ cell: PlayerInformationTableViewCell, withPlayer player: Players, indexPath: IndexPath) {
        
        cell.playerInformationLabel.text = player.firstName! + " " + player.lastName!
        cell.playerNumberLabel.text = String(player.number)
        cell.selectionStyle = .none
        
    }
    
    @objc func chevron(sender: UIButton)  {
        
        //This replaces accessoryButtonTappedForRowWith
        
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        
        updatePlayer(indexPath: indexPath as IndexPath)
        
    }
    
    @objc func stats(sender: UIButton)  {
        
        //This replaces accessoryButtonTappedForRowWith
        
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        
        let selectedPlayer = fetchedResultsController.object(at: indexPath as IndexPath)
        
        let statsPerGameViewController = storyboard?.instantiateViewController(withIdentifier: "StatsPerGameViewController") as! StatsPerGameViewController
        
        statsPerGameViewController.managedContext = managedContext
        statsPerGameViewController.selectedPlayer = selectedPlayer
        
        self.navigationController?.pushViewController(statsPerGameViewController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor     = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .light)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let numberOfPlayers = fetchedResultsController.sections?[section] else {
            
            return ""
            
        }
        
        //return sectionInfo.numberOfObjects
        let playersCount = numberOfPlayers.numberOfObjects
        
        return String(playersCount) + " Players"
        
    }  //titleForHeaderInSection
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let players = goFetch.playersOnIce(managedContext: managedContext)
        
        //Don't let the players be deleted if they are on the ice.
        if players.contains(fetchedResultsController.object(at: indexPath)) {
            return false
        } else {
            return true
        }
        
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let playerToDelete = fetchedResultsController.object(at:indexPath)
            managedContext.delete(playerToDelete)
            
            do {
                try managedContext.save()
                
            } catch let error as NSError {
                print("\(self) -> \(#function): Saving error: \(error), description: \(error.userInfo)")
            }  //do
            
        }  //if
        
    }  //editingStyle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let playerDetailsTableViewController = segue.destination as! PlayerDetailsTableViewController
        
        if segue.identifier == "newSegue" {
            
            playerDetailsTableViewController.managedContext = managedContext
            playerDetailsTableViewController.myDelegates    = myDelegates
            playerDetailsTableViewController.newPlayer = true
            
        }
        
    }  //prepare
}

extension PlayerInformationTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView?.reloadData()
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
            tableView?.reloadData()
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
} //extension
