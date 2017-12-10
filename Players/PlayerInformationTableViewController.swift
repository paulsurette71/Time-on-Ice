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
    
    //coredata
    var managedContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Players>!
    var selectedPlayer: Players?
    
    //classes
    let createAttributedString = CreateAttributedString()
    let goFetch                = GoFetch()
    let timeFormat             = TimeFormat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register tableView cell classes
        let cellNib = UINib(nibName: "PlayerInformationTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "playerInformationTableViewCell")
        tableView.rowHeight = 117
        
        goFetchPlayers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        goFetchPlayers()
    }
    
    func goFetchPlayers() {
        
        let fetchRequest: NSFetchRequest<Players> = Players.fetchRequest()
        let sortTeam   = NSSortDescriptor(key: #keyPath(Players.team), ascending: true)
        let sortNumber = NSSortDescriptor(key: #keyPath(Players.number), ascending: true)
        fetchRequest.sortDescriptors = [sortTeam, sortNumber]
        fetchRequest.fetchBatchSize = 10
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: #keyPath(Players.team), cacheName: nil)
        
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
        playerDetailsTableViewController.newPlayer = false
        
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
        
        let results = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withPlayer: results, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: PlayerInformationTableViewCell, withPlayer player: Players, indexPath: IndexPath) {
        
        let results = goFetch.timeOnIceWithShifts(player: player, managedContext: managedContext)
        
        let totalTimeOnIce = timeFormat.mmSS(totalSeconds: results["timeOnIce"]!)
        cell.totalTimeOnIceLabel.text = totalTimeOnIce
        
        if let shifts = results["shifts"] {
            cell.totalShiftsLabel.text = String(shifts)
        }
        
        let playerInformation = createAttributedString.poundNumberFirstNameLastName(number: player.number!, firstName: player.firstName!, lastName: player.lastName!)
        
        cell.playerInformationLabel.attributedText = playerInformation
        
        cell.selectionStyle = .none
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        updatePlayer(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor     = UIColor.black
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .light)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        header.backgroundView?.backgroundColor = UIColor(named: "gryphonGold")
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionInfo = fetchedResultsController.sections?[section]
        
        if sectionInfo?.name == "" {
            return "No team for Player"
        } else {
            return sectionInfo?.name
        }
        
    }  //titleForHeaderInSection
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
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
        case .update:
            let cell = tableView?.cellForRow(at: indexPath!) as! PlayerInformationTableViewCell  //crash?
            let results = fetchedResultsController.object(at: indexPath!)
            configureCell(cell, withPlayer: results, indexPath: indexPath!)
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
