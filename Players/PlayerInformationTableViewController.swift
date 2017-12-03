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
    
    let createAttributedString = CreateAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(self) -> \(#function)")
        
        // Register tableView cell classes
        let cellNib = UINib(nibName: "PlayerInformationTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "playerInformationTableViewCell")
        tableView.rowHeight = 90
        
        goFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) -> \(#function)")
        
        goFetch()
    }
    
    func goFetch() {
        print("\(self) -> \(#function)")
        
        let fetchRequest: NSFetchRequest<Players> = Players.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Players.number), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchBatchSize = 10
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: #keyPath(Players.team), cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("PlayerInformationTableViewController|goFetch: Fetching error: \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
        
    }
    
    func updatePlayer(indexPath: IndexPath)  {
        print("\(self) -> \(#function)")
        
        let player = self.fetchedResultsController.object(at: indexPath as IndexPath)
        
        let playerDetailsTableViewController = storyboard?.instantiateViewController(withIdentifier: "PlayerDetailsTableViewController") as! PlayerDetailsTableViewController
        
        playerDetailsTableViewController.selectedPlayer = player
        playerDetailsTableViewController.newPlayer = false
        
        self.navigationController?.pushViewController(playerDetailsTableViewController, animated: true)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("\(self) -> \(#function)")
        
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(self) -> \(#function)")
        
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("\(self) -> \(#function)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerInformationTableViewCell", for: indexPath) as! PlayerInformationTableViewCell
        
        let results = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withPlayer: results, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: PlayerInformationTableViewCell, withPlayer player: Players, indexPath: IndexPath) {
        print("\(self) -> \(#function)")
        
        cell.numberLabel.text = player.number
        
        let playerInformation = createAttributedString.forFirstNameLastNameDivisionLevel(firstName: player.firstName!, lastName: player.lastName!, divsion: player.division!, level: player.level!)
        
        cell.playerInformationLabel.attributedText = playerInformation
        
        if let position = player.position {
            cell.positionLabel.text = position
        }
        
        cell.selectionStyle = .none
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(self) -> \(#function)")
        
        updatePlayer(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        print("\(self) -> \(#function)")
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor     = UIColor.black
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .heavy)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        header.backgroundView?.backgroundColor = UIColor(named: "gryphonGold")
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print("\(self) -> \(#function)")
        
        var sectionName = ""
        
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return ""
        }
        
        if (sectionInfo.name.isEmpty) {
            sectionName = "No Team Name"
        } else {
            sectionName = sectionInfo.name
        }
        
        return sectionName
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print("\(self) -> \(#function)")
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("\(self) -> \(#function)")
        
        if editingStyle == .delete {
            
            let playerToDelete = fetchedResultsController.object(at:indexPath)
            managedContext.delete(playerToDelete)
            
            do {
                try managedContext.save()
                tableView.reloadData()
                
            } catch let error as NSError {
                print("PlayerInformationTableViewController|editingStyle: Saving error: \(error), description: \(error.userInfo)")
            }  //do
            
        }  //if
    }  //editingStyle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("\(self) -> \(#function)")
        
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
            let cell = tableView.cellForRow(at: indexPath!) as! PlayerInformationTableViewCell
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
