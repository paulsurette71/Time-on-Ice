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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PlayerInformationTableViewController|managedContext \(managedContext)")
        
        let fetchRequest: NSFetchRequest<Players> = Players.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Players.number), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchBatchSize = 10
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: #keyPath(Players.team), cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("GoalieInformationTableViewController|viewDidLoad: Fetching error: \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) -> \(#function)")
        
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEvent: event)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, withEvent event: Players) {
        cell.textLabel!.text = event.lastName
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        //http://stackoverflow.com/questions/19802336/changing-font-size-for-uitableview-section-headers
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .left
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.name
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let playerDetailsTableViewController = segue.destination as! PlayerDetailsTableViewController
        
        if segue.identifier == "newSegue" {
            
            print("Create new player")
            
            playerDetailsTableViewController.managedContext = managedContext
            playerDetailsTableViewController.newPlayer = true
            
        }
        
        if segue.identifier == "updateSegue" {
            
            print("Update this player")
            
            playerDetailsTableViewController.newPlayer = false
            
            if let indexPath = tableView.indexPathForSelectedRow{
                
                selectedPlayer = self.fetchedResultsController.object(at: indexPath as IndexPath)
                print("selectedPlayer \(String(describing: selectedPlayer))")
                
                playerDetailsTableViewController.selectedPlayer = selectedPlayer
                
            }
            
            
        }
        
    }  //prepare
}

extension PlayerInformationTableViewController: NSFetchedResultsControllerDelegate {
    
} //extension
